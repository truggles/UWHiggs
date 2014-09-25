'''
Base analyzer for hadronic tau fake-rate estimation
'''

from FinalStateAnalysis.PlotTools.MegaBase import MegaBase
import baseSelections as selections
import os
import array
import ROOT

class EMUFakeRatesBase(MegaBase):
    def __init__(self, tree, outfile, wrapper, **kwargs):
        #print 'called: TauFakeRatesBase'
        super(EMUFakeRatesBase, self).__init__(tree, outfile, **kwargs)
        # Use the cython wrapper
        self.tree = wrapper(tree)
        self.out = outfile
        # Histograms for each category
        self.histograms = {}
        self.is7TeV = '7TeV' in os.environ['jobid']
        self.lepton   = ''#self.leptonName()
        self.branchId = ''#self.branchIdentifier()
        self.eventSet = set() # to keep track of duplicate events
        self.hfunc   = { #maps the name of non-trivial histograms to a function to get the proper value, the function must have two args (evt and weight). Used in fill_histos later
            'Event_ID': lambda row, weight, evtList = []: array.array("f", [row.run,
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
                                                              evtList[0], # NumDenomCode
                                                              evtList[1], # tAbsEta
                                                              evtList[2], # tPt
                                                              evtList[3], # tJetPt
                                                              evtList[4], # LT
                                                              evtList[5], # Mass
                                                              evtList[6], # Pt
                                                              ] ),}

    def begin(self):
        # Book histograms
        self.histograms["Event_ID"] = ROOT.TNtuple("Event_ID","Event ID",'run:lumi:evt1:evt2:eVetoZH:muVetoZH:tauVetoZH:mva_metEt:mva_metPhi:pfMetEt:pfMetPhi:NumDenomCode:lAbsEta:lPt:lJetPt:LT:Mass:Pt')
        region = 'zlt'
        for denom in ['pt10']:
            denom_key = (region, denom)
            denom_histos = {}
            self.histograms[denom_key] = denom_histos

            for numerator in ['looseId','tightId']:
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

                book_histo(self.lepton+'Pt',     self.lepton+' Pt', 800, 0, 800)
                book_histo(self.lepton+'JetPt',  self.lepton+' Jet Pt', 800, 0, 800)
                book_histo(self.lepton+'AbsEta', self.lepton+' Abs Eta', 100, -2.5, 2.5)
    
    def process(self):
        # Generic filler function to fill plots after selection
        def fill(self, the_histos, row, evtList):
            weight = 1.0
            the_histos[self.lepton+'Pt'].Fill(    getattr( row, self.branchId+'Pt'    ), weight)
            the_histos[self.lepton+'JetPt'].Fill( getattr( row, self.branchId+'JetPt'), weight)
            the_histos[self.lepton+'AbsEta'].Fill(getattr( row, self.branchId+'AbsEta'), weight)
            for key, value in histos.iteritems():
               if str(value)[0] == "{": continue
               attr = key[ key.rfind('/') + 1 :]
               if attr in self.hfunc:
                   value.Fill( self.hfunc[attr](row, weight, evtList) )

        def preselection(self, row):
            if not self.zSelection(row):    return False
            #if row.pfMet_mes_Et > 20:                            return False
            #if row.mva_metEt > 20: return False
            #print getattr(row,self.branchId+'MtToMET')
            if getattr(row,self.branchId+'MtToMET') > 30: return False #AN --> 30
            #if row.jetVeto30 < 0.5: return False
            if not getattr(row,self.branchId+'_t_SS'):    return False
            #if not selections.signalTauSelection(row, 't'): return False        
            ## if row.tAbsEta  > 2.3:                return False
            ## if abs(row.tDZ) > 0.1:                return False    
            ## if not bool(row.tDecayFinding):       return False
            ## if not bool(row.tAntiElectronLoose):  return False #in the AN is not specified but seems reasonable
            ## if not bool(row.tAntiMuonLoose):      return False #in the AN is not specified but seems reasonable
            #BTag on the jet associated to the tau. Not exactly as Abdollah but close enough
            ## if row.tJetCSVBtag > 0.679:     return False
            return True

        histos = self.histograms
        # Denominator regions (dicts of histograms)
        pt10 = histos[('zlt', 'pt10')]

        # Analyze data.  Select events with a good Z.


        for row in self.tree:
            if not preselection(self, row):
                continue

            eventTuple = (row.run, row.lumi, row.evt, self.lepton_passes_loose_iso(row), self.lepton_passes_tight_iso(row) ) 
            if (eventTuple in self.eventSet):
                continue
            # Fill denominator
            #print 'PRESELECTION PASSED!'
            code = 20
            evtList = [code, getattr(row, self.branchId+'AbsEta'), getattr(row, self.branchId+'Pt'), getattr(row, self.branchId+'JetPt'), row.LT, row.Mass, row.Pt]
            fill(self, pt10, row, evtList)
            if self.lepton_passes_loose_iso(row):
                #print 'ISOLATION PASSED!'
                code = 21
                evtList = [code, getattr(row, self.branchId+'AbsEta'), getattr(row, self.branchId+'Pt'), getattr(row, self.branchId+'JetPt'), row.LT, row.Mass, row.Pt]
                fill(self, histos[('zlt', 'pt10', 'looseId')], row, evtList)
            if self.lepton_passes_tight_iso(row):
                code = 22
                evtList = [code, getattr(row, self.branchId+'AbsEta'), getattr(row, self.branchId+'Pt'), getattr(row, self.branchId+'JetPt'), row.LT, row.Mass, row.Pt]
                #print 'ISOLATION PASSED!'
                fill(self, histos[('zlt', 'pt10', 'tightId')], row, evtList)
            self.eventSet.add(eventTuple)

    def finish(self):
        self.write_histos()

