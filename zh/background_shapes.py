from ROOT import gROOT
from ROOT import gStyle
import ROOT
import os

# maps sample to marker color and marker fill style
samples = { 'TTZJets' : ("kCyan", "kCyan-2", 21),
            'VHWW' : ("kYellow", "kYellow-2", 21),
            'VHTauTau' : ("kMagenta", "kMagenta-2", 21),
            'ZZJetsTo4L' : ("kGreen", "kGreen-2", 21),
            'ggZZ2L2L' : ("kRed", "kRed-2", 21), 
            'Zjets' : ("kMagenta+3", "kMagenta+1", 21),
            'data_obs' : ("","")
}

ROOT.gROOT.SetBatch(True)

my_total = ROOT.THStack("my_total", "CMS Preliminary, Red + Irr bgk & Data, 19.7 fb^{-1} at S=#sqrt{8} TeV")
my_shapes = ROOT.TFile("results/2014-02-28_8TeV_Ntuples-v2/cards/shapes.root", "r")
my_data = ROOT.TH1F("my_data", "Data", 20, 0, 800)
my_VHWW = ROOT.TH1F("my_VHWW", "VHWW", 20, 0, 800)
my_VHTauTau = ROOT.TH1F("my_VHTauTau", "VHTauTau", 20, 0, 800)
my_TTZJets = ROOT.TH1F("my_TTZJets", "TTZJets", 20, 0, 800)
my_ggZZ2L2L = ROOT.TH1F("my_ggZZ2L2L", "ggZZ2L2L", 20, 0, 800)
my_ZZJetsTo4L = ROOT.TH1F("my_ZZJetsTo4L", "ZZJetsTo4L", 20, 0, 800)
my_Zjets = ROOT.TH1F("my_Zjets", "Zjets", 20, 0, 800)

for sample in ['VHWW', 'VHTauTau', 'TTZJets', 'ggZZ2L2L', 'ZZJetsTo4L', 'Zjets', 'data_obs']:

    my_red_combined = ROOT.THStack("%s combined" % sample, "%s combined" % sample)

    for channel in ['mmtt', 'eett', 'mmmt', 'eemt', 'mmet', 'eeet', 'mmme', 'eeem']:
        if (channel == 'mmme'):
            my_red = my_shapes.Get("mmem_zh/%s" % sample)
        else: my_red = my_shapes.Get("%s_zh/%s" % (channel, sample))

        c1 = ROOT.TCanvas("c1", "a canvas")
        pad1 = ROOT.TPad("pad1","",0,0,1,1) # compare distributions
        pad1.Draw()    
        pad1.cd() 
        pad1.SetGrid()
        my_red.Draw("%s_%s" % (sample, channel) )
        my_red.SetLineColor(ROOT.kRed)
        my_red.SetMarkerColor(ROOT.kRed)
        my_red.SetFillColor(ROOT.kRed)
        my_red.SetFillStyle(1001)
        my_red.GetXaxis().SetTitle(" A SVMass (GeV), %s" % channel)

        ''' Set reasonable maximums on histos '''        
        my_red_max = my_red.GetMaximum()
        my_red.SetMaximum(1.8 * my_red.GetMaximum() )
    
        c1.SaveAs("/afs/hep.wisc.edu/home/truggles/public_html/A_to_Zh_Plots/background_comparisons/%s/%s.png" % (sample, channel))
        pad1.Close()
        c1.Close()
            
        gROOT.cd()
        new_my_red = my_red.Clone()
        my_red_combined.Add(new_my_red)
    
    c2 = ROOT.TCanvas("c2", "a canvas")
    pad2 = ROOT.TPad("pad2","",0,0.2,1,1) # compare distributions
    pad2.Draw()
    
    pad2.cd()
    my_red_combined.GetStack().Last().Draw()
    my_red_combined.GetStack().Last().SetFillStyle( 1001 )
    my_red_combined.GetStack().Last().GetXaxis().SetTitle(" A SVMass (GeV), combined")
    
    pad2.SetGrid() 
    c2.SaveAs("/afs/hep.wisc.edu/home/truggles/public_html/A_to_Zh_Plots/background_comparisons/%s/combined.png" % sample)
    pad2.Close()
    c2.Close()

    gROOT.cd()

    my_red_combined.GetStack().Last().SetFillStyle( 1001 ) 
    #call0 = 'my_%s=ROOT.TH1F("my_%s", "%s", 20, 0, 800)' % (sample, sample, sample)
    #eval ( call0 )
    if sample == 'data_obs':
	my_red_combined.GetStack().Last().SetStats(0)
        tempHistD = ROOT.TH1F("my_temp_data", "%s" % sample, 20, 0, 800)
        tempHistD = my_red_combined.GetStack().Last().Clone()
        my_data.Add( tempHistD.Clone() )
    else:
        color = "ROOT.%s" % samples[sample][0]
        fillColor = "ROOT.%s" % samples[sample][1]
	my_red_combined.GetStack().Last().SetFillColor( eval(color) )
        my_red_combined.GetStack().Last().SetMarkerColor( eval(color) )
        my_red_combined.GetStack().Last().SetLineColor( eval(color) )
        my_red_combined.GetStack().Last().SetStats(0)
        call = "my_%s.Add ( my_red_combined.GetStack().Last().Clone() )" % sample
        eval( call )
        call = "my_%s.SetMarkerColor( eval(color) )" % sample
        eval( call )
        call = "my_%s.SetLineColor( ROOT.kBlack )" % sample
        eval( call )
        call = "my_%s.SetFillColor( eval(color) )" % sample
        eval( call )
        call = "my_%s.SetFillStyle( 1001 )" % sample
        eval( call )
        call = "my_%s.Clone()" % sample
        my_total.Add( eval( call ), "hist e1" )

        if sample == 'Zjets':
		cX = ROOT.TCanvas("cX", "a canvas")
		padX = ROOT.TPad("padX","",0,0.2,1,1)
		padX.Draw()
		padX.SetGridy(1)
		padX.cd()
		my_Zjets.Draw()
		my_Zjets.SetFillStyle( 1001 )
		cX.SaveAs("/afs/hep.wisc.edu/home/truggles/public_html/A_to_Zh_Plots/background_comparisons/Zjets_test.png")
		cX.Close()

c3 = ROOT.TCanvas("c3", "a canvas")
pad5 = ROOT.TPad("pad5","",0,0.2,1,1) # compare distributions
pad5.Draw()
pad5.SetGridy(1)
pad5.cd()
my_total.Draw()
#my_total.GetStack().SetFillStyle( 1001 )
my_total.GetStack().Last().GetXaxis().SetTitle(" A SVMass (GeV), total")
my_total.GetStack().Last().SetMaximum( 1.8 * my_total.GetStack().Last().GetMaximum() )
my_data.Draw("AP Same")
my_data.GetXaxis().SetTitle("A_SVMass (GeV)")
leg = pad5.BuildLegend()
#leg.SetNColumns(2)
leg.Draw()
c3.SaveAs("/afs/hep.wisc.edu/home/truggles/public_html/A_to_Zh_Plots/background_comparisons/total_bkg.png")
pad5.SetLogy()
c3.SaveAs("/afs/hep.wisc.edu/home/truggles/public_html/A_to_Zh_Plots/background_comparisons/total_bkg_log.png")
pad5.Close()
c3.Close()
