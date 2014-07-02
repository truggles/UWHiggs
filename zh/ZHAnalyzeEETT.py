'''

Analyze EETT events for the ZH analysis

'''

#from FinalStateAnalysis.StatTools.RooFunctorFromWS import build_roofunctor
import glob
from EETauTauTree import EETauTauTree
import os
import FinalStateAnalysis.TagAndProbe.MuonPOGCorrections as MuonPOGCorrections
import FinalStateAnalysis.TagAndProbe.PileupWeight as PileupWeight
import baseSelections as selections
import mcCorrectors
import ZHAnalyzerBase
import ROOT
import fake_rate_functions as fr_fcn

################################################################################
#### Analysis logic ############################################################
################################################################################

class ZHAnalyzeEETT(ZHAnalyzerBase.ZHAnalyzerBase):
    tree = 'eett/final/Ntuple'
    #tree = "Ntuple"
    name = 5
    def __init__(self, tree, outfile, **kwargs):
        super(ZHAnalyzeEETT, self).__init__(tree, outfile, EETauTauTree, 'TT', **kwargs)
        # Hack to use S6 weights for the one 7TeV sample we use in 8TeV
        target = os.environ['megatarget']
        self.pucorrector = mcCorrectors.make_puCorrector('doublee')
        ## if 'HWW3l' in target:
        ##     print "HACK using S6 PU weights for HWW3l"
        ##     mcCorrectors.force_pu_distribution('S6')

    def Z_decay_products(self):
        return ('e1','e2')

    def H_decay_products(self):
        return ('t1','t2')

    def book_histos(self, folder):
        self.book_general_histos(folder)
        self.book_kin_histos(folder, 'e1')
        self.book_kin_histos(folder, 'e2')
        self.book_kin_histos(folder, 't1')
        self.book_kin_histos(folder, 't2')
        self.book_Z_histos(folder)
        self.book_H_histos(folder)
 
    def tau1Selection(self, row):
        return bool(row.t1MediumIso3Hits) 

    def tau2Selection(self, row):
        return bool(row.t2MediumIso3Hits) 

    def red_shape_cuts(self, row):
        if (row.t1MVA2IsoRaw <= 0.0): return False
        if (row.t2MVA2IsoRaw <= 0.0): return False
        return True

    def preselection(self, row):
        ''' Preselection applied to events.

        Excludes FR object IDs and sign cut.
        '''
#        print "0"
        if not selections.ZEESelection(row): return False
#        print "1"
        if not selections.generalCuts(row, 'e1','e2','t1','t2') : return False
#        print "2"
        if not selections.looseTauSelection(row,'t1'): return False
#        print "3"
        if not selections.looseTauSelection(row,'t2'): return False
#        print "4"
        if not bool(row.t1AntiMuonLoose2): return False
#        print "5"
        if not bool(row.t1AntiElectronLoose): return False
#        print "6"
        if not bool(row.t2AntiMuonLoose2): return False
#        print "7"
        if not bool(row.t2AntiElectronLoose): return False
#        print "8"
        if row.t1Pt < row.t2Pt: return False #Avoid double counting
#        print "9"
        if (row.t1Pt + row.t2Pt < 70): return False
#        print "10"
        #X# if not (row.eTightCountZH == 2): return False #THR
#        print "11"
        #X# if (row.muTightCountZH > 0): return False #THR
#        print "12"
        return True

    def sign_cut(self, row):
        ''' Returns true if muons are SS '''
        return not bool(row.t1_t2_SS)

    def event_weight(self, row):
        if row.run > 2:
            return 1.
        return self.pucorrector(row.nTruePU) * \
            mcCorrectors.get_electron_corrections(row, 'e1','e2')

    def leg3_weight(self, row):
        if (row.t1AbsEta <= 1.4):
          return fr_fcn.tau_medium_jetpt_fr_low( row.t1JetPt ) / (1 - fr_fcn.tau_medium_jetpt_fr_low( row.t1JetPt ))
        else:
          return fr_fcn.tau_medium_jetpt_fr_high( row.t1JetPt ) / (1 - fr_fcn.tau_medium_jetpt_fr_high( row.t1JetPt ))

    def leg4_weight(self, row):
        if (row.t2AbsEta <= 1.4):
          return fr_fcn.tau_medium_jetpt_fr_low( row.t2JetPt ) / (1 - fr_fcn.tau_medium_jetpt_fr_low( row.t2JetPt ))
        else:
          return fr_fcn.tau_medium_jetpt_fr_high( row.t2JetPt ) / (1 - fr_fcn.tau_medium_jetpt_fr_high( row.t2JetPt ))
