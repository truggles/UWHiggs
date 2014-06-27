'''

Analyze MMMT events for the ZH analysis

'''

import glob
from MuMuTauTauTree import MuMuTauTauTree
import os
#import FinalStateAnalysis.TagAndProbe.MuonPOGCorrections as MuonPOGCorrections
import FinalStateAnalysis.TagAndProbe.PileupWeight as PileupWeight
import baseSelections as selections
import mcCorrectors
import ZHAnalyzerBase
import ROOT
import fake_rate_functions as fr_fcn
#import random

################################################################################
#### Analysis logic ############################################################
################################################################################

class ZHAnalyzeMMTT(ZHAnalyzerBase.ZHAnalyzerBase):
    tree = 'mmtt/final/Ntuple'
    #tree = 'Ntuple'
    name = 1
    def __init__(self, tree, outfile, **kwargs):
        super(ZHAnalyzeMMTT, self).__init__(tree, outfile, MuMuTauTauTree, 'TT', **kwargs)
        # Hack to use S6 weights for the one 7TeV sample we use in 8TeV
        target = os.environ['megatarget']
        self.pucorrector = mcCorrectors.make_puCorrector('doublemu')
        ## if 'HWW3l' in target:
        ##     print "HACK using S6 PU weights for HWW3l"
        ##     mcCorrectors.force_pu_distribution('S10')

    def Z_decay_products(self):
        return ('m1','m2')

    def H_decay_products(self):
        return ('t1','t2')

    def book_histos(self, folder):
        self.book_general_histos(folder)
        self.book_kin_histos(folder, 'm1')
        self.book_kin_histos(folder, 'm2')
        self.book_kin_histos(folder, 't1')
        self.book_kin_histos(folder, 't2')
        self.book(folder, "doubleMuPrescale", "HLT prescale", 26, -5.5, 20.5)
        self.book(folder, "leadingTauPt", "Leading #tau_{h} p_{T};p_{T} (GeV);Counts", 100, 0, 100)
        self.hfunc['leadingTauPt'] = lambda row, weight: max( row.t1Pt, row.t2Pt ) #Will NOT be weighted!!
        self.book_Z_histos(folder)
        self.book_H_histos(folder)

    def tau1Selection(self, row):
        return bool(row.t1MediumIso3Hits)
       # return bool(row.t1MediumIso) 

    def tau2Selection(self, row):
        return bool(row.t2MediumIso3Hits)
      #  return bool(row.t2MediumIso)

    def red_shape_cuts(self, row):
        if (row.t1LooseMVA2Iso <= 0.0): return False
        if (row.t2LooseMVA2Iso <= 0.0): return False
        return True

    def preselection(self, row):
        ''' Preselection applied to events.

        Excludes FR object IDs and sign cut.
        '''
#        print "0"
        if not selections.ZMuMuSelection(row): return False
#        print "1"
        if not selections.generalCuts(row, 'm1','m2','t1','t2') : return False
#        print "2"
        if not selections.looseTauSelection(row,'t1'): return False
#        print "3"
        if not selections.looseTauSelection(row,'t2'): return False
#        print "4"
        if not bool(row.t1AntiMuonLoose2): return False
#        print "5"
        if not bool(row.t1AntiElectronLoose): return False
#        print "6"
        if not bool(row.t2AntiMuonLoose2): return False
#        print "7"
        if not bool(row.t2AntiElectronLoose): return False
#        print "8"
        if (row.t1Pt < row.t2Pt): return False #Avoid double counting
#        print "9"
        if (row.t1Pt + row.t2Pt < 70): return False
#        print "10"
        if not (row.muTightCountZH == 2): return False #THR
#        print "11"
        if (row.eTightCountZH > 0): return False #THR
#        print "12"
        return True

    def sign_cut(self, row):
        ''' Returns true if muons are SS '''
        return not bool(row.t1_t2_SS)

    def event_weight(self, row):
        if row.run > 2:
            return 1.
        return self.pucorrector(row.nTruePU) * mcCorrectors.double_muon_trigger(row,'m1','m2')\
          #  mcCorrectors.get_muon_corrections(row,'m1','m2') * \
          #  mcCorrectors.double_muon_trigger(row,'m1','m2')

    def leg3_weight(self, row):
        if (row.t1AbsEta <= 1.4):
          return fr_fcn.tau_medium_jetpt_fr_low( row.t1JetPt ) / (1- fr_fcn.tau_medium_jetpt_fr_low( row.t1JetPt ))
        else:
          return fr_fcn.tau_medium_jetpt_fr_high( row.t1JetPt ) / (1- fr_fcn.tau_medium_jetpt_fr_high( row.t1JetPt ))

    def leg4_weight(self, row):
        if (row.t2AbsEta <= 1.4):
          return fr_fcn.tau_medium_jetpt_fr_low( row.t2JetPt ) / (1 - fr_fcn.tau_medium_jetpt_fr_low( row.t2JetPt ))
        else:
          return fr_fcn.tau_medium_jetpt_fr_high( row.t2JetPt ) / (1 - fr_fcn.tau_medium_jetpt_fr_high( row.t2JetPt ))

    ## def dump(self, row):
    ##     'debugging / sync helper function'
