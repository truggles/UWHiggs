'''
Base analyzer for hadronic tau fake-rate estimation: Z->mu mu
'''

import TauFakeRatesBase
import baseSelections as selections
from MuMuTauTauTree import MuMuTauTauTree


class TauFakeRatesMMTT(TauFakeRatesBase.TauFakeRatesBase):
    tree = 'mmtt/final/Ntuple'
    tau_legs = ['t1', 't2']
    def __init__(self, tree, outfile, **kwargs):
        super(TauFakeRatesMMTT, self).__init__(tree, outfile, MuMuTauTauTree, **kwargs)
        
    def zSelection(self, row):
        if not selections.ZMuMuSelection(row): return False
        if not selections.generalCuts(row, 'm1','m2','t1','t2'): return False
        if not selections.looseTauSelection(row, 't1'): return False
        if not selections.looseTauSelection(row, 't2'): return False
        if (row.t1Pt + row.t2Pt < 50): return False
        if not bool(row.t1AntiMuonLoose2): return False
        if not bool(row.t1AntiElectronLoose): return False
        if not bool(row.t2AntiMuonLoose2): return False
        if not bool(row.t2AntiElectronLoose): return False
        if (row.t1Pt < row.t2Pt): return False
        # Out homemade bJet Veto, bjetCSVVetoZHLikeNoJetId_2 counts total number of bJets, upper line removes those which overlapped with tight E/Mu
        removedBJets = selections.bJetOverlapMu(row, 'm1') + selections.bJetOverlapMu(row, 'm2')
        if (row.bjetCSVVetoZHLikeNoJetId_2 > removedBJets): return False

        # XXX Count Test
        if not row.muTightCountZH_0 == 2: return False
        if row.eTightCountZH_0 > 0: return False

        return True

    def sameSign(self, row):
        return bool(row.t1_t2_SS)


       
