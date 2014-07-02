

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

cdef class MuMuMuTauTree:
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

    cdef TBranch* m1_m3_CosThetaStar_branch
    cdef float m1_m3_CosThetaStar_value

    cdef TBranch* m1_m3_DPhi_branch
    cdef float m1_m3_DPhi_value

    cdef TBranch* m1_m3_DR_branch
    cdef float m1_m3_DR_value

    cdef TBranch* m1_m3_Eta_branch
    cdef float m1_m3_Eta_value

    cdef TBranch* m1_m3_Mass_branch
    cdef float m1_m3_Mass_value

    cdef TBranch* m1_m3_MassFsr_branch
    cdef float m1_m3_MassFsr_value

    cdef TBranch* m1_m3_PZeta_branch
    cdef float m1_m3_PZeta_value

    cdef TBranch* m1_m3_PZetaVis_branch
    cdef float m1_m3_PZetaVis_value

    cdef TBranch* m1_m3_Phi_branch
    cdef float m1_m3_Phi_value

    cdef TBranch* m1_m3_Pt_branch
    cdef float m1_m3_Pt_value

    cdef TBranch* m1_m3_PtFsr_branch
    cdef float m1_m3_PtFsr_value

    cdef TBranch* m1_m3_SS_branch
    cdef float m1_m3_SS_value

    cdef TBranch* m1_m3_ToMETDPhi_Ty1_branch
    cdef float m1_m3_ToMETDPhi_Ty1_value

    cdef TBranch* m1_m3_Zcompat_branch
    cdef float m1_m3_Zcompat_value

    cdef TBranch* m1_t_CosThetaStar_branch
    cdef float m1_t_CosThetaStar_value

    cdef TBranch* m1_t_DPhi_branch
    cdef float m1_t_DPhi_value

    cdef TBranch* m1_t_DR_branch
    cdef float m1_t_DR_value

    cdef TBranch* m1_t_Eta_branch
    cdef float m1_t_Eta_value

    cdef TBranch* m1_t_Mass_branch
    cdef float m1_t_Mass_value

    cdef TBranch* m1_t_MassFsr_branch
    cdef float m1_t_MassFsr_value

    cdef TBranch* m1_t_PZeta_branch
    cdef float m1_t_PZeta_value

    cdef TBranch* m1_t_PZetaVis_branch
    cdef float m1_t_PZetaVis_value

    cdef TBranch* m1_t_Phi_branch
    cdef float m1_t_Phi_value

    cdef TBranch* m1_t_Pt_branch
    cdef float m1_t_Pt_value

    cdef TBranch* m1_t_PtFsr_branch
    cdef float m1_t_PtFsr_value

    cdef TBranch* m1_t_SS_branch
    cdef float m1_t_SS_value

    cdef TBranch* m1_t_ToMETDPhi_Ty1_branch
    cdef float m1_t_ToMETDPhi_Ty1_value

    cdef TBranch* m1_t_Zcompat_branch
    cdef float m1_t_Zcompat_value

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

    cdef TBranch* m2_m3_CosThetaStar_branch
    cdef float m2_m3_CosThetaStar_value

    cdef TBranch* m2_m3_DPhi_branch
    cdef float m2_m3_DPhi_value

    cdef TBranch* m2_m3_DR_branch
    cdef float m2_m3_DR_value

    cdef TBranch* m2_m3_Eta_branch
    cdef float m2_m3_Eta_value

    cdef TBranch* m2_m3_Mass_branch
    cdef float m2_m3_Mass_value

    cdef TBranch* m2_m3_MassFsr_branch
    cdef float m2_m3_MassFsr_value

    cdef TBranch* m2_m3_PZeta_branch
    cdef float m2_m3_PZeta_value

    cdef TBranch* m2_m3_PZetaVis_branch
    cdef float m2_m3_PZetaVis_value

    cdef TBranch* m2_m3_Phi_branch
    cdef float m2_m3_Phi_value

    cdef TBranch* m2_m3_Pt_branch
    cdef float m2_m3_Pt_value

    cdef TBranch* m2_m3_PtFsr_branch
    cdef float m2_m3_PtFsr_value

    cdef TBranch* m2_m3_SS_branch
    cdef float m2_m3_SS_value

    cdef TBranch* m2_m3_ToMETDPhi_Ty1_branch
    cdef float m2_m3_ToMETDPhi_Ty1_value

    cdef TBranch* m2_m3_Zcompat_branch
    cdef float m2_m3_Zcompat_value

    cdef TBranch* m2_t_CosThetaStar_branch
    cdef float m2_t_CosThetaStar_value

    cdef TBranch* m2_t_DPhi_branch
    cdef float m2_t_DPhi_value

    cdef TBranch* m2_t_DR_branch
    cdef float m2_t_DR_value

    cdef TBranch* m2_t_Eta_branch
    cdef float m2_t_Eta_value

    cdef TBranch* m2_t_Mass_branch
    cdef float m2_t_Mass_value

    cdef TBranch* m2_t_MassFsr_branch
    cdef float m2_t_MassFsr_value

    cdef TBranch* m2_t_PZeta_branch
    cdef float m2_t_PZeta_value

    cdef TBranch* m2_t_PZetaVis_branch
    cdef float m2_t_PZetaVis_value

    cdef TBranch* m2_t_Phi_branch
    cdef float m2_t_Phi_value

    cdef TBranch* m2_t_Pt_branch
    cdef float m2_t_Pt_value

    cdef TBranch* m2_t_PtFsr_branch
    cdef float m2_t_PtFsr_value

    cdef TBranch* m2_t_SS_branch
    cdef float m2_t_SS_value

    cdef TBranch* m2_t_ToMETDPhi_Ty1_branch
    cdef float m2_t_ToMETDPhi_Ty1_value

    cdef TBranch* m2_t_Zcompat_branch
    cdef float m2_t_Zcompat_value

    cdef TBranch* m3AbsEta_branch
    cdef float m3AbsEta_value

    cdef TBranch* m3Charge_branch
    cdef float m3Charge_value

    cdef TBranch* m3ComesFromHiggs_branch
    cdef float m3ComesFromHiggs_value

    cdef TBranch* m3D0_branch
    cdef float m3D0_value

    cdef TBranch* m3DZ_branch
    cdef float m3DZ_value

    cdef TBranch* m3DiMuonL3PreFiltered7_branch
    cdef float m3DiMuonL3PreFiltered7_value

    cdef TBranch* m3DiMuonL3p5PreFiltered8_branch
    cdef float m3DiMuonL3p5PreFiltered8_value

    cdef TBranch* m3DiMuonMu17Mu8DzFiltered0p2_branch
    cdef float m3DiMuonMu17Mu8DzFiltered0p2_value

    cdef TBranch* m3EErrRochCor2011A_branch
    cdef float m3EErrRochCor2011A_value

    cdef TBranch* m3EErrRochCor2011B_branch
    cdef float m3EErrRochCor2011B_value

    cdef TBranch* m3EErrRochCor2012_branch
    cdef float m3EErrRochCor2012_value

    cdef TBranch* m3ERochCor2011A_branch
    cdef float m3ERochCor2011A_value

    cdef TBranch* m3ERochCor2011B_branch
    cdef float m3ERochCor2011B_value

    cdef TBranch* m3ERochCor2012_branch
    cdef float m3ERochCor2012_value

    cdef TBranch* m3EffectiveArea2011_branch
    cdef float m3EffectiveArea2011_value

    cdef TBranch* m3EffectiveArea2012_branch
    cdef float m3EffectiveArea2012_value

    cdef TBranch* m3Eta_branch
    cdef float m3Eta_value

    cdef TBranch* m3EtaRochCor2011A_branch
    cdef float m3EtaRochCor2011A_value

    cdef TBranch* m3EtaRochCor2011B_branch
    cdef float m3EtaRochCor2011B_value

    cdef TBranch* m3EtaRochCor2012_branch
    cdef float m3EtaRochCor2012_value

    cdef TBranch* m3GenCharge_branch
    cdef float m3GenCharge_value

    cdef TBranch* m3GenEnergy_branch
    cdef float m3GenEnergy_value

    cdef TBranch* m3GenEta_branch
    cdef float m3GenEta_value

    cdef TBranch* m3GenMotherPdgId_branch
    cdef float m3GenMotherPdgId_value

    cdef TBranch* m3GenPdgId_branch
    cdef float m3GenPdgId_value

    cdef TBranch* m3GenPhi_branch
    cdef float m3GenPhi_value

    cdef TBranch* m3GlbTrkHits_branch
    cdef float m3GlbTrkHits_value

    cdef TBranch* m3IDHZG2011_branch
    cdef float m3IDHZG2011_value

    cdef TBranch* m3IDHZG2012_branch
    cdef float m3IDHZG2012_value

    cdef TBranch* m3IP3DS_branch
    cdef float m3IP3DS_value

    cdef TBranch* m3IsGlobal_branch
    cdef float m3IsGlobal_value

    cdef TBranch* m3IsPFMuon_branch
    cdef float m3IsPFMuon_value

    cdef TBranch* m3IsTracker_branch
    cdef float m3IsTracker_value

    cdef TBranch* m3JetArea_branch
    cdef float m3JetArea_value

    cdef TBranch* m3JetBtag_branch
    cdef float m3JetBtag_value

    cdef TBranch* m3JetCSVBtag_branch
    cdef float m3JetCSVBtag_value

    cdef TBranch* m3JetEtaEtaMoment_branch
    cdef float m3JetEtaEtaMoment_value

    cdef TBranch* m3JetEtaPhiMoment_branch
    cdef float m3JetEtaPhiMoment_value

    cdef TBranch* m3JetEtaPhiSpread_branch
    cdef float m3JetEtaPhiSpread_value

    cdef TBranch* m3JetPartonFlavour_branch
    cdef float m3JetPartonFlavour_value

    cdef TBranch* m3JetPhiPhiMoment_branch
    cdef float m3JetPhiPhiMoment_value

    cdef TBranch* m3JetPt_branch
    cdef float m3JetPt_value

    cdef TBranch* m3JetQGLikelihoodID_branch
    cdef float m3JetQGLikelihoodID_value

    cdef TBranch* m3JetQGMVAID_branch
    cdef float m3JetQGMVAID_value

    cdef TBranch* m3Jetaxis1_branch
    cdef float m3Jetaxis1_value

    cdef TBranch* m3Jetaxis2_branch
    cdef float m3Jetaxis2_value

    cdef TBranch* m3Jetmult_branch
    cdef float m3Jetmult_value

    cdef TBranch* m3JetmultMLP_branch
    cdef float m3JetmultMLP_value

    cdef TBranch* m3JetmultMLPQC_branch
    cdef float m3JetmultMLPQC_value

    cdef TBranch* m3JetptD_branch
    cdef float m3JetptD_value

    cdef TBranch* m3L1Mu3EG5L3Filtered17_branch
    cdef float m3L1Mu3EG5L3Filtered17_value

    cdef TBranch* m3L3fL1DoubleMu10MuOpenL1f0L2f10L3Filtered17_branch
    cdef float m3L3fL1DoubleMu10MuOpenL1f0L2f10L3Filtered17_value

    cdef TBranch* m3Mass_branch
    cdef float m3Mass_value

    cdef TBranch* m3MatchedStations_branch
    cdef float m3MatchedStations_value

    cdef TBranch* m3MatchesDoubleMuPaths_branch
    cdef float m3MatchesDoubleMuPaths_value

    cdef TBranch* m3MatchesDoubleMuTrkPaths_branch
    cdef float m3MatchesDoubleMuTrkPaths_value

    cdef TBranch* m3MatchesIsoMu24eta2p1_branch
    cdef float m3MatchesIsoMu24eta2p1_value

    cdef TBranch* m3MatchesIsoMuGroup_branch
    cdef float m3MatchesIsoMuGroup_value

    cdef TBranch* m3MatchesMu17Ele8IsoPath_branch
    cdef float m3MatchesMu17Ele8IsoPath_value

    cdef TBranch* m3MatchesMu17Ele8Path_branch
    cdef float m3MatchesMu17Ele8Path_value

    cdef TBranch* m3MatchesMu17Mu8Path_branch
    cdef float m3MatchesMu17Mu8Path_value

    cdef TBranch* m3MatchesMu17TrkMu8Path_branch
    cdef float m3MatchesMu17TrkMu8Path_value

    cdef TBranch* m3MatchesMu8Ele17IsoPath_branch
    cdef float m3MatchesMu8Ele17IsoPath_value

    cdef TBranch* m3MatchesMu8Ele17Path_branch
    cdef float m3MatchesMu8Ele17Path_value

    cdef TBranch* m3MtToMET_branch
    cdef float m3MtToMET_value

    cdef TBranch* m3MtToMVAMET_branch
    cdef float m3MtToMVAMET_value

    cdef TBranch* m3MtToPFMET_branch
    cdef float m3MtToPFMET_value

    cdef TBranch* m3MtToPfMet_Ty1_branch
    cdef float m3MtToPfMet_Ty1_value

    cdef TBranch* m3MtToPfMet_jes_branch
    cdef float m3MtToPfMet_jes_value

    cdef TBranch* m3MtToPfMet_mes_branch
    cdef float m3MtToPfMet_mes_value

    cdef TBranch* m3MtToPfMet_tes_branch
    cdef float m3MtToPfMet_tes_value

    cdef TBranch* m3MtToPfMet_ues_branch
    cdef float m3MtToPfMet_ues_value

    cdef TBranch* m3Mu17Ele8dZFilter_branch
    cdef float m3Mu17Ele8dZFilter_value

    cdef TBranch* m3MuonHits_branch
    cdef float m3MuonHits_value

    cdef TBranch* m3NormTrkChi2_branch
    cdef float m3NormTrkChi2_value

    cdef TBranch* m3PFChargedIso_branch
    cdef float m3PFChargedIso_value

    cdef TBranch* m3PFIDTight_branch
    cdef float m3PFIDTight_value

    cdef TBranch* m3PFNeutralIso_branch
    cdef float m3PFNeutralIso_value

    cdef TBranch* m3PFPUChargedIso_branch
    cdef float m3PFPUChargedIso_value

    cdef TBranch* m3PFPhotonIso_branch
    cdef float m3PFPhotonIso_value

    cdef TBranch* m3PVDXY_branch
    cdef float m3PVDXY_value

    cdef TBranch* m3PVDZ_branch
    cdef float m3PVDZ_value

    cdef TBranch* m3Phi_branch
    cdef float m3Phi_value

    cdef TBranch* m3PhiRochCor2011A_branch
    cdef float m3PhiRochCor2011A_value

    cdef TBranch* m3PhiRochCor2011B_branch
    cdef float m3PhiRochCor2011B_value

    cdef TBranch* m3PhiRochCor2012_branch
    cdef float m3PhiRochCor2012_value

    cdef TBranch* m3PixHits_branch
    cdef float m3PixHits_value

    cdef TBranch* m3Pt_branch
    cdef float m3Pt_value

    cdef TBranch* m3PtRochCor2011A_branch
    cdef float m3PtRochCor2011A_value

    cdef TBranch* m3PtRochCor2011B_branch
    cdef float m3PtRochCor2011B_value

    cdef TBranch* m3PtRochCor2012_branch
    cdef float m3PtRochCor2012_value

    cdef TBranch* m3Rank_branch
    cdef float m3Rank_value

    cdef TBranch* m3RelPFIsoDB_branch
    cdef float m3RelPFIsoDB_value

    cdef TBranch* m3RelPFIsoRho_branch
    cdef float m3RelPFIsoRho_value

    cdef TBranch* m3RelPFIsoRhoFSR_branch
    cdef float m3RelPFIsoRhoFSR_value

    cdef TBranch* m3RhoHZG2011_branch
    cdef float m3RhoHZG2011_value

    cdef TBranch* m3RhoHZG2012_branch
    cdef float m3RhoHZG2012_value

    cdef TBranch* m3SingleMu13L3Filtered13_branch
    cdef float m3SingleMu13L3Filtered13_value

    cdef TBranch* m3SingleMu13L3Filtered17_branch
    cdef float m3SingleMu13L3Filtered17_value

    cdef TBranch* m3TkLayersWithMeasurement_branch
    cdef float m3TkLayersWithMeasurement_value

    cdef TBranch* m3ToMETDPhi_branch
    cdef float m3ToMETDPhi_value

    cdef TBranch* m3TypeCode_branch
    cdef int m3TypeCode_value

    cdef TBranch* m3VBTFID_branch
    cdef float m3VBTFID_value

    cdef TBranch* m3VZ_branch
    cdef float m3VZ_value

    cdef TBranch* m3WWID_branch
    cdef float m3WWID_value

    cdef TBranch* m3_t_CosThetaStar_branch
    cdef float m3_t_CosThetaStar_value

    cdef TBranch* m3_t_DPhi_branch
    cdef float m3_t_DPhi_value

    cdef TBranch* m3_t_DR_branch
    cdef float m3_t_DR_value

    cdef TBranch* m3_t_Eta_branch
    cdef float m3_t_Eta_value

    cdef TBranch* m3_t_Mass_branch
    cdef float m3_t_Mass_value

    cdef TBranch* m3_t_MassFsr_branch
    cdef float m3_t_MassFsr_value

    cdef TBranch* m3_t_PZeta_branch
    cdef float m3_t_PZeta_value

    cdef TBranch* m3_t_PZetaVis_branch
    cdef float m3_t_PZetaVis_value

    cdef TBranch* m3_t_Phi_branch
    cdef float m3_t_Phi_value

    cdef TBranch* m3_t_Pt_branch
    cdef float m3_t_Pt_value

    cdef TBranch* m3_t_PtFsr_branch
    cdef float m3_t_PtFsr_value

    cdef TBranch* m3_t_SS_branch
    cdef float m3_t_SS_value

    cdef TBranch* m3_t_SVfitEta_branch
    cdef float m3_t_SVfitEta_value

    cdef TBranch* m3_t_SVfitMass_branch
    cdef float m3_t_SVfitMass_value

    cdef TBranch* m3_t_SVfitPhi_branch
    cdef float m3_t_SVfitPhi_value

    cdef TBranch* m3_t_SVfitPt_branch
    cdef float m3_t_SVfitPt_value

    cdef TBranch* m3_t_ToMETDPhi_Ty1_branch
    cdef float m3_t_ToMETDPhi_Ty1_value

    cdef TBranch* m3_t_Zcompat_branch
    cdef float m3_t_Zcompat_value

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

    cdef TBranch* tAbsEta_branch
    cdef float tAbsEta_value

    cdef TBranch* tAntiElectronLoose_branch
    cdef float tAntiElectronLoose_value

    cdef TBranch* tAntiElectronMVA3Loose_branch
    cdef float tAntiElectronMVA3Loose_value

    cdef TBranch* tAntiElectronMVA3Medium_branch
    cdef float tAntiElectronMVA3Medium_value

    cdef TBranch* tAntiElectronMVA3Raw_branch
    cdef float tAntiElectronMVA3Raw_value

    cdef TBranch* tAntiElectronMVA3Tight_branch
    cdef float tAntiElectronMVA3Tight_value

    cdef TBranch* tAntiElectronMVA3VTight_branch
    cdef float tAntiElectronMVA3VTight_value

    cdef TBranch* tAntiElectronMedium_branch
    cdef float tAntiElectronMedium_value

    cdef TBranch* tAntiElectronTight_branch
    cdef float tAntiElectronTight_value

    cdef TBranch* tAntiMuonLoose_branch
    cdef float tAntiMuonLoose_value

    cdef TBranch* tAntiMuonLoose2_branch
    cdef float tAntiMuonLoose2_value

    cdef TBranch* tAntiMuonMedium_branch
    cdef float tAntiMuonMedium_value

    cdef TBranch* tAntiMuonMedium2_branch
    cdef float tAntiMuonMedium2_value

    cdef TBranch* tAntiMuonTight_branch
    cdef float tAntiMuonTight_value

    cdef TBranch* tAntiMuonTight2_branch
    cdef float tAntiMuonTight2_value

    cdef TBranch* tCharge_branch
    cdef float tCharge_value

    cdef TBranch* tCiCTightElecOverlap_branch
    cdef float tCiCTightElecOverlap_value

    cdef TBranch* tDZ_branch
    cdef float tDZ_value

    cdef TBranch* tDecayFinding_branch
    cdef float tDecayFinding_value

    cdef TBranch* tDecayMode_branch
    cdef float tDecayMode_value

    cdef TBranch* tElecOverlap_branch
    cdef float tElecOverlap_value

    cdef TBranch* tElecOverlapZHLoose_branch
    cdef float tElecOverlapZHLoose_value

    cdef TBranch* tElecOverlapZHTight_branch
    cdef float tElecOverlapZHTight_value

    cdef TBranch* tEta_branch
    cdef float tEta_value

    cdef TBranch* tGenDecayMode_branch
    cdef float tGenDecayMode_value

    cdef TBranch* tIP3DS_branch
    cdef float tIP3DS_value

    cdef TBranch* tJetArea_branch
    cdef float tJetArea_value

    cdef TBranch* tJetBtag_branch
    cdef float tJetBtag_value

    cdef TBranch* tJetCSVBtag_branch
    cdef float tJetCSVBtag_value

    cdef TBranch* tJetEtaEtaMoment_branch
    cdef float tJetEtaEtaMoment_value

    cdef TBranch* tJetEtaPhiMoment_branch
    cdef float tJetEtaPhiMoment_value

    cdef TBranch* tJetEtaPhiSpread_branch
    cdef float tJetEtaPhiSpread_value

    cdef TBranch* tJetPartonFlavour_branch
    cdef float tJetPartonFlavour_value

    cdef TBranch* tJetPhiPhiMoment_branch
    cdef float tJetPhiPhiMoment_value

    cdef TBranch* tJetPt_branch
    cdef float tJetPt_value

    cdef TBranch* tJetQGLikelihoodID_branch
    cdef float tJetQGLikelihoodID_value

    cdef TBranch* tJetQGMVAID_branch
    cdef float tJetQGMVAID_value

    cdef TBranch* tJetaxis1_branch
    cdef float tJetaxis1_value

    cdef TBranch* tJetaxis2_branch
    cdef float tJetaxis2_value

    cdef TBranch* tJetmult_branch
    cdef float tJetmult_value

    cdef TBranch* tJetmultMLP_branch
    cdef float tJetmultMLP_value

    cdef TBranch* tJetmultMLPQC_branch
    cdef float tJetmultMLPQC_value

    cdef TBranch* tJetptD_branch
    cdef float tJetptD_value

    cdef TBranch* tLeadTrackPt_branch
    cdef float tLeadTrackPt_value

    cdef TBranch* tLooseIso_branch
    cdef float tLooseIso_value

    cdef TBranch* tLooseIso3Hits_branch
    cdef float tLooseIso3Hits_value

    cdef TBranch* tLooseMVA2Iso_branch
    cdef float tLooseMVA2Iso_value

    cdef TBranch* tLooseMVAIso_branch
    cdef float tLooseMVAIso_value

    cdef TBranch* tMVA2IsoRaw_branch
    cdef float tMVA2IsoRaw_value

    cdef TBranch* tMass_branch
    cdef float tMass_value

    cdef TBranch* tMediumIso_branch
    cdef float tMediumIso_value

    cdef TBranch* tMediumIso3Hits_branch
    cdef float tMediumIso3Hits_value

    cdef TBranch* tMediumMVA2Iso_branch
    cdef float tMediumMVA2Iso_value

    cdef TBranch* tMediumMVAIso_branch
    cdef float tMediumMVAIso_value

    cdef TBranch* tMtToMET_branch
    cdef float tMtToMET_value

    cdef TBranch* tMtToMVAMET_branch
    cdef float tMtToMVAMET_value

    cdef TBranch* tMtToPFMET_branch
    cdef float tMtToPFMET_value

    cdef TBranch* tMtToPfMet_Ty1_branch
    cdef float tMtToPfMet_Ty1_value

    cdef TBranch* tMtToPfMet_jes_branch
    cdef float tMtToPfMet_jes_value

    cdef TBranch* tMtToPfMet_mes_branch
    cdef float tMtToPfMet_mes_value

    cdef TBranch* tMtToPfMet_tes_branch
    cdef float tMtToPfMet_tes_value

    cdef TBranch* tMtToPfMet_ues_branch
    cdef float tMtToPfMet_ues_value

    cdef TBranch* tMuOverlap_branch
    cdef float tMuOverlap_value

    cdef TBranch* tMuOverlapZHLoose_branch
    cdef float tMuOverlapZHLoose_value

    cdef TBranch* tMuOverlapZHTight_branch
    cdef float tMuOverlapZHTight_value

    cdef TBranch* tPhi_branch
    cdef float tPhi_value

    cdef TBranch* tPt_branch
    cdef float tPt_value

    cdef TBranch* tRank_branch
    cdef float tRank_value

    cdef TBranch* tTNPId_branch
    cdef float tTNPId_value

    cdef TBranch* tTightIso_branch
    cdef float tTightIso_value

    cdef TBranch* tTightIso3Hits_branch
    cdef float tTightIso3Hits_value

    cdef TBranch* tTightMVA2Iso_branch
    cdef float tTightMVA2Iso_value

    cdef TBranch* tTightMVAIso_branch
    cdef float tTightMVAIso_value

    cdef TBranch* tToMETDPhi_branch
    cdef float tToMETDPhi_value

    cdef TBranch* tVLooseIso_branch
    cdef float tVLooseIso_value

    cdef TBranch* tVZ_branch
    cdef float tVZ_value

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
            warnings.warn( "MuMuMuTauTree: Expected branch EmbPtWeight does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("EmbPtWeight")
        else:
            self.EmbPtWeight_branch.SetAddress(<void*>&self.EmbPtWeight_value)

        #print "making LT"
        self.LT_branch = the_tree.GetBranch("LT")
        #if not self.LT_branch and "LT" not in self.complained:
        if not self.LT_branch and "LT":
            warnings.warn( "MuMuMuTauTree: Expected branch LT does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("LT")
        else:
            self.LT_branch.SetAddress(<void*>&self.LT_value)

        #print "making Mass"
        self.Mass_branch = the_tree.GetBranch("Mass")
        #if not self.Mass_branch and "Mass" not in self.complained:
        if not self.Mass_branch and "Mass":
            warnings.warn( "MuMuMuTauTree: Expected branch Mass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Mass")
        else:
            self.Mass_branch.SetAddress(<void*>&self.Mass_value)

        #print "making MassError"
        self.MassError_branch = the_tree.GetBranch("MassError")
        #if not self.MassError_branch and "MassError" not in self.complained:
        if not self.MassError_branch and "MassError":
            warnings.warn( "MuMuMuTauTree: Expected branch MassError does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("MassError")
        else:
            self.MassError_branch.SetAddress(<void*>&self.MassError_value)

        #print "making MassErrord1"
        self.MassErrord1_branch = the_tree.GetBranch("MassErrord1")
        #if not self.MassErrord1_branch and "MassErrord1" not in self.complained:
        if not self.MassErrord1_branch and "MassErrord1":
            warnings.warn( "MuMuMuTauTree: Expected branch MassErrord1 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("MassErrord1")
        else:
            self.MassErrord1_branch.SetAddress(<void*>&self.MassErrord1_value)

        #print "making MassErrord2"
        self.MassErrord2_branch = the_tree.GetBranch("MassErrord2")
        #if not self.MassErrord2_branch and "MassErrord2" not in self.complained:
        if not self.MassErrord2_branch and "MassErrord2":
            warnings.warn( "MuMuMuTauTree: Expected branch MassErrord2 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("MassErrord2")
        else:
            self.MassErrord2_branch.SetAddress(<void*>&self.MassErrord2_value)

        #print "making MassErrord3"
        self.MassErrord3_branch = the_tree.GetBranch("MassErrord3")
        #if not self.MassErrord3_branch and "MassErrord3" not in self.complained:
        if not self.MassErrord3_branch and "MassErrord3":
            warnings.warn( "MuMuMuTauTree: Expected branch MassErrord3 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("MassErrord3")
        else:
            self.MassErrord3_branch.SetAddress(<void*>&self.MassErrord3_value)

        #print "making MassErrord4"
        self.MassErrord4_branch = the_tree.GetBranch("MassErrord4")
        #if not self.MassErrord4_branch and "MassErrord4" not in self.complained:
        if not self.MassErrord4_branch and "MassErrord4":
            warnings.warn( "MuMuMuTauTree: Expected branch MassErrord4 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("MassErrord4")
        else:
            self.MassErrord4_branch.SetAddress(<void*>&self.MassErrord4_value)

        #print "making NUP"
        self.NUP_branch = the_tree.GetBranch("NUP")
        #if not self.NUP_branch and "NUP" not in self.complained:
        if not self.NUP_branch and "NUP":
            warnings.warn( "MuMuMuTauTree: Expected branch NUP does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("NUP")
        else:
            self.NUP_branch.SetAddress(<void*>&self.NUP_value)

        #print "making Pt"
        self.Pt_branch = the_tree.GetBranch("Pt")
        #if not self.Pt_branch and "Pt" not in self.complained:
        if not self.Pt_branch and "Pt":
            warnings.warn( "MuMuMuTauTree: Expected branch Pt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Pt")
        else:
            self.Pt_branch.SetAddress(<void*>&self.Pt_value)

        #print "making bjetCSVVeto"
        self.bjetCSVVeto_branch = the_tree.GetBranch("bjetCSVVeto")
        #if not self.bjetCSVVeto_branch and "bjetCSVVeto" not in self.complained:
        if not self.bjetCSVVeto_branch and "bjetCSVVeto":
            warnings.warn( "MuMuMuTauTree: Expected branch bjetCSVVeto does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("bjetCSVVeto")
        else:
            self.bjetCSVVeto_branch.SetAddress(<void*>&self.bjetCSVVeto_value)

        #print "making bjetCSVVeto30"
        self.bjetCSVVeto30_branch = the_tree.GetBranch("bjetCSVVeto30")
        #if not self.bjetCSVVeto30_branch and "bjetCSVVeto30" not in self.complained:
        if not self.bjetCSVVeto30_branch and "bjetCSVVeto30":
            warnings.warn( "MuMuMuTauTree: Expected branch bjetCSVVeto30 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("bjetCSVVeto30")
        else:
            self.bjetCSVVeto30_branch.SetAddress(<void*>&self.bjetCSVVeto30_value)

        #print "making bjetCSVVetoZHLike"
        self.bjetCSVVetoZHLike_branch = the_tree.GetBranch("bjetCSVVetoZHLike")
        #if not self.bjetCSVVetoZHLike_branch and "bjetCSVVetoZHLike" not in self.complained:
        if not self.bjetCSVVetoZHLike_branch and "bjetCSVVetoZHLike":
            warnings.warn( "MuMuMuTauTree: Expected branch bjetCSVVetoZHLike does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("bjetCSVVetoZHLike")
        else:
            self.bjetCSVVetoZHLike_branch.SetAddress(<void*>&self.bjetCSVVetoZHLike_value)

        #print "making bjetCSVVetoZHLikeNoJetId"
        self.bjetCSVVetoZHLikeNoJetId_branch = the_tree.GetBranch("bjetCSVVetoZHLikeNoJetId")
        #if not self.bjetCSVVetoZHLikeNoJetId_branch and "bjetCSVVetoZHLikeNoJetId" not in self.complained:
        if not self.bjetCSVVetoZHLikeNoJetId_branch and "bjetCSVVetoZHLikeNoJetId":
            warnings.warn( "MuMuMuTauTree: Expected branch bjetCSVVetoZHLikeNoJetId does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("bjetCSVVetoZHLikeNoJetId")
        else:
            self.bjetCSVVetoZHLikeNoJetId_branch.SetAddress(<void*>&self.bjetCSVVetoZHLikeNoJetId_value)

        #print "making bjetCSVVetoZHLikeNoJetId_2"
        self.bjetCSVVetoZHLikeNoJetId_2_branch = the_tree.GetBranch("bjetCSVVetoZHLikeNoJetId_2")
        #if not self.bjetCSVVetoZHLikeNoJetId_2_branch and "bjetCSVVetoZHLikeNoJetId_2" not in self.complained:
        if not self.bjetCSVVetoZHLikeNoJetId_2_branch and "bjetCSVVetoZHLikeNoJetId_2":
            warnings.warn( "MuMuMuTauTree: Expected branch bjetCSVVetoZHLikeNoJetId_2 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("bjetCSVVetoZHLikeNoJetId_2")
        else:
            self.bjetCSVVetoZHLikeNoJetId_2_branch.SetAddress(<void*>&self.bjetCSVVetoZHLikeNoJetId_2_value)

        #print "making bjetTightCountZH"
        self.bjetTightCountZH_branch = the_tree.GetBranch("bjetTightCountZH")
        #if not self.bjetTightCountZH_branch and "bjetTightCountZH" not in self.complained:
        if not self.bjetTightCountZH_branch and "bjetTightCountZH":
            warnings.warn( "MuMuMuTauTree: Expected branch bjetTightCountZH does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("bjetTightCountZH")
        else:
            self.bjetTightCountZH_branch.SetAddress(<void*>&self.bjetTightCountZH_value)

        #print "making bjetVeto"
        self.bjetVeto_branch = the_tree.GetBranch("bjetVeto")
        #if not self.bjetVeto_branch and "bjetVeto" not in self.complained:
        if not self.bjetVeto_branch and "bjetVeto":
            warnings.warn( "MuMuMuTauTree: Expected branch bjetVeto does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("bjetVeto")
        else:
            self.bjetVeto_branch.SetAddress(<void*>&self.bjetVeto_value)

        #print "making charge"
        self.charge_branch = the_tree.GetBranch("charge")
        #if not self.charge_branch and "charge" not in self.complained:
        if not self.charge_branch and "charge":
            warnings.warn( "MuMuMuTauTree: Expected branch charge does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("charge")
        else:
            self.charge_branch.SetAddress(<void*>&self.charge_value)

        #print "making doubleEExtraGroup"
        self.doubleEExtraGroup_branch = the_tree.GetBranch("doubleEExtraGroup")
        #if not self.doubleEExtraGroup_branch and "doubleEExtraGroup" not in self.complained:
        if not self.doubleEExtraGroup_branch and "doubleEExtraGroup":
            warnings.warn( "MuMuMuTauTree: Expected branch doubleEExtraGroup does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleEExtraGroup")
        else:
            self.doubleEExtraGroup_branch.SetAddress(<void*>&self.doubleEExtraGroup_value)

        #print "making doubleEExtraPass"
        self.doubleEExtraPass_branch = the_tree.GetBranch("doubleEExtraPass")
        #if not self.doubleEExtraPass_branch and "doubleEExtraPass" not in self.complained:
        if not self.doubleEExtraPass_branch and "doubleEExtraPass":
            warnings.warn( "MuMuMuTauTree: Expected branch doubleEExtraPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleEExtraPass")
        else:
            self.doubleEExtraPass_branch.SetAddress(<void*>&self.doubleEExtraPass_value)

        #print "making doubleEExtraPrescale"
        self.doubleEExtraPrescale_branch = the_tree.GetBranch("doubleEExtraPrescale")
        #if not self.doubleEExtraPrescale_branch and "doubleEExtraPrescale" not in self.complained:
        if not self.doubleEExtraPrescale_branch and "doubleEExtraPrescale":
            warnings.warn( "MuMuMuTauTree: Expected branch doubleEExtraPrescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleEExtraPrescale")
        else:
            self.doubleEExtraPrescale_branch.SetAddress(<void*>&self.doubleEExtraPrescale_value)

        #print "making doubleEGroup"
        self.doubleEGroup_branch = the_tree.GetBranch("doubleEGroup")
        #if not self.doubleEGroup_branch and "doubleEGroup" not in self.complained:
        if not self.doubleEGroup_branch and "doubleEGroup":
            warnings.warn( "MuMuMuTauTree: Expected branch doubleEGroup does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleEGroup")
        else:
            self.doubleEGroup_branch.SetAddress(<void*>&self.doubleEGroup_value)

        #print "making doubleEPass"
        self.doubleEPass_branch = the_tree.GetBranch("doubleEPass")
        #if not self.doubleEPass_branch and "doubleEPass" not in self.complained:
        if not self.doubleEPass_branch and "doubleEPass":
            warnings.warn( "MuMuMuTauTree: Expected branch doubleEPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleEPass")
        else:
            self.doubleEPass_branch.SetAddress(<void*>&self.doubleEPass_value)

        #print "making doubleEPrescale"
        self.doubleEPrescale_branch = the_tree.GetBranch("doubleEPrescale")
        #if not self.doubleEPrescale_branch and "doubleEPrescale" not in self.complained:
        if not self.doubleEPrescale_branch and "doubleEPrescale":
            warnings.warn( "MuMuMuTauTree: Expected branch doubleEPrescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleEPrescale")
        else:
            self.doubleEPrescale_branch.SetAddress(<void*>&self.doubleEPrescale_value)

        #print "making doubleETightGroup"
        self.doubleETightGroup_branch = the_tree.GetBranch("doubleETightGroup")
        #if not self.doubleETightGroup_branch and "doubleETightGroup" not in self.complained:
        if not self.doubleETightGroup_branch and "doubleETightGroup":
            warnings.warn( "MuMuMuTauTree: Expected branch doubleETightGroup does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleETightGroup")
        else:
            self.doubleETightGroup_branch.SetAddress(<void*>&self.doubleETightGroup_value)

        #print "making doubleETightPass"
        self.doubleETightPass_branch = the_tree.GetBranch("doubleETightPass")
        #if not self.doubleETightPass_branch and "doubleETightPass" not in self.complained:
        if not self.doubleETightPass_branch and "doubleETightPass":
            warnings.warn( "MuMuMuTauTree: Expected branch doubleETightPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleETightPass")
        else:
            self.doubleETightPass_branch.SetAddress(<void*>&self.doubleETightPass_value)

        #print "making doubleETightPrescale"
        self.doubleETightPrescale_branch = the_tree.GetBranch("doubleETightPrescale")
        #if not self.doubleETightPrescale_branch and "doubleETightPrescale" not in self.complained:
        if not self.doubleETightPrescale_branch and "doubleETightPrescale":
            warnings.warn( "MuMuMuTauTree: Expected branch doubleETightPrescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleETightPrescale")
        else:
            self.doubleETightPrescale_branch.SetAddress(<void*>&self.doubleETightPrescale_value)

        #print "making doubleMuGroup"
        self.doubleMuGroup_branch = the_tree.GetBranch("doubleMuGroup")
        #if not self.doubleMuGroup_branch and "doubleMuGroup" not in self.complained:
        if not self.doubleMuGroup_branch and "doubleMuGroup":
            warnings.warn( "MuMuMuTauTree: Expected branch doubleMuGroup does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleMuGroup")
        else:
            self.doubleMuGroup_branch.SetAddress(<void*>&self.doubleMuGroup_value)

        #print "making doubleMuPass"
        self.doubleMuPass_branch = the_tree.GetBranch("doubleMuPass")
        #if not self.doubleMuPass_branch and "doubleMuPass" not in self.complained:
        if not self.doubleMuPass_branch and "doubleMuPass":
            warnings.warn( "MuMuMuTauTree: Expected branch doubleMuPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleMuPass")
        else:
            self.doubleMuPass_branch.SetAddress(<void*>&self.doubleMuPass_value)

        #print "making doubleMuPrescale"
        self.doubleMuPrescale_branch = the_tree.GetBranch("doubleMuPrescale")
        #if not self.doubleMuPrescale_branch and "doubleMuPrescale" not in self.complained:
        if not self.doubleMuPrescale_branch and "doubleMuPrescale":
            warnings.warn( "MuMuMuTauTree: Expected branch doubleMuPrescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleMuPrescale")
        else:
            self.doubleMuPrescale_branch.SetAddress(<void*>&self.doubleMuPrescale_value)

        #print "making doubleMuTrkGroup"
        self.doubleMuTrkGroup_branch = the_tree.GetBranch("doubleMuTrkGroup")
        #if not self.doubleMuTrkGroup_branch and "doubleMuTrkGroup" not in self.complained:
        if not self.doubleMuTrkGroup_branch and "doubleMuTrkGroup":
            warnings.warn( "MuMuMuTauTree: Expected branch doubleMuTrkGroup does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleMuTrkGroup")
        else:
            self.doubleMuTrkGroup_branch.SetAddress(<void*>&self.doubleMuTrkGroup_value)

        #print "making doubleMuTrkPass"
        self.doubleMuTrkPass_branch = the_tree.GetBranch("doubleMuTrkPass")
        #if not self.doubleMuTrkPass_branch and "doubleMuTrkPass" not in self.complained:
        if not self.doubleMuTrkPass_branch and "doubleMuTrkPass":
            warnings.warn( "MuMuMuTauTree: Expected branch doubleMuTrkPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleMuTrkPass")
        else:
            self.doubleMuTrkPass_branch.SetAddress(<void*>&self.doubleMuTrkPass_value)

        #print "making doubleMuTrkPrescale"
        self.doubleMuTrkPrescale_branch = the_tree.GetBranch("doubleMuTrkPrescale")
        #if not self.doubleMuTrkPrescale_branch and "doubleMuTrkPrescale" not in self.complained:
        if not self.doubleMuTrkPrescale_branch and "doubleMuTrkPrescale":
            warnings.warn( "MuMuMuTauTree: Expected branch doubleMuTrkPrescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleMuTrkPrescale")
        else:
            self.doubleMuTrkPrescale_branch.SetAddress(<void*>&self.doubleMuTrkPrescale_value)

        #print "making doublePhoGroup"
        self.doublePhoGroup_branch = the_tree.GetBranch("doublePhoGroup")
        #if not self.doublePhoGroup_branch and "doublePhoGroup" not in self.complained:
        if not self.doublePhoGroup_branch and "doublePhoGroup":
            warnings.warn( "MuMuMuTauTree: Expected branch doublePhoGroup does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doublePhoGroup")
        else:
            self.doublePhoGroup_branch.SetAddress(<void*>&self.doublePhoGroup_value)

        #print "making doublePhoPass"
        self.doublePhoPass_branch = the_tree.GetBranch("doublePhoPass")
        #if not self.doublePhoPass_branch and "doublePhoPass" not in self.complained:
        if not self.doublePhoPass_branch and "doublePhoPass":
            warnings.warn( "MuMuMuTauTree: Expected branch doublePhoPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doublePhoPass")
        else:
            self.doublePhoPass_branch.SetAddress(<void*>&self.doublePhoPass_value)

        #print "making doublePhoPrescale"
        self.doublePhoPrescale_branch = the_tree.GetBranch("doublePhoPrescale")
        #if not self.doublePhoPrescale_branch and "doublePhoPrescale" not in self.complained:
        if not self.doublePhoPrescale_branch and "doublePhoPrescale":
            warnings.warn( "MuMuMuTauTree: Expected branch doublePhoPrescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doublePhoPrescale")
        else:
            self.doublePhoPrescale_branch.SetAddress(<void*>&self.doublePhoPrescale_value)

        #print "making eTightCountZH"
        self.eTightCountZH_branch = the_tree.GetBranch("eTightCountZH")
        #if not self.eTightCountZH_branch and "eTightCountZH" not in self.complained:
        if not self.eTightCountZH_branch and "eTightCountZH":
            warnings.warn( "MuMuMuTauTree: Expected branch eTightCountZH does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eTightCountZH")
        else:
            self.eTightCountZH_branch.SetAddress(<void*>&self.eTightCountZH_value)

        #print "making eVetoCicTightIso"
        self.eVetoCicTightIso_branch = the_tree.GetBranch("eVetoCicTightIso")
        #if not self.eVetoCicTightIso_branch and "eVetoCicTightIso" not in self.complained:
        if not self.eVetoCicTightIso_branch and "eVetoCicTightIso":
            warnings.warn( "MuMuMuTauTree: Expected branch eVetoCicTightIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eVetoCicTightIso")
        else:
            self.eVetoCicTightIso_branch.SetAddress(<void*>&self.eVetoCicTightIso_value)

        #print "making eVetoMVAIso"
        self.eVetoMVAIso_branch = the_tree.GetBranch("eVetoMVAIso")
        #if not self.eVetoMVAIso_branch and "eVetoMVAIso" not in self.complained:
        if not self.eVetoMVAIso_branch and "eVetoMVAIso":
            warnings.warn( "MuMuMuTauTree: Expected branch eVetoMVAIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eVetoMVAIso")
        else:
            self.eVetoMVAIso_branch.SetAddress(<void*>&self.eVetoMVAIso_value)

        #print "making eVetoMVAIsoVtx"
        self.eVetoMVAIsoVtx_branch = the_tree.GetBranch("eVetoMVAIsoVtx")
        #if not self.eVetoMVAIsoVtx_branch and "eVetoMVAIsoVtx" not in self.complained:
        if not self.eVetoMVAIsoVtx_branch and "eVetoMVAIsoVtx":
            warnings.warn( "MuMuMuTauTree: Expected branch eVetoMVAIsoVtx does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eVetoMVAIsoVtx")
        else:
            self.eVetoMVAIsoVtx_branch.SetAddress(<void*>&self.eVetoMVAIsoVtx_value)

        #print "making eVetoZH"
        self.eVetoZH_branch = the_tree.GetBranch("eVetoZH")
        #if not self.eVetoZH_branch and "eVetoZH" not in self.complained:
        if not self.eVetoZH_branch and "eVetoZH":
            warnings.warn( "MuMuMuTauTree: Expected branch eVetoZH does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eVetoZH")
        else:
            self.eVetoZH_branch.SetAddress(<void*>&self.eVetoZH_value)

        #print "making eVetoZH_smallDR"
        self.eVetoZH_smallDR_branch = the_tree.GetBranch("eVetoZH_smallDR")
        #if not self.eVetoZH_smallDR_branch and "eVetoZH_smallDR" not in self.complained:
        if not self.eVetoZH_smallDR_branch and "eVetoZH_smallDR":
            warnings.warn( "MuMuMuTauTree: Expected branch eVetoZH_smallDR does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eVetoZH_smallDR")
        else:
            self.eVetoZH_smallDR_branch.SetAddress(<void*>&self.eVetoZH_smallDR_value)

        #print "making evt"
        self.evt_branch = the_tree.GetBranch("evt")
        #if not self.evt_branch and "evt" not in self.complained:
        if not self.evt_branch and "evt":
            warnings.warn( "MuMuMuTauTree: Expected branch evt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("evt")
        else:
            self.evt_branch.SetAddress(<void*>&self.evt_value)

        #print "making isGtautau"
        self.isGtautau_branch = the_tree.GetBranch("isGtautau")
        #if not self.isGtautau_branch and "isGtautau" not in self.complained:
        if not self.isGtautau_branch and "isGtautau":
            warnings.warn( "MuMuMuTauTree: Expected branch isGtautau does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("isGtautau")
        else:
            self.isGtautau_branch.SetAddress(<void*>&self.isGtautau_value)

        #print "making isWmunu"
        self.isWmunu_branch = the_tree.GetBranch("isWmunu")
        #if not self.isWmunu_branch and "isWmunu" not in self.complained:
        if not self.isWmunu_branch and "isWmunu":
            warnings.warn( "MuMuMuTauTree: Expected branch isWmunu does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("isWmunu")
        else:
            self.isWmunu_branch.SetAddress(<void*>&self.isWmunu_value)

        #print "making isWtaunu"
        self.isWtaunu_branch = the_tree.GetBranch("isWtaunu")
        #if not self.isWtaunu_branch and "isWtaunu" not in self.complained:
        if not self.isWtaunu_branch and "isWtaunu":
            warnings.warn( "MuMuMuTauTree: Expected branch isWtaunu does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("isWtaunu")
        else:
            self.isWtaunu_branch.SetAddress(<void*>&self.isWtaunu_value)

        #print "making isZtautau"
        self.isZtautau_branch = the_tree.GetBranch("isZtautau")
        #if not self.isZtautau_branch and "isZtautau" not in self.complained:
        if not self.isZtautau_branch and "isZtautau":
            warnings.warn( "MuMuMuTauTree: Expected branch isZtautau does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("isZtautau")
        else:
            self.isZtautau_branch.SetAddress(<void*>&self.isZtautau_value)

        #print "making isdata"
        self.isdata_branch = the_tree.GetBranch("isdata")
        #if not self.isdata_branch and "isdata" not in self.complained:
        if not self.isdata_branch and "isdata":
            warnings.warn( "MuMuMuTauTree: Expected branch isdata does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("isdata")
        else:
            self.isdata_branch.SetAddress(<void*>&self.isdata_value)

        #print "making isoMu24eta2p1Group"
        self.isoMu24eta2p1Group_branch = the_tree.GetBranch("isoMu24eta2p1Group")
        #if not self.isoMu24eta2p1Group_branch and "isoMu24eta2p1Group" not in self.complained:
        if not self.isoMu24eta2p1Group_branch and "isoMu24eta2p1Group":
            warnings.warn( "MuMuMuTauTree: Expected branch isoMu24eta2p1Group does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("isoMu24eta2p1Group")
        else:
            self.isoMu24eta2p1Group_branch.SetAddress(<void*>&self.isoMu24eta2p1Group_value)

        #print "making isoMu24eta2p1Pass"
        self.isoMu24eta2p1Pass_branch = the_tree.GetBranch("isoMu24eta2p1Pass")
        #if not self.isoMu24eta2p1Pass_branch and "isoMu24eta2p1Pass" not in self.complained:
        if not self.isoMu24eta2p1Pass_branch and "isoMu24eta2p1Pass":
            warnings.warn( "MuMuMuTauTree: Expected branch isoMu24eta2p1Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("isoMu24eta2p1Pass")
        else:
            self.isoMu24eta2p1Pass_branch.SetAddress(<void*>&self.isoMu24eta2p1Pass_value)

        #print "making isoMu24eta2p1Prescale"
        self.isoMu24eta2p1Prescale_branch = the_tree.GetBranch("isoMu24eta2p1Prescale")
        #if not self.isoMu24eta2p1Prescale_branch and "isoMu24eta2p1Prescale" not in self.complained:
        if not self.isoMu24eta2p1Prescale_branch and "isoMu24eta2p1Prescale":
            warnings.warn( "MuMuMuTauTree: Expected branch isoMu24eta2p1Prescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("isoMu24eta2p1Prescale")
        else:
            self.isoMu24eta2p1Prescale_branch.SetAddress(<void*>&self.isoMu24eta2p1Prescale_value)

        #print "making isoMuGroup"
        self.isoMuGroup_branch = the_tree.GetBranch("isoMuGroup")
        #if not self.isoMuGroup_branch and "isoMuGroup" not in self.complained:
        if not self.isoMuGroup_branch and "isoMuGroup":
            warnings.warn( "MuMuMuTauTree: Expected branch isoMuGroup does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("isoMuGroup")
        else:
            self.isoMuGroup_branch.SetAddress(<void*>&self.isoMuGroup_value)

        #print "making isoMuPass"
        self.isoMuPass_branch = the_tree.GetBranch("isoMuPass")
        #if not self.isoMuPass_branch and "isoMuPass" not in self.complained:
        if not self.isoMuPass_branch and "isoMuPass":
            warnings.warn( "MuMuMuTauTree: Expected branch isoMuPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("isoMuPass")
        else:
            self.isoMuPass_branch.SetAddress(<void*>&self.isoMuPass_value)

        #print "making isoMuPrescale"
        self.isoMuPrescale_branch = the_tree.GetBranch("isoMuPrescale")
        #if not self.isoMuPrescale_branch and "isoMuPrescale" not in self.complained:
        if not self.isoMuPrescale_branch and "isoMuPrescale":
            warnings.warn( "MuMuMuTauTree: Expected branch isoMuPrescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("isoMuPrescale")
        else:
            self.isoMuPrescale_branch.SetAddress(<void*>&self.isoMuPrescale_value)

        #print "making isoMuTauGroup"
        self.isoMuTauGroup_branch = the_tree.GetBranch("isoMuTauGroup")
        #if not self.isoMuTauGroup_branch and "isoMuTauGroup" not in self.complained:
        if not self.isoMuTauGroup_branch and "isoMuTauGroup":
            warnings.warn( "MuMuMuTauTree: Expected branch isoMuTauGroup does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("isoMuTauGroup")
        else:
            self.isoMuTauGroup_branch.SetAddress(<void*>&self.isoMuTauGroup_value)

        #print "making isoMuTauPass"
        self.isoMuTauPass_branch = the_tree.GetBranch("isoMuTauPass")
        #if not self.isoMuTauPass_branch and "isoMuTauPass" not in self.complained:
        if not self.isoMuTauPass_branch and "isoMuTauPass":
            warnings.warn( "MuMuMuTauTree: Expected branch isoMuTauPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("isoMuTauPass")
        else:
            self.isoMuTauPass_branch.SetAddress(<void*>&self.isoMuTauPass_value)

        #print "making isoMuTauPrescale"
        self.isoMuTauPrescale_branch = the_tree.GetBranch("isoMuTauPrescale")
        #if not self.isoMuTauPrescale_branch and "isoMuTauPrescale" not in self.complained:
        if not self.isoMuTauPrescale_branch and "isoMuTauPrescale":
            warnings.warn( "MuMuMuTauTree: Expected branch isoMuTauPrescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("isoMuTauPrescale")
        else:
            self.isoMuTauPrescale_branch.SetAddress(<void*>&self.isoMuTauPrescale_value)

        #print "making jetVeto20"
        self.jetVeto20_branch = the_tree.GetBranch("jetVeto20")
        #if not self.jetVeto20_branch and "jetVeto20" not in self.complained:
        if not self.jetVeto20_branch and "jetVeto20":
            warnings.warn( "MuMuMuTauTree: Expected branch jetVeto20 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto20")
        else:
            self.jetVeto20_branch.SetAddress(<void*>&self.jetVeto20_value)

        #print "making jetVeto20_DR05"
        self.jetVeto20_DR05_branch = the_tree.GetBranch("jetVeto20_DR05")
        #if not self.jetVeto20_DR05_branch and "jetVeto20_DR05" not in self.complained:
        if not self.jetVeto20_DR05_branch and "jetVeto20_DR05":
            warnings.warn( "MuMuMuTauTree: Expected branch jetVeto20_DR05 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto20_DR05")
        else:
            self.jetVeto20_DR05_branch.SetAddress(<void*>&self.jetVeto20_DR05_value)

        #print "making jetVeto30"
        self.jetVeto30_branch = the_tree.GetBranch("jetVeto30")
        #if not self.jetVeto30_branch and "jetVeto30" not in self.complained:
        if not self.jetVeto30_branch and "jetVeto30":
            warnings.warn( "MuMuMuTauTree: Expected branch jetVeto30 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30")
        else:
            self.jetVeto30_branch.SetAddress(<void*>&self.jetVeto30_value)

        #print "making jetVeto30_DR05"
        self.jetVeto30_DR05_branch = the_tree.GetBranch("jetVeto30_DR05")
        #if not self.jetVeto30_DR05_branch and "jetVeto30_DR05" not in self.complained:
        if not self.jetVeto30_DR05_branch and "jetVeto30_DR05":
            warnings.warn( "MuMuMuTauTree: Expected branch jetVeto30_DR05 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_DR05")
        else:
            self.jetVeto30_DR05_branch.SetAddress(<void*>&self.jetVeto30_DR05_value)

        #print "making jetVeto40"
        self.jetVeto40_branch = the_tree.GetBranch("jetVeto40")
        #if not self.jetVeto40_branch and "jetVeto40" not in self.complained:
        if not self.jetVeto40_branch and "jetVeto40":
            warnings.warn( "MuMuMuTauTree: Expected branch jetVeto40 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto40")
        else:
            self.jetVeto40_branch.SetAddress(<void*>&self.jetVeto40_value)

        #print "making jetVeto40_DR05"
        self.jetVeto40_DR05_branch = the_tree.GetBranch("jetVeto40_DR05")
        #if not self.jetVeto40_DR05_branch and "jetVeto40_DR05" not in self.complained:
        if not self.jetVeto40_DR05_branch and "jetVeto40_DR05":
            warnings.warn( "MuMuMuTauTree: Expected branch jetVeto40_DR05 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto40_DR05")
        else:
            self.jetVeto40_DR05_branch.SetAddress(<void*>&self.jetVeto40_DR05_value)

        #print "making lumi"
        self.lumi_branch = the_tree.GetBranch("lumi")
        #if not self.lumi_branch and "lumi" not in self.complained:
        if not self.lumi_branch and "lumi":
            warnings.warn( "MuMuMuTauTree: Expected branch lumi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lumi")
        else:
            self.lumi_branch.SetAddress(<void*>&self.lumi_value)

        #print "making m1AbsEta"
        self.m1AbsEta_branch = the_tree.GetBranch("m1AbsEta")
        #if not self.m1AbsEta_branch and "m1AbsEta" not in self.complained:
        if not self.m1AbsEta_branch and "m1AbsEta":
            warnings.warn( "MuMuMuTauTree: Expected branch m1AbsEta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1AbsEta")
        else:
            self.m1AbsEta_branch.SetAddress(<void*>&self.m1AbsEta_value)

        #print "making m1Charge"
        self.m1Charge_branch = the_tree.GetBranch("m1Charge")
        #if not self.m1Charge_branch and "m1Charge" not in self.complained:
        if not self.m1Charge_branch and "m1Charge":
            warnings.warn( "MuMuMuTauTree: Expected branch m1Charge does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1Charge")
        else:
            self.m1Charge_branch.SetAddress(<void*>&self.m1Charge_value)

        #print "making m1ComesFromHiggs"
        self.m1ComesFromHiggs_branch = the_tree.GetBranch("m1ComesFromHiggs")
        #if not self.m1ComesFromHiggs_branch and "m1ComesFromHiggs" not in self.complained:
        if not self.m1ComesFromHiggs_branch and "m1ComesFromHiggs":
            warnings.warn( "MuMuMuTauTree: Expected branch m1ComesFromHiggs does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1ComesFromHiggs")
        else:
            self.m1ComesFromHiggs_branch.SetAddress(<void*>&self.m1ComesFromHiggs_value)

        #print "making m1D0"
        self.m1D0_branch = the_tree.GetBranch("m1D0")
        #if not self.m1D0_branch and "m1D0" not in self.complained:
        if not self.m1D0_branch and "m1D0":
            warnings.warn( "MuMuMuTauTree: Expected branch m1D0 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1D0")
        else:
            self.m1D0_branch.SetAddress(<void*>&self.m1D0_value)

        #print "making m1DZ"
        self.m1DZ_branch = the_tree.GetBranch("m1DZ")
        #if not self.m1DZ_branch and "m1DZ" not in self.complained:
        if not self.m1DZ_branch and "m1DZ":
            warnings.warn( "MuMuMuTauTree: Expected branch m1DZ does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1DZ")
        else:
            self.m1DZ_branch.SetAddress(<void*>&self.m1DZ_value)

        #print "making m1DiMuonL3PreFiltered7"
        self.m1DiMuonL3PreFiltered7_branch = the_tree.GetBranch("m1DiMuonL3PreFiltered7")
        #if not self.m1DiMuonL3PreFiltered7_branch and "m1DiMuonL3PreFiltered7" not in self.complained:
        if not self.m1DiMuonL3PreFiltered7_branch and "m1DiMuonL3PreFiltered7":
            warnings.warn( "MuMuMuTauTree: Expected branch m1DiMuonL3PreFiltered7 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1DiMuonL3PreFiltered7")
        else:
            self.m1DiMuonL3PreFiltered7_branch.SetAddress(<void*>&self.m1DiMuonL3PreFiltered7_value)

        #print "making m1DiMuonL3p5PreFiltered8"
        self.m1DiMuonL3p5PreFiltered8_branch = the_tree.GetBranch("m1DiMuonL3p5PreFiltered8")
        #if not self.m1DiMuonL3p5PreFiltered8_branch and "m1DiMuonL3p5PreFiltered8" not in self.complained:
        if not self.m1DiMuonL3p5PreFiltered8_branch and "m1DiMuonL3p5PreFiltered8":
            warnings.warn( "MuMuMuTauTree: Expected branch m1DiMuonL3p5PreFiltered8 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1DiMuonL3p5PreFiltered8")
        else:
            self.m1DiMuonL3p5PreFiltered8_branch.SetAddress(<void*>&self.m1DiMuonL3p5PreFiltered8_value)

        #print "making m1DiMuonMu17Mu8DzFiltered0p2"
        self.m1DiMuonMu17Mu8DzFiltered0p2_branch = the_tree.GetBranch("m1DiMuonMu17Mu8DzFiltered0p2")
        #if not self.m1DiMuonMu17Mu8DzFiltered0p2_branch and "m1DiMuonMu17Mu8DzFiltered0p2" not in self.complained:
        if not self.m1DiMuonMu17Mu8DzFiltered0p2_branch and "m1DiMuonMu17Mu8DzFiltered0p2":
            warnings.warn( "MuMuMuTauTree: Expected branch m1DiMuonMu17Mu8DzFiltered0p2 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1DiMuonMu17Mu8DzFiltered0p2")
        else:
            self.m1DiMuonMu17Mu8DzFiltered0p2_branch.SetAddress(<void*>&self.m1DiMuonMu17Mu8DzFiltered0p2_value)

        #print "making m1EErrRochCor2011A"
        self.m1EErrRochCor2011A_branch = the_tree.GetBranch("m1EErrRochCor2011A")
        #if not self.m1EErrRochCor2011A_branch and "m1EErrRochCor2011A" not in self.complained:
        if not self.m1EErrRochCor2011A_branch and "m1EErrRochCor2011A":
            warnings.warn( "MuMuMuTauTree: Expected branch m1EErrRochCor2011A does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1EErrRochCor2011A")
        else:
            self.m1EErrRochCor2011A_branch.SetAddress(<void*>&self.m1EErrRochCor2011A_value)

        #print "making m1EErrRochCor2011B"
        self.m1EErrRochCor2011B_branch = the_tree.GetBranch("m1EErrRochCor2011B")
        #if not self.m1EErrRochCor2011B_branch and "m1EErrRochCor2011B" not in self.complained:
        if not self.m1EErrRochCor2011B_branch and "m1EErrRochCor2011B":
            warnings.warn( "MuMuMuTauTree: Expected branch m1EErrRochCor2011B does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1EErrRochCor2011B")
        else:
            self.m1EErrRochCor2011B_branch.SetAddress(<void*>&self.m1EErrRochCor2011B_value)

        #print "making m1EErrRochCor2012"
        self.m1EErrRochCor2012_branch = the_tree.GetBranch("m1EErrRochCor2012")
        #if not self.m1EErrRochCor2012_branch and "m1EErrRochCor2012" not in self.complained:
        if not self.m1EErrRochCor2012_branch and "m1EErrRochCor2012":
            warnings.warn( "MuMuMuTauTree: Expected branch m1EErrRochCor2012 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1EErrRochCor2012")
        else:
            self.m1EErrRochCor2012_branch.SetAddress(<void*>&self.m1EErrRochCor2012_value)

        #print "making m1ERochCor2011A"
        self.m1ERochCor2011A_branch = the_tree.GetBranch("m1ERochCor2011A")
        #if not self.m1ERochCor2011A_branch and "m1ERochCor2011A" not in self.complained:
        if not self.m1ERochCor2011A_branch and "m1ERochCor2011A":
            warnings.warn( "MuMuMuTauTree: Expected branch m1ERochCor2011A does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1ERochCor2011A")
        else:
            self.m1ERochCor2011A_branch.SetAddress(<void*>&self.m1ERochCor2011A_value)

        #print "making m1ERochCor2011B"
        self.m1ERochCor2011B_branch = the_tree.GetBranch("m1ERochCor2011B")
        #if not self.m1ERochCor2011B_branch and "m1ERochCor2011B" not in self.complained:
        if not self.m1ERochCor2011B_branch and "m1ERochCor2011B":
            warnings.warn( "MuMuMuTauTree: Expected branch m1ERochCor2011B does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1ERochCor2011B")
        else:
            self.m1ERochCor2011B_branch.SetAddress(<void*>&self.m1ERochCor2011B_value)

        #print "making m1ERochCor2012"
        self.m1ERochCor2012_branch = the_tree.GetBranch("m1ERochCor2012")
        #if not self.m1ERochCor2012_branch and "m1ERochCor2012" not in self.complained:
        if not self.m1ERochCor2012_branch and "m1ERochCor2012":
            warnings.warn( "MuMuMuTauTree: Expected branch m1ERochCor2012 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1ERochCor2012")
        else:
            self.m1ERochCor2012_branch.SetAddress(<void*>&self.m1ERochCor2012_value)

        #print "making m1EffectiveArea2011"
        self.m1EffectiveArea2011_branch = the_tree.GetBranch("m1EffectiveArea2011")
        #if not self.m1EffectiveArea2011_branch and "m1EffectiveArea2011" not in self.complained:
        if not self.m1EffectiveArea2011_branch and "m1EffectiveArea2011":
            warnings.warn( "MuMuMuTauTree: Expected branch m1EffectiveArea2011 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1EffectiveArea2011")
        else:
            self.m1EffectiveArea2011_branch.SetAddress(<void*>&self.m1EffectiveArea2011_value)

        #print "making m1EffectiveArea2012"
        self.m1EffectiveArea2012_branch = the_tree.GetBranch("m1EffectiveArea2012")
        #if not self.m1EffectiveArea2012_branch and "m1EffectiveArea2012" not in self.complained:
        if not self.m1EffectiveArea2012_branch and "m1EffectiveArea2012":
            warnings.warn( "MuMuMuTauTree: Expected branch m1EffectiveArea2012 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1EffectiveArea2012")
        else:
            self.m1EffectiveArea2012_branch.SetAddress(<void*>&self.m1EffectiveArea2012_value)

        #print "making m1Eta"
        self.m1Eta_branch = the_tree.GetBranch("m1Eta")
        #if not self.m1Eta_branch and "m1Eta" not in self.complained:
        if not self.m1Eta_branch and "m1Eta":
            warnings.warn( "MuMuMuTauTree: Expected branch m1Eta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1Eta")
        else:
            self.m1Eta_branch.SetAddress(<void*>&self.m1Eta_value)

        #print "making m1EtaRochCor2011A"
        self.m1EtaRochCor2011A_branch = the_tree.GetBranch("m1EtaRochCor2011A")
        #if not self.m1EtaRochCor2011A_branch and "m1EtaRochCor2011A" not in self.complained:
        if not self.m1EtaRochCor2011A_branch and "m1EtaRochCor2011A":
            warnings.warn( "MuMuMuTauTree: Expected branch m1EtaRochCor2011A does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1EtaRochCor2011A")
        else:
            self.m1EtaRochCor2011A_branch.SetAddress(<void*>&self.m1EtaRochCor2011A_value)

        #print "making m1EtaRochCor2011B"
        self.m1EtaRochCor2011B_branch = the_tree.GetBranch("m1EtaRochCor2011B")
        #if not self.m1EtaRochCor2011B_branch and "m1EtaRochCor2011B" not in self.complained:
        if not self.m1EtaRochCor2011B_branch and "m1EtaRochCor2011B":
            warnings.warn( "MuMuMuTauTree: Expected branch m1EtaRochCor2011B does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1EtaRochCor2011B")
        else:
            self.m1EtaRochCor2011B_branch.SetAddress(<void*>&self.m1EtaRochCor2011B_value)

        #print "making m1EtaRochCor2012"
        self.m1EtaRochCor2012_branch = the_tree.GetBranch("m1EtaRochCor2012")
        #if not self.m1EtaRochCor2012_branch and "m1EtaRochCor2012" not in self.complained:
        if not self.m1EtaRochCor2012_branch and "m1EtaRochCor2012":
            warnings.warn( "MuMuMuTauTree: Expected branch m1EtaRochCor2012 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1EtaRochCor2012")
        else:
            self.m1EtaRochCor2012_branch.SetAddress(<void*>&self.m1EtaRochCor2012_value)

        #print "making m1GenCharge"
        self.m1GenCharge_branch = the_tree.GetBranch("m1GenCharge")
        #if not self.m1GenCharge_branch and "m1GenCharge" not in self.complained:
        if not self.m1GenCharge_branch and "m1GenCharge":
            warnings.warn( "MuMuMuTauTree: Expected branch m1GenCharge does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1GenCharge")
        else:
            self.m1GenCharge_branch.SetAddress(<void*>&self.m1GenCharge_value)

        #print "making m1GenEnergy"
        self.m1GenEnergy_branch = the_tree.GetBranch("m1GenEnergy")
        #if not self.m1GenEnergy_branch and "m1GenEnergy" not in self.complained:
        if not self.m1GenEnergy_branch and "m1GenEnergy":
            warnings.warn( "MuMuMuTauTree: Expected branch m1GenEnergy does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1GenEnergy")
        else:
            self.m1GenEnergy_branch.SetAddress(<void*>&self.m1GenEnergy_value)

        #print "making m1GenEta"
        self.m1GenEta_branch = the_tree.GetBranch("m1GenEta")
        #if not self.m1GenEta_branch and "m1GenEta" not in self.complained:
        if not self.m1GenEta_branch and "m1GenEta":
            warnings.warn( "MuMuMuTauTree: Expected branch m1GenEta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1GenEta")
        else:
            self.m1GenEta_branch.SetAddress(<void*>&self.m1GenEta_value)

        #print "making m1GenMotherPdgId"
        self.m1GenMotherPdgId_branch = the_tree.GetBranch("m1GenMotherPdgId")
        #if not self.m1GenMotherPdgId_branch and "m1GenMotherPdgId" not in self.complained:
        if not self.m1GenMotherPdgId_branch and "m1GenMotherPdgId":
            warnings.warn( "MuMuMuTauTree: Expected branch m1GenMotherPdgId does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1GenMotherPdgId")
        else:
            self.m1GenMotherPdgId_branch.SetAddress(<void*>&self.m1GenMotherPdgId_value)

        #print "making m1GenPdgId"
        self.m1GenPdgId_branch = the_tree.GetBranch("m1GenPdgId")
        #if not self.m1GenPdgId_branch and "m1GenPdgId" not in self.complained:
        if not self.m1GenPdgId_branch and "m1GenPdgId":
            warnings.warn( "MuMuMuTauTree: Expected branch m1GenPdgId does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1GenPdgId")
        else:
            self.m1GenPdgId_branch.SetAddress(<void*>&self.m1GenPdgId_value)

        #print "making m1GenPhi"
        self.m1GenPhi_branch = the_tree.GetBranch("m1GenPhi")
        #if not self.m1GenPhi_branch and "m1GenPhi" not in self.complained:
        if not self.m1GenPhi_branch and "m1GenPhi":
            warnings.warn( "MuMuMuTauTree: Expected branch m1GenPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1GenPhi")
        else:
            self.m1GenPhi_branch.SetAddress(<void*>&self.m1GenPhi_value)

        #print "making m1GlbTrkHits"
        self.m1GlbTrkHits_branch = the_tree.GetBranch("m1GlbTrkHits")
        #if not self.m1GlbTrkHits_branch and "m1GlbTrkHits" not in self.complained:
        if not self.m1GlbTrkHits_branch and "m1GlbTrkHits":
            warnings.warn( "MuMuMuTauTree: Expected branch m1GlbTrkHits does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1GlbTrkHits")
        else:
            self.m1GlbTrkHits_branch.SetAddress(<void*>&self.m1GlbTrkHits_value)

        #print "making m1IDHZG2011"
        self.m1IDHZG2011_branch = the_tree.GetBranch("m1IDHZG2011")
        #if not self.m1IDHZG2011_branch and "m1IDHZG2011" not in self.complained:
        if not self.m1IDHZG2011_branch and "m1IDHZG2011":
            warnings.warn( "MuMuMuTauTree: Expected branch m1IDHZG2011 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1IDHZG2011")
        else:
            self.m1IDHZG2011_branch.SetAddress(<void*>&self.m1IDHZG2011_value)

        #print "making m1IDHZG2012"
        self.m1IDHZG2012_branch = the_tree.GetBranch("m1IDHZG2012")
        #if not self.m1IDHZG2012_branch and "m1IDHZG2012" not in self.complained:
        if not self.m1IDHZG2012_branch and "m1IDHZG2012":
            warnings.warn( "MuMuMuTauTree: Expected branch m1IDHZG2012 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1IDHZG2012")
        else:
            self.m1IDHZG2012_branch.SetAddress(<void*>&self.m1IDHZG2012_value)

        #print "making m1IP3DS"
        self.m1IP3DS_branch = the_tree.GetBranch("m1IP3DS")
        #if not self.m1IP3DS_branch and "m1IP3DS" not in self.complained:
        if not self.m1IP3DS_branch and "m1IP3DS":
            warnings.warn( "MuMuMuTauTree: Expected branch m1IP3DS does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1IP3DS")
        else:
            self.m1IP3DS_branch.SetAddress(<void*>&self.m1IP3DS_value)

        #print "making m1IsGlobal"
        self.m1IsGlobal_branch = the_tree.GetBranch("m1IsGlobal")
        #if not self.m1IsGlobal_branch and "m1IsGlobal" not in self.complained:
        if not self.m1IsGlobal_branch and "m1IsGlobal":
            warnings.warn( "MuMuMuTauTree: Expected branch m1IsGlobal does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1IsGlobal")
        else:
            self.m1IsGlobal_branch.SetAddress(<void*>&self.m1IsGlobal_value)

        #print "making m1IsPFMuon"
        self.m1IsPFMuon_branch = the_tree.GetBranch("m1IsPFMuon")
        #if not self.m1IsPFMuon_branch and "m1IsPFMuon" not in self.complained:
        if not self.m1IsPFMuon_branch and "m1IsPFMuon":
            warnings.warn( "MuMuMuTauTree: Expected branch m1IsPFMuon does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1IsPFMuon")
        else:
            self.m1IsPFMuon_branch.SetAddress(<void*>&self.m1IsPFMuon_value)

        #print "making m1IsTracker"
        self.m1IsTracker_branch = the_tree.GetBranch("m1IsTracker")
        #if not self.m1IsTracker_branch and "m1IsTracker" not in self.complained:
        if not self.m1IsTracker_branch and "m1IsTracker":
            warnings.warn( "MuMuMuTauTree: Expected branch m1IsTracker does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1IsTracker")
        else:
            self.m1IsTracker_branch.SetAddress(<void*>&self.m1IsTracker_value)

        #print "making m1JetArea"
        self.m1JetArea_branch = the_tree.GetBranch("m1JetArea")
        #if not self.m1JetArea_branch and "m1JetArea" not in self.complained:
        if not self.m1JetArea_branch and "m1JetArea":
            warnings.warn( "MuMuMuTauTree: Expected branch m1JetArea does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1JetArea")
        else:
            self.m1JetArea_branch.SetAddress(<void*>&self.m1JetArea_value)

        #print "making m1JetBtag"
        self.m1JetBtag_branch = the_tree.GetBranch("m1JetBtag")
        #if not self.m1JetBtag_branch and "m1JetBtag" not in self.complained:
        if not self.m1JetBtag_branch and "m1JetBtag":
            warnings.warn( "MuMuMuTauTree: Expected branch m1JetBtag does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1JetBtag")
        else:
            self.m1JetBtag_branch.SetAddress(<void*>&self.m1JetBtag_value)

        #print "making m1JetCSVBtag"
        self.m1JetCSVBtag_branch = the_tree.GetBranch("m1JetCSVBtag")
        #if not self.m1JetCSVBtag_branch and "m1JetCSVBtag" not in self.complained:
        if not self.m1JetCSVBtag_branch and "m1JetCSVBtag":
            warnings.warn( "MuMuMuTauTree: Expected branch m1JetCSVBtag does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1JetCSVBtag")
        else:
            self.m1JetCSVBtag_branch.SetAddress(<void*>&self.m1JetCSVBtag_value)

        #print "making m1JetEtaEtaMoment"
        self.m1JetEtaEtaMoment_branch = the_tree.GetBranch("m1JetEtaEtaMoment")
        #if not self.m1JetEtaEtaMoment_branch and "m1JetEtaEtaMoment" not in self.complained:
        if not self.m1JetEtaEtaMoment_branch and "m1JetEtaEtaMoment":
            warnings.warn( "MuMuMuTauTree: Expected branch m1JetEtaEtaMoment does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1JetEtaEtaMoment")
        else:
            self.m1JetEtaEtaMoment_branch.SetAddress(<void*>&self.m1JetEtaEtaMoment_value)

        #print "making m1JetEtaPhiMoment"
        self.m1JetEtaPhiMoment_branch = the_tree.GetBranch("m1JetEtaPhiMoment")
        #if not self.m1JetEtaPhiMoment_branch and "m1JetEtaPhiMoment" not in self.complained:
        if not self.m1JetEtaPhiMoment_branch and "m1JetEtaPhiMoment":
            warnings.warn( "MuMuMuTauTree: Expected branch m1JetEtaPhiMoment does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1JetEtaPhiMoment")
        else:
            self.m1JetEtaPhiMoment_branch.SetAddress(<void*>&self.m1JetEtaPhiMoment_value)

        #print "making m1JetEtaPhiSpread"
        self.m1JetEtaPhiSpread_branch = the_tree.GetBranch("m1JetEtaPhiSpread")
        #if not self.m1JetEtaPhiSpread_branch and "m1JetEtaPhiSpread" not in self.complained:
        if not self.m1JetEtaPhiSpread_branch and "m1JetEtaPhiSpread":
            warnings.warn( "MuMuMuTauTree: Expected branch m1JetEtaPhiSpread does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1JetEtaPhiSpread")
        else:
            self.m1JetEtaPhiSpread_branch.SetAddress(<void*>&self.m1JetEtaPhiSpread_value)

        #print "making m1JetPartonFlavour"
        self.m1JetPartonFlavour_branch = the_tree.GetBranch("m1JetPartonFlavour")
        #if not self.m1JetPartonFlavour_branch and "m1JetPartonFlavour" not in self.complained:
        if not self.m1JetPartonFlavour_branch and "m1JetPartonFlavour":
            warnings.warn( "MuMuMuTauTree: Expected branch m1JetPartonFlavour does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1JetPartonFlavour")
        else:
            self.m1JetPartonFlavour_branch.SetAddress(<void*>&self.m1JetPartonFlavour_value)

        #print "making m1JetPhiPhiMoment"
        self.m1JetPhiPhiMoment_branch = the_tree.GetBranch("m1JetPhiPhiMoment")
        #if not self.m1JetPhiPhiMoment_branch and "m1JetPhiPhiMoment" not in self.complained:
        if not self.m1JetPhiPhiMoment_branch and "m1JetPhiPhiMoment":
            warnings.warn( "MuMuMuTauTree: Expected branch m1JetPhiPhiMoment does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1JetPhiPhiMoment")
        else:
            self.m1JetPhiPhiMoment_branch.SetAddress(<void*>&self.m1JetPhiPhiMoment_value)

        #print "making m1JetPt"
        self.m1JetPt_branch = the_tree.GetBranch("m1JetPt")
        #if not self.m1JetPt_branch and "m1JetPt" not in self.complained:
        if not self.m1JetPt_branch and "m1JetPt":
            warnings.warn( "MuMuMuTauTree: Expected branch m1JetPt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1JetPt")
        else:
            self.m1JetPt_branch.SetAddress(<void*>&self.m1JetPt_value)

        #print "making m1JetQGLikelihoodID"
        self.m1JetQGLikelihoodID_branch = the_tree.GetBranch("m1JetQGLikelihoodID")
        #if not self.m1JetQGLikelihoodID_branch and "m1JetQGLikelihoodID" not in self.complained:
        if not self.m1JetQGLikelihoodID_branch and "m1JetQGLikelihoodID":
            warnings.warn( "MuMuMuTauTree: Expected branch m1JetQGLikelihoodID does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1JetQGLikelihoodID")
        else:
            self.m1JetQGLikelihoodID_branch.SetAddress(<void*>&self.m1JetQGLikelihoodID_value)

        #print "making m1JetQGMVAID"
        self.m1JetQGMVAID_branch = the_tree.GetBranch("m1JetQGMVAID")
        #if not self.m1JetQGMVAID_branch and "m1JetQGMVAID" not in self.complained:
        if not self.m1JetQGMVAID_branch and "m1JetQGMVAID":
            warnings.warn( "MuMuMuTauTree: Expected branch m1JetQGMVAID does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1JetQGMVAID")
        else:
            self.m1JetQGMVAID_branch.SetAddress(<void*>&self.m1JetQGMVAID_value)

        #print "making m1Jetaxis1"
        self.m1Jetaxis1_branch = the_tree.GetBranch("m1Jetaxis1")
        #if not self.m1Jetaxis1_branch and "m1Jetaxis1" not in self.complained:
        if not self.m1Jetaxis1_branch and "m1Jetaxis1":
            warnings.warn( "MuMuMuTauTree: Expected branch m1Jetaxis1 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1Jetaxis1")
        else:
            self.m1Jetaxis1_branch.SetAddress(<void*>&self.m1Jetaxis1_value)

        #print "making m1Jetaxis2"
        self.m1Jetaxis2_branch = the_tree.GetBranch("m1Jetaxis2")
        #if not self.m1Jetaxis2_branch and "m1Jetaxis2" not in self.complained:
        if not self.m1Jetaxis2_branch and "m1Jetaxis2":
            warnings.warn( "MuMuMuTauTree: Expected branch m1Jetaxis2 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1Jetaxis2")
        else:
            self.m1Jetaxis2_branch.SetAddress(<void*>&self.m1Jetaxis2_value)

        #print "making m1Jetmult"
        self.m1Jetmult_branch = the_tree.GetBranch("m1Jetmult")
        #if not self.m1Jetmult_branch and "m1Jetmult" not in self.complained:
        if not self.m1Jetmult_branch and "m1Jetmult":
            warnings.warn( "MuMuMuTauTree: Expected branch m1Jetmult does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1Jetmult")
        else:
            self.m1Jetmult_branch.SetAddress(<void*>&self.m1Jetmult_value)

        #print "making m1JetmultMLP"
        self.m1JetmultMLP_branch = the_tree.GetBranch("m1JetmultMLP")
        #if not self.m1JetmultMLP_branch and "m1JetmultMLP" not in self.complained:
        if not self.m1JetmultMLP_branch and "m1JetmultMLP":
            warnings.warn( "MuMuMuTauTree: Expected branch m1JetmultMLP does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1JetmultMLP")
        else:
            self.m1JetmultMLP_branch.SetAddress(<void*>&self.m1JetmultMLP_value)

        #print "making m1JetmultMLPQC"
        self.m1JetmultMLPQC_branch = the_tree.GetBranch("m1JetmultMLPQC")
        #if not self.m1JetmultMLPQC_branch and "m1JetmultMLPQC" not in self.complained:
        if not self.m1JetmultMLPQC_branch and "m1JetmultMLPQC":
            warnings.warn( "MuMuMuTauTree: Expected branch m1JetmultMLPQC does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1JetmultMLPQC")
        else:
            self.m1JetmultMLPQC_branch.SetAddress(<void*>&self.m1JetmultMLPQC_value)

        #print "making m1JetptD"
        self.m1JetptD_branch = the_tree.GetBranch("m1JetptD")
        #if not self.m1JetptD_branch and "m1JetptD" not in self.complained:
        if not self.m1JetptD_branch and "m1JetptD":
            warnings.warn( "MuMuMuTauTree: Expected branch m1JetptD does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1JetptD")
        else:
            self.m1JetptD_branch.SetAddress(<void*>&self.m1JetptD_value)

        #print "making m1L1Mu3EG5L3Filtered17"
        self.m1L1Mu3EG5L3Filtered17_branch = the_tree.GetBranch("m1L1Mu3EG5L3Filtered17")
        #if not self.m1L1Mu3EG5L3Filtered17_branch and "m1L1Mu3EG5L3Filtered17" not in self.complained:
        if not self.m1L1Mu3EG5L3Filtered17_branch and "m1L1Mu3EG5L3Filtered17":
            warnings.warn( "MuMuMuTauTree: Expected branch m1L1Mu3EG5L3Filtered17 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1L1Mu3EG5L3Filtered17")
        else:
            self.m1L1Mu3EG5L3Filtered17_branch.SetAddress(<void*>&self.m1L1Mu3EG5L3Filtered17_value)

        #print "making m1L3fL1DoubleMu10MuOpenL1f0L2f10L3Filtered17"
        self.m1L3fL1DoubleMu10MuOpenL1f0L2f10L3Filtered17_branch = the_tree.GetBranch("m1L3fL1DoubleMu10MuOpenL1f0L2f10L3Filtered17")
        #if not self.m1L3fL1DoubleMu10MuOpenL1f0L2f10L3Filtered17_branch and "m1L3fL1DoubleMu10MuOpenL1f0L2f10L3Filtered17" not in self.complained:
        if not self.m1L3fL1DoubleMu10MuOpenL1f0L2f10L3Filtered17_branch and "m1L3fL1DoubleMu10MuOpenL1f0L2f10L3Filtered17":
            warnings.warn( "MuMuMuTauTree: Expected branch m1L3fL1DoubleMu10MuOpenL1f0L2f10L3Filtered17 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1L3fL1DoubleMu10MuOpenL1f0L2f10L3Filtered17")
        else:
            self.m1L3fL1DoubleMu10MuOpenL1f0L2f10L3Filtered17_branch.SetAddress(<void*>&self.m1L3fL1DoubleMu10MuOpenL1f0L2f10L3Filtered17_value)

        #print "making m1Mass"
        self.m1Mass_branch = the_tree.GetBranch("m1Mass")
        #if not self.m1Mass_branch and "m1Mass" not in self.complained:
        if not self.m1Mass_branch and "m1Mass":
            warnings.warn( "MuMuMuTauTree: Expected branch m1Mass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1Mass")
        else:
            self.m1Mass_branch.SetAddress(<void*>&self.m1Mass_value)

        #print "making m1MatchedStations"
        self.m1MatchedStations_branch = the_tree.GetBranch("m1MatchedStations")
        #if not self.m1MatchedStations_branch and "m1MatchedStations" not in self.complained:
        if not self.m1MatchedStations_branch and "m1MatchedStations":
            warnings.warn( "MuMuMuTauTree: Expected branch m1MatchedStations does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1MatchedStations")
        else:
            self.m1MatchedStations_branch.SetAddress(<void*>&self.m1MatchedStations_value)

        #print "making m1MatchesDoubleMuPaths"
        self.m1MatchesDoubleMuPaths_branch = the_tree.GetBranch("m1MatchesDoubleMuPaths")
        #if not self.m1MatchesDoubleMuPaths_branch and "m1MatchesDoubleMuPaths" not in self.complained:
        if not self.m1MatchesDoubleMuPaths_branch and "m1MatchesDoubleMuPaths":
            warnings.warn( "MuMuMuTauTree: Expected branch m1MatchesDoubleMuPaths does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1MatchesDoubleMuPaths")
        else:
            self.m1MatchesDoubleMuPaths_branch.SetAddress(<void*>&self.m1MatchesDoubleMuPaths_value)

        #print "making m1MatchesDoubleMuTrkPaths"
        self.m1MatchesDoubleMuTrkPaths_branch = the_tree.GetBranch("m1MatchesDoubleMuTrkPaths")
        #if not self.m1MatchesDoubleMuTrkPaths_branch and "m1MatchesDoubleMuTrkPaths" not in self.complained:
        if not self.m1MatchesDoubleMuTrkPaths_branch and "m1MatchesDoubleMuTrkPaths":
            warnings.warn( "MuMuMuTauTree: Expected branch m1MatchesDoubleMuTrkPaths does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1MatchesDoubleMuTrkPaths")
        else:
            self.m1MatchesDoubleMuTrkPaths_branch.SetAddress(<void*>&self.m1MatchesDoubleMuTrkPaths_value)

        #print "making m1MatchesIsoMu24eta2p1"
        self.m1MatchesIsoMu24eta2p1_branch = the_tree.GetBranch("m1MatchesIsoMu24eta2p1")
        #if not self.m1MatchesIsoMu24eta2p1_branch and "m1MatchesIsoMu24eta2p1" not in self.complained:
        if not self.m1MatchesIsoMu24eta2p1_branch and "m1MatchesIsoMu24eta2p1":
            warnings.warn( "MuMuMuTauTree: Expected branch m1MatchesIsoMu24eta2p1 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1MatchesIsoMu24eta2p1")
        else:
            self.m1MatchesIsoMu24eta2p1_branch.SetAddress(<void*>&self.m1MatchesIsoMu24eta2p1_value)

        #print "making m1MatchesIsoMuGroup"
        self.m1MatchesIsoMuGroup_branch = the_tree.GetBranch("m1MatchesIsoMuGroup")
        #if not self.m1MatchesIsoMuGroup_branch and "m1MatchesIsoMuGroup" not in self.complained:
        if not self.m1MatchesIsoMuGroup_branch and "m1MatchesIsoMuGroup":
            warnings.warn( "MuMuMuTauTree: Expected branch m1MatchesIsoMuGroup does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1MatchesIsoMuGroup")
        else:
            self.m1MatchesIsoMuGroup_branch.SetAddress(<void*>&self.m1MatchesIsoMuGroup_value)

        #print "making m1MatchesMu17Ele8IsoPath"
        self.m1MatchesMu17Ele8IsoPath_branch = the_tree.GetBranch("m1MatchesMu17Ele8IsoPath")
        #if not self.m1MatchesMu17Ele8IsoPath_branch and "m1MatchesMu17Ele8IsoPath" not in self.complained:
        if not self.m1MatchesMu17Ele8IsoPath_branch and "m1MatchesMu17Ele8IsoPath":
            warnings.warn( "MuMuMuTauTree: Expected branch m1MatchesMu17Ele8IsoPath does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1MatchesMu17Ele8IsoPath")
        else:
            self.m1MatchesMu17Ele8IsoPath_branch.SetAddress(<void*>&self.m1MatchesMu17Ele8IsoPath_value)

        #print "making m1MatchesMu17Ele8Path"
        self.m1MatchesMu17Ele8Path_branch = the_tree.GetBranch("m1MatchesMu17Ele8Path")
        #if not self.m1MatchesMu17Ele8Path_branch and "m1MatchesMu17Ele8Path" not in self.complained:
        if not self.m1MatchesMu17Ele8Path_branch and "m1MatchesMu17Ele8Path":
            warnings.warn( "MuMuMuTauTree: Expected branch m1MatchesMu17Ele8Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1MatchesMu17Ele8Path")
        else:
            self.m1MatchesMu17Ele8Path_branch.SetAddress(<void*>&self.m1MatchesMu17Ele8Path_value)

        #print "making m1MatchesMu17Mu8Path"
        self.m1MatchesMu17Mu8Path_branch = the_tree.GetBranch("m1MatchesMu17Mu8Path")
        #if not self.m1MatchesMu17Mu8Path_branch and "m1MatchesMu17Mu8Path" not in self.complained:
        if not self.m1MatchesMu17Mu8Path_branch and "m1MatchesMu17Mu8Path":
            warnings.warn( "MuMuMuTauTree: Expected branch m1MatchesMu17Mu8Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1MatchesMu17Mu8Path")
        else:
            self.m1MatchesMu17Mu8Path_branch.SetAddress(<void*>&self.m1MatchesMu17Mu8Path_value)

        #print "making m1MatchesMu17TrkMu8Path"
        self.m1MatchesMu17TrkMu8Path_branch = the_tree.GetBranch("m1MatchesMu17TrkMu8Path")
        #if not self.m1MatchesMu17TrkMu8Path_branch and "m1MatchesMu17TrkMu8Path" not in self.complained:
        if not self.m1MatchesMu17TrkMu8Path_branch and "m1MatchesMu17TrkMu8Path":
            warnings.warn( "MuMuMuTauTree: Expected branch m1MatchesMu17TrkMu8Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1MatchesMu17TrkMu8Path")
        else:
            self.m1MatchesMu17TrkMu8Path_branch.SetAddress(<void*>&self.m1MatchesMu17TrkMu8Path_value)

        #print "making m1MatchesMu8Ele17IsoPath"
        self.m1MatchesMu8Ele17IsoPath_branch = the_tree.GetBranch("m1MatchesMu8Ele17IsoPath")
        #if not self.m1MatchesMu8Ele17IsoPath_branch and "m1MatchesMu8Ele17IsoPath" not in self.complained:
        if not self.m1MatchesMu8Ele17IsoPath_branch and "m1MatchesMu8Ele17IsoPath":
            warnings.warn( "MuMuMuTauTree: Expected branch m1MatchesMu8Ele17IsoPath does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1MatchesMu8Ele17IsoPath")
        else:
            self.m1MatchesMu8Ele17IsoPath_branch.SetAddress(<void*>&self.m1MatchesMu8Ele17IsoPath_value)

        #print "making m1MatchesMu8Ele17Path"
        self.m1MatchesMu8Ele17Path_branch = the_tree.GetBranch("m1MatchesMu8Ele17Path")
        #if not self.m1MatchesMu8Ele17Path_branch and "m1MatchesMu8Ele17Path" not in self.complained:
        if not self.m1MatchesMu8Ele17Path_branch and "m1MatchesMu8Ele17Path":
            warnings.warn( "MuMuMuTauTree: Expected branch m1MatchesMu8Ele17Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1MatchesMu8Ele17Path")
        else:
            self.m1MatchesMu8Ele17Path_branch.SetAddress(<void*>&self.m1MatchesMu8Ele17Path_value)

        #print "making m1MtToMET"
        self.m1MtToMET_branch = the_tree.GetBranch("m1MtToMET")
        #if not self.m1MtToMET_branch and "m1MtToMET" not in self.complained:
        if not self.m1MtToMET_branch and "m1MtToMET":
            warnings.warn( "MuMuMuTauTree: Expected branch m1MtToMET does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1MtToMET")
        else:
            self.m1MtToMET_branch.SetAddress(<void*>&self.m1MtToMET_value)

        #print "making m1MtToMVAMET"
        self.m1MtToMVAMET_branch = the_tree.GetBranch("m1MtToMVAMET")
        #if not self.m1MtToMVAMET_branch and "m1MtToMVAMET" not in self.complained:
        if not self.m1MtToMVAMET_branch and "m1MtToMVAMET":
            warnings.warn( "MuMuMuTauTree: Expected branch m1MtToMVAMET does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1MtToMVAMET")
        else:
            self.m1MtToMVAMET_branch.SetAddress(<void*>&self.m1MtToMVAMET_value)

        #print "making m1MtToPFMET"
        self.m1MtToPFMET_branch = the_tree.GetBranch("m1MtToPFMET")
        #if not self.m1MtToPFMET_branch and "m1MtToPFMET" not in self.complained:
        if not self.m1MtToPFMET_branch and "m1MtToPFMET":
            warnings.warn( "MuMuMuTauTree: Expected branch m1MtToPFMET does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1MtToPFMET")
        else:
            self.m1MtToPFMET_branch.SetAddress(<void*>&self.m1MtToPFMET_value)

        #print "making m1MtToPfMet_Ty1"
        self.m1MtToPfMet_Ty1_branch = the_tree.GetBranch("m1MtToPfMet_Ty1")
        #if not self.m1MtToPfMet_Ty1_branch and "m1MtToPfMet_Ty1" not in self.complained:
        if not self.m1MtToPfMet_Ty1_branch and "m1MtToPfMet_Ty1":
            warnings.warn( "MuMuMuTauTree: Expected branch m1MtToPfMet_Ty1 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1MtToPfMet_Ty1")
        else:
            self.m1MtToPfMet_Ty1_branch.SetAddress(<void*>&self.m1MtToPfMet_Ty1_value)

        #print "making m1MtToPfMet_jes"
        self.m1MtToPfMet_jes_branch = the_tree.GetBranch("m1MtToPfMet_jes")
        #if not self.m1MtToPfMet_jes_branch and "m1MtToPfMet_jes" not in self.complained:
        if not self.m1MtToPfMet_jes_branch and "m1MtToPfMet_jes":
            warnings.warn( "MuMuMuTauTree: Expected branch m1MtToPfMet_jes does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1MtToPfMet_jes")
        else:
            self.m1MtToPfMet_jes_branch.SetAddress(<void*>&self.m1MtToPfMet_jes_value)

        #print "making m1MtToPfMet_mes"
        self.m1MtToPfMet_mes_branch = the_tree.GetBranch("m1MtToPfMet_mes")
        #if not self.m1MtToPfMet_mes_branch and "m1MtToPfMet_mes" not in self.complained:
        if not self.m1MtToPfMet_mes_branch and "m1MtToPfMet_mes":
            warnings.warn( "MuMuMuTauTree: Expected branch m1MtToPfMet_mes does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1MtToPfMet_mes")
        else:
            self.m1MtToPfMet_mes_branch.SetAddress(<void*>&self.m1MtToPfMet_mes_value)

        #print "making m1MtToPfMet_tes"
        self.m1MtToPfMet_tes_branch = the_tree.GetBranch("m1MtToPfMet_tes")
        #if not self.m1MtToPfMet_tes_branch and "m1MtToPfMet_tes" not in self.complained:
        if not self.m1MtToPfMet_tes_branch and "m1MtToPfMet_tes":
            warnings.warn( "MuMuMuTauTree: Expected branch m1MtToPfMet_tes does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1MtToPfMet_tes")
        else:
            self.m1MtToPfMet_tes_branch.SetAddress(<void*>&self.m1MtToPfMet_tes_value)

        #print "making m1MtToPfMet_ues"
        self.m1MtToPfMet_ues_branch = the_tree.GetBranch("m1MtToPfMet_ues")
        #if not self.m1MtToPfMet_ues_branch and "m1MtToPfMet_ues" not in self.complained:
        if not self.m1MtToPfMet_ues_branch and "m1MtToPfMet_ues":
            warnings.warn( "MuMuMuTauTree: Expected branch m1MtToPfMet_ues does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1MtToPfMet_ues")
        else:
            self.m1MtToPfMet_ues_branch.SetAddress(<void*>&self.m1MtToPfMet_ues_value)

        #print "making m1Mu17Ele8dZFilter"
        self.m1Mu17Ele8dZFilter_branch = the_tree.GetBranch("m1Mu17Ele8dZFilter")
        #if not self.m1Mu17Ele8dZFilter_branch and "m1Mu17Ele8dZFilter" not in self.complained:
        if not self.m1Mu17Ele8dZFilter_branch and "m1Mu17Ele8dZFilter":
            warnings.warn( "MuMuMuTauTree: Expected branch m1Mu17Ele8dZFilter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1Mu17Ele8dZFilter")
        else:
            self.m1Mu17Ele8dZFilter_branch.SetAddress(<void*>&self.m1Mu17Ele8dZFilter_value)

        #print "making m1MuonHits"
        self.m1MuonHits_branch = the_tree.GetBranch("m1MuonHits")
        #if not self.m1MuonHits_branch and "m1MuonHits" not in self.complained:
        if not self.m1MuonHits_branch and "m1MuonHits":
            warnings.warn( "MuMuMuTauTree: Expected branch m1MuonHits does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1MuonHits")
        else:
            self.m1MuonHits_branch.SetAddress(<void*>&self.m1MuonHits_value)

        #print "making m1NormTrkChi2"
        self.m1NormTrkChi2_branch = the_tree.GetBranch("m1NormTrkChi2")
        #if not self.m1NormTrkChi2_branch and "m1NormTrkChi2" not in self.complained:
        if not self.m1NormTrkChi2_branch and "m1NormTrkChi2":
            warnings.warn( "MuMuMuTauTree: Expected branch m1NormTrkChi2 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1NormTrkChi2")
        else:
            self.m1NormTrkChi2_branch.SetAddress(<void*>&self.m1NormTrkChi2_value)

        #print "making m1PFChargedIso"
        self.m1PFChargedIso_branch = the_tree.GetBranch("m1PFChargedIso")
        #if not self.m1PFChargedIso_branch and "m1PFChargedIso" not in self.complained:
        if not self.m1PFChargedIso_branch and "m1PFChargedIso":
            warnings.warn( "MuMuMuTauTree: Expected branch m1PFChargedIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1PFChargedIso")
        else:
            self.m1PFChargedIso_branch.SetAddress(<void*>&self.m1PFChargedIso_value)

        #print "making m1PFIDTight"
        self.m1PFIDTight_branch = the_tree.GetBranch("m1PFIDTight")
        #if not self.m1PFIDTight_branch and "m1PFIDTight" not in self.complained:
        if not self.m1PFIDTight_branch and "m1PFIDTight":
            warnings.warn( "MuMuMuTauTree: Expected branch m1PFIDTight does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1PFIDTight")
        else:
            self.m1PFIDTight_branch.SetAddress(<void*>&self.m1PFIDTight_value)

        #print "making m1PFNeutralIso"
        self.m1PFNeutralIso_branch = the_tree.GetBranch("m1PFNeutralIso")
        #if not self.m1PFNeutralIso_branch and "m1PFNeutralIso" not in self.complained:
        if not self.m1PFNeutralIso_branch and "m1PFNeutralIso":
            warnings.warn( "MuMuMuTauTree: Expected branch m1PFNeutralIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1PFNeutralIso")
        else:
            self.m1PFNeutralIso_branch.SetAddress(<void*>&self.m1PFNeutralIso_value)

        #print "making m1PFPUChargedIso"
        self.m1PFPUChargedIso_branch = the_tree.GetBranch("m1PFPUChargedIso")
        #if not self.m1PFPUChargedIso_branch and "m1PFPUChargedIso" not in self.complained:
        if not self.m1PFPUChargedIso_branch and "m1PFPUChargedIso":
            warnings.warn( "MuMuMuTauTree: Expected branch m1PFPUChargedIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1PFPUChargedIso")
        else:
            self.m1PFPUChargedIso_branch.SetAddress(<void*>&self.m1PFPUChargedIso_value)

        #print "making m1PFPhotonIso"
        self.m1PFPhotonIso_branch = the_tree.GetBranch("m1PFPhotonIso")
        #if not self.m1PFPhotonIso_branch and "m1PFPhotonIso" not in self.complained:
        if not self.m1PFPhotonIso_branch and "m1PFPhotonIso":
            warnings.warn( "MuMuMuTauTree: Expected branch m1PFPhotonIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1PFPhotonIso")
        else:
            self.m1PFPhotonIso_branch.SetAddress(<void*>&self.m1PFPhotonIso_value)

        #print "making m1PVDXY"
        self.m1PVDXY_branch = the_tree.GetBranch("m1PVDXY")
        #if not self.m1PVDXY_branch and "m1PVDXY" not in self.complained:
        if not self.m1PVDXY_branch and "m1PVDXY":
            warnings.warn( "MuMuMuTauTree: Expected branch m1PVDXY does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1PVDXY")
        else:
            self.m1PVDXY_branch.SetAddress(<void*>&self.m1PVDXY_value)

        #print "making m1PVDZ"
        self.m1PVDZ_branch = the_tree.GetBranch("m1PVDZ")
        #if not self.m1PVDZ_branch and "m1PVDZ" not in self.complained:
        if not self.m1PVDZ_branch and "m1PVDZ":
            warnings.warn( "MuMuMuTauTree: Expected branch m1PVDZ does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1PVDZ")
        else:
            self.m1PVDZ_branch.SetAddress(<void*>&self.m1PVDZ_value)

        #print "making m1Phi"
        self.m1Phi_branch = the_tree.GetBranch("m1Phi")
        #if not self.m1Phi_branch and "m1Phi" not in self.complained:
        if not self.m1Phi_branch and "m1Phi":
            warnings.warn( "MuMuMuTauTree: Expected branch m1Phi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1Phi")
        else:
            self.m1Phi_branch.SetAddress(<void*>&self.m1Phi_value)

        #print "making m1PhiRochCor2011A"
        self.m1PhiRochCor2011A_branch = the_tree.GetBranch("m1PhiRochCor2011A")
        #if not self.m1PhiRochCor2011A_branch and "m1PhiRochCor2011A" not in self.complained:
        if not self.m1PhiRochCor2011A_branch and "m1PhiRochCor2011A":
            warnings.warn( "MuMuMuTauTree: Expected branch m1PhiRochCor2011A does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1PhiRochCor2011A")
        else:
            self.m1PhiRochCor2011A_branch.SetAddress(<void*>&self.m1PhiRochCor2011A_value)

        #print "making m1PhiRochCor2011B"
        self.m1PhiRochCor2011B_branch = the_tree.GetBranch("m1PhiRochCor2011B")
        #if not self.m1PhiRochCor2011B_branch and "m1PhiRochCor2011B" not in self.complained:
        if not self.m1PhiRochCor2011B_branch and "m1PhiRochCor2011B":
            warnings.warn( "MuMuMuTauTree: Expected branch m1PhiRochCor2011B does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1PhiRochCor2011B")
        else:
            self.m1PhiRochCor2011B_branch.SetAddress(<void*>&self.m1PhiRochCor2011B_value)

        #print "making m1PhiRochCor2012"
        self.m1PhiRochCor2012_branch = the_tree.GetBranch("m1PhiRochCor2012")
        #if not self.m1PhiRochCor2012_branch and "m1PhiRochCor2012" not in self.complained:
        if not self.m1PhiRochCor2012_branch and "m1PhiRochCor2012":
            warnings.warn( "MuMuMuTauTree: Expected branch m1PhiRochCor2012 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1PhiRochCor2012")
        else:
            self.m1PhiRochCor2012_branch.SetAddress(<void*>&self.m1PhiRochCor2012_value)

        #print "making m1PixHits"
        self.m1PixHits_branch = the_tree.GetBranch("m1PixHits")
        #if not self.m1PixHits_branch and "m1PixHits" not in self.complained:
        if not self.m1PixHits_branch and "m1PixHits":
            warnings.warn( "MuMuMuTauTree: Expected branch m1PixHits does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1PixHits")
        else:
            self.m1PixHits_branch.SetAddress(<void*>&self.m1PixHits_value)

        #print "making m1Pt"
        self.m1Pt_branch = the_tree.GetBranch("m1Pt")
        #if not self.m1Pt_branch and "m1Pt" not in self.complained:
        if not self.m1Pt_branch and "m1Pt":
            warnings.warn( "MuMuMuTauTree: Expected branch m1Pt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1Pt")
        else:
            self.m1Pt_branch.SetAddress(<void*>&self.m1Pt_value)

        #print "making m1PtRochCor2011A"
        self.m1PtRochCor2011A_branch = the_tree.GetBranch("m1PtRochCor2011A")
        #if not self.m1PtRochCor2011A_branch and "m1PtRochCor2011A" not in self.complained:
        if not self.m1PtRochCor2011A_branch and "m1PtRochCor2011A":
            warnings.warn( "MuMuMuTauTree: Expected branch m1PtRochCor2011A does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1PtRochCor2011A")
        else:
            self.m1PtRochCor2011A_branch.SetAddress(<void*>&self.m1PtRochCor2011A_value)

        #print "making m1PtRochCor2011B"
        self.m1PtRochCor2011B_branch = the_tree.GetBranch("m1PtRochCor2011B")
        #if not self.m1PtRochCor2011B_branch and "m1PtRochCor2011B" not in self.complained:
        if not self.m1PtRochCor2011B_branch and "m1PtRochCor2011B":
            warnings.warn( "MuMuMuTauTree: Expected branch m1PtRochCor2011B does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1PtRochCor2011B")
        else:
            self.m1PtRochCor2011B_branch.SetAddress(<void*>&self.m1PtRochCor2011B_value)

        #print "making m1PtRochCor2012"
        self.m1PtRochCor2012_branch = the_tree.GetBranch("m1PtRochCor2012")
        #if not self.m1PtRochCor2012_branch and "m1PtRochCor2012" not in self.complained:
        if not self.m1PtRochCor2012_branch and "m1PtRochCor2012":
            warnings.warn( "MuMuMuTauTree: Expected branch m1PtRochCor2012 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1PtRochCor2012")
        else:
            self.m1PtRochCor2012_branch.SetAddress(<void*>&self.m1PtRochCor2012_value)

        #print "making m1Rank"
        self.m1Rank_branch = the_tree.GetBranch("m1Rank")
        #if not self.m1Rank_branch and "m1Rank" not in self.complained:
        if not self.m1Rank_branch and "m1Rank":
            warnings.warn( "MuMuMuTauTree: Expected branch m1Rank does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1Rank")
        else:
            self.m1Rank_branch.SetAddress(<void*>&self.m1Rank_value)

        #print "making m1RelPFIsoDB"
        self.m1RelPFIsoDB_branch = the_tree.GetBranch("m1RelPFIsoDB")
        #if not self.m1RelPFIsoDB_branch and "m1RelPFIsoDB" not in self.complained:
        if not self.m1RelPFIsoDB_branch and "m1RelPFIsoDB":
            warnings.warn( "MuMuMuTauTree: Expected branch m1RelPFIsoDB does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1RelPFIsoDB")
        else:
            self.m1RelPFIsoDB_branch.SetAddress(<void*>&self.m1RelPFIsoDB_value)

        #print "making m1RelPFIsoRho"
        self.m1RelPFIsoRho_branch = the_tree.GetBranch("m1RelPFIsoRho")
        #if not self.m1RelPFIsoRho_branch and "m1RelPFIsoRho" not in self.complained:
        if not self.m1RelPFIsoRho_branch and "m1RelPFIsoRho":
            warnings.warn( "MuMuMuTauTree: Expected branch m1RelPFIsoRho does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1RelPFIsoRho")
        else:
            self.m1RelPFIsoRho_branch.SetAddress(<void*>&self.m1RelPFIsoRho_value)

        #print "making m1RelPFIsoRhoFSR"
        self.m1RelPFIsoRhoFSR_branch = the_tree.GetBranch("m1RelPFIsoRhoFSR")
        #if not self.m1RelPFIsoRhoFSR_branch and "m1RelPFIsoRhoFSR" not in self.complained:
        if not self.m1RelPFIsoRhoFSR_branch and "m1RelPFIsoRhoFSR":
            warnings.warn( "MuMuMuTauTree: Expected branch m1RelPFIsoRhoFSR does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1RelPFIsoRhoFSR")
        else:
            self.m1RelPFIsoRhoFSR_branch.SetAddress(<void*>&self.m1RelPFIsoRhoFSR_value)

        #print "making m1RhoHZG2011"
        self.m1RhoHZG2011_branch = the_tree.GetBranch("m1RhoHZG2011")
        #if not self.m1RhoHZG2011_branch and "m1RhoHZG2011" not in self.complained:
        if not self.m1RhoHZG2011_branch and "m1RhoHZG2011":
            warnings.warn( "MuMuMuTauTree: Expected branch m1RhoHZG2011 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1RhoHZG2011")
        else:
            self.m1RhoHZG2011_branch.SetAddress(<void*>&self.m1RhoHZG2011_value)

        #print "making m1RhoHZG2012"
        self.m1RhoHZG2012_branch = the_tree.GetBranch("m1RhoHZG2012")
        #if not self.m1RhoHZG2012_branch and "m1RhoHZG2012" not in self.complained:
        if not self.m1RhoHZG2012_branch and "m1RhoHZG2012":
            warnings.warn( "MuMuMuTauTree: Expected branch m1RhoHZG2012 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1RhoHZG2012")
        else:
            self.m1RhoHZG2012_branch.SetAddress(<void*>&self.m1RhoHZG2012_value)

        #print "making m1SingleMu13L3Filtered13"
        self.m1SingleMu13L3Filtered13_branch = the_tree.GetBranch("m1SingleMu13L3Filtered13")
        #if not self.m1SingleMu13L3Filtered13_branch and "m1SingleMu13L3Filtered13" not in self.complained:
        if not self.m1SingleMu13L3Filtered13_branch and "m1SingleMu13L3Filtered13":
            warnings.warn( "MuMuMuTauTree: Expected branch m1SingleMu13L3Filtered13 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1SingleMu13L3Filtered13")
        else:
            self.m1SingleMu13L3Filtered13_branch.SetAddress(<void*>&self.m1SingleMu13L3Filtered13_value)

        #print "making m1SingleMu13L3Filtered17"
        self.m1SingleMu13L3Filtered17_branch = the_tree.GetBranch("m1SingleMu13L3Filtered17")
        #if not self.m1SingleMu13L3Filtered17_branch and "m1SingleMu13L3Filtered17" not in self.complained:
        if not self.m1SingleMu13L3Filtered17_branch and "m1SingleMu13L3Filtered17":
            warnings.warn( "MuMuMuTauTree: Expected branch m1SingleMu13L3Filtered17 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1SingleMu13L3Filtered17")
        else:
            self.m1SingleMu13L3Filtered17_branch.SetAddress(<void*>&self.m1SingleMu13L3Filtered17_value)

        #print "making m1TkLayersWithMeasurement"
        self.m1TkLayersWithMeasurement_branch = the_tree.GetBranch("m1TkLayersWithMeasurement")
        #if not self.m1TkLayersWithMeasurement_branch and "m1TkLayersWithMeasurement" not in self.complained:
        if not self.m1TkLayersWithMeasurement_branch and "m1TkLayersWithMeasurement":
            warnings.warn( "MuMuMuTauTree: Expected branch m1TkLayersWithMeasurement does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1TkLayersWithMeasurement")
        else:
            self.m1TkLayersWithMeasurement_branch.SetAddress(<void*>&self.m1TkLayersWithMeasurement_value)

        #print "making m1ToMETDPhi"
        self.m1ToMETDPhi_branch = the_tree.GetBranch("m1ToMETDPhi")
        #if not self.m1ToMETDPhi_branch and "m1ToMETDPhi" not in self.complained:
        if not self.m1ToMETDPhi_branch and "m1ToMETDPhi":
            warnings.warn( "MuMuMuTauTree: Expected branch m1ToMETDPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1ToMETDPhi")
        else:
            self.m1ToMETDPhi_branch.SetAddress(<void*>&self.m1ToMETDPhi_value)

        #print "making m1TypeCode"
        self.m1TypeCode_branch = the_tree.GetBranch("m1TypeCode")
        #if not self.m1TypeCode_branch and "m1TypeCode" not in self.complained:
        if not self.m1TypeCode_branch and "m1TypeCode":
            warnings.warn( "MuMuMuTauTree: Expected branch m1TypeCode does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1TypeCode")
        else:
            self.m1TypeCode_branch.SetAddress(<void*>&self.m1TypeCode_value)

        #print "making m1VBTFID"
        self.m1VBTFID_branch = the_tree.GetBranch("m1VBTFID")
        #if not self.m1VBTFID_branch and "m1VBTFID" not in self.complained:
        if not self.m1VBTFID_branch and "m1VBTFID":
            warnings.warn( "MuMuMuTauTree: Expected branch m1VBTFID does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1VBTFID")
        else:
            self.m1VBTFID_branch.SetAddress(<void*>&self.m1VBTFID_value)

        #print "making m1VZ"
        self.m1VZ_branch = the_tree.GetBranch("m1VZ")
        #if not self.m1VZ_branch and "m1VZ" not in self.complained:
        if not self.m1VZ_branch and "m1VZ":
            warnings.warn( "MuMuMuTauTree: Expected branch m1VZ does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1VZ")
        else:
            self.m1VZ_branch.SetAddress(<void*>&self.m1VZ_value)

        #print "making m1WWID"
        self.m1WWID_branch = the_tree.GetBranch("m1WWID")
        #if not self.m1WWID_branch and "m1WWID" not in self.complained:
        if not self.m1WWID_branch and "m1WWID":
            warnings.warn( "MuMuMuTauTree: Expected branch m1WWID does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1WWID")
        else:
            self.m1WWID_branch.SetAddress(<void*>&self.m1WWID_value)

        #print "making m1_m2_CosThetaStar"
        self.m1_m2_CosThetaStar_branch = the_tree.GetBranch("m1_m2_CosThetaStar")
        #if not self.m1_m2_CosThetaStar_branch and "m1_m2_CosThetaStar" not in self.complained:
        if not self.m1_m2_CosThetaStar_branch and "m1_m2_CosThetaStar":
            warnings.warn( "MuMuMuTauTree: Expected branch m1_m2_CosThetaStar does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_m2_CosThetaStar")
        else:
            self.m1_m2_CosThetaStar_branch.SetAddress(<void*>&self.m1_m2_CosThetaStar_value)

        #print "making m1_m2_DPhi"
        self.m1_m2_DPhi_branch = the_tree.GetBranch("m1_m2_DPhi")
        #if not self.m1_m2_DPhi_branch and "m1_m2_DPhi" not in self.complained:
        if not self.m1_m2_DPhi_branch and "m1_m2_DPhi":
            warnings.warn( "MuMuMuTauTree: Expected branch m1_m2_DPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_m2_DPhi")
        else:
            self.m1_m2_DPhi_branch.SetAddress(<void*>&self.m1_m2_DPhi_value)

        #print "making m1_m2_DR"
        self.m1_m2_DR_branch = the_tree.GetBranch("m1_m2_DR")
        #if not self.m1_m2_DR_branch and "m1_m2_DR" not in self.complained:
        if not self.m1_m2_DR_branch and "m1_m2_DR":
            warnings.warn( "MuMuMuTauTree: Expected branch m1_m2_DR does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_m2_DR")
        else:
            self.m1_m2_DR_branch.SetAddress(<void*>&self.m1_m2_DR_value)

        #print "making m1_m2_Eta"
        self.m1_m2_Eta_branch = the_tree.GetBranch("m1_m2_Eta")
        #if not self.m1_m2_Eta_branch and "m1_m2_Eta" not in self.complained:
        if not self.m1_m2_Eta_branch and "m1_m2_Eta":
            warnings.warn( "MuMuMuTauTree: Expected branch m1_m2_Eta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_m2_Eta")
        else:
            self.m1_m2_Eta_branch.SetAddress(<void*>&self.m1_m2_Eta_value)

        #print "making m1_m2_Mass"
        self.m1_m2_Mass_branch = the_tree.GetBranch("m1_m2_Mass")
        #if not self.m1_m2_Mass_branch and "m1_m2_Mass" not in self.complained:
        if not self.m1_m2_Mass_branch and "m1_m2_Mass":
            warnings.warn( "MuMuMuTauTree: Expected branch m1_m2_Mass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_m2_Mass")
        else:
            self.m1_m2_Mass_branch.SetAddress(<void*>&self.m1_m2_Mass_value)

        #print "making m1_m2_MassFsr"
        self.m1_m2_MassFsr_branch = the_tree.GetBranch("m1_m2_MassFsr")
        #if not self.m1_m2_MassFsr_branch and "m1_m2_MassFsr" not in self.complained:
        if not self.m1_m2_MassFsr_branch and "m1_m2_MassFsr":
            warnings.warn( "MuMuMuTauTree: Expected branch m1_m2_MassFsr does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_m2_MassFsr")
        else:
            self.m1_m2_MassFsr_branch.SetAddress(<void*>&self.m1_m2_MassFsr_value)

        #print "making m1_m2_PZeta"
        self.m1_m2_PZeta_branch = the_tree.GetBranch("m1_m2_PZeta")
        #if not self.m1_m2_PZeta_branch and "m1_m2_PZeta" not in self.complained:
        if not self.m1_m2_PZeta_branch and "m1_m2_PZeta":
            warnings.warn( "MuMuMuTauTree: Expected branch m1_m2_PZeta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_m2_PZeta")
        else:
            self.m1_m2_PZeta_branch.SetAddress(<void*>&self.m1_m2_PZeta_value)

        #print "making m1_m2_PZetaVis"
        self.m1_m2_PZetaVis_branch = the_tree.GetBranch("m1_m2_PZetaVis")
        #if not self.m1_m2_PZetaVis_branch and "m1_m2_PZetaVis" not in self.complained:
        if not self.m1_m2_PZetaVis_branch and "m1_m2_PZetaVis":
            warnings.warn( "MuMuMuTauTree: Expected branch m1_m2_PZetaVis does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_m2_PZetaVis")
        else:
            self.m1_m2_PZetaVis_branch.SetAddress(<void*>&self.m1_m2_PZetaVis_value)

        #print "making m1_m2_Phi"
        self.m1_m2_Phi_branch = the_tree.GetBranch("m1_m2_Phi")
        #if not self.m1_m2_Phi_branch and "m1_m2_Phi" not in self.complained:
        if not self.m1_m2_Phi_branch and "m1_m2_Phi":
            warnings.warn( "MuMuMuTauTree: Expected branch m1_m2_Phi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_m2_Phi")
        else:
            self.m1_m2_Phi_branch.SetAddress(<void*>&self.m1_m2_Phi_value)

        #print "making m1_m2_Pt"
        self.m1_m2_Pt_branch = the_tree.GetBranch("m1_m2_Pt")
        #if not self.m1_m2_Pt_branch and "m1_m2_Pt" not in self.complained:
        if not self.m1_m2_Pt_branch and "m1_m2_Pt":
            warnings.warn( "MuMuMuTauTree: Expected branch m1_m2_Pt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_m2_Pt")
        else:
            self.m1_m2_Pt_branch.SetAddress(<void*>&self.m1_m2_Pt_value)

        #print "making m1_m2_PtFsr"
        self.m1_m2_PtFsr_branch = the_tree.GetBranch("m1_m2_PtFsr")
        #if not self.m1_m2_PtFsr_branch and "m1_m2_PtFsr" not in self.complained:
        if not self.m1_m2_PtFsr_branch and "m1_m2_PtFsr":
            warnings.warn( "MuMuMuTauTree: Expected branch m1_m2_PtFsr does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_m2_PtFsr")
        else:
            self.m1_m2_PtFsr_branch.SetAddress(<void*>&self.m1_m2_PtFsr_value)

        #print "making m1_m2_SS"
        self.m1_m2_SS_branch = the_tree.GetBranch("m1_m2_SS")
        #if not self.m1_m2_SS_branch and "m1_m2_SS" not in self.complained:
        if not self.m1_m2_SS_branch and "m1_m2_SS":
            warnings.warn( "MuMuMuTauTree: Expected branch m1_m2_SS does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_m2_SS")
        else:
            self.m1_m2_SS_branch.SetAddress(<void*>&self.m1_m2_SS_value)

        #print "making m1_m2_ToMETDPhi_Ty1"
        self.m1_m2_ToMETDPhi_Ty1_branch = the_tree.GetBranch("m1_m2_ToMETDPhi_Ty1")
        #if not self.m1_m2_ToMETDPhi_Ty1_branch and "m1_m2_ToMETDPhi_Ty1" not in self.complained:
        if not self.m1_m2_ToMETDPhi_Ty1_branch and "m1_m2_ToMETDPhi_Ty1":
            warnings.warn( "MuMuMuTauTree: Expected branch m1_m2_ToMETDPhi_Ty1 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_m2_ToMETDPhi_Ty1")
        else:
            self.m1_m2_ToMETDPhi_Ty1_branch.SetAddress(<void*>&self.m1_m2_ToMETDPhi_Ty1_value)

        #print "making m1_m2_Zcompat"
        self.m1_m2_Zcompat_branch = the_tree.GetBranch("m1_m2_Zcompat")
        #if not self.m1_m2_Zcompat_branch and "m1_m2_Zcompat" not in self.complained:
        if not self.m1_m2_Zcompat_branch and "m1_m2_Zcompat":
            warnings.warn( "MuMuMuTauTree: Expected branch m1_m2_Zcompat does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_m2_Zcompat")
        else:
            self.m1_m2_Zcompat_branch.SetAddress(<void*>&self.m1_m2_Zcompat_value)

        #print "making m1_m3_CosThetaStar"
        self.m1_m3_CosThetaStar_branch = the_tree.GetBranch("m1_m3_CosThetaStar")
        #if not self.m1_m3_CosThetaStar_branch and "m1_m3_CosThetaStar" not in self.complained:
        if not self.m1_m3_CosThetaStar_branch and "m1_m3_CosThetaStar":
            warnings.warn( "MuMuMuTauTree: Expected branch m1_m3_CosThetaStar does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_m3_CosThetaStar")
        else:
            self.m1_m3_CosThetaStar_branch.SetAddress(<void*>&self.m1_m3_CosThetaStar_value)

        #print "making m1_m3_DPhi"
        self.m1_m3_DPhi_branch = the_tree.GetBranch("m1_m3_DPhi")
        #if not self.m1_m3_DPhi_branch and "m1_m3_DPhi" not in self.complained:
        if not self.m1_m3_DPhi_branch and "m1_m3_DPhi":
            warnings.warn( "MuMuMuTauTree: Expected branch m1_m3_DPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_m3_DPhi")
        else:
            self.m1_m3_DPhi_branch.SetAddress(<void*>&self.m1_m3_DPhi_value)

        #print "making m1_m3_DR"
        self.m1_m3_DR_branch = the_tree.GetBranch("m1_m3_DR")
        #if not self.m1_m3_DR_branch and "m1_m3_DR" not in self.complained:
        if not self.m1_m3_DR_branch and "m1_m3_DR":
            warnings.warn( "MuMuMuTauTree: Expected branch m1_m3_DR does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_m3_DR")
        else:
            self.m1_m3_DR_branch.SetAddress(<void*>&self.m1_m3_DR_value)

        #print "making m1_m3_Eta"
        self.m1_m3_Eta_branch = the_tree.GetBranch("m1_m3_Eta")
        #if not self.m1_m3_Eta_branch and "m1_m3_Eta" not in self.complained:
        if not self.m1_m3_Eta_branch and "m1_m3_Eta":
            warnings.warn( "MuMuMuTauTree: Expected branch m1_m3_Eta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_m3_Eta")
        else:
            self.m1_m3_Eta_branch.SetAddress(<void*>&self.m1_m3_Eta_value)

        #print "making m1_m3_Mass"
        self.m1_m3_Mass_branch = the_tree.GetBranch("m1_m3_Mass")
        #if not self.m1_m3_Mass_branch and "m1_m3_Mass" not in self.complained:
        if not self.m1_m3_Mass_branch and "m1_m3_Mass":
            warnings.warn( "MuMuMuTauTree: Expected branch m1_m3_Mass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_m3_Mass")
        else:
            self.m1_m3_Mass_branch.SetAddress(<void*>&self.m1_m3_Mass_value)

        #print "making m1_m3_MassFsr"
        self.m1_m3_MassFsr_branch = the_tree.GetBranch("m1_m3_MassFsr")
        #if not self.m1_m3_MassFsr_branch and "m1_m3_MassFsr" not in self.complained:
        if not self.m1_m3_MassFsr_branch and "m1_m3_MassFsr":
            warnings.warn( "MuMuMuTauTree: Expected branch m1_m3_MassFsr does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_m3_MassFsr")
        else:
            self.m1_m3_MassFsr_branch.SetAddress(<void*>&self.m1_m3_MassFsr_value)

        #print "making m1_m3_PZeta"
        self.m1_m3_PZeta_branch = the_tree.GetBranch("m1_m3_PZeta")
        #if not self.m1_m3_PZeta_branch and "m1_m3_PZeta" not in self.complained:
        if not self.m1_m3_PZeta_branch and "m1_m3_PZeta":
            warnings.warn( "MuMuMuTauTree: Expected branch m1_m3_PZeta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_m3_PZeta")
        else:
            self.m1_m3_PZeta_branch.SetAddress(<void*>&self.m1_m3_PZeta_value)

        #print "making m1_m3_PZetaVis"
        self.m1_m3_PZetaVis_branch = the_tree.GetBranch("m1_m3_PZetaVis")
        #if not self.m1_m3_PZetaVis_branch and "m1_m3_PZetaVis" not in self.complained:
        if not self.m1_m3_PZetaVis_branch and "m1_m3_PZetaVis":
            warnings.warn( "MuMuMuTauTree: Expected branch m1_m3_PZetaVis does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_m3_PZetaVis")
        else:
            self.m1_m3_PZetaVis_branch.SetAddress(<void*>&self.m1_m3_PZetaVis_value)

        #print "making m1_m3_Phi"
        self.m1_m3_Phi_branch = the_tree.GetBranch("m1_m3_Phi")
        #if not self.m1_m3_Phi_branch and "m1_m3_Phi" not in self.complained:
        if not self.m1_m3_Phi_branch and "m1_m3_Phi":
            warnings.warn( "MuMuMuTauTree: Expected branch m1_m3_Phi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_m3_Phi")
        else:
            self.m1_m3_Phi_branch.SetAddress(<void*>&self.m1_m3_Phi_value)

        #print "making m1_m3_Pt"
        self.m1_m3_Pt_branch = the_tree.GetBranch("m1_m3_Pt")
        #if not self.m1_m3_Pt_branch and "m1_m3_Pt" not in self.complained:
        if not self.m1_m3_Pt_branch and "m1_m3_Pt":
            warnings.warn( "MuMuMuTauTree: Expected branch m1_m3_Pt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_m3_Pt")
        else:
            self.m1_m3_Pt_branch.SetAddress(<void*>&self.m1_m3_Pt_value)

        #print "making m1_m3_PtFsr"
        self.m1_m3_PtFsr_branch = the_tree.GetBranch("m1_m3_PtFsr")
        #if not self.m1_m3_PtFsr_branch and "m1_m3_PtFsr" not in self.complained:
        if not self.m1_m3_PtFsr_branch and "m1_m3_PtFsr":
            warnings.warn( "MuMuMuTauTree: Expected branch m1_m3_PtFsr does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_m3_PtFsr")
        else:
            self.m1_m3_PtFsr_branch.SetAddress(<void*>&self.m1_m3_PtFsr_value)

        #print "making m1_m3_SS"
        self.m1_m3_SS_branch = the_tree.GetBranch("m1_m3_SS")
        #if not self.m1_m3_SS_branch and "m1_m3_SS" not in self.complained:
        if not self.m1_m3_SS_branch and "m1_m3_SS":
            warnings.warn( "MuMuMuTauTree: Expected branch m1_m3_SS does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_m3_SS")
        else:
            self.m1_m3_SS_branch.SetAddress(<void*>&self.m1_m3_SS_value)

        #print "making m1_m3_ToMETDPhi_Ty1"
        self.m1_m3_ToMETDPhi_Ty1_branch = the_tree.GetBranch("m1_m3_ToMETDPhi_Ty1")
        #if not self.m1_m3_ToMETDPhi_Ty1_branch and "m1_m3_ToMETDPhi_Ty1" not in self.complained:
        if not self.m1_m3_ToMETDPhi_Ty1_branch and "m1_m3_ToMETDPhi_Ty1":
            warnings.warn( "MuMuMuTauTree: Expected branch m1_m3_ToMETDPhi_Ty1 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_m3_ToMETDPhi_Ty1")
        else:
            self.m1_m3_ToMETDPhi_Ty1_branch.SetAddress(<void*>&self.m1_m3_ToMETDPhi_Ty1_value)

        #print "making m1_m3_Zcompat"
        self.m1_m3_Zcompat_branch = the_tree.GetBranch("m1_m3_Zcompat")
        #if not self.m1_m3_Zcompat_branch and "m1_m3_Zcompat" not in self.complained:
        if not self.m1_m3_Zcompat_branch and "m1_m3_Zcompat":
            warnings.warn( "MuMuMuTauTree: Expected branch m1_m3_Zcompat does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_m3_Zcompat")
        else:
            self.m1_m3_Zcompat_branch.SetAddress(<void*>&self.m1_m3_Zcompat_value)

        #print "making m1_t_CosThetaStar"
        self.m1_t_CosThetaStar_branch = the_tree.GetBranch("m1_t_CosThetaStar")
        #if not self.m1_t_CosThetaStar_branch and "m1_t_CosThetaStar" not in self.complained:
        if not self.m1_t_CosThetaStar_branch and "m1_t_CosThetaStar":
            warnings.warn( "MuMuMuTauTree: Expected branch m1_t_CosThetaStar does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_t_CosThetaStar")
        else:
            self.m1_t_CosThetaStar_branch.SetAddress(<void*>&self.m1_t_CosThetaStar_value)

        #print "making m1_t_DPhi"
        self.m1_t_DPhi_branch = the_tree.GetBranch("m1_t_DPhi")
        #if not self.m1_t_DPhi_branch and "m1_t_DPhi" not in self.complained:
        if not self.m1_t_DPhi_branch and "m1_t_DPhi":
            warnings.warn( "MuMuMuTauTree: Expected branch m1_t_DPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_t_DPhi")
        else:
            self.m1_t_DPhi_branch.SetAddress(<void*>&self.m1_t_DPhi_value)

        #print "making m1_t_DR"
        self.m1_t_DR_branch = the_tree.GetBranch("m1_t_DR")
        #if not self.m1_t_DR_branch and "m1_t_DR" not in self.complained:
        if not self.m1_t_DR_branch and "m1_t_DR":
            warnings.warn( "MuMuMuTauTree: Expected branch m1_t_DR does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_t_DR")
        else:
            self.m1_t_DR_branch.SetAddress(<void*>&self.m1_t_DR_value)

        #print "making m1_t_Eta"
        self.m1_t_Eta_branch = the_tree.GetBranch("m1_t_Eta")
        #if not self.m1_t_Eta_branch and "m1_t_Eta" not in self.complained:
        if not self.m1_t_Eta_branch and "m1_t_Eta":
            warnings.warn( "MuMuMuTauTree: Expected branch m1_t_Eta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_t_Eta")
        else:
            self.m1_t_Eta_branch.SetAddress(<void*>&self.m1_t_Eta_value)

        #print "making m1_t_Mass"
        self.m1_t_Mass_branch = the_tree.GetBranch("m1_t_Mass")
        #if not self.m1_t_Mass_branch and "m1_t_Mass" not in self.complained:
        if not self.m1_t_Mass_branch and "m1_t_Mass":
            warnings.warn( "MuMuMuTauTree: Expected branch m1_t_Mass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_t_Mass")
        else:
            self.m1_t_Mass_branch.SetAddress(<void*>&self.m1_t_Mass_value)

        #print "making m1_t_MassFsr"
        self.m1_t_MassFsr_branch = the_tree.GetBranch("m1_t_MassFsr")
        #if not self.m1_t_MassFsr_branch and "m1_t_MassFsr" not in self.complained:
        if not self.m1_t_MassFsr_branch and "m1_t_MassFsr":
            warnings.warn( "MuMuMuTauTree: Expected branch m1_t_MassFsr does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_t_MassFsr")
        else:
            self.m1_t_MassFsr_branch.SetAddress(<void*>&self.m1_t_MassFsr_value)

        #print "making m1_t_PZeta"
        self.m1_t_PZeta_branch = the_tree.GetBranch("m1_t_PZeta")
        #if not self.m1_t_PZeta_branch and "m1_t_PZeta" not in self.complained:
        if not self.m1_t_PZeta_branch and "m1_t_PZeta":
            warnings.warn( "MuMuMuTauTree: Expected branch m1_t_PZeta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_t_PZeta")
        else:
            self.m1_t_PZeta_branch.SetAddress(<void*>&self.m1_t_PZeta_value)

        #print "making m1_t_PZetaVis"
        self.m1_t_PZetaVis_branch = the_tree.GetBranch("m1_t_PZetaVis")
        #if not self.m1_t_PZetaVis_branch and "m1_t_PZetaVis" not in self.complained:
        if not self.m1_t_PZetaVis_branch and "m1_t_PZetaVis":
            warnings.warn( "MuMuMuTauTree: Expected branch m1_t_PZetaVis does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_t_PZetaVis")
        else:
            self.m1_t_PZetaVis_branch.SetAddress(<void*>&self.m1_t_PZetaVis_value)

        #print "making m1_t_Phi"
        self.m1_t_Phi_branch = the_tree.GetBranch("m1_t_Phi")
        #if not self.m1_t_Phi_branch and "m1_t_Phi" not in self.complained:
        if not self.m1_t_Phi_branch and "m1_t_Phi":
            warnings.warn( "MuMuMuTauTree: Expected branch m1_t_Phi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_t_Phi")
        else:
            self.m1_t_Phi_branch.SetAddress(<void*>&self.m1_t_Phi_value)

        #print "making m1_t_Pt"
        self.m1_t_Pt_branch = the_tree.GetBranch("m1_t_Pt")
        #if not self.m1_t_Pt_branch and "m1_t_Pt" not in self.complained:
        if not self.m1_t_Pt_branch and "m1_t_Pt":
            warnings.warn( "MuMuMuTauTree: Expected branch m1_t_Pt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_t_Pt")
        else:
            self.m1_t_Pt_branch.SetAddress(<void*>&self.m1_t_Pt_value)

        #print "making m1_t_PtFsr"
        self.m1_t_PtFsr_branch = the_tree.GetBranch("m1_t_PtFsr")
        #if not self.m1_t_PtFsr_branch and "m1_t_PtFsr" not in self.complained:
        if not self.m1_t_PtFsr_branch and "m1_t_PtFsr":
            warnings.warn( "MuMuMuTauTree: Expected branch m1_t_PtFsr does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_t_PtFsr")
        else:
            self.m1_t_PtFsr_branch.SetAddress(<void*>&self.m1_t_PtFsr_value)

        #print "making m1_t_SS"
        self.m1_t_SS_branch = the_tree.GetBranch("m1_t_SS")
        #if not self.m1_t_SS_branch and "m1_t_SS" not in self.complained:
        if not self.m1_t_SS_branch and "m1_t_SS":
            warnings.warn( "MuMuMuTauTree: Expected branch m1_t_SS does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_t_SS")
        else:
            self.m1_t_SS_branch.SetAddress(<void*>&self.m1_t_SS_value)

        #print "making m1_t_ToMETDPhi_Ty1"
        self.m1_t_ToMETDPhi_Ty1_branch = the_tree.GetBranch("m1_t_ToMETDPhi_Ty1")
        #if not self.m1_t_ToMETDPhi_Ty1_branch and "m1_t_ToMETDPhi_Ty1" not in self.complained:
        if not self.m1_t_ToMETDPhi_Ty1_branch and "m1_t_ToMETDPhi_Ty1":
            warnings.warn( "MuMuMuTauTree: Expected branch m1_t_ToMETDPhi_Ty1 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_t_ToMETDPhi_Ty1")
        else:
            self.m1_t_ToMETDPhi_Ty1_branch.SetAddress(<void*>&self.m1_t_ToMETDPhi_Ty1_value)

        #print "making m1_t_Zcompat"
        self.m1_t_Zcompat_branch = the_tree.GetBranch("m1_t_Zcompat")
        #if not self.m1_t_Zcompat_branch and "m1_t_Zcompat" not in self.complained:
        if not self.m1_t_Zcompat_branch and "m1_t_Zcompat":
            warnings.warn( "MuMuMuTauTree: Expected branch m1_t_Zcompat does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_t_Zcompat")
        else:
            self.m1_t_Zcompat_branch.SetAddress(<void*>&self.m1_t_Zcompat_value)

        #print "making m2AbsEta"
        self.m2AbsEta_branch = the_tree.GetBranch("m2AbsEta")
        #if not self.m2AbsEta_branch and "m2AbsEta" not in self.complained:
        if not self.m2AbsEta_branch and "m2AbsEta":
            warnings.warn( "MuMuMuTauTree: Expected branch m2AbsEta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2AbsEta")
        else:
            self.m2AbsEta_branch.SetAddress(<void*>&self.m2AbsEta_value)

        #print "making m2Charge"
        self.m2Charge_branch = the_tree.GetBranch("m2Charge")
        #if not self.m2Charge_branch and "m2Charge" not in self.complained:
        if not self.m2Charge_branch and "m2Charge":
            warnings.warn( "MuMuMuTauTree: Expected branch m2Charge does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2Charge")
        else:
            self.m2Charge_branch.SetAddress(<void*>&self.m2Charge_value)

        #print "making m2ComesFromHiggs"
        self.m2ComesFromHiggs_branch = the_tree.GetBranch("m2ComesFromHiggs")
        #if not self.m2ComesFromHiggs_branch and "m2ComesFromHiggs" not in self.complained:
        if not self.m2ComesFromHiggs_branch and "m2ComesFromHiggs":
            warnings.warn( "MuMuMuTauTree: Expected branch m2ComesFromHiggs does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2ComesFromHiggs")
        else:
            self.m2ComesFromHiggs_branch.SetAddress(<void*>&self.m2ComesFromHiggs_value)

        #print "making m2D0"
        self.m2D0_branch = the_tree.GetBranch("m2D0")
        #if not self.m2D0_branch and "m2D0" not in self.complained:
        if not self.m2D0_branch and "m2D0":
            warnings.warn( "MuMuMuTauTree: Expected branch m2D0 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2D0")
        else:
            self.m2D0_branch.SetAddress(<void*>&self.m2D0_value)

        #print "making m2DZ"
        self.m2DZ_branch = the_tree.GetBranch("m2DZ")
        #if not self.m2DZ_branch and "m2DZ" not in self.complained:
        if not self.m2DZ_branch and "m2DZ":
            warnings.warn( "MuMuMuTauTree: Expected branch m2DZ does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2DZ")
        else:
            self.m2DZ_branch.SetAddress(<void*>&self.m2DZ_value)

        #print "making m2DiMuonL3PreFiltered7"
        self.m2DiMuonL3PreFiltered7_branch = the_tree.GetBranch("m2DiMuonL3PreFiltered7")
        #if not self.m2DiMuonL3PreFiltered7_branch and "m2DiMuonL3PreFiltered7" not in self.complained:
        if not self.m2DiMuonL3PreFiltered7_branch and "m2DiMuonL3PreFiltered7":
            warnings.warn( "MuMuMuTauTree: Expected branch m2DiMuonL3PreFiltered7 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2DiMuonL3PreFiltered7")
        else:
            self.m2DiMuonL3PreFiltered7_branch.SetAddress(<void*>&self.m2DiMuonL3PreFiltered7_value)

        #print "making m2DiMuonL3p5PreFiltered8"
        self.m2DiMuonL3p5PreFiltered8_branch = the_tree.GetBranch("m2DiMuonL3p5PreFiltered8")
        #if not self.m2DiMuonL3p5PreFiltered8_branch and "m2DiMuonL3p5PreFiltered8" not in self.complained:
        if not self.m2DiMuonL3p5PreFiltered8_branch and "m2DiMuonL3p5PreFiltered8":
            warnings.warn( "MuMuMuTauTree: Expected branch m2DiMuonL3p5PreFiltered8 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2DiMuonL3p5PreFiltered8")
        else:
            self.m2DiMuonL3p5PreFiltered8_branch.SetAddress(<void*>&self.m2DiMuonL3p5PreFiltered8_value)

        #print "making m2DiMuonMu17Mu8DzFiltered0p2"
        self.m2DiMuonMu17Mu8DzFiltered0p2_branch = the_tree.GetBranch("m2DiMuonMu17Mu8DzFiltered0p2")
        #if not self.m2DiMuonMu17Mu8DzFiltered0p2_branch and "m2DiMuonMu17Mu8DzFiltered0p2" not in self.complained:
        if not self.m2DiMuonMu17Mu8DzFiltered0p2_branch and "m2DiMuonMu17Mu8DzFiltered0p2":
            warnings.warn( "MuMuMuTauTree: Expected branch m2DiMuonMu17Mu8DzFiltered0p2 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2DiMuonMu17Mu8DzFiltered0p2")
        else:
            self.m2DiMuonMu17Mu8DzFiltered0p2_branch.SetAddress(<void*>&self.m2DiMuonMu17Mu8DzFiltered0p2_value)

        #print "making m2EErrRochCor2011A"
        self.m2EErrRochCor2011A_branch = the_tree.GetBranch("m2EErrRochCor2011A")
        #if not self.m2EErrRochCor2011A_branch and "m2EErrRochCor2011A" not in self.complained:
        if not self.m2EErrRochCor2011A_branch and "m2EErrRochCor2011A":
            warnings.warn( "MuMuMuTauTree: Expected branch m2EErrRochCor2011A does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2EErrRochCor2011A")
        else:
            self.m2EErrRochCor2011A_branch.SetAddress(<void*>&self.m2EErrRochCor2011A_value)

        #print "making m2EErrRochCor2011B"
        self.m2EErrRochCor2011B_branch = the_tree.GetBranch("m2EErrRochCor2011B")
        #if not self.m2EErrRochCor2011B_branch and "m2EErrRochCor2011B" not in self.complained:
        if not self.m2EErrRochCor2011B_branch and "m2EErrRochCor2011B":
            warnings.warn( "MuMuMuTauTree: Expected branch m2EErrRochCor2011B does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2EErrRochCor2011B")
        else:
            self.m2EErrRochCor2011B_branch.SetAddress(<void*>&self.m2EErrRochCor2011B_value)

        #print "making m2EErrRochCor2012"
        self.m2EErrRochCor2012_branch = the_tree.GetBranch("m2EErrRochCor2012")
        #if not self.m2EErrRochCor2012_branch and "m2EErrRochCor2012" not in self.complained:
        if not self.m2EErrRochCor2012_branch and "m2EErrRochCor2012":
            warnings.warn( "MuMuMuTauTree: Expected branch m2EErrRochCor2012 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2EErrRochCor2012")
        else:
            self.m2EErrRochCor2012_branch.SetAddress(<void*>&self.m2EErrRochCor2012_value)

        #print "making m2ERochCor2011A"
        self.m2ERochCor2011A_branch = the_tree.GetBranch("m2ERochCor2011A")
        #if not self.m2ERochCor2011A_branch and "m2ERochCor2011A" not in self.complained:
        if not self.m2ERochCor2011A_branch and "m2ERochCor2011A":
            warnings.warn( "MuMuMuTauTree: Expected branch m2ERochCor2011A does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2ERochCor2011A")
        else:
            self.m2ERochCor2011A_branch.SetAddress(<void*>&self.m2ERochCor2011A_value)

        #print "making m2ERochCor2011B"
        self.m2ERochCor2011B_branch = the_tree.GetBranch("m2ERochCor2011B")
        #if not self.m2ERochCor2011B_branch and "m2ERochCor2011B" not in self.complained:
        if not self.m2ERochCor2011B_branch and "m2ERochCor2011B":
            warnings.warn( "MuMuMuTauTree: Expected branch m2ERochCor2011B does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2ERochCor2011B")
        else:
            self.m2ERochCor2011B_branch.SetAddress(<void*>&self.m2ERochCor2011B_value)

        #print "making m2ERochCor2012"
        self.m2ERochCor2012_branch = the_tree.GetBranch("m2ERochCor2012")
        #if not self.m2ERochCor2012_branch and "m2ERochCor2012" not in self.complained:
        if not self.m2ERochCor2012_branch and "m2ERochCor2012":
            warnings.warn( "MuMuMuTauTree: Expected branch m2ERochCor2012 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2ERochCor2012")
        else:
            self.m2ERochCor2012_branch.SetAddress(<void*>&self.m2ERochCor2012_value)

        #print "making m2EffectiveArea2011"
        self.m2EffectiveArea2011_branch = the_tree.GetBranch("m2EffectiveArea2011")
        #if not self.m2EffectiveArea2011_branch and "m2EffectiveArea2011" not in self.complained:
        if not self.m2EffectiveArea2011_branch and "m2EffectiveArea2011":
            warnings.warn( "MuMuMuTauTree: Expected branch m2EffectiveArea2011 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2EffectiveArea2011")
        else:
            self.m2EffectiveArea2011_branch.SetAddress(<void*>&self.m2EffectiveArea2011_value)

        #print "making m2EffectiveArea2012"
        self.m2EffectiveArea2012_branch = the_tree.GetBranch("m2EffectiveArea2012")
        #if not self.m2EffectiveArea2012_branch and "m2EffectiveArea2012" not in self.complained:
        if not self.m2EffectiveArea2012_branch and "m2EffectiveArea2012":
            warnings.warn( "MuMuMuTauTree: Expected branch m2EffectiveArea2012 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2EffectiveArea2012")
        else:
            self.m2EffectiveArea2012_branch.SetAddress(<void*>&self.m2EffectiveArea2012_value)

        #print "making m2Eta"
        self.m2Eta_branch = the_tree.GetBranch("m2Eta")
        #if not self.m2Eta_branch and "m2Eta" not in self.complained:
        if not self.m2Eta_branch and "m2Eta":
            warnings.warn( "MuMuMuTauTree: Expected branch m2Eta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2Eta")
        else:
            self.m2Eta_branch.SetAddress(<void*>&self.m2Eta_value)

        #print "making m2EtaRochCor2011A"
        self.m2EtaRochCor2011A_branch = the_tree.GetBranch("m2EtaRochCor2011A")
        #if not self.m2EtaRochCor2011A_branch and "m2EtaRochCor2011A" not in self.complained:
        if not self.m2EtaRochCor2011A_branch and "m2EtaRochCor2011A":
            warnings.warn( "MuMuMuTauTree: Expected branch m2EtaRochCor2011A does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2EtaRochCor2011A")
        else:
            self.m2EtaRochCor2011A_branch.SetAddress(<void*>&self.m2EtaRochCor2011A_value)

        #print "making m2EtaRochCor2011B"
        self.m2EtaRochCor2011B_branch = the_tree.GetBranch("m2EtaRochCor2011B")
        #if not self.m2EtaRochCor2011B_branch and "m2EtaRochCor2011B" not in self.complained:
        if not self.m2EtaRochCor2011B_branch and "m2EtaRochCor2011B":
            warnings.warn( "MuMuMuTauTree: Expected branch m2EtaRochCor2011B does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2EtaRochCor2011B")
        else:
            self.m2EtaRochCor2011B_branch.SetAddress(<void*>&self.m2EtaRochCor2011B_value)

        #print "making m2EtaRochCor2012"
        self.m2EtaRochCor2012_branch = the_tree.GetBranch("m2EtaRochCor2012")
        #if not self.m2EtaRochCor2012_branch and "m2EtaRochCor2012" not in self.complained:
        if not self.m2EtaRochCor2012_branch and "m2EtaRochCor2012":
            warnings.warn( "MuMuMuTauTree: Expected branch m2EtaRochCor2012 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2EtaRochCor2012")
        else:
            self.m2EtaRochCor2012_branch.SetAddress(<void*>&self.m2EtaRochCor2012_value)

        #print "making m2GenCharge"
        self.m2GenCharge_branch = the_tree.GetBranch("m2GenCharge")
        #if not self.m2GenCharge_branch and "m2GenCharge" not in self.complained:
        if not self.m2GenCharge_branch and "m2GenCharge":
            warnings.warn( "MuMuMuTauTree: Expected branch m2GenCharge does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2GenCharge")
        else:
            self.m2GenCharge_branch.SetAddress(<void*>&self.m2GenCharge_value)

        #print "making m2GenEnergy"
        self.m2GenEnergy_branch = the_tree.GetBranch("m2GenEnergy")
        #if not self.m2GenEnergy_branch and "m2GenEnergy" not in self.complained:
        if not self.m2GenEnergy_branch and "m2GenEnergy":
            warnings.warn( "MuMuMuTauTree: Expected branch m2GenEnergy does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2GenEnergy")
        else:
            self.m2GenEnergy_branch.SetAddress(<void*>&self.m2GenEnergy_value)

        #print "making m2GenEta"
        self.m2GenEta_branch = the_tree.GetBranch("m2GenEta")
        #if not self.m2GenEta_branch and "m2GenEta" not in self.complained:
        if not self.m2GenEta_branch and "m2GenEta":
            warnings.warn( "MuMuMuTauTree: Expected branch m2GenEta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2GenEta")
        else:
            self.m2GenEta_branch.SetAddress(<void*>&self.m2GenEta_value)

        #print "making m2GenMotherPdgId"
        self.m2GenMotherPdgId_branch = the_tree.GetBranch("m2GenMotherPdgId")
        #if not self.m2GenMotherPdgId_branch and "m2GenMotherPdgId" not in self.complained:
        if not self.m2GenMotherPdgId_branch and "m2GenMotherPdgId":
            warnings.warn( "MuMuMuTauTree: Expected branch m2GenMotherPdgId does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2GenMotherPdgId")
        else:
            self.m2GenMotherPdgId_branch.SetAddress(<void*>&self.m2GenMotherPdgId_value)

        #print "making m2GenPdgId"
        self.m2GenPdgId_branch = the_tree.GetBranch("m2GenPdgId")
        #if not self.m2GenPdgId_branch and "m2GenPdgId" not in self.complained:
        if not self.m2GenPdgId_branch and "m2GenPdgId":
            warnings.warn( "MuMuMuTauTree: Expected branch m2GenPdgId does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2GenPdgId")
        else:
            self.m2GenPdgId_branch.SetAddress(<void*>&self.m2GenPdgId_value)

        #print "making m2GenPhi"
        self.m2GenPhi_branch = the_tree.GetBranch("m2GenPhi")
        #if not self.m2GenPhi_branch and "m2GenPhi" not in self.complained:
        if not self.m2GenPhi_branch and "m2GenPhi":
            warnings.warn( "MuMuMuTauTree: Expected branch m2GenPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2GenPhi")
        else:
            self.m2GenPhi_branch.SetAddress(<void*>&self.m2GenPhi_value)

        #print "making m2GlbTrkHits"
        self.m2GlbTrkHits_branch = the_tree.GetBranch("m2GlbTrkHits")
        #if not self.m2GlbTrkHits_branch and "m2GlbTrkHits" not in self.complained:
        if not self.m2GlbTrkHits_branch and "m2GlbTrkHits":
            warnings.warn( "MuMuMuTauTree: Expected branch m2GlbTrkHits does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2GlbTrkHits")
        else:
            self.m2GlbTrkHits_branch.SetAddress(<void*>&self.m2GlbTrkHits_value)

        #print "making m2IDHZG2011"
        self.m2IDHZG2011_branch = the_tree.GetBranch("m2IDHZG2011")
        #if not self.m2IDHZG2011_branch and "m2IDHZG2011" not in self.complained:
        if not self.m2IDHZG2011_branch and "m2IDHZG2011":
            warnings.warn( "MuMuMuTauTree: Expected branch m2IDHZG2011 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2IDHZG2011")
        else:
            self.m2IDHZG2011_branch.SetAddress(<void*>&self.m2IDHZG2011_value)

        #print "making m2IDHZG2012"
        self.m2IDHZG2012_branch = the_tree.GetBranch("m2IDHZG2012")
        #if not self.m2IDHZG2012_branch and "m2IDHZG2012" not in self.complained:
        if not self.m2IDHZG2012_branch and "m2IDHZG2012":
            warnings.warn( "MuMuMuTauTree: Expected branch m2IDHZG2012 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2IDHZG2012")
        else:
            self.m2IDHZG2012_branch.SetAddress(<void*>&self.m2IDHZG2012_value)

        #print "making m2IP3DS"
        self.m2IP3DS_branch = the_tree.GetBranch("m2IP3DS")
        #if not self.m2IP3DS_branch and "m2IP3DS" not in self.complained:
        if not self.m2IP3DS_branch and "m2IP3DS":
            warnings.warn( "MuMuMuTauTree: Expected branch m2IP3DS does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2IP3DS")
        else:
            self.m2IP3DS_branch.SetAddress(<void*>&self.m2IP3DS_value)

        #print "making m2IsGlobal"
        self.m2IsGlobal_branch = the_tree.GetBranch("m2IsGlobal")
        #if not self.m2IsGlobal_branch and "m2IsGlobal" not in self.complained:
        if not self.m2IsGlobal_branch and "m2IsGlobal":
            warnings.warn( "MuMuMuTauTree: Expected branch m2IsGlobal does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2IsGlobal")
        else:
            self.m2IsGlobal_branch.SetAddress(<void*>&self.m2IsGlobal_value)

        #print "making m2IsPFMuon"
        self.m2IsPFMuon_branch = the_tree.GetBranch("m2IsPFMuon")
        #if not self.m2IsPFMuon_branch and "m2IsPFMuon" not in self.complained:
        if not self.m2IsPFMuon_branch and "m2IsPFMuon":
            warnings.warn( "MuMuMuTauTree: Expected branch m2IsPFMuon does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2IsPFMuon")
        else:
            self.m2IsPFMuon_branch.SetAddress(<void*>&self.m2IsPFMuon_value)

        #print "making m2IsTracker"
        self.m2IsTracker_branch = the_tree.GetBranch("m2IsTracker")
        #if not self.m2IsTracker_branch and "m2IsTracker" not in self.complained:
        if not self.m2IsTracker_branch and "m2IsTracker":
            warnings.warn( "MuMuMuTauTree: Expected branch m2IsTracker does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2IsTracker")
        else:
            self.m2IsTracker_branch.SetAddress(<void*>&self.m2IsTracker_value)

        #print "making m2JetArea"
        self.m2JetArea_branch = the_tree.GetBranch("m2JetArea")
        #if not self.m2JetArea_branch and "m2JetArea" not in self.complained:
        if not self.m2JetArea_branch and "m2JetArea":
            warnings.warn( "MuMuMuTauTree: Expected branch m2JetArea does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2JetArea")
        else:
            self.m2JetArea_branch.SetAddress(<void*>&self.m2JetArea_value)

        #print "making m2JetBtag"
        self.m2JetBtag_branch = the_tree.GetBranch("m2JetBtag")
        #if not self.m2JetBtag_branch and "m2JetBtag" not in self.complained:
        if not self.m2JetBtag_branch and "m2JetBtag":
            warnings.warn( "MuMuMuTauTree: Expected branch m2JetBtag does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2JetBtag")
        else:
            self.m2JetBtag_branch.SetAddress(<void*>&self.m2JetBtag_value)

        #print "making m2JetCSVBtag"
        self.m2JetCSVBtag_branch = the_tree.GetBranch("m2JetCSVBtag")
        #if not self.m2JetCSVBtag_branch and "m2JetCSVBtag" not in self.complained:
        if not self.m2JetCSVBtag_branch and "m2JetCSVBtag":
            warnings.warn( "MuMuMuTauTree: Expected branch m2JetCSVBtag does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2JetCSVBtag")
        else:
            self.m2JetCSVBtag_branch.SetAddress(<void*>&self.m2JetCSVBtag_value)

        #print "making m2JetEtaEtaMoment"
        self.m2JetEtaEtaMoment_branch = the_tree.GetBranch("m2JetEtaEtaMoment")
        #if not self.m2JetEtaEtaMoment_branch and "m2JetEtaEtaMoment" not in self.complained:
        if not self.m2JetEtaEtaMoment_branch and "m2JetEtaEtaMoment":
            warnings.warn( "MuMuMuTauTree: Expected branch m2JetEtaEtaMoment does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2JetEtaEtaMoment")
        else:
            self.m2JetEtaEtaMoment_branch.SetAddress(<void*>&self.m2JetEtaEtaMoment_value)

        #print "making m2JetEtaPhiMoment"
        self.m2JetEtaPhiMoment_branch = the_tree.GetBranch("m2JetEtaPhiMoment")
        #if not self.m2JetEtaPhiMoment_branch and "m2JetEtaPhiMoment" not in self.complained:
        if not self.m2JetEtaPhiMoment_branch and "m2JetEtaPhiMoment":
            warnings.warn( "MuMuMuTauTree: Expected branch m2JetEtaPhiMoment does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2JetEtaPhiMoment")
        else:
            self.m2JetEtaPhiMoment_branch.SetAddress(<void*>&self.m2JetEtaPhiMoment_value)

        #print "making m2JetEtaPhiSpread"
        self.m2JetEtaPhiSpread_branch = the_tree.GetBranch("m2JetEtaPhiSpread")
        #if not self.m2JetEtaPhiSpread_branch and "m2JetEtaPhiSpread" not in self.complained:
        if not self.m2JetEtaPhiSpread_branch and "m2JetEtaPhiSpread":
            warnings.warn( "MuMuMuTauTree: Expected branch m2JetEtaPhiSpread does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2JetEtaPhiSpread")
        else:
            self.m2JetEtaPhiSpread_branch.SetAddress(<void*>&self.m2JetEtaPhiSpread_value)

        #print "making m2JetPartonFlavour"
        self.m2JetPartonFlavour_branch = the_tree.GetBranch("m2JetPartonFlavour")
        #if not self.m2JetPartonFlavour_branch and "m2JetPartonFlavour" not in self.complained:
        if not self.m2JetPartonFlavour_branch and "m2JetPartonFlavour":
            warnings.warn( "MuMuMuTauTree: Expected branch m2JetPartonFlavour does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2JetPartonFlavour")
        else:
            self.m2JetPartonFlavour_branch.SetAddress(<void*>&self.m2JetPartonFlavour_value)

        #print "making m2JetPhiPhiMoment"
        self.m2JetPhiPhiMoment_branch = the_tree.GetBranch("m2JetPhiPhiMoment")
        #if not self.m2JetPhiPhiMoment_branch and "m2JetPhiPhiMoment" not in self.complained:
        if not self.m2JetPhiPhiMoment_branch and "m2JetPhiPhiMoment":
            warnings.warn( "MuMuMuTauTree: Expected branch m2JetPhiPhiMoment does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2JetPhiPhiMoment")
        else:
            self.m2JetPhiPhiMoment_branch.SetAddress(<void*>&self.m2JetPhiPhiMoment_value)

        #print "making m2JetPt"
        self.m2JetPt_branch = the_tree.GetBranch("m2JetPt")
        #if not self.m2JetPt_branch and "m2JetPt" not in self.complained:
        if not self.m2JetPt_branch and "m2JetPt":
            warnings.warn( "MuMuMuTauTree: Expected branch m2JetPt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2JetPt")
        else:
            self.m2JetPt_branch.SetAddress(<void*>&self.m2JetPt_value)

        #print "making m2JetQGLikelihoodID"
        self.m2JetQGLikelihoodID_branch = the_tree.GetBranch("m2JetQGLikelihoodID")
        #if not self.m2JetQGLikelihoodID_branch and "m2JetQGLikelihoodID" not in self.complained:
        if not self.m2JetQGLikelihoodID_branch and "m2JetQGLikelihoodID":
            warnings.warn( "MuMuMuTauTree: Expected branch m2JetQGLikelihoodID does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2JetQGLikelihoodID")
        else:
            self.m2JetQGLikelihoodID_branch.SetAddress(<void*>&self.m2JetQGLikelihoodID_value)

        #print "making m2JetQGMVAID"
        self.m2JetQGMVAID_branch = the_tree.GetBranch("m2JetQGMVAID")
        #if not self.m2JetQGMVAID_branch and "m2JetQGMVAID" not in self.complained:
        if not self.m2JetQGMVAID_branch and "m2JetQGMVAID":
            warnings.warn( "MuMuMuTauTree: Expected branch m2JetQGMVAID does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2JetQGMVAID")
        else:
            self.m2JetQGMVAID_branch.SetAddress(<void*>&self.m2JetQGMVAID_value)

        #print "making m2Jetaxis1"
        self.m2Jetaxis1_branch = the_tree.GetBranch("m2Jetaxis1")
        #if not self.m2Jetaxis1_branch and "m2Jetaxis1" not in self.complained:
        if not self.m2Jetaxis1_branch and "m2Jetaxis1":
            warnings.warn( "MuMuMuTauTree: Expected branch m2Jetaxis1 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2Jetaxis1")
        else:
            self.m2Jetaxis1_branch.SetAddress(<void*>&self.m2Jetaxis1_value)

        #print "making m2Jetaxis2"
        self.m2Jetaxis2_branch = the_tree.GetBranch("m2Jetaxis2")
        #if not self.m2Jetaxis2_branch and "m2Jetaxis2" not in self.complained:
        if not self.m2Jetaxis2_branch and "m2Jetaxis2":
            warnings.warn( "MuMuMuTauTree: Expected branch m2Jetaxis2 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2Jetaxis2")
        else:
            self.m2Jetaxis2_branch.SetAddress(<void*>&self.m2Jetaxis2_value)

        #print "making m2Jetmult"
        self.m2Jetmult_branch = the_tree.GetBranch("m2Jetmult")
        #if not self.m2Jetmult_branch and "m2Jetmult" not in self.complained:
        if not self.m2Jetmult_branch and "m2Jetmult":
            warnings.warn( "MuMuMuTauTree: Expected branch m2Jetmult does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2Jetmult")
        else:
            self.m2Jetmult_branch.SetAddress(<void*>&self.m2Jetmult_value)

        #print "making m2JetmultMLP"
        self.m2JetmultMLP_branch = the_tree.GetBranch("m2JetmultMLP")
        #if not self.m2JetmultMLP_branch and "m2JetmultMLP" not in self.complained:
        if not self.m2JetmultMLP_branch and "m2JetmultMLP":
            warnings.warn( "MuMuMuTauTree: Expected branch m2JetmultMLP does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2JetmultMLP")
        else:
            self.m2JetmultMLP_branch.SetAddress(<void*>&self.m2JetmultMLP_value)

        #print "making m2JetmultMLPQC"
        self.m2JetmultMLPQC_branch = the_tree.GetBranch("m2JetmultMLPQC")
        #if not self.m2JetmultMLPQC_branch and "m2JetmultMLPQC" not in self.complained:
        if not self.m2JetmultMLPQC_branch and "m2JetmultMLPQC":
            warnings.warn( "MuMuMuTauTree: Expected branch m2JetmultMLPQC does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2JetmultMLPQC")
        else:
            self.m2JetmultMLPQC_branch.SetAddress(<void*>&self.m2JetmultMLPQC_value)

        #print "making m2JetptD"
        self.m2JetptD_branch = the_tree.GetBranch("m2JetptD")
        #if not self.m2JetptD_branch and "m2JetptD" not in self.complained:
        if not self.m2JetptD_branch and "m2JetptD":
            warnings.warn( "MuMuMuTauTree: Expected branch m2JetptD does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2JetptD")
        else:
            self.m2JetptD_branch.SetAddress(<void*>&self.m2JetptD_value)

        #print "making m2L1Mu3EG5L3Filtered17"
        self.m2L1Mu3EG5L3Filtered17_branch = the_tree.GetBranch("m2L1Mu3EG5L3Filtered17")
        #if not self.m2L1Mu3EG5L3Filtered17_branch and "m2L1Mu3EG5L3Filtered17" not in self.complained:
        if not self.m2L1Mu3EG5L3Filtered17_branch and "m2L1Mu3EG5L3Filtered17":
            warnings.warn( "MuMuMuTauTree: Expected branch m2L1Mu3EG5L3Filtered17 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2L1Mu3EG5L3Filtered17")
        else:
            self.m2L1Mu3EG5L3Filtered17_branch.SetAddress(<void*>&self.m2L1Mu3EG5L3Filtered17_value)

        #print "making m2L3fL1DoubleMu10MuOpenL1f0L2f10L3Filtered17"
        self.m2L3fL1DoubleMu10MuOpenL1f0L2f10L3Filtered17_branch = the_tree.GetBranch("m2L3fL1DoubleMu10MuOpenL1f0L2f10L3Filtered17")
        #if not self.m2L3fL1DoubleMu10MuOpenL1f0L2f10L3Filtered17_branch and "m2L3fL1DoubleMu10MuOpenL1f0L2f10L3Filtered17" not in self.complained:
        if not self.m2L3fL1DoubleMu10MuOpenL1f0L2f10L3Filtered17_branch and "m2L3fL1DoubleMu10MuOpenL1f0L2f10L3Filtered17":
            warnings.warn( "MuMuMuTauTree: Expected branch m2L3fL1DoubleMu10MuOpenL1f0L2f10L3Filtered17 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2L3fL1DoubleMu10MuOpenL1f0L2f10L3Filtered17")
        else:
            self.m2L3fL1DoubleMu10MuOpenL1f0L2f10L3Filtered17_branch.SetAddress(<void*>&self.m2L3fL1DoubleMu10MuOpenL1f0L2f10L3Filtered17_value)

        #print "making m2Mass"
        self.m2Mass_branch = the_tree.GetBranch("m2Mass")
        #if not self.m2Mass_branch and "m2Mass" not in self.complained:
        if not self.m2Mass_branch and "m2Mass":
            warnings.warn( "MuMuMuTauTree: Expected branch m2Mass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2Mass")
        else:
            self.m2Mass_branch.SetAddress(<void*>&self.m2Mass_value)

        #print "making m2MatchedStations"
        self.m2MatchedStations_branch = the_tree.GetBranch("m2MatchedStations")
        #if not self.m2MatchedStations_branch and "m2MatchedStations" not in self.complained:
        if not self.m2MatchedStations_branch and "m2MatchedStations":
            warnings.warn( "MuMuMuTauTree: Expected branch m2MatchedStations does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2MatchedStations")
        else:
            self.m2MatchedStations_branch.SetAddress(<void*>&self.m2MatchedStations_value)

        #print "making m2MatchesDoubleMuPaths"
        self.m2MatchesDoubleMuPaths_branch = the_tree.GetBranch("m2MatchesDoubleMuPaths")
        #if not self.m2MatchesDoubleMuPaths_branch and "m2MatchesDoubleMuPaths" not in self.complained:
        if not self.m2MatchesDoubleMuPaths_branch and "m2MatchesDoubleMuPaths":
            warnings.warn( "MuMuMuTauTree: Expected branch m2MatchesDoubleMuPaths does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2MatchesDoubleMuPaths")
        else:
            self.m2MatchesDoubleMuPaths_branch.SetAddress(<void*>&self.m2MatchesDoubleMuPaths_value)

        #print "making m2MatchesDoubleMuTrkPaths"
        self.m2MatchesDoubleMuTrkPaths_branch = the_tree.GetBranch("m2MatchesDoubleMuTrkPaths")
        #if not self.m2MatchesDoubleMuTrkPaths_branch and "m2MatchesDoubleMuTrkPaths" not in self.complained:
        if not self.m2MatchesDoubleMuTrkPaths_branch and "m2MatchesDoubleMuTrkPaths":
            warnings.warn( "MuMuMuTauTree: Expected branch m2MatchesDoubleMuTrkPaths does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2MatchesDoubleMuTrkPaths")
        else:
            self.m2MatchesDoubleMuTrkPaths_branch.SetAddress(<void*>&self.m2MatchesDoubleMuTrkPaths_value)

        #print "making m2MatchesIsoMu24eta2p1"
        self.m2MatchesIsoMu24eta2p1_branch = the_tree.GetBranch("m2MatchesIsoMu24eta2p1")
        #if not self.m2MatchesIsoMu24eta2p1_branch and "m2MatchesIsoMu24eta2p1" not in self.complained:
        if not self.m2MatchesIsoMu24eta2p1_branch and "m2MatchesIsoMu24eta2p1":
            warnings.warn( "MuMuMuTauTree: Expected branch m2MatchesIsoMu24eta2p1 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2MatchesIsoMu24eta2p1")
        else:
            self.m2MatchesIsoMu24eta2p1_branch.SetAddress(<void*>&self.m2MatchesIsoMu24eta2p1_value)

        #print "making m2MatchesIsoMuGroup"
        self.m2MatchesIsoMuGroup_branch = the_tree.GetBranch("m2MatchesIsoMuGroup")
        #if not self.m2MatchesIsoMuGroup_branch and "m2MatchesIsoMuGroup" not in self.complained:
        if not self.m2MatchesIsoMuGroup_branch and "m2MatchesIsoMuGroup":
            warnings.warn( "MuMuMuTauTree: Expected branch m2MatchesIsoMuGroup does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2MatchesIsoMuGroup")
        else:
            self.m2MatchesIsoMuGroup_branch.SetAddress(<void*>&self.m2MatchesIsoMuGroup_value)

        #print "making m2MatchesMu17Ele8IsoPath"
        self.m2MatchesMu17Ele8IsoPath_branch = the_tree.GetBranch("m2MatchesMu17Ele8IsoPath")
        #if not self.m2MatchesMu17Ele8IsoPath_branch and "m2MatchesMu17Ele8IsoPath" not in self.complained:
        if not self.m2MatchesMu17Ele8IsoPath_branch and "m2MatchesMu17Ele8IsoPath":
            warnings.warn( "MuMuMuTauTree: Expected branch m2MatchesMu17Ele8IsoPath does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2MatchesMu17Ele8IsoPath")
        else:
            self.m2MatchesMu17Ele8IsoPath_branch.SetAddress(<void*>&self.m2MatchesMu17Ele8IsoPath_value)

        #print "making m2MatchesMu17Ele8Path"
        self.m2MatchesMu17Ele8Path_branch = the_tree.GetBranch("m2MatchesMu17Ele8Path")
        #if not self.m2MatchesMu17Ele8Path_branch and "m2MatchesMu17Ele8Path" not in self.complained:
        if not self.m2MatchesMu17Ele8Path_branch and "m2MatchesMu17Ele8Path":
            warnings.warn( "MuMuMuTauTree: Expected branch m2MatchesMu17Ele8Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2MatchesMu17Ele8Path")
        else:
            self.m2MatchesMu17Ele8Path_branch.SetAddress(<void*>&self.m2MatchesMu17Ele8Path_value)

        #print "making m2MatchesMu17Mu8Path"
        self.m2MatchesMu17Mu8Path_branch = the_tree.GetBranch("m2MatchesMu17Mu8Path")
        #if not self.m2MatchesMu17Mu8Path_branch and "m2MatchesMu17Mu8Path" not in self.complained:
        if not self.m2MatchesMu17Mu8Path_branch and "m2MatchesMu17Mu8Path":
            warnings.warn( "MuMuMuTauTree: Expected branch m2MatchesMu17Mu8Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2MatchesMu17Mu8Path")
        else:
            self.m2MatchesMu17Mu8Path_branch.SetAddress(<void*>&self.m2MatchesMu17Mu8Path_value)

        #print "making m2MatchesMu17TrkMu8Path"
        self.m2MatchesMu17TrkMu8Path_branch = the_tree.GetBranch("m2MatchesMu17TrkMu8Path")
        #if not self.m2MatchesMu17TrkMu8Path_branch and "m2MatchesMu17TrkMu8Path" not in self.complained:
        if not self.m2MatchesMu17TrkMu8Path_branch and "m2MatchesMu17TrkMu8Path":
            warnings.warn( "MuMuMuTauTree: Expected branch m2MatchesMu17TrkMu8Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2MatchesMu17TrkMu8Path")
        else:
            self.m2MatchesMu17TrkMu8Path_branch.SetAddress(<void*>&self.m2MatchesMu17TrkMu8Path_value)

        #print "making m2MatchesMu8Ele17IsoPath"
        self.m2MatchesMu8Ele17IsoPath_branch = the_tree.GetBranch("m2MatchesMu8Ele17IsoPath")
        #if not self.m2MatchesMu8Ele17IsoPath_branch and "m2MatchesMu8Ele17IsoPath" not in self.complained:
        if not self.m2MatchesMu8Ele17IsoPath_branch and "m2MatchesMu8Ele17IsoPath":
            warnings.warn( "MuMuMuTauTree: Expected branch m2MatchesMu8Ele17IsoPath does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2MatchesMu8Ele17IsoPath")
        else:
            self.m2MatchesMu8Ele17IsoPath_branch.SetAddress(<void*>&self.m2MatchesMu8Ele17IsoPath_value)

        #print "making m2MatchesMu8Ele17Path"
        self.m2MatchesMu8Ele17Path_branch = the_tree.GetBranch("m2MatchesMu8Ele17Path")
        #if not self.m2MatchesMu8Ele17Path_branch and "m2MatchesMu8Ele17Path" not in self.complained:
        if not self.m2MatchesMu8Ele17Path_branch and "m2MatchesMu8Ele17Path":
            warnings.warn( "MuMuMuTauTree: Expected branch m2MatchesMu8Ele17Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2MatchesMu8Ele17Path")
        else:
            self.m2MatchesMu8Ele17Path_branch.SetAddress(<void*>&self.m2MatchesMu8Ele17Path_value)

        #print "making m2MtToMET"
        self.m2MtToMET_branch = the_tree.GetBranch("m2MtToMET")
        #if not self.m2MtToMET_branch and "m2MtToMET" not in self.complained:
        if not self.m2MtToMET_branch and "m2MtToMET":
            warnings.warn( "MuMuMuTauTree: Expected branch m2MtToMET does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2MtToMET")
        else:
            self.m2MtToMET_branch.SetAddress(<void*>&self.m2MtToMET_value)

        #print "making m2MtToMVAMET"
        self.m2MtToMVAMET_branch = the_tree.GetBranch("m2MtToMVAMET")
        #if not self.m2MtToMVAMET_branch and "m2MtToMVAMET" not in self.complained:
        if not self.m2MtToMVAMET_branch and "m2MtToMVAMET":
            warnings.warn( "MuMuMuTauTree: Expected branch m2MtToMVAMET does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2MtToMVAMET")
        else:
            self.m2MtToMVAMET_branch.SetAddress(<void*>&self.m2MtToMVAMET_value)

        #print "making m2MtToPFMET"
        self.m2MtToPFMET_branch = the_tree.GetBranch("m2MtToPFMET")
        #if not self.m2MtToPFMET_branch and "m2MtToPFMET" not in self.complained:
        if not self.m2MtToPFMET_branch and "m2MtToPFMET":
            warnings.warn( "MuMuMuTauTree: Expected branch m2MtToPFMET does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2MtToPFMET")
        else:
            self.m2MtToPFMET_branch.SetAddress(<void*>&self.m2MtToPFMET_value)

        #print "making m2MtToPfMet_Ty1"
        self.m2MtToPfMet_Ty1_branch = the_tree.GetBranch("m2MtToPfMet_Ty1")
        #if not self.m2MtToPfMet_Ty1_branch and "m2MtToPfMet_Ty1" not in self.complained:
        if not self.m2MtToPfMet_Ty1_branch and "m2MtToPfMet_Ty1":
            warnings.warn( "MuMuMuTauTree: Expected branch m2MtToPfMet_Ty1 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2MtToPfMet_Ty1")
        else:
            self.m2MtToPfMet_Ty1_branch.SetAddress(<void*>&self.m2MtToPfMet_Ty1_value)

        #print "making m2MtToPfMet_jes"
        self.m2MtToPfMet_jes_branch = the_tree.GetBranch("m2MtToPfMet_jes")
        #if not self.m2MtToPfMet_jes_branch and "m2MtToPfMet_jes" not in self.complained:
        if not self.m2MtToPfMet_jes_branch and "m2MtToPfMet_jes":
            warnings.warn( "MuMuMuTauTree: Expected branch m2MtToPfMet_jes does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2MtToPfMet_jes")
        else:
            self.m2MtToPfMet_jes_branch.SetAddress(<void*>&self.m2MtToPfMet_jes_value)

        #print "making m2MtToPfMet_mes"
        self.m2MtToPfMet_mes_branch = the_tree.GetBranch("m2MtToPfMet_mes")
        #if not self.m2MtToPfMet_mes_branch and "m2MtToPfMet_mes" not in self.complained:
        if not self.m2MtToPfMet_mes_branch and "m2MtToPfMet_mes":
            warnings.warn( "MuMuMuTauTree: Expected branch m2MtToPfMet_mes does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2MtToPfMet_mes")
        else:
            self.m2MtToPfMet_mes_branch.SetAddress(<void*>&self.m2MtToPfMet_mes_value)

        #print "making m2MtToPfMet_tes"
        self.m2MtToPfMet_tes_branch = the_tree.GetBranch("m2MtToPfMet_tes")
        #if not self.m2MtToPfMet_tes_branch and "m2MtToPfMet_tes" not in self.complained:
        if not self.m2MtToPfMet_tes_branch and "m2MtToPfMet_tes":
            warnings.warn( "MuMuMuTauTree: Expected branch m2MtToPfMet_tes does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2MtToPfMet_tes")
        else:
            self.m2MtToPfMet_tes_branch.SetAddress(<void*>&self.m2MtToPfMet_tes_value)

        #print "making m2MtToPfMet_ues"
        self.m2MtToPfMet_ues_branch = the_tree.GetBranch("m2MtToPfMet_ues")
        #if not self.m2MtToPfMet_ues_branch and "m2MtToPfMet_ues" not in self.complained:
        if not self.m2MtToPfMet_ues_branch and "m2MtToPfMet_ues":
            warnings.warn( "MuMuMuTauTree: Expected branch m2MtToPfMet_ues does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2MtToPfMet_ues")
        else:
            self.m2MtToPfMet_ues_branch.SetAddress(<void*>&self.m2MtToPfMet_ues_value)

        #print "making m2Mu17Ele8dZFilter"
        self.m2Mu17Ele8dZFilter_branch = the_tree.GetBranch("m2Mu17Ele8dZFilter")
        #if not self.m2Mu17Ele8dZFilter_branch and "m2Mu17Ele8dZFilter" not in self.complained:
        if not self.m2Mu17Ele8dZFilter_branch and "m2Mu17Ele8dZFilter":
            warnings.warn( "MuMuMuTauTree: Expected branch m2Mu17Ele8dZFilter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2Mu17Ele8dZFilter")
        else:
            self.m2Mu17Ele8dZFilter_branch.SetAddress(<void*>&self.m2Mu17Ele8dZFilter_value)

        #print "making m2MuonHits"
        self.m2MuonHits_branch = the_tree.GetBranch("m2MuonHits")
        #if not self.m2MuonHits_branch and "m2MuonHits" not in self.complained:
        if not self.m2MuonHits_branch and "m2MuonHits":
            warnings.warn( "MuMuMuTauTree: Expected branch m2MuonHits does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2MuonHits")
        else:
            self.m2MuonHits_branch.SetAddress(<void*>&self.m2MuonHits_value)

        #print "making m2NormTrkChi2"
        self.m2NormTrkChi2_branch = the_tree.GetBranch("m2NormTrkChi2")
        #if not self.m2NormTrkChi2_branch and "m2NormTrkChi2" not in self.complained:
        if not self.m2NormTrkChi2_branch and "m2NormTrkChi2":
            warnings.warn( "MuMuMuTauTree: Expected branch m2NormTrkChi2 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2NormTrkChi2")
        else:
            self.m2NormTrkChi2_branch.SetAddress(<void*>&self.m2NormTrkChi2_value)

        #print "making m2PFChargedIso"
        self.m2PFChargedIso_branch = the_tree.GetBranch("m2PFChargedIso")
        #if not self.m2PFChargedIso_branch and "m2PFChargedIso" not in self.complained:
        if not self.m2PFChargedIso_branch and "m2PFChargedIso":
            warnings.warn( "MuMuMuTauTree: Expected branch m2PFChargedIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2PFChargedIso")
        else:
            self.m2PFChargedIso_branch.SetAddress(<void*>&self.m2PFChargedIso_value)

        #print "making m2PFIDTight"
        self.m2PFIDTight_branch = the_tree.GetBranch("m2PFIDTight")
        #if not self.m2PFIDTight_branch and "m2PFIDTight" not in self.complained:
        if not self.m2PFIDTight_branch and "m2PFIDTight":
            warnings.warn( "MuMuMuTauTree: Expected branch m2PFIDTight does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2PFIDTight")
        else:
            self.m2PFIDTight_branch.SetAddress(<void*>&self.m2PFIDTight_value)

        #print "making m2PFNeutralIso"
        self.m2PFNeutralIso_branch = the_tree.GetBranch("m2PFNeutralIso")
        #if not self.m2PFNeutralIso_branch and "m2PFNeutralIso" not in self.complained:
        if not self.m2PFNeutralIso_branch and "m2PFNeutralIso":
            warnings.warn( "MuMuMuTauTree: Expected branch m2PFNeutralIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2PFNeutralIso")
        else:
            self.m2PFNeutralIso_branch.SetAddress(<void*>&self.m2PFNeutralIso_value)

        #print "making m2PFPUChargedIso"
        self.m2PFPUChargedIso_branch = the_tree.GetBranch("m2PFPUChargedIso")
        #if not self.m2PFPUChargedIso_branch and "m2PFPUChargedIso" not in self.complained:
        if not self.m2PFPUChargedIso_branch and "m2PFPUChargedIso":
            warnings.warn( "MuMuMuTauTree: Expected branch m2PFPUChargedIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2PFPUChargedIso")
        else:
            self.m2PFPUChargedIso_branch.SetAddress(<void*>&self.m2PFPUChargedIso_value)

        #print "making m2PFPhotonIso"
        self.m2PFPhotonIso_branch = the_tree.GetBranch("m2PFPhotonIso")
        #if not self.m2PFPhotonIso_branch and "m2PFPhotonIso" not in self.complained:
        if not self.m2PFPhotonIso_branch and "m2PFPhotonIso":
            warnings.warn( "MuMuMuTauTree: Expected branch m2PFPhotonIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2PFPhotonIso")
        else:
            self.m2PFPhotonIso_branch.SetAddress(<void*>&self.m2PFPhotonIso_value)

        #print "making m2PVDXY"
        self.m2PVDXY_branch = the_tree.GetBranch("m2PVDXY")
        #if not self.m2PVDXY_branch and "m2PVDXY" not in self.complained:
        if not self.m2PVDXY_branch and "m2PVDXY":
            warnings.warn( "MuMuMuTauTree: Expected branch m2PVDXY does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2PVDXY")
        else:
            self.m2PVDXY_branch.SetAddress(<void*>&self.m2PVDXY_value)

        #print "making m2PVDZ"
        self.m2PVDZ_branch = the_tree.GetBranch("m2PVDZ")
        #if not self.m2PVDZ_branch and "m2PVDZ" not in self.complained:
        if not self.m2PVDZ_branch and "m2PVDZ":
            warnings.warn( "MuMuMuTauTree: Expected branch m2PVDZ does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2PVDZ")
        else:
            self.m2PVDZ_branch.SetAddress(<void*>&self.m2PVDZ_value)

        #print "making m2Phi"
        self.m2Phi_branch = the_tree.GetBranch("m2Phi")
        #if not self.m2Phi_branch and "m2Phi" not in self.complained:
        if not self.m2Phi_branch and "m2Phi":
            warnings.warn( "MuMuMuTauTree: Expected branch m2Phi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2Phi")
        else:
            self.m2Phi_branch.SetAddress(<void*>&self.m2Phi_value)

        #print "making m2PhiRochCor2011A"
        self.m2PhiRochCor2011A_branch = the_tree.GetBranch("m2PhiRochCor2011A")
        #if not self.m2PhiRochCor2011A_branch and "m2PhiRochCor2011A" not in self.complained:
        if not self.m2PhiRochCor2011A_branch and "m2PhiRochCor2011A":
            warnings.warn( "MuMuMuTauTree: Expected branch m2PhiRochCor2011A does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2PhiRochCor2011A")
        else:
            self.m2PhiRochCor2011A_branch.SetAddress(<void*>&self.m2PhiRochCor2011A_value)

        #print "making m2PhiRochCor2011B"
        self.m2PhiRochCor2011B_branch = the_tree.GetBranch("m2PhiRochCor2011B")
        #if not self.m2PhiRochCor2011B_branch and "m2PhiRochCor2011B" not in self.complained:
        if not self.m2PhiRochCor2011B_branch and "m2PhiRochCor2011B":
            warnings.warn( "MuMuMuTauTree: Expected branch m2PhiRochCor2011B does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2PhiRochCor2011B")
        else:
            self.m2PhiRochCor2011B_branch.SetAddress(<void*>&self.m2PhiRochCor2011B_value)

        #print "making m2PhiRochCor2012"
        self.m2PhiRochCor2012_branch = the_tree.GetBranch("m2PhiRochCor2012")
        #if not self.m2PhiRochCor2012_branch and "m2PhiRochCor2012" not in self.complained:
        if not self.m2PhiRochCor2012_branch and "m2PhiRochCor2012":
            warnings.warn( "MuMuMuTauTree: Expected branch m2PhiRochCor2012 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2PhiRochCor2012")
        else:
            self.m2PhiRochCor2012_branch.SetAddress(<void*>&self.m2PhiRochCor2012_value)

        #print "making m2PixHits"
        self.m2PixHits_branch = the_tree.GetBranch("m2PixHits")
        #if not self.m2PixHits_branch and "m2PixHits" not in self.complained:
        if not self.m2PixHits_branch and "m2PixHits":
            warnings.warn( "MuMuMuTauTree: Expected branch m2PixHits does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2PixHits")
        else:
            self.m2PixHits_branch.SetAddress(<void*>&self.m2PixHits_value)

        #print "making m2Pt"
        self.m2Pt_branch = the_tree.GetBranch("m2Pt")
        #if not self.m2Pt_branch and "m2Pt" not in self.complained:
        if not self.m2Pt_branch and "m2Pt":
            warnings.warn( "MuMuMuTauTree: Expected branch m2Pt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2Pt")
        else:
            self.m2Pt_branch.SetAddress(<void*>&self.m2Pt_value)

        #print "making m2PtRochCor2011A"
        self.m2PtRochCor2011A_branch = the_tree.GetBranch("m2PtRochCor2011A")
        #if not self.m2PtRochCor2011A_branch and "m2PtRochCor2011A" not in self.complained:
        if not self.m2PtRochCor2011A_branch and "m2PtRochCor2011A":
            warnings.warn( "MuMuMuTauTree: Expected branch m2PtRochCor2011A does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2PtRochCor2011A")
        else:
            self.m2PtRochCor2011A_branch.SetAddress(<void*>&self.m2PtRochCor2011A_value)

        #print "making m2PtRochCor2011B"
        self.m2PtRochCor2011B_branch = the_tree.GetBranch("m2PtRochCor2011B")
        #if not self.m2PtRochCor2011B_branch and "m2PtRochCor2011B" not in self.complained:
        if not self.m2PtRochCor2011B_branch and "m2PtRochCor2011B":
            warnings.warn( "MuMuMuTauTree: Expected branch m2PtRochCor2011B does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2PtRochCor2011B")
        else:
            self.m2PtRochCor2011B_branch.SetAddress(<void*>&self.m2PtRochCor2011B_value)

        #print "making m2PtRochCor2012"
        self.m2PtRochCor2012_branch = the_tree.GetBranch("m2PtRochCor2012")
        #if not self.m2PtRochCor2012_branch and "m2PtRochCor2012" not in self.complained:
        if not self.m2PtRochCor2012_branch and "m2PtRochCor2012":
            warnings.warn( "MuMuMuTauTree: Expected branch m2PtRochCor2012 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2PtRochCor2012")
        else:
            self.m2PtRochCor2012_branch.SetAddress(<void*>&self.m2PtRochCor2012_value)

        #print "making m2Rank"
        self.m2Rank_branch = the_tree.GetBranch("m2Rank")
        #if not self.m2Rank_branch and "m2Rank" not in self.complained:
        if not self.m2Rank_branch and "m2Rank":
            warnings.warn( "MuMuMuTauTree: Expected branch m2Rank does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2Rank")
        else:
            self.m2Rank_branch.SetAddress(<void*>&self.m2Rank_value)

        #print "making m2RelPFIsoDB"
        self.m2RelPFIsoDB_branch = the_tree.GetBranch("m2RelPFIsoDB")
        #if not self.m2RelPFIsoDB_branch and "m2RelPFIsoDB" not in self.complained:
        if not self.m2RelPFIsoDB_branch and "m2RelPFIsoDB":
            warnings.warn( "MuMuMuTauTree: Expected branch m2RelPFIsoDB does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2RelPFIsoDB")
        else:
            self.m2RelPFIsoDB_branch.SetAddress(<void*>&self.m2RelPFIsoDB_value)

        #print "making m2RelPFIsoRho"
        self.m2RelPFIsoRho_branch = the_tree.GetBranch("m2RelPFIsoRho")
        #if not self.m2RelPFIsoRho_branch and "m2RelPFIsoRho" not in self.complained:
        if not self.m2RelPFIsoRho_branch and "m2RelPFIsoRho":
            warnings.warn( "MuMuMuTauTree: Expected branch m2RelPFIsoRho does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2RelPFIsoRho")
        else:
            self.m2RelPFIsoRho_branch.SetAddress(<void*>&self.m2RelPFIsoRho_value)

        #print "making m2RelPFIsoRhoFSR"
        self.m2RelPFIsoRhoFSR_branch = the_tree.GetBranch("m2RelPFIsoRhoFSR")
        #if not self.m2RelPFIsoRhoFSR_branch and "m2RelPFIsoRhoFSR" not in self.complained:
        if not self.m2RelPFIsoRhoFSR_branch and "m2RelPFIsoRhoFSR":
            warnings.warn( "MuMuMuTauTree: Expected branch m2RelPFIsoRhoFSR does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2RelPFIsoRhoFSR")
        else:
            self.m2RelPFIsoRhoFSR_branch.SetAddress(<void*>&self.m2RelPFIsoRhoFSR_value)

        #print "making m2RhoHZG2011"
        self.m2RhoHZG2011_branch = the_tree.GetBranch("m2RhoHZG2011")
        #if not self.m2RhoHZG2011_branch and "m2RhoHZG2011" not in self.complained:
        if not self.m2RhoHZG2011_branch and "m2RhoHZG2011":
            warnings.warn( "MuMuMuTauTree: Expected branch m2RhoHZG2011 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2RhoHZG2011")
        else:
            self.m2RhoHZG2011_branch.SetAddress(<void*>&self.m2RhoHZG2011_value)

        #print "making m2RhoHZG2012"
        self.m2RhoHZG2012_branch = the_tree.GetBranch("m2RhoHZG2012")
        #if not self.m2RhoHZG2012_branch and "m2RhoHZG2012" not in self.complained:
        if not self.m2RhoHZG2012_branch and "m2RhoHZG2012":
            warnings.warn( "MuMuMuTauTree: Expected branch m2RhoHZG2012 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2RhoHZG2012")
        else:
            self.m2RhoHZG2012_branch.SetAddress(<void*>&self.m2RhoHZG2012_value)

        #print "making m2SingleMu13L3Filtered13"
        self.m2SingleMu13L3Filtered13_branch = the_tree.GetBranch("m2SingleMu13L3Filtered13")
        #if not self.m2SingleMu13L3Filtered13_branch and "m2SingleMu13L3Filtered13" not in self.complained:
        if not self.m2SingleMu13L3Filtered13_branch and "m2SingleMu13L3Filtered13":
            warnings.warn( "MuMuMuTauTree: Expected branch m2SingleMu13L3Filtered13 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2SingleMu13L3Filtered13")
        else:
            self.m2SingleMu13L3Filtered13_branch.SetAddress(<void*>&self.m2SingleMu13L3Filtered13_value)

        #print "making m2SingleMu13L3Filtered17"
        self.m2SingleMu13L3Filtered17_branch = the_tree.GetBranch("m2SingleMu13L3Filtered17")
        #if not self.m2SingleMu13L3Filtered17_branch and "m2SingleMu13L3Filtered17" not in self.complained:
        if not self.m2SingleMu13L3Filtered17_branch and "m2SingleMu13L3Filtered17":
            warnings.warn( "MuMuMuTauTree: Expected branch m2SingleMu13L3Filtered17 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2SingleMu13L3Filtered17")
        else:
            self.m2SingleMu13L3Filtered17_branch.SetAddress(<void*>&self.m2SingleMu13L3Filtered17_value)

        #print "making m2TkLayersWithMeasurement"
        self.m2TkLayersWithMeasurement_branch = the_tree.GetBranch("m2TkLayersWithMeasurement")
        #if not self.m2TkLayersWithMeasurement_branch and "m2TkLayersWithMeasurement" not in self.complained:
        if not self.m2TkLayersWithMeasurement_branch and "m2TkLayersWithMeasurement":
            warnings.warn( "MuMuMuTauTree: Expected branch m2TkLayersWithMeasurement does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2TkLayersWithMeasurement")
        else:
            self.m2TkLayersWithMeasurement_branch.SetAddress(<void*>&self.m2TkLayersWithMeasurement_value)

        #print "making m2ToMETDPhi"
        self.m2ToMETDPhi_branch = the_tree.GetBranch("m2ToMETDPhi")
        #if not self.m2ToMETDPhi_branch and "m2ToMETDPhi" not in self.complained:
        if not self.m2ToMETDPhi_branch and "m2ToMETDPhi":
            warnings.warn( "MuMuMuTauTree: Expected branch m2ToMETDPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2ToMETDPhi")
        else:
            self.m2ToMETDPhi_branch.SetAddress(<void*>&self.m2ToMETDPhi_value)

        #print "making m2TypeCode"
        self.m2TypeCode_branch = the_tree.GetBranch("m2TypeCode")
        #if not self.m2TypeCode_branch and "m2TypeCode" not in self.complained:
        if not self.m2TypeCode_branch and "m2TypeCode":
            warnings.warn( "MuMuMuTauTree: Expected branch m2TypeCode does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2TypeCode")
        else:
            self.m2TypeCode_branch.SetAddress(<void*>&self.m2TypeCode_value)

        #print "making m2VBTFID"
        self.m2VBTFID_branch = the_tree.GetBranch("m2VBTFID")
        #if not self.m2VBTFID_branch and "m2VBTFID" not in self.complained:
        if not self.m2VBTFID_branch and "m2VBTFID":
            warnings.warn( "MuMuMuTauTree: Expected branch m2VBTFID does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2VBTFID")
        else:
            self.m2VBTFID_branch.SetAddress(<void*>&self.m2VBTFID_value)

        #print "making m2VZ"
        self.m2VZ_branch = the_tree.GetBranch("m2VZ")
        #if not self.m2VZ_branch and "m2VZ" not in self.complained:
        if not self.m2VZ_branch and "m2VZ":
            warnings.warn( "MuMuMuTauTree: Expected branch m2VZ does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2VZ")
        else:
            self.m2VZ_branch.SetAddress(<void*>&self.m2VZ_value)

        #print "making m2WWID"
        self.m2WWID_branch = the_tree.GetBranch("m2WWID")
        #if not self.m2WWID_branch and "m2WWID" not in self.complained:
        if not self.m2WWID_branch and "m2WWID":
            warnings.warn( "MuMuMuTauTree: Expected branch m2WWID does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2WWID")
        else:
            self.m2WWID_branch.SetAddress(<void*>&self.m2WWID_value)

        #print "making m2_m3_CosThetaStar"
        self.m2_m3_CosThetaStar_branch = the_tree.GetBranch("m2_m3_CosThetaStar")
        #if not self.m2_m3_CosThetaStar_branch and "m2_m3_CosThetaStar" not in self.complained:
        if not self.m2_m3_CosThetaStar_branch and "m2_m3_CosThetaStar":
            warnings.warn( "MuMuMuTauTree: Expected branch m2_m3_CosThetaStar does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2_m3_CosThetaStar")
        else:
            self.m2_m3_CosThetaStar_branch.SetAddress(<void*>&self.m2_m3_CosThetaStar_value)

        #print "making m2_m3_DPhi"
        self.m2_m3_DPhi_branch = the_tree.GetBranch("m2_m3_DPhi")
        #if not self.m2_m3_DPhi_branch and "m2_m3_DPhi" not in self.complained:
        if not self.m2_m3_DPhi_branch and "m2_m3_DPhi":
            warnings.warn( "MuMuMuTauTree: Expected branch m2_m3_DPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2_m3_DPhi")
        else:
            self.m2_m3_DPhi_branch.SetAddress(<void*>&self.m2_m3_DPhi_value)

        #print "making m2_m3_DR"
        self.m2_m3_DR_branch = the_tree.GetBranch("m2_m3_DR")
        #if not self.m2_m3_DR_branch and "m2_m3_DR" not in self.complained:
        if not self.m2_m3_DR_branch and "m2_m3_DR":
            warnings.warn( "MuMuMuTauTree: Expected branch m2_m3_DR does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2_m3_DR")
        else:
            self.m2_m3_DR_branch.SetAddress(<void*>&self.m2_m3_DR_value)

        #print "making m2_m3_Eta"
        self.m2_m3_Eta_branch = the_tree.GetBranch("m2_m3_Eta")
        #if not self.m2_m3_Eta_branch and "m2_m3_Eta" not in self.complained:
        if not self.m2_m3_Eta_branch and "m2_m3_Eta":
            warnings.warn( "MuMuMuTauTree: Expected branch m2_m3_Eta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2_m3_Eta")
        else:
            self.m2_m3_Eta_branch.SetAddress(<void*>&self.m2_m3_Eta_value)

        #print "making m2_m3_Mass"
        self.m2_m3_Mass_branch = the_tree.GetBranch("m2_m3_Mass")
        #if not self.m2_m3_Mass_branch and "m2_m3_Mass" not in self.complained:
        if not self.m2_m3_Mass_branch and "m2_m3_Mass":
            warnings.warn( "MuMuMuTauTree: Expected branch m2_m3_Mass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2_m3_Mass")
        else:
            self.m2_m3_Mass_branch.SetAddress(<void*>&self.m2_m3_Mass_value)

        #print "making m2_m3_MassFsr"
        self.m2_m3_MassFsr_branch = the_tree.GetBranch("m2_m3_MassFsr")
        #if not self.m2_m3_MassFsr_branch and "m2_m3_MassFsr" not in self.complained:
        if not self.m2_m3_MassFsr_branch and "m2_m3_MassFsr":
            warnings.warn( "MuMuMuTauTree: Expected branch m2_m3_MassFsr does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2_m3_MassFsr")
        else:
            self.m2_m3_MassFsr_branch.SetAddress(<void*>&self.m2_m3_MassFsr_value)

        #print "making m2_m3_PZeta"
        self.m2_m3_PZeta_branch = the_tree.GetBranch("m2_m3_PZeta")
        #if not self.m2_m3_PZeta_branch and "m2_m3_PZeta" not in self.complained:
        if not self.m2_m3_PZeta_branch and "m2_m3_PZeta":
            warnings.warn( "MuMuMuTauTree: Expected branch m2_m3_PZeta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2_m3_PZeta")
        else:
            self.m2_m3_PZeta_branch.SetAddress(<void*>&self.m2_m3_PZeta_value)

        #print "making m2_m3_PZetaVis"
        self.m2_m3_PZetaVis_branch = the_tree.GetBranch("m2_m3_PZetaVis")
        #if not self.m2_m3_PZetaVis_branch and "m2_m3_PZetaVis" not in self.complained:
        if not self.m2_m3_PZetaVis_branch and "m2_m3_PZetaVis":
            warnings.warn( "MuMuMuTauTree: Expected branch m2_m3_PZetaVis does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2_m3_PZetaVis")
        else:
            self.m2_m3_PZetaVis_branch.SetAddress(<void*>&self.m2_m3_PZetaVis_value)

        #print "making m2_m3_Phi"
        self.m2_m3_Phi_branch = the_tree.GetBranch("m2_m3_Phi")
        #if not self.m2_m3_Phi_branch and "m2_m3_Phi" not in self.complained:
        if not self.m2_m3_Phi_branch and "m2_m3_Phi":
            warnings.warn( "MuMuMuTauTree: Expected branch m2_m3_Phi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2_m3_Phi")
        else:
            self.m2_m3_Phi_branch.SetAddress(<void*>&self.m2_m3_Phi_value)

        #print "making m2_m3_Pt"
        self.m2_m3_Pt_branch = the_tree.GetBranch("m2_m3_Pt")
        #if not self.m2_m3_Pt_branch and "m2_m3_Pt" not in self.complained:
        if not self.m2_m3_Pt_branch and "m2_m3_Pt":
            warnings.warn( "MuMuMuTauTree: Expected branch m2_m3_Pt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2_m3_Pt")
        else:
            self.m2_m3_Pt_branch.SetAddress(<void*>&self.m2_m3_Pt_value)

        #print "making m2_m3_PtFsr"
        self.m2_m3_PtFsr_branch = the_tree.GetBranch("m2_m3_PtFsr")
        #if not self.m2_m3_PtFsr_branch and "m2_m3_PtFsr" not in self.complained:
        if not self.m2_m3_PtFsr_branch and "m2_m3_PtFsr":
            warnings.warn( "MuMuMuTauTree: Expected branch m2_m3_PtFsr does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2_m3_PtFsr")
        else:
            self.m2_m3_PtFsr_branch.SetAddress(<void*>&self.m2_m3_PtFsr_value)

        #print "making m2_m3_SS"
        self.m2_m3_SS_branch = the_tree.GetBranch("m2_m3_SS")
        #if not self.m2_m3_SS_branch and "m2_m3_SS" not in self.complained:
        if not self.m2_m3_SS_branch and "m2_m3_SS":
            warnings.warn( "MuMuMuTauTree: Expected branch m2_m3_SS does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2_m3_SS")
        else:
            self.m2_m3_SS_branch.SetAddress(<void*>&self.m2_m3_SS_value)

        #print "making m2_m3_ToMETDPhi_Ty1"
        self.m2_m3_ToMETDPhi_Ty1_branch = the_tree.GetBranch("m2_m3_ToMETDPhi_Ty1")
        #if not self.m2_m3_ToMETDPhi_Ty1_branch and "m2_m3_ToMETDPhi_Ty1" not in self.complained:
        if not self.m2_m3_ToMETDPhi_Ty1_branch and "m2_m3_ToMETDPhi_Ty1":
            warnings.warn( "MuMuMuTauTree: Expected branch m2_m3_ToMETDPhi_Ty1 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2_m3_ToMETDPhi_Ty1")
        else:
            self.m2_m3_ToMETDPhi_Ty1_branch.SetAddress(<void*>&self.m2_m3_ToMETDPhi_Ty1_value)

        #print "making m2_m3_Zcompat"
        self.m2_m3_Zcompat_branch = the_tree.GetBranch("m2_m3_Zcompat")
        #if not self.m2_m3_Zcompat_branch and "m2_m3_Zcompat" not in self.complained:
        if not self.m2_m3_Zcompat_branch and "m2_m3_Zcompat":
            warnings.warn( "MuMuMuTauTree: Expected branch m2_m3_Zcompat does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2_m3_Zcompat")
        else:
            self.m2_m3_Zcompat_branch.SetAddress(<void*>&self.m2_m3_Zcompat_value)

        #print "making m2_t_CosThetaStar"
        self.m2_t_CosThetaStar_branch = the_tree.GetBranch("m2_t_CosThetaStar")
        #if not self.m2_t_CosThetaStar_branch and "m2_t_CosThetaStar" not in self.complained:
        if not self.m2_t_CosThetaStar_branch and "m2_t_CosThetaStar":
            warnings.warn( "MuMuMuTauTree: Expected branch m2_t_CosThetaStar does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2_t_CosThetaStar")
        else:
            self.m2_t_CosThetaStar_branch.SetAddress(<void*>&self.m2_t_CosThetaStar_value)

        #print "making m2_t_DPhi"
        self.m2_t_DPhi_branch = the_tree.GetBranch("m2_t_DPhi")
        #if not self.m2_t_DPhi_branch and "m2_t_DPhi" not in self.complained:
        if not self.m2_t_DPhi_branch and "m2_t_DPhi":
            warnings.warn( "MuMuMuTauTree: Expected branch m2_t_DPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2_t_DPhi")
        else:
            self.m2_t_DPhi_branch.SetAddress(<void*>&self.m2_t_DPhi_value)

        #print "making m2_t_DR"
        self.m2_t_DR_branch = the_tree.GetBranch("m2_t_DR")
        #if not self.m2_t_DR_branch and "m2_t_DR" not in self.complained:
        if not self.m2_t_DR_branch and "m2_t_DR":
            warnings.warn( "MuMuMuTauTree: Expected branch m2_t_DR does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2_t_DR")
        else:
            self.m2_t_DR_branch.SetAddress(<void*>&self.m2_t_DR_value)

        #print "making m2_t_Eta"
        self.m2_t_Eta_branch = the_tree.GetBranch("m2_t_Eta")
        #if not self.m2_t_Eta_branch and "m2_t_Eta" not in self.complained:
        if not self.m2_t_Eta_branch and "m2_t_Eta":
            warnings.warn( "MuMuMuTauTree: Expected branch m2_t_Eta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2_t_Eta")
        else:
            self.m2_t_Eta_branch.SetAddress(<void*>&self.m2_t_Eta_value)

        #print "making m2_t_Mass"
        self.m2_t_Mass_branch = the_tree.GetBranch("m2_t_Mass")
        #if not self.m2_t_Mass_branch and "m2_t_Mass" not in self.complained:
        if not self.m2_t_Mass_branch and "m2_t_Mass":
            warnings.warn( "MuMuMuTauTree: Expected branch m2_t_Mass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2_t_Mass")
        else:
            self.m2_t_Mass_branch.SetAddress(<void*>&self.m2_t_Mass_value)

        #print "making m2_t_MassFsr"
        self.m2_t_MassFsr_branch = the_tree.GetBranch("m2_t_MassFsr")
        #if not self.m2_t_MassFsr_branch and "m2_t_MassFsr" not in self.complained:
        if not self.m2_t_MassFsr_branch and "m2_t_MassFsr":
            warnings.warn( "MuMuMuTauTree: Expected branch m2_t_MassFsr does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2_t_MassFsr")
        else:
            self.m2_t_MassFsr_branch.SetAddress(<void*>&self.m2_t_MassFsr_value)

        #print "making m2_t_PZeta"
        self.m2_t_PZeta_branch = the_tree.GetBranch("m2_t_PZeta")
        #if not self.m2_t_PZeta_branch and "m2_t_PZeta" not in self.complained:
        if not self.m2_t_PZeta_branch and "m2_t_PZeta":
            warnings.warn( "MuMuMuTauTree: Expected branch m2_t_PZeta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2_t_PZeta")
        else:
            self.m2_t_PZeta_branch.SetAddress(<void*>&self.m2_t_PZeta_value)

        #print "making m2_t_PZetaVis"
        self.m2_t_PZetaVis_branch = the_tree.GetBranch("m2_t_PZetaVis")
        #if not self.m2_t_PZetaVis_branch and "m2_t_PZetaVis" not in self.complained:
        if not self.m2_t_PZetaVis_branch and "m2_t_PZetaVis":
            warnings.warn( "MuMuMuTauTree: Expected branch m2_t_PZetaVis does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2_t_PZetaVis")
        else:
            self.m2_t_PZetaVis_branch.SetAddress(<void*>&self.m2_t_PZetaVis_value)

        #print "making m2_t_Phi"
        self.m2_t_Phi_branch = the_tree.GetBranch("m2_t_Phi")
        #if not self.m2_t_Phi_branch and "m2_t_Phi" not in self.complained:
        if not self.m2_t_Phi_branch and "m2_t_Phi":
            warnings.warn( "MuMuMuTauTree: Expected branch m2_t_Phi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2_t_Phi")
        else:
            self.m2_t_Phi_branch.SetAddress(<void*>&self.m2_t_Phi_value)

        #print "making m2_t_Pt"
        self.m2_t_Pt_branch = the_tree.GetBranch("m2_t_Pt")
        #if not self.m2_t_Pt_branch and "m2_t_Pt" not in self.complained:
        if not self.m2_t_Pt_branch and "m2_t_Pt":
            warnings.warn( "MuMuMuTauTree: Expected branch m2_t_Pt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2_t_Pt")
        else:
            self.m2_t_Pt_branch.SetAddress(<void*>&self.m2_t_Pt_value)

        #print "making m2_t_PtFsr"
        self.m2_t_PtFsr_branch = the_tree.GetBranch("m2_t_PtFsr")
        #if not self.m2_t_PtFsr_branch and "m2_t_PtFsr" not in self.complained:
        if not self.m2_t_PtFsr_branch and "m2_t_PtFsr":
            warnings.warn( "MuMuMuTauTree: Expected branch m2_t_PtFsr does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2_t_PtFsr")
        else:
            self.m2_t_PtFsr_branch.SetAddress(<void*>&self.m2_t_PtFsr_value)

        #print "making m2_t_SS"
        self.m2_t_SS_branch = the_tree.GetBranch("m2_t_SS")
        #if not self.m2_t_SS_branch and "m2_t_SS" not in self.complained:
        if not self.m2_t_SS_branch and "m2_t_SS":
            warnings.warn( "MuMuMuTauTree: Expected branch m2_t_SS does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2_t_SS")
        else:
            self.m2_t_SS_branch.SetAddress(<void*>&self.m2_t_SS_value)

        #print "making m2_t_ToMETDPhi_Ty1"
        self.m2_t_ToMETDPhi_Ty1_branch = the_tree.GetBranch("m2_t_ToMETDPhi_Ty1")
        #if not self.m2_t_ToMETDPhi_Ty1_branch and "m2_t_ToMETDPhi_Ty1" not in self.complained:
        if not self.m2_t_ToMETDPhi_Ty1_branch and "m2_t_ToMETDPhi_Ty1":
            warnings.warn( "MuMuMuTauTree: Expected branch m2_t_ToMETDPhi_Ty1 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2_t_ToMETDPhi_Ty1")
        else:
            self.m2_t_ToMETDPhi_Ty1_branch.SetAddress(<void*>&self.m2_t_ToMETDPhi_Ty1_value)

        #print "making m2_t_Zcompat"
        self.m2_t_Zcompat_branch = the_tree.GetBranch("m2_t_Zcompat")
        #if not self.m2_t_Zcompat_branch and "m2_t_Zcompat" not in self.complained:
        if not self.m2_t_Zcompat_branch and "m2_t_Zcompat":
            warnings.warn( "MuMuMuTauTree: Expected branch m2_t_Zcompat does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2_t_Zcompat")
        else:
            self.m2_t_Zcompat_branch.SetAddress(<void*>&self.m2_t_Zcompat_value)

        #print "making m3AbsEta"
        self.m3AbsEta_branch = the_tree.GetBranch("m3AbsEta")
        #if not self.m3AbsEta_branch and "m3AbsEta" not in self.complained:
        if not self.m3AbsEta_branch and "m3AbsEta":
            warnings.warn( "MuMuMuTauTree: Expected branch m3AbsEta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3AbsEta")
        else:
            self.m3AbsEta_branch.SetAddress(<void*>&self.m3AbsEta_value)

        #print "making m3Charge"
        self.m3Charge_branch = the_tree.GetBranch("m3Charge")
        #if not self.m3Charge_branch and "m3Charge" not in self.complained:
        if not self.m3Charge_branch and "m3Charge":
            warnings.warn( "MuMuMuTauTree: Expected branch m3Charge does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3Charge")
        else:
            self.m3Charge_branch.SetAddress(<void*>&self.m3Charge_value)

        #print "making m3ComesFromHiggs"
        self.m3ComesFromHiggs_branch = the_tree.GetBranch("m3ComesFromHiggs")
        #if not self.m3ComesFromHiggs_branch and "m3ComesFromHiggs" not in self.complained:
        if not self.m3ComesFromHiggs_branch and "m3ComesFromHiggs":
            warnings.warn( "MuMuMuTauTree: Expected branch m3ComesFromHiggs does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3ComesFromHiggs")
        else:
            self.m3ComesFromHiggs_branch.SetAddress(<void*>&self.m3ComesFromHiggs_value)

        #print "making m3D0"
        self.m3D0_branch = the_tree.GetBranch("m3D0")
        #if not self.m3D0_branch and "m3D0" not in self.complained:
        if not self.m3D0_branch and "m3D0":
            warnings.warn( "MuMuMuTauTree: Expected branch m3D0 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3D0")
        else:
            self.m3D0_branch.SetAddress(<void*>&self.m3D0_value)

        #print "making m3DZ"
        self.m3DZ_branch = the_tree.GetBranch("m3DZ")
        #if not self.m3DZ_branch and "m3DZ" not in self.complained:
        if not self.m3DZ_branch and "m3DZ":
            warnings.warn( "MuMuMuTauTree: Expected branch m3DZ does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3DZ")
        else:
            self.m3DZ_branch.SetAddress(<void*>&self.m3DZ_value)

        #print "making m3DiMuonL3PreFiltered7"
        self.m3DiMuonL3PreFiltered7_branch = the_tree.GetBranch("m3DiMuonL3PreFiltered7")
        #if not self.m3DiMuonL3PreFiltered7_branch and "m3DiMuonL3PreFiltered7" not in self.complained:
        if not self.m3DiMuonL3PreFiltered7_branch and "m3DiMuonL3PreFiltered7":
            warnings.warn( "MuMuMuTauTree: Expected branch m3DiMuonL3PreFiltered7 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3DiMuonL3PreFiltered7")
        else:
            self.m3DiMuonL3PreFiltered7_branch.SetAddress(<void*>&self.m3DiMuonL3PreFiltered7_value)

        #print "making m3DiMuonL3p5PreFiltered8"
        self.m3DiMuonL3p5PreFiltered8_branch = the_tree.GetBranch("m3DiMuonL3p5PreFiltered8")
        #if not self.m3DiMuonL3p5PreFiltered8_branch and "m3DiMuonL3p5PreFiltered8" not in self.complained:
        if not self.m3DiMuonL3p5PreFiltered8_branch and "m3DiMuonL3p5PreFiltered8":
            warnings.warn( "MuMuMuTauTree: Expected branch m3DiMuonL3p5PreFiltered8 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3DiMuonL3p5PreFiltered8")
        else:
            self.m3DiMuonL3p5PreFiltered8_branch.SetAddress(<void*>&self.m3DiMuonL3p5PreFiltered8_value)

        #print "making m3DiMuonMu17Mu8DzFiltered0p2"
        self.m3DiMuonMu17Mu8DzFiltered0p2_branch = the_tree.GetBranch("m3DiMuonMu17Mu8DzFiltered0p2")
        #if not self.m3DiMuonMu17Mu8DzFiltered0p2_branch and "m3DiMuonMu17Mu8DzFiltered0p2" not in self.complained:
        if not self.m3DiMuonMu17Mu8DzFiltered0p2_branch and "m3DiMuonMu17Mu8DzFiltered0p2":
            warnings.warn( "MuMuMuTauTree: Expected branch m3DiMuonMu17Mu8DzFiltered0p2 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3DiMuonMu17Mu8DzFiltered0p2")
        else:
            self.m3DiMuonMu17Mu8DzFiltered0p2_branch.SetAddress(<void*>&self.m3DiMuonMu17Mu8DzFiltered0p2_value)

        #print "making m3EErrRochCor2011A"
        self.m3EErrRochCor2011A_branch = the_tree.GetBranch("m3EErrRochCor2011A")
        #if not self.m3EErrRochCor2011A_branch and "m3EErrRochCor2011A" not in self.complained:
        if not self.m3EErrRochCor2011A_branch and "m3EErrRochCor2011A":
            warnings.warn( "MuMuMuTauTree: Expected branch m3EErrRochCor2011A does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3EErrRochCor2011A")
        else:
            self.m3EErrRochCor2011A_branch.SetAddress(<void*>&self.m3EErrRochCor2011A_value)

        #print "making m3EErrRochCor2011B"
        self.m3EErrRochCor2011B_branch = the_tree.GetBranch("m3EErrRochCor2011B")
        #if not self.m3EErrRochCor2011B_branch and "m3EErrRochCor2011B" not in self.complained:
        if not self.m3EErrRochCor2011B_branch and "m3EErrRochCor2011B":
            warnings.warn( "MuMuMuTauTree: Expected branch m3EErrRochCor2011B does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3EErrRochCor2011B")
        else:
            self.m3EErrRochCor2011B_branch.SetAddress(<void*>&self.m3EErrRochCor2011B_value)

        #print "making m3EErrRochCor2012"
        self.m3EErrRochCor2012_branch = the_tree.GetBranch("m3EErrRochCor2012")
        #if not self.m3EErrRochCor2012_branch and "m3EErrRochCor2012" not in self.complained:
        if not self.m3EErrRochCor2012_branch and "m3EErrRochCor2012":
            warnings.warn( "MuMuMuTauTree: Expected branch m3EErrRochCor2012 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3EErrRochCor2012")
        else:
            self.m3EErrRochCor2012_branch.SetAddress(<void*>&self.m3EErrRochCor2012_value)

        #print "making m3ERochCor2011A"
        self.m3ERochCor2011A_branch = the_tree.GetBranch("m3ERochCor2011A")
        #if not self.m3ERochCor2011A_branch and "m3ERochCor2011A" not in self.complained:
        if not self.m3ERochCor2011A_branch and "m3ERochCor2011A":
            warnings.warn( "MuMuMuTauTree: Expected branch m3ERochCor2011A does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3ERochCor2011A")
        else:
            self.m3ERochCor2011A_branch.SetAddress(<void*>&self.m3ERochCor2011A_value)

        #print "making m3ERochCor2011B"
        self.m3ERochCor2011B_branch = the_tree.GetBranch("m3ERochCor2011B")
        #if not self.m3ERochCor2011B_branch and "m3ERochCor2011B" not in self.complained:
        if not self.m3ERochCor2011B_branch and "m3ERochCor2011B":
            warnings.warn( "MuMuMuTauTree: Expected branch m3ERochCor2011B does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3ERochCor2011B")
        else:
            self.m3ERochCor2011B_branch.SetAddress(<void*>&self.m3ERochCor2011B_value)

        #print "making m3ERochCor2012"
        self.m3ERochCor2012_branch = the_tree.GetBranch("m3ERochCor2012")
        #if not self.m3ERochCor2012_branch and "m3ERochCor2012" not in self.complained:
        if not self.m3ERochCor2012_branch and "m3ERochCor2012":
            warnings.warn( "MuMuMuTauTree: Expected branch m3ERochCor2012 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3ERochCor2012")
        else:
            self.m3ERochCor2012_branch.SetAddress(<void*>&self.m3ERochCor2012_value)

        #print "making m3EffectiveArea2011"
        self.m3EffectiveArea2011_branch = the_tree.GetBranch("m3EffectiveArea2011")
        #if not self.m3EffectiveArea2011_branch and "m3EffectiveArea2011" not in self.complained:
        if not self.m3EffectiveArea2011_branch and "m3EffectiveArea2011":
            warnings.warn( "MuMuMuTauTree: Expected branch m3EffectiveArea2011 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3EffectiveArea2011")
        else:
            self.m3EffectiveArea2011_branch.SetAddress(<void*>&self.m3EffectiveArea2011_value)

        #print "making m3EffectiveArea2012"
        self.m3EffectiveArea2012_branch = the_tree.GetBranch("m3EffectiveArea2012")
        #if not self.m3EffectiveArea2012_branch and "m3EffectiveArea2012" not in self.complained:
        if not self.m3EffectiveArea2012_branch and "m3EffectiveArea2012":
            warnings.warn( "MuMuMuTauTree: Expected branch m3EffectiveArea2012 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3EffectiveArea2012")
        else:
            self.m3EffectiveArea2012_branch.SetAddress(<void*>&self.m3EffectiveArea2012_value)

        #print "making m3Eta"
        self.m3Eta_branch = the_tree.GetBranch("m3Eta")
        #if not self.m3Eta_branch and "m3Eta" not in self.complained:
        if not self.m3Eta_branch and "m3Eta":
            warnings.warn( "MuMuMuTauTree: Expected branch m3Eta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3Eta")
        else:
            self.m3Eta_branch.SetAddress(<void*>&self.m3Eta_value)

        #print "making m3EtaRochCor2011A"
        self.m3EtaRochCor2011A_branch = the_tree.GetBranch("m3EtaRochCor2011A")
        #if not self.m3EtaRochCor2011A_branch and "m3EtaRochCor2011A" not in self.complained:
        if not self.m3EtaRochCor2011A_branch and "m3EtaRochCor2011A":
            warnings.warn( "MuMuMuTauTree: Expected branch m3EtaRochCor2011A does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3EtaRochCor2011A")
        else:
            self.m3EtaRochCor2011A_branch.SetAddress(<void*>&self.m3EtaRochCor2011A_value)

        #print "making m3EtaRochCor2011B"
        self.m3EtaRochCor2011B_branch = the_tree.GetBranch("m3EtaRochCor2011B")
        #if not self.m3EtaRochCor2011B_branch and "m3EtaRochCor2011B" not in self.complained:
        if not self.m3EtaRochCor2011B_branch and "m3EtaRochCor2011B":
            warnings.warn( "MuMuMuTauTree: Expected branch m3EtaRochCor2011B does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3EtaRochCor2011B")
        else:
            self.m3EtaRochCor2011B_branch.SetAddress(<void*>&self.m3EtaRochCor2011B_value)

        #print "making m3EtaRochCor2012"
        self.m3EtaRochCor2012_branch = the_tree.GetBranch("m3EtaRochCor2012")
        #if not self.m3EtaRochCor2012_branch and "m3EtaRochCor2012" not in self.complained:
        if not self.m3EtaRochCor2012_branch and "m3EtaRochCor2012":
            warnings.warn( "MuMuMuTauTree: Expected branch m3EtaRochCor2012 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3EtaRochCor2012")
        else:
            self.m3EtaRochCor2012_branch.SetAddress(<void*>&self.m3EtaRochCor2012_value)

        #print "making m3GenCharge"
        self.m3GenCharge_branch = the_tree.GetBranch("m3GenCharge")
        #if not self.m3GenCharge_branch and "m3GenCharge" not in self.complained:
        if not self.m3GenCharge_branch and "m3GenCharge":
            warnings.warn( "MuMuMuTauTree: Expected branch m3GenCharge does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3GenCharge")
        else:
            self.m3GenCharge_branch.SetAddress(<void*>&self.m3GenCharge_value)

        #print "making m3GenEnergy"
        self.m3GenEnergy_branch = the_tree.GetBranch("m3GenEnergy")
        #if not self.m3GenEnergy_branch and "m3GenEnergy" not in self.complained:
        if not self.m3GenEnergy_branch and "m3GenEnergy":
            warnings.warn( "MuMuMuTauTree: Expected branch m3GenEnergy does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3GenEnergy")
        else:
            self.m3GenEnergy_branch.SetAddress(<void*>&self.m3GenEnergy_value)

        #print "making m3GenEta"
        self.m3GenEta_branch = the_tree.GetBranch("m3GenEta")
        #if not self.m3GenEta_branch and "m3GenEta" not in self.complained:
        if not self.m3GenEta_branch and "m3GenEta":
            warnings.warn( "MuMuMuTauTree: Expected branch m3GenEta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3GenEta")
        else:
            self.m3GenEta_branch.SetAddress(<void*>&self.m3GenEta_value)

        #print "making m3GenMotherPdgId"
        self.m3GenMotherPdgId_branch = the_tree.GetBranch("m3GenMotherPdgId")
        #if not self.m3GenMotherPdgId_branch and "m3GenMotherPdgId" not in self.complained:
        if not self.m3GenMotherPdgId_branch and "m3GenMotherPdgId":
            warnings.warn( "MuMuMuTauTree: Expected branch m3GenMotherPdgId does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3GenMotherPdgId")
        else:
            self.m3GenMotherPdgId_branch.SetAddress(<void*>&self.m3GenMotherPdgId_value)

        #print "making m3GenPdgId"
        self.m3GenPdgId_branch = the_tree.GetBranch("m3GenPdgId")
        #if not self.m3GenPdgId_branch and "m3GenPdgId" not in self.complained:
        if not self.m3GenPdgId_branch and "m3GenPdgId":
            warnings.warn( "MuMuMuTauTree: Expected branch m3GenPdgId does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3GenPdgId")
        else:
            self.m3GenPdgId_branch.SetAddress(<void*>&self.m3GenPdgId_value)

        #print "making m3GenPhi"
        self.m3GenPhi_branch = the_tree.GetBranch("m3GenPhi")
        #if not self.m3GenPhi_branch and "m3GenPhi" not in self.complained:
        if not self.m3GenPhi_branch and "m3GenPhi":
            warnings.warn( "MuMuMuTauTree: Expected branch m3GenPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3GenPhi")
        else:
            self.m3GenPhi_branch.SetAddress(<void*>&self.m3GenPhi_value)

        #print "making m3GlbTrkHits"
        self.m3GlbTrkHits_branch = the_tree.GetBranch("m3GlbTrkHits")
        #if not self.m3GlbTrkHits_branch and "m3GlbTrkHits" not in self.complained:
        if not self.m3GlbTrkHits_branch and "m3GlbTrkHits":
            warnings.warn( "MuMuMuTauTree: Expected branch m3GlbTrkHits does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3GlbTrkHits")
        else:
            self.m3GlbTrkHits_branch.SetAddress(<void*>&self.m3GlbTrkHits_value)

        #print "making m3IDHZG2011"
        self.m3IDHZG2011_branch = the_tree.GetBranch("m3IDHZG2011")
        #if not self.m3IDHZG2011_branch and "m3IDHZG2011" not in self.complained:
        if not self.m3IDHZG2011_branch and "m3IDHZG2011":
            warnings.warn( "MuMuMuTauTree: Expected branch m3IDHZG2011 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3IDHZG2011")
        else:
            self.m3IDHZG2011_branch.SetAddress(<void*>&self.m3IDHZG2011_value)

        #print "making m3IDHZG2012"
        self.m3IDHZG2012_branch = the_tree.GetBranch("m3IDHZG2012")
        #if not self.m3IDHZG2012_branch and "m3IDHZG2012" not in self.complained:
        if not self.m3IDHZG2012_branch and "m3IDHZG2012":
            warnings.warn( "MuMuMuTauTree: Expected branch m3IDHZG2012 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3IDHZG2012")
        else:
            self.m3IDHZG2012_branch.SetAddress(<void*>&self.m3IDHZG2012_value)

        #print "making m3IP3DS"
        self.m3IP3DS_branch = the_tree.GetBranch("m3IP3DS")
        #if not self.m3IP3DS_branch and "m3IP3DS" not in self.complained:
        if not self.m3IP3DS_branch and "m3IP3DS":
            warnings.warn( "MuMuMuTauTree: Expected branch m3IP3DS does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3IP3DS")
        else:
            self.m3IP3DS_branch.SetAddress(<void*>&self.m3IP3DS_value)

        #print "making m3IsGlobal"
        self.m3IsGlobal_branch = the_tree.GetBranch("m3IsGlobal")
        #if not self.m3IsGlobal_branch and "m3IsGlobal" not in self.complained:
        if not self.m3IsGlobal_branch and "m3IsGlobal":
            warnings.warn( "MuMuMuTauTree: Expected branch m3IsGlobal does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3IsGlobal")
        else:
            self.m3IsGlobal_branch.SetAddress(<void*>&self.m3IsGlobal_value)

        #print "making m3IsPFMuon"
        self.m3IsPFMuon_branch = the_tree.GetBranch("m3IsPFMuon")
        #if not self.m3IsPFMuon_branch and "m3IsPFMuon" not in self.complained:
        if not self.m3IsPFMuon_branch and "m3IsPFMuon":
            warnings.warn( "MuMuMuTauTree: Expected branch m3IsPFMuon does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3IsPFMuon")
        else:
            self.m3IsPFMuon_branch.SetAddress(<void*>&self.m3IsPFMuon_value)

        #print "making m3IsTracker"
        self.m3IsTracker_branch = the_tree.GetBranch("m3IsTracker")
        #if not self.m3IsTracker_branch and "m3IsTracker" not in self.complained:
        if not self.m3IsTracker_branch and "m3IsTracker":
            warnings.warn( "MuMuMuTauTree: Expected branch m3IsTracker does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3IsTracker")
        else:
            self.m3IsTracker_branch.SetAddress(<void*>&self.m3IsTracker_value)

        #print "making m3JetArea"
        self.m3JetArea_branch = the_tree.GetBranch("m3JetArea")
        #if not self.m3JetArea_branch and "m3JetArea" not in self.complained:
        if not self.m3JetArea_branch and "m3JetArea":
            warnings.warn( "MuMuMuTauTree: Expected branch m3JetArea does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3JetArea")
        else:
            self.m3JetArea_branch.SetAddress(<void*>&self.m3JetArea_value)

        #print "making m3JetBtag"
        self.m3JetBtag_branch = the_tree.GetBranch("m3JetBtag")
        #if not self.m3JetBtag_branch and "m3JetBtag" not in self.complained:
        if not self.m3JetBtag_branch and "m3JetBtag":
            warnings.warn( "MuMuMuTauTree: Expected branch m3JetBtag does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3JetBtag")
        else:
            self.m3JetBtag_branch.SetAddress(<void*>&self.m3JetBtag_value)

        #print "making m3JetCSVBtag"
        self.m3JetCSVBtag_branch = the_tree.GetBranch("m3JetCSVBtag")
        #if not self.m3JetCSVBtag_branch and "m3JetCSVBtag" not in self.complained:
        if not self.m3JetCSVBtag_branch and "m3JetCSVBtag":
            warnings.warn( "MuMuMuTauTree: Expected branch m3JetCSVBtag does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3JetCSVBtag")
        else:
            self.m3JetCSVBtag_branch.SetAddress(<void*>&self.m3JetCSVBtag_value)

        #print "making m3JetEtaEtaMoment"
        self.m3JetEtaEtaMoment_branch = the_tree.GetBranch("m3JetEtaEtaMoment")
        #if not self.m3JetEtaEtaMoment_branch and "m3JetEtaEtaMoment" not in self.complained:
        if not self.m3JetEtaEtaMoment_branch and "m3JetEtaEtaMoment":
            warnings.warn( "MuMuMuTauTree: Expected branch m3JetEtaEtaMoment does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3JetEtaEtaMoment")
        else:
            self.m3JetEtaEtaMoment_branch.SetAddress(<void*>&self.m3JetEtaEtaMoment_value)

        #print "making m3JetEtaPhiMoment"
        self.m3JetEtaPhiMoment_branch = the_tree.GetBranch("m3JetEtaPhiMoment")
        #if not self.m3JetEtaPhiMoment_branch and "m3JetEtaPhiMoment" not in self.complained:
        if not self.m3JetEtaPhiMoment_branch and "m3JetEtaPhiMoment":
            warnings.warn( "MuMuMuTauTree: Expected branch m3JetEtaPhiMoment does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3JetEtaPhiMoment")
        else:
            self.m3JetEtaPhiMoment_branch.SetAddress(<void*>&self.m3JetEtaPhiMoment_value)

        #print "making m3JetEtaPhiSpread"
        self.m3JetEtaPhiSpread_branch = the_tree.GetBranch("m3JetEtaPhiSpread")
        #if not self.m3JetEtaPhiSpread_branch and "m3JetEtaPhiSpread" not in self.complained:
        if not self.m3JetEtaPhiSpread_branch and "m3JetEtaPhiSpread":
            warnings.warn( "MuMuMuTauTree: Expected branch m3JetEtaPhiSpread does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3JetEtaPhiSpread")
        else:
            self.m3JetEtaPhiSpread_branch.SetAddress(<void*>&self.m3JetEtaPhiSpread_value)

        #print "making m3JetPartonFlavour"
        self.m3JetPartonFlavour_branch = the_tree.GetBranch("m3JetPartonFlavour")
        #if not self.m3JetPartonFlavour_branch and "m3JetPartonFlavour" not in self.complained:
        if not self.m3JetPartonFlavour_branch and "m3JetPartonFlavour":
            warnings.warn( "MuMuMuTauTree: Expected branch m3JetPartonFlavour does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3JetPartonFlavour")
        else:
            self.m3JetPartonFlavour_branch.SetAddress(<void*>&self.m3JetPartonFlavour_value)

        #print "making m3JetPhiPhiMoment"
        self.m3JetPhiPhiMoment_branch = the_tree.GetBranch("m3JetPhiPhiMoment")
        #if not self.m3JetPhiPhiMoment_branch and "m3JetPhiPhiMoment" not in self.complained:
        if not self.m3JetPhiPhiMoment_branch and "m3JetPhiPhiMoment":
            warnings.warn( "MuMuMuTauTree: Expected branch m3JetPhiPhiMoment does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3JetPhiPhiMoment")
        else:
            self.m3JetPhiPhiMoment_branch.SetAddress(<void*>&self.m3JetPhiPhiMoment_value)

        #print "making m3JetPt"
        self.m3JetPt_branch = the_tree.GetBranch("m3JetPt")
        #if not self.m3JetPt_branch and "m3JetPt" not in self.complained:
        if not self.m3JetPt_branch and "m3JetPt":
            warnings.warn( "MuMuMuTauTree: Expected branch m3JetPt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3JetPt")
        else:
            self.m3JetPt_branch.SetAddress(<void*>&self.m3JetPt_value)

        #print "making m3JetQGLikelihoodID"
        self.m3JetQGLikelihoodID_branch = the_tree.GetBranch("m3JetQGLikelihoodID")
        #if not self.m3JetQGLikelihoodID_branch and "m3JetQGLikelihoodID" not in self.complained:
        if not self.m3JetQGLikelihoodID_branch and "m3JetQGLikelihoodID":
            warnings.warn( "MuMuMuTauTree: Expected branch m3JetQGLikelihoodID does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3JetQGLikelihoodID")
        else:
            self.m3JetQGLikelihoodID_branch.SetAddress(<void*>&self.m3JetQGLikelihoodID_value)

        #print "making m3JetQGMVAID"
        self.m3JetQGMVAID_branch = the_tree.GetBranch("m3JetQGMVAID")
        #if not self.m3JetQGMVAID_branch and "m3JetQGMVAID" not in self.complained:
        if not self.m3JetQGMVAID_branch and "m3JetQGMVAID":
            warnings.warn( "MuMuMuTauTree: Expected branch m3JetQGMVAID does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3JetQGMVAID")
        else:
            self.m3JetQGMVAID_branch.SetAddress(<void*>&self.m3JetQGMVAID_value)

        #print "making m3Jetaxis1"
        self.m3Jetaxis1_branch = the_tree.GetBranch("m3Jetaxis1")
        #if not self.m3Jetaxis1_branch and "m3Jetaxis1" not in self.complained:
        if not self.m3Jetaxis1_branch and "m3Jetaxis1":
            warnings.warn( "MuMuMuTauTree: Expected branch m3Jetaxis1 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3Jetaxis1")
        else:
            self.m3Jetaxis1_branch.SetAddress(<void*>&self.m3Jetaxis1_value)

        #print "making m3Jetaxis2"
        self.m3Jetaxis2_branch = the_tree.GetBranch("m3Jetaxis2")
        #if not self.m3Jetaxis2_branch and "m3Jetaxis2" not in self.complained:
        if not self.m3Jetaxis2_branch and "m3Jetaxis2":
            warnings.warn( "MuMuMuTauTree: Expected branch m3Jetaxis2 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3Jetaxis2")
        else:
            self.m3Jetaxis2_branch.SetAddress(<void*>&self.m3Jetaxis2_value)

        #print "making m3Jetmult"
        self.m3Jetmult_branch = the_tree.GetBranch("m3Jetmult")
        #if not self.m3Jetmult_branch and "m3Jetmult" not in self.complained:
        if not self.m3Jetmult_branch and "m3Jetmult":
            warnings.warn( "MuMuMuTauTree: Expected branch m3Jetmult does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3Jetmult")
        else:
            self.m3Jetmult_branch.SetAddress(<void*>&self.m3Jetmult_value)

        #print "making m3JetmultMLP"
        self.m3JetmultMLP_branch = the_tree.GetBranch("m3JetmultMLP")
        #if not self.m3JetmultMLP_branch and "m3JetmultMLP" not in self.complained:
        if not self.m3JetmultMLP_branch and "m3JetmultMLP":
            warnings.warn( "MuMuMuTauTree: Expected branch m3JetmultMLP does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3JetmultMLP")
        else:
            self.m3JetmultMLP_branch.SetAddress(<void*>&self.m3JetmultMLP_value)

        #print "making m3JetmultMLPQC"
        self.m3JetmultMLPQC_branch = the_tree.GetBranch("m3JetmultMLPQC")
        #if not self.m3JetmultMLPQC_branch and "m3JetmultMLPQC" not in self.complained:
        if not self.m3JetmultMLPQC_branch and "m3JetmultMLPQC":
            warnings.warn( "MuMuMuTauTree: Expected branch m3JetmultMLPQC does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3JetmultMLPQC")
        else:
            self.m3JetmultMLPQC_branch.SetAddress(<void*>&self.m3JetmultMLPQC_value)

        #print "making m3JetptD"
        self.m3JetptD_branch = the_tree.GetBranch("m3JetptD")
        #if not self.m3JetptD_branch and "m3JetptD" not in self.complained:
        if not self.m3JetptD_branch and "m3JetptD":
            warnings.warn( "MuMuMuTauTree: Expected branch m3JetptD does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3JetptD")
        else:
            self.m3JetptD_branch.SetAddress(<void*>&self.m3JetptD_value)

        #print "making m3L1Mu3EG5L3Filtered17"
        self.m3L1Mu3EG5L3Filtered17_branch = the_tree.GetBranch("m3L1Mu3EG5L3Filtered17")
        #if not self.m3L1Mu3EG5L3Filtered17_branch and "m3L1Mu3EG5L3Filtered17" not in self.complained:
        if not self.m3L1Mu3EG5L3Filtered17_branch and "m3L1Mu3EG5L3Filtered17":
            warnings.warn( "MuMuMuTauTree: Expected branch m3L1Mu3EG5L3Filtered17 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3L1Mu3EG5L3Filtered17")
        else:
            self.m3L1Mu3EG5L3Filtered17_branch.SetAddress(<void*>&self.m3L1Mu3EG5L3Filtered17_value)

        #print "making m3L3fL1DoubleMu10MuOpenL1f0L2f10L3Filtered17"
        self.m3L3fL1DoubleMu10MuOpenL1f0L2f10L3Filtered17_branch = the_tree.GetBranch("m3L3fL1DoubleMu10MuOpenL1f0L2f10L3Filtered17")
        #if not self.m3L3fL1DoubleMu10MuOpenL1f0L2f10L3Filtered17_branch and "m3L3fL1DoubleMu10MuOpenL1f0L2f10L3Filtered17" not in self.complained:
        if not self.m3L3fL1DoubleMu10MuOpenL1f0L2f10L3Filtered17_branch and "m3L3fL1DoubleMu10MuOpenL1f0L2f10L3Filtered17":
            warnings.warn( "MuMuMuTauTree: Expected branch m3L3fL1DoubleMu10MuOpenL1f0L2f10L3Filtered17 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3L3fL1DoubleMu10MuOpenL1f0L2f10L3Filtered17")
        else:
            self.m3L3fL1DoubleMu10MuOpenL1f0L2f10L3Filtered17_branch.SetAddress(<void*>&self.m3L3fL1DoubleMu10MuOpenL1f0L2f10L3Filtered17_value)

        #print "making m3Mass"
        self.m3Mass_branch = the_tree.GetBranch("m3Mass")
        #if not self.m3Mass_branch and "m3Mass" not in self.complained:
        if not self.m3Mass_branch and "m3Mass":
            warnings.warn( "MuMuMuTauTree: Expected branch m3Mass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3Mass")
        else:
            self.m3Mass_branch.SetAddress(<void*>&self.m3Mass_value)

        #print "making m3MatchedStations"
        self.m3MatchedStations_branch = the_tree.GetBranch("m3MatchedStations")
        #if not self.m3MatchedStations_branch and "m3MatchedStations" not in self.complained:
        if not self.m3MatchedStations_branch and "m3MatchedStations":
            warnings.warn( "MuMuMuTauTree: Expected branch m3MatchedStations does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3MatchedStations")
        else:
            self.m3MatchedStations_branch.SetAddress(<void*>&self.m3MatchedStations_value)

        #print "making m3MatchesDoubleMuPaths"
        self.m3MatchesDoubleMuPaths_branch = the_tree.GetBranch("m3MatchesDoubleMuPaths")
        #if not self.m3MatchesDoubleMuPaths_branch and "m3MatchesDoubleMuPaths" not in self.complained:
        if not self.m3MatchesDoubleMuPaths_branch and "m3MatchesDoubleMuPaths":
            warnings.warn( "MuMuMuTauTree: Expected branch m3MatchesDoubleMuPaths does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3MatchesDoubleMuPaths")
        else:
            self.m3MatchesDoubleMuPaths_branch.SetAddress(<void*>&self.m3MatchesDoubleMuPaths_value)

        #print "making m3MatchesDoubleMuTrkPaths"
        self.m3MatchesDoubleMuTrkPaths_branch = the_tree.GetBranch("m3MatchesDoubleMuTrkPaths")
        #if not self.m3MatchesDoubleMuTrkPaths_branch and "m3MatchesDoubleMuTrkPaths" not in self.complained:
        if not self.m3MatchesDoubleMuTrkPaths_branch and "m3MatchesDoubleMuTrkPaths":
            warnings.warn( "MuMuMuTauTree: Expected branch m3MatchesDoubleMuTrkPaths does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3MatchesDoubleMuTrkPaths")
        else:
            self.m3MatchesDoubleMuTrkPaths_branch.SetAddress(<void*>&self.m3MatchesDoubleMuTrkPaths_value)

        #print "making m3MatchesIsoMu24eta2p1"
        self.m3MatchesIsoMu24eta2p1_branch = the_tree.GetBranch("m3MatchesIsoMu24eta2p1")
        #if not self.m3MatchesIsoMu24eta2p1_branch and "m3MatchesIsoMu24eta2p1" not in self.complained:
        if not self.m3MatchesIsoMu24eta2p1_branch and "m3MatchesIsoMu24eta2p1":
            warnings.warn( "MuMuMuTauTree: Expected branch m3MatchesIsoMu24eta2p1 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3MatchesIsoMu24eta2p1")
        else:
            self.m3MatchesIsoMu24eta2p1_branch.SetAddress(<void*>&self.m3MatchesIsoMu24eta2p1_value)

        #print "making m3MatchesIsoMuGroup"
        self.m3MatchesIsoMuGroup_branch = the_tree.GetBranch("m3MatchesIsoMuGroup")
        #if not self.m3MatchesIsoMuGroup_branch and "m3MatchesIsoMuGroup" not in self.complained:
        if not self.m3MatchesIsoMuGroup_branch and "m3MatchesIsoMuGroup":
            warnings.warn( "MuMuMuTauTree: Expected branch m3MatchesIsoMuGroup does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3MatchesIsoMuGroup")
        else:
            self.m3MatchesIsoMuGroup_branch.SetAddress(<void*>&self.m3MatchesIsoMuGroup_value)

        #print "making m3MatchesMu17Ele8IsoPath"
        self.m3MatchesMu17Ele8IsoPath_branch = the_tree.GetBranch("m3MatchesMu17Ele8IsoPath")
        #if not self.m3MatchesMu17Ele8IsoPath_branch and "m3MatchesMu17Ele8IsoPath" not in self.complained:
        if not self.m3MatchesMu17Ele8IsoPath_branch and "m3MatchesMu17Ele8IsoPath":
            warnings.warn( "MuMuMuTauTree: Expected branch m3MatchesMu17Ele8IsoPath does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3MatchesMu17Ele8IsoPath")
        else:
            self.m3MatchesMu17Ele8IsoPath_branch.SetAddress(<void*>&self.m3MatchesMu17Ele8IsoPath_value)

        #print "making m3MatchesMu17Ele8Path"
        self.m3MatchesMu17Ele8Path_branch = the_tree.GetBranch("m3MatchesMu17Ele8Path")
        #if not self.m3MatchesMu17Ele8Path_branch and "m3MatchesMu17Ele8Path" not in self.complained:
        if not self.m3MatchesMu17Ele8Path_branch and "m3MatchesMu17Ele8Path":
            warnings.warn( "MuMuMuTauTree: Expected branch m3MatchesMu17Ele8Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3MatchesMu17Ele8Path")
        else:
            self.m3MatchesMu17Ele8Path_branch.SetAddress(<void*>&self.m3MatchesMu17Ele8Path_value)

        #print "making m3MatchesMu17Mu8Path"
        self.m3MatchesMu17Mu8Path_branch = the_tree.GetBranch("m3MatchesMu17Mu8Path")
        #if not self.m3MatchesMu17Mu8Path_branch and "m3MatchesMu17Mu8Path" not in self.complained:
        if not self.m3MatchesMu17Mu8Path_branch and "m3MatchesMu17Mu8Path":
            warnings.warn( "MuMuMuTauTree: Expected branch m3MatchesMu17Mu8Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3MatchesMu17Mu8Path")
        else:
            self.m3MatchesMu17Mu8Path_branch.SetAddress(<void*>&self.m3MatchesMu17Mu8Path_value)

        #print "making m3MatchesMu17TrkMu8Path"
        self.m3MatchesMu17TrkMu8Path_branch = the_tree.GetBranch("m3MatchesMu17TrkMu8Path")
        #if not self.m3MatchesMu17TrkMu8Path_branch and "m3MatchesMu17TrkMu8Path" not in self.complained:
        if not self.m3MatchesMu17TrkMu8Path_branch and "m3MatchesMu17TrkMu8Path":
            warnings.warn( "MuMuMuTauTree: Expected branch m3MatchesMu17TrkMu8Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3MatchesMu17TrkMu8Path")
        else:
            self.m3MatchesMu17TrkMu8Path_branch.SetAddress(<void*>&self.m3MatchesMu17TrkMu8Path_value)

        #print "making m3MatchesMu8Ele17IsoPath"
        self.m3MatchesMu8Ele17IsoPath_branch = the_tree.GetBranch("m3MatchesMu8Ele17IsoPath")
        #if not self.m3MatchesMu8Ele17IsoPath_branch and "m3MatchesMu8Ele17IsoPath" not in self.complained:
        if not self.m3MatchesMu8Ele17IsoPath_branch and "m3MatchesMu8Ele17IsoPath":
            warnings.warn( "MuMuMuTauTree: Expected branch m3MatchesMu8Ele17IsoPath does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3MatchesMu8Ele17IsoPath")
        else:
            self.m3MatchesMu8Ele17IsoPath_branch.SetAddress(<void*>&self.m3MatchesMu8Ele17IsoPath_value)

        #print "making m3MatchesMu8Ele17Path"
        self.m3MatchesMu8Ele17Path_branch = the_tree.GetBranch("m3MatchesMu8Ele17Path")
        #if not self.m3MatchesMu8Ele17Path_branch and "m3MatchesMu8Ele17Path" not in self.complained:
        if not self.m3MatchesMu8Ele17Path_branch and "m3MatchesMu8Ele17Path":
            warnings.warn( "MuMuMuTauTree: Expected branch m3MatchesMu8Ele17Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3MatchesMu8Ele17Path")
        else:
            self.m3MatchesMu8Ele17Path_branch.SetAddress(<void*>&self.m3MatchesMu8Ele17Path_value)

        #print "making m3MtToMET"
        self.m3MtToMET_branch = the_tree.GetBranch("m3MtToMET")
        #if not self.m3MtToMET_branch and "m3MtToMET" not in self.complained:
        if not self.m3MtToMET_branch and "m3MtToMET":
            warnings.warn( "MuMuMuTauTree: Expected branch m3MtToMET does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3MtToMET")
        else:
            self.m3MtToMET_branch.SetAddress(<void*>&self.m3MtToMET_value)

        #print "making m3MtToMVAMET"
        self.m3MtToMVAMET_branch = the_tree.GetBranch("m3MtToMVAMET")
        #if not self.m3MtToMVAMET_branch and "m3MtToMVAMET" not in self.complained:
        if not self.m3MtToMVAMET_branch and "m3MtToMVAMET":
            warnings.warn( "MuMuMuTauTree: Expected branch m3MtToMVAMET does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3MtToMVAMET")
        else:
            self.m3MtToMVAMET_branch.SetAddress(<void*>&self.m3MtToMVAMET_value)

        #print "making m3MtToPFMET"
        self.m3MtToPFMET_branch = the_tree.GetBranch("m3MtToPFMET")
        #if not self.m3MtToPFMET_branch and "m3MtToPFMET" not in self.complained:
        if not self.m3MtToPFMET_branch and "m3MtToPFMET":
            warnings.warn( "MuMuMuTauTree: Expected branch m3MtToPFMET does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3MtToPFMET")
        else:
            self.m3MtToPFMET_branch.SetAddress(<void*>&self.m3MtToPFMET_value)

        #print "making m3MtToPfMet_Ty1"
        self.m3MtToPfMet_Ty1_branch = the_tree.GetBranch("m3MtToPfMet_Ty1")
        #if not self.m3MtToPfMet_Ty1_branch and "m3MtToPfMet_Ty1" not in self.complained:
        if not self.m3MtToPfMet_Ty1_branch and "m3MtToPfMet_Ty1":
            warnings.warn( "MuMuMuTauTree: Expected branch m3MtToPfMet_Ty1 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3MtToPfMet_Ty1")
        else:
            self.m3MtToPfMet_Ty1_branch.SetAddress(<void*>&self.m3MtToPfMet_Ty1_value)

        #print "making m3MtToPfMet_jes"
        self.m3MtToPfMet_jes_branch = the_tree.GetBranch("m3MtToPfMet_jes")
        #if not self.m3MtToPfMet_jes_branch and "m3MtToPfMet_jes" not in self.complained:
        if not self.m3MtToPfMet_jes_branch and "m3MtToPfMet_jes":
            warnings.warn( "MuMuMuTauTree: Expected branch m3MtToPfMet_jes does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3MtToPfMet_jes")
        else:
            self.m3MtToPfMet_jes_branch.SetAddress(<void*>&self.m3MtToPfMet_jes_value)

        #print "making m3MtToPfMet_mes"
        self.m3MtToPfMet_mes_branch = the_tree.GetBranch("m3MtToPfMet_mes")
        #if not self.m3MtToPfMet_mes_branch and "m3MtToPfMet_mes" not in self.complained:
        if not self.m3MtToPfMet_mes_branch and "m3MtToPfMet_mes":
            warnings.warn( "MuMuMuTauTree: Expected branch m3MtToPfMet_mes does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3MtToPfMet_mes")
        else:
            self.m3MtToPfMet_mes_branch.SetAddress(<void*>&self.m3MtToPfMet_mes_value)

        #print "making m3MtToPfMet_tes"
        self.m3MtToPfMet_tes_branch = the_tree.GetBranch("m3MtToPfMet_tes")
        #if not self.m3MtToPfMet_tes_branch and "m3MtToPfMet_tes" not in self.complained:
        if not self.m3MtToPfMet_tes_branch and "m3MtToPfMet_tes":
            warnings.warn( "MuMuMuTauTree: Expected branch m3MtToPfMet_tes does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3MtToPfMet_tes")
        else:
            self.m3MtToPfMet_tes_branch.SetAddress(<void*>&self.m3MtToPfMet_tes_value)

        #print "making m3MtToPfMet_ues"
        self.m3MtToPfMet_ues_branch = the_tree.GetBranch("m3MtToPfMet_ues")
        #if not self.m3MtToPfMet_ues_branch and "m3MtToPfMet_ues" not in self.complained:
        if not self.m3MtToPfMet_ues_branch and "m3MtToPfMet_ues":
            warnings.warn( "MuMuMuTauTree: Expected branch m3MtToPfMet_ues does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3MtToPfMet_ues")
        else:
            self.m3MtToPfMet_ues_branch.SetAddress(<void*>&self.m3MtToPfMet_ues_value)

        #print "making m3Mu17Ele8dZFilter"
        self.m3Mu17Ele8dZFilter_branch = the_tree.GetBranch("m3Mu17Ele8dZFilter")
        #if not self.m3Mu17Ele8dZFilter_branch and "m3Mu17Ele8dZFilter" not in self.complained:
        if not self.m3Mu17Ele8dZFilter_branch and "m3Mu17Ele8dZFilter":
            warnings.warn( "MuMuMuTauTree: Expected branch m3Mu17Ele8dZFilter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3Mu17Ele8dZFilter")
        else:
            self.m3Mu17Ele8dZFilter_branch.SetAddress(<void*>&self.m3Mu17Ele8dZFilter_value)

        #print "making m3MuonHits"
        self.m3MuonHits_branch = the_tree.GetBranch("m3MuonHits")
        #if not self.m3MuonHits_branch and "m3MuonHits" not in self.complained:
        if not self.m3MuonHits_branch and "m3MuonHits":
            warnings.warn( "MuMuMuTauTree: Expected branch m3MuonHits does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3MuonHits")
        else:
            self.m3MuonHits_branch.SetAddress(<void*>&self.m3MuonHits_value)

        #print "making m3NormTrkChi2"
        self.m3NormTrkChi2_branch = the_tree.GetBranch("m3NormTrkChi2")
        #if not self.m3NormTrkChi2_branch and "m3NormTrkChi2" not in self.complained:
        if not self.m3NormTrkChi2_branch and "m3NormTrkChi2":
            warnings.warn( "MuMuMuTauTree: Expected branch m3NormTrkChi2 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3NormTrkChi2")
        else:
            self.m3NormTrkChi2_branch.SetAddress(<void*>&self.m3NormTrkChi2_value)

        #print "making m3PFChargedIso"
        self.m3PFChargedIso_branch = the_tree.GetBranch("m3PFChargedIso")
        #if not self.m3PFChargedIso_branch and "m3PFChargedIso" not in self.complained:
        if not self.m3PFChargedIso_branch and "m3PFChargedIso":
            warnings.warn( "MuMuMuTauTree: Expected branch m3PFChargedIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3PFChargedIso")
        else:
            self.m3PFChargedIso_branch.SetAddress(<void*>&self.m3PFChargedIso_value)

        #print "making m3PFIDTight"
        self.m3PFIDTight_branch = the_tree.GetBranch("m3PFIDTight")
        #if not self.m3PFIDTight_branch and "m3PFIDTight" not in self.complained:
        if not self.m3PFIDTight_branch and "m3PFIDTight":
            warnings.warn( "MuMuMuTauTree: Expected branch m3PFIDTight does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3PFIDTight")
        else:
            self.m3PFIDTight_branch.SetAddress(<void*>&self.m3PFIDTight_value)

        #print "making m3PFNeutralIso"
        self.m3PFNeutralIso_branch = the_tree.GetBranch("m3PFNeutralIso")
        #if not self.m3PFNeutralIso_branch and "m3PFNeutralIso" not in self.complained:
        if not self.m3PFNeutralIso_branch and "m3PFNeutralIso":
            warnings.warn( "MuMuMuTauTree: Expected branch m3PFNeutralIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3PFNeutralIso")
        else:
            self.m3PFNeutralIso_branch.SetAddress(<void*>&self.m3PFNeutralIso_value)

        #print "making m3PFPUChargedIso"
        self.m3PFPUChargedIso_branch = the_tree.GetBranch("m3PFPUChargedIso")
        #if not self.m3PFPUChargedIso_branch and "m3PFPUChargedIso" not in self.complained:
        if not self.m3PFPUChargedIso_branch and "m3PFPUChargedIso":
            warnings.warn( "MuMuMuTauTree: Expected branch m3PFPUChargedIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3PFPUChargedIso")
        else:
            self.m3PFPUChargedIso_branch.SetAddress(<void*>&self.m3PFPUChargedIso_value)

        #print "making m3PFPhotonIso"
        self.m3PFPhotonIso_branch = the_tree.GetBranch("m3PFPhotonIso")
        #if not self.m3PFPhotonIso_branch and "m3PFPhotonIso" not in self.complained:
        if not self.m3PFPhotonIso_branch and "m3PFPhotonIso":
            warnings.warn( "MuMuMuTauTree: Expected branch m3PFPhotonIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3PFPhotonIso")
        else:
            self.m3PFPhotonIso_branch.SetAddress(<void*>&self.m3PFPhotonIso_value)

        #print "making m3PVDXY"
        self.m3PVDXY_branch = the_tree.GetBranch("m3PVDXY")
        #if not self.m3PVDXY_branch and "m3PVDXY" not in self.complained:
        if not self.m3PVDXY_branch and "m3PVDXY":
            warnings.warn( "MuMuMuTauTree: Expected branch m3PVDXY does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3PVDXY")
        else:
            self.m3PVDXY_branch.SetAddress(<void*>&self.m3PVDXY_value)

        #print "making m3PVDZ"
        self.m3PVDZ_branch = the_tree.GetBranch("m3PVDZ")
        #if not self.m3PVDZ_branch and "m3PVDZ" not in self.complained:
        if not self.m3PVDZ_branch and "m3PVDZ":
            warnings.warn( "MuMuMuTauTree: Expected branch m3PVDZ does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3PVDZ")
        else:
            self.m3PVDZ_branch.SetAddress(<void*>&self.m3PVDZ_value)

        #print "making m3Phi"
        self.m3Phi_branch = the_tree.GetBranch("m3Phi")
        #if not self.m3Phi_branch and "m3Phi" not in self.complained:
        if not self.m3Phi_branch and "m3Phi":
            warnings.warn( "MuMuMuTauTree: Expected branch m3Phi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3Phi")
        else:
            self.m3Phi_branch.SetAddress(<void*>&self.m3Phi_value)

        #print "making m3PhiRochCor2011A"
        self.m3PhiRochCor2011A_branch = the_tree.GetBranch("m3PhiRochCor2011A")
        #if not self.m3PhiRochCor2011A_branch and "m3PhiRochCor2011A" not in self.complained:
        if not self.m3PhiRochCor2011A_branch and "m3PhiRochCor2011A":
            warnings.warn( "MuMuMuTauTree: Expected branch m3PhiRochCor2011A does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3PhiRochCor2011A")
        else:
            self.m3PhiRochCor2011A_branch.SetAddress(<void*>&self.m3PhiRochCor2011A_value)

        #print "making m3PhiRochCor2011B"
        self.m3PhiRochCor2011B_branch = the_tree.GetBranch("m3PhiRochCor2011B")
        #if not self.m3PhiRochCor2011B_branch and "m3PhiRochCor2011B" not in self.complained:
        if not self.m3PhiRochCor2011B_branch and "m3PhiRochCor2011B":
            warnings.warn( "MuMuMuTauTree: Expected branch m3PhiRochCor2011B does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3PhiRochCor2011B")
        else:
            self.m3PhiRochCor2011B_branch.SetAddress(<void*>&self.m3PhiRochCor2011B_value)

        #print "making m3PhiRochCor2012"
        self.m3PhiRochCor2012_branch = the_tree.GetBranch("m3PhiRochCor2012")
        #if not self.m3PhiRochCor2012_branch and "m3PhiRochCor2012" not in self.complained:
        if not self.m3PhiRochCor2012_branch and "m3PhiRochCor2012":
            warnings.warn( "MuMuMuTauTree: Expected branch m3PhiRochCor2012 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3PhiRochCor2012")
        else:
            self.m3PhiRochCor2012_branch.SetAddress(<void*>&self.m3PhiRochCor2012_value)

        #print "making m3PixHits"
        self.m3PixHits_branch = the_tree.GetBranch("m3PixHits")
        #if not self.m3PixHits_branch and "m3PixHits" not in self.complained:
        if not self.m3PixHits_branch and "m3PixHits":
            warnings.warn( "MuMuMuTauTree: Expected branch m3PixHits does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3PixHits")
        else:
            self.m3PixHits_branch.SetAddress(<void*>&self.m3PixHits_value)

        #print "making m3Pt"
        self.m3Pt_branch = the_tree.GetBranch("m3Pt")
        #if not self.m3Pt_branch and "m3Pt" not in self.complained:
        if not self.m3Pt_branch and "m3Pt":
            warnings.warn( "MuMuMuTauTree: Expected branch m3Pt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3Pt")
        else:
            self.m3Pt_branch.SetAddress(<void*>&self.m3Pt_value)

        #print "making m3PtRochCor2011A"
        self.m3PtRochCor2011A_branch = the_tree.GetBranch("m3PtRochCor2011A")
        #if not self.m3PtRochCor2011A_branch and "m3PtRochCor2011A" not in self.complained:
        if not self.m3PtRochCor2011A_branch and "m3PtRochCor2011A":
            warnings.warn( "MuMuMuTauTree: Expected branch m3PtRochCor2011A does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3PtRochCor2011A")
        else:
            self.m3PtRochCor2011A_branch.SetAddress(<void*>&self.m3PtRochCor2011A_value)

        #print "making m3PtRochCor2011B"
        self.m3PtRochCor2011B_branch = the_tree.GetBranch("m3PtRochCor2011B")
        #if not self.m3PtRochCor2011B_branch and "m3PtRochCor2011B" not in self.complained:
        if not self.m3PtRochCor2011B_branch and "m3PtRochCor2011B":
            warnings.warn( "MuMuMuTauTree: Expected branch m3PtRochCor2011B does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3PtRochCor2011B")
        else:
            self.m3PtRochCor2011B_branch.SetAddress(<void*>&self.m3PtRochCor2011B_value)

        #print "making m3PtRochCor2012"
        self.m3PtRochCor2012_branch = the_tree.GetBranch("m3PtRochCor2012")
        #if not self.m3PtRochCor2012_branch and "m3PtRochCor2012" not in self.complained:
        if not self.m3PtRochCor2012_branch and "m3PtRochCor2012":
            warnings.warn( "MuMuMuTauTree: Expected branch m3PtRochCor2012 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3PtRochCor2012")
        else:
            self.m3PtRochCor2012_branch.SetAddress(<void*>&self.m3PtRochCor2012_value)

        #print "making m3Rank"
        self.m3Rank_branch = the_tree.GetBranch("m3Rank")
        #if not self.m3Rank_branch and "m3Rank" not in self.complained:
        if not self.m3Rank_branch and "m3Rank":
            warnings.warn( "MuMuMuTauTree: Expected branch m3Rank does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3Rank")
        else:
            self.m3Rank_branch.SetAddress(<void*>&self.m3Rank_value)

        #print "making m3RelPFIsoDB"
        self.m3RelPFIsoDB_branch = the_tree.GetBranch("m3RelPFIsoDB")
        #if not self.m3RelPFIsoDB_branch and "m3RelPFIsoDB" not in self.complained:
        if not self.m3RelPFIsoDB_branch and "m3RelPFIsoDB":
            warnings.warn( "MuMuMuTauTree: Expected branch m3RelPFIsoDB does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3RelPFIsoDB")
        else:
            self.m3RelPFIsoDB_branch.SetAddress(<void*>&self.m3RelPFIsoDB_value)

        #print "making m3RelPFIsoRho"
        self.m3RelPFIsoRho_branch = the_tree.GetBranch("m3RelPFIsoRho")
        #if not self.m3RelPFIsoRho_branch and "m3RelPFIsoRho" not in self.complained:
        if not self.m3RelPFIsoRho_branch and "m3RelPFIsoRho":
            warnings.warn( "MuMuMuTauTree: Expected branch m3RelPFIsoRho does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3RelPFIsoRho")
        else:
            self.m3RelPFIsoRho_branch.SetAddress(<void*>&self.m3RelPFIsoRho_value)

        #print "making m3RelPFIsoRhoFSR"
        self.m3RelPFIsoRhoFSR_branch = the_tree.GetBranch("m3RelPFIsoRhoFSR")
        #if not self.m3RelPFIsoRhoFSR_branch and "m3RelPFIsoRhoFSR" not in self.complained:
        if not self.m3RelPFIsoRhoFSR_branch and "m3RelPFIsoRhoFSR":
            warnings.warn( "MuMuMuTauTree: Expected branch m3RelPFIsoRhoFSR does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3RelPFIsoRhoFSR")
        else:
            self.m3RelPFIsoRhoFSR_branch.SetAddress(<void*>&self.m3RelPFIsoRhoFSR_value)

        #print "making m3RhoHZG2011"
        self.m3RhoHZG2011_branch = the_tree.GetBranch("m3RhoHZG2011")
        #if not self.m3RhoHZG2011_branch and "m3RhoHZG2011" not in self.complained:
        if not self.m3RhoHZG2011_branch and "m3RhoHZG2011":
            warnings.warn( "MuMuMuTauTree: Expected branch m3RhoHZG2011 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3RhoHZG2011")
        else:
            self.m3RhoHZG2011_branch.SetAddress(<void*>&self.m3RhoHZG2011_value)

        #print "making m3RhoHZG2012"
        self.m3RhoHZG2012_branch = the_tree.GetBranch("m3RhoHZG2012")
        #if not self.m3RhoHZG2012_branch and "m3RhoHZG2012" not in self.complained:
        if not self.m3RhoHZG2012_branch and "m3RhoHZG2012":
            warnings.warn( "MuMuMuTauTree: Expected branch m3RhoHZG2012 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3RhoHZG2012")
        else:
            self.m3RhoHZG2012_branch.SetAddress(<void*>&self.m3RhoHZG2012_value)

        #print "making m3SingleMu13L3Filtered13"
        self.m3SingleMu13L3Filtered13_branch = the_tree.GetBranch("m3SingleMu13L3Filtered13")
        #if not self.m3SingleMu13L3Filtered13_branch and "m3SingleMu13L3Filtered13" not in self.complained:
        if not self.m3SingleMu13L3Filtered13_branch and "m3SingleMu13L3Filtered13":
            warnings.warn( "MuMuMuTauTree: Expected branch m3SingleMu13L3Filtered13 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3SingleMu13L3Filtered13")
        else:
            self.m3SingleMu13L3Filtered13_branch.SetAddress(<void*>&self.m3SingleMu13L3Filtered13_value)

        #print "making m3SingleMu13L3Filtered17"
        self.m3SingleMu13L3Filtered17_branch = the_tree.GetBranch("m3SingleMu13L3Filtered17")
        #if not self.m3SingleMu13L3Filtered17_branch and "m3SingleMu13L3Filtered17" not in self.complained:
        if not self.m3SingleMu13L3Filtered17_branch and "m3SingleMu13L3Filtered17":
            warnings.warn( "MuMuMuTauTree: Expected branch m3SingleMu13L3Filtered17 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3SingleMu13L3Filtered17")
        else:
            self.m3SingleMu13L3Filtered17_branch.SetAddress(<void*>&self.m3SingleMu13L3Filtered17_value)

        #print "making m3TkLayersWithMeasurement"
        self.m3TkLayersWithMeasurement_branch = the_tree.GetBranch("m3TkLayersWithMeasurement")
        #if not self.m3TkLayersWithMeasurement_branch and "m3TkLayersWithMeasurement" not in self.complained:
        if not self.m3TkLayersWithMeasurement_branch and "m3TkLayersWithMeasurement":
            warnings.warn( "MuMuMuTauTree: Expected branch m3TkLayersWithMeasurement does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3TkLayersWithMeasurement")
        else:
            self.m3TkLayersWithMeasurement_branch.SetAddress(<void*>&self.m3TkLayersWithMeasurement_value)

        #print "making m3ToMETDPhi"
        self.m3ToMETDPhi_branch = the_tree.GetBranch("m3ToMETDPhi")
        #if not self.m3ToMETDPhi_branch and "m3ToMETDPhi" not in self.complained:
        if not self.m3ToMETDPhi_branch and "m3ToMETDPhi":
            warnings.warn( "MuMuMuTauTree: Expected branch m3ToMETDPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3ToMETDPhi")
        else:
            self.m3ToMETDPhi_branch.SetAddress(<void*>&self.m3ToMETDPhi_value)

        #print "making m3TypeCode"
        self.m3TypeCode_branch = the_tree.GetBranch("m3TypeCode")
        #if not self.m3TypeCode_branch and "m3TypeCode" not in self.complained:
        if not self.m3TypeCode_branch and "m3TypeCode":
            warnings.warn( "MuMuMuTauTree: Expected branch m3TypeCode does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3TypeCode")
        else:
            self.m3TypeCode_branch.SetAddress(<void*>&self.m3TypeCode_value)

        #print "making m3VBTFID"
        self.m3VBTFID_branch = the_tree.GetBranch("m3VBTFID")
        #if not self.m3VBTFID_branch and "m3VBTFID" not in self.complained:
        if not self.m3VBTFID_branch and "m3VBTFID":
            warnings.warn( "MuMuMuTauTree: Expected branch m3VBTFID does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3VBTFID")
        else:
            self.m3VBTFID_branch.SetAddress(<void*>&self.m3VBTFID_value)

        #print "making m3VZ"
        self.m3VZ_branch = the_tree.GetBranch("m3VZ")
        #if not self.m3VZ_branch and "m3VZ" not in self.complained:
        if not self.m3VZ_branch and "m3VZ":
            warnings.warn( "MuMuMuTauTree: Expected branch m3VZ does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3VZ")
        else:
            self.m3VZ_branch.SetAddress(<void*>&self.m3VZ_value)

        #print "making m3WWID"
        self.m3WWID_branch = the_tree.GetBranch("m3WWID")
        #if not self.m3WWID_branch and "m3WWID" not in self.complained:
        if not self.m3WWID_branch and "m3WWID":
            warnings.warn( "MuMuMuTauTree: Expected branch m3WWID does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3WWID")
        else:
            self.m3WWID_branch.SetAddress(<void*>&self.m3WWID_value)

        #print "making m3_t_CosThetaStar"
        self.m3_t_CosThetaStar_branch = the_tree.GetBranch("m3_t_CosThetaStar")
        #if not self.m3_t_CosThetaStar_branch and "m3_t_CosThetaStar" not in self.complained:
        if not self.m3_t_CosThetaStar_branch and "m3_t_CosThetaStar":
            warnings.warn( "MuMuMuTauTree: Expected branch m3_t_CosThetaStar does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3_t_CosThetaStar")
        else:
            self.m3_t_CosThetaStar_branch.SetAddress(<void*>&self.m3_t_CosThetaStar_value)

        #print "making m3_t_DPhi"
        self.m3_t_DPhi_branch = the_tree.GetBranch("m3_t_DPhi")
        #if not self.m3_t_DPhi_branch and "m3_t_DPhi" not in self.complained:
        if not self.m3_t_DPhi_branch and "m3_t_DPhi":
            warnings.warn( "MuMuMuTauTree: Expected branch m3_t_DPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3_t_DPhi")
        else:
            self.m3_t_DPhi_branch.SetAddress(<void*>&self.m3_t_DPhi_value)

        #print "making m3_t_DR"
        self.m3_t_DR_branch = the_tree.GetBranch("m3_t_DR")
        #if not self.m3_t_DR_branch and "m3_t_DR" not in self.complained:
        if not self.m3_t_DR_branch and "m3_t_DR":
            warnings.warn( "MuMuMuTauTree: Expected branch m3_t_DR does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3_t_DR")
        else:
            self.m3_t_DR_branch.SetAddress(<void*>&self.m3_t_DR_value)

        #print "making m3_t_Eta"
        self.m3_t_Eta_branch = the_tree.GetBranch("m3_t_Eta")
        #if not self.m3_t_Eta_branch and "m3_t_Eta" not in self.complained:
        if not self.m3_t_Eta_branch and "m3_t_Eta":
            warnings.warn( "MuMuMuTauTree: Expected branch m3_t_Eta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3_t_Eta")
        else:
            self.m3_t_Eta_branch.SetAddress(<void*>&self.m3_t_Eta_value)

        #print "making m3_t_Mass"
        self.m3_t_Mass_branch = the_tree.GetBranch("m3_t_Mass")
        #if not self.m3_t_Mass_branch and "m3_t_Mass" not in self.complained:
        if not self.m3_t_Mass_branch and "m3_t_Mass":
            warnings.warn( "MuMuMuTauTree: Expected branch m3_t_Mass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3_t_Mass")
        else:
            self.m3_t_Mass_branch.SetAddress(<void*>&self.m3_t_Mass_value)

        #print "making m3_t_MassFsr"
        self.m3_t_MassFsr_branch = the_tree.GetBranch("m3_t_MassFsr")
        #if not self.m3_t_MassFsr_branch and "m3_t_MassFsr" not in self.complained:
        if not self.m3_t_MassFsr_branch and "m3_t_MassFsr":
            warnings.warn( "MuMuMuTauTree: Expected branch m3_t_MassFsr does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3_t_MassFsr")
        else:
            self.m3_t_MassFsr_branch.SetAddress(<void*>&self.m3_t_MassFsr_value)

        #print "making m3_t_PZeta"
        self.m3_t_PZeta_branch = the_tree.GetBranch("m3_t_PZeta")
        #if not self.m3_t_PZeta_branch and "m3_t_PZeta" not in self.complained:
        if not self.m3_t_PZeta_branch and "m3_t_PZeta":
            warnings.warn( "MuMuMuTauTree: Expected branch m3_t_PZeta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3_t_PZeta")
        else:
            self.m3_t_PZeta_branch.SetAddress(<void*>&self.m3_t_PZeta_value)

        #print "making m3_t_PZetaVis"
        self.m3_t_PZetaVis_branch = the_tree.GetBranch("m3_t_PZetaVis")
        #if not self.m3_t_PZetaVis_branch and "m3_t_PZetaVis" not in self.complained:
        if not self.m3_t_PZetaVis_branch and "m3_t_PZetaVis":
            warnings.warn( "MuMuMuTauTree: Expected branch m3_t_PZetaVis does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3_t_PZetaVis")
        else:
            self.m3_t_PZetaVis_branch.SetAddress(<void*>&self.m3_t_PZetaVis_value)

        #print "making m3_t_Phi"
        self.m3_t_Phi_branch = the_tree.GetBranch("m3_t_Phi")
        #if not self.m3_t_Phi_branch and "m3_t_Phi" not in self.complained:
        if not self.m3_t_Phi_branch and "m3_t_Phi":
            warnings.warn( "MuMuMuTauTree: Expected branch m3_t_Phi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3_t_Phi")
        else:
            self.m3_t_Phi_branch.SetAddress(<void*>&self.m3_t_Phi_value)

        #print "making m3_t_Pt"
        self.m3_t_Pt_branch = the_tree.GetBranch("m3_t_Pt")
        #if not self.m3_t_Pt_branch and "m3_t_Pt" not in self.complained:
        if not self.m3_t_Pt_branch and "m3_t_Pt":
            warnings.warn( "MuMuMuTauTree: Expected branch m3_t_Pt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3_t_Pt")
        else:
            self.m3_t_Pt_branch.SetAddress(<void*>&self.m3_t_Pt_value)

        #print "making m3_t_PtFsr"
        self.m3_t_PtFsr_branch = the_tree.GetBranch("m3_t_PtFsr")
        #if not self.m3_t_PtFsr_branch and "m3_t_PtFsr" not in self.complained:
        if not self.m3_t_PtFsr_branch and "m3_t_PtFsr":
            warnings.warn( "MuMuMuTauTree: Expected branch m3_t_PtFsr does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3_t_PtFsr")
        else:
            self.m3_t_PtFsr_branch.SetAddress(<void*>&self.m3_t_PtFsr_value)

        #print "making m3_t_SS"
        self.m3_t_SS_branch = the_tree.GetBranch("m3_t_SS")
        #if not self.m3_t_SS_branch and "m3_t_SS" not in self.complained:
        if not self.m3_t_SS_branch and "m3_t_SS":
            warnings.warn( "MuMuMuTauTree: Expected branch m3_t_SS does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3_t_SS")
        else:
            self.m3_t_SS_branch.SetAddress(<void*>&self.m3_t_SS_value)

        #print "making m3_t_SVfitEta"
        self.m3_t_SVfitEta_branch = the_tree.GetBranch("m3_t_SVfitEta")
        #if not self.m3_t_SVfitEta_branch and "m3_t_SVfitEta" not in self.complained:
        if not self.m3_t_SVfitEta_branch and "m3_t_SVfitEta":
            warnings.warn( "MuMuMuTauTree: Expected branch m3_t_SVfitEta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3_t_SVfitEta")
        else:
            self.m3_t_SVfitEta_branch.SetAddress(<void*>&self.m3_t_SVfitEta_value)

        #print "making m3_t_SVfitMass"
        self.m3_t_SVfitMass_branch = the_tree.GetBranch("m3_t_SVfitMass")
        #if not self.m3_t_SVfitMass_branch and "m3_t_SVfitMass" not in self.complained:
        if not self.m3_t_SVfitMass_branch and "m3_t_SVfitMass":
            warnings.warn( "MuMuMuTauTree: Expected branch m3_t_SVfitMass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3_t_SVfitMass")
        else:
            self.m3_t_SVfitMass_branch.SetAddress(<void*>&self.m3_t_SVfitMass_value)

        #print "making m3_t_SVfitPhi"
        self.m3_t_SVfitPhi_branch = the_tree.GetBranch("m3_t_SVfitPhi")
        #if not self.m3_t_SVfitPhi_branch and "m3_t_SVfitPhi" not in self.complained:
        if not self.m3_t_SVfitPhi_branch and "m3_t_SVfitPhi":
            warnings.warn( "MuMuMuTauTree: Expected branch m3_t_SVfitPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3_t_SVfitPhi")
        else:
            self.m3_t_SVfitPhi_branch.SetAddress(<void*>&self.m3_t_SVfitPhi_value)

        #print "making m3_t_SVfitPt"
        self.m3_t_SVfitPt_branch = the_tree.GetBranch("m3_t_SVfitPt")
        #if not self.m3_t_SVfitPt_branch and "m3_t_SVfitPt" not in self.complained:
        if not self.m3_t_SVfitPt_branch and "m3_t_SVfitPt":
            warnings.warn( "MuMuMuTauTree: Expected branch m3_t_SVfitPt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3_t_SVfitPt")
        else:
            self.m3_t_SVfitPt_branch.SetAddress(<void*>&self.m3_t_SVfitPt_value)

        #print "making m3_t_ToMETDPhi_Ty1"
        self.m3_t_ToMETDPhi_Ty1_branch = the_tree.GetBranch("m3_t_ToMETDPhi_Ty1")
        #if not self.m3_t_ToMETDPhi_Ty1_branch and "m3_t_ToMETDPhi_Ty1" not in self.complained:
        if not self.m3_t_ToMETDPhi_Ty1_branch and "m3_t_ToMETDPhi_Ty1":
            warnings.warn( "MuMuMuTauTree: Expected branch m3_t_ToMETDPhi_Ty1 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3_t_ToMETDPhi_Ty1")
        else:
            self.m3_t_ToMETDPhi_Ty1_branch.SetAddress(<void*>&self.m3_t_ToMETDPhi_Ty1_value)

        #print "making m3_t_Zcompat"
        self.m3_t_Zcompat_branch = the_tree.GetBranch("m3_t_Zcompat")
        #if not self.m3_t_Zcompat_branch and "m3_t_Zcompat" not in self.complained:
        if not self.m3_t_Zcompat_branch and "m3_t_Zcompat":
            warnings.warn( "MuMuMuTauTree: Expected branch m3_t_Zcompat does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3_t_Zcompat")
        else:
            self.m3_t_Zcompat_branch.SetAddress(<void*>&self.m3_t_Zcompat_value)

        #print "making mu17ele8Group"
        self.mu17ele8Group_branch = the_tree.GetBranch("mu17ele8Group")
        #if not self.mu17ele8Group_branch and "mu17ele8Group" not in self.complained:
        if not self.mu17ele8Group_branch and "mu17ele8Group":
            warnings.warn( "MuMuMuTauTree: Expected branch mu17ele8Group does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mu17ele8Group")
        else:
            self.mu17ele8Group_branch.SetAddress(<void*>&self.mu17ele8Group_value)

        #print "making mu17ele8Pass"
        self.mu17ele8Pass_branch = the_tree.GetBranch("mu17ele8Pass")
        #if not self.mu17ele8Pass_branch and "mu17ele8Pass" not in self.complained:
        if not self.mu17ele8Pass_branch and "mu17ele8Pass":
            warnings.warn( "MuMuMuTauTree: Expected branch mu17ele8Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mu17ele8Pass")
        else:
            self.mu17ele8Pass_branch.SetAddress(<void*>&self.mu17ele8Pass_value)

        #print "making mu17ele8Prescale"
        self.mu17ele8Prescale_branch = the_tree.GetBranch("mu17ele8Prescale")
        #if not self.mu17ele8Prescale_branch and "mu17ele8Prescale" not in self.complained:
        if not self.mu17ele8Prescale_branch and "mu17ele8Prescale":
            warnings.warn( "MuMuMuTauTree: Expected branch mu17ele8Prescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mu17ele8Prescale")
        else:
            self.mu17ele8Prescale_branch.SetAddress(<void*>&self.mu17ele8Prescale_value)

        #print "making mu17ele8isoGroup"
        self.mu17ele8isoGroup_branch = the_tree.GetBranch("mu17ele8isoGroup")
        #if not self.mu17ele8isoGroup_branch and "mu17ele8isoGroup" not in self.complained:
        if not self.mu17ele8isoGroup_branch and "mu17ele8isoGroup":
            warnings.warn( "MuMuMuTauTree: Expected branch mu17ele8isoGroup does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mu17ele8isoGroup")
        else:
            self.mu17ele8isoGroup_branch.SetAddress(<void*>&self.mu17ele8isoGroup_value)

        #print "making mu17ele8isoPass"
        self.mu17ele8isoPass_branch = the_tree.GetBranch("mu17ele8isoPass")
        #if not self.mu17ele8isoPass_branch and "mu17ele8isoPass" not in self.complained:
        if not self.mu17ele8isoPass_branch and "mu17ele8isoPass":
            warnings.warn( "MuMuMuTauTree: Expected branch mu17ele8isoPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mu17ele8isoPass")
        else:
            self.mu17ele8isoPass_branch.SetAddress(<void*>&self.mu17ele8isoPass_value)

        #print "making mu17ele8isoPrescale"
        self.mu17ele8isoPrescale_branch = the_tree.GetBranch("mu17ele8isoPrescale")
        #if not self.mu17ele8isoPrescale_branch and "mu17ele8isoPrescale" not in self.complained:
        if not self.mu17ele8isoPrescale_branch and "mu17ele8isoPrescale":
            warnings.warn( "MuMuMuTauTree: Expected branch mu17ele8isoPrescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mu17ele8isoPrescale")
        else:
            self.mu17ele8isoPrescale_branch.SetAddress(<void*>&self.mu17ele8isoPrescale_value)

        #print "making mu17mu8Group"
        self.mu17mu8Group_branch = the_tree.GetBranch("mu17mu8Group")
        #if not self.mu17mu8Group_branch and "mu17mu8Group" not in self.complained:
        if not self.mu17mu8Group_branch and "mu17mu8Group":
            warnings.warn( "MuMuMuTauTree: Expected branch mu17mu8Group does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mu17mu8Group")
        else:
            self.mu17mu8Group_branch.SetAddress(<void*>&self.mu17mu8Group_value)

        #print "making mu17mu8Pass"
        self.mu17mu8Pass_branch = the_tree.GetBranch("mu17mu8Pass")
        #if not self.mu17mu8Pass_branch and "mu17mu8Pass" not in self.complained:
        if not self.mu17mu8Pass_branch and "mu17mu8Pass":
            warnings.warn( "MuMuMuTauTree: Expected branch mu17mu8Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mu17mu8Pass")
        else:
            self.mu17mu8Pass_branch.SetAddress(<void*>&self.mu17mu8Pass_value)

        #print "making mu17mu8Prescale"
        self.mu17mu8Prescale_branch = the_tree.GetBranch("mu17mu8Prescale")
        #if not self.mu17mu8Prescale_branch and "mu17mu8Prescale" not in self.complained:
        if not self.mu17mu8Prescale_branch and "mu17mu8Prescale":
            warnings.warn( "MuMuMuTauTree: Expected branch mu17mu8Prescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mu17mu8Prescale")
        else:
            self.mu17mu8Prescale_branch.SetAddress(<void*>&self.mu17mu8Prescale_value)

        #print "making mu8ele17Group"
        self.mu8ele17Group_branch = the_tree.GetBranch("mu8ele17Group")
        #if not self.mu8ele17Group_branch and "mu8ele17Group" not in self.complained:
        if not self.mu8ele17Group_branch and "mu8ele17Group":
            warnings.warn( "MuMuMuTauTree: Expected branch mu8ele17Group does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mu8ele17Group")
        else:
            self.mu8ele17Group_branch.SetAddress(<void*>&self.mu8ele17Group_value)

        #print "making mu8ele17Pass"
        self.mu8ele17Pass_branch = the_tree.GetBranch("mu8ele17Pass")
        #if not self.mu8ele17Pass_branch and "mu8ele17Pass" not in self.complained:
        if not self.mu8ele17Pass_branch and "mu8ele17Pass":
            warnings.warn( "MuMuMuTauTree: Expected branch mu8ele17Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mu8ele17Pass")
        else:
            self.mu8ele17Pass_branch.SetAddress(<void*>&self.mu8ele17Pass_value)

        #print "making mu8ele17Prescale"
        self.mu8ele17Prescale_branch = the_tree.GetBranch("mu8ele17Prescale")
        #if not self.mu8ele17Prescale_branch and "mu8ele17Prescale" not in self.complained:
        if not self.mu8ele17Prescale_branch and "mu8ele17Prescale":
            warnings.warn( "MuMuMuTauTree: Expected branch mu8ele17Prescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mu8ele17Prescale")
        else:
            self.mu8ele17Prescale_branch.SetAddress(<void*>&self.mu8ele17Prescale_value)

        #print "making mu8ele17isoGroup"
        self.mu8ele17isoGroup_branch = the_tree.GetBranch("mu8ele17isoGroup")
        #if not self.mu8ele17isoGroup_branch and "mu8ele17isoGroup" not in self.complained:
        if not self.mu8ele17isoGroup_branch and "mu8ele17isoGroup":
            warnings.warn( "MuMuMuTauTree: Expected branch mu8ele17isoGroup does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mu8ele17isoGroup")
        else:
            self.mu8ele17isoGroup_branch.SetAddress(<void*>&self.mu8ele17isoGroup_value)

        #print "making mu8ele17isoPass"
        self.mu8ele17isoPass_branch = the_tree.GetBranch("mu8ele17isoPass")
        #if not self.mu8ele17isoPass_branch and "mu8ele17isoPass" not in self.complained:
        if not self.mu8ele17isoPass_branch and "mu8ele17isoPass":
            warnings.warn( "MuMuMuTauTree: Expected branch mu8ele17isoPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mu8ele17isoPass")
        else:
            self.mu8ele17isoPass_branch.SetAddress(<void*>&self.mu8ele17isoPass_value)

        #print "making mu8ele17isoPrescale"
        self.mu8ele17isoPrescale_branch = the_tree.GetBranch("mu8ele17isoPrescale")
        #if not self.mu8ele17isoPrescale_branch and "mu8ele17isoPrescale" not in self.complained:
        if not self.mu8ele17isoPrescale_branch and "mu8ele17isoPrescale":
            warnings.warn( "MuMuMuTauTree: Expected branch mu8ele17isoPrescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mu8ele17isoPrescale")
        else:
            self.mu8ele17isoPrescale_branch.SetAddress(<void*>&self.mu8ele17isoPrescale_value)

        #print "making muGlbIsoVetoPt10"
        self.muGlbIsoVetoPt10_branch = the_tree.GetBranch("muGlbIsoVetoPt10")
        #if not self.muGlbIsoVetoPt10_branch and "muGlbIsoVetoPt10" not in self.complained:
        if not self.muGlbIsoVetoPt10_branch and "muGlbIsoVetoPt10":
            warnings.warn( "MuMuMuTauTree: Expected branch muGlbIsoVetoPt10 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("muGlbIsoVetoPt10")
        else:
            self.muGlbIsoVetoPt10_branch.SetAddress(<void*>&self.muGlbIsoVetoPt10_value)

        #print "making muTauGroup"
        self.muTauGroup_branch = the_tree.GetBranch("muTauGroup")
        #if not self.muTauGroup_branch and "muTauGroup" not in self.complained:
        if not self.muTauGroup_branch and "muTauGroup":
            warnings.warn( "MuMuMuTauTree: Expected branch muTauGroup does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("muTauGroup")
        else:
            self.muTauGroup_branch.SetAddress(<void*>&self.muTauGroup_value)

        #print "making muTauPass"
        self.muTauPass_branch = the_tree.GetBranch("muTauPass")
        #if not self.muTauPass_branch and "muTauPass" not in self.complained:
        if not self.muTauPass_branch and "muTauPass":
            warnings.warn( "MuMuMuTauTree: Expected branch muTauPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("muTauPass")
        else:
            self.muTauPass_branch.SetAddress(<void*>&self.muTauPass_value)

        #print "making muTauPrescale"
        self.muTauPrescale_branch = the_tree.GetBranch("muTauPrescale")
        #if not self.muTauPrescale_branch and "muTauPrescale" not in self.complained:
        if not self.muTauPrescale_branch and "muTauPrescale":
            warnings.warn( "MuMuMuTauTree: Expected branch muTauPrescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("muTauPrescale")
        else:
            self.muTauPrescale_branch.SetAddress(<void*>&self.muTauPrescale_value)

        #print "making muTauTestGroup"
        self.muTauTestGroup_branch = the_tree.GetBranch("muTauTestGroup")
        #if not self.muTauTestGroup_branch and "muTauTestGroup" not in self.complained:
        if not self.muTauTestGroup_branch and "muTauTestGroup":
            warnings.warn( "MuMuMuTauTree: Expected branch muTauTestGroup does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("muTauTestGroup")
        else:
            self.muTauTestGroup_branch.SetAddress(<void*>&self.muTauTestGroup_value)

        #print "making muTauTestPass"
        self.muTauTestPass_branch = the_tree.GetBranch("muTauTestPass")
        #if not self.muTauTestPass_branch and "muTauTestPass" not in self.complained:
        if not self.muTauTestPass_branch and "muTauTestPass":
            warnings.warn( "MuMuMuTauTree: Expected branch muTauTestPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("muTauTestPass")
        else:
            self.muTauTestPass_branch.SetAddress(<void*>&self.muTauTestPass_value)

        #print "making muTauTestPrescale"
        self.muTauTestPrescale_branch = the_tree.GetBranch("muTauTestPrescale")
        #if not self.muTauTestPrescale_branch and "muTauTestPrescale" not in self.complained:
        if not self.muTauTestPrescale_branch and "muTauTestPrescale":
            warnings.warn( "MuMuMuTauTree: Expected branch muTauTestPrescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("muTauTestPrescale")
        else:
            self.muTauTestPrescale_branch.SetAddress(<void*>&self.muTauTestPrescale_value)

        #print "making muTightCountZH"
        self.muTightCountZH_branch = the_tree.GetBranch("muTightCountZH")
        #if not self.muTightCountZH_branch and "muTightCountZH" not in self.complained:
        if not self.muTightCountZH_branch and "muTightCountZH":
            warnings.warn( "MuMuMuTauTree: Expected branch muTightCountZH does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("muTightCountZH")
        else:
            self.muTightCountZH_branch.SetAddress(<void*>&self.muTightCountZH_value)

        #print "making muVetoPt15IsoIdVtx"
        self.muVetoPt15IsoIdVtx_branch = the_tree.GetBranch("muVetoPt15IsoIdVtx")
        #if not self.muVetoPt15IsoIdVtx_branch and "muVetoPt15IsoIdVtx" not in self.complained:
        if not self.muVetoPt15IsoIdVtx_branch and "muVetoPt15IsoIdVtx":
            warnings.warn( "MuMuMuTauTree: Expected branch muVetoPt15IsoIdVtx does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("muVetoPt15IsoIdVtx")
        else:
            self.muVetoPt15IsoIdVtx_branch.SetAddress(<void*>&self.muVetoPt15IsoIdVtx_value)

        #print "making muVetoPt5"
        self.muVetoPt5_branch = the_tree.GetBranch("muVetoPt5")
        #if not self.muVetoPt5_branch and "muVetoPt5" not in self.complained:
        if not self.muVetoPt5_branch and "muVetoPt5":
            warnings.warn( "MuMuMuTauTree: Expected branch muVetoPt5 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("muVetoPt5")
        else:
            self.muVetoPt5_branch.SetAddress(<void*>&self.muVetoPt5_value)

        #print "making muVetoPt5IsoIdVtx"
        self.muVetoPt5IsoIdVtx_branch = the_tree.GetBranch("muVetoPt5IsoIdVtx")
        #if not self.muVetoPt5IsoIdVtx_branch and "muVetoPt5IsoIdVtx" not in self.complained:
        if not self.muVetoPt5IsoIdVtx_branch and "muVetoPt5IsoIdVtx":
            warnings.warn( "MuMuMuTauTree: Expected branch muVetoPt5IsoIdVtx does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("muVetoPt5IsoIdVtx")
        else:
            self.muVetoPt5IsoIdVtx_branch.SetAddress(<void*>&self.muVetoPt5IsoIdVtx_value)

        #print "making muVetoZH"
        self.muVetoZH_branch = the_tree.GetBranch("muVetoZH")
        #if not self.muVetoZH_branch and "muVetoZH" not in self.complained:
        if not self.muVetoZH_branch and "muVetoZH":
            warnings.warn( "MuMuMuTauTree: Expected branch muVetoZH does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("muVetoZH")
        else:
            self.muVetoZH_branch.SetAddress(<void*>&self.muVetoZH_value)

        #print "making mva_metEt"
        self.mva_metEt_branch = the_tree.GetBranch("mva_metEt")
        #if not self.mva_metEt_branch and "mva_metEt" not in self.complained:
        if not self.mva_metEt_branch and "mva_metEt":
            warnings.warn( "MuMuMuTauTree: Expected branch mva_metEt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mva_metEt")
        else:
            self.mva_metEt_branch.SetAddress(<void*>&self.mva_metEt_value)

        #print "making mva_metPhi"
        self.mva_metPhi_branch = the_tree.GetBranch("mva_metPhi")
        #if not self.mva_metPhi_branch and "mva_metPhi" not in self.complained:
        if not self.mva_metPhi_branch and "mva_metPhi":
            warnings.warn( "MuMuMuTauTree: Expected branch mva_metPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mva_metPhi")
        else:
            self.mva_metPhi_branch.SetAddress(<void*>&self.mva_metPhi_value)

        #print "making nTruePU"
        self.nTruePU_branch = the_tree.GetBranch("nTruePU")
        #if not self.nTruePU_branch and "nTruePU" not in self.complained:
        if not self.nTruePU_branch and "nTruePU":
            warnings.warn( "MuMuMuTauTree: Expected branch nTruePU does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("nTruePU")
        else:
            self.nTruePU_branch.SetAddress(<void*>&self.nTruePU_value)

        #print "making nvtx"
        self.nvtx_branch = the_tree.GetBranch("nvtx")
        #if not self.nvtx_branch and "nvtx" not in self.complained:
        if not self.nvtx_branch and "nvtx":
            warnings.warn( "MuMuMuTauTree: Expected branch nvtx does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("nvtx")
        else:
            self.nvtx_branch.SetAddress(<void*>&self.nvtx_value)

        #print "making pfMetEt"
        self.pfMetEt_branch = the_tree.GetBranch("pfMetEt")
        #if not self.pfMetEt_branch and "pfMetEt" not in self.complained:
        if not self.pfMetEt_branch and "pfMetEt":
            warnings.warn( "MuMuMuTauTree: Expected branch pfMetEt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pfMetEt")
        else:
            self.pfMetEt_branch.SetAddress(<void*>&self.pfMetEt_value)

        #print "making pfMetPhi"
        self.pfMetPhi_branch = the_tree.GetBranch("pfMetPhi")
        #if not self.pfMetPhi_branch and "pfMetPhi" not in self.complained:
        if not self.pfMetPhi_branch and "pfMetPhi":
            warnings.warn( "MuMuMuTauTree: Expected branch pfMetPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pfMetPhi")
        else:
            self.pfMetPhi_branch.SetAddress(<void*>&self.pfMetPhi_value)

        #print "making pfMet_jes_Et"
        self.pfMet_jes_Et_branch = the_tree.GetBranch("pfMet_jes_Et")
        #if not self.pfMet_jes_Et_branch and "pfMet_jes_Et" not in self.complained:
        if not self.pfMet_jes_Et_branch and "pfMet_jes_Et":
            warnings.warn( "MuMuMuTauTree: Expected branch pfMet_jes_Et does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pfMet_jes_Et")
        else:
            self.pfMet_jes_Et_branch.SetAddress(<void*>&self.pfMet_jes_Et_value)

        #print "making pfMet_jes_Phi"
        self.pfMet_jes_Phi_branch = the_tree.GetBranch("pfMet_jes_Phi")
        #if not self.pfMet_jes_Phi_branch and "pfMet_jes_Phi" not in self.complained:
        if not self.pfMet_jes_Phi_branch and "pfMet_jes_Phi":
            warnings.warn( "MuMuMuTauTree: Expected branch pfMet_jes_Phi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pfMet_jes_Phi")
        else:
            self.pfMet_jes_Phi_branch.SetAddress(<void*>&self.pfMet_jes_Phi_value)

        #print "making pfMet_mes_Et"
        self.pfMet_mes_Et_branch = the_tree.GetBranch("pfMet_mes_Et")
        #if not self.pfMet_mes_Et_branch and "pfMet_mes_Et" not in self.complained:
        if not self.pfMet_mes_Et_branch and "pfMet_mes_Et":
            warnings.warn( "MuMuMuTauTree: Expected branch pfMet_mes_Et does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pfMet_mes_Et")
        else:
            self.pfMet_mes_Et_branch.SetAddress(<void*>&self.pfMet_mes_Et_value)

        #print "making pfMet_mes_Phi"
        self.pfMet_mes_Phi_branch = the_tree.GetBranch("pfMet_mes_Phi")
        #if not self.pfMet_mes_Phi_branch and "pfMet_mes_Phi" not in self.complained:
        if not self.pfMet_mes_Phi_branch and "pfMet_mes_Phi":
            warnings.warn( "MuMuMuTauTree: Expected branch pfMet_mes_Phi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pfMet_mes_Phi")
        else:
            self.pfMet_mes_Phi_branch.SetAddress(<void*>&self.pfMet_mes_Phi_value)

        #print "making pfMet_tes_Et"
        self.pfMet_tes_Et_branch = the_tree.GetBranch("pfMet_tes_Et")
        #if not self.pfMet_tes_Et_branch and "pfMet_tes_Et" not in self.complained:
        if not self.pfMet_tes_Et_branch and "pfMet_tes_Et":
            warnings.warn( "MuMuMuTauTree: Expected branch pfMet_tes_Et does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pfMet_tes_Et")
        else:
            self.pfMet_tes_Et_branch.SetAddress(<void*>&self.pfMet_tes_Et_value)

        #print "making pfMet_tes_Phi"
        self.pfMet_tes_Phi_branch = the_tree.GetBranch("pfMet_tes_Phi")
        #if not self.pfMet_tes_Phi_branch and "pfMet_tes_Phi" not in self.complained:
        if not self.pfMet_tes_Phi_branch and "pfMet_tes_Phi":
            warnings.warn( "MuMuMuTauTree: Expected branch pfMet_tes_Phi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pfMet_tes_Phi")
        else:
            self.pfMet_tes_Phi_branch.SetAddress(<void*>&self.pfMet_tes_Phi_value)

        #print "making pfMet_ues_Et"
        self.pfMet_ues_Et_branch = the_tree.GetBranch("pfMet_ues_Et")
        #if not self.pfMet_ues_Et_branch and "pfMet_ues_Et" not in self.complained:
        if not self.pfMet_ues_Et_branch and "pfMet_ues_Et":
            warnings.warn( "MuMuMuTauTree: Expected branch pfMet_ues_Et does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pfMet_ues_Et")
        else:
            self.pfMet_ues_Et_branch.SetAddress(<void*>&self.pfMet_ues_Et_value)

        #print "making pfMet_ues_Phi"
        self.pfMet_ues_Phi_branch = the_tree.GetBranch("pfMet_ues_Phi")
        #if not self.pfMet_ues_Phi_branch and "pfMet_ues_Phi" not in self.complained:
        if not self.pfMet_ues_Phi_branch and "pfMet_ues_Phi":
            warnings.warn( "MuMuMuTauTree: Expected branch pfMet_ues_Phi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pfMet_ues_Phi")
        else:
            self.pfMet_ues_Phi_branch.SetAddress(<void*>&self.pfMet_ues_Phi_value)

        #print "making processID"
        self.processID_branch = the_tree.GetBranch("processID")
        #if not self.processID_branch and "processID" not in self.complained:
        if not self.processID_branch and "processID":
            warnings.warn( "MuMuMuTauTree: Expected branch processID does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("processID")
        else:
            self.processID_branch.SetAddress(<void*>&self.processID_value)

        #print "making pvChi2"
        self.pvChi2_branch = the_tree.GetBranch("pvChi2")
        #if not self.pvChi2_branch and "pvChi2" not in self.complained:
        if not self.pvChi2_branch and "pvChi2":
            warnings.warn( "MuMuMuTauTree: Expected branch pvChi2 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pvChi2")
        else:
            self.pvChi2_branch.SetAddress(<void*>&self.pvChi2_value)

        #print "making pvDX"
        self.pvDX_branch = the_tree.GetBranch("pvDX")
        #if not self.pvDX_branch and "pvDX" not in self.complained:
        if not self.pvDX_branch and "pvDX":
            warnings.warn( "MuMuMuTauTree: Expected branch pvDX does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pvDX")
        else:
            self.pvDX_branch.SetAddress(<void*>&self.pvDX_value)

        #print "making pvDY"
        self.pvDY_branch = the_tree.GetBranch("pvDY")
        #if not self.pvDY_branch and "pvDY" not in self.complained:
        if not self.pvDY_branch and "pvDY":
            warnings.warn( "MuMuMuTauTree: Expected branch pvDY does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pvDY")
        else:
            self.pvDY_branch.SetAddress(<void*>&self.pvDY_value)

        #print "making pvDZ"
        self.pvDZ_branch = the_tree.GetBranch("pvDZ")
        #if not self.pvDZ_branch and "pvDZ" not in self.complained:
        if not self.pvDZ_branch and "pvDZ":
            warnings.warn( "MuMuMuTauTree: Expected branch pvDZ does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pvDZ")
        else:
            self.pvDZ_branch.SetAddress(<void*>&self.pvDZ_value)

        #print "making pvIsFake"
        self.pvIsFake_branch = the_tree.GetBranch("pvIsFake")
        #if not self.pvIsFake_branch and "pvIsFake" not in self.complained:
        if not self.pvIsFake_branch and "pvIsFake":
            warnings.warn( "MuMuMuTauTree: Expected branch pvIsFake does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pvIsFake")
        else:
            self.pvIsFake_branch.SetAddress(<void*>&self.pvIsFake_value)

        #print "making pvIsValid"
        self.pvIsValid_branch = the_tree.GetBranch("pvIsValid")
        #if not self.pvIsValid_branch and "pvIsValid" not in self.complained:
        if not self.pvIsValid_branch and "pvIsValid":
            warnings.warn( "MuMuMuTauTree: Expected branch pvIsValid does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pvIsValid")
        else:
            self.pvIsValid_branch.SetAddress(<void*>&self.pvIsValid_value)

        #print "making pvNormChi2"
        self.pvNormChi2_branch = the_tree.GetBranch("pvNormChi2")
        #if not self.pvNormChi2_branch and "pvNormChi2" not in self.complained:
        if not self.pvNormChi2_branch and "pvNormChi2":
            warnings.warn( "MuMuMuTauTree: Expected branch pvNormChi2 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pvNormChi2")
        else:
            self.pvNormChi2_branch.SetAddress(<void*>&self.pvNormChi2_value)

        #print "making pvX"
        self.pvX_branch = the_tree.GetBranch("pvX")
        #if not self.pvX_branch and "pvX" not in self.complained:
        if not self.pvX_branch and "pvX":
            warnings.warn( "MuMuMuTauTree: Expected branch pvX does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pvX")
        else:
            self.pvX_branch.SetAddress(<void*>&self.pvX_value)

        #print "making pvY"
        self.pvY_branch = the_tree.GetBranch("pvY")
        #if not self.pvY_branch and "pvY" not in self.complained:
        if not self.pvY_branch and "pvY":
            warnings.warn( "MuMuMuTauTree: Expected branch pvY does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pvY")
        else:
            self.pvY_branch.SetAddress(<void*>&self.pvY_value)

        #print "making pvZ"
        self.pvZ_branch = the_tree.GetBranch("pvZ")
        #if not self.pvZ_branch and "pvZ" not in self.complained:
        if not self.pvZ_branch and "pvZ":
            warnings.warn( "MuMuMuTauTree: Expected branch pvZ does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pvZ")
        else:
            self.pvZ_branch.SetAddress(<void*>&self.pvZ_value)

        #print "making pvndof"
        self.pvndof_branch = the_tree.GetBranch("pvndof")
        #if not self.pvndof_branch and "pvndof" not in self.complained:
        if not self.pvndof_branch and "pvndof":
            warnings.warn( "MuMuMuTauTree: Expected branch pvndof does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pvndof")
        else:
            self.pvndof_branch.SetAddress(<void*>&self.pvndof_value)

        #print "making recoilDaught"
        self.recoilDaught_branch = the_tree.GetBranch("recoilDaught")
        #if not self.recoilDaught_branch and "recoilDaught" not in self.complained:
        if not self.recoilDaught_branch and "recoilDaught":
            warnings.warn( "MuMuMuTauTree: Expected branch recoilDaught does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("recoilDaught")
        else:
            self.recoilDaught_branch.SetAddress(<void*>&self.recoilDaught_value)

        #print "making recoilWithMet"
        self.recoilWithMet_branch = the_tree.GetBranch("recoilWithMet")
        #if not self.recoilWithMet_branch and "recoilWithMet" not in self.complained:
        if not self.recoilWithMet_branch and "recoilWithMet":
            warnings.warn( "MuMuMuTauTree: Expected branch recoilWithMet does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("recoilWithMet")
        else:
            self.recoilWithMet_branch.SetAddress(<void*>&self.recoilWithMet_value)

        #print "making rho"
        self.rho_branch = the_tree.GetBranch("rho")
        #if not self.rho_branch and "rho" not in self.complained:
        if not self.rho_branch and "rho":
            warnings.warn( "MuMuMuTauTree: Expected branch rho does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("rho")
        else:
            self.rho_branch.SetAddress(<void*>&self.rho_value)

        #print "making run"
        self.run_branch = the_tree.GetBranch("run")
        #if not self.run_branch and "run" not in self.complained:
        if not self.run_branch and "run":
            warnings.warn( "MuMuMuTauTree: Expected branch run does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("run")
        else:
            self.run_branch.SetAddress(<void*>&self.run_value)

        #print "making singleEGroup"
        self.singleEGroup_branch = the_tree.GetBranch("singleEGroup")
        #if not self.singleEGroup_branch and "singleEGroup" not in self.complained:
        if not self.singleEGroup_branch and "singleEGroup":
            warnings.warn( "MuMuMuTauTree: Expected branch singleEGroup does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleEGroup")
        else:
            self.singleEGroup_branch.SetAddress(<void*>&self.singleEGroup_value)

        #print "making singleEPFMTGroup"
        self.singleEPFMTGroup_branch = the_tree.GetBranch("singleEPFMTGroup")
        #if not self.singleEPFMTGroup_branch and "singleEPFMTGroup" not in self.complained:
        if not self.singleEPFMTGroup_branch and "singleEPFMTGroup":
            warnings.warn( "MuMuMuTauTree: Expected branch singleEPFMTGroup does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleEPFMTGroup")
        else:
            self.singleEPFMTGroup_branch.SetAddress(<void*>&self.singleEPFMTGroup_value)

        #print "making singleEPFMTPass"
        self.singleEPFMTPass_branch = the_tree.GetBranch("singleEPFMTPass")
        #if not self.singleEPFMTPass_branch and "singleEPFMTPass" not in self.complained:
        if not self.singleEPFMTPass_branch and "singleEPFMTPass":
            warnings.warn( "MuMuMuTauTree: Expected branch singleEPFMTPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleEPFMTPass")
        else:
            self.singleEPFMTPass_branch.SetAddress(<void*>&self.singleEPFMTPass_value)

        #print "making singleEPFMTPrescale"
        self.singleEPFMTPrescale_branch = the_tree.GetBranch("singleEPFMTPrescale")
        #if not self.singleEPFMTPrescale_branch and "singleEPFMTPrescale" not in self.complained:
        if not self.singleEPFMTPrescale_branch and "singleEPFMTPrescale":
            warnings.warn( "MuMuMuTauTree: Expected branch singleEPFMTPrescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleEPFMTPrescale")
        else:
            self.singleEPFMTPrescale_branch.SetAddress(<void*>&self.singleEPFMTPrescale_value)

        #print "making singleEPass"
        self.singleEPass_branch = the_tree.GetBranch("singleEPass")
        #if not self.singleEPass_branch and "singleEPass" not in self.complained:
        if not self.singleEPass_branch and "singleEPass":
            warnings.warn( "MuMuMuTauTree: Expected branch singleEPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleEPass")
        else:
            self.singleEPass_branch.SetAddress(<void*>&self.singleEPass_value)

        #print "making singleEPrescale"
        self.singleEPrescale_branch = the_tree.GetBranch("singleEPrescale")
        #if not self.singleEPrescale_branch and "singleEPrescale" not in self.complained:
        if not self.singleEPrescale_branch and "singleEPrescale":
            warnings.warn( "MuMuMuTauTree: Expected branch singleEPrescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleEPrescale")
        else:
            self.singleEPrescale_branch.SetAddress(<void*>&self.singleEPrescale_value)

        #print "making singleMuGroup"
        self.singleMuGroup_branch = the_tree.GetBranch("singleMuGroup")
        #if not self.singleMuGroup_branch and "singleMuGroup" not in self.complained:
        if not self.singleMuGroup_branch and "singleMuGroup":
            warnings.warn( "MuMuMuTauTree: Expected branch singleMuGroup does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleMuGroup")
        else:
            self.singleMuGroup_branch.SetAddress(<void*>&self.singleMuGroup_value)

        #print "making singleMuPass"
        self.singleMuPass_branch = the_tree.GetBranch("singleMuPass")
        #if not self.singleMuPass_branch and "singleMuPass" not in self.complained:
        if not self.singleMuPass_branch and "singleMuPass":
            warnings.warn( "MuMuMuTauTree: Expected branch singleMuPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleMuPass")
        else:
            self.singleMuPass_branch.SetAddress(<void*>&self.singleMuPass_value)

        #print "making singleMuPrescale"
        self.singleMuPrescale_branch = the_tree.GetBranch("singleMuPrescale")
        #if not self.singleMuPrescale_branch and "singleMuPrescale" not in self.complained:
        if not self.singleMuPrescale_branch and "singleMuPrescale":
            warnings.warn( "MuMuMuTauTree: Expected branch singleMuPrescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleMuPrescale")
        else:
            self.singleMuPrescale_branch.SetAddress(<void*>&self.singleMuPrescale_value)

        #print "making singlePhoGroup"
        self.singlePhoGroup_branch = the_tree.GetBranch("singlePhoGroup")
        #if not self.singlePhoGroup_branch and "singlePhoGroup" not in self.complained:
        if not self.singlePhoGroup_branch and "singlePhoGroup":
            warnings.warn( "MuMuMuTauTree: Expected branch singlePhoGroup does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singlePhoGroup")
        else:
            self.singlePhoGroup_branch.SetAddress(<void*>&self.singlePhoGroup_value)

        #print "making singlePhoPass"
        self.singlePhoPass_branch = the_tree.GetBranch("singlePhoPass")
        #if not self.singlePhoPass_branch and "singlePhoPass" not in self.complained:
        if not self.singlePhoPass_branch and "singlePhoPass":
            warnings.warn( "MuMuMuTauTree: Expected branch singlePhoPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singlePhoPass")
        else:
            self.singlePhoPass_branch.SetAddress(<void*>&self.singlePhoPass_value)

        #print "making singlePhoPrescale"
        self.singlePhoPrescale_branch = the_tree.GetBranch("singlePhoPrescale")
        #if not self.singlePhoPrescale_branch and "singlePhoPrescale" not in self.complained:
        if not self.singlePhoPrescale_branch and "singlePhoPrescale":
            warnings.warn( "MuMuMuTauTree: Expected branch singlePhoPrescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singlePhoPrescale")
        else:
            self.singlePhoPrescale_branch.SetAddress(<void*>&self.singlePhoPrescale_value)

        #print "making tAbsEta"
        self.tAbsEta_branch = the_tree.GetBranch("tAbsEta")
        #if not self.tAbsEta_branch and "tAbsEta" not in self.complained:
        if not self.tAbsEta_branch and "tAbsEta":
            warnings.warn( "MuMuMuTauTree: Expected branch tAbsEta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tAbsEta")
        else:
            self.tAbsEta_branch.SetAddress(<void*>&self.tAbsEta_value)

        #print "making tAntiElectronLoose"
        self.tAntiElectronLoose_branch = the_tree.GetBranch("tAntiElectronLoose")
        #if not self.tAntiElectronLoose_branch and "tAntiElectronLoose" not in self.complained:
        if not self.tAntiElectronLoose_branch and "tAntiElectronLoose":
            warnings.warn( "MuMuMuTauTree: Expected branch tAntiElectronLoose does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tAntiElectronLoose")
        else:
            self.tAntiElectronLoose_branch.SetAddress(<void*>&self.tAntiElectronLoose_value)

        #print "making tAntiElectronMVA3Loose"
        self.tAntiElectronMVA3Loose_branch = the_tree.GetBranch("tAntiElectronMVA3Loose")
        #if not self.tAntiElectronMVA3Loose_branch and "tAntiElectronMVA3Loose" not in self.complained:
        if not self.tAntiElectronMVA3Loose_branch and "tAntiElectronMVA3Loose":
            warnings.warn( "MuMuMuTauTree: Expected branch tAntiElectronMVA3Loose does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tAntiElectronMVA3Loose")
        else:
            self.tAntiElectronMVA3Loose_branch.SetAddress(<void*>&self.tAntiElectronMVA3Loose_value)

        #print "making tAntiElectronMVA3Medium"
        self.tAntiElectronMVA3Medium_branch = the_tree.GetBranch("tAntiElectronMVA3Medium")
        #if not self.tAntiElectronMVA3Medium_branch and "tAntiElectronMVA3Medium" not in self.complained:
        if not self.tAntiElectronMVA3Medium_branch and "tAntiElectronMVA3Medium":
            warnings.warn( "MuMuMuTauTree: Expected branch tAntiElectronMVA3Medium does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tAntiElectronMVA3Medium")
        else:
            self.tAntiElectronMVA3Medium_branch.SetAddress(<void*>&self.tAntiElectronMVA3Medium_value)

        #print "making tAntiElectronMVA3Raw"
        self.tAntiElectronMVA3Raw_branch = the_tree.GetBranch("tAntiElectronMVA3Raw")
        #if not self.tAntiElectronMVA3Raw_branch and "tAntiElectronMVA3Raw" not in self.complained:
        if not self.tAntiElectronMVA3Raw_branch and "tAntiElectronMVA3Raw":
            warnings.warn( "MuMuMuTauTree: Expected branch tAntiElectronMVA3Raw does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tAntiElectronMVA3Raw")
        else:
            self.tAntiElectronMVA3Raw_branch.SetAddress(<void*>&self.tAntiElectronMVA3Raw_value)

        #print "making tAntiElectronMVA3Tight"
        self.tAntiElectronMVA3Tight_branch = the_tree.GetBranch("tAntiElectronMVA3Tight")
        #if not self.tAntiElectronMVA3Tight_branch and "tAntiElectronMVA3Tight" not in self.complained:
        if not self.tAntiElectronMVA3Tight_branch and "tAntiElectronMVA3Tight":
            warnings.warn( "MuMuMuTauTree: Expected branch tAntiElectronMVA3Tight does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tAntiElectronMVA3Tight")
        else:
            self.tAntiElectronMVA3Tight_branch.SetAddress(<void*>&self.tAntiElectronMVA3Tight_value)

        #print "making tAntiElectronMVA3VTight"
        self.tAntiElectronMVA3VTight_branch = the_tree.GetBranch("tAntiElectronMVA3VTight")
        #if not self.tAntiElectronMVA3VTight_branch and "tAntiElectronMVA3VTight" not in self.complained:
        if not self.tAntiElectronMVA3VTight_branch and "tAntiElectronMVA3VTight":
            warnings.warn( "MuMuMuTauTree: Expected branch tAntiElectronMVA3VTight does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tAntiElectronMVA3VTight")
        else:
            self.tAntiElectronMVA3VTight_branch.SetAddress(<void*>&self.tAntiElectronMVA3VTight_value)

        #print "making tAntiElectronMedium"
        self.tAntiElectronMedium_branch = the_tree.GetBranch("tAntiElectronMedium")
        #if not self.tAntiElectronMedium_branch and "tAntiElectronMedium" not in self.complained:
        if not self.tAntiElectronMedium_branch and "tAntiElectronMedium":
            warnings.warn( "MuMuMuTauTree: Expected branch tAntiElectronMedium does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tAntiElectronMedium")
        else:
            self.tAntiElectronMedium_branch.SetAddress(<void*>&self.tAntiElectronMedium_value)

        #print "making tAntiElectronTight"
        self.tAntiElectronTight_branch = the_tree.GetBranch("tAntiElectronTight")
        #if not self.tAntiElectronTight_branch and "tAntiElectronTight" not in self.complained:
        if not self.tAntiElectronTight_branch and "tAntiElectronTight":
            warnings.warn( "MuMuMuTauTree: Expected branch tAntiElectronTight does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tAntiElectronTight")
        else:
            self.tAntiElectronTight_branch.SetAddress(<void*>&self.tAntiElectronTight_value)

        #print "making tAntiMuonLoose"
        self.tAntiMuonLoose_branch = the_tree.GetBranch("tAntiMuonLoose")
        #if not self.tAntiMuonLoose_branch and "tAntiMuonLoose" not in self.complained:
        if not self.tAntiMuonLoose_branch and "tAntiMuonLoose":
            warnings.warn( "MuMuMuTauTree: Expected branch tAntiMuonLoose does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tAntiMuonLoose")
        else:
            self.tAntiMuonLoose_branch.SetAddress(<void*>&self.tAntiMuonLoose_value)

        #print "making tAntiMuonLoose2"
        self.tAntiMuonLoose2_branch = the_tree.GetBranch("tAntiMuonLoose2")
        #if not self.tAntiMuonLoose2_branch and "tAntiMuonLoose2" not in self.complained:
        if not self.tAntiMuonLoose2_branch and "tAntiMuonLoose2":
            warnings.warn( "MuMuMuTauTree: Expected branch tAntiMuonLoose2 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tAntiMuonLoose2")
        else:
            self.tAntiMuonLoose2_branch.SetAddress(<void*>&self.tAntiMuonLoose2_value)

        #print "making tAntiMuonMedium"
        self.tAntiMuonMedium_branch = the_tree.GetBranch("tAntiMuonMedium")
        #if not self.tAntiMuonMedium_branch and "tAntiMuonMedium" not in self.complained:
        if not self.tAntiMuonMedium_branch and "tAntiMuonMedium":
            warnings.warn( "MuMuMuTauTree: Expected branch tAntiMuonMedium does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tAntiMuonMedium")
        else:
            self.tAntiMuonMedium_branch.SetAddress(<void*>&self.tAntiMuonMedium_value)

        #print "making tAntiMuonMedium2"
        self.tAntiMuonMedium2_branch = the_tree.GetBranch("tAntiMuonMedium2")
        #if not self.tAntiMuonMedium2_branch and "tAntiMuonMedium2" not in self.complained:
        if not self.tAntiMuonMedium2_branch and "tAntiMuonMedium2":
            warnings.warn( "MuMuMuTauTree: Expected branch tAntiMuonMedium2 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tAntiMuonMedium2")
        else:
            self.tAntiMuonMedium2_branch.SetAddress(<void*>&self.tAntiMuonMedium2_value)

        #print "making tAntiMuonTight"
        self.tAntiMuonTight_branch = the_tree.GetBranch("tAntiMuonTight")
        #if not self.tAntiMuonTight_branch and "tAntiMuonTight" not in self.complained:
        if not self.tAntiMuonTight_branch and "tAntiMuonTight":
            warnings.warn( "MuMuMuTauTree: Expected branch tAntiMuonTight does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tAntiMuonTight")
        else:
            self.tAntiMuonTight_branch.SetAddress(<void*>&self.tAntiMuonTight_value)

        #print "making tAntiMuonTight2"
        self.tAntiMuonTight2_branch = the_tree.GetBranch("tAntiMuonTight2")
        #if not self.tAntiMuonTight2_branch and "tAntiMuonTight2" not in self.complained:
        if not self.tAntiMuonTight2_branch and "tAntiMuonTight2":
            warnings.warn( "MuMuMuTauTree: Expected branch tAntiMuonTight2 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tAntiMuonTight2")
        else:
            self.tAntiMuonTight2_branch.SetAddress(<void*>&self.tAntiMuonTight2_value)

        #print "making tCharge"
        self.tCharge_branch = the_tree.GetBranch("tCharge")
        #if not self.tCharge_branch and "tCharge" not in self.complained:
        if not self.tCharge_branch and "tCharge":
            warnings.warn( "MuMuMuTauTree: Expected branch tCharge does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tCharge")
        else:
            self.tCharge_branch.SetAddress(<void*>&self.tCharge_value)

        #print "making tCiCTightElecOverlap"
        self.tCiCTightElecOverlap_branch = the_tree.GetBranch("tCiCTightElecOverlap")
        #if not self.tCiCTightElecOverlap_branch and "tCiCTightElecOverlap" not in self.complained:
        if not self.tCiCTightElecOverlap_branch and "tCiCTightElecOverlap":
            warnings.warn( "MuMuMuTauTree: Expected branch tCiCTightElecOverlap does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tCiCTightElecOverlap")
        else:
            self.tCiCTightElecOverlap_branch.SetAddress(<void*>&self.tCiCTightElecOverlap_value)

        #print "making tDZ"
        self.tDZ_branch = the_tree.GetBranch("tDZ")
        #if not self.tDZ_branch and "tDZ" not in self.complained:
        if not self.tDZ_branch and "tDZ":
            warnings.warn( "MuMuMuTauTree: Expected branch tDZ does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tDZ")
        else:
            self.tDZ_branch.SetAddress(<void*>&self.tDZ_value)

        #print "making tDecayFinding"
        self.tDecayFinding_branch = the_tree.GetBranch("tDecayFinding")
        #if not self.tDecayFinding_branch and "tDecayFinding" not in self.complained:
        if not self.tDecayFinding_branch and "tDecayFinding":
            warnings.warn( "MuMuMuTauTree: Expected branch tDecayFinding does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tDecayFinding")
        else:
            self.tDecayFinding_branch.SetAddress(<void*>&self.tDecayFinding_value)

        #print "making tDecayMode"
        self.tDecayMode_branch = the_tree.GetBranch("tDecayMode")
        #if not self.tDecayMode_branch and "tDecayMode" not in self.complained:
        if not self.tDecayMode_branch and "tDecayMode":
            warnings.warn( "MuMuMuTauTree: Expected branch tDecayMode does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tDecayMode")
        else:
            self.tDecayMode_branch.SetAddress(<void*>&self.tDecayMode_value)

        #print "making tElecOverlap"
        self.tElecOverlap_branch = the_tree.GetBranch("tElecOverlap")
        #if not self.tElecOverlap_branch and "tElecOverlap" not in self.complained:
        if not self.tElecOverlap_branch and "tElecOverlap":
            warnings.warn( "MuMuMuTauTree: Expected branch tElecOverlap does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tElecOverlap")
        else:
            self.tElecOverlap_branch.SetAddress(<void*>&self.tElecOverlap_value)

        #print "making tElecOverlapZHLoose"
        self.tElecOverlapZHLoose_branch = the_tree.GetBranch("tElecOverlapZHLoose")
        #if not self.tElecOverlapZHLoose_branch and "tElecOverlapZHLoose" not in self.complained:
        if not self.tElecOverlapZHLoose_branch and "tElecOverlapZHLoose":
            warnings.warn( "MuMuMuTauTree: Expected branch tElecOverlapZHLoose does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tElecOverlapZHLoose")
        else:
            self.tElecOverlapZHLoose_branch.SetAddress(<void*>&self.tElecOverlapZHLoose_value)

        #print "making tElecOverlapZHTight"
        self.tElecOverlapZHTight_branch = the_tree.GetBranch("tElecOverlapZHTight")
        #if not self.tElecOverlapZHTight_branch and "tElecOverlapZHTight" not in self.complained:
        if not self.tElecOverlapZHTight_branch and "tElecOverlapZHTight":
            warnings.warn( "MuMuMuTauTree: Expected branch tElecOverlapZHTight does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tElecOverlapZHTight")
        else:
            self.tElecOverlapZHTight_branch.SetAddress(<void*>&self.tElecOverlapZHTight_value)

        #print "making tEta"
        self.tEta_branch = the_tree.GetBranch("tEta")
        #if not self.tEta_branch and "tEta" not in self.complained:
        if not self.tEta_branch and "tEta":
            warnings.warn( "MuMuMuTauTree: Expected branch tEta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tEta")
        else:
            self.tEta_branch.SetAddress(<void*>&self.tEta_value)

        #print "making tGenDecayMode"
        self.tGenDecayMode_branch = the_tree.GetBranch("tGenDecayMode")
        #if not self.tGenDecayMode_branch and "tGenDecayMode" not in self.complained:
        if not self.tGenDecayMode_branch and "tGenDecayMode":
            warnings.warn( "MuMuMuTauTree: Expected branch tGenDecayMode does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tGenDecayMode")
        else:
            self.tGenDecayMode_branch.SetAddress(<void*>&self.tGenDecayMode_value)

        #print "making tIP3DS"
        self.tIP3DS_branch = the_tree.GetBranch("tIP3DS")
        #if not self.tIP3DS_branch and "tIP3DS" not in self.complained:
        if not self.tIP3DS_branch and "tIP3DS":
            warnings.warn( "MuMuMuTauTree: Expected branch tIP3DS does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tIP3DS")
        else:
            self.tIP3DS_branch.SetAddress(<void*>&self.tIP3DS_value)

        #print "making tJetArea"
        self.tJetArea_branch = the_tree.GetBranch("tJetArea")
        #if not self.tJetArea_branch and "tJetArea" not in self.complained:
        if not self.tJetArea_branch and "tJetArea":
            warnings.warn( "MuMuMuTauTree: Expected branch tJetArea does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tJetArea")
        else:
            self.tJetArea_branch.SetAddress(<void*>&self.tJetArea_value)

        #print "making tJetBtag"
        self.tJetBtag_branch = the_tree.GetBranch("tJetBtag")
        #if not self.tJetBtag_branch and "tJetBtag" not in self.complained:
        if not self.tJetBtag_branch and "tJetBtag":
            warnings.warn( "MuMuMuTauTree: Expected branch tJetBtag does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tJetBtag")
        else:
            self.tJetBtag_branch.SetAddress(<void*>&self.tJetBtag_value)

        #print "making tJetCSVBtag"
        self.tJetCSVBtag_branch = the_tree.GetBranch("tJetCSVBtag")
        #if not self.tJetCSVBtag_branch and "tJetCSVBtag" not in self.complained:
        if not self.tJetCSVBtag_branch and "tJetCSVBtag":
            warnings.warn( "MuMuMuTauTree: Expected branch tJetCSVBtag does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tJetCSVBtag")
        else:
            self.tJetCSVBtag_branch.SetAddress(<void*>&self.tJetCSVBtag_value)

        #print "making tJetEtaEtaMoment"
        self.tJetEtaEtaMoment_branch = the_tree.GetBranch("tJetEtaEtaMoment")
        #if not self.tJetEtaEtaMoment_branch and "tJetEtaEtaMoment" not in self.complained:
        if not self.tJetEtaEtaMoment_branch and "tJetEtaEtaMoment":
            warnings.warn( "MuMuMuTauTree: Expected branch tJetEtaEtaMoment does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tJetEtaEtaMoment")
        else:
            self.tJetEtaEtaMoment_branch.SetAddress(<void*>&self.tJetEtaEtaMoment_value)

        #print "making tJetEtaPhiMoment"
        self.tJetEtaPhiMoment_branch = the_tree.GetBranch("tJetEtaPhiMoment")
        #if not self.tJetEtaPhiMoment_branch and "tJetEtaPhiMoment" not in self.complained:
        if not self.tJetEtaPhiMoment_branch and "tJetEtaPhiMoment":
            warnings.warn( "MuMuMuTauTree: Expected branch tJetEtaPhiMoment does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tJetEtaPhiMoment")
        else:
            self.tJetEtaPhiMoment_branch.SetAddress(<void*>&self.tJetEtaPhiMoment_value)

        #print "making tJetEtaPhiSpread"
        self.tJetEtaPhiSpread_branch = the_tree.GetBranch("tJetEtaPhiSpread")
        #if not self.tJetEtaPhiSpread_branch and "tJetEtaPhiSpread" not in self.complained:
        if not self.tJetEtaPhiSpread_branch and "tJetEtaPhiSpread":
            warnings.warn( "MuMuMuTauTree: Expected branch tJetEtaPhiSpread does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tJetEtaPhiSpread")
        else:
            self.tJetEtaPhiSpread_branch.SetAddress(<void*>&self.tJetEtaPhiSpread_value)

        #print "making tJetPartonFlavour"
        self.tJetPartonFlavour_branch = the_tree.GetBranch("tJetPartonFlavour")
        #if not self.tJetPartonFlavour_branch and "tJetPartonFlavour" not in self.complained:
        if not self.tJetPartonFlavour_branch and "tJetPartonFlavour":
            warnings.warn( "MuMuMuTauTree: Expected branch tJetPartonFlavour does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tJetPartonFlavour")
        else:
            self.tJetPartonFlavour_branch.SetAddress(<void*>&self.tJetPartonFlavour_value)

        #print "making tJetPhiPhiMoment"
        self.tJetPhiPhiMoment_branch = the_tree.GetBranch("tJetPhiPhiMoment")
        #if not self.tJetPhiPhiMoment_branch and "tJetPhiPhiMoment" not in self.complained:
        if not self.tJetPhiPhiMoment_branch and "tJetPhiPhiMoment":
            warnings.warn( "MuMuMuTauTree: Expected branch tJetPhiPhiMoment does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tJetPhiPhiMoment")
        else:
            self.tJetPhiPhiMoment_branch.SetAddress(<void*>&self.tJetPhiPhiMoment_value)

        #print "making tJetPt"
        self.tJetPt_branch = the_tree.GetBranch("tJetPt")
        #if not self.tJetPt_branch and "tJetPt" not in self.complained:
        if not self.tJetPt_branch and "tJetPt":
            warnings.warn( "MuMuMuTauTree: Expected branch tJetPt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tJetPt")
        else:
            self.tJetPt_branch.SetAddress(<void*>&self.tJetPt_value)

        #print "making tJetQGLikelihoodID"
        self.tJetQGLikelihoodID_branch = the_tree.GetBranch("tJetQGLikelihoodID")
        #if not self.tJetQGLikelihoodID_branch and "tJetQGLikelihoodID" not in self.complained:
        if not self.tJetQGLikelihoodID_branch and "tJetQGLikelihoodID":
            warnings.warn( "MuMuMuTauTree: Expected branch tJetQGLikelihoodID does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tJetQGLikelihoodID")
        else:
            self.tJetQGLikelihoodID_branch.SetAddress(<void*>&self.tJetQGLikelihoodID_value)

        #print "making tJetQGMVAID"
        self.tJetQGMVAID_branch = the_tree.GetBranch("tJetQGMVAID")
        #if not self.tJetQGMVAID_branch and "tJetQGMVAID" not in self.complained:
        if not self.tJetQGMVAID_branch and "tJetQGMVAID":
            warnings.warn( "MuMuMuTauTree: Expected branch tJetQGMVAID does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tJetQGMVAID")
        else:
            self.tJetQGMVAID_branch.SetAddress(<void*>&self.tJetQGMVAID_value)

        #print "making tJetaxis1"
        self.tJetaxis1_branch = the_tree.GetBranch("tJetaxis1")
        #if not self.tJetaxis1_branch and "tJetaxis1" not in self.complained:
        if not self.tJetaxis1_branch and "tJetaxis1":
            warnings.warn( "MuMuMuTauTree: Expected branch tJetaxis1 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tJetaxis1")
        else:
            self.tJetaxis1_branch.SetAddress(<void*>&self.tJetaxis1_value)

        #print "making tJetaxis2"
        self.tJetaxis2_branch = the_tree.GetBranch("tJetaxis2")
        #if not self.tJetaxis2_branch and "tJetaxis2" not in self.complained:
        if not self.tJetaxis2_branch and "tJetaxis2":
            warnings.warn( "MuMuMuTauTree: Expected branch tJetaxis2 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tJetaxis2")
        else:
            self.tJetaxis2_branch.SetAddress(<void*>&self.tJetaxis2_value)

        #print "making tJetmult"
        self.tJetmult_branch = the_tree.GetBranch("tJetmult")
        #if not self.tJetmult_branch and "tJetmult" not in self.complained:
        if not self.tJetmult_branch and "tJetmult":
            warnings.warn( "MuMuMuTauTree: Expected branch tJetmult does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tJetmult")
        else:
            self.tJetmult_branch.SetAddress(<void*>&self.tJetmult_value)

        #print "making tJetmultMLP"
        self.tJetmultMLP_branch = the_tree.GetBranch("tJetmultMLP")
        #if not self.tJetmultMLP_branch and "tJetmultMLP" not in self.complained:
        if not self.tJetmultMLP_branch and "tJetmultMLP":
            warnings.warn( "MuMuMuTauTree: Expected branch tJetmultMLP does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tJetmultMLP")
        else:
            self.tJetmultMLP_branch.SetAddress(<void*>&self.tJetmultMLP_value)

        #print "making tJetmultMLPQC"
        self.tJetmultMLPQC_branch = the_tree.GetBranch("tJetmultMLPQC")
        #if not self.tJetmultMLPQC_branch and "tJetmultMLPQC" not in self.complained:
        if not self.tJetmultMLPQC_branch and "tJetmultMLPQC":
            warnings.warn( "MuMuMuTauTree: Expected branch tJetmultMLPQC does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tJetmultMLPQC")
        else:
            self.tJetmultMLPQC_branch.SetAddress(<void*>&self.tJetmultMLPQC_value)

        #print "making tJetptD"
        self.tJetptD_branch = the_tree.GetBranch("tJetptD")
        #if not self.tJetptD_branch and "tJetptD" not in self.complained:
        if not self.tJetptD_branch and "tJetptD":
            warnings.warn( "MuMuMuTauTree: Expected branch tJetptD does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tJetptD")
        else:
            self.tJetptD_branch.SetAddress(<void*>&self.tJetptD_value)

        #print "making tLeadTrackPt"
        self.tLeadTrackPt_branch = the_tree.GetBranch("tLeadTrackPt")
        #if not self.tLeadTrackPt_branch and "tLeadTrackPt" not in self.complained:
        if not self.tLeadTrackPt_branch and "tLeadTrackPt":
            warnings.warn( "MuMuMuTauTree: Expected branch tLeadTrackPt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tLeadTrackPt")
        else:
            self.tLeadTrackPt_branch.SetAddress(<void*>&self.tLeadTrackPt_value)

        #print "making tLooseIso"
        self.tLooseIso_branch = the_tree.GetBranch("tLooseIso")
        #if not self.tLooseIso_branch and "tLooseIso" not in self.complained:
        if not self.tLooseIso_branch and "tLooseIso":
            warnings.warn( "MuMuMuTauTree: Expected branch tLooseIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tLooseIso")
        else:
            self.tLooseIso_branch.SetAddress(<void*>&self.tLooseIso_value)

        #print "making tLooseIso3Hits"
        self.tLooseIso3Hits_branch = the_tree.GetBranch("tLooseIso3Hits")
        #if not self.tLooseIso3Hits_branch and "tLooseIso3Hits" not in self.complained:
        if not self.tLooseIso3Hits_branch and "tLooseIso3Hits":
            warnings.warn( "MuMuMuTauTree: Expected branch tLooseIso3Hits does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tLooseIso3Hits")
        else:
            self.tLooseIso3Hits_branch.SetAddress(<void*>&self.tLooseIso3Hits_value)

        #print "making tLooseMVA2Iso"
        self.tLooseMVA2Iso_branch = the_tree.GetBranch("tLooseMVA2Iso")
        #if not self.tLooseMVA2Iso_branch and "tLooseMVA2Iso" not in self.complained:
        if not self.tLooseMVA2Iso_branch and "tLooseMVA2Iso":
            warnings.warn( "MuMuMuTauTree: Expected branch tLooseMVA2Iso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tLooseMVA2Iso")
        else:
            self.tLooseMVA2Iso_branch.SetAddress(<void*>&self.tLooseMVA2Iso_value)

        #print "making tLooseMVAIso"
        self.tLooseMVAIso_branch = the_tree.GetBranch("tLooseMVAIso")
        #if not self.tLooseMVAIso_branch and "tLooseMVAIso" not in self.complained:
        if not self.tLooseMVAIso_branch and "tLooseMVAIso":
            warnings.warn( "MuMuMuTauTree: Expected branch tLooseMVAIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tLooseMVAIso")
        else:
            self.tLooseMVAIso_branch.SetAddress(<void*>&self.tLooseMVAIso_value)

        #print "making tMVA2IsoRaw"
        self.tMVA2IsoRaw_branch = the_tree.GetBranch("tMVA2IsoRaw")
        #if not self.tMVA2IsoRaw_branch and "tMVA2IsoRaw" not in self.complained:
        if not self.tMVA2IsoRaw_branch and "tMVA2IsoRaw":
            warnings.warn( "MuMuMuTauTree: Expected branch tMVA2IsoRaw does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tMVA2IsoRaw")
        else:
            self.tMVA2IsoRaw_branch.SetAddress(<void*>&self.tMVA2IsoRaw_value)

        #print "making tMass"
        self.tMass_branch = the_tree.GetBranch("tMass")
        #if not self.tMass_branch and "tMass" not in self.complained:
        if not self.tMass_branch and "tMass":
            warnings.warn( "MuMuMuTauTree: Expected branch tMass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tMass")
        else:
            self.tMass_branch.SetAddress(<void*>&self.tMass_value)

        #print "making tMediumIso"
        self.tMediumIso_branch = the_tree.GetBranch("tMediumIso")
        #if not self.tMediumIso_branch and "tMediumIso" not in self.complained:
        if not self.tMediumIso_branch and "tMediumIso":
            warnings.warn( "MuMuMuTauTree: Expected branch tMediumIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tMediumIso")
        else:
            self.tMediumIso_branch.SetAddress(<void*>&self.tMediumIso_value)

        #print "making tMediumIso3Hits"
        self.tMediumIso3Hits_branch = the_tree.GetBranch("tMediumIso3Hits")
        #if not self.tMediumIso3Hits_branch and "tMediumIso3Hits" not in self.complained:
        if not self.tMediumIso3Hits_branch and "tMediumIso3Hits":
            warnings.warn( "MuMuMuTauTree: Expected branch tMediumIso3Hits does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tMediumIso3Hits")
        else:
            self.tMediumIso3Hits_branch.SetAddress(<void*>&self.tMediumIso3Hits_value)

        #print "making tMediumMVA2Iso"
        self.tMediumMVA2Iso_branch = the_tree.GetBranch("tMediumMVA2Iso")
        #if not self.tMediumMVA2Iso_branch and "tMediumMVA2Iso" not in self.complained:
        if not self.tMediumMVA2Iso_branch and "tMediumMVA2Iso":
            warnings.warn( "MuMuMuTauTree: Expected branch tMediumMVA2Iso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tMediumMVA2Iso")
        else:
            self.tMediumMVA2Iso_branch.SetAddress(<void*>&self.tMediumMVA2Iso_value)

        #print "making tMediumMVAIso"
        self.tMediumMVAIso_branch = the_tree.GetBranch("tMediumMVAIso")
        #if not self.tMediumMVAIso_branch and "tMediumMVAIso" not in self.complained:
        if not self.tMediumMVAIso_branch and "tMediumMVAIso":
            warnings.warn( "MuMuMuTauTree: Expected branch tMediumMVAIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tMediumMVAIso")
        else:
            self.tMediumMVAIso_branch.SetAddress(<void*>&self.tMediumMVAIso_value)

        #print "making tMtToMET"
        self.tMtToMET_branch = the_tree.GetBranch("tMtToMET")
        #if not self.tMtToMET_branch and "tMtToMET" not in self.complained:
        if not self.tMtToMET_branch and "tMtToMET":
            warnings.warn( "MuMuMuTauTree: Expected branch tMtToMET does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tMtToMET")
        else:
            self.tMtToMET_branch.SetAddress(<void*>&self.tMtToMET_value)

        #print "making tMtToMVAMET"
        self.tMtToMVAMET_branch = the_tree.GetBranch("tMtToMVAMET")
        #if not self.tMtToMVAMET_branch and "tMtToMVAMET" not in self.complained:
        if not self.tMtToMVAMET_branch and "tMtToMVAMET":
            warnings.warn( "MuMuMuTauTree: Expected branch tMtToMVAMET does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tMtToMVAMET")
        else:
            self.tMtToMVAMET_branch.SetAddress(<void*>&self.tMtToMVAMET_value)

        #print "making tMtToPFMET"
        self.tMtToPFMET_branch = the_tree.GetBranch("tMtToPFMET")
        #if not self.tMtToPFMET_branch and "tMtToPFMET" not in self.complained:
        if not self.tMtToPFMET_branch and "tMtToPFMET":
            warnings.warn( "MuMuMuTauTree: Expected branch tMtToPFMET does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tMtToPFMET")
        else:
            self.tMtToPFMET_branch.SetAddress(<void*>&self.tMtToPFMET_value)

        #print "making tMtToPfMet_Ty1"
        self.tMtToPfMet_Ty1_branch = the_tree.GetBranch("tMtToPfMet_Ty1")
        #if not self.tMtToPfMet_Ty1_branch and "tMtToPfMet_Ty1" not in self.complained:
        if not self.tMtToPfMet_Ty1_branch and "tMtToPfMet_Ty1":
            warnings.warn( "MuMuMuTauTree: Expected branch tMtToPfMet_Ty1 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tMtToPfMet_Ty1")
        else:
            self.tMtToPfMet_Ty1_branch.SetAddress(<void*>&self.tMtToPfMet_Ty1_value)

        #print "making tMtToPfMet_jes"
        self.tMtToPfMet_jes_branch = the_tree.GetBranch("tMtToPfMet_jes")
        #if not self.tMtToPfMet_jes_branch and "tMtToPfMet_jes" not in self.complained:
        if not self.tMtToPfMet_jes_branch and "tMtToPfMet_jes":
            warnings.warn( "MuMuMuTauTree: Expected branch tMtToPfMet_jes does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tMtToPfMet_jes")
        else:
            self.tMtToPfMet_jes_branch.SetAddress(<void*>&self.tMtToPfMet_jes_value)

        #print "making tMtToPfMet_mes"
        self.tMtToPfMet_mes_branch = the_tree.GetBranch("tMtToPfMet_mes")
        #if not self.tMtToPfMet_mes_branch and "tMtToPfMet_mes" not in self.complained:
        if not self.tMtToPfMet_mes_branch and "tMtToPfMet_mes":
            warnings.warn( "MuMuMuTauTree: Expected branch tMtToPfMet_mes does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tMtToPfMet_mes")
        else:
            self.tMtToPfMet_mes_branch.SetAddress(<void*>&self.tMtToPfMet_mes_value)

        #print "making tMtToPfMet_tes"
        self.tMtToPfMet_tes_branch = the_tree.GetBranch("tMtToPfMet_tes")
        #if not self.tMtToPfMet_tes_branch and "tMtToPfMet_tes" not in self.complained:
        if not self.tMtToPfMet_tes_branch and "tMtToPfMet_tes":
            warnings.warn( "MuMuMuTauTree: Expected branch tMtToPfMet_tes does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tMtToPfMet_tes")
        else:
            self.tMtToPfMet_tes_branch.SetAddress(<void*>&self.tMtToPfMet_tes_value)

        #print "making tMtToPfMet_ues"
        self.tMtToPfMet_ues_branch = the_tree.GetBranch("tMtToPfMet_ues")
        #if not self.tMtToPfMet_ues_branch and "tMtToPfMet_ues" not in self.complained:
        if not self.tMtToPfMet_ues_branch and "tMtToPfMet_ues":
            warnings.warn( "MuMuMuTauTree: Expected branch tMtToPfMet_ues does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tMtToPfMet_ues")
        else:
            self.tMtToPfMet_ues_branch.SetAddress(<void*>&self.tMtToPfMet_ues_value)

        #print "making tMuOverlap"
        self.tMuOverlap_branch = the_tree.GetBranch("tMuOverlap")
        #if not self.tMuOverlap_branch and "tMuOverlap" not in self.complained:
        if not self.tMuOverlap_branch and "tMuOverlap":
            warnings.warn( "MuMuMuTauTree: Expected branch tMuOverlap does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tMuOverlap")
        else:
            self.tMuOverlap_branch.SetAddress(<void*>&self.tMuOverlap_value)

        #print "making tMuOverlapZHLoose"
        self.tMuOverlapZHLoose_branch = the_tree.GetBranch("tMuOverlapZHLoose")
        #if not self.tMuOverlapZHLoose_branch and "tMuOverlapZHLoose" not in self.complained:
        if not self.tMuOverlapZHLoose_branch and "tMuOverlapZHLoose":
            warnings.warn( "MuMuMuTauTree: Expected branch tMuOverlapZHLoose does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tMuOverlapZHLoose")
        else:
            self.tMuOverlapZHLoose_branch.SetAddress(<void*>&self.tMuOverlapZHLoose_value)

        #print "making tMuOverlapZHTight"
        self.tMuOverlapZHTight_branch = the_tree.GetBranch("tMuOverlapZHTight")
        #if not self.tMuOverlapZHTight_branch and "tMuOverlapZHTight" not in self.complained:
        if not self.tMuOverlapZHTight_branch and "tMuOverlapZHTight":
            warnings.warn( "MuMuMuTauTree: Expected branch tMuOverlapZHTight does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tMuOverlapZHTight")
        else:
            self.tMuOverlapZHTight_branch.SetAddress(<void*>&self.tMuOverlapZHTight_value)

        #print "making tPhi"
        self.tPhi_branch = the_tree.GetBranch("tPhi")
        #if not self.tPhi_branch and "tPhi" not in self.complained:
        if not self.tPhi_branch and "tPhi":
            warnings.warn( "MuMuMuTauTree: Expected branch tPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tPhi")
        else:
            self.tPhi_branch.SetAddress(<void*>&self.tPhi_value)

        #print "making tPt"
        self.tPt_branch = the_tree.GetBranch("tPt")
        #if not self.tPt_branch and "tPt" not in self.complained:
        if not self.tPt_branch and "tPt":
            warnings.warn( "MuMuMuTauTree: Expected branch tPt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tPt")
        else:
            self.tPt_branch.SetAddress(<void*>&self.tPt_value)

        #print "making tRank"
        self.tRank_branch = the_tree.GetBranch("tRank")
        #if not self.tRank_branch and "tRank" not in self.complained:
        if not self.tRank_branch and "tRank":
            warnings.warn( "MuMuMuTauTree: Expected branch tRank does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tRank")
        else:
            self.tRank_branch.SetAddress(<void*>&self.tRank_value)

        #print "making tTNPId"
        self.tTNPId_branch = the_tree.GetBranch("tTNPId")
        #if not self.tTNPId_branch and "tTNPId" not in self.complained:
        if not self.tTNPId_branch and "tTNPId":
            warnings.warn( "MuMuMuTauTree: Expected branch tTNPId does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tTNPId")
        else:
            self.tTNPId_branch.SetAddress(<void*>&self.tTNPId_value)

        #print "making tTightIso"
        self.tTightIso_branch = the_tree.GetBranch("tTightIso")
        #if not self.tTightIso_branch and "tTightIso" not in self.complained:
        if not self.tTightIso_branch and "tTightIso":
            warnings.warn( "MuMuMuTauTree: Expected branch tTightIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tTightIso")
        else:
            self.tTightIso_branch.SetAddress(<void*>&self.tTightIso_value)

        #print "making tTightIso3Hits"
        self.tTightIso3Hits_branch = the_tree.GetBranch("tTightIso3Hits")
        #if not self.tTightIso3Hits_branch and "tTightIso3Hits" not in self.complained:
        if not self.tTightIso3Hits_branch and "tTightIso3Hits":
            warnings.warn( "MuMuMuTauTree: Expected branch tTightIso3Hits does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tTightIso3Hits")
        else:
            self.tTightIso3Hits_branch.SetAddress(<void*>&self.tTightIso3Hits_value)

        #print "making tTightMVA2Iso"
        self.tTightMVA2Iso_branch = the_tree.GetBranch("tTightMVA2Iso")
        #if not self.tTightMVA2Iso_branch and "tTightMVA2Iso" not in self.complained:
        if not self.tTightMVA2Iso_branch and "tTightMVA2Iso":
            warnings.warn( "MuMuMuTauTree: Expected branch tTightMVA2Iso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tTightMVA2Iso")
        else:
            self.tTightMVA2Iso_branch.SetAddress(<void*>&self.tTightMVA2Iso_value)

        #print "making tTightMVAIso"
        self.tTightMVAIso_branch = the_tree.GetBranch("tTightMVAIso")
        #if not self.tTightMVAIso_branch and "tTightMVAIso" not in self.complained:
        if not self.tTightMVAIso_branch and "tTightMVAIso":
            warnings.warn( "MuMuMuTauTree: Expected branch tTightMVAIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tTightMVAIso")
        else:
            self.tTightMVAIso_branch.SetAddress(<void*>&self.tTightMVAIso_value)

        #print "making tToMETDPhi"
        self.tToMETDPhi_branch = the_tree.GetBranch("tToMETDPhi")
        #if not self.tToMETDPhi_branch and "tToMETDPhi" not in self.complained:
        if not self.tToMETDPhi_branch and "tToMETDPhi":
            warnings.warn( "MuMuMuTauTree: Expected branch tToMETDPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tToMETDPhi")
        else:
            self.tToMETDPhi_branch.SetAddress(<void*>&self.tToMETDPhi_value)

        #print "making tVLooseIso"
        self.tVLooseIso_branch = the_tree.GetBranch("tVLooseIso")
        #if not self.tVLooseIso_branch and "tVLooseIso" not in self.complained:
        if not self.tVLooseIso_branch and "tVLooseIso":
            warnings.warn( "MuMuMuTauTree: Expected branch tVLooseIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tVLooseIso")
        else:
            self.tVLooseIso_branch.SetAddress(<void*>&self.tVLooseIso_value)

        #print "making tVZ"
        self.tVZ_branch = the_tree.GetBranch("tVZ")
        #if not self.tVZ_branch and "tVZ" not in self.complained:
        if not self.tVZ_branch and "tVZ":
            warnings.warn( "MuMuMuTauTree: Expected branch tVZ does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tVZ")
        else:
            self.tVZ_branch.SetAddress(<void*>&self.tVZ_value)

        #print "making tauHpsVetoPt20"
        self.tauHpsVetoPt20_branch = the_tree.GetBranch("tauHpsVetoPt20")
        #if not self.tauHpsVetoPt20_branch and "tauHpsVetoPt20" not in self.complained:
        if not self.tauHpsVetoPt20_branch and "tauHpsVetoPt20":
            warnings.warn( "MuMuMuTauTree: Expected branch tauHpsVetoPt20 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tauHpsVetoPt20")
        else:
            self.tauHpsVetoPt20_branch.SetAddress(<void*>&self.tauHpsVetoPt20_value)

        #print "making tauTightCountZH"
        self.tauTightCountZH_branch = the_tree.GetBranch("tauTightCountZH")
        #if not self.tauTightCountZH_branch and "tauTightCountZH" not in self.complained:
        if not self.tauTightCountZH_branch and "tauTightCountZH":
            warnings.warn( "MuMuMuTauTree: Expected branch tauTightCountZH does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tauTightCountZH")
        else:
            self.tauTightCountZH_branch.SetAddress(<void*>&self.tauTightCountZH_value)

        #print "making tauVetoPt20"
        self.tauVetoPt20_branch = the_tree.GetBranch("tauVetoPt20")
        #if not self.tauVetoPt20_branch and "tauVetoPt20" not in self.complained:
        if not self.tauVetoPt20_branch and "tauVetoPt20":
            warnings.warn( "MuMuMuTauTree: Expected branch tauVetoPt20 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tauVetoPt20")
        else:
            self.tauVetoPt20_branch.SetAddress(<void*>&self.tauVetoPt20_value)

        #print "making tauVetoPt20Loose3HitsVtx"
        self.tauVetoPt20Loose3HitsVtx_branch = the_tree.GetBranch("tauVetoPt20Loose3HitsVtx")
        #if not self.tauVetoPt20Loose3HitsVtx_branch and "tauVetoPt20Loose3HitsVtx" not in self.complained:
        if not self.tauVetoPt20Loose3HitsVtx_branch and "tauVetoPt20Loose3HitsVtx":
            warnings.warn( "MuMuMuTauTree: Expected branch tauVetoPt20Loose3HitsVtx does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tauVetoPt20Loose3HitsVtx")
        else:
            self.tauVetoPt20Loose3HitsVtx_branch.SetAddress(<void*>&self.tauVetoPt20Loose3HitsVtx_value)

        #print "making tauVetoPt20LooseMVA2Vtx"
        self.tauVetoPt20LooseMVA2Vtx_branch = the_tree.GetBranch("tauVetoPt20LooseMVA2Vtx")
        #if not self.tauVetoPt20LooseMVA2Vtx_branch and "tauVetoPt20LooseMVA2Vtx" not in self.complained:
        if not self.tauVetoPt20LooseMVA2Vtx_branch and "tauVetoPt20LooseMVA2Vtx":
            warnings.warn( "MuMuMuTauTree: Expected branch tauVetoPt20LooseMVA2Vtx does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tauVetoPt20LooseMVA2Vtx")
        else:
            self.tauVetoPt20LooseMVA2Vtx_branch.SetAddress(<void*>&self.tauVetoPt20LooseMVA2Vtx_value)

        #print "making tauVetoPt20LooseMVAVtx"
        self.tauVetoPt20LooseMVAVtx_branch = the_tree.GetBranch("tauVetoPt20LooseMVAVtx")
        #if not self.tauVetoPt20LooseMVAVtx_branch and "tauVetoPt20LooseMVAVtx" not in self.complained:
        if not self.tauVetoPt20LooseMVAVtx_branch and "tauVetoPt20LooseMVAVtx":
            warnings.warn( "MuMuMuTauTree: Expected branch tauVetoPt20LooseMVAVtx does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tauVetoPt20LooseMVAVtx")
        else:
            self.tauVetoPt20LooseMVAVtx_branch.SetAddress(<void*>&self.tauVetoPt20LooseMVAVtx_value)

        #print "making tauVetoPt20VLooseHPSVtx"
        self.tauVetoPt20VLooseHPSVtx_branch = the_tree.GetBranch("tauVetoPt20VLooseHPSVtx")
        #if not self.tauVetoPt20VLooseHPSVtx_branch and "tauVetoPt20VLooseHPSVtx" not in self.complained:
        if not self.tauVetoPt20VLooseHPSVtx_branch and "tauVetoPt20VLooseHPSVtx":
            warnings.warn( "MuMuMuTauTree: Expected branch tauVetoPt20VLooseHPSVtx does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tauVetoPt20VLooseHPSVtx")
        else:
            self.tauVetoPt20VLooseHPSVtx_branch.SetAddress(<void*>&self.tauVetoPt20VLooseHPSVtx_value)

        #print "making tauVetoZH"
        self.tauVetoZH_branch = the_tree.GetBranch("tauVetoZH")
        #if not self.tauVetoZH_branch and "tauVetoZH" not in self.complained:
        if not self.tauVetoZH_branch and "tauVetoZH":
            warnings.warn( "MuMuMuTauTree: Expected branch tauVetoZH does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tauVetoZH")
        else:
            self.tauVetoZH_branch.SetAddress(<void*>&self.tauVetoZH_value)

        #print "making type1_pfMetEt"
        self.type1_pfMetEt_branch = the_tree.GetBranch("type1_pfMetEt")
        #if not self.type1_pfMetEt_branch and "type1_pfMetEt" not in self.complained:
        if not self.type1_pfMetEt_branch and "type1_pfMetEt":
            warnings.warn( "MuMuMuTauTree: Expected branch type1_pfMetEt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMetEt")
        else:
            self.type1_pfMetEt_branch.SetAddress(<void*>&self.type1_pfMetEt_value)

        #print "making type1_pfMetPhi"
        self.type1_pfMetPhi_branch = the_tree.GetBranch("type1_pfMetPhi")
        #if not self.type1_pfMetPhi_branch and "type1_pfMetPhi" not in self.complained:
        if not self.type1_pfMetPhi_branch and "type1_pfMetPhi":
            warnings.warn( "MuMuMuTauTree: Expected branch type1_pfMetPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMetPhi")
        else:
            self.type1_pfMetPhi_branch.SetAddress(<void*>&self.type1_pfMetPhi_value)

        #print "making idx"
        self.idx_branch = the_tree.GetBranch("idx")
        #if not self.idx_branch and "idx" not in self.complained:
        if not self.idx_branch and "idx":
            warnings.warn( "MuMuMuTauTree: Expected branch idx does not exist!"                " It will crash if you try and use it!",Warning)
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

    property m1_m3_CosThetaStar:
        def __get__(self):
            self.m1_m3_CosThetaStar_branch.GetEntry(self.localentry, 0)
            return self.m1_m3_CosThetaStar_value

    property m1_m3_DPhi:
        def __get__(self):
            self.m1_m3_DPhi_branch.GetEntry(self.localentry, 0)
            return self.m1_m3_DPhi_value

    property m1_m3_DR:
        def __get__(self):
            self.m1_m3_DR_branch.GetEntry(self.localentry, 0)
            return self.m1_m3_DR_value

    property m1_m3_Eta:
        def __get__(self):
            self.m1_m3_Eta_branch.GetEntry(self.localentry, 0)
            return self.m1_m3_Eta_value

    property m1_m3_Mass:
        def __get__(self):
            self.m1_m3_Mass_branch.GetEntry(self.localentry, 0)
            return self.m1_m3_Mass_value

    property m1_m3_MassFsr:
        def __get__(self):
            self.m1_m3_MassFsr_branch.GetEntry(self.localentry, 0)
            return self.m1_m3_MassFsr_value

    property m1_m3_PZeta:
        def __get__(self):
            self.m1_m3_PZeta_branch.GetEntry(self.localentry, 0)
            return self.m1_m3_PZeta_value

    property m1_m3_PZetaVis:
        def __get__(self):
            self.m1_m3_PZetaVis_branch.GetEntry(self.localentry, 0)
            return self.m1_m3_PZetaVis_value

    property m1_m3_Phi:
        def __get__(self):
            self.m1_m3_Phi_branch.GetEntry(self.localentry, 0)
            return self.m1_m3_Phi_value

    property m1_m3_Pt:
        def __get__(self):
            self.m1_m3_Pt_branch.GetEntry(self.localentry, 0)
            return self.m1_m3_Pt_value

    property m1_m3_PtFsr:
        def __get__(self):
            self.m1_m3_PtFsr_branch.GetEntry(self.localentry, 0)
            return self.m1_m3_PtFsr_value

    property m1_m3_SS:
        def __get__(self):
            self.m1_m3_SS_branch.GetEntry(self.localentry, 0)
            return self.m1_m3_SS_value

    property m1_m3_ToMETDPhi_Ty1:
        def __get__(self):
            self.m1_m3_ToMETDPhi_Ty1_branch.GetEntry(self.localentry, 0)
            return self.m1_m3_ToMETDPhi_Ty1_value

    property m1_m3_Zcompat:
        def __get__(self):
            self.m1_m3_Zcompat_branch.GetEntry(self.localentry, 0)
            return self.m1_m3_Zcompat_value

    property m1_t_CosThetaStar:
        def __get__(self):
            self.m1_t_CosThetaStar_branch.GetEntry(self.localentry, 0)
            return self.m1_t_CosThetaStar_value

    property m1_t_DPhi:
        def __get__(self):
            self.m1_t_DPhi_branch.GetEntry(self.localentry, 0)
            return self.m1_t_DPhi_value

    property m1_t_DR:
        def __get__(self):
            self.m1_t_DR_branch.GetEntry(self.localentry, 0)
            return self.m1_t_DR_value

    property m1_t_Eta:
        def __get__(self):
            self.m1_t_Eta_branch.GetEntry(self.localentry, 0)
            return self.m1_t_Eta_value

    property m1_t_Mass:
        def __get__(self):
            self.m1_t_Mass_branch.GetEntry(self.localentry, 0)
            return self.m1_t_Mass_value

    property m1_t_MassFsr:
        def __get__(self):
            self.m1_t_MassFsr_branch.GetEntry(self.localentry, 0)
            return self.m1_t_MassFsr_value

    property m1_t_PZeta:
        def __get__(self):
            self.m1_t_PZeta_branch.GetEntry(self.localentry, 0)
            return self.m1_t_PZeta_value

    property m1_t_PZetaVis:
        def __get__(self):
            self.m1_t_PZetaVis_branch.GetEntry(self.localentry, 0)
            return self.m1_t_PZetaVis_value

    property m1_t_Phi:
        def __get__(self):
            self.m1_t_Phi_branch.GetEntry(self.localentry, 0)
            return self.m1_t_Phi_value

    property m1_t_Pt:
        def __get__(self):
            self.m1_t_Pt_branch.GetEntry(self.localentry, 0)
            return self.m1_t_Pt_value

    property m1_t_PtFsr:
        def __get__(self):
            self.m1_t_PtFsr_branch.GetEntry(self.localentry, 0)
            return self.m1_t_PtFsr_value

    property m1_t_SS:
        def __get__(self):
            self.m1_t_SS_branch.GetEntry(self.localentry, 0)
            return self.m1_t_SS_value

    property m1_t_ToMETDPhi_Ty1:
        def __get__(self):
            self.m1_t_ToMETDPhi_Ty1_branch.GetEntry(self.localentry, 0)
            return self.m1_t_ToMETDPhi_Ty1_value

    property m1_t_Zcompat:
        def __get__(self):
            self.m1_t_Zcompat_branch.GetEntry(self.localentry, 0)
            return self.m1_t_Zcompat_value

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

    property m2_m3_CosThetaStar:
        def __get__(self):
            self.m2_m3_CosThetaStar_branch.GetEntry(self.localentry, 0)
            return self.m2_m3_CosThetaStar_value

    property m2_m3_DPhi:
        def __get__(self):
            self.m2_m3_DPhi_branch.GetEntry(self.localentry, 0)
            return self.m2_m3_DPhi_value

    property m2_m3_DR:
        def __get__(self):
            self.m2_m3_DR_branch.GetEntry(self.localentry, 0)
            return self.m2_m3_DR_value

    property m2_m3_Eta:
        def __get__(self):
            self.m2_m3_Eta_branch.GetEntry(self.localentry, 0)
            return self.m2_m3_Eta_value

    property m2_m3_Mass:
        def __get__(self):
            self.m2_m3_Mass_branch.GetEntry(self.localentry, 0)
            return self.m2_m3_Mass_value

    property m2_m3_MassFsr:
        def __get__(self):
            self.m2_m3_MassFsr_branch.GetEntry(self.localentry, 0)
            return self.m2_m3_MassFsr_value

    property m2_m3_PZeta:
        def __get__(self):
            self.m2_m3_PZeta_branch.GetEntry(self.localentry, 0)
            return self.m2_m3_PZeta_value

    property m2_m3_PZetaVis:
        def __get__(self):
            self.m2_m3_PZetaVis_branch.GetEntry(self.localentry, 0)
            return self.m2_m3_PZetaVis_value

    property m2_m3_Phi:
        def __get__(self):
            self.m2_m3_Phi_branch.GetEntry(self.localentry, 0)
            return self.m2_m3_Phi_value

    property m2_m3_Pt:
        def __get__(self):
            self.m2_m3_Pt_branch.GetEntry(self.localentry, 0)
            return self.m2_m3_Pt_value

    property m2_m3_PtFsr:
        def __get__(self):
            self.m2_m3_PtFsr_branch.GetEntry(self.localentry, 0)
            return self.m2_m3_PtFsr_value

    property m2_m3_SS:
        def __get__(self):
            self.m2_m3_SS_branch.GetEntry(self.localentry, 0)
            return self.m2_m3_SS_value

    property m2_m3_ToMETDPhi_Ty1:
        def __get__(self):
            self.m2_m3_ToMETDPhi_Ty1_branch.GetEntry(self.localentry, 0)
            return self.m2_m3_ToMETDPhi_Ty1_value

    property m2_m3_Zcompat:
        def __get__(self):
            self.m2_m3_Zcompat_branch.GetEntry(self.localentry, 0)
            return self.m2_m3_Zcompat_value

    property m2_t_CosThetaStar:
        def __get__(self):
            self.m2_t_CosThetaStar_branch.GetEntry(self.localentry, 0)
            return self.m2_t_CosThetaStar_value

    property m2_t_DPhi:
        def __get__(self):
            self.m2_t_DPhi_branch.GetEntry(self.localentry, 0)
            return self.m2_t_DPhi_value

    property m2_t_DR:
        def __get__(self):
            self.m2_t_DR_branch.GetEntry(self.localentry, 0)
            return self.m2_t_DR_value

    property m2_t_Eta:
        def __get__(self):
            self.m2_t_Eta_branch.GetEntry(self.localentry, 0)
            return self.m2_t_Eta_value

    property m2_t_Mass:
        def __get__(self):
            self.m2_t_Mass_branch.GetEntry(self.localentry, 0)
            return self.m2_t_Mass_value

    property m2_t_MassFsr:
        def __get__(self):
            self.m2_t_MassFsr_branch.GetEntry(self.localentry, 0)
            return self.m2_t_MassFsr_value

    property m2_t_PZeta:
        def __get__(self):
            self.m2_t_PZeta_branch.GetEntry(self.localentry, 0)
            return self.m2_t_PZeta_value

    property m2_t_PZetaVis:
        def __get__(self):
            self.m2_t_PZetaVis_branch.GetEntry(self.localentry, 0)
            return self.m2_t_PZetaVis_value

    property m2_t_Phi:
        def __get__(self):
            self.m2_t_Phi_branch.GetEntry(self.localentry, 0)
            return self.m2_t_Phi_value

    property m2_t_Pt:
        def __get__(self):
            self.m2_t_Pt_branch.GetEntry(self.localentry, 0)
            return self.m2_t_Pt_value

    property m2_t_PtFsr:
        def __get__(self):
            self.m2_t_PtFsr_branch.GetEntry(self.localentry, 0)
            return self.m2_t_PtFsr_value

    property m2_t_SS:
        def __get__(self):
            self.m2_t_SS_branch.GetEntry(self.localentry, 0)
            return self.m2_t_SS_value

    property m2_t_ToMETDPhi_Ty1:
        def __get__(self):
            self.m2_t_ToMETDPhi_Ty1_branch.GetEntry(self.localentry, 0)
            return self.m2_t_ToMETDPhi_Ty1_value

    property m2_t_Zcompat:
        def __get__(self):
            self.m2_t_Zcompat_branch.GetEntry(self.localentry, 0)
            return self.m2_t_Zcompat_value

    property m3AbsEta:
        def __get__(self):
            self.m3AbsEta_branch.GetEntry(self.localentry, 0)
            return self.m3AbsEta_value

    property m3Charge:
        def __get__(self):
            self.m3Charge_branch.GetEntry(self.localentry, 0)
            return self.m3Charge_value

    property m3ComesFromHiggs:
        def __get__(self):
            self.m3ComesFromHiggs_branch.GetEntry(self.localentry, 0)
            return self.m3ComesFromHiggs_value

    property m3D0:
        def __get__(self):
            self.m3D0_branch.GetEntry(self.localentry, 0)
            return self.m3D0_value

    property m3DZ:
        def __get__(self):
            self.m3DZ_branch.GetEntry(self.localentry, 0)
            return self.m3DZ_value

    property m3DiMuonL3PreFiltered7:
        def __get__(self):
            self.m3DiMuonL3PreFiltered7_branch.GetEntry(self.localentry, 0)
            return self.m3DiMuonL3PreFiltered7_value

    property m3DiMuonL3p5PreFiltered8:
        def __get__(self):
            self.m3DiMuonL3p5PreFiltered8_branch.GetEntry(self.localentry, 0)
            return self.m3DiMuonL3p5PreFiltered8_value

    property m3DiMuonMu17Mu8DzFiltered0p2:
        def __get__(self):
            self.m3DiMuonMu17Mu8DzFiltered0p2_branch.GetEntry(self.localentry, 0)
            return self.m3DiMuonMu17Mu8DzFiltered0p2_value

    property m3EErrRochCor2011A:
        def __get__(self):
            self.m3EErrRochCor2011A_branch.GetEntry(self.localentry, 0)
            return self.m3EErrRochCor2011A_value

    property m3EErrRochCor2011B:
        def __get__(self):
            self.m3EErrRochCor2011B_branch.GetEntry(self.localentry, 0)
            return self.m3EErrRochCor2011B_value

    property m3EErrRochCor2012:
        def __get__(self):
            self.m3EErrRochCor2012_branch.GetEntry(self.localentry, 0)
            return self.m3EErrRochCor2012_value

    property m3ERochCor2011A:
        def __get__(self):
            self.m3ERochCor2011A_branch.GetEntry(self.localentry, 0)
            return self.m3ERochCor2011A_value

    property m3ERochCor2011B:
        def __get__(self):
            self.m3ERochCor2011B_branch.GetEntry(self.localentry, 0)
            return self.m3ERochCor2011B_value

    property m3ERochCor2012:
        def __get__(self):
            self.m3ERochCor2012_branch.GetEntry(self.localentry, 0)
            return self.m3ERochCor2012_value

    property m3EffectiveArea2011:
        def __get__(self):
            self.m3EffectiveArea2011_branch.GetEntry(self.localentry, 0)
            return self.m3EffectiveArea2011_value

    property m3EffectiveArea2012:
        def __get__(self):
            self.m3EffectiveArea2012_branch.GetEntry(self.localentry, 0)
            return self.m3EffectiveArea2012_value

    property m3Eta:
        def __get__(self):
            self.m3Eta_branch.GetEntry(self.localentry, 0)
            return self.m3Eta_value

    property m3EtaRochCor2011A:
        def __get__(self):
            self.m3EtaRochCor2011A_branch.GetEntry(self.localentry, 0)
            return self.m3EtaRochCor2011A_value

    property m3EtaRochCor2011B:
        def __get__(self):
            self.m3EtaRochCor2011B_branch.GetEntry(self.localentry, 0)
            return self.m3EtaRochCor2011B_value

    property m3EtaRochCor2012:
        def __get__(self):
            self.m3EtaRochCor2012_branch.GetEntry(self.localentry, 0)
            return self.m3EtaRochCor2012_value

    property m3GenCharge:
        def __get__(self):
            self.m3GenCharge_branch.GetEntry(self.localentry, 0)
            return self.m3GenCharge_value

    property m3GenEnergy:
        def __get__(self):
            self.m3GenEnergy_branch.GetEntry(self.localentry, 0)
            return self.m3GenEnergy_value

    property m3GenEta:
        def __get__(self):
            self.m3GenEta_branch.GetEntry(self.localentry, 0)
            return self.m3GenEta_value

    property m3GenMotherPdgId:
        def __get__(self):
            self.m3GenMotherPdgId_branch.GetEntry(self.localentry, 0)
            return self.m3GenMotherPdgId_value

    property m3GenPdgId:
        def __get__(self):
            self.m3GenPdgId_branch.GetEntry(self.localentry, 0)
            return self.m3GenPdgId_value

    property m3GenPhi:
        def __get__(self):
            self.m3GenPhi_branch.GetEntry(self.localentry, 0)
            return self.m3GenPhi_value

    property m3GlbTrkHits:
        def __get__(self):
            self.m3GlbTrkHits_branch.GetEntry(self.localentry, 0)
            return self.m3GlbTrkHits_value

    property m3IDHZG2011:
        def __get__(self):
            self.m3IDHZG2011_branch.GetEntry(self.localentry, 0)
            return self.m3IDHZG2011_value

    property m3IDHZG2012:
        def __get__(self):
            self.m3IDHZG2012_branch.GetEntry(self.localentry, 0)
            return self.m3IDHZG2012_value

    property m3IP3DS:
        def __get__(self):
            self.m3IP3DS_branch.GetEntry(self.localentry, 0)
            return self.m3IP3DS_value

    property m3IsGlobal:
        def __get__(self):
            self.m3IsGlobal_branch.GetEntry(self.localentry, 0)
            return self.m3IsGlobal_value

    property m3IsPFMuon:
        def __get__(self):
            self.m3IsPFMuon_branch.GetEntry(self.localentry, 0)
            return self.m3IsPFMuon_value

    property m3IsTracker:
        def __get__(self):
            self.m3IsTracker_branch.GetEntry(self.localentry, 0)
            return self.m3IsTracker_value

    property m3JetArea:
        def __get__(self):
            self.m3JetArea_branch.GetEntry(self.localentry, 0)
            return self.m3JetArea_value

    property m3JetBtag:
        def __get__(self):
            self.m3JetBtag_branch.GetEntry(self.localentry, 0)
            return self.m3JetBtag_value

    property m3JetCSVBtag:
        def __get__(self):
            self.m3JetCSVBtag_branch.GetEntry(self.localentry, 0)
            return self.m3JetCSVBtag_value

    property m3JetEtaEtaMoment:
        def __get__(self):
            self.m3JetEtaEtaMoment_branch.GetEntry(self.localentry, 0)
            return self.m3JetEtaEtaMoment_value

    property m3JetEtaPhiMoment:
        def __get__(self):
            self.m3JetEtaPhiMoment_branch.GetEntry(self.localentry, 0)
            return self.m3JetEtaPhiMoment_value

    property m3JetEtaPhiSpread:
        def __get__(self):
            self.m3JetEtaPhiSpread_branch.GetEntry(self.localentry, 0)
            return self.m3JetEtaPhiSpread_value

    property m3JetPartonFlavour:
        def __get__(self):
            self.m3JetPartonFlavour_branch.GetEntry(self.localentry, 0)
            return self.m3JetPartonFlavour_value

    property m3JetPhiPhiMoment:
        def __get__(self):
            self.m3JetPhiPhiMoment_branch.GetEntry(self.localentry, 0)
            return self.m3JetPhiPhiMoment_value

    property m3JetPt:
        def __get__(self):
            self.m3JetPt_branch.GetEntry(self.localentry, 0)
            return self.m3JetPt_value

    property m3JetQGLikelihoodID:
        def __get__(self):
            self.m3JetQGLikelihoodID_branch.GetEntry(self.localentry, 0)
            return self.m3JetQGLikelihoodID_value

    property m3JetQGMVAID:
        def __get__(self):
            self.m3JetQGMVAID_branch.GetEntry(self.localentry, 0)
            return self.m3JetQGMVAID_value

    property m3Jetaxis1:
        def __get__(self):
            self.m3Jetaxis1_branch.GetEntry(self.localentry, 0)
            return self.m3Jetaxis1_value

    property m3Jetaxis2:
        def __get__(self):
            self.m3Jetaxis2_branch.GetEntry(self.localentry, 0)
            return self.m3Jetaxis2_value

    property m3Jetmult:
        def __get__(self):
            self.m3Jetmult_branch.GetEntry(self.localentry, 0)
            return self.m3Jetmult_value

    property m3JetmultMLP:
        def __get__(self):
            self.m3JetmultMLP_branch.GetEntry(self.localentry, 0)
            return self.m3JetmultMLP_value

    property m3JetmultMLPQC:
        def __get__(self):
            self.m3JetmultMLPQC_branch.GetEntry(self.localentry, 0)
            return self.m3JetmultMLPQC_value

    property m3JetptD:
        def __get__(self):
            self.m3JetptD_branch.GetEntry(self.localentry, 0)
            return self.m3JetptD_value

    property m3L1Mu3EG5L3Filtered17:
        def __get__(self):
            self.m3L1Mu3EG5L3Filtered17_branch.GetEntry(self.localentry, 0)
            return self.m3L1Mu3EG5L3Filtered17_value

    property m3L3fL1DoubleMu10MuOpenL1f0L2f10L3Filtered17:
        def __get__(self):
            self.m3L3fL1DoubleMu10MuOpenL1f0L2f10L3Filtered17_branch.GetEntry(self.localentry, 0)
            return self.m3L3fL1DoubleMu10MuOpenL1f0L2f10L3Filtered17_value

    property m3Mass:
        def __get__(self):
            self.m3Mass_branch.GetEntry(self.localentry, 0)
            return self.m3Mass_value

    property m3MatchedStations:
        def __get__(self):
            self.m3MatchedStations_branch.GetEntry(self.localentry, 0)
            return self.m3MatchedStations_value

    property m3MatchesDoubleMuPaths:
        def __get__(self):
            self.m3MatchesDoubleMuPaths_branch.GetEntry(self.localentry, 0)
            return self.m3MatchesDoubleMuPaths_value

    property m3MatchesDoubleMuTrkPaths:
        def __get__(self):
            self.m3MatchesDoubleMuTrkPaths_branch.GetEntry(self.localentry, 0)
            return self.m3MatchesDoubleMuTrkPaths_value

    property m3MatchesIsoMu24eta2p1:
        def __get__(self):
            self.m3MatchesIsoMu24eta2p1_branch.GetEntry(self.localentry, 0)
            return self.m3MatchesIsoMu24eta2p1_value

    property m3MatchesIsoMuGroup:
        def __get__(self):
            self.m3MatchesIsoMuGroup_branch.GetEntry(self.localentry, 0)
            return self.m3MatchesIsoMuGroup_value

    property m3MatchesMu17Ele8IsoPath:
        def __get__(self):
            self.m3MatchesMu17Ele8IsoPath_branch.GetEntry(self.localentry, 0)
            return self.m3MatchesMu17Ele8IsoPath_value

    property m3MatchesMu17Ele8Path:
        def __get__(self):
            self.m3MatchesMu17Ele8Path_branch.GetEntry(self.localentry, 0)
            return self.m3MatchesMu17Ele8Path_value

    property m3MatchesMu17Mu8Path:
        def __get__(self):
            self.m3MatchesMu17Mu8Path_branch.GetEntry(self.localentry, 0)
            return self.m3MatchesMu17Mu8Path_value

    property m3MatchesMu17TrkMu8Path:
        def __get__(self):
            self.m3MatchesMu17TrkMu8Path_branch.GetEntry(self.localentry, 0)
            return self.m3MatchesMu17TrkMu8Path_value

    property m3MatchesMu8Ele17IsoPath:
        def __get__(self):
            self.m3MatchesMu8Ele17IsoPath_branch.GetEntry(self.localentry, 0)
            return self.m3MatchesMu8Ele17IsoPath_value

    property m3MatchesMu8Ele17Path:
        def __get__(self):
            self.m3MatchesMu8Ele17Path_branch.GetEntry(self.localentry, 0)
            return self.m3MatchesMu8Ele17Path_value

    property m3MtToMET:
        def __get__(self):
            self.m3MtToMET_branch.GetEntry(self.localentry, 0)
            return self.m3MtToMET_value

    property m3MtToMVAMET:
        def __get__(self):
            self.m3MtToMVAMET_branch.GetEntry(self.localentry, 0)
            return self.m3MtToMVAMET_value

    property m3MtToPFMET:
        def __get__(self):
            self.m3MtToPFMET_branch.GetEntry(self.localentry, 0)
            return self.m3MtToPFMET_value

    property m3MtToPfMet_Ty1:
        def __get__(self):
            self.m3MtToPfMet_Ty1_branch.GetEntry(self.localentry, 0)
            return self.m3MtToPfMet_Ty1_value

    property m3MtToPfMet_jes:
        def __get__(self):
            self.m3MtToPfMet_jes_branch.GetEntry(self.localentry, 0)
            return self.m3MtToPfMet_jes_value

    property m3MtToPfMet_mes:
        def __get__(self):
            self.m3MtToPfMet_mes_branch.GetEntry(self.localentry, 0)
            return self.m3MtToPfMet_mes_value

    property m3MtToPfMet_tes:
        def __get__(self):
            self.m3MtToPfMet_tes_branch.GetEntry(self.localentry, 0)
            return self.m3MtToPfMet_tes_value

    property m3MtToPfMet_ues:
        def __get__(self):
            self.m3MtToPfMet_ues_branch.GetEntry(self.localentry, 0)
            return self.m3MtToPfMet_ues_value

    property m3Mu17Ele8dZFilter:
        def __get__(self):
            self.m3Mu17Ele8dZFilter_branch.GetEntry(self.localentry, 0)
            return self.m3Mu17Ele8dZFilter_value

    property m3MuonHits:
        def __get__(self):
            self.m3MuonHits_branch.GetEntry(self.localentry, 0)
            return self.m3MuonHits_value

    property m3NormTrkChi2:
        def __get__(self):
            self.m3NormTrkChi2_branch.GetEntry(self.localentry, 0)
            return self.m3NormTrkChi2_value

    property m3PFChargedIso:
        def __get__(self):
            self.m3PFChargedIso_branch.GetEntry(self.localentry, 0)
            return self.m3PFChargedIso_value

    property m3PFIDTight:
        def __get__(self):
            self.m3PFIDTight_branch.GetEntry(self.localentry, 0)
            return self.m3PFIDTight_value

    property m3PFNeutralIso:
        def __get__(self):
            self.m3PFNeutralIso_branch.GetEntry(self.localentry, 0)
            return self.m3PFNeutralIso_value

    property m3PFPUChargedIso:
        def __get__(self):
            self.m3PFPUChargedIso_branch.GetEntry(self.localentry, 0)
            return self.m3PFPUChargedIso_value

    property m3PFPhotonIso:
        def __get__(self):
            self.m3PFPhotonIso_branch.GetEntry(self.localentry, 0)
            return self.m3PFPhotonIso_value

    property m3PVDXY:
        def __get__(self):
            self.m3PVDXY_branch.GetEntry(self.localentry, 0)
            return self.m3PVDXY_value

    property m3PVDZ:
        def __get__(self):
            self.m3PVDZ_branch.GetEntry(self.localentry, 0)
            return self.m3PVDZ_value

    property m3Phi:
        def __get__(self):
            self.m3Phi_branch.GetEntry(self.localentry, 0)
            return self.m3Phi_value

    property m3PhiRochCor2011A:
        def __get__(self):
            self.m3PhiRochCor2011A_branch.GetEntry(self.localentry, 0)
            return self.m3PhiRochCor2011A_value

    property m3PhiRochCor2011B:
        def __get__(self):
            self.m3PhiRochCor2011B_branch.GetEntry(self.localentry, 0)
            return self.m3PhiRochCor2011B_value

    property m3PhiRochCor2012:
        def __get__(self):
            self.m3PhiRochCor2012_branch.GetEntry(self.localentry, 0)
            return self.m3PhiRochCor2012_value

    property m3PixHits:
        def __get__(self):
            self.m3PixHits_branch.GetEntry(self.localentry, 0)
            return self.m3PixHits_value

    property m3Pt:
        def __get__(self):
            self.m3Pt_branch.GetEntry(self.localentry, 0)
            return self.m3Pt_value

    property m3PtRochCor2011A:
        def __get__(self):
            self.m3PtRochCor2011A_branch.GetEntry(self.localentry, 0)
            return self.m3PtRochCor2011A_value

    property m3PtRochCor2011B:
        def __get__(self):
            self.m3PtRochCor2011B_branch.GetEntry(self.localentry, 0)
            return self.m3PtRochCor2011B_value

    property m3PtRochCor2012:
        def __get__(self):
            self.m3PtRochCor2012_branch.GetEntry(self.localentry, 0)
            return self.m3PtRochCor2012_value

    property m3Rank:
        def __get__(self):
            self.m3Rank_branch.GetEntry(self.localentry, 0)
            return self.m3Rank_value

    property m3RelPFIsoDB:
        def __get__(self):
            self.m3RelPFIsoDB_branch.GetEntry(self.localentry, 0)
            return self.m3RelPFIsoDB_value

    property m3RelPFIsoRho:
        def __get__(self):
            self.m3RelPFIsoRho_branch.GetEntry(self.localentry, 0)
            return self.m3RelPFIsoRho_value

    property m3RelPFIsoRhoFSR:
        def __get__(self):
            self.m3RelPFIsoRhoFSR_branch.GetEntry(self.localentry, 0)
            return self.m3RelPFIsoRhoFSR_value

    property m3RhoHZG2011:
        def __get__(self):
            self.m3RhoHZG2011_branch.GetEntry(self.localentry, 0)
            return self.m3RhoHZG2011_value

    property m3RhoHZG2012:
        def __get__(self):
            self.m3RhoHZG2012_branch.GetEntry(self.localentry, 0)
            return self.m3RhoHZG2012_value

    property m3SingleMu13L3Filtered13:
        def __get__(self):
            self.m3SingleMu13L3Filtered13_branch.GetEntry(self.localentry, 0)
            return self.m3SingleMu13L3Filtered13_value

    property m3SingleMu13L3Filtered17:
        def __get__(self):
            self.m3SingleMu13L3Filtered17_branch.GetEntry(self.localentry, 0)
            return self.m3SingleMu13L3Filtered17_value

    property m3TkLayersWithMeasurement:
        def __get__(self):
            self.m3TkLayersWithMeasurement_branch.GetEntry(self.localentry, 0)
            return self.m3TkLayersWithMeasurement_value

    property m3ToMETDPhi:
        def __get__(self):
            self.m3ToMETDPhi_branch.GetEntry(self.localentry, 0)
            return self.m3ToMETDPhi_value

    property m3TypeCode:
        def __get__(self):
            self.m3TypeCode_branch.GetEntry(self.localentry, 0)
            return self.m3TypeCode_value

    property m3VBTFID:
        def __get__(self):
            self.m3VBTFID_branch.GetEntry(self.localentry, 0)
            return self.m3VBTFID_value

    property m3VZ:
        def __get__(self):
            self.m3VZ_branch.GetEntry(self.localentry, 0)
            return self.m3VZ_value

    property m3WWID:
        def __get__(self):
            self.m3WWID_branch.GetEntry(self.localentry, 0)
            return self.m3WWID_value

    property m3_t_CosThetaStar:
        def __get__(self):
            self.m3_t_CosThetaStar_branch.GetEntry(self.localentry, 0)
            return self.m3_t_CosThetaStar_value

    property m3_t_DPhi:
        def __get__(self):
            self.m3_t_DPhi_branch.GetEntry(self.localentry, 0)
            return self.m3_t_DPhi_value

    property m3_t_DR:
        def __get__(self):
            self.m3_t_DR_branch.GetEntry(self.localentry, 0)
            return self.m3_t_DR_value

    property m3_t_Eta:
        def __get__(self):
            self.m3_t_Eta_branch.GetEntry(self.localentry, 0)
            return self.m3_t_Eta_value

    property m3_t_Mass:
        def __get__(self):
            self.m3_t_Mass_branch.GetEntry(self.localentry, 0)
            return self.m3_t_Mass_value

    property m3_t_MassFsr:
        def __get__(self):
            self.m3_t_MassFsr_branch.GetEntry(self.localentry, 0)
            return self.m3_t_MassFsr_value

    property m3_t_PZeta:
        def __get__(self):
            self.m3_t_PZeta_branch.GetEntry(self.localentry, 0)
            return self.m3_t_PZeta_value

    property m3_t_PZetaVis:
        def __get__(self):
            self.m3_t_PZetaVis_branch.GetEntry(self.localentry, 0)
            return self.m3_t_PZetaVis_value

    property m3_t_Phi:
        def __get__(self):
            self.m3_t_Phi_branch.GetEntry(self.localentry, 0)
            return self.m3_t_Phi_value

    property m3_t_Pt:
        def __get__(self):
            self.m3_t_Pt_branch.GetEntry(self.localentry, 0)
            return self.m3_t_Pt_value

    property m3_t_PtFsr:
        def __get__(self):
            self.m3_t_PtFsr_branch.GetEntry(self.localentry, 0)
            return self.m3_t_PtFsr_value

    property m3_t_SS:
        def __get__(self):
            self.m3_t_SS_branch.GetEntry(self.localentry, 0)
            return self.m3_t_SS_value

    property m3_t_SVfitEta:
        def __get__(self):
            self.m3_t_SVfitEta_branch.GetEntry(self.localentry, 0)
            return self.m3_t_SVfitEta_value

    property m3_t_SVfitMass:
        def __get__(self):
            self.m3_t_SVfitMass_branch.GetEntry(self.localentry, 0)
            return self.m3_t_SVfitMass_value

    property m3_t_SVfitPhi:
        def __get__(self):
            self.m3_t_SVfitPhi_branch.GetEntry(self.localentry, 0)
            return self.m3_t_SVfitPhi_value

    property m3_t_SVfitPt:
        def __get__(self):
            self.m3_t_SVfitPt_branch.GetEntry(self.localentry, 0)
            return self.m3_t_SVfitPt_value

    property m3_t_ToMETDPhi_Ty1:
        def __get__(self):
            self.m3_t_ToMETDPhi_Ty1_branch.GetEntry(self.localentry, 0)
            return self.m3_t_ToMETDPhi_Ty1_value

    property m3_t_Zcompat:
        def __get__(self):
            self.m3_t_Zcompat_branch.GetEntry(self.localentry, 0)
            return self.m3_t_Zcompat_value

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

    property tAbsEta:
        def __get__(self):
            self.tAbsEta_branch.GetEntry(self.localentry, 0)
            return self.tAbsEta_value

    property tAntiElectronLoose:
        def __get__(self):
            self.tAntiElectronLoose_branch.GetEntry(self.localentry, 0)
            return self.tAntiElectronLoose_value

    property tAntiElectronMVA3Loose:
        def __get__(self):
            self.tAntiElectronMVA3Loose_branch.GetEntry(self.localentry, 0)
            return self.tAntiElectronMVA3Loose_value

    property tAntiElectronMVA3Medium:
        def __get__(self):
            self.tAntiElectronMVA3Medium_branch.GetEntry(self.localentry, 0)
            return self.tAntiElectronMVA3Medium_value

    property tAntiElectronMVA3Raw:
        def __get__(self):
            self.tAntiElectronMVA3Raw_branch.GetEntry(self.localentry, 0)
            return self.tAntiElectronMVA3Raw_value

    property tAntiElectronMVA3Tight:
        def __get__(self):
            self.tAntiElectronMVA3Tight_branch.GetEntry(self.localentry, 0)
            return self.tAntiElectronMVA3Tight_value

    property tAntiElectronMVA3VTight:
        def __get__(self):
            self.tAntiElectronMVA3VTight_branch.GetEntry(self.localentry, 0)
            return self.tAntiElectronMVA3VTight_value

    property tAntiElectronMedium:
        def __get__(self):
            self.tAntiElectronMedium_branch.GetEntry(self.localentry, 0)
            return self.tAntiElectronMedium_value

    property tAntiElectronTight:
        def __get__(self):
            self.tAntiElectronTight_branch.GetEntry(self.localentry, 0)
            return self.tAntiElectronTight_value

    property tAntiMuonLoose:
        def __get__(self):
            self.tAntiMuonLoose_branch.GetEntry(self.localentry, 0)
            return self.tAntiMuonLoose_value

    property tAntiMuonLoose2:
        def __get__(self):
            self.tAntiMuonLoose2_branch.GetEntry(self.localentry, 0)
            return self.tAntiMuonLoose2_value

    property tAntiMuonMedium:
        def __get__(self):
            self.tAntiMuonMedium_branch.GetEntry(self.localentry, 0)
            return self.tAntiMuonMedium_value

    property tAntiMuonMedium2:
        def __get__(self):
            self.tAntiMuonMedium2_branch.GetEntry(self.localentry, 0)
            return self.tAntiMuonMedium2_value

    property tAntiMuonTight:
        def __get__(self):
            self.tAntiMuonTight_branch.GetEntry(self.localentry, 0)
            return self.tAntiMuonTight_value

    property tAntiMuonTight2:
        def __get__(self):
            self.tAntiMuonTight2_branch.GetEntry(self.localentry, 0)
            return self.tAntiMuonTight2_value

    property tCharge:
        def __get__(self):
            self.tCharge_branch.GetEntry(self.localentry, 0)
            return self.tCharge_value

    property tCiCTightElecOverlap:
        def __get__(self):
            self.tCiCTightElecOverlap_branch.GetEntry(self.localentry, 0)
            return self.tCiCTightElecOverlap_value

    property tDZ:
        def __get__(self):
            self.tDZ_branch.GetEntry(self.localentry, 0)
            return self.tDZ_value

    property tDecayFinding:
        def __get__(self):
            self.tDecayFinding_branch.GetEntry(self.localentry, 0)
            return self.tDecayFinding_value

    property tDecayMode:
        def __get__(self):
            self.tDecayMode_branch.GetEntry(self.localentry, 0)
            return self.tDecayMode_value

    property tElecOverlap:
        def __get__(self):
            self.tElecOverlap_branch.GetEntry(self.localentry, 0)
            return self.tElecOverlap_value

    property tElecOverlapZHLoose:
        def __get__(self):
            self.tElecOverlapZHLoose_branch.GetEntry(self.localentry, 0)
            return self.tElecOverlapZHLoose_value

    property tElecOverlapZHTight:
        def __get__(self):
            self.tElecOverlapZHTight_branch.GetEntry(self.localentry, 0)
            return self.tElecOverlapZHTight_value

    property tEta:
        def __get__(self):
            self.tEta_branch.GetEntry(self.localentry, 0)
            return self.tEta_value

    property tGenDecayMode:
        def __get__(self):
            self.tGenDecayMode_branch.GetEntry(self.localentry, 0)
            return self.tGenDecayMode_value

    property tIP3DS:
        def __get__(self):
            self.tIP3DS_branch.GetEntry(self.localentry, 0)
            return self.tIP3DS_value

    property tJetArea:
        def __get__(self):
            self.tJetArea_branch.GetEntry(self.localentry, 0)
            return self.tJetArea_value

    property tJetBtag:
        def __get__(self):
            self.tJetBtag_branch.GetEntry(self.localentry, 0)
            return self.tJetBtag_value

    property tJetCSVBtag:
        def __get__(self):
            self.tJetCSVBtag_branch.GetEntry(self.localentry, 0)
            return self.tJetCSVBtag_value

    property tJetEtaEtaMoment:
        def __get__(self):
            self.tJetEtaEtaMoment_branch.GetEntry(self.localentry, 0)
            return self.tJetEtaEtaMoment_value

    property tJetEtaPhiMoment:
        def __get__(self):
            self.tJetEtaPhiMoment_branch.GetEntry(self.localentry, 0)
            return self.tJetEtaPhiMoment_value

    property tJetEtaPhiSpread:
        def __get__(self):
            self.tJetEtaPhiSpread_branch.GetEntry(self.localentry, 0)
            return self.tJetEtaPhiSpread_value

    property tJetPartonFlavour:
        def __get__(self):
            self.tJetPartonFlavour_branch.GetEntry(self.localentry, 0)
            return self.tJetPartonFlavour_value

    property tJetPhiPhiMoment:
        def __get__(self):
            self.tJetPhiPhiMoment_branch.GetEntry(self.localentry, 0)
            return self.tJetPhiPhiMoment_value

    property tJetPt:
        def __get__(self):
            self.tJetPt_branch.GetEntry(self.localentry, 0)
            return self.tJetPt_value

    property tJetQGLikelihoodID:
        def __get__(self):
            self.tJetQGLikelihoodID_branch.GetEntry(self.localentry, 0)
            return self.tJetQGLikelihoodID_value

    property tJetQGMVAID:
        def __get__(self):
            self.tJetQGMVAID_branch.GetEntry(self.localentry, 0)
            return self.tJetQGMVAID_value

    property tJetaxis1:
        def __get__(self):
            self.tJetaxis1_branch.GetEntry(self.localentry, 0)
            return self.tJetaxis1_value

    property tJetaxis2:
        def __get__(self):
            self.tJetaxis2_branch.GetEntry(self.localentry, 0)
            return self.tJetaxis2_value

    property tJetmult:
        def __get__(self):
            self.tJetmult_branch.GetEntry(self.localentry, 0)
            return self.tJetmult_value

    property tJetmultMLP:
        def __get__(self):
            self.tJetmultMLP_branch.GetEntry(self.localentry, 0)
            return self.tJetmultMLP_value

    property tJetmultMLPQC:
        def __get__(self):
            self.tJetmultMLPQC_branch.GetEntry(self.localentry, 0)
            return self.tJetmultMLPQC_value

    property tJetptD:
        def __get__(self):
            self.tJetptD_branch.GetEntry(self.localentry, 0)
            return self.tJetptD_value

    property tLeadTrackPt:
        def __get__(self):
            self.tLeadTrackPt_branch.GetEntry(self.localentry, 0)
            return self.tLeadTrackPt_value

    property tLooseIso:
        def __get__(self):
            self.tLooseIso_branch.GetEntry(self.localentry, 0)
            return self.tLooseIso_value

    property tLooseIso3Hits:
        def __get__(self):
            self.tLooseIso3Hits_branch.GetEntry(self.localentry, 0)
            return self.tLooseIso3Hits_value

    property tLooseMVA2Iso:
        def __get__(self):
            self.tLooseMVA2Iso_branch.GetEntry(self.localentry, 0)
            return self.tLooseMVA2Iso_value

    property tLooseMVAIso:
        def __get__(self):
            self.tLooseMVAIso_branch.GetEntry(self.localentry, 0)
            return self.tLooseMVAIso_value

    property tMVA2IsoRaw:
        def __get__(self):
            self.tMVA2IsoRaw_branch.GetEntry(self.localentry, 0)
            return self.tMVA2IsoRaw_value

    property tMass:
        def __get__(self):
            self.tMass_branch.GetEntry(self.localentry, 0)
            return self.tMass_value

    property tMediumIso:
        def __get__(self):
            self.tMediumIso_branch.GetEntry(self.localentry, 0)
            return self.tMediumIso_value

    property tMediumIso3Hits:
        def __get__(self):
            self.tMediumIso3Hits_branch.GetEntry(self.localentry, 0)
            return self.tMediumIso3Hits_value

    property tMediumMVA2Iso:
        def __get__(self):
            self.tMediumMVA2Iso_branch.GetEntry(self.localentry, 0)
            return self.tMediumMVA2Iso_value

    property tMediumMVAIso:
        def __get__(self):
            self.tMediumMVAIso_branch.GetEntry(self.localentry, 0)
            return self.tMediumMVAIso_value

    property tMtToMET:
        def __get__(self):
            self.tMtToMET_branch.GetEntry(self.localentry, 0)
            return self.tMtToMET_value

    property tMtToMVAMET:
        def __get__(self):
            self.tMtToMVAMET_branch.GetEntry(self.localentry, 0)
            return self.tMtToMVAMET_value

    property tMtToPFMET:
        def __get__(self):
            self.tMtToPFMET_branch.GetEntry(self.localentry, 0)
            return self.tMtToPFMET_value

    property tMtToPfMet_Ty1:
        def __get__(self):
            self.tMtToPfMet_Ty1_branch.GetEntry(self.localentry, 0)
            return self.tMtToPfMet_Ty1_value

    property tMtToPfMet_jes:
        def __get__(self):
            self.tMtToPfMet_jes_branch.GetEntry(self.localentry, 0)
            return self.tMtToPfMet_jes_value

    property tMtToPfMet_mes:
        def __get__(self):
            self.tMtToPfMet_mes_branch.GetEntry(self.localentry, 0)
            return self.tMtToPfMet_mes_value

    property tMtToPfMet_tes:
        def __get__(self):
            self.tMtToPfMet_tes_branch.GetEntry(self.localentry, 0)
            return self.tMtToPfMet_tes_value

    property tMtToPfMet_ues:
        def __get__(self):
            self.tMtToPfMet_ues_branch.GetEntry(self.localentry, 0)
            return self.tMtToPfMet_ues_value

    property tMuOverlap:
        def __get__(self):
            self.tMuOverlap_branch.GetEntry(self.localentry, 0)
            return self.tMuOverlap_value

    property tMuOverlapZHLoose:
        def __get__(self):
            self.tMuOverlapZHLoose_branch.GetEntry(self.localentry, 0)
            return self.tMuOverlapZHLoose_value

    property tMuOverlapZHTight:
        def __get__(self):
            self.tMuOverlapZHTight_branch.GetEntry(self.localentry, 0)
            return self.tMuOverlapZHTight_value

    property tPhi:
        def __get__(self):
            self.tPhi_branch.GetEntry(self.localentry, 0)
            return self.tPhi_value

    property tPt:
        def __get__(self):
            self.tPt_branch.GetEntry(self.localentry, 0)
            return self.tPt_value

    property tRank:
        def __get__(self):
            self.tRank_branch.GetEntry(self.localentry, 0)
            return self.tRank_value

    property tTNPId:
        def __get__(self):
            self.tTNPId_branch.GetEntry(self.localentry, 0)
            return self.tTNPId_value

    property tTightIso:
        def __get__(self):
            self.tTightIso_branch.GetEntry(self.localentry, 0)
            return self.tTightIso_value

    property tTightIso3Hits:
        def __get__(self):
            self.tTightIso3Hits_branch.GetEntry(self.localentry, 0)
            return self.tTightIso3Hits_value

    property tTightMVA2Iso:
        def __get__(self):
            self.tTightMVA2Iso_branch.GetEntry(self.localentry, 0)
            return self.tTightMVA2Iso_value

    property tTightMVAIso:
        def __get__(self):
            self.tTightMVAIso_branch.GetEntry(self.localentry, 0)
            return self.tTightMVAIso_value

    property tToMETDPhi:
        def __get__(self):
            self.tToMETDPhi_branch.GetEntry(self.localentry, 0)
            return self.tToMETDPhi_value

    property tVLooseIso:
        def __get__(self):
            self.tVLooseIso_branch.GetEntry(self.localentry, 0)
            return self.tVLooseIso_value

    property tVZ:
        def __get__(self):
            self.tVZ_branch.GetEntry(self.localentry, 0)
            return self.tVZ_value

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


