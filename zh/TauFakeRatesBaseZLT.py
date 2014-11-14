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
        # Histograms for each category
        self.histograms = {}
        self.is7TeV = '7TeV' in os.environ['jobid']
        self.numerators = ['LooseIso3Hits', 'MediumIso3Hits']
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
        region = 'ztt'
        self.histograms["Event_ID"] = ROOT.TNtuple("Event_ID","Event ID",'run:lumi:evt1:evt2:eVetoZH:muVetoZH:tauVetoZH:mva_metEt:mva_metPhi:pfMetEt:pfMetPhi:NumDenomCode:Channel:Zmass:t1Pt:t1Eta:t1MtToMET:t2Pt:t2Eta:tauCode')
        for denom in ['pt10low', 'pt10high']:
            denom_key = (region, denom)
            denom_histos = {}
            self.histograms[denom_key] = denom_histos
            folder = region
            #print "Folder: %s" % folder
            #self.book('', "Event_ID","Event ID",'run:lumi:evt1:evt2:eVetoZH:muVetoZH:tauVetoZH:mva_metEt:mva_metPhi:pfMetEt:pfMetPhi:NumDenomCode:tAbsEta:tPt:tJetPt:LT:Mass:Pt', type=ROOT.TNtuple)

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

                book_histo('tauPt', 'Tau Pt', 150, 0, 150)
                book_histo('tauJetPt', 'Tau Jet Pt', 150, 0, 150)
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
        def fill(self, the_histos, row, t, evtList = []):
            weight = 1.0
            the_histos['tauPt'].Fill(getattr( row,t+'Pt'), weight)
            if ( getattr( row,t+'JetPt') < getattr( row,t+'Pt')):
                the_histos['tauJetPt'].Fill(getattr( row,t+'Pt'), weight)
            else:
                the_histos['tauJetPt'].Fill(getattr( row,t+'JetPt'), weight)
            the_histos['tauAbsEta'].Fill(getattr( row,t+'AbsEta'), weight)
            for key, value in histos.iteritems():
               if str(value)[0] == "{": continue
               attr = key[ key.rfind('/') + 1 :]
               if attr in self.hfunc:
                   value.Fill( self.hfunc[attr](row, weight, evtList) )

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

            eventTuple = (row.run, row.lumi, row.evt) #'_NumPlace_' is place holders for below numerator values
            if (eventTuple not in self.eventSet):
                self.eventSet.add(eventTuple)
                
                # Get variables to populate EventID with later
                try:
                    if (row.e1_e2_Mass): Zmass = row.e1_e2_Mass
                except AttributeError: pass
                try:
                    if (row.m1_m2_Mass): Zmass = row.m1_m2_Mass
                except AttributeError: pass
                channel = 0
                ## Channel
                #try:
                #  if (row.e1_e2_Mass):
                #    try:
                #      if (row.e3Pt):
                #        try: 
                #          if (row.tPt): channel = 1 # EEET
                #        except AttributeError: pass
                #    except AttributeError: pass
                #except AttributeError: pass
                #try:
                #  if (row.m1_m2_Mass):
                #    try:
                #      if (row.e3Pt):
                #        try:
                #          if (row.tPt): channel = 11 # MMET
                #        except AttributeError: pass
                #    except AttributeError: pass
                #except AttributeError: pass
                #try:
                #  if (row.e1_e2_Mass):
                #    try:
                #      if (row.m3Pt):
                #        try: 
                #          if (row.tPt): channel = 2 # EEMT
                #        except AttributeError: pass
                #    except AttributeError: pass
                #except AttributeError: pass
                #try:
                #  if (row.m1_m2_Mass):
                #    try:
                #      if (row.m3Pt):
                #        try:
                #          if (row.tPt): channel = 12 # MMMT
                #        except AttributeError: pass
                #    except AttributeError: pass
                #except AttributeError: pass
                #try:
                #  if (row.e1_e2_Mass):
                #    try:
                #      if (row.e3Pt):
                #        try:
                #          if (row.mPt): channel = 3 # EEEM
                #        except AttributeError: pass
                #    except AttributeError: pass
                #except AttributeError: pass
                #try:
                #  if (row.m1_m2_Mass):
                #    try:
                #      if (row.m3Pt):
                #        try:
                #          if (row.ePt): channel = 13 # MMEM
                #        except AttributeError: pass
                #    except AttributeError: pass
                #except AttributeError: pass
                #try:
                #  if (row.e1_e2_Mass):
                #    try:
                #      if (row.t2Pt): channel = 4 # EETT
                #    except AttributeError: pass
                #except AttributeError: pass
                #try:
                #  if (row.m1_m2_Mass):
                #    try:
                #      if (row.t2Pt): channel = 14 # MMTT
                #    except AttributeError: pass
                #except AttributeError: pass
                # Tau 1 = higgs leg 1
                # Tau 1 Pt
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
                
                for t in self.tau_legs:
                    # Remove all non-TT final states
                    if not (t == "t"):
                        print "Event Killed: %s" % t
                        continue
            
                    if (getattr(row, t+'AbsEta') <= 1.4):
                        pt10 = pt10_low
                        code = 0
                    elif (getattr(row, t+'AbsEta') > 1.4):
                        pt10 = pt10_high
                        code = 10
                    tauCode = -1 # 0 = LT event, 1 = t1, 2 = t2 in TT events
                    if t == "t": tauCode = 0
                    if t == "t1": tauCode = 1
                    if t == "t2": tauCode = 2
                    #eventTuple = (row.run, row.lumi, row.evt, getattr(row, t+'AbsEta') <= 1.4, getattr(row, t+'AbsEta') > 1.4, 'Denom', '_NumPlace_') #'_NumPlace_' is place holders for below numerator values
                    #evtList = [code, getattr(row, t+'AbsEta'), getattr(row, t+'Pt'), getattr(row, t+'JetPt'), row.LT, row.Mass, row.Pt]
                    #print "Channel: %i Zmass %f          " % (channel ,Zmass)
                    evtList = [code, channel, Zmass, tau1Pt, tau1Eta, tau1MtToMET, tau2Pt, tau2Eta, tauCode]
                    fill(self, pt10, row, t, evtList) # fill denominator
                    for num in self.numerators:
                        if bool( getattr(row,t+num) ):
                            #eventTuple = (row.run, row.lumi, row.evt, getattr(row, t+'AbsEta') <= 1.4, getattr(row, t+'AbsEta') > 1.4, 'Num', num)
                            #if (eventTuple not in self.eventSet):
                            if (getattr(row, t+'AbsEta') <= 1.4):
                                if num == 'LooseIso3Hits' : code = 1
                                else: code = 11
                                #evtList = [code, getattr(row, t+'AbsEta'), getattr(row, t+'Pt'), getattr(row, t+'JetPt'), row.LT, row.Mass, row.Pt]
                                evtList = [code, channel, Zmass, tau1Pt, tau1Eta, tau1MtToMET, tau2Pt, tau2Eta, tauCode]
                                fill(self, histos[('ztt', 'pt10low', num)], row, t, evtList) # fill numerator
                            elif (getattr(row, t+'AbsEta') > 1.4):
                                if num == 'LooseIso3Hits': code = 2
                                else: code = 12
                                #evtList = [code, getattr(row, t+'AbsEta'), getattr(row, t+'Pt'), getattr(row, t+'JetPt'), row.LT, row.Mass, row.Pt]
                                evtList = [code, channel, Zmass, tau1Pt, tau1Eta, tau1MtToMET, tau2Pt, tau2Eta, tauCode]
                                fill(self, histos[('ztt', 'pt10high', num)], row, t, evtList) # fill numerator
                            #self.eventSet.add(eventTuple)
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

