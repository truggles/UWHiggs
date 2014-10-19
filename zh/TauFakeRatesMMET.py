'''
Base analyzer for hadronic tau fake-rate estimation: Z->mu mu
'''

import TauFakeRatesBase
import baseSelections as selections
from MuMuETauTree import MuMuETauTree


class TauFakeRatesMMET(TauFakeRatesBase.TauFakeRatesBase):
    tree = 'emmt/final/Ntuple'
    tau_legs = ['t']
    def __init__(self, tree, outfile, **kwargs):
        super(TauFakeRatesMMET, self).__init__(tree, outfile, MuMuETauTree, **kwargs)
        
    def zSelection(self, row):
        if not selections.ZMuMuSelection(row): return False
        if not selections.generalCuts(row, 'm1','m2','e','t'): return False
        if not selections.looseTauSelection(row,'t'): return False
        if not bool(row.tAntiMuonLoose2): return False
        if not bool(row.tAntiElectronMVA3Tight): return False
        if not selections.looseElectronSelection(row,'e'): return False
        # Out homemade bJet Veto, bjetCSVVetoZHLikeNoJetId_2 counts total number of bJets, upper line removes those which overlapped with tight E/Mu
        removedBJets = selections.bJetOverlapMu(row, 'm1') + selections.bJetOverlapMu(row, 'm2') + selections.bJetOverlapElec(row, 'e')
        if (row.bjetCSVVetoZHLikeNoJetId_2 > removedBJets): return False

        # XXX Count Test
        if not row.muTightCountZH_0 == 2: return False
 
        return True
        
    def sameSign(self, row):
        return bool(row.e_t_SS)


       
