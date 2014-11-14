'''

Analyze EEEM events for the ZH analysis

'''

#from FinalStateAnalysis.StatTools.RooFunctorFromWS import build_roofunctor
import glob
from EEEMuTree import EEEMuTree
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

class ZHAnalyzeEEEM(ZHAnalyzerBase.ZHAnalyzerBase):
    tree = 'eeem/final/Ntuple'
    name = 8
    def __init__(self, tree, outfile, **kwargs):
        super(ZHAnalyzeEEEM, self).__init__(tree, outfile, EEEMuTree, 'EM', **kwargs)
        # Hack to use S6 weights for the one 7TeV sample we use in 8TeV
        target = os.environ['megatarget']
        self.pucorrector = mcCorrectors.make_puCorrector('doublee')
        ## if 'HWW3l' in target:
        ##     print "HACK using S6 PU weights for HWW3l"
        ##     mcCorrectors.force_pu_distribution('S6')

    def Z_decay_products(self):
        return ('e1','e2')

    def H_decay_products(self):
        return ('e3','m')

    def book_histos(self, folder):
        self.book_general_histos(folder)
        self.book_kin_histos(folder, 'e1')
        self.book_kin_histos(folder, 'e2')
        self.book_kin_histos(folder, 'm')
        self.book_kin_histos(folder, 'e3')
        self.book_Z_histos(folder)
        self.book_H_histos(folder)

    def tau1Selection(self, row):
        return selections.elIsoLoose(row, 'e3') and selections.eleIDLoose(row, 'e3')

    def tau2Selection(self, row):
        return selections.muIsoLoose(row, 'm') and selections.muIDLoose(row, 'm')

    def red_shape_cuts(self, row):
        #if (row.e3RelPFIsoDB > 2.0): return False
        if (row.mRelPFIsoDB > 2.0): return False
        if not selections.muIDLoose(row, 'm'): return False
        return True

    def preselection(self, row):
        ''' Preselection applied to events.

        Excludes FR object IDs and sign cut.
        '''
        if not selections.ZEESelection(row): return False
        if not selections.generalCuts(row, 'e1','e2','e3','m') : return False
        if not selections.looseMuonSelection(row,'m'): return False
        if not selections.looseElectronSelection(row,'e3'): return False
        if (row.e3Pt + row.mPt < 25): return False
        # Out homemade bJet Veto, bjetCSVVetoZHLikeNoJetId_2 counts total number of bJets, upper line removes those which overlapped with tight E/Mu
        removedBJets = selections.bJetOverlapElec(row, 'e1') + selections.bJetOverlapElec(row, 'e2') + selections.bJetOverlapElec(row, 'e3') + selections.bJetOverlapMu(row, 'm')
        if (row.bjetCSVVetoZHLikeNoJetId_2 > removedBJets): return False

        # XXX Count Test - no requirements

        return True

    def sign_cut(self, row):
        ''' Returns true if muons are SS '''
        return not bool(row.e3_m_SS)

    def event_weight(self, row):
        if row.run > 2:
            return 1.
        return self.pucorrector(row.nTruePU) * \
            mcCorrectors.get_muon_corrections(row,'m') * \
            mcCorrectors.get_electron_corrections(row, 'e1','e2')
    
    def leg3_weight(self, row):
        return fr_fcn.e_loose_jetpt_fr( row.e3JetPt ) / (1 - fr_fcn.e_loose_jetpt_fr( row.e3JetPt ))

    def leg4_weight(self, row):
        return fr_fcn.mu_loose_jetpt_fr( row.mJetPt ) / (1 - fr_fcn.mu_loose_jetpt_fr( row.mJetPt ))
