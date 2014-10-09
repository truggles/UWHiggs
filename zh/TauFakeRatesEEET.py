'''
Base analyzer for hadronic tau fake-rate estimation: Z->mu mu
'''

import TauFakeRatesBase
from EEETauTree import EEETauTree
import baseSelections as selections

class TauFakeRatesEEET(TauFakeRatesBase.TauFakeRatesBase):
    tree = 'eeet/final/Ntuple'
    tau_legs = ['t']
    def __init__(self, tree, outfile, **kwargs):
        super(TauFakeRatesEEET, self).__init__(tree, outfile, EEETauTree, **kwargs)
        
    def zSelection(self, row):
        if not selections.ZEESelection(row): return False
        if not selections.generalCuts(row, 'e1','e2','e3','t') : return False
        if not selections.looseTauSelection(row,'t'): return False
        #if not bool(row.tAntiMuonLoose2): return False
        if not bool(row.tAntiElectronMVA3Tight): return False
        if not selections.looseElectronSelection(row,'e3'): return False
        # Out homemade bJet Veto, bjetCSVVetoZHLikeNoJetId_2 counts total number of bJets, upper line removes those which overlapped with tight E/Mu
        removedBJets = selections.bJetOverlapElec(row, 'e1') + selections.bJetOverlapElec(row, 'e2') + selections.bJetOverlapElec(row, 'e3')
        if (row.bjetCSVVetoZHLikeNoJetId_2 > removedBJets): return False
        return True

    def sameSign(self, row):
        return bool(row.e3_t_SS)


        
