'''

Analyze MMEM events for the ZH analysis

'''

#from FinalStateAnalysis.StatTools.RooFunctorFromWS import build_roofunctor
import glob
from EMuMuMuTree import EMuMuMuTree
import os
import baseSelections as selections
import mcCorrectors
import ZHAnalyzerBase
import ROOT
import fake_rate_functions as fr_fcn

################################################################################
#### Analysis logic ############################################################
################################################################################

class ZHAnalyzeMMEM(ZHAnalyzerBase.ZHAnalyzerBase):
    tree = 'emmm/final/Ntuple'
    name = 4
    def __init__(self, tree, outfile, **kwargs):
        super(ZHAnalyzeMMEM, self).__init__(tree, outfile, EMuMuMuTree, 'EM', **kwargs)
        # Hack to use S6 weights for the one 7TeV sample we use in 8TeV
        self.pucorrector = mcCorrectors.make_puCorrector('doublemu')
        target = os.environ['megatarget']
        ## if 'HWW3l' in target:
        ##     print "HACK using S6 PU weights for HWW3l"
        ##     mcCorrectors.force_pu_distribution('S6')

    def Z_decay_products(self):
        return ('m1','m2')

    def H_decay_products(self):
        return ('e','m3')

    def book_histos(self, folder):
        self.book_cut_flow_histos(folder)
        self.book_general_histos(folder)
        self.book_kin_histos(folder, 'm1')
        self.book_kin_histos(folder, 'm2')
        self.book_kin_histos(folder, 'e')
        self.book_kin_histos(folder, 'm3')
        self.book(folder, "doubleMuPrescale", "HLT prescale", 26, -5.5, 20.5)
        self.book_Z_histos(folder)
        self.book_H_histos(folder)

    def tau1Selection(self, row):
        return selections.elIsoLoose(row, 'e') and selections.eleIDLoose(row, 'e')# and bool(row.eMissingHits <= 1)

    def tau2Selection(self, row):
        return selections.muIsoLoose(row, 'm3') and selections.muIDLoose(row, 'm3')

    def red_shape_cuts(self, row):
        # looser final selections after preselection, used for reducible shape region
        if (row.eRelPFIsoDB > 2.0): return False
        if (row.m3RelPFIsoDB > 2.0): return False
        if not selections.muIDLoose(row, 'm3'): return False
        return True

    def preselection(self, row):
        if not selections.ZMuMuSelection(row):
		return (False, 1)
        if not selections.looseElectronSelection(row, 'e'):
		return (False, 2)
        if not selections.looseMuonSelection(row, 'm3'):
		return (False, 3)
        if not selections.generalCuts(row, 'm1','m2','e','m3'):
		return (False, 4)
        if row.muTightCountZH_0 > 3:
		return (False, 4)
        if row.eTightCountZH_0 > 1 and row.eMuOverlapZHTight == 0:
		return (False, 4)
        if (row.ePt + row.m3Pt < 25):
		return (False, 5)
        # Out homemade bJet Veto, bjetCSVVetoZHLikeNoJetId_2 counts total number of bJets, upper line removes those which overlapped with tight E/Mu
        removedBJets = selections.bJetOverlapMu(row, 'm1') + selections.bJetOverlapMu(row, 'm2') + selections.bJetOverlapElec(row, 'e') + selections.bJetOverlapMu(row, 'm3')
        if (row.bjetCSVVetoZHLikeNoJetId_2 > removedBJets):
		return (False, 6)

        return (True, -1)
        

    def sign_cut(self, row):
        ''' Returns true if e and mu are OS '''
        return not bool(row.e_m3_SS)

    def event_weight(self, row):
        if row.run > 2:
            return 1.
        return self.pucorrector(row.nTruePU) * \
            mcCorrectors.get_muon_corrections(row,'m1','m2', 'm3') * \
            mcCorrectors.double_muon_trigger(row,'m1','m2')

    def leg3_weight(self, row):
        if ( row.eAbsEta <= 1.4 ):
            return fr_fcn.e_loose_jetpt_barrel_fr( row.eJetPt ) / (1 - fr_fcn.e_loose_jetpt_barrel_fr( row.eJetPt ))
        else:
            return fr_fcn.e_loose_jetpt_endcap_fr( row.eJetPt ) / (1 - fr_fcn.e_loose_jetpt_endcap_fr( row.eJetPt ))

    def leg4_weight(self, row):
        if ( row.m3AbsEta <= 1.4 ):
            return fr_fcn.mu_loose_jetpt_barrel_fr( row.m3JetPt ) / (1 - fr_fcn.mu_loose_jetpt_barrel_fr( row.m3JetPt ))
        else:
            return fr_fcn.mu_loose_jetpt_endcap_fr( row.m3JetPt ) / (1 - fr_fcn.mu_loose_jetpt_endcap_fr( row.m3JetPt ))
