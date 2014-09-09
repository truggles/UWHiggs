'''

Base class to do WH plotting.

Author: Evan K. Friis, UW

Takes as input a set of ROOT [files] with analysis histgrams, and the corresponding
lumicalc.sum [lumifiles] that have the effective lumi for each sample.

If [blind] is true, data in the p1p2p3 region will not be plotted.

'''

import rootpy.plotting.views as views
import rootpy.plotting as plotting
#from rootpy.tree import TreeChain
import rootpy.io
from FinalStateAnalysis.PlotTools.Plotter import Plotter
from FinalStateAnalysis.PlotTools.BlindView import BlindView
from FinalStateAnalysis.PlotTools.PoissonView import PoissonView
from FinalStateAnalysis.PlotTools.HistToTGRaphErrors import HistToTGRaphErrors, HistStackToTGRaphErrors
from FinalStateAnalysis.PlotTools.InflateErrorView import InflateErrorView
from FinalStateAnalysis.MetaData.data_styles import data_styles
#from RecoLuminosity.LumiDB import argparse''' 
import sys
import os
import glob
from FinalStateAnalysis.PlotTools.THBin import zipBins
import pprint
import ROOT

import math

ROOT.gROOT.SetBatch(True)
ROOT.gStyle.SetOptTitle(0)

def quad(*xs):
    return math.sqrt(sum(x*x for x in xs))

class BackgroundErrorView(object):
    ''' Compute the total background error in each bin. '''
    def __init__(self, fakes, wz, zz, wz_error=0.1, zz_error=0.04, fake_error=0.3):
        self.fakes = fakes
        self.wz = wz
        self.zz = zz
        self.fake_error = fake_error
        self.wz_error = wz_error
        self.zz_error = zz_error

    def Get(self, path):
        fakes = self.fakes.Get(path)
        wz = self.wz.Get(path)
        zz = self.zz.Get(path)

        bkg_error = wz.Clone()
        bkg_error.SetTitle("Bkg. Unc.")
        bkg_error.Reset()
        for bin_err, bin_wz, bin_zz, bin_fake in zipBins(bkg_error, wz, zz, fakes): #range(1, bkg_error.GetNbinsX() + 1):
            bin_err.error = quad(
                bin_fake.error,
                bin_fake.content*self.fake_error,
                bin_wz.content*self.wz_error,
                bin_zz.content*self.zz_error
            )
            bin_err.content = (
                bin_fake.content(bin) +
                bin_wz.content(bin) +
                bin_zz.content(bin)
            )
        bkg_error.SetMarkerSize(0)
        bkg_error.SetFillColor(1)
        bkg_error.SetFillStyle(3013)
        bkg_error.legendstyle = 'f'
        return bkg_error

def guess_var_content(channel):
    chSet  = set(channel)
    chSort = sorted(chSet)
    ret    = []
    for char in chSort:
        nc = chSort.count(char)
        if nc == 1:
            ret.append( char.lower() )
        else:
            for i in range(1,nc+1):
                ret.append( '%s%s' % (char.lower(), i) )
    return ret

def get_mass_histos(channel):
    varcont = guess_var_content(channel)
    for pos, obj1 in enumerate( varcont ):
        for obj2 in varcont[pos+1:]:
            yield "%s_%s_Mass" % (obj1, obj2)

products_map = { #a finction might be cooler but is totally a bummer
                 'MMMT' : (('m1', 'm2'),('m3','t')),
                 'MMET' : (('m1', 'm2'),('e','t')),
                 'MMEM' : (('m1', 'm2'),('e','m3')),
                 'MMTT' : (('m1', 'm2'),('t1','t2')),
                 'EEMT' : (('e1', 'e2'),('m','t')),
                 'EEET' : (('e1', 'e2'),('e3','t')),
                 'EEEM' : (('e1', 'e2'),('e3','m')),
                 'EETT' : (('e1', 'e2'),('t1','t2')),
                 }

