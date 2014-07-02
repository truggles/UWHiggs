

# Load relevant ROOT C++ headers
cdef extern from "TObject.h":
    cdef cppclass TObject:
        pass

cdef extern from "TBranch.h":
    cdef cppclass TBranch:
        int GetEntry(long, int)
        void SetAddress(void*)

cdef extern from "TTree.h":
    cdef cppclass TTree:
        TTree()
        int GetEntry(long, int)
        long LoadTree(long)
        long GetEntries()
        TTree* GetTree()
        int GetTreeNumber()
        TBranch* GetBranch(char*)

cdef extern from "TFile.h":
    cdef cppclass TFile:
        TFile(char*, char*, char*, int)
        TObject* Get(char*)

# Used for filtering with a string
cdef extern from "TTreeFormula.h":
    cdef cppclass TTreeFormula:
        TTreeFormula(char*, char*, TTree*)
        double EvalInstance(int, char**)
        void UpdateFormulaLeaves()
        void SetTree(TTree*)

from cpython cimport PyCObject_AsVoidPtr
import warnings
def my_warning_format(message, category, filename, lineno, line=""):
    return "%s:%s\n" % (category.__name__, message)
warnings.formatwarning = my_warning_format

cdef class MuMuTauTauTree:
    # Pointers to tree (may be a chain), current active tree, and current entry
    # localentry is the entry in the current tree of the chain
    cdef TTree* tree
    cdef TTree* currentTree
    cdef int currentTreeNumber
    cdef long ientry
    cdef long localentry
    # Keep track of missing branches we have complained about.
    cdef public set complained

    # Branches and address for all

    cdef TBranch* EmbPtWeight_branch
    cdef float EmbPtWeight_value

    cdef TBranch* LT_branch
    cdef float LT_value

    cdef TBranch* Mass_branch
    cdef float Mass_value

    cdef TBranch* MassError_branch
    cdef float MassError_value

    cdef TBranch* MassErrord1_branch
    cdef float MassErrord1_value

    cdef TBranch* MassErrord2_branch
    cdef float MassErrord2_value

    cdef TBranch* MassErrord3_branch
    cdef float MassErrord3_value

    cdef TBranch* MassErrord4_branch
    cdef float MassErrord4_value

    cdef TBranch* NUP_branch
    cdef float NUP_value

    cdef TBranch* Pt_branch
    cdef float Pt_value

    cdef TBranch* bjetCSVVeto_branch
    cdef float bjetCSVVeto_value

    cdef TBranch* bjetCSVVeto30_branch
    cdef float bjetCSVVeto30_value

    cdef TBranch* bjetCSVVetoZHLike_branch
    cdef float bjetCSVVetoZHLike_value

    cdef TBranch* bjetCSVVetoZHLikeNoJetId_branch
    cdef float bjetCSVVetoZHLikeNoJetId_value

    cdef TBranch* bjetCSVVetoZHLikeNoJetId_2_branch
    cdef float bjetCSVVetoZHLikeNoJetId_2_value

    cdef TBranch* bjetTightCountZH_branch
    cdef float bjetTightCountZH_value

    cdef TBranch* bjetVeto_branch
    cdef float bjetVeto_value

    cdef TBranch* charge_branch
    cdef float charge_value

    cdef TBranch* doubleEExtraGroup_branch
    cdef float doubleEExtraGroup_value

    cdef TBranch* doubleEExtraPass_branch
    cdef float doubleEExtraPass_value

    cdef TBranch* doubleEExtraPrescale_branch
    cdef float doubleEExtraPrescale_value

    cdef TBranch* doubleEGroup_branch
    cdef float doubleEGroup_value

    cdef TBranch* doubleEPass_branch
    cdef float doubleEPass_value

    cdef TBranch* doubleEPrescale_branch
    cdef float doubleEPrescale_value

    cdef TBranch* doubleETightGroup_branch
    cdef float doubleETightGroup_value

    cdef TBranch* doubleETightPass_branch
    cdef float doubleETightPass_value

    cdef TBranch* doubleETightPrescale_branch
    cdef float doubleETightPrescale_value

    cdef TBranch* doubleMuGroup_branch
    cdef float doubleMuGroup_value

    cdef TBranch* doubleMuPass_branch
    cdef float doubleMuPass_value

    cdef TBranch* doubleMuPrescale_branch
    cdef float doubleMuPrescale_value

    cdef TBranch* doubleMuTrkGroup_branch
    cdef float doubleMuTrkGroup_value

    cdef TBranch* doubleMuTrkPass_branch
    cdef float doubleMuTrkPass_value

    cdef TBranch* doubleMuTrkPrescale_branch
    cdef float doubleMuTrkPrescale_value

    cdef TBranch* doublePhoGroup_branch
    cdef float doublePhoGroup_value

    cdef TBranch* doublePhoPass_branch
    cdef float doublePhoPass_value

    cdef TBranch* doublePhoPrescale_branch
    cdef float doublePhoPrescale_value

    cdef TBranch* eTightCountZH_branch
    cdef float eTightCountZH_value

    cdef TBranch* eVetoCicTightIso_branch
    cdef float eVetoCicTightIso_value

    cdef TBranch* eVetoMVAIso_branch
    cdef float eVetoMVAIso_value

    cdef TBranch* eVetoMVAIsoVtx_branch
    cdef float eVetoMVAIsoVtx_value

    cdef TBranch* eVetoZH_branch
    cdef float eVetoZH_value

    cdef TBranch* eVetoZH_smallDR_branch
    cdef float eVetoZH_smallDR_value

    cdef TBranch* evt_branch
    cdef int evt_value

    cdef TBranch* isGtautau_branch
    cdef float isGtautau_value

    cdef TBranch* isWmunu_branch
    cdef float isWmunu_value

    cdef TBranch* isWtaunu_branch
    cdef float isWtaunu_value

    cdef TBranch* isZtautau_branch
    cdef float isZtautau_value

    cdef TBranch* isdata_branch
    cdef int isdata_value

    cdef TBranch* isoMu24eta2p1Group_branch
    cdef float isoMu24eta2p1Group_value

    cdef TBranch* isoMu24eta2p1Pass_branch
    cdef float isoMu24eta2p1Pass_value

    cdef TBranch* isoMu24eta2p1Prescale_branch
    cdef float isoMu24eta2p1Prescale_value

    cdef TBranch* isoMuGroup_branch
    cdef float isoMuGroup_value

    cdef TBranch* isoMuPass_branch
    cdef float isoMuPass_value

    cdef TBranch* isoMuPrescale_branch
    cdef float isoMuPrescale_value

    cdef TBranch* isoMuTauGroup_branch
    cdef float isoMuTauGroup_value

    cdef TBranch* isoMuTauPass_branch
    cdef float isoMuTauPass_value

    cdef TBranch* isoMuTauPrescale_branch
    cdef float isoMuTauPrescale_value

    cdef TBranch* jetVeto20_branch
    cdef float jetVeto20_value

    cdef TBranch* jetVeto20_DR05_branch
    cdef float jetVeto20_DR05_value

    cdef TBranch* jetVeto30_branch
    cdef float jetVeto30_value

    cdef TBranch* jetVeto30_DR05_branch
    cdef float jetVeto30_DR05_value

    cdef TBranch* jetVeto40_branch
    cdef float jetVeto40_value

    cdef TBranch* jetVeto40_DR05_branch
    cdef float jetVeto40_DR05_value

    cdef TBranch* lumi_branch
    cdef int lumi_value

    cdef TBranch* m1AbsEta_branch
    cdef float m1AbsEta_value

    cdef TBranch* m1Charge_branch
    cdef float m1Charge_value

    cdef TBranch* m1ComesFromHiggs_branch
    cdef float m1ComesFromHiggs_value

    cdef TBranch* m1D0_branch
    cdef float m1D0_value

    cdef TBranch* m1DZ_branch
    cdef float m1DZ_value

    cdef TBranch* m1DiMuonL3PreFiltered7_branch
    cdef float m1DiMuonL3PreFiltered7_value

    cdef TBranch* m1DiMuonL3p5PreFiltered8_branch
    cdef float m1DiMuonL3p5PreFiltered8_value

    cdef TBranch* m1DiMuonMu17Mu8DzFiltered0p2_branch
    cdef float m1DiMuonMu17Mu8DzFiltered0p2_value

    cdef TBranch* m1EErrRochCor2011A_branch
    cdef float m1EErrRochCor2011A_value

    cdef TBranch* m1EErrRochCor2011B_branch
    cdef float m1EErrRochCor2011B_value

    cdef TBranch* m1EErrRochCor2012_branch
    cdef float m1EErrRochCor2012_value

    cdef TBranch* m1ERochCor2011A_branch
    cdef float m1ERochCor2011A_value

    cdef TBranch* m1ERochCor2011B_branch
    cdef float m1ERochCor2011B_value

    cdef TBranch* m1ERochCor2012_branch
    cdef float m1ERochCor2012_value

    cdef TBranch* m1EffectiveArea2011_branch
    cdef float m1EffectiveArea2011_value

    cdef TBranch* m1EffectiveArea2012_branch
    cdef float m1EffectiveArea2012_value

    cdef TBranch* m1Eta_branch
    cdef float m1Eta_value

    cdef TBranch* m1EtaRochCor2011A_branch
    cdef float m1EtaRochCor2011A_value

    cdef TBranch* m1EtaRochCor2011B_branch
    cdef float m1EtaRochCor2011B_value

    cdef TBranch* m1EtaRochCor2012_branch
    cdef float m1EtaRochCor2012_value

    cdef TBranch* m1GenCharge_branch
    cdef float m1GenCharge_value

    cdef TBranch* m1GenEnergy_branch
    cdef float m1GenEnergy_value

    cdef TBranch* m1GenEta_branch
    cdef float m1GenEta_value

    cdef TBranch* m1GenMotherPdgId_branch
    cdef float m1GenMotherPdgId_value

    cdef TBranch* m1GenPdgId_branch
    cdef float m1GenPdgId_value

    cdef TBranch* m1GenPhi_branch
    cdef float m1GenPhi_value

    cdef TBranch* m1GlbTrkHits_branch
    cdef float m1GlbTrkHits_value

    cdef TBranch* m1IDHZG2011_branch
    cdef float m1IDHZG2011_value

    cdef TBranch* m1IDHZG2012_branch
    cdef float m1IDHZG2012_value

    cdef TBranch* m1IP3DS_branch
    cdef float m1IP3DS_value

    cdef TBranch* m1IsGlobal_branch
    cdef float m1IsGlobal_value

    cdef TBranch* m1IsPFMuon_branch
    cdef float m1IsPFMuon_value

    cdef TBranch* m1IsTracker_branch
    cdef float m1IsTracker_value

    cdef TBranch* m1JetArea_branch
    cdef float m1JetArea_value

    cdef TBranch* m1JetBtag_branch
    cdef float m1JetBtag_value

    cdef TBranch* m1JetCSVBtag_branch
    cdef float m1JetCSVBtag_value

    cdef TBranch* m1JetEtaEtaMoment_branch
    cdef float m1JetEtaEtaMoment_value

    cdef TBranch* m1JetEtaPhiMoment_branch
    cdef float m1JetEtaPhiMoment_value

    cdef TBranch* m1JetEtaPhiSpread_branch
    cdef float m1JetEtaPhiSpread_value

    cdef TBranch* m1JetPartonFlavour_branch
    cdef float m1JetPartonFlavour_value

    cdef TBranch* m1JetPhiPhiMoment_branch
    cdef float m1JetPhiPhiMoment_value

    cdef TBranch* m1JetPt_branch
    cdef float m1JetPt_value

    cdef TBranch* m1JetQGLikelihoodID_branch
    cdef float m1JetQGLikelihoodID_value

    cdef TBranch* m1JetQGMVAID_branch
    cdef float m1JetQGMVAID_value

    cdef TBranch* m1Jetaxis1_branch
    cdef float m1Jetaxis1_value

    cdef TBranch* m1Jetaxis2_branch
    cdef float m1Jetaxis2_value

    cdef TBranch* m1Jetmult_branch
    cdef float m1Jetmult_value

    cdef TBranch* m1JetmultMLP_branch
    cdef float m1JetmultMLP_value

    cdef TBranch* m1JetmultMLPQC_branch
    cdef float m1JetmultMLPQC_value

    cdef TBranch* m1JetptD_branch
    cdef float m1JetptD_value

    cdef TBranch* m1L1Mu3EG5L3Filtered17_branch
    cdef float m1L1Mu3EG5L3Filtered17_value

    cdef TBranch* m1L3fL1DoubleMu10MuOpenL1f0L2f10L3Filtered17_branch
    cdef float m1L3fL1DoubleMu10MuOpenL1f0L2f10L3Filtered17_value

    cdef TBranch* m1Mass_branch
    cdef float m1Mass_value

    cdef TBranch* m1MatchedStations_branch
    cdef float m1MatchedStations_value

    cdef TBranch* m1MatchesDoubleMuPaths_branch
    cdef float m1MatchesDoubleMuPaths_value

    cdef TBranch* m1MatchesDoubleMuTrkPaths_branch
    cdef float m1MatchesDoubleMuTrkPaths_value

    cdef TBranch* m1MatchesIsoMu24eta2p1_branch
    cdef float m1MatchesIsoMu24eta2p1_value

    cdef TBranch* m1MatchesIsoMuGroup_branch
    cdef float m1MatchesIsoMuGroup_value

    cdef TBranch* m1MatchesMu17Ele8IsoPath_branch
    cdef float m1MatchesMu17Ele8IsoPath_value

    cdef TBranch* m1MatchesMu17Ele8Path_branch
    cdef float m1MatchesMu17Ele8Path_value

    cdef TBranch* m1MatchesMu17Mu8Path_branch
    cdef float m1MatchesMu17Mu8Path_value

    cdef TBranch* m1MatchesMu17TrkMu8Path_branch
    cdef float m1MatchesMu17TrkMu8Path_value

    cdef TBranch* m1MatchesMu8Ele17IsoPath_branch
    cdef float m1MatchesMu8Ele17IsoPath_value

    cdef TBranch* m1MatchesMu8Ele17Path_branch
    cdef float m1MatchesMu8Ele17Path_value

    cdef TBranch* m1MtToMET_branch
    cdef float m1MtToMET_value

    cdef TBranch* m1MtToMVAMET_branch
    cdef float m1MtToMVAMET_value

    cdef TBranch* m1MtToPFMET_branch
    cdef float m1MtToPFMET_value

    cdef TBranch* m1MtToPfMet_Ty1_branch
    cdef float m1MtToPfMet_Ty1_value

    cdef TBranch* m1MtToPfMet_jes_branch
    cdef float m1MtToPfMet_jes_value

    cdef TBranch* m1MtToPfMet_mes_branch
    cdef float m1MtToPfMet_mes_value

    cdef TBranch* m1MtToPfMet_tes_branch
    cdef float m1MtToPfMet_tes_value

    cdef TBranch* m1MtToPfMet_ues_branch
    cdef float m1MtToPfMet_ues_value

    cdef TBranch* m1Mu17Ele8dZFilter_branch
    cdef float m1Mu17Ele8dZFilter_value

    cdef TBranch* m1MuonHits_branch
    cdef float m1MuonHits_value

    cdef TBranch* m1NormTrkChi2_branch
    cdef float m1NormTrkChi2_value

    cdef TBranch* m1PFChargedIso_branch
    cdef float m1PFChargedIso_value

    cdef TBranch* m1PFIDTight_branch
    cdef float m1PFIDTight_value

    cdef TBranch* m1PFNeutralIso_branch
    cdef float m1PFNeutralIso_value

    cdef TBranch* m1PFPUChargedIso_branch
    cdef float m1PFPUChargedIso_value

    cdef TBranch* m1PFPhotonIso_branch
    cdef float m1PFPhotonIso_value

    cdef TBranch* m1PVDXY_branch
    cdef float m1PVDXY_value

    cdef TBranch* m1PVDZ_branch
    cdef float m1PVDZ_value

    cdef TBranch* m1Phi_branch
    cdef float m1Phi_value

    cdef TBranch* m1PhiRochCor2011A_branch
    cdef float m1PhiRochCor2011A_value

    cdef TBranch* m1PhiRochCor2011B_branch
    cdef float m1PhiRochCor2011B_value

    cdef TBranch* m1PhiRochCor2012_branch
    cdef float m1PhiRochCor2012_value

    cdef TBranch* m1PixHits_branch
    cdef float m1PixHits_value

    cdef TBranch* m1Pt_branch
    cdef float m1Pt_value

    cdef TBranch* m1PtRochCor2011A_branch
    cdef float m1PtRochCor2011A_value

    cdef TBranch* m1PtRochCor2011B_branch
    cdef float m1PtRochCor2011B_value

    cdef TBranch* m1PtRochCor2012_branch
    cdef float m1PtRochCor2012_value

    cdef TBranch* m1Rank_branch
    cdef float m1Rank_value

    cdef TBranch* m1RelPFIsoDB_branch
    cdef float m1RelPFIsoDB_value

    cdef TBranch* m1RelPFIsoRho_branch
    cdef float m1RelPFIsoRho_value

    cdef TBranch* m1RelPFIsoRhoFSR_branch
    cdef float m1RelPFIsoRhoFSR_value

    cdef TBranch* m1RhoHZG2011_branch
    cdef float m1RhoHZG2011_value

    cdef TBranch* m1RhoHZG2012_branch
    cdef float m1RhoHZG2012_value

    cdef TBranch* m1SingleMu13L3Filtered13_branch
    cdef float m1SingleMu13L3Filtered13_value

    cdef TBranch* m1SingleMu13L3Filtered17_branch
    cdef float m1SingleMu13L3Filtered17_value

    cdef TBranch* m1TkLayersWithMeasurement_branch
    cdef float m1TkLayersWithMeasurement_value

    cdef TBranch* m1ToMETDPhi_branch
    cdef float m1ToMETDPhi_value

    cdef TBranch* m1TypeCode_branch
    cdef int m1TypeCode_value

    cdef TBranch* m1VBTFID_branch
    cdef float m1VBTFID_value

    cdef TBranch* m1VZ_branch
    cdef float m1VZ_value

    cdef TBranch* m1WWID_branch
    cdef float m1WWID_value

    cdef TBranch* m1_m2_CosThetaStar_branch
    cdef float m1_m2_CosThetaStar_value

    cdef TBranch* m1_m2_DPhi_branch
    cdef float m1_m2_DPhi_value

    cdef TBranch* m1_m2_DR_branch
    cdef float m1_m2_DR_value

    cdef TBranch* m1_m2_Eta_branch
    cdef float m1_m2_Eta_value

    cdef TBranch* m1_m2_Mass_branch
    cdef float m1_m2_Mass_value

    cdef TBranch* m1_m2_MassFsr_branch
    cdef float m1_m2_MassFsr_value

    cdef TBranch* m1_m2_PZeta_branch
    cdef float m1_m2_PZeta_value

    cdef TBranch* m1_m2_PZetaVis_branch
    cdef float m1_m2_PZetaVis_value

    cdef TBranch* m1_m2_Phi_branch
    cdef float m1_m2_Phi_value

    cdef TBranch* m1_m2_Pt_branch
    cdef float m1_m2_Pt_value

    cdef TBranch* m1_m2_PtFsr_branch
    cdef float m1_m2_PtFsr_value

    cdef TBranch* m1_m2_SS_branch
    cdef float m1_m2_SS_value

    cdef TBranch* m1_m2_ToMETDPhi_Ty1_branch
    cdef float m1_m2_ToMETDPhi_Ty1_value

    cdef TBranch* m1_m2_Zcompat_branch
    cdef float m1_m2_Zcompat_value

    cdef TBranch* m1_t1_CosThetaStar_branch
    cdef float m1_t1_CosThetaStar_value

    cdef TBranch* m1_t1_DPhi_branch
    cdef float m1_t1_DPhi_value

    cdef TBranch* m1_t1_DR_branch
    cdef float m1_t1_DR_value

    cdef TBranch* m1_t1_Eta_branch
    cdef float m1_t1_Eta_value

    cdef TBranch* m1_t1_Mass_branch
    cdef float m1_t1_Mass_value

    cdef TBranch* m1_t1_MassFsr_branch
    cdef float m1_t1_MassFsr_value

    cdef TBranch* m1_t1_PZeta_branch
    cdef float m1_t1_PZeta_value

    cdef TBranch* m1_t1_PZetaVis_branch
    cdef float m1_t1_PZetaVis_value

    cdef TBranch* m1_t1_Phi_branch
    cdef float m1_t1_Phi_value

    cdef TBranch* m1_t1_Pt_branch
    cdef float m1_t1_Pt_value

    cdef TBranch* m1_t1_PtFsr_branch
    cdef float m1_t1_PtFsr_value

    cdef TBranch* m1_t1_SS_branch
    cdef float m1_t1_SS_value

    cdef TBranch* m1_t1_ToMETDPhi_Ty1_branch
    cdef float m1_t1_ToMETDPhi_Ty1_value

    cdef TBranch* m1_t1_Zcompat_branch
    cdef float m1_t1_Zcompat_value

    cdef TBranch* m1_t2_CosThetaStar_branch
    cdef float m1_t2_CosThetaStar_value

    cdef TBranch* m1_t2_DPhi_branch
    cdef float m1_t2_DPhi_value

    cdef TBranch* m1_t2_DR_branch
    cdef float m1_t2_DR_value

    cdef TBranch* m1_t2_Eta_branch
    cdef float m1_t2_Eta_value

    cdef TBranch* m1_t2_Mass_branch
    cdef float m1_t2_Mass_value

    cdef TBranch* m1_t2_MassFsr_branch
    cdef float m1_t2_MassFsr_value

    cdef TBranch* m1_t2_PZeta_branch
    cdef float m1_t2_PZeta_value

    cdef TBranch* m1_t2_PZetaVis_branch
    cdef float m1_t2_PZetaVis_value

    cdef TBranch* m1_t2_Phi_branch
    cdef float m1_t2_Phi_value

    cdef TBranch* m1_t2_Pt_branch
    cdef float m1_t2_Pt_value

    cdef TBranch* m1_t2_PtFsr_branch
    cdef float m1_t2_PtFsr_value

    cdef TBranch* m1_t2_SS_branch
    cdef float m1_t2_SS_value

    cdef TBranch* m1_t2_ToMETDPhi_Ty1_branch
    cdef float m1_t2_ToMETDPhi_Ty1_value

    cdef TBranch* m1_t2_Zcompat_branch
    cdef float m1_t2_Zcompat_value

    cdef TBranch* m2AbsEta_branch
    cdef float m2AbsEta_value

    cdef TBranch* m2Charge_branch
    cdef float m2Charge_value

    cdef TBranch* m2ComesFromHiggs_branch
    cdef float m2ComesFromHiggs_value

    cdef TBranch* m2D0_branch
    cdef float m2D0_value

    cdef TBranch* m2DZ_branch
    cdef float m2DZ_value

    cdef TBranch* m2DiMuonL3PreFiltered7_branch
    cdef float m2DiMuonL3PreFiltered7_value

    cdef TBranch* m2DiMuonL3p5PreFiltered8_branch
    cdef float m2DiMuonL3p5PreFiltered8_value

    cdef TBranch* m2DiMuonMu17Mu8DzFiltered0p2_branch
    cdef float m2DiMuonMu17Mu8DzFiltered0p2_value

    cdef TBranch* m2EErrRochCor2011A_branch
    cdef float m2EErrRochCor2011A_value

    cdef TBranch* m2EErrRochCor2011B_branch
    cdef float m2EErrRochCor2011B_value

    cdef TBranch* m2EErrRochCor2012_branch
    cdef float m2EErrRochCor2012_value

    cdef TBranch* m2ERochCor2011A_branch
    cdef float m2ERochCor2011A_value

    cdef TBranch* m2ERochCor2011B_branch
    cdef float m2ERochCor2011B_value

    cdef TBranch* m2ERochCor2012_branch
    cdef float m2ERochCor2012_value

    cdef TBranch* m2EffectiveArea2011_branch
    cdef float m2EffectiveArea2011_value

    cdef TBranch* m2EffectiveArea2012_branch
    cdef float m2EffectiveArea2012_value

    cdef TBranch* m2Eta_branch
    cdef float m2Eta_value

    cdef TBranch* m2EtaRochCor2011A_branch
    cdef float m2EtaRochCor2011A_value

    cdef TBranch* m2EtaRochCor2011B_branch
    cdef float m2EtaRochCor2011B_value

    cdef TBranch* m2EtaRochCor2012_branch
    cdef float m2EtaRochCor2012_value

    cdef TBranch* m2GenCharge_branch
    cdef float m2GenCharge_value

    cdef TBranch* m2GenEnergy_branch
    cdef float m2GenEnergy_value

    cdef TBranch* m2GenEta_branch
    cdef float m2GenEta_value

    cdef TBranch* m2GenMotherPdgId_branch
    cdef float m2GenMotherPdgId_value

    cdef TBranch* m2GenPdgId_branch
    cdef float m2GenPdgId_value

    cdef TBranch* m2GenPhi_branch
    cdef float m2GenPhi_value

    cdef TBranch* m2GlbTrkHits_branch
    cdef float m2GlbTrkHits_value

    cdef TBranch* m2IDHZG2011_branch
    cdef float m2IDHZG2011_value

    cdef TBranch* m2IDHZG2012_branch
    cdef float m2IDHZG2012_value

    cdef TBranch* m2IP3DS_branch
    cdef float m2IP3DS_value

    cdef TBranch* m2IsGlobal_branch
    cdef float m2IsGlobal_value

    cdef TBranch* m2IsPFMuon_branch
    cdef float m2IsPFMuon_value

    cdef TBranch* m2IsTracker_branch
    cdef float m2IsTracker_value

    cdef TBranch* m2JetArea_branch
    cdef float m2JetArea_value

    cdef TBranch* m2JetBtag_branch
    cdef float m2JetBtag_value

    cdef TBranch* m2JetCSVBtag_branch
    cdef float m2JetCSVBtag_value

    cdef TBranch* m2JetEtaEtaMoment_branch
    cdef float m2JetEtaEtaMoment_value

    cdef TBranch* m2JetEtaPhiMoment_branch
    cdef float m2JetEtaPhiMoment_value

    cdef TBranch* m2JetEtaPhiSpread_branch
    cdef float m2JetEtaPhiSpread_value

    cdef TBranch* m2JetPartonFlavour_branch
    cdef float m2JetPartonFlavour_value

    cdef TBranch* m2JetPhiPhiMoment_branch
    cdef float m2JetPhiPhiMoment_value

    cdef TBranch* m2JetPt_branch
    cdef float m2JetPt_value

    cdef TBranch* m2JetQGLikelihoodID_branch
    cdef float m2JetQGLikelihoodID_value

    cdef TBranch* m2JetQGMVAID_branch
    cdef float m2JetQGMVAID_value

    cdef TBranch* m2Jetaxis1_branch
    cdef float m2Jetaxis1_value

    cdef TBranch* m2Jetaxis2_branch
    cdef float m2Jetaxis2_value

    cdef TBranch* m2Jetmult_branch
    cdef float m2Jetmult_value

    cdef TBranch* m2JetmultMLP_branch
    cdef float m2JetmultMLP_value

    cdef TBranch* m2JetmultMLPQC_branch
    cdef float m2JetmultMLPQC_value

    cdef TBranch* m2JetptD_branch
    cdef float m2JetptD_value

    cdef TBranch* m2L1Mu3EG5L3Filtered17_branch
    cdef float m2L1Mu3EG5L3Filtered17_value

    cdef TBranch* m2L3fL1DoubleMu10MuOpenL1f0L2f10L3Filtered17_branch
    cdef float m2L3fL1DoubleMu10MuOpenL1f0L2f10L3Filtered17_value

    cdef TBranch* m2Mass_branch
    cdef float m2Mass_value

    cdef TBranch* m2MatchedStations_branch
    cdef float m2MatchedStations_value

    cdef TBranch* m2MatchesDoubleMuPaths_branch
    cdef float m2MatchesDoubleMuPaths_value

    cdef TBranch* m2MatchesDoubleMuTrkPaths_branch
    cdef float m2MatchesDoubleMuTrkPaths_value

    cdef TBranch* m2MatchesIsoMu24eta2p1_branch
    cdef float m2MatchesIsoMu24eta2p1_value

    cdef TBranch* m2MatchesIsoMuGroup_branch
    cdef float m2MatchesIsoMuGroup_value

    cdef TBranch* m2MatchesMu17Ele8IsoPath_branch
    cdef float m2MatchesMu17Ele8IsoPath_value

    cdef TBranch* m2MatchesMu17Ele8Path_branch
    cdef float m2MatchesMu17Ele8Path_value

    cdef TBranch* m2MatchesMu17Mu8Path_branch
    cdef float m2MatchesMu17Mu8Path_value

    cdef TBranch* m2MatchesMu17TrkMu8Path_branch
    cdef float m2MatchesMu17TrkMu8Path_value

    cdef TBranch* m2MatchesMu8Ele17IsoPath_branch
    cdef float m2MatchesMu8Ele17IsoPath_value

    cdef TBranch* m2MatchesMu8Ele17Path_branch
    cdef float m2MatchesMu8Ele17Path_value

    cdef TBranch* m2MtToMET_branch
    cdef float m2MtToMET_value

    cdef TBranch* m2MtToMVAMET_branch
    cdef float m2MtToMVAMET_value

    cdef TBranch* m2MtToPFMET_branch
    cdef float m2MtToPFMET_value

    cdef TBranch* m2MtToPfMet_Ty1_branch
    cdef float m2MtToPfMet_Ty1_value

    cdef TBranch* m2MtToPfMet_jes_branch
    cdef float m2MtToPfMet_jes_value

    cdef TBranch* m2MtToPfMet_mes_branch
    cdef float m2MtToPfMet_mes_value

    cdef TBranch* m2MtToPfMet_tes_branch
    cdef float m2MtToPfMet_tes_value

    cdef TBranch* m2MtToPfMet_ues_branch
    cdef float m2MtToPfMet_ues_value

    cdef TBranch* m2Mu17Ele8dZFilter_branch
    cdef float m2Mu17Ele8dZFilter_value

    cdef TBranch* m2MuonHits_branch
    cdef float m2MuonHits_value

    cdef TBranch* m2NormTrkChi2_branch
    cdef float m2NormTrkChi2_value

    cdef TBranch* m2PFChargedIso_branch
    cdef float m2PFChargedIso_value

    cdef TBranch* m2PFIDTight_branch
    cdef float m2PFIDTight_value

    cdef TBranch* m2PFNeutralIso_branch
    cdef float m2PFNeutralIso_value

    cdef TBranch* m2PFPUChargedIso_branch
    cdef float m2PFPUChargedIso_value

    cdef TBranch* m2PFPhotonIso_branch
    cdef float m2PFPhotonIso_value

    cdef TBranch* m2PVDXY_branch
    cdef float m2PVDXY_value

    cdef TBranch* m2PVDZ_branch
    cdef float m2PVDZ_value

    cdef TBranch* m2Phi_branch
    cdef float m2Phi_value

    cdef TBranch* m2PhiRochCor2011A_branch
    cdef float m2PhiRochCor2011A_value

    cdef TBranch* m2PhiRochCor2011B_branch
    cdef float m2PhiRochCor2011B_value

    cdef TBranch* m2PhiRochCor2012_branch
    cdef float m2PhiRochCor2012_value

    cdef TBranch* m2PixHits_branch
    cdef float m2PixHits_value

    cdef TBranch* m2Pt_branch
    cdef float m2Pt_value

    cdef TBranch* m2PtRochCor2011A_branch
    cdef float m2PtRochCor2011A_value

    cdef TBranch* m2PtRochCor2011B_branch
    cdef float m2PtRochCor2011B_value

    cdef TBranch* m2PtRochCor2012_branch
    cdef float m2PtRochCor2012_value

    cdef TBranch* m2Rank_branch
    cdef float m2Rank_value

    cdef TBranch* m2RelPFIsoDB_branch
    cdef float m2RelPFIsoDB_value

    cdef TBranch* m2RelPFIsoRho_branch
    cdef float m2RelPFIsoRho_value

    cdef TBranch* m2RelPFIsoRhoFSR_branch
    cdef float m2RelPFIsoRhoFSR_value

    cdef TBranch* m2RhoHZG2011_branch
    cdef float m2RhoHZG2011_value

    cdef TBranch* m2RhoHZG2012_branch
    cdef float m2RhoHZG2012_value

    cdef TBranch* m2SingleMu13L3Filtered13_branch
    cdef float m2SingleMu13L3Filtered13_value

    cdef TBranch* m2SingleMu13L3Filtered17_branch
    cdef float m2SingleMu13L3Filtered17_value

    cdef TBranch* m2TkLayersWithMeasurement_branch
    cdef float m2TkLayersWithMeasurement_value

    cdef TBranch* m2ToMETDPhi_branch
    cdef float m2ToMETDPhi_value

    cdef TBranch* m2TypeCode_branch
    cdef int m2TypeCode_value

    cdef TBranch* m2VBTFID_branch
    cdef float m2VBTFID_value

    cdef TBranch* m2VZ_branch
    cdef float m2VZ_value

    cdef TBranch* m2WWID_branch
    cdef float m2WWID_value

    cdef TBranch* m2_t1_CosThetaStar_branch
    cdef float m2_t1_CosThetaStar_value

    cdef TBranch* m2_t1_DPhi_branch
    cdef float m2_t1_DPhi_value

    cdef TBranch* m2_t1_DR_branch
    cdef float m2_t1_DR_value

    cdef TBranch* m2_t1_Eta_branch
    cdef float m2_t1_Eta_value

    cdef TBranch* m2_t1_Mass_branch
    cdef float m2_t1_Mass_value

    cdef TBranch* m2_t1_MassFsr_branch
    cdef float m2_t1_MassFsr_value

    cdef TBranch* m2_t1_PZeta_branch
    cdef float m2_t1_PZeta_value

    cdef TBranch* m2_t1_PZetaVis_branch
    cdef float m2_t1_PZetaVis_value

    cdef TBranch* m2_t1_Phi_branch
    cdef float m2_t1_Phi_value

    cdef TBranch* m2_t1_Pt_branch
    cdef float m2_t1_Pt_value

    cdef TBranch* m2_t1_PtFsr_branch
    cdef float m2_t1_PtFsr_value

    cdef TBranch* m2_t1_SS_branch
    cdef float m2_t1_SS_value

    cdef TBranch* m2_t1_ToMETDPhi_Ty1_branch
    cdef float m2_t1_ToMETDPhi_Ty1_value

    cdef TBranch* m2_t1_Zcompat_branch
    cdef float m2_t1_Zcompat_value

    cdef TBranch* m2_t2_CosThetaStar_branch
    cdef float m2_t2_CosThetaStar_value

    cdef TBranch* m2_t2_DPhi_branch
    cdef float m2_t2_DPhi_value

    cdef TBranch* m2_t2_DR_branch
    cdef float m2_t2_DR_value

    cdef TBranch* m2_t2_Eta_branch
    cdef float m2_t2_Eta_value

    cdef TBranch* m2_t2_Mass_branch
    cdef float m2_t2_Mass_value

    cdef TBranch* m2_t2_MassFsr_branch
    cdef float m2_t2_MassFsr_value

    cdef TBranch* m2_t2_PZeta_branch
    cdef float m2_t2_PZeta_value

    cdef TBranch* m2_t2_PZetaVis_branch
    cdef float m2_t2_PZetaVis_value

    cdef TBranch* m2_t2_Phi_branch
    cdef float m2_t2_Phi_value

    cdef TBranch* m2_t2_Pt_branch
    cdef float m2_t2_Pt_value

    cdef TBranch* m2_t2_PtFsr_branch
    cdef float m2_t2_PtFsr_value

    cdef TBranch* m2_t2_SS_branch
    cdef float m2_t2_SS_value

    cdef TBranch* m2_t2_ToMETDPhi_Ty1_branch
    cdef float m2_t2_ToMETDPhi_Ty1_value

    cdef TBranch* m2_t2_Zcompat_branch
    cdef float m2_t2_Zcompat_value

    cdef TBranch* mu17ele8Group_branch
    cdef float mu17ele8Group_value

    cdef TBranch* mu17ele8Pass_branch
    cdef float mu17ele8Pass_value

    cdef TBranch* mu17ele8Prescale_branch
    cdef float mu17ele8Prescale_value

    cdef TBranch* mu17ele8isoGroup_branch
    cdef float mu17ele8isoGroup_value

    cdef TBranch* mu17ele8isoPass_branch
    cdef float mu17ele8isoPass_value

    cdef TBranch* mu17ele8isoPrescale_branch
    cdef float mu17ele8isoPrescale_value

    cdef TBranch* mu17mu8Group_branch
    cdef float mu17mu8Group_value

    cdef TBranch* mu17mu8Pass_branch
    cdef float mu17mu8Pass_value

    cdef TBranch* mu17mu8Prescale_branch
    cdef float mu17mu8Prescale_value

    cdef TBranch* mu8ele17Group_branch
    cdef float mu8ele17Group_value

    cdef TBranch* mu8ele17Pass_branch
    cdef float mu8ele17Pass_value

    cdef TBranch* mu8ele17Prescale_branch
    cdef float mu8ele17Prescale_value

    cdef TBranch* mu8ele17isoGroup_branch
    cdef float mu8ele17isoGroup_value

    cdef TBranch* mu8ele17isoPass_branch
    cdef float mu8ele17isoPass_value

    cdef TBranch* mu8ele17isoPrescale_branch
    cdef float mu8ele17isoPrescale_value

    cdef TBranch* muGlbIsoVetoPt10_branch
    cdef float muGlbIsoVetoPt10_value

    cdef TBranch* muTauGroup_branch
    cdef float muTauGroup_value

    cdef TBranch* muTauPass_branch
    cdef float muTauPass_value

    cdef TBranch* muTauPrescale_branch
    cdef float muTauPrescale_value

    cdef TBranch* muTauTestGroup_branch
    cdef float muTauTestGroup_value

    cdef TBranch* muTauTestPass_branch
    cdef float muTauTestPass_value

    cdef TBranch* muTauTestPrescale_branch
    cdef float muTauTestPrescale_value

    cdef TBranch* muTightCountZH_branch
    cdef float muTightCountZH_value

    cdef TBranch* muVetoPt15IsoIdVtx_branch
    cdef float muVetoPt15IsoIdVtx_value

    cdef TBranch* muVetoPt5_branch
    cdef float muVetoPt5_value

    cdef TBranch* muVetoPt5IsoIdVtx_branch
    cdef float muVetoPt5IsoIdVtx_value

    cdef TBranch* muVetoZH_branch
    cdef float muVetoZH_value

    cdef TBranch* mva_metEt_branch
    cdef float mva_metEt_value

    cdef TBranch* mva_metPhi_branch
    cdef float mva_metPhi_value

    cdef TBranch* nTruePU_branch
    cdef float nTruePU_value

    cdef TBranch* nvtx_branch
    cdef float nvtx_value

    cdef TBranch* pfMetEt_branch
    cdef float pfMetEt_value

    cdef TBranch* pfMetPhi_branch
    cdef float pfMetPhi_value

    cdef TBranch* pfMet_jes_Et_branch
    cdef float pfMet_jes_Et_value

    cdef TBranch* pfMet_jes_Phi_branch
    cdef float pfMet_jes_Phi_value

    cdef TBranch* pfMet_mes_Et_branch
    cdef float pfMet_mes_Et_value

    cdef TBranch* pfMet_mes_Phi_branch
    cdef float pfMet_mes_Phi_value

    cdef TBranch* pfMet_tes_Et_branch
    cdef float pfMet_tes_Et_value

    cdef TBranch* pfMet_tes_Phi_branch
    cdef float pfMet_tes_Phi_value

    cdef TBranch* pfMet_ues_Et_branch
    cdef float pfMet_ues_Et_value

    cdef TBranch* pfMet_ues_Phi_branch
    cdef float pfMet_ues_Phi_value

    cdef TBranch* processID_branch
    cdef float processID_value

    cdef TBranch* pvChi2_branch
    cdef float pvChi2_value

    cdef TBranch* pvDX_branch
    cdef float pvDX_value

    cdef TBranch* pvDY_branch
    cdef float pvDY_value

    cdef TBranch* pvDZ_branch
    cdef float pvDZ_value

    cdef TBranch* pvIsFake_branch
    cdef int pvIsFake_value

    cdef TBranch* pvIsValid_branch
    cdef int pvIsValid_value

    cdef TBranch* pvNormChi2_branch
    cdef float pvNormChi2_value

    cdef TBranch* pvX_branch
    cdef float pvX_value

    cdef TBranch* pvY_branch
    cdef float pvY_value

    cdef TBranch* pvZ_branch
    cdef float pvZ_value

    cdef TBranch* pvndof_branch
    cdef float pvndof_value

    cdef TBranch* recoilDaught_branch
    cdef float recoilDaught_value

    cdef TBranch* recoilWithMet_branch
    cdef float recoilWithMet_value

    cdef TBranch* rho_branch
    cdef float rho_value

    cdef TBranch* run_branch
    cdef int run_value

    cdef TBranch* singleEGroup_branch
    cdef float singleEGroup_value

    cdef TBranch* singleEPFMTGroup_branch
    cdef float singleEPFMTGroup_value

    cdef TBranch* singleEPFMTPass_branch
    cdef float singleEPFMTPass_value

    cdef TBranch* singleEPFMTPrescale_branch
    cdef float singleEPFMTPrescale_value

    cdef TBranch* singleEPass_branch
    cdef float singleEPass_value

    cdef TBranch* singleEPrescale_branch
    cdef float singleEPrescale_value

    cdef TBranch* singleMuGroup_branch
    cdef float singleMuGroup_value

    cdef TBranch* singleMuPass_branch
    cdef float singleMuPass_value

    cdef TBranch* singleMuPrescale_branch
    cdef float singleMuPrescale_value

    cdef TBranch* singlePhoGroup_branch
    cdef float singlePhoGroup_value

    cdef TBranch* singlePhoPass_branch
    cdef float singlePhoPass_value

    cdef TBranch* singlePhoPrescale_branch
    cdef float singlePhoPrescale_value

    cdef TBranch* t1AbsEta_branch
    cdef float t1AbsEta_value

    cdef TBranch* t1AntiElectronLoose_branch
    cdef float t1AntiElectronLoose_value

    cdef TBranch* t1AntiElectronMVA3Loose_branch
    cdef float t1AntiElectronMVA3Loose_value

    cdef TBranch* t1AntiElectronMVA3Medium_branch
    cdef float t1AntiElectronMVA3Medium_value

    cdef TBranch* t1AntiElectronMVA3Raw_branch
    cdef float t1AntiElectronMVA3Raw_value

    cdef TBranch* t1AntiElectronMVA3Tight_branch
    cdef float t1AntiElectronMVA3Tight_value

    cdef TBranch* t1AntiElectronMVA3VTight_branch
    cdef float t1AntiElectronMVA3VTight_value

    cdef TBranch* t1AntiElectronMedium_branch
    cdef float t1AntiElectronMedium_value

    cdef TBranch* t1AntiElectronTight_branch
    cdef float t1AntiElectronTight_value

    cdef TBranch* t1AntiMuonLoose_branch
    cdef float t1AntiMuonLoose_value

    cdef TBranch* t1AntiMuonLoose2_branch
    cdef float t1AntiMuonLoose2_value

    cdef TBranch* t1AntiMuonMedium_branch
    cdef float t1AntiMuonMedium_value

    cdef TBranch* t1AntiMuonMedium2_branch
    cdef float t1AntiMuonMedium2_value

    cdef TBranch* t1AntiMuonTight_branch
    cdef float t1AntiMuonTight_value

    cdef TBranch* t1AntiMuonTight2_branch
    cdef float t1AntiMuonTight2_value

    cdef TBranch* t1Charge_branch
    cdef float t1Charge_value

    cdef TBranch* t1CiCTightElecOverlap_branch
    cdef float t1CiCTightElecOverlap_value

    cdef TBranch* t1DZ_branch
    cdef float t1DZ_value

    cdef TBranch* t1DecayFinding_branch
    cdef float t1DecayFinding_value

    cdef TBranch* t1DecayMode_branch
    cdef float t1DecayMode_value

    cdef TBranch* t1ElecOverlap_branch
    cdef float t1ElecOverlap_value

    cdef TBranch* t1ElecOverlapZHLoose_branch
    cdef float t1ElecOverlapZHLoose_value

    cdef TBranch* t1ElecOverlapZHTight_branch
    cdef float t1ElecOverlapZHTight_value

    cdef TBranch* t1Eta_branch
    cdef float t1Eta_value

    cdef TBranch* t1GenDecayMode_branch
    cdef float t1GenDecayMode_value

    cdef TBranch* t1IP3DS_branch
    cdef float t1IP3DS_value

    cdef TBranch* t1JetArea_branch
    cdef float t1JetArea_value

    cdef TBranch* t1JetBtag_branch
    cdef float t1JetBtag_value

    cdef TBranch* t1JetCSVBtag_branch
    cdef float t1JetCSVBtag_value

    cdef TBranch* t1JetEtaEtaMoment_branch
    cdef float t1JetEtaEtaMoment_value

    cdef TBranch* t1JetEtaPhiMoment_branch
    cdef float t1JetEtaPhiMoment_value

    cdef TBranch* t1JetEtaPhiSpread_branch
    cdef float t1JetEtaPhiSpread_value

    cdef TBranch* t1JetPartonFlavour_branch
    cdef float t1JetPartonFlavour_value

    cdef TBranch* t1JetPhiPhiMoment_branch
    cdef float t1JetPhiPhiMoment_value

    cdef TBranch* t1JetPt_branch
    cdef float t1JetPt_value

    cdef TBranch* t1JetQGLikelihoodID_branch
    cdef float t1JetQGLikelihoodID_value

    cdef TBranch* t1JetQGMVAID_branch
    cdef float t1JetQGMVAID_value

    cdef TBranch* t1Jetaxis1_branch
    cdef float t1Jetaxis1_value

    cdef TBranch* t1Jetaxis2_branch
    cdef float t1Jetaxis2_value

    cdef TBranch* t1Jetmult_branch
    cdef float t1Jetmult_value

    cdef TBranch* t1JetmultMLP_branch
    cdef float t1JetmultMLP_value

    cdef TBranch* t1JetmultMLPQC_branch
    cdef float t1JetmultMLPQC_value

    cdef TBranch* t1JetptD_branch
    cdef float t1JetptD_value

    cdef TBranch* t1LeadTrackPt_branch
    cdef float t1LeadTrackPt_value

    cdef TBranch* t1LooseIso_branch
    cdef float t1LooseIso_value

    cdef TBranch* t1LooseIso3Hits_branch
    cdef float t1LooseIso3Hits_value

    cdef TBranch* t1LooseMVA2Iso_branch
    cdef float t1LooseMVA2Iso_value

    cdef TBranch* t1LooseMVAIso_branch
    cdef float t1LooseMVAIso_value

    cdef TBranch* t1MVA2IsoRaw_branch
    cdef float t1MVA2IsoRaw_value

    cdef TBranch* t1Mass_branch
    cdef float t1Mass_value

    cdef TBranch* t1MediumIso_branch
    cdef float t1MediumIso_value

    cdef TBranch* t1MediumIso3Hits_branch
    cdef float t1MediumIso3Hits_value

    cdef TBranch* t1MediumMVA2Iso_branch
    cdef float t1MediumMVA2Iso_value

    cdef TBranch* t1MediumMVAIso_branch
    cdef float t1MediumMVAIso_value

    cdef TBranch* t1MtToMET_branch
    cdef float t1MtToMET_value

    cdef TBranch* t1MtToMVAMET_branch
    cdef float t1MtToMVAMET_value

    cdef TBranch* t1MtToPFMET_branch
    cdef float t1MtToPFMET_value

    cdef TBranch* t1MtToPfMet_Ty1_branch
    cdef float t1MtToPfMet_Ty1_value

    cdef TBranch* t1MtToPfMet_jes_branch
    cdef float t1MtToPfMet_jes_value

    cdef TBranch* t1MtToPfMet_mes_branch
    cdef float t1MtToPfMet_mes_value

    cdef TBranch* t1MtToPfMet_tes_branch
    cdef float t1MtToPfMet_tes_value

    cdef TBranch* t1MtToPfMet_ues_branch
    cdef float t1MtToPfMet_ues_value

    cdef TBranch* t1MuOverlap_branch
    cdef float t1MuOverlap_value

    cdef TBranch* t1MuOverlapZHLoose_branch
    cdef float t1MuOverlapZHLoose_value

    cdef TBranch* t1MuOverlapZHTight_branch
    cdef float t1MuOverlapZHTight_value

    cdef TBranch* t1Phi_branch
    cdef float t1Phi_value

    cdef TBranch* t1Pt_branch
    cdef float t1Pt_value

    cdef TBranch* t1Rank_branch
    cdef float t1Rank_value

    cdef TBranch* t1TNPId_branch
    cdef float t1TNPId_value

    cdef TBranch* t1TightIso_branch
    cdef float t1TightIso_value

    cdef TBranch* t1TightIso3Hits_branch
    cdef float t1TightIso3Hits_value

    cdef TBranch* t1TightMVA2Iso_branch
    cdef float t1TightMVA2Iso_value

    cdef TBranch* t1TightMVAIso_branch
    cdef float t1TightMVAIso_value

    cdef TBranch* t1ToMETDPhi_branch
    cdef float t1ToMETDPhi_value

    cdef TBranch* t1VLooseIso_branch
    cdef float t1VLooseIso_value

    cdef TBranch* t1VZ_branch
    cdef float t1VZ_value

    cdef TBranch* t1_t2_CosThetaStar_branch
    cdef float t1_t2_CosThetaStar_value

    cdef TBranch* t1_t2_DPhi_branch
    cdef float t1_t2_DPhi_value

    cdef TBranch* t1_t2_DR_branch
    cdef float t1_t2_DR_value

    cdef TBranch* t1_t2_Eta_branch
    cdef float t1_t2_Eta_value

    cdef TBranch* t1_t2_Mass_branch
    cdef float t1_t2_Mass_value

    cdef TBranch* t1_t2_MassFsr_branch
    cdef float t1_t2_MassFsr_value

    cdef TBranch* t1_t2_PZeta_branch
    cdef float t1_t2_PZeta_value

    cdef TBranch* t1_t2_PZetaVis_branch
    cdef float t1_t2_PZetaVis_value

    cdef TBranch* t1_t2_Phi_branch
    cdef float t1_t2_Phi_value

    cdef TBranch* t1_t2_Pt_branch
    cdef float t1_t2_Pt_value

    cdef TBranch* t1_t2_PtFsr_branch
    cdef float t1_t2_PtFsr_value

    cdef TBranch* t1_t2_SS_branch
    cdef float t1_t2_SS_value

    cdef TBranch* t1_t2_SVfitEta_branch
    cdef float t1_t2_SVfitEta_value

    cdef TBranch* t1_t2_SVfitMass_branch
    cdef float t1_t2_SVfitMass_value

    cdef TBranch* t1_t2_SVfitPhi_branch
    cdef float t1_t2_SVfitPhi_value

    cdef TBranch* t1_t2_SVfitPt_branch
    cdef float t1_t2_SVfitPt_value

    cdef TBranch* t1_t2_ToMETDPhi_Ty1_branch
    cdef float t1_t2_ToMETDPhi_Ty1_value

    cdef TBranch* t1_t2_Zcompat_branch
    cdef float t1_t2_Zcompat_value

    cdef TBranch* t2AbsEta_branch
    cdef float t2AbsEta_value

    cdef TBranch* t2AntiElectronLoose_branch
    cdef float t2AntiElectronLoose_value

    cdef TBranch* t2AntiElectronMVA3Loose_branch
    cdef float t2AntiElectronMVA3Loose_value

    cdef TBranch* t2AntiElectronMVA3Medium_branch
    cdef float t2AntiElectronMVA3Medium_value

    cdef TBranch* t2AntiElectronMVA3Raw_branch
    cdef float t2AntiElectronMVA3Raw_value

    cdef TBranch* t2AntiElectronMVA3Tight_branch
    cdef float t2AntiElectronMVA3Tight_value

    cdef TBranch* t2AntiElectronMVA3VTight_branch
    cdef float t2AntiElectronMVA3VTight_value

    cdef TBranch* t2AntiElectronMedium_branch
    cdef float t2AntiElectronMedium_value

    cdef TBranch* t2AntiElectronTight_branch
    cdef float t2AntiElectronTight_value

    cdef TBranch* t2AntiMuonLoose_branch
    cdef float t2AntiMuonLoose_value

    cdef TBranch* t2AntiMuonLoose2_branch
    cdef float t2AntiMuonLoose2_value

    cdef TBranch* t2AntiMuonMedium_branch
    cdef float t2AntiMuonMedium_value

    cdef TBranch* t2AntiMuonMedium2_branch
    cdef float t2AntiMuonMedium2_value

    cdef TBranch* t2AntiMuonTight_branch
    cdef float t2AntiMuonTight_value

    cdef TBranch* t2AntiMuonTight2_branch
    cdef float t2AntiMuonTight2_value

    cdef TBranch* t2Charge_branch
    cdef float t2Charge_value

    cdef TBranch* t2CiCTightElecOverlap_branch
    cdef float t2CiCTightElecOverlap_value

    cdef TBranch* t2DZ_branch
    cdef float t2DZ_value

    cdef TBranch* t2DecayFinding_branch
    cdef float t2DecayFinding_value

    cdef TBranch* t2DecayMode_branch
    cdef float t2DecayMode_value

    cdef TBranch* t2ElecOverlap_branch
    cdef float t2ElecOverlap_value

    cdef TBranch* t2ElecOverlapZHLoose_branch
    cdef float t2ElecOverlapZHLoose_value

    cdef TBranch* t2ElecOverlapZHTight_branch
    cdef float t2ElecOverlapZHTight_value

    cdef TBranch* t2Eta_branch
    cdef float t2Eta_value

    cdef TBranch* t2GenDecayMode_branch
    cdef float t2GenDecayMode_value

    cdef TBranch* t2IP3DS_branch
    cdef float t2IP3DS_value

    cdef TBranch* t2JetArea_branch
    cdef float t2JetArea_value

    cdef TBranch* t2JetBtag_branch
    cdef float t2JetBtag_value

    cdef TBranch* t2JetCSVBtag_branch
    cdef float t2JetCSVBtag_value

    cdef TBranch* t2JetEtaEtaMoment_branch
    cdef float t2JetEtaEtaMoment_value

    cdef TBranch* t2JetEtaPhiMoment_branch
    cdef float t2JetEtaPhiMoment_value

    cdef TBranch* t2JetEtaPhiSpread_branch
    cdef float t2JetEtaPhiSpread_value

    cdef TBranch* t2JetPartonFlavour_branch
    cdef float t2JetPartonFlavour_value

    cdef TBranch* t2JetPhiPhiMoment_branch
    cdef float t2JetPhiPhiMoment_value

    cdef TBranch* t2JetPt_branch
    cdef float t2JetPt_value

    cdef TBranch* t2JetQGLikelihoodID_branch
    cdef float t2JetQGLikelihoodID_value

    cdef TBranch* t2JetQGMVAID_branch
    cdef float t2JetQGMVAID_value

    cdef TBranch* t2Jetaxis1_branch
    cdef float t2Jetaxis1_value

    cdef TBranch* t2Jetaxis2_branch
    cdef float t2Jetaxis2_value

    cdef TBranch* t2Jetmult_branch
    cdef float t2Jetmult_value

    cdef TBranch* t2JetmultMLP_branch
    cdef float t2JetmultMLP_value

    cdef TBranch* t2JetmultMLPQC_branch
    cdef float t2JetmultMLPQC_value

    cdef TBranch* t2JetptD_branch
    cdef float t2JetptD_value

    cdef TBranch* t2LeadTrackPt_branch
    cdef float t2LeadTrackPt_value

    cdef TBranch* t2LooseIso_branch
    cdef float t2LooseIso_value

    cdef TBranch* t2LooseIso3Hits_branch
    cdef float t2LooseIso3Hits_value

    cdef TBranch* t2LooseMVA2Iso_branch
    cdef float t2LooseMVA2Iso_value

    cdef TBranch* t2LooseMVAIso_branch
    cdef float t2LooseMVAIso_value

    cdef TBranch* t2MVA2IsoRaw_branch
    cdef float t2MVA2IsoRaw_value

    cdef TBranch* t2Mass_branch
    cdef float t2Mass_value

    cdef TBranch* t2MediumIso_branch
    cdef float t2MediumIso_value

    cdef TBranch* t2MediumIso3Hits_branch
    cdef float t2MediumIso3Hits_value

    cdef TBranch* t2MediumMVA2Iso_branch
    cdef float t2MediumMVA2Iso_value

    cdef TBranch* t2MediumMVAIso_branch
    cdef float t2MediumMVAIso_value

    cdef TBranch* t2MtToMET_branch
    cdef float t2MtToMET_value

    cdef TBranch* t2MtToMVAMET_branch
    cdef float t2MtToMVAMET_value

    cdef TBranch* t2MtToPFMET_branch
    cdef float t2MtToPFMET_value

    cdef TBranch* t2MtToPfMet_Ty1_branch
    cdef float t2MtToPfMet_Ty1_value

    cdef TBranch* t2MtToPfMet_jes_branch
    cdef float t2MtToPfMet_jes_value

    cdef TBranch* t2MtToPfMet_mes_branch
    cdef float t2MtToPfMet_mes_value

    cdef TBranch* t2MtToPfMet_tes_branch
    cdef float t2MtToPfMet_tes_value

    cdef TBranch* t2MtToPfMet_ues_branch
    cdef float t2MtToPfMet_ues_value

    cdef TBranch* t2MuOverlap_branch
    cdef float t2MuOverlap_value

    cdef TBranch* t2MuOverlapZHLoose_branch
    cdef float t2MuOverlapZHLoose_value

    cdef TBranch* t2MuOverlapZHTight_branch
    cdef float t2MuOverlapZHTight_value

    cdef TBranch* t2Phi_branch
    cdef float t2Phi_value

    cdef TBranch* t2Pt_branch
    cdef float t2Pt_value

    cdef TBranch* t2Rank_branch
    cdef float t2Rank_value

    cdef TBranch* t2TNPId_branch
    cdef float t2TNPId_value

    cdef TBranch* t2TightIso_branch
    cdef float t2TightIso_value

    cdef TBranch* t2TightIso3Hits_branch
    cdef float t2TightIso3Hits_value

    cdef TBranch* t2TightMVA2Iso_branch
    cdef float t2TightMVA2Iso_value

    cdef TBranch* t2TightMVAIso_branch
    cdef float t2TightMVAIso_value

    cdef TBranch* t2ToMETDPhi_branch
    cdef float t2ToMETDPhi_value

    cdef TBranch* t2VLooseIso_branch
    cdef float t2VLooseIso_value

    cdef TBranch* t2VZ_branch
    cdef float t2VZ_value

    cdef TBranch* tauHpsVetoPt20_branch
    cdef float tauHpsVetoPt20_value

    cdef TBranch* tauTightCountZH_branch
    cdef float tauTightCountZH_value

    cdef TBranch* tauVetoPt20_branch
    cdef float tauVetoPt20_value

    cdef TBranch* tauVetoPt20Loose3HitsVtx_branch
    cdef float tauVetoPt20Loose3HitsVtx_value

    cdef TBranch* tauVetoPt20LooseMVA2Vtx_branch
    cdef float tauVetoPt20LooseMVA2Vtx_value

    cdef TBranch* tauVetoPt20LooseMVAVtx_branch
    cdef float tauVetoPt20LooseMVAVtx_value

    cdef TBranch* tauVetoPt20VLooseHPSVtx_branch
    cdef float tauVetoPt20VLooseHPSVtx_value

    cdef TBranch* tauVetoZH_branch
    cdef float tauVetoZH_value

    cdef TBranch* type1_pfMetEt_branch
    cdef float type1_pfMetEt_value

    cdef TBranch* type1_pfMetPhi_branch
    cdef float type1_pfMetPhi_value

    cdef TBranch* idx_branch
    cdef int idx_value


    def __cinit__(self, ttree):
        #print "cinit"
        # Constructor from a ROOT.TTree
        from ROOT import AsCObject
        self.tree = <TTree*>PyCObject_AsVoidPtr(AsCObject(ttree))
        self.ientry = 0
        self.currentTreeNumber = -1
        #print self.tree.GetEntries()
        #self.load_entry(0)
        self.complained = set([])

    cdef load_entry(self, long i):
        #print "load", i
        # Load the correct tree and setup the branches
        self.localentry = self.tree.LoadTree(i)
        #print "local", self.localentry
        new_tree = self.tree.GetTree()
        #print "tree", <long>(new_tree)
        treenum = self.tree.GetTreeNumber()
        #print "num", treenum
        if treenum != self.currentTreeNumber or new_tree != self.currentTree:
            #print "New tree!"
            self.currentTree = new_tree
            self.currentTreeNumber = treenum
            self.setup_branches(new_tree)

    cdef setup_branches(self, TTree* the_tree):
        #print "setup"

        #print "making EmbPtWeight"
        self.EmbPtWeight_branch = the_tree.GetBranch("EmbPtWeight")
        #if not self.EmbPtWeight_branch and "EmbPtWeight" not in self.complained:
        if not self.EmbPtWeight_branch and "EmbPtWeight":
            warnings.warn( "MuMuTauTauTree: Expected branch EmbPtWeight does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("EmbPtWeight")
        else:
            self.EmbPtWeight_branch.SetAddress(<void*>&self.EmbPtWeight_value)

        #print "making LT"
        self.LT_branch = the_tree.GetBranch("LT")
        #if not self.LT_branch and "LT" not in self.complained:
        if not self.LT_branch and "LT":
            warnings.warn( "MuMuTauTauTree: Expected branch LT does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("LT")
        else:
            self.LT_branch.SetAddress(<void*>&self.LT_value)

        #print "making Mass"
        self.Mass_branch = the_tree.GetBranch("Mass")
        #if not self.Mass_branch and "Mass" not in self.complained:
        if not self.Mass_branch and "Mass":
            warnings.warn( "MuMuTauTauTree: Expected branch Mass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Mass")
        else:
            self.Mass_branch.SetAddress(<void*>&self.Mass_value)

        #print "making MassError"
        self.MassError_branch = the_tree.GetBranch("MassError")
        #if not self.MassError_branch and "MassError" not in self.complained:
        if not self.MassError_branch and "MassError":
            warnings.warn( "MuMuTauTauTree: Expected branch MassError does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("MassError")
        else:
            self.MassError_branch.SetAddress(<void*>&self.MassError_value)

        #print "making MassErrord1"
        self.MassErrord1_branch = the_tree.GetBranch("MassErrord1")
        #if not self.MassErrord1_branch and "MassErrord1" not in self.complained:
        if not self.MassErrord1_branch and "MassErrord1":
            warnings.warn( "MuMuTauTauTree: Expected branch MassErrord1 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("MassErrord1")
        else:
            self.MassErrord1_branch.SetAddress(<void*>&self.MassErrord1_value)

        #print "making MassErrord2"
        self.MassErrord2_branch = the_tree.GetBranch("MassErrord2")
        #if not self.MassErrord2_branch and "MassErrord2" not in self.complained:
        if not self.MassErrord2_branch and "MassErrord2":
            warnings.warn( "MuMuTauTauTree: Expected branch MassErrord2 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("MassErrord2")
        else:
            self.MassErrord2_branch.SetAddress(<void*>&self.MassErrord2_value)

        #print "making MassErrord3"
        self.MassErrord3_branch = the_tree.GetBranch("MassErrord3")
        #if not self.MassErrord3_branch and "MassErrord3" not in self.complained:
        if not self.MassErrord3_branch and "MassErrord3":
            warnings.warn( "MuMuTauTauTree: Expected branch MassErrord3 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("MassErrord3")
        else:
            self.MassErrord3_branch.SetAddress(<void*>&self.MassErrord3_value)

        #print "making MassErrord4"
        self.MassErrord4_branch = the_tree.GetBranch("MassErrord4")
        #if not self.MassErrord4_branch and "MassErrord4" not in self.complained:
        if not self.MassErrord4_branch and "MassErrord4":
            warnings.warn( "MuMuTauTauTree: Expected branch MassErrord4 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("MassErrord4")
        else:
            self.MassErrord4_branch.SetAddress(<void*>&self.MassErrord4_value)

        #print "making NUP"
        self.NUP_branch = the_tree.GetBranch("NUP")
        #if not self.NUP_branch and "NUP" not in self.complained:
        if not self.NUP_branch and "NUP":
            warnings.warn( "MuMuTauTauTree: Expected branch NUP does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("NUP")
        else:
            self.NUP_branch.SetAddress(<void*>&self.NUP_value)

        #print "making Pt"
        self.Pt_branch = the_tree.GetBranch("Pt")
        #if not self.Pt_branch and "Pt" not in self.complained:
        if not self.Pt_branch and "Pt":
            warnings.warn( "MuMuTauTauTree: Expected branch Pt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Pt")
        else:
            self.Pt_branch.SetAddress(<void*>&self.Pt_value)

        #print "making bjetCSVVeto"
        self.bjetCSVVeto_branch = the_tree.GetBranch("bjetCSVVeto")
        #if not self.bjetCSVVeto_branch and "bjetCSVVeto" not in self.complained:
        if not self.bjetCSVVeto_branch and "bjetCSVVeto":
            warnings.warn( "MuMuTauTauTree: Expected branch bjetCSVVeto does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("bjetCSVVeto")
        else:
            self.bjetCSVVeto_branch.SetAddress(<void*>&self.bjetCSVVeto_value)

        #print "making bjetCSVVeto30"
        self.bjetCSVVeto30_branch = the_tree.GetBranch("bjetCSVVeto30")
        #if not self.bjetCSVVeto30_branch and "bjetCSVVeto30" not in self.complained:
        if not self.bjetCSVVeto30_branch and "bjetCSVVeto30":
            warnings.warn( "MuMuTauTauTree: Expected branch bjetCSVVeto30 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("bjetCSVVeto30")
        else:
            self.bjetCSVVeto30_branch.SetAddress(<void*>&self.bjetCSVVeto30_value)

        #print "making bjetCSVVetoZHLike"
        self.bjetCSVVetoZHLike_branch = the_tree.GetBranch("bjetCSVVetoZHLike")
        #if not self.bjetCSVVetoZHLike_branch and "bjetCSVVetoZHLike" not in self.complained:
        if not self.bjetCSVVetoZHLike_branch and "bjetCSVVetoZHLike":
            warnings.warn( "MuMuTauTauTree: Expected branch bjetCSVVetoZHLike does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("bjetCSVVetoZHLike")
        else:
            self.bjetCSVVetoZHLike_branch.SetAddress(<void*>&self.bjetCSVVetoZHLike_value)

        #print "making bjetCSVVetoZHLikeNoJetId"
        self.bjetCSVVetoZHLikeNoJetId_branch = the_tree.GetBranch("bjetCSVVetoZHLikeNoJetId")
        #if not self.bjetCSVVetoZHLikeNoJetId_branch and "bjetCSVVetoZHLikeNoJetId" not in self.complained:
        if not self.bjetCSVVetoZHLikeNoJetId_branch and "bjetCSVVetoZHLikeNoJetId":
            warnings.warn( "MuMuTauTauTree: Expected branch bjetCSVVetoZHLikeNoJetId does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("bjetCSVVetoZHLikeNoJetId")
        else:
            self.bjetCSVVetoZHLikeNoJetId_branch.SetAddress(<void*>&self.bjetCSVVetoZHLikeNoJetId_value)

        #print "making bjetCSVVetoZHLikeNoJetId_2"
        self.bjetCSVVetoZHLikeNoJetId_2_branch = the_tree.GetBranch("bjetCSVVetoZHLikeNoJetId_2")
        #if not self.bjetCSVVetoZHLikeNoJetId_2_branch and "bjetCSVVetoZHLikeNoJetId_2" not in self.complained:
        if not self.bjetCSVVetoZHLikeNoJetId_2_branch and "bjetCSVVetoZHLikeNoJetId_2":
            warnings.warn( "MuMuTauTauTree: Expected branch bjetCSVVetoZHLikeNoJetId_2 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("bjetCSVVetoZHLikeNoJetId_2")
        else:
            self.bjetCSVVetoZHLikeNoJetId_2_branch.SetAddress(<void*>&self.bjetCSVVetoZHLikeNoJetId_2_value)

        #print "making bjetTightCountZH"
        self.bjetTightCountZH_branch = the_tree.GetBranch("bjetTightCountZH")
        #if not self.bjetTightCountZH_branch and "bjetTightCountZH" not in self.complained:
        if not self.bjetTightCountZH_branch and "bjetTightCountZH":
            warnings.warn( "MuMuTauTauTree: Expected branch bjetTightCountZH does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("bjetTightCountZH")
        else:
            self.bjetTightCountZH_branch.SetAddress(<void*>&self.bjetTightCountZH_value)

        #print "making bjetVeto"
        self.bjetVeto_branch = the_tree.GetBranch("bjetVeto")
        #if not self.bjetVeto_branch and "bjetVeto" not in self.complained:
        if not self.bjetVeto_branch and "bjetVeto":
            warnings.warn( "MuMuTauTauTree: Expected branch bjetVeto does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("bjetVeto")
        else:
            self.bjetVeto_branch.SetAddress(<void*>&self.bjetVeto_value)

        #print "making charge"
        self.charge_branch = the_tree.GetBranch("charge")
        #if not self.charge_branch and "charge" not in self.complained:
        if not self.charge_branch and "charge":
            warnings.warn( "MuMuTauTauTree: Expected branch charge does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("charge")
        else:
            self.charge_branch.SetAddress(<void*>&self.charge_value)

        #print "making doubleEExtraGroup"
        self.doubleEExtraGroup_branch = the_tree.GetBranch("doubleEExtraGroup")
        #if not self.doubleEExtraGroup_branch and "doubleEExtraGroup" not in self.complained:
        if not self.doubleEExtraGroup_branch and "doubleEExtraGroup":
            warnings.warn( "MuMuTauTauTree: Expected branch doubleEExtraGroup does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleEExtraGroup")
        else:
            self.doubleEExtraGroup_branch.SetAddress(<void*>&self.doubleEExtraGroup_value)

        #print "making doubleEExtraPass"
        self.doubleEExtraPass_branch = the_tree.GetBranch("doubleEExtraPass")
        #if not self.doubleEExtraPass_branch and "doubleEExtraPass" not in self.complained:
        if not self.doubleEExtraPass_branch and "doubleEExtraPass":
            warnings.warn( "MuMuTauTauTree: Expected branch doubleEExtraPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleEExtraPass")
        else:
            self.doubleEExtraPass_branch.SetAddress(<void*>&self.doubleEExtraPass_value)

        #print "making doubleEExtraPrescale"
        self.doubleEExtraPrescale_branch = the_tree.GetBranch("doubleEExtraPrescale")
        #if not self.doubleEExtraPrescale_branch and "doubleEExtraPrescale" not in self.complained:
        if not self.doubleEExtraPrescale_branch and "doubleEExtraPrescale":
            warnings.warn( "MuMuTauTauTree: Expected branch doubleEExtraPrescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleEExtraPrescale")
        else:
            self.doubleEExtraPrescale_branch.SetAddress(<void*>&self.doubleEExtraPrescale_value)

        #print "making doubleEGroup"
        self.doubleEGroup_branch = the_tree.GetBranch("doubleEGroup")
        #if not self.doubleEGroup_branch and "doubleEGroup" not in self.complained:
        if not self.doubleEGroup_branch and "doubleEGroup":
            warnings.warn( "MuMuTauTauTree: Expected branch doubleEGroup does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleEGroup")
        else:
            self.doubleEGroup_branch.SetAddress(<void*>&self.doubleEGroup_value)

        #print "making doubleEPass"
        self.doubleEPass_branch = the_tree.GetBranch("doubleEPass")
        #if not self.doubleEPass_branch and "doubleEPass" not in self.complained:
        if not self.doubleEPass_branch and "doubleEPass":
            warnings.warn( "MuMuTauTauTree: Expected branch doubleEPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleEPass")
        else:
            self.doubleEPass_branch.SetAddress(<void*>&self.doubleEPass_value)

        #print "making doubleEPrescale"
        self.doubleEPrescale_branch = the_tree.GetBranch("doubleEPrescale")
        #if not self.doubleEPrescale_branch and "doubleEPrescale" not in self.complained:
        if not self.doubleEPrescale_branch and "doubleEPrescale":
            warnings.warn( "MuMuTauTauTree: Expected branch doubleEPrescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleEPrescale")
        else:
            self.doubleEPrescale_branch.SetAddress(<void*>&self.doubleEPrescale_value)

        #print "making doubleETightGroup"
        self.doubleETightGroup_branch = the_tree.GetBranch("doubleETightGroup")
        #if not self.doubleETightGroup_branch and "doubleETightGroup" not in self.complained:
        if not self.doubleETightGroup_branch and "doubleETightGroup":
            warnings.warn( "MuMuTauTauTree: Expected branch doubleETightGroup does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleETightGroup")
        else:
            self.doubleETightGroup_branch.SetAddress(<void*>&self.doubleETightGroup_value)

        #print "making doubleETightPass"
        self.doubleETightPass_branch = the_tree.GetBranch("doubleETightPass")
        #if not self.doubleETightPass_branch and "doubleETightPass" not in self.complained:
        if not self.doubleETightPass_branch and "doubleETightPass":
            warnings.warn( "MuMuTauTauTree: Expected branch doubleETightPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleETightPass")
        else:
            self.doubleETightPass_branch.SetAddress(<void*>&self.doubleETightPass_value)

        #print "making doubleETightPrescale"
        self.doubleETightPrescale_branch = the_tree.GetBranch("doubleETightPrescale")
        #if not self.doubleETightPrescale_branch and "doubleETightPrescale" not in self.complained:
        if not self.doubleETightPrescale_branch and "doubleETightPrescale":
            warnings.warn( "MuMuTauTauTree: Expected branch doubleETightPrescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleETightPrescale")
        else:
            self.doubleETightPrescale_branch.SetAddress(<void*>&self.doubleETightPrescale_value)

        #print "making doubleMuGroup"
        self.doubleMuGroup_branch = the_tree.GetBranch("doubleMuGroup")
        #if not self.doubleMuGroup_branch and "doubleMuGroup" not in self.complained:
        if not self.doubleMuGroup_branch and "doubleMuGroup":
            warnings.warn( "MuMuTauTauTree: Expected branch doubleMuGroup does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleMuGroup")
        else:
            self.doubleMuGroup_branch.SetAddress(<void*>&self.doubleMuGroup_value)

        #print "making doubleMuPass"
        self.doubleMuPass_branch = the_tree.GetBranch("doubleMuPass")
        #if not self.doubleMuPass_branch and "doubleMuPass" not in self.complained:
        if not self.doubleMuPass_branch and "doubleMuPass":
            warnings.warn( "MuMuTauTauTree: Expected branch doubleMuPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleMuPass")
        else:
            self.doubleMuPass_branch.SetAddress(<void*>&self.doubleMuPass_value)

        #print "making doubleMuPrescale"
        self.doubleMuPrescale_branch = the_tree.GetBranch("doubleMuPrescale")
        #if not self.doubleMuPrescale_branch and "doubleMuPrescale" not in self.complained:
        if not self.doubleMuPrescale_branch and "doubleMuPrescale":
            warnings.warn( "MuMuTauTauTree: Expected branch doubleMuPrescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleMuPrescale")
        else:
            self.doubleMuPrescale_branch.SetAddress(<void*>&self.doubleMuPrescale_value)

        #print "making doubleMuTrkGroup"
        self.doubleMuTrkGroup_branch = the_tree.GetBranch("doubleMuTrkGroup")
        #if not self.doubleMuTrkGroup_branch and "doubleMuTrkGroup" not in self.complained:
        if not self.doubleMuTrkGroup_branch and "doubleMuTrkGroup":
            warnings.warn( "MuMuTauTauTree: Expected branch doubleMuTrkGroup does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleMuTrkGroup")
        else:
            self.doubleMuTrkGroup_branch.SetAddress(<void*>&self.doubleMuTrkGroup_value)

        #print "making doubleMuTrkPass"
        self.doubleMuTrkPass_branch = the_tree.GetBranch("doubleMuTrkPass")
        #if not self.doubleMuTrkPass_branch and "doubleMuTrkPass" not in self.complained:
        if not self.doubleMuTrkPass_branch and "doubleMuTrkPass":
            warnings.warn( "MuMuTauTauTree: Expected branch doubleMuTrkPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleMuTrkPass")
        else:
            self.doubleMuTrkPass_branch.SetAddress(<void*>&self.doubleMuTrkPass_value)

        #print "making doubleMuTrkPrescale"
        self.doubleMuTrkPrescale_branch = the_tree.GetBranch("doubleMuTrkPrescale")
        #if not self.doubleMuTrkPrescale_branch and "doubleMuTrkPrescale" not in self.complained:
        if not self.doubleMuTrkPrescale_branch and "doubleMuTrkPrescale":
            warnings.warn( "MuMuTauTauTree: Expected branch doubleMuTrkPrescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleMuTrkPrescale")
        else:
            self.doubleMuTrkPrescale_branch.SetAddress(<void*>&self.doubleMuTrkPrescale_value)

        #print "making doublePhoGroup"
        self.doublePhoGroup_branch = the_tree.GetBranch("doublePhoGroup")
        #if not self.doublePhoGroup_branch and "doublePhoGroup" not in self.complained:
        if not self.doublePhoGroup_branch and "doublePhoGroup":
            warnings.warn( "MuMuTauTauTree: Expected branch doublePhoGroup does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doublePhoGroup")
        else:
            self.doublePhoGroup_branch.SetAddress(<void*>&self.doublePhoGroup_value)

        #print "making doublePhoPass"
        self.doublePhoPass_branch = the_tree.GetBranch("doublePhoPass")
        #if not self.doublePhoPass_branch and "doublePhoPass" not in self.complained:
        if not self.doublePhoPass_branch and "doublePhoPass":
            warnings.warn( "MuMuTauTauTree: Expected branch doublePhoPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doublePhoPass")
        else:
            self.doublePhoPass_branch.SetAddress(<void*>&self.doublePhoPass_value)

        #print "making doublePhoPrescale"
        self.doublePhoPrescale_branch = the_tree.GetBranch("doublePhoPrescale")
        #if not self.doublePhoPrescale_branch and "doublePhoPrescale" not in self.complained:
        if not self.doublePhoPrescale_branch and "doublePhoPrescale":
            warnings.warn( "MuMuTauTauTree: Expected branch doublePhoPrescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doublePhoPrescale")
        else:
            self.doublePhoPrescale_branch.SetAddress(<void*>&self.doublePhoPrescale_value)

        #print "making eTightCountZH"
        self.eTightCountZH_branch = the_tree.GetBranch("eTightCountZH")
        #if not self.eTightCountZH_branch and "eTightCountZH" not in self.complained:
        if not self.eTightCountZH_branch and "eTightCountZH":
            warnings.warn( "MuMuTauTauTree: Expected branch eTightCountZH does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eTightCountZH")
        else:
            self.eTightCountZH_branch.SetAddress(<void*>&self.eTightCountZH_value)

        #print "making eVetoCicTightIso"
        self.eVetoCicTightIso_branch = the_tree.GetBranch("eVetoCicTightIso")
        #if not self.eVetoCicTightIso_branch and "eVetoCicTightIso" not in self.complained:
        if not self.eVetoCicTightIso_branch and "eVetoCicTightIso":
            warnings.warn( "MuMuTauTauTree: Expected branch eVetoCicTightIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eVetoCicTightIso")
        else:
            self.eVetoCicTightIso_branch.SetAddress(<void*>&self.eVetoCicTightIso_value)

        #print "making eVetoMVAIso"
        self.eVetoMVAIso_branch = the_tree.GetBranch("eVetoMVAIso")
        #if not self.eVetoMVAIso_branch and "eVetoMVAIso" not in self.complained:
        if not self.eVetoMVAIso_branch and "eVetoMVAIso":
            warnings.warn( "MuMuTauTauTree: Expected branch eVetoMVAIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eVetoMVAIso")
        else:
            self.eVetoMVAIso_branch.SetAddress(<void*>&self.eVetoMVAIso_value)

        #print "making eVetoMVAIsoVtx"
        self.eVetoMVAIsoVtx_branch = the_tree.GetBranch("eVetoMVAIsoVtx")
        #if not self.eVetoMVAIsoVtx_branch and "eVetoMVAIsoVtx" not in self.complained:
        if not self.eVetoMVAIsoVtx_branch and "eVetoMVAIsoVtx":
            warnings.warn( "MuMuTauTauTree: Expected branch eVetoMVAIsoVtx does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eVetoMVAIsoVtx")
        else:
            self.eVetoMVAIsoVtx_branch.SetAddress(<void*>&self.eVetoMVAIsoVtx_value)

        #print "making eVetoZH"
        self.eVetoZH_branch = the_tree.GetBranch("eVetoZH")
        #if not self.eVetoZH_branch and "eVetoZH" not in self.complained:
        if not self.eVetoZH_branch and "eVetoZH":
            warnings.warn( "MuMuTauTauTree: Expected branch eVetoZH does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eVetoZH")
        else:
            self.eVetoZH_branch.SetAddress(<void*>&self.eVetoZH_value)

        #print "making eVetoZH_smallDR"
        self.eVetoZH_smallDR_branch = the_tree.GetBranch("eVetoZH_smallDR")
        #if not self.eVetoZH_smallDR_branch and "eVetoZH_smallDR" not in self.complained:
        if not self.eVetoZH_smallDR_branch and "eVetoZH_smallDR":
            warnings.warn( "MuMuTauTauTree: Expected branch eVetoZH_smallDR does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eVetoZH_smallDR")
        else:
            self.eVetoZH_smallDR_branch.SetAddress(<void*>&self.eVetoZH_smallDR_value)

        #print "making evt"
        self.evt_branch = the_tree.GetBranch("evt")
        #if not self.evt_branch and "evt" not in self.complained:
        if not self.evt_branch and "evt":
            warnings.warn( "MuMuTauTauTree: Expected branch evt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("evt")
        else:
            self.evt_branch.SetAddress(<void*>&self.evt_value)

        #print "making isGtautau"
        self.isGtautau_branch = the_tree.GetBranch("isGtautau")
        #if not self.isGtautau_branch and "isGtautau" not in self.complained:
        if not self.isGtautau_branch and "isGtautau":
            warnings.warn( "MuMuTauTauTree: Expected branch isGtautau does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("isGtautau")
        else:
            self.isGtautau_branch.SetAddress(<void*>&self.isGtautau_value)

        #print "making isWmunu"
        self.isWmunu_branch = the_tree.GetBranch("isWmunu")
        #if not self.isWmunu_branch and "isWmunu" not in self.complained:
        if not self.isWmunu_branch and "isWmunu":
            warnings.warn( "MuMuTauTauTree: Expected branch isWmunu does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("isWmunu")
        else:
            self.isWmunu_branch.SetAddress(<void*>&self.isWmunu_value)

        #print "making isWtaunu"
        self.isWtaunu_branch = the_tree.GetBranch("isWtaunu")
        #if not self.isWtaunu_branch and "isWtaunu" not in self.complained:
        if not self.isWtaunu_branch and "isWtaunu":
            warnings.warn( "MuMuTauTauTree: Expected branch isWtaunu does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("isWtaunu")
        else:
            self.isWtaunu_branch.SetAddress(<void*>&self.isWtaunu_value)

        #print "making isZtautau"
        self.isZtautau_branch = the_tree.GetBranch("isZtautau")
        #if not self.isZtautau_branch and "isZtautau" not in self.complained:
        if not self.isZtautau_branch and "isZtautau":
            warnings.warn( "MuMuTauTauTree: Expected branch isZtautau does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("isZtautau")
        else:
            self.isZtautau_branch.SetAddress(<void*>&self.isZtautau_value)

        #print "making isdata"
        self.isdata_branch = the_tree.GetBranch("isdata")
        #if not self.isdata_branch and "isdata" not in self.complained:
        if not self.isdata_branch and "isdata":
            warnings.warn( "MuMuTauTauTree: Expected branch isdata does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("isdata")
        else:
            self.isdata_branch.SetAddress(<void*>&self.isdata_value)

        #print "making isoMu24eta2p1Group"
        self.isoMu24eta2p1Group_branch = the_tree.GetBranch("isoMu24eta2p1Group")
        #if not self.isoMu24eta2p1Group_branch and "isoMu24eta2p1Group" not in self.complained:
        if not self.isoMu24eta2p1Group_branch and "isoMu24eta2p1Group":
            warnings.warn( "MuMuTauTauTree: Expected branch isoMu24eta2p1Group does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("isoMu24eta2p1Group")
        else:
            self.isoMu24eta2p1Group_branch.SetAddress(<void*>&self.isoMu24eta2p1Group_value)

        #print "making isoMu24eta2p1Pass"
        self.isoMu24eta2p1Pass_branch = the_tree.GetBranch("isoMu24eta2p1Pass")
        #if not self.isoMu24eta2p1Pass_branch and "isoMu24eta2p1Pass" not in self.complained:
        if not self.isoMu24eta2p1Pass_branch and "isoMu24eta2p1Pass":
            warnings.warn( "MuMuTauTauTree: Expected branch isoMu24eta2p1Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("isoMu24eta2p1Pass")
        else:
            self.isoMu24eta2p1Pass_branch.SetAddress(<void*>&self.isoMu24eta2p1Pass_value)

        #print "making isoMu24eta2p1Prescale"
        self.isoMu24eta2p1Prescale_branch = the_tree.GetBranch("isoMu24eta2p1Prescale")
        #if not self.isoMu24eta2p1Prescale_branch and "isoMu24eta2p1Prescale" not in self.complained:
        if not self.isoMu24eta2p1Prescale_branch and "isoMu24eta2p1Prescale":
            warnings.warn( "MuMuTauTauTree: Expected branch isoMu24eta2p1Prescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("isoMu24eta2p1Prescale")
        else:
            self.isoMu24eta2p1Prescale_branch.SetAddress(<void*>&self.isoMu24eta2p1Prescale_value)

        #print "making isoMuGroup"
        self.isoMuGroup_branch = the_tree.GetBranch("isoMuGroup")
        #if not self.isoMuGroup_branch and "isoMuGroup" not in self.complained:
        if not self.isoMuGroup_branch and "isoMuGroup":
            warnings.warn( "MuMuTauTauTree: Expected branch isoMuGroup does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("isoMuGroup")
        else:
            self.isoMuGroup_branch.SetAddress(<void*>&self.isoMuGroup_value)

        #print "making isoMuPass"
        self.isoMuPass_branch = the_tree.GetBranch("isoMuPass")
        #if not self.isoMuPass_branch and "isoMuPass" not in self.complained:
        if not self.isoMuPass_branch and "isoMuPass":
            warnings.warn( "MuMuTauTauTree: Expected branch isoMuPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("isoMuPass")
        else:
            self.isoMuPass_branch.SetAddress(<void*>&self.isoMuPass_value)

        #print "making isoMuPrescale"
        self.isoMuPrescale_branch = the_tree.GetBranch("isoMuPrescale")
        #if not self.isoMuPrescale_branch and "isoMuPrescale" not in self.complained:
        if not self.isoMuPrescale_branch and "isoMuPrescale":
            warnings.warn( "MuMuTauTauTree: Expected branch isoMuPrescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("isoMuPrescale")
        else:
            self.isoMuPrescale_branch.SetAddress(<void*>&self.isoMuPrescale_value)

        #print "making isoMuTauGroup"
        self.isoMuTauGroup_branch = the_tree.GetBranch("isoMuTauGroup")
        #if not self.isoMuTauGroup_branch and "isoMuTauGroup" not in self.complained:
        if not self.isoMuTauGroup_branch and "isoMuTauGroup":
            warnings.warn( "MuMuTauTauTree: Expected branch isoMuTauGroup does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("isoMuTauGroup")
        else:
            self.isoMuTauGroup_branch.SetAddress(<void*>&self.isoMuTauGroup_value)

        #print "making isoMuTauPass"
        self.isoMuTauPass_branch = the_tree.GetBranch("isoMuTauPass")
        #if not self.isoMuTauPass_branch and "isoMuTauPass" not in self.complained:
        if not self.isoMuTauPass_branch and "isoMuTauPass":
            warnings.warn( "MuMuTauTauTree: Expected branch isoMuTauPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("isoMuTauPass")
        else:
            self.isoMuTauPass_branch.SetAddress(<void*>&self.isoMuTauPass_value)

        #print "making isoMuTauPrescale"
        self.isoMuTauPrescale_branch = the_tree.GetBranch("isoMuTauPrescale")
        #if not self.isoMuTauPrescale_branch and "isoMuTauPrescale" not in self.complained:
        if not self.isoMuTauPrescale_branch and "isoMuTauPrescale":
            warnings.warn( "MuMuTauTauTree: Expected branch isoMuTauPrescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("isoMuTauPrescale")
        else:
            self.isoMuTauPrescale_branch.SetAddress(<void*>&self.isoMuTauPrescale_value)

        #print "making jetVeto20"
        self.jetVeto20_branch = the_tree.GetBranch("jetVeto20")
        #if not self.jetVeto20_branch and "jetVeto20" not in self.complained:
        if not self.jetVeto20_branch and "jetVeto20":
            warnings.warn( "MuMuTauTauTree: Expected branch jetVeto20 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto20")
        else:
            self.jetVeto20_branch.SetAddress(<void*>&self.jetVeto20_value)

        #print "making jetVeto20_DR05"
        self.jetVeto20_DR05_branch = the_tree.GetBranch("jetVeto20_DR05")
        #if not self.jetVeto20_DR05_branch and "jetVeto20_DR05" not in self.complained:
        if not self.jetVeto20_DR05_branch and "jetVeto20_DR05":
            warnings.warn( "MuMuTauTauTree: Expected branch jetVeto20_DR05 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto20_DR05")
        else:
            self.jetVeto20_DR05_branch.SetAddress(<void*>&self.jetVeto20_DR05_value)

        #print "making jetVeto30"
        self.jetVeto30_branch = the_tree.GetBranch("jetVeto30")
        #if not self.jetVeto30_branch and "jetVeto30" not in self.complained:
        if not self.jetVeto30_branch and "jetVeto30":
            warnings.warn( "MuMuTauTauTree: Expected branch jetVeto30 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30")
        else:
            self.jetVeto30_branch.SetAddress(<void*>&self.jetVeto30_value)

        #print "making jetVeto30_DR05"
        self.jetVeto30_DR05_branch = the_tree.GetBranch("jetVeto30_DR05")
        #if not self.jetVeto30_DR05_branch and "jetVeto30_DR05" not in self.complained:
        if not self.jetVeto30_DR05_branch and "jetVeto30_DR05":
            warnings.warn( "MuMuTauTauTree: Expected branch jetVeto30_DR05 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_DR05")
        else:
            self.jetVeto30_DR05_branch.SetAddress(<void*>&self.jetVeto30_DR05_value)

        #print "making jetVeto40"
        self.jetVeto40_branch = the_tree.GetBranch("jetVeto40")
        #if not self.jetVeto40_branch and "jetVeto40" not in self.complained:
        if not self.jetVeto40_branch and "jetVeto40":
            warnings.warn( "MuMuTauTauTree: Expected branch jetVeto40 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto40")
        else:
            self.jetVeto40_branch.SetAddress(<void*>&self.jetVeto40_value)

        #print "making jetVeto40_DR05"
        self.jetVeto40_DR05_branch = the_tree.GetBranch("jetVeto40_DR05")
        #if not self.jetVeto40_DR05_branch and "jetVeto40_DR05" not in self.complained:
        if not self.jetVeto40_DR05_branch and "jetVeto40_DR05":
            warnings.warn( "MuMuTauTauTree: Expected branch jetVeto40_DR05 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto40_DR05")
        else:
            self.jetVeto40_DR05_branch.SetAddress(<void*>&self.jetVeto40_DR05_value)

        #print "making lumi"
        self.lumi_branch = the_tree.GetBranch("lumi")
        #if not self.lumi_branch and "lumi" not in self.complained:
        if not self.lumi_branch and "lumi":
            warnings.warn( "MuMuTauTauTree: Expected branch lumi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lumi")
        else:
            self.lumi_branch.SetAddress(<void*>&self.lumi_value)

        #print "making m1AbsEta"
        self.m1AbsEta_branch = the_tree.GetBranch("m1AbsEta")
        #if not self.m1AbsEta_branch and "m1AbsEta" not in self.complained:
        if not self.m1AbsEta_branch and "m1AbsEta":
            warnings.warn( "MuMuTauTauTree: Expected branch m1AbsEta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1AbsEta")
        else:
            self.m1AbsEta_branch.SetAddress(<void*>&self.m1AbsEta_value)

        #print "making m1Charge"
        self.m1Charge_branch = the_tree.GetBranch("m1Charge")
        #if not self.m1Charge_branch and "m1Charge" not in self.complained:
        if not self.m1Charge_branch and "m1Charge":
            warnings.warn( "MuMuTauTauTree: Expected branch m1Charge does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1Charge")
        else:
            self.m1Charge_branch.SetAddress(<void*>&self.m1Charge_value)

        #print "making m1ComesFromHiggs"
        self.m1ComesFromHiggs_branch = the_tree.GetBranch("m1ComesFromHiggs")
        #if not self.m1ComesFromHiggs_branch and "m1ComesFromHiggs" not in self.complained:
        if not self.m1ComesFromHiggs_branch and "m1ComesFromHiggs":
            warnings.warn( "MuMuTauTauTree: Expected branch m1ComesFromHiggs does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1ComesFromHiggs")
        else:
            self.m1ComesFromHiggs_branch.SetAddress(<void*>&self.m1ComesFromHiggs_value)

        #print "making m1D0"
        self.m1D0_branch = the_tree.GetBranch("m1D0")
        #if not self.m1D0_branch and "m1D0" not in self.complained:
        if not self.m1D0_branch and "m1D0":
            warnings.warn( "MuMuTauTauTree: Expected branch m1D0 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1D0")
        else:
            self.m1D0_branch.SetAddress(<void*>&self.m1D0_value)

        #print "making m1DZ"
        self.m1DZ_branch = the_tree.GetBranch("m1DZ")
        #if not self.m1DZ_branch and "m1DZ" not in self.complained:
        if not self.m1DZ_branch and "m1DZ":
            warnings.warn( "MuMuTauTauTree: Expected branch m1DZ does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1DZ")
        else:
            self.m1DZ_branch.SetAddress(<void*>&self.m1DZ_value)

        #print "making m1DiMuonL3PreFiltered7"
        self.m1DiMuonL3PreFiltered7_branch = the_tree.GetBranch("m1DiMuonL3PreFiltered7")
        #if not self.m1DiMuonL3PreFiltered7_branch and "m1DiMuonL3PreFiltered7" not in self.complained:
        if not self.m1DiMuonL3PreFiltered7_branch and "m1DiMuonL3PreFiltered7":
            warnings.warn( "MuMuTauTauTree: Expected branch m1DiMuonL3PreFiltered7 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1DiMuonL3PreFiltered7")
        else:
            self.m1DiMuonL3PreFiltered7_branch.SetAddress(<void*>&self.m1DiMuonL3PreFiltered7_value)

        #print "making m1DiMuonL3p5PreFiltered8"
        self.m1DiMuonL3p5PreFiltered8_branch = the_tree.GetBranch("m1DiMuonL3p5PreFiltered8")
        #if not self.m1DiMuonL3p5PreFiltered8_branch and "m1DiMuonL3p5PreFiltered8" not in self.complained:
        if not self.m1DiMuonL3p5PreFiltered8_branch and "m1DiMuonL3p5PreFiltered8":
            warnings.warn( "MuMuTauTauTree: Expected branch m1DiMuonL3p5PreFiltered8 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1DiMuonL3p5PreFiltered8")
        else:
            self.m1DiMuonL3p5PreFiltered8_branch.SetAddress(<void*>&self.m1DiMuonL3p5PreFiltered8_value)

        #print "making m1DiMuonMu17Mu8DzFiltered0p2"
        self.m1DiMuonMu17Mu8DzFiltered0p2_branch = the_tree.GetBranch("m1DiMuonMu17Mu8DzFiltered0p2")
        #if not self.m1DiMuonMu17Mu8DzFiltered0p2_branch and "m1DiMuonMu17Mu8DzFiltered0p2" not in self.complained:
        if not self.m1DiMuonMu17Mu8DzFiltered0p2_branch and "m1DiMuonMu17Mu8DzFiltered0p2":
            warnings.warn( "MuMuTauTauTree: Expected branch m1DiMuonMu17Mu8DzFiltered0p2 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1DiMuonMu17Mu8DzFiltered0p2")
        else:
            self.m1DiMuonMu17Mu8DzFiltered0p2_branch.SetAddress(<void*>&self.m1DiMuonMu17Mu8DzFiltered0p2_value)

        #print "making m1EErrRochCor2011A"
        self.m1EErrRochCor2011A_branch = the_tree.GetBranch("m1EErrRochCor2011A")
        #if not self.m1EErrRochCor2011A_branch and "m1EErrRochCor2011A" not in self.complained:
        if not self.m1EErrRochCor2011A_branch and "m1EErrRochCor2011A":
            warnings.warn( "MuMuTauTauTree: Expected branch m1EErrRochCor2011A does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1EErrRochCor2011A")
        else:
            self.m1EErrRochCor2011A_branch.SetAddress(<void*>&self.m1EErrRochCor2011A_value)

        #print "making m1EErrRochCor2011B"
        self.m1EErrRochCor2011B_branch = the_tree.GetBranch("m1EErrRochCor2011B")
        #if not self.m1EErrRochCor2011B_branch and "m1EErrRochCor2011B" not in self.complained:
        if not self.m1EErrRochCor2011B_branch and "m1EErrRochCor2011B":
            warnings.warn( "MuMuTauTauTree: Expected branch m1EErrRochCor2011B does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1EErrRochCor2011B")
        else:
            self.m1EErrRochCor2011B_branch.SetAddress(<void*>&self.m1EErrRochCor2011B_value)

        #print "making m1EErrRochCor2012"
        self.m1EErrRochCor2012_branch = the_tree.GetBranch("m1EErrRochCor2012")
        #if not self.m1EErrRochCor2012_branch and "m1EErrRochCor2012" not in self.complained:
        if not self.m1EErrRochCor2012_branch and "m1EErrRochCor2012":
            warnings.warn( "MuMuTauTauTree: Expected branch m1EErrRochCor2012 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1EErrRochCor2012")
        else:
            self.m1EErrRochCor2012_branch.SetAddress(<void*>&self.m1EErrRochCor2012_value)

        #print "making m1ERochCor2011A"
        self.m1ERochCor2011A_branch = the_tree.GetBranch("m1ERochCor2011A")
        #if not self.m1ERochCor2011A_branch and "m1ERochCor2011A" not in self.complained:
        if not self.m1ERochCor2011A_branch and "m1ERochCor2011A":
            warnings.warn( "MuMuTauTauTree: Expected branch m1ERochCor2011A does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1ERochCor2011A")
        else:
            self.m1ERochCor2011A_branch.SetAddress(<void*>&self.m1ERochCor2011A_value)

        #print "making m1ERochCor2011B"
        self.m1ERochCor2011B_branch = the_tree.GetBranch("m1ERochCor2011B")
        #if not self.m1ERochCor2011B_branch and "m1ERochCor2011B" not in self.complained:
        if not self.m1ERochCor2011B_branch and "m1ERochCor2011B":
            warnings.warn( "MuMuTauTauTree: Expected branch m1ERochCor2011B does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1ERochCor2011B")
        else:
            self.m1ERochCor2011B_branch.SetAddress(<void*>&self.m1ERochCor2011B_value)

        #print "making m1ERochCor2012"
        self.m1ERochCor2012_branch = the_tree.GetBranch("m1ERochCor2012")
        #if not self.m1ERochCor2012_branch and "m1ERochCor2012" not in self.complained:
        if not self.m1ERochCor2012_branch and "m1ERochCor2012":
            warnings.warn( "MuMuTauTauTree: Expected branch m1ERochCor2012 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1ERochCor2012")
        else:
            self.m1ERochCor2012_branch.SetAddress(<void*>&self.m1ERochCor2012_value)

        #print "making m1EffectiveArea2011"
        self.m1EffectiveArea2011_branch = the_tree.GetBranch("m1EffectiveArea2011")
        #if not self.m1EffectiveArea2011_branch and "m1EffectiveArea2011" not in self.complained:
        if not self.m1EffectiveArea2011_branch and "m1EffectiveArea2011":
            warnings.warn( "MuMuTauTauTree: Expected branch m1EffectiveArea2011 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1EffectiveArea2011")
        else:
            self.m1EffectiveArea2011_branch.SetAddress(<void*>&self.m1EffectiveArea2011_value)

        #print "making m1EffectiveArea2012"
        self.m1EffectiveArea2012_branch = the_tree.GetBranch("m1EffectiveArea2012")
        #if not self.m1EffectiveArea2012_branch and "m1EffectiveArea2012" not in self.complained:
        if not self.m1EffectiveArea2012_branch and "m1EffectiveArea2012":
            warnings.warn( "MuMuTauTauTree: Expected branch m1EffectiveArea2012 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1EffectiveArea2012")
        else:
            self.m1EffectiveArea2012_branch.SetAddress(<void*>&self.m1EffectiveArea2012_value)

        #print "making m1Eta"
        self.m1Eta_branch = the_tree.GetBranch("m1Eta")
        #if not self.m1Eta_branch and "m1Eta" not in self.complained:
        if not self.m1Eta_branch and "m1Eta":
            warnings.warn( "MuMuTauTauTree: Expected branch m1Eta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1Eta")
        else:
            self.m1Eta_branch.SetAddress(<void*>&self.m1Eta_value)

        #print "making m1EtaRochCor2011A"
        self.m1EtaRochCor2011A_branch = the_tree.GetBranch("m1EtaRochCor2011A")
        #if not self.m1EtaRochCor2011A_branch and "m1EtaRochCor2011A" not in self.complained:
        if not self.m1EtaRochCor2011A_branch and "m1EtaRochCor2011A":
            warnings.warn( "MuMuTauTauTree: Expected branch m1EtaRochCor2011A does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1EtaRochCor2011A")
        else:
            self.m1EtaRochCor2011A_branch.SetAddress(<void*>&self.m1EtaRochCor2011A_value)

        #print "making m1EtaRochCor2011B"
        self.m1EtaRochCor2011B_branch = the_tree.GetBranch("m1EtaRochCor2011B")
        #if not self.m1EtaRochCor2011B_branch and "m1EtaRochCor2011B" not in self.complained:
        if not self.m1EtaRochCor2011B_branch and "m1EtaRochCor2011B":
            warnings.warn( "MuMuTauTauTree: Expected branch m1EtaRochCor2011B does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1EtaRochCor2011B")
        else:
            self.m1EtaRochCor2011B_branch.SetAddress(<void*>&self.m1EtaRochCor2011B_value)

        #print "making m1EtaRochCor2012"
        self.m1EtaRochCor2012_branch = the_tree.GetBranch("m1EtaRochCor2012")
        #if not self.m1EtaRochCor2012_branch and "m1EtaRochCor2012" not in self.complained:
        if not self.m1EtaRochCor2012_branch and "m1EtaRochCor2012":
            warnings.warn( "MuMuTauTauTree: Expected branch m1EtaRochCor2012 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1EtaRochCor2012")
        else:
            self.m1EtaRochCor2012_branch.SetAddress(<void*>&self.m1EtaRochCor2012_value)

        #print "making m1GenCharge"
        self.m1GenCharge_branch = the_tree.GetBranch("m1GenCharge")
        #if not self.m1GenCharge_branch and "m1GenCharge" not in self.complained:
        if not self.m1GenCharge_branch and "m1GenCharge":
            warnings.warn( "MuMuTauTauTree: Expected branch m1GenCharge does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1GenCharge")
        else:
            self.m1GenCharge_branch.SetAddress(<void*>&self.m1GenCharge_value)

        #print "making m1GenEnergy"
        self.m1GenEnergy_branch = the_tree.GetBranch("m1GenEnergy")
        #if not self.m1GenEnergy_branch and "m1GenEnergy" not in self.complained:
        if not self.m1GenEnergy_branch and "m1GenEnergy":
            warnings.warn( "MuMuTauTauTree: Expected branch m1GenEnergy does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1GenEnergy")
        else:
            self.m1GenEnergy_branch.SetAddress(<void*>&self.m1GenEnergy_value)

        #print "making m1GenEta"
        self.m1GenEta_branch = the_tree.GetBranch("m1GenEta")
        #if not self.m1GenEta_branch and "m1GenEta" not in self.complained:
        if not self.m1GenEta_branch and "m1GenEta":
            warnings.warn( "MuMuTauTauTree: Expected branch m1GenEta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1GenEta")
        else:
            self.m1GenEta_branch.SetAddress(<void*>&self.m1GenEta_value)

        #print "making m1GenMotherPdgId"
        self.m1GenMotherPdgId_branch = the_tree.GetBranch("m1GenMotherPdgId")
        #if not self.m1GenMotherPdgId_branch and "m1GenMotherPdgId" not in self.complained:
        if not self.m1GenMotherPdgId_branch and "m1GenMotherPdgId":
            warnings.warn( "MuMuTauTauTree: Expected branch m1GenMotherPdgId does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1GenMotherPdgId")
        else:
            self.m1GenMotherPdgId_branch.SetAddress(<void*>&self.m1GenMotherPdgId_value)

        #print "making m1GenPdgId"
        self.m1GenPdgId_branch = the_tree.GetBranch("m1GenPdgId")
        #if not self.m1GenPdgId_branch and "m1GenPdgId" not in self.complained:
        if not self.m1GenPdgId_branch and "m1GenPdgId":
            warnings.warn( "MuMuTauTauTree: Expected branch m1GenPdgId does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1GenPdgId")
        else:
            self.m1GenPdgId_branch.SetAddress(<void*>&self.m1GenPdgId_value)

        #print "making m1GenPhi"
        self.m1GenPhi_branch = the_tree.GetBranch("m1GenPhi")
        #if not self.m1GenPhi_branch and "m1GenPhi" not in self.complained:
        if not self.m1GenPhi_branch and "m1GenPhi":
            warnings.warn( "MuMuTauTauTree: Expected branch m1GenPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1GenPhi")
        else:
            self.m1GenPhi_branch.SetAddress(<void*>&self.m1GenPhi_value)

        #print "making m1GlbTrkHits"
        self.m1GlbTrkHits_branch = the_tree.GetBranch("m1GlbTrkHits")
        #if not self.m1GlbTrkHits_branch and "m1GlbTrkHits" not in self.complained:
        if not self.m1GlbTrkHits_branch and "m1GlbTrkHits":
            warnings.warn( "MuMuTauTauTree: Expected branch m1GlbTrkHits does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1GlbTrkHits")
        else:
            self.m1GlbTrkHits_branch.SetAddress(<void*>&self.m1GlbTrkHits_value)

        #print "making m1IDHZG2011"
        self.m1IDHZG2011_branch = the_tree.GetBranch("m1IDHZG2011")
        #if not self.m1IDHZG2011_branch and "m1IDHZG2011" not in self.complained:
        if not self.m1IDHZG2011_branch and "m1IDHZG2011":
            warnings.warn( "MuMuTauTauTree: Expected branch m1IDHZG2011 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1IDHZG2011")
        else:
            self.m1IDHZG2011_branch.SetAddress(<void*>&self.m1IDHZG2011_value)

        #print "making m1IDHZG2012"
        self.m1IDHZG2012_branch = the_tree.GetBranch("m1IDHZG2012")
        #if not self.m1IDHZG2012_branch and "m1IDHZG2012" not in self.complained:
        if not self.m1IDHZG2012_branch and "m1IDHZG2012":
            warnings.warn( "MuMuTauTauTree: Expected branch m1IDHZG2012 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1IDHZG2012")
        else:
            self.m1IDHZG2012_branch.SetAddress(<void*>&self.m1IDHZG2012_value)

        #print "making m1IP3DS"
        self.m1IP3DS_branch = the_tree.GetBranch("m1IP3DS")
        #if not self.m1IP3DS_branch and "m1IP3DS" not in self.complained:
        if not self.m1IP3DS_branch and "m1IP3DS":
            warnings.warn( "MuMuTauTauTree: Expected branch m1IP3DS does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1IP3DS")
        else:
            self.m1IP3DS_branch.SetAddress(<void*>&self.m1IP3DS_value)

        #print "making m1IsGlobal"
        self.m1IsGlobal_branch = the_tree.GetBranch("m1IsGlobal")
        #if not self.m1IsGlobal_branch and "m1IsGlobal" not in self.complained:
        if not self.m1IsGlobal_branch and "m1IsGlobal":
            warnings.warn( "MuMuTauTauTree: Expected branch m1IsGlobal does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1IsGlobal")
        else:
            self.m1IsGlobal_branch.SetAddress(<void*>&self.m1IsGlobal_value)

        #print "making m1IsPFMuon"
        self.m1IsPFMuon_branch = the_tree.GetBranch("m1IsPFMuon")
        #if not self.m1IsPFMuon_branch and "m1IsPFMuon" not in self.complained:
        if not self.m1IsPFMuon_branch and "m1IsPFMuon":
            warnings.warn( "MuMuTauTauTree: Expected branch m1IsPFMuon does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1IsPFMuon")
        else:
            self.m1IsPFMuon_branch.SetAddress(<void*>&self.m1IsPFMuon_value)

        #print "making m1IsTracker"
        self.m1IsTracker_branch = the_tree.GetBranch("m1IsTracker")
        #if not self.m1IsTracker_branch and "m1IsTracker" not in self.complained:
        if not self.m1IsTracker_branch and "m1IsTracker":
            warnings.warn( "MuMuTauTauTree: Expected branch m1IsTracker does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1IsTracker")
        else:
            self.m1IsTracker_branch.SetAddress(<void*>&self.m1IsTracker_value)

        #print "making m1JetArea"
        self.m1JetArea_branch = the_tree.GetBranch("m1JetArea")
        #if not self.m1JetArea_branch and "m1JetArea" not in self.complained:
        if not self.m1JetArea_branch and "m1JetArea":
            warnings.warn( "MuMuTauTauTree: Expected branch m1JetArea does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1JetArea")
        else:
            self.m1JetArea_branch.SetAddress(<void*>&self.m1JetArea_value)

        #print "making m1JetBtag"
        self.m1JetBtag_branch = the_tree.GetBranch("m1JetBtag")
        #if not self.m1JetBtag_branch and "m1JetBtag" not in self.complained:
        if not self.m1JetBtag_branch and "m1JetBtag":
            warnings.warn( "MuMuTauTauTree: Expected branch m1JetBtag does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1JetBtag")
        else:
            self.m1JetBtag_branch.SetAddress(<void*>&self.m1JetBtag_value)

        #print "making m1JetCSVBtag"
        self.m1JetCSVBtag_branch = the_tree.GetBranch("m1JetCSVBtag")
        #if not self.m1JetCSVBtag_branch and "m1JetCSVBtag" not in self.complained:
        if not self.m1JetCSVBtag_branch and "m1JetCSVBtag":
            warnings.warn( "MuMuTauTauTree: Expected branch m1JetCSVBtag does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1JetCSVBtag")
        else:
            self.m1JetCSVBtag_branch.SetAddress(<void*>&self.m1JetCSVBtag_value)

        #print "making m1JetEtaEtaMoment"
        self.m1JetEtaEtaMoment_branch = the_tree.GetBranch("m1JetEtaEtaMoment")
        #if not self.m1JetEtaEtaMoment_branch and "m1JetEtaEtaMoment" not in self.complained:
        if not self.m1JetEtaEtaMoment_branch and "m1JetEtaEtaMoment":
            warnings.warn( "MuMuTauTauTree: Expected branch m1JetEtaEtaMoment does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1JetEtaEtaMoment")
        else:
            self.m1JetEtaEtaMoment_branch.SetAddress(<void*>&self.m1JetEtaEtaMoment_value)

        #print "making m1JetEtaPhiMoment"
        self.m1JetEtaPhiMoment_branch = the_tree.GetBranch("m1JetEtaPhiMoment")
        #if not self.m1JetEtaPhiMoment_branch and "m1JetEtaPhiMoment" not in self.complained:
        if not self.m1JetEtaPhiMoment_branch and "m1JetEtaPhiMoment":
            warnings.warn( "MuMuTauTauTree: Expected branch m1JetEtaPhiMoment does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1JetEtaPhiMoment")
        else:
            self.m1JetEtaPhiMoment_branch.SetAddress(<void*>&self.m1JetEtaPhiMoment_value)

        #print "making m1JetEtaPhiSpread"
        self.m1JetEtaPhiSpread_branch = the_tree.GetBranch("m1JetEtaPhiSpread")
        #if not self.m1JetEtaPhiSpread_branch and "m1JetEtaPhiSpread" not in self.complained:
        if not self.m1JetEtaPhiSpread_branch and "m1JetEtaPhiSpread":
            warnings.warn( "MuMuTauTauTree: Expected branch m1JetEtaPhiSpread does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1JetEtaPhiSpread")
        else:
            self.m1JetEtaPhiSpread_branch.SetAddress(<void*>&self.m1JetEtaPhiSpread_value)

        #print "making m1JetPartonFlavour"
        self.m1JetPartonFlavour_branch = the_tree.GetBranch("m1JetPartonFlavour")
        #if not self.m1JetPartonFlavour_branch and "m1JetPartonFlavour" not in self.complained:
        if not self.m1JetPartonFlavour_branch and "m1JetPartonFlavour":
            warnings.warn( "MuMuTauTauTree: Expected branch m1JetPartonFlavour does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1JetPartonFlavour")
        else:
            self.m1JetPartonFlavour_branch.SetAddress(<void*>&self.m1JetPartonFlavour_value)

        #print "making m1JetPhiPhiMoment"
        self.m1JetPhiPhiMoment_branch = the_tree.GetBranch("m1JetPhiPhiMoment")
        #if not self.m1JetPhiPhiMoment_branch and "m1JetPhiPhiMoment" not in self.complained:
        if not self.m1JetPhiPhiMoment_branch and "m1JetPhiPhiMoment":
            warnings.warn( "MuMuTauTauTree: Expected branch m1JetPhiPhiMoment does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1JetPhiPhiMoment")
        else:
            self.m1JetPhiPhiMoment_branch.SetAddress(<void*>&self.m1JetPhiPhiMoment_value)

        #print "making m1JetPt"
        self.m1JetPt_branch = the_tree.GetBranch("m1JetPt")
        #if not self.m1JetPt_branch and "m1JetPt" not in self.complained:
        if not self.m1JetPt_branch and "m1JetPt":
            warnings.warn( "MuMuTauTauTree: Expected branch m1JetPt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1JetPt")
        else:
            self.m1JetPt_branch.SetAddress(<void*>&self.m1JetPt_value)

        #print "making m1JetQGLikelihoodID"
        self.m1JetQGLikelihoodID_branch = the_tree.GetBranch("m1JetQGLikelihoodID")
        #if not self.m1JetQGLikelihoodID_branch and "m1JetQGLikelihoodID" not in self.complained:
        if not self.m1JetQGLikelihoodID_branch and "m1JetQGLikelihoodID":
            warnings.warn( "MuMuTauTauTree: Expected branch m1JetQGLikelihoodID does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1JetQGLikelihoodID")
        else:
            self.m1JetQGLikelihoodID_branch.SetAddress(<void*>&self.m1JetQGLikelihoodID_value)

        #print "making m1JetQGMVAID"
        self.m1JetQGMVAID_branch = the_tree.GetBranch("m1JetQGMVAID")
        #if not self.m1JetQGMVAID_branch and "m1JetQGMVAID" not in self.complained:
        if not self.m1JetQGMVAID_branch and "m1JetQGMVAID":
            warnings.warn( "MuMuTauTauTree: Expected branch m1JetQGMVAID does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1JetQGMVAID")
        else:
            self.m1JetQGMVAID_branch.SetAddress(<void*>&self.m1JetQGMVAID_value)

        #print "making m1Jetaxis1"
        self.m1Jetaxis1_branch = the_tree.GetBranch("m1Jetaxis1")
        #if not self.m1Jetaxis1_branch and "m1Jetaxis1" not in self.complained:
        if not self.m1Jetaxis1_branch and "m1Jetaxis1":
            warnings.warn( "MuMuTauTauTree: Expected branch m1Jetaxis1 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1Jetaxis1")
        else:
            self.m1Jetaxis1_branch.SetAddress(<void*>&self.m1Jetaxis1_value)

        #print "making m1Jetaxis2"
        self.m1Jetaxis2_branch = the_tree.GetBranch("m1Jetaxis2")
        #if not self.m1Jetaxis2_branch and "m1Jetaxis2" not in self.complained:
        if not self.m1Jetaxis2_branch and "m1Jetaxis2":
            warnings.warn( "MuMuTauTauTree: Expected branch m1Jetaxis2 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1Jetaxis2")
        else:
            self.m1Jetaxis2_branch.SetAddress(<void*>&self.m1Jetaxis2_value)

        #print "making m1Jetmult"
        self.m1Jetmult_branch = the_tree.GetBranch("m1Jetmult")
        #if not self.m1Jetmult_branch and "m1Jetmult" not in self.complained:
        if not self.m1Jetmult_branch and "m1Jetmult":
            warnings.warn( "MuMuTauTauTree: Expected branch m1Jetmult does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1Jetmult")
        else:
            self.m1Jetmult_branch.SetAddress(<void*>&self.m1Jetmult_value)

        #print "making m1JetmultMLP"
        self.m1JetmultMLP_branch = the_tree.GetBranch("m1JetmultMLP")
        #if not self.m1JetmultMLP_branch and "m1JetmultMLP" not in self.complained:
        if not self.m1JetmultMLP_branch and "m1JetmultMLP":
            warnings.warn( "MuMuTauTauTree: Expected branch m1JetmultMLP does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1JetmultMLP")
        else:
            self.m1JetmultMLP_branch.SetAddress(<void*>&self.m1JetmultMLP_value)

        #print "making m1JetmultMLPQC"
        self.m1JetmultMLPQC_branch = the_tree.GetBranch("m1JetmultMLPQC")
        #if not self.m1JetmultMLPQC_branch and "m1JetmultMLPQC" not in self.complained:
        if not self.m1JetmultMLPQC_branch and "m1JetmultMLPQC":
            warnings.warn( "MuMuTauTauTree: Expected branch m1JetmultMLPQC does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1JetmultMLPQC")
        else:
            self.m1JetmultMLPQC_branch.SetAddress(<void*>&self.m1JetmultMLPQC_value)

        #print "making m1JetptD"
        self.m1JetptD_branch = the_tree.GetBranch("m1JetptD")
        #if not self.m1JetptD_branch and "m1JetptD" not in self.complained:
        if not self.m1JetptD_branch and "m1JetptD":
            warnings.warn( "MuMuTauTauTree: Expected branch m1JetptD does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1JetptD")
        else:
            self.m1JetptD_branch.SetAddress(<void*>&self.m1JetptD_value)

        #print "making m1L1Mu3EG5L3Filtered17"
        self.m1L1Mu3EG5L3Filtered17_branch = the_tree.GetBranch("m1L1Mu3EG5L3Filtered17")
        #if not self.m1L1Mu3EG5L3Filtered17_branch and "m1L1Mu3EG5L3Filtered17" not in self.complained:
        if not self.m1L1Mu3EG5L3Filtered17_branch and "m1L1Mu3EG5L3Filtered17":
            warnings.warn( "MuMuTauTauTree: Expected branch m1L1Mu3EG5L3Filtered17 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1L1Mu3EG5L3Filtered17")
        else:
            self.m1L1Mu3EG5L3Filtered17_branch.SetAddress(<void*>&self.m1L1Mu3EG5L3Filtered17_value)

        #print "making m1L3fL1DoubleMu10MuOpenL1f0L2f10L3Filtered17"
        self.m1L3fL1DoubleMu10MuOpenL1f0L2f10L3Filtered17_branch = the_tree.GetBranch("m1L3fL1DoubleMu10MuOpenL1f0L2f10L3Filtered17")
        #if not self.m1L3fL1DoubleMu10MuOpenL1f0L2f10L3Filtered17_branch and "m1L3fL1DoubleMu10MuOpenL1f0L2f10L3Filtered17" not in self.complained:
        if not self.m1L3fL1DoubleMu10MuOpenL1f0L2f10L3Filtered17_branch and "m1L3fL1DoubleMu10MuOpenL1f0L2f10L3Filtered17":
            warnings.warn( "MuMuTauTauTree: Expected branch m1L3fL1DoubleMu10MuOpenL1f0L2f10L3Filtered17 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1L3fL1DoubleMu10MuOpenL1f0L2f10L3Filtered17")
        else:
            self.m1L3fL1DoubleMu10MuOpenL1f0L2f10L3Filtered17_branch.SetAddress(<void*>&self.m1L3fL1DoubleMu10MuOpenL1f0L2f10L3Filtered17_value)

        #print "making m1Mass"
        self.m1Mass_branch = the_tree.GetBranch("m1Mass")
        #if not self.m1Mass_branch and "m1Mass" not in self.complained:
        if not self.m1Mass_branch and "m1Mass":
            warnings.warn( "MuMuTauTauTree: Expected branch m1Mass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1Mass")
        else:
            self.m1Mass_branch.SetAddress(<void*>&self.m1Mass_value)

        #print "making m1MatchedStations"
        self.m1MatchedStations_branch = the_tree.GetBranch("m1MatchedStations")
        #if not self.m1MatchedStations_branch and "m1MatchedStations" not in self.complained:
        if not self.m1MatchedStations_branch and "m1MatchedStations":
            warnings.warn( "MuMuTauTauTree: Expected branch m1MatchedStations does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1MatchedStations")
        else:
            self.m1MatchedStations_branch.SetAddress(<void*>&self.m1MatchedStations_value)

        #print "making m1MatchesDoubleMuPaths"
        self.m1MatchesDoubleMuPaths_branch = the_tree.GetBranch("m1MatchesDoubleMuPaths")
        #if not self.m1MatchesDoubleMuPaths_branch and "m1MatchesDoubleMuPaths" not in self.complained:
        if not self.m1MatchesDoubleMuPaths_branch and "m1MatchesDoubleMuPaths":
            warnings.warn( "MuMuTauTauTree: Expected branch m1MatchesDoubleMuPaths does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1MatchesDoubleMuPaths")
        else:
            self.m1MatchesDoubleMuPaths_branch.SetAddress(<void*>&self.m1MatchesDoubleMuPaths_value)

        #print "making m1MatchesDoubleMuTrkPaths"
        self.m1MatchesDoubleMuTrkPaths_branch = the_tree.GetBranch("m1MatchesDoubleMuTrkPaths")
        #if not self.m1MatchesDoubleMuTrkPaths_branch and "m1MatchesDoubleMuTrkPaths" not in self.complained:
        if not self.m1MatchesDoubleMuTrkPaths_branch and "m1MatchesDoubleMuTrkPaths":
            warnings.warn( "MuMuTauTauTree: Expected branch m1MatchesDoubleMuTrkPaths does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1MatchesDoubleMuTrkPaths")
        else:
            self.m1MatchesDoubleMuTrkPaths_branch.SetAddress(<void*>&self.m1MatchesDoubleMuTrkPaths_value)

        #print "making m1MatchesIsoMu24eta2p1"
        self.m1MatchesIsoMu24eta2p1_branch = the_tree.GetBranch("m1MatchesIsoMu24eta2p1")
        #if not self.m1MatchesIsoMu24eta2p1_branch and "m1MatchesIsoMu24eta2p1" not in self.complained:
        if not self.m1MatchesIsoMu24eta2p1_branch and "m1MatchesIsoMu24eta2p1":
            warnings.warn( "MuMuTauTauTree: Expected branch m1MatchesIsoMu24eta2p1 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1MatchesIsoMu24eta2p1")
        else:
            self.m1MatchesIsoMu24eta2p1_branch.SetAddress(<void*>&self.m1MatchesIsoMu24eta2p1_value)

        #print "making m1MatchesIsoMuGroup"
        self.m1MatchesIsoMuGroup_branch = the_tree.GetBranch("m1MatchesIsoMuGroup")
        #if not self.m1MatchesIsoMuGroup_branch and "m1MatchesIsoMuGroup" not in self.complained:
        if not self.m1MatchesIsoMuGroup_branch and "m1MatchesIsoMuGroup":
            warnings.warn( "MuMuTauTauTree: Expected branch m1MatchesIsoMuGroup does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1MatchesIsoMuGroup")
        else:
            self.m1MatchesIsoMuGroup_branch.SetAddress(<void*>&self.m1MatchesIsoMuGroup_value)

        #print "making m1MatchesMu17Ele8IsoPath"
        self.m1MatchesMu17Ele8IsoPath_branch = the_tree.GetBranch("m1MatchesMu17Ele8IsoPath")
        #if not self.m1MatchesMu17Ele8IsoPath_branch and "m1MatchesMu17Ele8IsoPath" not in self.complained:
        if not self.m1MatchesMu17Ele8IsoPath_branch and "m1MatchesMu17Ele8IsoPath":
            warnings.warn( "MuMuTauTauTree: Expected branch m1MatchesMu17Ele8IsoPath does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1MatchesMu17Ele8IsoPath")
        else:
            self.m1MatchesMu17Ele8IsoPath_branch.SetAddress(<void*>&self.m1MatchesMu17Ele8IsoPath_value)

        #print "making m1MatchesMu17Ele8Path"
        self.m1MatchesMu17Ele8Path_branch = the_tree.GetBranch("m1MatchesMu17Ele8Path")
        #if not self.m1MatchesMu17Ele8Path_branch and "m1MatchesMu17Ele8Path" not in self.complained:
        if not self.m1MatchesMu17Ele8Path_branch and "m1MatchesMu17Ele8Path":
            warnings.warn( "MuMuTauTauTree: Expected branch m1MatchesMu17Ele8Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1MatchesMu17Ele8Path")
        else:
            self.m1MatchesMu17Ele8Path_branch.SetAddress(<void*>&self.m1MatchesMu17Ele8Path_value)

        #print "making m1MatchesMu17Mu8Path"
        self.m1MatchesMu17Mu8Path_branch = the_tree.GetBranch("m1MatchesMu17Mu8Path")
        #if not self.m1MatchesMu17Mu8Path_branch and "m1MatchesMu17Mu8Path" not in self.complained:
        if not self.m1MatchesMu17Mu8Path_branch and "m1MatchesMu17Mu8Path":
            warnings.warn( "MuMuTauTauTree: Expected branch m1MatchesMu17Mu8Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1MatchesMu17Mu8Path")
        else:
            self.m1MatchesMu17Mu8Path_branch.SetAddress(<void*>&self.m1MatchesMu17Mu8Path_value)

        #print "making m1MatchesMu17TrkMu8Path"
        self.m1MatchesMu17TrkMu8Path_branch = the_tree.GetBranch("m1MatchesMu17TrkMu8Path")
        #if not self.m1MatchesMu17TrkMu8Path_branch and "m1MatchesMu17TrkMu8Path" not in self.complained:
        if not self.m1MatchesMu17TrkMu8Path_branch and "m1MatchesMu17TrkMu8Path":
            warnings.warn( "MuMuTauTauTree: Expected branch m1MatchesMu17TrkMu8Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1MatchesMu17TrkMu8Path")
        else:
            self.m1MatchesMu17TrkMu8Path_branch.SetAddress(<void*>&self.m1MatchesMu17TrkMu8Path_value)

        #print "making m1MatchesMu8Ele17IsoPath"
        self.m1MatchesMu8Ele17IsoPath_branch = the_tree.GetBranch("m1MatchesMu8Ele17IsoPath")
        #if not self.m1MatchesMu8Ele17IsoPath_branch and "m1MatchesMu8Ele17IsoPath" not in self.complained:
        if not self.m1MatchesMu8Ele17IsoPath_branch and "m1MatchesMu8Ele17IsoPath":
            warnings.warn( "MuMuTauTauTree: Expected branch m1MatchesMu8Ele17IsoPath does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1MatchesMu8Ele17IsoPath")
        else:
            self.m1MatchesMu8Ele17IsoPath_branch.SetAddress(<void*>&self.m1MatchesMu8Ele17IsoPath_value)

        #print "making m1MatchesMu8Ele17Path"
        self.m1MatchesMu8Ele17Path_branch = the_tree.GetBranch("m1MatchesMu8Ele17Path")
        #if not self.m1MatchesMu8Ele17Path_branch and "m1MatchesMu8Ele17Path" not in self.complained:
        if not self.m1MatchesMu8Ele17Path_branch and "m1MatchesMu8Ele17Path":
            warnings.warn( "MuMuTauTauTree: Expected branch m1MatchesMu8Ele17Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1MatchesMu8Ele17Path")
        else:
            self.m1MatchesMu8Ele17Path_branch.SetAddress(<void*>&self.m1MatchesMu8Ele17Path_value)

        #print "making m1MtToMET"
        self.m1MtToMET_branch = the_tree.GetBranch("m1MtToMET")
        #if not self.m1MtToMET_branch and "m1MtToMET" not in self.complained:
        if not self.m1MtToMET_branch and "m1MtToMET":
            warnings.warn( "MuMuTauTauTree: Expected branch m1MtToMET does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1MtToMET")
        else:
            self.m1MtToMET_branch.SetAddress(<void*>&self.m1MtToMET_value)

        #print "making m1MtToMVAMET"
        self.m1MtToMVAMET_branch = the_tree.GetBranch("m1MtToMVAMET")
        #if not self.m1MtToMVAMET_branch and "m1MtToMVAMET" not in self.complained:
        if not self.m1MtToMVAMET_branch and "m1MtToMVAMET":
            warnings.warn( "MuMuTauTauTree: Expected branch m1MtToMVAMET does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1MtToMVAMET")
        else:
            self.m1MtToMVAMET_branch.SetAddress(<void*>&self.m1MtToMVAMET_value)

        #print "making m1MtToPFMET"
        self.m1MtToPFMET_branch = the_tree.GetBranch("m1MtToPFMET")
        #if not self.m1MtToPFMET_branch and "m1MtToPFMET" not in self.complained:
        if not self.m1MtToPFMET_branch and "m1MtToPFMET":
            warnings.warn( "MuMuTauTauTree: Expected branch m1MtToPFMET does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1MtToPFMET")
        else:
            self.m1MtToPFMET_branch.SetAddress(<void*>&self.m1MtToPFMET_value)

        #print "making m1MtToPfMet_Ty1"
        self.m1MtToPfMet_Ty1_branch = the_tree.GetBranch("m1MtToPfMet_Ty1")
        #if not self.m1MtToPfMet_Ty1_branch and "m1MtToPfMet_Ty1" not in self.complained:
        if not self.m1MtToPfMet_Ty1_branch and "m1MtToPfMet_Ty1":
            warnings.warn( "MuMuTauTauTree: Expected branch m1MtToPfMet_Ty1 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1MtToPfMet_Ty1")
        else:
            self.m1MtToPfMet_Ty1_branch.SetAddress(<void*>&self.m1MtToPfMet_Ty1_value)

        #print "making m1MtToPfMet_jes"
        self.m1MtToPfMet_jes_branch = the_tree.GetBranch("m1MtToPfMet_jes")
        #if not self.m1MtToPfMet_jes_branch and "m1MtToPfMet_jes" not in self.complained:
        if not self.m1MtToPfMet_jes_branch and "m1MtToPfMet_jes":
            warnings.warn( "MuMuTauTauTree: Expected branch m1MtToPfMet_jes does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1MtToPfMet_jes")
        else:
            self.m1MtToPfMet_jes_branch.SetAddress(<void*>&self.m1MtToPfMet_jes_value)

        #print "making m1MtToPfMet_mes"
        self.m1MtToPfMet_mes_branch = the_tree.GetBranch("m1MtToPfMet_mes")
        #if not self.m1MtToPfMet_mes_branch and "m1MtToPfMet_mes" not in self.complained:
        if not self.m1MtToPfMet_mes_branch and "m1MtToPfMet_mes":
            warnings.warn( "MuMuTauTauTree: Expected branch m1MtToPfMet_mes does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1MtToPfMet_mes")
        else:
            self.m1MtToPfMet_mes_branch.SetAddress(<void*>&self.m1MtToPfMet_mes_value)

        #print "making m1MtToPfMet_tes"
        self.m1MtToPfMet_tes_branch = the_tree.GetBranch("m1MtToPfMet_tes")
        #if not self.m1MtToPfMet_tes_branch and "m1MtToPfMet_tes" not in self.complained:
        if not self.m1MtToPfMet_tes_branch and "m1MtToPfMet_tes":
            warnings.warn( "MuMuTauTauTree: Expected branch m1MtToPfMet_tes does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1MtToPfMet_tes")
        else:
            self.m1MtToPfMet_tes_branch.SetAddress(<void*>&self.m1MtToPfMet_tes_value)

        #print "making m1MtToPfMet_ues"
        self.m1MtToPfMet_ues_branch = the_tree.GetBranch("m1MtToPfMet_ues")
        #if not self.m1MtToPfMet_ues_branch and "m1MtToPfMet_ues" not in self.complained:
        if not self.m1MtToPfMet_ues_branch and "m1MtToPfMet_ues":
            warnings.warn( "MuMuTauTauTree: Expected branch m1MtToPfMet_ues does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1MtToPfMet_ues")
        else:
            self.m1MtToPfMet_ues_branch.SetAddress(<void*>&self.m1MtToPfMet_ues_value)

        #print "making m1Mu17Ele8dZFilter"
        self.m1Mu17Ele8dZFilter_branch = the_tree.GetBranch("m1Mu17Ele8dZFilter")
        #if not self.m1Mu17Ele8dZFilter_branch and "m1Mu17Ele8dZFilter" not in self.complained:
        if not self.m1Mu17Ele8dZFilter_branch and "m1Mu17Ele8dZFilter":
            warnings.warn( "MuMuTauTauTree: Expected branch m1Mu17Ele8dZFilter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1Mu17Ele8dZFilter")
        else:
            self.m1Mu17Ele8dZFilter_branch.SetAddress(<void*>&self.m1Mu17Ele8dZFilter_value)

        #print "making m1MuonHits"
        self.m1MuonHits_branch = the_tree.GetBranch("m1MuonHits")
        #if not self.m1MuonHits_branch and "m1MuonHits" not in self.complained:
        if not self.m1MuonHits_branch and "m1MuonHits":
            warnings.warn( "MuMuTauTauTree: Expected branch m1MuonHits does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1MuonHits")
        else:
            self.m1MuonHits_branch.SetAddress(<void*>&self.m1MuonHits_value)

        #print "making m1NormTrkChi2"
        self.m1NormTrkChi2_branch = the_tree.GetBranch("m1NormTrkChi2")
        #if not self.m1NormTrkChi2_branch and "m1NormTrkChi2" not in self.complained:
        if not self.m1NormTrkChi2_branch and "m1NormTrkChi2":
            warnings.warn( "MuMuTauTauTree: Expected branch m1NormTrkChi2 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1NormTrkChi2")
        else:
            self.m1NormTrkChi2_branch.SetAddress(<void*>&self.m1NormTrkChi2_value)

        #print "making m1PFChargedIso"
        self.m1PFChargedIso_branch = the_tree.GetBranch("m1PFChargedIso")
        #if not self.m1PFChargedIso_branch and "m1PFChargedIso" not in self.complained:
        if not self.m1PFChargedIso_branch and "m1PFChargedIso":
            warnings.warn( "MuMuTauTauTree: Expected branch m1PFChargedIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1PFChargedIso")
        else:
            self.m1PFChargedIso_branch.SetAddress(<void*>&self.m1PFChargedIso_value)

        #print "making m1PFIDTight"
        self.m1PFIDTight_branch = the_tree.GetBranch("m1PFIDTight")
        #if not self.m1PFIDTight_branch and "m1PFIDTight" not in self.complained:
        if not self.m1PFIDTight_branch and "m1PFIDTight":
            warnings.warn( "MuMuTauTauTree: Expected branch m1PFIDTight does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1PFIDTight")
        else:
            self.m1PFIDTight_branch.SetAddress(<void*>&self.m1PFIDTight_value)

        #print "making m1PFNeutralIso"
        self.m1PFNeutralIso_branch = the_tree.GetBranch("m1PFNeutralIso")
        #if not self.m1PFNeutralIso_branch and "m1PFNeutralIso" not in self.complained:
        if not self.m1PFNeutralIso_branch and "m1PFNeutralIso":
            warnings.warn( "MuMuTauTauTree: Expected branch m1PFNeutralIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1PFNeutralIso")
        else:
            self.m1PFNeutralIso_branch.SetAddress(<void*>&self.m1PFNeutralIso_value)

        #print "making m1PFPUChargedIso"
        self.m1PFPUChargedIso_branch = the_tree.GetBranch("m1PFPUChargedIso")
        #if not self.m1PFPUChargedIso_branch and "m1PFPUChargedIso" not in self.complained:
        if not self.m1PFPUChargedIso_branch and "m1PFPUChargedIso":
            warnings.warn( "MuMuTauTauTree: Expected branch m1PFPUChargedIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1PFPUChargedIso")
        else:
            self.m1PFPUChargedIso_branch.SetAddress(<void*>&self.m1PFPUChargedIso_value)

        #print "making m1PFPhotonIso"
        self.m1PFPhotonIso_branch = the_tree.GetBranch("m1PFPhotonIso")
        #if not self.m1PFPhotonIso_branch and "m1PFPhotonIso" not in self.complained:
        if not self.m1PFPhotonIso_branch and "m1PFPhotonIso":
            warnings.warn( "MuMuTauTauTree: Expected branch m1PFPhotonIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1PFPhotonIso")
        else:
            self.m1PFPhotonIso_branch.SetAddress(<void*>&self.m1PFPhotonIso_value)

        #print "making m1PVDXY"
        self.m1PVDXY_branch = the_tree.GetBranch("m1PVDXY")
        #if not self.m1PVDXY_branch and "m1PVDXY" not in self.complained:
        if not self.m1PVDXY_branch and "m1PVDXY":
            warnings.warn( "MuMuTauTauTree: Expected branch m1PVDXY does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1PVDXY")
        else:
            self.m1PVDXY_branch.SetAddress(<void*>&self.m1PVDXY_value)

        #print "making m1PVDZ"
        self.m1PVDZ_branch = the_tree.GetBranch("m1PVDZ")
        #if not self.m1PVDZ_branch and "m1PVDZ" not in self.complained:
        if not self.m1PVDZ_branch and "m1PVDZ":
            warnings.warn( "MuMuTauTauTree: Expected branch m1PVDZ does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1PVDZ")
        else:
            self.m1PVDZ_branch.SetAddress(<void*>&self.m1PVDZ_value)

        #print "making m1Phi"
        self.m1Phi_branch = the_tree.GetBranch("m1Phi")
        #if not self.m1Phi_branch and "m1Phi" not in self.complained:
        if not self.m1Phi_branch and "m1Phi":
            warnings.warn( "MuMuTauTauTree: Expected branch m1Phi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1Phi")
        else:
            self.m1Phi_branch.SetAddress(<void*>&self.m1Phi_value)

        #print "making m1PhiRochCor2011A"
        self.m1PhiRochCor2011A_branch = the_tree.GetBranch("m1PhiRochCor2011A")
        #if not self.m1PhiRochCor2011A_branch and "m1PhiRochCor2011A" not in self.complained:
        if not self.m1PhiRochCor2011A_branch and "m1PhiRochCor2011A":
            warnings.warn( "MuMuTauTauTree: Expected branch m1PhiRochCor2011A does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1PhiRochCor2011A")
        else:
            self.m1PhiRochCor2011A_branch.SetAddress(<void*>&self.m1PhiRochCor2011A_value)

        #print "making m1PhiRochCor2011B"
        self.m1PhiRochCor2011B_branch = the_tree.GetBranch("m1PhiRochCor2011B")
        #if not self.m1PhiRochCor2011B_branch and "m1PhiRochCor2011B" not in self.complained:
        if not self.m1PhiRochCor2011B_branch and "m1PhiRochCor2011B":
            warnings.warn( "MuMuTauTauTree: Expected branch m1PhiRochCor2011B does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1PhiRochCor2011B")
        else:
            self.m1PhiRochCor2011B_branch.SetAddress(<void*>&self.m1PhiRochCor2011B_value)

        #print "making m1PhiRochCor2012"
        self.m1PhiRochCor2012_branch = the_tree.GetBranch("m1PhiRochCor2012")
        #if not self.m1PhiRochCor2012_branch and "m1PhiRochCor2012" not in self.complained:
        if not self.m1PhiRochCor2012_branch and "m1PhiRochCor2012":
            warnings.warn( "MuMuTauTauTree: Expected branch m1PhiRochCor2012 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1PhiRochCor2012")
        else:
            self.m1PhiRochCor2012_branch.SetAddress(<void*>&self.m1PhiRochCor2012_value)

        #print "making m1PixHits"
        self.m1PixHits_branch = the_tree.GetBranch("m1PixHits")
        #if not self.m1PixHits_branch and "m1PixHits" not in self.complained:
        if not self.m1PixHits_branch and "m1PixHits":
            warnings.warn( "MuMuTauTauTree: Expected branch m1PixHits does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1PixHits")
        else:
            self.m1PixHits_branch.SetAddress(<void*>&self.m1PixHits_value)

        #print "making m1Pt"
        self.m1Pt_branch = the_tree.GetBranch("m1Pt")
        #if not self.m1Pt_branch and "m1Pt" not in self.complained:
        if not self.m1Pt_branch and "m1Pt":
            warnings.warn( "MuMuTauTauTree: Expected branch m1Pt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1Pt")
        else:
            self.m1Pt_branch.SetAddress(<void*>&self.m1Pt_value)

        #print "making m1PtRochCor2011A"
        self.m1PtRochCor2011A_branch = the_tree.GetBranch("m1PtRochCor2011A")
        #if not self.m1PtRochCor2011A_branch and "m1PtRochCor2011A" not in self.complained:
        if not self.m1PtRochCor2011A_branch and "m1PtRochCor2011A":
            warnings.warn( "MuMuTauTauTree: Expected branch m1PtRochCor2011A does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1PtRochCor2011A")
        else:
            self.m1PtRochCor2011A_branch.SetAddress(<void*>&self.m1PtRochCor2011A_value)

        #print "making m1PtRochCor2011B"
        self.m1PtRochCor2011B_branch = the_tree.GetBranch("m1PtRochCor2011B")
        #if not self.m1PtRochCor2011B_branch and "m1PtRochCor2011B" not in self.complained:
        if not self.m1PtRochCor2011B_branch and "m1PtRochCor2011B":
            warnings.warn( "MuMuTauTauTree: Expected branch m1PtRochCor2011B does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1PtRochCor2011B")
        else:
            self.m1PtRochCor2011B_branch.SetAddress(<void*>&self.m1PtRochCor2011B_value)

        #print "making m1PtRochCor2012"
        self.m1PtRochCor2012_branch = the_tree.GetBranch("m1PtRochCor2012")
        #if not self.m1PtRochCor2012_branch and "m1PtRochCor2012" not in self.complained:
        if not self.m1PtRochCor2012_branch and "m1PtRochCor2012":
            warnings.warn( "MuMuTauTauTree: Expected branch m1PtRochCor2012 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1PtRochCor2012")
        else:
            self.m1PtRochCor2012_branch.SetAddress(<void*>&self.m1PtRochCor2012_value)

        #print "making m1Rank"
        self.m1Rank_branch = the_tree.GetBranch("m1Rank")
        #if not self.m1Rank_branch and "m1Rank" not in self.complained:
        if not self.m1Rank_branch and "m1Rank":
            warnings.warn( "MuMuTauTauTree: Expected branch m1Rank does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1Rank")
        else:
            self.m1Rank_branch.SetAddress(<void*>&self.m1Rank_value)

        #print "making m1RelPFIsoDB"
        self.m1RelPFIsoDB_branch = the_tree.GetBranch("m1RelPFIsoDB")
        #if not self.m1RelPFIsoDB_branch and "m1RelPFIsoDB" not in self.complained:
        if not self.m1RelPFIsoDB_branch and "m1RelPFIsoDB":
            warnings.warn( "MuMuTauTauTree: Expected branch m1RelPFIsoDB does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1RelPFIsoDB")
        else:
            self.m1RelPFIsoDB_branch.SetAddress(<void*>&self.m1RelPFIsoDB_value)

        #print "making m1RelPFIsoRho"
        self.m1RelPFIsoRho_branch = the_tree.GetBranch("m1RelPFIsoRho")
        #if not self.m1RelPFIsoRho_branch and "m1RelPFIsoRho" not in self.complained:
        if not self.m1RelPFIsoRho_branch and "m1RelPFIsoRho":
            warnings.warn( "MuMuTauTauTree: Expected branch m1RelPFIsoRho does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1RelPFIsoRho")
        else:
            self.m1RelPFIsoRho_branch.SetAddress(<void*>&self.m1RelPFIsoRho_value)

        #print "making m1RelPFIsoRhoFSR"
        self.m1RelPFIsoRhoFSR_branch = the_tree.GetBranch("m1RelPFIsoRhoFSR")
        #if not self.m1RelPFIsoRhoFSR_branch and "m1RelPFIsoRhoFSR" not in self.complained:
        if not self.m1RelPFIsoRhoFSR_branch and "m1RelPFIsoRhoFSR":
            warnings.warn( "MuMuTauTauTree: Expected branch m1RelPFIsoRhoFSR does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1RelPFIsoRhoFSR")
        else:
            self.m1RelPFIsoRhoFSR_branch.SetAddress(<void*>&self.m1RelPFIsoRhoFSR_value)

        #print "making m1RhoHZG2011"
        self.m1RhoHZG2011_branch = the_tree.GetBranch("m1RhoHZG2011")
        #if not self.m1RhoHZG2011_branch and "m1RhoHZG2011" not in self.complained:
        if not self.m1RhoHZG2011_branch and "m1RhoHZG2011":
            warnings.warn( "MuMuTauTauTree: Expected branch m1RhoHZG2011 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1RhoHZG2011")
        else:
            self.m1RhoHZG2011_branch.SetAddress(<void*>&self.m1RhoHZG2011_value)

        #print "making m1RhoHZG2012"
        self.m1RhoHZG2012_branch = the_tree.GetBranch("m1RhoHZG2012")
        #if not self.m1RhoHZG2012_branch and "m1RhoHZG2012" not in self.complained:
        if not self.m1RhoHZG2012_branch and "m1RhoHZG2012":
            warnings.warn( "MuMuTauTauTree: Expected branch m1RhoHZG2012 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1RhoHZG2012")
        else:
            self.m1RhoHZG2012_branch.SetAddress(<void*>&self.m1RhoHZG2012_value)

        #print "making m1SingleMu13L3Filtered13"
        self.m1SingleMu13L3Filtered13_branch = the_tree.GetBranch("m1SingleMu13L3Filtered13")
        #if not self.m1SingleMu13L3Filtered13_branch and "m1SingleMu13L3Filtered13" not in self.complained:
        if not self.m1SingleMu13L3Filtered13_branch and "m1SingleMu13L3Filtered13":
            warnings.warn( "MuMuTauTauTree: Expected branch m1SingleMu13L3Filtered13 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1SingleMu13L3Filtered13")
        else:
            self.m1SingleMu13L3Filtered13_branch.SetAddress(<void*>&self.m1SingleMu13L3Filtered13_value)

        #print "making m1SingleMu13L3Filtered17"
        self.m1SingleMu13L3Filtered17_branch = the_tree.GetBranch("m1SingleMu13L3Filtered17")
        #if not self.m1SingleMu13L3Filtered17_branch and "m1SingleMu13L3Filtered17" not in self.complained:
        if not self.m1SingleMu13L3Filtered17_branch and "m1SingleMu13L3Filtered17":
            warnings.warn( "MuMuTauTauTree: Expected branch m1SingleMu13L3Filtered17 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1SingleMu13L3Filtered17")
        else:
            self.m1SingleMu13L3Filtered17_branch.SetAddress(<void*>&self.m1SingleMu13L3Filtered17_value)

        #print "making m1TkLayersWithMeasurement"
        self.m1TkLayersWithMeasurement_branch = the_tree.GetBranch("m1TkLayersWithMeasurement")
        #if not self.m1TkLayersWithMeasurement_branch and "m1TkLayersWithMeasurement" not in self.complained:
        if not self.m1TkLayersWithMeasurement_branch and "m1TkLayersWithMeasurement":
            warnings.warn( "MuMuTauTauTree: Expected branch m1TkLayersWithMeasurement does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1TkLayersWithMeasurement")
        else:
            self.m1TkLayersWithMeasurement_branch.SetAddress(<void*>&self.m1TkLayersWithMeasurement_value)

        #print "making m1ToMETDPhi"
        self.m1ToMETDPhi_branch = the_tree.GetBranch("m1ToMETDPhi")
        #if not self.m1ToMETDPhi_branch and "m1ToMETDPhi" not in self.complained:
        if not self.m1ToMETDPhi_branch and "m1ToMETDPhi":
            warnings.warn( "MuMuTauTauTree: Expected branch m1ToMETDPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1ToMETDPhi")
        else:
            self.m1ToMETDPhi_branch.SetAddress(<void*>&self.m1ToMETDPhi_value)

        #print "making m1TypeCode"
        self.m1TypeCode_branch = the_tree.GetBranch("m1TypeCode")
        #if not self.m1TypeCode_branch and "m1TypeCode" not in self.complained:
        if not self.m1TypeCode_branch and "m1TypeCode":
            warnings.warn( "MuMuTauTauTree: Expected branch m1TypeCode does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1TypeCode")
        else:
            self.m1TypeCode_branch.SetAddress(<void*>&self.m1TypeCode_value)

        #print "making m1VBTFID"
        self.m1VBTFID_branch = the_tree.GetBranch("m1VBTFID")
        #if not self.m1VBTFID_branch and "m1VBTFID" not in self.complained:
        if not self.m1VBTFID_branch and "m1VBTFID":
            warnings.warn( "MuMuTauTauTree: Expected branch m1VBTFID does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1VBTFID")
        else:
            self.m1VBTFID_branch.SetAddress(<void*>&self.m1VBTFID_value)

        #print "making m1VZ"
        self.m1VZ_branch = the_tree.GetBranch("m1VZ")
        #if not self.m1VZ_branch and "m1VZ" not in self.complained:
        if not self.m1VZ_branch and "m1VZ":
            warnings.warn( "MuMuTauTauTree: Expected branch m1VZ does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1VZ")
        else:
            self.m1VZ_branch.SetAddress(<void*>&self.m1VZ_value)

        #print "making m1WWID"
        self.m1WWID_branch = the_tree.GetBranch("m1WWID")
        #if not self.m1WWID_branch and "m1WWID" not in self.complained:
        if not self.m1WWID_branch and "m1WWID":
            warnings.warn( "MuMuTauTauTree: Expected branch m1WWID does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1WWID")
        else:
            self.m1WWID_branch.SetAddress(<void*>&self.m1WWID_value)

        #print "making m1_m2_CosThetaStar"
        self.m1_m2_CosThetaStar_branch = the_tree.GetBranch("m1_m2_CosThetaStar")
        #if not self.m1_m2_CosThetaStar_branch and "m1_m2_CosThetaStar" not in self.complained:
        if not self.m1_m2_CosThetaStar_branch and "m1_m2_CosThetaStar":
            warnings.warn( "MuMuTauTauTree: Expected branch m1_m2_CosThetaStar does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_m2_CosThetaStar")
        else:
            self.m1_m2_CosThetaStar_branch.SetAddress(<void*>&self.m1_m2_CosThetaStar_value)

        #print "making m1_m2_DPhi"
        self.m1_m2_DPhi_branch = the_tree.GetBranch("m1_m2_DPhi")
        #if not self.m1_m2_DPhi_branch and "m1_m2_DPhi" not in self.complained:
        if not self.m1_m2_DPhi_branch and "m1_m2_DPhi":
            warnings.warn( "MuMuTauTauTree: Expected branch m1_m2_DPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_m2_DPhi")
        else:
            self.m1_m2_DPhi_branch.SetAddress(<void*>&self.m1_m2_DPhi_value)

        #print "making m1_m2_DR"
        self.m1_m2_DR_branch = the_tree.GetBranch("m1_m2_DR")
        #if not self.m1_m2_DR_branch and "m1_m2_DR" not in self.complained:
        if not self.m1_m2_DR_branch and "m1_m2_DR":
            warnings.warn( "MuMuTauTauTree: Expected branch m1_m2_DR does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_m2_DR")
        else:
            self.m1_m2_DR_branch.SetAddress(<void*>&self.m1_m2_DR_value)

        #print "making m1_m2_Eta"
        self.m1_m2_Eta_branch = the_tree.GetBranch("m1_m2_Eta")
        #if not self.m1_m2_Eta_branch and "m1_m2_Eta" not in self.complained:
        if not self.m1_m2_Eta_branch and "m1_m2_Eta":
            warnings.warn( "MuMuTauTauTree: Expected branch m1_m2_Eta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_m2_Eta")
        else:
            self.m1_m2_Eta_branch.SetAddress(<void*>&self.m1_m2_Eta_value)

        #print "making m1_m2_Mass"
        self.m1_m2_Mass_branch = the_tree.GetBranch("m1_m2_Mass")
        #if not self.m1_m2_Mass_branch and "m1_m2_Mass" not in self.complained:
        if not self.m1_m2_Mass_branch and "m1_m2_Mass":
            warnings.warn( "MuMuTauTauTree: Expected branch m1_m2_Mass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_m2_Mass")
        else:
            self.m1_m2_Mass_branch.SetAddress(<void*>&self.m1_m2_Mass_value)

        #print "making m1_m2_MassFsr"
        self.m1_m2_MassFsr_branch = the_tree.GetBranch("m1_m2_MassFsr")
        #if not self.m1_m2_MassFsr_branch and "m1_m2_MassFsr" not in self.complained:
        if not self.m1_m2_MassFsr_branch and "m1_m2_MassFsr":
            warnings.warn( "MuMuTauTauTree: Expected branch m1_m2_MassFsr does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_m2_MassFsr")
        else:
            self.m1_m2_MassFsr_branch.SetAddress(<void*>&self.m1_m2_MassFsr_value)

        #print "making m1_m2_PZeta"
        self.m1_m2_PZeta_branch = the_tree.GetBranch("m1_m2_PZeta")
        #if not self.m1_m2_PZeta_branch and "m1_m2_PZeta" not in self.complained:
        if not self.m1_m2_PZeta_branch and "m1_m2_PZeta":
            warnings.warn( "MuMuTauTauTree: Expected branch m1_m2_PZeta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_m2_PZeta")
        else:
            self.m1_m2_PZeta_branch.SetAddress(<void*>&self.m1_m2_PZeta_value)

        #print "making m1_m2_PZetaVis"
        self.m1_m2_PZetaVis_branch = the_tree.GetBranch("m1_m2_PZetaVis")
        #if not self.m1_m2_PZetaVis_branch and "m1_m2_PZetaVis" not in self.complained:
        if not self.m1_m2_PZetaVis_branch and "m1_m2_PZetaVis":
            warnings.warn( "MuMuTauTauTree: Expected branch m1_m2_PZetaVis does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_m2_PZetaVis")
        else:
            self.m1_m2_PZetaVis_branch.SetAddress(<void*>&self.m1_m2_PZetaVis_value)

        #print "making m1_m2_Phi"
        self.m1_m2_Phi_branch = the_tree.GetBranch("m1_m2_Phi")
        #if not self.m1_m2_Phi_branch and "m1_m2_Phi" not in self.complained:
        if not self.m1_m2_Phi_branch and "m1_m2_Phi":
            warnings.warn( "MuMuTauTauTree: Expected branch m1_m2_Phi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_m2_Phi")
        else:
            self.m1_m2_Phi_branch.SetAddress(<void*>&self.m1_m2_Phi_value)

        #print "making m1_m2_Pt"
        self.m1_m2_Pt_branch = the_tree.GetBranch("m1_m2_Pt")
        #if not self.m1_m2_Pt_branch and "m1_m2_Pt" not in self.complained:
        if not self.m1_m2_Pt_branch and "m1_m2_Pt":
            warnings.warn( "MuMuTauTauTree: Expected branch m1_m2_Pt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_m2_Pt")
        else:
            self.m1_m2_Pt_branch.SetAddress(<void*>&self.m1_m2_Pt_value)

        #print "making m1_m2_PtFsr"
        self.m1_m2_PtFsr_branch = the_tree.GetBranch("m1_m2_PtFsr")
        #if not self.m1_m2_PtFsr_branch and "m1_m2_PtFsr" not in self.complained:
        if not self.m1_m2_PtFsr_branch and "m1_m2_PtFsr":
            warnings.warn( "MuMuTauTauTree: Expected branch m1_m2_PtFsr does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_m2_PtFsr")
        else:
            self.m1_m2_PtFsr_branch.SetAddress(<void*>&self.m1_m2_PtFsr_value)

        #print "making m1_m2_SS"
        self.m1_m2_SS_branch = the_tree.GetBranch("m1_m2_SS")
        #if not self.m1_m2_SS_branch and "m1_m2_SS" not in self.complained:
        if not self.m1_m2_SS_branch and "m1_m2_SS":
            warnings.warn( "MuMuTauTauTree: Expected branch m1_m2_SS does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_m2_SS")
        else:
            self.m1_m2_SS_branch.SetAddress(<void*>&self.m1_m2_SS_value)

        #print "making m1_m2_ToMETDPhi_Ty1"
        self.m1_m2_ToMETDPhi_Ty1_branch = the_tree.GetBranch("m1_m2_ToMETDPhi_Ty1")
        #if not self.m1_m2_ToMETDPhi_Ty1_branch and "m1_m2_ToMETDPhi_Ty1" not in self.complained:
        if not self.m1_m2_ToMETDPhi_Ty1_branch and "m1_m2_ToMETDPhi_Ty1":
            warnings.warn( "MuMuTauTauTree: Expected branch m1_m2_ToMETDPhi_Ty1 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_m2_ToMETDPhi_Ty1")
        else:
            self.m1_m2_ToMETDPhi_Ty1_branch.SetAddress(<void*>&self.m1_m2_ToMETDPhi_Ty1_value)

        #print "making m1_m2_Zcompat"
        self.m1_m2_Zcompat_branch = the_tree.GetBranch("m1_m2_Zcompat")
        #if not self.m1_m2_Zcompat_branch and "m1_m2_Zcompat" not in self.complained:
        if not self.m1_m2_Zcompat_branch and "m1_m2_Zcompat":
            warnings.warn( "MuMuTauTauTree: Expected branch m1_m2_Zcompat does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_m2_Zcompat")
        else:
            self.m1_m2_Zcompat_branch.SetAddress(<void*>&self.m1_m2_Zcompat_value)

        #print "making m1_t1_CosThetaStar"
        self.m1_t1_CosThetaStar_branch = the_tree.GetBranch("m1_t1_CosThetaStar")
        #if not self.m1_t1_CosThetaStar_branch and "m1_t1_CosThetaStar" not in self.complained:
        if not self.m1_t1_CosThetaStar_branch and "m1_t1_CosThetaStar":
            warnings.warn( "MuMuTauTauTree: Expected branch m1_t1_CosThetaStar does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_t1_CosThetaStar")
        else:
            self.m1_t1_CosThetaStar_branch.SetAddress(<void*>&self.m1_t1_CosThetaStar_value)

        #print "making m1_t1_DPhi"
        self.m1_t1_DPhi_branch = the_tree.GetBranch("m1_t1_DPhi")
        #if not self.m1_t1_DPhi_branch and "m1_t1_DPhi" not in self.complained:
        if not self.m1_t1_DPhi_branch and "m1_t1_DPhi":
            warnings.warn( "MuMuTauTauTree: Expected branch m1_t1_DPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_t1_DPhi")
        else:
            self.m1_t1_DPhi_branch.SetAddress(<void*>&self.m1_t1_DPhi_value)

        #print "making m1_t1_DR"
        self.m1_t1_DR_branch = the_tree.GetBranch("m1_t1_DR")
        #if not self.m1_t1_DR_branch and "m1_t1_DR" not in self.complained:
        if not self.m1_t1_DR_branch and "m1_t1_DR":
            warnings.warn( "MuMuTauTauTree: Expected branch m1_t1_DR does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_t1_DR")
        else:
            self.m1_t1_DR_branch.SetAddress(<void*>&self.m1_t1_DR_value)

        #print "making m1_t1_Eta"
        self.m1_t1_Eta_branch = the_tree.GetBranch("m1_t1_Eta")
        #if not self.m1_t1_Eta_branch and "m1_t1_Eta" not in self.complained:
        if not self.m1_t1_Eta_branch and "m1_t1_Eta":
            warnings.warn( "MuMuTauTauTree: Expected branch m1_t1_Eta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_t1_Eta")
        else:
            self.m1_t1_Eta_branch.SetAddress(<void*>&self.m1_t1_Eta_value)

        #print "making m1_t1_Mass"
        self.m1_t1_Mass_branch = the_tree.GetBranch("m1_t1_Mass")
        #if not self.m1_t1_Mass_branch and "m1_t1_Mass" not in self.complained:
        if not self.m1_t1_Mass_branch and "m1_t1_Mass":
            warnings.warn( "MuMuTauTauTree: Expected branch m1_t1_Mass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_t1_Mass")
        else:
            self.m1_t1_Mass_branch.SetAddress(<void*>&self.m1_t1_Mass_value)

        #print "making m1_t1_MassFsr"
        self.m1_t1_MassFsr_branch = the_tree.GetBranch("m1_t1_MassFsr")
        #if not self.m1_t1_MassFsr_branch and "m1_t1_MassFsr" not in self.complained:
        if not self.m1_t1_MassFsr_branch and "m1_t1_MassFsr":
            warnings.warn( "MuMuTauTauTree: Expected branch m1_t1_MassFsr does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_t1_MassFsr")
        else:
            self.m1_t1_MassFsr_branch.SetAddress(<void*>&self.m1_t1_MassFsr_value)

        #print "making m1_t1_PZeta"
        self.m1_t1_PZeta_branch = the_tree.GetBranch("m1_t1_PZeta")
        #if not self.m1_t1_PZeta_branch and "m1_t1_PZeta" not in self.complained:
        if not self.m1_t1_PZeta_branch and "m1_t1_PZeta":
            warnings.warn( "MuMuTauTauTree: Expected branch m1_t1_PZeta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_t1_PZeta")
        else:
            self.m1_t1_PZeta_branch.SetAddress(<void*>&self.m1_t1_PZeta_value)

        #print "making m1_t1_PZetaVis"
        self.m1_t1_PZetaVis_branch = the_tree.GetBranch("m1_t1_PZetaVis")
        #if not self.m1_t1_PZetaVis_branch and "m1_t1_PZetaVis" not in self.complained:
        if not self.m1_t1_PZetaVis_branch and "m1_t1_PZetaVis":
            warnings.warn( "MuMuTauTauTree: Expected branch m1_t1_PZetaVis does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_t1_PZetaVis")
        else:
            self.m1_t1_PZetaVis_branch.SetAddress(<void*>&self.m1_t1_PZetaVis_value)

        #print "making m1_t1_Phi"
        self.m1_t1_Phi_branch = the_tree.GetBranch("m1_t1_Phi")
        #if not self.m1_t1_Phi_branch and "m1_t1_Phi" not in self.complained:
        if not self.m1_t1_Phi_branch and "m1_t1_Phi":
            warnings.warn( "MuMuTauTauTree: Expected branch m1_t1_Phi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_t1_Phi")
        else:
            self.m1_t1_Phi_branch.SetAddress(<void*>&self.m1_t1_Phi_value)

        #print "making m1_t1_Pt"
        self.m1_t1_Pt_branch = the_tree.GetBranch("m1_t1_Pt")
        #if not self.m1_t1_Pt_branch and "m1_t1_Pt" not in self.complained:
        if not self.m1_t1_Pt_branch and "m1_t1_Pt":
            warnings.warn( "MuMuTauTauTree: Expected branch m1_t1_Pt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_t1_Pt")
        else:
            self.m1_t1_Pt_branch.SetAddress(<void*>&self.m1_t1_Pt_value)

        #print "making m1_t1_PtFsr"
        self.m1_t1_PtFsr_branch = the_tree.GetBranch("m1_t1_PtFsr")
        #if not self.m1_t1_PtFsr_branch and "m1_t1_PtFsr" not in self.complained:
        if not self.m1_t1_PtFsr_branch and "m1_t1_PtFsr":
            warnings.warn( "MuMuTauTauTree: Expected branch m1_t1_PtFsr does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_t1_PtFsr")
        else:
            self.m1_t1_PtFsr_branch.SetAddress(<void*>&self.m1_t1_PtFsr_value)

        #print "making m1_t1_SS"
        self.m1_t1_SS_branch = the_tree.GetBranch("m1_t1_SS")
        #if not self.m1_t1_SS_branch and "m1_t1_SS" not in self.complained:
        if not self.m1_t1_SS_branch and "m1_t1_SS":
            warnings.warn( "MuMuTauTauTree: Expected branch m1_t1_SS does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_t1_SS")
        else:
            self.m1_t1_SS_branch.SetAddress(<void*>&self.m1_t1_SS_value)

        #print "making m1_t1_ToMETDPhi_Ty1"
        self.m1_t1_ToMETDPhi_Ty1_branch = the_tree.GetBranch("m1_t1_ToMETDPhi_Ty1")
        #if not self.m1_t1_ToMETDPhi_Ty1_branch and "m1_t1_ToMETDPhi_Ty1" not in self.complained:
        if not self.m1_t1_ToMETDPhi_Ty1_branch and "m1_t1_ToMETDPhi_Ty1":
            warnings.warn( "MuMuTauTauTree: Expected branch m1_t1_ToMETDPhi_Ty1 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_t1_ToMETDPhi_Ty1")
        else:
            self.m1_t1_ToMETDPhi_Ty1_branch.SetAddress(<void*>&self.m1_t1_ToMETDPhi_Ty1_value)

        #print "making m1_t1_Zcompat"
        self.m1_t1_Zcompat_branch = the_tree.GetBranch("m1_t1_Zcompat")
        #if not self.m1_t1_Zcompat_branch and "m1_t1_Zcompat" not in self.complained:
        if not self.m1_t1_Zcompat_branch and "m1_t1_Zcompat":
            warnings.warn( "MuMuTauTauTree: Expected branch m1_t1_Zcompat does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_t1_Zcompat")
        else:
            self.m1_t1_Zcompat_branch.SetAddress(<void*>&self.m1_t1_Zcompat_value)

        #print "making m1_t2_CosThetaStar"
        self.m1_t2_CosThetaStar_branch = the_tree.GetBranch("m1_t2_CosThetaStar")
        #if not self.m1_t2_CosThetaStar_branch and "m1_t2_CosThetaStar" not in self.complained:
        if not self.m1_t2_CosThetaStar_branch and "m1_t2_CosThetaStar":
            warnings.warn( "MuMuTauTauTree: Expected branch m1_t2_CosThetaStar does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_t2_CosThetaStar")
        else:
            self.m1_t2_CosThetaStar_branch.SetAddress(<void*>&self.m1_t2_CosThetaStar_value)

        #print "making m1_t2_DPhi"
        self.m1_t2_DPhi_branch = the_tree.GetBranch("m1_t2_DPhi")
        #if not self.m1_t2_DPhi_branch and "m1_t2_DPhi" not in self.complained:
        if not self.m1_t2_DPhi_branch and "m1_t2_DPhi":
            warnings.warn( "MuMuTauTauTree: Expected branch m1_t2_DPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_t2_DPhi")
        else:
            self.m1_t2_DPhi_branch.SetAddress(<void*>&self.m1_t2_DPhi_value)

        #print "making m1_t2_DR"
        self.m1_t2_DR_branch = the_tree.GetBranch("m1_t2_DR")
        #if not self.m1_t2_DR_branch and "m1_t2_DR" not in self.complained:
        if not self.m1_t2_DR_branch and "m1_t2_DR":
            warnings.warn( "MuMuTauTauTree: Expected branch m1_t2_DR does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_t2_DR")
        else:
            self.m1_t2_DR_branch.SetAddress(<void*>&self.m1_t2_DR_value)

        #print "making m1_t2_Eta"
        self.m1_t2_Eta_branch = the_tree.GetBranch("m1_t2_Eta")
        #if not self.m1_t2_Eta_branch and "m1_t2_Eta" not in self.complained:
        if not self.m1_t2_Eta_branch and "m1_t2_Eta":
            warnings.warn( "MuMuTauTauTree: Expected branch m1_t2_Eta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_t2_Eta")
        else:
            self.m1_t2_Eta_branch.SetAddress(<void*>&self.m1_t2_Eta_value)

        #print "making m1_t2_Mass"
        self.m1_t2_Mass_branch = the_tree.GetBranch("m1_t2_Mass")
        #if not self.m1_t2_Mass_branch and "m1_t2_Mass" not in self.complained:
        if not self.m1_t2_Mass_branch and "m1_t2_Mass":
            warnings.warn( "MuMuTauTauTree: Expected branch m1_t2_Mass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_t2_Mass")
        else:
            self.m1_t2_Mass_branch.SetAddress(<void*>&self.m1_t2_Mass_value)

        #print "making m1_t2_MassFsr"
        self.m1_t2_MassFsr_branch = the_tree.GetBranch("m1_t2_MassFsr")
        #if not self.m1_t2_MassFsr_branch and "m1_t2_MassFsr" not in self.complained:
        if not self.m1_t2_MassFsr_branch and "m1_t2_MassFsr":
            warnings.warn( "MuMuTauTauTree: Expected branch m1_t2_MassFsr does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_t2_MassFsr")
        else:
            self.m1_t2_MassFsr_branch.SetAddress(<void*>&self.m1_t2_MassFsr_value)

        #print "making m1_t2_PZeta"
        self.m1_t2_PZeta_branch = the_tree.GetBranch("m1_t2_PZeta")
        #if not self.m1_t2_PZeta_branch and "m1_t2_PZeta" not in self.complained:
        if not self.m1_t2_PZeta_branch and "m1_t2_PZeta":
            warnings.warn( "MuMuTauTauTree: Expected branch m1_t2_PZeta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_t2_PZeta")
        else:
            self.m1_t2_PZeta_branch.SetAddress(<void*>&self.m1_t2_PZeta_value)

        #print "making m1_t2_PZetaVis"
        self.m1_t2_PZetaVis_branch = the_tree.GetBranch("m1_t2_PZetaVis")
        #if not self.m1_t2_PZetaVis_branch and "m1_t2_PZetaVis" not in self.complained:
        if not self.m1_t2_PZetaVis_branch and "m1_t2_PZetaVis":
            warnings.warn( "MuMuTauTauTree: Expected branch m1_t2_PZetaVis does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_t2_PZetaVis")
        else:
            self.m1_t2_PZetaVis_branch.SetAddress(<void*>&self.m1_t2_PZetaVis_value)

        #print "making m1_t2_Phi"
        self.m1_t2_Phi_branch = the_tree.GetBranch("m1_t2_Phi")
        #if not self.m1_t2_Phi_branch and "m1_t2_Phi" not in self.complained:
        if not self.m1_t2_Phi_branch and "m1_t2_Phi":
            warnings.warn( "MuMuTauTauTree: Expected branch m1_t2_Phi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_t2_Phi")
        else:
            self.m1_t2_Phi_branch.SetAddress(<void*>&self.m1_t2_Phi_value)

        #print "making m1_t2_Pt"
        self.m1_t2_Pt_branch = the_tree.GetBranch("m1_t2_Pt")
        #if not self.m1_t2_Pt_branch and "m1_t2_Pt" not in self.complained:
        if not self.m1_t2_Pt_branch and "m1_t2_Pt":
            warnings.warn( "MuMuTauTauTree: Expected branch m1_t2_Pt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_t2_Pt")
        else:
            self.m1_t2_Pt_branch.SetAddress(<void*>&self.m1_t2_Pt_value)

        #print "making m1_t2_PtFsr"
        self.m1_t2_PtFsr_branch = the_tree.GetBranch("m1_t2_PtFsr")
        #if not self.m1_t2_PtFsr_branch and "m1_t2_PtFsr" not in self.complained:
        if not self.m1_t2_PtFsr_branch and "m1_t2_PtFsr":
            warnings.warn( "MuMuTauTauTree: Expected branch m1_t2_PtFsr does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_t2_PtFsr")
        else:
            self.m1_t2_PtFsr_branch.SetAddress(<void*>&self.m1_t2_PtFsr_value)

        #print "making m1_t2_SS"
        self.m1_t2_SS_branch = the_tree.GetBranch("m1_t2_SS")
        #if not self.m1_t2_SS_branch and "m1_t2_SS" not in self.complained:
        if not self.m1_t2_SS_branch and "m1_t2_SS":
            warnings.warn( "MuMuTauTauTree: Expected branch m1_t2_SS does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_t2_SS")
        else:
            self.m1_t2_SS_branch.SetAddress(<void*>&self.m1_t2_SS_value)

        #print "making m1_t2_ToMETDPhi_Ty1"
        self.m1_t2_ToMETDPhi_Ty1_branch = the_tree.GetBranch("m1_t2_ToMETDPhi_Ty1")
        #if not self.m1_t2_ToMETDPhi_Ty1_branch and "m1_t2_ToMETDPhi_Ty1" not in self.complained:
        if not self.m1_t2_ToMETDPhi_Ty1_branch and "m1_t2_ToMETDPhi_Ty1":
            warnings.warn( "MuMuTauTauTree: Expected branch m1_t2_ToMETDPhi_Ty1 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_t2_ToMETDPhi_Ty1")
        else:
            self.m1_t2_ToMETDPhi_Ty1_branch.SetAddress(<void*>&self.m1_t2_ToMETDPhi_Ty1_value)

        #print "making m1_t2_Zcompat"
        self.m1_t2_Zcompat_branch = the_tree.GetBranch("m1_t2_Zcompat")
        #if not self.m1_t2_Zcompat_branch and "m1_t2_Zcompat" not in self.complained:
        if not self.m1_t2_Zcompat_branch and "m1_t2_Zcompat":
            warnings.warn( "MuMuTauTauTree: Expected branch m1_t2_Zcompat does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_t2_Zcompat")
        else:
            self.m1_t2_Zcompat_branch.SetAddress(<void*>&self.m1_t2_Zcompat_value)

        #print "making m2AbsEta"
        self.m2AbsEta_branch = the_tree.GetBranch("m2AbsEta")
        #if not self.m2AbsEta_branch and "m2AbsEta" not in self.complained:
        if not self.m2AbsEta_branch and "m2AbsEta":
            warnings.warn( "MuMuTauTauTree: Expected branch m2AbsEta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2AbsEta")
        else:
            self.m2AbsEta_branch.SetAddress(<void*>&self.m2AbsEta_value)

        #print "making m2Charge"
        self.m2Charge_branch = the_tree.GetBranch("m2Charge")
        #if not self.m2Charge_branch and "m2Charge" not in self.complained:
        if not self.m2Charge_branch and "m2Charge":
            warnings.warn( "MuMuTauTauTree: Expected branch m2Charge does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2Charge")
        else:
            self.m2Charge_branch.SetAddress(<void*>&self.m2Charge_value)

        #print "making m2ComesFromHiggs"
        self.m2ComesFromHiggs_branch = the_tree.GetBranch("m2ComesFromHiggs")
        #if not self.m2ComesFromHiggs_branch and "m2ComesFromHiggs" not in self.complained:
        if not self.m2ComesFromHiggs_branch and "m2ComesFromHiggs":
            warnings.warn( "MuMuTauTauTree: Expected branch m2ComesFromHiggs does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2ComesFromHiggs")
        else:
            self.m2ComesFromHiggs_branch.SetAddress(<void*>&self.m2ComesFromHiggs_value)

        #print "making m2D0"
        self.m2D0_branch = the_tree.GetBranch("m2D0")
        #if not self.m2D0_branch and "m2D0" not in self.complained:
        if not self.m2D0_branch and "m2D0":
            warnings.warn( "MuMuTauTauTree: Expected branch m2D0 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2D0")
        else:
            self.m2D0_branch.SetAddress(<void*>&self.m2D0_value)

        #print "making m2DZ"
        self.m2DZ_branch = the_tree.GetBranch("m2DZ")
        #if not self.m2DZ_branch and "m2DZ" not in self.complained:
        if not self.m2DZ_branch and "m2DZ":
            warnings.warn( "MuMuTauTauTree: Expected branch m2DZ does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2DZ")
        else:
            self.m2DZ_branch.SetAddress(<void*>&self.m2DZ_value)

        #print "making m2DiMuonL3PreFiltered7"
        self.m2DiMuonL3PreFiltered7_branch = the_tree.GetBranch("m2DiMuonL3PreFiltered7")
        #if not self.m2DiMuonL3PreFiltered7_branch and "m2DiMuonL3PreFiltered7" not in self.complained:
        if not self.m2DiMuonL3PreFiltered7_branch and "m2DiMuonL3PreFiltered7":
            warnings.warn( "MuMuTauTauTree: Expected branch m2DiMuonL3PreFiltered7 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2DiMuonL3PreFiltered7")
        else:
            self.m2DiMuonL3PreFiltered7_branch.SetAddress(<void*>&self.m2DiMuonL3PreFiltered7_value)

        #print "making m2DiMuonL3p5PreFiltered8"
        self.m2DiMuonL3p5PreFiltered8_branch = the_tree.GetBranch("m2DiMuonL3p5PreFiltered8")
        #if not self.m2DiMuonL3p5PreFiltered8_branch and "m2DiMuonL3p5PreFiltered8" not in self.complained:
        if not self.m2DiMuonL3p5PreFiltered8_branch and "m2DiMuonL3p5PreFiltered8":
            warnings.warn( "MuMuTauTauTree: Expected branch m2DiMuonL3p5PreFiltered8 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2DiMuonL3p5PreFiltered8")
        else:
            self.m2DiMuonL3p5PreFiltered8_branch.SetAddress(<void*>&self.m2DiMuonL3p5PreFiltered8_value)

        #print "making m2DiMuonMu17Mu8DzFiltered0p2"
        self.m2DiMuonMu17Mu8DzFiltered0p2_branch = the_tree.GetBranch("m2DiMuonMu17Mu8DzFiltered0p2")
        #if not self.m2DiMuonMu17Mu8DzFiltered0p2_branch and "m2DiMuonMu17Mu8DzFiltered0p2" not in self.complained:
        if not self.m2DiMuonMu17Mu8DzFiltered0p2_branch and "m2DiMuonMu17Mu8DzFiltered0p2":
            warnings.warn( "MuMuTauTauTree: Expected branch m2DiMuonMu17Mu8DzFiltered0p2 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2DiMuonMu17Mu8DzFiltered0p2")
        else:
            self.m2DiMuonMu17Mu8DzFiltered0p2_branch.SetAddress(<void*>&self.m2DiMuonMu17Mu8DzFiltered0p2_value)

        #print "making m2EErrRochCor2011A"
        self.m2EErrRochCor2011A_branch = the_tree.GetBranch("m2EErrRochCor2011A")
        #if not self.m2EErrRochCor2011A_branch and "m2EErrRochCor2011A" not in self.complained:
        if not self.m2EErrRochCor2011A_branch and "m2EErrRochCor2011A":
            warnings.warn( "MuMuTauTauTree: Expected branch m2EErrRochCor2011A does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2EErrRochCor2011A")
        else:
            self.m2EErrRochCor2011A_branch.SetAddress(<void*>&self.m2EErrRochCor2011A_value)

        #print "making m2EErrRochCor2011B"
        self.m2EErrRochCor2011B_branch = the_tree.GetBranch("m2EErrRochCor2011B")
        #if not self.m2EErrRochCor2011B_branch and "m2EErrRochCor2011B" not in self.complained:
        if not self.m2EErrRochCor2011B_branch and "m2EErrRochCor2011B":
            warnings.warn( "MuMuTauTauTree: Expected branch m2EErrRochCor2011B does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2EErrRochCor2011B")
        else:
            self.m2EErrRochCor2011B_branch.SetAddress(<void*>&self.m2EErrRochCor2011B_value)

        #print "making m2EErrRochCor2012"
        self.m2EErrRochCor2012_branch = the_tree.GetBranch("m2EErrRochCor2012")
        #if not self.m2EErrRochCor2012_branch and "m2EErrRochCor2012" not in self.complained:
        if not self.m2EErrRochCor2012_branch and "m2EErrRochCor2012":
            warnings.warn( "MuMuTauTauTree: Expected branch m2EErrRochCor2012 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2EErrRochCor2012")
        else:
            self.m2EErrRochCor2012_branch.SetAddress(<void*>&self.m2EErrRochCor2012_value)

        #print "making m2ERochCor2011A"
        self.m2ERochCor2011A_branch = the_tree.GetBranch("m2ERochCor2011A")
        #if not self.m2ERochCor2011A_branch and "m2ERochCor2011A" not in self.complained:
        if not self.m2ERochCor2011A_branch and "m2ERochCor2011A":
            warnings.warn( "MuMuTauTauTree: Expected branch m2ERochCor2011A does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2ERochCor2011A")
        else:
            self.m2ERochCor2011A_branch.SetAddress(<void*>&self.m2ERochCor2011A_value)

        #print "making m2ERochCor2011B"
        self.m2ERochCor2011B_branch = the_tree.GetBranch("m2ERochCor2011B")
        #if not self.m2ERochCor2011B_branch and "m2ERochCor2011B" not in self.complained:
        if not self.m2ERochCor2011B_branch and "m2ERochCor2011B":
            warnings.warn( "MuMuTauTauTree: Expected branch m2ERochCor2011B does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2ERochCor2011B")
        else:
            self.m2ERochCor2011B_branch.SetAddress(<void*>&self.m2ERochCor2011B_value)

        #print "making m2ERochCor2012"
        self.m2ERochCor2012_branch = the_tree.GetBranch("m2ERochCor2012")
        #if not self.m2ERochCor2012_branch and "m2ERochCor2012" not in self.complained:
        if not self.m2ERochCor2012_branch and "m2ERochCor2012":
            warnings.warn( "MuMuTauTauTree: Expected branch m2ERochCor2012 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2ERochCor2012")
        else:
            self.m2ERochCor2012_branch.SetAddress(<void*>&self.m2ERochCor2012_value)

        #print "making m2EffectiveArea2011"
        self.m2EffectiveArea2011_branch = the_tree.GetBranch("m2EffectiveArea2011")
        #if not self.m2EffectiveArea2011_branch and "m2EffectiveArea2011" not in self.complained:
        if not self.m2EffectiveArea2011_branch and "m2EffectiveArea2011":
            warnings.warn( "MuMuTauTauTree: Expected branch m2EffectiveArea2011 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2EffectiveArea2011")
        else:
            self.m2EffectiveArea2011_branch.SetAddress(<void*>&self.m2EffectiveArea2011_value)

        #print "making m2EffectiveArea2012"
        self.m2EffectiveArea2012_branch = the_tree.GetBranch("m2EffectiveArea2012")
        #if not self.m2EffectiveArea2012_branch and "m2EffectiveArea2012" not in self.complained:
        if not self.m2EffectiveArea2012_branch and "m2EffectiveArea2012":
            warnings.warn( "MuMuTauTauTree: Expected branch m2EffectiveArea2012 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2EffectiveArea2012")
        else:
            self.m2EffectiveArea2012_branch.SetAddress(<void*>&self.m2EffectiveArea2012_value)

        #print "making m2Eta"
        self.m2Eta_branch = the_tree.GetBranch("m2Eta")
        #if not self.m2Eta_branch and "m2Eta" not in self.complained:
        if not self.m2Eta_branch and "m2Eta":
            warnings.warn( "MuMuTauTauTree: Expected branch m2Eta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2Eta")
        else:
            self.m2Eta_branch.SetAddress(<void*>&self.m2Eta_value)

        #print "making m2EtaRochCor2011A"
        self.m2EtaRochCor2011A_branch = the_tree.GetBranch("m2EtaRochCor2011A")
        #if not self.m2EtaRochCor2011A_branch and "m2EtaRochCor2011A" not in self.complained:
        if not self.m2EtaRochCor2011A_branch and "m2EtaRochCor2011A":
            warnings.warn( "MuMuTauTauTree: Expected branch m2EtaRochCor2011A does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2EtaRochCor2011A")
        else:
            self.m2EtaRochCor2011A_branch.SetAddress(<void*>&self.m2EtaRochCor2011A_value)

        #print "making m2EtaRochCor2011B"
        self.m2EtaRochCor2011B_branch = the_tree.GetBranch("m2EtaRochCor2011B")
        #if not self.m2EtaRochCor2011B_branch and "m2EtaRochCor2011B" not in self.complained:
        if not self.m2EtaRochCor2011B_branch and "m2EtaRochCor2011B":
            warnings.warn( "MuMuTauTauTree: Expected branch m2EtaRochCor2011B does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2EtaRochCor2011B")
        else:
            self.m2EtaRochCor2011B_branch.SetAddress(<void*>&self.m2EtaRochCor2011B_value)

        #print "making m2EtaRochCor2012"
        self.m2EtaRochCor2012_branch = the_tree.GetBranch("m2EtaRochCor2012")
        #if not self.m2EtaRochCor2012_branch and "m2EtaRochCor2012" not in self.complained:
        if not self.m2EtaRochCor2012_branch and "m2EtaRochCor2012":
            warnings.warn( "MuMuTauTauTree: Expected branch m2EtaRochCor2012 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2EtaRochCor2012")
        else:
            self.m2EtaRochCor2012_branch.SetAddress(<void*>&self.m2EtaRochCor2012_value)

        #print "making m2GenCharge"
        self.m2GenCharge_branch = the_tree.GetBranch("m2GenCharge")
        #if not self.m2GenCharge_branch and "m2GenCharge" not in self.complained:
        if not self.m2GenCharge_branch and "m2GenCharge":
            warnings.warn( "MuMuTauTauTree: Expected branch m2GenCharge does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2GenCharge")
        else:
            self.m2GenCharge_branch.SetAddress(<void*>&self.m2GenCharge_value)

        #print "making m2GenEnergy"
        self.m2GenEnergy_branch = the_tree.GetBranch("m2GenEnergy")
        #if not self.m2GenEnergy_branch and "m2GenEnergy" not in self.complained:
        if not self.m2GenEnergy_branch and "m2GenEnergy":
            warnings.warn( "MuMuTauTauTree: Expected branch m2GenEnergy does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2GenEnergy")
        else:
            self.m2GenEnergy_branch.SetAddress(<void*>&self.m2GenEnergy_value)

        #print "making m2GenEta"
        self.m2GenEta_branch = the_tree.GetBranch("m2GenEta")
        #if not self.m2GenEta_branch and "m2GenEta" not in self.complained:
        if not self.m2GenEta_branch and "m2GenEta":
            warnings.warn( "MuMuTauTauTree: Expected branch m2GenEta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2GenEta")
        else:
            self.m2GenEta_branch.SetAddress(<void*>&self.m2GenEta_value)

        #print "making m2GenMotherPdgId"
        self.m2GenMotherPdgId_branch = the_tree.GetBranch("m2GenMotherPdgId")
        #if not self.m2GenMotherPdgId_branch and "m2GenMotherPdgId" not in self.complained:
        if not self.m2GenMotherPdgId_branch and "m2GenMotherPdgId":
            warnings.warn( "MuMuTauTauTree: Expected branch m2GenMotherPdgId does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2GenMotherPdgId")
        else:
            self.m2GenMotherPdgId_branch.SetAddress(<void*>&self.m2GenMotherPdgId_value)

        #print "making m2GenPdgId"
        self.m2GenPdgId_branch = the_tree.GetBranch("m2GenPdgId")
        #if not self.m2GenPdgId_branch and "m2GenPdgId" not in self.complained:
        if not self.m2GenPdgId_branch and "m2GenPdgId":
            warnings.warn( "MuMuTauTauTree: Expected branch m2GenPdgId does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2GenPdgId")
        else:
            self.m2GenPdgId_branch.SetAddress(<void*>&self.m2GenPdgId_value)

        #print "making m2GenPhi"
        self.m2GenPhi_branch = the_tree.GetBranch("m2GenPhi")
        #if not self.m2GenPhi_branch and "m2GenPhi" not in self.complained:
        if not self.m2GenPhi_branch and "m2GenPhi":
            warnings.warn( "MuMuTauTauTree: Expected branch m2GenPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2GenPhi")
        else:
            self.m2GenPhi_branch.SetAddress(<void*>&self.m2GenPhi_value)

        #print "making m2GlbTrkHits"
        self.m2GlbTrkHits_branch = the_tree.GetBranch("m2GlbTrkHits")
        #if not self.m2GlbTrkHits_branch and "m2GlbTrkHits" not in self.complained:
        if not self.m2GlbTrkHits_branch and "m2GlbTrkHits":
            warnings.warn( "MuMuTauTauTree: Expected branch m2GlbTrkHits does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2GlbTrkHits")
        else:
            self.m2GlbTrkHits_branch.SetAddress(<void*>&self.m2GlbTrkHits_value)

        #print "making m2IDHZG2011"
        self.m2IDHZG2011_branch = the_tree.GetBranch("m2IDHZG2011")
        #if not self.m2IDHZG2011_branch and "m2IDHZG2011" not in self.complained:
        if not self.m2IDHZG2011_branch and "m2IDHZG2011":
            warnings.warn( "MuMuTauTauTree: Expected branch m2IDHZG2011 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2IDHZG2011")
        else:
            self.m2IDHZG2011_branch.SetAddress(<void*>&self.m2IDHZG2011_value)

        #print "making m2IDHZG2012"
        self.m2IDHZG2012_branch = the_tree.GetBranch("m2IDHZG2012")
        #if not self.m2IDHZG2012_branch and "m2IDHZG2012" not in self.complained:
        if not self.m2IDHZG2012_branch and "m2IDHZG2012":
            warnings.warn( "MuMuTauTauTree: Expected branch m2IDHZG2012 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2IDHZG2012")
        else:
            self.m2IDHZG2012_branch.SetAddress(<void*>&self.m2IDHZG2012_value)

        #print "making m2IP3DS"
        self.m2IP3DS_branch = the_tree.GetBranch("m2IP3DS")
        #if not self.m2IP3DS_branch and "m2IP3DS" not in self.complained:
        if not self.m2IP3DS_branch and "m2IP3DS":
            warnings.warn( "MuMuTauTauTree: Expected branch m2IP3DS does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2IP3DS")
        else:
            self.m2IP3DS_branch.SetAddress(<void*>&self.m2IP3DS_value)

        #print "making m2IsGlobal"
        self.m2IsGlobal_branch = the_tree.GetBranch("m2IsGlobal")
        #if not self.m2IsGlobal_branch and "m2IsGlobal" not in self.complained:
        if not self.m2IsGlobal_branch and "m2IsGlobal":
            warnings.warn( "MuMuTauTauTree: Expected branch m2IsGlobal does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2IsGlobal")
        else:
            self.m2IsGlobal_branch.SetAddress(<void*>&self.m2IsGlobal_value)

        #print "making m2IsPFMuon"
        self.m2IsPFMuon_branch = the_tree.GetBranch("m2IsPFMuon")
        #if not self.m2IsPFMuon_branch and "m2IsPFMuon" not in self.complained:
        if not self.m2IsPFMuon_branch and "m2IsPFMuon":
            warnings.warn( "MuMuTauTauTree: Expected branch m2IsPFMuon does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2IsPFMuon")
        else:
            self.m2IsPFMuon_branch.SetAddress(<void*>&self.m2IsPFMuon_value)

        #print "making m2IsTracker"
        self.m2IsTracker_branch = the_tree.GetBranch("m2IsTracker")
        #if not self.m2IsTracker_branch and "m2IsTracker" not in self.complained:
        if not self.m2IsTracker_branch and "m2IsTracker":
            warnings.warn( "MuMuTauTauTree: Expected branch m2IsTracker does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2IsTracker")
        else:
            self.m2IsTracker_branch.SetAddress(<void*>&self.m2IsTracker_value)

        #print "making m2JetArea"
        self.m2JetArea_branch = the_tree.GetBranch("m2JetArea")
        #if not self.m2JetArea_branch and "m2JetArea" not in self.complained:
        if not self.m2JetArea_branch and "m2JetArea":
            warnings.warn( "MuMuTauTauTree: Expected branch m2JetArea does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2JetArea")
        else:
            self.m2JetArea_branch.SetAddress(<void*>&self.m2JetArea_value)

        #print "making m2JetBtag"
        self.m2JetBtag_branch = the_tree.GetBranch("m2JetBtag")
        #if not self.m2JetBtag_branch and "m2JetBtag" not in self.complained:
        if not self.m2JetBtag_branch and "m2JetBtag":
            warnings.warn( "MuMuTauTauTree: Expected branch m2JetBtag does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2JetBtag")
        else:
            self.m2JetBtag_branch.SetAddress(<void*>&self.m2JetBtag_value)

        #print "making m2JetCSVBtag"
        self.m2JetCSVBtag_branch = the_tree.GetBranch("m2JetCSVBtag")
        #if not self.m2JetCSVBtag_branch and "m2JetCSVBtag" not in self.complained:
        if not self.m2JetCSVBtag_branch and "m2JetCSVBtag":
            warnings.warn( "MuMuTauTauTree: Expected branch m2JetCSVBtag does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2JetCSVBtag")
        else:
            self.m2JetCSVBtag_branch.SetAddress(<void*>&self.m2JetCSVBtag_value)

        #print "making m2JetEtaEtaMoment"
        self.m2JetEtaEtaMoment_branch = the_tree.GetBranch("m2JetEtaEtaMoment")
        #if not self.m2JetEtaEtaMoment_branch and "m2JetEtaEtaMoment" not in self.complained:
        if not self.m2JetEtaEtaMoment_branch and "m2JetEtaEtaMoment":
            warnings.warn( "MuMuTauTauTree: Expected branch m2JetEtaEtaMoment does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2JetEtaEtaMoment")
        else:
            self.m2JetEtaEtaMoment_branch.SetAddress(<void*>&self.m2JetEtaEtaMoment_value)

        #print "making m2JetEtaPhiMoment"
        self.m2JetEtaPhiMoment_branch = the_tree.GetBranch("m2JetEtaPhiMoment")
        #if not self.m2JetEtaPhiMoment_branch and "m2JetEtaPhiMoment" not in self.complained:
        if not self.m2JetEtaPhiMoment_branch and "m2JetEtaPhiMoment":
            warnings.warn( "MuMuTauTauTree: Expected branch m2JetEtaPhiMoment does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2JetEtaPhiMoment")
        else:
            self.m2JetEtaPhiMoment_branch.SetAddress(<void*>&self.m2JetEtaPhiMoment_value)

        #print "making m2JetEtaPhiSpread"
        self.m2JetEtaPhiSpread_branch = the_tree.GetBranch("m2JetEtaPhiSpread")
        #if not self.m2JetEtaPhiSpread_branch and "m2JetEtaPhiSpread" not in self.complained:
        if not self.m2JetEtaPhiSpread_branch and "m2JetEtaPhiSpread":
            warnings.warn( "MuMuTauTauTree: Expected branch m2JetEtaPhiSpread does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2JetEtaPhiSpread")
        else:
            self.m2JetEtaPhiSpread_branch.SetAddress(<void*>&self.m2JetEtaPhiSpread_value)

        #print "making m2JetPartonFlavour"
        self.m2JetPartonFlavour_branch = the_tree.GetBranch("m2JetPartonFlavour")
        #if not self.m2JetPartonFlavour_branch and "m2JetPartonFlavour" not in self.complained:
        if not self.m2JetPartonFlavour_branch and "m2JetPartonFlavour":
            warnings.warn( "MuMuTauTauTree: Expected branch m2JetPartonFlavour does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2JetPartonFlavour")
        else:
            self.m2JetPartonFlavour_branch.SetAddress(<void*>&self.m2JetPartonFlavour_value)

        #print "making m2JetPhiPhiMoment"
        self.m2JetPhiPhiMoment_branch = the_tree.GetBranch("m2JetPhiPhiMoment")
        #if not self.m2JetPhiPhiMoment_branch and "m2JetPhiPhiMoment" not in self.complained:
        if not self.m2JetPhiPhiMoment_branch and "m2JetPhiPhiMoment":
            warnings.warn( "MuMuTauTauTree: Expected branch m2JetPhiPhiMoment does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2JetPhiPhiMoment")
        else:
            self.m2JetPhiPhiMoment_branch.SetAddress(<void*>&self.m2JetPhiPhiMoment_value)

        #print "making m2JetPt"
        self.m2JetPt_branch = the_tree.GetBranch("m2JetPt")
        #if not self.m2JetPt_branch and "m2JetPt" not in self.complained:
        if not self.m2JetPt_branch and "m2JetPt":
            warnings.warn( "MuMuTauTauTree: Expected branch m2JetPt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2JetPt")
        else:
            self.m2JetPt_branch.SetAddress(<void*>&self.m2JetPt_value)

        #print "making m2JetQGLikelihoodID"
        self.m2JetQGLikelihoodID_branch = the_tree.GetBranch("m2JetQGLikelihoodID")
        #if not self.m2JetQGLikelihoodID_branch and "m2JetQGLikelihoodID" not in self.complained:
        if not self.m2JetQGLikelihoodID_branch and "m2JetQGLikelihoodID":
            warnings.warn( "MuMuTauTauTree: Expected branch m2JetQGLikelihoodID does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2JetQGLikelihoodID")
        else:
            self.m2JetQGLikelihoodID_branch.SetAddress(<void*>&self.m2JetQGLikelihoodID_value)

        #print "making m2JetQGMVAID"
        self.m2JetQGMVAID_branch = the_tree.GetBranch("m2JetQGMVAID")
        #if not self.m2JetQGMVAID_branch and "m2JetQGMVAID" not in self.complained:
        if not self.m2JetQGMVAID_branch and "m2JetQGMVAID":
            warnings.warn( "MuMuTauTauTree: Expected branch m2JetQGMVAID does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2JetQGMVAID")
        else:
            self.m2JetQGMVAID_branch.SetAddress(<void*>&self.m2JetQGMVAID_value)

        #print "making m2Jetaxis1"
        self.m2Jetaxis1_branch = the_tree.GetBranch("m2Jetaxis1")
        #if not self.m2Jetaxis1_branch and "m2Jetaxis1" not in self.complained:
        if not self.m2Jetaxis1_branch and "m2Jetaxis1":
            warnings.warn( "MuMuTauTauTree: Expected branch m2Jetaxis1 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2Jetaxis1")
        else:
            self.m2Jetaxis1_branch.SetAddress(<void*>&self.m2Jetaxis1_value)

        #print "making m2Jetaxis2"
        self.m2Jetaxis2_branch = the_tree.GetBranch("m2Jetaxis2")
        #if not self.m2Jetaxis2_branch and "m2Jetaxis2" not in self.complained:
        if not self.m2Jetaxis2_branch and "m2Jetaxis2":
            warnings.warn( "MuMuTauTauTree: Expected branch m2Jetaxis2 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2Jetaxis2")
        else:
            self.m2Jetaxis2_branch.SetAddress(<void*>&self.m2Jetaxis2_value)

        #print "making m2Jetmult"
        self.m2Jetmult_branch = the_tree.GetBranch("m2Jetmult")
        #if not self.m2Jetmult_branch and "m2Jetmult" not in self.complained:
        if not self.m2Jetmult_branch and "m2Jetmult":
            warnings.warn( "MuMuTauTauTree: Expected branch m2Jetmult does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2Jetmult")
        else:
            self.m2Jetmult_branch.SetAddress(<void*>&self.m2Jetmult_value)

        #print "making m2JetmultMLP"
        self.m2JetmultMLP_branch = the_tree.GetBranch("m2JetmultMLP")
        #if not self.m2JetmultMLP_branch and "m2JetmultMLP" not in self.complained:
        if not self.m2JetmultMLP_branch and "m2JetmultMLP":
            warnings.warn( "MuMuTauTauTree: Expected branch m2JetmultMLP does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2JetmultMLP")
        else:
            self.m2JetmultMLP_branch.SetAddress(<void*>&self.m2JetmultMLP_value)

        #print "making m2JetmultMLPQC"
        self.m2JetmultMLPQC_branch = the_tree.GetBranch("m2JetmultMLPQC")
        #if not self.m2JetmultMLPQC_branch and "m2JetmultMLPQC" not in self.complained:
        if not self.m2JetmultMLPQC_branch and "m2JetmultMLPQC":
            warnings.warn( "MuMuTauTauTree: Expected branch m2JetmultMLPQC does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2JetmultMLPQC")
        else:
            self.m2JetmultMLPQC_branch.SetAddress(<void*>&self.m2JetmultMLPQC_value)

        #print "making m2JetptD"
        self.m2JetptD_branch = the_tree.GetBranch("m2JetptD")
        #if not self.m2JetptD_branch and "m2JetptD" not in self.complained:
        if not self.m2JetptD_branch and "m2JetptD":
            warnings.warn( "MuMuTauTauTree: Expected branch m2JetptD does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2JetptD")
        else:
            self.m2JetptD_branch.SetAddress(<void*>&self.m2JetptD_value)

        #print "making m2L1Mu3EG5L3Filtered17"
        self.m2L1Mu3EG5L3Filtered17_branch = the_tree.GetBranch("m2L1Mu3EG5L3Filtered17")
        #if not self.m2L1Mu3EG5L3Filtered17_branch and "m2L1Mu3EG5L3Filtered17" not in self.complained:
        if not self.m2L1Mu3EG5L3Filtered17_branch and "m2L1Mu3EG5L3Filtered17":
            warnings.warn( "MuMuTauTauTree: Expected branch m2L1Mu3EG5L3Filtered17 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2L1Mu3EG5L3Filtered17")
        else:
            self.m2L1Mu3EG5L3Filtered17_branch.SetAddress(<void*>&self.m2L1Mu3EG5L3Filtered17_value)

        #print "making m2L3fL1DoubleMu10MuOpenL1f0L2f10L3Filtered17"
        self.m2L3fL1DoubleMu10MuOpenL1f0L2f10L3Filtered17_branch = the_tree.GetBranch("m2L3fL1DoubleMu10MuOpenL1f0L2f10L3Filtered17")
        #if not self.m2L3fL1DoubleMu10MuOpenL1f0L2f10L3Filtered17_branch and "m2L3fL1DoubleMu10MuOpenL1f0L2f10L3Filtered17" not in self.complained:
        if not self.m2L3fL1DoubleMu10MuOpenL1f0L2f10L3Filtered17_branch and "m2L3fL1DoubleMu10MuOpenL1f0L2f10L3Filtered17":
            warnings.warn( "MuMuTauTauTree: Expected branch m2L3fL1DoubleMu10MuOpenL1f0L2f10L3Filtered17 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2L3fL1DoubleMu10MuOpenL1f0L2f10L3Filtered17")
        else:
            self.m2L3fL1DoubleMu10MuOpenL1f0L2f10L3Filtered17_branch.SetAddress(<void*>&self.m2L3fL1DoubleMu10MuOpenL1f0L2f10L3Filtered17_value)

        #print "making m2Mass"
        self.m2Mass_branch = the_tree.GetBranch("m2Mass")
        #if not self.m2Mass_branch and "m2Mass" not in self.complained:
        if not self.m2Mass_branch and "m2Mass":
            warnings.warn( "MuMuTauTauTree: Expected branch m2Mass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2Mass")
        else:
            self.m2Mass_branch.SetAddress(<void*>&self.m2Mass_value)

        #print "making m2MatchedStations"
        self.m2MatchedStations_branch = the_tree.GetBranch("m2MatchedStations")
        #if not self.m2MatchedStations_branch and "m2MatchedStations" not in self.complained:
        if not self.m2MatchedStations_branch and "m2MatchedStations":
            warnings.warn( "MuMuTauTauTree: Expected branch m2MatchedStations does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2MatchedStations")
        else:
            self.m2MatchedStations_branch.SetAddress(<void*>&self.m2MatchedStations_value)

        #print "making m2MatchesDoubleMuPaths"
        self.m2MatchesDoubleMuPaths_branch = the_tree.GetBranch("m2MatchesDoubleMuPaths")
        #if not self.m2MatchesDoubleMuPaths_branch and "m2MatchesDoubleMuPaths" not in self.complained:
        if not self.m2MatchesDoubleMuPaths_branch and "m2MatchesDoubleMuPaths":
            warnings.warn( "MuMuTauTauTree: Expected branch m2MatchesDoubleMuPaths does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2MatchesDoubleMuPaths")
        else:
            self.m2MatchesDoubleMuPaths_branch.SetAddress(<void*>&self.m2MatchesDoubleMuPaths_value)

        #print "making m2MatchesDoubleMuTrkPaths"
        self.m2MatchesDoubleMuTrkPaths_branch = the_tree.GetBranch("m2MatchesDoubleMuTrkPaths")
        #if not self.m2MatchesDoubleMuTrkPaths_branch and "m2MatchesDoubleMuTrkPaths" not in self.complained:
        if not self.m2MatchesDoubleMuTrkPaths_branch and "m2MatchesDoubleMuTrkPaths":
            warnings.warn( "MuMuTauTauTree: Expected branch m2MatchesDoubleMuTrkPaths does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2MatchesDoubleMuTrkPaths")
        else:
            self.m2MatchesDoubleMuTrkPaths_branch.SetAddress(<void*>&self.m2MatchesDoubleMuTrkPaths_value)

        #print "making m2MatchesIsoMu24eta2p1"
        self.m2MatchesIsoMu24eta2p1_branch = the_tree.GetBranch("m2MatchesIsoMu24eta2p1")
        #if not self.m2MatchesIsoMu24eta2p1_branch and "m2MatchesIsoMu24eta2p1" not in self.complained:
        if not self.m2MatchesIsoMu24eta2p1_branch and "m2MatchesIsoMu24eta2p1":
            warnings.warn( "MuMuTauTauTree: Expected branch m2MatchesIsoMu24eta2p1 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2MatchesIsoMu24eta2p1")
        else:
            self.m2MatchesIsoMu24eta2p1_branch.SetAddress(<void*>&self.m2MatchesIsoMu24eta2p1_value)

        #print "making m2MatchesIsoMuGroup"
        self.m2MatchesIsoMuGroup_branch = the_tree.GetBranch("m2MatchesIsoMuGroup")
        #if not self.m2MatchesIsoMuGroup_branch and "m2MatchesIsoMuGroup" not in self.complained:
        if not self.m2MatchesIsoMuGroup_branch and "m2MatchesIsoMuGroup":
            warnings.warn( "MuMuTauTauTree: Expected branch m2MatchesIsoMuGroup does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2MatchesIsoMuGroup")
        else:
            self.m2MatchesIsoMuGroup_branch.SetAddress(<void*>&self.m2MatchesIsoMuGroup_value)

        #print "making m2MatchesMu17Ele8IsoPath"
        self.m2MatchesMu17Ele8IsoPath_branch = the_tree.GetBranch("m2MatchesMu17Ele8IsoPath")
        #if not self.m2MatchesMu17Ele8IsoPath_branch and "m2MatchesMu17Ele8IsoPath" not in self.complained:
        if not self.m2MatchesMu17Ele8IsoPath_branch and "m2MatchesMu17Ele8IsoPath":
            warnings.warn( "MuMuTauTauTree: Expected branch m2MatchesMu17Ele8IsoPath does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2MatchesMu17Ele8IsoPath")
        else:
            self.m2MatchesMu17Ele8IsoPath_branch.SetAddress(<void*>&self.m2MatchesMu17Ele8IsoPath_value)

        #print "making m2MatchesMu17Ele8Path"
        self.m2MatchesMu17Ele8Path_branch = the_tree.GetBranch("m2MatchesMu17Ele8Path")
        #if not self.m2MatchesMu17Ele8Path_branch and "m2MatchesMu17Ele8Path" not in self.complained:
        if not self.m2MatchesMu17Ele8Path_branch and "m2MatchesMu17Ele8Path":
            warnings.warn( "MuMuTauTauTree: Expected branch m2MatchesMu17Ele8Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2MatchesMu17Ele8Path")
        else:
            self.m2MatchesMu17Ele8Path_branch.SetAddress(<void*>&self.m2MatchesMu17Ele8Path_value)

        #print "making m2MatchesMu17Mu8Path"
        self.m2MatchesMu17Mu8Path_branch = the_tree.GetBranch("m2MatchesMu17Mu8Path")
        #if not self.m2MatchesMu17Mu8Path_branch and "m2MatchesMu17Mu8Path" not in self.complained:
        if not self.m2MatchesMu17Mu8Path_branch and "m2MatchesMu17Mu8Path":
            warnings.warn( "MuMuTauTauTree: Expected branch m2MatchesMu17Mu8Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2MatchesMu17Mu8Path")
        else:
            self.m2MatchesMu17Mu8Path_branch.SetAddress(<void*>&self.m2MatchesMu17Mu8Path_value)

        #print "making m2MatchesMu17TrkMu8Path"
        self.m2MatchesMu17TrkMu8Path_branch = the_tree.GetBranch("m2MatchesMu17TrkMu8Path")
        #if not self.m2MatchesMu17TrkMu8Path_branch and "m2MatchesMu17TrkMu8Path" not in self.complained:
        if not self.m2MatchesMu17TrkMu8Path_branch and "m2MatchesMu17TrkMu8Path":
            warnings.warn( "MuMuTauTauTree: Expected branch m2MatchesMu17TrkMu8Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2MatchesMu17TrkMu8Path")
        else:
            self.m2MatchesMu17TrkMu8Path_branch.SetAddress(<void*>&self.m2MatchesMu17TrkMu8Path_value)

        #print "making m2MatchesMu8Ele17IsoPath"
        self.m2MatchesMu8Ele17IsoPath_branch = the_tree.GetBranch("m2MatchesMu8Ele17IsoPath")
        #if not self.m2MatchesMu8Ele17IsoPath_branch and "m2MatchesMu8Ele17IsoPath" not in self.complained:
        if not self.m2MatchesMu8Ele17IsoPath_branch and "m2MatchesMu8Ele17IsoPath":
            warnings.warn( "MuMuTauTauTree: Expected branch m2MatchesMu8Ele17IsoPath does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2MatchesMu8Ele17IsoPath")
        else:
            self.m2MatchesMu8Ele17IsoPath_branch.SetAddress(<void*>&self.m2MatchesMu8Ele17IsoPath_value)

        #print "making m2MatchesMu8Ele17Path"
        self.m2MatchesMu8Ele17Path_branch = the_tree.GetBranch("m2MatchesMu8Ele17Path")
        #if not self.m2MatchesMu8Ele17Path_branch and "m2MatchesMu8Ele17Path" not in self.complained:
        if not self.m2MatchesMu8Ele17Path_branch and "m2MatchesMu8Ele17Path":
            warnings.warn( "MuMuTauTauTree: Expected branch m2MatchesMu8Ele17Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2MatchesMu8Ele17Path")
        else:
            self.m2MatchesMu8Ele17Path_branch.SetAddress(<void*>&self.m2MatchesMu8Ele17Path_value)

        #print "making m2MtToMET"
        self.m2MtToMET_branch = the_tree.GetBranch("m2MtToMET")
        #if not self.m2MtToMET_branch and "m2MtToMET" not in self.complained:
        if not self.m2MtToMET_branch and "m2MtToMET":
            warnings.warn( "MuMuTauTauTree: Expected branch m2MtToMET does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2MtToMET")
        else:
            self.m2MtToMET_branch.SetAddress(<void*>&self.m2MtToMET_value)

        #print "making m2MtToMVAMET"
        self.m2MtToMVAMET_branch = the_tree.GetBranch("m2MtToMVAMET")
        #if not self.m2MtToMVAMET_branch and "m2MtToMVAMET" not in self.complained:
        if not self.m2MtToMVAMET_branch and "m2MtToMVAMET":
            warnings.warn( "MuMuTauTauTree: Expected branch m2MtToMVAMET does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2MtToMVAMET")
        else:
            self.m2MtToMVAMET_branch.SetAddress(<void*>&self.m2MtToMVAMET_value)

        #print "making m2MtToPFMET"
        self.m2MtToPFMET_branch = the_tree.GetBranch("m2MtToPFMET")
        #if not self.m2MtToPFMET_branch and "m2MtToPFMET" not in self.complained:
        if not self.m2MtToPFMET_branch and "m2MtToPFMET":
            warnings.warn( "MuMuTauTauTree: Expected branch m2MtToPFMET does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2MtToPFMET")
        else:
            self.m2MtToPFMET_branch.SetAddress(<void*>&self.m2MtToPFMET_value)

        #print "making m2MtToPfMet_Ty1"
        self.m2MtToPfMet_Ty1_branch = the_tree.GetBranch("m2MtToPfMet_Ty1")
        #if not self.m2MtToPfMet_Ty1_branch and "m2MtToPfMet_Ty1" not in self.complained:
        if not self.m2MtToPfMet_Ty1_branch and "m2MtToPfMet_Ty1":
            warnings.warn( "MuMuTauTauTree: Expected branch m2MtToPfMet_Ty1 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2MtToPfMet_Ty1")
        else:
            self.m2MtToPfMet_Ty1_branch.SetAddress(<void*>&self.m2MtToPfMet_Ty1_value)

        #print "making m2MtToPfMet_jes"
        self.m2MtToPfMet_jes_branch = the_tree.GetBranch("m2MtToPfMet_jes")
        #if not self.m2MtToPfMet_jes_branch and "m2MtToPfMet_jes" not in self.complained:
        if not self.m2MtToPfMet_jes_branch and "m2MtToPfMet_jes":
            warnings.warn( "MuMuTauTauTree: Expected branch m2MtToPfMet_jes does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2MtToPfMet_jes")
        else:
            self.m2MtToPfMet_jes_branch.SetAddress(<void*>&self.m2MtToPfMet_jes_value)

        #print "making m2MtToPfMet_mes"
        self.m2MtToPfMet_mes_branch = the_tree.GetBranch("m2MtToPfMet_mes")
        #if not self.m2MtToPfMet_mes_branch and "m2MtToPfMet_mes" not in self.complained:
        if not self.m2MtToPfMet_mes_branch and "m2MtToPfMet_mes":
            warnings.warn( "MuMuTauTauTree: Expected branch m2MtToPfMet_mes does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2MtToPfMet_mes")
        else:
            self.m2MtToPfMet_mes_branch.SetAddress(<void*>&self.m2MtToPfMet_mes_value)

        #print "making m2MtToPfMet_tes"
        self.m2MtToPfMet_tes_branch = the_tree.GetBranch("m2MtToPfMet_tes")
        #if not self.m2MtToPfMet_tes_branch and "m2MtToPfMet_tes" not in self.complained:
        if not self.m2MtToPfMet_tes_branch and "m2MtToPfMet_tes":
            warnings.warn( "MuMuTauTauTree: Expected branch m2MtToPfMet_tes does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2MtToPfMet_tes")
        else:
            self.m2MtToPfMet_tes_branch.SetAddress(<void*>&self.m2MtToPfMet_tes_value)

        #print "making m2MtToPfMet_ues"
        self.m2MtToPfMet_ues_branch = the_tree.GetBranch("m2MtToPfMet_ues")
        #if not self.m2MtToPfMet_ues_branch and "m2MtToPfMet_ues" not in self.complained:
        if not self.m2MtToPfMet_ues_branch and "m2MtToPfMet_ues":
            warnings.warn( "MuMuTauTauTree: Expected branch m2MtToPfMet_ues does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2MtToPfMet_ues")
        else:
            self.m2MtToPfMet_ues_branch.SetAddress(<void*>&self.m2MtToPfMet_ues_value)

        #print "making m2Mu17Ele8dZFilter"
        self.m2Mu17Ele8dZFilter_branch = the_tree.GetBranch("m2Mu17Ele8dZFilter")
        #if not self.m2Mu17Ele8dZFilter_branch and "m2Mu17Ele8dZFilter" not in self.complained:
        if not self.m2Mu17Ele8dZFilter_branch and "m2Mu17Ele8dZFilter":
            warnings.warn( "MuMuTauTauTree: Expected branch m2Mu17Ele8dZFilter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2Mu17Ele8dZFilter")
        else:
            self.m2Mu17Ele8dZFilter_branch.SetAddress(<void*>&self.m2Mu17Ele8dZFilter_value)

        #print "making m2MuonHits"
        self.m2MuonHits_branch = the_tree.GetBranch("m2MuonHits")
        #if not self.m2MuonHits_branch and "m2MuonHits" not in self.complained:
        if not self.m2MuonHits_branch and "m2MuonHits":
            warnings.warn( "MuMuTauTauTree: Expected branch m2MuonHits does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2MuonHits")
        else:
            self.m2MuonHits_branch.SetAddress(<void*>&self.m2MuonHits_value)

        #print "making m2NormTrkChi2"
        self.m2NormTrkChi2_branch = the_tree.GetBranch("m2NormTrkChi2")
        #if not self.m2NormTrkChi2_branch and "m2NormTrkChi2" not in self.complained:
        if not self.m2NormTrkChi2_branch and "m2NormTrkChi2":
            warnings.warn( "MuMuTauTauTree: Expected branch m2NormTrkChi2 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2NormTrkChi2")
        else:
            self.m2NormTrkChi2_branch.SetAddress(<void*>&self.m2NormTrkChi2_value)

        #print "making m2PFChargedIso"
        self.m2PFChargedIso_branch = the_tree.GetBranch("m2PFChargedIso")
        #if not self.m2PFChargedIso_branch and "m2PFChargedIso" not in self.complained:
        if not self.m2PFChargedIso_branch and "m2PFChargedIso":
            warnings.warn( "MuMuTauTauTree: Expected branch m2PFChargedIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2PFChargedIso")
        else:
            self.m2PFChargedIso_branch.SetAddress(<void*>&self.m2PFChargedIso_value)

        #print "making m2PFIDTight"
        self.m2PFIDTight_branch = the_tree.GetBranch("m2PFIDTight")
        #if not self.m2PFIDTight_branch and "m2PFIDTight" not in self.complained:
        if not self.m2PFIDTight_branch and "m2PFIDTight":
            warnings.warn( "MuMuTauTauTree: Expected branch m2PFIDTight does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2PFIDTight")
        else:
            self.m2PFIDTight_branch.SetAddress(<void*>&self.m2PFIDTight_value)

        #print "making m2PFNeutralIso"
        self.m2PFNeutralIso_branch = the_tree.GetBranch("m2PFNeutralIso")
        #if not self.m2PFNeutralIso_branch and "m2PFNeutralIso" not in self.complained:
        if not self.m2PFNeutralIso_branch and "m2PFNeutralIso":
            warnings.warn( "MuMuTauTauTree: Expected branch m2PFNeutralIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2PFNeutralIso")
        else:
            self.m2PFNeutralIso_branch.SetAddress(<void*>&self.m2PFNeutralIso_value)

        #print "making m2PFPUChargedIso"
        self.m2PFPUChargedIso_branch = the_tree.GetBranch("m2PFPUChargedIso")
        #if not self.m2PFPUChargedIso_branch and "m2PFPUChargedIso" not in self.complained:
        if not self.m2PFPUChargedIso_branch and "m2PFPUChargedIso":
            warnings.warn( "MuMuTauTauTree: Expected branch m2PFPUChargedIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2PFPUChargedIso")
        else:
            self.m2PFPUChargedIso_branch.SetAddress(<void*>&self.m2PFPUChargedIso_value)

        #print "making m2PFPhotonIso"
        self.m2PFPhotonIso_branch = the_tree.GetBranch("m2PFPhotonIso")
        #if not self.m2PFPhotonIso_branch and "m2PFPhotonIso" not in self.complained:
        if not self.m2PFPhotonIso_branch and "m2PFPhotonIso":
            warnings.warn( "MuMuTauTauTree: Expected branch m2PFPhotonIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2PFPhotonIso")
        else:
            self.m2PFPhotonIso_branch.SetAddress(<void*>&self.m2PFPhotonIso_value)

        #print "making m2PVDXY"
        self.m2PVDXY_branch = the_tree.GetBranch("m2PVDXY")
        #if not self.m2PVDXY_branch and "m2PVDXY" not in self.complained:
        if not self.m2PVDXY_branch and "m2PVDXY":
            warnings.warn( "MuMuTauTauTree: Expected branch m2PVDXY does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2PVDXY")
        else:
            self.m2PVDXY_branch.SetAddress(<void*>&self.m2PVDXY_value)

        #print "making m2PVDZ"
        self.m2PVDZ_branch = the_tree.GetBranch("m2PVDZ")
        #if not self.m2PVDZ_branch and "m2PVDZ" not in self.complained:
        if not self.m2PVDZ_branch and "m2PVDZ":
            warnings.warn( "MuMuTauTauTree: Expected branch m2PVDZ does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2PVDZ")
        else:
            self.m2PVDZ_branch.SetAddress(<void*>&self.m2PVDZ_value)

        #print "making m2Phi"
        self.m2Phi_branch = the_tree.GetBranch("m2Phi")
        #if not self.m2Phi_branch and "m2Phi" not in self.complained:
        if not self.m2Phi_branch and "m2Phi":
            warnings.warn( "MuMuTauTauTree: Expected branch m2Phi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2Phi")
        else:
            self.m2Phi_branch.SetAddress(<void*>&self.m2Phi_value)

        #print "making m2PhiRochCor2011A"
        self.m2PhiRochCor2011A_branch = the_tree.GetBranch("m2PhiRochCor2011A")
        #if not self.m2PhiRochCor2011A_branch and "m2PhiRochCor2011A" not in self.complained:
        if not self.m2PhiRochCor2011A_branch and "m2PhiRochCor2011A":
            warnings.warn( "MuMuTauTauTree: Expected branch m2PhiRochCor2011A does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2PhiRochCor2011A")
        else:
            self.m2PhiRochCor2011A_branch.SetAddress(<void*>&self.m2PhiRochCor2011A_value)

        #print "making m2PhiRochCor2011B"
        self.m2PhiRochCor2011B_branch = the_tree.GetBranch("m2PhiRochCor2011B")
        #if not self.m2PhiRochCor2011B_branch and "m2PhiRochCor2011B" not in self.complained:
        if not self.m2PhiRochCor2011B_branch and "m2PhiRochCor2011B":
            warnings.warn( "MuMuTauTauTree: Expected branch m2PhiRochCor2011B does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2PhiRochCor2011B")
        else:
            self.m2PhiRochCor2011B_branch.SetAddress(<void*>&self.m2PhiRochCor2011B_value)

        #print "making m2PhiRochCor2012"
        self.m2PhiRochCor2012_branch = the_tree.GetBranch("m2PhiRochCor2012")
        #if not self.m2PhiRochCor2012_branch and "m2PhiRochCor2012" not in self.complained:
        if not self.m2PhiRochCor2012_branch and "m2PhiRochCor2012":
            warnings.warn( "MuMuTauTauTree: Expected branch m2PhiRochCor2012 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2PhiRochCor2012")
        else:
            self.m2PhiRochCor2012_branch.SetAddress(<void*>&self.m2PhiRochCor2012_value)

        #print "making m2PixHits"
        self.m2PixHits_branch = the_tree.GetBranch("m2PixHits")
        #if not self.m2PixHits_branch and "m2PixHits" not in self.complained:
        if not self.m2PixHits_branch and "m2PixHits":
            warnings.warn( "MuMuTauTauTree: Expected branch m2PixHits does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2PixHits")
        else:
            self.m2PixHits_branch.SetAddress(<void*>&self.m2PixHits_value)

        #print "making m2Pt"
        self.m2Pt_branch = the_tree.GetBranch("m2Pt")
        #if not self.m2Pt_branch and "m2Pt" not in self.complained:
        if not self.m2Pt_branch and "m2Pt":
            warnings.warn( "MuMuTauTauTree: Expected branch m2Pt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2Pt")
        else:
            self.m2Pt_branch.SetAddress(<void*>&self.m2Pt_value)

        #print "making m2PtRochCor2011A"
        self.m2PtRochCor2011A_branch = the_tree.GetBranch("m2PtRochCor2011A")
        #if not self.m2PtRochCor2011A_branch and "m2PtRochCor2011A" not in self.complained:
        if not self.m2PtRochCor2011A_branch and "m2PtRochCor2011A":
            warnings.warn( "MuMuTauTauTree: Expected branch m2PtRochCor2011A does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2PtRochCor2011A")
        else:
            self.m2PtRochCor2011A_branch.SetAddress(<void*>&self.m2PtRochCor2011A_value)

        #print "making m2PtRochCor2011B"
        self.m2PtRochCor2011B_branch = the_tree.GetBranch("m2PtRochCor2011B")
        #if not self.m2PtRochCor2011B_branch and "m2PtRochCor2011B" not in self.complained:
        if not self.m2PtRochCor2011B_branch and "m2PtRochCor2011B":
            warnings.warn( "MuMuTauTauTree: Expected branch m2PtRochCor2011B does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2PtRochCor2011B")
        else:
            self.m2PtRochCor2011B_branch.SetAddress(<void*>&self.m2PtRochCor2011B_value)

        #print "making m2PtRochCor2012"
        self.m2PtRochCor2012_branch = the_tree.GetBranch("m2PtRochCor2012")
        #if not self.m2PtRochCor2012_branch and "m2PtRochCor2012" not in self.complained:
        if not self.m2PtRochCor2012_branch and "m2PtRochCor2012":
            warnings.warn( "MuMuTauTauTree: Expected branch m2PtRochCor2012 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2PtRochCor2012")
        else:
            self.m2PtRochCor2012_branch.SetAddress(<void*>&self.m2PtRochCor2012_value)

        #print "making m2Rank"
        self.m2Rank_branch = the_tree.GetBranch("m2Rank")
        #if not self.m2Rank_branch and "m2Rank" not in self.complained:
        if not self.m2Rank_branch and "m2Rank":
            warnings.warn( "MuMuTauTauTree: Expected branch m2Rank does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2Rank")
        else:
            self.m2Rank_branch.SetAddress(<void*>&self.m2Rank_value)

        #print "making m2RelPFIsoDB"
        self.m2RelPFIsoDB_branch = the_tree.GetBranch("m2RelPFIsoDB")
        #if not self.m2RelPFIsoDB_branch and "m2RelPFIsoDB" not in self.complained:
        if not self.m2RelPFIsoDB_branch and "m2RelPFIsoDB":
            warnings.warn( "MuMuTauTauTree: Expected branch m2RelPFIsoDB does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2RelPFIsoDB")
        else:
            self.m2RelPFIsoDB_branch.SetAddress(<void*>&self.m2RelPFIsoDB_value)

        #print "making m2RelPFIsoRho"
        self.m2RelPFIsoRho_branch = the_tree.GetBranch("m2RelPFIsoRho")
        #if not self.m2RelPFIsoRho_branch and "m2RelPFIsoRho" not in self.complained:
        if not self.m2RelPFIsoRho_branch and "m2RelPFIsoRho":
            warnings.warn( "MuMuTauTauTree: Expected branch m2RelPFIsoRho does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2RelPFIsoRho")
        else:
            self.m2RelPFIsoRho_branch.SetAddress(<void*>&self.m2RelPFIsoRho_value)

        #print "making m2RelPFIsoRhoFSR"
        self.m2RelPFIsoRhoFSR_branch = the_tree.GetBranch("m2RelPFIsoRhoFSR")
        #if not self.m2RelPFIsoRhoFSR_branch and "m2RelPFIsoRhoFSR" not in self.complained:
        if not self.m2RelPFIsoRhoFSR_branch and "m2RelPFIsoRhoFSR":
            warnings.warn( "MuMuTauTauTree: Expected branch m2RelPFIsoRhoFSR does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2RelPFIsoRhoFSR")
        else:
            self.m2RelPFIsoRhoFSR_branch.SetAddress(<void*>&self.m2RelPFIsoRhoFSR_value)

        #print "making m2RhoHZG2011"
        self.m2RhoHZG2011_branch = the_tree.GetBranch("m2RhoHZG2011")
        #if not self.m2RhoHZG2011_branch and "m2RhoHZG2011" not in self.complained:
        if not self.m2RhoHZG2011_branch and "m2RhoHZG2011":
            warnings.warn( "MuMuTauTauTree: Expected branch m2RhoHZG2011 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2RhoHZG2011")
        else:
            self.m2RhoHZG2011_branch.SetAddress(<void*>&self.m2RhoHZG2011_value)

        #print "making m2RhoHZG2012"
        self.m2RhoHZG2012_branch = the_tree.GetBranch("m2RhoHZG2012")
        #if not self.m2RhoHZG2012_branch and "m2RhoHZG2012" not in self.complained:
        if not self.m2RhoHZG2012_branch and "m2RhoHZG2012":
            warnings.warn( "MuMuTauTauTree: Expected branch m2RhoHZG2012 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2RhoHZG2012")
        else:
            self.m2RhoHZG2012_branch.SetAddress(<void*>&self.m2RhoHZG2012_value)

        #print "making m2SingleMu13L3Filtered13"
        self.m2SingleMu13L3Filtered13_branch = the_tree.GetBranch("m2SingleMu13L3Filtered13")
        #if not self.m2SingleMu13L3Filtered13_branch and "m2SingleMu13L3Filtered13" not in self.complained:
        if not self.m2SingleMu13L3Filtered13_branch and "m2SingleMu13L3Filtered13":
            warnings.warn( "MuMuTauTauTree: Expected branch m2SingleMu13L3Filtered13 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2SingleMu13L3Filtered13")
        else:
            self.m2SingleMu13L3Filtered13_branch.SetAddress(<void*>&self.m2SingleMu13L3Filtered13_value)

        #print "making m2SingleMu13L3Filtered17"
        self.m2SingleMu13L3Filtered17_branch = the_tree.GetBranch("m2SingleMu13L3Filtered17")
        #if not self.m2SingleMu13L3Filtered17_branch and "m2SingleMu13L3Filtered17" not in self.complained:
        if not self.m2SingleMu13L3Filtered17_branch and "m2SingleMu13L3Filtered17":
            warnings.warn( "MuMuTauTauTree: Expected branch m2SingleMu13L3Filtered17 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2SingleMu13L3Filtered17")
        else:
            self.m2SingleMu13L3Filtered17_branch.SetAddress(<void*>&self.m2SingleMu13L3Filtered17_value)

        #print "making m2TkLayersWithMeasurement"
        self.m2TkLayersWithMeasurement_branch = the_tree.GetBranch("m2TkLayersWithMeasurement")
        #if not self.m2TkLayersWithMeasurement_branch and "m2TkLayersWithMeasurement" not in self.complained:
        if not self.m2TkLayersWithMeasurement_branch and "m2TkLayersWithMeasurement":
            warnings.warn( "MuMuTauTauTree: Expected branch m2TkLayersWithMeasurement does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2TkLayersWithMeasurement")
        else:
            self.m2TkLayersWithMeasurement_branch.SetAddress(<void*>&self.m2TkLayersWithMeasurement_value)

        #print "making m2ToMETDPhi"
        self.m2ToMETDPhi_branch = the_tree.GetBranch("m2ToMETDPhi")
        #if not self.m2ToMETDPhi_branch and "m2ToMETDPhi" not in self.complained:
        if not self.m2ToMETDPhi_branch and "m2ToMETDPhi":
            warnings.warn( "MuMuTauTauTree: Expected branch m2ToMETDPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2ToMETDPhi")
        else:
            self.m2ToMETDPhi_branch.SetAddress(<void*>&self.m2ToMETDPhi_value)

        #print "making m2TypeCode"
        self.m2TypeCode_branch = the_tree.GetBranch("m2TypeCode")
        #if not self.m2TypeCode_branch and "m2TypeCode" not in self.complained:
        if not self.m2TypeCode_branch and "m2TypeCode":
            warnings.warn( "MuMuTauTauTree: Expected branch m2TypeCode does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2TypeCode")
        else:
            self.m2TypeCode_branch.SetAddress(<void*>&self.m2TypeCode_value)

        #print "making m2VBTFID"
        self.m2VBTFID_branch = the_tree.GetBranch("m2VBTFID")
        #if not self.m2VBTFID_branch and "m2VBTFID" not in self.complained:
        if not self.m2VBTFID_branch and "m2VBTFID":
            warnings.warn( "MuMuTauTauTree: Expected branch m2VBTFID does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2VBTFID")
        else:
            self.m2VBTFID_branch.SetAddress(<void*>&self.m2VBTFID_value)

        #print "making m2VZ"
        self.m2VZ_branch = the_tree.GetBranch("m2VZ")
        #if not self.m2VZ_branch and "m2VZ" not in self.complained:
        if not self.m2VZ_branch and "m2VZ":
            warnings.warn( "MuMuTauTauTree: Expected branch m2VZ does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2VZ")
        else:
            self.m2VZ_branch.SetAddress(<void*>&self.m2VZ_value)

        #print "making m2WWID"
        self.m2WWID_branch = the_tree.GetBranch("m2WWID")
        #if not self.m2WWID_branch and "m2WWID" not in self.complained:
        if not self.m2WWID_branch and "m2WWID":
            warnings.warn( "MuMuTauTauTree: Expected branch m2WWID does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2WWID")
        else:
            self.m2WWID_branch.SetAddress(<void*>&self.m2WWID_value)

        #print "making m2_t1_CosThetaStar"
        self.m2_t1_CosThetaStar_branch = the_tree.GetBranch("m2_t1_CosThetaStar")
        #if not self.m2_t1_CosThetaStar_branch and "m2_t1_CosThetaStar" not in self.complained:
        if not self.m2_t1_CosThetaStar_branch and "m2_t1_CosThetaStar":
            warnings.warn( "MuMuTauTauTree: Expected branch m2_t1_CosThetaStar does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2_t1_CosThetaStar")
        else:
            self.m2_t1_CosThetaStar_branch.SetAddress(<void*>&self.m2_t1_CosThetaStar_value)

        #print "making m2_t1_DPhi"
        self.m2_t1_DPhi_branch = the_tree.GetBranch("m2_t1_DPhi")
        #if not self.m2_t1_DPhi_branch and "m2_t1_DPhi" not in self.complained:
        if not self.m2_t1_DPhi_branch and "m2_t1_DPhi":
            warnings.warn( "MuMuTauTauTree: Expected branch m2_t1_DPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2_t1_DPhi")
        else:
            self.m2_t1_DPhi_branch.SetAddress(<void*>&self.m2_t1_DPhi_value)

        #print "making m2_t1_DR"
        self.m2_t1_DR_branch = the_tree.GetBranch("m2_t1_DR")
        #if not self.m2_t1_DR_branch and "m2_t1_DR" not in self.complained:
        if not self.m2_t1_DR_branch and "m2_t1_DR":
            warnings.warn( "MuMuTauTauTree: Expected branch m2_t1_DR does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2_t1_DR")
        else:
            self.m2_t1_DR_branch.SetAddress(<void*>&self.m2_t1_DR_value)

        #print "making m2_t1_Eta"
        self.m2_t1_Eta_branch = the_tree.GetBranch("m2_t1_Eta")
        #if not self.m2_t1_Eta_branch and "m2_t1_Eta" not in self.complained:
        if not self.m2_t1_Eta_branch and "m2_t1_Eta":
            warnings.warn( "MuMuTauTauTree: Expected branch m2_t1_Eta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2_t1_Eta")
        else:
            self.m2_t1_Eta_branch.SetAddress(<void*>&self.m2_t1_Eta_value)

        #print "making m2_t1_Mass"
        self.m2_t1_Mass_branch = the_tree.GetBranch("m2_t1_Mass")
        #if not self.m2_t1_Mass_branch and "m2_t1_Mass" not in self.complained:
        if not self.m2_t1_Mass_branch and "m2_t1_Mass":
            warnings.warn( "MuMuTauTauTree: Expected branch m2_t1_Mass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2_t1_Mass")
        else:
            self.m2_t1_Mass_branch.SetAddress(<void*>&self.m2_t1_Mass_value)

        #print "making m2_t1_MassFsr"
        self.m2_t1_MassFsr_branch = the_tree.GetBranch("m2_t1_MassFsr")
        #if not self.m2_t1_MassFsr_branch and "m2_t1_MassFsr" not in self.complained:
        if not self.m2_t1_MassFsr_branch and "m2_t1_MassFsr":
            warnings.warn( "MuMuTauTauTree: Expected branch m2_t1_MassFsr does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2_t1_MassFsr")
        else:
            self.m2_t1_MassFsr_branch.SetAddress(<void*>&self.m2_t1_MassFsr_value)

        #print "making m2_t1_PZeta"
        self.m2_t1_PZeta_branch = the_tree.GetBranch("m2_t1_PZeta")
        #if not self.m2_t1_PZeta_branch and "m2_t1_PZeta" not in self.complained:
        if not self.m2_t1_PZeta_branch and "m2_t1_PZeta":
            warnings.warn( "MuMuTauTauTree: Expected branch m2_t1_PZeta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2_t1_PZeta")
        else:
            self.m2_t1_PZeta_branch.SetAddress(<void*>&self.m2_t1_PZeta_value)

        #print "making m2_t1_PZetaVis"
        self.m2_t1_PZetaVis_branch = the_tree.GetBranch("m2_t1_PZetaVis")
        #if not self.m2_t1_PZetaVis_branch and "m2_t1_PZetaVis" not in self.complained:
        if not self.m2_t1_PZetaVis_branch and "m2_t1_PZetaVis":
            warnings.warn( "MuMuTauTauTree: Expected branch m2_t1_PZetaVis does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2_t1_PZetaVis")
        else:
            self.m2_t1_PZetaVis_branch.SetAddress(<void*>&self.m2_t1_PZetaVis_value)

        #print "making m2_t1_Phi"
        self.m2_t1_Phi_branch = the_tree.GetBranch("m2_t1_Phi")
        #if not self.m2_t1_Phi_branch and "m2_t1_Phi" not in self.complained:
        if not self.m2_t1_Phi_branch and "m2_t1_Phi":
            warnings.warn( "MuMuTauTauTree: Expected branch m2_t1_Phi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2_t1_Phi")
        else:
            self.m2_t1_Phi_branch.SetAddress(<void*>&self.m2_t1_Phi_value)

        #print "making m2_t1_Pt"
        self.m2_t1_Pt_branch = the_tree.GetBranch("m2_t1_Pt")
        #if not self.m2_t1_Pt_branch and "m2_t1_Pt" not in self.complained:
        if not self.m2_t1_Pt_branch and "m2_t1_Pt":
            warnings.warn( "MuMuTauTauTree: Expected branch m2_t1_Pt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2_t1_Pt")
        else:
            self.m2_t1_Pt_branch.SetAddress(<void*>&self.m2_t1_Pt_value)

        #print "making m2_t1_PtFsr"
        self.m2_t1_PtFsr_branch = the_tree.GetBranch("m2_t1_PtFsr")
        #if not self.m2_t1_PtFsr_branch and "m2_t1_PtFsr" not in self.complained:
        if not self.m2_t1_PtFsr_branch and "m2_t1_PtFsr":
            warnings.warn( "MuMuTauTauTree: Expected branch m2_t1_PtFsr does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2_t1_PtFsr")
        else:
            self.m2_t1_PtFsr_branch.SetAddress(<void*>&self.m2_t1_PtFsr_value)

        #print "making m2_t1_SS"
        self.m2_t1_SS_branch = the_tree.GetBranch("m2_t1_SS")
        #if not self.m2_t1_SS_branch and "m2_t1_SS" not in self.complained:
        if not self.m2_t1_SS_branch and "m2_t1_SS":
            warnings.warn( "MuMuTauTauTree: Expected branch m2_t1_SS does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2_t1_SS")
        else:
            self.m2_t1_SS_branch.SetAddress(<void*>&self.m2_t1_SS_value)

        #print "making m2_t1_ToMETDPhi_Ty1"
        self.m2_t1_ToMETDPhi_Ty1_branch = the_tree.GetBranch("m2_t1_ToMETDPhi_Ty1")
        #if not self.m2_t1_ToMETDPhi_Ty1_branch and "m2_t1_ToMETDPhi_Ty1" not in self.complained:
        if not self.m2_t1_ToMETDPhi_Ty1_branch and "m2_t1_ToMETDPhi_Ty1":
            warnings.warn( "MuMuTauTauTree: Expected branch m2_t1_ToMETDPhi_Ty1 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2_t1_ToMETDPhi_Ty1")
        else:
            self.m2_t1_ToMETDPhi_Ty1_branch.SetAddress(<void*>&self.m2_t1_ToMETDPhi_Ty1_value)

        #print "making m2_t1_Zcompat"
        self.m2_t1_Zcompat_branch = the_tree.GetBranch("m2_t1_Zcompat")
        #if not self.m2_t1_Zcompat_branch and "m2_t1_Zcompat" not in self.complained:
        if not self.m2_t1_Zcompat_branch and "m2_t1_Zcompat":
            warnings.warn( "MuMuTauTauTree: Expected branch m2_t1_Zcompat does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2_t1_Zcompat")
        else:
            self.m2_t1_Zcompat_branch.SetAddress(<void*>&self.m2_t1_Zcompat_value)

        #print "making m2_t2_CosThetaStar"
        self.m2_t2_CosThetaStar_branch = the_tree.GetBranch("m2_t2_CosThetaStar")
        #if not self.m2_t2_CosThetaStar_branch and "m2_t2_CosThetaStar" not in self.complained:
        if not self.m2_t2_CosThetaStar_branch and "m2_t2_CosThetaStar":
            warnings.warn( "MuMuTauTauTree: Expected branch m2_t2_CosThetaStar does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2_t2_CosThetaStar")
        else:
            self.m2_t2_CosThetaStar_branch.SetAddress(<void*>&self.m2_t2_CosThetaStar_value)

        #print "making m2_t2_DPhi"
        self.m2_t2_DPhi_branch = the_tree.GetBranch("m2_t2_DPhi")
        #if not self.m2_t2_DPhi_branch and "m2_t2_DPhi" not in self.complained:
        if not self.m2_t2_DPhi_branch and "m2_t2_DPhi":
            warnings.warn( "MuMuTauTauTree: Expected branch m2_t2_DPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2_t2_DPhi")
        else:
            self.m2_t2_DPhi_branch.SetAddress(<void*>&self.m2_t2_DPhi_value)

        #print "making m2_t2_DR"
        self.m2_t2_DR_branch = the_tree.GetBranch("m2_t2_DR")
        #if not self.m2_t2_DR_branch and "m2_t2_DR" not in self.complained:
        if not self.m2_t2_DR_branch and "m2_t2_DR":
            warnings.warn( "MuMuTauTauTree: Expected branch m2_t2_DR does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2_t2_DR")
        else:
            self.m2_t2_DR_branch.SetAddress(<void*>&self.m2_t2_DR_value)

        #print "making m2_t2_Eta"
        self.m2_t2_Eta_branch = the_tree.GetBranch("m2_t2_Eta")
        #if not self.m2_t2_Eta_branch and "m2_t2_Eta" not in self.complained:
        if not self.m2_t2_Eta_branch and "m2_t2_Eta":
            warnings.warn( "MuMuTauTauTree: Expected branch m2_t2_Eta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2_t2_Eta")
        else:
            self.m2_t2_Eta_branch.SetAddress(<void*>&self.m2_t2_Eta_value)

        #print "making m2_t2_Mass"
        self.m2_t2_Mass_branch = the_tree.GetBranch("m2_t2_Mass")
        #if not self.m2_t2_Mass_branch and "m2_t2_Mass" not in self.complained:
        if not self.m2_t2_Mass_branch and "m2_t2_Mass":
            warnings.warn( "MuMuTauTauTree: Expected branch m2_t2_Mass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2_t2_Mass")
        else:
            self.m2_t2_Mass_branch.SetAddress(<void*>&self.m2_t2_Mass_value)

        #print "making m2_t2_MassFsr"
        self.m2_t2_MassFsr_branch = the_tree.GetBranch("m2_t2_MassFsr")
        #if not self.m2_t2_MassFsr_branch and "m2_t2_MassFsr" not in self.complained:
        if not self.m2_t2_MassFsr_branch and "m2_t2_MassFsr":
            warnings.warn( "MuMuTauTauTree: Expected branch m2_t2_MassFsr does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2_t2_MassFsr")
        else:
            self.m2_t2_MassFsr_branch.SetAddress(<void*>&self.m2_t2_MassFsr_value)

        #print "making m2_t2_PZeta"
        self.m2_t2_PZeta_branch = the_tree.GetBranch("m2_t2_PZeta")
        #if not self.m2_t2_PZeta_branch and "m2_t2_PZeta" not in self.complained:
        if not self.m2_t2_PZeta_branch and "m2_t2_PZeta":
            warnings.warn( "MuMuTauTauTree: Expected branch m2_t2_PZeta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2_t2_PZeta")
        else:
            self.m2_t2_PZeta_branch.SetAddress(<void*>&self.m2_t2_PZeta_value)

        #print "making m2_t2_PZetaVis"
        self.m2_t2_PZetaVis_branch = the_tree.GetBranch("m2_t2_PZetaVis")
        #if not self.m2_t2_PZetaVis_branch and "m2_t2_PZetaVis" not in self.complained:
        if not self.m2_t2_PZetaVis_branch and "m2_t2_PZetaVis":
            warnings.warn( "MuMuTauTauTree: Expected branch m2_t2_PZetaVis does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2_t2_PZetaVis")
        else:
            self.m2_t2_PZetaVis_branch.SetAddress(<void*>&self.m2_t2_PZetaVis_value)

        #print "making m2_t2_Phi"
        self.m2_t2_Phi_branch = the_tree.GetBranch("m2_t2_Phi")
        #if not self.m2_t2_Phi_branch and "m2_t2_Phi" not in self.complained:
        if not self.m2_t2_Phi_branch and "m2_t2_Phi":
            warnings.warn( "MuMuTauTauTree: Expected branch m2_t2_Phi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2_t2_Phi")
        else:
            self.m2_t2_Phi_branch.SetAddress(<void*>&self.m2_t2_Phi_value)

        #print "making m2_t2_Pt"
        self.m2_t2_Pt_branch = the_tree.GetBranch("m2_t2_Pt")
        #if not self.m2_t2_Pt_branch and "m2_t2_Pt" not in self.complained:
        if not self.m2_t2_Pt_branch and "m2_t2_Pt":
            warnings.warn( "MuMuTauTauTree: Expected branch m2_t2_Pt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2_t2_Pt")
        else:
            self.m2_t2_Pt_branch.SetAddress(<void*>&self.m2_t2_Pt_value)

        #print "making m2_t2_PtFsr"
        self.m2_t2_PtFsr_branch = the_tree.GetBranch("m2_t2_PtFsr")
        #if not self.m2_t2_PtFsr_branch and "m2_t2_PtFsr" not in self.complained:
        if not self.m2_t2_PtFsr_branch and "m2_t2_PtFsr":
            warnings.warn( "MuMuTauTauTree: Expected branch m2_t2_PtFsr does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2_t2_PtFsr")
        else:
            self.m2_t2_PtFsr_branch.SetAddress(<void*>&self.m2_t2_PtFsr_value)

        #print "making m2_t2_SS"
        self.m2_t2_SS_branch = the_tree.GetBranch("m2_t2_SS")
        #if not self.m2_t2_SS_branch and "m2_t2_SS" not in self.complained:
        if not self.m2_t2_SS_branch and "m2_t2_SS":
            warnings.warn( "MuMuTauTauTree: Expected branch m2_t2_SS does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2_t2_SS")
        else:
            self.m2_t2_SS_branch.SetAddress(<void*>&self.m2_t2_SS_value)

        #print "making m2_t2_ToMETDPhi_Ty1"
        self.m2_t2_ToMETDPhi_Ty1_branch = the_tree.GetBranch("m2_t2_ToMETDPhi_Ty1")
        #if not self.m2_t2_ToMETDPhi_Ty1_branch and "m2_t2_ToMETDPhi_Ty1" not in self.complained:
        if not self.m2_t2_ToMETDPhi_Ty1_branch and "m2_t2_ToMETDPhi_Ty1":
            warnings.warn( "MuMuTauTauTree: Expected branch m2_t2_ToMETDPhi_Ty1 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2_t2_ToMETDPhi_Ty1")
        else:
            self.m2_t2_ToMETDPhi_Ty1_branch.SetAddress(<void*>&self.m2_t2_ToMETDPhi_Ty1_value)

        #print "making m2_t2_Zcompat"
        self.m2_t2_Zcompat_branch = the_tree.GetBranch("m2_t2_Zcompat")
        #if not self.m2_t2_Zcompat_branch and "m2_t2_Zcompat" not in self.complained:
        if not self.m2_t2_Zcompat_branch and "m2_t2_Zcompat":
            warnings.warn( "MuMuTauTauTree: Expected branch m2_t2_Zcompat does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2_t2_Zcompat")
        else:
            self.m2_t2_Zcompat_branch.SetAddress(<void*>&self.m2_t2_Zcompat_value)

        #print "making mu17ele8Group"
        self.mu17ele8Group_branch = the_tree.GetBranch("mu17ele8Group")
        #if not self.mu17ele8Group_branch and "mu17ele8Group" not in self.complained:
        if not self.mu17ele8Group_branch and "mu17ele8Group":
            warnings.warn( "MuMuTauTauTree: Expected branch mu17ele8Group does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mu17ele8Group")
        else:
            self.mu17ele8Group_branch.SetAddress(<void*>&self.mu17ele8Group_value)

        #print "making mu17ele8Pass"
        self.mu17ele8Pass_branch = the_tree.GetBranch("mu17ele8Pass")
        #if not self.mu17ele8Pass_branch and "mu17ele8Pass" not in self.complained:
        if not self.mu17ele8Pass_branch and "mu17ele8Pass":
            warnings.warn( "MuMuTauTauTree: Expected branch mu17ele8Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mu17ele8Pass")
        else:
            self.mu17ele8Pass_branch.SetAddress(<void*>&self.mu17ele8Pass_value)

        #print "making mu17ele8Prescale"
        self.mu17ele8Prescale_branch = the_tree.GetBranch("mu17ele8Prescale")
        #if not self.mu17ele8Prescale_branch and "mu17ele8Prescale" not in self.complained:
        if not self.mu17ele8Prescale_branch and "mu17ele8Prescale":
            warnings.warn( "MuMuTauTauTree: Expected branch mu17ele8Prescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mu17ele8Prescale")
        else:
            self.mu17ele8Prescale_branch.SetAddress(<void*>&self.mu17ele8Prescale_value)

        #print "making mu17ele8isoGroup"
        self.mu17ele8isoGroup_branch = the_tree.GetBranch("mu17ele8isoGroup")
        #if not self.mu17ele8isoGroup_branch and "mu17ele8isoGroup" not in self.complained:
        if not self.mu17ele8isoGroup_branch and "mu17ele8isoGroup":
            warnings.warn( "MuMuTauTauTree: Expected branch mu17ele8isoGroup does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mu17ele8isoGroup")
        else:
            self.mu17ele8isoGroup_branch.SetAddress(<void*>&self.mu17ele8isoGroup_value)

        #print "making mu17ele8isoPass"
        self.mu17ele8isoPass_branch = the_tree.GetBranch("mu17ele8isoPass")
        #if not self.mu17ele8isoPass_branch and "mu17ele8isoPass" not in self.complained:
        if not self.mu17ele8isoPass_branch and "mu17ele8isoPass":
            warnings.warn( "MuMuTauTauTree: Expected branch mu17ele8isoPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mu17ele8isoPass")
        else:
            self.mu17ele8isoPass_branch.SetAddress(<void*>&self.mu17ele8isoPass_value)

        #print "making mu17ele8isoPrescale"
        self.mu17ele8isoPrescale_branch = the_tree.GetBranch("mu17ele8isoPrescale")
        #if not self.mu17ele8isoPrescale_branch and "mu17ele8isoPrescale" not in self.complained:
        if not self.mu17ele8isoPrescale_branch and "mu17ele8isoPrescale":
            warnings.warn( "MuMuTauTauTree: Expected branch mu17ele8isoPrescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mu17ele8isoPrescale")
        else:
            self.mu17ele8isoPrescale_branch.SetAddress(<void*>&self.mu17ele8isoPrescale_value)

        #print "making mu17mu8Group"
        self.mu17mu8Group_branch = the_tree.GetBranch("mu17mu8Group")
        #if not self.mu17mu8Group_branch and "mu17mu8Group" not in self.complained:
        if not self.mu17mu8Group_branch and "mu17mu8Group":
            warnings.warn( "MuMuTauTauTree: Expected branch mu17mu8Group does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mu17mu8Group")
        else:
            self.mu17mu8Group_branch.SetAddress(<void*>&self.mu17mu8Group_value)

        #print "making mu17mu8Pass"
        self.mu17mu8Pass_branch = the_tree.GetBranch("mu17mu8Pass")
        #if not self.mu17mu8Pass_branch and "mu17mu8Pass" not in self.complained:
        if not self.mu17mu8Pass_branch and "mu17mu8Pass":
            warnings.warn( "MuMuTauTauTree: Expected branch mu17mu8Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mu17mu8Pass")
        else:
            self.mu17mu8Pass_branch.SetAddress(<void*>&self.mu17mu8Pass_value)

        #print "making mu17mu8Prescale"
        self.mu17mu8Prescale_branch = the_tree.GetBranch("mu17mu8Prescale")
        #if not self.mu17mu8Prescale_branch and "mu17mu8Prescale" not in self.complained:
        if not self.mu17mu8Prescale_branch and "mu17mu8Prescale":
            warnings.warn( "MuMuTauTauTree: Expected branch mu17mu8Prescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mu17mu8Prescale")
        else:
            self.mu17mu8Prescale_branch.SetAddress(<void*>&self.mu17mu8Prescale_value)

        #print "making mu8ele17Group"
        self.mu8ele17Group_branch = the_tree.GetBranch("mu8ele17Group")
        #if not self.mu8ele17Group_branch and "mu8ele17Group" not in self.complained:
        if not self.mu8ele17Group_branch and "mu8ele17Group":
            warnings.warn( "MuMuTauTauTree: Expected branch mu8ele17Group does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mu8ele17Group")
        else:
            self.mu8ele17Group_branch.SetAddress(<void*>&self.mu8ele17Group_value)

        #print "making mu8ele17Pass"
        self.mu8ele17Pass_branch = the_tree.GetBranch("mu8ele17Pass")
        #if not self.mu8ele17Pass_branch and "mu8ele17Pass" not in self.complained:
        if not self.mu8ele17Pass_branch and "mu8ele17Pass":
            warnings.warn( "MuMuTauTauTree: Expected branch mu8ele17Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mu8ele17Pass")
        else:
            self.mu8ele17Pass_branch.SetAddress(<void*>&self.mu8ele17Pass_value)

        #print "making mu8ele17Prescale"
        self.mu8ele17Prescale_branch = the_tree.GetBranch("mu8ele17Prescale")
        #if not self.mu8ele17Prescale_branch and "mu8ele17Prescale" not in self.complained:
        if not self.mu8ele17Prescale_branch and "mu8ele17Prescale":
            warnings.warn( "MuMuTauTauTree: Expected branch mu8ele17Prescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mu8ele17Prescale")
        else:
            self.mu8ele17Prescale_branch.SetAddress(<void*>&self.mu8ele17Prescale_value)

        #print "making mu8ele17isoGroup"
        self.mu8ele17isoGroup_branch = the_tree.GetBranch("mu8ele17isoGroup")
        #if not self.mu8ele17isoGroup_branch and "mu8ele17isoGroup" not in self.complained:
        if not self.mu8ele17isoGroup_branch and "mu8ele17isoGroup":
            warnings.warn( "MuMuTauTauTree: Expected branch mu8ele17isoGroup does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mu8ele17isoGroup")
        else:
            self.mu8ele17isoGroup_branch.SetAddress(<void*>&self.mu8ele17isoGroup_value)

        #print "making mu8ele17isoPass"
        self.mu8ele17isoPass_branch = the_tree.GetBranch("mu8ele17isoPass")
        #if not self.mu8ele17isoPass_branch and "mu8ele17isoPass" not in self.complained:
        if not self.mu8ele17isoPass_branch and "mu8ele17isoPass":
            warnings.warn( "MuMuTauTauTree: Expected branch mu8ele17isoPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mu8ele17isoPass")
        else:
            self.mu8ele17isoPass_branch.SetAddress(<void*>&self.mu8ele17isoPass_value)

        #print "making mu8ele17isoPrescale"
        self.mu8ele17isoPrescale_branch = the_tree.GetBranch("mu8ele17isoPrescale")
        #if not self.mu8ele17isoPrescale_branch and "mu8ele17isoPrescale" not in self.complained:
        if not self.mu8ele17isoPrescale_branch and "mu8ele17isoPrescale":
            warnings.warn( "MuMuTauTauTree: Expected branch mu8ele17isoPrescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mu8ele17isoPrescale")
        else:
            self.mu8ele17isoPrescale_branch.SetAddress(<void*>&self.mu8ele17isoPrescale_value)

        #print "making muGlbIsoVetoPt10"
        self.muGlbIsoVetoPt10_branch = the_tree.GetBranch("muGlbIsoVetoPt10")
        #if not self.muGlbIsoVetoPt10_branch and "muGlbIsoVetoPt10" not in self.complained:
        if not self.muGlbIsoVetoPt10_branch and "muGlbIsoVetoPt10":
            warnings.warn( "MuMuTauTauTree: Expected branch muGlbIsoVetoPt10 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("muGlbIsoVetoPt10")
        else:
            self.muGlbIsoVetoPt10_branch.SetAddress(<void*>&self.muGlbIsoVetoPt10_value)

        #print "making muTauGroup"
        self.muTauGroup_branch = the_tree.GetBranch("muTauGroup")
        #if not self.muTauGroup_branch and "muTauGroup" not in self.complained:
        if not self.muTauGroup_branch and "muTauGroup":
            warnings.warn( "MuMuTauTauTree: Expected branch muTauGroup does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("muTauGroup")
        else:
            self.muTauGroup_branch.SetAddress(<void*>&self.muTauGroup_value)

        #print "making muTauPass"
        self.muTauPass_branch = the_tree.GetBranch("muTauPass")
        #if not self.muTauPass_branch and "muTauPass" not in self.complained:
        if not self.muTauPass_branch and "muTauPass":
            warnings.warn( "MuMuTauTauTree: Expected branch muTauPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("muTauPass")
        else:
            self.muTauPass_branch.SetAddress(<void*>&self.muTauPass_value)

        #print "making muTauPrescale"
        self.muTauPrescale_branch = the_tree.GetBranch("muTauPrescale")
        #if not self.muTauPrescale_branch and "muTauPrescale" not in self.complained:
        if not self.muTauPrescale_branch and "muTauPrescale":
            warnings.warn( "MuMuTauTauTree: Expected branch muTauPrescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("muTauPrescale")
        else:
            self.muTauPrescale_branch.SetAddress(<void*>&self.muTauPrescale_value)

        #print "making muTauTestGroup"
        self.muTauTestGroup_branch = the_tree.GetBranch("muTauTestGroup")
        #if not self.muTauTestGroup_branch and "muTauTestGroup" not in self.complained:
        if not self.muTauTestGroup_branch and "muTauTestGroup":
            warnings.warn( "MuMuTauTauTree: Expected branch muTauTestGroup does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("muTauTestGroup")
        else:
            self.muTauTestGroup_branch.SetAddress(<void*>&self.muTauTestGroup_value)

        #print "making muTauTestPass"
        self.muTauTestPass_branch = the_tree.GetBranch("muTauTestPass")
        #if not self.muTauTestPass_branch and "muTauTestPass" not in self.complained:
        if not self.muTauTestPass_branch and "muTauTestPass":
            warnings.warn( "MuMuTauTauTree: Expected branch muTauTestPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("muTauTestPass")
        else:
            self.muTauTestPass_branch.SetAddress(<void*>&self.muTauTestPass_value)

        #print "making muTauTestPrescale"
        self.muTauTestPrescale_branch = the_tree.GetBranch("muTauTestPrescale")
        #if not self.muTauTestPrescale_branch and "muTauTestPrescale" not in self.complained:
        if not self.muTauTestPrescale_branch and "muTauTestPrescale":
            warnings.warn( "MuMuTauTauTree: Expected branch muTauTestPrescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("muTauTestPrescale")
        else:
            self.muTauTestPrescale_branch.SetAddress(<void*>&self.muTauTestPrescale_value)

        #print "making muTightCountZH"
        self.muTightCountZH_branch = the_tree.GetBranch("muTightCountZH")
        #if not self.muTightCountZH_branch and "muTightCountZH" not in self.complained:
        if not self.muTightCountZH_branch and "muTightCountZH":
            warnings.warn( "MuMuTauTauTree: Expected branch muTightCountZH does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("muTightCountZH")
        else:
            self.muTightCountZH_branch.SetAddress(<void*>&self.muTightCountZH_value)

        #print "making muVetoPt15IsoIdVtx"
        self.muVetoPt15IsoIdVtx_branch = the_tree.GetBranch("muVetoPt15IsoIdVtx")
        #if not self.muVetoPt15IsoIdVtx_branch and "muVetoPt15IsoIdVtx" not in self.complained:
        if not self.muVetoPt15IsoIdVtx_branch and "muVetoPt15IsoIdVtx":
            warnings.warn( "MuMuTauTauTree: Expected branch muVetoPt15IsoIdVtx does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("muVetoPt15IsoIdVtx")
        else:
            self.muVetoPt15IsoIdVtx_branch.SetAddress(<void*>&self.muVetoPt15IsoIdVtx_value)

        #print "making muVetoPt5"
        self.muVetoPt5_branch = the_tree.GetBranch("muVetoPt5")
        #if not self.muVetoPt5_branch and "muVetoPt5" not in self.complained:
        if not self.muVetoPt5_branch and "muVetoPt5":
            warnings.warn( "MuMuTauTauTree: Expected branch muVetoPt5 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("muVetoPt5")
        else:
            self.muVetoPt5_branch.SetAddress(<void*>&self.muVetoPt5_value)

        #print "making muVetoPt5IsoIdVtx"
        self.muVetoPt5IsoIdVtx_branch = the_tree.GetBranch("muVetoPt5IsoIdVtx")
        #if not self.muVetoPt5IsoIdVtx_branch and "muVetoPt5IsoIdVtx" not in self.complained:
        if not self.muVetoPt5IsoIdVtx_branch and "muVetoPt5IsoIdVtx":
            warnings.warn( "MuMuTauTauTree: Expected branch muVetoPt5IsoIdVtx does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("muVetoPt5IsoIdVtx")
        else:
            self.muVetoPt5IsoIdVtx_branch.SetAddress(<void*>&self.muVetoPt5IsoIdVtx_value)

        #print "making muVetoZH"
        self.muVetoZH_branch = the_tree.GetBranch("muVetoZH")
        #if not self.muVetoZH_branch and "muVetoZH" not in self.complained:
        if not self.muVetoZH_branch and "muVetoZH":
            warnings.warn( "MuMuTauTauTree: Expected branch muVetoZH does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("muVetoZH")
        else:
            self.muVetoZH_branch.SetAddress(<void*>&self.muVetoZH_value)

        #print "making mva_metEt"
        self.mva_metEt_branch = the_tree.GetBranch("mva_metEt")
        #if not self.mva_metEt_branch and "mva_metEt" not in self.complained:
        if not self.mva_metEt_branch and "mva_metEt":
            warnings.warn( "MuMuTauTauTree: Expected branch mva_metEt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mva_metEt")
        else:
            self.mva_metEt_branch.SetAddress(<void*>&self.mva_metEt_value)

        #print "making mva_metPhi"
        self.mva_metPhi_branch = the_tree.GetBranch("mva_metPhi")
        #if not self.mva_metPhi_branch and "mva_metPhi" not in self.complained:
        if not self.mva_metPhi_branch and "mva_metPhi":
            warnings.warn( "MuMuTauTauTree: Expected branch mva_metPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mva_metPhi")
        else:
            self.mva_metPhi_branch.SetAddress(<void*>&self.mva_metPhi_value)

        #print "making nTruePU"
        self.nTruePU_branch = the_tree.GetBranch("nTruePU")
        #if not self.nTruePU_branch and "nTruePU" not in self.complained:
        if not self.nTruePU_branch and "nTruePU":
            warnings.warn( "MuMuTauTauTree: Expected branch nTruePU does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("nTruePU")
        else:
            self.nTruePU_branch.SetAddress(<void*>&self.nTruePU_value)

        #print "making nvtx"
        self.nvtx_branch = the_tree.GetBranch("nvtx")
        #if not self.nvtx_branch and "nvtx" not in self.complained:
        if not self.nvtx_branch and "nvtx":
            warnings.warn( "MuMuTauTauTree: Expected branch nvtx does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("nvtx")
        else:
            self.nvtx_branch.SetAddress(<void*>&self.nvtx_value)

        #print "making pfMetEt"
        self.pfMetEt_branch = the_tree.GetBranch("pfMetEt")
        #if not self.pfMetEt_branch and "pfMetEt" not in self.complained:
        if not self.pfMetEt_branch and "pfMetEt":
            warnings.warn( "MuMuTauTauTree: Expected branch pfMetEt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pfMetEt")
        else:
            self.pfMetEt_branch.SetAddress(<void*>&self.pfMetEt_value)

        #print "making pfMetPhi"
        self.pfMetPhi_branch = the_tree.GetBranch("pfMetPhi")
        #if not self.pfMetPhi_branch and "pfMetPhi" not in self.complained:
        if not self.pfMetPhi_branch and "pfMetPhi":
            warnings.warn( "MuMuTauTauTree: Expected branch pfMetPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pfMetPhi")
        else:
            self.pfMetPhi_branch.SetAddress(<void*>&self.pfMetPhi_value)

        #print "making pfMet_jes_Et"
        self.pfMet_jes_Et_branch = the_tree.GetBranch("pfMet_jes_Et")
        #if not self.pfMet_jes_Et_branch and "pfMet_jes_Et" not in self.complained:
        if not self.pfMet_jes_Et_branch and "pfMet_jes_Et":
            warnings.warn( "MuMuTauTauTree: Expected branch pfMet_jes_Et does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pfMet_jes_Et")
        else:
            self.pfMet_jes_Et_branch.SetAddress(<void*>&self.pfMet_jes_Et_value)

        #print "making pfMet_jes_Phi"
        self.pfMet_jes_Phi_branch = the_tree.GetBranch("pfMet_jes_Phi")
        #if not self.pfMet_jes_Phi_branch and "pfMet_jes_Phi" not in self.complained:
        if not self.pfMet_jes_Phi_branch and "pfMet_jes_Phi":
            warnings.warn( "MuMuTauTauTree: Expected branch pfMet_jes_Phi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pfMet_jes_Phi")
        else:
            self.pfMet_jes_Phi_branch.SetAddress(<void*>&self.pfMet_jes_Phi_value)

        #print "making pfMet_mes_Et"
        self.pfMet_mes_Et_branch = the_tree.GetBranch("pfMet_mes_Et")
        #if not self.pfMet_mes_Et_branch and "pfMet_mes_Et" not in self.complained:
        if not self.pfMet_mes_Et_branch and "pfMet_mes_Et":
            warnings.warn( "MuMuTauTauTree: Expected branch pfMet_mes_Et does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pfMet_mes_Et")
        else:
            self.pfMet_mes_Et_branch.SetAddress(<void*>&self.pfMet_mes_Et_value)

        #print "making pfMet_mes_Phi"
        self.pfMet_mes_Phi_branch = the_tree.GetBranch("pfMet_mes_Phi")
        #if not self.pfMet_mes_Phi_branch and "pfMet_mes_Phi" not in self.complained:
        if not self.pfMet_mes_Phi_branch and "pfMet_mes_Phi":
            warnings.warn( "MuMuTauTauTree: Expected branch pfMet_mes_Phi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pfMet_mes_Phi")
        else:
            self.pfMet_mes_Phi_branch.SetAddress(<void*>&self.pfMet_mes_Phi_value)

        #print "making pfMet_tes_Et"
        self.pfMet_tes_Et_branch = the_tree.GetBranch("pfMet_tes_Et")
        #if not self.pfMet_tes_Et_branch and "pfMet_tes_Et" not in self.complained:
        if not self.pfMet_tes_Et_branch and "pfMet_tes_Et":
            warnings.warn( "MuMuTauTauTree: Expected branch pfMet_tes_Et does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pfMet_tes_Et")
        else:
            self.pfMet_tes_Et_branch.SetAddress(<void*>&self.pfMet_tes_Et_value)

        #print "making pfMet_tes_Phi"
        self.pfMet_tes_Phi_branch = the_tree.GetBranch("pfMet_tes_Phi")
        #if not self.pfMet_tes_Phi_branch and "pfMet_tes_Phi" not in self.complained:
        if not self.pfMet_tes_Phi_branch and "pfMet_tes_Phi":
            warnings.warn( "MuMuTauTauTree: Expected branch pfMet_tes_Phi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pfMet_tes_Phi")
        else:
            self.pfMet_tes_Phi_branch.SetAddress(<void*>&self.pfMet_tes_Phi_value)

        #print "making pfMet_ues_Et"
        self.pfMet_ues_Et_branch = the_tree.GetBranch("pfMet_ues_Et")
        #if not self.pfMet_ues_Et_branch and "pfMet_ues_Et" not in self.complained:
        if not self.pfMet_ues_Et_branch and "pfMet_ues_Et":
            warnings.warn( "MuMuTauTauTree: Expected branch pfMet_ues_Et does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pfMet_ues_Et")
        else:
            self.pfMet_ues_Et_branch.SetAddress(<void*>&self.pfMet_ues_Et_value)

        #print "making pfMet_ues_Phi"
        self.pfMet_ues_Phi_branch = the_tree.GetBranch("pfMet_ues_Phi")
        #if not self.pfMet_ues_Phi_branch and "pfMet_ues_Phi" not in self.complained:
        if not self.pfMet_ues_Phi_branch and "pfMet_ues_Phi":
            warnings.warn( "MuMuTauTauTree: Expected branch pfMet_ues_Phi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pfMet_ues_Phi")
        else:
            self.pfMet_ues_Phi_branch.SetAddress(<void*>&self.pfMet_ues_Phi_value)

        #print "making processID"
        self.processID_branch = the_tree.GetBranch("processID")
        #if not self.processID_branch and "processID" not in self.complained:
        if not self.processID_branch and "processID":
            warnings.warn( "MuMuTauTauTree: Expected branch processID does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("processID")
        else:
            self.processID_branch.SetAddress(<void*>&self.processID_value)

        #print "making pvChi2"
        self.pvChi2_branch = the_tree.GetBranch("pvChi2")
        #if not self.pvChi2_branch and "pvChi2" not in self.complained:
        if not self.pvChi2_branch and "pvChi2":
            warnings.warn( "MuMuTauTauTree: Expected branch pvChi2 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pvChi2")
        else:
            self.pvChi2_branch.SetAddress(<void*>&self.pvChi2_value)

        #print "making pvDX"
        self.pvDX_branch = the_tree.GetBranch("pvDX")
        #if not self.pvDX_branch and "pvDX" not in self.complained:
        if not self.pvDX_branch and "pvDX":
            warnings.warn( "MuMuTauTauTree: Expected branch pvDX does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pvDX")
        else:
            self.pvDX_branch.SetAddress(<void*>&self.pvDX_value)

        #print "making pvDY"
        self.pvDY_branch = the_tree.GetBranch("pvDY")
        #if not self.pvDY_branch and "pvDY" not in self.complained:
        if not self.pvDY_branch and "pvDY":
            warnings.warn( "MuMuTauTauTree: Expected branch pvDY does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pvDY")
        else:
            self.pvDY_branch.SetAddress(<void*>&self.pvDY_value)

        #print "making pvDZ"
        self.pvDZ_branch = the_tree.GetBranch("pvDZ")
        #if not self.pvDZ_branch and "pvDZ" not in self.complained:
        if not self.pvDZ_branch and "pvDZ":
            warnings.warn( "MuMuTauTauTree: Expected branch pvDZ does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pvDZ")
        else:
            self.pvDZ_branch.SetAddress(<void*>&self.pvDZ_value)

        #print "making pvIsFake"
        self.pvIsFake_branch = the_tree.GetBranch("pvIsFake")
        #if not self.pvIsFake_branch and "pvIsFake" not in self.complained:
        if not self.pvIsFake_branch and "pvIsFake":
            warnings.warn( "MuMuTauTauTree: Expected branch pvIsFake does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pvIsFake")
        else:
            self.pvIsFake_branch.SetAddress(<void*>&self.pvIsFake_value)

        #print "making pvIsValid"
        self.pvIsValid_branch = the_tree.GetBranch("pvIsValid")
        #if not self.pvIsValid_branch and "pvIsValid" not in self.complained:
        if not self.pvIsValid_branch and "pvIsValid":
            warnings.warn( "MuMuTauTauTree: Expected branch pvIsValid does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pvIsValid")
        else:
            self.pvIsValid_branch.SetAddress(<void*>&self.pvIsValid_value)

        #print "making pvNormChi2"
        self.pvNormChi2_branch = the_tree.GetBranch("pvNormChi2")
        #if not self.pvNormChi2_branch and "pvNormChi2" not in self.complained:
        if not self.pvNormChi2_branch and "pvNormChi2":
            warnings.warn( "MuMuTauTauTree: Expected branch pvNormChi2 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pvNormChi2")
        else:
            self.pvNormChi2_branch.SetAddress(<void*>&self.pvNormChi2_value)

        #print "making pvX"
        self.pvX_branch = the_tree.GetBranch("pvX")
        #if not self.pvX_branch and "pvX" not in self.complained:
        if not self.pvX_branch and "pvX":
            warnings.warn( "MuMuTauTauTree: Expected branch pvX does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pvX")
        else:
            self.pvX_branch.SetAddress(<void*>&self.pvX_value)

        #print "making pvY"
        self.pvY_branch = the_tree.GetBranch("pvY")
        #if not self.pvY_branch and "pvY" not in self.complained:
        if not self.pvY_branch and "pvY":
            warnings.warn( "MuMuTauTauTree: Expected branch pvY does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pvY")
        else:
            self.pvY_branch.SetAddress(<void*>&self.pvY_value)

        #print "making pvZ"
        self.pvZ_branch = the_tree.GetBranch("pvZ")
        #if not self.pvZ_branch and "pvZ" not in self.complained:
        if not self.pvZ_branch and "pvZ":
            warnings.warn( "MuMuTauTauTree: Expected branch pvZ does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pvZ")
        else:
            self.pvZ_branch.SetAddress(<void*>&self.pvZ_value)

        #print "making pvndof"
        self.pvndof_branch = the_tree.GetBranch("pvndof")
        #if not self.pvndof_branch and "pvndof" not in self.complained:
        if not self.pvndof_branch and "pvndof":
            warnings.warn( "MuMuTauTauTree: Expected branch pvndof does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pvndof")
        else:
            self.pvndof_branch.SetAddress(<void*>&self.pvndof_value)

        #print "making recoilDaught"
        self.recoilDaught_branch = the_tree.GetBranch("recoilDaught")
        #if not self.recoilDaught_branch and "recoilDaught" not in self.complained:
        if not self.recoilDaught_branch and "recoilDaught":
            warnings.warn( "MuMuTauTauTree: Expected branch recoilDaught does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("recoilDaught")
        else:
            self.recoilDaught_branch.SetAddress(<void*>&self.recoilDaught_value)

        #print "making recoilWithMet"
        self.recoilWithMet_branch = the_tree.GetBranch("recoilWithMet")
        #if not self.recoilWithMet_branch and "recoilWithMet" not in self.complained:
        if not self.recoilWithMet_branch and "recoilWithMet":
            warnings.warn( "MuMuTauTauTree: Expected branch recoilWithMet does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("recoilWithMet")
        else:
            self.recoilWithMet_branch.SetAddress(<void*>&self.recoilWithMet_value)

        #print "making rho"
        self.rho_branch = the_tree.GetBranch("rho")
        #if not self.rho_branch and "rho" not in self.complained:
        if not self.rho_branch and "rho":
            warnings.warn( "MuMuTauTauTree: Expected branch rho does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("rho")
        else:
            self.rho_branch.SetAddress(<void*>&self.rho_value)

        #print "making run"
        self.run_branch = the_tree.GetBranch("run")
        #if not self.run_branch and "run" not in self.complained:
        if not self.run_branch and "run":
            warnings.warn( "MuMuTauTauTree: Expected branch run does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("run")
        else:
            self.run_branch.SetAddress(<void*>&self.run_value)

        #print "making singleEGroup"
        self.singleEGroup_branch = the_tree.GetBranch("singleEGroup")
        #if not self.singleEGroup_branch and "singleEGroup" not in self.complained:
        if not self.singleEGroup_branch and "singleEGroup":
            warnings.warn( "MuMuTauTauTree: Expected branch singleEGroup does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleEGroup")
        else:
            self.singleEGroup_branch.SetAddress(<void*>&self.singleEGroup_value)

        #print "making singleEPFMTGroup"
        self.singleEPFMTGroup_branch = the_tree.GetBranch("singleEPFMTGroup")
        #if not self.singleEPFMTGroup_branch and "singleEPFMTGroup" not in self.complained:
        if not self.singleEPFMTGroup_branch and "singleEPFMTGroup":
            warnings.warn( "MuMuTauTauTree: Expected branch singleEPFMTGroup does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleEPFMTGroup")
        else:
            self.singleEPFMTGroup_branch.SetAddress(<void*>&self.singleEPFMTGroup_value)

        #print "making singleEPFMTPass"
        self.singleEPFMTPass_branch = the_tree.GetBranch("singleEPFMTPass")
        #if not self.singleEPFMTPass_branch and "singleEPFMTPass" not in self.complained:
        if not self.singleEPFMTPass_branch and "singleEPFMTPass":
            warnings.warn( "MuMuTauTauTree: Expected branch singleEPFMTPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleEPFMTPass")
        else:
            self.singleEPFMTPass_branch.SetAddress(<void*>&self.singleEPFMTPass_value)

        #print "making singleEPFMTPrescale"
        self.singleEPFMTPrescale_branch = the_tree.GetBranch("singleEPFMTPrescale")
        #if not self.singleEPFMTPrescale_branch and "singleEPFMTPrescale" not in self.complained:
        if not self.singleEPFMTPrescale_branch and "singleEPFMTPrescale":
            warnings.warn( "MuMuTauTauTree: Expected branch singleEPFMTPrescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleEPFMTPrescale")
        else:
            self.singleEPFMTPrescale_branch.SetAddress(<void*>&self.singleEPFMTPrescale_value)

        #print "making singleEPass"
        self.singleEPass_branch = the_tree.GetBranch("singleEPass")
        #if not self.singleEPass_branch and "singleEPass" not in self.complained:
        if not self.singleEPass_branch and "singleEPass":
            warnings.warn( "MuMuTauTauTree: Expected branch singleEPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleEPass")
        else:
            self.singleEPass_branch.SetAddress(<void*>&self.singleEPass_value)

        #print "making singleEPrescale"
        self.singleEPrescale_branch = the_tree.GetBranch("singleEPrescale")
        #if not self.singleEPrescale_branch and "singleEPrescale" not in self.complained:
        if not self.singleEPrescale_branch and "singleEPrescale":
            warnings.warn( "MuMuTauTauTree: Expected branch singleEPrescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleEPrescale")
        else:
            self.singleEPrescale_branch.SetAddress(<void*>&self.singleEPrescale_value)

        #print "making singleMuGroup"
        self.singleMuGroup_branch = the_tree.GetBranch("singleMuGroup")
        #if not self.singleMuGroup_branch and "singleMuGroup" not in self.complained:
        if not self.singleMuGroup_branch and "singleMuGroup":
            warnings.warn( "MuMuTauTauTree: Expected branch singleMuGroup does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleMuGroup")
        else:
            self.singleMuGroup_branch.SetAddress(<void*>&self.singleMuGroup_value)

        #print "making singleMuPass"
        self.singleMuPass_branch = the_tree.GetBranch("singleMuPass")
        #if not self.singleMuPass_branch and "singleMuPass" not in self.complained:
        if not self.singleMuPass_branch and "singleMuPass":
            warnings.warn( "MuMuTauTauTree: Expected branch singleMuPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleMuPass")
        else:
            self.singleMuPass_branch.SetAddress(<void*>&self.singleMuPass_value)

        #print "making singleMuPrescale"
        self.singleMuPrescale_branch = the_tree.GetBranch("singleMuPrescale")
        #if not self.singleMuPrescale_branch and "singleMuPrescale" not in self.complained:
        if not self.singleMuPrescale_branch and "singleMuPrescale":
            warnings.warn( "MuMuTauTauTree: Expected branch singleMuPrescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleMuPrescale")
        else:
            self.singleMuPrescale_branch.SetAddress(<void*>&self.singleMuPrescale_value)

        #print "making singlePhoGroup"
        self.singlePhoGroup_branch = the_tree.GetBranch("singlePhoGroup")
        #if not self.singlePhoGroup_branch and "singlePhoGroup" not in self.complained:
        if not self.singlePhoGroup_branch and "singlePhoGroup":
            warnings.warn( "MuMuTauTauTree: Expected branch singlePhoGroup does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singlePhoGroup")
        else:
            self.singlePhoGroup_branch.SetAddress(<void*>&self.singlePhoGroup_value)

        #print "making singlePhoPass"
        self.singlePhoPass_branch = the_tree.GetBranch("singlePhoPass")
        #if not self.singlePhoPass_branch and "singlePhoPass" not in self.complained:
        if not self.singlePhoPass_branch and "singlePhoPass":
            warnings.warn( "MuMuTauTauTree: Expected branch singlePhoPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singlePhoPass")
        else:
            self.singlePhoPass_branch.SetAddress(<void*>&self.singlePhoPass_value)

        #print "making singlePhoPrescale"
        self.singlePhoPrescale_branch = the_tree.GetBranch("singlePhoPrescale")
        #if not self.singlePhoPrescale_branch and "singlePhoPrescale" not in self.complained:
        if not self.singlePhoPrescale_branch and "singlePhoPrescale":
            warnings.warn( "MuMuTauTauTree: Expected branch singlePhoPrescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singlePhoPrescale")
        else:
            self.singlePhoPrescale_branch.SetAddress(<void*>&self.singlePhoPrescale_value)

        #print "making t1AbsEta"
        self.t1AbsEta_branch = the_tree.GetBranch("t1AbsEta")
        #if not self.t1AbsEta_branch and "t1AbsEta" not in self.complained:
        if not self.t1AbsEta_branch and "t1AbsEta":
            warnings.warn( "MuMuTauTauTree: Expected branch t1AbsEta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t1AbsEta")
        else:
            self.t1AbsEta_branch.SetAddress(<void*>&self.t1AbsEta_value)

        #print "making t1AntiElectronLoose"
        self.t1AntiElectronLoose_branch = the_tree.GetBranch("t1AntiElectronLoose")
        #if not self.t1AntiElectronLoose_branch and "t1AntiElectronLoose" not in self.complained:
        if not self.t1AntiElectronLoose_branch and "t1AntiElectronLoose":
            warnings.warn( "MuMuTauTauTree: Expected branch t1AntiElectronLoose does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t1AntiElectronLoose")
        else:
            self.t1AntiElectronLoose_branch.SetAddress(<void*>&self.t1AntiElectronLoose_value)

        #print "making t1AntiElectronMVA3Loose"
        self.t1AntiElectronMVA3Loose_branch = the_tree.GetBranch("t1AntiElectronMVA3Loose")
        #if not self.t1AntiElectronMVA3Loose_branch and "t1AntiElectronMVA3Loose" not in self.complained:
        if not self.t1AntiElectronMVA3Loose_branch and "t1AntiElectronMVA3Loose":
            warnings.warn( "MuMuTauTauTree: Expected branch t1AntiElectronMVA3Loose does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t1AntiElectronMVA3Loose")
        else:
            self.t1AntiElectronMVA3Loose_branch.SetAddress(<void*>&self.t1AntiElectronMVA3Loose_value)

        #print "making t1AntiElectronMVA3Medium"
        self.t1AntiElectronMVA3Medium_branch = the_tree.GetBranch("t1AntiElectronMVA3Medium")
        #if not self.t1AntiElectronMVA3Medium_branch and "t1AntiElectronMVA3Medium" not in self.complained:
        if not self.t1AntiElectronMVA3Medium_branch and "t1AntiElectronMVA3Medium":
            warnings.warn( "MuMuTauTauTree: Expected branch t1AntiElectronMVA3Medium does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t1AntiElectronMVA3Medium")
        else:
            self.t1AntiElectronMVA3Medium_branch.SetAddress(<void*>&self.t1AntiElectronMVA3Medium_value)

        #print "making t1AntiElectronMVA3Raw"
        self.t1AntiElectronMVA3Raw_branch = the_tree.GetBranch("t1AntiElectronMVA3Raw")
        #if not self.t1AntiElectronMVA3Raw_branch and "t1AntiElectronMVA3Raw" not in self.complained:
        if not self.t1AntiElectronMVA3Raw_branch and "t1AntiElectronMVA3Raw":
            warnings.warn( "MuMuTauTauTree: Expected branch t1AntiElectronMVA3Raw does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t1AntiElectronMVA3Raw")
        else:
            self.t1AntiElectronMVA3Raw_branch.SetAddress(<void*>&self.t1AntiElectronMVA3Raw_value)

        #print "making t1AntiElectronMVA3Tight"
        self.t1AntiElectronMVA3Tight_branch = the_tree.GetBranch("t1AntiElectronMVA3Tight")
        #if not self.t1AntiElectronMVA3Tight_branch and "t1AntiElectronMVA3Tight" not in self.complained:
        if not self.t1AntiElectronMVA3Tight_branch and "t1AntiElectronMVA3Tight":
            warnings.warn( "MuMuTauTauTree: Expected branch t1AntiElectronMVA3Tight does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t1AntiElectronMVA3Tight")
        else:
            self.t1AntiElectronMVA3Tight_branch.SetAddress(<void*>&self.t1AntiElectronMVA3Tight_value)

        #print "making t1AntiElectronMVA3VTight"
        self.t1AntiElectronMVA3VTight_branch = the_tree.GetBranch("t1AntiElectronMVA3VTight")
        #if not self.t1AntiElectronMVA3VTight_branch and "t1AntiElectronMVA3VTight" not in self.complained:
        if not self.t1AntiElectronMVA3VTight_branch and "t1AntiElectronMVA3VTight":
            warnings.warn( "MuMuTauTauTree: Expected branch t1AntiElectronMVA3VTight does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t1AntiElectronMVA3VTight")
        else:
            self.t1AntiElectronMVA3VTight_branch.SetAddress(<void*>&self.t1AntiElectronMVA3VTight_value)

        #print "making t1AntiElectronMedium"
        self.t1AntiElectronMedium_branch = the_tree.GetBranch("t1AntiElectronMedium")
        #if not self.t1AntiElectronMedium_branch and "t1AntiElectronMedium" not in self.complained:
        if not self.t1AntiElectronMedium_branch and "t1AntiElectronMedium":
            warnings.warn( "MuMuTauTauTree: Expected branch t1AntiElectronMedium does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t1AntiElectronMedium")
        else:
            self.t1AntiElectronMedium_branch.SetAddress(<void*>&self.t1AntiElectronMedium_value)

        #print "making t1AntiElectronTight"
        self.t1AntiElectronTight_branch = the_tree.GetBranch("t1AntiElectronTight")
        #if not self.t1AntiElectronTight_branch and "t1AntiElectronTight" not in self.complained:
        if not self.t1AntiElectronTight_branch and "t1AntiElectronTight":
            warnings.warn( "MuMuTauTauTree: Expected branch t1AntiElectronTight does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t1AntiElectronTight")
        else:
            self.t1AntiElectronTight_branch.SetAddress(<void*>&self.t1AntiElectronTight_value)

        #print "making t1AntiMuonLoose"
        self.t1AntiMuonLoose_branch = the_tree.GetBranch("t1AntiMuonLoose")
        #if not self.t1AntiMuonLoose_branch and "t1AntiMuonLoose" not in self.complained:
        if not self.t1AntiMuonLoose_branch and "t1AntiMuonLoose":
            warnings.warn( "MuMuTauTauTree: Expected branch t1AntiMuonLoose does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t1AntiMuonLoose")
        else:
            self.t1AntiMuonLoose_branch.SetAddress(<void*>&self.t1AntiMuonLoose_value)

        #print "making t1AntiMuonLoose2"
        self.t1AntiMuonLoose2_branch = the_tree.GetBranch("t1AntiMuonLoose2")
        #if not self.t1AntiMuonLoose2_branch and "t1AntiMuonLoose2" not in self.complained:
        if not self.t1AntiMuonLoose2_branch and "t1AntiMuonLoose2":
            warnings.warn( "MuMuTauTauTree: Expected branch t1AntiMuonLoose2 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t1AntiMuonLoose2")
        else:
            self.t1AntiMuonLoose2_branch.SetAddress(<void*>&self.t1AntiMuonLoose2_value)

        #print "making t1AntiMuonMedium"
        self.t1AntiMuonMedium_branch = the_tree.GetBranch("t1AntiMuonMedium")
        #if not self.t1AntiMuonMedium_branch and "t1AntiMuonMedium" not in self.complained:
        if not self.t1AntiMuonMedium_branch and "t1AntiMuonMedium":
            warnings.warn( "MuMuTauTauTree: Expected branch t1AntiMuonMedium does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t1AntiMuonMedium")
        else:
            self.t1AntiMuonMedium_branch.SetAddress(<void*>&self.t1AntiMuonMedium_value)

        #print "making t1AntiMuonMedium2"
        self.t1AntiMuonMedium2_branch = the_tree.GetBranch("t1AntiMuonMedium2")
        #if not self.t1AntiMuonMedium2_branch and "t1AntiMuonMedium2" not in self.complained:
        if not self.t1AntiMuonMedium2_branch and "t1AntiMuonMedium2":
            warnings.warn( "MuMuTauTauTree: Expected branch t1AntiMuonMedium2 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t1AntiMuonMedium2")
        else:
            self.t1AntiMuonMedium2_branch.SetAddress(<void*>&self.t1AntiMuonMedium2_value)

        #print "making t1AntiMuonTight"
        self.t1AntiMuonTight_branch = the_tree.GetBranch("t1AntiMuonTight")
        #if not self.t1AntiMuonTight_branch and "t1AntiMuonTight" not in self.complained:
        if not self.t1AntiMuonTight_branch and "t1AntiMuonTight":
            warnings.warn( "MuMuTauTauTree: Expected branch t1AntiMuonTight does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t1AntiMuonTight")
        else:
            self.t1AntiMuonTight_branch.SetAddress(<void*>&self.t1AntiMuonTight_value)

        #print "making t1AntiMuonTight2"
        self.t1AntiMuonTight2_branch = the_tree.GetBranch("t1AntiMuonTight2")
        #if not self.t1AntiMuonTight2_branch and "t1AntiMuonTight2" not in self.complained:
        if not self.t1AntiMuonTight2_branch and "t1AntiMuonTight2":
            warnings.warn( "MuMuTauTauTree: Expected branch t1AntiMuonTight2 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t1AntiMuonTight2")
        else:
            self.t1AntiMuonTight2_branch.SetAddress(<void*>&self.t1AntiMuonTight2_value)

        #print "making t1Charge"
        self.t1Charge_branch = the_tree.GetBranch("t1Charge")
        #if not self.t1Charge_branch and "t1Charge" not in self.complained:
        if not self.t1Charge_branch and "t1Charge":
            warnings.warn( "MuMuTauTauTree: Expected branch t1Charge does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t1Charge")
        else:
            self.t1Charge_branch.SetAddress(<void*>&self.t1Charge_value)

        #print "making t1CiCTightElecOverlap"
        self.t1CiCTightElecOverlap_branch = the_tree.GetBranch("t1CiCTightElecOverlap")
        #if not self.t1CiCTightElecOverlap_branch and "t1CiCTightElecOverlap" not in self.complained:
        if not self.t1CiCTightElecOverlap_branch and "t1CiCTightElecOverlap":
            warnings.warn( "MuMuTauTauTree: Expected branch t1CiCTightElecOverlap does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t1CiCTightElecOverlap")
        else:
            self.t1CiCTightElecOverlap_branch.SetAddress(<void*>&self.t1CiCTightElecOverlap_value)

        #print "making t1DZ"
        self.t1DZ_branch = the_tree.GetBranch("t1DZ")
        #if not self.t1DZ_branch and "t1DZ" not in self.complained:
        if not self.t1DZ_branch and "t1DZ":
            warnings.warn( "MuMuTauTauTree: Expected branch t1DZ does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t1DZ")
        else:
            self.t1DZ_branch.SetAddress(<void*>&self.t1DZ_value)

        #print "making t1DecayFinding"
        self.t1DecayFinding_branch = the_tree.GetBranch("t1DecayFinding")
        #if not self.t1DecayFinding_branch and "t1DecayFinding" not in self.complained:
        if not self.t1DecayFinding_branch and "t1DecayFinding":
            warnings.warn( "MuMuTauTauTree: Expected branch t1DecayFinding does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t1DecayFinding")
        else:
            self.t1DecayFinding_branch.SetAddress(<void*>&self.t1DecayFinding_value)

        #print "making t1DecayMode"
        self.t1DecayMode_branch = the_tree.GetBranch("t1DecayMode")
        #if not self.t1DecayMode_branch and "t1DecayMode" not in self.complained:
        if not self.t1DecayMode_branch and "t1DecayMode":
            warnings.warn( "MuMuTauTauTree: Expected branch t1DecayMode does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t1DecayMode")
        else:
            self.t1DecayMode_branch.SetAddress(<void*>&self.t1DecayMode_value)

        #print "making t1ElecOverlap"
        self.t1ElecOverlap_branch = the_tree.GetBranch("t1ElecOverlap")
        #if not self.t1ElecOverlap_branch and "t1ElecOverlap" not in self.complained:
        if not self.t1ElecOverlap_branch and "t1ElecOverlap":
            warnings.warn( "MuMuTauTauTree: Expected branch t1ElecOverlap does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t1ElecOverlap")
        else:
            self.t1ElecOverlap_branch.SetAddress(<void*>&self.t1ElecOverlap_value)

        #print "making t1ElecOverlapZHLoose"
        self.t1ElecOverlapZHLoose_branch = the_tree.GetBranch("t1ElecOverlapZHLoose")
        #if not self.t1ElecOverlapZHLoose_branch and "t1ElecOverlapZHLoose" not in self.complained:
        if not self.t1ElecOverlapZHLoose_branch and "t1ElecOverlapZHLoose":
            warnings.warn( "MuMuTauTauTree: Expected branch t1ElecOverlapZHLoose does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t1ElecOverlapZHLoose")
        else:
            self.t1ElecOverlapZHLoose_branch.SetAddress(<void*>&self.t1ElecOverlapZHLoose_value)

        #print "making t1ElecOverlapZHTight"
        self.t1ElecOverlapZHTight_branch = the_tree.GetBranch("t1ElecOverlapZHTight")
        #if not self.t1ElecOverlapZHTight_branch and "t1ElecOverlapZHTight" not in self.complained:
        if not self.t1ElecOverlapZHTight_branch and "t1ElecOverlapZHTight":
            warnings.warn( "MuMuTauTauTree: Expected branch t1ElecOverlapZHTight does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t1ElecOverlapZHTight")
        else:
            self.t1ElecOverlapZHTight_branch.SetAddress(<void*>&self.t1ElecOverlapZHTight_value)

        #print "making t1Eta"
        self.t1Eta_branch = the_tree.GetBranch("t1Eta")
        #if not self.t1Eta_branch and "t1Eta" not in self.complained:
        if not self.t1Eta_branch and "t1Eta":
            warnings.warn( "MuMuTauTauTree: Expected branch t1Eta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t1Eta")
        else:
            self.t1Eta_branch.SetAddress(<void*>&self.t1Eta_value)

        #print "making t1GenDecayMode"
        self.t1GenDecayMode_branch = the_tree.GetBranch("t1GenDecayMode")
        #if not self.t1GenDecayMode_branch and "t1GenDecayMode" not in self.complained:
        if not self.t1GenDecayMode_branch and "t1GenDecayMode":
            warnings.warn( "MuMuTauTauTree: Expected branch t1GenDecayMode does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t1GenDecayMode")
        else:
            self.t1GenDecayMode_branch.SetAddress(<void*>&self.t1GenDecayMode_value)

        #print "making t1IP3DS"
        self.t1IP3DS_branch = the_tree.GetBranch("t1IP3DS")
        #if not self.t1IP3DS_branch and "t1IP3DS" not in self.complained:
        if not self.t1IP3DS_branch and "t1IP3DS":
            warnings.warn( "MuMuTauTauTree: Expected branch t1IP3DS does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t1IP3DS")
        else:
            self.t1IP3DS_branch.SetAddress(<void*>&self.t1IP3DS_value)

        #print "making t1JetArea"
        self.t1JetArea_branch = the_tree.GetBranch("t1JetArea")
        #if not self.t1JetArea_branch and "t1JetArea" not in self.complained:
        if not self.t1JetArea_branch and "t1JetArea":
            warnings.warn( "MuMuTauTauTree: Expected branch t1JetArea does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t1JetArea")
        else:
            self.t1JetArea_branch.SetAddress(<void*>&self.t1JetArea_value)

        #print "making t1JetBtag"
        self.t1JetBtag_branch = the_tree.GetBranch("t1JetBtag")
        #if not self.t1JetBtag_branch and "t1JetBtag" not in self.complained:
        if not self.t1JetBtag_branch and "t1JetBtag":
            warnings.warn( "MuMuTauTauTree: Expected branch t1JetBtag does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t1JetBtag")
        else:
            self.t1JetBtag_branch.SetAddress(<void*>&self.t1JetBtag_value)

        #print "making t1JetCSVBtag"
        self.t1JetCSVBtag_branch = the_tree.GetBranch("t1JetCSVBtag")
        #if not self.t1JetCSVBtag_branch and "t1JetCSVBtag" not in self.complained:
        if not self.t1JetCSVBtag_branch and "t1JetCSVBtag":
            warnings.warn( "MuMuTauTauTree: Expected branch t1JetCSVBtag does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t1JetCSVBtag")
        else:
            self.t1JetCSVBtag_branch.SetAddress(<void*>&self.t1JetCSVBtag_value)

        #print "making t1JetEtaEtaMoment"
        self.t1JetEtaEtaMoment_branch = the_tree.GetBranch("t1JetEtaEtaMoment")
        #if not self.t1JetEtaEtaMoment_branch and "t1JetEtaEtaMoment" not in self.complained:
        if not self.t1JetEtaEtaMoment_branch and "t1JetEtaEtaMoment":
            warnings.warn( "MuMuTauTauTree: Expected branch t1JetEtaEtaMoment does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t1JetEtaEtaMoment")
        else:
            self.t1JetEtaEtaMoment_branch.SetAddress(<void*>&self.t1JetEtaEtaMoment_value)

        #print "making t1JetEtaPhiMoment"
        self.t1JetEtaPhiMoment_branch = the_tree.GetBranch("t1JetEtaPhiMoment")
        #if not self.t1JetEtaPhiMoment_branch and "t1JetEtaPhiMoment" not in self.complained:
        if not self.t1JetEtaPhiMoment_branch and "t1JetEtaPhiMoment":
            warnings.warn( "MuMuTauTauTree: Expected branch t1JetEtaPhiMoment does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t1JetEtaPhiMoment")
        else:
            self.t1JetEtaPhiMoment_branch.SetAddress(<void*>&self.t1JetEtaPhiMoment_value)

        #print "making t1JetEtaPhiSpread"
        self.t1JetEtaPhiSpread_branch = the_tree.GetBranch("t1JetEtaPhiSpread")
        #if not self.t1JetEtaPhiSpread_branch and "t1JetEtaPhiSpread" not in self.complained:
        if not self.t1JetEtaPhiSpread_branch and "t1JetEtaPhiSpread":
            warnings.warn( "MuMuTauTauTree: Expected branch t1JetEtaPhiSpread does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t1JetEtaPhiSpread")
        else:
            self.t1JetEtaPhiSpread_branch.SetAddress(<void*>&self.t1JetEtaPhiSpread_value)

        #print "making t1JetPartonFlavour"
        self.t1JetPartonFlavour_branch = the_tree.GetBranch("t1JetPartonFlavour")
        #if not self.t1JetPartonFlavour_branch and "t1JetPartonFlavour" not in self.complained:
        if not self.t1JetPartonFlavour_branch and "t1JetPartonFlavour":
            warnings.warn( "MuMuTauTauTree: Expected branch t1JetPartonFlavour does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t1JetPartonFlavour")
        else:
            self.t1JetPartonFlavour_branch.SetAddress(<void*>&self.t1JetPartonFlavour_value)

        #print "making t1JetPhiPhiMoment"
        self.t1JetPhiPhiMoment_branch = the_tree.GetBranch("t1JetPhiPhiMoment")
        #if not self.t1JetPhiPhiMoment_branch and "t1JetPhiPhiMoment" not in self.complained:
        if not self.t1JetPhiPhiMoment_branch and "t1JetPhiPhiMoment":
            warnings.warn( "MuMuTauTauTree: Expected branch t1JetPhiPhiMoment does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t1JetPhiPhiMoment")
        else:
            self.t1JetPhiPhiMoment_branch.SetAddress(<void*>&self.t1JetPhiPhiMoment_value)

        #print "making t1JetPt"
        self.t1JetPt_branch = the_tree.GetBranch("t1JetPt")
        #if not self.t1JetPt_branch and "t1JetPt" not in self.complained:
        if not self.t1JetPt_branch and "t1JetPt":
            warnings.warn( "MuMuTauTauTree: Expected branch t1JetPt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t1JetPt")
        else:
            self.t1JetPt_branch.SetAddress(<void*>&self.t1JetPt_value)

        #print "making t1JetQGLikelihoodID"
        self.t1JetQGLikelihoodID_branch = the_tree.GetBranch("t1JetQGLikelihoodID")
        #if not self.t1JetQGLikelihoodID_branch and "t1JetQGLikelihoodID" not in self.complained:
        if not self.t1JetQGLikelihoodID_branch and "t1JetQGLikelihoodID":
            warnings.warn( "MuMuTauTauTree: Expected branch t1JetQGLikelihoodID does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t1JetQGLikelihoodID")
        else:
            self.t1JetQGLikelihoodID_branch.SetAddress(<void*>&self.t1JetQGLikelihoodID_value)

        #print "making t1JetQGMVAID"
        self.t1JetQGMVAID_branch = the_tree.GetBranch("t1JetQGMVAID")
        #if not self.t1JetQGMVAID_branch and "t1JetQGMVAID" not in self.complained:
        if not self.t1JetQGMVAID_branch and "t1JetQGMVAID":
            warnings.warn( "MuMuTauTauTree: Expected branch t1JetQGMVAID does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t1JetQGMVAID")
        else:
            self.t1JetQGMVAID_branch.SetAddress(<void*>&self.t1JetQGMVAID_value)

        #print "making t1Jetaxis1"
        self.t1Jetaxis1_branch = the_tree.GetBranch("t1Jetaxis1")
        #if not self.t1Jetaxis1_branch and "t1Jetaxis1" not in self.complained:
        if not self.t1Jetaxis1_branch and "t1Jetaxis1":
            warnings.warn( "MuMuTauTauTree: Expected branch t1Jetaxis1 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t1Jetaxis1")
        else:
            self.t1Jetaxis1_branch.SetAddress(<void*>&self.t1Jetaxis1_value)

        #print "making t1Jetaxis2"
        self.t1Jetaxis2_branch = the_tree.GetBranch("t1Jetaxis2")
        #if not self.t1Jetaxis2_branch and "t1Jetaxis2" not in self.complained:
        if not self.t1Jetaxis2_branch and "t1Jetaxis2":
            warnings.warn( "MuMuTauTauTree: Expected branch t1Jetaxis2 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t1Jetaxis2")
        else:
            self.t1Jetaxis2_branch.SetAddress(<void*>&self.t1Jetaxis2_value)

        #print "making t1Jetmult"
        self.t1Jetmult_branch = the_tree.GetBranch("t1Jetmult")
        #if not self.t1Jetmult_branch and "t1Jetmult" not in self.complained:
        if not self.t1Jetmult_branch and "t1Jetmult":
            warnings.warn( "MuMuTauTauTree: Expected branch t1Jetmult does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t1Jetmult")
        else:
            self.t1Jetmult_branch.SetAddress(<void*>&self.t1Jetmult_value)

        #print "making t1JetmultMLP"
        self.t1JetmultMLP_branch = the_tree.GetBranch("t1JetmultMLP")
        #if not self.t1JetmultMLP_branch and "t1JetmultMLP" not in self.complained:
        if not self.t1JetmultMLP_branch and "t1JetmultMLP":
            warnings.warn( "MuMuTauTauTree: Expected branch t1JetmultMLP does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t1JetmultMLP")
        else:
            self.t1JetmultMLP_branch.SetAddress(<void*>&self.t1JetmultMLP_value)

        #print "making t1JetmultMLPQC"
        self.t1JetmultMLPQC_branch = the_tree.GetBranch("t1JetmultMLPQC")
        #if not self.t1JetmultMLPQC_branch and "t1JetmultMLPQC" not in self.complained:
        if not self.t1JetmultMLPQC_branch and "t1JetmultMLPQC":
            warnings.warn( "MuMuTauTauTree: Expected branch t1JetmultMLPQC does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t1JetmultMLPQC")
        else:
            self.t1JetmultMLPQC_branch.SetAddress(<void*>&self.t1JetmultMLPQC_value)

        #print "making t1JetptD"
        self.t1JetptD_branch = the_tree.GetBranch("t1JetptD")
        #if not self.t1JetptD_branch and "t1JetptD" not in self.complained:
        if not self.t1JetptD_branch and "t1JetptD":
            warnings.warn( "MuMuTauTauTree: Expected branch t1JetptD does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t1JetptD")
        else:
            self.t1JetptD_branch.SetAddress(<void*>&self.t1JetptD_value)

        #print "making t1LeadTrackPt"
        self.t1LeadTrackPt_branch = the_tree.GetBranch("t1LeadTrackPt")
        #if not self.t1LeadTrackPt_branch and "t1LeadTrackPt" not in self.complained:
        if not self.t1LeadTrackPt_branch and "t1LeadTrackPt":
            warnings.warn( "MuMuTauTauTree: Expected branch t1LeadTrackPt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t1LeadTrackPt")
        else:
            self.t1LeadTrackPt_branch.SetAddress(<void*>&self.t1LeadTrackPt_value)

        #print "making t1LooseIso"
        self.t1LooseIso_branch = the_tree.GetBranch("t1LooseIso")
        #if not self.t1LooseIso_branch and "t1LooseIso" not in self.complained:
        if not self.t1LooseIso_branch and "t1LooseIso":
            warnings.warn( "MuMuTauTauTree: Expected branch t1LooseIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t1LooseIso")
        else:
            self.t1LooseIso_branch.SetAddress(<void*>&self.t1LooseIso_value)

        #print "making t1LooseIso3Hits"
        self.t1LooseIso3Hits_branch = the_tree.GetBranch("t1LooseIso3Hits")
        #if not self.t1LooseIso3Hits_branch and "t1LooseIso3Hits" not in self.complained:
        if not self.t1LooseIso3Hits_branch and "t1LooseIso3Hits":
            warnings.warn( "MuMuTauTauTree: Expected branch t1LooseIso3Hits does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t1LooseIso3Hits")
        else:
            self.t1LooseIso3Hits_branch.SetAddress(<void*>&self.t1LooseIso3Hits_value)

        #print "making t1LooseMVA2Iso"
        self.t1LooseMVA2Iso_branch = the_tree.GetBranch("t1LooseMVA2Iso")
        #if not self.t1LooseMVA2Iso_branch and "t1LooseMVA2Iso" not in self.complained:
        if not self.t1LooseMVA2Iso_branch and "t1LooseMVA2Iso":
            warnings.warn( "MuMuTauTauTree: Expected branch t1LooseMVA2Iso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t1LooseMVA2Iso")
        else:
            self.t1LooseMVA2Iso_branch.SetAddress(<void*>&self.t1LooseMVA2Iso_value)

        #print "making t1LooseMVAIso"
        self.t1LooseMVAIso_branch = the_tree.GetBranch("t1LooseMVAIso")
        #if not self.t1LooseMVAIso_branch and "t1LooseMVAIso" not in self.complained:
        if not self.t1LooseMVAIso_branch and "t1LooseMVAIso":
            warnings.warn( "MuMuTauTauTree: Expected branch t1LooseMVAIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t1LooseMVAIso")
        else:
            self.t1LooseMVAIso_branch.SetAddress(<void*>&self.t1LooseMVAIso_value)

        #print "making t1MVA2IsoRaw"
        self.t1MVA2IsoRaw_branch = the_tree.GetBranch("t1MVA2IsoRaw")
        #if not self.t1MVA2IsoRaw_branch and "t1MVA2IsoRaw" not in self.complained:
        if not self.t1MVA2IsoRaw_branch and "t1MVA2IsoRaw":
            warnings.warn( "MuMuTauTauTree: Expected branch t1MVA2IsoRaw does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t1MVA2IsoRaw")
        else:
            self.t1MVA2IsoRaw_branch.SetAddress(<void*>&self.t1MVA2IsoRaw_value)

        #print "making t1Mass"
        self.t1Mass_branch = the_tree.GetBranch("t1Mass")
        #if not self.t1Mass_branch and "t1Mass" not in self.complained:
        if not self.t1Mass_branch and "t1Mass":
            warnings.warn( "MuMuTauTauTree: Expected branch t1Mass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t1Mass")
        else:
            self.t1Mass_branch.SetAddress(<void*>&self.t1Mass_value)

        #print "making t1MediumIso"
        self.t1MediumIso_branch = the_tree.GetBranch("t1MediumIso")
        #if not self.t1MediumIso_branch and "t1MediumIso" not in self.complained:
        if not self.t1MediumIso_branch and "t1MediumIso":
            warnings.warn( "MuMuTauTauTree: Expected branch t1MediumIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t1MediumIso")
        else:
            self.t1MediumIso_branch.SetAddress(<void*>&self.t1MediumIso_value)

        #print "making t1MediumIso3Hits"
        self.t1MediumIso3Hits_branch = the_tree.GetBranch("t1MediumIso3Hits")
        #if not self.t1MediumIso3Hits_branch and "t1MediumIso3Hits" not in self.complained:
        if not self.t1MediumIso3Hits_branch and "t1MediumIso3Hits":
            warnings.warn( "MuMuTauTauTree: Expected branch t1MediumIso3Hits does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t1MediumIso3Hits")
        else:
            self.t1MediumIso3Hits_branch.SetAddress(<void*>&self.t1MediumIso3Hits_value)

        #print "making t1MediumMVA2Iso"
        self.t1MediumMVA2Iso_branch = the_tree.GetBranch("t1MediumMVA2Iso")
        #if not self.t1MediumMVA2Iso_branch and "t1MediumMVA2Iso" not in self.complained:
        if not self.t1MediumMVA2Iso_branch and "t1MediumMVA2Iso":
            warnings.warn( "MuMuTauTauTree: Expected branch t1MediumMVA2Iso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t1MediumMVA2Iso")
        else:
            self.t1MediumMVA2Iso_branch.SetAddress(<void*>&self.t1MediumMVA2Iso_value)

        #print "making t1MediumMVAIso"
        self.t1MediumMVAIso_branch = the_tree.GetBranch("t1MediumMVAIso")
        #if not self.t1MediumMVAIso_branch and "t1MediumMVAIso" not in self.complained:
        if not self.t1MediumMVAIso_branch and "t1MediumMVAIso":
            warnings.warn( "MuMuTauTauTree: Expected branch t1MediumMVAIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t1MediumMVAIso")
        else:
            self.t1MediumMVAIso_branch.SetAddress(<void*>&self.t1MediumMVAIso_value)

        #print "making t1MtToMET"
        self.t1MtToMET_branch = the_tree.GetBranch("t1MtToMET")
        #if not self.t1MtToMET_branch and "t1MtToMET" not in self.complained:
        if not self.t1MtToMET_branch and "t1MtToMET":
            warnings.warn( "MuMuTauTauTree: Expected branch t1MtToMET does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t1MtToMET")
        else:
            self.t1MtToMET_branch.SetAddress(<void*>&self.t1MtToMET_value)

        #print "making t1MtToMVAMET"
        self.t1MtToMVAMET_branch = the_tree.GetBranch("t1MtToMVAMET")
        #if not self.t1MtToMVAMET_branch and "t1MtToMVAMET" not in self.complained:
        if not self.t1MtToMVAMET_branch and "t1MtToMVAMET":
            warnings.warn( "MuMuTauTauTree: Expected branch t1MtToMVAMET does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t1MtToMVAMET")
        else:
            self.t1MtToMVAMET_branch.SetAddress(<void*>&self.t1MtToMVAMET_value)

        #print "making t1MtToPFMET"
        self.t1MtToPFMET_branch = the_tree.GetBranch("t1MtToPFMET")
        #if not self.t1MtToPFMET_branch and "t1MtToPFMET" not in self.complained:
        if not self.t1MtToPFMET_branch and "t1MtToPFMET":
            warnings.warn( "MuMuTauTauTree: Expected branch t1MtToPFMET does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t1MtToPFMET")
        else:
            self.t1MtToPFMET_branch.SetAddress(<void*>&self.t1MtToPFMET_value)

        #print "making t1MtToPfMet_Ty1"
        self.t1MtToPfMet_Ty1_branch = the_tree.GetBranch("t1MtToPfMet_Ty1")
        #if not self.t1MtToPfMet_Ty1_branch and "t1MtToPfMet_Ty1" not in self.complained:
        if not self.t1MtToPfMet_Ty1_branch and "t1MtToPfMet_Ty1":
            warnings.warn( "MuMuTauTauTree: Expected branch t1MtToPfMet_Ty1 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t1MtToPfMet_Ty1")
        else:
            self.t1MtToPfMet_Ty1_branch.SetAddress(<void*>&self.t1MtToPfMet_Ty1_value)

        #print "making t1MtToPfMet_jes"
        self.t1MtToPfMet_jes_branch = the_tree.GetBranch("t1MtToPfMet_jes")
        #if not self.t1MtToPfMet_jes_branch and "t1MtToPfMet_jes" not in self.complained:
        if not self.t1MtToPfMet_jes_branch and "t1MtToPfMet_jes":
            warnings.warn( "MuMuTauTauTree: Expected branch t1MtToPfMet_jes does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t1MtToPfMet_jes")
        else:
            self.t1MtToPfMet_jes_branch.SetAddress(<void*>&self.t1MtToPfMet_jes_value)

        #print "making t1MtToPfMet_mes"
        self.t1MtToPfMet_mes_branch = the_tree.GetBranch("t1MtToPfMet_mes")
        #if not self.t1MtToPfMet_mes_branch and "t1MtToPfMet_mes" not in self.complained:
        if not self.t1MtToPfMet_mes_branch and "t1MtToPfMet_mes":
            warnings.warn( "MuMuTauTauTree: Expected branch t1MtToPfMet_mes does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t1MtToPfMet_mes")
        else:
            self.t1MtToPfMet_mes_branch.SetAddress(<void*>&self.t1MtToPfMet_mes_value)

        #print "making t1MtToPfMet_tes"
        self.t1MtToPfMet_tes_branch = the_tree.GetBranch("t1MtToPfMet_tes")
        #if not self.t1MtToPfMet_tes_branch and "t1MtToPfMet_tes" not in self.complained:
        if not self.t1MtToPfMet_tes_branch and "t1MtToPfMet_tes":
            warnings.warn( "MuMuTauTauTree: Expected branch t1MtToPfMet_tes does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t1MtToPfMet_tes")
        else:
            self.t1MtToPfMet_tes_branch.SetAddress(<void*>&self.t1MtToPfMet_tes_value)

        #print "making t1MtToPfMet_ues"
        self.t1MtToPfMet_ues_branch = the_tree.GetBranch("t1MtToPfMet_ues")
        #if not self.t1MtToPfMet_ues_branch and "t1MtToPfMet_ues" not in self.complained:
        if not self.t1MtToPfMet_ues_branch and "t1MtToPfMet_ues":
            warnings.warn( "MuMuTauTauTree: Expected branch t1MtToPfMet_ues does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t1MtToPfMet_ues")
        else:
            self.t1MtToPfMet_ues_branch.SetAddress(<void*>&self.t1MtToPfMet_ues_value)

        #print "making t1MuOverlap"
        self.t1MuOverlap_branch = the_tree.GetBranch("t1MuOverlap")
        #if not self.t1MuOverlap_branch and "t1MuOverlap" not in self.complained:
        if not self.t1MuOverlap_branch and "t1MuOverlap":
            warnings.warn( "MuMuTauTauTree: Expected branch t1MuOverlap does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t1MuOverlap")
        else:
            self.t1MuOverlap_branch.SetAddress(<void*>&self.t1MuOverlap_value)

        #print "making t1MuOverlapZHLoose"
        self.t1MuOverlapZHLoose_branch = the_tree.GetBranch("t1MuOverlapZHLoose")
        #if not self.t1MuOverlapZHLoose_branch and "t1MuOverlapZHLoose" not in self.complained:
        if not self.t1MuOverlapZHLoose_branch and "t1MuOverlapZHLoose":
            warnings.warn( "MuMuTauTauTree: Expected branch t1MuOverlapZHLoose does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t1MuOverlapZHLoose")
        else:
            self.t1MuOverlapZHLoose_branch.SetAddress(<void*>&self.t1MuOverlapZHLoose_value)

        #print "making t1MuOverlapZHTight"
        self.t1MuOverlapZHTight_branch = the_tree.GetBranch("t1MuOverlapZHTight")
        #if not self.t1MuOverlapZHTight_branch and "t1MuOverlapZHTight" not in self.complained:
        if not self.t1MuOverlapZHTight_branch and "t1MuOverlapZHTight":
            warnings.warn( "MuMuTauTauTree: Expected branch t1MuOverlapZHTight does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t1MuOverlapZHTight")
        else:
            self.t1MuOverlapZHTight_branch.SetAddress(<void*>&self.t1MuOverlapZHTight_value)

        #print "making t1Phi"
        self.t1Phi_branch = the_tree.GetBranch("t1Phi")
        #if not self.t1Phi_branch and "t1Phi" not in self.complained:
        if not self.t1Phi_branch and "t1Phi":
            warnings.warn( "MuMuTauTauTree: Expected branch t1Phi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t1Phi")
        else:
            self.t1Phi_branch.SetAddress(<void*>&self.t1Phi_value)

        #print "making t1Pt"
        self.t1Pt_branch = the_tree.GetBranch("t1Pt")
        #if not self.t1Pt_branch and "t1Pt" not in self.complained:
        if not self.t1Pt_branch and "t1Pt":
            warnings.warn( "MuMuTauTauTree: Expected branch t1Pt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t1Pt")
        else:
            self.t1Pt_branch.SetAddress(<void*>&self.t1Pt_value)

        #print "making t1Rank"
        self.t1Rank_branch = the_tree.GetBranch("t1Rank")
        #if not self.t1Rank_branch and "t1Rank" not in self.complained:
        if not self.t1Rank_branch and "t1Rank":
            warnings.warn( "MuMuTauTauTree: Expected branch t1Rank does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t1Rank")
        else:
            self.t1Rank_branch.SetAddress(<void*>&self.t1Rank_value)

        #print "making t1TNPId"
        self.t1TNPId_branch = the_tree.GetBranch("t1TNPId")
        #if not self.t1TNPId_branch and "t1TNPId" not in self.complained:
        if not self.t1TNPId_branch and "t1TNPId":
            warnings.warn( "MuMuTauTauTree: Expected branch t1TNPId does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t1TNPId")
        else:
            self.t1TNPId_branch.SetAddress(<void*>&self.t1TNPId_value)

        #print "making t1TightIso"
        self.t1TightIso_branch = the_tree.GetBranch("t1TightIso")
        #if not self.t1TightIso_branch and "t1TightIso" not in self.complained:
        if not self.t1TightIso_branch and "t1TightIso":
            warnings.warn( "MuMuTauTauTree: Expected branch t1TightIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t1TightIso")
        else:
            self.t1TightIso_branch.SetAddress(<void*>&self.t1TightIso_value)

        #print "making t1TightIso3Hits"
        self.t1TightIso3Hits_branch = the_tree.GetBranch("t1TightIso3Hits")
        #if not self.t1TightIso3Hits_branch and "t1TightIso3Hits" not in self.complained:
        if not self.t1TightIso3Hits_branch and "t1TightIso3Hits":
            warnings.warn( "MuMuTauTauTree: Expected branch t1TightIso3Hits does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t1TightIso3Hits")
        else:
            self.t1TightIso3Hits_branch.SetAddress(<void*>&self.t1TightIso3Hits_value)

        #print "making t1TightMVA2Iso"
        self.t1TightMVA2Iso_branch = the_tree.GetBranch("t1TightMVA2Iso")
        #if not self.t1TightMVA2Iso_branch and "t1TightMVA2Iso" not in self.complained:
        if not self.t1TightMVA2Iso_branch and "t1TightMVA2Iso":
            warnings.warn( "MuMuTauTauTree: Expected branch t1TightMVA2Iso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t1TightMVA2Iso")
        else:
            self.t1TightMVA2Iso_branch.SetAddress(<void*>&self.t1TightMVA2Iso_value)

        #print "making t1TightMVAIso"
        self.t1TightMVAIso_branch = the_tree.GetBranch("t1TightMVAIso")
        #if not self.t1TightMVAIso_branch and "t1TightMVAIso" not in self.complained:
        if not self.t1TightMVAIso_branch and "t1TightMVAIso":
            warnings.warn( "MuMuTauTauTree: Expected branch t1TightMVAIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t1TightMVAIso")
        else:
            self.t1TightMVAIso_branch.SetAddress(<void*>&self.t1TightMVAIso_value)

        #print "making t1ToMETDPhi"
        self.t1ToMETDPhi_branch = the_tree.GetBranch("t1ToMETDPhi")
        #if not self.t1ToMETDPhi_branch and "t1ToMETDPhi" not in self.complained:
        if not self.t1ToMETDPhi_branch and "t1ToMETDPhi":
            warnings.warn( "MuMuTauTauTree: Expected branch t1ToMETDPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t1ToMETDPhi")
        else:
            self.t1ToMETDPhi_branch.SetAddress(<void*>&self.t1ToMETDPhi_value)

        #print "making t1VLooseIso"
        self.t1VLooseIso_branch = the_tree.GetBranch("t1VLooseIso")
        #if not self.t1VLooseIso_branch and "t1VLooseIso" not in self.complained:
        if not self.t1VLooseIso_branch and "t1VLooseIso":
            warnings.warn( "MuMuTauTauTree: Expected branch t1VLooseIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t1VLooseIso")
        else:
            self.t1VLooseIso_branch.SetAddress(<void*>&self.t1VLooseIso_value)

        #print "making t1VZ"
        self.t1VZ_branch = the_tree.GetBranch("t1VZ")
        #if not self.t1VZ_branch and "t1VZ" not in self.complained:
        if not self.t1VZ_branch and "t1VZ":
            warnings.warn( "MuMuTauTauTree: Expected branch t1VZ does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t1VZ")
        else:
            self.t1VZ_branch.SetAddress(<void*>&self.t1VZ_value)

        #print "making t1_t2_CosThetaStar"
        self.t1_t2_CosThetaStar_branch = the_tree.GetBranch("t1_t2_CosThetaStar")
        #if not self.t1_t2_CosThetaStar_branch and "t1_t2_CosThetaStar" not in self.complained:
        if not self.t1_t2_CosThetaStar_branch and "t1_t2_CosThetaStar":
            warnings.warn( "MuMuTauTauTree: Expected branch t1_t2_CosThetaStar does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t1_t2_CosThetaStar")
        else:
            self.t1_t2_CosThetaStar_branch.SetAddress(<void*>&self.t1_t2_CosThetaStar_value)

        #print "making t1_t2_DPhi"
        self.t1_t2_DPhi_branch = the_tree.GetBranch("t1_t2_DPhi")
        #if not self.t1_t2_DPhi_branch and "t1_t2_DPhi" not in self.complained:
        if not self.t1_t2_DPhi_branch and "t1_t2_DPhi":
            warnings.warn( "MuMuTauTauTree: Expected branch t1_t2_DPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t1_t2_DPhi")
        else:
            self.t1_t2_DPhi_branch.SetAddress(<void*>&self.t1_t2_DPhi_value)

        #print "making t1_t2_DR"
        self.t1_t2_DR_branch = the_tree.GetBranch("t1_t2_DR")
        #if not self.t1_t2_DR_branch and "t1_t2_DR" not in self.complained:
        if not self.t1_t2_DR_branch and "t1_t2_DR":
            warnings.warn( "MuMuTauTauTree: Expected branch t1_t2_DR does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t1_t2_DR")
        else:
            self.t1_t2_DR_branch.SetAddress(<void*>&self.t1_t2_DR_value)

        #print "making t1_t2_Eta"
        self.t1_t2_Eta_branch = the_tree.GetBranch("t1_t2_Eta")
        #if not self.t1_t2_Eta_branch and "t1_t2_Eta" not in self.complained:
        if not self.t1_t2_Eta_branch and "t1_t2_Eta":
            warnings.warn( "MuMuTauTauTree: Expected branch t1_t2_Eta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t1_t2_Eta")
        else:
            self.t1_t2_Eta_branch.SetAddress(<void*>&self.t1_t2_Eta_value)

        #print "making t1_t2_Mass"
        self.t1_t2_Mass_branch = the_tree.GetBranch("t1_t2_Mass")
        #if not self.t1_t2_Mass_branch and "t1_t2_Mass" not in self.complained:
        if not self.t1_t2_Mass_branch and "t1_t2_Mass":
            warnings.warn( "MuMuTauTauTree: Expected branch t1_t2_Mass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t1_t2_Mass")
        else:
            self.t1_t2_Mass_branch.SetAddress(<void*>&self.t1_t2_Mass_value)

        #print "making t1_t2_MassFsr"
        self.t1_t2_MassFsr_branch = the_tree.GetBranch("t1_t2_MassFsr")
        #if not self.t1_t2_MassFsr_branch and "t1_t2_MassFsr" not in self.complained:
        if not self.t1_t2_MassFsr_branch and "t1_t2_MassFsr":
            warnings.warn( "MuMuTauTauTree: Expected branch t1_t2_MassFsr does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t1_t2_MassFsr")
        else:
            self.t1_t2_MassFsr_branch.SetAddress(<void*>&self.t1_t2_MassFsr_value)

        #print "making t1_t2_PZeta"
        self.t1_t2_PZeta_branch = the_tree.GetBranch("t1_t2_PZeta")
        #if not self.t1_t2_PZeta_branch and "t1_t2_PZeta" not in self.complained:
        if not self.t1_t2_PZeta_branch and "t1_t2_PZeta":
            warnings.warn( "MuMuTauTauTree: Expected branch t1_t2_PZeta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t1_t2_PZeta")
        else:
            self.t1_t2_PZeta_branch.SetAddress(<void*>&self.t1_t2_PZeta_value)

        #print "making t1_t2_PZetaVis"
        self.t1_t2_PZetaVis_branch = the_tree.GetBranch("t1_t2_PZetaVis")
        #if not self.t1_t2_PZetaVis_branch and "t1_t2_PZetaVis" not in self.complained:
        if not self.t1_t2_PZetaVis_branch and "t1_t2_PZetaVis":
            warnings.warn( "MuMuTauTauTree: Expected branch t1_t2_PZetaVis does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t1_t2_PZetaVis")
        else:
            self.t1_t2_PZetaVis_branch.SetAddress(<void*>&self.t1_t2_PZetaVis_value)

        #print "making t1_t2_Phi"
        self.t1_t2_Phi_branch = the_tree.GetBranch("t1_t2_Phi")
        #if not self.t1_t2_Phi_branch and "t1_t2_Phi" not in self.complained:
        if not self.t1_t2_Phi_branch and "t1_t2_Phi":
            warnings.warn( "MuMuTauTauTree: Expected branch t1_t2_Phi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t1_t2_Phi")
        else:
            self.t1_t2_Phi_branch.SetAddress(<void*>&self.t1_t2_Phi_value)

        #print "making t1_t2_Pt"
        self.t1_t2_Pt_branch = the_tree.GetBranch("t1_t2_Pt")
        #if not self.t1_t2_Pt_branch and "t1_t2_Pt" not in self.complained:
        if not self.t1_t2_Pt_branch and "t1_t2_Pt":
            warnings.warn( "MuMuTauTauTree: Expected branch t1_t2_Pt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t1_t2_Pt")
        else:
            self.t1_t2_Pt_branch.SetAddress(<void*>&self.t1_t2_Pt_value)

        #print "making t1_t2_PtFsr"
        self.t1_t2_PtFsr_branch = the_tree.GetBranch("t1_t2_PtFsr")
        #if not self.t1_t2_PtFsr_branch and "t1_t2_PtFsr" not in self.complained:
        if not self.t1_t2_PtFsr_branch and "t1_t2_PtFsr":
            warnings.warn( "MuMuTauTauTree: Expected branch t1_t2_PtFsr does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t1_t2_PtFsr")
        else:
            self.t1_t2_PtFsr_branch.SetAddress(<void*>&self.t1_t2_PtFsr_value)

        #print "making t1_t2_SS"
        self.t1_t2_SS_branch = the_tree.GetBranch("t1_t2_SS")
        #if not self.t1_t2_SS_branch and "t1_t2_SS" not in self.complained:
        if not self.t1_t2_SS_branch and "t1_t2_SS":
            warnings.warn( "MuMuTauTauTree: Expected branch t1_t2_SS does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t1_t2_SS")
        else:
            self.t1_t2_SS_branch.SetAddress(<void*>&self.t1_t2_SS_value)

        #print "making t1_t2_SVfitEta"
        self.t1_t2_SVfitEta_branch = the_tree.GetBranch("t1_t2_SVfitEta")
        #if not self.t1_t2_SVfitEta_branch and "t1_t2_SVfitEta" not in self.complained:
        if not self.t1_t2_SVfitEta_branch and "t1_t2_SVfitEta":
            warnings.warn( "MuMuTauTauTree: Expected branch t1_t2_SVfitEta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t1_t2_SVfitEta")
        else:
            self.t1_t2_SVfitEta_branch.SetAddress(<void*>&self.t1_t2_SVfitEta_value)

        #print "making t1_t2_SVfitMass"
        self.t1_t2_SVfitMass_branch = the_tree.GetBranch("t1_t2_SVfitMass")
        #if not self.t1_t2_SVfitMass_branch and "t1_t2_SVfitMass" not in self.complained:
        if not self.t1_t2_SVfitMass_branch and "t1_t2_SVfitMass":
            warnings.warn( "MuMuTauTauTree: Expected branch t1_t2_SVfitMass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t1_t2_SVfitMass")
        else:
            self.t1_t2_SVfitMass_branch.SetAddress(<void*>&self.t1_t2_SVfitMass_value)

        #print "making t1_t2_SVfitPhi"
        self.t1_t2_SVfitPhi_branch = the_tree.GetBranch("t1_t2_SVfitPhi")
        #if not self.t1_t2_SVfitPhi_branch and "t1_t2_SVfitPhi" not in self.complained:
        if not self.t1_t2_SVfitPhi_branch and "t1_t2_SVfitPhi":
            warnings.warn( "MuMuTauTauTree: Expected branch t1_t2_SVfitPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t1_t2_SVfitPhi")
        else:
            self.t1_t2_SVfitPhi_branch.SetAddress(<void*>&self.t1_t2_SVfitPhi_value)

        #print "making t1_t2_SVfitPt"
        self.t1_t2_SVfitPt_branch = the_tree.GetBranch("t1_t2_SVfitPt")
        #if not self.t1_t2_SVfitPt_branch and "t1_t2_SVfitPt" not in self.complained:
        if not self.t1_t2_SVfitPt_branch and "t1_t2_SVfitPt":
            warnings.warn( "MuMuTauTauTree: Expected branch t1_t2_SVfitPt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t1_t2_SVfitPt")
        else:
            self.t1_t2_SVfitPt_branch.SetAddress(<void*>&self.t1_t2_SVfitPt_value)

        #print "making t1_t2_ToMETDPhi_Ty1"
        self.t1_t2_ToMETDPhi_Ty1_branch = the_tree.GetBranch("t1_t2_ToMETDPhi_Ty1")
        #if not self.t1_t2_ToMETDPhi_Ty1_branch and "t1_t2_ToMETDPhi_Ty1" not in self.complained:
        if not self.t1_t2_ToMETDPhi_Ty1_branch and "t1_t2_ToMETDPhi_Ty1":
            warnings.warn( "MuMuTauTauTree: Expected branch t1_t2_ToMETDPhi_Ty1 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t1_t2_ToMETDPhi_Ty1")
        else:
            self.t1_t2_ToMETDPhi_Ty1_branch.SetAddress(<void*>&self.t1_t2_ToMETDPhi_Ty1_value)

        #print "making t1_t2_Zcompat"
        self.t1_t2_Zcompat_branch = the_tree.GetBranch("t1_t2_Zcompat")
        #if not self.t1_t2_Zcompat_branch and "t1_t2_Zcompat" not in self.complained:
        if not self.t1_t2_Zcompat_branch and "t1_t2_Zcompat":
            warnings.warn( "MuMuTauTauTree: Expected branch t1_t2_Zcompat does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t1_t2_Zcompat")
        else:
            self.t1_t2_Zcompat_branch.SetAddress(<void*>&self.t1_t2_Zcompat_value)

        #print "making t2AbsEta"
        self.t2AbsEta_branch = the_tree.GetBranch("t2AbsEta")
        #if not self.t2AbsEta_branch and "t2AbsEta" not in self.complained:
        if not self.t2AbsEta_branch and "t2AbsEta":
            warnings.warn( "MuMuTauTauTree: Expected branch t2AbsEta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t2AbsEta")
        else:
            self.t2AbsEta_branch.SetAddress(<void*>&self.t2AbsEta_value)

        #print "making t2AntiElectronLoose"
        self.t2AntiElectronLoose_branch = the_tree.GetBranch("t2AntiElectronLoose")
        #if not self.t2AntiElectronLoose_branch and "t2AntiElectronLoose" not in self.complained:
        if not self.t2AntiElectronLoose_branch and "t2AntiElectronLoose":
            warnings.warn( "MuMuTauTauTree: Expected branch t2AntiElectronLoose does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t2AntiElectronLoose")
        else:
            self.t2AntiElectronLoose_branch.SetAddress(<void*>&self.t2AntiElectronLoose_value)

        #print "making t2AntiElectronMVA3Loose"
        self.t2AntiElectronMVA3Loose_branch = the_tree.GetBranch("t2AntiElectronMVA3Loose")
        #if not self.t2AntiElectronMVA3Loose_branch and "t2AntiElectronMVA3Loose" not in self.complained:
        if not self.t2AntiElectronMVA3Loose_branch and "t2AntiElectronMVA3Loose":
            warnings.warn( "MuMuTauTauTree: Expected branch t2AntiElectronMVA3Loose does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t2AntiElectronMVA3Loose")
        else:
            self.t2AntiElectronMVA3Loose_branch.SetAddress(<void*>&self.t2AntiElectronMVA3Loose_value)

        #print "making t2AntiElectronMVA3Medium"
        self.t2AntiElectronMVA3Medium_branch = the_tree.GetBranch("t2AntiElectronMVA3Medium")
        #if not self.t2AntiElectronMVA3Medium_branch and "t2AntiElectronMVA3Medium" not in self.complained:
        if not self.t2AntiElectronMVA3Medium_branch and "t2AntiElectronMVA3Medium":
            warnings.warn( "MuMuTauTauTree: Expected branch t2AntiElectronMVA3Medium does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t2AntiElectronMVA3Medium")
        else:
            self.t2AntiElectronMVA3Medium_branch.SetAddress(<void*>&self.t2AntiElectronMVA3Medium_value)

        #print "making t2AntiElectronMVA3Raw"
        self.t2AntiElectronMVA3Raw_branch = the_tree.GetBranch("t2AntiElectronMVA3Raw")
        #if not self.t2AntiElectronMVA3Raw_branch and "t2AntiElectronMVA3Raw" not in self.complained:
        if not self.t2AntiElectronMVA3Raw_branch and "t2AntiElectronMVA3Raw":
            warnings.warn( "MuMuTauTauTree: Expected branch t2AntiElectronMVA3Raw does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t2AntiElectronMVA3Raw")
        else:
            self.t2AntiElectronMVA3Raw_branch.SetAddress(<void*>&self.t2AntiElectronMVA3Raw_value)

        #print "making t2AntiElectronMVA3Tight"
        self.t2AntiElectronMVA3Tight_branch = the_tree.GetBranch("t2AntiElectronMVA3Tight")
        #if not self.t2AntiElectronMVA3Tight_branch and "t2AntiElectronMVA3Tight" not in self.complained:
        if not self.t2AntiElectronMVA3Tight_branch and "t2AntiElectronMVA3Tight":
            warnings.warn( "MuMuTauTauTree: Expected branch t2AntiElectronMVA3Tight does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t2AntiElectronMVA3Tight")
        else:
            self.t2AntiElectronMVA3Tight_branch.SetAddress(<void*>&self.t2AntiElectronMVA3Tight_value)

        #print "making t2AntiElectronMVA3VTight"
        self.t2AntiElectronMVA3VTight_branch = the_tree.GetBranch("t2AntiElectronMVA3VTight")
        #if not self.t2AntiElectronMVA3VTight_branch and "t2AntiElectronMVA3VTight" not in self.complained:
        if not self.t2AntiElectronMVA3VTight_branch and "t2AntiElectronMVA3VTight":
            warnings.warn( "MuMuTauTauTree: Expected branch t2AntiElectronMVA3VTight does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t2AntiElectronMVA3VTight")
        else:
            self.t2AntiElectronMVA3VTight_branch.SetAddress(<void*>&self.t2AntiElectronMVA3VTight_value)

        #print "making t2AntiElectronMedium"
        self.t2AntiElectronMedium_branch = the_tree.GetBranch("t2AntiElectronMedium")
        #if not self.t2AntiElectronMedium_branch and "t2AntiElectronMedium" not in self.complained:
        if not self.t2AntiElectronMedium_branch and "t2AntiElectronMedium":
            warnings.warn( "MuMuTauTauTree: Expected branch t2AntiElectronMedium does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t2AntiElectronMedium")
        else:
            self.t2AntiElectronMedium_branch.SetAddress(<void*>&self.t2AntiElectronMedium_value)

        #print "making t2AntiElectronTight"
        self.t2AntiElectronTight_branch = the_tree.GetBranch("t2AntiElectronTight")
        #if not self.t2AntiElectronTight_branch and "t2AntiElectronTight" not in self.complained:
        if not self.t2AntiElectronTight_branch and "t2AntiElectronTight":
            warnings.warn( "MuMuTauTauTree: Expected branch t2AntiElectronTight does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t2AntiElectronTight")
        else:
            self.t2AntiElectronTight_branch.SetAddress(<void*>&self.t2AntiElectronTight_value)

        #print "making t2AntiMuonLoose"
        self.t2AntiMuonLoose_branch = the_tree.GetBranch("t2AntiMuonLoose")
        #if not self.t2AntiMuonLoose_branch and "t2AntiMuonLoose" not in self.complained:
        if not self.t2AntiMuonLoose_branch and "t2AntiMuonLoose":
            warnings.warn( "MuMuTauTauTree: Expected branch t2AntiMuonLoose does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t2AntiMuonLoose")
        else:
            self.t2AntiMuonLoose_branch.SetAddress(<void*>&self.t2AntiMuonLoose_value)

        #print "making t2AntiMuonLoose2"
        self.t2AntiMuonLoose2_branch = the_tree.GetBranch("t2AntiMuonLoose2")
        #if not self.t2AntiMuonLoose2_branch and "t2AntiMuonLoose2" not in self.complained:
        if not self.t2AntiMuonLoose2_branch and "t2AntiMuonLoose2":
            warnings.warn( "MuMuTauTauTree: Expected branch t2AntiMuonLoose2 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t2AntiMuonLoose2")
        else:
            self.t2AntiMuonLoose2_branch.SetAddress(<void*>&self.t2AntiMuonLoose2_value)

        #print "making t2AntiMuonMedium"
        self.t2AntiMuonMedium_branch = the_tree.GetBranch("t2AntiMuonMedium")
        #if not self.t2AntiMuonMedium_branch and "t2AntiMuonMedium" not in self.complained:
        if not self.t2AntiMuonMedium_branch and "t2AntiMuonMedium":
            warnings.warn( "MuMuTauTauTree: Expected branch t2AntiMuonMedium does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t2AntiMuonMedium")
        else:
            self.t2AntiMuonMedium_branch.SetAddress(<void*>&self.t2AntiMuonMedium_value)

        #print "making t2AntiMuonMedium2"
        self.t2AntiMuonMedium2_branch = the_tree.GetBranch("t2AntiMuonMedium2")
        #if not self.t2AntiMuonMedium2_branch and "t2AntiMuonMedium2" not in self.complained:
        if not self.t2AntiMuonMedium2_branch and "t2AntiMuonMedium2":
            warnings.warn( "MuMuTauTauTree: Expected branch t2AntiMuonMedium2 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t2AntiMuonMedium2")
        else:
            self.t2AntiMuonMedium2_branch.SetAddress(<void*>&self.t2AntiMuonMedium2_value)

        #print "making t2AntiMuonTight"
        self.t2AntiMuonTight_branch = the_tree.GetBranch("t2AntiMuonTight")
        #if not self.t2AntiMuonTight_branch and "t2AntiMuonTight" not in self.complained:
        if not self.t2AntiMuonTight_branch and "t2AntiMuonTight":
            warnings.warn( "MuMuTauTauTree: Expected branch t2AntiMuonTight does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t2AntiMuonTight")
        else:
            self.t2AntiMuonTight_branch.SetAddress(<void*>&self.t2AntiMuonTight_value)

        #print "making t2AntiMuonTight2"
        self.t2AntiMuonTight2_branch = the_tree.GetBranch("t2AntiMuonTight2")
        #if not self.t2AntiMuonTight2_branch and "t2AntiMuonTight2" not in self.complained:
        if not self.t2AntiMuonTight2_branch and "t2AntiMuonTight2":
            warnings.warn( "MuMuTauTauTree: Expected branch t2AntiMuonTight2 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t2AntiMuonTight2")
        else:
            self.t2AntiMuonTight2_branch.SetAddress(<void*>&self.t2AntiMuonTight2_value)

        #print "making t2Charge"
        self.t2Charge_branch = the_tree.GetBranch("t2Charge")
        #if not self.t2Charge_branch and "t2Charge" not in self.complained:
        if not self.t2Charge_branch and "t2Charge":
            warnings.warn( "MuMuTauTauTree: Expected branch t2Charge does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t2Charge")
        else:
            self.t2Charge_branch.SetAddress(<void*>&self.t2Charge_value)

        #print "making t2CiCTightElecOverlap"
        self.t2CiCTightElecOverlap_branch = the_tree.GetBranch("t2CiCTightElecOverlap")
        #if not self.t2CiCTightElecOverlap_branch and "t2CiCTightElecOverlap" not in self.complained:
        if not self.t2CiCTightElecOverlap_branch and "t2CiCTightElecOverlap":
            warnings.warn( "MuMuTauTauTree: Expected branch t2CiCTightElecOverlap does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t2CiCTightElecOverlap")
        else:
            self.t2CiCTightElecOverlap_branch.SetAddress(<void*>&self.t2CiCTightElecOverlap_value)

        #print "making t2DZ"
        self.t2DZ_branch = the_tree.GetBranch("t2DZ")
        #if not self.t2DZ_branch and "t2DZ" not in self.complained:
        if not self.t2DZ_branch and "t2DZ":
            warnings.warn( "MuMuTauTauTree: Expected branch t2DZ does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t2DZ")
        else:
            self.t2DZ_branch.SetAddress(<void*>&self.t2DZ_value)

        #print "making t2DecayFinding"
        self.t2DecayFinding_branch = the_tree.GetBranch("t2DecayFinding")
        #if not self.t2DecayFinding_branch and "t2DecayFinding" not in self.complained:
        if not self.t2DecayFinding_branch and "t2DecayFinding":
            warnings.warn( "MuMuTauTauTree: Expected branch t2DecayFinding does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t2DecayFinding")
        else:
            self.t2DecayFinding_branch.SetAddress(<void*>&self.t2DecayFinding_value)

        #print "making t2DecayMode"
        self.t2DecayMode_branch = the_tree.GetBranch("t2DecayMode")
        #if not self.t2DecayMode_branch and "t2DecayMode" not in self.complained:
        if not self.t2DecayMode_branch and "t2DecayMode":
            warnings.warn( "MuMuTauTauTree: Expected branch t2DecayMode does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t2DecayMode")
        else:
            self.t2DecayMode_branch.SetAddress(<void*>&self.t2DecayMode_value)

        #print "making t2ElecOverlap"
        self.t2ElecOverlap_branch = the_tree.GetBranch("t2ElecOverlap")
        #if not self.t2ElecOverlap_branch and "t2ElecOverlap" not in self.complained:
        if not self.t2ElecOverlap_branch and "t2ElecOverlap":
            warnings.warn( "MuMuTauTauTree: Expected branch t2ElecOverlap does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t2ElecOverlap")
        else:
            self.t2ElecOverlap_branch.SetAddress(<void*>&self.t2ElecOverlap_value)

        #print "making t2ElecOverlapZHLoose"
        self.t2ElecOverlapZHLoose_branch = the_tree.GetBranch("t2ElecOverlapZHLoose")
        #if not self.t2ElecOverlapZHLoose_branch and "t2ElecOverlapZHLoose" not in self.complained:
        if not self.t2ElecOverlapZHLoose_branch and "t2ElecOverlapZHLoose":
            warnings.warn( "MuMuTauTauTree: Expected branch t2ElecOverlapZHLoose does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t2ElecOverlapZHLoose")
        else:
            self.t2ElecOverlapZHLoose_branch.SetAddress(<void*>&self.t2ElecOverlapZHLoose_value)

        #print "making t2ElecOverlapZHTight"
        self.t2ElecOverlapZHTight_branch = the_tree.GetBranch("t2ElecOverlapZHTight")
        #if not self.t2ElecOverlapZHTight_branch and "t2ElecOverlapZHTight" not in self.complained:
        if not self.t2ElecOverlapZHTight_branch and "t2ElecOverlapZHTight":
            warnings.warn( "MuMuTauTauTree: Expected branch t2ElecOverlapZHTight does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t2ElecOverlapZHTight")
        else:
            self.t2ElecOverlapZHTight_branch.SetAddress(<void*>&self.t2ElecOverlapZHTight_value)

        #print "making t2Eta"
        self.t2Eta_branch = the_tree.GetBranch("t2Eta")
        #if not self.t2Eta_branch and "t2Eta" not in self.complained:
        if not self.t2Eta_branch and "t2Eta":
            warnings.warn( "MuMuTauTauTree: Expected branch t2Eta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t2Eta")
        else:
            self.t2Eta_branch.SetAddress(<void*>&self.t2Eta_value)

        #print "making t2GenDecayMode"
        self.t2GenDecayMode_branch = the_tree.GetBranch("t2GenDecayMode")
        #if not self.t2GenDecayMode_branch and "t2GenDecayMode" not in self.complained:
        if not self.t2GenDecayMode_branch and "t2GenDecayMode":
            warnings.warn( "MuMuTauTauTree: Expected branch t2GenDecayMode does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t2GenDecayMode")
        else:
            self.t2GenDecayMode_branch.SetAddress(<void*>&self.t2GenDecayMode_value)

        #print "making t2IP3DS"
        self.t2IP3DS_branch = the_tree.GetBranch("t2IP3DS")
        #if not self.t2IP3DS_branch and "t2IP3DS" not in self.complained:
        if not self.t2IP3DS_branch and "t2IP3DS":
            warnings.warn( "MuMuTauTauTree: Expected branch t2IP3DS does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t2IP3DS")
        else:
            self.t2IP3DS_branch.SetAddress(<void*>&self.t2IP3DS_value)

        #print "making t2JetArea"
        self.t2JetArea_branch = the_tree.GetBranch("t2JetArea")
        #if not self.t2JetArea_branch and "t2JetArea" not in self.complained:
        if not self.t2JetArea_branch and "t2JetArea":
            warnings.warn( "MuMuTauTauTree: Expected branch t2JetArea does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t2JetArea")
        else:
            self.t2JetArea_branch.SetAddress(<void*>&self.t2JetArea_value)

        #print "making t2JetBtag"
        self.t2JetBtag_branch = the_tree.GetBranch("t2JetBtag")
        #if not self.t2JetBtag_branch and "t2JetBtag" not in self.complained:
        if not self.t2JetBtag_branch and "t2JetBtag":
            warnings.warn( "MuMuTauTauTree: Expected branch t2JetBtag does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t2JetBtag")
        else:
            self.t2JetBtag_branch.SetAddress(<void*>&self.t2JetBtag_value)

        #print "making t2JetCSVBtag"
        self.t2JetCSVBtag_branch = the_tree.GetBranch("t2JetCSVBtag")
        #if not self.t2JetCSVBtag_branch and "t2JetCSVBtag" not in self.complained:
        if not self.t2JetCSVBtag_branch and "t2JetCSVBtag":
            warnings.warn( "MuMuTauTauTree: Expected branch t2JetCSVBtag does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t2JetCSVBtag")
        else:
            self.t2JetCSVBtag_branch.SetAddress(<void*>&self.t2JetCSVBtag_value)

        #print "making t2JetEtaEtaMoment"
        self.t2JetEtaEtaMoment_branch = the_tree.GetBranch("t2JetEtaEtaMoment")
        #if not self.t2JetEtaEtaMoment_branch and "t2JetEtaEtaMoment" not in self.complained:
        if not self.t2JetEtaEtaMoment_branch and "t2JetEtaEtaMoment":
            warnings.warn( "MuMuTauTauTree: Expected branch t2JetEtaEtaMoment does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t2JetEtaEtaMoment")
        else:
            self.t2JetEtaEtaMoment_branch.SetAddress(<void*>&self.t2JetEtaEtaMoment_value)

        #print "making t2JetEtaPhiMoment"
        self.t2JetEtaPhiMoment_branch = the_tree.GetBranch("t2JetEtaPhiMoment")
        #if not self.t2JetEtaPhiMoment_branch and "t2JetEtaPhiMoment" not in self.complained:
        if not self.t2JetEtaPhiMoment_branch and "t2JetEtaPhiMoment":
            warnings.warn( "MuMuTauTauTree: Expected branch t2JetEtaPhiMoment does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t2JetEtaPhiMoment")
        else:
            self.t2JetEtaPhiMoment_branch.SetAddress(<void*>&self.t2JetEtaPhiMoment_value)

        #print "making t2JetEtaPhiSpread"
        self.t2JetEtaPhiSpread_branch = the_tree.GetBranch("t2JetEtaPhiSpread")
        #if not self.t2JetEtaPhiSpread_branch and "t2JetEtaPhiSpread" not in self.complained:
        if not self.t2JetEtaPhiSpread_branch and "t2JetEtaPhiSpread":
            warnings.warn( "MuMuTauTauTree: Expected branch t2JetEtaPhiSpread does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t2JetEtaPhiSpread")
        else:
            self.t2JetEtaPhiSpread_branch.SetAddress(<void*>&self.t2JetEtaPhiSpread_value)

        #print "making t2JetPartonFlavour"
        self.t2JetPartonFlavour_branch = the_tree.GetBranch("t2JetPartonFlavour")
        #if not self.t2JetPartonFlavour_branch and "t2JetPartonFlavour" not in self.complained:
        if not self.t2JetPartonFlavour_branch and "t2JetPartonFlavour":
            warnings.warn( "MuMuTauTauTree: Expected branch t2JetPartonFlavour does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t2JetPartonFlavour")
        else:
            self.t2JetPartonFlavour_branch.SetAddress(<void*>&self.t2JetPartonFlavour_value)

        #print "making t2JetPhiPhiMoment"
        self.t2JetPhiPhiMoment_branch = the_tree.GetBranch("t2JetPhiPhiMoment")
        #if not self.t2JetPhiPhiMoment_branch and "t2JetPhiPhiMoment" not in self.complained:
        if not self.t2JetPhiPhiMoment_branch and "t2JetPhiPhiMoment":
            warnings.warn( "MuMuTauTauTree: Expected branch t2JetPhiPhiMoment does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t2JetPhiPhiMoment")
        else:
            self.t2JetPhiPhiMoment_branch.SetAddress(<void*>&self.t2JetPhiPhiMoment_value)

        #print "making t2JetPt"
        self.t2JetPt_branch = the_tree.GetBranch("t2JetPt")
        #if not self.t2JetPt_branch and "t2JetPt" not in self.complained:
        if not self.t2JetPt_branch and "t2JetPt":
            warnings.warn( "MuMuTauTauTree: Expected branch t2JetPt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t2JetPt")
        else:
            self.t2JetPt_branch.SetAddress(<void*>&self.t2JetPt_value)

        #print "making t2JetQGLikelihoodID"
        self.t2JetQGLikelihoodID_branch = the_tree.GetBranch("t2JetQGLikelihoodID")
        #if not self.t2JetQGLikelihoodID_branch and "t2JetQGLikelihoodID" not in self.complained:
        if not self.t2JetQGLikelihoodID_branch and "t2JetQGLikelihoodID":
            warnings.warn( "MuMuTauTauTree: Expected branch t2JetQGLikelihoodID does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t2JetQGLikelihoodID")
        else:
            self.t2JetQGLikelihoodID_branch.SetAddress(<void*>&self.t2JetQGLikelihoodID_value)

        #print "making t2JetQGMVAID"
        self.t2JetQGMVAID_branch = the_tree.GetBranch("t2JetQGMVAID")
        #if not self.t2JetQGMVAID_branch and "t2JetQGMVAID" not in self.complained:
        if not self.t2JetQGMVAID_branch and "t2JetQGMVAID":
            warnings.warn( "MuMuTauTauTree: Expected branch t2JetQGMVAID does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t2JetQGMVAID")
        else:
            self.t2JetQGMVAID_branch.SetAddress(<void*>&self.t2JetQGMVAID_value)

        #print "making t2Jetaxis1"
        self.t2Jetaxis1_branch = the_tree.GetBranch("t2Jetaxis1")
        #if not self.t2Jetaxis1_branch and "t2Jetaxis1" not in self.complained:
        if not self.t2Jetaxis1_branch and "t2Jetaxis1":
            warnings.warn( "MuMuTauTauTree: Expected branch t2Jetaxis1 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t2Jetaxis1")
        else:
            self.t2Jetaxis1_branch.SetAddress(<void*>&self.t2Jetaxis1_value)

        #print "making t2Jetaxis2"
        self.t2Jetaxis2_branch = the_tree.GetBranch("t2Jetaxis2")
        #if not self.t2Jetaxis2_branch and "t2Jetaxis2" not in self.complained:
        if not self.t2Jetaxis2_branch and "t2Jetaxis2":
            warnings.warn( "MuMuTauTauTree: Expected branch t2Jetaxis2 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t2Jetaxis2")
        else:
            self.t2Jetaxis2_branch.SetAddress(<void*>&self.t2Jetaxis2_value)

        #print "making t2Jetmult"
        self.t2Jetmult_branch = the_tree.GetBranch("t2Jetmult")
        #if not self.t2Jetmult_branch and "t2Jetmult" not in self.complained:
        if not self.t2Jetmult_branch and "t2Jetmult":
            warnings.warn( "MuMuTauTauTree: Expected branch t2Jetmult does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t2Jetmult")
        else:
            self.t2Jetmult_branch.SetAddress(<void*>&self.t2Jetmult_value)

        #print "making t2JetmultMLP"
        self.t2JetmultMLP_branch = the_tree.GetBranch("t2JetmultMLP")
        #if not self.t2JetmultMLP_branch and "t2JetmultMLP" not in self.complained:
        if not self.t2JetmultMLP_branch and "t2JetmultMLP":
            warnings.warn( "MuMuTauTauTree: Expected branch t2JetmultMLP does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t2JetmultMLP")
        else:
            self.t2JetmultMLP_branch.SetAddress(<void*>&self.t2JetmultMLP_value)

        #print "making t2JetmultMLPQC"
        self.t2JetmultMLPQC_branch = the_tree.GetBranch("t2JetmultMLPQC")
        #if not self.t2JetmultMLPQC_branch and "t2JetmultMLPQC" not in self.complained:
        if not self.t2JetmultMLPQC_branch and "t2JetmultMLPQC":
            warnings.warn( "MuMuTauTauTree: Expected branch t2JetmultMLPQC does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t2JetmultMLPQC")
        else:
            self.t2JetmultMLPQC_branch.SetAddress(<void*>&self.t2JetmultMLPQC_value)

        #print "making t2JetptD"
        self.t2JetptD_branch = the_tree.GetBranch("t2JetptD")
        #if not self.t2JetptD_branch and "t2JetptD" not in self.complained:
        if not self.t2JetptD_branch and "t2JetptD":
            warnings.warn( "MuMuTauTauTree: Expected branch t2JetptD does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t2JetptD")
        else:
            self.t2JetptD_branch.SetAddress(<void*>&self.t2JetptD_value)

        #print "making t2LeadTrackPt"
        self.t2LeadTrackPt_branch = the_tree.GetBranch("t2LeadTrackPt")
        #if not self.t2LeadTrackPt_branch and "t2LeadTrackPt" not in self.complained:
        if not self.t2LeadTrackPt_branch and "t2LeadTrackPt":
            warnings.warn( "MuMuTauTauTree: Expected branch t2LeadTrackPt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t2LeadTrackPt")
        else:
            self.t2LeadTrackPt_branch.SetAddress(<void*>&self.t2LeadTrackPt_value)

        #print "making t2LooseIso"
        self.t2LooseIso_branch = the_tree.GetBranch("t2LooseIso")
        #if not self.t2LooseIso_branch and "t2LooseIso" not in self.complained:
        if not self.t2LooseIso_branch and "t2LooseIso":
            warnings.warn( "MuMuTauTauTree: Expected branch t2LooseIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t2LooseIso")
        else:
            self.t2LooseIso_branch.SetAddress(<void*>&self.t2LooseIso_value)

        #print "making t2LooseIso3Hits"
        self.t2LooseIso3Hits_branch = the_tree.GetBranch("t2LooseIso3Hits")
        #if not self.t2LooseIso3Hits_branch and "t2LooseIso3Hits" not in self.complained:
        if not self.t2LooseIso3Hits_branch and "t2LooseIso3Hits":
            warnings.warn( "MuMuTauTauTree: Expected branch t2LooseIso3Hits does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t2LooseIso3Hits")
        else:
            self.t2LooseIso3Hits_branch.SetAddress(<void*>&self.t2LooseIso3Hits_value)

        #print "making t2LooseMVA2Iso"
        self.t2LooseMVA2Iso_branch = the_tree.GetBranch("t2LooseMVA2Iso")
        #if not self.t2LooseMVA2Iso_branch and "t2LooseMVA2Iso" not in self.complained:
        if not self.t2LooseMVA2Iso_branch and "t2LooseMVA2Iso":
            warnings.warn( "MuMuTauTauTree: Expected branch t2LooseMVA2Iso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t2LooseMVA2Iso")
        else:
            self.t2LooseMVA2Iso_branch.SetAddress(<void*>&self.t2LooseMVA2Iso_value)

        #print "making t2LooseMVAIso"
        self.t2LooseMVAIso_branch = the_tree.GetBranch("t2LooseMVAIso")
        #if not self.t2LooseMVAIso_branch and "t2LooseMVAIso" not in self.complained:
        if not self.t2LooseMVAIso_branch and "t2LooseMVAIso":
            warnings.warn( "MuMuTauTauTree: Expected branch t2LooseMVAIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t2LooseMVAIso")
        else:
            self.t2LooseMVAIso_branch.SetAddress(<void*>&self.t2LooseMVAIso_value)

        #print "making t2MVA2IsoRaw"
        self.t2MVA2IsoRaw_branch = the_tree.GetBranch("t2MVA2IsoRaw")
        #if not self.t2MVA2IsoRaw_branch and "t2MVA2IsoRaw" not in self.complained:
        if not self.t2MVA2IsoRaw_branch and "t2MVA2IsoRaw":
            warnings.warn( "MuMuTauTauTree: Expected branch t2MVA2IsoRaw does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t2MVA2IsoRaw")
        else:
            self.t2MVA2IsoRaw_branch.SetAddress(<void*>&self.t2MVA2IsoRaw_value)

        #print "making t2Mass"
        self.t2Mass_branch = the_tree.GetBranch("t2Mass")
        #if not self.t2Mass_branch and "t2Mass" not in self.complained:
        if not self.t2Mass_branch and "t2Mass":
            warnings.warn( "MuMuTauTauTree: Expected branch t2Mass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t2Mass")
        else:
            self.t2Mass_branch.SetAddress(<void*>&self.t2Mass_value)

        #print "making t2MediumIso"
        self.t2MediumIso_branch = the_tree.GetBranch("t2MediumIso")
        #if not self.t2MediumIso_branch and "t2MediumIso" not in self.complained:
        if not self.t2MediumIso_branch and "t2MediumIso":
            warnings.warn( "MuMuTauTauTree: Expected branch t2MediumIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t2MediumIso")
        else:
            self.t2MediumIso_branch.SetAddress(<void*>&self.t2MediumIso_value)

        #print "making t2MediumIso3Hits"
        self.t2MediumIso3Hits_branch = the_tree.GetBranch("t2MediumIso3Hits")
        #if not self.t2MediumIso3Hits_branch and "t2MediumIso3Hits" not in self.complained:
        if not self.t2MediumIso3Hits_branch and "t2MediumIso3Hits":
            warnings.warn( "MuMuTauTauTree: Expected branch t2MediumIso3Hits does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t2MediumIso3Hits")
        else:
            self.t2MediumIso3Hits_branch.SetAddress(<void*>&self.t2MediumIso3Hits_value)

        #print "making t2MediumMVA2Iso"
        self.t2MediumMVA2Iso_branch = the_tree.GetBranch("t2MediumMVA2Iso")
        #if not self.t2MediumMVA2Iso_branch and "t2MediumMVA2Iso" not in self.complained:
        if not self.t2MediumMVA2Iso_branch and "t2MediumMVA2Iso":
            warnings.warn( "MuMuTauTauTree: Expected branch t2MediumMVA2Iso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t2MediumMVA2Iso")
        else:
            self.t2MediumMVA2Iso_branch.SetAddress(<void*>&self.t2MediumMVA2Iso_value)

        #print "making t2MediumMVAIso"
        self.t2MediumMVAIso_branch = the_tree.GetBranch("t2MediumMVAIso")
        #if not self.t2MediumMVAIso_branch and "t2MediumMVAIso" not in self.complained:
        if not self.t2MediumMVAIso_branch and "t2MediumMVAIso":
            warnings.warn( "MuMuTauTauTree: Expected branch t2MediumMVAIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t2MediumMVAIso")
        else:
            self.t2MediumMVAIso_branch.SetAddress(<void*>&self.t2MediumMVAIso_value)

        #print "making t2MtToMET"
        self.t2MtToMET_branch = the_tree.GetBranch("t2MtToMET")
        #if not self.t2MtToMET_branch and "t2MtToMET" not in self.complained:
        if not self.t2MtToMET_branch and "t2MtToMET":
            warnings.warn( "MuMuTauTauTree: Expected branch t2MtToMET does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t2MtToMET")
        else:
            self.t2MtToMET_branch.SetAddress(<void*>&self.t2MtToMET_value)

        #print "making t2MtToMVAMET"
        self.t2MtToMVAMET_branch = the_tree.GetBranch("t2MtToMVAMET")
        #if not self.t2MtToMVAMET_branch and "t2MtToMVAMET" not in self.complained:
        if not self.t2MtToMVAMET_branch and "t2MtToMVAMET":
            warnings.warn( "MuMuTauTauTree: Expected branch t2MtToMVAMET does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t2MtToMVAMET")
        else:
            self.t2MtToMVAMET_branch.SetAddress(<void*>&self.t2MtToMVAMET_value)

        #print "making t2MtToPFMET"
        self.t2MtToPFMET_branch = the_tree.GetBranch("t2MtToPFMET")
        #if not self.t2MtToPFMET_branch and "t2MtToPFMET" not in self.complained:
        if not self.t2MtToPFMET_branch and "t2MtToPFMET":
            warnings.warn( "MuMuTauTauTree: Expected branch t2MtToPFMET does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t2MtToPFMET")
        else:
            self.t2MtToPFMET_branch.SetAddress(<void*>&self.t2MtToPFMET_value)

        #print "making t2MtToPfMet_Ty1"
        self.t2MtToPfMet_Ty1_branch = the_tree.GetBranch("t2MtToPfMet_Ty1")
        #if not self.t2MtToPfMet_Ty1_branch and "t2MtToPfMet_Ty1" not in self.complained:
        if not self.t2MtToPfMet_Ty1_branch and "t2MtToPfMet_Ty1":
            warnings.warn( "MuMuTauTauTree: Expected branch t2MtToPfMet_Ty1 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t2MtToPfMet_Ty1")
        else:
            self.t2MtToPfMet_Ty1_branch.SetAddress(<void*>&self.t2MtToPfMet_Ty1_value)

        #print "making t2MtToPfMet_jes"
        self.t2MtToPfMet_jes_branch = the_tree.GetBranch("t2MtToPfMet_jes")
        #if not self.t2MtToPfMet_jes_branch and "t2MtToPfMet_jes" not in self.complained:
        if not self.t2MtToPfMet_jes_branch and "t2MtToPfMet_jes":
            warnings.warn( "MuMuTauTauTree: Expected branch t2MtToPfMet_jes does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t2MtToPfMet_jes")
        else:
            self.t2MtToPfMet_jes_branch.SetAddress(<void*>&self.t2MtToPfMet_jes_value)

        #print "making t2MtToPfMet_mes"
        self.t2MtToPfMet_mes_branch = the_tree.GetBranch("t2MtToPfMet_mes")
        #if not self.t2MtToPfMet_mes_branch and "t2MtToPfMet_mes" not in self.complained:
        if not self.t2MtToPfMet_mes_branch and "t2MtToPfMet_mes":
            warnings.warn( "MuMuTauTauTree: Expected branch t2MtToPfMet_mes does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t2MtToPfMet_mes")
        else:
            self.t2MtToPfMet_mes_branch.SetAddress(<void*>&self.t2MtToPfMet_mes_value)

        #print "making t2MtToPfMet_tes"
        self.t2MtToPfMet_tes_branch = the_tree.GetBranch("t2MtToPfMet_tes")
        #if not self.t2MtToPfMet_tes_branch and "t2MtToPfMet_tes" not in self.complained:
        if not self.t2MtToPfMet_tes_branch and "t2MtToPfMet_tes":
            warnings.warn( "MuMuTauTauTree: Expected branch t2MtToPfMet_tes does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t2MtToPfMet_tes")
        else:
            self.t2MtToPfMet_tes_branch.SetAddress(<void*>&self.t2MtToPfMet_tes_value)

        #print "making t2MtToPfMet_ues"
        self.t2MtToPfMet_ues_branch = the_tree.GetBranch("t2MtToPfMet_ues")
        #if not self.t2MtToPfMet_ues_branch and "t2MtToPfMet_ues" not in self.complained:
        if not self.t2MtToPfMet_ues_branch and "t2MtToPfMet_ues":
            warnings.warn( "MuMuTauTauTree: Expected branch t2MtToPfMet_ues does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t2MtToPfMet_ues")
        else:
            self.t2MtToPfMet_ues_branch.SetAddress(<void*>&self.t2MtToPfMet_ues_value)

        #print "making t2MuOverlap"
        self.t2MuOverlap_branch = the_tree.GetBranch("t2MuOverlap")
        #if not self.t2MuOverlap_branch and "t2MuOverlap" not in self.complained:
        if not self.t2MuOverlap_branch and "t2MuOverlap":
            warnings.warn( "MuMuTauTauTree: Expected branch t2MuOverlap does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t2MuOverlap")
        else:
            self.t2MuOverlap_branch.SetAddress(<void*>&self.t2MuOverlap_value)

        #print "making t2MuOverlapZHLoose"
        self.t2MuOverlapZHLoose_branch = the_tree.GetBranch("t2MuOverlapZHLoose")
        #if not self.t2MuOverlapZHLoose_branch and "t2MuOverlapZHLoose" not in self.complained:
        if not self.t2MuOverlapZHLoose_branch and "t2MuOverlapZHLoose":
            warnings.warn( "MuMuTauTauTree: Expected branch t2MuOverlapZHLoose does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t2MuOverlapZHLoose")
        else:
            self.t2MuOverlapZHLoose_branch.SetAddress(<void*>&self.t2MuOverlapZHLoose_value)

        #print "making t2MuOverlapZHTight"
        self.t2MuOverlapZHTight_branch = the_tree.GetBranch("t2MuOverlapZHTight")
        #if not self.t2MuOverlapZHTight_branch and "t2MuOverlapZHTight" not in self.complained:
        if not self.t2MuOverlapZHTight_branch and "t2MuOverlapZHTight":
            warnings.warn( "MuMuTauTauTree: Expected branch t2MuOverlapZHTight does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t2MuOverlapZHTight")
        else:
            self.t2MuOverlapZHTight_branch.SetAddress(<void*>&self.t2MuOverlapZHTight_value)

        #print "making t2Phi"
        self.t2Phi_branch = the_tree.GetBranch("t2Phi")
        #if not self.t2Phi_branch and "t2Phi" not in self.complained:
        if not self.t2Phi_branch and "t2Phi":
            warnings.warn( "MuMuTauTauTree: Expected branch t2Phi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t2Phi")
        else:
            self.t2Phi_branch.SetAddress(<void*>&self.t2Phi_value)

        #print "making t2Pt"
        self.t2Pt_branch = the_tree.GetBranch("t2Pt")
        #if not self.t2Pt_branch and "t2Pt" not in self.complained:
        if not self.t2Pt_branch and "t2Pt":
            warnings.warn( "MuMuTauTauTree: Expected branch t2Pt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t2Pt")
        else:
            self.t2Pt_branch.SetAddress(<void*>&self.t2Pt_value)

        #print "making t2Rank"
        self.t2Rank_branch = the_tree.GetBranch("t2Rank")
        #if not self.t2Rank_branch and "t2Rank" not in self.complained:
        if not self.t2Rank_branch and "t2Rank":
            warnings.warn( "MuMuTauTauTree: Expected branch t2Rank does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t2Rank")
        else:
            self.t2Rank_branch.SetAddress(<void*>&self.t2Rank_value)

        #print "making t2TNPId"
        self.t2TNPId_branch = the_tree.GetBranch("t2TNPId")
        #if not self.t2TNPId_branch and "t2TNPId" not in self.complained:
        if not self.t2TNPId_branch and "t2TNPId":
            warnings.warn( "MuMuTauTauTree: Expected branch t2TNPId does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t2TNPId")
        else:
            self.t2TNPId_branch.SetAddress(<void*>&self.t2TNPId_value)

        #print "making t2TightIso"
        self.t2TightIso_branch = the_tree.GetBranch("t2TightIso")
        #if not self.t2TightIso_branch and "t2TightIso" not in self.complained:
        if not self.t2TightIso_branch and "t2TightIso":
            warnings.warn( "MuMuTauTauTree: Expected branch t2TightIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t2TightIso")
        else:
            self.t2TightIso_branch.SetAddress(<void*>&self.t2TightIso_value)

        #print "making t2TightIso3Hits"
        self.t2TightIso3Hits_branch = the_tree.GetBranch("t2TightIso3Hits")
        #if not self.t2TightIso3Hits_branch and "t2TightIso3Hits" not in self.complained:
        if not self.t2TightIso3Hits_branch and "t2TightIso3Hits":
            warnings.warn( "MuMuTauTauTree: Expected branch t2TightIso3Hits does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t2TightIso3Hits")
        else:
            self.t2TightIso3Hits_branch.SetAddress(<void*>&self.t2TightIso3Hits_value)

        #print "making t2TightMVA2Iso"
        self.t2TightMVA2Iso_branch = the_tree.GetBranch("t2TightMVA2Iso")
        #if not self.t2TightMVA2Iso_branch and "t2TightMVA2Iso" not in self.complained:
        if not self.t2TightMVA2Iso_branch and "t2TightMVA2Iso":
            warnings.warn( "MuMuTauTauTree: Expected branch t2TightMVA2Iso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t2TightMVA2Iso")
        else:
            self.t2TightMVA2Iso_branch.SetAddress(<void*>&self.t2TightMVA2Iso_value)

        #print "making t2TightMVAIso"
        self.t2TightMVAIso_branch = the_tree.GetBranch("t2TightMVAIso")
        #if not self.t2TightMVAIso_branch and "t2TightMVAIso" not in self.complained:
        if not self.t2TightMVAIso_branch and "t2TightMVAIso":
            warnings.warn( "MuMuTauTauTree: Expected branch t2TightMVAIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t2TightMVAIso")
        else:
            self.t2TightMVAIso_branch.SetAddress(<void*>&self.t2TightMVAIso_value)

        #print "making t2ToMETDPhi"
        self.t2ToMETDPhi_branch = the_tree.GetBranch("t2ToMETDPhi")
        #if not self.t2ToMETDPhi_branch and "t2ToMETDPhi" not in self.complained:
        if not self.t2ToMETDPhi_branch and "t2ToMETDPhi":
            warnings.warn( "MuMuTauTauTree: Expected branch t2ToMETDPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t2ToMETDPhi")
        else:
            self.t2ToMETDPhi_branch.SetAddress(<void*>&self.t2ToMETDPhi_value)

        #print "making t2VLooseIso"
        self.t2VLooseIso_branch = the_tree.GetBranch("t2VLooseIso")
        #if not self.t2VLooseIso_branch and "t2VLooseIso" not in self.complained:
        if not self.t2VLooseIso_branch and "t2VLooseIso":
            warnings.warn( "MuMuTauTauTree: Expected branch t2VLooseIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t2VLooseIso")
        else:
            self.t2VLooseIso_branch.SetAddress(<void*>&self.t2VLooseIso_value)

        #print "making t2VZ"
        self.t2VZ_branch = the_tree.GetBranch("t2VZ")
        #if not self.t2VZ_branch and "t2VZ" not in self.complained:
        if not self.t2VZ_branch and "t2VZ":
            warnings.warn( "MuMuTauTauTree: Expected branch t2VZ does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t2VZ")
        else:
            self.t2VZ_branch.SetAddress(<void*>&self.t2VZ_value)

        #print "making tauHpsVetoPt20"
        self.tauHpsVetoPt20_branch = the_tree.GetBranch("tauHpsVetoPt20")
        #if not self.tauHpsVetoPt20_branch and "tauHpsVetoPt20" not in self.complained:
        if not self.tauHpsVetoPt20_branch and "tauHpsVetoPt20":
            warnings.warn( "MuMuTauTauTree: Expected branch tauHpsVetoPt20 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tauHpsVetoPt20")
        else:
            self.tauHpsVetoPt20_branch.SetAddress(<void*>&self.tauHpsVetoPt20_value)

        #print "making tauTightCountZH"
        self.tauTightCountZH_branch = the_tree.GetBranch("tauTightCountZH")
        #if not self.tauTightCountZH_branch and "tauTightCountZH" not in self.complained:
        if not self.tauTightCountZH_branch and "tauTightCountZH":
            warnings.warn( "MuMuTauTauTree: Expected branch tauTightCountZH does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tauTightCountZH")
        else:
            self.tauTightCountZH_branch.SetAddress(<void*>&self.tauTightCountZH_value)

        #print "making tauVetoPt20"
        self.tauVetoPt20_branch = the_tree.GetBranch("tauVetoPt20")
        #if not self.tauVetoPt20_branch and "tauVetoPt20" not in self.complained:
        if not self.tauVetoPt20_branch and "tauVetoPt20":
            warnings.warn( "MuMuTauTauTree: Expected branch tauVetoPt20 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tauVetoPt20")
        else:
            self.tauVetoPt20_branch.SetAddress(<void*>&self.tauVetoPt20_value)

        #print "making tauVetoPt20Loose3HitsVtx"
        self.tauVetoPt20Loose3HitsVtx_branch = the_tree.GetBranch("tauVetoPt20Loose3HitsVtx")
        #if not self.tauVetoPt20Loose3HitsVtx_branch and "tauVetoPt20Loose3HitsVtx" not in self.complained:
        if not self.tauVetoPt20Loose3HitsVtx_branch and "tauVetoPt20Loose3HitsVtx":
            warnings.warn( "MuMuTauTauTree: Expected branch tauVetoPt20Loose3HitsVtx does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tauVetoPt20Loose3HitsVtx")
        else:
            self.tauVetoPt20Loose3HitsVtx_branch.SetAddress(<void*>&self.tauVetoPt20Loose3HitsVtx_value)

        #print "making tauVetoPt20LooseMVA2Vtx"
        self.tauVetoPt20LooseMVA2Vtx_branch = the_tree.GetBranch("tauVetoPt20LooseMVA2Vtx")
        #if not self.tauVetoPt20LooseMVA2Vtx_branch and "tauVetoPt20LooseMVA2Vtx" not in self.complained:
        if not self.tauVetoPt20LooseMVA2Vtx_branch and "tauVetoPt20LooseMVA2Vtx":
            warnings.warn( "MuMuTauTauTree: Expected branch tauVetoPt20LooseMVA2Vtx does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tauVetoPt20LooseMVA2Vtx")
        else:
            self.tauVetoPt20LooseMVA2Vtx_branch.SetAddress(<void*>&self.tauVetoPt20LooseMVA2Vtx_value)

        #print "making tauVetoPt20LooseMVAVtx"
        self.tauVetoPt20LooseMVAVtx_branch = the_tree.GetBranch("tauVetoPt20LooseMVAVtx")
        #if not self.tauVetoPt20LooseMVAVtx_branch and "tauVetoPt20LooseMVAVtx" not in self.complained:
        if not self.tauVetoPt20LooseMVAVtx_branch and "tauVetoPt20LooseMVAVtx":
            warnings.warn( "MuMuTauTauTree: Expected branch tauVetoPt20LooseMVAVtx does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tauVetoPt20LooseMVAVtx")
        else:
            self.tauVetoPt20LooseMVAVtx_branch.SetAddress(<void*>&self.tauVetoPt20LooseMVAVtx_value)

        #print "making tauVetoPt20VLooseHPSVtx"
        self.tauVetoPt20VLooseHPSVtx_branch = the_tree.GetBranch("tauVetoPt20VLooseHPSVtx")
        #if not self.tauVetoPt20VLooseHPSVtx_branch and "tauVetoPt20VLooseHPSVtx" not in self.complained:
        if not self.tauVetoPt20VLooseHPSVtx_branch and "tauVetoPt20VLooseHPSVtx":
            warnings.warn( "MuMuTauTauTree: Expected branch tauVetoPt20VLooseHPSVtx does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tauVetoPt20VLooseHPSVtx")
        else:
            self.tauVetoPt20VLooseHPSVtx_branch.SetAddress(<void*>&self.tauVetoPt20VLooseHPSVtx_value)

        #print "making tauVetoZH"
        self.tauVetoZH_branch = the_tree.GetBranch("tauVetoZH")
        #if not self.tauVetoZH_branch and "tauVetoZH" not in self.complained:
        if not self.tauVetoZH_branch and "tauVetoZH":
            warnings.warn( "MuMuTauTauTree: Expected branch tauVetoZH does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tauVetoZH")
        else:
            self.tauVetoZH_branch.SetAddress(<void*>&self.tauVetoZH_value)

        #print "making type1_pfMetEt"
        self.type1_pfMetEt_branch = the_tree.GetBranch("type1_pfMetEt")
        #if not self.type1_pfMetEt_branch and "type1_pfMetEt" not in self.complained:
        if not self.type1_pfMetEt_branch and "type1_pfMetEt":
            warnings.warn( "MuMuTauTauTree: Expected branch type1_pfMetEt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMetEt")
        else:
            self.type1_pfMetEt_branch.SetAddress(<void*>&self.type1_pfMetEt_value)

        #print "making type1_pfMetPhi"
        self.type1_pfMetPhi_branch = the_tree.GetBranch("type1_pfMetPhi")
        #if not self.type1_pfMetPhi_branch and "type1_pfMetPhi" not in self.complained:
        if not self.type1_pfMetPhi_branch and "type1_pfMetPhi":
            warnings.warn( "MuMuTauTauTree: Expected branch type1_pfMetPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMetPhi")
        else:
            self.type1_pfMetPhi_branch.SetAddress(<void*>&self.type1_pfMetPhi_value)

        #print "making idx"
        self.idx_branch = the_tree.GetBranch("idx")
        #if not self.idx_branch and "idx" not in self.complained:
        if not self.idx_branch and "idx":
            warnings.warn( "MuMuTauTauTree: Expected branch idx does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("idx")
        else:
            self.idx_branch.SetAddress(<void*>&self.idx_value)


    # Iterating over the tree
    def __iter__(self):
        self.ientry = 0
        while self.ientry < self.tree.GetEntries():
            self.load_entry(self.ientry)
            yield self
            self.ientry += 1

    # Iterate over rows which pass the filter
    def where(self, filter):
        print "where"
        cdef TTreeFormula* formula = new TTreeFormula(
            "cyiter", filter, self.tree)
        self.ientry = 0
        cdef TTree* currentTree = self.tree.GetTree()
        while self.ientry < self.tree.GetEntries():
            self.tree.LoadTree(self.ientry)
            if currentTree != self.tree.GetTree():
                currentTree = self.tree.GetTree()
                formula.SetTree(currentTree)
                formula.UpdateFormulaLeaves()
            if formula.EvalInstance(0, NULL):
                yield self
            self.ientry += 1
        del formula

    # Getting/setting the Tree entry number
    property entry:
        def __get__(self):
            return self.ientry
        def __set__(self, int i):
            print i
            self.ientry = i
            self.load_entry(i)

    # Access to the current branch values

    property EmbPtWeight:
        def __get__(self):
            self.EmbPtWeight_branch.GetEntry(self.localentry, 0)
            return self.EmbPtWeight_value

    property LT:
        def __get__(self):
            self.LT_branch.GetEntry(self.localentry, 0)
            return self.LT_value

    property Mass:
        def __get__(self):
            self.Mass_branch.GetEntry(self.localentry, 0)
            return self.Mass_value

    property MassError:
        def __get__(self):
            self.MassError_branch.GetEntry(self.localentry, 0)
            return self.MassError_value

    property MassErrord1:
        def __get__(self):
            self.MassErrord1_branch.GetEntry(self.localentry, 0)
            return self.MassErrord1_value

    property MassErrord2:
        def __get__(self):
            self.MassErrord2_branch.GetEntry(self.localentry, 0)
            return self.MassErrord2_value

    property MassErrord3:
        def __get__(self):
            self.MassErrord3_branch.GetEntry(self.localentry, 0)
            return self.MassErrord3_value

    property MassErrord4:
        def __get__(self):
            self.MassErrord4_branch.GetEntry(self.localentry, 0)
            return self.MassErrord4_value

    property NUP:
        def __get__(self):
            self.NUP_branch.GetEntry(self.localentry, 0)
            return self.NUP_value

    property Pt:
        def __get__(self):
            self.Pt_branch.GetEntry(self.localentry, 0)
            return self.Pt_value

    property bjetCSVVeto:
        def __get__(self):
            self.bjetCSVVeto_branch.GetEntry(self.localentry, 0)
            return self.bjetCSVVeto_value

    property bjetCSVVeto30:
        def __get__(self):
            self.bjetCSVVeto30_branch.GetEntry(self.localentry, 0)
            return self.bjetCSVVeto30_value

    property bjetCSVVetoZHLike:
        def __get__(self):
            self.bjetCSVVetoZHLike_branch.GetEntry(self.localentry, 0)
            return self.bjetCSVVetoZHLike_value

    property bjetCSVVetoZHLikeNoJetId:
        def __get__(self):
            self.bjetCSVVetoZHLikeNoJetId_branch.GetEntry(self.localentry, 0)
            return self.bjetCSVVetoZHLikeNoJetId_value

    property bjetCSVVetoZHLikeNoJetId_2:
        def __get__(self):
            self.bjetCSVVetoZHLikeNoJetId_2_branch.GetEntry(self.localentry, 0)
            return self.bjetCSVVetoZHLikeNoJetId_2_value

    property bjetTightCountZH:
        def __get__(self):
            self.bjetTightCountZH_branch.GetEntry(self.localentry, 0)
            return self.bjetTightCountZH_value

    property bjetVeto:
        def __get__(self):
            self.bjetVeto_branch.GetEntry(self.localentry, 0)
            return self.bjetVeto_value

    property charge:
        def __get__(self):
            self.charge_branch.GetEntry(self.localentry, 0)
            return self.charge_value

    property doubleEExtraGroup:
        def __get__(self):
            self.doubleEExtraGroup_branch.GetEntry(self.localentry, 0)
            return self.doubleEExtraGroup_value

    property doubleEExtraPass:
        def __get__(self):
            self.doubleEExtraPass_branch.GetEntry(self.localentry, 0)
            return self.doubleEExtraPass_value

    property doubleEExtraPrescale:
        def __get__(self):
            self.doubleEExtraPrescale_branch.GetEntry(self.localentry, 0)
            return self.doubleEExtraPrescale_value

    property doubleEGroup:
        def __get__(self):
            self.doubleEGroup_branch.GetEntry(self.localentry, 0)
            return self.doubleEGroup_value

    property doubleEPass:
        def __get__(self):
            self.doubleEPass_branch.GetEntry(self.localentry, 0)
            return self.doubleEPass_value

    property doubleEPrescale:
        def __get__(self):
            self.doubleEPrescale_branch.GetEntry(self.localentry, 0)
            return self.doubleEPrescale_value

    property doubleETightGroup:
        def __get__(self):
            self.doubleETightGroup_branch.GetEntry(self.localentry, 0)
            return self.doubleETightGroup_value

    property doubleETightPass:
        def __get__(self):
            self.doubleETightPass_branch.GetEntry(self.localentry, 0)
            return self.doubleETightPass_value

    property doubleETightPrescale:
        def __get__(self):
            self.doubleETightPrescale_branch.GetEntry(self.localentry, 0)
            return self.doubleETightPrescale_value

    property doubleMuGroup:
        def __get__(self):
            self.doubleMuGroup_branch.GetEntry(self.localentry, 0)
            return self.doubleMuGroup_value

    property doubleMuPass:
        def __get__(self):
            self.doubleMuPass_branch.GetEntry(self.localentry, 0)
            return self.doubleMuPass_value

    property doubleMuPrescale:
        def __get__(self):
            self.doubleMuPrescale_branch.GetEntry(self.localentry, 0)
            return self.doubleMuPrescale_value

    property doubleMuTrkGroup:
        def __get__(self):
            self.doubleMuTrkGroup_branch.GetEntry(self.localentry, 0)
            return self.doubleMuTrkGroup_value

    property doubleMuTrkPass:
        def __get__(self):
            self.doubleMuTrkPass_branch.GetEntry(self.localentry, 0)
            return self.doubleMuTrkPass_value

    property doubleMuTrkPrescale:
        def __get__(self):
            self.doubleMuTrkPrescale_branch.GetEntry(self.localentry, 0)
            return self.doubleMuTrkPrescale_value

    property doublePhoGroup:
        def __get__(self):
            self.doublePhoGroup_branch.GetEntry(self.localentry, 0)
            return self.doublePhoGroup_value

    property doublePhoPass:
        def __get__(self):
            self.doublePhoPass_branch.GetEntry(self.localentry, 0)
            return self.doublePhoPass_value

    property doublePhoPrescale:
        def __get__(self):
            self.doublePhoPrescale_branch.GetEntry(self.localentry, 0)
            return self.doublePhoPrescale_value

    property eTightCountZH:
        def __get__(self):
            self.eTightCountZH_branch.GetEntry(self.localentry, 0)
            return self.eTightCountZH_value

    property eVetoCicTightIso:
        def __get__(self):
            self.eVetoCicTightIso_branch.GetEntry(self.localentry, 0)
            return self.eVetoCicTightIso_value

    property eVetoMVAIso:
        def __get__(self):
            self.eVetoMVAIso_branch.GetEntry(self.localentry, 0)
            return self.eVetoMVAIso_value

    property eVetoMVAIsoVtx:
        def __get__(self):
            self.eVetoMVAIsoVtx_branch.GetEntry(self.localentry, 0)
            return self.eVetoMVAIsoVtx_value

    property eVetoZH:
        def __get__(self):
            self.eVetoZH_branch.GetEntry(self.localentry, 0)
            return self.eVetoZH_value

    property eVetoZH_smallDR:
        def __get__(self):
            self.eVetoZH_smallDR_branch.GetEntry(self.localentry, 0)
            return self.eVetoZH_smallDR_value

    property evt:
        def __get__(self):
            self.evt_branch.GetEntry(self.localentry, 0)
            return self.evt_value

    property isGtautau:
        def __get__(self):
            self.isGtautau_branch.GetEntry(self.localentry, 0)
            return self.isGtautau_value

    property isWmunu:
        def __get__(self):
            self.isWmunu_branch.GetEntry(self.localentry, 0)
            return self.isWmunu_value

    property isWtaunu:
        def __get__(self):
            self.isWtaunu_branch.GetEntry(self.localentry, 0)
            return self.isWtaunu_value

    property isZtautau:
        def __get__(self):
            self.isZtautau_branch.GetEntry(self.localentry, 0)
            return self.isZtautau_value

    property isdata:
        def __get__(self):
            self.isdata_branch.GetEntry(self.localentry, 0)
            return self.isdata_value

    property isoMu24eta2p1Group:
        def __get__(self):
            self.isoMu24eta2p1Group_branch.GetEntry(self.localentry, 0)
            return self.isoMu24eta2p1Group_value

    property isoMu24eta2p1Pass:
        def __get__(self):
            self.isoMu24eta2p1Pass_branch.GetEntry(self.localentry, 0)
            return self.isoMu24eta2p1Pass_value

    property isoMu24eta2p1Prescale:
        def __get__(self):
            self.isoMu24eta2p1Prescale_branch.GetEntry(self.localentry, 0)
            return self.isoMu24eta2p1Prescale_value

    property isoMuGroup:
        def __get__(self):
            self.isoMuGroup_branch.GetEntry(self.localentry, 0)
            return self.isoMuGroup_value

    property isoMuPass:
        def __get__(self):
            self.isoMuPass_branch.GetEntry(self.localentry, 0)
            return self.isoMuPass_value

    property isoMuPrescale:
        def __get__(self):
            self.isoMuPrescale_branch.GetEntry(self.localentry, 0)
            return self.isoMuPrescale_value

    property isoMuTauGroup:
        def __get__(self):
            self.isoMuTauGroup_branch.GetEntry(self.localentry, 0)
            return self.isoMuTauGroup_value

    property isoMuTauPass:
        def __get__(self):
            self.isoMuTauPass_branch.GetEntry(self.localentry, 0)
            return self.isoMuTauPass_value

    property isoMuTauPrescale:
        def __get__(self):
            self.isoMuTauPrescale_branch.GetEntry(self.localentry, 0)
            return self.isoMuTauPrescale_value

    property jetVeto20:
        def __get__(self):
            self.jetVeto20_branch.GetEntry(self.localentry, 0)
            return self.jetVeto20_value

    property jetVeto20_DR05:
        def __get__(self):
            self.jetVeto20_DR05_branch.GetEntry(self.localentry, 0)
            return self.jetVeto20_DR05_value

    property jetVeto30:
        def __get__(self):
            self.jetVeto30_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30_value

    property jetVeto30_DR05:
        def __get__(self):
            self.jetVeto30_DR05_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30_DR05_value

    property jetVeto40:
        def __get__(self):
            self.jetVeto40_branch.GetEntry(self.localentry, 0)
            return self.jetVeto40_value

    property jetVeto40_DR05:
        def __get__(self):
            self.jetVeto40_DR05_branch.GetEntry(self.localentry, 0)
            return self.jetVeto40_DR05_value

    property lumi:
        def __get__(self):
            self.lumi_branch.GetEntry(self.localentry, 0)
            return self.lumi_value

    property m1AbsEta:
        def __get__(self):
            self.m1AbsEta_branch.GetEntry(self.localentry, 0)
            return self.m1AbsEta_value

    property m1Charge:
        def __get__(self):
            self.m1Charge_branch.GetEntry(self.localentry, 0)
            return self.m1Charge_value

    property m1ComesFromHiggs:
        def __get__(self):
            self.m1ComesFromHiggs_branch.GetEntry(self.localentry, 0)
            return self.m1ComesFromHiggs_value

    property m1D0:
        def __get__(self):
            self.m1D0_branch.GetEntry(self.localentry, 0)
            return self.m1D0_value

    property m1DZ:
        def __get__(self):
            self.m1DZ_branch.GetEntry(self.localentry, 0)
            return self.m1DZ_value

    property m1DiMuonL3PreFiltered7:
        def __get__(self):
            self.m1DiMuonL3PreFiltered7_branch.GetEntry(self.localentry, 0)
            return self.m1DiMuonL3PreFiltered7_value

    property m1DiMuonL3p5PreFiltered8:
        def __get__(self):
            self.m1DiMuonL3p5PreFiltered8_branch.GetEntry(self.localentry, 0)
            return self.m1DiMuonL3p5PreFiltered8_value

    property m1DiMuonMu17Mu8DzFiltered0p2:
        def __get__(self):
            self.m1DiMuonMu17Mu8DzFiltered0p2_branch.GetEntry(self.localentry, 0)
            return self.m1DiMuonMu17Mu8DzFiltered0p2_value

    property m1EErrRochCor2011A:
        def __get__(self):
            self.m1EErrRochCor2011A_branch.GetEntry(self.localentry, 0)
            return self.m1EErrRochCor2011A_value

    property m1EErrRochCor2011B:
        def __get__(self):
            self.m1EErrRochCor2011B_branch.GetEntry(self.localentry, 0)
            return self.m1EErrRochCor2011B_value

    property m1EErrRochCor2012:
        def __get__(self):
            self.m1EErrRochCor2012_branch.GetEntry(self.localentry, 0)
            return self.m1EErrRochCor2012_value

    property m1ERochCor2011A:
        def __get__(self):
            self.m1ERochCor2011A_branch.GetEntry(self.localentry, 0)
            return self.m1ERochCor2011A_value

    property m1ERochCor2011B:
        def __get__(self):
            self.m1ERochCor2011B_branch.GetEntry(self.localentry, 0)
            return self.m1ERochCor2011B_value

    property m1ERochCor2012:
        def __get__(self):
            self.m1ERochCor2012_branch.GetEntry(self.localentry, 0)
            return self.m1ERochCor2012_value

    property m1EffectiveArea2011:
        def __get__(self):
            self.m1EffectiveArea2011_branch.GetEntry(self.localentry, 0)
            return self.m1EffectiveArea2011_value

    property m1EffectiveArea2012:
        def __get__(self):
            self.m1EffectiveArea2012_branch.GetEntry(self.localentry, 0)
            return self.m1EffectiveArea2012_value

    property m1Eta:
        def __get__(self):
            self.m1Eta_branch.GetEntry(self.localentry, 0)
            return self.m1Eta_value

    property m1EtaRochCor2011A:
        def __get__(self):
            self.m1EtaRochCor2011A_branch.GetEntry(self.localentry, 0)
            return self.m1EtaRochCor2011A_value

    property m1EtaRochCor2011B:
        def __get__(self):
            self.m1EtaRochCor2011B_branch.GetEntry(self.localentry, 0)
            return self.m1EtaRochCor2011B_value

    property m1EtaRochCor2012:
        def __get__(self):
            self.m1EtaRochCor2012_branch.GetEntry(self.localentry, 0)
            return self.m1EtaRochCor2012_value

    property m1GenCharge:
        def __get__(self):
            self.m1GenCharge_branch.GetEntry(self.localentry, 0)
            return self.m1GenCharge_value

    property m1GenEnergy:
        def __get__(self):
            self.m1GenEnergy_branch.GetEntry(self.localentry, 0)
            return self.m1GenEnergy_value

    property m1GenEta:
        def __get__(self):
            self.m1GenEta_branch.GetEntry(self.localentry, 0)
            return self.m1GenEta_value

    property m1GenMotherPdgId:
        def __get__(self):
            self.m1GenMotherPdgId_branch.GetEntry(self.localentry, 0)
            return self.m1GenMotherPdgId_value

    property m1GenPdgId:
        def __get__(self):
            self.m1GenPdgId_branch.GetEntry(self.localentry, 0)
            return self.m1GenPdgId_value

    property m1GenPhi:
        def __get__(self):
            self.m1GenPhi_branch.GetEntry(self.localentry, 0)
            return self.m1GenPhi_value

    property m1GlbTrkHits:
        def __get__(self):
            self.m1GlbTrkHits_branch.GetEntry(self.localentry, 0)
            return self.m1GlbTrkHits_value

    property m1IDHZG2011:
        def __get__(self):
            self.m1IDHZG2011_branch.GetEntry(self.localentry, 0)
            return self.m1IDHZG2011_value

    property m1IDHZG2012:
        def __get__(self):
            self.m1IDHZG2012_branch.GetEntry(self.localentry, 0)
            return self.m1IDHZG2012_value

    property m1IP3DS:
        def __get__(self):
            self.m1IP3DS_branch.GetEntry(self.localentry, 0)
            return self.m1IP3DS_value

    property m1IsGlobal:
        def __get__(self):
            self.m1IsGlobal_branch.GetEntry(self.localentry, 0)
            return self.m1IsGlobal_value

    property m1IsPFMuon:
        def __get__(self):
            self.m1IsPFMuon_branch.GetEntry(self.localentry, 0)
            return self.m1IsPFMuon_value

    property m1IsTracker:
        def __get__(self):
            self.m1IsTracker_branch.GetEntry(self.localentry, 0)
            return self.m1IsTracker_value

    property m1JetArea:
        def __get__(self):
            self.m1JetArea_branch.GetEntry(self.localentry, 0)
            return self.m1JetArea_value

    property m1JetBtag:
        def __get__(self):
            self.m1JetBtag_branch.GetEntry(self.localentry, 0)
            return self.m1JetBtag_value

    property m1JetCSVBtag:
        def __get__(self):
            self.m1JetCSVBtag_branch.GetEntry(self.localentry, 0)
            return self.m1JetCSVBtag_value

    property m1JetEtaEtaMoment:
        def __get__(self):
            self.m1JetEtaEtaMoment_branch.GetEntry(self.localentry, 0)
            return self.m1JetEtaEtaMoment_value

    property m1JetEtaPhiMoment:
        def __get__(self):
            self.m1JetEtaPhiMoment_branch.GetEntry(self.localentry, 0)
            return self.m1JetEtaPhiMoment_value

    property m1JetEtaPhiSpread:
        def __get__(self):
            self.m1JetEtaPhiSpread_branch.GetEntry(self.localentry, 0)
            return self.m1JetEtaPhiSpread_value

    property m1JetPartonFlavour:
        def __get__(self):
            self.m1JetPartonFlavour_branch.GetEntry(self.localentry, 0)
            return self.m1JetPartonFlavour_value

    property m1JetPhiPhiMoment:
        def __get__(self):
            self.m1JetPhiPhiMoment_branch.GetEntry(self.localentry, 0)
            return self.m1JetPhiPhiMoment_value

    property m1JetPt:
        def __get__(self):
            self.m1JetPt_branch.GetEntry(self.localentry, 0)
            return self.m1JetPt_value

    property m1JetQGLikelihoodID:
        def __get__(self):
            self.m1JetQGLikelihoodID_branch.GetEntry(self.localentry, 0)
            return self.m1JetQGLikelihoodID_value

    property m1JetQGMVAID:
        def __get__(self):
            self.m1JetQGMVAID_branch.GetEntry(self.localentry, 0)
            return self.m1JetQGMVAID_value

    property m1Jetaxis1:
        def __get__(self):
            self.m1Jetaxis1_branch.GetEntry(self.localentry, 0)
            return self.m1Jetaxis1_value

    property m1Jetaxis2:
        def __get__(self):
            self.m1Jetaxis2_branch.GetEntry(self.localentry, 0)
            return self.m1Jetaxis2_value

    property m1Jetmult:
        def __get__(self):
            self.m1Jetmult_branch.GetEntry(self.localentry, 0)
            return self.m1Jetmult_value

    property m1JetmultMLP:
        def __get__(self):
            self.m1JetmultMLP_branch.GetEntry(self.localentry, 0)
            return self.m1JetmultMLP_value

    property m1JetmultMLPQC:
        def __get__(self):
            self.m1JetmultMLPQC_branch.GetEntry(self.localentry, 0)
            return self.m1JetmultMLPQC_value

    property m1JetptD:
        def __get__(self):
            self.m1JetptD_branch.GetEntry(self.localentry, 0)
            return self.m1JetptD_value

    property m1L1Mu3EG5L3Filtered17:
        def __get__(self):
            self.m1L1Mu3EG5L3Filtered17_branch.GetEntry(self.localentry, 0)
            return self.m1L1Mu3EG5L3Filtered17_value

    property m1L3fL1DoubleMu10MuOpenL1f0L2f10L3Filtered17:
        def __get__(self):
            self.m1L3fL1DoubleMu10MuOpenL1f0L2f10L3Filtered17_branch.GetEntry(self.localentry, 0)
            return self.m1L3fL1DoubleMu10MuOpenL1f0L2f10L3Filtered17_value

    property m1Mass:
        def __get__(self):
            self.m1Mass_branch.GetEntry(self.localentry, 0)
            return self.m1Mass_value

    property m1MatchedStations:
        def __get__(self):
            self.m1MatchedStations_branch.GetEntry(self.localentry, 0)
            return self.m1MatchedStations_value

    property m1MatchesDoubleMuPaths:
        def __get__(self):
            self.m1MatchesDoubleMuPaths_branch.GetEntry(self.localentry, 0)
            return self.m1MatchesDoubleMuPaths_value

    property m1MatchesDoubleMuTrkPaths:
        def __get__(self):
            self.m1MatchesDoubleMuTrkPaths_branch.GetEntry(self.localentry, 0)
            return self.m1MatchesDoubleMuTrkPaths_value

    property m1MatchesIsoMu24eta2p1:
        def __get__(self):
            self.m1MatchesIsoMu24eta2p1_branch.GetEntry(self.localentry, 0)
            return self.m1MatchesIsoMu24eta2p1_value

    property m1MatchesIsoMuGroup:
        def __get__(self):
            self.m1MatchesIsoMuGroup_branch.GetEntry(self.localentry, 0)
            return self.m1MatchesIsoMuGroup_value

    property m1MatchesMu17Ele8IsoPath:
        def __get__(self):
            self.m1MatchesMu17Ele8IsoPath_branch.GetEntry(self.localentry, 0)
            return self.m1MatchesMu17Ele8IsoPath_value

    property m1MatchesMu17Ele8Path:
        def __get__(self):
            self.m1MatchesMu17Ele8Path_branch.GetEntry(self.localentry, 0)
            return self.m1MatchesMu17Ele8Path_value

    property m1MatchesMu17Mu8Path:
        def __get__(self):
            self.m1MatchesMu17Mu8Path_branch.GetEntry(self.localentry, 0)
            return self.m1MatchesMu17Mu8Path_value

    property m1MatchesMu17TrkMu8Path:
        def __get__(self):
            self.m1MatchesMu17TrkMu8Path_branch.GetEntry(self.localentry, 0)
            return self.m1MatchesMu17TrkMu8Path_value

    property m1MatchesMu8Ele17IsoPath:
        def __get__(self):
            self.m1MatchesMu8Ele17IsoPath_branch.GetEntry(self.localentry, 0)
            return self.m1MatchesMu8Ele17IsoPath_value

    property m1MatchesMu8Ele17Path:
        def __get__(self):
            self.m1MatchesMu8Ele17Path_branch.GetEntry(self.localentry, 0)
            return self.m1MatchesMu8Ele17Path_value

    property m1MtToMET:
        def __get__(self):
            self.m1MtToMET_branch.GetEntry(self.localentry, 0)
            return self.m1MtToMET_value

    property m1MtToMVAMET:
        def __get__(self):
            self.m1MtToMVAMET_branch.GetEntry(self.localentry, 0)
            return self.m1MtToMVAMET_value

    property m1MtToPFMET:
        def __get__(self):
            self.m1MtToPFMET_branch.GetEntry(self.localentry, 0)
            return self.m1MtToPFMET_value

    property m1MtToPfMet_Ty1:
        def __get__(self):
            self.m1MtToPfMet_Ty1_branch.GetEntry(self.localentry, 0)
            return self.m1MtToPfMet_Ty1_value

    property m1MtToPfMet_jes:
        def __get__(self):
            self.m1MtToPfMet_jes_branch.GetEntry(self.localentry, 0)
            return self.m1MtToPfMet_jes_value

    property m1MtToPfMet_mes:
        def __get__(self):
            self.m1MtToPfMet_mes_branch.GetEntry(self.localentry, 0)
            return self.m1MtToPfMet_mes_value

    property m1MtToPfMet_tes:
        def __get__(self):
            self.m1MtToPfMet_tes_branch.GetEntry(self.localentry, 0)
            return self.m1MtToPfMet_tes_value

    property m1MtToPfMet_ues:
        def __get__(self):
            self.m1MtToPfMet_ues_branch.GetEntry(self.localentry, 0)
            return self.m1MtToPfMet_ues_value

    property m1Mu17Ele8dZFilter:
        def __get__(self):
            self.m1Mu17Ele8dZFilter_branch.GetEntry(self.localentry, 0)
            return self.m1Mu17Ele8dZFilter_value

    property m1MuonHits:
        def __get__(self):
            self.m1MuonHits_branch.GetEntry(self.localentry, 0)
            return self.m1MuonHits_value

    property m1NormTrkChi2:
        def __get__(self):
            self.m1NormTrkChi2_branch.GetEntry(self.localentry, 0)
            return self.m1NormTrkChi2_value

    property m1PFChargedIso:
        def __get__(self):
            self.m1PFChargedIso_branch.GetEntry(self.localentry, 0)
            return self.m1PFChargedIso_value

    property m1PFIDTight:
        def __get__(self):
            self.m1PFIDTight_branch.GetEntry(self.localentry, 0)
            return self.m1PFIDTight_value

    property m1PFNeutralIso:
        def __get__(self):
            self.m1PFNeutralIso_branch.GetEntry(self.localentry, 0)
            return self.m1PFNeutralIso_value

    property m1PFPUChargedIso:
        def __get__(self):
            self.m1PFPUChargedIso_branch.GetEntry(self.localentry, 0)
            return self.m1PFPUChargedIso_value

    property m1PFPhotonIso:
        def __get__(self):
            self.m1PFPhotonIso_branch.GetEntry(self.localentry, 0)
            return self.m1PFPhotonIso_value

    property m1PVDXY:
        def __get__(self):
            self.m1PVDXY_branch.GetEntry(self.localentry, 0)
            return self.m1PVDXY_value

    property m1PVDZ:
        def __get__(self):
            self.m1PVDZ_branch.GetEntry(self.localentry, 0)
            return self.m1PVDZ_value

    property m1Phi:
        def __get__(self):
            self.m1Phi_branch.GetEntry(self.localentry, 0)
            return self.m1Phi_value

    property m1PhiRochCor2011A:
        def __get__(self):
            self.m1PhiRochCor2011A_branch.GetEntry(self.localentry, 0)
            return self.m1PhiRochCor2011A_value

    property m1PhiRochCor2011B:
        def __get__(self):
            self.m1PhiRochCor2011B_branch.GetEntry(self.localentry, 0)
            return self.m1PhiRochCor2011B_value

    property m1PhiRochCor2012:
        def __get__(self):
            self.m1PhiRochCor2012_branch.GetEntry(self.localentry, 0)
            return self.m1PhiRochCor2012_value

    property m1PixHits:
        def __get__(self):
            self.m1PixHits_branch.GetEntry(self.localentry, 0)
            return self.m1PixHits_value

    property m1Pt:
        def __get__(self):
            self.m1Pt_branch.GetEntry(self.localentry, 0)
            return self.m1Pt_value

    property m1PtRochCor2011A:
        def __get__(self):
            self.m1PtRochCor2011A_branch.GetEntry(self.localentry, 0)
            return self.m1PtRochCor2011A_value

    property m1PtRochCor2011B:
        def __get__(self):
            self.m1PtRochCor2011B_branch.GetEntry(self.localentry, 0)
            return self.m1PtRochCor2011B_value

    property m1PtRochCor2012:
        def __get__(self):
            self.m1PtRochCor2012_branch.GetEntry(self.localentry, 0)
            return self.m1PtRochCor2012_value

    property m1Rank:
        def __get__(self):
            self.m1Rank_branch.GetEntry(self.localentry, 0)
            return self.m1Rank_value

    property m1RelPFIsoDB:
        def __get__(self):
            self.m1RelPFIsoDB_branch.GetEntry(self.localentry, 0)
            return self.m1RelPFIsoDB_value

    property m1RelPFIsoRho:
        def __get__(self):
            self.m1RelPFIsoRho_branch.GetEntry(self.localentry, 0)
            return self.m1RelPFIsoRho_value

    property m1RelPFIsoRhoFSR:
        def __get__(self):
            self.m1RelPFIsoRhoFSR_branch.GetEntry(self.localentry, 0)
            return self.m1RelPFIsoRhoFSR_value

    property m1RhoHZG2011:
        def __get__(self):
            self.m1RhoHZG2011_branch.GetEntry(self.localentry, 0)
            return self.m1RhoHZG2011_value

    property m1RhoHZG2012:
        def __get__(self):
            self.m1RhoHZG2012_branch.GetEntry(self.localentry, 0)
            return self.m1RhoHZG2012_value

    property m1SingleMu13L3Filtered13:
        def __get__(self):
            self.m1SingleMu13L3Filtered13_branch.GetEntry(self.localentry, 0)
            return self.m1SingleMu13L3Filtered13_value

    property m1SingleMu13L3Filtered17:
        def __get__(self):
            self.m1SingleMu13L3Filtered17_branch.GetEntry(self.localentry, 0)
            return self.m1SingleMu13L3Filtered17_value

    property m1TkLayersWithMeasurement:
        def __get__(self):
            self.m1TkLayersWithMeasurement_branch.GetEntry(self.localentry, 0)
            return self.m1TkLayersWithMeasurement_value

    property m1ToMETDPhi:
        def __get__(self):
            self.m1ToMETDPhi_branch.GetEntry(self.localentry, 0)
            return self.m1ToMETDPhi_value

    property m1TypeCode:
        def __get__(self):
            self.m1TypeCode_branch.GetEntry(self.localentry, 0)
            return self.m1TypeCode_value

    property m1VBTFID:
        def __get__(self):
            self.m1VBTFID_branch.GetEntry(self.localentry, 0)
            return self.m1VBTFID_value

    property m1VZ:
        def __get__(self):
            self.m1VZ_branch.GetEntry(self.localentry, 0)
            return self.m1VZ_value

    property m1WWID:
        def __get__(self):
            self.m1WWID_branch.GetEntry(self.localentry, 0)
            return self.m1WWID_value

    property m1_m2_CosThetaStar:
        def __get__(self):
            self.m1_m2_CosThetaStar_branch.GetEntry(self.localentry, 0)
            return self.m1_m2_CosThetaStar_value

    property m1_m2_DPhi:
        def __get__(self):
            self.m1_m2_DPhi_branch.GetEntry(self.localentry, 0)
            return self.m1_m2_DPhi_value

    property m1_m2_DR:
        def __get__(self):
            self.m1_m2_DR_branch.GetEntry(self.localentry, 0)
            return self.m1_m2_DR_value

    property m1_m2_Eta:
        def __get__(self):
            self.m1_m2_Eta_branch.GetEntry(self.localentry, 0)
            return self.m1_m2_Eta_value

    property m1_m2_Mass:
        def __get__(self):
            self.m1_m2_Mass_branch.GetEntry(self.localentry, 0)
            return self.m1_m2_Mass_value

    property m1_m2_MassFsr:
        def __get__(self):
            self.m1_m2_MassFsr_branch.GetEntry(self.localentry, 0)
            return self.m1_m2_MassFsr_value

    property m1_m2_PZeta:
        def __get__(self):
            self.m1_m2_PZeta_branch.GetEntry(self.localentry, 0)
            return self.m1_m2_PZeta_value

    property m1_m2_PZetaVis:
        def __get__(self):
            self.m1_m2_PZetaVis_branch.GetEntry(self.localentry, 0)
            return self.m1_m2_PZetaVis_value

    property m1_m2_Phi:
        def __get__(self):
            self.m1_m2_Phi_branch.GetEntry(self.localentry, 0)
            return self.m1_m2_Phi_value

    property m1_m2_Pt:
        def __get__(self):
            self.m1_m2_Pt_branch.GetEntry(self.localentry, 0)
            return self.m1_m2_Pt_value

    property m1_m2_PtFsr:
        def __get__(self):
            self.m1_m2_PtFsr_branch.GetEntry(self.localentry, 0)
            return self.m1_m2_PtFsr_value

    property m1_m2_SS:
        def __get__(self):
            self.m1_m2_SS_branch.GetEntry(self.localentry, 0)
            return self.m1_m2_SS_value

    property m1_m2_ToMETDPhi_Ty1:
        def __get__(self):
            self.m1_m2_ToMETDPhi_Ty1_branch.GetEntry(self.localentry, 0)
            return self.m1_m2_ToMETDPhi_Ty1_value

    property m1_m2_Zcompat:
        def __get__(self):
            self.m1_m2_Zcompat_branch.GetEntry(self.localentry, 0)
            return self.m1_m2_Zcompat_value

    property m1_t1_CosThetaStar:
        def __get__(self):
            self.m1_t1_CosThetaStar_branch.GetEntry(self.localentry, 0)
            return self.m1_t1_CosThetaStar_value

    property m1_t1_DPhi:
        def __get__(self):
            self.m1_t1_DPhi_branch.GetEntry(self.localentry, 0)
            return self.m1_t1_DPhi_value

    property m1_t1_DR:
        def __get__(self):
            self.m1_t1_DR_branch.GetEntry(self.localentry, 0)
            return self.m1_t1_DR_value

    property m1_t1_Eta:
        def __get__(self):
            self.m1_t1_Eta_branch.GetEntry(self.localentry, 0)
            return self.m1_t1_Eta_value

    property m1_t1_Mass:
        def __get__(self):
            self.m1_t1_Mass_branch.GetEntry(self.localentry, 0)
            return self.m1_t1_Mass_value

    property m1_t1_MassFsr:
        def __get__(self):
            self.m1_t1_MassFsr_branch.GetEntry(self.localentry, 0)
            return self.m1_t1_MassFsr_value

    property m1_t1_PZeta:
        def __get__(self):
            self.m1_t1_PZeta_branch.GetEntry(self.localentry, 0)
            return self.m1_t1_PZeta_value

    property m1_t1_PZetaVis:
        def __get__(self):
            self.m1_t1_PZetaVis_branch.GetEntry(self.localentry, 0)
            return self.m1_t1_PZetaVis_value

    property m1_t1_Phi:
        def __get__(self):
            self.m1_t1_Phi_branch.GetEntry(self.localentry, 0)
            return self.m1_t1_Phi_value

    property m1_t1_Pt:
        def __get__(self):
            self.m1_t1_Pt_branch.GetEntry(self.localentry, 0)
            return self.m1_t1_Pt_value

    property m1_t1_PtFsr:
        def __get__(self):
            self.m1_t1_PtFsr_branch.GetEntry(self.localentry, 0)
            return self.m1_t1_PtFsr_value

    property m1_t1_SS:
        def __get__(self):
            self.m1_t1_SS_branch.GetEntry(self.localentry, 0)
            return self.m1_t1_SS_value

    property m1_t1_ToMETDPhi_Ty1:
        def __get__(self):
            self.m1_t1_ToMETDPhi_Ty1_branch.GetEntry(self.localentry, 0)
            return self.m1_t1_ToMETDPhi_Ty1_value

    property m1_t1_Zcompat:
        def __get__(self):
            self.m1_t1_Zcompat_branch.GetEntry(self.localentry, 0)
            return self.m1_t1_Zcompat_value

    property m1_t2_CosThetaStar:
        def __get__(self):
            self.m1_t2_CosThetaStar_branch.GetEntry(self.localentry, 0)
            return self.m1_t2_CosThetaStar_value

    property m1_t2_DPhi:
        def __get__(self):
            self.m1_t2_DPhi_branch.GetEntry(self.localentry, 0)
            return self.m1_t2_DPhi_value

    property m1_t2_DR:
        def __get__(self):
            self.m1_t2_DR_branch.GetEntry(self.localentry, 0)
            return self.m1_t2_DR_value

    property m1_t2_Eta:
        def __get__(self):
            self.m1_t2_Eta_branch.GetEntry(self.localentry, 0)
            return self.m1_t2_Eta_value

    property m1_t2_Mass:
        def __get__(self):
            self.m1_t2_Mass_branch.GetEntry(self.localentry, 0)
            return self.m1_t2_Mass_value

    property m1_t2_MassFsr:
        def __get__(self):
            self.m1_t2_MassFsr_branch.GetEntry(self.localentry, 0)
            return self.m1_t2_MassFsr_value

    property m1_t2_PZeta:
        def __get__(self):
            self.m1_t2_PZeta_branch.GetEntry(self.localentry, 0)
            return self.m1_t2_PZeta_value

    property m1_t2_PZetaVis:
        def __get__(self):
            self.m1_t2_PZetaVis_branch.GetEntry(self.localentry, 0)
            return self.m1_t2_PZetaVis_value

    property m1_t2_Phi:
        def __get__(self):
            self.m1_t2_Phi_branch.GetEntry(self.localentry, 0)
            return self.m1_t2_Phi_value

    property m1_t2_Pt:
        def __get__(self):
            self.m1_t2_Pt_branch.GetEntry(self.localentry, 0)
            return self.m1_t2_Pt_value

    property m1_t2_PtFsr:
        def __get__(self):
            self.m1_t2_PtFsr_branch.GetEntry(self.localentry, 0)
            return self.m1_t2_PtFsr_value

    property m1_t2_SS:
        def __get__(self):
            self.m1_t2_SS_branch.GetEntry(self.localentry, 0)
            return self.m1_t2_SS_value

    property m1_t2_ToMETDPhi_Ty1:
        def __get__(self):
            self.m1_t2_ToMETDPhi_Ty1_branch.GetEntry(self.localentry, 0)
            return self.m1_t2_ToMETDPhi_Ty1_value

    property m1_t2_Zcompat:
        def __get__(self):
            self.m1_t2_Zcompat_branch.GetEntry(self.localentry, 0)
            return self.m1_t2_Zcompat_value

    property m2AbsEta:
        def __get__(self):
            self.m2AbsEta_branch.GetEntry(self.localentry, 0)
            return self.m2AbsEta_value

    property m2Charge:
        def __get__(self):
            self.m2Charge_branch.GetEntry(self.localentry, 0)
            return self.m2Charge_value

    property m2ComesFromHiggs:
        def __get__(self):
            self.m2ComesFromHiggs_branch.GetEntry(self.localentry, 0)
            return self.m2ComesFromHiggs_value

    property m2D0:
        def __get__(self):
            self.m2D0_branch.GetEntry(self.localentry, 0)
            return self.m2D0_value

    property m2DZ:
        def __get__(self):
            self.m2DZ_branch.GetEntry(self.localentry, 0)
            return self.m2DZ_value

    property m2DiMuonL3PreFiltered7:
        def __get__(self):
            self.m2DiMuonL3PreFiltered7_branch.GetEntry(self.localentry, 0)
            return self.m2DiMuonL3PreFiltered7_value

    property m2DiMuonL3p5PreFiltered8:
        def __get__(self):
            self.m2DiMuonL3p5PreFiltered8_branch.GetEntry(self.localentry, 0)
            return self.m2DiMuonL3p5PreFiltered8_value

    property m2DiMuonMu17Mu8DzFiltered0p2:
        def __get__(self):
            self.m2DiMuonMu17Mu8DzFiltered0p2_branch.GetEntry(self.localentry, 0)
            return self.m2DiMuonMu17Mu8DzFiltered0p2_value

    property m2EErrRochCor2011A:
        def __get__(self):
            self.m2EErrRochCor2011A_branch.GetEntry(self.localentry, 0)
            return self.m2EErrRochCor2011A_value

    property m2EErrRochCor2011B:
        def __get__(self):
            self.m2EErrRochCor2011B_branch.GetEntry(self.localentry, 0)
            return self.m2EErrRochCor2011B_value

    property m2EErrRochCor2012:
        def __get__(self):
            self.m2EErrRochCor2012_branch.GetEntry(self.localentry, 0)
            return self.m2EErrRochCor2012_value

    property m2ERochCor2011A:
        def __get__(self):
            self.m2ERochCor2011A_branch.GetEntry(self.localentry, 0)
            return self.m2ERochCor2011A_value

    property m2ERochCor2011B:
        def __get__(self):
            self.m2ERochCor2011B_branch.GetEntry(self.localentry, 0)
            return self.m2ERochCor2011B_value

    property m2ERochCor2012:
        def __get__(self):
            self.m2ERochCor2012_branch.GetEntry(self.localentry, 0)
            return self.m2ERochCor2012_value

    property m2EffectiveArea2011:
        def __get__(self):
            self.m2EffectiveArea2011_branch.GetEntry(self.localentry, 0)
            return self.m2EffectiveArea2011_value

    property m2EffectiveArea2012:
        def __get__(self):
            self.m2EffectiveArea2012_branch.GetEntry(self.localentry, 0)
            return self.m2EffectiveArea2012_value

    property m2Eta:
        def __get__(self):
            self.m2Eta_branch.GetEntry(self.localentry, 0)
            return self.m2Eta_value

    property m2EtaRochCor2011A:
        def __get__(self):
            self.m2EtaRochCor2011A_branch.GetEntry(self.localentry, 0)
            return self.m2EtaRochCor2011A_value

    property m2EtaRochCor2011B:
        def __get__(self):
            self.m2EtaRochCor2011B_branch.GetEntry(self.localentry, 0)
            return self.m2EtaRochCor2011B_value

    property m2EtaRochCor2012:
        def __get__(self):
            self.m2EtaRochCor2012_branch.GetEntry(self.localentry, 0)
            return self.m2EtaRochCor2012_value

    property m2GenCharge:
        def __get__(self):
            self.m2GenCharge_branch.GetEntry(self.localentry, 0)
            return self.m2GenCharge_value

    property m2GenEnergy:
        def __get__(self):
            self.m2GenEnergy_branch.GetEntry(self.localentry, 0)
            return self.m2GenEnergy_value

    property m2GenEta:
        def __get__(self):
            self.m2GenEta_branch.GetEntry(self.localentry, 0)
            return self.m2GenEta_value

    property m2GenMotherPdgId:
        def __get__(self):
            self.m2GenMotherPdgId_branch.GetEntry(self.localentry, 0)
            return self.m2GenMotherPdgId_value

    property m2GenPdgId:
        def __get__(self):
            self.m2GenPdgId_branch.GetEntry(self.localentry, 0)
            return self.m2GenPdgId_value

    property m2GenPhi:
        def __get__(self):
            self.m2GenPhi_branch.GetEntry(self.localentry, 0)
            return self.m2GenPhi_value

    property m2GlbTrkHits:
        def __get__(self):
            self.m2GlbTrkHits_branch.GetEntry(self.localentry, 0)
            return self.m2GlbTrkHits_value

    property m2IDHZG2011:
        def __get__(self):
            self.m2IDHZG2011_branch.GetEntry(self.localentry, 0)
            return self.m2IDHZG2011_value

    property m2IDHZG2012:
        def __get__(self):
            self.m2IDHZG2012_branch.GetEntry(self.localentry, 0)
            return self.m2IDHZG2012_value

    property m2IP3DS:
        def __get__(self):
            self.m2IP3DS_branch.GetEntry(self.localentry, 0)
            return self.m2IP3DS_value

    property m2IsGlobal:
        def __get__(self):
            self.m2IsGlobal_branch.GetEntry(self.localentry, 0)
            return self.m2IsGlobal_value

    property m2IsPFMuon:
        def __get__(self):
            self.m2IsPFMuon_branch.GetEntry(self.localentry, 0)
            return self.m2IsPFMuon_value

    property m2IsTracker:
        def __get__(self):
            self.m2IsTracker_branch.GetEntry(self.localentry, 0)
            return self.m2IsTracker_value

    property m2JetArea:
        def __get__(self):
            self.m2JetArea_branch.GetEntry(self.localentry, 0)
            return self.m2JetArea_value

    property m2JetBtag:
        def __get__(self):
            self.m2JetBtag_branch.GetEntry(self.localentry, 0)
            return self.m2JetBtag_value

    property m2JetCSVBtag:
        def __get__(self):
            self.m2JetCSVBtag_branch.GetEntry(self.localentry, 0)
            return self.m2JetCSVBtag_value

    property m2JetEtaEtaMoment:
        def __get__(self):
            self.m2JetEtaEtaMoment_branch.GetEntry(self.localentry, 0)
            return self.m2JetEtaEtaMoment_value

    property m2JetEtaPhiMoment:
        def __get__(self):
            self.m2JetEtaPhiMoment_branch.GetEntry(self.localentry, 0)
            return self.m2JetEtaPhiMoment_value

    property m2JetEtaPhiSpread:
        def __get__(self):
            self.m2JetEtaPhiSpread_branch.GetEntry(self.localentry, 0)
            return self.m2JetEtaPhiSpread_value

    property m2JetPartonFlavour:
        def __get__(self):
            self.m2JetPartonFlavour_branch.GetEntry(self.localentry, 0)
            return self.m2JetPartonFlavour_value

    property m2JetPhiPhiMoment:
        def __get__(self):
            self.m2JetPhiPhiMoment_branch.GetEntry(self.localentry, 0)
            return self.m2JetPhiPhiMoment_value

    property m2JetPt:
        def __get__(self):
            self.m2JetPt_branch.GetEntry(self.localentry, 0)
            return self.m2JetPt_value

    property m2JetQGLikelihoodID:
        def __get__(self):
            self.m2JetQGLikelihoodID_branch.GetEntry(self.localentry, 0)
            return self.m2JetQGLikelihoodID_value

    property m2JetQGMVAID:
        def __get__(self):
            self.m2JetQGMVAID_branch.GetEntry(self.localentry, 0)
            return self.m2JetQGMVAID_value

    property m2Jetaxis1:
        def __get__(self):
            self.m2Jetaxis1_branch.GetEntry(self.localentry, 0)
            return self.m2Jetaxis1_value

    property m2Jetaxis2:
        def __get__(self):
            self.m2Jetaxis2_branch.GetEntry(self.localentry, 0)
            return self.m2Jetaxis2_value

    property m2Jetmult:
        def __get__(self):
            self.m2Jetmult_branch.GetEntry(self.localentry, 0)
            return self.m2Jetmult_value

    property m2JetmultMLP:
        def __get__(self):
            self.m2JetmultMLP_branch.GetEntry(self.localentry, 0)
            return self.m2JetmultMLP_value

    property m2JetmultMLPQC:
        def __get__(self):
            self.m2JetmultMLPQC_branch.GetEntry(self.localentry, 0)
            return self.m2JetmultMLPQC_value

    property m2JetptD:
        def __get__(self):
            self.m2JetptD_branch.GetEntry(self.localentry, 0)
            return self.m2JetptD_value

    property m2L1Mu3EG5L3Filtered17:
        def __get__(self):
            self.m2L1Mu3EG5L3Filtered17_branch.GetEntry(self.localentry, 0)
            return self.m2L1Mu3EG5L3Filtered17_value

    property m2L3fL1DoubleMu10MuOpenL1f0L2f10L3Filtered17:
        def __get__(self):
            self.m2L3fL1DoubleMu10MuOpenL1f0L2f10L3Filtered17_branch.GetEntry(self.localentry, 0)
            return self.m2L3fL1DoubleMu10MuOpenL1f0L2f10L3Filtered17_value

    property m2Mass:
        def __get__(self):
            self.m2Mass_branch.GetEntry(self.localentry, 0)
            return self.m2Mass_value

    property m2MatchedStations:
        def __get__(self):
            self.m2MatchedStations_branch.GetEntry(self.localentry, 0)
            return self.m2MatchedStations_value

    property m2MatchesDoubleMuPaths:
        def __get__(self):
            self.m2MatchesDoubleMuPaths_branch.GetEntry(self.localentry, 0)
            return self.m2MatchesDoubleMuPaths_value

    property m2MatchesDoubleMuTrkPaths:
        def __get__(self):
            self.m2MatchesDoubleMuTrkPaths_branch.GetEntry(self.localentry, 0)
            return self.m2MatchesDoubleMuTrkPaths_value

    property m2MatchesIsoMu24eta2p1:
        def __get__(self):
            self.m2MatchesIsoMu24eta2p1_branch.GetEntry(self.localentry, 0)
            return self.m2MatchesIsoMu24eta2p1_value

    property m2MatchesIsoMuGroup:
        def __get__(self):
            self.m2MatchesIsoMuGroup_branch.GetEntry(self.localentry, 0)
            return self.m2MatchesIsoMuGroup_value

    property m2MatchesMu17Ele8IsoPath:
        def __get__(self):
            self.m2MatchesMu17Ele8IsoPath_branch.GetEntry(self.localentry, 0)
            return self.m2MatchesMu17Ele8IsoPath_value

    property m2MatchesMu17Ele8Path:
        def __get__(self):
            self.m2MatchesMu17Ele8Path_branch.GetEntry(self.localentry, 0)
            return self.m2MatchesMu17Ele8Path_value

    property m2MatchesMu17Mu8Path:
        def __get__(self):
            self.m2MatchesMu17Mu8Path_branch.GetEntry(self.localentry, 0)
            return self.m2MatchesMu17Mu8Path_value

    property m2MatchesMu17TrkMu8Path:
        def __get__(self):
            self.m2MatchesMu17TrkMu8Path_branch.GetEntry(self.localentry, 0)
            return self.m2MatchesMu17TrkMu8Path_value

    property m2MatchesMu8Ele17IsoPath:
        def __get__(self):
            self.m2MatchesMu8Ele17IsoPath_branch.GetEntry(self.localentry, 0)
            return self.m2MatchesMu8Ele17IsoPath_value

    property m2MatchesMu8Ele17Path:
        def __get__(self):
            self.m2MatchesMu8Ele17Path_branch.GetEntry(self.localentry, 0)
            return self.m2MatchesMu8Ele17Path_value

    property m2MtToMET:
        def __get__(self):
            self.m2MtToMET_branch.GetEntry(self.localentry, 0)
            return self.m2MtToMET_value

    property m2MtToMVAMET:
        def __get__(self):
            self.m2MtToMVAMET_branch.GetEntry(self.localentry, 0)
            return self.m2MtToMVAMET_value

    property m2MtToPFMET:
        def __get__(self):
            self.m2MtToPFMET_branch.GetEntry(self.localentry, 0)
            return self.m2MtToPFMET_value

    property m2MtToPfMet_Ty1:
        def __get__(self):
            self.m2MtToPfMet_Ty1_branch.GetEntry(self.localentry, 0)
            return self.m2MtToPfMet_Ty1_value

    property m2MtToPfMet_jes:
        def __get__(self):
            self.m2MtToPfMet_jes_branch.GetEntry(self.localentry, 0)
            return self.m2MtToPfMet_jes_value

    property m2MtToPfMet_mes:
        def __get__(self):
            self.m2MtToPfMet_mes_branch.GetEntry(self.localentry, 0)
            return self.m2MtToPfMet_mes_value

    property m2MtToPfMet_tes:
        def __get__(self):
            self.m2MtToPfMet_tes_branch.GetEntry(self.localentry, 0)
            return self.m2MtToPfMet_tes_value

    property m2MtToPfMet_ues:
        def __get__(self):
            self.m2MtToPfMet_ues_branch.GetEntry(self.localentry, 0)
            return self.m2MtToPfMet_ues_value

    property m2Mu17Ele8dZFilter:
        def __get__(self):
            self.m2Mu17Ele8dZFilter_branch.GetEntry(self.localentry, 0)
            return self.m2Mu17Ele8dZFilter_value

    property m2MuonHits:
        def __get__(self):
            self.m2MuonHits_branch.GetEntry(self.localentry, 0)
            return self.m2MuonHits_value

    property m2NormTrkChi2:
        def __get__(self):
            self.m2NormTrkChi2_branch.GetEntry(self.localentry, 0)
            return self.m2NormTrkChi2_value

    property m2PFChargedIso:
        def __get__(self):
            self.m2PFChargedIso_branch.GetEntry(self.localentry, 0)
            return self.m2PFChargedIso_value

    property m2PFIDTight:
        def __get__(self):
            self.m2PFIDTight_branch.GetEntry(self.localentry, 0)
            return self.m2PFIDTight_value

    property m2PFNeutralIso:
        def __get__(self):
            self.m2PFNeutralIso_branch.GetEntry(self.localentry, 0)
            return self.m2PFNeutralIso_value

    property m2PFPUChargedIso:
        def __get__(self):
            self.m2PFPUChargedIso_branch.GetEntry(self.localentry, 0)
            return self.m2PFPUChargedIso_value

    property m2PFPhotonIso:
        def __get__(self):
            self.m2PFPhotonIso_branch.GetEntry(self.localentry, 0)
            return self.m2PFPhotonIso_value

    property m2PVDXY:
        def __get__(self):
            self.m2PVDXY_branch.GetEntry(self.localentry, 0)
            return self.m2PVDXY_value

    property m2PVDZ:
        def __get__(self):
            self.m2PVDZ_branch.GetEntry(self.localentry, 0)
            return self.m2PVDZ_value

    property m2Phi:
        def __get__(self):
            self.m2Phi_branch.GetEntry(self.localentry, 0)
            return self.m2Phi_value

    property m2PhiRochCor2011A:
        def __get__(self):
            self.m2PhiRochCor2011A_branch.GetEntry(self.localentry, 0)
            return self.m2PhiRochCor2011A_value

    property m2PhiRochCor2011B:
        def __get__(self):
            self.m2PhiRochCor2011B_branch.GetEntry(self.localentry, 0)
            return self.m2PhiRochCor2011B_value

    property m2PhiRochCor2012:
        def __get__(self):
            self.m2PhiRochCor2012_branch.GetEntry(self.localentry, 0)
            return self.m2PhiRochCor2012_value

    property m2PixHits:
        def __get__(self):
            self.m2PixHits_branch.GetEntry(self.localentry, 0)
            return self.m2PixHits_value

    property m2Pt:
        def __get__(self):
            self.m2Pt_branch.GetEntry(self.localentry, 0)
            return self.m2Pt_value

    property m2PtRochCor2011A:
        def __get__(self):
            self.m2PtRochCor2011A_branch.GetEntry(self.localentry, 0)
            return self.m2PtRochCor2011A_value

    property m2PtRochCor2011B:
        def __get__(self):
            self.m2PtRochCor2011B_branch.GetEntry(self.localentry, 0)
            return self.m2PtRochCor2011B_value

    property m2PtRochCor2012:
        def __get__(self):
            self.m2PtRochCor2012_branch.GetEntry(self.localentry, 0)
            return self.m2PtRochCor2012_value

    property m2Rank:
        def __get__(self):
            self.m2Rank_branch.GetEntry(self.localentry, 0)
            return self.m2Rank_value

    property m2RelPFIsoDB:
        def __get__(self):
            self.m2RelPFIsoDB_branch.GetEntry(self.localentry, 0)
            return self.m2RelPFIsoDB_value

    property m2RelPFIsoRho:
        def __get__(self):
            self.m2RelPFIsoRho_branch.GetEntry(self.localentry, 0)
            return self.m2RelPFIsoRho_value

    property m2RelPFIsoRhoFSR:
        def __get__(self):
            self.m2RelPFIsoRhoFSR_branch.GetEntry(self.localentry, 0)
            return self.m2RelPFIsoRhoFSR_value

    property m2RhoHZG2011:
        def __get__(self):
            self.m2RhoHZG2011_branch.GetEntry(self.localentry, 0)
            return self.m2RhoHZG2011_value

    property m2RhoHZG2012:
        def __get__(self):
            self.m2RhoHZG2012_branch.GetEntry(self.localentry, 0)
            return self.m2RhoHZG2012_value

    property m2SingleMu13L3Filtered13:
        def __get__(self):
            self.m2SingleMu13L3Filtered13_branch.GetEntry(self.localentry, 0)
            return self.m2SingleMu13L3Filtered13_value

    property m2SingleMu13L3Filtered17:
        def __get__(self):
            self.m2SingleMu13L3Filtered17_branch.GetEntry(self.localentry, 0)
            return self.m2SingleMu13L3Filtered17_value

    property m2TkLayersWithMeasurement:
        def __get__(self):
            self.m2TkLayersWithMeasurement_branch.GetEntry(self.localentry, 0)
            return self.m2TkLayersWithMeasurement_value

    property m2ToMETDPhi:
        def __get__(self):
            self.m2ToMETDPhi_branch.GetEntry(self.localentry, 0)
            return self.m2ToMETDPhi_value

    property m2TypeCode:
        def __get__(self):
            self.m2TypeCode_branch.GetEntry(self.localentry, 0)
            return self.m2TypeCode_value

    property m2VBTFID:
        def __get__(self):
            self.m2VBTFID_branch.GetEntry(self.localentry, 0)
            return self.m2VBTFID_value

    property m2VZ:
        def __get__(self):
            self.m2VZ_branch.GetEntry(self.localentry, 0)
            return self.m2VZ_value

    property m2WWID:
        def __get__(self):
            self.m2WWID_branch.GetEntry(self.localentry, 0)
            return self.m2WWID_value

    property m2_t1_CosThetaStar:
        def __get__(self):
            self.m2_t1_CosThetaStar_branch.GetEntry(self.localentry, 0)
            return self.m2_t1_CosThetaStar_value

    property m2_t1_DPhi:
        def __get__(self):
            self.m2_t1_DPhi_branch.GetEntry(self.localentry, 0)
            return self.m2_t1_DPhi_value

    property m2_t1_DR:
        def __get__(self):
            self.m2_t1_DR_branch.GetEntry(self.localentry, 0)
            return self.m2_t1_DR_value

    property m2_t1_Eta:
        def __get__(self):
            self.m2_t1_Eta_branch.GetEntry(self.localentry, 0)
            return self.m2_t1_Eta_value

    property m2_t1_Mass:
        def __get__(self):
            self.m2_t1_Mass_branch.GetEntry(self.localentry, 0)
            return self.m2_t1_Mass_value

    property m2_t1_MassFsr:
        def __get__(self):
            self.m2_t1_MassFsr_branch.GetEntry(self.localentry, 0)
            return self.m2_t1_MassFsr_value

    property m2_t1_PZeta:
        def __get__(self):
            self.m2_t1_PZeta_branch.GetEntry(self.localentry, 0)
            return self.m2_t1_PZeta_value

    property m2_t1_PZetaVis:
        def __get__(self):
            self.m2_t1_PZetaVis_branch.GetEntry(self.localentry, 0)
            return self.m2_t1_PZetaVis_value

    property m2_t1_Phi:
        def __get__(self):
            self.m2_t1_Phi_branch.GetEntry(self.localentry, 0)
            return self.m2_t1_Phi_value

    property m2_t1_Pt:
        def __get__(self):
            self.m2_t1_Pt_branch.GetEntry(self.localentry, 0)
            return self.m2_t1_Pt_value

    property m2_t1_PtFsr:
        def __get__(self):
            self.m2_t1_PtFsr_branch.GetEntry(self.localentry, 0)
            return self.m2_t1_PtFsr_value

    property m2_t1_SS:
        def __get__(self):
            self.m2_t1_SS_branch.GetEntry(self.localentry, 0)
            return self.m2_t1_SS_value

    property m2_t1_ToMETDPhi_Ty1:
        def __get__(self):
            self.m2_t1_ToMETDPhi_Ty1_branch.GetEntry(self.localentry, 0)
            return self.m2_t1_ToMETDPhi_Ty1_value

    property m2_t1_Zcompat:
        def __get__(self):
            self.m2_t1_Zcompat_branch.GetEntry(self.localentry, 0)
            return self.m2_t1_Zcompat_value

    property m2_t2_CosThetaStar:
        def __get__(self):
            self.m2_t2_CosThetaStar_branch.GetEntry(self.localentry, 0)
            return self.m2_t2_CosThetaStar_value

    property m2_t2_DPhi:
        def __get__(self):
            self.m2_t2_DPhi_branch.GetEntry(self.localentry, 0)
            return self.m2_t2_DPhi_value

    property m2_t2_DR:
        def __get__(self):
            self.m2_t2_DR_branch.GetEntry(self.localentry, 0)
            return self.m2_t2_DR_value

    property m2_t2_Eta:
        def __get__(self):
            self.m2_t2_Eta_branch.GetEntry(self.localentry, 0)
            return self.m2_t2_Eta_value

    property m2_t2_Mass:
        def __get__(self):
            self.m2_t2_Mass_branch.GetEntry(self.localentry, 0)
            return self.m2_t2_Mass_value

    property m2_t2_MassFsr:
        def __get__(self):
            self.m2_t2_MassFsr_branch.GetEntry(self.localentry, 0)
            return self.m2_t2_MassFsr_value

    property m2_t2_PZeta:
        def __get__(self):
            self.m2_t2_PZeta_branch.GetEntry(self.localentry, 0)
            return self.m2_t2_PZeta_value

    property m2_t2_PZetaVis:
        def __get__(self):
            self.m2_t2_PZetaVis_branch.GetEntry(self.localentry, 0)
            return self.m2_t2_PZetaVis_value

    property m2_t2_Phi:
        def __get__(self):
            self.m2_t2_Phi_branch.GetEntry(self.localentry, 0)
            return self.m2_t2_Phi_value

    property m2_t2_Pt:
        def __get__(self):
            self.m2_t2_Pt_branch.GetEntry(self.localentry, 0)
            return self.m2_t2_Pt_value

    property m2_t2_PtFsr:
        def __get__(self):
            self.m2_t2_PtFsr_branch.GetEntry(self.localentry, 0)
            return self.m2_t2_PtFsr_value

    property m2_t2_SS:
        def __get__(self):
            self.m2_t2_SS_branch.GetEntry(self.localentry, 0)
            return self.m2_t2_SS_value

    property m2_t2_ToMETDPhi_Ty1:
        def __get__(self):
            self.m2_t2_ToMETDPhi_Ty1_branch.GetEntry(self.localentry, 0)
            return self.m2_t2_ToMETDPhi_Ty1_value

    property m2_t2_Zcompat:
        def __get__(self):
            self.m2_t2_Zcompat_branch.GetEntry(self.localentry, 0)
            return self.m2_t2_Zcompat_value

    property mu17ele8Group:
        def __get__(self):
            self.mu17ele8Group_branch.GetEntry(self.localentry, 0)
            return self.mu17ele8Group_value

    property mu17ele8Pass:
        def __get__(self):
            self.mu17ele8Pass_branch.GetEntry(self.localentry, 0)
            return self.mu17ele8Pass_value

    property mu17ele8Prescale:
        def __get__(self):
            self.mu17ele8Prescale_branch.GetEntry(self.localentry, 0)
            return self.mu17ele8Prescale_value

    property mu17ele8isoGroup:
        def __get__(self):
            self.mu17ele8isoGroup_branch.GetEntry(self.localentry, 0)
            return self.mu17ele8isoGroup_value

    property mu17ele8isoPass:
        def __get__(self):
            self.mu17ele8isoPass_branch.GetEntry(self.localentry, 0)
            return self.mu17ele8isoPass_value

    property mu17ele8isoPrescale:
        def __get__(self):
            self.mu17ele8isoPrescale_branch.GetEntry(self.localentry, 0)
            return self.mu17ele8isoPrescale_value

    property mu17mu8Group:
        def __get__(self):
            self.mu17mu8Group_branch.GetEntry(self.localentry, 0)
            return self.mu17mu8Group_value

    property mu17mu8Pass:
        def __get__(self):
            self.mu17mu8Pass_branch.GetEntry(self.localentry, 0)
            return self.mu17mu8Pass_value

    property mu17mu8Prescale:
        def __get__(self):
            self.mu17mu8Prescale_branch.GetEntry(self.localentry, 0)
            return self.mu17mu8Prescale_value

    property mu8ele17Group:
        def __get__(self):
            self.mu8ele17Group_branch.GetEntry(self.localentry, 0)
            return self.mu8ele17Group_value

    property mu8ele17Pass:
        def __get__(self):
            self.mu8ele17Pass_branch.GetEntry(self.localentry, 0)
            return self.mu8ele17Pass_value

    property mu8ele17Prescale:
        def __get__(self):
            self.mu8ele17Prescale_branch.GetEntry(self.localentry, 0)
            return self.mu8ele17Prescale_value

    property mu8ele17isoGroup:
        def __get__(self):
            self.mu8ele17isoGroup_branch.GetEntry(self.localentry, 0)
            return self.mu8ele17isoGroup_value

    property mu8ele17isoPass:
        def __get__(self):
            self.mu8ele17isoPass_branch.GetEntry(self.localentry, 0)
            return self.mu8ele17isoPass_value

    property mu8ele17isoPrescale:
        def __get__(self):
            self.mu8ele17isoPrescale_branch.GetEntry(self.localentry, 0)
            return self.mu8ele17isoPrescale_value

    property muGlbIsoVetoPt10:
        def __get__(self):
            self.muGlbIsoVetoPt10_branch.GetEntry(self.localentry, 0)
            return self.muGlbIsoVetoPt10_value

    property muTauGroup:
        def __get__(self):
            self.muTauGroup_branch.GetEntry(self.localentry, 0)
            return self.muTauGroup_value

    property muTauPass:
        def __get__(self):
            self.muTauPass_branch.GetEntry(self.localentry, 0)
            return self.muTauPass_value

    property muTauPrescale:
        def __get__(self):
            self.muTauPrescale_branch.GetEntry(self.localentry, 0)
            return self.muTauPrescale_value

    property muTauTestGroup:
        def __get__(self):
            self.muTauTestGroup_branch.GetEntry(self.localentry, 0)
            return self.muTauTestGroup_value

    property muTauTestPass:
        def __get__(self):
            self.muTauTestPass_branch.GetEntry(self.localentry, 0)
            return self.muTauTestPass_value

    property muTauTestPrescale:
        def __get__(self):
            self.muTauTestPrescale_branch.GetEntry(self.localentry, 0)
            return self.muTauTestPrescale_value

    property muTightCountZH:
        def __get__(self):
            self.muTightCountZH_branch.GetEntry(self.localentry, 0)
            return self.muTightCountZH_value

    property muVetoPt15IsoIdVtx:
        def __get__(self):
            self.muVetoPt15IsoIdVtx_branch.GetEntry(self.localentry, 0)
            return self.muVetoPt15IsoIdVtx_value

    property muVetoPt5:
        def __get__(self):
            self.muVetoPt5_branch.GetEntry(self.localentry, 0)
            return self.muVetoPt5_value

    property muVetoPt5IsoIdVtx:
        def __get__(self):
            self.muVetoPt5IsoIdVtx_branch.GetEntry(self.localentry, 0)
            return self.muVetoPt5IsoIdVtx_value

    property muVetoZH:
        def __get__(self):
            self.muVetoZH_branch.GetEntry(self.localentry, 0)
            return self.muVetoZH_value

    property mva_metEt:
        def __get__(self):
            self.mva_metEt_branch.GetEntry(self.localentry, 0)
            return self.mva_metEt_value

    property mva_metPhi:
        def __get__(self):
            self.mva_metPhi_branch.GetEntry(self.localentry, 0)
            return self.mva_metPhi_value

    property nTruePU:
        def __get__(self):
            self.nTruePU_branch.GetEntry(self.localentry, 0)
            return self.nTruePU_value

    property nvtx:
        def __get__(self):
            self.nvtx_branch.GetEntry(self.localentry, 0)
            return self.nvtx_value

    property pfMetEt:
        def __get__(self):
            self.pfMetEt_branch.GetEntry(self.localentry, 0)
            return self.pfMetEt_value

    property pfMetPhi:
        def __get__(self):
            self.pfMetPhi_branch.GetEntry(self.localentry, 0)
            return self.pfMetPhi_value

    property pfMet_jes_Et:
        def __get__(self):
            self.pfMet_jes_Et_branch.GetEntry(self.localentry, 0)
            return self.pfMet_jes_Et_value

    property pfMet_jes_Phi:
        def __get__(self):
            self.pfMet_jes_Phi_branch.GetEntry(self.localentry, 0)
            return self.pfMet_jes_Phi_value

    property pfMet_mes_Et:
        def __get__(self):
            self.pfMet_mes_Et_branch.GetEntry(self.localentry, 0)
            return self.pfMet_mes_Et_value

    property pfMet_mes_Phi:
        def __get__(self):
            self.pfMet_mes_Phi_branch.GetEntry(self.localentry, 0)
            return self.pfMet_mes_Phi_value

    property pfMet_tes_Et:
        def __get__(self):
            self.pfMet_tes_Et_branch.GetEntry(self.localentry, 0)
            return self.pfMet_tes_Et_value

    property pfMet_tes_Phi:
        def __get__(self):
            self.pfMet_tes_Phi_branch.GetEntry(self.localentry, 0)
            return self.pfMet_tes_Phi_value

    property pfMet_ues_Et:
        def __get__(self):
            self.pfMet_ues_Et_branch.GetEntry(self.localentry, 0)
            return self.pfMet_ues_Et_value

    property pfMet_ues_Phi:
        def __get__(self):
            self.pfMet_ues_Phi_branch.GetEntry(self.localentry, 0)
            return self.pfMet_ues_Phi_value

    property processID:
        def __get__(self):
            self.processID_branch.GetEntry(self.localentry, 0)
            return self.processID_value

    property pvChi2:
        def __get__(self):
            self.pvChi2_branch.GetEntry(self.localentry, 0)
            return self.pvChi2_value

    property pvDX:
        def __get__(self):
            self.pvDX_branch.GetEntry(self.localentry, 0)
            return self.pvDX_value

    property pvDY:
        def __get__(self):
            self.pvDY_branch.GetEntry(self.localentry, 0)
            return self.pvDY_value

    property pvDZ:
        def __get__(self):
            self.pvDZ_branch.GetEntry(self.localentry, 0)
            return self.pvDZ_value

    property pvIsFake:
        def __get__(self):
            self.pvIsFake_branch.GetEntry(self.localentry, 0)
            return self.pvIsFake_value

    property pvIsValid:
        def __get__(self):
            self.pvIsValid_branch.GetEntry(self.localentry, 0)
            return self.pvIsValid_value

    property pvNormChi2:
        def __get__(self):
            self.pvNormChi2_branch.GetEntry(self.localentry, 0)
            return self.pvNormChi2_value

    property pvX:
        def __get__(self):
            self.pvX_branch.GetEntry(self.localentry, 0)
            return self.pvX_value

    property pvY:
        def __get__(self):
            self.pvY_branch.GetEntry(self.localentry, 0)
            return self.pvY_value

    property pvZ:
        def __get__(self):
            self.pvZ_branch.GetEntry(self.localentry, 0)
            return self.pvZ_value

    property pvndof:
        def __get__(self):
            self.pvndof_branch.GetEntry(self.localentry, 0)
            return self.pvndof_value

    property recoilDaught:
        def __get__(self):
            self.recoilDaught_branch.GetEntry(self.localentry, 0)
            return self.recoilDaught_value

    property recoilWithMet:
        def __get__(self):
            self.recoilWithMet_branch.GetEntry(self.localentry, 0)
            return self.recoilWithMet_value

    property rho:
        def __get__(self):
            self.rho_branch.GetEntry(self.localentry, 0)
            return self.rho_value

    property run:
        def __get__(self):
            self.run_branch.GetEntry(self.localentry, 0)
            return self.run_value

    property singleEGroup:
        def __get__(self):
            self.singleEGroup_branch.GetEntry(self.localentry, 0)
            return self.singleEGroup_value

    property singleEPFMTGroup:
        def __get__(self):
            self.singleEPFMTGroup_branch.GetEntry(self.localentry, 0)
            return self.singleEPFMTGroup_value

    property singleEPFMTPass:
        def __get__(self):
            self.singleEPFMTPass_branch.GetEntry(self.localentry, 0)
            return self.singleEPFMTPass_value

    property singleEPFMTPrescale:
        def __get__(self):
            self.singleEPFMTPrescale_branch.GetEntry(self.localentry, 0)
            return self.singleEPFMTPrescale_value

    property singleEPass:
        def __get__(self):
            self.singleEPass_branch.GetEntry(self.localentry, 0)
            return self.singleEPass_value

    property singleEPrescale:
        def __get__(self):
            self.singleEPrescale_branch.GetEntry(self.localentry, 0)
            return self.singleEPrescale_value

    property singleMuGroup:
        def __get__(self):
            self.singleMuGroup_branch.GetEntry(self.localentry, 0)
            return self.singleMuGroup_value

    property singleMuPass:
        def __get__(self):
            self.singleMuPass_branch.GetEntry(self.localentry, 0)
            return self.singleMuPass_value

    property singleMuPrescale:
        def __get__(self):
            self.singleMuPrescale_branch.GetEntry(self.localentry, 0)
            return self.singleMuPrescale_value

    property singlePhoGroup:
        def __get__(self):
            self.singlePhoGroup_branch.GetEntry(self.localentry, 0)
            return self.singlePhoGroup_value

    property singlePhoPass:
        def __get__(self):
            self.singlePhoPass_branch.GetEntry(self.localentry, 0)
            return self.singlePhoPass_value

    property singlePhoPrescale:
        def __get__(self):
            self.singlePhoPrescale_branch.GetEntry(self.localentry, 0)
            return self.singlePhoPrescale_value

    property t1AbsEta:
        def __get__(self):
            self.t1AbsEta_branch.GetEntry(self.localentry, 0)
            return self.t1AbsEta_value

    property t1AntiElectronLoose:
        def __get__(self):
            self.t1AntiElectronLoose_branch.GetEntry(self.localentry, 0)
            return self.t1AntiElectronLoose_value

    property t1AntiElectronMVA3Loose:
        def __get__(self):
            self.t1AntiElectronMVA3Loose_branch.GetEntry(self.localentry, 0)
            return self.t1AntiElectronMVA3Loose_value

    property t1AntiElectronMVA3Medium:
        def __get__(self):
            self.t1AntiElectronMVA3Medium_branch.GetEntry(self.localentry, 0)
            return self.t1AntiElectronMVA3Medium_value

    property t1AntiElectronMVA3Raw:
        def __get__(self):
            self.t1AntiElectronMVA3Raw_branch.GetEntry(self.localentry, 0)
            return self.t1AntiElectronMVA3Raw_value

    property t1AntiElectronMVA3Tight:
        def __get__(self):
            self.t1AntiElectronMVA3Tight_branch.GetEntry(self.localentry, 0)
            return self.t1AntiElectronMVA3Tight_value

    property t1AntiElectronMVA3VTight:
        def __get__(self):
            self.t1AntiElectronMVA3VTight_branch.GetEntry(self.localentry, 0)
            return self.t1AntiElectronMVA3VTight_value

    property t1AntiElectronMedium:
        def __get__(self):
            self.t1AntiElectronMedium_branch.GetEntry(self.localentry, 0)
            return self.t1AntiElectronMedium_value

    property t1AntiElectronTight:
        def __get__(self):
            self.t1AntiElectronTight_branch.GetEntry(self.localentry, 0)
            return self.t1AntiElectronTight_value

    property t1AntiMuonLoose:
        def __get__(self):
            self.t1AntiMuonLoose_branch.GetEntry(self.localentry, 0)
            return self.t1AntiMuonLoose_value

    property t1AntiMuonLoose2:
        def __get__(self):
            self.t1AntiMuonLoose2_branch.GetEntry(self.localentry, 0)
            return self.t1AntiMuonLoose2_value

    property t1AntiMuonMedium:
        def __get__(self):
            self.t1AntiMuonMedium_branch.GetEntry(self.localentry, 0)
            return self.t1AntiMuonMedium_value

    property t1AntiMuonMedium2:
        def __get__(self):
            self.t1AntiMuonMedium2_branch.GetEntry(self.localentry, 0)
            return self.t1AntiMuonMedium2_value

    property t1AntiMuonTight:
        def __get__(self):
            self.t1AntiMuonTight_branch.GetEntry(self.localentry, 0)
            return self.t1AntiMuonTight_value

    property t1AntiMuonTight2:
        def __get__(self):
            self.t1AntiMuonTight2_branch.GetEntry(self.localentry, 0)
            return self.t1AntiMuonTight2_value

    property t1Charge:
        def __get__(self):
            self.t1Charge_branch.GetEntry(self.localentry, 0)
            return self.t1Charge_value

    property t1CiCTightElecOverlap:
        def __get__(self):
            self.t1CiCTightElecOverlap_branch.GetEntry(self.localentry, 0)
            return self.t1CiCTightElecOverlap_value

    property t1DZ:
        def __get__(self):
            self.t1DZ_branch.GetEntry(self.localentry, 0)
            return self.t1DZ_value

    property t1DecayFinding:
        def __get__(self):
            self.t1DecayFinding_branch.GetEntry(self.localentry, 0)
            return self.t1DecayFinding_value

    property t1DecayMode:
        def __get__(self):
            self.t1DecayMode_branch.GetEntry(self.localentry, 0)
            return self.t1DecayMode_value

    property t1ElecOverlap:
        def __get__(self):
            self.t1ElecOverlap_branch.GetEntry(self.localentry, 0)
            return self.t1ElecOverlap_value

    property t1ElecOverlapZHLoose:
        def __get__(self):
            self.t1ElecOverlapZHLoose_branch.GetEntry(self.localentry, 0)
            return self.t1ElecOverlapZHLoose_value

    property t1ElecOverlapZHTight:
        def __get__(self):
            self.t1ElecOverlapZHTight_branch.GetEntry(self.localentry, 0)
            return self.t1ElecOverlapZHTight_value

    property t1Eta:
        def __get__(self):
            self.t1Eta_branch.GetEntry(self.localentry, 0)
            return self.t1Eta_value

    property t1GenDecayMode:
        def __get__(self):
            self.t1GenDecayMode_branch.GetEntry(self.localentry, 0)
            return self.t1GenDecayMode_value

    property t1IP3DS:
        def __get__(self):
            self.t1IP3DS_branch.GetEntry(self.localentry, 0)
            return self.t1IP3DS_value

    property t1JetArea:
        def __get__(self):
            self.t1JetArea_branch.GetEntry(self.localentry, 0)
            return self.t1JetArea_value

    property t1JetBtag:
        def __get__(self):
            self.t1JetBtag_branch.GetEntry(self.localentry, 0)
            return self.t1JetBtag_value

    property t1JetCSVBtag:
        def __get__(self):
            self.t1JetCSVBtag_branch.GetEntry(self.localentry, 0)
            return self.t1JetCSVBtag_value

    property t1JetEtaEtaMoment:
        def __get__(self):
            self.t1JetEtaEtaMoment_branch.GetEntry(self.localentry, 0)
            return self.t1JetEtaEtaMoment_value

    property t1JetEtaPhiMoment:
        def __get__(self):
            self.t1JetEtaPhiMoment_branch.GetEntry(self.localentry, 0)
            return self.t1JetEtaPhiMoment_value

    property t1JetEtaPhiSpread:
        def __get__(self):
            self.t1JetEtaPhiSpread_branch.GetEntry(self.localentry, 0)
            return self.t1JetEtaPhiSpread_value

    property t1JetPartonFlavour:
        def __get__(self):
            self.t1JetPartonFlavour_branch.GetEntry(self.localentry, 0)
            return self.t1JetPartonFlavour_value

    property t1JetPhiPhiMoment:
        def __get__(self):
            self.t1JetPhiPhiMoment_branch.GetEntry(self.localentry, 0)
            return self.t1JetPhiPhiMoment_value

    property t1JetPt:
        def __get__(self):
            self.t1JetPt_branch.GetEntry(self.localentry, 0)
            return self.t1JetPt_value

    property t1JetQGLikelihoodID:
        def __get__(self):
            self.t1JetQGLikelihoodID_branch.GetEntry(self.localentry, 0)
            return self.t1JetQGLikelihoodID_value

    property t1JetQGMVAID:
        def __get__(self):
            self.t1JetQGMVAID_branch.GetEntry(self.localentry, 0)
            return self.t1JetQGMVAID_value

    property t1Jetaxis1:
        def __get__(self):
            self.t1Jetaxis1_branch.GetEntry(self.localentry, 0)
            return self.t1Jetaxis1_value

    property t1Jetaxis2:
        def __get__(self):
            self.t1Jetaxis2_branch.GetEntry(self.localentry, 0)
            return self.t1Jetaxis2_value

    property t1Jetmult:
        def __get__(self):
            self.t1Jetmult_branch.GetEntry(self.localentry, 0)
            return self.t1Jetmult_value

    property t1JetmultMLP:
        def __get__(self):
            self.t1JetmultMLP_branch.GetEntry(self.localentry, 0)
            return self.t1JetmultMLP_value

    property t1JetmultMLPQC:
        def __get__(self):
            self.t1JetmultMLPQC_branch.GetEntry(self.localentry, 0)
            return self.t1JetmultMLPQC_value

    property t1JetptD:
        def __get__(self):
            self.t1JetptD_branch.GetEntry(self.localentry, 0)
            return self.t1JetptD_value

    property t1LeadTrackPt:
        def __get__(self):
            self.t1LeadTrackPt_branch.GetEntry(self.localentry, 0)
            return self.t1LeadTrackPt_value

    property t1LooseIso:
        def __get__(self):
            self.t1LooseIso_branch.GetEntry(self.localentry, 0)
            return self.t1LooseIso_value

    property t1LooseIso3Hits:
        def __get__(self):
            self.t1LooseIso3Hits_branch.GetEntry(self.localentry, 0)
            return self.t1LooseIso3Hits_value

    property t1LooseMVA2Iso:
        def __get__(self):
            self.t1LooseMVA2Iso_branch.GetEntry(self.localentry, 0)
            return self.t1LooseMVA2Iso_value

    property t1LooseMVAIso:
        def __get__(self):
            self.t1LooseMVAIso_branch.GetEntry(self.localentry, 0)
            return self.t1LooseMVAIso_value

    property t1MVA2IsoRaw:
        def __get__(self):
            self.t1MVA2IsoRaw_branch.GetEntry(self.localentry, 0)
            return self.t1MVA2IsoRaw_value

    property t1Mass:
        def __get__(self):
            self.t1Mass_branch.GetEntry(self.localentry, 0)
            return self.t1Mass_value

    property t1MediumIso:
        def __get__(self):
            self.t1MediumIso_branch.GetEntry(self.localentry, 0)
            return self.t1MediumIso_value

    property t1MediumIso3Hits:
        def __get__(self):
            self.t1MediumIso3Hits_branch.GetEntry(self.localentry, 0)
            return self.t1MediumIso3Hits_value

    property t1MediumMVA2Iso:
        def __get__(self):
            self.t1MediumMVA2Iso_branch.GetEntry(self.localentry, 0)
            return self.t1MediumMVA2Iso_value

    property t1MediumMVAIso:
        def __get__(self):
            self.t1MediumMVAIso_branch.GetEntry(self.localentry, 0)
            return self.t1MediumMVAIso_value

    property t1MtToMET:
        def __get__(self):
            self.t1MtToMET_branch.GetEntry(self.localentry, 0)
            return self.t1MtToMET_value

    property t1MtToMVAMET:
        def __get__(self):
            self.t1MtToMVAMET_branch.GetEntry(self.localentry, 0)
            return self.t1MtToMVAMET_value

    property t1MtToPFMET:
        def __get__(self):
            self.t1MtToPFMET_branch.GetEntry(self.localentry, 0)
            return self.t1MtToPFMET_value

    property t1MtToPfMet_Ty1:
        def __get__(self):
            self.t1MtToPfMet_Ty1_branch.GetEntry(self.localentry, 0)
            return self.t1MtToPfMet_Ty1_value

    property t1MtToPfMet_jes:
        def __get__(self):
            self.t1MtToPfMet_jes_branch.GetEntry(self.localentry, 0)
            return self.t1MtToPfMet_jes_value

    property t1MtToPfMet_mes:
        def __get__(self):
            self.t1MtToPfMet_mes_branch.GetEntry(self.localentry, 0)
            return self.t1MtToPfMet_mes_value

    property t1MtToPfMet_tes:
        def __get__(self):
            self.t1MtToPfMet_tes_branch.GetEntry(self.localentry, 0)
            return self.t1MtToPfMet_tes_value

    property t1MtToPfMet_ues:
        def __get__(self):
            self.t1MtToPfMet_ues_branch.GetEntry(self.localentry, 0)
            return self.t1MtToPfMet_ues_value

    property t1MuOverlap:
        def __get__(self):
            self.t1MuOverlap_branch.GetEntry(self.localentry, 0)
            return self.t1MuOverlap_value

    property t1MuOverlapZHLoose:
        def __get__(self):
            self.t1MuOverlapZHLoose_branch.GetEntry(self.localentry, 0)
            return self.t1MuOverlapZHLoose_value

    property t1MuOverlapZHTight:
        def __get__(self):
            self.t1MuOverlapZHTight_branch.GetEntry(self.localentry, 0)
            return self.t1MuOverlapZHTight_value

    property t1Phi:
        def __get__(self):
            self.t1Phi_branch.GetEntry(self.localentry, 0)
            return self.t1Phi_value

    property t1Pt:
        def __get__(self):
            self.t1Pt_branch.GetEntry(self.localentry, 0)
            return self.t1Pt_value

    property t1Rank:
        def __get__(self):
            self.t1Rank_branch.GetEntry(self.localentry, 0)
            return self.t1Rank_value

    property t1TNPId:
        def __get__(self):
            self.t1TNPId_branch.GetEntry(self.localentry, 0)
            return self.t1TNPId_value

    property t1TightIso:
        def __get__(self):
            self.t1TightIso_branch.GetEntry(self.localentry, 0)
            return self.t1TightIso_value

    property t1TightIso3Hits:
        def __get__(self):
            self.t1TightIso3Hits_branch.GetEntry(self.localentry, 0)
            return self.t1TightIso3Hits_value

    property t1TightMVA2Iso:
        def __get__(self):
            self.t1TightMVA2Iso_branch.GetEntry(self.localentry, 0)
            return self.t1TightMVA2Iso_value

    property t1TightMVAIso:
        def __get__(self):
            self.t1TightMVAIso_branch.GetEntry(self.localentry, 0)
            return self.t1TightMVAIso_value

    property t1ToMETDPhi:
        def __get__(self):
            self.t1ToMETDPhi_branch.GetEntry(self.localentry, 0)
            return self.t1ToMETDPhi_value

    property t1VLooseIso:
        def __get__(self):
            self.t1VLooseIso_branch.GetEntry(self.localentry, 0)
            return self.t1VLooseIso_value

    property t1VZ:
        def __get__(self):
            self.t1VZ_branch.GetEntry(self.localentry, 0)
            return self.t1VZ_value

    property t1_t2_CosThetaStar:
        def __get__(self):
            self.t1_t2_CosThetaStar_branch.GetEntry(self.localentry, 0)
            return self.t1_t2_CosThetaStar_value

    property t1_t2_DPhi:
        def __get__(self):
            self.t1_t2_DPhi_branch.GetEntry(self.localentry, 0)
            return self.t1_t2_DPhi_value

    property t1_t2_DR:
        def __get__(self):
            self.t1_t2_DR_branch.GetEntry(self.localentry, 0)
            return self.t1_t2_DR_value

    property t1_t2_Eta:
        def __get__(self):
            self.t1_t2_Eta_branch.GetEntry(self.localentry, 0)
            return self.t1_t2_Eta_value

    property t1_t2_Mass:
        def __get__(self):
            self.t1_t2_Mass_branch.GetEntry(self.localentry, 0)
            return self.t1_t2_Mass_value

    property t1_t2_MassFsr:
        def __get__(self):
            self.t1_t2_MassFsr_branch.GetEntry(self.localentry, 0)
            return self.t1_t2_MassFsr_value

    property t1_t2_PZeta:
        def __get__(self):
            self.t1_t2_PZeta_branch.GetEntry(self.localentry, 0)
            return self.t1_t2_PZeta_value

    property t1_t2_PZetaVis:
        def __get__(self):
            self.t1_t2_PZetaVis_branch.GetEntry(self.localentry, 0)
            return self.t1_t2_PZetaVis_value

    property t1_t2_Phi:
        def __get__(self):
            self.t1_t2_Phi_branch.GetEntry(self.localentry, 0)
            return self.t1_t2_Phi_value

    property t1_t2_Pt:
        def __get__(self):
            self.t1_t2_Pt_branch.GetEntry(self.localentry, 0)
            return self.t1_t2_Pt_value

    property t1_t2_PtFsr:
        def __get__(self):
            self.t1_t2_PtFsr_branch.GetEntry(self.localentry, 0)
            return self.t1_t2_PtFsr_value

    property t1_t2_SS:
        def __get__(self):
            self.t1_t2_SS_branch.GetEntry(self.localentry, 0)
            return self.t1_t2_SS_value

    property t1_t2_SVfitEta:
        def __get__(self):
            self.t1_t2_SVfitEta_branch.GetEntry(self.localentry, 0)
            return self.t1_t2_SVfitEta_value

    property t1_t2_SVfitMass:
        def __get__(self):
            self.t1_t2_SVfitMass_branch.GetEntry(self.localentry, 0)
            return self.t1_t2_SVfitMass_value

    property t1_t2_SVfitPhi:
        def __get__(self):
            self.t1_t2_SVfitPhi_branch.GetEntry(self.localentry, 0)
            return self.t1_t2_SVfitPhi_value

    property t1_t2_SVfitPt:
        def __get__(self):
            self.t1_t2_SVfitPt_branch.GetEntry(self.localentry, 0)
            return self.t1_t2_SVfitPt_value

    property t1_t2_ToMETDPhi_Ty1:
        def __get__(self):
            self.t1_t2_ToMETDPhi_Ty1_branch.GetEntry(self.localentry, 0)
            return self.t1_t2_ToMETDPhi_Ty1_value

    property t1_t2_Zcompat:
        def __get__(self):
            self.t1_t2_Zcompat_branch.GetEntry(self.localentry, 0)
            return self.t1_t2_Zcompat_value

    property t2AbsEta:
        def __get__(self):
            self.t2AbsEta_branch.GetEntry(self.localentry, 0)
            return self.t2AbsEta_value

    property t2AntiElectronLoose:
        def __get__(self):
            self.t2AntiElectronLoose_branch.GetEntry(self.localentry, 0)
            return self.t2AntiElectronLoose_value

    property t2AntiElectronMVA3Loose:
        def __get__(self):
            self.t2AntiElectronMVA3Loose_branch.GetEntry(self.localentry, 0)
            return self.t2AntiElectronMVA3Loose_value

    property t2AntiElectronMVA3Medium:
        def __get__(self):
            self.t2AntiElectronMVA3Medium_branch.GetEntry(self.localentry, 0)
            return self.t2AntiElectronMVA3Medium_value

    property t2AntiElectronMVA3Raw:
        def __get__(self):
            self.t2AntiElectronMVA3Raw_branch.GetEntry(self.localentry, 0)
            return self.t2AntiElectronMVA3Raw_value

    property t2AntiElectronMVA3Tight:
        def __get__(self):
            self.t2AntiElectronMVA3Tight_branch.GetEntry(self.localentry, 0)
            return self.t2AntiElectronMVA3Tight_value

    property t2AntiElectronMVA3VTight:
        def __get__(self):
            self.t2AntiElectronMVA3VTight_branch.GetEntry(self.localentry, 0)
            return self.t2AntiElectronMVA3VTight_value

    property t2AntiElectronMedium:
        def __get__(self):
            self.t2AntiElectronMedium_branch.GetEntry(self.localentry, 0)
            return self.t2AntiElectronMedium_value

    property t2AntiElectronTight:
        def __get__(self):
            self.t2AntiElectronTight_branch.GetEntry(self.localentry, 0)
            return self.t2AntiElectronTight_value

    property t2AntiMuonLoose:
        def __get__(self):
            self.t2AntiMuonLoose_branch.GetEntry(self.localentry, 0)
            return self.t2AntiMuonLoose_value

    property t2AntiMuonLoose2:
        def __get__(self):
            self.t2AntiMuonLoose2_branch.GetEntry(self.localentry, 0)
            return self.t2AntiMuonLoose2_value

    property t2AntiMuonMedium:
        def __get__(self):
            self.t2AntiMuonMedium_branch.GetEntry(self.localentry, 0)
            return self.t2AntiMuonMedium_value

    property t2AntiMuonMedium2:
        def __get__(self):
            self.t2AntiMuonMedium2_branch.GetEntry(self.localentry, 0)
            return self.t2AntiMuonMedium2_value

    property t2AntiMuonTight:
        def __get__(self):
            self.t2AntiMuonTight_branch.GetEntry(self.localentry, 0)
            return self.t2AntiMuonTight_value

    property t2AntiMuonTight2:
        def __get__(self):
            self.t2AntiMuonTight2_branch.GetEntry(self.localentry, 0)
            return self.t2AntiMuonTight2_value

    property t2Charge:
        def __get__(self):
            self.t2Charge_branch.GetEntry(self.localentry, 0)
            return self.t2Charge_value

    property t2CiCTightElecOverlap:
        def __get__(self):
            self.t2CiCTightElecOverlap_branch.GetEntry(self.localentry, 0)
            return self.t2CiCTightElecOverlap_value

    property t2DZ:
        def __get__(self):
            self.t2DZ_branch.GetEntry(self.localentry, 0)
            return self.t2DZ_value

    property t2DecayFinding:
        def __get__(self):
            self.t2DecayFinding_branch.GetEntry(self.localentry, 0)
            return self.t2DecayFinding_value

    property t2DecayMode:
        def __get__(self):
            self.t2DecayMode_branch.GetEntry(self.localentry, 0)
            return self.t2DecayMode_value

    property t2ElecOverlap:
        def __get__(self):
            self.t2ElecOverlap_branch.GetEntry(self.localentry, 0)
            return self.t2ElecOverlap_value

    property t2ElecOverlapZHLoose:
        def __get__(self):
            self.t2ElecOverlapZHLoose_branch.GetEntry(self.localentry, 0)
            return self.t2ElecOverlapZHLoose_value

    property t2ElecOverlapZHTight:
        def __get__(self):
            self.t2ElecOverlapZHTight_branch.GetEntry(self.localentry, 0)
            return self.t2ElecOverlapZHTight_value

    property t2Eta:
        def __get__(self):
            self.t2Eta_branch.GetEntry(self.localentry, 0)
            return self.t2Eta_value

    property t2GenDecayMode:
        def __get__(self):
            self.t2GenDecayMode_branch.GetEntry(self.localentry, 0)
            return self.t2GenDecayMode_value

    property t2IP3DS:
        def __get__(self):
            self.t2IP3DS_branch.GetEntry(self.localentry, 0)
            return self.t2IP3DS_value

    property t2JetArea:
        def __get__(self):
            self.t2JetArea_branch.GetEntry(self.localentry, 0)
            return self.t2JetArea_value

    property t2JetBtag:
        def __get__(self):
            self.t2JetBtag_branch.GetEntry(self.localentry, 0)
            return self.t2JetBtag_value

    property t2JetCSVBtag:
        def __get__(self):
            self.t2JetCSVBtag_branch.GetEntry(self.localentry, 0)
            return self.t2JetCSVBtag_value

    property t2JetEtaEtaMoment:
        def __get__(self):
            self.t2JetEtaEtaMoment_branch.GetEntry(self.localentry, 0)
            return self.t2JetEtaEtaMoment_value

    property t2JetEtaPhiMoment:
        def __get__(self):
            self.t2JetEtaPhiMoment_branch.GetEntry(self.localentry, 0)
            return self.t2JetEtaPhiMoment_value

    property t2JetEtaPhiSpread:
        def __get__(self):
            self.t2JetEtaPhiSpread_branch.GetEntry(self.localentry, 0)
            return self.t2JetEtaPhiSpread_value

    property t2JetPartonFlavour:
        def __get__(self):
            self.t2JetPartonFlavour_branch.GetEntry(self.localentry, 0)
            return self.t2JetPartonFlavour_value

    property t2JetPhiPhiMoment:
        def __get__(self):
            self.t2JetPhiPhiMoment_branch.GetEntry(self.localentry, 0)
            return self.t2JetPhiPhiMoment_value

    property t2JetPt:
        def __get__(self):
            self.t2JetPt_branch.GetEntry(self.localentry, 0)
            return self.t2JetPt_value

    property t2JetQGLikelihoodID:
        def __get__(self):
            self.t2JetQGLikelihoodID_branch.GetEntry(self.localentry, 0)
            return self.t2JetQGLikelihoodID_value

    property t2JetQGMVAID:
        def __get__(self):
            self.t2JetQGMVAID_branch.GetEntry(self.localentry, 0)
            return self.t2JetQGMVAID_value

    property t2Jetaxis1:
        def __get__(self):
            self.t2Jetaxis1_branch.GetEntry(self.localentry, 0)
            return self.t2Jetaxis1_value

    property t2Jetaxis2:
        def __get__(self):
            self.t2Jetaxis2_branch.GetEntry(self.localentry, 0)
            return self.t2Jetaxis2_value

    property t2Jetmult:
        def __get__(self):
            self.t2Jetmult_branch.GetEntry(self.localentry, 0)
            return self.t2Jetmult_value

    property t2JetmultMLP:
        def __get__(self):
            self.t2JetmultMLP_branch.GetEntry(self.localentry, 0)
            return self.t2JetmultMLP_value

    property t2JetmultMLPQC:
        def __get__(self):
            self.t2JetmultMLPQC_branch.GetEntry(self.localentry, 0)
            return self.t2JetmultMLPQC_value

    property t2JetptD:
        def __get__(self):
            self.t2JetptD_branch.GetEntry(self.localentry, 0)
            return self.t2JetptD_value

    property t2LeadTrackPt:
        def __get__(self):
            self.t2LeadTrackPt_branch.GetEntry(self.localentry, 0)
            return self.t2LeadTrackPt_value

    property t2LooseIso:
        def __get__(self):
            self.t2LooseIso_branch.GetEntry(self.localentry, 0)
            return self.t2LooseIso_value

    property t2LooseIso3Hits:
        def __get__(self):
            self.t2LooseIso3Hits_branch.GetEntry(self.localentry, 0)
            return self.t2LooseIso3Hits_value

    property t2LooseMVA2Iso:
        def __get__(self):
            self.t2LooseMVA2Iso_branch.GetEntry(self.localentry, 0)
            return self.t2LooseMVA2Iso_value

    property t2LooseMVAIso:
        def __get__(self):
            self.t2LooseMVAIso_branch.GetEntry(self.localentry, 0)
            return self.t2LooseMVAIso_value

    property t2MVA2IsoRaw:
        def __get__(self):
            self.t2MVA2IsoRaw_branch.GetEntry(self.localentry, 0)
            return self.t2MVA2IsoRaw_value

    property t2Mass:
        def __get__(self):
            self.t2Mass_branch.GetEntry(self.localentry, 0)
            return self.t2Mass_value

    property t2MediumIso:
        def __get__(self):
            self.t2MediumIso_branch.GetEntry(self.localentry, 0)
            return self.t2MediumIso_value

    property t2MediumIso3Hits:
        def __get__(self):
            self.t2MediumIso3Hits_branch.GetEntry(self.localentry, 0)
            return self.t2MediumIso3Hits_value

    property t2MediumMVA2Iso:
        def __get__(self):
            self.t2MediumMVA2Iso_branch.GetEntry(self.localentry, 0)
            return self.t2MediumMVA2Iso_value

    property t2MediumMVAIso:
        def __get__(self):
            self.t2MediumMVAIso_branch.GetEntry(self.localentry, 0)
            return self.t2MediumMVAIso_value

    property t2MtToMET:
        def __get__(self):
            self.t2MtToMET_branch.GetEntry(self.localentry, 0)
            return self.t2MtToMET_value

    property t2MtToMVAMET:
        def __get__(self):
            self.t2MtToMVAMET_branch.GetEntry(self.localentry, 0)
            return self.t2MtToMVAMET_value

    property t2MtToPFMET:
        def __get__(self):
            self.t2MtToPFMET_branch.GetEntry(self.localentry, 0)
            return self.t2MtToPFMET_value

    property t2MtToPfMet_Ty1:
        def __get__(self):
            self.t2MtToPfMet_Ty1_branch.GetEntry(self.localentry, 0)
            return self.t2MtToPfMet_Ty1_value

    property t2MtToPfMet_jes:
        def __get__(self):
            self.t2MtToPfMet_jes_branch.GetEntry(self.localentry, 0)
            return self.t2MtToPfMet_jes_value

    property t2MtToPfMet_mes:
        def __get__(self):
            self.t2MtToPfMet_mes_branch.GetEntry(self.localentry, 0)
            return self.t2MtToPfMet_mes_value

    property t2MtToPfMet_tes:
        def __get__(self):
            self.t2MtToPfMet_tes_branch.GetEntry(self.localentry, 0)
            return self.t2MtToPfMet_tes_value

    property t2MtToPfMet_ues:
        def __get__(self):
            self.t2MtToPfMet_ues_branch.GetEntry(self.localentry, 0)
            return self.t2MtToPfMet_ues_value

    property t2MuOverlap:
        def __get__(self):
            self.t2MuOverlap_branch.GetEntry(self.localentry, 0)
            return self.t2MuOverlap_value

    property t2MuOverlapZHLoose:
        def __get__(self):
            self.t2MuOverlapZHLoose_branch.GetEntry(self.localentry, 0)
            return self.t2MuOverlapZHLoose_value

    property t2MuOverlapZHTight:
        def __get__(self):
            self.t2MuOverlapZHTight_branch.GetEntry(self.localentry, 0)
            return self.t2MuOverlapZHTight_value

    property t2Phi:
        def __get__(self):
            self.t2Phi_branch.GetEntry(self.localentry, 0)
            return self.t2Phi_value

    property t2Pt:
        def __get__(self):
            self.t2Pt_branch.GetEntry(self.localentry, 0)
            return self.t2Pt_value

    property t2Rank:
        def __get__(self):
            self.t2Rank_branch.GetEntry(self.localentry, 0)
            return self.t2Rank_value

    property t2TNPId:
        def __get__(self):
            self.t2TNPId_branch.GetEntry(self.localentry, 0)
            return self.t2TNPId_value

    property t2TightIso:
        def __get__(self):
            self.t2TightIso_branch.GetEntry(self.localentry, 0)
            return self.t2TightIso_value

    property t2TightIso3Hits:
        def __get__(self):
            self.t2TightIso3Hits_branch.GetEntry(self.localentry, 0)
            return self.t2TightIso3Hits_value

    property t2TightMVA2Iso:
        def __get__(self):
            self.t2TightMVA2Iso_branch.GetEntry(self.localentry, 0)
            return self.t2TightMVA2Iso_value

    property t2TightMVAIso:
        def __get__(self):
            self.t2TightMVAIso_branch.GetEntry(self.localentry, 0)
            return self.t2TightMVAIso_value

    property t2ToMETDPhi:
        def __get__(self):
            self.t2ToMETDPhi_branch.GetEntry(self.localentry, 0)
            return self.t2ToMETDPhi_value

    property t2VLooseIso:
        def __get__(self):
            self.t2VLooseIso_branch.GetEntry(self.localentry, 0)
            return self.t2VLooseIso_value

    property t2VZ:
        def __get__(self):
            self.t2VZ_branch.GetEntry(self.localentry, 0)
            return self.t2VZ_value

    property tauHpsVetoPt20:
        def __get__(self):
            self.tauHpsVetoPt20_branch.GetEntry(self.localentry, 0)
            return self.tauHpsVetoPt20_value

    property tauTightCountZH:
        def __get__(self):
            self.tauTightCountZH_branch.GetEntry(self.localentry, 0)
            return self.tauTightCountZH_value

    property tauVetoPt20:
        def __get__(self):
            self.tauVetoPt20_branch.GetEntry(self.localentry, 0)
            return self.tauVetoPt20_value

    property tauVetoPt20Loose3HitsVtx:
        def __get__(self):
            self.tauVetoPt20Loose3HitsVtx_branch.GetEntry(self.localentry, 0)
            return self.tauVetoPt20Loose3HitsVtx_value

    property tauVetoPt20LooseMVA2Vtx:
        def __get__(self):
            self.tauVetoPt20LooseMVA2Vtx_branch.GetEntry(self.localentry, 0)
            return self.tauVetoPt20LooseMVA2Vtx_value

    property tauVetoPt20LooseMVAVtx:
        def __get__(self):
            self.tauVetoPt20LooseMVAVtx_branch.GetEntry(self.localentry, 0)
            return self.tauVetoPt20LooseMVAVtx_value

    property tauVetoPt20VLooseHPSVtx:
        def __get__(self):
            self.tauVetoPt20VLooseHPSVtx_branch.GetEntry(self.localentry, 0)
            return self.tauVetoPt20VLooseHPSVtx_value

    property tauVetoZH:
        def __get__(self):
            self.tauVetoZH_branch.GetEntry(self.localentry, 0)
            return self.tauVetoZH_value

    property type1_pfMetEt:
        def __get__(self):
            self.type1_pfMetEt_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMetEt_value

    property type1_pfMetPhi:
        def __get__(self):
            self.type1_pfMetPhi_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMetPhi_value

    property idx:
        def __get__(self):
            self.idx_branch.GetEntry(self.localentry, 0)
            return self.idx_value


