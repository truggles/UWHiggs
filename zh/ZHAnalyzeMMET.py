'''

Analyze MMET events for the ZH analysis

'''

#from FinalStateAnalysis.StatTools.RooFunctorFromWS import build_roofunctor
import glob
from MuMuETauTree import MuMuETauTree
import os
#import FinalStateAnalysis.TagAndProbe.MuonPOGCorrections as MuonPOGCorrections
import FinalStateAnalysis.TagAndProbe.PileupWeight as PileupWeight
import baseSelections as selections
import mcCorrectors
import ZHAnalyzerBase
import ROOT
import fake_rate_functions as fr_fcn

################################################################################
#### Analysis logic ############################################################
################################################################################

class ZHAnalyzeMMET(ZHAnalyzerBase.ZHAnalyzerBase):
    tree = 'emmt/final/Ntuple'
    name = 2
    def __init__(self, tree, outfile, **kwargs):
        super(ZHAnalyzeMMET, self).__init__(tree, outfile, MuMuETauTree, 'ET', **kwargs)
        # Hack to use S6 weights for the one 7TeV sample we use in 8TeV
        self.pucorrector = mcCorrectors.make_puCorrector('doublemu')
        target = os.environ['megatarget']
        ## if 'HWW3l' in target:
        ##     print "HACK using S6 PU weights for HWW3l"
        ##     mcCorrectors.force_pu_distribution('S6')
            
    def Z_decay_products(self):
        return ('m1','m2')

    def H_decay_products(self):
        return ('e','t')

    def book_histos(self, folder):
        self.book_general_histos(folder)
        self.book_kin_histos(folder, 'm1')
        self.book_kin_histos(folder, 'm2')
        self.book_kin_histos(folder, 'e')
        self.book_kin_histos(folder, 't')
        self.book(folder, "doubleMuPrescale", "HLT prescale", 26, -5.5, 20.5)
        self.book_Z_histos(folder)
        self.book_H_histos(folder)

    def tau1Selection(self, row):
        return selections.eleIDTight(row,'e') and selections.elIsoTight(row, 'e') and (row.eMissingHits==0)

    def tau2Selection(self, row):
        return bool(row.tLooseIso3Hits) ##Why not tMediumMVAIso

    def red_shape_cuts(self, row):
        if (row.eRelPFIsoDB > 2.0): return False
        if (row.tMVA2IsoRaw <= 0.0): return False
        return True

    def preselection(self, row):
        ''' Preselection applied to events.

        Excludes FR object IDs and sign cut.
        '''
        #Z Selection
        if not selections.ZMuMuSelection(row): return False
        if not selections.generalCuts(row, 'm1','m2','e','t') : return False
        if not selections.looseTauSelection(row,'t'): return False
        if not bool(row.tAntiMuonLoose2): return False
        if not bool(row.tAntiElectronMVA3Tight): return False
        if (row.ePt + row.tPt < 30): return False
        #X# if not (row.muTightCountZH == 2): return False #THR
        # Out homemade bJet Veto, bjetCSVVetoZHLikeNoJetId_2 counts total number of bJets, upper line removes those which overlapped with tight E/Mu
        removedBJets = selections.bJetOverlapMu(row, 'm1') + selections.bJetOverlapMu(row, 'm2') + selections.bJetOverlapElec(row, 'e')
        if (row.bjetCSVVetoZHLikeNoJetId_2 > removedBJets): return False
        return selections.looseElectronSelection(row,'e')

    def sign_cut(self, row):
        ''' Returns true if muons are SS '''
        return not bool(row.e_t_SS)

    def event_weight(self, row):
        if row.run > 2:
            return 1.
        return self.pucorrector(row.nTruePU) * \
            mcCorrectors.get_muon_corrections(row,'m1','m2') * \
            mcCorrectors.get_electron_corrections(row, 'e') * \
            mcCorrectors.double_muon_trigger(row,'m1','m2')

    def leg3_weight(self, row):
        return fr_fcn.e_tight_jetpt_fr( row.eJetPt ) / (1 - fr_fcn.e_tight_jetpt_fr( row.eJetPt ))

    def leg4_weight(self, row):
        if (row.tAbsEta <= 1.4):
          return fr_fcn.tau_jetpt_fr_low( row.tJetPt ) / (1 - fr_fcn.tau_jetpt_fr_low( row.tJetPt ))
        else:
          return fr_fcn.tau_jetpt_fr_high( row.tJetPt ) / (1 - fr_fcn.tau_jetpt_fr_high( row.tJetPt ))