naming_map = {
    'm' : '#mu',
    'e' : 'e',
    't' : '#tau',
    }

var_map = {
    'Mass'  : 'M_{%s%s}',
    'Pt'    : 'p_{T%s}',
    'Abseta': '|#eta_{%s}|',
    }


class ZHPlotterBase(Plotter):
    def __init__(self, channel, blind=False):
        #self.samples = [ 'Zjets_M50', 'WplusJets_madgraph', 'WZ*', 'ZZ*', 'WW*', 'VH*', 'TTplusJets_madgraph','*A*Zh*']#'WH*',
        #self.samples = ['ZZ*','VH_H2Tau_M-125','*A*Zh*', 'VH*HWW*', 'ggZZ2L2L' ]
        self.samples = ['A*Zh-lltt-MadGraph','TTZJets','VHWW_lepdecay_125','VH_H2Tau_M-125','ZZJetsTo4L_pythia','ggZZ2L2L']
        self.samples += ['WJetsToLNu']
        self.samples += ['data_DoubleMu*'] if channel[:2] == 'MM' else ['data_DoubleElectron*']
        self.jobid = os.environ['jobid']
        self.channel = channel
        self.period = '7TeV' if '7TeV' in jobid else '8TeV'
        self.sqrts = 7 if '7TeV' in jobid else 8
        files = []
        self.blind = blind
        lumifiles = []
        for x in self.samples:
            files += glob.glob('results/%s/ZHAnalyze%s/%s.root' % (jobid, channel, x))
            lumifiles += glob.glob('inputs/%s/%s.lumicalc.sum' % (jobid, x))
        self.outputdir = 'results/%s/plots/%s' % (jobid, channel.lower() )
        #pprint.pprint(files)
        blinder = None
        if blind:
            # Don't look at the SS all pass region
            blinder = lambda x: BlindView(x, "ss/All_Passed/.*")
        super(ZHPlotterBase, self).__init__(files, lumifiles, self.outputdir, blinder)
        self.general_histos = ["nTruePU", "weight", "rho", "nvtx"]
        self.general_histos += ['doubleMuPrescale'] if channel[:2] == 'MM' else []
        self.kin_histos     = ["%sPt", "%sJetPt", "%sAbsEta"]
        self.mass_histos    = [h for h in get_mass_histos(channel)]
        #pprint.pprint(self.views)

    def plot_mc_vs_data(self, folder, variable, rebin=1, xaxis='', leftside=True, xrange=None):
        super(ZHPlotterBase, self).plot_mc_vs_data(folder, variable, rebin, xaxis, leftside, xrange)
        self.add_cms_blurb(self.sqrts)

    def make_signal_views(self, rebin, unblinded=True):
        ''' Make signal views with FR background estimation '''

        WJetsToLNu_view = views.SubdirectoryView(
            self.rebin_view(self.get_view('WJetsToLNu'), rebin),
            'os/All_Passed/'
        )
        TTZJets_view = views.SubdirectoryView(
            self.rebin_view(self.get_view('TTZJets'), rebin),
            'os/All_Passed/'
        )
        VHWW_view = views.SubdirectoryView(
            self.rebin_view(self.get_view('VHWW_lepdecay_125'), rebin),
            'os/All_Passed/'
        )
        VHTauTau_view = views.SubdirectoryView(
            self.rebin_view(self.get_view('VH_H2Tau_M-125'), rebin),
            'os/All_Passed/'
        )
        ZZJetsTo4L_view = views.SubdirectoryView(
            self.rebin_view(self.get_view('ZZJetsTo4L_pythia'), rebin),
            'os/All_Passed/'
        )
        ggZZ2L2L_view = views.SubdirectoryView(
            self.rebin_view(self.get_view('ggZZ2L2L'), rebin),
            'os/All_Passed/'
        )
        #zz_view = views.SubdirectoryView(
        #    self.rebin_view(self.get_view('ZZ*'), rebin),
        #    'os/All_Passed/'
        #)

        all_data_view =self.rebin_view(self.get_view('data'), rebin)
        if unblinded and self.blind:
            all_data_view =self.rebin_view(
                self.get_view('data', 'unblinded_view'), rebin)
            
        data_view = views.SubdirectoryView(all_data_view, 'os/All_Passed/')
        #Categories (to match Abdollah's naming convention) (not anymore!! :) )
        #probes = [p+'IsoFailed' for p in products_map[self.channel][1]]
        cat0   = 'os/Leg3Failed_Leg4Failed/all_weights_applied/'
        cat1   = 'os/Leg3Failed/leg3_weight/'
        cat2   = 'os/Leg4Failed/leg4_weight/'
        cat_red = 'ss/All_Passed_red_shape/'

        # View of weighted obj1-fails data
        cat1_view = views.SubdirectoryView(all_data_view, cat1)
        # View of weighted obj2-fails data
        cat2_view = views.SubdirectoryView(all_data_view, cat2)
        # View of weighted obj1&2-fails data
        cat0_view = views.SubdirectoryView(all_data_view, cat0)

        cat_red_view = views.SubdirectoryView(all_data_view, cat_red)

        subtract_cat0_view = views.ScaleView(cat0_view, -1)
        # Corrected fake view
        Zjets_view = views.SumView(cat1_view, cat2_view, subtract_cat0_view)
        #Zjets_view = views.TitleView(
        #    views.StyleView(Zjets_view, **data_styles['Zjets*']), 'Non-prompt')

        #charge_fakes = views.TitleView(
        #    views.StyleView(
        #        views.SubdirectoryView(all_data_view, 'os/p1p2p3/c1'),
        #        **data_styles['TT*']), 'Charge mis-id')

        #Zjets_view = views.ScaleView(cat_red_view, Zjets_view.Get('A_SVfitMass').Integral() / cat_red_view.Get('A_SVfitMass').Integral() )

        output = {
            'TTZJets' : TTZJets_view,
            'VHWW' : VHWW_view,
            'VHTauTau' : VHTauTau_view,
            'ZZJetsTo4L' : ZZJetsTo4L_view,
            'ggZZ2L2L' : ggZZ2L2L_view,
            'WJetsToLNu' : WJetsToLNu_view,
            'data' : data_view,
            'cat0' : cat0_view,
            'cat1' : cat1_view,
            'cat2' : cat2_view,
            'cat_red' : cat_red_view,
            'Zjets' : Zjets_view
            #'ggZZ2L2L' : ggzz_view
            #'charge_fakes' : charge_fakes
        }

        for mass in [220, 230, 240, 250, 260, 270, 280, 290, 300, 310, 320, 330, 340, 350]:
            AZh_view = views.SubdirectoryView(
                  self.rebin_view(self.get_view('A%i-Zh-lltt-MadGraph' % mass), rebin),
                  'os/All_Passed/'
                )
            output['AZhtt%i' % mass] = AZh_view 
        ## Add signal 
        # Not for MSSM!
        #for mass in [110, 120, 130, 140]:
        #    vh_view = views.SubdirectoryView(
        #       self.rebin_view(self.get_view('VH_H2Tau_M-%i' % mass), rebin),
        #        'os/All_Passed/'
        #    )
        #    output['vh%i' % mass] = vh_view
        #    ww_view = views.SubdirectoryView(
        #       self.rebin_view(self.get_view('VH_%i_HWW' % mass), rebin),
        #        'os/All_Passed/'
        #    )
        #    output['vh%i_hww' % mass] = ww_view
        #    output['signal%i' % mass] = views.SumView(ww_view, vh_view)
 
        #hww_view = views.SubdirectoryView(
        #    self.rebin_view(self.get_view('VH_120_HWW'), rebin),
        #    'os/All_Passed/'
        #)
        #hww_view = views.ScaleView(hww_view, 1.28090/1.27742) # scale mH=120 GeV sample to 125 GeV (ratio of xsec's)
        # from http://ceballos.web.cern.ch/ceballos/mcfm/xsec_several_ecm.txt
        #output['VH_120_HWW'] = hww_view
        
        #for mass in [260, 270, 290, 350]:
        #    AZh_view = views.SubdirectoryView(
        #          self.rebin_view(self.get_view('A%i-AToZhToLLTauTau-MadGraph' % mass), rebin),
        #          'os/All_Passed/'
        #        )
        #
        #    output['AZhtt%i' % mass] = AZh_view 
        
        return output

    def write_shapes(self, variable, rebin, outdir, unblinded=False):
        ''' Write final shape histos for [variable] into a TDirectory [outputdir] '''
        sig_view = self.make_signal_views(rebin, unblinded)
        outdir.cd()
       
        TTZJets = sig_view['TTZJets'].Get(variable)
        VHWW = sig_view['VHWW'].Get(variable)
        VHTauTau = sig_view['VHTauTau'].Get(variable)
        ZZJetsTo4L = sig_view['ZZJetsTo4L'].Get(variable)
        ggZZ2L2L = sig_view['ggZZ2L2L'].Get(variable)
        WJetsToLNu = sig_view['WJetsToLNu'].Get(variable)
        cat0 = sig_view['cat0'].Get(variable)
        cat1 = sig_view['cat1'].Get(variable)
        cat2 = sig_view['cat2'].Get(variable)
        cat_red = sig_view['cat_red'].Get(variable)
        obs = sig_view['data'].Get(variable)
        Zjets = sig_view['Zjets'].Get(variable)
        #wz = sig_view['wz'].Get(variable)
        #zz = sig_view['zz'].Get(variable)
        #ggzz = sig_view['ggZZ2L2L'].Get(variable)
        #vhtt = sig_view['VH_H2Tau_M-125'].Get(variable)
        #vhww = sig_view['VH_120_HWW'].Get(variable)
        
        obs.SetName('data_obs')
        Zjets.SetName('Zjets')
        TTZJets.SetName('TTZJets')
        VHWW.SetName('VHWW')
        VHTauTau.SetName('VHTauTau')
        ZZJetsTo4L.SetName('ZZJetsTo4L')
        ggZZ2L2L.SetName('ggZZ2L2L')
        WJetsToLNu.SetName('WJetsToLNu')
        cat0.SetName('cat0')
        cat1.SetName('cat1')
        cat2.SetName('cat2')
        cat_red.SetName('cat_red')
        #wz.SetName('WZ')
        #zz.SetName('ZZ')
        #vhtt.SetName('VHtautau')
        #vhww.SetName('VHww')
        #ggzz.SetName('ggZZ2L2L')

        #print sig_view.keys()
        #for mass in [260,270,280,290,300,310,320,330,340]:
        for mass in [220, 230, 240, 250, 260, 270, 280, 290, 300, 310, 320, 330, 340, 350]:
        #for mass in [260,270,290,350]:
            signal = sig_view['AZhtt%i' % mass].Get(variable)
            signal.SetName('AHttZll%i' % mass)
            signal.Write()

        obs.Write()
        Zjets.Write()
        TTZJets.Write()
        VHWW.Write()
        VHTauTau.Write()
        ZZJetsTo4L.Write()
        ggZZ2L2L.Write()
        WJetsToLNu.Write()
        cat0.Write()
        cat1.Write()
        cat2.Write()
        cat_red.Write()
        #vhtt.Write()
        #zz.Write()
        #vhww.Write()

    def write_cut_and_count(self, variable, outdir, unblinded=False):
        ''' Version of write_shapes(...) with only one bin.

        Equivalent to a cut & count analysis.
        '''
        sig_view = self.make_signal_views(1, unblinded)
        nbins = sig_view['wz'].Get(variable).GetNbinsX()
        return self.write_shapes(variable, nbins, outdir, unblinded)

    def get_yield(self, variable, unblinded=False):
        sig_view = self.make_signal_views(1, unblinded)
        #wz = sig_view['wz'].Get(variable)
        #zz = sig_view['zz'].Get(variable)
        obs = sig_view['data'].Get(variable)
        Zjets = sig_view['Zjets'].Get(variable)
        TTZJets = sig_view['TTZJets'].Get(variable)
        VHWW = sig_view['VHWW'].Get(variable)
        VHTauTau = sig_view['VHTauTau'].Get(variable)
        ZZJetsTo4L = sig_view['ZZJetsTo4L'].Get(variable)
        ggZZ2L2L = sig_view['ggZZ2L2L'].Get(variable)
        WJetsToLNu = sig_view['WJetsToLNu'].Get(variable)
        cat0 = sig_view['cat0'].Get(variable)
        cat1 = sig_view['cat1'].Get(variable)
        cat2 = sig_view['cat2'].Get(variable)
        cat_red = sig_view['cat_red'].Get(variable)

        return {
            #'wz'    : wz.Integral(),   
            #'zz'    : zz.Integral(),
            'obs'   : obs.Integral(),
            'Zjets' : Zjets.Integral(),
            'TTZJets'   : TTZJets.Integral(),
            'VHWW'   : VHWW.Integral(),
            'VHTauTau'   : VHTauTau.Integral(),
            'ZZJetsTo4L'   : ZZJetsTo4L.Integral(),
            'ggZZ2L2L'   : ggZZ2L2L.Integral(),
            'WJetsToLNu'   : WJetsToLNu.Integral(),
            'cat0'   : cat0.Integral(),
            'cat1'   : cat1.Integral(),
            'cat2'   : cat2.Integral(),
            'cat_red'   : cat_red.Integral(),
            }

    def passing_events(self):
        all_data_view =self.get_view('data')
        def _find_file(view):
            if type(view) == rootpy.io.file.File:
                return view
            return _find_file(view.dir)
        ## print '\n\n\n', _find_file(all_data_view.dirs[0]).GetName(), '\n\n\n'
        data_files = [_find_file(view).GetName() for view in all_data_view.dirs]
        chain = ROOT.TChain('os/All_Passed/Event_ID')
        for f in data_files:
            chain.Add(f)
        retVal = []
        for row in chain:
            retVal.append( (int(row.run), int(row.lumi), int(row.evt1)*10**5+int(row.evt2) ) )
        return retVal


    def print_passing_events(self,outputfileName):
        passing_evts = self.passing_events()
        print 'saving passing events in: '+self.outputdir+'/'+outputfileName
        with open(self.outputdir+'/'+outputfileName,'w') as out:
            out.write('%10s %10s %14s\n' % ('run', 'lumi', 'evt') )
            for row in passing_evts:
                out.write('%10i %10i %14i\n' % row )
        #printing in python format
        pyfname = outputfileName.split('.')[0]+'.py'
        print 'saving passing events in: '+self.outputdir+'/'+pyfname
        with open(self.outputdir+'/'+pyfname,'w') as out:
            out.write('#Printing events passing selections for channel ' + self.channel + ' (run, lumi, evt)\n')
            out.write('passing = ' + passing_evts.__repr__() + '\n')
        return

    def simple_draw(self, path, rebin=1, xaxis=''):
        data_view = self.rebin_view(self.data, rebin)
        histo = data_view.Get(path)
        histo.drawstyle = "ep"
        histo.Draw()
        self.add_cms_blurb(self.sqrts)

    def make_closure_plots(self, var, testDir, refDir, rebin=1, xaxis=''):
        '''helper function to make comparison between data and data (closure test for fakerates etc.)'''
        self.canvas.cd()
        data_view = self.rebin_view(self.data, rebin)
        test_view = views.StyleView( views.TitleView( views.SubdirectoryView( data_view, testDir), 'Weighted data' ), fillcolor=ROOT.EColor.kRed, drawstyle='hist' )#.Get(var)
        refData   = views.SubdirectoryView( data_view, refDir).Get(var)

        testSampleName = '_'.join(testDir.split('/')[1:]).replace('IsoFailed','fail').replace('_weight','w')
        refSampleName  = refDir.split('/')[1].replace('IsoFailed','fail').replace('_weight','w')
        #testData.SetTitle(testSampleName)
        refData.SetTitle(refSampleName)

        diboson_views   = [ InflateErrorView( views.SubdirectoryView(self.rebin_view(self.get_view(pattern), rebin), refDir), 0.16 ) for pattern in ['VH*'] ] #, 'ZZ*', 'WW*'] ]
        to_stack_views  = diboson_views + [test_view] #+ 
        stack_hist      = views.StackView( *to_stack_views ).Get(var)
        refData.drawstyle  = "ep"
        stack_hist.drawstyle = "HIST same" # same" #"HISTe same "
         
        hmax = max( [max([(b.content+b.error) for b in zipBins(refData)]),stack_hist.GetMaximum()] )
        refData.GetYaxis().SetRangeUser(0,hmax*1.3)
        refData.GetXaxis().SetTitle(xaxis)

        tgTest = HistStackToTGRaphErrors( stack_hist )
        tgTest.SetFillStyle(3013)
        tgTest.GetXaxis().SetTitle(xaxis)
        tgTest.GetYaxis().SetRangeUser(0,hmax*1.3)
        self.keep.append(tgTest)

        refData.SetMarkerStyle(20)
        refData.SetMarkerSize(1)
        self.keep.append(refData)
        self.keep.append(stack_hist)
        refData.Draw()
        stack_hist.Draw('same')
        stack_hist.GetXaxis().SetTitle(xaxis)
        stack_hist.GetYaxis().SetRangeUser(0,hmax*1.3)
        refData.Draw('same')
        tgTest.Draw('2 same')
        #stack_hist.Draw()
        #self.canvas.SetLogy()
        
        legend = self.add_legend([refData], leftside=False, entries=len(to_stack_views) +1)
        legend.AddEntry(stack_hist,'f')
        legend.Draw()
        self.add_cms_blurb(self.sqrts)

    def draw_closure_frobj1(self, var, rebin=1, xaxis=''):
        Zprod, Hprod = products_map[self.channel]
        self.make_closure_plots( var, 'os/Leg3Failed_Leg4Failed/leg3_weight', 'os/Leg4Failed/', rebin, xaxis)

    def draw_closure_frobj2(self, var, rebin=1, xaxis=''):
        Zprod, Hprod = products_map[self.channel]
        self.make_closure_plots( var, 'os/Leg3Failed_Leg4Failed/leg4_weight', 'os/Leg3Failed/', rebin, xaxis)

    def plot_final(self, variable, rebin=1, xaxis='', maxy=10, show_error=False, magnifyHiggs=5 ):
        ''' Plot the final output - with bkg. estimation '''
        
        sig_view = self.make_signal_views(rebin)
        #vh_nx = views.TitleView(
        #    views.StyleView(
        #        views.ScaleView(sig_view['signal120'], magnifyHiggs),
        #        **data_styles['VH*']
        #    ),
        #    "(%s#times) m_{H} = 120" % magnifyHiggs
        #)

        stack = views.StackView(
            #sig_view['wz'],
            #sig_view['zz'],
            sig_view['fakes'],
            sig_view['TTZJets'],
            sig_view['VHWW'],
            sig_view['VHTauTau'],
            sig_view['ZZJetsTo4L'],
            sig_view['ggZZ2L2L'],
            sig_view['WJetsToLNu'],
            sig_view['cat0'],
            sig_view['cat1'],
            sig_view['cat2'],
            sig_view['cat_red'],
         #   vh_10x,
        )
        histo = stack.Get(variable)
        histo.Draw()
        histo.GetHistogram().GetXaxis().SetTitle(xaxis)
        histo.SetMaximum(maxy)
        self.keep.append(histo)

        # Add legend
        legend = self.add_legend(histo, leftside=False, entries=4)

        if show_error:
            bkg_error_view = BackgroundErrorView(
                sig_view['fakes'],
                #sig_view['wz'],
                #sig_view['zz'],
                sig_view['TTZJets'],
                sig_view['VHWW'],
                sig_view['VHTauTau'],
                sig_view['ZZJetsTo4L'],
                sig_view['ggZZ2L2L'],
                sig_view['WJetsToLNu'],
                sig_view['cat0'],
                sig_view['cat1'],
                sig_view['cat2'],
                sig_view['cat_red'],
            )
            bkg_error = bkg_error_view.Get(variable)
            self.keep.append(bkg_error)
            bkg_error.Draw('pe2,same')
            legend.AddEntry(bkg_error)

        # Use poisson error bars on the data
        sig_view['data'] = PoissonView(sig_view['data'], x_err=False)

        data = sig_view['data'].Get(variable)
        data.Draw('pe,same')
        self.keep.append(data)

        #legend.AddEntry(data)
        legend.Draw()

        
