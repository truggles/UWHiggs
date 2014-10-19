'''
Base analyzer for hadronic tau fake-rate estimation: Z->mu mu
'''

import TauFakeRatesBase
from EETauTauTree import EETauTauTree
import baseSelections as selections

class TauFakeRatesEETT(TauFakeRatesBase.TauFakeRatesBase):
    tree = 'eett/final/Ntuple'
    tau_legs = ['t1', 't2']
    def __init__(self, tree, outfile, **kwargs):
        super(TauFakeRatesEETT, self).__init__(tree, outfile, EETauTauTree, **kwargs)
        
    def zSelection(self, row):
        if not selections.ZEESelection(row): return False
        if not selections.generalCuts(row, 'e1','e2','t1','t2'): return False
        if not selections.looseTauSelection(row, 't1'): return False
        if not selections.looseTauSelection(row, 't2'): return False
        if (row.t1Pt + row.t2Pt < 50): return False
        if not bool(row.t1AntiMuonLoose2): return False
        if not bool(row.t1AntiElectronLoose): return False
        if not bool(row.t2AntiMuonLoose2): return False
        if not bool(row.t2AntiElectronLoose): return False
        if row.t1Pt < row.t2Pt: return False
        # Out homemade bJet Veto, bjetCSVVetoZHLikeNoJetId_2 counts total number of bJets, upper line removes those which overlapped with tight E/Mu
        removedBJets = selections.bJetOverlapElec(row, 'e1') + selections.bJetOverlapElec(row, 'e2')
        if (row.bjetCSVVetoZHLikeNoJetId_2 > removedBJets): return False

        # XXX Count test
        if not row.eTightCountZH_0 == 2: return False
        if row.muTightCountZH_0 > 0: return False

        return True

    def sameSign(self, row):
        return bool(row.t1_t2_SS)

        
