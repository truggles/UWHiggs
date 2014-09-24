'''
Base analyzer for hadronic tau fake-rate estimation
'''

from FinalStateAnalysis.PlotTools.MegaBase import MegaBase
import baseSelections as selections
import os
import array
import ROOT

class TauFakeRatesBase(MegaBase):
    def __init__(self, tree, outfile, wrapper, **kwargs):
        super(TauFakeRatesBase, self).__init__(tree, outfile, **kwargs)
        # Use the cython wrapper
        self.tree = wrapper(tree)
        self.out = outfile
        #print "Outfile: %s" % outfile
        #print "Tree: %s" % tree
        #print "Dir: %s" % ROOT.gDirectory.pwd()
        # Histograms for each category
        self.histograms = {}
        self.is7TeV = '7TeV' in os.environ['jobid']
        self.numerators = ['LooseIso3Hits', 'MediumIso3Hits']
        self.eventSet = set() # to keep track of duplicate events
        self.hfunc   = { #maps the name of non-trivial histograms to a function to get the proper value, the function must have two args (evt and weight). Used in fill_histos later
            'nTruePU' : lambda row, weight: row.nTruePU,
            'weight'  : lambda row, weight: weight,
            'Event_ID': lambda row, weight, NumDenomCode: array.array("f", [row.run,
                                                              row.lumi,
                                                              int((row.evt)/10**5),
                                                              int((row.evt)%10**5),
                                                              row.eVetoZH,
                                                              row.muVetoZH,
                                                              row.tauVetoZH,
                                                              row.mva_metEt,
                                                              row.mva_metPhi,
                                                              row.pfMetEt,
                                                              row.pfMetPhi,
                                                              NumDenomCode,
                                                              ] ),} 
        #self.tauFRout = open("tauFR.out", "a")

    def begin(self):
        # Book histograms
        region = 'ztt'
        for denom in ['pt10low', 'pt10high']:
            denom_key = (region, denom)
            denom_histos = {}
            self.histograms[denom_key] = denom_histos
            #folder = region + "/" + denom
            #print "Folder: %s" % folder
            #self.book(folder, "Event_ID","Event ID",'run:lumi:evt1:evt2:eVetoZH:muVetoZH:tauVetoZH:mva_metEt:mva_metPhi:pfMetEt:pfMetPhi', type=ROOT.TNtuple)
            self.histograms["Event_ID"] = ROOT.TNtuple("Event_ID","Event ID",'run:lumi:evt1:evt2:eVetoZH:muVetoZH:tauVetoZH:mva_metEt:mva_metPhi:pfMetEt:pfMetPhi:NumDenomCode')

            for numerator in self.numerators:
                num_key = (region, denom, numerator)
                num_histos = {}
                self.histograms[num_key] = num_histos

                def book_histo(name, *args):
                    # Helper to book a histogram
                    if name not in denom_histos:
                        denom_histos[name] = self.book(os.path.join(
                            region, denom), name, *args)
                    num_histos[name] = self.book(os.path.join(
                        region, denom, numerator), name, *args)

                book_histo('tauPt', 'Tau Pt', 800, 0, 800)
                book_histo('tauJetPt', 'Tau Jet Pt', 800, 0, 800)
                book_histo('tauAbsEta', 'Tau Abs Eta', 100, -2.5, 2.5)
                book_histo('tauTauInvMass', ';M_{#tau #tau} [GeV/c^{2}];Events/10 [GeV/c^{2}]', 51, 0., 255)

                #Histos so we can add info via tuple
                #book_histo('lumi', 'Lumi', 800, 0, 800)
                #book_histo('evt', 'Event ID', 800, 0, 800)
                #book_histo('eVetoZH', 'eVetoZH', 800, 0, 800)
                #book_histo('muVetoZH', 'muVetoZh', 800, 0, 800)
                #book_histo('tauVetoZH', 'tauVetoZh', 800, 0, 800)
                #book_histo('mva_metEt', 'mva_metEt', 800, 0, 800)
                #book_histo('mva_metPhi', 'mva_metPhi', 800, 0, 800)
                #book_histo('pfMetEt', 'pfMetEt', 800, 0, 800)
                #book_histo('pfMetPhi', 'pfMetPhi', 800, 0, 800)

                #folder = region + "/" + denom + "/" + numerator
                #print "Folder: %s" % folder
                #print "Folder = %s" % folder
                #self.book(folder, "Event_ID","Event ID",'run:lumi:evt1:evt2:eVetoZH:muVetoZH:tauVetoZH:mva_metEt:mva_metPhi:pfMetEt:pfMetPhi', type=ROOT.TNtuple)
                #self.histograms[folder + "/Event_ID"] = ROOT.TNtuple("Event_ID","Event ID",'run:lumi:evt1:evt2:eVetoZH:muVetoZH:tauVetoZH:mva_metEt:mva_metPhi:pfMetEt:pfMetPhi')

    def process(self):
        # Generic filler function to fill plots after selection
        def fill(self, the_histos, row, t, NumDenomCode):
            weight = 1.0
            the_histos['tauPt'].Fill(getattr( row,t+'Pt'), weight)
            the_histos['tauJetPt'].Fill(getattr( row,t+'JetPt'), weight)
            the_histos['tauAbsEta'].Fill(getattr( row,t+'AbsEta'), weight)
            #tmpPath = "/".join( the_histos.iteritems() )
            #print "tmpPath: %s" % tmpPath
            #the_histos.iteritems()
            #for key, value in the_histos.iteritems():
               #print "the_Key: %s" % key
               #print "the_Value: %s" % value
            for key, value in histos.iteritems():
               if str(value)[0] == "{": continue
               #print "Value: %s" % value
               #print "Key: %s" % key
               attr = key[ key.rfind('/') + 1 :]
               #print "Attr: %s" % attr
               if attr in self.hfunc:
                   #print "#########Found Attr: %s #########" % key
                   value.Fill( self.hfunc[attr](row, weight, NumDenomCode) )
                   #value.Fill( getattr(row,key), weight )

        def preselection(self, row):
            if not self.zSelection(row):     return False
            #if not selections.looseTauSelection(row, 't1'): return False
            #if not selections.looseTauSelection(row, 't2'): return False
            #if not bool(row.t1AntiMuonLoose2): return False
            #if not bool(row.t1AntiElectronLoose): return False
            #if not bool(row.t2AntiMuonLoose2): return False
            #if not bool(row.t2AntiElectronLoose): return False
            #if row.t1Pt < row.t2Pt: return False #Avoid double counting
            #if row.t1Pt + row.t2Pt < 60: return False
            #if not bool(row.t1_t2_SS):       return False
            return self.sameSign(row)

        histos = self.histograms

        # Denominator regions (dicts of histograms)
        #pt10 = histos[('ztt', 'pt10')]
        pt10_low = histos[('ztt', 'pt10low')]
        pt10_high = histos[('ztt', 'pt10high')]
        #pt10_antiElMVATight_antiMuLoose = histos[('ztt', 'pt10-antiElMVATight-antiMuLoose')]
        #pt10_antiElMed_antiMuMed = histos[('ztt','pt10-antiElMed-antiMuMed')]
        #pt10_antiElLoose_antiMuTight = histos[('ztt','pt10-antiElLoose-antiMuTight')]

        # Analyze data.  Select events with a good Z.
        for row in self.tree:
            if not preselection(self, row):
                continue
            
            for t in self.tau_legs:
                code = -1
                pt10_ = '' # make a string to pass to our text output
                if (getattr(row, t+'AbsEta') <= 1.4):
                    pt10 = pt10_low
                    pt10_ = "pt10low"
                    code = 1
                elif (getattr(row, t+'AbsEta') > 1.4):
                    pt10 = pt10_high
                    pt10_ = "pt10high"
                    code = 11
                eventTuple = (row.run, row.lumi, row.evt, getattr(row, t+'AbsEta') <= 1.4, getattr(row, t+'AbsEta') > 1.4, 'Denom', '_NumPlace_') #'_NumPlace_' is place holders for below numerator values
                if (eventTuple not in self.eventSet):
                    fill(self, pt10, row, t, code) # fill denominator
                    #self.tauFRout.write("%i %i %i %s %s %s %s %f %f %f\n" % (row.run, row.lumi, row.evt, self.tree, "ztt", pt10_, "denominator", getattr(row, t+'AbsEta'), getattr(row, t+'Pt'), getattr(row, t+'JetPt')) )
                    self.eventSet.add(eventTuple)
                for num in self.numerators:
                    if bool( getattr(row,t+num) ):
                        #self.tauFRout.write("%i %i %i" % (row.run, row.lumi, row.evt) )
                        eventTuple = (row.run, row.lumi, row.evt, getattr(row, t+'AbsEta') <= 1.4, getattr(row, t+'AbsEta') > 1.4, 'Num', num)
                        if (eventTuple not in self.eventSet):
                            if (getattr(row, t+'AbsEta') <= 1.4):
                                code = code + 1
                                fill(self, histos[('ztt', 'pt10low', num)], row, t, code) # fill numerator
                                #print "Filled ztt_pt10low"
                            elif (getattr(row, t+'AbsEta') > 1.4):
                                code = code + 2
                                fill(self, histos[('ztt', 'pt10high', num)], row, t, code) # fill numerator
                                #print "Filled ztt_pt10high"
                            #self.tauFRout.write("%i %i %i %s %s %s %f %f %f\n" % (row.run, row.lumi, row.evt, "ztt", pt10_, num, getattr(row, t+'AbsEta'), getattr(row, t+'Pt'), getattr(row, t+'JetPt')) )
                            self.eventSet.add(eventTuple)
            #pt10['tauTauInvMass'].Fill( row.t1_t2_Mass, 1.)

            #if (row.t1AbsEta < 1.4):
            #    fill(pt10_lo, row, 't1')
            #    fill(pt10_lo, row, 't2')
            #    for t in ['t1','t2']:
            #      for num in self.numerators:
            #        if bool( getattr(row, t+num) ):
            #          fill(histos[('ztt', 'pt10_lo', num)], row, t)

            #if (row.t1AbsEta > 1.4):
            #    fill(pt10_hi, row, 't1')
            #    fill(pt10_hi, row, 't2')
            #    for t in ['t1','t2']:
            #      for num in self.numerators:
            #        if bool( getattr(row, t+num) ):
            #          fill(histos[('ztt', 'pt10_hi', num)], row, t)

            # Fill denominator
         #   if row.t1AntiElectronLoose and row.t2AntiElectronLoose and row.t1AntiMuonTight2 and row.t2AntiMuonTight2: 
         #       fill(pt10_antiElLoose_antiMuTight, row, 't1')
         #       fill(pt10_antiElLoose_antiMuTight, row, 't2')
         #       for t in ['t1','t2']:
         #         for num in self.numerators:
         #           if bool( getattr(row,t+num) ):
         #               fill(histos[('ztt', 'pt10-antiElLoose-antiMuTight', num)], row, t)

         #   if row.t1AntiElectronMVA2Tight and row.t2AntiElectronMVA2Tight and row.t1AntiMuonLoose and row.t2AntiMuonLoose:
         #       fill(pt10_antiElMVATight_antiMuLoose, row, 't1')
         #       fill(pt10_antiElMVATight_antiMuLoose, row, 't2')
         #       for t in ['t1','t2']:
         #         for num in self.numerators:
          #          if bool( getattr(row,t+num) ):
          #              fill(histos[('ztt','pt10-antiElMVATight-antiMuLoose', num)], row, t)

          #  if row.t1AntiElectronMedium and row.t2AntiElectronMedium and row.t1AntiMuonMedium2 and row.t2AntiMuonMedium2:
          #      fill(pt10_antiElMed_antiMuMed, row, 't1')
          #      fill(pt10_antiElMed_antiMuMed, row, 't2')
          #      for t in ['t1','t2']:
          #        for num in self.numerators:
          #          if bool( getattr(row,t+num) ):
          #              fill(histos[('ztt','pt10-antiElMed-antiMuMed', num,)], row, t)


    def finish(self):
        self.write_histos()
        #self.tauFRout.close()