if __name__ <> "__main__":
    sys.exit(0)
jobid = os.environ['jobid']

channels = filter( lambda x: len(x) == 4 and x.upper() == x, sys.argv) #['MMMT']#[ Z+H for Z in ['EE','MM'] for H in ['MT', 'ET', 'TT', 'EM']] #
print channels
yields = {}
for channel in channels:
    print "Plotting %s for %s" % (channel, jobid)
    Zprod, Hprod = products_map[channel]
    texZprod = tuple( naming_map[p[0]] for p in Zprod )
    texHprod = tuple( naming_map[p[0]] for p in Hprod )
    plotter = ZHPlotterBase(channel)
    
    ###########################################################################
    ##  Z control plots #####################################################
    ###########################################################################
    #plotter.plot_mc_vs_data('os/All_Passed', '%s_%s_Pt' % Zprod, rebin=10, xaxis='p_{T%s%s} (GeV)' % texZprod, leftside=False)
    #plotter.save('%s_mcdata-os-all_passed_ZPt' % channel.lower() )

    #plotter.plot_mc_vs_data('os/All_Passed', '%s_%s_Mass' % Zprod, rebin=10, xaxis='M_{%s%s} (GeV)' % texZprod, leftside=False)
    #plotter.save('%s_mcdata-os-all_passed_ZMass' % channel.lower() )

    #plotter.plot_mc_vs_data('os/Leg3Failed_Leg4Failed', '%s_%s_Mass' % Zprod, rebin=10, xaxis='M_{%s%s} (GeV)' % texZprod, leftside=False)
    #plotter.save('%s_mcdata-os-all_failed_ZMass' % channel.lower() )

    ###########################################################################
    ##  Objects Control plots                                                ##
    ###########################################################################

    #plotter.simple_draw('os/Leg3Failed_Leg4Failed/%sPt' %  Hprod[0], rebin=10, xaxis='p_{T %s} (GeV)' % texHprod[0])
    #plotter.save('%s_os-all_failed-%s_Pt' % (channel.lower(),Hprod[0]) )

    #plotter.simple_draw('os/Leg3Failed_Leg4Failed/%sPt' %  Hprod[1], rebin=10, xaxis='p_{T %s} (GeV)' % texHprod[1])
    #plotter.save('%s_os-all_failed-%s_Pt' % (channel.lower(),Hprod[1]) )

    #plotter.simple_draw('os/Leg3Failed/%sPt' % Hprod[0], rebin=10, xaxis='p_{T %s} (GeV)' % texHprod[0])
    #plotter.save('%s_os-%s_failed-%s_Pt' % (channel.lower(), Hprod[0], Hprod[0]) )

    #plotter.simple_draw('os/Leg4Failed/%sPt' % Hprod[1], rebin=10, xaxis='p_{T %s} (GeV)' % texHprod[1])
    #plotter.save('%s_os-%s_failed-%s_Pt' % (channel.lower(), Hprod[1], Hprod[1]) )

    ###########################################################################
    ##  Fake rates control plots                                             ##
    ###########################################################################

    #plotter.draw_closure_frobj1('%s_%s_Pt' % Hprod, rebin=25, xaxis='p_{T%s%s} (GeV)' % texHprod)
    #plotter.save('%s_frclosureobj1-os-failed2-HPt' % channel.lower() )

    #plotter.draw_closure_frobj1('%s_%s_Mass' % Hprod, rebin=25, xaxis='M_{%s%s} (GeV)' % texHprod)
    #plotter.save('%s_frclosureobj1-os-failed2-HMass' % channel.lower() )

    #plotter.draw_closure_frobj1('%sPt' % Hprod[0], rebin=25, xaxis='p_{T%s} (GeV)' % texHprod[0])
    #plotter.save('%s_frclosureobj1-os-failed2-obj1Pt' % channel.lower() )

    #plotter.draw_closure_frobj2('%s_%s_Pt' % Hprod, rebin=25, xaxis='p_{T%s%s} (GeV)' % texHprod)
    #plotter.save('%s_frclosureobj2-os-failed1-HPt' % channel.lower() )

    #plotter.draw_closure_frobj2('%s_%s_Mass' % Hprod, rebin=25, xaxis='M_{%s%s} (GeV)' % texHprod)
    #plotter.save('%s_frclosureobj2-os-failed1-HMass' % channel.lower() )

    #plotter.draw_closure_frobj2('%sPt' % Hprod[1], rebin=25, xaxis='p_{T%s} (GeV)' % texHprod[1])
    #plotter.save('%s_frclosureobj2-os-failed1-obj2Pt' % channel.lower() )

    ###########################################################################
    ##  H control plots #####################################################
    ###########################################################################
    plotter.plot_mc_vs_data('os/All_Passed', '%s_%s_Pt' % Hprod, rebin=10, xaxis='p_{T%s%s} (GeV)' % texHprod, leftside=False)
    plotter.save('%s_mcdata-os-all_passed_HPt' % channel.lower() )

    #plotter.plot_mc_vs_data('os/All_Passed', '%s_%s_Mass' % Hprod, rebin=10, xaxis='M_{%s%s} (GeV)' % texHprod, leftside=False)
    #plotter.save('%s_mcdata-os-all_passed_HMass' % channel.lower() )

    ###########################################################################
    ##  Yields                #################################################
    ###########################################################################

    yields[channel] = plotter.get_yield('A_SVfitMass')
    plotter.print_passing_events('passing_events.txt')

    ###########################################################################
    ##  Making shape file     #################################################
    ###########################################################################

    shape_file = ROOT.TFile( os.path.join(plotter.outputdir, '%s_shapes_%s.root' % (channel.lower(), plotter.period)), 'RECREATE')
    shape_dir  = shape_file.mkdir( channel.lower()+'_zh' )
    #plotter.write_shapes('%s_%s_SVfitMass' % Hprod, 15, shape_dir, unblinded=True)
    plotter.write_shapes('A_SVfitMass', 40, shape_dir, unblinded=True)
    #plotter.write_cut_and_count('subMass', shape_dir, unblinded=True)
    shape_file.Close()


#Write yields
filename = 'results/%s/plots/yields.txt' % jobid
lines    = []
if os.path.isfile(filename):
    with open(filename) as yfile:
        lines = [line for line in yfile.readlines()]

#understand the file
#oldYields = dict( [ (line.split(' ')[0], line) for line in lines if line.split(' ')[0] in channels] )
#form      =  '%10s %8s %8s %8s %8s\n'
#output    = form % ( 'channel', 'obs', 'wz', 'zz', 'Zjets' )
#for channel in channels:
#    if channel in yields:
#        chyield = yields[channel]
#        output += form[::-1].replace('s','.3f'[::-1],4)[::-1] % (channel, chyield['obs'], chyield['zz'], chyield['Zjets'])
#    else:
#        output += oldYields[channel]
#
#with open(filename,'w') as yfile:
#    yfile.write(output)
