'''
Base analyzer for hadronic tau fake-rate estimation: Z->mu mu
'''

import TauFakeRatesBase
from EETauTauTree import EETauTauTree
import baseSelections as selections

class TauFakeRatesEETT(TauFakeRatesBase.TauFakeRatesBase):
    tree = 'eett/final/Ntuple'
    def __init__(self, tree, outfile, **kwargs):
        super(TauFakeRatesEETT, self).__init__(tree, outfile, EETauTauTree, **kwargs)
        
    def zSelection(self, row):
        if not selections.ZEESelection(row): return False
        if not selections.generalCuts(row, 'e1','e2','t1','t2'): return False
        if (row.t1Pt + row.t2Pt < 50): return False
        if not bool(row.t1AntiMuonLoose2): return False
        if not bool(row.t1AntiElectronLoose): return False
        if not bool(row.t2AntiMuonLoose2): return False
        if not bool(row.t2AntiElectronLoose): return False
        return True


        
