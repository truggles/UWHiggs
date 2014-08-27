'''
Base analyzer for muon id fake-rate estimation: Z->e e
'''

import EMUFakeRatesBase
import baseSelections as selections
from EEMuTauTree import EEMuTauTree

class MUFakeRateEEMT(EMUFakeRatesBase.EMUFakeRatesBase):
    tree = 'eemt/final/Ntuple'
    def __init__(self, tree, outfile, **kwargs):
        super(MUFakeRateEEMT, self).__init__(tree, outfile, EEMuTauTree, **kwargs)
        self.lepton   = 'muon'
        self.branchId = 'm'
        
    def zSelection(self, row):
        #if not selections.ZEESelectionNoVetos(row): return False
        #if bool(row.muGlbIsoVetoPt10):  return False
        #if bool(row.bjetCSVVeto):       return False
        #if selections.overlap(row, 'e1','e2','m','t') : return False
        #if row.tPt < 5:                 return False
        ## if row.mPt < 10:              return False
        ## if row.mAbsEta > 2.4:         return False
        ## if row.mDZ > 0.1:             return False
        ## return True
        #return selections.signalMuonSelection(row,'m')

        if not selections.ZEESelection(row): return False
        if not selections.generalCuts(row, 'e1','e2','m','t') : return False
        if not selections.looseTauSelection(row,'t'): return False
        if not bool(row.tAntiMuonTight2): return False
        if not bool(row.tAntiElectronLoose): return False
        return selections.looseMuonSelection(row,'m')

    def lepton_passes_tight_iso(self, row):
        return selections.muIsoTight(row, 'm') and selections.muIDTight(row, 'm')

    def lepton_passes_loose_iso(self, row):
        return selections.muIsoLoose(row, 'm') and selections.muIDLoose(row, 'm')        
    
