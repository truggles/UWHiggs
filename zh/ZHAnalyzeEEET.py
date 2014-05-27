'''

Analyze EEET events for the ZH analysis

'''

#from FinalStateAnalysis.StatTools.RooFunctorFromWS import build_roofunctor
import glob
from EEETauTree import EEETauTree
import os
import FinalStateAnalysis.TagAndProbe.MuonPOGCorrections as MuonPOGCorrections
import FinalStateAnalysis.TagAndProbe.PileupWeight as PileupWeight
import mcCorrectors
import ZHAnalyzerBase
import baseSelections as selections
import ROOT
import fake_rate_functions as fr_fcn

################################################################################
#### Analysis logic ############################################################
################################################################################

class ZHAnalyzeEEET(ZHAnalyzerBase.ZHAnalyzerBase):
    tree = 'eeet/final/Ntuple'
    name = 7
    def __init__(self, tree, outfile, **kwargs):
        super(ZHAnalyzeEEET, self).__init__(tree, outfile, EEETauTree, 'ET', **kwargs)
        # Hack to use S6 weights for the one 7TeV sample we use in 8TeV
        target = os.environ['megatarget']
        self.pucorrector = mcCorrectors.make_puCorrector('doublee')
        ## if 'HWW3l' in target:
        ##     print "HACK using S6 PU weights for HWW3l"
        ##     mcCorrectors.force_pu_distribution('S6')

    def Z_decay_products(self):
        return ('e1','e2')

    def H_decay_products(self):
        return ('e3','t')

    def book_histos(self, folder):
        self.book_general_histos(folder)
        self.book_kin_histos(folder, 'e1')
        self.book_kin_histos(folder, 'e2')
        self.book_kin_histos(folder, 'e3')
        self.book_kin_histos(folder, 't')
        self.book_Z_histos(folder)
        self.book_H_histos(folder)

    def tau1Selection(self, row):
        return selections.eleIDTight(row, 'e3') and selections.elIsoTight(row, 'e3')# and (row.e3MissingHits==0)

    def tau2Selection(self, row):
        return bool(row.tLooseIso3Hits) ##Why not tMediumMVAIso

    def red_shape_cuts(self, row):
        if (row.e3RelPFIsoDB > 2.0): return False
        if (row.tLooseMVA2Iso <= 0.0): return False
        return True

    def preselection(self, row):
        ''' Preselection applied to events.

        Excludes FR object IDs and sign cut.
        '''
        #Z Selection
        if not selections.ZEESelection(row): return False
        if not selections.generalCuts(row, 'e1','e2','e3','t') : return False
        if not selections.looseTauSelection(row,'t'): return False
        if not bool(row.tAntiMuonLoose2): return False
        if not bool(row.tAntiElectronMVA3Tight): return False
        if not selections.looseElectronSelection(row,'e3'): return False
        if (row.e3Pt + row.tPt < 30): return False
        return True

    def sign_cut(self, row):
        ''' Returns true if muons are SS '''
        return not bool(row.e3_t_SS)

    def event_weight(self, row):
        if row.run > 2:
            return 1.
        return self.pucorrector(row.nTruePU) * \
            mcCorrectors.get_electron_corrections(row, 'e1','e2','e3')

    def leg3_weight(self, row):
        return fr_fcn.e_tight_jetpt_fr( row.e3JetPt ) / (1 - fr_fcn.e_tight_jetpt_fr( row.e3JetPt ))

    def leg4_weight(self, row):
        return fr_fcn.tau_jetpt_fr( row.tJetPt ) / (1 - fr_fcn.tau_jetpt_fr( row.tJetPt ))
