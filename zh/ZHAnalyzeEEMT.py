'''

Analyze EEMT events for the ZH analysis

'''

#from FinalStateAnalysis.StatTools.RooFunctorFromWS import build_roofunctor
import glob
from EEMuTauTree import EEMuTauTree
import os
import FinalStateAnalysis.TagAndProbe.MuonPOGCorrections as MuonPOGCorrections
import FinalStateAnalysis.TagAndProbe.PileupWeight as PileupWeight
import baseSelections as selections
import mcCorrectors
import ZHAnalyzerBase
import ROOT
import fake_rate_functions as fr_fcn

################################################################################
#### Analysis logic ############################################################
################################################################################

class ZHAnalyzeEEMT(ZHAnalyzerBase.ZHAnalyzerBase):
    tree = 'eemt/final/Ntuple'
    name = 6
    def __init__(self, tree, outfile, **kwargs):
        super(ZHAnalyzeEEMT, self).__init__(tree, outfile, EEMuTauTree, 'MT', **kwargs)
        # Hack to use S6 weights for the one 7TeV sample we use in 8TeV
        target = os.environ['megatarget']
        self.pucorrector = mcCorrectors.make_puCorrector('doublee')
        ## if 'HWW3l' in target:
        ##     print "HACK using S6 PU weights for HWW3l"
        ##     mcCorrectors.force_pu_distribution('S6')

    def Z_decay_products(self):
        return ('e1','e2')

    def H_decay_products(self):
        return ('m','t')

    def book_histos(self, folder):
        self.book_cut_flow_histos(folder)
        self.book_general_histos(folder)
        self.book_kin_histos(folder, 'e1')
        self.book_kin_histos(folder, 'e2')
        self.book_kin_histos(folder, 'm')
        self.book_kin_histos(folder, 't')
        self.book_Z_histos(folder)
        self.book_H_histos(folder)

    def tau1Selection(self, row): 
        return selections.muIDTight(row, 'm') and selections.muIsoLoose(row, 'm')

    def tau2Selection(self, row):
        return bool(row.tLooseIso3Hits) ##Why not tMediumMVAIso

    def red_shape_cuts(self, row):
        if (row.mRelPFIsoDB > 0.7): return False
        if (row.tMVA2IsoRaw <= -0.95): return False
        if not selections.muIDLoose(row, 'm'): return False
        return True

    def preselection(self, row):
        ''' Preselection applied to events.

        Excludes FR object IDs and sign cut.
        '''
        #Z Selection
        if not selections.ZEESelection(row):
		return (False, 1)
        if not selections.looseMuonSelection(row,'m'):
		return (False, 2)
        if not selections.looseTauSelectionTESUp(row,'t'):
		return (False, 3)
        if not bool(row.tAntiMuonTight2):
		return (False, 3)
        if not bool(row.tAntiElectronLoose):
		return (False, 3)
        if not selections.generalCuts(row, 'e1','e2','m','t') :
		return (False, 4)
        if not row.eTightCountZH_0 == 2:
		return (False, 4)
        if row.muTightCountZH_0 > 1:
		return (False, 4)
        if (row.mPt + row.tPt < 45):
		return (False, 5)
        # Out homemade bJet Veto, bjetCSVVetoZHLikeNoJetId_2 counts total number of bJets, upper line removes those which overlapped with tight E/Mu
        removedBJets = selections.bJetOverlapElec(row, 'e1') + selections.bJetOverlapElec(row, 'e2') + selections.bJetOverlapMu(row, 'm')
        if (row.bjetCSVVetoZHLikeNoJetId_2 > removedBJets):
		return (False, 6)

        return (True, -1)


    def sign_cut(self, row):
        ''' Returns true if muon and tau are OS '''
        return not bool(row.m_t_SS)

    def event_weight(self, row):
        if row.run > 2:
            return 1.
        return self.pucorrector(row.nTruePU) * \
            mcCorrectors.get_muon_corrections(row,'m') * \
            mcCorrectors.get_electron_corrections(row, 'e1', 'e2')

    def leg3_weight(self, row):
        return fr_fcn.mu_tight_jetpt_fr( row.mJetPt ) / (1 - fr_fcn.mu_tight_jetpt_fr( row.mJetPt ))

    def leg4_weight(self, row):
        if (row.tAbsEta <= 1.4):
          return fr_fcn.tau_jetpt_fr_low( row.tJetPt ) / (1 -  fr_fcn.tau_jetpt_fr_low( row.tJetPt ))
        else: 
          return fr_fcn.tau_jetpt_fr_high( row.tJetPt ) / (1 -  fr_fcn.tau_jetpt_fr_high( row.tJetPt ))
