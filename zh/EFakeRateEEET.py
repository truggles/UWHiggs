'''
Base analyzer for muon id fake-rate estimation: Z->e e
'''

import EMUFakeRatesBase
from EEETauTree import EEETauTree
import baseSelections as selections

class EFakeRateEEET(EMUFakeRatesBase.EMUFakeRatesBase):
    tree = 'eeet/final/Ntuple'
    def __init__(self, tree, outfile, **kwargs):
        #print 'Called: EFakeRateEEET'
        super(EFakeRateEEET, self).__init__(tree, outfile, EEETauTree, **kwargs)
        self.lepton   = 'electron'
        self.branchId = 'e3'
        
    def zSelection(self, row):
        #if not selections.ZEESelectionNoVetos(row): return False
        #if selections.overlap(row, 'e1','e2','e3','t') : return False
        #if bool(row.eVetoMVAIso):       return False
        #if bool(row.bjetCSVVeto):       return False    
        #if row.tPt < 5:                 return False     
        #if not selections.signalElectronSelection(row,'e3'): return False

        if not selections.ZEESelection(row): return False
        if not selections.generalCuts(row, 'e1','e2','e3','t') : return False
        if not selections.looseTauSelection(row,'t'): return False
        #if not bool(row.tAntiMuonLoose2): return False
        if not bool(row.tAntiElectronMVA3Tight): return False
        if not selections.looseElectronSelection(row,'e3'): return False

        # Out homemade bJet Veto, bjetCSVVetoZHLikeNoJetId_2 counts total number of bJets, upper line removes those which overlapped with tight E/Mu
        removedBJets = selections.bJetOverlapElec(row, 'e1') + selections.bJetOverlapElec(row, 'e2') + selections.bJetOverlapElec(row, 'e3')
	if (row.bjetCSVVetoZHLikeNoJetId_2 > removedBJets): return False

        # XXX Count check
        if row.muTightCountZH_0 > 0: return False
        if row.eTightCountZH_0 == 3: return False

        return True

    def lepton_passes_tight_iso(self, row):
        return selections.elIsoTight(row, 'e3') and selections.eleIDTight(row, 'e3') and (row.e3MissingHits==0) #bool( row.e3MVAIDH2TauWP ) ##THIS SEEMS too low        

    def lepton_passes_loose_iso(self, row):
        return selections.elIsoLoose(row, 'e3') and selections.eleIDLoose(row, 'e3') #bool( row.e3MVAIDH2TauWP ) ##THIS SEEMS too low        

    
