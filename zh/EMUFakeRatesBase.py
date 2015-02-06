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
                                                              evtList[1], # Channel
                                                              evtList[2], # Zmass
                                                              evtList[3], # t1Pt
                                                              evtList[4], # t1Eta
                                                              evtList[5], # t1MtToMET
                                                              evtList[6], # t2Pt
                                                              evtList[7], # t2Eta
                                                              evtList[8], # tauCode
                                                              ] ),}

    def begin(self):
        # Book histograms
        self.histograms["Event_ID"] = ROOT.TNtuple("Event_ID","Event ID",'run:lumi:evt1:evt2:eVetoZH:muVetoZH:tauVetoZH:mva_metEt:mva_metPhi:pfMetEt:pfMetPhi:NumDenomCode:Channel:Zmass:t1Pt:t1Eta:t1MtToMET:t2Pt:t2Eta:tauCode')
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

                book_histo(self.lepton+'Pt',     self.lepton+' Pt', 150, 0, 150)
                book_histo(self.lepton+'JetPt',  self.lepton+' Jet Pt', 150, 0, 150)
                book_histo(self.lepton+'AbsEta', self.lepton+' Abs Eta', 100, -2.5, 2.5)
                book_histo(self.lepton+'JetPtBarrel',  self.lepton+' Jet Pt (Barrel Region)', 150, 0, 150)
                book_histo(self.lepton+'JetPtEndCap',  self.lepton+' Jet Pt (EndCap Region)', 150, 0, 150)
                #book_histo(self.lepton+'JetPtLow',  self.lepton+' Jet Pt (Low Eta Region)', 150, 0, 150)
                #book_histo(self.lepton+'JetPtMedium',  self.lepton+' Jet Pt (Medium Eta Region)', 150, 0, 150)
                #book_histo(self.lepton+'JetPtHigh',  self.lepton+' Jet Pt (High Eta Region)', 150, 0, 150)
    
    def process(self):
        # Generic filler function to fill plots after selection
        def fill(self, the_histos, row, evtList):
            weight = 1.0
            the_histos[self.lepton+'Pt'].Fill(    getattr( row, self.branchId+'Pt'    ), weight)
            # original JetPt plot for all Eta
            if ( getattr( row, self.branchId+'JetPt') < getattr( row, self.branchId+'Pt') ):
                the_histos[self.lepton+'JetPt'].Fill( getattr( row, self.branchId+'Pt'), weight)
            else:
                the_histos[self.lepton+'JetPt'].Fill( getattr( row, self.branchId+'JetPt'), weight)
            # new JetPt plot broken down by Eta region
            # The commented out version below is for splitting electrons by their 3 ID regions in eta
            # It was decided to split loose ID by barrel and endcap only.
            #if ( getattr( row, self.branchId+'AbsEta') ) < 0.8:
            #    if ( getattr( row, self.branchId+'JetPt') < getattr( row, self.branchId+'Pt') ):
            #        the_histos[self.lepton+'JetPtLow'].Fill( getattr( row, self.branchId+'Pt'), weight)
            #    else:
            #        the_histos[self.lepton+'JetPtLow'].Fill( getattr( row, self.branchId+'JetPt'), weight)
            #elif ( ( getattr( row, self.branchId+'AbsEta') ) > 0.8 and ( getattr( row, self.branchId+'AbsEta') ) < 1.479 ):
            #    if ( getattr( row, self.branchId+'JetPt') < getattr( row, self.branchId+'Pt') ):
            #        the_histos[self.lepton+'JetPtMedium'].Fill( getattr( row, self.branchId+'Pt'), weight)
            #    else:
            #        the_histos[self.lepton+'JetPtMedium'].Fill( getattr( row, self.branchId+'JetPt'), weight)
            #else:
            #    if ( getattr( row, self.branchId+'JetPt') < getattr( row, self.branchId+'Pt') ):
            #        the_histos[self.lepton+'JetPtHigh'].Fill( getattr( row, self.branchId+'Pt'), weight)
            #    else:
            #        the_histos[self.lepton+'JetPtHigh'].Fill( getattr( row, self.branchId+'JetPt'), weight)
            if ( getattr( row, self.branchId+'AbsEta') ) < 1.4:
                if ( getattr( row, self.branchId+'JetPt') < getattr( row, self.branchId+'Pt') ):
                    the_histos[self.lepton+'JetPtBarrel'].Fill( getattr( row, self.branchId+'Pt'), weight)
                else:
                    the_histos[self.lepton+'JetPtBarrel'].Fill( getattr( row, self.branchId+'JetPt'), weight)
            else:
                if ( getattr( row, self.branchId+'JetPt') < getattr( row, self.branchId+'Pt') ):
                    the_histos[self.lepton+'JetPtEndCap'].Fill( getattr( row, self.branchId+'Pt'), weight)
                else:
                    the_histos[self.lepton+'JetPtEndCap'].Fill( getattr( row, self.branchId+'JetPt'), weight)
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

            # Nov12,2014, Cecile and I agree to use MtToPFMET to see if we can sync FRs
            # I am sure she is using no PhiCorrection in her PFMET, however, I do not have it calculated without a PhiCorrection
            # Jan 14, 2015, Cut changed to MtToMVAMET_noPhiCor to match with Cecile
            #if getattr(row,self.branchId+'MtToPFMET') > 30: return False
            if getattr(row,self.branchId+'MtToMVAMET_noPhiCor') > 30: return False
            
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

            #eventTuple = (row.run, row.lumi, row.evt, self.lepton_passes_loose_iso(row), self.lepton_passes_tight_iso(row) ) 
            eventTuple = (row.run, row.lumi, row.evt) 
            if (eventTuple in self.eventSet):
                continue

            # Get variables to populate EventID with later
            try:
                if (row.e1_e2_Mass): Zmass = row.e1_e2_Mass
            except AttributeError: pass
            try:
                if (row.m1_m2_Mass): Zmass = row.m1_m2_Mass
            except AttributeError: pass
            channel = 0
            try:
                if (row.e3Pt):
                    tau1Pt = row.e3Pt
                    tau1Eta = row.e3Eta
                    tau1MtToMET = row.e3MtToMET
                    tau2Pt = row.tPt
                    tau2Eta = row.tEta
            except AttributeError: pass
            try:
                if (row.ePt):
                    tau1Pt = row.ePt
                    tau1Eta = row.eEta
                    tau1MtToMET = row.eMtToMET
                    tau2Pt = row.tPt
                    tau2Eta = row.tEta
            except AttributeError: pass
            try:
                if (row.m3Pt):
                    tau1Pt = row.m3Pt
                    tau1Eta = row.m3Eta
                    tau1MtToMET = row.m3MtToMET
                    tau2Pt = row.tPt
                    tau2Eta = row.tEta
            except AttributeError: pass
            try:
                if (row.mPt):
                    tau1Pt = row.mPt
                    tau1Eta = row.mEta
                    tau1MtToMET = row.mMtToMET
                    tau2Pt = row.tPt
                    tau2Eta = row.tEta
            except AttributeError: pass
            try:
                if (row.t2Pt):
                    tau1Pt = row.t1Pt
                    tau1Eta = row.t1Eta
                    tau1MtToMET = row.t1MtToMET
                    tau2Pt = row.t2Pt
                    tau2Eta = row.t2Eta
            except AttributeError: pass

            # Fill denominator
            #print 'PRESELECTION PASSED!'
            code = 20
            tauCode = -1
            if self.branchId == "e": tauCode = 10
            if self.branchId == "e3": tauCode = 11
            if self.branchId == "m": tauCode = 20
            if self.branchId == "m3": tauCode = 21
            
            #evtList = [code, getattr(row, self.branchId+'AbsEta'), getattr(row, self.branchId+'Pt'), getattr(row, self.branchId+'JetPt'), row.LT, row.Mass, row.Pt]
            evtList = [code, channel, Zmass, tau1Pt, tau1Eta, tau1MtToMET, tau2Pt, tau2Eta, tauCode]
            fill(self, pt10, row, evtList)
            if self.lepton_passes_loose_iso(row):
                #print 'ISOLATION PASSED!'
                code = 21
                #evtList = [code, getattr(row, self.branchId+'AbsEta'), getattr(row, self.branchId+'Pt'), getattr(row, self.branchId+'JetPt'), row.LT, row.Mass, row.Pt]
                evtList = [code, channel, Zmass, tau1Pt, tau1Eta, tau1MtToMET, tau2Pt, tau2Eta, tauCode]
                fill(self, histos[('zlt', 'pt10', 'looseId')], row, evtList)
            if self.lepton_passes_tight_iso(row):
                code = 22
                #evtList = [code, getattr(row, self.branchId+'AbsEta'), getattr(row, self.branchId+'Pt'), getattr(row, self.branchId+'JetPt'), row.LT, row.Mass, row.Pt]
                evtList = [code, channel, Zmass, tau1Pt, tau1Eta, tau1MtToMET, tau2Pt, tau2Eta, tauCode]
                #print 'ISOLATION PASSED!'
                fill(self, histos[('zlt', 'pt10', 'tightId')], row, evtList)
            self.eventSet.add(eventTuple)

    def finish(self):
        self.write_histos()

