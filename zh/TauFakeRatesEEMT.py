'''
Base analyzer for hadronic tau fake-rate estimation: Z->mu mu
'''

import TauFakeRatesBase
from EEMuTauTree import EEMuTauTree
import baseSelections as selections

class TauFakeRatesEEMT(TauFakeRatesBase.TauFakeRatesBase):
    tree = 'eemt/final/Ntuple'
    tau_legs = ['t']
    def __init__(self, tree, outfile, **kwargs):
        super(TauFakeRatesEEMT, self).__init__(tree, outfile, EEMuTauTree, **kwargs)
        
    def zSelection(self, row):
        if not selections.ZEESelection(row): return False
        if not selections.generalCuts(row, 'e1','e2','m','t'): return False
        if not selections.looseTauSelection(row, 't'): return False
        if not bool(row.tAntiMuonTight2): return False
        #if not bool(row.tAntiElectronLoose): return False
        if not selections.looseMuonSelection(row, 'm'): return False
        return True

    def sameSign(self, row):
        return bool(row.m_t_SS)

        
