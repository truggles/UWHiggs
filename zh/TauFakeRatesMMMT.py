'''
Base analyzer for hadronic tau fake-rate estimation: Z->mu mu
'''

import TauFakeRatesBase
import baseSelections as selections
from MuMuMuTauTree import MuMuMuTauTree


class TauFakeRatesMMMT(TauFakeRatesBase.TauFakeRatesBase):
    tree = 'mmmt/final/Ntuple'
    tau_legs = ['t']
    def __init__(self, tree, outfile, **kwargs):
        super(TauFakeRatesMMMT, self).__init__(tree, outfile, MuMuMuTauTree, **kwargs)
        
    def zSelection(self, row):
        if not selections.ZMuMuSelection(row): return False
        if not selections.generalCuts(row, 'm1','m2','m3','t'): return False
        if not selections.looseTauSelection(row, 't'): return False
        if not bool(row.tAntiMuonTight2): return False
        if not bool(row.tAntiElectronLoose): return False
        if not selections.looseMuonSelection(row, 'm3'): return False
        return True

    def sameSign(self, row):
        return bool(row.m3_t_SS)


       