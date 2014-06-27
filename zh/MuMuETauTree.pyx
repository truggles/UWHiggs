

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

cdef class MuMuETauTree:
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

    cdef TBranch* eAbsEta_branch
    cdef float eAbsEta_value

    cdef TBranch* eCBID_LOOSE_branch
    cdef float eCBID_LOOSE_value

    cdef TBranch* eCBID_MEDIUM_branch
    cdef float eCBID_MEDIUM_value

    cdef TBranch* eCBID_TIGHT_branch
    cdef float eCBID_TIGHT_value

    cdef TBranch* eCBID_VETO_branch
    cdef float eCBID_VETO_value

    cdef TBranch* eCharge_branch
    cdef float eCharge_value

    cdef TBranch* eChargeIdLoose_branch
    cdef float eChargeIdLoose_value

    cdef TBranch* eChargeIdMed_branch
    cdef float eChargeIdMed_value

    cdef TBranch* eChargeIdTight_branch
    cdef float eChargeIdTight_value

    cdef TBranch* eCiCTight_branch
    cdef float eCiCTight_value

    cdef TBranch* eComesFromHiggs_branch
    cdef float eComesFromHiggs_value

    cdef TBranch* eDZ_branch
    cdef float eDZ_value

    cdef TBranch* eE1x5_branch
    cdef float eE1x5_value

    cdef TBranch* eE2x5Max_branch
    cdef float eE2x5Max_value

    cdef TBranch* eE5x5_branch
    cdef float eE5x5_value

    cdef TBranch* eECorrReg_2012Jul13ReReco_branch
    cdef float eECorrReg_2012Jul13ReReco_value

    cdef TBranch* eECorrReg_Fall11_branch
    cdef float eECorrReg_Fall11_value

    cdef TBranch* eECorrReg_Jan16ReReco_branch
    cdef float eECorrReg_Jan16ReReco_value

    cdef TBranch* eECorrReg_Summer12_DR53X_HCP2012_branch
    cdef float eECorrReg_Summer12_DR53X_HCP2012_value

    cdef TBranch* eECorrSmearedNoReg_2012Jul13ReReco_branch
    cdef float eECorrSmearedNoReg_2012Jul13ReReco_value

    cdef TBranch* eECorrSmearedNoReg_Fall11_branch
    cdef float eECorrSmearedNoReg_Fall11_value

    cdef TBranch* eECorrSmearedNoReg_Jan16ReReco_branch
    cdef float eECorrSmearedNoReg_Jan16ReReco_value

    cdef TBranch* eECorrSmearedNoReg_Summer12_DR53X_HCP2012_branch
    cdef float eECorrSmearedNoReg_Summer12_DR53X_HCP2012_value

    cdef TBranch* eECorrSmearedReg_2012Jul13ReReco_branch
    cdef float eECorrSmearedReg_2012Jul13ReReco_value

    cdef TBranch* eECorrSmearedReg_Fall11_branch
    cdef float eECorrSmearedReg_Fall11_value

    cdef TBranch* eECorrSmearedReg_Jan16ReReco_branch
    cdef float eECorrSmearedReg_Jan16ReReco_value

    cdef TBranch* eECorrSmearedReg_Summer12_DR53X_HCP2012_branch
    cdef float eECorrSmearedReg_Summer12_DR53X_HCP2012_value

    cdef TBranch* eEcalIsoDR03_branch
    cdef float eEcalIsoDR03_value

    cdef TBranch* eEffectiveArea2011Data_branch
    cdef float eEffectiveArea2011Data_value

    cdef TBranch* eEffectiveArea2012Data_branch
    cdef float eEffectiveArea2012Data_value

    cdef TBranch* eEffectiveAreaFall11MC_branch
    cdef float eEffectiveAreaFall11MC_value

    cdef TBranch* eEle27WP80PFMT50PFMTFilter_branch
    cdef float eEle27WP80PFMT50PFMTFilter_value

    cdef TBranch* eEle27WP80TrackIsoMatchFilter_branch
    cdef float eEle27WP80TrackIsoMatchFilter_value

    cdef TBranch* eEle32WP70PFMT50PFMTFilter_branch
    cdef float eEle32WP70PFMT50PFMTFilter_value

    cdef TBranch* eEnergyError_branch
    cdef float eEnergyError_value

    cdef TBranch* eEta_branch
    cdef float eEta_value

    cdef TBranch* eEtaCorrReg_2012Jul13ReReco_branch
    cdef float eEtaCorrReg_2012Jul13ReReco_value

    cdef TBranch* eEtaCorrReg_Fall11_branch
    cdef float eEtaCorrReg_Fall11_value

    cdef TBranch* eEtaCorrReg_Jan16ReReco_branch
    cdef float eEtaCorrReg_Jan16ReReco_value

    cdef TBranch* eEtaCorrReg_Summer12_DR53X_HCP2012_branch
    cdef float eEtaCorrReg_Summer12_DR53X_HCP2012_value

    cdef TBranch* eEtaCorrSmearedNoReg_2012Jul13ReReco_branch
    cdef float eEtaCorrSmearedNoReg_2012Jul13ReReco_value

    cdef TBranch* eEtaCorrSmearedNoReg_Fall11_branch
    cdef float eEtaCorrSmearedNoReg_Fall11_value

    cdef TBranch* eEtaCorrSmearedNoReg_Jan16ReReco_branch
    cdef float eEtaCorrSmearedNoReg_Jan16ReReco_value

    cdef TBranch* eEtaCorrSmearedNoReg_Summer12_DR53X_HCP2012_branch
    cdef float eEtaCorrSmearedNoReg_Summer12_DR53X_HCP2012_value

    cdef TBranch* eEtaCorrSmearedReg_2012Jul13ReReco_branch
    cdef float eEtaCorrSmearedReg_2012Jul13ReReco_value

    cdef TBranch* eEtaCorrSmearedReg_Fall11_branch
    cdef float eEtaCorrSmearedReg_Fall11_value

    cdef TBranch* eEtaCorrSmearedReg_Jan16ReReco_branch
    cdef float eEtaCorrSmearedReg_Jan16ReReco_value

    cdef TBranch* eEtaCorrSmearedReg_Summer12_DR53X_HCP2012_branch
    cdef float eEtaCorrSmearedReg_Summer12_DR53X_HCP2012_value

    cdef TBranch* eGenCharge_branch
    cdef float eGenCharge_value

    cdef TBranch* eGenEnergy_branch
    cdef float eGenEnergy_value

    cdef TBranch* eGenEta_branch
    cdef float eGenEta_value

    cdef TBranch* eGenMotherPdgId_branch
    cdef float eGenMotherPdgId_value

    cdef TBranch* eGenPdgId_branch
    cdef float eGenPdgId_value

    cdef TBranch* eGenPhi_branch
    cdef float eGenPhi_value

    cdef TBranch* eHadronicDepth1OverEm_branch
    cdef float eHadronicDepth1OverEm_value

    cdef TBranch* eHadronicDepth2OverEm_branch
    cdef float eHadronicDepth2OverEm_value

    cdef TBranch* eHadronicOverEM_branch
    cdef float eHadronicOverEM_value

    cdef TBranch* eHasConversion_branch
    cdef float eHasConversion_value

    cdef TBranch* eHasMatchedConversion_branch
    cdef int eHasMatchedConversion_value

    cdef TBranch* eHcalIsoDR03_branch
    cdef float eHcalIsoDR03_value

    cdef TBranch* eIP3DS_branch
    cdef float eIP3DS_value

    cdef TBranch* eJetArea_branch
    cdef float eJetArea_value

    cdef TBranch* eJetBtag_branch
    cdef float eJetBtag_value

    cdef TBranch* eJetCSVBtag_branch
    cdef float eJetCSVBtag_value

    cdef TBranch* eJetEtaEtaMoment_branch
    cdef float eJetEtaEtaMoment_value

    cdef TBranch* eJetEtaPhiMoment_branch
    cdef float eJetEtaPhiMoment_value

    cdef TBranch* eJetEtaPhiSpread_branch
    cdef float eJetEtaPhiSpread_value

    cdef TBranch* eJetPartonFlavour_branch
    cdef float eJetPartonFlavour_value

    cdef TBranch* eJetPhiPhiMoment_branch
    cdef float eJetPhiPhiMoment_value

    cdef TBranch* eJetPt_branch
    cdef float eJetPt_value

    cdef TBranch* eJetQGLikelihoodID_branch
    cdef float eJetQGLikelihoodID_value

    cdef TBranch* eJetQGMVAID_branch
    cdef float eJetQGMVAID_value

    cdef TBranch* eJetaxis1_branch
    cdef float eJetaxis1_value

    cdef TBranch* eJetaxis2_branch
    cdef float eJetaxis2_value

    cdef TBranch* eJetmult_branch
    cdef float eJetmult_value

    cdef TBranch* eJetmultMLP_branch
    cdef float eJetmultMLP_value

    cdef TBranch* eJetmultMLPQC_branch
    cdef float eJetmultMLPQC_value

    cdef TBranch* eJetptD_branch
    cdef float eJetptD_value

    cdef TBranch* eL1NonIsoHLTNonIsoMu17Ele8PixelMatchFilter_branch
    cdef float eL1NonIsoHLTNonIsoMu17Ele8PixelMatchFilter_value

    cdef TBranch* eMITID_branch
    cdef float eMITID_value

    cdef TBranch* eMVAIDH2TauWP_branch
    cdef float eMVAIDH2TauWP_value

    cdef TBranch* eMVANonTrig_branch
    cdef float eMVANonTrig_value

    cdef TBranch* eMVATrig_branch
    cdef float eMVATrig_value

    cdef TBranch* eMVATrigIDISO_branch
    cdef float eMVATrigIDISO_value

    cdef TBranch* eMVATrigIDISOPUSUB_branch
    cdef float eMVATrigIDISOPUSUB_value

    cdef TBranch* eMVATrigNoIP_branch
    cdef float eMVATrigNoIP_value

    cdef TBranch* eMass_branch
    cdef float eMass_value

    cdef TBranch* eMatchesDoubleEPath_branch
    cdef float eMatchesDoubleEPath_value

    cdef TBranch* eMatchesMu17Ele8IsoPath_branch
    cdef float eMatchesMu17Ele8IsoPath_value

    cdef TBranch* eMatchesMu17Ele8Path_branch
    cdef float eMatchesMu17Ele8Path_value

    cdef TBranch* eMatchesMu8Ele17IsoPath_branch
    cdef float eMatchesMu8Ele17IsoPath_value

    cdef TBranch* eMatchesMu8Ele17Path_branch
    cdef float eMatchesMu8Ele17Path_value

    cdef TBranch* eMatchesSingleE_branch
    cdef float eMatchesSingleE_value

    cdef TBranch* eMatchesSingleEPlusMET_branch
    cdef float eMatchesSingleEPlusMET_value

    cdef TBranch* eMissingHits_branch
    cdef float eMissingHits_value

    cdef TBranch* eMtToMET_branch
    cdef float eMtToMET_value

    cdef TBranch* eMtToMVAMET_branch
    cdef float eMtToMVAMET_value

    cdef TBranch* eMtToPFMET_branch
    cdef float eMtToPFMET_value

    cdef TBranch* eMtToPfMet_Ty1_branch
    cdef float eMtToPfMet_Ty1_value

    cdef TBranch* eMtToPfMet_jes_branch
    cdef float eMtToPfMet_jes_value

    cdef TBranch* eMtToPfMet_mes_branch
    cdef float eMtToPfMet_mes_value

    cdef TBranch* eMtToPfMet_tes_branch
    cdef float eMtToPfMet_tes_value

    cdef TBranch* eMtToPfMet_ues_branch
    cdef float eMtToPfMet_ues_value

    cdef TBranch* eMu17Ele8CaloIdTCaloIsoVLTrkIdVLTrkIsoVLTrackIsoFilter_branch
    cdef float eMu17Ele8CaloIdTCaloIsoVLTrkIdVLTrkIsoVLTrackIsoFilter_value

    cdef TBranch* eMu17Ele8CaloIdTPixelMatchFilter_branch
    cdef float eMu17Ele8CaloIdTPixelMatchFilter_value

    cdef TBranch* eMu17Ele8dZFilter_branch
    cdef float eMu17Ele8dZFilter_value

    cdef TBranch* eNearMuonVeto_branch
    cdef float eNearMuonVeto_value

    cdef TBranch* ePFChargedIso_branch
    cdef float ePFChargedIso_value

    cdef TBranch* ePFNeutralIso_branch
    cdef float ePFNeutralIso_value

    cdef TBranch* ePFPhotonIso_branch
    cdef float ePFPhotonIso_value

    cdef TBranch* ePVDXY_branch
    cdef float ePVDXY_value

    cdef TBranch* ePVDZ_branch
    cdef float ePVDZ_value

    cdef TBranch* ePhi_branch
    cdef float ePhi_value

    cdef TBranch* ePhiCorrReg_2012Jul13ReReco_branch
    cdef float ePhiCorrReg_2012Jul13ReReco_value

    cdef TBranch* ePhiCorrReg_Fall11_branch
    cdef float ePhiCorrReg_Fall11_value

    cdef TBranch* ePhiCorrReg_Jan16ReReco_branch
    cdef float ePhiCorrReg_Jan16ReReco_value

    cdef TBranch* ePhiCorrReg_Summer12_DR53X_HCP2012_branch
    cdef float ePhiCorrReg_Summer12_DR53X_HCP2012_value

    cdef TBranch* ePhiCorrSmearedNoReg_2012Jul13ReReco_branch
    cdef float ePhiCorrSmearedNoReg_2012Jul13ReReco_value

    cdef TBranch* ePhiCorrSmearedNoReg_Fall11_branch
    cdef float ePhiCorrSmearedNoReg_Fall11_value

    cdef TBranch* ePhiCorrSmearedNoReg_Jan16ReReco_branch
    cdef float ePhiCorrSmearedNoReg_Jan16ReReco_value

    cdef TBranch* ePhiCorrSmearedNoReg_Summer12_DR53X_HCP2012_branch
    cdef float ePhiCorrSmearedNoReg_Summer12_DR53X_HCP2012_value

    cdef TBranch* ePhiCorrSmearedReg_2012Jul13ReReco_branch
    cdef float ePhiCorrSmearedReg_2012Jul13ReReco_value

    cdef TBranch* ePhiCorrSmearedReg_Fall11_branch
    cdef float ePhiCorrSmearedReg_Fall11_value

    cdef TBranch* ePhiCorrSmearedReg_Jan16ReReco_branch
    cdef float ePhiCorrSmearedReg_Jan16ReReco_value

    cdef TBranch* ePhiCorrSmearedReg_Summer12_DR53X_HCP2012_branch
    cdef float ePhiCorrSmearedReg_Summer12_DR53X_HCP2012_value

    cdef TBranch* ePt_branch
    cdef float ePt_value

    cdef TBranch* ePtCorrReg_2012Jul13ReReco_branch
    cdef float ePtCorrReg_2012Jul13ReReco_value

    cdef TBranch* ePtCorrReg_Fall11_branch
    cdef float ePtCorrReg_Fall11_value

    cdef TBranch* ePtCorrReg_Jan16ReReco_branch
    cdef float ePtCorrReg_Jan16ReReco_value

    cdef TBranch* ePtCorrReg_Summer12_DR53X_HCP2012_branch
    cdef float ePtCorrReg_Summer12_DR53X_HCP2012_value

    cdef TBranch* ePtCorrSmearedNoReg_2012Jul13ReReco_branch
    cdef float ePtCorrSmearedNoReg_2012Jul13ReReco_value

    cdef TBranch* ePtCorrSmearedNoReg_Fall11_branch
    cdef float ePtCorrSmearedNoReg_Fall11_value

    cdef TBranch* ePtCorrSmearedNoReg_Jan16ReReco_branch
    cdef float ePtCorrSmearedNoReg_Jan16ReReco_value

    cdef TBranch* ePtCorrSmearedNoReg_Summer12_DR53X_HCP2012_branch
    cdef float ePtCorrSmearedNoReg_Summer12_DR53X_HCP2012_value

    cdef TBranch* ePtCorrSmearedReg_2012Jul13ReReco_branch
    cdef float ePtCorrSmearedReg_2012Jul13ReReco_value

    cdef TBranch* ePtCorrSmearedReg_Fall11_branch
    cdef float ePtCorrSmearedReg_Fall11_value

    cdef TBranch* ePtCorrSmearedReg_Jan16ReReco_branch
    cdef float ePtCorrSmearedReg_Jan16ReReco_value

    cdef TBranch* ePtCorrSmearedReg_Summer12_DR53X_HCP2012_branch
    cdef float ePtCorrSmearedReg_Summer12_DR53X_HCP2012_value

    cdef TBranch* eRank_branch
    cdef float eRank_value

    cdef TBranch* eRelIso_branch
    cdef float eRelIso_value

    cdef TBranch* eRelPFIsoDB_branch
    cdef float eRelPFIsoDB_value

    cdef TBranch* eRelPFIsoRho_branch
    cdef float eRelPFIsoRho_value

    cdef TBranch* eRelPFIsoRhoFSR_branch
    cdef float eRelPFIsoRhoFSR_value

    cdef TBranch* eRhoHZG2011_branch
    cdef float eRhoHZG2011_value

    cdef TBranch* eRhoHZG2012_branch
    cdef float eRhoHZG2012_value

    cdef TBranch* eSCEnergy_branch
    cdef float eSCEnergy_value

    cdef TBranch* eSCEta_branch
    cdef float eSCEta_value

    cdef TBranch* eSCEtaWidth_branch
    cdef float eSCEtaWidth_value

    cdef TBranch* eSCPhi_branch
    cdef float eSCPhi_value

    cdef TBranch* eSCPhiWidth_branch
    cdef float eSCPhiWidth_value

    cdef TBranch* eSCPreshowerEnergy_branch
    cdef float eSCPreshowerEnergy_value

    cdef TBranch* eSCRawEnergy_branch
    cdef float eSCRawEnergy_value

    cdef TBranch* eSigmaIEtaIEta_branch
    cdef float eSigmaIEtaIEta_value

    cdef TBranch* eTightCountZH_branch
    cdef float eTightCountZH_value

    cdef TBranch* eToMETDPhi_branch
    cdef float eToMETDPhi_value

    cdef TBranch* eTrkIsoDR03_branch
    cdef float eTrkIsoDR03_value

    cdef TBranch* eVZ_branch
    cdef float eVZ_value

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

    cdef TBranch* eWWID_branch
    cdef float eWWID_value

    cdef TBranch* e_m1_CosThetaStar_branch
    cdef float e_m1_CosThetaStar_value

    cdef TBranch* e_m1_DPhi_branch
    cdef float e_m1_DPhi_value

    cdef TBranch* e_m1_DR_branch
    cdef float e_m1_DR_value

    cdef TBranch* e_m1_Eta_branch
    cdef float e_m1_Eta_value

    cdef TBranch* e_m1_Mass_branch
    cdef float e_m1_Mass_value

    cdef TBranch* e_m1_MassFsr_branch
    cdef float e_m1_MassFsr_value

    cdef TBranch* e_m1_PZeta_branch
    cdef float e_m1_PZeta_value

    cdef TBranch* e_m1_PZetaVis_branch
    cdef float e_m1_PZetaVis_value

    cdef TBranch* e_m1_Phi_branch
    cdef float e_m1_Phi_value

    cdef TBranch* e_m1_Pt_branch
    cdef float e_m1_Pt_value

    cdef TBranch* e_m1_PtFsr_branch
    cdef float e_m1_PtFsr_value

    cdef TBranch* e_m1_SS_branch
    cdef float e_m1_SS_value

    cdef TBranch* e_m1_SVfitEta_branch
    cdef float e_m1_SVfitEta_value

    cdef TBranch* e_m1_SVfitMass_branch
    cdef float e_m1_SVfitMass_value

    cdef TBranch* e_m1_SVfitPhi_branch
    cdef float e_m1_SVfitPhi_value

    cdef TBranch* e_m1_SVfitPt_branch
    cdef float e_m1_SVfitPt_value

    cdef TBranch* e_m1_ToMETDPhi_Ty1_branch
    cdef float e_m1_ToMETDPhi_Ty1_value

    cdef TBranch* e_m1_Zcompat_branch
    cdef float e_m1_Zcompat_value

    cdef TBranch* e_m2_CosThetaStar_branch
    cdef float e_m2_CosThetaStar_value

    cdef TBranch* e_m2_DPhi_branch
    cdef float e_m2_DPhi_value

    cdef TBranch* e_m2_DR_branch
    cdef float e_m2_DR_value

    cdef TBranch* e_m2_Eta_branch
    cdef float e_m2_Eta_value

    cdef TBranch* e_m2_Mass_branch
    cdef float e_m2_Mass_value

    cdef TBranch* e_m2_MassFsr_branch
    cdef float e_m2_MassFsr_value

    cdef TBranch* e_m2_PZeta_branch
    cdef float e_m2_PZeta_value

    cdef TBranch* e_m2_PZetaVis_branch
    cdef float e_m2_PZetaVis_value

    cdef TBranch* e_m2_Phi_branch
    cdef float e_m2_Phi_value

    cdef TBranch* e_m2_Pt_branch
    cdef float e_m2_Pt_value

    cdef TBranch* e_m2_PtFsr_branch
    cdef float e_m2_PtFsr_value

    cdef TBranch* e_m2_SS_branch
    cdef float e_m2_SS_value

    cdef TBranch* e_m2_ToMETDPhi_Ty1_branch
    cdef float e_m2_ToMETDPhi_Ty1_value

    cdef TBranch* e_m2_Zcompat_branch
    cdef float e_m2_Zcompat_value

    cdef TBranch* e_t_CosThetaStar_branch
    cdef float e_t_CosThetaStar_value

    cdef TBranch* e_t_DPhi_branch
    cdef float e_t_DPhi_value

    cdef TBranch* e_t_DR_branch
    cdef float e_t_DR_value

    cdef TBranch* e_t_Eta_branch
    cdef float e_t_Eta_value

    cdef TBranch* e_t_Mass_branch
    cdef float e_t_Mass_value

    cdef TBranch* e_t_MassFsr_branch
    cdef float e_t_MassFsr_value

    cdef TBranch* e_t_PZeta_branch
    cdef float e_t_PZeta_value

    cdef TBranch* e_t_PZetaVis_branch
    cdef float e_t_PZetaVis_value

    cdef TBranch* e_t_Phi_branch
    cdef float e_t_Phi_value

    cdef TBranch* e_t_Pt_branch
    cdef float e_t_Pt_value

    cdef TBranch* e_t_PtFsr_branch
    cdef float e_t_PtFsr_value

    cdef TBranch* e_t_SS_branch
    cdef float e_t_SS_value

    cdef TBranch* e_t_SVfitEta_branch
    cdef float e_t_SVfitEta_value

    cdef TBranch* e_t_SVfitMass_branch
    cdef float e_t_SVfitMass_value

    cdef TBranch* e_t_SVfitPhi_branch
    cdef float e_t_SVfitPhi_value

    cdef TBranch* e_t_SVfitPt_branch
    cdef float e_t_SVfitPt_value

    cdef TBranch* e_t_ToMETDPhi_Ty1_branch
    cdef float e_t_ToMETDPhi_Ty1_value

    cdef TBranch* e_t_Zcompat_branch
    cdef float e_t_Zcompat_value

    cdef TBranch* edECorrReg_2012Jul13ReReco_branch
    cdef float edECorrReg_2012Jul13ReReco_value

    cdef TBranch* edECorrReg_Fall11_branch
    cdef float edECorrReg_Fall11_value

    cdef TBranch* edECorrReg_Jan16ReReco_branch
    cdef float edECorrReg_Jan16ReReco_value

    cdef TBranch* edECorrReg_Summer12_DR53X_HCP2012_branch
    cdef float edECorrReg_Summer12_DR53X_HCP2012_value

    cdef TBranch* edECorrSmearedNoReg_2012Jul13ReReco_branch
    cdef float edECorrSmearedNoReg_2012Jul13ReReco_value

    cdef TBranch* edECorrSmearedNoReg_Fall11_branch
    cdef float edECorrSmearedNoReg_Fall11_value

    cdef TBranch* edECorrSmearedNoReg_Jan16ReReco_branch
    cdef float edECorrSmearedNoReg_Jan16ReReco_value

    cdef TBranch* edECorrSmearedNoReg_Summer12_DR53X_HCP2012_branch
    cdef float edECorrSmearedNoReg_Summer12_DR53X_HCP2012_value

    cdef TBranch* edECorrSmearedReg_2012Jul13ReReco_branch
    cdef float edECorrSmearedReg_2012Jul13ReReco_value

    cdef TBranch* edECorrSmearedReg_Fall11_branch
    cdef float edECorrSmearedReg_Fall11_value

    cdef TBranch* edECorrSmearedReg_Jan16ReReco_branch
    cdef float edECorrSmearedReg_Jan16ReReco_value

    cdef TBranch* edECorrSmearedReg_Summer12_DR53X_HCP2012_branch
    cdef float edECorrSmearedReg_Summer12_DR53X_HCP2012_value

    cdef TBranch* edeltaEtaSuperClusterTrackAtVtx_branch
    cdef float edeltaEtaSuperClusterTrackAtVtx_value

    cdef TBranch* edeltaPhiSuperClusterTrackAtVtx_branch
    cdef float edeltaPhiSuperClusterTrackAtVtx_value

    cdef TBranch* eeSuperClusterOverP_branch
    cdef float eeSuperClusterOverP_value

    cdef TBranch* eecalEnergy_branch
    cdef float eecalEnergy_value

    cdef TBranch* efBrem_branch
    cdef float efBrem_value

    cdef TBranch* etrackMomentumAtVtxP_branch
    cdef float etrackMomentumAtVtxP_value

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

    cdef TBranch* m2_t_SVfitEta_branch
    cdef float m2_t_SVfitEta_value

    cdef TBranch* m2_t_SVfitMass_branch
    cdef float m2_t_SVfitMass_value

    cdef TBranch* m2_t_SVfitPhi_branch
    cdef float m2_t_SVfitPhi_value

    cdef TBranch* m2_t_SVfitPt_branch
    cdef float m2_t_SVfitPt_value

    cdef TBranch* m2_t_ToMETDPhi_Ty1_branch
    cdef float m2_t_ToMETDPhi_Ty1_value

    cdef TBranch* m2_t_Zcompat_branch
    cdef float m2_t_Zcompat_value

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
            warnings.warn( "MuMuETauTree: Expected branch EmbPtWeight does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("EmbPtWeight")
        else:
            self.EmbPtWeight_branch.SetAddress(<void*>&self.EmbPtWeight_value)

        #print "making LT"
        self.LT_branch = the_tree.GetBranch("LT")
        #if not self.LT_branch and "LT" not in self.complained:
        if not self.LT_branch and "LT":
            warnings.warn( "MuMuETauTree: Expected branch LT does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("LT")
        else:
            self.LT_branch.SetAddress(<void*>&self.LT_value)

        #print "making Mass"
        self.Mass_branch = the_tree.GetBranch("Mass")
        #if not self.Mass_branch and "Mass" not in self.complained:
        if not self.Mass_branch and "Mass":
            warnings.warn( "MuMuETauTree: Expected branch Mass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Mass")
        else:
            self.Mass_branch.SetAddress(<void*>&self.Mass_value)

        #print "making MassError"
        self.MassError_branch = the_tree.GetBranch("MassError")
        #if not self.MassError_branch and "MassError" not in self.complained:
        if not self.MassError_branch and "MassError":
            warnings.warn( "MuMuETauTree: Expected branch MassError does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("MassError")
        else:
            self.MassError_branch.SetAddress(<void*>&self.MassError_value)

        #print "making MassErrord1"
        self.MassErrord1_branch = the_tree.GetBranch("MassErrord1")
        #if not self.MassErrord1_branch and "MassErrord1" not in self.complained:
        if not self.MassErrord1_branch and "MassErrord1":
            warnings.warn( "MuMuETauTree: Expected branch MassErrord1 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("MassErrord1")
        else:
            self.MassErrord1_branch.SetAddress(<void*>&self.MassErrord1_value)

        #print "making MassErrord2"
        self.MassErrord2_branch = the_tree.GetBranch("MassErrord2")
        #if not self.MassErrord2_branch and "MassErrord2" not in self.complained:
        if not self.MassErrord2_branch and "MassErrord2":
            warnings.warn( "MuMuETauTree: Expected branch MassErrord2 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("MassErrord2")
        else:
            self.MassErrord2_branch.SetAddress(<void*>&self.MassErrord2_value)

        #print "making MassErrord3"
        self.MassErrord3_branch = the_tree.GetBranch("MassErrord3")
        #if not self.MassErrord3_branch and "MassErrord3" not in self.complained:
        if not self.MassErrord3_branch and "MassErrord3":
            warnings.warn( "MuMuETauTree: Expected branch MassErrord3 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("MassErrord3")
        else:
            self.MassErrord3_branch.SetAddress(<void*>&self.MassErrord3_value)

        #print "making MassErrord4"
        self.MassErrord4_branch = the_tree.GetBranch("MassErrord4")
        #if not self.MassErrord4_branch and "MassErrord4" not in self.complained:
        if not self.MassErrord4_branch and "MassErrord4":
            warnings.warn( "MuMuETauTree: Expected branch MassErrord4 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("MassErrord4")
        else:
            self.MassErrord4_branch.SetAddress(<void*>&self.MassErrord4_value)

        #print "making NUP"
        self.NUP_branch = the_tree.GetBranch("NUP")
        #if not self.NUP_branch and "NUP" not in self.complained:
        if not self.NUP_branch and "NUP":
            warnings.warn( "MuMuETauTree: Expected branch NUP does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("NUP")
        else:
            self.NUP_branch.SetAddress(<void*>&self.NUP_value)

        #print "making Pt"
        self.Pt_branch = the_tree.GetBranch("Pt")
        #if not self.Pt_branch and "Pt" not in self.complained:
        if not self.Pt_branch and "Pt":
            warnings.warn( "MuMuETauTree: Expected branch Pt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Pt")
        else:
            self.Pt_branch.SetAddress(<void*>&self.Pt_value)

        #print "making bjetCSVVeto"
        self.bjetCSVVeto_branch = the_tree.GetBranch("bjetCSVVeto")
        #if not self.bjetCSVVeto_branch and "bjetCSVVeto" not in self.complained:
        if not self.bjetCSVVeto_branch and "bjetCSVVeto":
            warnings.warn( "MuMuETauTree: Expected branch bjetCSVVeto does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("bjetCSVVeto")
        else:
            self.bjetCSVVeto_branch.SetAddress(<void*>&self.bjetCSVVeto_value)

        #print "making bjetCSVVeto30"
        self.bjetCSVVeto30_branch = the_tree.GetBranch("bjetCSVVeto30")
        #if not self.bjetCSVVeto30_branch and "bjetCSVVeto30" not in self.complained:
        if not self.bjetCSVVeto30_branch and "bjetCSVVeto30":
            warnings.warn( "MuMuETauTree: Expected branch bjetCSVVeto30 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("bjetCSVVeto30")
        else:
            self.bjetCSVVeto30_branch.SetAddress(<void*>&self.bjetCSVVeto30_value)

        #print "making bjetCSVVetoZHLike"
        self.bjetCSVVetoZHLike_branch = the_tree.GetBranch("bjetCSVVetoZHLike")
        #if not self.bjetCSVVetoZHLike_branch and "bjetCSVVetoZHLike" not in self.complained:
        if not self.bjetCSVVetoZHLike_branch and "bjetCSVVetoZHLike":
            warnings.warn( "MuMuETauTree: Expected branch bjetCSVVetoZHLike does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("bjetCSVVetoZHLike")
        else:
            self.bjetCSVVetoZHLike_branch.SetAddress(<void*>&self.bjetCSVVetoZHLike_value)

        #print "making bjetCSVVetoZHLikeNoJetId"
        self.bjetCSVVetoZHLikeNoJetId_branch = the_tree.GetBranch("bjetCSVVetoZHLikeNoJetId")
        #if not self.bjetCSVVetoZHLikeNoJetId_branch and "bjetCSVVetoZHLikeNoJetId" not in self.complained:
        if not self.bjetCSVVetoZHLikeNoJetId_branch and "bjetCSVVetoZHLikeNoJetId":
            warnings.warn( "MuMuETauTree: Expected branch bjetCSVVetoZHLikeNoJetId does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("bjetCSVVetoZHLikeNoJetId")
        else:
            self.bjetCSVVetoZHLikeNoJetId_branch.SetAddress(<void*>&self.bjetCSVVetoZHLikeNoJetId_value)

        #print "making bjetCSVVetoZHLikeNoJetId_2"
        self.bjetCSVVetoZHLikeNoJetId_2_branch = the_tree.GetBranch("bjetCSVVetoZHLikeNoJetId_2")
        #if not self.bjetCSVVetoZHLikeNoJetId_2_branch and "bjetCSVVetoZHLikeNoJetId_2" not in self.complained:
        if not self.bjetCSVVetoZHLikeNoJetId_2_branch and "bjetCSVVetoZHLikeNoJetId_2":
            warnings.warn( "MuMuETauTree: Expected branch bjetCSVVetoZHLikeNoJetId_2 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("bjetCSVVetoZHLikeNoJetId_2")
        else:
            self.bjetCSVVetoZHLikeNoJetId_2_branch.SetAddress(<void*>&self.bjetCSVVetoZHLikeNoJetId_2_value)

        #print "making bjetTightCountZH"
        self.bjetTightCountZH_branch = the_tree.GetBranch("bjetTightCountZH")
        #if not self.bjetTightCountZH_branch and "bjetTightCountZH" not in self.complained:
        if not self.bjetTightCountZH_branch and "bjetTightCountZH":
            warnings.warn( "MuMuETauTree: Expected branch bjetTightCountZH does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("bjetTightCountZH")
        else:
            self.bjetTightCountZH_branch.SetAddress(<void*>&self.bjetTightCountZH_value)

        #print "making bjetVeto"
        self.bjetVeto_branch = the_tree.GetBranch("bjetVeto")
        #if not self.bjetVeto_branch and "bjetVeto" not in self.complained:
        if not self.bjetVeto_branch and "bjetVeto":
            warnings.warn( "MuMuETauTree: Expected branch bjetVeto does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("bjetVeto")
        else:
            self.bjetVeto_branch.SetAddress(<void*>&self.bjetVeto_value)

        #print "making charge"
        self.charge_branch = the_tree.GetBranch("charge")
        #if not self.charge_branch and "charge" not in self.complained:
        if not self.charge_branch and "charge":
            warnings.warn( "MuMuETauTree: Expected branch charge does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("charge")
        else:
            self.charge_branch.SetAddress(<void*>&self.charge_value)

        #print "making doubleEExtraGroup"
        self.doubleEExtraGroup_branch = the_tree.GetBranch("doubleEExtraGroup")
        #if not self.doubleEExtraGroup_branch and "doubleEExtraGroup" not in self.complained:
        if not self.doubleEExtraGroup_branch and "doubleEExtraGroup":
            warnings.warn( "MuMuETauTree: Expected branch doubleEExtraGroup does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleEExtraGroup")
        else:
            self.doubleEExtraGroup_branch.SetAddress(<void*>&self.doubleEExtraGroup_value)

        #print "making doubleEExtraPass"
        self.doubleEExtraPass_branch = the_tree.GetBranch("doubleEExtraPass")
        #if not self.doubleEExtraPass_branch and "doubleEExtraPass" not in self.complained:
        if not self.doubleEExtraPass_branch and "doubleEExtraPass":
            warnings.warn( "MuMuETauTree: Expected branch doubleEExtraPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleEExtraPass")
        else:
            self.doubleEExtraPass_branch.SetAddress(<void*>&self.doubleEExtraPass_value)

        #print "making doubleEExtraPrescale"
        self.doubleEExtraPrescale_branch = the_tree.GetBranch("doubleEExtraPrescale")
        #if not self.doubleEExtraPrescale_branch and "doubleEExtraPrescale" not in self.complained:
        if not self.doubleEExtraPrescale_branch and "doubleEExtraPrescale":
            warnings.warn( "MuMuETauTree: Expected branch doubleEExtraPrescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleEExtraPrescale")
        else:
            self.doubleEExtraPrescale_branch.SetAddress(<void*>&self.doubleEExtraPrescale_value)

        #print "making doubleEGroup"
        self.doubleEGroup_branch = the_tree.GetBranch("doubleEGroup")
        #if not self.doubleEGroup_branch and "doubleEGroup" not in self.complained:
        if not self.doubleEGroup_branch and "doubleEGroup":
            warnings.warn( "MuMuETauTree: Expected branch doubleEGroup does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleEGroup")
        else:
            self.doubleEGroup_branch.SetAddress(<void*>&self.doubleEGroup_value)

        #print "making doubleEPass"
        self.doubleEPass_branch = the_tree.GetBranch("doubleEPass")
        #if not self.doubleEPass_branch and "doubleEPass" not in self.complained:
        if not self.doubleEPass_branch and "doubleEPass":
            warnings.warn( "MuMuETauTree: Expected branch doubleEPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleEPass")
        else:
            self.doubleEPass_branch.SetAddress(<void*>&self.doubleEPass_value)

        #print "making doubleEPrescale"
        self.doubleEPrescale_branch = the_tree.GetBranch("doubleEPrescale")
        #if not self.doubleEPrescale_branch and "doubleEPrescale" not in self.complained:
        if not self.doubleEPrescale_branch and "doubleEPrescale":
            warnings.warn( "MuMuETauTree: Expected branch doubleEPrescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleEPrescale")
        else:
            self.doubleEPrescale_branch.SetAddress(<void*>&self.doubleEPrescale_value)

        #print "making doubleETightGroup"
        self.doubleETightGroup_branch = the_tree.GetBranch("doubleETightGroup")
        #if not self.doubleETightGroup_branch and "doubleETightGroup" not in self.complained:
        if not self.doubleETightGroup_branch and "doubleETightGroup":
            warnings.warn( "MuMuETauTree: Expected branch doubleETightGroup does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleETightGroup")
        else:
            self.doubleETightGroup_branch.SetAddress(<void*>&self.doubleETightGroup_value)

        #print "making doubleETightPass"
        self.doubleETightPass_branch = the_tree.GetBranch("doubleETightPass")
        #if not self.doubleETightPass_branch and "doubleETightPass" not in self.complained:
        if not self.doubleETightPass_branch and "doubleETightPass":
            warnings.warn( "MuMuETauTree: Expected branch doubleETightPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleETightPass")
        else:
            self.doubleETightPass_branch.SetAddress(<void*>&self.doubleETightPass_value)

        #print "making doubleETightPrescale"
        self.doubleETightPrescale_branch = the_tree.GetBranch("doubleETightPrescale")
        #if not self.doubleETightPrescale_branch and "doubleETightPrescale" not in self.complained:
        if not self.doubleETightPrescale_branch and "doubleETightPrescale":
            warnings.warn( "MuMuETauTree: Expected branch doubleETightPrescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleETightPrescale")
        else:
            self.doubleETightPrescale_branch.SetAddress(<void*>&self.doubleETightPrescale_value)

        #print "making doubleMuGroup"
        self.doubleMuGroup_branch = the_tree.GetBranch("doubleMuGroup")
        #if not self.doubleMuGroup_branch and "doubleMuGroup" not in self.complained:
        if not self.doubleMuGroup_branch and "doubleMuGroup":
            warnings.warn( "MuMuETauTree: Expected branch doubleMuGroup does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleMuGroup")
        else:
            self.doubleMuGroup_branch.SetAddress(<void*>&self.doubleMuGroup_value)

        #print "making doubleMuPass"
        self.doubleMuPass_branch = the_tree.GetBranch("doubleMuPass")
        #if not self.doubleMuPass_branch and "doubleMuPass" not in self.complained:
        if not self.doubleMuPass_branch and "doubleMuPass":
            warnings.warn( "MuMuETauTree: Expected branch doubleMuPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleMuPass")
        else:
            self.doubleMuPass_branch.SetAddress(<void*>&self.doubleMuPass_value)

        #print "making doubleMuPrescale"
        self.doubleMuPrescale_branch = the_tree.GetBranch("doubleMuPrescale")
        #if not self.doubleMuPrescale_branch and "doubleMuPrescale" not in self.complained:
        if not self.doubleMuPrescale_branch and "doubleMuPrescale":
            warnings.warn( "MuMuETauTree: Expected branch doubleMuPrescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleMuPrescale")
        else:
            self.doubleMuPrescale_branch.SetAddress(<void*>&self.doubleMuPrescale_value)

        #print "making doubleMuTrkGroup"
        self.doubleMuTrkGroup_branch = the_tree.GetBranch("doubleMuTrkGroup")
        #if not self.doubleMuTrkGroup_branch and "doubleMuTrkGroup" not in self.complained:
        if not self.doubleMuTrkGroup_branch and "doubleMuTrkGroup":
            warnings.warn( "MuMuETauTree: Expected branch doubleMuTrkGroup does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleMuTrkGroup")
        else:
            self.doubleMuTrkGroup_branch.SetAddress(<void*>&self.doubleMuTrkGroup_value)

        #print "making doubleMuTrkPass"
        self.doubleMuTrkPass_branch = the_tree.GetBranch("doubleMuTrkPass")
        #if not self.doubleMuTrkPass_branch and "doubleMuTrkPass" not in self.complained:
        if not self.doubleMuTrkPass_branch and "doubleMuTrkPass":
            warnings.warn( "MuMuETauTree: Expected branch doubleMuTrkPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleMuTrkPass")
        else:
            self.doubleMuTrkPass_branch.SetAddress(<void*>&self.doubleMuTrkPass_value)

        #print "making doubleMuTrkPrescale"
        self.doubleMuTrkPrescale_branch = the_tree.GetBranch("doubleMuTrkPrescale")
        #if not self.doubleMuTrkPrescale_branch and "doubleMuTrkPrescale" not in self.complained:
        if not self.doubleMuTrkPrescale_branch and "doubleMuTrkPrescale":
            warnings.warn( "MuMuETauTree: Expected branch doubleMuTrkPrescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleMuTrkPrescale")
        else:
            self.doubleMuTrkPrescale_branch.SetAddress(<void*>&self.doubleMuTrkPrescale_value)

        #print "making doublePhoGroup"
        self.doublePhoGroup_branch = the_tree.GetBranch("doublePhoGroup")
        #if not self.doublePhoGroup_branch and "doublePhoGroup" not in self.complained:
        if not self.doublePhoGroup_branch and "doublePhoGroup":
            warnings.warn( "MuMuETauTree: Expected branch doublePhoGroup does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doublePhoGroup")
        else:
            self.doublePhoGroup_branch.SetAddress(<void*>&self.doublePhoGroup_value)

        #print "making doublePhoPass"
        self.doublePhoPass_branch = the_tree.GetBranch("doublePhoPass")
        #if not self.doublePhoPass_branch and "doublePhoPass" not in self.complained:
        if not self.doublePhoPass_branch and "doublePhoPass":
            warnings.warn( "MuMuETauTree: Expected branch doublePhoPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doublePhoPass")
        else:
            self.doublePhoPass_branch.SetAddress(<void*>&self.doublePhoPass_value)

        #print "making doublePhoPrescale"
        self.doublePhoPrescale_branch = the_tree.GetBranch("doublePhoPrescale")
        #if not self.doublePhoPrescale_branch and "doublePhoPrescale" not in self.complained:
        if not self.doublePhoPrescale_branch and "doublePhoPrescale":
            warnings.warn( "MuMuETauTree: Expected branch doublePhoPrescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doublePhoPrescale")
        else:
            self.doublePhoPrescale_branch.SetAddress(<void*>&self.doublePhoPrescale_value)

        #print "making eAbsEta"
        self.eAbsEta_branch = the_tree.GetBranch("eAbsEta")
        #if not self.eAbsEta_branch and "eAbsEta" not in self.complained:
        if not self.eAbsEta_branch and "eAbsEta":
            warnings.warn( "MuMuETauTree: Expected branch eAbsEta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eAbsEta")
        else:
            self.eAbsEta_branch.SetAddress(<void*>&self.eAbsEta_value)

        #print "making eCBID_LOOSE"
        self.eCBID_LOOSE_branch = the_tree.GetBranch("eCBID_LOOSE")
        #if not self.eCBID_LOOSE_branch and "eCBID_LOOSE" not in self.complained:
        if not self.eCBID_LOOSE_branch and "eCBID_LOOSE":
            warnings.warn( "MuMuETauTree: Expected branch eCBID_LOOSE does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eCBID_LOOSE")
        else:
            self.eCBID_LOOSE_branch.SetAddress(<void*>&self.eCBID_LOOSE_value)

        #print "making eCBID_MEDIUM"
        self.eCBID_MEDIUM_branch = the_tree.GetBranch("eCBID_MEDIUM")
        #if not self.eCBID_MEDIUM_branch and "eCBID_MEDIUM" not in self.complained:
        if not self.eCBID_MEDIUM_branch and "eCBID_MEDIUM":
            warnings.warn( "MuMuETauTree: Expected branch eCBID_MEDIUM does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eCBID_MEDIUM")
        else:
            self.eCBID_MEDIUM_branch.SetAddress(<void*>&self.eCBID_MEDIUM_value)

        #print "making eCBID_TIGHT"
        self.eCBID_TIGHT_branch = the_tree.GetBranch("eCBID_TIGHT")
        #if not self.eCBID_TIGHT_branch and "eCBID_TIGHT" not in self.complained:
        if not self.eCBID_TIGHT_branch and "eCBID_TIGHT":
            warnings.warn( "MuMuETauTree: Expected branch eCBID_TIGHT does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eCBID_TIGHT")
        else:
            self.eCBID_TIGHT_branch.SetAddress(<void*>&self.eCBID_TIGHT_value)

        #print "making eCBID_VETO"
        self.eCBID_VETO_branch = the_tree.GetBranch("eCBID_VETO")
        #if not self.eCBID_VETO_branch and "eCBID_VETO" not in self.complained:
        if not self.eCBID_VETO_branch and "eCBID_VETO":
            warnings.warn( "MuMuETauTree: Expected branch eCBID_VETO does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eCBID_VETO")
        else:
            self.eCBID_VETO_branch.SetAddress(<void*>&self.eCBID_VETO_value)

        #print "making eCharge"
        self.eCharge_branch = the_tree.GetBranch("eCharge")
        #if not self.eCharge_branch and "eCharge" not in self.complained:
        if not self.eCharge_branch and "eCharge":
            warnings.warn( "MuMuETauTree: Expected branch eCharge does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eCharge")
        else:
            self.eCharge_branch.SetAddress(<void*>&self.eCharge_value)

        #print "making eChargeIdLoose"
        self.eChargeIdLoose_branch = the_tree.GetBranch("eChargeIdLoose")
        #if not self.eChargeIdLoose_branch and "eChargeIdLoose" not in self.complained:
        if not self.eChargeIdLoose_branch and "eChargeIdLoose":
            warnings.warn( "MuMuETauTree: Expected branch eChargeIdLoose does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eChargeIdLoose")
        else:
            self.eChargeIdLoose_branch.SetAddress(<void*>&self.eChargeIdLoose_value)

        #print "making eChargeIdMed"
        self.eChargeIdMed_branch = the_tree.GetBranch("eChargeIdMed")
        #if not self.eChargeIdMed_branch and "eChargeIdMed" not in self.complained:
        if not self.eChargeIdMed_branch and "eChargeIdMed":
            warnings.warn( "MuMuETauTree: Expected branch eChargeIdMed does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eChargeIdMed")
        else:
            self.eChargeIdMed_branch.SetAddress(<void*>&self.eChargeIdMed_value)

        #print "making eChargeIdTight"
        self.eChargeIdTight_branch = the_tree.GetBranch("eChargeIdTight")
        #if not self.eChargeIdTight_branch and "eChargeIdTight" not in self.complained:
        if not self.eChargeIdTight_branch and "eChargeIdTight":
            warnings.warn( "MuMuETauTree: Expected branch eChargeIdTight does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eChargeIdTight")
        else:
            self.eChargeIdTight_branch.SetAddress(<void*>&self.eChargeIdTight_value)

        #print "making eCiCTight"
        self.eCiCTight_branch = the_tree.GetBranch("eCiCTight")
        #if not self.eCiCTight_branch and "eCiCTight" not in self.complained:
        if not self.eCiCTight_branch and "eCiCTight":
            warnings.warn( "MuMuETauTree: Expected branch eCiCTight does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eCiCTight")
        else:
            self.eCiCTight_branch.SetAddress(<void*>&self.eCiCTight_value)

        #print "making eComesFromHiggs"
        self.eComesFromHiggs_branch = the_tree.GetBranch("eComesFromHiggs")
        #if not self.eComesFromHiggs_branch and "eComesFromHiggs" not in self.complained:
        if not self.eComesFromHiggs_branch and "eComesFromHiggs":
            warnings.warn( "MuMuETauTree: Expected branch eComesFromHiggs does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eComesFromHiggs")
        else:
            self.eComesFromHiggs_branch.SetAddress(<void*>&self.eComesFromHiggs_value)

        #print "making eDZ"
        self.eDZ_branch = the_tree.GetBranch("eDZ")
        #if not self.eDZ_branch and "eDZ" not in self.complained:
        if not self.eDZ_branch and "eDZ":
            warnings.warn( "MuMuETauTree: Expected branch eDZ does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eDZ")
        else:
            self.eDZ_branch.SetAddress(<void*>&self.eDZ_value)

        #print "making eE1x5"
        self.eE1x5_branch = the_tree.GetBranch("eE1x5")
        #if not self.eE1x5_branch and "eE1x5" not in self.complained:
        if not self.eE1x5_branch and "eE1x5":
            warnings.warn( "MuMuETauTree: Expected branch eE1x5 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eE1x5")
        else:
            self.eE1x5_branch.SetAddress(<void*>&self.eE1x5_value)

        #print "making eE2x5Max"
        self.eE2x5Max_branch = the_tree.GetBranch("eE2x5Max")
        #if not self.eE2x5Max_branch and "eE2x5Max" not in self.complained:
        if not self.eE2x5Max_branch and "eE2x5Max":
            warnings.warn( "MuMuETauTree: Expected branch eE2x5Max does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eE2x5Max")
        else:
            self.eE2x5Max_branch.SetAddress(<void*>&self.eE2x5Max_value)

        #print "making eE5x5"
        self.eE5x5_branch = the_tree.GetBranch("eE5x5")
        #if not self.eE5x5_branch and "eE5x5" not in self.complained:
        if not self.eE5x5_branch and "eE5x5":
            warnings.warn( "MuMuETauTree: Expected branch eE5x5 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eE5x5")
        else:
            self.eE5x5_branch.SetAddress(<void*>&self.eE5x5_value)

        #print "making eECorrReg_2012Jul13ReReco"
        self.eECorrReg_2012Jul13ReReco_branch = the_tree.GetBranch("eECorrReg_2012Jul13ReReco")
        #if not self.eECorrReg_2012Jul13ReReco_branch and "eECorrReg_2012Jul13ReReco" not in self.complained:
        if not self.eECorrReg_2012Jul13ReReco_branch and "eECorrReg_2012Jul13ReReco":
            warnings.warn( "MuMuETauTree: Expected branch eECorrReg_2012Jul13ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eECorrReg_2012Jul13ReReco")
        else:
            self.eECorrReg_2012Jul13ReReco_branch.SetAddress(<void*>&self.eECorrReg_2012Jul13ReReco_value)

        #print "making eECorrReg_Fall11"
        self.eECorrReg_Fall11_branch = the_tree.GetBranch("eECorrReg_Fall11")
        #if not self.eECorrReg_Fall11_branch and "eECorrReg_Fall11" not in self.complained:
        if not self.eECorrReg_Fall11_branch and "eECorrReg_Fall11":
            warnings.warn( "MuMuETauTree: Expected branch eECorrReg_Fall11 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eECorrReg_Fall11")
        else:
            self.eECorrReg_Fall11_branch.SetAddress(<void*>&self.eECorrReg_Fall11_value)

        #print "making eECorrReg_Jan16ReReco"
        self.eECorrReg_Jan16ReReco_branch = the_tree.GetBranch("eECorrReg_Jan16ReReco")
        #if not self.eECorrReg_Jan16ReReco_branch and "eECorrReg_Jan16ReReco" not in self.complained:
        if not self.eECorrReg_Jan16ReReco_branch and "eECorrReg_Jan16ReReco":
            warnings.warn( "MuMuETauTree: Expected branch eECorrReg_Jan16ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eECorrReg_Jan16ReReco")
        else:
            self.eECorrReg_Jan16ReReco_branch.SetAddress(<void*>&self.eECorrReg_Jan16ReReco_value)

        #print "making eECorrReg_Summer12_DR53X_HCP2012"
        self.eECorrReg_Summer12_DR53X_HCP2012_branch = the_tree.GetBranch("eECorrReg_Summer12_DR53X_HCP2012")
        #if not self.eECorrReg_Summer12_DR53X_HCP2012_branch and "eECorrReg_Summer12_DR53X_HCP2012" not in self.complained:
        if not self.eECorrReg_Summer12_DR53X_HCP2012_branch and "eECorrReg_Summer12_DR53X_HCP2012":
            warnings.warn( "MuMuETauTree: Expected branch eECorrReg_Summer12_DR53X_HCP2012 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eECorrReg_Summer12_DR53X_HCP2012")
        else:
            self.eECorrReg_Summer12_DR53X_HCP2012_branch.SetAddress(<void*>&self.eECorrReg_Summer12_DR53X_HCP2012_value)

        #print "making eECorrSmearedNoReg_2012Jul13ReReco"
        self.eECorrSmearedNoReg_2012Jul13ReReco_branch = the_tree.GetBranch("eECorrSmearedNoReg_2012Jul13ReReco")
        #if not self.eECorrSmearedNoReg_2012Jul13ReReco_branch and "eECorrSmearedNoReg_2012Jul13ReReco" not in self.complained:
        if not self.eECorrSmearedNoReg_2012Jul13ReReco_branch and "eECorrSmearedNoReg_2012Jul13ReReco":
            warnings.warn( "MuMuETauTree: Expected branch eECorrSmearedNoReg_2012Jul13ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eECorrSmearedNoReg_2012Jul13ReReco")
        else:
            self.eECorrSmearedNoReg_2012Jul13ReReco_branch.SetAddress(<void*>&self.eECorrSmearedNoReg_2012Jul13ReReco_value)

        #print "making eECorrSmearedNoReg_Fall11"
        self.eECorrSmearedNoReg_Fall11_branch = the_tree.GetBranch("eECorrSmearedNoReg_Fall11")
        #if not self.eECorrSmearedNoReg_Fall11_branch and "eECorrSmearedNoReg_Fall11" not in self.complained:
        if not self.eECorrSmearedNoReg_Fall11_branch and "eECorrSmearedNoReg_Fall11":
            warnings.warn( "MuMuETauTree: Expected branch eECorrSmearedNoReg_Fall11 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eECorrSmearedNoReg_Fall11")
        else:
            self.eECorrSmearedNoReg_Fall11_branch.SetAddress(<void*>&self.eECorrSmearedNoReg_Fall11_value)

        #print "making eECorrSmearedNoReg_Jan16ReReco"
        self.eECorrSmearedNoReg_Jan16ReReco_branch = the_tree.GetBranch("eECorrSmearedNoReg_Jan16ReReco")
        #if not self.eECorrSmearedNoReg_Jan16ReReco_branch and "eECorrSmearedNoReg_Jan16ReReco" not in self.complained:
        if not self.eECorrSmearedNoReg_Jan16ReReco_branch and "eECorrSmearedNoReg_Jan16ReReco":
            warnings.warn( "MuMuETauTree: Expected branch eECorrSmearedNoReg_Jan16ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eECorrSmearedNoReg_Jan16ReReco")
        else:
            self.eECorrSmearedNoReg_Jan16ReReco_branch.SetAddress(<void*>&self.eECorrSmearedNoReg_Jan16ReReco_value)

        #print "making eECorrSmearedNoReg_Summer12_DR53X_HCP2012"
        self.eECorrSmearedNoReg_Summer12_DR53X_HCP2012_branch = the_tree.GetBranch("eECorrSmearedNoReg_Summer12_DR53X_HCP2012")
        #if not self.eECorrSmearedNoReg_Summer12_DR53X_HCP2012_branch and "eECorrSmearedNoReg_Summer12_DR53X_HCP2012" not in self.complained:
        if not self.eECorrSmearedNoReg_Summer12_DR53X_HCP2012_branch and "eECorrSmearedNoReg_Summer12_DR53X_HCP2012":
            warnings.warn( "MuMuETauTree: Expected branch eECorrSmearedNoReg_Summer12_DR53X_HCP2012 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eECorrSmearedNoReg_Summer12_DR53X_HCP2012")
        else:
            self.eECorrSmearedNoReg_Summer12_DR53X_HCP2012_branch.SetAddress(<void*>&self.eECorrSmearedNoReg_Summer12_DR53X_HCP2012_value)

        #print "making eECorrSmearedReg_2012Jul13ReReco"
        self.eECorrSmearedReg_2012Jul13ReReco_branch = the_tree.GetBranch("eECorrSmearedReg_2012Jul13ReReco")
        #if not self.eECorrSmearedReg_2012Jul13ReReco_branch and "eECorrSmearedReg_2012Jul13ReReco" not in self.complained:
        if not self.eECorrSmearedReg_2012Jul13ReReco_branch and "eECorrSmearedReg_2012Jul13ReReco":
            warnings.warn( "MuMuETauTree: Expected branch eECorrSmearedReg_2012Jul13ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eECorrSmearedReg_2012Jul13ReReco")
        else:
            self.eECorrSmearedReg_2012Jul13ReReco_branch.SetAddress(<void*>&self.eECorrSmearedReg_2012Jul13ReReco_value)

        #print "making eECorrSmearedReg_Fall11"
        self.eECorrSmearedReg_Fall11_branch = the_tree.GetBranch("eECorrSmearedReg_Fall11")
        #if not self.eECorrSmearedReg_Fall11_branch and "eECorrSmearedReg_Fall11" not in self.complained:
        if not self.eECorrSmearedReg_Fall11_branch and "eECorrSmearedReg_Fall11":
            warnings.warn( "MuMuETauTree: Expected branch eECorrSmearedReg_Fall11 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eECorrSmearedReg_Fall11")
        else:
            self.eECorrSmearedReg_Fall11_branch.SetAddress(<void*>&self.eECorrSmearedReg_Fall11_value)

        #print "making eECorrSmearedReg_Jan16ReReco"
        self.eECorrSmearedReg_Jan16ReReco_branch = the_tree.GetBranch("eECorrSmearedReg_Jan16ReReco")
        #if not self.eECorrSmearedReg_Jan16ReReco_branch and "eECorrSmearedReg_Jan16ReReco" not in self.complained:
        if not self.eECorrSmearedReg_Jan16ReReco_branch and "eECorrSmearedReg_Jan16ReReco":
            warnings.warn( "MuMuETauTree: Expected branch eECorrSmearedReg_Jan16ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eECorrSmearedReg_Jan16ReReco")
        else:
            self.eECorrSmearedReg_Jan16ReReco_branch.SetAddress(<void*>&self.eECorrSmearedReg_Jan16ReReco_value)

        #print "making eECorrSmearedReg_Summer12_DR53X_HCP2012"
        self.eECorrSmearedReg_Summer12_DR53X_HCP2012_branch = the_tree.GetBranch("eECorrSmearedReg_Summer12_DR53X_HCP2012")
        #if not self.eECorrSmearedReg_Summer12_DR53X_HCP2012_branch and "eECorrSmearedReg_Summer12_DR53X_HCP2012" not in self.complained:
        if not self.eECorrSmearedReg_Summer12_DR53X_HCP2012_branch and "eECorrSmearedReg_Summer12_DR53X_HCP2012":
            warnings.warn( "MuMuETauTree: Expected branch eECorrSmearedReg_Summer12_DR53X_HCP2012 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eECorrSmearedReg_Summer12_DR53X_HCP2012")
        else:
            self.eECorrSmearedReg_Summer12_DR53X_HCP2012_branch.SetAddress(<void*>&self.eECorrSmearedReg_Summer12_DR53X_HCP2012_value)

        #print "making eEcalIsoDR03"
        self.eEcalIsoDR03_branch = the_tree.GetBranch("eEcalIsoDR03")
        #if not self.eEcalIsoDR03_branch and "eEcalIsoDR03" not in self.complained:
        if not self.eEcalIsoDR03_branch and "eEcalIsoDR03":
            warnings.warn( "MuMuETauTree: Expected branch eEcalIsoDR03 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eEcalIsoDR03")
        else:
            self.eEcalIsoDR03_branch.SetAddress(<void*>&self.eEcalIsoDR03_value)

        #print "making eEffectiveArea2011Data"
        self.eEffectiveArea2011Data_branch = the_tree.GetBranch("eEffectiveArea2011Data")
        #if not self.eEffectiveArea2011Data_branch and "eEffectiveArea2011Data" not in self.complained:
        if not self.eEffectiveArea2011Data_branch and "eEffectiveArea2011Data":
            warnings.warn( "MuMuETauTree: Expected branch eEffectiveArea2011Data does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eEffectiveArea2011Data")
        else:
            self.eEffectiveArea2011Data_branch.SetAddress(<void*>&self.eEffectiveArea2011Data_value)

        #print "making eEffectiveArea2012Data"
        self.eEffectiveArea2012Data_branch = the_tree.GetBranch("eEffectiveArea2012Data")
        #if not self.eEffectiveArea2012Data_branch and "eEffectiveArea2012Data" not in self.complained:
        if not self.eEffectiveArea2012Data_branch and "eEffectiveArea2012Data":
            warnings.warn( "MuMuETauTree: Expected branch eEffectiveArea2012Data does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eEffectiveArea2012Data")
        else:
            self.eEffectiveArea2012Data_branch.SetAddress(<void*>&self.eEffectiveArea2012Data_value)

        #print "making eEffectiveAreaFall11MC"
        self.eEffectiveAreaFall11MC_branch = the_tree.GetBranch("eEffectiveAreaFall11MC")
        #if not self.eEffectiveAreaFall11MC_branch and "eEffectiveAreaFall11MC" not in self.complained:
        if not self.eEffectiveAreaFall11MC_branch and "eEffectiveAreaFall11MC":
            warnings.warn( "MuMuETauTree: Expected branch eEffectiveAreaFall11MC does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eEffectiveAreaFall11MC")
        else:
            self.eEffectiveAreaFall11MC_branch.SetAddress(<void*>&self.eEffectiveAreaFall11MC_value)

        #print "making eEle27WP80PFMT50PFMTFilter"
        self.eEle27WP80PFMT50PFMTFilter_branch = the_tree.GetBranch("eEle27WP80PFMT50PFMTFilter")
        #if not self.eEle27WP80PFMT50PFMTFilter_branch and "eEle27WP80PFMT50PFMTFilter" not in self.complained:
        if not self.eEle27WP80PFMT50PFMTFilter_branch and "eEle27WP80PFMT50PFMTFilter":
            warnings.warn( "MuMuETauTree: Expected branch eEle27WP80PFMT50PFMTFilter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eEle27WP80PFMT50PFMTFilter")
        else:
            self.eEle27WP80PFMT50PFMTFilter_branch.SetAddress(<void*>&self.eEle27WP80PFMT50PFMTFilter_value)

        #print "making eEle27WP80TrackIsoMatchFilter"
        self.eEle27WP80TrackIsoMatchFilter_branch = the_tree.GetBranch("eEle27WP80TrackIsoMatchFilter")
        #if not self.eEle27WP80TrackIsoMatchFilter_branch and "eEle27WP80TrackIsoMatchFilter" not in self.complained:
        if not self.eEle27WP80TrackIsoMatchFilter_branch and "eEle27WP80TrackIsoMatchFilter":
            warnings.warn( "MuMuETauTree: Expected branch eEle27WP80TrackIsoMatchFilter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eEle27WP80TrackIsoMatchFilter")
        else:
            self.eEle27WP80TrackIsoMatchFilter_branch.SetAddress(<void*>&self.eEle27WP80TrackIsoMatchFilter_value)

        #print "making eEle32WP70PFMT50PFMTFilter"
        self.eEle32WP70PFMT50PFMTFilter_branch = the_tree.GetBranch("eEle32WP70PFMT50PFMTFilter")
        #if not self.eEle32WP70PFMT50PFMTFilter_branch and "eEle32WP70PFMT50PFMTFilter" not in self.complained:
        if not self.eEle32WP70PFMT50PFMTFilter_branch and "eEle32WP70PFMT50PFMTFilter":
            warnings.warn( "MuMuETauTree: Expected branch eEle32WP70PFMT50PFMTFilter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eEle32WP70PFMT50PFMTFilter")
        else:
            self.eEle32WP70PFMT50PFMTFilter_branch.SetAddress(<void*>&self.eEle32WP70PFMT50PFMTFilter_value)

        #print "making eEnergyError"
        self.eEnergyError_branch = the_tree.GetBranch("eEnergyError")
        #if not self.eEnergyError_branch and "eEnergyError" not in self.complained:
        if not self.eEnergyError_branch and "eEnergyError":
            warnings.warn( "MuMuETauTree: Expected branch eEnergyError does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eEnergyError")
        else:
            self.eEnergyError_branch.SetAddress(<void*>&self.eEnergyError_value)

        #print "making eEta"
        self.eEta_branch = the_tree.GetBranch("eEta")
        #if not self.eEta_branch and "eEta" not in self.complained:
        if not self.eEta_branch and "eEta":
            warnings.warn( "MuMuETauTree: Expected branch eEta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eEta")
        else:
            self.eEta_branch.SetAddress(<void*>&self.eEta_value)

        #print "making eEtaCorrReg_2012Jul13ReReco"
        self.eEtaCorrReg_2012Jul13ReReco_branch = the_tree.GetBranch("eEtaCorrReg_2012Jul13ReReco")
        #if not self.eEtaCorrReg_2012Jul13ReReco_branch and "eEtaCorrReg_2012Jul13ReReco" not in self.complained:
        if not self.eEtaCorrReg_2012Jul13ReReco_branch and "eEtaCorrReg_2012Jul13ReReco":
            warnings.warn( "MuMuETauTree: Expected branch eEtaCorrReg_2012Jul13ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eEtaCorrReg_2012Jul13ReReco")
        else:
            self.eEtaCorrReg_2012Jul13ReReco_branch.SetAddress(<void*>&self.eEtaCorrReg_2012Jul13ReReco_value)

        #print "making eEtaCorrReg_Fall11"
        self.eEtaCorrReg_Fall11_branch = the_tree.GetBranch("eEtaCorrReg_Fall11")
        #if not self.eEtaCorrReg_Fall11_branch and "eEtaCorrReg_Fall11" not in self.complained:
        if not self.eEtaCorrReg_Fall11_branch and "eEtaCorrReg_Fall11":
            warnings.warn( "MuMuETauTree: Expected branch eEtaCorrReg_Fall11 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eEtaCorrReg_Fall11")
        else:
            self.eEtaCorrReg_Fall11_branch.SetAddress(<void*>&self.eEtaCorrReg_Fall11_value)

        #print "making eEtaCorrReg_Jan16ReReco"
        self.eEtaCorrReg_Jan16ReReco_branch = the_tree.GetBranch("eEtaCorrReg_Jan16ReReco")
        #if not self.eEtaCorrReg_Jan16ReReco_branch and "eEtaCorrReg_Jan16ReReco" not in self.complained:
        if not self.eEtaCorrReg_Jan16ReReco_branch and "eEtaCorrReg_Jan16ReReco":
            warnings.warn( "MuMuETauTree: Expected branch eEtaCorrReg_Jan16ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eEtaCorrReg_Jan16ReReco")
        else:
            self.eEtaCorrReg_Jan16ReReco_branch.SetAddress(<void*>&self.eEtaCorrReg_Jan16ReReco_value)

        #print "making eEtaCorrReg_Summer12_DR53X_HCP2012"
        self.eEtaCorrReg_Summer12_DR53X_HCP2012_branch = the_tree.GetBranch("eEtaCorrReg_Summer12_DR53X_HCP2012")
        #if not self.eEtaCorrReg_Summer12_DR53X_HCP2012_branch and "eEtaCorrReg_Summer12_DR53X_HCP2012" not in self.complained:
        if not self.eEtaCorrReg_Summer12_DR53X_HCP2012_branch and "eEtaCorrReg_Summer12_DR53X_HCP2012":
            warnings.warn( "MuMuETauTree: Expected branch eEtaCorrReg_Summer12_DR53X_HCP2012 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eEtaCorrReg_Summer12_DR53X_HCP2012")
        else:
            self.eEtaCorrReg_Summer12_DR53X_HCP2012_branch.SetAddress(<void*>&self.eEtaCorrReg_Summer12_DR53X_HCP2012_value)

        #print "making eEtaCorrSmearedNoReg_2012Jul13ReReco"
        self.eEtaCorrSmearedNoReg_2012Jul13ReReco_branch = the_tree.GetBranch("eEtaCorrSmearedNoReg_2012Jul13ReReco")
        #if not self.eEtaCorrSmearedNoReg_2012Jul13ReReco_branch and "eEtaCorrSmearedNoReg_2012Jul13ReReco" not in self.complained:
        if not self.eEtaCorrSmearedNoReg_2012Jul13ReReco_branch and "eEtaCorrSmearedNoReg_2012Jul13ReReco":
            warnings.warn( "MuMuETauTree: Expected branch eEtaCorrSmearedNoReg_2012Jul13ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eEtaCorrSmearedNoReg_2012Jul13ReReco")
        else:
            self.eEtaCorrSmearedNoReg_2012Jul13ReReco_branch.SetAddress(<void*>&self.eEtaCorrSmearedNoReg_2012Jul13ReReco_value)

        #print "making eEtaCorrSmearedNoReg_Fall11"
        self.eEtaCorrSmearedNoReg_Fall11_branch = the_tree.GetBranch("eEtaCorrSmearedNoReg_Fall11")
        #if not self.eEtaCorrSmearedNoReg_Fall11_branch and "eEtaCorrSmearedNoReg_Fall11" not in self.complained:
        if not self.eEtaCorrSmearedNoReg_Fall11_branch and "eEtaCorrSmearedNoReg_Fall11":
            warnings.warn( "MuMuETauTree: Expected branch eEtaCorrSmearedNoReg_Fall11 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eEtaCorrSmearedNoReg_Fall11")
        else:
            self.eEtaCorrSmearedNoReg_Fall11_branch.SetAddress(<void*>&self.eEtaCorrSmearedNoReg_Fall11_value)

        #print "making eEtaCorrSmearedNoReg_Jan16ReReco"
        self.eEtaCorrSmearedNoReg_Jan16ReReco_branch = the_tree.GetBranch("eEtaCorrSmearedNoReg_Jan16ReReco")
        #if not self.eEtaCorrSmearedNoReg_Jan16ReReco_branch and "eEtaCorrSmearedNoReg_Jan16ReReco" not in self.complained:
        if not self.eEtaCorrSmearedNoReg_Jan16ReReco_branch and "eEtaCorrSmearedNoReg_Jan16ReReco":
            warnings.warn( "MuMuETauTree: Expected branch eEtaCorrSmearedNoReg_Jan16ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eEtaCorrSmearedNoReg_Jan16ReReco")
        else:
            self.eEtaCorrSmearedNoReg_Jan16ReReco_branch.SetAddress(<void*>&self.eEtaCorrSmearedNoReg_Jan16ReReco_value)

        #print "making eEtaCorrSmearedNoReg_Summer12_DR53X_HCP2012"
        self.eEtaCorrSmearedNoReg_Summer12_DR53X_HCP2012_branch = the_tree.GetBranch("eEtaCorrSmearedNoReg_Summer12_DR53X_HCP2012")
        #if not self.eEtaCorrSmearedNoReg_Summer12_DR53X_HCP2012_branch and "eEtaCorrSmearedNoReg_Summer12_DR53X_HCP2012" not in self.complained:
        if not self.eEtaCorrSmearedNoReg_Summer12_DR53X_HCP2012_branch and "eEtaCorrSmearedNoReg_Summer12_DR53X_HCP2012":
            warnings.warn( "MuMuETauTree: Expected branch eEtaCorrSmearedNoReg_Summer12_DR53X_HCP2012 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eEtaCorrSmearedNoReg_Summer12_DR53X_HCP2012")
        else:
            self.eEtaCorrSmearedNoReg_Summer12_DR53X_HCP2012_branch.SetAddress(<void*>&self.eEtaCorrSmearedNoReg_Summer12_DR53X_HCP2012_value)

        #print "making eEtaCorrSmearedReg_2012Jul13ReReco"
        self.eEtaCorrSmearedReg_2012Jul13ReReco_branch = the_tree.GetBranch("eEtaCorrSmearedReg_2012Jul13ReReco")
        #if not self.eEtaCorrSmearedReg_2012Jul13ReReco_branch and "eEtaCorrSmearedReg_2012Jul13ReReco" not in self.complained:
        if not self.eEtaCorrSmearedReg_2012Jul13ReReco_branch and "eEtaCorrSmearedReg_2012Jul13ReReco":
            warnings.warn( "MuMuETauTree: Expected branch eEtaCorrSmearedReg_2012Jul13ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eEtaCorrSmearedReg_2012Jul13ReReco")
        else:
            self.eEtaCorrSmearedReg_2012Jul13ReReco_branch.SetAddress(<void*>&self.eEtaCorrSmearedReg_2012Jul13ReReco_value)

        #print "making eEtaCorrSmearedReg_Fall11"
        self.eEtaCorrSmearedReg_Fall11_branch = the_tree.GetBranch("eEtaCorrSmearedReg_Fall11")
        #if not self.eEtaCorrSmearedReg_Fall11_branch and "eEtaCorrSmearedReg_Fall11" not in self.complained:
        if not self.eEtaCorrSmearedReg_Fall11_branch and "eEtaCorrSmearedReg_Fall11":
            warnings.warn( "MuMuETauTree: Expected branch eEtaCorrSmearedReg_Fall11 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eEtaCorrSmearedReg_Fall11")
        else:
            self.eEtaCorrSmearedReg_Fall11_branch.SetAddress(<void*>&self.eEtaCorrSmearedReg_Fall11_value)

        #print "making eEtaCorrSmearedReg_Jan16ReReco"
        self.eEtaCorrSmearedReg_Jan16ReReco_branch = the_tree.GetBranch("eEtaCorrSmearedReg_Jan16ReReco")
        #if not self.eEtaCorrSmearedReg_Jan16ReReco_branch and "eEtaCorrSmearedReg_Jan16ReReco" not in self.complained:
        if not self.eEtaCorrSmearedReg_Jan16ReReco_branch and "eEtaCorrSmearedReg_Jan16ReReco":
            warnings.warn( "MuMuETauTree: Expected branch eEtaCorrSmearedReg_Jan16ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eEtaCorrSmearedReg_Jan16ReReco")
        else:
            self.eEtaCorrSmearedReg_Jan16ReReco_branch.SetAddress(<void*>&self.eEtaCorrSmearedReg_Jan16ReReco_value)

        #print "making eEtaCorrSmearedReg_Summer12_DR53X_HCP2012"
        self.eEtaCorrSmearedReg_Summer12_DR53X_HCP2012_branch = the_tree.GetBranch("eEtaCorrSmearedReg_Summer12_DR53X_HCP2012")
        #if not self.eEtaCorrSmearedReg_Summer12_DR53X_HCP2012_branch and "eEtaCorrSmearedReg_Summer12_DR53X_HCP2012" not in self.complained:
        if not self.eEtaCorrSmearedReg_Summer12_DR53X_HCP2012_branch and "eEtaCorrSmearedReg_Summer12_DR53X_HCP2012":
            warnings.warn( "MuMuETauTree: Expected branch eEtaCorrSmearedReg_Summer12_DR53X_HCP2012 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eEtaCorrSmearedReg_Summer12_DR53X_HCP2012")
        else:
            self.eEtaCorrSmearedReg_Summer12_DR53X_HCP2012_branch.SetAddress(<void*>&self.eEtaCorrSmearedReg_Summer12_DR53X_HCP2012_value)

        #print "making eGenCharge"
        self.eGenCharge_branch = the_tree.GetBranch("eGenCharge")
        #if not self.eGenCharge_branch and "eGenCharge" not in self.complained:
        if not self.eGenCharge_branch and "eGenCharge":
            warnings.warn( "MuMuETauTree: Expected branch eGenCharge does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eGenCharge")
        else:
            self.eGenCharge_branch.SetAddress(<void*>&self.eGenCharge_value)

        #print "making eGenEnergy"
        self.eGenEnergy_branch = the_tree.GetBranch("eGenEnergy")
        #if not self.eGenEnergy_branch and "eGenEnergy" not in self.complained:
        if not self.eGenEnergy_branch and "eGenEnergy":
            warnings.warn( "MuMuETauTree: Expected branch eGenEnergy does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eGenEnergy")
        else:
            self.eGenEnergy_branch.SetAddress(<void*>&self.eGenEnergy_value)

        #print "making eGenEta"
        self.eGenEta_branch = the_tree.GetBranch("eGenEta")
        #if not self.eGenEta_branch and "eGenEta" not in self.complained:
        if not self.eGenEta_branch and "eGenEta":
            warnings.warn( "MuMuETauTree: Expected branch eGenEta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eGenEta")
        else:
            self.eGenEta_branch.SetAddress(<void*>&self.eGenEta_value)

        #print "making eGenMotherPdgId"
        self.eGenMotherPdgId_branch = the_tree.GetBranch("eGenMotherPdgId")
        #if not self.eGenMotherPdgId_branch and "eGenMotherPdgId" not in self.complained:
        if not self.eGenMotherPdgId_branch and "eGenMotherPdgId":
            warnings.warn( "MuMuETauTree: Expected branch eGenMotherPdgId does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eGenMotherPdgId")
        else:
            self.eGenMotherPdgId_branch.SetAddress(<void*>&self.eGenMotherPdgId_value)

        #print "making eGenPdgId"
        self.eGenPdgId_branch = the_tree.GetBranch("eGenPdgId")
        #if not self.eGenPdgId_branch and "eGenPdgId" not in self.complained:
        if not self.eGenPdgId_branch and "eGenPdgId":
            warnings.warn( "MuMuETauTree: Expected branch eGenPdgId does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eGenPdgId")
        else:
            self.eGenPdgId_branch.SetAddress(<void*>&self.eGenPdgId_value)

        #print "making eGenPhi"
        self.eGenPhi_branch = the_tree.GetBranch("eGenPhi")
        #if not self.eGenPhi_branch and "eGenPhi" not in self.complained:
        if not self.eGenPhi_branch and "eGenPhi":
            warnings.warn( "MuMuETauTree: Expected branch eGenPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eGenPhi")
        else:
            self.eGenPhi_branch.SetAddress(<void*>&self.eGenPhi_value)

        #print "making eHadronicDepth1OverEm"
        self.eHadronicDepth1OverEm_branch = the_tree.GetBranch("eHadronicDepth1OverEm")
        #if not self.eHadronicDepth1OverEm_branch and "eHadronicDepth1OverEm" not in self.complained:
        if not self.eHadronicDepth1OverEm_branch and "eHadronicDepth1OverEm":
            warnings.warn( "MuMuETauTree: Expected branch eHadronicDepth1OverEm does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eHadronicDepth1OverEm")
        else:
            self.eHadronicDepth1OverEm_branch.SetAddress(<void*>&self.eHadronicDepth1OverEm_value)

        #print "making eHadronicDepth2OverEm"
        self.eHadronicDepth2OverEm_branch = the_tree.GetBranch("eHadronicDepth2OverEm")
        #if not self.eHadronicDepth2OverEm_branch and "eHadronicDepth2OverEm" not in self.complained:
        if not self.eHadronicDepth2OverEm_branch and "eHadronicDepth2OverEm":
            warnings.warn( "MuMuETauTree: Expected branch eHadronicDepth2OverEm does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eHadronicDepth2OverEm")
        else:
            self.eHadronicDepth2OverEm_branch.SetAddress(<void*>&self.eHadronicDepth2OverEm_value)

        #print "making eHadronicOverEM"
        self.eHadronicOverEM_branch = the_tree.GetBranch("eHadronicOverEM")
        #if not self.eHadronicOverEM_branch and "eHadronicOverEM" not in self.complained:
        if not self.eHadronicOverEM_branch and "eHadronicOverEM":
            warnings.warn( "MuMuETauTree: Expected branch eHadronicOverEM does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eHadronicOverEM")
        else:
            self.eHadronicOverEM_branch.SetAddress(<void*>&self.eHadronicOverEM_value)

        #print "making eHasConversion"
        self.eHasConversion_branch = the_tree.GetBranch("eHasConversion")
        #if not self.eHasConversion_branch and "eHasConversion" not in self.complained:
        if not self.eHasConversion_branch and "eHasConversion":
            warnings.warn( "MuMuETauTree: Expected branch eHasConversion does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eHasConversion")
        else:
            self.eHasConversion_branch.SetAddress(<void*>&self.eHasConversion_value)

        #print "making eHasMatchedConversion"
        self.eHasMatchedConversion_branch = the_tree.GetBranch("eHasMatchedConversion")
        #if not self.eHasMatchedConversion_branch and "eHasMatchedConversion" not in self.complained:
        if not self.eHasMatchedConversion_branch and "eHasMatchedConversion":
            warnings.warn( "MuMuETauTree: Expected branch eHasMatchedConversion does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eHasMatchedConversion")
        else:
            self.eHasMatchedConversion_branch.SetAddress(<void*>&self.eHasMatchedConversion_value)

        #print "making eHcalIsoDR03"
        self.eHcalIsoDR03_branch = the_tree.GetBranch("eHcalIsoDR03")
        #if not self.eHcalIsoDR03_branch and "eHcalIsoDR03" not in self.complained:
        if not self.eHcalIsoDR03_branch and "eHcalIsoDR03":
            warnings.warn( "MuMuETauTree: Expected branch eHcalIsoDR03 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eHcalIsoDR03")
        else:
            self.eHcalIsoDR03_branch.SetAddress(<void*>&self.eHcalIsoDR03_value)

        #print "making eIP3DS"
        self.eIP3DS_branch = the_tree.GetBranch("eIP3DS")
        #if not self.eIP3DS_branch and "eIP3DS" not in self.complained:
        if not self.eIP3DS_branch and "eIP3DS":
            warnings.warn( "MuMuETauTree: Expected branch eIP3DS does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eIP3DS")
        else:
            self.eIP3DS_branch.SetAddress(<void*>&self.eIP3DS_value)

        #print "making eJetArea"
        self.eJetArea_branch = the_tree.GetBranch("eJetArea")
        #if not self.eJetArea_branch and "eJetArea" not in self.complained:
        if not self.eJetArea_branch and "eJetArea":
            warnings.warn( "MuMuETauTree: Expected branch eJetArea does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eJetArea")
        else:
            self.eJetArea_branch.SetAddress(<void*>&self.eJetArea_value)

        #print "making eJetBtag"
        self.eJetBtag_branch = the_tree.GetBranch("eJetBtag")
        #if not self.eJetBtag_branch and "eJetBtag" not in self.complained:
        if not self.eJetBtag_branch and "eJetBtag":
            warnings.warn( "MuMuETauTree: Expected branch eJetBtag does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eJetBtag")
        else:
            self.eJetBtag_branch.SetAddress(<void*>&self.eJetBtag_value)

        #print "making eJetCSVBtag"
        self.eJetCSVBtag_branch = the_tree.GetBranch("eJetCSVBtag")
        #if not self.eJetCSVBtag_branch and "eJetCSVBtag" not in self.complained:
        if not self.eJetCSVBtag_branch and "eJetCSVBtag":
            warnings.warn( "MuMuETauTree: Expected branch eJetCSVBtag does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eJetCSVBtag")
        else:
            self.eJetCSVBtag_branch.SetAddress(<void*>&self.eJetCSVBtag_value)

        #print "making eJetEtaEtaMoment"
        self.eJetEtaEtaMoment_branch = the_tree.GetBranch("eJetEtaEtaMoment")
        #if not self.eJetEtaEtaMoment_branch and "eJetEtaEtaMoment" not in self.complained:
        if not self.eJetEtaEtaMoment_branch and "eJetEtaEtaMoment":
            warnings.warn( "MuMuETauTree: Expected branch eJetEtaEtaMoment does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eJetEtaEtaMoment")
        else:
            self.eJetEtaEtaMoment_branch.SetAddress(<void*>&self.eJetEtaEtaMoment_value)

        #print "making eJetEtaPhiMoment"
        self.eJetEtaPhiMoment_branch = the_tree.GetBranch("eJetEtaPhiMoment")
        #if not self.eJetEtaPhiMoment_branch and "eJetEtaPhiMoment" not in self.complained:
        if not self.eJetEtaPhiMoment_branch and "eJetEtaPhiMoment":
            warnings.warn( "MuMuETauTree: Expected branch eJetEtaPhiMoment does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eJetEtaPhiMoment")
        else:
            self.eJetEtaPhiMoment_branch.SetAddress(<void*>&self.eJetEtaPhiMoment_value)

        #print "making eJetEtaPhiSpread"
        self.eJetEtaPhiSpread_branch = the_tree.GetBranch("eJetEtaPhiSpread")
        #if not self.eJetEtaPhiSpread_branch and "eJetEtaPhiSpread" not in self.complained:
        if not self.eJetEtaPhiSpread_branch and "eJetEtaPhiSpread":
            warnings.warn( "MuMuETauTree: Expected branch eJetEtaPhiSpread does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eJetEtaPhiSpread")
        else:
            self.eJetEtaPhiSpread_branch.SetAddress(<void*>&self.eJetEtaPhiSpread_value)

        #print "making eJetPartonFlavour"
        self.eJetPartonFlavour_branch = the_tree.GetBranch("eJetPartonFlavour")
        #if not self.eJetPartonFlavour_branch and "eJetPartonFlavour" not in self.complained:
        if not self.eJetPartonFlavour_branch and "eJetPartonFlavour":
            warnings.warn( "MuMuETauTree: Expected branch eJetPartonFlavour does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eJetPartonFlavour")
        else:
            self.eJetPartonFlavour_branch.SetAddress(<void*>&self.eJetPartonFlavour_value)

        #print "making eJetPhiPhiMoment"
        self.eJetPhiPhiMoment_branch = the_tree.GetBranch("eJetPhiPhiMoment")
        #if not self.eJetPhiPhiMoment_branch and "eJetPhiPhiMoment" not in self.complained:
        if not self.eJetPhiPhiMoment_branch and "eJetPhiPhiMoment":
            warnings.warn( "MuMuETauTree: Expected branch eJetPhiPhiMoment does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eJetPhiPhiMoment")
        else:
            self.eJetPhiPhiMoment_branch.SetAddress(<void*>&self.eJetPhiPhiMoment_value)

        #print "making eJetPt"
        self.eJetPt_branch = the_tree.GetBranch("eJetPt")
        #if not self.eJetPt_branch and "eJetPt" not in self.complained:
        if not self.eJetPt_branch and "eJetPt":
            warnings.warn( "MuMuETauTree: Expected branch eJetPt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eJetPt")
        else:
            self.eJetPt_branch.SetAddress(<void*>&self.eJetPt_value)

        #print "making eJetQGLikelihoodID"
        self.eJetQGLikelihoodID_branch = the_tree.GetBranch("eJetQGLikelihoodID")
        #if not self.eJetQGLikelihoodID_branch and "eJetQGLikelihoodID" not in self.complained:
        if not self.eJetQGLikelihoodID_branch and "eJetQGLikelihoodID":
            warnings.warn( "MuMuETauTree: Expected branch eJetQGLikelihoodID does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eJetQGLikelihoodID")
        else:
            self.eJetQGLikelihoodID_branch.SetAddress(<void*>&self.eJetQGLikelihoodID_value)

        #print "making eJetQGMVAID"
        self.eJetQGMVAID_branch = the_tree.GetBranch("eJetQGMVAID")
        #if not self.eJetQGMVAID_branch and "eJetQGMVAID" not in self.complained:
        if not self.eJetQGMVAID_branch and "eJetQGMVAID":
            warnings.warn( "MuMuETauTree: Expected branch eJetQGMVAID does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eJetQGMVAID")
        else:
            self.eJetQGMVAID_branch.SetAddress(<void*>&self.eJetQGMVAID_value)

        #print "making eJetaxis1"
        self.eJetaxis1_branch = the_tree.GetBranch("eJetaxis1")
        #if not self.eJetaxis1_branch and "eJetaxis1" not in self.complained:
        if not self.eJetaxis1_branch and "eJetaxis1":
            warnings.warn( "MuMuETauTree: Expected branch eJetaxis1 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eJetaxis1")
        else:
            self.eJetaxis1_branch.SetAddress(<void*>&self.eJetaxis1_value)

        #print "making eJetaxis2"
        self.eJetaxis2_branch = the_tree.GetBranch("eJetaxis2")
        #if not self.eJetaxis2_branch and "eJetaxis2" not in self.complained:
        if not self.eJetaxis2_branch and "eJetaxis2":
            warnings.warn( "MuMuETauTree: Expected branch eJetaxis2 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eJetaxis2")
        else:
            self.eJetaxis2_branch.SetAddress(<void*>&self.eJetaxis2_value)

        #print "making eJetmult"
        self.eJetmult_branch = the_tree.GetBranch("eJetmult")
        #if not self.eJetmult_branch and "eJetmult" not in self.complained:
        if not self.eJetmult_branch and "eJetmult":
            warnings.warn( "MuMuETauTree: Expected branch eJetmult does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eJetmult")
        else:
            self.eJetmult_branch.SetAddress(<void*>&self.eJetmult_value)

        #print "making eJetmultMLP"
        self.eJetmultMLP_branch = the_tree.GetBranch("eJetmultMLP")
        #if not self.eJetmultMLP_branch and "eJetmultMLP" not in self.complained:
        if not self.eJetmultMLP_branch and "eJetmultMLP":
            warnings.warn( "MuMuETauTree: Expected branch eJetmultMLP does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eJetmultMLP")
        else:
            self.eJetmultMLP_branch.SetAddress(<void*>&self.eJetmultMLP_value)

        #print "making eJetmultMLPQC"
        self.eJetmultMLPQC_branch = the_tree.GetBranch("eJetmultMLPQC")
        #if not self.eJetmultMLPQC_branch and "eJetmultMLPQC" not in self.complained:
        if not self.eJetmultMLPQC_branch and "eJetmultMLPQC":
            warnings.warn( "MuMuETauTree: Expected branch eJetmultMLPQC does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eJetmultMLPQC")
        else:
            self.eJetmultMLPQC_branch.SetAddress(<void*>&self.eJetmultMLPQC_value)

        #print "making eJetptD"
        self.eJetptD_branch = the_tree.GetBranch("eJetptD")
        #if not self.eJetptD_branch and "eJetptD" not in self.complained:
        if not self.eJetptD_branch and "eJetptD":
            warnings.warn( "MuMuETauTree: Expected branch eJetptD does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eJetptD")
        else:
            self.eJetptD_branch.SetAddress(<void*>&self.eJetptD_value)

        #print "making eL1NonIsoHLTNonIsoMu17Ele8PixelMatchFilter"
        self.eL1NonIsoHLTNonIsoMu17Ele8PixelMatchFilter_branch = the_tree.GetBranch("eL1NonIsoHLTNonIsoMu17Ele8PixelMatchFilter")
        #if not self.eL1NonIsoHLTNonIsoMu17Ele8PixelMatchFilter_branch and "eL1NonIsoHLTNonIsoMu17Ele8PixelMatchFilter" not in self.complained:
        if not self.eL1NonIsoHLTNonIsoMu17Ele8PixelMatchFilter_branch and "eL1NonIsoHLTNonIsoMu17Ele8PixelMatchFilter":
            warnings.warn( "MuMuETauTree: Expected branch eL1NonIsoHLTNonIsoMu17Ele8PixelMatchFilter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eL1NonIsoHLTNonIsoMu17Ele8PixelMatchFilter")
        else:
            self.eL1NonIsoHLTNonIsoMu17Ele8PixelMatchFilter_branch.SetAddress(<void*>&self.eL1NonIsoHLTNonIsoMu17Ele8PixelMatchFilter_value)

        #print "making eMITID"
        self.eMITID_branch = the_tree.GetBranch("eMITID")
        #if not self.eMITID_branch and "eMITID" not in self.complained:
        if not self.eMITID_branch and "eMITID":
            warnings.warn( "MuMuETauTree: Expected branch eMITID does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eMITID")
        else:
            self.eMITID_branch.SetAddress(<void*>&self.eMITID_value)

        #print "making eMVAIDH2TauWP"
        self.eMVAIDH2TauWP_branch = the_tree.GetBranch("eMVAIDH2TauWP")
        #if not self.eMVAIDH2TauWP_branch and "eMVAIDH2TauWP" not in self.complained:
        if not self.eMVAIDH2TauWP_branch and "eMVAIDH2TauWP":
            warnings.warn( "MuMuETauTree: Expected branch eMVAIDH2TauWP does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eMVAIDH2TauWP")
        else:
            self.eMVAIDH2TauWP_branch.SetAddress(<void*>&self.eMVAIDH2TauWP_value)

        #print "making eMVANonTrig"
        self.eMVANonTrig_branch = the_tree.GetBranch("eMVANonTrig")
        #if not self.eMVANonTrig_branch and "eMVANonTrig" not in self.complained:
        if not self.eMVANonTrig_branch and "eMVANonTrig":
            warnings.warn( "MuMuETauTree: Expected branch eMVANonTrig does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eMVANonTrig")
        else:
            self.eMVANonTrig_branch.SetAddress(<void*>&self.eMVANonTrig_value)

        #print "making eMVATrig"
        self.eMVATrig_branch = the_tree.GetBranch("eMVATrig")
        #if not self.eMVATrig_branch and "eMVATrig" not in self.complained:
        if not self.eMVATrig_branch and "eMVATrig":
            warnings.warn( "MuMuETauTree: Expected branch eMVATrig does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eMVATrig")
        else:
            self.eMVATrig_branch.SetAddress(<void*>&self.eMVATrig_value)

        #print "making eMVATrigIDISO"
        self.eMVATrigIDISO_branch = the_tree.GetBranch("eMVATrigIDISO")
        #if not self.eMVATrigIDISO_branch and "eMVATrigIDISO" not in self.complained:
        if not self.eMVATrigIDISO_branch and "eMVATrigIDISO":
            warnings.warn( "MuMuETauTree: Expected branch eMVATrigIDISO does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eMVATrigIDISO")
        else:
            self.eMVATrigIDISO_branch.SetAddress(<void*>&self.eMVATrigIDISO_value)

        #print "making eMVATrigIDISOPUSUB"
        self.eMVATrigIDISOPUSUB_branch = the_tree.GetBranch("eMVATrigIDISOPUSUB")
        #if not self.eMVATrigIDISOPUSUB_branch and "eMVATrigIDISOPUSUB" not in self.complained:
        if not self.eMVATrigIDISOPUSUB_branch and "eMVATrigIDISOPUSUB":
            warnings.warn( "MuMuETauTree: Expected branch eMVATrigIDISOPUSUB does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eMVATrigIDISOPUSUB")
        else:
            self.eMVATrigIDISOPUSUB_branch.SetAddress(<void*>&self.eMVATrigIDISOPUSUB_value)

        #print "making eMVATrigNoIP"
        self.eMVATrigNoIP_branch = the_tree.GetBranch("eMVATrigNoIP")
        #if not self.eMVATrigNoIP_branch and "eMVATrigNoIP" not in self.complained:
        if not self.eMVATrigNoIP_branch and "eMVATrigNoIP":
            warnings.warn( "MuMuETauTree: Expected branch eMVATrigNoIP does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eMVATrigNoIP")
        else:
            self.eMVATrigNoIP_branch.SetAddress(<void*>&self.eMVATrigNoIP_value)

        #print "making eMass"
        self.eMass_branch = the_tree.GetBranch("eMass")
        #if not self.eMass_branch and "eMass" not in self.complained:
        if not self.eMass_branch and "eMass":
            warnings.warn( "MuMuETauTree: Expected branch eMass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eMass")
        else:
            self.eMass_branch.SetAddress(<void*>&self.eMass_value)

        #print "making eMatchesDoubleEPath"
        self.eMatchesDoubleEPath_branch = the_tree.GetBranch("eMatchesDoubleEPath")
        #if not self.eMatchesDoubleEPath_branch and "eMatchesDoubleEPath" not in self.complained:
        if not self.eMatchesDoubleEPath_branch and "eMatchesDoubleEPath":
            warnings.warn( "MuMuETauTree: Expected branch eMatchesDoubleEPath does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eMatchesDoubleEPath")
        else:
            self.eMatchesDoubleEPath_branch.SetAddress(<void*>&self.eMatchesDoubleEPath_value)

        #print "making eMatchesMu17Ele8IsoPath"
        self.eMatchesMu17Ele8IsoPath_branch = the_tree.GetBranch("eMatchesMu17Ele8IsoPath")
        #if not self.eMatchesMu17Ele8IsoPath_branch and "eMatchesMu17Ele8IsoPath" not in self.complained:
        if not self.eMatchesMu17Ele8IsoPath_branch and "eMatchesMu17Ele8IsoPath":
            warnings.warn( "MuMuETauTree: Expected branch eMatchesMu17Ele8IsoPath does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eMatchesMu17Ele8IsoPath")
        else:
            self.eMatchesMu17Ele8IsoPath_branch.SetAddress(<void*>&self.eMatchesMu17Ele8IsoPath_value)

        #print "making eMatchesMu17Ele8Path"
        self.eMatchesMu17Ele8Path_branch = the_tree.GetBranch("eMatchesMu17Ele8Path")
        #if not self.eMatchesMu17Ele8Path_branch and "eMatchesMu17Ele8Path" not in self.complained:
        if not self.eMatchesMu17Ele8Path_branch and "eMatchesMu17Ele8Path":
            warnings.warn( "MuMuETauTree: Expected branch eMatchesMu17Ele8Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eMatchesMu17Ele8Path")
        else:
            self.eMatchesMu17Ele8Path_branch.SetAddress(<void*>&self.eMatchesMu17Ele8Path_value)

        #print "making eMatchesMu8Ele17IsoPath"
        self.eMatchesMu8Ele17IsoPath_branch = the_tree.GetBranch("eMatchesMu8Ele17IsoPath")
        #if not self.eMatchesMu8Ele17IsoPath_branch and "eMatchesMu8Ele17IsoPath" not in self.complained:
        if not self.eMatchesMu8Ele17IsoPath_branch and "eMatchesMu8Ele17IsoPath":
            warnings.warn( "MuMuETauTree: Expected branch eMatchesMu8Ele17IsoPath does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eMatchesMu8Ele17IsoPath")
        else:
            self.eMatchesMu8Ele17IsoPath_branch.SetAddress(<void*>&self.eMatchesMu8Ele17IsoPath_value)

        #print "making eMatchesMu8Ele17Path"
        self.eMatchesMu8Ele17Path_branch = the_tree.GetBranch("eMatchesMu8Ele17Path")
        #if not self.eMatchesMu8Ele17Path_branch and "eMatchesMu8Ele17Path" not in self.complained:
        if not self.eMatchesMu8Ele17Path_branch and "eMatchesMu8Ele17Path":
            warnings.warn( "MuMuETauTree: Expected branch eMatchesMu8Ele17Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eMatchesMu8Ele17Path")
        else:
            self.eMatchesMu8Ele17Path_branch.SetAddress(<void*>&self.eMatchesMu8Ele17Path_value)

        #print "making eMatchesSingleE"
        self.eMatchesSingleE_branch = the_tree.GetBranch("eMatchesSingleE")
        #if not self.eMatchesSingleE_branch and "eMatchesSingleE" not in self.complained:
        if not self.eMatchesSingleE_branch and "eMatchesSingleE":
            warnings.warn( "MuMuETauTree: Expected branch eMatchesSingleE does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eMatchesSingleE")
        else:
            self.eMatchesSingleE_branch.SetAddress(<void*>&self.eMatchesSingleE_value)

        #print "making eMatchesSingleEPlusMET"
        self.eMatchesSingleEPlusMET_branch = the_tree.GetBranch("eMatchesSingleEPlusMET")
        #if not self.eMatchesSingleEPlusMET_branch and "eMatchesSingleEPlusMET" not in self.complained:
        if not self.eMatchesSingleEPlusMET_branch and "eMatchesSingleEPlusMET":
            warnings.warn( "MuMuETauTree: Expected branch eMatchesSingleEPlusMET does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eMatchesSingleEPlusMET")
        else:
            self.eMatchesSingleEPlusMET_branch.SetAddress(<void*>&self.eMatchesSingleEPlusMET_value)

        #print "making eMissingHits"
        self.eMissingHits_branch = the_tree.GetBranch("eMissingHits")
        #if not self.eMissingHits_branch and "eMissingHits" not in self.complained:
        if not self.eMissingHits_branch and "eMissingHits":
            warnings.warn( "MuMuETauTree: Expected branch eMissingHits does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eMissingHits")
        else:
            self.eMissingHits_branch.SetAddress(<void*>&self.eMissingHits_value)

        #print "making eMtToMET"
        self.eMtToMET_branch = the_tree.GetBranch("eMtToMET")
        #if not self.eMtToMET_branch and "eMtToMET" not in self.complained:
        if not self.eMtToMET_branch and "eMtToMET":
            warnings.warn( "MuMuETauTree: Expected branch eMtToMET does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eMtToMET")
        else:
            self.eMtToMET_branch.SetAddress(<void*>&self.eMtToMET_value)

        #print "making eMtToMVAMET"
        self.eMtToMVAMET_branch = the_tree.GetBranch("eMtToMVAMET")
        #if not self.eMtToMVAMET_branch and "eMtToMVAMET" not in self.complained:
        if not self.eMtToMVAMET_branch and "eMtToMVAMET":
            warnings.warn( "MuMuETauTree: Expected branch eMtToMVAMET does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eMtToMVAMET")
        else:
            self.eMtToMVAMET_branch.SetAddress(<void*>&self.eMtToMVAMET_value)

        #print "making eMtToPFMET"
        self.eMtToPFMET_branch = the_tree.GetBranch("eMtToPFMET")
        #if not self.eMtToPFMET_branch and "eMtToPFMET" not in self.complained:
        if not self.eMtToPFMET_branch and "eMtToPFMET":
            warnings.warn( "MuMuETauTree: Expected branch eMtToPFMET does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eMtToPFMET")
        else:
            self.eMtToPFMET_branch.SetAddress(<void*>&self.eMtToPFMET_value)

        #print "making eMtToPfMet_Ty1"
        self.eMtToPfMet_Ty1_branch = the_tree.GetBranch("eMtToPfMet_Ty1")
        #if not self.eMtToPfMet_Ty1_branch and "eMtToPfMet_Ty1" not in self.complained:
        if not self.eMtToPfMet_Ty1_branch and "eMtToPfMet_Ty1":
            warnings.warn( "MuMuETauTree: Expected branch eMtToPfMet_Ty1 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eMtToPfMet_Ty1")
        else:
            self.eMtToPfMet_Ty1_branch.SetAddress(<void*>&self.eMtToPfMet_Ty1_value)

        #print "making eMtToPfMet_jes"
        self.eMtToPfMet_jes_branch = the_tree.GetBranch("eMtToPfMet_jes")
        #if not self.eMtToPfMet_jes_branch and "eMtToPfMet_jes" not in self.complained:
        if not self.eMtToPfMet_jes_branch and "eMtToPfMet_jes":
            warnings.warn( "MuMuETauTree: Expected branch eMtToPfMet_jes does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eMtToPfMet_jes")
        else:
            self.eMtToPfMet_jes_branch.SetAddress(<void*>&self.eMtToPfMet_jes_value)

        #print "making eMtToPfMet_mes"
        self.eMtToPfMet_mes_branch = the_tree.GetBranch("eMtToPfMet_mes")
        #if not self.eMtToPfMet_mes_branch and "eMtToPfMet_mes" not in self.complained:
        if not self.eMtToPfMet_mes_branch and "eMtToPfMet_mes":
            warnings.warn( "MuMuETauTree: Expected branch eMtToPfMet_mes does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eMtToPfMet_mes")
        else:
            self.eMtToPfMet_mes_branch.SetAddress(<void*>&self.eMtToPfMet_mes_value)

        #print "making eMtToPfMet_tes"
        self.eMtToPfMet_tes_branch = the_tree.GetBranch("eMtToPfMet_tes")
        #if not self.eMtToPfMet_tes_branch and "eMtToPfMet_tes" not in self.complained:
        if not self.eMtToPfMet_tes_branch and "eMtToPfMet_tes":
            warnings.warn( "MuMuETauTree: Expected branch eMtToPfMet_tes does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eMtToPfMet_tes")
        else:
            self.eMtToPfMet_tes_branch.SetAddress(<void*>&self.eMtToPfMet_tes_value)

        #print "making eMtToPfMet_ues"
        self.eMtToPfMet_ues_branch = the_tree.GetBranch("eMtToPfMet_ues")
        #if not self.eMtToPfMet_ues_branch and "eMtToPfMet_ues" not in self.complained:
        if not self.eMtToPfMet_ues_branch and "eMtToPfMet_ues":
            warnings.warn( "MuMuETauTree: Expected branch eMtToPfMet_ues does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eMtToPfMet_ues")
        else:
            self.eMtToPfMet_ues_branch.SetAddress(<void*>&self.eMtToPfMet_ues_value)

        #print "making eMu17Ele8CaloIdTCaloIsoVLTrkIdVLTrkIsoVLTrackIsoFilter"
        self.eMu17Ele8CaloIdTCaloIsoVLTrkIdVLTrkIsoVLTrackIsoFilter_branch = the_tree.GetBranch("eMu17Ele8CaloIdTCaloIsoVLTrkIdVLTrkIsoVLTrackIsoFilter")
        #if not self.eMu17Ele8CaloIdTCaloIsoVLTrkIdVLTrkIsoVLTrackIsoFilter_branch and "eMu17Ele8CaloIdTCaloIsoVLTrkIdVLTrkIsoVLTrackIsoFilter" not in self.complained:
        if not self.eMu17Ele8CaloIdTCaloIsoVLTrkIdVLTrkIsoVLTrackIsoFilter_branch and "eMu17Ele8CaloIdTCaloIsoVLTrkIdVLTrkIsoVLTrackIsoFilter":
            warnings.warn( "MuMuETauTree: Expected branch eMu17Ele8CaloIdTCaloIsoVLTrkIdVLTrkIsoVLTrackIsoFilter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eMu17Ele8CaloIdTCaloIsoVLTrkIdVLTrkIsoVLTrackIsoFilter")
        else:
            self.eMu17Ele8CaloIdTCaloIsoVLTrkIdVLTrkIsoVLTrackIsoFilter_branch.SetAddress(<void*>&self.eMu17Ele8CaloIdTCaloIsoVLTrkIdVLTrkIsoVLTrackIsoFilter_value)

        #print "making eMu17Ele8CaloIdTPixelMatchFilter"
        self.eMu17Ele8CaloIdTPixelMatchFilter_branch = the_tree.GetBranch("eMu17Ele8CaloIdTPixelMatchFilter")
        #if not self.eMu17Ele8CaloIdTPixelMatchFilter_branch and "eMu17Ele8CaloIdTPixelMatchFilter" not in self.complained:
        if not self.eMu17Ele8CaloIdTPixelMatchFilter_branch and "eMu17Ele8CaloIdTPixelMatchFilter":
            warnings.warn( "MuMuETauTree: Expected branch eMu17Ele8CaloIdTPixelMatchFilter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eMu17Ele8CaloIdTPixelMatchFilter")
        else:
            self.eMu17Ele8CaloIdTPixelMatchFilter_branch.SetAddress(<void*>&self.eMu17Ele8CaloIdTPixelMatchFilter_value)

        #print "making eMu17Ele8dZFilter"
        self.eMu17Ele8dZFilter_branch = the_tree.GetBranch("eMu17Ele8dZFilter")
        #if not self.eMu17Ele8dZFilter_branch and "eMu17Ele8dZFilter" not in self.complained:
        if not self.eMu17Ele8dZFilter_branch and "eMu17Ele8dZFilter":
            warnings.warn( "MuMuETauTree: Expected branch eMu17Ele8dZFilter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eMu17Ele8dZFilter")
        else:
            self.eMu17Ele8dZFilter_branch.SetAddress(<void*>&self.eMu17Ele8dZFilter_value)

        #print "making eNearMuonVeto"
        self.eNearMuonVeto_branch = the_tree.GetBranch("eNearMuonVeto")
        #if not self.eNearMuonVeto_branch and "eNearMuonVeto" not in self.complained:
        if not self.eNearMuonVeto_branch and "eNearMuonVeto":
            warnings.warn( "MuMuETauTree: Expected branch eNearMuonVeto does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eNearMuonVeto")
        else:
            self.eNearMuonVeto_branch.SetAddress(<void*>&self.eNearMuonVeto_value)

        #print "making ePFChargedIso"
        self.ePFChargedIso_branch = the_tree.GetBranch("ePFChargedIso")
        #if not self.ePFChargedIso_branch and "ePFChargedIso" not in self.complained:
        if not self.ePFChargedIso_branch and "ePFChargedIso":
            warnings.warn( "MuMuETauTree: Expected branch ePFChargedIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("ePFChargedIso")
        else:
            self.ePFChargedIso_branch.SetAddress(<void*>&self.ePFChargedIso_value)

        #print "making ePFNeutralIso"
        self.ePFNeutralIso_branch = the_tree.GetBranch("ePFNeutralIso")
        #if not self.ePFNeutralIso_branch and "ePFNeutralIso" not in self.complained:
        if not self.ePFNeutralIso_branch and "ePFNeutralIso":
            warnings.warn( "MuMuETauTree: Expected branch ePFNeutralIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("ePFNeutralIso")
        else:
            self.ePFNeutralIso_branch.SetAddress(<void*>&self.ePFNeutralIso_value)

        #print "making ePFPhotonIso"
        self.ePFPhotonIso_branch = the_tree.GetBranch("ePFPhotonIso")
        #if not self.ePFPhotonIso_branch and "ePFPhotonIso" not in self.complained:
        if not self.ePFPhotonIso_branch and "ePFPhotonIso":
            warnings.warn( "MuMuETauTree: Expected branch ePFPhotonIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("ePFPhotonIso")
        else:
            self.ePFPhotonIso_branch.SetAddress(<void*>&self.ePFPhotonIso_value)

        #print "making ePVDXY"
        self.ePVDXY_branch = the_tree.GetBranch("ePVDXY")
        #if not self.ePVDXY_branch and "ePVDXY" not in self.complained:
        if not self.ePVDXY_branch and "ePVDXY":
            warnings.warn( "MuMuETauTree: Expected branch ePVDXY does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("ePVDXY")
        else:
            self.ePVDXY_branch.SetAddress(<void*>&self.ePVDXY_value)

        #print "making ePVDZ"
        self.ePVDZ_branch = the_tree.GetBranch("ePVDZ")
        #if not self.ePVDZ_branch and "ePVDZ" not in self.complained:
        if not self.ePVDZ_branch and "ePVDZ":
            warnings.warn( "MuMuETauTree: Expected branch ePVDZ does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("ePVDZ")
        else:
            self.ePVDZ_branch.SetAddress(<void*>&self.ePVDZ_value)

        #print "making ePhi"
        self.ePhi_branch = the_tree.GetBranch("ePhi")
        #if not self.ePhi_branch and "ePhi" not in self.complained:
        if not self.ePhi_branch and "ePhi":
            warnings.warn( "MuMuETauTree: Expected branch ePhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("ePhi")
        else:
            self.ePhi_branch.SetAddress(<void*>&self.ePhi_value)

        #print "making ePhiCorrReg_2012Jul13ReReco"
        self.ePhiCorrReg_2012Jul13ReReco_branch = the_tree.GetBranch("ePhiCorrReg_2012Jul13ReReco")
        #if not self.ePhiCorrReg_2012Jul13ReReco_branch and "ePhiCorrReg_2012Jul13ReReco" not in self.complained:
        if not self.ePhiCorrReg_2012Jul13ReReco_branch and "ePhiCorrReg_2012Jul13ReReco":
            warnings.warn( "MuMuETauTree: Expected branch ePhiCorrReg_2012Jul13ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("ePhiCorrReg_2012Jul13ReReco")
        else:
            self.ePhiCorrReg_2012Jul13ReReco_branch.SetAddress(<void*>&self.ePhiCorrReg_2012Jul13ReReco_value)

        #print "making ePhiCorrReg_Fall11"
        self.ePhiCorrReg_Fall11_branch = the_tree.GetBranch("ePhiCorrReg_Fall11")
        #if not self.ePhiCorrReg_Fall11_branch and "ePhiCorrReg_Fall11" not in self.complained:
        if not self.ePhiCorrReg_Fall11_branch and "ePhiCorrReg_Fall11":
            warnings.warn( "MuMuETauTree: Expected branch ePhiCorrReg_Fall11 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("ePhiCorrReg_Fall11")
        else:
            self.ePhiCorrReg_Fall11_branch.SetAddress(<void*>&self.ePhiCorrReg_Fall11_value)

        #print "making ePhiCorrReg_Jan16ReReco"
        self.ePhiCorrReg_Jan16ReReco_branch = the_tree.GetBranch("ePhiCorrReg_Jan16ReReco")
        #if not self.ePhiCorrReg_Jan16ReReco_branch and "ePhiCorrReg_Jan16ReReco" not in self.complained:
        if not self.ePhiCorrReg_Jan16ReReco_branch and "ePhiCorrReg_Jan16ReReco":
            warnings.warn( "MuMuETauTree: Expected branch ePhiCorrReg_Jan16ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("ePhiCorrReg_Jan16ReReco")
        else:
            self.ePhiCorrReg_Jan16ReReco_branch.SetAddress(<void*>&self.ePhiCorrReg_Jan16ReReco_value)

        #print "making ePhiCorrReg_Summer12_DR53X_HCP2012"
        self.ePhiCorrReg_Summer12_DR53X_HCP2012_branch = the_tree.GetBranch("ePhiCorrReg_Summer12_DR53X_HCP2012")
        #if not self.ePhiCorrReg_Summer12_DR53X_HCP2012_branch and "ePhiCorrReg_Summer12_DR53X_HCP2012" not in self.complained:
        if not self.ePhiCorrReg_Summer12_DR53X_HCP2012_branch and "ePhiCorrReg_Summer12_DR53X_HCP2012":
            warnings.warn( "MuMuETauTree: Expected branch ePhiCorrReg_Summer12_DR53X_HCP2012 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("ePhiCorrReg_Summer12_DR53X_HCP2012")
        else:
            self.ePhiCorrReg_Summer12_DR53X_HCP2012_branch.SetAddress(<void*>&self.ePhiCorrReg_Summer12_DR53X_HCP2012_value)

        #print "making ePhiCorrSmearedNoReg_2012Jul13ReReco"
        self.ePhiCorrSmearedNoReg_2012Jul13ReReco_branch = the_tree.GetBranch("ePhiCorrSmearedNoReg_2012Jul13ReReco")
        #if not self.ePhiCorrSmearedNoReg_2012Jul13ReReco_branch and "ePhiCorrSmearedNoReg_2012Jul13ReReco" not in self.complained:
        if not self.ePhiCorrSmearedNoReg_2012Jul13ReReco_branch and "ePhiCorrSmearedNoReg_2012Jul13ReReco":
            warnings.warn( "MuMuETauTree: Expected branch ePhiCorrSmearedNoReg_2012Jul13ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("ePhiCorrSmearedNoReg_2012Jul13ReReco")
        else:
            self.ePhiCorrSmearedNoReg_2012Jul13ReReco_branch.SetAddress(<void*>&self.ePhiCorrSmearedNoReg_2012Jul13ReReco_value)

        #print "making ePhiCorrSmearedNoReg_Fall11"
        self.ePhiCorrSmearedNoReg_Fall11_branch = the_tree.GetBranch("ePhiCorrSmearedNoReg_Fall11")
        #if not self.ePhiCorrSmearedNoReg_Fall11_branch and "ePhiCorrSmearedNoReg_Fall11" not in self.complained:
        if not self.ePhiCorrSmearedNoReg_Fall11_branch and "ePhiCorrSmearedNoReg_Fall11":
            warnings.warn( "MuMuETauTree: Expected branch ePhiCorrSmearedNoReg_Fall11 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("ePhiCorrSmearedNoReg_Fall11")
        else:
            self.ePhiCorrSmearedNoReg_Fall11_branch.SetAddress(<void*>&self.ePhiCorrSmearedNoReg_Fall11_value)

        #print "making ePhiCorrSmearedNoReg_Jan16ReReco"
        self.ePhiCorrSmearedNoReg_Jan16ReReco_branch = the_tree.GetBranch("ePhiCorrSmearedNoReg_Jan16ReReco")
        #if not self.ePhiCorrSmearedNoReg_Jan16ReReco_branch and "ePhiCorrSmearedNoReg_Jan16ReReco" not in self.complained:
        if not self.ePhiCorrSmearedNoReg_Jan16ReReco_branch and "ePhiCorrSmearedNoReg_Jan16ReReco":
            warnings.warn( "MuMuETauTree: Expected branch ePhiCorrSmearedNoReg_Jan16ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("ePhiCorrSmearedNoReg_Jan16ReReco")
        else:
            self.ePhiCorrSmearedNoReg_Jan16ReReco_branch.SetAddress(<void*>&self.ePhiCorrSmearedNoReg_Jan16ReReco_value)

        #print "making ePhiCorrSmearedNoReg_Summer12_DR53X_HCP2012"
        self.ePhiCorrSmearedNoReg_Summer12_DR53X_HCP2012_branch = the_tree.GetBranch("ePhiCorrSmearedNoReg_Summer12_DR53X_HCP2012")
        #if not self.ePhiCorrSmearedNoReg_Summer12_DR53X_HCP2012_branch and "ePhiCorrSmearedNoReg_Summer12_DR53X_HCP2012" not in self.complained:
        if not self.ePhiCorrSmearedNoReg_Summer12_DR53X_HCP2012_branch and "ePhiCorrSmearedNoReg_Summer12_DR53X_HCP2012":
            warnings.warn( "MuMuETauTree: Expected branch ePhiCorrSmearedNoReg_Summer12_DR53X_HCP2012 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("ePhiCorrSmearedNoReg_Summer12_DR53X_HCP2012")
        else:
            self.ePhiCorrSmearedNoReg_Summer12_DR53X_HCP2012_branch.SetAddress(<void*>&self.ePhiCorrSmearedNoReg_Summer12_DR53X_HCP2012_value)

        #print "making ePhiCorrSmearedReg_2012Jul13ReReco"
        self.ePhiCorrSmearedReg_2012Jul13ReReco_branch = the_tree.GetBranch("ePhiCorrSmearedReg_2012Jul13ReReco")
        #if not self.ePhiCorrSmearedReg_2012Jul13ReReco_branch and "ePhiCorrSmearedReg_2012Jul13ReReco" not in self.complained:
        if not self.ePhiCorrSmearedReg_2012Jul13ReReco_branch and "ePhiCorrSmearedReg_2012Jul13ReReco":
            warnings.warn( "MuMuETauTree: Expected branch ePhiCorrSmearedReg_2012Jul13ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("ePhiCorrSmearedReg_2012Jul13ReReco")
        else:
            self.ePhiCorrSmearedReg_2012Jul13ReReco_branch.SetAddress(<void*>&self.ePhiCorrSmearedReg_2012Jul13ReReco_value)

        #print "making ePhiCorrSmearedReg_Fall11"
        self.ePhiCorrSmearedReg_Fall11_branch = the_tree.GetBranch("ePhiCorrSmearedReg_Fall11")
        #if not self.ePhiCorrSmearedReg_Fall11_branch and "ePhiCorrSmearedReg_Fall11" not in self.complained:
        if not self.ePhiCorrSmearedReg_Fall11_branch and "ePhiCorrSmearedReg_Fall11":
            warnings.warn( "MuMuETauTree: Expected branch ePhiCorrSmearedReg_Fall11 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("ePhiCorrSmearedReg_Fall11")
        else:
            self.ePhiCorrSmearedReg_Fall11_branch.SetAddress(<void*>&self.ePhiCorrSmearedReg_Fall11_value)

        #print "making ePhiCorrSmearedReg_Jan16ReReco"
        self.ePhiCorrSmearedReg_Jan16ReReco_branch = the_tree.GetBranch("ePhiCorrSmearedReg_Jan16ReReco")
        #if not self.ePhiCorrSmearedReg_Jan16ReReco_branch and "ePhiCorrSmearedReg_Jan16ReReco" not in self.complained:
        if not self.ePhiCorrSmearedReg_Jan16ReReco_branch and "ePhiCorrSmearedReg_Jan16ReReco":
            warnings.warn( "MuMuETauTree: Expected branch ePhiCorrSmearedReg_Jan16ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("ePhiCorrSmearedReg_Jan16ReReco")
        else:
            self.ePhiCorrSmearedReg_Jan16ReReco_branch.SetAddress(<void*>&self.ePhiCorrSmearedReg_Jan16ReReco_value)

        #print "making ePhiCorrSmearedReg_Summer12_DR53X_HCP2012"
        self.ePhiCorrSmearedReg_Summer12_DR53X_HCP2012_branch = the_tree.GetBranch("ePhiCorrSmearedReg_Summer12_DR53X_HCP2012")
        #if not self.ePhiCorrSmearedReg_Summer12_DR53X_HCP2012_branch and "ePhiCorrSmearedReg_Summer12_DR53X_HCP2012" not in self.complained:
        if not self.ePhiCorrSmearedReg_Summer12_DR53X_HCP2012_branch and "ePhiCorrSmearedReg_Summer12_DR53X_HCP2012":
            warnings.warn( "MuMuETauTree: Expected branch ePhiCorrSmearedReg_Summer12_DR53X_HCP2012 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("ePhiCorrSmearedReg_Summer12_DR53X_HCP2012")
        else:
            self.ePhiCorrSmearedReg_Summer12_DR53X_HCP2012_branch.SetAddress(<void*>&self.ePhiCorrSmearedReg_Summer12_DR53X_HCP2012_value)

        #print "making ePt"
        self.ePt_branch = the_tree.GetBranch("ePt")
        #if not self.ePt_branch and "ePt" not in self.complained:
        if not self.ePt_branch and "ePt":
            warnings.warn( "MuMuETauTree: Expected branch ePt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("ePt")
        else:
            self.ePt_branch.SetAddress(<void*>&self.ePt_value)

        #print "making ePtCorrReg_2012Jul13ReReco"
        self.ePtCorrReg_2012Jul13ReReco_branch = the_tree.GetBranch("ePtCorrReg_2012Jul13ReReco")
        #if not self.ePtCorrReg_2012Jul13ReReco_branch and "ePtCorrReg_2012Jul13ReReco" not in self.complained:
        if not self.ePtCorrReg_2012Jul13ReReco_branch and "ePtCorrReg_2012Jul13ReReco":
            warnings.warn( "MuMuETauTree: Expected branch ePtCorrReg_2012Jul13ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("ePtCorrReg_2012Jul13ReReco")
        else:
            self.ePtCorrReg_2012Jul13ReReco_branch.SetAddress(<void*>&self.ePtCorrReg_2012Jul13ReReco_value)

        #print "making ePtCorrReg_Fall11"
        self.ePtCorrReg_Fall11_branch = the_tree.GetBranch("ePtCorrReg_Fall11")
        #if not self.ePtCorrReg_Fall11_branch and "ePtCorrReg_Fall11" not in self.complained:
        if not self.ePtCorrReg_Fall11_branch and "ePtCorrReg_Fall11":
            warnings.warn( "MuMuETauTree: Expected branch ePtCorrReg_Fall11 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("ePtCorrReg_Fall11")
        else:
            self.ePtCorrReg_Fall11_branch.SetAddress(<void*>&self.ePtCorrReg_Fall11_value)

        #print "making ePtCorrReg_Jan16ReReco"
        self.ePtCorrReg_Jan16ReReco_branch = the_tree.GetBranch("ePtCorrReg_Jan16ReReco")
        #if not self.ePtCorrReg_Jan16ReReco_branch and "ePtCorrReg_Jan16ReReco" not in self.complained:
        if not self.ePtCorrReg_Jan16ReReco_branch and "ePtCorrReg_Jan16ReReco":
            warnings.warn( "MuMuETauTree: Expected branch ePtCorrReg_Jan16ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("ePtCorrReg_Jan16ReReco")
        else:
            self.ePtCorrReg_Jan16ReReco_branch.SetAddress(<void*>&self.ePtCorrReg_Jan16ReReco_value)

        #print "making ePtCorrReg_Summer12_DR53X_HCP2012"
        self.ePtCorrReg_Summer12_DR53X_HCP2012_branch = the_tree.GetBranch("ePtCorrReg_Summer12_DR53X_HCP2012")
        #if not self.ePtCorrReg_Summer12_DR53X_HCP2012_branch and "ePtCorrReg_Summer12_DR53X_HCP2012" not in self.complained:
        if not self.ePtCorrReg_Summer12_DR53X_HCP2012_branch and "ePtCorrReg_Summer12_DR53X_HCP2012":
            warnings.warn( "MuMuETauTree: Expected branch ePtCorrReg_Summer12_DR53X_HCP2012 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("ePtCorrReg_Summer12_DR53X_HCP2012")
        else:
            self.ePtCorrReg_Summer12_DR53X_HCP2012_branch.SetAddress(<void*>&self.ePtCorrReg_Summer12_DR53X_HCP2012_value)

        #print "making ePtCorrSmearedNoReg_2012Jul13ReReco"
        self.ePtCorrSmearedNoReg_2012Jul13ReReco_branch = the_tree.GetBranch("ePtCorrSmearedNoReg_2012Jul13ReReco")
        #if not self.ePtCorrSmearedNoReg_2012Jul13ReReco_branch and "ePtCorrSmearedNoReg_2012Jul13ReReco" not in self.complained:
        if not self.ePtCorrSmearedNoReg_2012Jul13ReReco_branch and "ePtCorrSmearedNoReg_2012Jul13ReReco":
            warnings.warn( "MuMuETauTree: Expected branch ePtCorrSmearedNoReg_2012Jul13ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("ePtCorrSmearedNoReg_2012Jul13ReReco")
        else:
            self.ePtCorrSmearedNoReg_2012Jul13ReReco_branch.SetAddress(<void*>&self.ePtCorrSmearedNoReg_2012Jul13ReReco_value)

        #print "making ePtCorrSmearedNoReg_Fall11"
        self.ePtCorrSmearedNoReg_Fall11_branch = the_tree.GetBranch("ePtCorrSmearedNoReg_Fall11")
        #if not self.ePtCorrSmearedNoReg_Fall11_branch and "ePtCorrSmearedNoReg_Fall11" not in self.complained:
        if not self.ePtCorrSmearedNoReg_Fall11_branch and "ePtCorrSmearedNoReg_Fall11":
            warnings.warn( "MuMuETauTree: Expected branch ePtCorrSmearedNoReg_Fall11 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("ePtCorrSmearedNoReg_Fall11")
        else:
            self.ePtCorrSmearedNoReg_Fall11_branch.SetAddress(<void*>&self.ePtCorrSmearedNoReg_Fall11_value)

        #print "making ePtCorrSmearedNoReg_Jan16ReReco"
        self.ePtCorrSmearedNoReg_Jan16ReReco_branch = the_tree.GetBranch("ePtCorrSmearedNoReg_Jan16ReReco")
        #if not self.ePtCorrSmearedNoReg_Jan16ReReco_branch and "ePtCorrSmearedNoReg_Jan16ReReco" not in self.complained:
        if not self.ePtCorrSmearedNoReg_Jan16ReReco_branch and "ePtCorrSmearedNoReg_Jan16ReReco":
            warnings.warn( "MuMuETauTree: Expected branch ePtCorrSmearedNoReg_Jan16ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("ePtCorrSmearedNoReg_Jan16ReReco")
        else:
            self.ePtCorrSmearedNoReg_Jan16ReReco_branch.SetAddress(<void*>&self.ePtCorrSmearedNoReg_Jan16ReReco_value)

        #print "making ePtCorrSmearedNoReg_Summer12_DR53X_HCP2012"
        self.ePtCorrSmearedNoReg_Summer12_DR53X_HCP2012_branch = the_tree.GetBranch("ePtCorrSmearedNoReg_Summer12_DR53X_HCP2012")
        #if not self.ePtCorrSmearedNoReg_Summer12_DR53X_HCP2012_branch and "ePtCorrSmearedNoReg_Summer12_DR53X_HCP2012" not in self.complained:
        if not self.ePtCorrSmearedNoReg_Summer12_DR53X_HCP2012_branch and "ePtCorrSmearedNoReg_Summer12_DR53X_HCP2012":
            warnings.warn( "MuMuETauTree: Expected branch ePtCorrSmearedNoReg_Summer12_DR53X_HCP2012 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("ePtCorrSmearedNoReg_Summer12_DR53X_HCP2012")
        else:
            self.ePtCorrSmearedNoReg_Summer12_DR53X_HCP2012_branch.SetAddress(<void*>&self.ePtCorrSmearedNoReg_Summer12_DR53X_HCP2012_value)

        #print "making ePtCorrSmearedReg_2012Jul13ReReco"
        self.ePtCorrSmearedReg_2012Jul13ReReco_branch = the_tree.GetBranch("ePtCorrSmearedReg_2012Jul13ReReco")
        #if not self.ePtCorrSmearedReg_2012Jul13ReReco_branch and "ePtCorrSmearedReg_2012Jul13ReReco" not in self.complained:
        if not self.ePtCorrSmearedReg_2012Jul13ReReco_branch and "ePtCorrSmearedReg_2012Jul13ReReco":
            warnings.warn( "MuMuETauTree: Expected branch ePtCorrSmearedReg_2012Jul13ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("ePtCorrSmearedReg_2012Jul13ReReco")
        else:
            self.ePtCorrSmearedReg_2012Jul13ReReco_branch.SetAddress(<void*>&self.ePtCorrSmearedReg_2012Jul13ReReco_value)

        #print "making ePtCorrSmearedReg_Fall11"
        self.ePtCorrSmearedReg_Fall11_branch = the_tree.GetBranch("ePtCorrSmearedReg_Fall11")
        #if not self.ePtCorrSmearedReg_Fall11_branch and "ePtCorrSmearedReg_Fall11" not in self.complained:
        if not self.ePtCorrSmearedReg_Fall11_branch and "ePtCorrSmearedReg_Fall11":
            warnings.warn( "MuMuETauTree: Expected branch ePtCorrSmearedReg_Fall11 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("ePtCorrSmearedReg_Fall11")
        else:
            self.ePtCorrSmearedReg_Fall11_branch.SetAddress(<void*>&self.ePtCorrSmearedReg_Fall11_value)

        #print "making ePtCorrSmearedReg_Jan16ReReco"
        self.ePtCorrSmearedReg_Jan16ReReco_branch = the_tree.GetBranch("ePtCorrSmearedReg_Jan16ReReco")
        #if not self.ePtCorrSmearedReg_Jan16ReReco_branch and "ePtCorrSmearedReg_Jan16ReReco" not in self.complained:
        if not self.ePtCorrSmearedReg_Jan16ReReco_branch and "ePtCorrSmearedReg_Jan16ReReco":
            warnings.warn( "MuMuETauTree: Expected branch ePtCorrSmearedReg_Jan16ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("ePtCorrSmearedReg_Jan16ReReco")
        else:
            self.ePtCorrSmearedReg_Jan16ReReco_branch.SetAddress(<void*>&self.ePtCorrSmearedReg_Jan16ReReco_value)

        #print "making ePtCorrSmearedReg_Summer12_DR53X_HCP2012"
        self.ePtCorrSmearedReg_Summer12_DR53X_HCP2012_branch = the_tree.GetBranch("ePtCorrSmearedReg_Summer12_DR53X_HCP2012")
        #if not self.ePtCorrSmearedReg_Summer12_DR53X_HCP2012_branch and "ePtCorrSmearedReg_Summer12_DR53X_HCP2012" not in self.complained:
        if not self.ePtCorrSmearedReg_Summer12_DR53X_HCP2012_branch and "ePtCorrSmearedReg_Summer12_DR53X_HCP2012":
            warnings.warn( "MuMuETauTree: Expected branch ePtCorrSmearedReg_Summer12_DR53X_HCP2012 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("ePtCorrSmearedReg_Summer12_DR53X_HCP2012")
        else:
            self.ePtCorrSmearedReg_Summer12_DR53X_HCP2012_branch.SetAddress(<void*>&self.ePtCorrSmearedReg_Summer12_DR53X_HCP2012_value)

        #print "making eRank"
        self.eRank_branch = the_tree.GetBranch("eRank")
        #if not self.eRank_branch and "eRank" not in self.complained:
        if not self.eRank_branch and "eRank":
            warnings.warn( "MuMuETauTree: Expected branch eRank does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eRank")
        else:
            self.eRank_branch.SetAddress(<void*>&self.eRank_value)

        #print "making eRelIso"
        self.eRelIso_branch = the_tree.GetBranch("eRelIso")
        #if not self.eRelIso_branch and "eRelIso" not in self.complained:
        if not self.eRelIso_branch and "eRelIso":
            warnings.warn( "MuMuETauTree: Expected branch eRelIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eRelIso")
        else:
            self.eRelIso_branch.SetAddress(<void*>&self.eRelIso_value)

        #print "making eRelPFIsoDB"
        self.eRelPFIsoDB_branch = the_tree.GetBranch("eRelPFIsoDB")
        #if not self.eRelPFIsoDB_branch and "eRelPFIsoDB" not in self.complained:
        if not self.eRelPFIsoDB_branch and "eRelPFIsoDB":
            warnings.warn( "MuMuETauTree: Expected branch eRelPFIsoDB does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eRelPFIsoDB")
        else:
            self.eRelPFIsoDB_branch.SetAddress(<void*>&self.eRelPFIsoDB_value)

        #print "making eRelPFIsoRho"
        self.eRelPFIsoRho_branch = the_tree.GetBranch("eRelPFIsoRho")
        #if not self.eRelPFIsoRho_branch and "eRelPFIsoRho" not in self.complained:
        if not self.eRelPFIsoRho_branch and "eRelPFIsoRho":
            warnings.warn( "MuMuETauTree: Expected branch eRelPFIsoRho does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eRelPFIsoRho")
        else:
            self.eRelPFIsoRho_branch.SetAddress(<void*>&self.eRelPFIsoRho_value)

        #print "making eRelPFIsoRhoFSR"
        self.eRelPFIsoRhoFSR_branch = the_tree.GetBranch("eRelPFIsoRhoFSR")
        #if not self.eRelPFIsoRhoFSR_branch and "eRelPFIsoRhoFSR" not in self.complained:
        if not self.eRelPFIsoRhoFSR_branch and "eRelPFIsoRhoFSR":
            warnings.warn( "MuMuETauTree: Expected branch eRelPFIsoRhoFSR does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eRelPFIsoRhoFSR")
        else:
            self.eRelPFIsoRhoFSR_branch.SetAddress(<void*>&self.eRelPFIsoRhoFSR_value)

        #print "making eRhoHZG2011"
        self.eRhoHZG2011_branch = the_tree.GetBranch("eRhoHZG2011")
        #if not self.eRhoHZG2011_branch and "eRhoHZG2011" not in self.complained:
        if not self.eRhoHZG2011_branch and "eRhoHZG2011":
            warnings.warn( "MuMuETauTree: Expected branch eRhoHZG2011 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eRhoHZG2011")
        else:
            self.eRhoHZG2011_branch.SetAddress(<void*>&self.eRhoHZG2011_value)

        #print "making eRhoHZG2012"
        self.eRhoHZG2012_branch = the_tree.GetBranch("eRhoHZG2012")
        #if not self.eRhoHZG2012_branch and "eRhoHZG2012" not in self.complained:
        if not self.eRhoHZG2012_branch and "eRhoHZG2012":
            warnings.warn( "MuMuETauTree: Expected branch eRhoHZG2012 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eRhoHZG2012")
        else:
            self.eRhoHZG2012_branch.SetAddress(<void*>&self.eRhoHZG2012_value)

        #print "making eSCEnergy"
        self.eSCEnergy_branch = the_tree.GetBranch("eSCEnergy")
        #if not self.eSCEnergy_branch and "eSCEnergy" not in self.complained:
        if not self.eSCEnergy_branch and "eSCEnergy":
            warnings.warn( "MuMuETauTree: Expected branch eSCEnergy does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eSCEnergy")
        else:
            self.eSCEnergy_branch.SetAddress(<void*>&self.eSCEnergy_value)

        #print "making eSCEta"
        self.eSCEta_branch = the_tree.GetBranch("eSCEta")
        #if not self.eSCEta_branch and "eSCEta" not in self.complained:
        if not self.eSCEta_branch and "eSCEta":
            warnings.warn( "MuMuETauTree: Expected branch eSCEta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eSCEta")
        else:
            self.eSCEta_branch.SetAddress(<void*>&self.eSCEta_value)

        #print "making eSCEtaWidth"
        self.eSCEtaWidth_branch = the_tree.GetBranch("eSCEtaWidth")
        #if not self.eSCEtaWidth_branch and "eSCEtaWidth" not in self.complained:
        if not self.eSCEtaWidth_branch and "eSCEtaWidth":
            warnings.warn( "MuMuETauTree: Expected branch eSCEtaWidth does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eSCEtaWidth")
        else:
            self.eSCEtaWidth_branch.SetAddress(<void*>&self.eSCEtaWidth_value)

        #print "making eSCPhi"
        self.eSCPhi_branch = the_tree.GetBranch("eSCPhi")
        #if not self.eSCPhi_branch and "eSCPhi" not in self.complained:
        if not self.eSCPhi_branch and "eSCPhi":
            warnings.warn( "MuMuETauTree: Expected branch eSCPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eSCPhi")
        else:
            self.eSCPhi_branch.SetAddress(<void*>&self.eSCPhi_value)

        #print "making eSCPhiWidth"
        self.eSCPhiWidth_branch = the_tree.GetBranch("eSCPhiWidth")
        #if not self.eSCPhiWidth_branch and "eSCPhiWidth" not in self.complained:
        if not self.eSCPhiWidth_branch and "eSCPhiWidth":
            warnings.warn( "MuMuETauTree: Expected branch eSCPhiWidth does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eSCPhiWidth")
        else:
            self.eSCPhiWidth_branch.SetAddress(<void*>&self.eSCPhiWidth_value)

        #print "making eSCPreshowerEnergy"
        self.eSCPreshowerEnergy_branch = the_tree.GetBranch("eSCPreshowerEnergy")
        #if not self.eSCPreshowerEnergy_branch and "eSCPreshowerEnergy" not in self.complained:
        if not self.eSCPreshowerEnergy_branch and "eSCPreshowerEnergy":
            warnings.warn( "MuMuETauTree: Expected branch eSCPreshowerEnergy does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eSCPreshowerEnergy")
        else:
            self.eSCPreshowerEnergy_branch.SetAddress(<void*>&self.eSCPreshowerEnergy_value)

        #print "making eSCRawEnergy"
        self.eSCRawEnergy_branch = the_tree.GetBranch("eSCRawEnergy")
        #if not self.eSCRawEnergy_branch and "eSCRawEnergy" not in self.complained:
        if not self.eSCRawEnergy_branch and "eSCRawEnergy":
            warnings.warn( "MuMuETauTree: Expected branch eSCRawEnergy does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eSCRawEnergy")
        else:
            self.eSCRawEnergy_branch.SetAddress(<void*>&self.eSCRawEnergy_value)

        #print "making eSigmaIEtaIEta"
        self.eSigmaIEtaIEta_branch = the_tree.GetBranch("eSigmaIEtaIEta")
        #if not self.eSigmaIEtaIEta_branch and "eSigmaIEtaIEta" not in self.complained:
        if not self.eSigmaIEtaIEta_branch and "eSigmaIEtaIEta":
            warnings.warn( "MuMuETauTree: Expected branch eSigmaIEtaIEta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eSigmaIEtaIEta")
        else:
            self.eSigmaIEtaIEta_branch.SetAddress(<void*>&self.eSigmaIEtaIEta_value)

        #print "making eTightCountZH"
        self.eTightCountZH_branch = the_tree.GetBranch("eTightCountZH")
        #if not self.eTightCountZH_branch and "eTightCountZH" not in self.complained:
        if not self.eTightCountZH_branch and "eTightCountZH":
            warnings.warn( "MuMuETauTree: Expected branch eTightCountZH does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eTightCountZH")
        else:
            self.eTightCountZH_branch.SetAddress(<void*>&self.eTightCountZH_value)

        #print "making eToMETDPhi"
        self.eToMETDPhi_branch = the_tree.GetBranch("eToMETDPhi")
        #if not self.eToMETDPhi_branch and "eToMETDPhi" not in self.complained:
        if not self.eToMETDPhi_branch and "eToMETDPhi":
            warnings.warn( "MuMuETauTree: Expected branch eToMETDPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eToMETDPhi")
        else:
            self.eToMETDPhi_branch.SetAddress(<void*>&self.eToMETDPhi_value)

        #print "making eTrkIsoDR03"
        self.eTrkIsoDR03_branch = the_tree.GetBranch("eTrkIsoDR03")
        #if not self.eTrkIsoDR03_branch and "eTrkIsoDR03" not in self.complained:
        if not self.eTrkIsoDR03_branch and "eTrkIsoDR03":
            warnings.warn( "MuMuETauTree: Expected branch eTrkIsoDR03 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eTrkIsoDR03")
        else:
            self.eTrkIsoDR03_branch.SetAddress(<void*>&self.eTrkIsoDR03_value)

        #print "making eVZ"
        self.eVZ_branch = the_tree.GetBranch("eVZ")
        #if not self.eVZ_branch and "eVZ" not in self.complained:
        if not self.eVZ_branch and "eVZ":
            warnings.warn( "MuMuETauTree: Expected branch eVZ does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eVZ")
        else:
            self.eVZ_branch.SetAddress(<void*>&self.eVZ_value)

        #print "making eVetoCicTightIso"
        self.eVetoCicTightIso_branch = the_tree.GetBranch("eVetoCicTightIso")
        #if not self.eVetoCicTightIso_branch and "eVetoCicTightIso" not in self.complained:
        if not self.eVetoCicTightIso_branch and "eVetoCicTightIso":
            warnings.warn( "MuMuETauTree: Expected branch eVetoCicTightIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eVetoCicTightIso")
        else:
            self.eVetoCicTightIso_branch.SetAddress(<void*>&self.eVetoCicTightIso_value)

        #print "making eVetoMVAIso"
        self.eVetoMVAIso_branch = the_tree.GetBranch("eVetoMVAIso")
        #if not self.eVetoMVAIso_branch and "eVetoMVAIso" not in self.complained:
        if not self.eVetoMVAIso_branch and "eVetoMVAIso":
            warnings.warn( "MuMuETauTree: Expected branch eVetoMVAIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eVetoMVAIso")
        else:
            self.eVetoMVAIso_branch.SetAddress(<void*>&self.eVetoMVAIso_value)

        #print "making eVetoMVAIsoVtx"
        self.eVetoMVAIsoVtx_branch = the_tree.GetBranch("eVetoMVAIsoVtx")
        #if not self.eVetoMVAIsoVtx_branch and "eVetoMVAIsoVtx" not in self.complained:
        if not self.eVetoMVAIsoVtx_branch and "eVetoMVAIsoVtx":
            warnings.warn( "MuMuETauTree: Expected branch eVetoMVAIsoVtx does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eVetoMVAIsoVtx")
        else:
            self.eVetoMVAIsoVtx_branch.SetAddress(<void*>&self.eVetoMVAIsoVtx_value)

        #print "making eVetoZH"
        self.eVetoZH_branch = the_tree.GetBranch("eVetoZH")
        #if not self.eVetoZH_branch and "eVetoZH" not in self.complained:
        if not self.eVetoZH_branch and "eVetoZH":
            warnings.warn( "MuMuETauTree: Expected branch eVetoZH does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eVetoZH")
        else:
            self.eVetoZH_branch.SetAddress(<void*>&self.eVetoZH_value)

        #print "making eVetoZH_smallDR"
        self.eVetoZH_smallDR_branch = the_tree.GetBranch("eVetoZH_smallDR")
        #if not self.eVetoZH_smallDR_branch and "eVetoZH_smallDR" not in self.complained:
        if not self.eVetoZH_smallDR_branch and "eVetoZH_smallDR":
            warnings.warn( "MuMuETauTree: Expected branch eVetoZH_smallDR does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eVetoZH_smallDR")
        else:
            self.eVetoZH_smallDR_branch.SetAddress(<void*>&self.eVetoZH_smallDR_value)

        #print "making eWWID"
        self.eWWID_branch = the_tree.GetBranch("eWWID")
        #if not self.eWWID_branch and "eWWID" not in self.complained:
        if not self.eWWID_branch and "eWWID":
            warnings.warn( "MuMuETauTree: Expected branch eWWID does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eWWID")
        else:
            self.eWWID_branch.SetAddress(<void*>&self.eWWID_value)

        #print "making e_m1_CosThetaStar"
        self.e_m1_CosThetaStar_branch = the_tree.GetBranch("e_m1_CosThetaStar")
        #if not self.e_m1_CosThetaStar_branch and "e_m1_CosThetaStar" not in self.complained:
        if not self.e_m1_CosThetaStar_branch and "e_m1_CosThetaStar":
            warnings.warn( "MuMuETauTree: Expected branch e_m1_CosThetaStar does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e_m1_CosThetaStar")
        else:
            self.e_m1_CosThetaStar_branch.SetAddress(<void*>&self.e_m1_CosThetaStar_value)

        #print "making e_m1_DPhi"
        self.e_m1_DPhi_branch = the_tree.GetBranch("e_m1_DPhi")
        #if not self.e_m1_DPhi_branch and "e_m1_DPhi" not in self.complained:
        if not self.e_m1_DPhi_branch and "e_m1_DPhi":
            warnings.warn( "MuMuETauTree: Expected branch e_m1_DPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e_m1_DPhi")
        else:
            self.e_m1_DPhi_branch.SetAddress(<void*>&self.e_m1_DPhi_value)

        #print "making e_m1_DR"
        self.e_m1_DR_branch = the_tree.GetBranch("e_m1_DR")
        #if not self.e_m1_DR_branch and "e_m1_DR" not in self.complained:
        if not self.e_m1_DR_branch and "e_m1_DR":
            warnings.warn( "MuMuETauTree: Expected branch e_m1_DR does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e_m1_DR")
        else:
            self.e_m1_DR_branch.SetAddress(<void*>&self.e_m1_DR_value)

        #print "making e_m1_Eta"
        self.e_m1_Eta_branch = the_tree.GetBranch("e_m1_Eta")
        #if not self.e_m1_Eta_branch and "e_m1_Eta" not in self.complained:
        if not self.e_m1_Eta_branch and "e_m1_Eta":
            warnings.warn( "MuMuETauTree: Expected branch e_m1_Eta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e_m1_Eta")
        else:
            self.e_m1_Eta_branch.SetAddress(<void*>&self.e_m1_Eta_value)

        #print "making e_m1_Mass"
        self.e_m1_Mass_branch = the_tree.GetBranch("e_m1_Mass")
        #if not self.e_m1_Mass_branch and "e_m1_Mass" not in self.complained:
        if not self.e_m1_Mass_branch and "e_m1_Mass":
            warnings.warn( "MuMuETauTree: Expected branch e_m1_Mass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e_m1_Mass")
        else:
            self.e_m1_Mass_branch.SetAddress(<void*>&self.e_m1_Mass_value)

        #print "making e_m1_MassFsr"
        self.e_m1_MassFsr_branch = the_tree.GetBranch("e_m1_MassFsr")
        #if not self.e_m1_MassFsr_branch and "e_m1_MassFsr" not in self.complained:
        if not self.e_m1_MassFsr_branch and "e_m1_MassFsr":
            warnings.warn( "MuMuETauTree: Expected branch e_m1_MassFsr does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e_m1_MassFsr")
        else:
            self.e_m1_MassFsr_branch.SetAddress(<void*>&self.e_m1_MassFsr_value)

        #print "making e_m1_PZeta"
        self.e_m1_PZeta_branch = the_tree.GetBranch("e_m1_PZeta")
        #if not self.e_m1_PZeta_branch and "e_m1_PZeta" not in self.complained:
        if not self.e_m1_PZeta_branch and "e_m1_PZeta":
            warnings.warn( "MuMuETauTree: Expected branch e_m1_PZeta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e_m1_PZeta")
        else:
            self.e_m1_PZeta_branch.SetAddress(<void*>&self.e_m1_PZeta_value)

        #print "making e_m1_PZetaVis"
        self.e_m1_PZetaVis_branch = the_tree.GetBranch("e_m1_PZetaVis")
        #if not self.e_m1_PZetaVis_branch and "e_m1_PZetaVis" not in self.complained:
        if not self.e_m1_PZetaVis_branch and "e_m1_PZetaVis":
            warnings.warn( "MuMuETauTree: Expected branch e_m1_PZetaVis does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e_m1_PZetaVis")
        else:
            self.e_m1_PZetaVis_branch.SetAddress(<void*>&self.e_m1_PZetaVis_value)

        #print "making e_m1_Phi"
        self.e_m1_Phi_branch = the_tree.GetBranch("e_m1_Phi")
        #if not self.e_m1_Phi_branch and "e_m1_Phi" not in self.complained:
        if not self.e_m1_Phi_branch and "e_m1_Phi":
            warnings.warn( "MuMuETauTree: Expected branch e_m1_Phi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e_m1_Phi")
        else:
            self.e_m1_Phi_branch.SetAddress(<void*>&self.e_m1_Phi_value)

        #print "making e_m1_Pt"
        self.e_m1_Pt_branch = the_tree.GetBranch("e_m1_Pt")
        #if not self.e_m1_Pt_branch and "e_m1_Pt" not in self.complained:
        if not self.e_m1_Pt_branch and "e_m1_Pt":
            warnings.warn( "MuMuETauTree: Expected branch e_m1_Pt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e_m1_Pt")
        else:
            self.e_m1_Pt_branch.SetAddress(<void*>&self.e_m1_Pt_value)

        #print "making e_m1_PtFsr"
        self.e_m1_PtFsr_branch = the_tree.GetBranch("e_m1_PtFsr")
        #if not self.e_m1_PtFsr_branch and "e_m1_PtFsr" not in self.complained:
        if not self.e_m1_PtFsr_branch and "e_m1_PtFsr":
            warnings.warn( "MuMuETauTree: Expected branch e_m1_PtFsr does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e_m1_PtFsr")
        else:
            self.e_m1_PtFsr_branch.SetAddress(<void*>&self.e_m1_PtFsr_value)

        #print "making e_m1_SS"
        self.e_m1_SS_branch = the_tree.GetBranch("e_m1_SS")
        #if not self.e_m1_SS_branch and "e_m1_SS" not in self.complained:
        if not self.e_m1_SS_branch and "e_m1_SS":
            warnings.warn( "MuMuETauTree: Expected branch e_m1_SS does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e_m1_SS")
        else:
            self.e_m1_SS_branch.SetAddress(<void*>&self.e_m1_SS_value)

        #print "making e_m1_SVfitEta"
        self.e_m1_SVfitEta_branch = the_tree.GetBranch("e_m1_SVfitEta")
        #if not self.e_m1_SVfitEta_branch and "e_m1_SVfitEta" not in self.complained:
        if not self.e_m1_SVfitEta_branch and "e_m1_SVfitEta":
            warnings.warn( "MuMuETauTree: Expected branch e_m1_SVfitEta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e_m1_SVfitEta")
        else:
            self.e_m1_SVfitEta_branch.SetAddress(<void*>&self.e_m1_SVfitEta_value)

        #print "making e_m1_SVfitMass"
        self.e_m1_SVfitMass_branch = the_tree.GetBranch("e_m1_SVfitMass")
        #if not self.e_m1_SVfitMass_branch and "e_m1_SVfitMass" not in self.complained:
        if not self.e_m1_SVfitMass_branch and "e_m1_SVfitMass":
            warnings.warn( "MuMuETauTree: Expected branch e_m1_SVfitMass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e_m1_SVfitMass")
        else:
            self.e_m1_SVfitMass_branch.SetAddress(<void*>&self.e_m1_SVfitMass_value)

        #print "making e_m1_SVfitPhi"
        self.e_m1_SVfitPhi_branch = the_tree.GetBranch("e_m1_SVfitPhi")
        #if not self.e_m1_SVfitPhi_branch and "e_m1_SVfitPhi" not in self.complained:
        if not self.e_m1_SVfitPhi_branch and "e_m1_SVfitPhi":
            warnings.warn( "MuMuETauTree: Expected branch e_m1_SVfitPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e_m1_SVfitPhi")
        else:
            self.e_m1_SVfitPhi_branch.SetAddress(<void*>&self.e_m1_SVfitPhi_value)

        #print "making e_m1_SVfitPt"
        self.e_m1_SVfitPt_branch = the_tree.GetBranch("e_m1_SVfitPt")
        #if not self.e_m1_SVfitPt_branch and "e_m1_SVfitPt" not in self.complained:
        if not self.e_m1_SVfitPt_branch and "e_m1_SVfitPt":
            warnings.warn( "MuMuETauTree: Expected branch e_m1_SVfitPt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e_m1_SVfitPt")
        else:
            self.e_m1_SVfitPt_branch.SetAddress(<void*>&self.e_m1_SVfitPt_value)

        #print "making e_m1_ToMETDPhi_Ty1"
        self.e_m1_ToMETDPhi_Ty1_branch = the_tree.GetBranch("e_m1_ToMETDPhi_Ty1")
        #if not self.e_m1_ToMETDPhi_Ty1_branch and "e_m1_ToMETDPhi_Ty1" not in self.complained:
        if not self.e_m1_ToMETDPhi_Ty1_branch and "e_m1_ToMETDPhi_Ty1":
            warnings.warn( "MuMuETauTree: Expected branch e_m1_ToMETDPhi_Ty1 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e_m1_ToMETDPhi_Ty1")
        else:
            self.e_m1_ToMETDPhi_Ty1_branch.SetAddress(<void*>&self.e_m1_ToMETDPhi_Ty1_value)

        #print "making e_m1_Zcompat"
        self.e_m1_Zcompat_branch = the_tree.GetBranch("e_m1_Zcompat")
        #if not self.e_m1_Zcompat_branch and "e_m1_Zcompat" not in self.complained:
        if not self.e_m1_Zcompat_branch and "e_m1_Zcompat":
            warnings.warn( "MuMuETauTree: Expected branch e_m1_Zcompat does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e_m1_Zcompat")
        else:
            self.e_m1_Zcompat_branch.SetAddress(<void*>&self.e_m1_Zcompat_value)

        #print "making e_m2_CosThetaStar"
        self.e_m2_CosThetaStar_branch = the_tree.GetBranch("e_m2_CosThetaStar")
        #if not self.e_m2_CosThetaStar_branch and "e_m2_CosThetaStar" not in self.complained:
        if not self.e_m2_CosThetaStar_branch and "e_m2_CosThetaStar":
            warnings.warn( "MuMuETauTree: Expected branch e_m2_CosThetaStar does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e_m2_CosThetaStar")
        else:
            self.e_m2_CosThetaStar_branch.SetAddress(<void*>&self.e_m2_CosThetaStar_value)

        #print "making e_m2_DPhi"
        self.e_m2_DPhi_branch = the_tree.GetBranch("e_m2_DPhi")
        #if not self.e_m2_DPhi_branch and "e_m2_DPhi" not in self.complained:
        if not self.e_m2_DPhi_branch and "e_m2_DPhi":
            warnings.warn( "MuMuETauTree: Expected branch e_m2_DPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e_m2_DPhi")
        else:
            self.e_m2_DPhi_branch.SetAddress(<void*>&self.e_m2_DPhi_value)

        #print "making e_m2_DR"
        self.e_m2_DR_branch = the_tree.GetBranch("e_m2_DR")
        #if not self.e_m2_DR_branch and "e_m2_DR" not in self.complained:
        if not self.e_m2_DR_branch and "e_m2_DR":
            warnings.warn( "MuMuETauTree: Expected branch e_m2_DR does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e_m2_DR")
        else:
            self.e_m2_DR_branch.SetAddress(<void*>&self.e_m2_DR_value)

        #print "making e_m2_Eta"
        self.e_m2_Eta_branch = the_tree.GetBranch("e_m2_Eta")
        #if not self.e_m2_Eta_branch and "e_m2_Eta" not in self.complained:
        if not self.e_m2_Eta_branch and "e_m2_Eta":
            warnings.warn( "MuMuETauTree: Expected branch e_m2_Eta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e_m2_Eta")
        else:
            self.e_m2_Eta_branch.SetAddress(<void*>&self.e_m2_Eta_value)

        #print "making e_m2_Mass"
        self.e_m2_Mass_branch = the_tree.GetBranch("e_m2_Mass")
        #if not self.e_m2_Mass_branch and "e_m2_Mass" not in self.complained:
        if not self.e_m2_Mass_branch and "e_m2_Mass":
            warnings.warn( "MuMuETauTree: Expected branch e_m2_Mass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e_m2_Mass")
        else:
            self.e_m2_Mass_branch.SetAddress(<void*>&self.e_m2_Mass_value)

        #print "making e_m2_MassFsr"
        self.e_m2_MassFsr_branch = the_tree.GetBranch("e_m2_MassFsr")
        #if not self.e_m2_MassFsr_branch and "e_m2_MassFsr" not in self.complained:
        if not self.e_m2_MassFsr_branch and "e_m2_MassFsr":
            warnings.warn( "MuMuETauTree: Expected branch e_m2_MassFsr does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e_m2_MassFsr")
        else:
            self.e_m2_MassFsr_branch.SetAddress(<void*>&self.e_m2_MassFsr_value)

        #print "making e_m2_PZeta"
        self.e_m2_PZeta_branch = the_tree.GetBranch("e_m2_PZeta")
        #if not self.e_m2_PZeta_branch and "e_m2_PZeta" not in self.complained:
        if not self.e_m2_PZeta_branch and "e_m2_PZeta":
            warnings.warn( "MuMuETauTree: Expected branch e_m2_PZeta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e_m2_PZeta")
        else:
            self.e_m2_PZeta_branch.SetAddress(<void*>&self.e_m2_PZeta_value)

        #print "making e_m2_PZetaVis"
        self.e_m2_PZetaVis_branch = the_tree.GetBranch("e_m2_PZetaVis")
        #if not self.e_m2_PZetaVis_branch and "e_m2_PZetaVis" not in self.complained:
        if not self.e_m2_PZetaVis_branch and "e_m2_PZetaVis":
            warnings.warn( "MuMuETauTree: Expected branch e_m2_PZetaVis does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e_m2_PZetaVis")
        else:
            self.e_m2_PZetaVis_branch.SetAddress(<void*>&self.e_m2_PZetaVis_value)

        #print "making e_m2_Phi"
        self.e_m2_Phi_branch = the_tree.GetBranch("e_m2_Phi")
        #if not self.e_m2_Phi_branch and "e_m2_Phi" not in self.complained:
        if not self.e_m2_Phi_branch and "e_m2_Phi":
            warnings.warn( "MuMuETauTree: Expected branch e_m2_Phi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e_m2_Phi")
        else:
            self.e_m2_Phi_branch.SetAddress(<void*>&self.e_m2_Phi_value)

        #print "making e_m2_Pt"
        self.e_m2_Pt_branch = the_tree.GetBranch("e_m2_Pt")
        #if not self.e_m2_Pt_branch and "e_m2_Pt" not in self.complained:
        if not self.e_m2_Pt_branch and "e_m2_Pt":
            warnings.warn( "MuMuETauTree: Expected branch e_m2_Pt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e_m2_Pt")
        else:
            self.e_m2_Pt_branch.SetAddress(<void*>&self.e_m2_Pt_value)

        #print "making e_m2_PtFsr"
        self.e_m2_PtFsr_branch = the_tree.GetBranch("e_m2_PtFsr")
        #if not self.e_m2_PtFsr_branch and "e_m2_PtFsr" not in self.complained:
        if not self.e_m2_PtFsr_branch and "e_m2_PtFsr":
            warnings.warn( "MuMuETauTree: Expected branch e_m2_PtFsr does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e_m2_PtFsr")
        else:
            self.e_m2_PtFsr_branch.SetAddress(<void*>&self.e_m2_PtFsr_value)

        #print "making e_m2_SS"
        self.e_m2_SS_branch = the_tree.GetBranch("e_m2_SS")
        #if not self.e_m2_SS_branch and "e_m2_SS" not in self.complained:
        if not self.e_m2_SS_branch and "e_m2_SS":
            warnings.warn( "MuMuETauTree: Expected branch e_m2_SS does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e_m2_SS")
        else:
            self.e_m2_SS_branch.SetAddress(<void*>&self.e_m2_SS_value)

        #print "making e_m2_ToMETDPhi_Ty1"
        self.e_m2_ToMETDPhi_Ty1_branch = the_tree.GetBranch("e_m2_ToMETDPhi_Ty1")
        #if not self.e_m2_ToMETDPhi_Ty1_branch and "e_m2_ToMETDPhi_Ty1" not in self.complained:
        if not self.e_m2_ToMETDPhi_Ty1_branch and "e_m2_ToMETDPhi_Ty1":
            warnings.warn( "MuMuETauTree: Expected branch e_m2_ToMETDPhi_Ty1 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e_m2_ToMETDPhi_Ty1")
        else:
            self.e_m2_ToMETDPhi_Ty1_branch.SetAddress(<void*>&self.e_m2_ToMETDPhi_Ty1_value)

        #print "making e_m2_Zcompat"
        self.e_m2_Zcompat_branch = the_tree.GetBranch("e_m2_Zcompat")
        #if not self.e_m2_Zcompat_branch and "e_m2_Zcompat" not in self.complained:
        if not self.e_m2_Zcompat_branch and "e_m2_Zcompat":
            warnings.warn( "MuMuETauTree: Expected branch e_m2_Zcompat does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e_m2_Zcompat")
        else:
            self.e_m2_Zcompat_branch.SetAddress(<void*>&self.e_m2_Zcompat_value)

        #print "making e_t_CosThetaStar"
        self.e_t_CosThetaStar_branch = the_tree.GetBranch("e_t_CosThetaStar")
        #if not self.e_t_CosThetaStar_branch and "e_t_CosThetaStar" not in self.complained:
        if not self.e_t_CosThetaStar_branch and "e_t_CosThetaStar":
            warnings.warn( "MuMuETauTree: Expected branch e_t_CosThetaStar does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e_t_CosThetaStar")
        else:
            self.e_t_CosThetaStar_branch.SetAddress(<void*>&self.e_t_CosThetaStar_value)

        #print "making e_t_DPhi"
        self.e_t_DPhi_branch = the_tree.GetBranch("e_t_DPhi")
        #if not self.e_t_DPhi_branch and "e_t_DPhi" not in self.complained:
        if not self.e_t_DPhi_branch and "e_t_DPhi":
            warnings.warn( "MuMuETauTree: Expected branch e_t_DPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e_t_DPhi")
        else:
            self.e_t_DPhi_branch.SetAddress(<void*>&self.e_t_DPhi_value)

        #print "making e_t_DR"
        self.e_t_DR_branch = the_tree.GetBranch("e_t_DR")
        #if not self.e_t_DR_branch and "e_t_DR" not in self.complained:
        if not self.e_t_DR_branch and "e_t_DR":
            warnings.warn( "MuMuETauTree: Expected branch e_t_DR does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e_t_DR")
        else:
            self.e_t_DR_branch.SetAddress(<void*>&self.e_t_DR_value)

        #print "making e_t_Eta"
        self.e_t_Eta_branch = the_tree.GetBranch("e_t_Eta")
        #if not self.e_t_Eta_branch and "e_t_Eta" not in self.complained:
        if not self.e_t_Eta_branch and "e_t_Eta":
            warnings.warn( "MuMuETauTree: Expected branch e_t_Eta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e_t_Eta")
        else:
            self.e_t_Eta_branch.SetAddress(<void*>&self.e_t_Eta_value)

        #print "making e_t_Mass"
        self.e_t_Mass_branch = the_tree.GetBranch("e_t_Mass")
        #if not self.e_t_Mass_branch and "e_t_Mass" not in self.complained:
        if not self.e_t_Mass_branch and "e_t_Mass":
            warnings.warn( "MuMuETauTree: Expected branch e_t_Mass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e_t_Mass")
        else:
            self.e_t_Mass_branch.SetAddress(<void*>&self.e_t_Mass_value)

        #print "making e_t_MassFsr"
        self.e_t_MassFsr_branch = the_tree.GetBranch("e_t_MassFsr")
        #if not self.e_t_MassFsr_branch and "e_t_MassFsr" not in self.complained:
        if not self.e_t_MassFsr_branch and "e_t_MassFsr":
            warnings.warn( "MuMuETauTree: Expected branch e_t_MassFsr does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e_t_MassFsr")
        else:
            self.e_t_MassFsr_branch.SetAddress(<void*>&self.e_t_MassFsr_value)

        #print "making e_t_PZeta"
        self.e_t_PZeta_branch = the_tree.GetBranch("e_t_PZeta")
        #if not self.e_t_PZeta_branch and "e_t_PZeta" not in self.complained:
        if not self.e_t_PZeta_branch and "e_t_PZeta":
            warnings.warn( "MuMuETauTree: Expected branch e_t_PZeta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e_t_PZeta")
        else:
            self.e_t_PZeta_branch.SetAddress(<void*>&self.e_t_PZeta_value)

        #print "making e_t_PZetaVis"
        self.e_t_PZetaVis_branch = the_tree.GetBranch("e_t_PZetaVis")
        #if not self.e_t_PZetaVis_branch and "e_t_PZetaVis" not in self.complained:
        if not self.e_t_PZetaVis_branch and "e_t_PZetaVis":
            warnings.warn( "MuMuETauTree: Expected branch e_t_PZetaVis does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e_t_PZetaVis")
        else:
            self.e_t_PZetaVis_branch.SetAddress(<void*>&self.e_t_PZetaVis_value)

        #print "making e_t_Phi"
        self.e_t_Phi_branch = the_tree.GetBranch("e_t_Phi")
        #if not self.e_t_Phi_branch and "e_t_Phi" not in self.complained:
        if not self.e_t_Phi_branch and "e_t_Phi":
            warnings.warn( "MuMuETauTree: Expected branch e_t_Phi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e_t_Phi")
        else:
            self.e_t_Phi_branch.SetAddress(<void*>&self.e_t_Phi_value)

        #print "making e_t_Pt"
        self.e_t_Pt_branch = the_tree.GetBranch("e_t_Pt")
        #if not self.e_t_Pt_branch and "e_t_Pt" not in self.complained:
        if not self.e_t_Pt_branch and "e_t_Pt":
            warnings.warn( "MuMuETauTree: Expected branch e_t_Pt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e_t_Pt")
        else:
            self.e_t_Pt_branch.SetAddress(<void*>&self.e_t_Pt_value)

        #print "making e_t_PtFsr"
        self.e_t_PtFsr_branch = the_tree.GetBranch("e_t_PtFsr")
        #if not self.e_t_PtFsr_branch and "e_t_PtFsr" not in self.complained:
        if not self.e_t_PtFsr_branch and "e_t_PtFsr":
            warnings.warn( "MuMuETauTree: Expected branch e_t_PtFsr does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e_t_PtFsr")
        else:
            self.e_t_PtFsr_branch.SetAddress(<void*>&self.e_t_PtFsr_value)

        #print "making e_t_SS"
        self.e_t_SS_branch = the_tree.GetBranch("e_t_SS")
        #if not self.e_t_SS_branch and "e_t_SS" not in self.complained:
        if not self.e_t_SS_branch and "e_t_SS":
            warnings.warn( "MuMuETauTree: Expected branch e_t_SS does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e_t_SS")
        else:
            self.e_t_SS_branch.SetAddress(<void*>&self.e_t_SS_value)

        #print "making e_t_SVfitEta"
        self.e_t_SVfitEta_branch = the_tree.GetBranch("e_t_SVfitEta")
        #if not self.e_t_SVfitEta_branch and "e_t_SVfitEta" not in self.complained:
        if not self.e_t_SVfitEta_branch and "e_t_SVfitEta":
            warnings.warn( "MuMuETauTree: Expected branch e_t_SVfitEta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e_t_SVfitEta")
        else:
            self.e_t_SVfitEta_branch.SetAddress(<void*>&self.e_t_SVfitEta_value)

        #print "making e_t_SVfitMass"
        self.e_t_SVfitMass_branch = the_tree.GetBranch("e_t_SVfitMass")
        #if not self.e_t_SVfitMass_branch and "e_t_SVfitMass" not in self.complained:
        if not self.e_t_SVfitMass_branch and "e_t_SVfitMass":
            warnings.warn( "MuMuETauTree: Expected branch e_t_SVfitMass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e_t_SVfitMass")
        else:
            self.e_t_SVfitMass_branch.SetAddress(<void*>&self.e_t_SVfitMass_value)

        #print "making e_t_SVfitPhi"
        self.e_t_SVfitPhi_branch = the_tree.GetBranch("e_t_SVfitPhi")
        #if not self.e_t_SVfitPhi_branch and "e_t_SVfitPhi" not in self.complained:
        if not self.e_t_SVfitPhi_branch and "e_t_SVfitPhi":
            warnings.warn( "MuMuETauTree: Expected branch e_t_SVfitPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e_t_SVfitPhi")
        else:
            self.e_t_SVfitPhi_branch.SetAddress(<void*>&self.e_t_SVfitPhi_value)

        #print "making e_t_SVfitPt"
        self.e_t_SVfitPt_branch = the_tree.GetBranch("e_t_SVfitPt")
        #if not self.e_t_SVfitPt_branch and "e_t_SVfitPt" not in self.complained:
        if not self.e_t_SVfitPt_branch and "e_t_SVfitPt":
            warnings.warn( "MuMuETauTree: Expected branch e_t_SVfitPt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e_t_SVfitPt")
        else:
            self.e_t_SVfitPt_branch.SetAddress(<void*>&self.e_t_SVfitPt_value)

        #print "making e_t_ToMETDPhi_Ty1"
        self.e_t_ToMETDPhi_Ty1_branch = the_tree.GetBranch("e_t_ToMETDPhi_Ty1")
        #if not self.e_t_ToMETDPhi_Ty1_branch and "e_t_ToMETDPhi_Ty1" not in self.complained:
        if not self.e_t_ToMETDPhi_Ty1_branch and "e_t_ToMETDPhi_Ty1":
            warnings.warn( "MuMuETauTree: Expected branch e_t_ToMETDPhi_Ty1 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e_t_ToMETDPhi_Ty1")
        else:
            self.e_t_ToMETDPhi_Ty1_branch.SetAddress(<void*>&self.e_t_ToMETDPhi_Ty1_value)

        #print "making e_t_Zcompat"
        self.e_t_Zcompat_branch = the_tree.GetBranch("e_t_Zcompat")
        #if not self.e_t_Zcompat_branch and "e_t_Zcompat" not in self.complained:
        if not self.e_t_Zcompat_branch and "e_t_Zcompat":
            warnings.warn( "MuMuETauTree: Expected branch e_t_Zcompat does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e_t_Zcompat")
        else:
            self.e_t_Zcompat_branch.SetAddress(<void*>&self.e_t_Zcompat_value)

        #print "making edECorrReg_2012Jul13ReReco"
        self.edECorrReg_2012Jul13ReReco_branch = the_tree.GetBranch("edECorrReg_2012Jul13ReReco")
        #if not self.edECorrReg_2012Jul13ReReco_branch and "edECorrReg_2012Jul13ReReco" not in self.complained:
        if not self.edECorrReg_2012Jul13ReReco_branch and "edECorrReg_2012Jul13ReReco":
            warnings.warn( "MuMuETauTree: Expected branch edECorrReg_2012Jul13ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("edECorrReg_2012Jul13ReReco")
        else:
            self.edECorrReg_2012Jul13ReReco_branch.SetAddress(<void*>&self.edECorrReg_2012Jul13ReReco_value)

        #print "making edECorrReg_Fall11"
        self.edECorrReg_Fall11_branch = the_tree.GetBranch("edECorrReg_Fall11")
        #if not self.edECorrReg_Fall11_branch and "edECorrReg_Fall11" not in self.complained:
        if not self.edECorrReg_Fall11_branch and "edECorrReg_Fall11":
            warnings.warn( "MuMuETauTree: Expected branch edECorrReg_Fall11 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("edECorrReg_Fall11")
        else:
            self.edECorrReg_Fall11_branch.SetAddress(<void*>&self.edECorrReg_Fall11_value)

        #print "making edECorrReg_Jan16ReReco"
        self.edECorrReg_Jan16ReReco_branch = the_tree.GetBranch("edECorrReg_Jan16ReReco")
        #if not self.edECorrReg_Jan16ReReco_branch and "edECorrReg_Jan16ReReco" not in self.complained:
        if not self.edECorrReg_Jan16ReReco_branch and "edECorrReg_Jan16ReReco":
            warnings.warn( "MuMuETauTree: Expected branch edECorrReg_Jan16ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("edECorrReg_Jan16ReReco")
        else:
            self.edECorrReg_Jan16ReReco_branch.SetAddress(<void*>&self.edECorrReg_Jan16ReReco_value)

        #print "making edECorrReg_Summer12_DR53X_HCP2012"
        self.edECorrReg_Summer12_DR53X_HCP2012_branch = the_tree.GetBranch("edECorrReg_Summer12_DR53X_HCP2012")
        #if not self.edECorrReg_Summer12_DR53X_HCP2012_branch and "edECorrReg_Summer12_DR53X_HCP2012" not in self.complained:
        if not self.edECorrReg_Summer12_DR53X_HCP2012_branch and "edECorrReg_Summer12_DR53X_HCP2012":
            warnings.warn( "MuMuETauTree: Expected branch edECorrReg_Summer12_DR53X_HCP2012 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("edECorrReg_Summer12_DR53X_HCP2012")
        else:
            self.edECorrReg_Summer12_DR53X_HCP2012_branch.SetAddress(<void*>&self.edECorrReg_Summer12_DR53X_HCP2012_value)

        #print "making edECorrSmearedNoReg_2012Jul13ReReco"
        self.edECorrSmearedNoReg_2012Jul13ReReco_branch = the_tree.GetBranch("edECorrSmearedNoReg_2012Jul13ReReco")
        #if not self.edECorrSmearedNoReg_2012Jul13ReReco_branch and "edECorrSmearedNoReg_2012Jul13ReReco" not in self.complained:
        if not self.edECorrSmearedNoReg_2012Jul13ReReco_branch and "edECorrSmearedNoReg_2012Jul13ReReco":
            warnings.warn( "MuMuETauTree: Expected branch edECorrSmearedNoReg_2012Jul13ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("edECorrSmearedNoReg_2012Jul13ReReco")
        else:
            self.edECorrSmearedNoReg_2012Jul13ReReco_branch.SetAddress(<void*>&self.edECorrSmearedNoReg_2012Jul13ReReco_value)

        #print "making edECorrSmearedNoReg_Fall11"
        self.edECorrSmearedNoReg_Fall11_branch = the_tree.GetBranch("edECorrSmearedNoReg_Fall11")
        #if not self.edECorrSmearedNoReg_Fall11_branch and "edECorrSmearedNoReg_Fall11" not in self.complained:
        if not self.edECorrSmearedNoReg_Fall11_branch and "edECorrSmearedNoReg_Fall11":
            warnings.warn( "MuMuETauTree: Expected branch edECorrSmearedNoReg_Fall11 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("edECorrSmearedNoReg_Fall11")
        else:
            self.edECorrSmearedNoReg_Fall11_branch.SetAddress(<void*>&self.edECorrSmearedNoReg_Fall11_value)

        #print "making edECorrSmearedNoReg_Jan16ReReco"
        self.edECorrSmearedNoReg_Jan16ReReco_branch = the_tree.GetBranch("edECorrSmearedNoReg_Jan16ReReco")
        #if not self.edECorrSmearedNoReg_Jan16ReReco_branch and "edECorrSmearedNoReg_Jan16ReReco" not in self.complained:
        if not self.edECorrSmearedNoReg_Jan16ReReco_branch and "edECorrSmearedNoReg_Jan16ReReco":
            warnings.warn( "MuMuETauTree: Expected branch edECorrSmearedNoReg_Jan16ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("edECorrSmearedNoReg_Jan16ReReco")
        else:
            self.edECorrSmearedNoReg_Jan16ReReco_branch.SetAddress(<void*>&self.edECorrSmearedNoReg_Jan16ReReco_value)

        #print "making edECorrSmearedNoReg_Summer12_DR53X_HCP2012"
        self.edECorrSmearedNoReg_Summer12_DR53X_HCP2012_branch = the_tree.GetBranch("edECorrSmearedNoReg_Summer12_DR53X_HCP2012")
        #if not self.edECorrSmearedNoReg_Summer12_DR53X_HCP2012_branch and "edECorrSmearedNoReg_Summer12_DR53X_HCP2012" not in self.complained:
        if not self.edECorrSmearedNoReg_Summer12_DR53X_HCP2012_branch and "edECorrSmearedNoReg_Summer12_DR53X_HCP2012":
            warnings.warn( "MuMuETauTree: Expected branch edECorrSmearedNoReg_Summer12_DR53X_HCP2012 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("edECorrSmearedNoReg_Summer12_DR53X_HCP2012")
        else:
            self.edECorrSmearedNoReg_Summer12_DR53X_HCP2012_branch.SetAddress(<void*>&self.edECorrSmearedNoReg_Summer12_DR53X_HCP2012_value)

        #print "making edECorrSmearedReg_2012Jul13ReReco"
        self.edECorrSmearedReg_2012Jul13ReReco_branch = the_tree.GetBranch("edECorrSmearedReg_2012Jul13ReReco")
        #if not self.edECorrSmearedReg_2012Jul13ReReco_branch and "edECorrSmearedReg_2012Jul13ReReco" not in self.complained:
        if not self.edECorrSmearedReg_2012Jul13ReReco_branch and "edECorrSmearedReg_2012Jul13ReReco":
            warnings.warn( "MuMuETauTree: Expected branch edECorrSmearedReg_2012Jul13ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("edECorrSmearedReg_2012Jul13ReReco")
        else:
            self.edECorrSmearedReg_2012Jul13ReReco_branch.SetAddress(<void*>&self.edECorrSmearedReg_2012Jul13ReReco_value)

        #print "making edECorrSmearedReg_Fall11"
        self.edECorrSmearedReg_Fall11_branch = the_tree.GetBranch("edECorrSmearedReg_Fall11")
        #if not self.edECorrSmearedReg_Fall11_branch and "edECorrSmearedReg_Fall11" not in self.complained:
        if not self.edECorrSmearedReg_Fall11_branch and "edECorrSmearedReg_Fall11":
            warnings.warn( "MuMuETauTree: Expected branch edECorrSmearedReg_Fall11 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("edECorrSmearedReg_Fall11")
        else:
            self.edECorrSmearedReg_Fall11_branch.SetAddress(<void*>&self.edECorrSmearedReg_Fall11_value)

        #print "making edECorrSmearedReg_Jan16ReReco"
        self.edECorrSmearedReg_Jan16ReReco_branch = the_tree.GetBranch("edECorrSmearedReg_Jan16ReReco")
        #if not self.edECorrSmearedReg_Jan16ReReco_branch and "edECorrSmearedReg_Jan16ReReco" not in self.complained:
        if not self.edECorrSmearedReg_Jan16ReReco_branch and "edECorrSmearedReg_Jan16ReReco":
            warnings.warn( "MuMuETauTree: Expected branch edECorrSmearedReg_Jan16ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("edECorrSmearedReg_Jan16ReReco")
        else:
            self.edECorrSmearedReg_Jan16ReReco_branch.SetAddress(<void*>&self.edECorrSmearedReg_Jan16ReReco_value)

        #print "making edECorrSmearedReg_Summer12_DR53X_HCP2012"
        self.edECorrSmearedReg_Summer12_DR53X_HCP2012_branch = the_tree.GetBranch("edECorrSmearedReg_Summer12_DR53X_HCP2012")
        #if not self.edECorrSmearedReg_Summer12_DR53X_HCP2012_branch and "edECorrSmearedReg_Summer12_DR53X_HCP2012" not in self.complained:
        if not self.edECorrSmearedReg_Summer12_DR53X_HCP2012_branch and "edECorrSmearedReg_Summer12_DR53X_HCP2012":
            warnings.warn( "MuMuETauTree: Expected branch edECorrSmearedReg_Summer12_DR53X_HCP2012 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("edECorrSmearedReg_Summer12_DR53X_HCP2012")
        else:
            self.edECorrSmearedReg_Summer12_DR53X_HCP2012_branch.SetAddress(<void*>&self.edECorrSmearedReg_Summer12_DR53X_HCP2012_value)

        #print "making edeltaEtaSuperClusterTrackAtVtx"
        self.edeltaEtaSuperClusterTrackAtVtx_branch = the_tree.GetBranch("edeltaEtaSuperClusterTrackAtVtx")
        #if not self.edeltaEtaSuperClusterTrackAtVtx_branch and "edeltaEtaSuperClusterTrackAtVtx" not in self.complained:
        if not self.edeltaEtaSuperClusterTrackAtVtx_branch and "edeltaEtaSuperClusterTrackAtVtx":
            warnings.warn( "MuMuETauTree: Expected branch edeltaEtaSuperClusterTrackAtVtx does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("edeltaEtaSuperClusterTrackAtVtx")
        else:
            self.edeltaEtaSuperClusterTrackAtVtx_branch.SetAddress(<void*>&self.edeltaEtaSuperClusterTrackAtVtx_value)

        #print "making edeltaPhiSuperClusterTrackAtVtx"
        self.edeltaPhiSuperClusterTrackAtVtx_branch = the_tree.GetBranch("edeltaPhiSuperClusterTrackAtVtx")
        #if not self.edeltaPhiSuperClusterTrackAtVtx_branch and "edeltaPhiSuperClusterTrackAtVtx" not in self.complained:
        if not self.edeltaPhiSuperClusterTrackAtVtx_branch and "edeltaPhiSuperClusterTrackAtVtx":
            warnings.warn( "MuMuETauTree: Expected branch edeltaPhiSuperClusterTrackAtVtx does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("edeltaPhiSuperClusterTrackAtVtx")
        else:
            self.edeltaPhiSuperClusterTrackAtVtx_branch.SetAddress(<void*>&self.edeltaPhiSuperClusterTrackAtVtx_value)

        #print "making eeSuperClusterOverP"
        self.eeSuperClusterOverP_branch = the_tree.GetBranch("eeSuperClusterOverP")
        #if not self.eeSuperClusterOverP_branch and "eeSuperClusterOverP" not in self.complained:
        if not self.eeSuperClusterOverP_branch and "eeSuperClusterOverP":
            warnings.warn( "MuMuETauTree: Expected branch eeSuperClusterOverP does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eeSuperClusterOverP")
        else:
            self.eeSuperClusterOverP_branch.SetAddress(<void*>&self.eeSuperClusterOverP_value)

        #print "making eecalEnergy"
        self.eecalEnergy_branch = the_tree.GetBranch("eecalEnergy")
        #if not self.eecalEnergy_branch and "eecalEnergy" not in self.complained:
        if not self.eecalEnergy_branch and "eecalEnergy":
            warnings.warn( "MuMuETauTree: Expected branch eecalEnergy does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eecalEnergy")
        else:
            self.eecalEnergy_branch.SetAddress(<void*>&self.eecalEnergy_value)

        #print "making efBrem"
        self.efBrem_branch = the_tree.GetBranch("efBrem")
        #if not self.efBrem_branch and "efBrem" not in self.complained:
        if not self.efBrem_branch and "efBrem":
            warnings.warn( "MuMuETauTree: Expected branch efBrem does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("efBrem")
        else:
            self.efBrem_branch.SetAddress(<void*>&self.efBrem_value)

        #print "making etrackMomentumAtVtxP"
        self.etrackMomentumAtVtxP_branch = the_tree.GetBranch("etrackMomentumAtVtxP")
        #if not self.etrackMomentumAtVtxP_branch and "etrackMomentumAtVtxP" not in self.complained:
        if not self.etrackMomentumAtVtxP_branch and "etrackMomentumAtVtxP":
            warnings.warn( "MuMuETauTree: Expected branch etrackMomentumAtVtxP does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("etrackMomentumAtVtxP")
        else:
            self.etrackMomentumAtVtxP_branch.SetAddress(<void*>&self.etrackMomentumAtVtxP_value)

        #print "making evt"
        self.evt_branch = the_tree.GetBranch("evt")
        #if not self.evt_branch and "evt" not in self.complained:
        if not self.evt_branch and "evt":
            warnings.warn( "MuMuETauTree: Expected branch evt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("evt")
        else:
            self.evt_branch.SetAddress(<void*>&self.evt_value)

        #print "making isGtautau"
        self.isGtautau_branch = the_tree.GetBranch("isGtautau")
        #if not self.isGtautau_branch and "isGtautau" not in self.complained:
        if not self.isGtautau_branch and "isGtautau":
            warnings.warn( "MuMuETauTree: Expected branch isGtautau does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("isGtautau")
        else:
            self.isGtautau_branch.SetAddress(<void*>&self.isGtautau_value)

        #print "making isWmunu"
        self.isWmunu_branch = the_tree.GetBranch("isWmunu")
        #if not self.isWmunu_branch and "isWmunu" not in self.complained:
        if not self.isWmunu_branch and "isWmunu":
            warnings.warn( "MuMuETauTree: Expected branch isWmunu does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("isWmunu")
        else:
            self.isWmunu_branch.SetAddress(<void*>&self.isWmunu_value)

        #print "making isWtaunu"
        self.isWtaunu_branch = the_tree.GetBranch("isWtaunu")
        #if not self.isWtaunu_branch and "isWtaunu" not in self.complained:
        if not self.isWtaunu_branch and "isWtaunu":
            warnings.warn( "MuMuETauTree: Expected branch isWtaunu does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("isWtaunu")
        else:
            self.isWtaunu_branch.SetAddress(<void*>&self.isWtaunu_value)

        #print "making isZtautau"
        self.isZtautau_branch = the_tree.GetBranch("isZtautau")
        #if not self.isZtautau_branch and "isZtautau" not in self.complained:
        if not self.isZtautau_branch and "isZtautau":
            warnings.warn( "MuMuETauTree: Expected branch isZtautau does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("isZtautau")
        else:
            self.isZtautau_branch.SetAddress(<void*>&self.isZtautau_value)

        #print "making isdata"
        self.isdata_branch = the_tree.GetBranch("isdata")
        #if not self.isdata_branch and "isdata" not in self.complained:
        if not self.isdata_branch and "isdata":
            warnings.warn( "MuMuETauTree: Expected branch isdata does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("isdata")
        else:
            self.isdata_branch.SetAddress(<void*>&self.isdata_value)

        #print "making isoMu24eta2p1Group"
        self.isoMu24eta2p1Group_branch = the_tree.GetBranch("isoMu24eta2p1Group")
        #if not self.isoMu24eta2p1Group_branch and "isoMu24eta2p1Group" not in self.complained:
        if not self.isoMu24eta2p1Group_branch and "isoMu24eta2p1Group":
            warnings.warn( "MuMuETauTree: Expected branch isoMu24eta2p1Group does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("isoMu24eta2p1Group")
        else:
            self.isoMu24eta2p1Group_branch.SetAddress(<void*>&self.isoMu24eta2p1Group_value)

        #print "making isoMu24eta2p1Pass"
        self.isoMu24eta2p1Pass_branch = the_tree.GetBranch("isoMu24eta2p1Pass")
        #if not self.isoMu24eta2p1Pass_branch and "isoMu24eta2p1Pass" not in self.complained:
        if not self.isoMu24eta2p1Pass_branch and "isoMu24eta2p1Pass":
            warnings.warn( "MuMuETauTree: Expected branch isoMu24eta2p1Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("isoMu24eta2p1Pass")
        else:
            self.isoMu24eta2p1Pass_branch.SetAddress(<void*>&self.isoMu24eta2p1Pass_value)

        #print "making isoMu24eta2p1Prescale"
        self.isoMu24eta2p1Prescale_branch = the_tree.GetBranch("isoMu24eta2p1Prescale")
        #if not self.isoMu24eta2p1Prescale_branch and "isoMu24eta2p1Prescale" not in self.complained:
        if not self.isoMu24eta2p1Prescale_branch and "isoMu24eta2p1Prescale":
            warnings.warn( "MuMuETauTree: Expected branch isoMu24eta2p1Prescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("isoMu24eta2p1Prescale")
        else:
            self.isoMu24eta2p1Prescale_branch.SetAddress(<void*>&self.isoMu24eta2p1Prescale_value)

        #print "making isoMuGroup"
        self.isoMuGroup_branch = the_tree.GetBranch("isoMuGroup")
        #if not self.isoMuGroup_branch and "isoMuGroup" not in self.complained:
        if not self.isoMuGroup_branch and "isoMuGroup":
            warnings.warn( "MuMuETauTree: Expected branch isoMuGroup does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("isoMuGroup")
        else:
            self.isoMuGroup_branch.SetAddress(<void*>&self.isoMuGroup_value)

        #print "making isoMuPass"
        self.isoMuPass_branch = the_tree.GetBranch("isoMuPass")
        #if not self.isoMuPass_branch and "isoMuPass" not in self.complained:
        if not self.isoMuPass_branch and "isoMuPass":
            warnings.warn( "MuMuETauTree: Expected branch isoMuPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("isoMuPass")
        else:
            self.isoMuPass_branch.SetAddress(<void*>&self.isoMuPass_value)

        #print "making isoMuPrescale"
        self.isoMuPrescale_branch = the_tree.GetBranch("isoMuPrescale")
        #if not self.isoMuPrescale_branch and "isoMuPrescale" not in self.complained:
        if not self.isoMuPrescale_branch and "isoMuPrescale":
            warnings.warn( "MuMuETauTree: Expected branch isoMuPrescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("isoMuPrescale")
        else:
            self.isoMuPrescale_branch.SetAddress(<void*>&self.isoMuPrescale_value)

        #print "making isoMuTauGroup"
        self.isoMuTauGroup_branch = the_tree.GetBranch("isoMuTauGroup")
        #if not self.isoMuTauGroup_branch and "isoMuTauGroup" not in self.complained:
        if not self.isoMuTauGroup_branch and "isoMuTauGroup":
            warnings.warn( "MuMuETauTree: Expected branch isoMuTauGroup does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("isoMuTauGroup")
        else:
            self.isoMuTauGroup_branch.SetAddress(<void*>&self.isoMuTauGroup_value)

        #print "making isoMuTauPass"
        self.isoMuTauPass_branch = the_tree.GetBranch("isoMuTauPass")
        #if not self.isoMuTauPass_branch and "isoMuTauPass" not in self.complained:
        if not self.isoMuTauPass_branch and "isoMuTauPass":
            warnings.warn( "MuMuETauTree: Expected branch isoMuTauPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("isoMuTauPass")
        else:
            self.isoMuTauPass_branch.SetAddress(<void*>&self.isoMuTauPass_value)

        #print "making isoMuTauPrescale"
        self.isoMuTauPrescale_branch = the_tree.GetBranch("isoMuTauPrescale")
        #if not self.isoMuTauPrescale_branch and "isoMuTauPrescale" not in self.complained:
        if not self.isoMuTauPrescale_branch and "isoMuTauPrescale":
            warnings.warn( "MuMuETauTree: Expected branch isoMuTauPrescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("isoMuTauPrescale")
        else:
            self.isoMuTauPrescale_branch.SetAddress(<void*>&self.isoMuTauPrescale_value)

        #print "making jetVeto20"
        self.jetVeto20_branch = the_tree.GetBranch("jetVeto20")
        #if not self.jetVeto20_branch and "jetVeto20" not in self.complained:
        if not self.jetVeto20_branch and "jetVeto20":
            warnings.warn( "MuMuETauTree: Expected branch jetVeto20 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto20")
        else:
            self.jetVeto20_branch.SetAddress(<void*>&self.jetVeto20_value)

        #print "making jetVeto20_DR05"
        self.jetVeto20_DR05_branch = the_tree.GetBranch("jetVeto20_DR05")
        #if not self.jetVeto20_DR05_branch and "jetVeto20_DR05" not in self.complained:
        if not self.jetVeto20_DR05_branch and "jetVeto20_DR05":
            warnings.warn( "MuMuETauTree: Expected branch jetVeto20_DR05 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto20_DR05")
        else:
            self.jetVeto20_DR05_branch.SetAddress(<void*>&self.jetVeto20_DR05_value)

        #print "making jetVeto30"
        self.jetVeto30_branch = the_tree.GetBranch("jetVeto30")
        #if not self.jetVeto30_branch and "jetVeto30" not in self.complained:
        if not self.jetVeto30_branch and "jetVeto30":
            warnings.warn( "MuMuETauTree: Expected branch jetVeto30 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30")
        else:
            self.jetVeto30_branch.SetAddress(<void*>&self.jetVeto30_value)

        #print "making jetVeto30_DR05"
        self.jetVeto30_DR05_branch = the_tree.GetBranch("jetVeto30_DR05")
        #if not self.jetVeto30_DR05_branch and "jetVeto30_DR05" not in self.complained:
        if not self.jetVeto30_DR05_branch and "jetVeto30_DR05":
            warnings.warn( "MuMuETauTree: Expected branch jetVeto30_DR05 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_DR05")
        else:
            self.jetVeto30_DR05_branch.SetAddress(<void*>&self.jetVeto30_DR05_value)

        #print "making jetVeto40"
        self.jetVeto40_branch = the_tree.GetBranch("jetVeto40")
        #if not self.jetVeto40_branch and "jetVeto40" not in self.complained:
        if not self.jetVeto40_branch and "jetVeto40":
            warnings.warn( "MuMuETauTree: Expected branch jetVeto40 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto40")
        else:
            self.jetVeto40_branch.SetAddress(<void*>&self.jetVeto40_value)

        #print "making jetVeto40_DR05"
        self.jetVeto40_DR05_branch = the_tree.GetBranch("jetVeto40_DR05")
        #if not self.jetVeto40_DR05_branch and "jetVeto40_DR05" not in self.complained:
        if not self.jetVeto40_DR05_branch and "jetVeto40_DR05":
            warnings.warn( "MuMuETauTree: Expected branch jetVeto40_DR05 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto40_DR05")
        else:
            self.jetVeto40_DR05_branch.SetAddress(<void*>&self.jetVeto40_DR05_value)

        #print "making lumi"
        self.lumi_branch = the_tree.GetBranch("lumi")
        #if not self.lumi_branch and "lumi" not in self.complained:
        if not self.lumi_branch and "lumi":
            warnings.warn( "MuMuETauTree: Expected branch lumi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lumi")
        else:
            self.lumi_branch.SetAddress(<void*>&self.lumi_value)

        #print "making m1AbsEta"
        self.m1AbsEta_branch = the_tree.GetBranch("m1AbsEta")
        #if not self.m1AbsEta_branch and "m1AbsEta" not in self.complained:
        if not self.m1AbsEta_branch and "m1AbsEta":
            warnings.warn( "MuMuETauTree: Expected branch m1AbsEta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1AbsEta")
        else:
            self.m1AbsEta_branch.SetAddress(<void*>&self.m1AbsEta_value)

        #print "making m1Charge"
        self.m1Charge_branch = the_tree.GetBranch("m1Charge")
        #if not self.m1Charge_branch and "m1Charge" not in self.complained:
        if not self.m1Charge_branch and "m1Charge":
            warnings.warn( "MuMuETauTree: Expected branch m1Charge does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1Charge")
        else:
            self.m1Charge_branch.SetAddress(<void*>&self.m1Charge_value)

        #print "making m1ComesFromHiggs"
        self.m1ComesFromHiggs_branch = the_tree.GetBranch("m1ComesFromHiggs")
        #if not self.m1ComesFromHiggs_branch and "m1ComesFromHiggs" not in self.complained:
        if not self.m1ComesFromHiggs_branch and "m1ComesFromHiggs":
            warnings.warn( "MuMuETauTree: Expected branch m1ComesFromHiggs does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1ComesFromHiggs")
        else:
            self.m1ComesFromHiggs_branch.SetAddress(<void*>&self.m1ComesFromHiggs_value)

        #print "making m1D0"
        self.m1D0_branch = the_tree.GetBranch("m1D0")
        #if not self.m1D0_branch and "m1D0" not in self.complained:
        if not self.m1D0_branch and "m1D0":
            warnings.warn( "MuMuETauTree: Expected branch m1D0 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1D0")
        else:
            self.m1D0_branch.SetAddress(<void*>&self.m1D0_value)

        #print "making m1DZ"
        self.m1DZ_branch = the_tree.GetBranch("m1DZ")
        #if not self.m1DZ_branch and "m1DZ" not in self.complained:
        if not self.m1DZ_branch and "m1DZ":
            warnings.warn( "MuMuETauTree: Expected branch m1DZ does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1DZ")
        else:
            self.m1DZ_branch.SetAddress(<void*>&self.m1DZ_value)

        #print "making m1DiMuonL3PreFiltered7"
        self.m1DiMuonL3PreFiltered7_branch = the_tree.GetBranch("m1DiMuonL3PreFiltered7")
        #if not self.m1DiMuonL3PreFiltered7_branch and "m1DiMuonL3PreFiltered7" not in self.complained:
        if not self.m1DiMuonL3PreFiltered7_branch and "m1DiMuonL3PreFiltered7":
            warnings.warn( "MuMuETauTree: Expected branch m1DiMuonL3PreFiltered7 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1DiMuonL3PreFiltered7")
        else:
            self.m1DiMuonL3PreFiltered7_branch.SetAddress(<void*>&self.m1DiMuonL3PreFiltered7_value)

        #print "making m1DiMuonL3p5PreFiltered8"
        self.m1DiMuonL3p5PreFiltered8_branch = the_tree.GetBranch("m1DiMuonL3p5PreFiltered8")
        #if not self.m1DiMuonL3p5PreFiltered8_branch and "m1DiMuonL3p5PreFiltered8" not in self.complained:
        if not self.m1DiMuonL3p5PreFiltered8_branch and "m1DiMuonL3p5PreFiltered8":
            warnings.warn( "MuMuETauTree: Expected branch m1DiMuonL3p5PreFiltered8 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1DiMuonL3p5PreFiltered8")
        else:
            self.m1DiMuonL3p5PreFiltered8_branch.SetAddress(<void*>&self.m1DiMuonL3p5PreFiltered8_value)

        #print "making m1DiMuonMu17Mu8DzFiltered0p2"
        self.m1DiMuonMu17Mu8DzFiltered0p2_branch = the_tree.GetBranch("m1DiMuonMu17Mu8DzFiltered0p2")
        #if not self.m1DiMuonMu17Mu8DzFiltered0p2_branch and "m1DiMuonMu17Mu8DzFiltered0p2" not in self.complained:
        if not self.m1DiMuonMu17Mu8DzFiltered0p2_branch and "m1DiMuonMu17Mu8DzFiltered0p2":
            warnings.warn( "MuMuETauTree: Expected branch m1DiMuonMu17Mu8DzFiltered0p2 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1DiMuonMu17Mu8DzFiltered0p2")
        else:
            self.m1DiMuonMu17Mu8DzFiltered0p2_branch.SetAddress(<void*>&self.m1DiMuonMu17Mu8DzFiltered0p2_value)

        #print "making m1EErrRochCor2011A"
        self.m1EErrRochCor2011A_branch = the_tree.GetBranch("m1EErrRochCor2011A")
        #if not self.m1EErrRochCor2011A_branch and "m1EErrRochCor2011A" not in self.complained:
        if not self.m1EErrRochCor2011A_branch and "m1EErrRochCor2011A":
            warnings.warn( "MuMuETauTree: Expected branch m1EErrRochCor2011A does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1EErrRochCor2011A")
        else:
            self.m1EErrRochCor2011A_branch.SetAddress(<void*>&self.m1EErrRochCor2011A_value)

        #print "making m1EErrRochCor2011B"
        self.m1EErrRochCor2011B_branch = the_tree.GetBranch("m1EErrRochCor2011B")
        #if not self.m1EErrRochCor2011B_branch and "m1EErrRochCor2011B" not in self.complained:
        if not self.m1EErrRochCor2011B_branch and "m1EErrRochCor2011B":
            warnings.warn( "MuMuETauTree: Expected branch m1EErrRochCor2011B does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1EErrRochCor2011B")
        else:
            self.m1EErrRochCor2011B_branch.SetAddress(<void*>&self.m1EErrRochCor2011B_value)

        #print "making m1EErrRochCor2012"
        self.m1EErrRochCor2012_branch = the_tree.GetBranch("m1EErrRochCor2012")
        #if not self.m1EErrRochCor2012_branch and "m1EErrRochCor2012" not in self.complained:
        if not self.m1EErrRochCor2012_branch and "m1EErrRochCor2012":
            warnings.warn( "MuMuETauTree: Expected branch m1EErrRochCor2012 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1EErrRochCor2012")
        else:
            self.m1EErrRochCor2012_branch.SetAddress(<void*>&self.m1EErrRochCor2012_value)

        #print "making m1ERochCor2011A"
        self.m1ERochCor2011A_branch = the_tree.GetBranch("m1ERochCor2011A")
        #if not self.m1ERochCor2011A_branch and "m1ERochCor2011A" not in self.complained:
        if not self.m1ERochCor2011A_branch and "m1ERochCor2011A":
            warnings.warn( "MuMuETauTree: Expected branch m1ERochCor2011A does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1ERochCor2011A")
        else:
            self.m1ERochCor2011A_branch.SetAddress(<void*>&self.m1ERochCor2011A_value)

        #print "making m1ERochCor2011B"
        self.m1ERochCor2011B_branch = the_tree.GetBranch("m1ERochCor2011B")
        #if not self.m1ERochCor2011B_branch and "m1ERochCor2011B" not in self.complained:
        if not self.m1ERochCor2011B_branch and "m1ERochCor2011B":
            warnings.warn( "MuMuETauTree: Expected branch m1ERochCor2011B does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1ERochCor2011B")
        else:
            self.m1ERochCor2011B_branch.SetAddress(<void*>&self.m1ERochCor2011B_value)

        #print "making m1ERochCor2012"
        self.m1ERochCor2012_branch = the_tree.GetBranch("m1ERochCor2012")
        #if not self.m1ERochCor2012_branch and "m1ERochCor2012" not in self.complained:
        if not self.m1ERochCor2012_branch and "m1ERochCor2012":
            warnings.warn( "MuMuETauTree: Expected branch m1ERochCor2012 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1ERochCor2012")
        else:
            self.m1ERochCor2012_branch.SetAddress(<void*>&self.m1ERochCor2012_value)

        #print "making m1EffectiveArea2011"
        self.m1EffectiveArea2011_branch = the_tree.GetBranch("m1EffectiveArea2011")
        #if not self.m1EffectiveArea2011_branch and "m1EffectiveArea2011" not in self.complained:
        if not self.m1EffectiveArea2011_branch and "m1EffectiveArea2011":
            warnings.warn( "MuMuETauTree: Expected branch m1EffectiveArea2011 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1EffectiveArea2011")
        else:
            self.m1EffectiveArea2011_branch.SetAddress(<void*>&self.m1EffectiveArea2011_value)

        #print "making m1EffectiveArea2012"
        self.m1EffectiveArea2012_branch = the_tree.GetBranch("m1EffectiveArea2012")
        #if not self.m1EffectiveArea2012_branch and "m1EffectiveArea2012" not in self.complained:
        if not self.m1EffectiveArea2012_branch and "m1EffectiveArea2012":
            warnings.warn( "MuMuETauTree: Expected branch m1EffectiveArea2012 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1EffectiveArea2012")
        else:
            self.m1EffectiveArea2012_branch.SetAddress(<void*>&self.m1EffectiveArea2012_value)

        #print "making m1Eta"
        self.m1Eta_branch = the_tree.GetBranch("m1Eta")
        #if not self.m1Eta_branch and "m1Eta" not in self.complained:
        if not self.m1Eta_branch and "m1Eta":
            warnings.warn( "MuMuETauTree: Expected branch m1Eta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1Eta")
        else:
            self.m1Eta_branch.SetAddress(<void*>&self.m1Eta_value)

        #print "making m1EtaRochCor2011A"
        self.m1EtaRochCor2011A_branch = the_tree.GetBranch("m1EtaRochCor2011A")
        #if not self.m1EtaRochCor2011A_branch and "m1EtaRochCor2011A" not in self.complained:
        if not self.m1EtaRochCor2011A_branch and "m1EtaRochCor2011A":
            warnings.warn( "MuMuETauTree: Expected branch m1EtaRochCor2011A does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1EtaRochCor2011A")
        else:
            self.m1EtaRochCor2011A_branch.SetAddress(<void*>&self.m1EtaRochCor2011A_value)

        #print "making m1EtaRochCor2011B"
        self.m1EtaRochCor2011B_branch = the_tree.GetBranch("m1EtaRochCor2011B")
        #if not self.m1EtaRochCor2011B_branch and "m1EtaRochCor2011B" not in self.complained:
        if not self.m1EtaRochCor2011B_branch and "m1EtaRochCor2011B":
            warnings.warn( "MuMuETauTree: Expected branch m1EtaRochCor2011B does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1EtaRochCor2011B")
        else:
            self.m1EtaRochCor2011B_branch.SetAddress(<void*>&self.m1EtaRochCor2011B_value)

        #print "making m1EtaRochCor2012"
        self.m1EtaRochCor2012_branch = the_tree.GetBranch("m1EtaRochCor2012")
        #if not self.m1EtaRochCor2012_branch and "m1EtaRochCor2012" not in self.complained:
        if not self.m1EtaRochCor2012_branch and "m1EtaRochCor2012":
            warnings.warn( "MuMuETauTree: Expected branch m1EtaRochCor2012 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1EtaRochCor2012")
        else:
            self.m1EtaRochCor2012_branch.SetAddress(<void*>&self.m1EtaRochCor2012_value)

        #print "making m1GenCharge"
        self.m1GenCharge_branch = the_tree.GetBranch("m1GenCharge")
        #if not self.m1GenCharge_branch and "m1GenCharge" not in self.complained:
        if not self.m1GenCharge_branch and "m1GenCharge":
            warnings.warn( "MuMuETauTree: Expected branch m1GenCharge does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1GenCharge")
        else:
            self.m1GenCharge_branch.SetAddress(<void*>&self.m1GenCharge_value)

        #print "making m1GenEnergy"
        self.m1GenEnergy_branch = the_tree.GetBranch("m1GenEnergy")
        #if not self.m1GenEnergy_branch and "m1GenEnergy" not in self.complained:
        if not self.m1GenEnergy_branch and "m1GenEnergy":
            warnings.warn( "MuMuETauTree: Expected branch m1GenEnergy does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1GenEnergy")
        else:
            self.m1GenEnergy_branch.SetAddress(<void*>&self.m1GenEnergy_value)

        #print "making m1GenEta"
        self.m1GenEta_branch = the_tree.GetBranch("m1GenEta")
        #if not self.m1GenEta_branch and "m1GenEta" not in self.complained:
        if not self.m1GenEta_branch and "m1GenEta":
            warnings.warn( "MuMuETauTree: Expected branch m1GenEta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1GenEta")
        else:
            self.m1GenEta_branch.SetAddress(<void*>&self.m1GenEta_value)

        #print "making m1GenMotherPdgId"
        self.m1GenMotherPdgId_branch = the_tree.GetBranch("m1GenMotherPdgId")
        #if not self.m1GenMotherPdgId_branch and "m1GenMotherPdgId" not in self.complained:
        if not self.m1GenMotherPdgId_branch and "m1GenMotherPdgId":
            warnings.warn( "MuMuETauTree: Expected branch m1GenMotherPdgId does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1GenMotherPdgId")
        else:
            self.m1GenMotherPdgId_branch.SetAddress(<void*>&self.m1GenMotherPdgId_value)

        #print "making m1GenPdgId"
        self.m1GenPdgId_branch = the_tree.GetBranch("m1GenPdgId")
        #if not self.m1GenPdgId_branch and "m1GenPdgId" not in self.complained:
        if not self.m1GenPdgId_branch and "m1GenPdgId":
            warnings.warn( "MuMuETauTree: Expected branch m1GenPdgId does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1GenPdgId")
        else:
            self.m1GenPdgId_branch.SetAddress(<void*>&self.m1GenPdgId_value)

        #print "making m1GenPhi"
        self.m1GenPhi_branch = the_tree.GetBranch("m1GenPhi")
        #if not self.m1GenPhi_branch and "m1GenPhi" not in self.complained:
        if not self.m1GenPhi_branch and "m1GenPhi":
            warnings.warn( "MuMuETauTree: Expected branch m1GenPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1GenPhi")
        else:
            self.m1GenPhi_branch.SetAddress(<void*>&self.m1GenPhi_value)

        #print "making m1GlbTrkHits"
        self.m1GlbTrkHits_branch = the_tree.GetBranch("m1GlbTrkHits")
        #if not self.m1GlbTrkHits_branch and "m1GlbTrkHits" not in self.complained:
        if not self.m1GlbTrkHits_branch and "m1GlbTrkHits":
            warnings.warn( "MuMuETauTree: Expected branch m1GlbTrkHits does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1GlbTrkHits")
        else:
            self.m1GlbTrkHits_branch.SetAddress(<void*>&self.m1GlbTrkHits_value)

        #print "making m1IDHZG2011"
        self.m1IDHZG2011_branch = the_tree.GetBranch("m1IDHZG2011")
        #if not self.m1IDHZG2011_branch and "m1IDHZG2011" not in self.complained:
        if not self.m1IDHZG2011_branch and "m1IDHZG2011":
            warnings.warn( "MuMuETauTree: Expected branch m1IDHZG2011 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1IDHZG2011")
        else:
            self.m1IDHZG2011_branch.SetAddress(<void*>&self.m1IDHZG2011_value)

        #print "making m1IDHZG2012"
        self.m1IDHZG2012_branch = the_tree.GetBranch("m1IDHZG2012")
        #if not self.m1IDHZG2012_branch and "m1IDHZG2012" not in self.complained:
        if not self.m1IDHZG2012_branch and "m1IDHZG2012":
            warnings.warn( "MuMuETauTree: Expected branch m1IDHZG2012 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1IDHZG2012")
        else:
            self.m1IDHZG2012_branch.SetAddress(<void*>&self.m1IDHZG2012_value)

        #print "making m1IP3DS"
        self.m1IP3DS_branch = the_tree.GetBranch("m1IP3DS")
        #if not self.m1IP3DS_branch and "m1IP3DS" not in self.complained:
        if not self.m1IP3DS_branch and "m1IP3DS":
            warnings.warn( "MuMuETauTree: Expected branch m1IP3DS does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1IP3DS")
        else:
            self.m1IP3DS_branch.SetAddress(<void*>&self.m1IP3DS_value)

        #print "making m1IsGlobal"
        self.m1IsGlobal_branch = the_tree.GetBranch("m1IsGlobal")
        #if not self.m1IsGlobal_branch and "m1IsGlobal" not in self.complained:
        if not self.m1IsGlobal_branch and "m1IsGlobal":
            warnings.warn( "MuMuETauTree: Expected branch m1IsGlobal does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1IsGlobal")
        else:
            self.m1IsGlobal_branch.SetAddress(<void*>&self.m1IsGlobal_value)

        #print "making m1IsPFMuon"
        self.m1IsPFMuon_branch = the_tree.GetBranch("m1IsPFMuon")
        #if not self.m1IsPFMuon_branch and "m1IsPFMuon" not in self.complained:
        if not self.m1IsPFMuon_branch and "m1IsPFMuon":
            warnings.warn( "MuMuETauTree: Expected branch m1IsPFMuon does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1IsPFMuon")
        else:
            self.m1IsPFMuon_branch.SetAddress(<void*>&self.m1IsPFMuon_value)

        #print "making m1IsTracker"
        self.m1IsTracker_branch = the_tree.GetBranch("m1IsTracker")
        #if not self.m1IsTracker_branch and "m1IsTracker" not in self.complained:
        if not self.m1IsTracker_branch and "m1IsTracker":
            warnings.warn( "MuMuETauTree: Expected branch m1IsTracker does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1IsTracker")
        else:
            self.m1IsTracker_branch.SetAddress(<void*>&self.m1IsTracker_value)

        #print "making m1JetArea"
        self.m1JetArea_branch = the_tree.GetBranch("m1JetArea")
        #if not self.m1JetArea_branch and "m1JetArea" not in self.complained:
        if not self.m1JetArea_branch and "m1JetArea":
            warnings.warn( "MuMuETauTree: Expected branch m1JetArea does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1JetArea")
        else:
            self.m1JetArea_branch.SetAddress(<void*>&self.m1JetArea_value)

        #print "making m1JetBtag"
        self.m1JetBtag_branch = the_tree.GetBranch("m1JetBtag")
        #if not self.m1JetBtag_branch and "m1JetBtag" not in self.complained:
        if not self.m1JetBtag_branch and "m1JetBtag":
            warnings.warn( "MuMuETauTree: Expected branch m1JetBtag does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1JetBtag")
        else:
            self.m1JetBtag_branch.SetAddress(<void*>&self.m1JetBtag_value)

        #print "making m1JetCSVBtag"
        self.m1JetCSVBtag_branch = the_tree.GetBranch("m1JetCSVBtag")
        #if not self.m1JetCSVBtag_branch and "m1JetCSVBtag" not in self.complained:
        if not self.m1JetCSVBtag_branch and "m1JetCSVBtag":
            warnings.warn( "MuMuETauTree: Expected branch m1JetCSVBtag does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1JetCSVBtag")
        else:
            self.m1JetCSVBtag_branch.SetAddress(<void*>&self.m1JetCSVBtag_value)

        #print "making m1JetEtaEtaMoment"
        self.m1JetEtaEtaMoment_branch = the_tree.GetBranch("m1JetEtaEtaMoment")
        #if not self.m1JetEtaEtaMoment_branch and "m1JetEtaEtaMoment" not in self.complained:
        if not self.m1JetEtaEtaMoment_branch and "m1JetEtaEtaMoment":
            warnings.warn( "MuMuETauTree: Expected branch m1JetEtaEtaMoment does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1JetEtaEtaMoment")
        else:
            self.m1JetEtaEtaMoment_branch.SetAddress(<void*>&self.m1JetEtaEtaMoment_value)

        #print "making m1JetEtaPhiMoment"
        self.m1JetEtaPhiMoment_branch = the_tree.GetBranch("m1JetEtaPhiMoment")
        #if not self.m1JetEtaPhiMoment_branch and "m1JetEtaPhiMoment" not in self.complained:
        if not self.m1JetEtaPhiMoment_branch and "m1JetEtaPhiMoment":
            warnings.warn( "MuMuETauTree: Expected branch m1JetEtaPhiMoment does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1JetEtaPhiMoment")
        else:
            self.m1JetEtaPhiMoment_branch.SetAddress(<void*>&self.m1JetEtaPhiMoment_value)

        #print "making m1JetEtaPhiSpread"
        self.m1JetEtaPhiSpread_branch = the_tree.GetBranch("m1JetEtaPhiSpread")
        #if not self.m1JetEtaPhiSpread_branch and "m1JetEtaPhiSpread" not in self.complained:
        if not self.m1JetEtaPhiSpread_branch and "m1JetEtaPhiSpread":
            warnings.warn( "MuMuETauTree: Expected branch m1JetEtaPhiSpread does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1JetEtaPhiSpread")
        else:
            self.m1JetEtaPhiSpread_branch.SetAddress(<void*>&self.m1JetEtaPhiSpread_value)

        #print "making m1JetPartonFlavour"
        self.m1JetPartonFlavour_branch = the_tree.GetBranch("m1JetPartonFlavour")
        #if not self.m1JetPartonFlavour_branch and "m1JetPartonFlavour" not in self.complained:
        if not self.m1JetPartonFlavour_branch and "m1JetPartonFlavour":
            warnings.warn( "MuMuETauTree: Expected branch m1JetPartonFlavour does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1JetPartonFlavour")
        else:
            self.m1JetPartonFlavour_branch.SetAddress(<void*>&self.m1JetPartonFlavour_value)

        #print "making m1JetPhiPhiMoment"
        self.m1JetPhiPhiMoment_branch = the_tree.GetBranch("m1JetPhiPhiMoment")
        #if not self.m1JetPhiPhiMoment_branch and "m1JetPhiPhiMoment" not in self.complained:
        if not self.m1JetPhiPhiMoment_branch and "m1JetPhiPhiMoment":
            warnings.warn( "MuMuETauTree: Expected branch m1JetPhiPhiMoment does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1JetPhiPhiMoment")
        else:
            self.m1JetPhiPhiMoment_branch.SetAddress(<void*>&self.m1JetPhiPhiMoment_value)

        #print "making m1JetPt"
        self.m1JetPt_branch = the_tree.GetBranch("m1JetPt")
        #if not self.m1JetPt_branch and "m1JetPt" not in self.complained:
        if not self.m1JetPt_branch and "m1JetPt":
            warnings.warn( "MuMuETauTree: Expected branch m1JetPt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1JetPt")
        else:
            self.m1JetPt_branch.SetAddress(<void*>&self.m1JetPt_value)

        #print "making m1JetQGLikelihoodID"
        self.m1JetQGLikelihoodID_branch = the_tree.GetBranch("m1JetQGLikelihoodID")
        #if not self.m1JetQGLikelihoodID_branch and "m1JetQGLikelihoodID" not in self.complained:
        if not self.m1JetQGLikelihoodID_branch and "m1JetQGLikelihoodID":
            warnings.warn( "MuMuETauTree: Expected branch m1JetQGLikelihoodID does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1JetQGLikelihoodID")
        else:
            self.m1JetQGLikelihoodID_branch.SetAddress(<void*>&self.m1JetQGLikelihoodID_value)

        #print "making m1JetQGMVAID"
        self.m1JetQGMVAID_branch = the_tree.GetBranch("m1JetQGMVAID")
        #if not self.m1JetQGMVAID_branch and "m1JetQGMVAID" not in self.complained:
        if not self.m1JetQGMVAID_branch and "m1JetQGMVAID":
            warnings.warn( "MuMuETauTree: Expected branch m1JetQGMVAID does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1JetQGMVAID")
        else:
            self.m1JetQGMVAID_branch.SetAddress(<void*>&self.m1JetQGMVAID_value)

        #print "making m1Jetaxis1"
        self.m1Jetaxis1_branch = the_tree.GetBranch("m1Jetaxis1")
        #if not self.m1Jetaxis1_branch and "m1Jetaxis1" not in self.complained:
        if not self.m1Jetaxis1_branch and "m1Jetaxis1":
            warnings.warn( "MuMuETauTree: Expected branch m1Jetaxis1 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1Jetaxis1")
        else:
            self.m1Jetaxis1_branch.SetAddress(<void*>&self.m1Jetaxis1_value)

        #print "making m1Jetaxis2"
        self.m1Jetaxis2_branch = the_tree.GetBranch("m1Jetaxis2")
        #if not self.m1Jetaxis2_branch and "m1Jetaxis2" not in self.complained:
        if not self.m1Jetaxis2_branch and "m1Jetaxis2":
            warnings.warn( "MuMuETauTree: Expected branch m1Jetaxis2 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1Jetaxis2")
        else:
            self.m1Jetaxis2_branch.SetAddress(<void*>&self.m1Jetaxis2_value)

        #print "making m1Jetmult"
        self.m1Jetmult_branch = the_tree.GetBranch("m1Jetmult")
        #if not self.m1Jetmult_branch and "m1Jetmult" not in self.complained:
        if not self.m1Jetmult_branch and "m1Jetmult":
            warnings.warn( "MuMuETauTree: Expected branch m1Jetmult does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1Jetmult")
        else:
            self.m1Jetmult_branch.SetAddress(<void*>&self.m1Jetmult_value)

        #print "making m1JetmultMLP"
        self.m1JetmultMLP_branch = the_tree.GetBranch("m1JetmultMLP")
        #if not self.m1JetmultMLP_branch and "m1JetmultMLP" not in self.complained:
        if not self.m1JetmultMLP_branch and "m1JetmultMLP":
            warnings.warn( "MuMuETauTree: Expected branch m1JetmultMLP does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1JetmultMLP")
        else:
            self.m1JetmultMLP_branch.SetAddress(<void*>&self.m1JetmultMLP_value)

        #print "making m1JetmultMLPQC"
        self.m1JetmultMLPQC_branch = the_tree.GetBranch("m1JetmultMLPQC")
        #if not self.m1JetmultMLPQC_branch and "m1JetmultMLPQC" not in self.complained:
        if not self.m1JetmultMLPQC_branch and "m1JetmultMLPQC":
            warnings.warn( "MuMuETauTree: Expected branch m1JetmultMLPQC does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1JetmultMLPQC")
        else:
            self.m1JetmultMLPQC_branch.SetAddress(<void*>&self.m1JetmultMLPQC_value)

        #print "making m1JetptD"
        self.m1JetptD_branch = the_tree.GetBranch("m1JetptD")
        #if not self.m1JetptD_branch and "m1JetptD" not in self.complained:
        if not self.m1JetptD_branch and "m1JetptD":
            warnings.warn( "MuMuETauTree: Expected branch m1JetptD does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1JetptD")
        else:
            self.m1JetptD_branch.SetAddress(<void*>&self.m1JetptD_value)

        #print "making m1L1Mu3EG5L3Filtered17"
        self.m1L1Mu3EG5L3Filtered17_branch = the_tree.GetBranch("m1L1Mu3EG5L3Filtered17")
        #if not self.m1L1Mu3EG5L3Filtered17_branch and "m1L1Mu3EG5L3Filtered17" not in self.complained:
        if not self.m1L1Mu3EG5L3Filtered17_branch and "m1L1Mu3EG5L3Filtered17":
            warnings.warn( "MuMuETauTree: Expected branch m1L1Mu3EG5L3Filtered17 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1L1Mu3EG5L3Filtered17")
        else:
            self.m1L1Mu3EG5L3Filtered17_branch.SetAddress(<void*>&self.m1L1Mu3EG5L3Filtered17_value)

        #print "making m1L3fL1DoubleMu10MuOpenL1f0L2f10L3Filtered17"
        self.m1L3fL1DoubleMu10MuOpenL1f0L2f10L3Filtered17_branch = the_tree.GetBranch("m1L3fL1DoubleMu10MuOpenL1f0L2f10L3Filtered17")
        #if not self.m1L3fL1DoubleMu10MuOpenL1f0L2f10L3Filtered17_branch and "m1L3fL1DoubleMu10MuOpenL1f0L2f10L3Filtered17" not in self.complained:
        if not self.m1L3fL1DoubleMu10MuOpenL1f0L2f10L3Filtered17_branch and "m1L3fL1DoubleMu10MuOpenL1f0L2f10L3Filtered17":
            warnings.warn( "MuMuETauTree: Expected branch m1L3fL1DoubleMu10MuOpenL1f0L2f10L3Filtered17 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1L3fL1DoubleMu10MuOpenL1f0L2f10L3Filtered17")
        else:
            self.m1L3fL1DoubleMu10MuOpenL1f0L2f10L3Filtered17_branch.SetAddress(<void*>&self.m1L3fL1DoubleMu10MuOpenL1f0L2f10L3Filtered17_value)

        #print "making m1Mass"
        self.m1Mass_branch = the_tree.GetBranch("m1Mass")
        #if not self.m1Mass_branch and "m1Mass" not in self.complained:
        if not self.m1Mass_branch and "m1Mass":
            warnings.warn( "MuMuETauTree: Expected branch m1Mass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1Mass")
        else:
            self.m1Mass_branch.SetAddress(<void*>&self.m1Mass_value)

        #print "making m1MatchedStations"
        self.m1MatchedStations_branch = the_tree.GetBranch("m1MatchedStations")
        #if not self.m1MatchedStations_branch and "m1MatchedStations" not in self.complained:
        if not self.m1MatchedStations_branch and "m1MatchedStations":
            warnings.warn( "MuMuETauTree: Expected branch m1MatchedStations does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1MatchedStations")
        else:
            self.m1MatchedStations_branch.SetAddress(<void*>&self.m1MatchedStations_value)

        #print "making m1MatchesDoubleMuPaths"
        self.m1MatchesDoubleMuPaths_branch = the_tree.GetBranch("m1MatchesDoubleMuPaths")
        #if not self.m1MatchesDoubleMuPaths_branch and "m1MatchesDoubleMuPaths" not in self.complained:
        if not self.m1MatchesDoubleMuPaths_branch and "m1MatchesDoubleMuPaths":
            warnings.warn( "MuMuETauTree: Expected branch m1MatchesDoubleMuPaths does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1MatchesDoubleMuPaths")
        else:
            self.m1MatchesDoubleMuPaths_branch.SetAddress(<void*>&self.m1MatchesDoubleMuPaths_value)

        #print "making m1MatchesDoubleMuTrkPaths"
        self.m1MatchesDoubleMuTrkPaths_branch = the_tree.GetBranch("m1MatchesDoubleMuTrkPaths")
        #if not self.m1MatchesDoubleMuTrkPaths_branch and "m1MatchesDoubleMuTrkPaths" not in self.complained:
        if not self.m1MatchesDoubleMuTrkPaths_branch and "m1MatchesDoubleMuTrkPaths":
            warnings.warn( "MuMuETauTree: Expected branch m1MatchesDoubleMuTrkPaths does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1MatchesDoubleMuTrkPaths")
        else:
            self.m1MatchesDoubleMuTrkPaths_branch.SetAddress(<void*>&self.m1MatchesDoubleMuTrkPaths_value)

        #print "making m1MatchesIsoMu24eta2p1"
        self.m1MatchesIsoMu24eta2p1_branch = the_tree.GetBranch("m1MatchesIsoMu24eta2p1")
        #if not self.m1MatchesIsoMu24eta2p1_branch and "m1MatchesIsoMu24eta2p1" not in self.complained:
        if not self.m1MatchesIsoMu24eta2p1_branch and "m1MatchesIsoMu24eta2p1":
            warnings.warn( "MuMuETauTree: Expected branch m1MatchesIsoMu24eta2p1 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1MatchesIsoMu24eta2p1")
        else:
            self.m1MatchesIsoMu24eta2p1_branch.SetAddress(<void*>&self.m1MatchesIsoMu24eta2p1_value)

        #print "making m1MatchesIsoMuGroup"
        self.m1MatchesIsoMuGroup_branch = the_tree.GetBranch("m1MatchesIsoMuGroup")
        #if not self.m1MatchesIsoMuGroup_branch and "m1MatchesIsoMuGroup" not in self.complained:
        if not self.m1MatchesIsoMuGroup_branch and "m1MatchesIsoMuGroup":
            warnings.warn( "MuMuETauTree: Expected branch m1MatchesIsoMuGroup does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1MatchesIsoMuGroup")
        else:
            self.m1MatchesIsoMuGroup_branch.SetAddress(<void*>&self.m1MatchesIsoMuGroup_value)

        #print "making m1MatchesMu17Ele8IsoPath"
        self.m1MatchesMu17Ele8IsoPath_branch = the_tree.GetBranch("m1MatchesMu17Ele8IsoPath")
        #if not self.m1MatchesMu17Ele8IsoPath_branch and "m1MatchesMu17Ele8IsoPath" not in self.complained:
        if not self.m1MatchesMu17Ele8IsoPath_branch and "m1MatchesMu17Ele8IsoPath":
            warnings.warn( "MuMuETauTree: Expected branch m1MatchesMu17Ele8IsoPath does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1MatchesMu17Ele8IsoPath")
        else:
            self.m1MatchesMu17Ele8IsoPath_branch.SetAddress(<void*>&self.m1MatchesMu17Ele8IsoPath_value)

        #print "making m1MatchesMu17Ele8Path"
        self.m1MatchesMu17Ele8Path_branch = the_tree.GetBranch("m1MatchesMu17Ele8Path")
        #if not self.m1MatchesMu17Ele8Path_branch and "m1MatchesMu17Ele8Path" not in self.complained:
        if not self.m1MatchesMu17Ele8Path_branch and "m1MatchesMu17Ele8Path":
            warnings.warn( "MuMuETauTree: Expected branch m1MatchesMu17Ele8Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1MatchesMu17Ele8Path")
        else:
            self.m1MatchesMu17Ele8Path_branch.SetAddress(<void*>&self.m1MatchesMu17Ele8Path_value)

        #print "making m1MatchesMu17Mu8Path"
        self.m1MatchesMu17Mu8Path_branch = the_tree.GetBranch("m1MatchesMu17Mu8Path")
        #if not self.m1MatchesMu17Mu8Path_branch and "m1MatchesMu17Mu8Path" not in self.complained:
        if not self.m1MatchesMu17Mu8Path_branch and "m1MatchesMu17Mu8Path":
            warnings.warn( "MuMuETauTree: Expected branch m1MatchesMu17Mu8Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1MatchesMu17Mu8Path")
        else:
            self.m1MatchesMu17Mu8Path_branch.SetAddress(<void*>&self.m1MatchesMu17Mu8Path_value)

        #print "making m1MatchesMu17TrkMu8Path"
        self.m1MatchesMu17TrkMu8Path_branch = the_tree.GetBranch("m1MatchesMu17TrkMu8Path")
        #if not self.m1MatchesMu17TrkMu8Path_branch and "m1MatchesMu17TrkMu8Path" not in self.complained:
        if not self.m1MatchesMu17TrkMu8Path_branch and "m1MatchesMu17TrkMu8Path":
            warnings.warn( "MuMuETauTree: Expected branch m1MatchesMu17TrkMu8Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1MatchesMu17TrkMu8Path")
        else:
            self.m1MatchesMu17TrkMu8Path_branch.SetAddress(<void*>&self.m1MatchesMu17TrkMu8Path_value)

        #print "making m1MatchesMu8Ele17IsoPath"
        self.m1MatchesMu8Ele17IsoPath_branch = the_tree.GetBranch("m1MatchesMu8Ele17IsoPath")
        #if not self.m1MatchesMu8Ele17IsoPath_branch and "m1MatchesMu8Ele17IsoPath" not in self.complained:
        if not self.m1MatchesMu8Ele17IsoPath_branch and "m1MatchesMu8Ele17IsoPath":
            warnings.warn( "MuMuETauTree: Expected branch m1MatchesMu8Ele17IsoPath does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1MatchesMu8Ele17IsoPath")
        else:
            self.m1MatchesMu8Ele17IsoPath_branch.SetAddress(<void*>&self.m1MatchesMu8Ele17IsoPath_value)

        #print "making m1MatchesMu8Ele17Path"
        self.m1MatchesMu8Ele17Path_branch = the_tree.GetBranch("m1MatchesMu8Ele17Path")
        #if not self.m1MatchesMu8Ele17Path_branch and "m1MatchesMu8Ele17Path" not in self.complained:
        if not self.m1MatchesMu8Ele17Path_branch and "m1MatchesMu8Ele17Path":
            warnings.warn( "MuMuETauTree: Expected branch m1MatchesMu8Ele17Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1MatchesMu8Ele17Path")
        else:
            self.m1MatchesMu8Ele17Path_branch.SetAddress(<void*>&self.m1MatchesMu8Ele17Path_value)

        #print "making m1MtToMET"
        self.m1MtToMET_branch = the_tree.GetBranch("m1MtToMET")
        #if not self.m1MtToMET_branch and "m1MtToMET" not in self.complained:
        if not self.m1MtToMET_branch and "m1MtToMET":
            warnings.warn( "MuMuETauTree: Expected branch m1MtToMET does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1MtToMET")
        else:
            self.m1MtToMET_branch.SetAddress(<void*>&self.m1MtToMET_value)

        #print "making m1MtToMVAMET"
        self.m1MtToMVAMET_branch = the_tree.GetBranch("m1MtToMVAMET")
        #if not self.m1MtToMVAMET_branch and "m1MtToMVAMET" not in self.complained:
        if not self.m1MtToMVAMET_branch and "m1MtToMVAMET":
            warnings.warn( "MuMuETauTree: Expected branch m1MtToMVAMET does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1MtToMVAMET")
        else:
            self.m1MtToMVAMET_branch.SetAddress(<void*>&self.m1MtToMVAMET_value)

        #print "making m1MtToPFMET"
        self.m1MtToPFMET_branch = the_tree.GetBranch("m1MtToPFMET")
        #if not self.m1MtToPFMET_branch and "m1MtToPFMET" not in self.complained:
        if not self.m1MtToPFMET_branch and "m1MtToPFMET":
            warnings.warn( "MuMuETauTree: Expected branch m1MtToPFMET does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1MtToPFMET")
        else:
            self.m1MtToPFMET_branch.SetAddress(<void*>&self.m1MtToPFMET_value)

        #print "making m1MtToPfMet_Ty1"
        self.m1MtToPfMet_Ty1_branch = the_tree.GetBranch("m1MtToPfMet_Ty1")
        #if not self.m1MtToPfMet_Ty1_branch and "m1MtToPfMet_Ty1" not in self.complained:
        if not self.m1MtToPfMet_Ty1_branch and "m1MtToPfMet_Ty1":
            warnings.warn( "MuMuETauTree: Expected branch m1MtToPfMet_Ty1 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1MtToPfMet_Ty1")
        else:
            self.m1MtToPfMet_Ty1_branch.SetAddress(<void*>&self.m1MtToPfMet_Ty1_value)

        #print "making m1MtToPfMet_jes"
        self.m1MtToPfMet_jes_branch = the_tree.GetBranch("m1MtToPfMet_jes")
        #if not self.m1MtToPfMet_jes_branch and "m1MtToPfMet_jes" not in self.complained:
        if not self.m1MtToPfMet_jes_branch and "m1MtToPfMet_jes":
            warnings.warn( "MuMuETauTree: Expected branch m1MtToPfMet_jes does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1MtToPfMet_jes")
        else:
            self.m1MtToPfMet_jes_branch.SetAddress(<void*>&self.m1MtToPfMet_jes_value)

        #print "making m1MtToPfMet_mes"
        self.m1MtToPfMet_mes_branch = the_tree.GetBranch("m1MtToPfMet_mes")
        #if not self.m1MtToPfMet_mes_branch and "m1MtToPfMet_mes" not in self.complained:
        if not self.m1MtToPfMet_mes_branch and "m1MtToPfMet_mes":
            warnings.warn( "MuMuETauTree: Expected branch m1MtToPfMet_mes does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1MtToPfMet_mes")
        else:
            self.m1MtToPfMet_mes_branch.SetAddress(<void*>&self.m1MtToPfMet_mes_value)

        #print "making m1MtToPfMet_tes"
        self.m1MtToPfMet_tes_branch = the_tree.GetBranch("m1MtToPfMet_tes")
        #if not self.m1MtToPfMet_tes_branch and "m1MtToPfMet_tes" not in self.complained:
        if not self.m1MtToPfMet_tes_branch and "m1MtToPfMet_tes":
            warnings.warn( "MuMuETauTree: Expected branch m1MtToPfMet_tes does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1MtToPfMet_tes")
        else:
            self.m1MtToPfMet_tes_branch.SetAddress(<void*>&self.m1MtToPfMet_tes_value)

        #print "making m1MtToPfMet_ues"
        self.m1MtToPfMet_ues_branch = the_tree.GetBranch("m1MtToPfMet_ues")
        #if not self.m1MtToPfMet_ues_branch and "m1MtToPfMet_ues" not in self.complained:
        if not self.m1MtToPfMet_ues_branch and "m1MtToPfMet_ues":
            warnings.warn( "MuMuETauTree: Expected branch m1MtToPfMet_ues does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1MtToPfMet_ues")
        else:
            self.m1MtToPfMet_ues_branch.SetAddress(<void*>&self.m1MtToPfMet_ues_value)

        #print "making m1Mu17Ele8dZFilter"
        self.m1Mu17Ele8dZFilter_branch = the_tree.GetBranch("m1Mu17Ele8dZFilter")
        #if not self.m1Mu17Ele8dZFilter_branch and "m1Mu17Ele8dZFilter" not in self.complained:
        if not self.m1Mu17Ele8dZFilter_branch and "m1Mu17Ele8dZFilter":
            warnings.warn( "MuMuETauTree: Expected branch m1Mu17Ele8dZFilter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1Mu17Ele8dZFilter")
        else:
            self.m1Mu17Ele8dZFilter_branch.SetAddress(<void*>&self.m1Mu17Ele8dZFilter_value)

        #print "making m1MuonHits"
        self.m1MuonHits_branch = the_tree.GetBranch("m1MuonHits")
        #if not self.m1MuonHits_branch and "m1MuonHits" not in self.complained:
        if not self.m1MuonHits_branch and "m1MuonHits":
            warnings.warn( "MuMuETauTree: Expected branch m1MuonHits does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1MuonHits")
        else:
            self.m1MuonHits_branch.SetAddress(<void*>&self.m1MuonHits_value)

        #print "making m1NormTrkChi2"
        self.m1NormTrkChi2_branch = the_tree.GetBranch("m1NormTrkChi2")
        #if not self.m1NormTrkChi2_branch and "m1NormTrkChi2" not in self.complained:
        if not self.m1NormTrkChi2_branch and "m1NormTrkChi2":
            warnings.warn( "MuMuETauTree: Expected branch m1NormTrkChi2 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1NormTrkChi2")
        else:
            self.m1NormTrkChi2_branch.SetAddress(<void*>&self.m1NormTrkChi2_value)

        #print "making m1PFChargedIso"
        self.m1PFChargedIso_branch = the_tree.GetBranch("m1PFChargedIso")
        #if not self.m1PFChargedIso_branch and "m1PFChargedIso" not in self.complained:
        if not self.m1PFChargedIso_branch and "m1PFChargedIso":
            warnings.warn( "MuMuETauTree: Expected branch m1PFChargedIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1PFChargedIso")
        else:
            self.m1PFChargedIso_branch.SetAddress(<void*>&self.m1PFChargedIso_value)

        #print "making m1PFIDTight"
        self.m1PFIDTight_branch = the_tree.GetBranch("m1PFIDTight")
        #if not self.m1PFIDTight_branch and "m1PFIDTight" not in self.complained:
        if not self.m1PFIDTight_branch and "m1PFIDTight":
            warnings.warn( "MuMuETauTree: Expected branch m1PFIDTight does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1PFIDTight")
        else:
            self.m1PFIDTight_branch.SetAddress(<void*>&self.m1PFIDTight_value)

        #print "making m1PFNeutralIso"
        self.m1PFNeutralIso_branch = the_tree.GetBranch("m1PFNeutralIso")
        #if not self.m1PFNeutralIso_branch and "m1PFNeutralIso" not in self.complained:
        if not self.m1PFNeutralIso_branch and "m1PFNeutralIso":
            warnings.warn( "MuMuETauTree: Expected branch m1PFNeutralIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1PFNeutralIso")
        else:
            self.m1PFNeutralIso_branch.SetAddress(<void*>&self.m1PFNeutralIso_value)

        #print "making m1PFPUChargedIso"
        self.m1PFPUChargedIso_branch = the_tree.GetBranch("m1PFPUChargedIso")
        #if not self.m1PFPUChargedIso_branch and "m1PFPUChargedIso" not in self.complained:
        if not self.m1PFPUChargedIso_branch and "m1PFPUChargedIso":
            warnings.warn( "MuMuETauTree: Expected branch m1PFPUChargedIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1PFPUChargedIso")
        else:
            self.m1PFPUChargedIso_branch.SetAddress(<void*>&self.m1PFPUChargedIso_value)

        #print "making m1PFPhotonIso"
        self.m1PFPhotonIso_branch = the_tree.GetBranch("m1PFPhotonIso")
        #if not self.m1PFPhotonIso_branch and "m1PFPhotonIso" not in self.complained:
        if not self.m1PFPhotonIso_branch and "m1PFPhotonIso":
            warnings.warn( "MuMuETauTree: Expected branch m1PFPhotonIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1PFPhotonIso")
        else:
            self.m1PFPhotonIso_branch.SetAddress(<void*>&self.m1PFPhotonIso_value)

        #print "making m1PVDXY"
        self.m1PVDXY_branch = the_tree.GetBranch("m1PVDXY")
        #if not self.m1PVDXY_branch and "m1PVDXY" not in self.complained:
        if not self.m1PVDXY_branch and "m1PVDXY":
            warnings.warn( "MuMuETauTree: Expected branch m1PVDXY does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1PVDXY")
        else:
            self.m1PVDXY_branch.SetAddress(<void*>&self.m1PVDXY_value)

        #print "making m1PVDZ"
        self.m1PVDZ_branch = the_tree.GetBranch("m1PVDZ")
        #if not self.m1PVDZ_branch and "m1PVDZ" not in self.complained:
        if not self.m1PVDZ_branch and "m1PVDZ":
            warnings.warn( "MuMuETauTree: Expected branch m1PVDZ does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1PVDZ")
        else:
            self.m1PVDZ_branch.SetAddress(<void*>&self.m1PVDZ_value)

        #print "making m1Phi"
        self.m1Phi_branch = the_tree.GetBranch("m1Phi")
        #if not self.m1Phi_branch and "m1Phi" not in self.complained:
        if not self.m1Phi_branch and "m1Phi":
            warnings.warn( "MuMuETauTree: Expected branch m1Phi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1Phi")
        else:
            self.m1Phi_branch.SetAddress(<void*>&self.m1Phi_value)

        #print "making m1PhiRochCor2011A"
        self.m1PhiRochCor2011A_branch = the_tree.GetBranch("m1PhiRochCor2011A")
        #if not self.m1PhiRochCor2011A_branch and "m1PhiRochCor2011A" not in self.complained:
        if not self.m1PhiRochCor2011A_branch and "m1PhiRochCor2011A":
            warnings.warn( "MuMuETauTree: Expected branch m1PhiRochCor2011A does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1PhiRochCor2011A")
        else:
            self.m1PhiRochCor2011A_branch.SetAddress(<void*>&self.m1PhiRochCor2011A_value)

        #print "making m1PhiRochCor2011B"
        self.m1PhiRochCor2011B_branch = the_tree.GetBranch("m1PhiRochCor2011B")
        #if not self.m1PhiRochCor2011B_branch and "m1PhiRochCor2011B" not in self.complained:
        if not self.m1PhiRochCor2011B_branch and "m1PhiRochCor2011B":
            warnings.warn( "MuMuETauTree: Expected branch m1PhiRochCor2011B does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1PhiRochCor2011B")
        else:
            self.m1PhiRochCor2011B_branch.SetAddress(<void*>&self.m1PhiRochCor2011B_value)

        #print "making m1PhiRochCor2012"
        self.m1PhiRochCor2012_branch = the_tree.GetBranch("m1PhiRochCor2012")
        #if not self.m1PhiRochCor2012_branch and "m1PhiRochCor2012" not in self.complained:
        if not self.m1PhiRochCor2012_branch and "m1PhiRochCor2012":
            warnings.warn( "MuMuETauTree: Expected branch m1PhiRochCor2012 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1PhiRochCor2012")
        else:
            self.m1PhiRochCor2012_branch.SetAddress(<void*>&self.m1PhiRochCor2012_value)

        #print "making m1PixHits"
        self.m1PixHits_branch = the_tree.GetBranch("m1PixHits")
        #if not self.m1PixHits_branch and "m1PixHits" not in self.complained:
        if not self.m1PixHits_branch and "m1PixHits":
            warnings.warn( "MuMuETauTree: Expected branch m1PixHits does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1PixHits")
        else:
            self.m1PixHits_branch.SetAddress(<void*>&self.m1PixHits_value)

        #print "making m1Pt"
        self.m1Pt_branch = the_tree.GetBranch("m1Pt")
        #if not self.m1Pt_branch and "m1Pt" not in self.complained:
        if not self.m1Pt_branch and "m1Pt":
            warnings.warn( "MuMuETauTree: Expected branch m1Pt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1Pt")
        else:
            self.m1Pt_branch.SetAddress(<void*>&self.m1Pt_value)

        #print "making m1PtRochCor2011A"
        self.m1PtRochCor2011A_branch = the_tree.GetBranch("m1PtRochCor2011A")
        #if not self.m1PtRochCor2011A_branch and "m1PtRochCor2011A" not in self.complained:
        if not self.m1PtRochCor2011A_branch and "m1PtRochCor2011A":
            warnings.warn( "MuMuETauTree: Expected branch m1PtRochCor2011A does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1PtRochCor2011A")
        else:
            self.m1PtRochCor2011A_branch.SetAddress(<void*>&self.m1PtRochCor2011A_value)

        #print "making m1PtRochCor2011B"
        self.m1PtRochCor2011B_branch = the_tree.GetBranch("m1PtRochCor2011B")
        #if not self.m1PtRochCor2011B_branch and "m1PtRochCor2011B" not in self.complained:
        if not self.m1PtRochCor2011B_branch and "m1PtRochCor2011B":
            warnings.warn( "MuMuETauTree: Expected branch m1PtRochCor2011B does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1PtRochCor2011B")
        else:
            self.m1PtRochCor2011B_branch.SetAddress(<void*>&self.m1PtRochCor2011B_value)

        #print "making m1PtRochCor2012"
        self.m1PtRochCor2012_branch = the_tree.GetBranch("m1PtRochCor2012")
        #if not self.m1PtRochCor2012_branch and "m1PtRochCor2012" not in self.complained:
        if not self.m1PtRochCor2012_branch and "m1PtRochCor2012":
            warnings.warn( "MuMuETauTree: Expected branch m1PtRochCor2012 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1PtRochCor2012")
        else:
            self.m1PtRochCor2012_branch.SetAddress(<void*>&self.m1PtRochCor2012_value)

        #print "making m1Rank"
        self.m1Rank_branch = the_tree.GetBranch("m1Rank")
        #if not self.m1Rank_branch and "m1Rank" not in self.complained:
        if not self.m1Rank_branch and "m1Rank":
            warnings.warn( "MuMuETauTree: Expected branch m1Rank does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1Rank")
        else:
            self.m1Rank_branch.SetAddress(<void*>&self.m1Rank_value)

        #print "making m1RelPFIsoDB"
        self.m1RelPFIsoDB_branch = the_tree.GetBranch("m1RelPFIsoDB")
        #if not self.m1RelPFIsoDB_branch and "m1RelPFIsoDB" not in self.complained:
        if not self.m1RelPFIsoDB_branch and "m1RelPFIsoDB":
            warnings.warn( "MuMuETauTree: Expected branch m1RelPFIsoDB does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1RelPFIsoDB")
        else:
            self.m1RelPFIsoDB_branch.SetAddress(<void*>&self.m1RelPFIsoDB_value)

        #print "making m1RelPFIsoRho"
        self.m1RelPFIsoRho_branch = the_tree.GetBranch("m1RelPFIsoRho")
        #if not self.m1RelPFIsoRho_branch and "m1RelPFIsoRho" not in self.complained:
        if not self.m1RelPFIsoRho_branch and "m1RelPFIsoRho":
            warnings.warn( "MuMuETauTree: Expected branch m1RelPFIsoRho does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1RelPFIsoRho")
        else:
            self.m1RelPFIsoRho_branch.SetAddress(<void*>&self.m1RelPFIsoRho_value)

        #print "making m1RelPFIsoRhoFSR"
        self.m1RelPFIsoRhoFSR_branch = the_tree.GetBranch("m1RelPFIsoRhoFSR")
        #if not self.m1RelPFIsoRhoFSR_branch and "m1RelPFIsoRhoFSR" not in self.complained:
        if not self.m1RelPFIsoRhoFSR_branch and "m1RelPFIsoRhoFSR":
            warnings.warn( "MuMuETauTree: Expected branch m1RelPFIsoRhoFSR does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1RelPFIsoRhoFSR")
        else:
            self.m1RelPFIsoRhoFSR_branch.SetAddress(<void*>&self.m1RelPFIsoRhoFSR_value)

        #print "making m1RhoHZG2011"
        self.m1RhoHZG2011_branch = the_tree.GetBranch("m1RhoHZG2011")
        #if not self.m1RhoHZG2011_branch and "m1RhoHZG2011" not in self.complained:
        if not self.m1RhoHZG2011_branch and "m1RhoHZG2011":
            warnings.warn( "MuMuETauTree: Expected branch m1RhoHZG2011 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1RhoHZG2011")
        else:
            self.m1RhoHZG2011_branch.SetAddress(<void*>&self.m1RhoHZG2011_value)

        #print "making m1RhoHZG2012"
        self.m1RhoHZG2012_branch = the_tree.GetBranch("m1RhoHZG2012")
        #if not self.m1RhoHZG2012_branch and "m1RhoHZG2012" not in self.complained:
        if not self.m1RhoHZG2012_branch and "m1RhoHZG2012":
            warnings.warn( "MuMuETauTree: Expected branch m1RhoHZG2012 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1RhoHZG2012")
        else:
            self.m1RhoHZG2012_branch.SetAddress(<void*>&self.m1RhoHZG2012_value)

        #print "making m1SingleMu13L3Filtered13"
        self.m1SingleMu13L3Filtered13_branch = the_tree.GetBranch("m1SingleMu13L3Filtered13")
        #if not self.m1SingleMu13L3Filtered13_branch and "m1SingleMu13L3Filtered13" not in self.complained:
        if not self.m1SingleMu13L3Filtered13_branch and "m1SingleMu13L3Filtered13":
            warnings.warn( "MuMuETauTree: Expected branch m1SingleMu13L3Filtered13 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1SingleMu13L3Filtered13")
        else:
            self.m1SingleMu13L3Filtered13_branch.SetAddress(<void*>&self.m1SingleMu13L3Filtered13_value)

        #print "making m1SingleMu13L3Filtered17"
        self.m1SingleMu13L3Filtered17_branch = the_tree.GetBranch("m1SingleMu13L3Filtered17")
        #if not self.m1SingleMu13L3Filtered17_branch and "m1SingleMu13L3Filtered17" not in self.complained:
        if not self.m1SingleMu13L3Filtered17_branch and "m1SingleMu13L3Filtered17":
            warnings.warn( "MuMuETauTree: Expected branch m1SingleMu13L3Filtered17 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1SingleMu13L3Filtered17")
        else:
            self.m1SingleMu13L3Filtered17_branch.SetAddress(<void*>&self.m1SingleMu13L3Filtered17_value)

        #print "making m1TkLayersWithMeasurement"
        self.m1TkLayersWithMeasurement_branch = the_tree.GetBranch("m1TkLayersWithMeasurement")
        #if not self.m1TkLayersWithMeasurement_branch and "m1TkLayersWithMeasurement" not in self.complained:
        if not self.m1TkLayersWithMeasurement_branch and "m1TkLayersWithMeasurement":
            warnings.warn( "MuMuETauTree: Expected branch m1TkLayersWithMeasurement does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1TkLayersWithMeasurement")
        else:
            self.m1TkLayersWithMeasurement_branch.SetAddress(<void*>&self.m1TkLayersWithMeasurement_value)

        #print "making m1ToMETDPhi"
        self.m1ToMETDPhi_branch = the_tree.GetBranch("m1ToMETDPhi")
        #if not self.m1ToMETDPhi_branch and "m1ToMETDPhi" not in self.complained:
        if not self.m1ToMETDPhi_branch and "m1ToMETDPhi":
            warnings.warn( "MuMuETauTree: Expected branch m1ToMETDPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1ToMETDPhi")
        else:
            self.m1ToMETDPhi_branch.SetAddress(<void*>&self.m1ToMETDPhi_value)

        #print "making m1TypeCode"
        self.m1TypeCode_branch = the_tree.GetBranch("m1TypeCode")
        #if not self.m1TypeCode_branch and "m1TypeCode" not in self.complained:
        if not self.m1TypeCode_branch and "m1TypeCode":
            warnings.warn( "MuMuETauTree: Expected branch m1TypeCode does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1TypeCode")
        else:
            self.m1TypeCode_branch.SetAddress(<void*>&self.m1TypeCode_value)

        #print "making m1VBTFID"
        self.m1VBTFID_branch = the_tree.GetBranch("m1VBTFID")
        #if not self.m1VBTFID_branch and "m1VBTFID" not in self.complained:
        if not self.m1VBTFID_branch and "m1VBTFID":
            warnings.warn( "MuMuETauTree: Expected branch m1VBTFID does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1VBTFID")
        else:
            self.m1VBTFID_branch.SetAddress(<void*>&self.m1VBTFID_value)

        #print "making m1VZ"
        self.m1VZ_branch = the_tree.GetBranch("m1VZ")
        #if not self.m1VZ_branch and "m1VZ" not in self.complained:
        if not self.m1VZ_branch and "m1VZ":
            warnings.warn( "MuMuETauTree: Expected branch m1VZ does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1VZ")
        else:
            self.m1VZ_branch.SetAddress(<void*>&self.m1VZ_value)

        #print "making m1WWID"
        self.m1WWID_branch = the_tree.GetBranch("m1WWID")
        #if not self.m1WWID_branch and "m1WWID" not in self.complained:
        if not self.m1WWID_branch and "m1WWID":
            warnings.warn( "MuMuETauTree: Expected branch m1WWID does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1WWID")
        else:
            self.m1WWID_branch.SetAddress(<void*>&self.m1WWID_value)

        #print "making m1_m2_CosThetaStar"
        self.m1_m2_CosThetaStar_branch = the_tree.GetBranch("m1_m2_CosThetaStar")
        #if not self.m1_m2_CosThetaStar_branch and "m1_m2_CosThetaStar" not in self.complained:
        if not self.m1_m2_CosThetaStar_branch and "m1_m2_CosThetaStar":
            warnings.warn( "MuMuETauTree: Expected branch m1_m2_CosThetaStar does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_m2_CosThetaStar")
        else:
            self.m1_m2_CosThetaStar_branch.SetAddress(<void*>&self.m1_m2_CosThetaStar_value)

        #print "making m1_m2_DPhi"
        self.m1_m2_DPhi_branch = the_tree.GetBranch("m1_m2_DPhi")
        #if not self.m1_m2_DPhi_branch and "m1_m2_DPhi" not in self.complained:
        if not self.m1_m2_DPhi_branch and "m1_m2_DPhi":
            warnings.warn( "MuMuETauTree: Expected branch m1_m2_DPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_m2_DPhi")
        else:
            self.m1_m2_DPhi_branch.SetAddress(<void*>&self.m1_m2_DPhi_value)

        #print "making m1_m2_DR"
        self.m1_m2_DR_branch = the_tree.GetBranch("m1_m2_DR")
        #if not self.m1_m2_DR_branch and "m1_m2_DR" not in self.complained:
        if not self.m1_m2_DR_branch and "m1_m2_DR":
            warnings.warn( "MuMuETauTree: Expected branch m1_m2_DR does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_m2_DR")
        else:
            self.m1_m2_DR_branch.SetAddress(<void*>&self.m1_m2_DR_value)

        #print "making m1_m2_Eta"
        self.m1_m2_Eta_branch = the_tree.GetBranch("m1_m2_Eta")
        #if not self.m1_m2_Eta_branch and "m1_m2_Eta" not in self.complained:
        if not self.m1_m2_Eta_branch and "m1_m2_Eta":
            warnings.warn( "MuMuETauTree: Expected branch m1_m2_Eta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_m2_Eta")
        else:
            self.m1_m2_Eta_branch.SetAddress(<void*>&self.m1_m2_Eta_value)

        #print "making m1_m2_Mass"
        self.m1_m2_Mass_branch = the_tree.GetBranch("m1_m2_Mass")
        #if not self.m1_m2_Mass_branch and "m1_m2_Mass" not in self.complained:
        if not self.m1_m2_Mass_branch and "m1_m2_Mass":
            warnings.warn( "MuMuETauTree: Expected branch m1_m2_Mass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_m2_Mass")
        else:
            self.m1_m2_Mass_branch.SetAddress(<void*>&self.m1_m2_Mass_value)

        #print "making m1_m2_MassFsr"
        self.m1_m2_MassFsr_branch = the_tree.GetBranch("m1_m2_MassFsr")
        #if not self.m1_m2_MassFsr_branch and "m1_m2_MassFsr" not in self.complained:
        if not self.m1_m2_MassFsr_branch and "m1_m2_MassFsr":
            warnings.warn( "MuMuETauTree: Expected branch m1_m2_MassFsr does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_m2_MassFsr")
        else:
            self.m1_m2_MassFsr_branch.SetAddress(<void*>&self.m1_m2_MassFsr_value)

        #print "making m1_m2_PZeta"
        self.m1_m2_PZeta_branch = the_tree.GetBranch("m1_m2_PZeta")
        #if not self.m1_m2_PZeta_branch and "m1_m2_PZeta" not in self.complained:
        if not self.m1_m2_PZeta_branch and "m1_m2_PZeta":
            warnings.warn( "MuMuETauTree: Expected branch m1_m2_PZeta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_m2_PZeta")
        else:
            self.m1_m2_PZeta_branch.SetAddress(<void*>&self.m1_m2_PZeta_value)

        #print "making m1_m2_PZetaVis"
        self.m1_m2_PZetaVis_branch = the_tree.GetBranch("m1_m2_PZetaVis")
        #if not self.m1_m2_PZetaVis_branch and "m1_m2_PZetaVis" not in self.complained:
        if not self.m1_m2_PZetaVis_branch and "m1_m2_PZetaVis":
            warnings.warn( "MuMuETauTree: Expected branch m1_m2_PZetaVis does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_m2_PZetaVis")
        else:
            self.m1_m2_PZetaVis_branch.SetAddress(<void*>&self.m1_m2_PZetaVis_value)

        #print "making m1_m2_Phi"
        self.m1_m2_Phi_branch = the_tree.GetBranch("m1_m2_Phi")
        #if not self.m1_m2_Phi_branch and "m1_m2_Phi" not in self.complained:
        if not self.m1_m2_Phi_branch and "m1_m2_Phi":
            warnings.warn( "MuMuETauTree: Expected branch m1_m2_Phi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_m2_Phi")
        else:
            self.m1_m2_Phi_branch.SetAddress(<void*>&self.m1_m2_Phi_value)

        #print "making m1_m2_Pt"
        self.m1_m2_Pt_branch = the_tree.GetBranch("m1_m2_Pt")
        #if not self.m1_m2_Pt_branch and "m1_m2_Pt" not in self.complained:
        if not self.m1_m2_Pt_branch and "m1_m2_Pt":
            warnings.warn( "MuMuETauTree: Expected branch m1_m2_Pt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_m2_Pt")
        else:
            self.m1_m2_Pt_branch.SetAddress(<void*>&self.m1_m2_Pt_value)

        #print "making m1_m2_PtFsr"
        self.m1_m2_PtFsr_branch = the_tree.GetBranch("m1_m2_PtFsr")
        #if not self.m1_m2_PtFsr_branch and "m1_m2_PtFsr" not in self.complained:
        if not self.m1_m2_PtFsr_branch and "m1_m2_PtFsr":
            warnings.warn( "MuMuETauTree: Expected branch m1_m2_PtFsr does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_m2_PtFsr")
        else:
            self.m1_m2_PtFsr_branch.SetAddress(<void*>&self.m1_m2_PtFsr_value)

        #print "making m1_m2_SS"
        self.m1_m2_SS_branch = the_tree.GetBranch("m1_m2_SS")
        #if not self.m1_m2_SS_branch and "m1_m2_SS" not in self.complained:
        if not self.m1_m2_SS_branch and "m1_m2_SS":
            warnings.warn( "MuMuETauTree: Expected branch m1_m2_SS does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_m2_SS")
        else:
            self.m1_m2_SS_branch.SetAddress(<void*>&self.m1_m2_SS_value)

        #print "making m1_m2_ToMETDPhi_Ty1"
        self.m1_m2_ToMETDPhi_Ty1_branch = the_tree.GetBranch("m1_m2_ToMETDPhi_Ty1")
        #if not self.m1_m2_ToMETDPhi_Ty1_branch and "m1_m2_ToMETDPhi_Ty1" not in self.complained:
        if not self.m1_m2_ToMETDPhi_Ty1_branch and "m1_m2_ToMETDPhi_Ty1":
            warnings.warn( "MuMuETauTree: Expected branch m1_m2_ToMETDPhi_Ty1 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_m2_ToMETDPhi_Ty1")
        else:
            self.m1_m2_ToMETDPhi_Ty1_branch.SetAddress(<void*>&self.m1_m2_ToMETDPhi_Ty1_value)

        #print "making m1_m2_Zcompat"
        self.m1_m2_Zcompat_branch = the_tree.GetBranch("m1_m2_Zcompat")
        #if not self.m1_m2_Zcompat_branch and "m1_m2_Zcompat" not in self.complained:
        if not self.m1_m2_Zcompat_branch and "m1_m2_Zcompat":
            warnings.warn( "MuMuETauTree: Expected branch m1_m2_Zcompat does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_m2_Zcompat")
        else:
            self.m1_m2_Zcompat_branch.SetAddress(<void*>&self.m1_m2_Zcompat_value)

        #print "making m1_t_CosThetaStar"
        self.m1_t_CosThetaStar_branch = the_tree.GetBranch("m1_t_CosThetaStar")
        #if not self.m1_t_CosThetaStar_branch and "m1_t_CosThetaStar" not in self.complained:
        if not self.m1_t_CosThetaStar_branch and "m1_t_CosThetaStar":
            warnings.warn( "MuMuETauTree: Expected branch m1_t_CosThetaStar does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_t_CosThetaStar")
        else:
            self.m1_t_CosThetaStar_branch.SetAddress(<void*>&self.m1_t_CosThetaStar_value)

        #print "making m1_t_DPhi"
        self.m1_t_DPhi_branch = the_tree.GetBranch("m1_t_DPhi")
        #if not self.m1_t_DPhi_branch and "m1_t_DPhi" not in self.complained:
        if not self.m1_t_DPhi_branch and "m1_t_DPhi":
            warnings.warn( "MuMuETauTree: Expected branch m1_t_DPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_t_DPhi")
        else:
            self.m1_t_DPhi_branch.SetAddress(<void*>&self.m1_t_DPhi_value)

        #print "making m1_t_DR"
        self.m1_t_DR_branch = the_tree.GetBranch("m1_t_DR")
        #if not self.m1_t_DR_branch and "m1_t_DR" not in self.complained:
        if not self.m1_t_DR_branch and "m1_t_DR":
            warnings.warn( "MuMuETauTree: Expected branch m1_t_DR does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_t_DR")
        else:
            self.m1_t_DR_branch.SetAddress(<void*>&self.m1_t_DR_value)

        #print "making m1_t_Eta"
        self.m1_t_Eta_branch = the_tree.GetBranch("m1_t_Eta")
        #if not self.m1_t_Eta_branch and "m1_t_Eta" not in self.complained:
        if not self.m1_t_Eta_branch and "m1_t_Eta":
            warnings.warn( "MuMuETauTree: Expected branch m1_t_Eta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_t_Eta")
        else:
            self.m1_t_Eta_branch.SetAddress(<void*>&self.m1_t_Eta_value)

        #print "making m1_t_Mass"
        self.m1_t_Mass_branch = the_tree.GetBranch("m1_t_Mass")
        #if not self.m1_t_Mass_branch and "m1_t_Mass" not in self.complained:
        if not self.m1_t_Mass_branch and "m1_t_Mass":
            warnings.warn( "MuMuETauTree: Expected branch m1_t_Mass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_t_Mass")
        else:
            self.m1_t_Mass_branch.SetAddress(<void*>&self.m1_t_Mass_value)

        #print "making m1_t_MassFsr"
        self.m1_t_MassFsr_branch = the_tree.GetBranch("m1_t_MassFsr")
        #if not self.m1_t_MassFsr_branch and "m1_t_MassFsr" not in self.complained:
        if not self.m1_t_MassFsr_branch and "m1_t_MassFsr":
            warnings.warn( "MuMuETauTree: Expected branch m1_t_MassFsr does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_t_MassFsr")
        else:
            self.m1_t_MassFsr_branch.SetAddress(<void*>&self.m1_t_MassFsr_value)

        #print "making m1_t_PZeta"
        self.m1_t_PZeta_branch = the_tree.GetBranch("m1_t_PZeta")
        #if not self.m1_t_PZeta_branch and "m1_t_PZeta" not in self.complained:
        if not self.m1_t_PZeta_branch and "m1_t_PZeta":
            warnings.warn( "MuMuETauTree: Expected branch m1_t_PZeta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_t_PZeta")
        else:
            self.m1_t_PZeta_branch.SetAddress(<void*>&self.m1_t_PZeta_value)

        #print "making m1_t_PZetaVis"
        self.m1_t_PZetaVis_branch = the_tree.GetBranch("m1_t_PZetaVis")
        #if not self.m1_t_PZetaVis_branch and "m1_t_PZetaVis" not in self.complained:
        if not self.m1_t_PZetaVis_branch and "m1_t_PZetaVis":
            warnings.warn( "MuMuETauTree: Expected branch m1_t_PZetaVis does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_t_PZetaVis")
        else:
            self.m1_t_PZetaVis_branch.SetAddress(<void*>&self.m1_t_PZetaVis_value)

        #print "making m1_t_Phi"
        self.m1_t_Phi_branch = the_tree.GetBranch("m1_t_Phi")
        #if not self.m1_t_Phi_branch and "m1_t_Phi" not in self.complained:
        if not self.m1_t_Phi_branch and "m1_t_Phi":
            warnings.warn( "MuMuETauTree: Expected branch m1_t_Phi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_t_Phi")
        else:
            self.m1_t_Phi_branch.SetAddress(<void*>&self.m1_t_Phi_value)

        #print "making m1_t_Pt"
        self.m1_t_Pt_branch = the_tree.GetBranch("m1_t_Pt")
        #if not self.m1_t_Pt_branch and "m1_t_Pt" not in self.complained:
        if not self.m1_t_Pt_branch and "m1_t_Pt":
            warnings.warn( "MuMuETauTree: Expected branch m1_t_Pt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_t_Pt")
        else:
            self.m1_t_Pt_branch.SetAddress(<void*>&self.m1_t_Pt_value)

        #print "making m1_t_PtFsr"
        self.m1_t_PtFsr_branch = the_tree.GetBranch("m1_t_PtFsr")
        #if not self.m1_t_PtFsr_branch and "m1_t_PtFsr" not in self.complained:
        if not self.m1_t_PtFsr_branch and "m1_t_PtFsr":
            warnings.warn( "MuMuETauTree: Expected branch m1_t_PtFsr does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_t_PtFsr")
        else:
            self.m1_t_PtFsr_branch.SetAddress(<void*>&self.m1_t_PtFsr_value)

        #print "making m1_t_SS"
        self.m1_t_SS_branch = the_tree.GetBranch("m1_t_SS")
        #if not self.m1_t_SS_branch and "m1_t_SS" not in self.complained:
        if not self.m1_t_SS_branch and "m1_t_SS":
            warnings.warn( "MuMuETauTree: Expected branch m1_t_SS does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_t_SS")
        else:
            self.m1_t_SS_branch.SetAddress(<void*>&self.m1_t_SS_value)

        #print "making m1_t_ToMETDPhi_Ty1"
        self.m1_t_ToMETDPhi_Ty1_branch = the_tree.GetBranch("m1_t_ToMETDPhi_Ty1")
        #if not self.m1_t_ToMETDPhi_Ty1_branch and "m1_t_ToMETDPhi_Ty1" not in self.complained:
        if not self.m1_t_ToMETDPhi_Ty1_branch and "m1_t_ToMETDPhi_Ty1":
            warnings.warn( "MuMuETauTree: Expected branch m1_t_ToMETDPhi_Ty1 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_t_ToMETDPhi_Ty1")
        else:
            self.m1_t_ToMETDPhi_Ty1_branch.SetAddress(<void*>&self.m1_t_ToMETDPhi_Ty1_value)

        #print "making m1_t_Zcompat"
        self.m1_t_Zcompat_branch = the_tree.GetBranch("m1_t_Zcompat")
        #if not self.m1_t_Zcompat_branch and "m1_t_Zcompat" not in self.complained:
        if not self.m1_t_Zcompat_branch and "m1_t_Zcompat":
            warnings.warn( "MuMuETauTree: Expected branch m1_t_Zcompat does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_t_Zcompat")
        else:
            self.m1_t_Zcompat_branch.SetAddress(<void*>&self.m1_t_Zcompat_value)

        #print "making m2AbsEta"
        self.m2AbsEta_branch = the_tree.GetBranch("m2AbsEta")
        #if not self.m2AbsEta_branch and "m2AbsEta" not in self.complained:
        if not self.m2AbsEta_branch and "m2AbsEta":
            warnings.warn( "MuMuETauTree: Expected branch m2AbsEta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2AbsEta")
        else:
            self.m2AbsEta_branch.SetAddress(<void*>&self.m2AbsEta_value)

        #print "making m2Charge"
        self.m2Charge_branch = the_tree.GetBranch("m2Charge")
        #if not self.m2Charge_branch and "m2Charge" not in self.complained:
        if not self.m2Charge_branch and "m2Charge":
            warnings.warn( "MuMuETauTree: Expected branch m2Charge does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2Charge")
        else:
            self.m2Charge_branch.SetAddress(<void*>&self.m2Charge_value)

        #print "making m2ComesFromHiggs"
        self.m2ComesFromHiggs_branch = the_tree.GetBranch("m2ComesFromHiggs")
        #if not self.m2ComesFromHiggs_branch and "m2ComesFromHiggs" not in self.complained:
        if not self.m2ComesFromHiggs_branch and "m2ComesFromHiggs":
            warnings.warn( "MuMuETauTree: Expected branch m2ComesFromHiggs does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2ComesFromHiggs")
        else:
            self.m2ComesFromHiggs_branch.SetAddress(<void*>&self.m2ComesFromHiggs_value)

        #print "making m2D0"
        self.m2D0_branch = the_tree.GetBranch("m2D0")
        #if not self.m2D0_branch and "m2D0" not in self.complained:
        if not self.m2D0_branch and "m2D0":
            warnings.warn( "MuMuETauTree: Expected branch m2D0 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2D0")
        else:
            self.m2D0_branch.SetAddress(<void*>&self.m2D0_value)

        #print "making m2DZ"
        self.m2DZ_branch = the_tree.GetBranch("m2DZ")
        #if not self.m2DZ_branch and "m2DZ" not in self.complained:
        if not self.m2DZ_branch and "m2DZ":
            warnings.warn( "MuMuETauTree: Expected branch m2DZ does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2DZ")
        else:
            self.m2DZ_branch.SetAddress(<void*>&self.m2DZ_value)

        #print "making m2DiMuonL3PreFiltered7"
        self.m2DiMuonL3PreFiltered7_branch = the_tree.GetBranch("m2DiMuonL3PreFiltered7")
        #if not self.m2DiMuonL3PreFiltered7_branch and "m2DiMuonL3PreFiltered7" not in self.complained:
        if not self.m2DiMuonL3PreFiltered7_branch and "m2DiMuonL3PreFiltered7":
            warnings.warn( "MuMuETauTree: Expected branch m2DiMuonL3PreFiltered7 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2DiMuonL3PreFiltered7")
        else:
            self.m2DiMuonL3PreFiltered7_branch.SetAddress(<void*>&self.m2DiMuonL3PreFiltered7_value)

        #print "making m2DiMuonL3p5PreFiltered8"
        self.m2DiMuonL3p5PreFiltered8_branch = the_tree.GetBranch("m2DiMuonL3p5PreFiltered8")
        #if not self.m2DiMuonL3p5PreFiltered8_branch and "m2DiMuonL3p5PreFiltered8" not in self.complained:
        if not self.m2DiMuonL3p5PreFiltered8_branch and "m2DiMuonL3p5PreFiltered8":
            warnings.warn( "MuMuETauTree: Expected branch m2DiMuonL3p5PreFiltered8 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2DiMuonL3p5PreFiltered8")
        else:
            self.m2DiMuonL3p5PreFiltered8_branch.SetAddress(<void*>&self.m2DiMuonL3p5PreFiltered8_value)

        #print "making m2DiMuonMu17Mu8DzFiltered0p2"
        self.m2DiMuonMu17Mu8DzFiltered0p2_branch = the_tree.GetBranch("m2DiMuonMu17Mu8DzFiltered0p2")
        #if not self.m2DiMuonMu17Mu8DzFiltered0p2_branch and "m2DiMuonMu17Mu8DzFiltered0p2" not in self.complained:
        if not self.m2DiMuonMu17Mu8DzFiltered0p2_branch and "m2DiMuonMu17Mu8DzFiltered0p2":
            warnings.warn( "MuMuETauTree: Expected branch m2DiMuonMu17Mu8DzFiltered0p2 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2DiMuonMu17Mu8DzFiltered0p2")
        else:
            self.m2DiMuonMu17Mu8DzFiltered0p2_branch.SetAddress(<void*>&self.m2DiMuonMu17Mu8DzFiltered0p2_value)

        #print "making m2EErrRochCor2011A"
        self.m2EErrRochCor2011A_branch = the_tree.GetBranch("m2EErrRochCor2011A")
        #if not self.m2EErrRochCor2011A_branch and "m2EErrRochCor2011A" not in self.complained:
        if not self.m2EErrRochCor2011A_branch and "m2EErrRochCor2011A":
            warnings.warn( "MuMuETauTree: Expected branch m2EErrRochCor2011A does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2EErrRochCor2011A")
        else:
            self.m2EErrRochCor2011A_branch.SetAddress(<void*>&self.m2EErrRochCor2011A_value)

        #print "making m2EErrRochCor2011B"
        self.m2EErrRochCor2011B_branch = the_tree.GetBranch("m2EErrRochCor2011B")
        #if not self.m2EErrRochCor2011B_branch and "m2EErrRochCor2011B" not in self.complained:
        if not self.m2EErrRochCor2011B_branch and "m2EErrRochCor2011B":
            warnings.warn( "MuMuETauTree: Expected branch m2EErrRochCor2011B does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2EErrRochCor2011B")
        else:
            self.m2EErrRochCor2011B_branch.SetAddress(<void*>&self.m2EErrRochCor2011B_value)

        #print "making m2EErrRochCor2012"
        self.m2EErrRochCor2012_branch = the_tree.GetBranch("m2EErrRochCor2012")
        #if not self.m2EErrRochCor2012_branch and "m2EErrRochCor2012" not in self.complained:
        if not self.m2EErrRochCor2012_branch and "m2EErrRochCor2012":
            warnings.warn( "MuMuETauTree: Expected branch m2EErrRochCor2012 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2EErrRochCor2012")
        else:
            self.m2EErrRochCor2012_branch.SetAddress(<void*>&self.m2EErrRochCor2012_value)

        #print "making m2ERochCor2011A"
        self.m2ERochCor2011A_branch = the_tree.GetBranch("m2ERochCor2011A")
        #if not self.m2ERochCor2011A_branch and "m2ERochCor2011A" not in self.complained:
        if not self.m2ERochCor2011A_branch and "m2ERochCor2011A":
            warnings.warn( "MuMuETauTree: Expected branch m2ERochCor2011A does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2ERochCor2011A")
        else:
            self.m2ERochCor2011A_branch.SetAddress(<void*>&self.m2ERochCor2011A_value)

        #print "making m2ERochCor2011B"
        self.m2ERochCor2011B_branch = the_tree.GetBranch("m2ERochCor2011B")
        #if not self.m2ERochCor2011B_branch and "m2ERochCor2011B" not in self.complained:
        if not self.m2ERochCor2011B_branch and "m2ERochCor2011B":
            warnings.warn( "MuMuETauTree: Expected branch m2ERochCor2011B does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2ERochCor2011B")
        else:
            self.m2ERochCor2011B_branch.SetAddress(<void*>&self.m2ERochCor2011B_value)

        #print "making m2ERochCor2012"
        self.m2ERochCor2012_branch = the_tree.GetBranch("m2ERochCor2012")
        #if not self.m2ERochCor2012_branch and "m2ERochCor2012" not in self.complained:
        if not self.m2ERochCor2012_branch and "m2ERochCor2012":
            warnings.warn( "MuMuETauTree: Expected branch m2ERochCor2012 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2ERochCor2012")
        else:
            self.m2ERochCor2012_branch.SetAddress(<void*>&self.m2ERochCor2012_value)

        #print "making m2EffectiveArea2011"
        self.m2EffectiveArea2011_branch = the_tree.GetBranch("m2EffectiveArea2011")
        #if not self.m2EffectiveArea2011_branch and "m2EffectiveArea2011" not in self.complained:
        if not self.m2EffectiveArea2011_branch and "m2EffectiveArea2011":
            warnings.warn( "MuMuETauTree: Expected branch m2EffectiveArea2011 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2EffectiveArea2011")
        else:
            self.m2EffectiveArea2011_branch.SetAddress(<void*>&self.m2EffectiveArea2011_value)

        #print "making m2EffectiveArea2012"
        self.m2EffectiveArea2012_branch = the_tree.GetBranch("m2EffectiveArea2012")
        #if not self.m2EffectiveArea2012_branch and "m2EffectiveArea2012" not in self.complained:
        if not self.m2EffectiveArea2012_branch and "m2EffectiveArea2012":
            warnings.warn( "MuMuETauTree: Expected branch m2EffectiveArea2012 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2EffectiveArea2012")
        else:
            self.m2EffectiveArea2012_branch.SetAddress(<void*>&self.m2EffectiveArea2012_value)

        #print "making m2Eta"
        self.m2Eta_branch = the_tree.GetBranch("m2Eta")
        #if not self.m2Eta_branch and "m2Eta" not in self.complained:
        if not self.m2Eta_branch and "m2Eta":
            warnings.warn( "MuMuETauTree: Expected branch m2Eta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2Eta")
        else:
            self.m2Eta_branch.SetAddress(<void*>&self.m2Eta_value)

        #print "making m2EtaRochCor2011A"
        self.m2EtaRochCor2011A_branch = the_tree.GetBranch("m2EtaRochCor2011A")
        #if not self.m2EtaRochCor2011A_branch and "m2EtaRochCor2011A" not in self.complained:
        if not self.m2EtaRochCor2011A_branch and "m2EtaRochCor2011A":
            warnings.warn( "MuMuETauTree: Expected branch m2EtaRochCor2011A does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2EtaRochCor2011A")
        else:
            self.m2EtaRochCor2011A_branch.SetAddress(<void*>&self.m2EtaRochCor2011A_value)

        #print "making m2EtaRochCor2011B"
        self.m2EtaRochCor2011B_branch = the_tree.GetBranch("m2EtaRochCor2011B")
        #if not self.m2EtaRochCor2011B_branch and "m2EtaRochCor2011B" not in self.complained:
        if not self.m2EtaRochCor2011B_branch and "m2EtaRochCor2011B":
            warnings.warn( "MuMuETauTree: Expected branch m2EtaRochCor2011B does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2EtaRochCor2011B")
        else:
            self.m2EtaRochCor2011B_branch.SetAddress(<void*>&self.m2EtaRochCor2011B_value)

        #print "making m2EtaRochCor2012"
        self.m2EtaRochCor2012_branch = the_tree.GetBranch("m2EtaRochCor2012")
        #if not self.m2EtaRochCor2012_branch and "m2EtaRochCor2012" not in self.complained:
        if not self.m2EtaRochCor2012_branch and "m2EtaRochCor2012":
            warnings.warn( "MuMuETauTree: Expected branch m2EtaRochCor2012 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2EtaRochCor2012")
        else:
            self.m2EtaRochCor2012_branch.SetAddress(<void*>&self.m2EtaRochCor2012_value)

        #print "making m2GenCharge"
        self.m2GenCharge_branch = the_tree.GetBranch("m2GenCharge")
        #if not self.m2GenCharge_branch and "m2GenCharge" not in self.complained:
        if not self.m2GenCharge_branch and "m2GenCharge":
            warnings.warn( "MuMuETauTree: Expected branch m2GenCharge does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2GenCharge")
        else:
            self.m2GenCharge_branch.SetAddress(<void*>&self.m2GenCharge_value)

        #print "making m2GenEnergy"
        self.m2GenEnergy_branch = the_tree.GetBranch("m2GenEnergy")
        #if not self.m2GenEnergy_branch and "m2GenEnergy" not in self.complained:
        if not self.m2GenEnergy_branch and "m2GenEnergy":
            warnings.warn( "MuMuETauTree: Expected branch m2GenEnergy does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2GenEnergy")
        else:
            self.m2GenEnergy_branch.SetAddress(<void*>&self.m2GenEnergy_value)

        #print "making m2GenEta"
        self.m2GenEta_branch = the_tree.GetBranch("m2GenEta")
        #if not self.m2GenEta_branch and "m2GenEta" not in self.complained:
        if not self.m2GenEta_branch and "m2GenEta":
            warnings.warn( "MuMuETauTree: Expected branch m2GenEta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2GenEta")
        else:
            self.m2GenEta_branch.SetAddress(<void*>&self.m2GenEta_value)

        #print "making m2GenMotherPdgId"
        self.m2GenMotherPdgId_branch = the_tree.GetBranch("m2GenMotherPdgId")
        #if not self.m2GenMotherPdgId_branch and "m2GenMotherPdgId" not in self.complained:
        if not self.m2GenMotherPdgId_branch and "m2GenMotherPdgId":
            warnings.warn( "MuMuETauTree: Expected branch m2GenMotherPdgId does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2GenMotherPdgId")
        else:
            self.m2GenMotherPdgId_branch.SetAddress(<void*>&self.m2GenMotherPdgId_value)

        #print "making m2GenPdgId"
        self.m2GenPdgId_branch = the_tree.GetBranch("m2GenPdgId")
        #if not self.m2GenPdgId_branch and "m2GenPdgId" not in self.complained:
        if not self.m2GenPdgId_branch and "m2GenPdgId":
            warnings.warn( "MuMuETauTree: Expected branch m2GenPdgId does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2GenPdgId")
        else:
            self.m2GenPdgId_branch.SetAddress(<void*>&self.m2GenPdgId_value)

        #print "making m2GenPhi"
        self.m2GenPhi_branch = the_tree.GetBranch("m2GenPhi")
        #if not self.m2GenPhi_branch and "m2GenPhi" not in self.complained:
        if not self.m2GenPhi_branch and "m2GenPhi":
            warnings.warn( "MuMuETauTree: Expected branch m2GenPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2GenPhi")
        else:
            self.m2GenPhi_branch.SetAddress(<void*>&self.m2GenPhi_value)

        #print "making m2GlbTrkHits"
        self.m2GlbTrkHits_branch = the_tree.GetBranch("m2GlbTrkHits")
        #if not self.m2GlbTrkHits_branch and "m2GlbTrkHits" not in self.complained:
        if not self.m2GlbTrkHits_branch and "m2GlbTrkHits":
            warnings.warn( "MuMuETauTree: Expected branch m2GlbTrkHits does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2GlbTrkHits")
        else:
            self.m2GlbTrkHits_branch.SetAddress(<void*>&self.m2GlbTrkHits_value)

        #print "making m2IDHZG2011"
        self.m2IDHZG2011_branch = the_tree.GetBranch("m2IDHZG2011")
        #if not self.m2IDHZG2011_branch and "m2IDHZG2011" not in self.complained:
        if not self.m2IDHZG2011_branch and "m2IDHZG2011":
            warnings.warn( "MuMuETauTree: Expected branch m2IDHZG2011 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2IDHZG2011")
        else:
            self.m2IDHZG2011_branch.SetAddress(<void*>&self.m2IDHZG2011_value)

        #print "making m2IDHZG2012"
        self.m2IDHZG2012_branch = the_tree.GetBranch("m2IDHZG2012")
        #if not self.m2IDHZG2012_branch and "m2IDHZG2012" not in self.complained:
        if not self.m2IDHZG2012_branch and "m2IDHZG2012":
            warnings.warn( "MuMuETauTree: Expected branch m2IDHZG2012 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2IDHZG2012")
        else:
            self.m2IDHZG2012_branch.SetAddress(<void*>&self.m2IDHZG2012_value)

        #print "making m2IP3DS"
        self.m2IP3DS_branch = the_tree.GetBranch("m2IP3DS")
        #if not self.m2IP3DS_branch and "m2IP3DS" not in self.complained:
        if not self.m2IP3DS_branch and "m2IP3DS":
            warnings.warn( "MuMuETauTree: Expected branch m2IP3DS does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2IP3DS")
        else:
            self.m2IP3DS_branch.SetAddress(<void*>&self.m2IP3DS_value)

        #print "making m2IsGlobal"
        self.m2IsGlobal_branch = the_tree.GetBranch("m2IsGlobal")
        #if not self.m2IsGlobal_branch and "m2IsGlobal" not in self.complained:
        if not self.m2IsGlobal_branch and "m2IsGlobal":
            warnings.warn( "MuMuETauTree: Expected branch m2IsGlobal does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2IsGlobal")
        else:
            self.m2IsGlobal_branch.SetAddress(<void*>&self.m2IsGlobal_value)

        #print "making m2IsPFMuon"
        self.m2IsPFMuon_branch = the_tree.GetBranch("m2IsPFMuon")
        #if not self.m2IsPFMuon_branch and "m2IsPFMuon" not in self.complained:
        if not self.m2IsPFMuon_branch and "m2IsPFMuon":
            warnings.warn( "MuMuETauTree: Expected branch m2IsPFMuon does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2IsPFMuon")
        else:
            self.m2IsPFMuon_branch.SetAddress(<void*>&self.m2IsPFMuon_value)

        #print "making m2IsTracker"
        self.m2IsTracker_branch = the_tree.GetBranch("m2IsTracker")
        #if not self.m2IsTracker_branch and "m2IsTracker" not in self.complained:
        if not self.m2IsTracker_branch and "m2IsTracker":
            warnings.warn( "MuMuETauTree: Expected branch m2IsTracker does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2IsTracker")
        else:
            self.m2IsTracker_branch.SetAddress(<void*>&self.m2IsTracker_value)

        #print "making m2JetArea"
        self.m2JetArea_branch = the_tree.GetBranch("m2JetArea")
        #if not self.m2JetArea_branch and "m2JetArea" not in self.complained:
        if not self.m2JetArea_branch and "m2JetArea":
            warnings.warn( "MuMuETauTree: Expected branch m2JetArea does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2JetArea")
        else:
            self.m2JetArea_branch.SetAddress(<void*>&self.m2JetArea_value)

        #print "making m2JetBtag"
        self.m2JetBtag_branch = the_tree.GetBranch("m2JetBtag")
        #if not self.m2JetBtag_branch and "m2JetBtag" not in self.complained:
        if not self.m2JetBtag_branch and "m2JetBtag":
            warnings.warn( "MuMuETauTree: Expected branch m2JetBtag does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2JetBtag")
        else:
            self.m2JetBtag_branch.SetAddress(<void*>&self.m2JetBtag_value)

        #print "making m2JetCSVBtag"
        self.m2JetCSVBtag_branch = the_tree.GetBranch("m2JetCSVBtag")
        #if not self.m2JetCSVBtag_branch and "m2JetCSVBtag" not in self.complained:
        if not self.m2JetCSVBtag_branch and "m2JetCSVBtag":
            warnings.warn( "MuMuETauTree: Expected branch m2JetCSVBtag does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2JetCSVBtag")
        else:
            self.m2JetCSVBtag_branch.SetAddress(<void*>&self.m2JetCSVBtag_value)

        #print "making m2JetEtaEtaMoment"
        self.m2JetEtaEtaMoment_branch = the_tree.GetBranch("m2JetEtaEtaMoment")
        #if not self.m2JetEtaEtaMoment_branch and "m2JetEtaEtaMoment" not in self.complained:
        if not self.m2JetEtaEtaMoment_branch and "m2JetEtaEtaMoment":
            warnings.warn( "MuMuETauTree: Expected branch m2JetEtaEtaMoment does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2JetEtaEtaMoment")
        else:
            self.m2JetEtaEtaMoment_branch.SetAddress(<void*>&self.m2JetEtaEtaMoment_value)

        #print "making m2JetEtaPhiMoment"
        self.m2JetEtaPhiMoment_branch = the_tree.GetBranch("m2JetEtaPhiMoment")
        #if not self.m2JetEtaPhiMoment_branch and "m2JetEtaPhiMoment" not in self.complained:
        if not self.m2JetEtaPhiMoment_branch and "m2JetEtaPhiMoment":
            warnings.warn( "MuMuETauTree: Expected branch m2JetEtaPhiMoment does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2JetEtaPhiMoment")
        else:
            self.m2JetEtaPhiMoment_branch.SetAddress(<void*>&self.m2JetEtaPhiMoment_value)

        #print "making m2JetEtaPhiSpread"
        self.m2JetEtaPhiSpread_branch = the_tree.GetBranch("m2JetEtaPhiSpread")
        #if not self.m2JetEtaPhiSpread_branch and "m2JetEtaPhiSpread" not in self.complained:
        if not self.m2JetEtaPhiSpread_branch and "m2JetEtaPhiSpread":
            warnings.warn( "MuMuETauTree: Expected branch m2JetEtaPhiSpread does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2JetEtaPhiSpread")
        else:
            self.m2JetEtaPhiSpread_branch.SetAddress(<void*>&self.m2JetEtaPhiSpread_value)

        #print "making m2JetPartonFlavour"
        self.m2JetPartonFlavour_branch = the_tree.GetBranch("m2JetPartonFlavour")
        #if not self.m2JetPartonFlavour_branch and "m2JetPartonFlavour" not in self.complained:
        if not self.m2JetPartonFlavour_branch and "m2JetPartonFlavour":
            warnings.warn( "MuMuETauTree: Expected branch m2JetPartonFlavour does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2JetPartonFlavour")
        else:
            self.m2JetPartonFlavour_branch.SetAddress(<void*>&self.m2JetPartonFlavour_value)

        #print "making m2JetPhiPhiMoment"
        self.m2JetPhiPhiMoment_branch = the_tree.GetBranch("m2JetPhiPhiMoment")
        #if not self.m2JetPhiPhiMoment_branch and "m2JetPhiPhiMoment" not in self.complained:
        if not self.m2JetPhiPhiMoment_branch and "m2JetPhiPhiMoment":
            warnings.warn( "MuMuETauTree: Expected branch m2JetPhiPhiMoment does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2JetPhiPhiMoment")
        else:
            self.m2JetPhiPhiMoment_branch.SetAddress(<void*>&self.m2JetPhiPhiMoment_value)

        #print "making m2JetPt"
        self.m2JetPt_branch = the_tree.GetBranch("m2JetPt")
        #if not self.m2JetPt_branch and "m2JetPt" not in self.complained:
        if not self.m2JetPt_branch and "m2JetPt":
            warnings.warn( "MuMuETauTree: Expected branch m2JetPt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2JetPt")
        else:
            self.m2JetPt_branch.SetAddress(<void*>&self.m2JetPt_value)

        #print "making m2JetQGLikelihoodID"
        self.m2JetQGLikelihoodID_branch = the_tree.GetBranch("m2JetQGLikelihoodID")
        #if not self.m2JetQGLikelihoodID_branch and "m2JetQGLikelihoodID" not in self.complained:
        if not self.m2JetQGLikelihoodID_branch and "m2JetQGLikelihoodID":
            warnings.warn( "MuMuETauTree: Expected branch m2JetQGLikelihoodID does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2JetQGLikelihoodID")
        else:
            self.m2JetQGLikelihoodID_branch.SetAddress(<void*>&self.m2JetQGLikelihoodID_value)

        #print "making m2JetQGMVAID"
        self.m2JetQGMVAID_branch = the_tree.GetBranch("m2JetQGMVAID")
        #if not self.m2JetQGMVAID_branch and "m2JetQGMVAID" not in self.complained:
        if not self.m2JetQGMVAID_branch and "m2JetQGMVAID":
            warnings.warn( "MuMuETauTree: Expected branch m2JetQGMVAID does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2JetQGMVAID")
        else:
            self.m2JetQGMVAID_branch.SetAddress(<void*>&self.m2JetQGMVAID_value)

        #print "making m2Jetaxis1"
        self.m2Jetaxis1_branch = the_tree.GetBranch("m2Jetaxis1")
        #if not self.m2Jetaxis1_branch and "m2Jetaxis1" not in self.complained:
        if not self.m2Jetaxis1_branch and "m2Jetaxis1":
            warnings.warn( "MuMuETauTree: Expected branch m2Jetaxis1 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2Jetaxis1")
        else:
            self.m2Jetaxis1_branch.SetAddress(<void*>&self.m2Jetaxis1_value)

        #print "making m2Jetaxis2"
        self.m2Jetaxis2_branch = the_tree.GetBranch("m2Jetaxis2")
        #if not self.m2Jetaxis2_branch and "m2Jetaxis2" not in self.complained:
        if not self.m2Jetaxis2_branch and "m2Jetaxis2":
            warnings.warn( "MuMuETauTree: Expected branch m2Jetaxis2 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2Jetaxis2")
        else:
            self.m2Jetaxis2_branch.SetAddress(<void*>&self.m2Jetaxis2_value)

        #print "making m2Jetmult"
        self.m2Jetmult_branch = the_tree.GetBranch("m2Jetmult")
        #if not self.m2Jetmult_branch and "m2Jetmult" not in self.complained:
        if not self.m2Jetmult_branch and "m2Jetmult":
            warnings.warn( "MuMuETauTree: Expected branch m2Jetmult does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2Jetmult")
        else:
            self.m2Jetmult_branch.SetAddress(<void*>&self.m2Jetmult_value)

        #print "making m2JetmultMLP"
        self.m2JetmultMLP_branch = the_tree.GetBranch("m2JetmultMLP")
        #if not self.m2JetmultMLP_branch and "m2JetmultMLP" not in self.complained:
        if not self.m2JetmultMLP_branch and "m2JetmultMLP":
            warnings.warn( "MuMuETauTree: Expected branch m2JetmultMLP does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2JetmultMLP")
        else:
            self.m2JetmultMLP_branch.SetAddress(<void*>&self.m2JetmultMLP_value)

        #print "making m2JetmultMLPQC"
        self.m2JetmultMLPQC_branch = the_tree.GetBranch("m2JetmultMLPQC")
        #if not self.m2JetmultMLPQC_branch and "m2JetmultMLPQC" not in self.complained:
        if not self.m2JetmultMLPQC_branch and "m2JetmultMLPQC":
            warnings.warn( "MuMuETauTree: Expected branch m2JetmultMLPQC does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2JetmultMLPQC")
        else:
            self.m2JetmultMLPQC_branch.SetAddress(<void*>&self.m2JetmultMLPQC_value)

        #print "making m2JetptD"
        self.m2JetptD_branch = the_tree.GetBranch("m2JetptD")
        #if not self.m2JetptD_branch and "m2JetptD" not in self.complained:
        if not self.m2JetptD_branch and "m2JetptD":
            warnings.warn( "MuMuETauTree: Expected branch m2JetptD does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2JetptD")
        else:
            self.m2JetptD_branch.SetAddress(<void*>&self.m2JetptD_value)

        #print "making m2L1Mu3EG5L3Filtered17"
        self.m2L1Mu3EG5L3Filtered17_branch = the_tree.GetBranch("m2L1Mu3EG5L3Filtered17")
        #if not self.m2L1Mu3EG5L3Filtered17_branch and "m2L1Mu3EG5L3Filtered17" not in self.complained:
        if not self.m2L1Mu3EG5L3Filtered17_branch and "m2L1Mu3EG5L3Filtered17":
            warnings.warn( "MuMuETauTree: Expected branch m2L1Mu3EG5L3Filtered17 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2L1Mu3EG5L3Filtered17")
        else:
            self.m2L1Mu3EG5L3Filtered17_branch.SetAddress(<void*>&self.m2L1Mu3EG5L3Filtered17_value)

        #print "making m2L3fL1DoubleMu10MuOpenL1f0L2f10L3Filtered17"
        self.m2L3fL1DoubleMu10MuOpenL1f0L2f10L3Filtered17_branch = the_tree.GetBranch("m2L3fL1DoubleMu10MuOpenL1f0L2f10L3Filtered17")
        #if not self.m2L3fL1DoubleMu10MuOpenL1f0L2f10L3Filtered17_branch and "m2L3fL1DoubleMu10MuOpenL1f0L2f10L3Filtered17" not in self.complained:
        if not self.m2L3fL1DoubleMu10MuOpenL1f0L2f10L3Filtered17_branch and "m2L3fL1DoubleMu10MuOpenL1f0L2f10L3Filtered17":
            warnings.warn( "MuMuETauTree: Expected branch m2L3fL1DoubleMu10MuOpenL1f0L2f10L3Filtered17 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2L3fL1DoubleMu10MuOpenL1f0L2f10L3Filtered17")
        else:
            self.m2L3fL1DoubleMu10MuOpenL1f0L2f10L3Filtered17_branch.SetAddress(<void*>&self.m2L3fL1DoubleMu10MuOpenL1f0L2f10L3Filtered17_value)

        #print "making m2Mass"
        self.m2Mass_branch = the_tree.GetBranch("m2Mass")
        #if not self.m2Mass_branch and "m2Mass" not in self.complained:
        if not self.m2Mass_branch and "m2Mass":
            warnings.warn( "MuMuETauTree: Expected branch m2Mass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2Mass")
        else:
            self.m2Mass_branch.SetAddress(<void*>&self.m2Mass_value)

        #print "making m2MatchedStations"
        self.m2MatchedStations_branch = the_tree.GetBranch("m2MatchedStations")
        #if not self.m2MatchedStations_branch and "m2MatchedStations" not in self.complained:
        if not self.m2MatchedStations_branch and "m2MatchedStations":
            warnings.warn( "MuMuETauTree: Expected branch m2MatchedStations does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2MatchedStations")
        else:
            self.m2MatchedStations_branch.SetAddress(<void*>&self.m2MatchedStations_value)

        #print "making m2MatchesDoubleMuPaths"
        self.m2MatchesDoubleMuPaths_branch = the_tree.GetBranch("m2MatchesDoubleMuPaths")
        #if not self.m2MatchesDoubleMuPaths_branch and "m2MatchesDoubleMuPaths" not in self.complained:
        if not self.m2MatchesDoubleMuPaths_branch and "m2MatchesDoubleMuPaths":
            warnings.warn( "MuMuETauTree: Expected branch m2MatchesDoubleMuPaths does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2MatchesDoubleMuPaths")
        else:
            self.m2MatchesDoubleMuPaths_branch.SetAddress(<void*>&self.m2MatchesDoubleMuPaths_value)

        #print "making m2MatchesDoubleMuTrkPaths"
        self.m2MatchesDoubleMuTrkPaths_branch = the_tree.GetBranch("m2MatchesDoubleMuTrkPaths")
        #if not self.m2MatchesDoubleMuTrkPaths_branch and "m2MatchesDoubleMuTrkPaths" not in self.complained:
        if not self.m2MatchesDoubleMuTrkPaths_branch and "m2MatchesDoubleMuTrkPaths":
            warnings.warn( "MuMuETauTree: Expected branch m2MatchesDoubleMuTrkPaths does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2MatchesDoubleMuTrkPaths")
        else:
            self.m2MatchesDoubleMuTrkPaths_branch.SetAddress(<void*>&self.m2MatchesDoubleMuTrkPaths_value)

        #print "making m2MatchesIsoMu24eta2p1"
        self.m2MatchesIsoMu24eta2p1_branch = the_tree.GetBranch("m2MatchesIsoMu24eta2p1")
        #if not self.m2MatchesIsoMu24eta2p1_branch and "m2MatchesIsoMu24eta2p1" not in self.complained:
        if not self.m2MatchesIsoMu24eta2p1_branch and "m2MatchesIsoMu24eta2p1":
            warnings.warn( "MuMuETauTree: Expected branch m2MatchesIsoMu24eta2p1 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2MatchesIsoMu24eta2p1")
        else:
            self.m2MatchesIsoMu24eta2p1_branch.SetAddress(<void*>&self.m2MatchesIsoMu24eta2p1_value)

        #print "making m2MatchesIsoMuGroup"
        self.m2MatchesIsoMuGroup_branch = the_tree.GetBranch("m2MatchesIsoMuGroup")
        #if not self.m2MatchesIsoMuGroup_branch and "m2MatchesIsoMuGroup" not in self.complained:
        if not self.m2MatchesIsoMuGroup_branch and "m2MatchesIsoMuGroup":
            warnings.warn( "MuMuETauTree: Expected branch m2MatchesIsoMuGroup does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2MatchesIsoMuGroup")
        else:
            self.m2MatchesIsoMuGroup_branch.SetAddress(<void*>&self.m2MatchesIsoMuGroup_value)

        #print "making m2MatchesMu17Ele8IsoPath"
        self.m2MatchesMu17Ele8IsoPath_branch = the_tree.GetBranch("m2MatchesMu17Ele8IsoPath")
        #if not self.m2MatchesMu17Ele8IsoPath_branch and "m2MatchesMu17Ele8IsoPath" not in self.complained:
        if not self.m2MatchesMu17Ele8IsoPath_branch and "m2MatchesMu17Ele8IsoPath":
            warnings.warn( "MuMuETauTree: Expected branch m2MatchesMu17Ele8IsoPath does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2MatchesMu17Ele8IsoPath")
        else:
            self.m2MatchesMu17Ele8IsoPath_branch.SetAddress(<void*>&self.m2MatchesMu17Ele8IsoPath_value)

        #print "making m2MatchesMu17Ele8Path"
        self.m2MatchesMu17Ele8Path_branch = the_tree.GetBranch("m2MatchesMu17Ele8Path")
        #if not self.m2MatchesMu17Ele8Path_branch and "m2MatchesMu17Ele8Path" not in self.complained:
        if not self.m2MatchesMu17Ele8Path_branch and "m2MatchesMu17Ele8Path":
            warnings.warn( "MuMuETauTree: Expected branch m2MatchesMu17Ele8Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2MatchesMu17Ele8Path")
        else:
            self.m2MatchesMu17Ele8Path_branch.SetAddress(<void*>&self.m2MatchesMu17Ele8Path_value)

        #print "making m2MatchesMu17Mu8Path"
        self.m2MatchesMu17Mu8Path_branch = the_tree.GetBranch("m2MatchesMu17Mu8Path")
        #if not self.m2MatchesMu17Mu8Path_branch and "m2MatchesMu17Mu8Path" not in self.complained:
        if not self.m2MatchesMu17Mu8Path_branch and "m2MatchesMu17Mu8Path":
            warnings.warn( "MuMuETauTree: Expected branch m2MatchesMu17Mu8Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2MatchesMu17Mu8Path")
        else:
            self.m2MatchesMu17Mu8Path_branch.SetAddress(<void*>&self.m2MatchesMu17Mu8Path_value)

        #print "making m2MatchesMu17TrkMu8Path"
        self.m2MatchesMu17TrkMu8Path_branch = the_tree.GetBranch("m2MatchesMu17TrkMu8Path")
        #if not self.m2MatchesMu17TrkMu8Path_branch and "m2MatchesMu17TrkMu8Path" not in self.complained:
        if not self.m2MatchesMu17TrkMu8Path_branch and "m2MatchesMu17TrkMu8Path":
            warnings.warn( "MuMuETauTree: Expected branch m2MatchesMu17TrkMu8Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2MatchesMu17TrkMu8Path")
        else:
            self.m2MatchesMu17TrkMu8Path_branch.SetAddress(<void*>&self.m2MatchesMu17TrkMu8Path_value)

        #print "making m2MatchesMu8Ele17IsoPath"
        self.m2MatchesMu8Ele17IsoPath_branch = the_tree.GetBranch("m2MatchesMu8Ele17IsoPath")
        #if not self.m2MatchesMu8Ele17IsoPath_branch and "m2MatchesMu8Ele17IsoPath" not in self.complained:
        if not self.m2MatchesMu8Ele17IsoPath_branch and "m2MatchesMu8Ele17IsoPath":
            warnings.warn( "MuMuETauTree: Expected branch m2MatchesMu8Ele17IsoPath does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2MatchesMu8Ele17IsoPath")
        else:
            self.m2MatchesMu8Ele17IsoPath_branch.SetAddress(<void*>&self.m2MatchesMu8Ele17IsoPath_value)

        #print "making m2MatchesMu8Ele17Path"
        self.m2MatchesMu8Ele17Path_branch = the_tree.GetBranch("m2MatchesMu8Ele17Path")
        #if not self.m2MatchesMu8Ele17Path_branch and "m2MatchesMu8Ele17Path" not in self.complained:
        if not self.m2MatchesMu8Ele17Path_branch and "m2MatchesMu8Ele17Path":
            warnings.warn( "MuMuETauTree: Expected branch m2MatchesMu8Ele17Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2MatchesMu8Ele17Path")
        else:
            self.m2MatchesMu8Ele17Path_branch.SetAddress(<void*>&self.m2MatchesMu8Ele17Path_value)

        #print "making m2MtToMET"
        self.m2MtToMET_branch = the_tree.GetBranch("m2MtToMET")
        #if not self.m2MtToMET_branch and "m2MtToMET" not in self.complained:
        if not self.m2MtToMET_branch and "m2MtToMET":
            warnings.warn( "MuMuETauTree: Expected branch m2MtToMET does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2MtToMET")
        else:
            self.m2MtToMET_branch.SetAddress(<void*>&self.m2MtToMET_value)

        #print "making m2MtToMVAMET"
        self.m2MtToMVAMET_branch = the_tree.GetBranch("m2MtToMVAMET")
        #if not self.m2MtToMVAMET_branch and "m2MtToMVAMET" not in self.complained:
        if not self.m2MtToMVAMET_branch and "m2MtToMVAMET":
            warnings.warn( "MuMuETauTree: Expected branch m2MtToMVAMET does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2MtToMVAMET")
        else:
            self.m2MtToMVAMET_branch.SetAddress(<void*>&self.m2MtToMVAMET_value)

        #print "making m2MtToPFMET"
        self.m2MtToPFMET_branch = the_tree.GetBranch("m2MtToPFMET")
        #if not self.m2MtToPFMET_branch and "m2MtToPFMET" not in self.complained:
        if not self.m2MtToPFMET_branch and "m2MtToPFMET":
            warnings.warn( "MuMuETauTree: Expected branch m2MtToPFMET does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2MtToPFMET")
        else:
            self.m2MtToPFMET_branch.SetAddress(<void*>&self.m2MtToPFMET_value)

        #print "making m2MtToPfMet_Ty1"
        self.m2MtToPfMet_Ty1_branch = the_tree.GetBranch("m2MtToPfMet_Ty1")
        #if not self.m2MtToPfMet_Ty1_branch and "m2MtToPfMet_Ty1" not in self.complained:
        if not self.m2MtToPfMet_Ty1_branch and "m2MtToPfMet_Ty1":
            warnings.warn( "MuMuETauTree: Expected branch m2MtToPfMet_Ty1 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2MtToPfMet_Ty1")
        else:
            self.m2MtToPfMet_Ty1_branch.SetAddress(<void*>&self.m2MtToPfMet_Ty1_value)

        #print "making m2MtToPfMet_jes"
        self.m2MtToPfMet_jes_branch = the_tree.GetBranch("m2MtToPfMet_jes")
        #if not self.m2MtToPfMet_jes_branch and "m2MtToPfMet_jes" not in self.complained:
        if not self.m2MtToPfMet_jes_branch and "m2MtToPfMet_jes":
            warnings.warn( "MuMuETauTree: Expected branch m2MtToPfMet_jes does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2MtToPfMet_jes")
        else:
            self.m2MtToPfMet_jes_branch.SetAddress(<void*>&self.m2MtToPfMet_jes_value)

        #print "making m2MtToPfMet_mes"
        self.m2MtToPfMet_mes_branch = the_tree.GetBranch("m2MtToPfMet_mes")
        #if not self.m2MtToPfMet_mes_branch and "m2MtToPfMet_mes" not in self.complained:
        if not self.m2MtToPfMet_mes_branch and "m2MtToPfMet_mes":
            warnings.warn( "MuMuETauTree: Expected branch m2MtToPfMet_mes does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2MtToPfMet_mes")
        else:
            self.m2MtToPfMet_mes_branch.SetAddress(<void*>&self.m2MtToPfMet_mes_value)

        #print "making m2MtToPfMet_tes"
        self.m2MtToPfMet_tes_branch = the_tree.GetBranch("m2MtToPfMet_tes")
        #if not self.m2MtToPfMet_tes_branch and "m2MtToPfMet_tes" not in self.complained:
        if not self.m2MtToPfMet_tes_branch and "m2MtToPfMet_tes":
            warnings.warn( "MuMuETauTree: Expected branch m2MtToPfMet_tes does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2MtToPfMet_tes")
        else:
            self.m2MtToPfMet_tes_branch.SetAddress(<void*>&self.m2MtToPfMet_tes_value)

        #print "making m2MtToPfMet_ues"
        self.m2MtToPfMet_ues_branch = the_tree.GetBranch("m2MtToPfMet_ues")
        #if not self.m2MtToPfMet_ues_branch and "m2MtToPfMet_ues" not in self.complained:
        if not self.m2MtToPfMet_ues_branch and "m2MtToPfMet_ues":
            warnings.warn( "MuMuETauTree: Expected branch m2MtToPfMet_ues does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2MtToPfMet_ues")
        else:
            self.m2MtToPfMet_ues_branch.SetAddress(<void*>&self.m2MtToPfMet_ues_value)

        #print "making m2Mu17Ele8dZFilter"
        self.m2Mu17Ele8dZFilter_branch = the_tree.GetBranch("m2Mu17Ele8dZFilter")
        #if not self.m2Mu17Ele8dZFilter_branch and "m2Mu17Ele8dZFilter" not in self.complained:
        if not self.m2Mu17Ele8dZFilter_branch and "m2Mu17Ele8dZFilter":
            warnings.warn( "MuMuETauTree: Expected branch m2Mu17Ele8dZFilter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2Mu17Ele8dZFilter")
        else:
            self.m2Mu17Ele8dZFilter_branch.SetAddress(<void*>&self.m2Mu17Ele8dZFilter_value)

        #print "making m2MuonHits"
        self.m2MuonHits_branch = the_tree.GetBranch("m2MuonHits")
        #if not self.m2MuonHits_branch and "m2MuonHits" not in self.complained:
        if not self.m2MuonHits_branch and "m2MuonHits":
            warnings.warn( "MuMuETauTree: Expected branch m2MuonHits does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2MuonHits")
        else:
            self.m2MuonHits_branch.SetAddress(<void*>&self.m2MuonHits_value)

        #print "making m2NormTrkChi2"
        self.m2NormTrkChi2_branch = the_tree.GetBranch("m2NormTrkChi2")
        #if not self.m2NormTrkChi2_branch and "m2NormTrkChi2" not in self.complained:
        if not self.m2NormTrkChi2_branch and "m2NormTrkChi2":
            warnings.warn( "MuMuETauTree: Expected branch m2NormTrkChi2 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2NormTrkChi2")
        else:
            self.m2NormTrkChi2_branch.SetAddress(<void*>&self.m2NormTrkChi2_value)

        #print "making m2PFChargedIso"
        self.m2PFChargedIso_branch = the_tree.GetBranch("m2PFChargedIso")
        #if not self.m2PFChargedIso_branch and "m2PFChargedIso" not in self.complained:
        if not self.m2PFChargedIso_branch and "m2PFChargedIso":
            warnings.warn( "MuMuETauTree: Expected branch m2PFChargedIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2PFChargedIso")
        else:
            self.m2PFChargedIso_branch.SetAddress(<void*>&self.m2PFChargedIso_value)

        #print "making m2PFIDTight"
        self.m2PFIDTight_branch = the_tree.GetBranch("m2PFIDTight")
        #if not self.m2PFIDTight_branch and "m2PFIDTight" not in self.complained:
        if not self.m2PFIDTight_branch and "m2PFIDTight":
            warnings.warn( "MuMuETauTree: Expected branch m2PFIDTight does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2PFIDTight")
        else:
            self.m2PFIDTight_branch.SetAddress(<void*>&self.m2PFIDTight_value)

        #print "making m2PFNeutralIso"
        self.m2PFNeutralIso_branch = the_tree.GetBranch("m2PFNeutralIso")
        #if not self.m2PFNeutralIso_branch and "m2PFNeutralIso" not in self.complained:
        if not self.m2PFNeutralIso_branch and "m2PFNeutralIso":
            warnings.warn( "MuMuETauTree: Expected branch m2PFNeutralIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2PFNeutralIso")
        else:
            self.m2PFNeutralIso_branch.SetAddress(<void*>&self.m2PFNeutralIso_value)

        #print "making m2PFPUChargedIso"
        self.m2PFPUChargedIso_branch = the_tree.GetBranch("m2PFPUChargedIso")
        #if not self.m2PFPUChargedIso_branch and "m2PFPUChargedIso" not in self.complained:
        if not self.m2PFPUChargedIso_branch and "m2PFPUChargedIso":
            warnings.warn( "MuMuETauTree: Expected branch m2PFPUChargedIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2PFPUChargedIso")
        else:
            self.m2PFPUChargedIso_branch.SetAddress(<void*>&self.m2PFPUChargedIso_value)

        #print "making m2PFPhotonIso"
        self.m2PFPhotonIso_branch = the_tree.GetBranch("m2PFPhotonIso")
        #if not self.m2PFPhotonIso_branch and "m2PFPhotonIso" not in self.complained:
        if not self.m2PFPhotonIso_branch and "m2PFPhotonIso":
            warnings.warn( "MuMuETauTree: Expected branch m2PFPhotonIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2PFPhotonIso")
        else:
            self.m2PFPhotonIso_branch.SetAddress(<void*>&self.m2PFPhotonIso_value)

        #print "making m2PVDXY"
        self.m2PVDXY_branch = the_tree.GetBranch("m2PVDXY")
        #if not self.m2PVDXY_branch and "m2PVDXY" not in self.complained:
        if not self.m2PVDXY_branch and "m2PVDXY":
            warnings.warn( "MuMuETauTree: Expected branch m2PVDXY does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2PVDXY")
        else:
            self.m2PVDXY_branch.SetAddress(<void*>&self.m2PVDXY_value)

        #print "making m2PVDZ"
        self.m2PVDZ_branch = the_tree.GetBranch("m2PVDZ")
        #if not self.m2PVDZ_branch and "m2PVDZ" not in self.complained:
        if not self.m2PVDZ_branch and "m2PVDZ":
            warnings.warn( "MuMuETauTree: Expected branch m2PVDZ does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2PVDZ")
        else:
            self.m2PVDZ_branch.SetAddress(<void*>&self.m2PVDZ_value)

        #print "making m2Phi"
        self.m2Phi_branch = the_tree.GetBranch("m2Phi")
        #if not self.m2Phi_branch and "m2Phi" not in self.complained:
        if not self.m2Phi_branch and "m2Phi":
            warnings.warn( "MuMuETauTree: Expected branch m2Phi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2Phi")
        else:
            self.m2Phi_branch.SetAddress(<void*>&self.m2Phi_value)

        #print "making m2PhiRochCor2011A"
        self.m2PhiRochCor2011A_branch = the_tree.GetBranch("m2PhiRochCor2011A")
        #if not self.m2PhiRochCor2011A_branch and "m2PhiRochCor2011A" not in self.complained:
        if not self.m2PhiRochCor2011A_branch and "m2PhiRochCor2011A":
            warnings.warn( "MuMuETauTree: Expected branch m2PhiRochCor2011A does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2PhiRochCor2011A")
        else:
            self.m2PhiRochCor2011A_branch.SetAddress(<void*>&self.m2PhiRochCor2011A_value)

        #print "making m2PhiRochCor2011B"
        self.m2PhiRochCor2011B_branch = the_tree.GetBranch("m2PhiRochCor2011B")
        #if not self.m2PhiRochCor2011B_branch and "m2PhiRochCor2011B" not in self.complained:
        if not self.m2PhiRochCor2011B_branch and "m2PhiRochCor2011B":
            warnings.warn( "MuMuETauTree: Expected branch m2PhiRochCor2011B does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2PhiRochCor2011B")
        else:
            self.m2PhiRochCor2011B_branch.SetAddress(<void*>&self.m2PhiRochCor2011B_value)

        #print "making m2PhiRochCor2012"
        self.m2PhiRochCor2012_branch = the_tree.GetBranch("m2PhiRochCor2012")
        #if not self.m2PhiRochCor2012_branch and "m2PhiRochCor2012" not in self.complained:
        if not self.m2PhiRochCor2012_branch and "m2PhiRochCor2012":
            warnings.warn( "MuMuETauTree: Expected branch m2PhiRochCor2012 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2PhiRochCor2012")
        else:
            self.m2PhiRochCor2012_branch.SetAddress(<void*>&self.m2PhiRochCor2012_value)

        #print "making m2PixHits"
        self.m2PixHits_branch = the_tree.GetBranch("m2PixHits")
        #if not self.m2PixHits_branch and "m2PixHits" not in self.complained:
        if not self.m2PixHits_branch and "m2PixHits":
            warnings.warn( "MuMuETauTree: Expected branch m2PixHits does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2PixHits")
        else:
            self.m2PixHits_branch.SetAddress(<void*>&self.m2PixHits_value)

        #print "making m2Pt"
        self.m2Pt_branch = the_tree.GetBranch("m2Pt")
        #if not self.m2Pt_branch and "m2Pt" not in self.complained:
        if not self.m2Pt_branch and "m2Pt":
            warnings.warn( "MuMuETauTree: Expected branch m2Pt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2Pt")
        else:
            self.m2Pt_branch.SetAddress(<void*>&self.m2Pt_value)

        #print "making m2PtRochCor2011A"
        self.m2PtRochCor2011A_branch = the_tree.GetBranch("m2PtRochCor2011A")
        #if not self.m2PtRochCor2011A_branch and "m2PtRochCor2011A" not in self.complained:
        if not self.m2PtRochCor2011A_branch and "m2PtRochCor2011A":
            warnings.warn( "MuMuETauTree: Expected branch m2PtRochCor2011A does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2PtRochCor2011A")
        else:
            self.m2PtRochCor2011A_branch.SetAddress(<void*>&self.m2PtRochCor2011A_value)

        #print "making m2PtRochCor2011B"
        self.m2PtRochCor2011B_branch = the_tree.GetBranch("m2PtRochCor2011B")
        #if not self.m2PtRochCor2011B_branch and "m2PtRochCor2011B" not in self.complained:
        if not self.m2PtRochCor2011B_branch and "m2PtRochCor2011B":
            warnings.warn( "MuMuETauTree: Expected branch m2PtRochCor2011B does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2PtRochCor2011B")
        else:
            self.m2PtRochCor2011B_branch.SetAddress(<void*>&self.m2PtRochCor2011B_value)

        #print "making m2PtRochCor2012"
        self.m2PtRochCor2012_branch = the_tree.GetBranch("m2PtRochCor2012")
        #if not self.m2PtRochCor2012_branch and "m2PtRochCor2012" not in self.complained:
        if not self.m2PtRochCor2012_branch and "m2PtRochCor2012":
            warnings.warn( "MuMuETauTree: Expected branch m2PtRochCor2012 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2PtRochCor2012")
        else:
            self.m2PtRochCor2012_branch.SetAddress(<void*>&self.m2PtRochCor2012_value)

        #print "making m2Rank"
        self.m2Rank_branch = the_tree.GetBranch("m2Rank")
        #if not self.m2Rank_branch and "m2Rank" not in self.complained:
        if not self.m2Rank_branch and "m2Rank":
            warnings.warn( "MuMuETauTree: Expected branch m2Rank does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2Rank")
        else:
            self.m2Rank_branch.SetAddress(<void*>&self.m2Rank_value)

        #print "making m2RelPFIsoDB"
        self.m2RelPFIsoDB_branch = the_tree.GetBranch("m2RelPFIsoDB")
        #if not self.m2RelPFIsoDB_branch and "m2RelPFIsoDB" not in self.complained:
        if not self.m2RelPFIsoDB_branch and "m2RelPFIsoDB":
            warnings.warn( "MuMuETauTree: Expected branch m2RelPFIsoDB does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2RelPFIsoDB")
        else:
            self.m2RelPFIsoDB_branch.SetAddress(<void*>&self.m2RelPFIsoDB_value)

        #print "making m2RelPFIsoRho"
        self.m2RelPFIsoRho_branch = the_tree.GetBranch("m2RelPFIsoRho")
        #if not self.m2RelPFIsoRho_branch and "m2RelPFIsoRho" not in self.complained:
        if not self.m2RelPFIsoRho_branch and "m2RelPFIsoRho":
            warnings.warn( "MuMuETauTree: Expected branch m2RelPFIsoRho does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2RelPFIsoRho")
        else:
            self.m2RelPFIsoRho_branch.SetAddress(<void*>&self.m2RelPFIsoRho_value)

        #print "making m2RelPFIsoRhoFSR"
        self.m2RelPFIsoRhoFSR_branch = the_tree.GetBranch("m2RelPFIsoRhoFSR")
        #if not self.m2RelPFIsoRhoFSR_branch and "m2RelPFIsoRhoFSR" not in self.complained:
        if not self.m2RelPFIsoRhoFSR_branch and "m2RelPFIsoRhoFSR":
            warnings.warn( "MuMuETauTree: Expected branch m2RelPFIsoRhoFSR does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2RelPFIsoRhoFSR")
        else:
            self.m2RelPFIsoRhoFSR_branch.SetAddress(<void*>&self.m2RelPFIsoRhoFSR_value)

        #print "making m2RhoHZG2011"
        self.m2RhoHZG2011_branch = the_tree.GetBranch("m2RhoHZG2011")
        #if not self.m2RhoHZG2011_branch and "m2RhoHZG2011" not in self.complained:
        if not self.m2RhoHZG2011_branch and "m2RhoHZG2011":
            warnings.warn( "MuMuETauTree: Expected branch m2RhoHZG2011 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2RhoHZG2011")
        else:
            self.m2RhoHZG2011_branch.SetAddress(<void*>&self.m2RhoHZG2011_value)

        #print "making m2RhoHZG2012"
        self.m2RhoHZG2012_branch = the_tree.GetBranch("m2RhoHZG2012")
        #if not self.m2RhoHZG2012_branch and "m2RhoHZG2012" not in self.complained:
        if not self.m2RhoHZG2012_branch and "m2RhoHZG2012":
            warnings.warn( "MuMuETauTree: Expected branch m2RhoHZG2012 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2RhoHZG2012")
        else:
            self.m2RhoHZG2012_branch.SetAddress(<void*>&self.m2RhoHZG2012_value)

        #print "making m2SingleMu13L3Filtered13"
        self.m2SingleMu13L3Filtered13_branch = the_tree.GetBranch("m2SingleMu13L3Filtered13")
        #if not self.m2SingleMu13L3Filtered13_branch and "m2SingleMu13L3Filtered13" not in self.complained:
        if not self.m2SingleMu13L3Filtered13_branch and "m2SingleMu13L3Filtered13":
            warnings.warn( "MuMuETauTree: Expected branch m2SingleMu13L3Filtered13 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2SingleMu13L3Filtered13")
        else:
            self.m2SingleMu13L3Filtered13_branch.SetAddress(<void*>&self.m2SingleMu13L3Filtered13_value)

        #print "making m2SingleMu13L3Filtered17"
        self.m2SingleMu13L3Filtered17_branch = the_tree.GetBranch("m2SingleMu13L3Filtered17")
        #if not self.m2SingleMu13L3Filtered17_branch and "m2SingleMu13L3Filtered17" not in self.complained:
        if not self.m2SingleMu13L3Filtered17_branch and "m2SingleMu13L3Filtered17":
            warnings.warn( "MuMuETauTree: Expected branch m2SingleMu13L3Filtered17 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2SingleMu13L3Filtered17")
        else:
            self.m2SingleMu13L3Filtered17_branch.SetAddress(<void*>&self.m2SingleMu13L3Filtered17_value)

        #print "making m2TkLayersWithMeasurement"
        self.m2TkLayersWithMeasurement_branch = the_tree.GetBranch("m2TkLayersWithMeasurement")
        #if not self.m2TkLayersWithMeasurement_branch and "m2TkLayersWithMeasurement" not in self.complained:
        if not self.m2TkLayersWithMeasurement_branch and "m2TkLayersWithMeasurement":
            warnings.warn( "MuMuETauTree: Expected branch m2TkLayersWithMeasurement does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2TkLayersWithMeasurement")
        else:
            self.m2TkLayersWithMeasurement_branch.SetAddress(<void*>&self.m2TkLayersWithMeasurement_value)

        #print "making m2ToMETDPhi"
        self.m2ToMETDPhi_branch = the_tree.GetBranch("m2ToMETDPhi")
        #if not self.m2ToMETDPhi_branch and "m2ToMETDPhi" not in self.complained:
        if not self.m2ToMETDPhi_branch and "m2ToMETDPhi":
            warnings.warn( "MuMuETauTree: Expected branch m2ToMETDPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2ToMETDPhi")
        else:
            self.m2ToMETDPhi_branch.SetAddress(<void*>&self.m2ToMETDPhi_value)

        #print "making m2TypeCode"
        self.m2TypeCode_branch = the_tree.GetBranch("m2TypeCode")
        #if not self.m2TypeCode_branch and "m2TypeCode" not in self.complained:
        if not self.m2TypeCode_branch and "m2TypeCode":
            warnings.warn( "MuMuETauTree: Expected branch m2TypeCode does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2TypeCode")
        else:
            self.m2TypeCode_branch.SetAddress(<void*>&self.m2TypeCode_value)

        #print "making m2VBTFID"
        self.m2VBTFID_branch = the_tree.GetBranch("m2VBTFID")
        #if not self.m2VBTFID_branch and "m2VBTFID" not in self.complained:
        if not self.m2VBTFID_branch and "m2VBTFID":
            warnings.warn( "MuMuETauTree: Expected branch m2VBTFID does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2VBTFID")
        else:
            self.m2VBTFID_branch.SetAddress(<void*>&self.m2VBTFID_value)

        #print "making m2VZ"
        self.m2VZ_branch = the_tree.GetBranch("m2VZ")
        #if not self.m2VZ_branch and "m2VZ" not in self.complained:
        if not self.m2VZ_branch and "m2VZ":
            warnings.warn( "MuMuETauTree: Expected branch m2VZ does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2VZ")
        else:
            self.m2VZ_branch.SetAddress(<void*>&self.m2VZ_value)

        #print "making m2WWID"
        self.m2WWID_branch = the_tree.GetBranch("m2WWID")
        #if not self.m2WWID_branch and "m2WWID" not in self.complained:
        if not self.m2WWID_branch and "m2WWID":
            warnings.warn( "MuMuETauTree: Expected branch m2WWID does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2WWID")
        else:
            self.m2WWID_branch.SetAddress(<void*>&self.m2WWID_value)

        #print "making m2_t_CosThetaStar"
        self.m2_t_CosThetaStar_branch = the_tree.GetBranch("m2_t_CosThetaStar")
        #if not self.m2_t_CosThetaStar_branch and "m2_t_CosThetaStar" not in self.complained:
        if not self.m2_t_CosThetaStar_branch and "m2_t_CosThetaStar":
            warnings.warn( "MuMuETauTree: Expected branch m2_t_CosThetaStar does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2_t_CosThetaStar")
        else:
            self.m2_t_CosThetaStar_branch.SetAddress(<void*>&self.m2_t_CosThetaStar_value)

        #print "making m2_t_DPhi"
        self.m2_t_DPhi_branch = the_tree.GetBranch("m2_t_DPhi")
        #if not self.m2_t_DPhi_branch and "m2_t_DPhi" not in self.complained:
        if not self.m2_t_DPhi_branch and "m2_t_DPhi":
            warnings.warn( "MuMuETauTree: Expected branch m2_t_DPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2_t_DPhi")
        else:
            self.m2_t_DPhi_branch.SetAddress(<void*>&self.m2_t_DPhi_value)

        #print "making m2_t_DR"
        self.m2_t_DR_branch = the_tree.GetBranch("m2_t_DR")
        #if not self.m2_t_DR_branch and "m2_t_DR" not in self.complained:
        if not self.m2_t_DR_branch and "m2_t_DR":
            warnings.warn( "MuMuETauTree: Expected branch m2_t_DR does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2_t_DR")
        else:
            self.m2_t_DR_branch.SetAddress(<void*>&self.m2_t_DR_value)

        #print "making m2_t_Eta"
        self.m2_t_Eta_branch = the_tree.GetBranch("m2_t_Eta")
        #if not self.m2_t_Eta_branch and "m2_t_Eta" not in self.complained:
        if not self.m2_t_Eta_branch and "m2_t_Eta":
            warnings.warn( "MuMuETauTree: Expected branch m2_t_Eta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2_t_Eta")
        else:
            self.m2_t_Eta_branch.SetAddress(<void*>&self.m2_t_Eta_value)

        #print "making m2_t_Mass"
        self.m2_t_Mass_branch = the_tree.GetBranch("m2_t_Mass")
        #if not self.m2_t_Mass_branch and "m2_t_Mass" not in self.complained:
        if not self.m2_t_Mass_branch and "m2_t_Mass":
            warnings.warn( "MuMuETauTree: Expected branch m2_t_Mass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2_t_Mass")
        else:
            self.m2_t_Mass_branch.SetAddress(<void*>&self.m2_t_Mass_value)

        #print "making m2_t_MassFsr"
        self.m2_t_MassFsr_branch = the_tree.GetBranch("m2_t_MassFsr")
        #if not self.m2_t_MassFsr_branch and "m2_t_MassFsr" not in self.complained:
        if not self.m2_t_MassFsr_branch and "m2_t_MassFsr":
            warnings.warn( "MuMuETauTree: Expected branch m2_t_MassFsr does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2_t_MassFsr")
        else:
            self.m2_t_MassFsr_branch.SetAddress(<void*>&self.m2_t_MassFsr_value)

        #print "making m2_t_PZeta"
        self.m2_t_PZeta_branch = the_tree.GetBranch("m2_t_PZeta")
        #if not self.m2_t_PZeta_branch and "m2_t_PZeta" not in self.complained:
        if not self.m2_t_PZeta_branch and "m2_t_PZeta":
            warnings.warn( "MuMuETauTree: Expected branch m2_t_PZeta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2_t_PZeta")
        else:
            self.m2_t_PZeta_branch.SetAddress(<void*>&self.m2_t_PZeta_value)

        #print "making m2_t_PZetaVis"
        self.m2_t_PZetaVis_branch = the_tree.GetBranch("m2_t_PZetaVis")
        #if not self.m2_t_PZetaVis_branch and "m2_t_PZetaVis" not in self.complained:
        if not self.m2_t_PZetaVis_branch and "m2_t_PZetaVis":
            warnings.warn( "MuMuETauTree: Expected branch m2_t_PZetaVis does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2_t_PZetaVis")
        else:
            self.m2_t_PZetaVis_branch.SetAddress(<void*>&self.m2_t_PZetaVis_value)

        #print "making m2_t_Phi"
        self.m2_t_Phi_branch = the_tree.GetBranch("m2_t_Phi")
        #if not self.m2_t_Phi_branch and "m2_t_Phi" not in self.complained:
        if not self.m2_t_Phi_branch and "m2_t_Phi":
            warnings.warn( "MuMuETauTree: Expected branch m2_t_Phi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2_t_Phi")
        else:
            self.m2_t_Phi_branch.SetAddress(<void*>&self.m2_t_Phi_value)

        #print "making m2_t_Pt"
        self.m2_t_Pt_branch = the_tree.GetBranch("m2_t_Pt")
        #if not self.m2_t_Pt_branch and "m2_t_Pt" not in self.complained:
        if not self.m2_t_Pt_branch and "m2_t_Pt":
            warnings.warn( "MuMuETauTree: Expected branch m2_t_Pt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2_t_Pt")
        else:
            self.m2_t_Pt_branch.SetAddress(<void*>&self.m2_t_Pt_value)

        #print "making m2_t_PtFsr"
        self.m2_t_PtFsr_branch = the_tree.GetBranch("m2_t_PtFsr")
        #if not self.m2_t_PtFsr_branch and "m2_t_PtFsr" not in self.complained:
        if not self.m2_t_PtFsr_branch and "m2_t_PtFsr":
            warnings.warn( "MuMuETauTree: Expected branch m2_t_PtFsr does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2_t_PtFsr")
        else:
            self.m2_t_PtFsr_branch.SetAddress(<void*>&self.m2_t_PtFsr_value)

        #print "making m2_t_SS"
        self.m2_t_SS_branch = the_tree.GetBranch("m2_t_SS")
        #if not self.m2_t_SS_branch and "m2_t_SS" not in self.complained:
        if not self.m2_t_SS_branch and "m2_t_SS":
            warnings.warn( "MuMuETauTree: Expected branch m2_t_SS does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2_t_SS")
        else:
            self.m2_t_SS_branch.SetAddress(<void*>&self.m2_t_SS_value)

        #print "making m2_t_SVfitEta"
        self.m2_t_SVfitEta_branch = the_tree.GetBranch("m2_t_SVfitEta")
        #if not self.m2_t_SVfitEta_branch and "m2_t_SVfitEta" not in self.complained:
        if not self.m2_t_SVfitEta_branch and "m2_t_SVfitEta":
            warnings.warn( "MuMuETauTree: Expected branch m2_t_SVfitEta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2_t_SVfitEta")
        else:
            self.m2_t_SVfitEta_branch.SetAddress(<void*>&self.m2_t_SVfitEta_value)

        #print "making m2_t_SVfitMass"
        self.m2_t_SVfitMass_branch = the_tree.GetBranch("m2_t_SVfitMass")
        #if not self.m2_t_SVfitMass_branch and "m2_t_SVfitMass" not in self.complained:
        if not self.m2_t_SVfitMass_branch and "m2_t_SVfitMass":
            warnings.warn( "MuMuETauTree: Expected branch m2_t_SVfitMass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2_t_SVfitMass")
        else:
            self.m2_t_SVfitMass_branch.SetAddress(<void*>&self.m2_t_SVfitMass_value)

        #print "making m2_t_SVfitPhi"
        self.m2_t_SVfitPhi_branch = the_tree.GetBranch("m2_t_SVfitPhi")
        #if not self.m2_t_SVfitPhi_branch and "m2_t_SVfitPhi" not in self.complained:
        if not self.m2_t_SVfitPhi_branch and "m2_t_SVfitPhi":
            warnings.warn( "MuMuETauTree: Expected branch m2_t_SVfitPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2_t_SVfitPhi")
        else:
            self.m2_t_SVfitPhi_branch.SetAddress(<void*>&self.m2_t_SVfitPhi_value)

        #print "making m2_t_SVfitPt"
        self.m2_t_SVfitPt_branch = the_tree.GetBranch("m2_t_SVfitPt")
        #if not self.m2_t_SVfitPt_branch and "m2_t_SVfitPt" not in self.complained:
        if not self.m2_t_SVfitPt_branch and "m2_t_SVfitPt":
            warnings.warn( "MuMuETauTree: Expected branch m2_t_SVfitPt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2_t_SVfitPt")
        else:
            self.m2_t_SVfitPt_branch.SetAddress(<void*>&self.m2_t_SVfitPt_value)

        #print "making m2_t_ToMETDPhi_Ty1"
        self.m2_t_ToMETDPhi_Ty1_branch = the_tree.GetBranch("m2_t_ToMETDPhi_Ty1")
        #if not self.m2_t_ToMETDPhi_Ty1_branch and "m2_t_ToMETDPhi_Ty1" not in self.complained:
        if not self.m2_t_ToMETDPhi_Ty1_branch and "m2_t_ToMETDPhi_Ty1":
            warnings.warn( "MuMuETauTree: Expected branch m2_t_ToMETDPhi_Ty1 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2_t_ToMETDPhi_Ty1")
        else:
            self.m2_t_ToMETDPhi_Ty1_branch.SetAddress(<void*>&self.m2_t_ToMETDPhi_Ty1_value)

        #print "making m2_t_Zcompat"
        self.m2_t_Zcompat_branch = the_tree.GetBranch("m2_t_Zcompat")
        #if not self.m2_t_Zcompat_branch and "m2_t_Zcompat" not in self.complained:
        if not self.m2_t_Zcompat_branch and "m2_t_Zcompat":
            warnings.warn( "MuMuETauTree: Expected branch m2_t_Zcompat does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2_t_Zcompat")
        else:
            self.m2_t_Zcompat_branch.SetAddress(<void*>&self.m2_t_Zcompat_value)

        #print "making mu17ele8Group"
        self.mu17ele8Group_branch = the_tree.GetBranch("mu17ele8Group")
        #if not self.mu17ele8Group_branch and "mu17ele8Group" not in self.complained:
        if not self.mu17ele8Group_branch and "mu17ele8Group":
            warnings.warn( "MuMuETauTree: Expected branch mu17ele8Group does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mu17ele8Group")
        else:
            self.mu17ele8Group_branch.SetAddress(<void*>&self.mu17ele8Group_value)

        #print "making mu17ele8Pass"
        self.mu17ele8Pass_branch = the_tree.GetBranch("mu17ele8Pass")
        #if not self.mu17ele8Pass_branch and "mu17ele8Pass" not in self.complained:
        if not self.mu17ele8Pass_branch and "mu17ele8Pass":
            warnings.warn( "MuMuETauTree: Expected branch mu17ele8Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mu17ele8Pass")
        else:
            self.mu17ele8Pass_branch.SetAddress(<void*>&self.mu17ele8Pass_value)

        #print "making mu17ele8Prescale"
        self.mu17ele8Prescale_branch = the_tree.GetBranch("mu17ele8Prescale")
        #if not self.mu17ele8Prescale_branch and "mu17ele8Prescale" not in self.complained:
        if not self.mu17ele8Prescale_branch and "mu17ele8Prescale":
            warnings.warn( "MuMuETauTree: Expected branch mu17ele8Prescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mu17ele8Prescale")
        else:
            self.mu17ele8Prescale_branch.SetAddress(<void*>&self.mu17ele8Prescale_value)

        #print "making mu17ele8isoGroup"
        self.mu17ele8isoGroup_branch = the_tree.GetBranch("mu17ele8isoGroup")
        #if not self.mu17ele8isoGroup_branch and "mu17ele8isoGroup" not in self.complained:
        if not self.mu17ele8isoGroup_branch and "mu17ele8isoGroup":
            warnings.warn( "MuMuETauTree: Expected branch mu17ele8isoGroup does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mu17ele8isoGroup")
        else:
            self.mu17ele8isoGroup_branch.SetAddress(<void*>&self.mu17ele8isoGroup_value)

        #print "making mu17ele8isoPass"
        self.mu17ele8isoPass_branch = the_tree.GetBranch("mu17ele8isoPass")
        #if not self.mu17ele8isoPass_branch and "mu17ele8isoPass" not in self.complained:
        if not self.mu17ele8isoPass_branch and "mu17ele8isoPass":
            warnings.warn( "MuMuETauTree: Expected branch mu17ele8isoPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mu17ele8isoPass")
        else:
            self.mu17ele8isoPass_branch.SetAddress(<void*>&self.mu17ele8isoPass_value)

        #print "making mu17ele8isoPrescale"
        self.mu17ele8isoPrescale_branch = the_tree.GetBranch("mu17ele8isoPrescale")
        #if not self.mu17ele8isoPrescale_branch and "mu17ele8isoPrescale" not in self.complained:
        if not self.mu17ele8isoPrescale_branch and "mu17ele8isoPrescale":
            warnings.warn( "MuMuETauTree: Expected branch mu17ele8isoPrescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mu17ele8isoPrescale")
        else:
            self.mu17ele8isoPrescale_branch.SetAddress(<void*>&self.mu17ele8isoPrescale_value)

        #print "making mu17mu8Group"
        self.mu17mu8Group_branch = the_tree.GetBranch("mu17mu8Group")
        #if not self.mu17mu8Group_branch and "mu17mu8Group" not in self.complained:
        if not self.mu17mu8Group_branch and "mu17mu8Group":
            warnings.warn( "MuMuETauTree: Expected branch mu17mu8Group does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mu17mu8Group")
        else:
            self.mu17mu8Group_branch.SetAddress(<void*>&self.mu17mu8Group_value)

        #print "making mu17mu8Pass"
        self.mu17mu8Pass_branch = the_tree.GetBranch("mu17mu8Pass")
        #if not self.mu17mu8Pass_branch and "mu17mu8Pass" not in self.complained:
        if not self.mu17mu8Pass_branch and "mu17mu8Pass":
            warnings.warn( "MuMuETauTree: Expected branch mu17mu8Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mu17mu8Pass")
        else:
            self.mu17mu8Pass_branch.SetAddress(<void*>&self.mu17mu8Pass_value)

        #print "making mu17mu8Prescale"
        self.mu17mu8Prescale_branch = the_tree.GetBranch("mu17mu8Prescale")
        #if not self.mu17mu8Prescale_branch and "mu17mu8Prescale" not in self.complained:
        if not self.mu17mu8Prescale_branch and "mu17mu8Prescale":
            warnings.warn( "MuMuETauTree: Expected branch mu17mu8Prescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mu17mu8Prescale")
        else:
            self.mu17mu8Prescale_branch.SetAddress(<void*>&self.mu17mu8Prescale_value)

        #print "making mu8ele17Group"
        self.mu8ele17Group_branch = the_tree.GetBranch("mu8ele17Group")
        #if not self.mu8ele17Group_branch and "mu8ele17Group" not in self.complained:
        if not self.mu8ele17Group_branch and "mu8ele17Group":
            warnings.warn( "MuMuETauTree: Expected branch mu8ele17Group does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mu8ele17Group")
        else:
            self.mu8ele17Group_branch.SetAddress(<void*>&self.mu8ele17Group_value)

        #print "making mu8ele17Pass"
        self.mu8ele17Pass_branch = the_tree.GetBranch("mu8ele17Pass")
        #if not self.mu8ele17Pass_branch and "mu8ele17Pass" not in self.complained:
        if not self.mu8ele17Pass_branch and "mu8ele17Pass":
            warnings.warn( "MuMuETauTree: Expected branch mu8ele17Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mu8ele17Pass")
        else:
            self.mu8ele17Pass_branch.SetAddress(<void*>&self.mu8ele17Pass_value)

        #print "making mu8ele17Prescale"
        self.mu8ele17Prescale_branch = the_tree.GetBranch("mu8ele17Prescale")
        #if not self.mu8ele17Prescale_branch and "mu8ele17Prescale" not in self.complained:
        if not self.mu8ele17Prescale_branch and "mu8ele17Prescale":
            warnings.warn( "MuMuETauTree: Expected branch mu8ele17Prescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mu8ele17Prescale")
        else:
            self.mu8ele17Prescale_branch.SetAddress(<void*>&self.mu8ele17Prescale_value)

        #print "making mu8ele17isoGroup"
        self.mu8ele17isoGroup_branch = the_tree.GetBranch("mu8ele17isoGroup")
        #if not self.mu8ele17isoGroup_branch and "mu8ele17isoGroup" not in self.complained:
        if not self.mu8ele17isoGroup_branch and "mu8ele17isoGroup":
            warnings.warn( "MuMuETauTree: Expected branch mu8ele17isoGroup does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mu8ele17isoGroup")
        else:
            self.mu8ele17isoGroup_branch.SetAddress(<void*>&self.mu8ele17isoGroup_value)

        #print "making mu8ele17isoPass"
        self.mu8ele17isoPass_branch = the_tree.GetBranch("mu8ele17isoPass")
        #if not self.mu8ele17isoPass_branch and "mu8ele17isoPass" not in self.complained:
        if not self.mu8ele17isoPass_branch and "mu8ele17isoPass":
            warnings.warn( "MuMuETauTree: Expected branch mu8ele17isoPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mu8ele17isoPass")
        else:
            self.mu8ele17isoPass_branch.SetAddress(<void*>&self.mu8ele17isoPass_value)

        #print "making mu8ele17isoPrescale"
        self.mu8ele17isoPrescale_branch = the_tree.GetBranch("mu8ele17isoPrescale")
        #if not self.mu8ele17isoPrescale_branch and "mu8ele17isoPrescale" not in self.complained:
        if not self.mu8ele17isoPrescale_branch and "mu8ele17isoPrescale":
            warnings.warn( "MuMuETauTree: Expected branch mu8ele17isoPrescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mu8ele17isoPrescale")
        else:
            self.mu8ele17isoPrescale_branch.SetAddress(<void*>&self.mu8ele17isoPrescale_value)

        #print "making muGlbIsoVetoPt10"
        self.muGlbIsoVetoPt10_branch = the_tree.GetBranch("muGlbIsoVetoPt10")
        #if not self.muGlbIsoVetoPt10_branch and "muGlbIsoVetoPt10" not in self.complained:
        if not self.muGlbIsoVetoPt10_branch and "muGlbIsoVetoPt10":
            warnings.warn( "MuMuETauTree: Expected branch muGlbIsoVetoPt10 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("muGlbIsoVetoPt10")
        else:
            self.muGlbIsoVetoPt10_branch.SetAddress(<void*>&self.muGlbIsoVetoPt10_value)

        #print "making muTauGroup"
        self.muTauGroup_branch = the_tree.GetBranch("muTauGroup")
        #if not self.muTauGroup_branch and "muTauGroup" not in self.complained:
        if not self.muTauGroup_branch and "muTauGroup":
            warnings.warn( "MuMuETauTree: Expected branch muTauGroup does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("muTauGroup")
        else:
            self.muTauGroup_branch.SetAddress(<void*>&self.muTauGroup_value)

        #print "making muTauPass"
        self.muTauPass_branch = the_tree.GetBranch("muTauPass")
        #if not self.muTauPass_branch and "muTauPass" not in self.complained:
        if not self.muTauPass_branch and "muTauPass":
            warnings.warn( "MuMuETauTree: Expected branch muTauPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("muTauPass")
        else:
            self.muTauPass_branch.SetAddress(<void*>&self.muTauPass_value)

        #print "making muTauPrescale"
        self.muTauPrescale_branch = the_tree.GetBranch("muTauPrescale")
        #if not self.muTauPrescale_branch and "muTauPrescale" not in self.complained:
        if not self.muTauPrescale_branch and "muTauPrescale":
            warnings.warn( "MuMuETauTree: Expected branch muTauPrescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("muTauPrescale")
        else:
            self.muTauPrescale_branch.SetAddress(<void*>&self.muTauPrescale_value)

        #print "making muTauTestGroup"
        self.muTauTestGroup_branch = the_tree.GetBranch("muTauTestGroup")
        #if not self.muTauTestGroup_branch and "muTauTestGroup" not in self.complained:
        if not self.muTauTestGroup_branch and "muTauTestGroup":
            warnings.warn( "MuMuETauTree: Expected branch muTauTestGroup does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("muTauTestGroup")
        else:
            self.muTauTestGroup_branch.SetAddress(<void*>&self.muTauTestGroup_value)

        #print "making muTauTestPass"
        self.muTauTestPass_branch = the_tree.GetBranch("muTauTestPass")
        #if not self.muTauTestPass_branch and "muTauTestPass" not in self.complained:
        if not self.muTauTestPass_branch and "muTauTestPass":
            warnings.warn( "MuMuETauTree: Expected branch muTauTestPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("muTauTestPass")
        else:
            self.muTauTestPass_branch.SetAddress(<void*>&self.muTauTestPass_value)

        #print "making muTauTestPrescale"
        self.muTauTestPrescale_branch = the_tree.GetBranch("muTauTestPrescale")
        #if not self.muTauTestPrescale_branch and "muTauTestPrescale" not in self.complained:
        if not self.muTauTestPrescale_branch and "muTauTestPrescale":
            warnings.warn( "MuMuETauTree: Expected branch muTauTestPrescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("muTauTestPrescale")
        else:
            self.muTauTestPrescale_branch.SetAddress(<void*>&self.muTauTestPrescale_value)

        #print "making muTightCountZH"
        self.muTightCountZH_branch = the_tree.GetBranch("muTightCountZH")
        #if not self.muTightCountZH_branch and "muTightCountZH" not in self.complained:
        if not self.muTightCountZH_branch and "muTightCountZH":
            warnings.warn( "MuMuETauTree: Expected branch muTightCountZH does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("muTightCountZH")
        else:
            self.muTightCountZH_branch.SetAddress(<void*>&self.muTightCountZH_value)

        #print "making muVetoPt15IsoIdVtx"
        self.muVetoPt15IsoIdVtx_branch = the_tree.GetBranch("muVetoPt15IsoIdVtx")
        #if not self.muVetoPt15IsoIdVtx_branch and "muVetoPt15IsoIdVtx" not in self.complained:
        if not self.muVetoPt15IsoIdVtx_branch and "muVetoPt15IsoIdVtx":
            warnings.warn( "MuMuETauTree: Expected branch muVetoPt15IsoIdVtx does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("muVetoPt15IsoIdVtx")
        else:
            self.muVetoPt15IsoIdVtx_branch.SetAddress(<void*>&self.muVetoPt15IsoIdVtx_value)

        #print "making muVetoPt5"
        self.muVetoPt5_branch = the_tree.GetBranch("muVetoPt5")
        #if not self.muVetoPt5_branch and "muVetoPt5" not in self.complained:
        if not self.muVetoPt5_branch and "muVetoPt5":
            warnings.warn( "MuMuETauTree: Expected branch muVetoPt5 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("muVetoPt5")
        else:
            self.muVetoPt5_branch.SetAddress(<void*>&self.muVetoPt5_value)

        #print "making muVetoPt5IsoIdVtx"
        self.muVetoPt5IsoIdVtx_branch = the_tree.GetBranch("muVetoPt5IsoIdVtx")
        #if not self.muVetoPt5IsoIdVtx_branch and "muVetoPt5IsoIdVtx" not in self.complained:
        if not self.muVetoPt5IsoIdVtx_branch and "muVetoPt5IsoIdVtx":
            warnings.warn( "MuMuETauTree: Expected branch muVetoPt5IsoIdVtx does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("muVetoPt5IsoIdVtx")
        else:
            self.muVetoPt5IsoIdVtx_branch.SetAddress(<void*>&self.muVetoPt5IsoIdVtx_value)

        #print "making muVetoZH"
        self.muVetoZH_branch = the_tree.GetBranch("muVetoZH")
        #if not self.muVetoZH_branch and "muVetoZH" not in self.complained:
        if not self.muVetoZH_branch and "muVetoZH":
            warnings.warn( "MuMuETauTree: Expected branch muVetoZH does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("muVetoZH")
        else:
            self.muVetoZH_branch.SetAddress(<void*>&self.muVetoZH_value)

        #print "making mva_metEt"
        self.mva_metEt_branch = the_tree.GetBranch("mva_metEt")
        #if not self.mva_metEt_branch and "mva_metEt" not in self.complained:
        if not self.mva_metEt_branch and "mva_metEt":
            warnings.warn( "MuMuETauTree: Expected branch mva_metEt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mva_metEt")
        else:
            self.mva_metEt_branch.SetAddress(<void*>&self.mva_metEt_value)

        #print "making mva_metPhi"
        self.mva_metPhi_branch = the_tree.GetBranch("mva_metPhi")
        #if not self.mva_metPhi_branch and "mva_metPhi" not in self.complained:
        if not self.mva_metPhi_branch and "mva_metPhi":
            warnings.warn( "MuMuETauTree: Expected branch mva_metPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mva_metPhi")
        else:
            self.mva_metPhi_branch.SetAddress(<void*>&self.mva_metPhi_value)

        #print "making nTruePU"
        self.nTruePU_branch = the_tree.GetBranch("nTruePU")
        #if not self.nTruePU_branch and "nTruePU" not in self.complained:
        if not self.nTruePU_branch and "nTruePU":
            warnings.warn( "MuMuETauTree: Expected branch nTruePU does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("nTruePU")
        else:
            self.nTruePU_branch.SetAddress(<void*>&self.nTruePU_value)

        #print "making nvtx"
        self.nvtx_branch = the_tree.GetBranch("nvtx")
        #if not self.nvtx_branch and "nvtx" not in self.complained:
        if not self.nvtx_branch and "nvtx":
            warnings.warn( "MuMuETauTree: Expected branch nvtx does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("nvtx")
        else:
            self.nvtx_branch.SetAddress(<void*>&self.nvtx_value)

        #print "making pfMetEt"
        self.pfMetEt_branch = the_tree.GetBranch("pfMetEt")
        #if not self.pfMetEt_branch and "pfMetEt" not in self.complained:
        if not self.pfMetEt_branch and "pfMetEt":
            warnings.warn( "MuMuETauTree: Expected branch pfMetEt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pfMetEt")
        else:
            self.pfMetEt_branch.SetAddress(<void*>&self.pfMetEt_value)

        #print "making pfMetPhi"
        self.pfMetPhi_branch = the_tree.GetBranch("pfMetPhi")
        #if not self.pfMetPhi_branch and "pfMetPhi" not in self.complained:
        if not self.pfMetPhi_branch and "pfMetPhi":
            warnings.warn( "MuMuETauTree: Expected branch pfMetPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pfMetPhi")
        else:
            self.pfMetPhi_branch.SetAddress(<void*>&self.pfMetPhi_value)

        #print "making pfMet_jes_Et"
        self.pfMet_jes_Et_branch = the_tree.GetBranch("pfMet_jes_Et")
        #if not self.pfMet_jes_Et_branch and "pfMet_jes_Et" not in self.complained:
        if not self.pfMet_jes_Et_branch and "pfMet_jes_Et":
            warnings.warn( "MuMuETauTree: Expected branch pfMet_jes_Et does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pfMet_jes_Et")
        else:
            self.pfMet_jes_Et_branch.SetAddress(<void*>&self.pfMet_jes_Et_value)

        #print "making pfMet_jes_Phi"
        self.pfMet_jes_Phi_branch = the_tree.GetBranch("pfMet_jes_Phi")
        #if not self.pfMet_jes_Phi_branch and "pfMet_jes_Phi" not in self.complained:
        if not self.pfMet_jes_Phi_branch and "pfMet_jes_Phi":
            warnings.warn( "MuMuETauTree: Expected branch pfMet_jes_Phi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pfMet_jes_Phi")
        else:
            self.pfMet_jes_Phi_branch.SetAddress(<void*>&self.pfMet_jes_Phi_value)

        #print "making pfMet_mes_Et"
        self.pfMet_mes_Et_branch = the_tree.GetBranch("pfMet_mes_Et")
        #if not self.pfMet_mes_Et_branch and "pfMet_mes_Et" not in self.complained:
        if not self.pfMet_mes_Et_branch and "pfMet_mes_Et":
            warnings.warn( "MuMuETauTree: Expected branch pfMet_mes_Et does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pfMet_mes_Et")
        else:
            self.pfMet_mes_Et_branch.SetAddress(<void*>&self.pfMet_mes_Et_value)

        #print "making pfMet_mes_Phi"
        self.pfMet_mes_Phi_branch = the_tree.GetBranch("pfMet_mes_Phi")
        #if not self.pfMet_mes_Phi_branch and "pfMet_mes_Phi" not in self.complained:
        if not self.pfMet_mes_Phi_branch and "pfMet_mes_Phi":
            warnings.warn( "MuMuETauTree: Expected branch pfMet_mes_Phi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pfMet_mes_Phi")
        else:
            self.pfMet_mes_Phi_branch.SetAddress(<void*>&self.pfMet_mes_Phi_value)

        #print "making pfMet_tes_Et"
        self.pfMet_tes_Et_branch = the_tree.GetBranch("pfMet_tes_Et")
        #if not self.pfMet_tes_Et_branch and "pfMet_tes_Et" not in self.complained:
        if not self.pfMet_tes_Et_branch and "pfMet_tes_Et":
            warnings.warn( "MuMuETauTree: Expected branch pfMet_tes_Et does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pfMet_tes_Et")
        else:
            self.pfMet_tes_Et_branch.SetAddress(<void*>&self.pfMet_tes_Et_value)

        #print "making pfMet_tes_Phi"
        self.pfMet_tes_Phi_branch = the_tree.GetBranch("pfMet_tes_Phi")
        #if not self.pfMet_tes_Phi_branch and "pfMet_tes_Phi" not in self.complained:
        if not self.pfMet_tes_Phi_branch and "pfMet_tes_Phi":
            warnings.warn( "MuMuETauTree: Expected branch pfMet_tes_Phi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pfMet_tes_Phi")
        else:
            self.pfMet_tes_Phi_branch.SetAddress(<void*>&self.pfMet_tes_Phi_value)

        #print "making pfMet_ues_Et"
        self.pfMet_ues_Et_branch = the_tree.GetBranch("pfMet_ues_Et")
        #if not self.pfMet_ues_Et_branch and "pfMet_ues_Et" not in self.complained:
        if not self.pfMet_ues_Et_branch and "pfMet_ues_Et":
            warnings.warn( "MuMuETauTree: Expected branch pfMet_ues_Et does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pfMet_ues_Et")
        else:
            self.pfMet_ues_Et_branch.SetAddress(<void*>&self.pfMet_ues_Et_value)

        #print "making pfMet_ues_Phi"
        self.pfMet_ues_Phi_branch = the_tree.GetBranch("pfMet_ues_Phi")
        #if not self.pfMet_ues_Phi_branch and "pfMet_ues_Phi" not in self.complained:
        if not self.pfMet_ues_Phi_branch and "pfMet_ues_Phi":
            warnings.warn( "MuMuETauTree: Expected branch pfMet_ues_Phi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pfMet_ues_Phi")
        else:
            self.pfMet_ues_Phi_branch.SetAddress(<void*>&self.pfMet_ues_Phi_value)

        #print "making processID"
        self.processID_branch = the_tree.GetBranch("processID")
        #if not self.processID_branch and "processID" not in self.complained:
        if not self.processID_branch and "processID":
            warnings.warn( "MuMuETauTree: Expected branch processID does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("processID")
        else:
            self.processID_branch.SetAddress(<void*>&self.processID_value)

        #print "making pvChi2"
        self.pvChi2_branch = the_tree.GetBranch("pvChi2")
        #if not self.pvChi2_branch and "pvChi2" not in self.complained:
        if not self.pvChi2_branch and "pvChi2":
            warnings.warn( "MuMuETauTree: Expected branch pvChi2 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pvChi2")
        else:
            self.pvChi2_branch.SetAddress(<void*>&self.pvChi2_value)

        #print "making pvDX"
        self.pvDX_branch = the_tree.GetBranch("pvDX")
        #if not self.pvDX_branch and "pvDX" not in self.complained:
        if not self.pvDX_branch and "pvDX":
            warnings.warn( "MuMuETauTree: Expected branch pvDX does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pvDX")
        else:
            self.pvDX_branch.SetAddress(<void*>&self.pvDX_value)

        #print "making pvDY"
        self.pvDY_branch = the_tree.GetBranch("pvDY")
        #if not self.pvDY_branch and "pvDY" not in self.complained:
        if not self.pvDY_branch and "pvDY":
            warnings.warn( "MuMuETauTree: Expected branch pvDY does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pvDY")
        else:
            self.pvDY_branch.SetAddress(<void*>&self.pvDY_value)

        #print "making pvDZ"
        self.pvDZ_branch = the_tree.GetBranch("pvDZ")
        #if not self.pvDZ_branch and "pvDZ" not in self.complained:
        if not self.pvDZ_branch and "pvDZ":
            warnings.warn( "MuMuETauTree: Expected branch pvDZ does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pvDZ")
        else:
            self.pvDZ_branch.SetAddress(<void*>&self.pvDZ_value)

        #print "making pvIsFake"
        self.pvIsFake_branch = the_tree.GetBranch("pvIsFake")
        #if not self.pvIsFake_branch and "pvIsFake" not in self.complained:
        if not self.pvIsFake_branch and "pvIsFake":
            warnings.warn( "MuMuETauTree: Expected branch pvIsFake does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pvIsFake")
        else:
            self.pvIsFake_branch.SetAddress(<void*>&self.pvIsFake_value)

        #print "making pvIsValid"
        self.pvIsValid_branch = the_tree.GetBranch("pvIsValid")
        #if not self.pvIsValid_branch and "pvIsValid" not in self.complained:
        if not self.pvIsValid_branch and "pvIsValid":
            warnings.warn( "MuMuETauTree: Expected branch pvIsValid does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pvIsValid")
        else:
            self.pvIsValid_branch.SetAddress(<void*>&self.pvIsValid_value)

        #print "making pvNormChi2"
        self.pvNormChi2_branch = the_tree.GetBranch("pvNormChi2")
        #if not self.pvNormChi2_branch and "pvNormChi2" not in self.complained:
        if not self.pvNormChi2_branch and "pvNormChi2":
            warnings.warn( "MuMuETauTree: Expected branch pvNormChi2 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pvNormChi2")
        else:
            self.pvNormChi2_branch.SetAddress(<void*>&self.pvNormChi2_value)

        #print "making pvX"
        self.pvX_branch = the_tree.GetBranch("pvX")
        #if not self.pvX_branch and "pvX" not in self.complained:
        if not self.pvX_branch and "pvX":
            warnings.warn( "MuMuETauTree: Expected branch pvX does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pvX")
        else:
            self.pvX_branch.SetAddress(<void*>&self.pvX_value)

        #print "making pvY"
        self.pvY_branch = the_tree.GetBranch("pvY")
        #if not self.pvY_branch and "pvY" not in self.complained:
        if not self.pvY_branch and "pvY":
            warnings.warn( "MuMuETauTree: Expected branch pvY does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pvY")
        else:
            self.pvY_branch.SetAddress(<void*>&self.pvY_value)

        #print "making pvZ"
        self.pvZ_branch = the_tree.GetBranch("pvZ")
        #if not self.pvZ_branch and "pvZ" not in self.complained:
        if not self.pvZ_branch and "pvZ":
            warnings.warn( "MuMuETauTree: Expected branch pvZ does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pvZ")
        else:
            self.pvZ_branch.SetAddress(<void*>&self.pvZ_value)

        #print "making pvndof"
        self.pvndof_branch = the_tree.GetBranch("pvndof")
        #if not self.pvndof_branch and "pvndof" not in self.complained:
        if not self.pvndof_branch and "pvndof":
            warnings.warn( "MuMuETauTree: Expected branch pvndof does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pvndof")
        else:
            self.pvndof_branch.SetAddress(<void*>&self.pvndof_value)

        #print "making recoilDaught"
        self.recoilDaught_branch = the_tree.GetBranch("recoilDaught")
        #if not self.recoilDaught_branch and "recoilDaught" not in self.complained:
        if not self.recoilDaught_branch and "recoilDaught":
            warnings.warn( "MuMuETauTree: Expected branch recoilDaught does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("recoilDaught")
        else:
            self.recoilDaught_branch.SetAddress(<void*>&self.recoilDaught_value)

        #print "making recoilWithMet"
        self.recoilWithMet_branch = the_tree.GetBranch("recoilWithMet")
        #if not self.recoilWithMet_branch and "recoilWithMet" not in self.complained:
        if not self.recoilWithMet_branch and "recoilWithMet":
            warnings.warn( "MuMuETauTree: Expected branch recoilWithMet does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("recoilWithMet")
        else:
            self.recoilWithMet_branch.SetAddress(<void*>&self.recoilWithMet_value)

        #print "making rho"
        self.rho_branch = the_tree.GetBranch("rho")
        #if not self.rho_branch and "rho" not in self.complained:
        if not self.rho_branch and "rho":
            warnings.warn( "MuMuETauTree: Expected branch rho does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("rho")
        else:
            self.rho_branch.SetAddress(<void*>&self.rho_value)

        #print "making run"
        self.run_branch = the_tree.GetBranch("run")
        #if not self.run_branch and "run" not in self.complained:
        if not self.run_branch and "run":
            warnings.warn( "MuMuETauTree: Expected branch run does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("run")
        else:
            self.run_branch.SetAddress(<void*>&self.run_value)

        #print "making singleEGroup"
        self.singleEGroup_branch = the_tree.GetBranch("singleEGroup")
        #if not self.singleEGroup_branch and "singleEGroup" not in self.complained:
        if not self.singleEGroup_branch and "singleEGroup":
            warnings.warn( "MuMuETauTree: Expected branch singleEGroup does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleEGroup")
        else:
            self.singleEGroup_branch.SetAddress(<void*>&self.singleEGroup_value)

        #print "making singleEPFMTGroup"
        self.singleEPFMTGroup_branch = the_tree.GetBranch("singleEPFMTGroup")
        #if not self.singleEPFMTGroup_branch and "singleEPFMTGroup" not in self.complained:
        if not self.singleEPFMTGroup_branch and "singleEPFMTGroup":
            warnings.warn( "MuMuETauTree: Expected branch singleEPFMTGroup does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleEPFMTGroup")
        else:
            self.singleEPFMTGroup_branch.SetAddress(<void*>&self.singleEPFMTGroup_value)

        #print "making singleEPFMTPass"
        self.singleEPFMTPass_branch = the_tree.GetBranch("singleEPFMTPass")
        #if not self.singleEPFMTPass_branch and "singleEPFMTPass" not in self.complained:
        if not self.singleEPFMTPass_branch and "singleEPFMTPass":
            warnings.warn( "MuMuETauTree: Expected branch singleEPFMTPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleEPFMTPass")
        else:
            self.singleEPFMTPass_branch.SetAddress(<void*>&self.singleEPFMTPass_value)

        #print "making singleEPFMTPrescale"
        self.singleEPFMTPrescale_branch = the_tree.GetBranch("singleEPFMTPrescale")
        #if not self.singleEPFMTPrescale_branch and "singleEPFMTPrescale" not in self.complained:
        if not self.singleEPFMTPrescale_branch and "singleEPFMTPrescale":
            warnings.warn( "MuMuETauTree: Expected branch singleEPFMTPrescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleEPFMTPrescale")
        else:
            self.singleEPFMTPrescale_branch.SetAddress(<void*>&self.singleEPFMTPrescale_value)

        #print "making singleEPass"
        self.singleEPass_branch = the_tree.GetBranch("singleEPass")
        #if not self.singleEPass_branch and "singleEPass" not in self.complained:
        if not self.singleEPass_branch and "singleEPass":
            warnings.warn( "MuMuETauTree: Expected branch singleEPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleEPass")
        else:
            self.singleEPass_branch.SetAddress(<void*>&self.singleEPass_value)

        #print "making singleEPrescale"
        self.singleEPrescale_branch = the_tree.GetBranch("singleEPrescale")
        #if not self.singleEPrescale_branch and "singleEPrescale" not in self.complained:
        if not self.singleEPrescale_branch and "singleEPrescale":
            warnings.warn( "MuMuETauTree: Expected branch singleEPrescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleEPrescale")
        else:
            self.singleEPrescale_branch.SetAddress(<void*>&self.singleEPrescale_value)

        #print "making singleMuGroup"
        self.singleMuGroup_branch = the_tree.GetBranch("singleMuGroup")
        #if not self.singleMuGroup_branch and "singleMuGroup" not in self.complained:
        if not self.singleMuGroup_branch and "singleMuGroup":
            warnings.warn( "MuMuETauTree: Expected branch singleMuGroup does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleMuGroup")
        else:
            self.singleMuGroup_branch.SetAddress(<void*>&self.singleMuGroup_value)

        #print "making singleMuPass"
        self.singleMuPass_branch = the_tree.GetBranch("singleMuPass")
        #if not self.singleMuPass_branch and "singleMuPass" not in self.complained:
        if not self.singleMuPass_branch and "singleMuPass":
            warnings.warn( "MuMuETauTree: Expected branch singleMuPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleMuPass")
        else:
            self.singleMuPass_branch.SetAddress(<void*>&self.singleMuPass_value)

        #print "making singleMuPrescale"
        self.singleMuPrescale_branch = the_tree.GetBranch("singleMuPrescale")
        #if not self.singleMuPrescale_branch and "singleMuPrescale" not in self.complained:
        if not self.singleMuPrescale_branch and "singleMuPrescale":
            warnings.warn( "MuMuETauTree: Expected branch singleMuPrescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleMuPrescale")
        else:
            self.singleMuPrescale_branch.SetAddress(<void*>&self.singleMuPrescale_value)

        #print "making singlePhoGroup"
        self.singlePhoGroup_branch = the_tree.GetBranch("singlePhoGroup")
        #if not self.singlePhoGroup_branch and "singlePhoGroup" not in self.complained:
        if not self.singlePhoGroup_branch and "singlePhoGroup":
            warnings.warn( "MuMuETauTree: Expected branch singlePhoGroup does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singlePhoGroup")
        else:
            self.singlePhoGroup_branch.SetAddress(<void*>&self.singlePhoGroup_value)

        #print "making singlePhoPass"
        self.singlePhoPass_branch = the_tree.GetBranch("singlePhoPass")
        #if not self.singlePhoPass_branch and "singlePhoPass" not in self.complained:
        if not self.singlePhoPass_branch and "singlePhoPass":
            warnings.warn( "MuMuETauTree: Expected branch singlePhoPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singlePhoPass")
        else:
            self.singlePhoPass_branch.SetAddress(<void*>&self.singlePhoPass_value)

        #print "making singlePhoPrescale"
        self.singlePhoPrescale_branch = the_tree.GetBranch("singlePhoPrescale")
        #if not self.singlePhoPrescale_branch and "singlePhoPrescale" not in self.complained:
        if not self.singlePhoPrescale_branch and "singlePhoPrescale":
            warnings.warn( "MuMuETauTree: Expected branch singlePhoPrescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singlePhoPrescale")
        else:
            self.singlePhoPrescale_branch.SetAddress(<void*>&self.singlePhoPrescale_value)

        #print "making tAbsEta"
        self.tAbsEta_branch = the_tree.GetBranch("tAbsEta")
        #if not self.tAbsEta_branch and "tAbsEta" not in self.complained:
        if not self.tAbsEta_branch and "tAbsEta":
            warnings.warn( "MuMuETauTree: Expected branch tAbsEta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tAbsEta")
        else:
            self.tAbsEta_branch.SetAddress(<void*>&self.tAbsEta_value)

        #print "making tAntiElectronLoose"
        self.tAntiElectronLoose_branch = the_tree.GetBranch("tAntiElectronLoose")
        #if not self.tAntiElectronLoose_branch and "tAntiElectronLoose" not in self.complained:
        if not self.tAntiElectronLoose_branch and "tAntiElectronLoose":
            warnings.warn( "MuMuETauTree: Expected branch tAntiElectronLoose does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tAntiElectronLoose")
        else:
            self.tAntiElectronLoose_branch.SetAddress(<void*>&self.tAntiElectronLoose_value)

        #print "making tAntiElectronMVA3Loose"
        self.tAntiElectronMVA3Loose_branch = the_tree.GetBranch("tAntiElectronMVA3Loose")
        #if not self.tAntiElectronMVA3Loose_branch and "tAntiElectronMVA3Loose" not in self.complained:
        if not self.tAntiElectronMVA3Loose_branch and "tAntiElectronMVA3Loose":
            warnings.warn( "MuMuETauTree: Expected branch tAntiElectronMVA3Loose does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tAntiElectronMVA3Loose")
        else:
            self.tAntiElectronMVA3Loose_branch.SetAddress(<void*>&self.tAntiElectronMVA3Loose_value)

        #print "making tAntiElectronMVA3Medium"
        self.tAntiElectronMVA3Medium_branch = the_tree.GetBranch("tAntiElectronMVA3Medium")
        #if not self.tAntiElectronMVA3Medium_branch and "tAntiElectronMVA3Medium" not in self.complained:
        if not self.tAntiElectronMVA3Medium_branch and "tAntiElectronMVA3Medium":
            warnings.warn( "MuMuETauTree: Expected branch tAntiElectronMVA3Medium does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tAntiElectronMVA3Medium")
        else:
            self.tAntiElectronMVA3Medium_branch.SetAddress(<void*>&self.tAntiElectronMVA3Medium_value)

        #print "making tAntiElectronMVA3Raw"
        self.tAntiElectronMVA3Raw_branch = the_tree.GetBranch("tAntiElectronMVA3Raw")
        #if not self.tAntiElectronMVA3Raw_branch and "tAntiElectronMVA3Raw" not in self.complained:
        if not self.tAntiElectronMVA3Raw_branch and "tAntiElectronMVA3Raw":
            warnings.warn( "MuMuETauTree: Expected branch tAntiElectronMVA3Raw does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tAntiElectronMVA3Raw")
        else:
            self.tAntiElectronMVA3Raw_branch.SetAddress(<void*>&self.tAntiElectronMVA3Raw_value)

        #print "making tAntiElectronMVA3Tight"
        self.tAntiElectronMVA3Tight_branch = the_tree.GetBranch("tAntiElectronMVA3Tight")
        #if not self.tAntiElectronMVA3Tight_branch and "tAntiElectronMVA3Tight" not in self.complained:
        if not self.tAntiElectronMVA3Tight_branch and "tAntiElectronMVA3Tight":
            warnings.warn( "MuMuETauTree: Expected branch tAntiElectronMVA3Tight does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tAntiElectronMVA3Tight")
        else:
            self.tAntiElectronMVA3Tight_branch.SetAddress(<void*>&self.tAntiElectronMVA3Tight_value)

        #print "making tAntiElectronMVA3VTight"
        self.tAntiElectronMVA3VTight_branch = the_tree.GetBranch("tAntiElectronMVA3VTight")
        #if not self.tAntiElectronMVA3VTight_branch and "tAntiElectronMVA3VTight" not in self.complained:
        if not self.tAntiElectronMVA3VTight_branch and "tAntiElectronMVA3VTight":
            warnings.warn( "MuMuETauTree: Expected branch tAntiElectronMVA3VTight does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tAntiElectronMVA3VTight")
        else:
            self.tAntiElectronMVA3VTight_branch.SetAddress(<void*>&self.tAntiElectronMVA3VTight_value)

        #print "making tAntiElectronMedium"
        self.tAntiElectronMedium_branch = the_tree.GetBranch("tAntiElectronMedium")
        #if not self.tAntiElectronMedium_branch and "tAntiElectronMedium" not in self.complained:
        if not self.tAntiElectronMedium_branch and "tAntiElectronMedium":
            warnings.warn( "MuMuETauTree: Expected branch tAntiElectronMedium does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tAntiElectronMedium")
        else:
            self.tAntiElectronMedium_branch.SetAddress(<void*>&self.tAntiElectronMedium_value)

        #print "making tAntiElectronTight"
        self.tAntiElectronTight_branch = the_tree.GetBranch("tAntiElectronTight")
        #if not self.tAntiElectronTight_branch and "tAntiElectronTight" not in self.complained:
        if not self.tAntiElectronTight_branch and "tAntiElectronTight":
            warnings.warn( "MuMuETauTree: Expected branch tAntiElectronTight does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tAntiElectronTight")
        else:
            self.tAntiElectronTight_branch.SetAddress(<void*>&self.tAntiElectronTight_value)

        #print "making tAntiMuonLoose"
        self.tAntiMuonLoose_branch = the_tree.GetBranch("tAntiMuonLoose")
        #if not self.tAntiMuonLoose_branch and "tAntiMuonLoose" not in self.complained:
        if not self.tAntiMuonLoose_branch and "tAntiMuonLoose":
            warnings.warn( "MuMuETauTree: Expected branch tAntiMuonLoose does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tAntiMuonLoose")
        else:
            self.tAntiMuonLoose_branch.SetAddress(<void*>&self.tAntiMuonLoose_value)

        #print "making tAntiMuonLoose2"
        self.tAntiMuonLoose2_branch = the_tree.GetBranch("tAntiMuonLoose2")
        #if not self.tAntiMuonLoose2_branch and "tAntiMuonLoose2" not in self.complained:
        if not self.tAntiMuonLoose2_branch and "tAntiMuonLoose2":
            warnings.warn( "MuMuETauTree: Expected branch tAntiMuonLoose2 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tAntiMuonLoose2")
        else:
            self.tAntiMuonLoose2_branch.SetAddress(<void*>&self.tAntiMuonLoose2_value)

        #print "making tAntiMuonMedium"
        self.tAntiMuonMedium_branch = the_tree.GetBranch("tAntiMuonMedium")
        #if not self.tAntiMuonMedium_branch and "tAntiMuonMedium" not in self.complained:
        if not self.tAntiMuonMedium_branch and "tAntiMuonMedium":
            warnings.warn( "MuMuETauTree: Expected branch tAntiMuonMedium does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tAntiMuonMedium")
        else:
            self.tAntiMuonMedium_branch.SetAddress(<void*>&self.tAntiMuonMedium_value)

        #print "making tAntiMuonMedium2"
        self.tAntiMuonMedium2_branch = the_tree.GetBranch("tAntiMuonMedium2")
        #if not self.tAntiMuonMedium2_branch and "tAntiMuonMedium2" not in self.complained:
        if not self.tAntiMuonMedium2_branch and "tAntiMuonMedium2":
            warnings.warn( "MuMuETauTree: Expected branch tAntiMuonMedium2 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tAntiMuonMedium2")
        else:
            self.tAntiMuonMedium2_branch.SetAddress(<void*>&self.tAntiMuonMedium2_value)

        #print "making tAntiMuonTight"
        self.tAntiMuonTight_branch = the_tree.GetBranch("tAntiMuonTight")
        #if not self.tAntiMuonTight_branch and "tAntiMuonTight" not in self.complained:
        if not self.tAntiMuonTight_branch and "tAntiMuonTight":
            warnings.warn( "MuMuETauTree: Expected branch tAntiMuonTight does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tAntiMuonTight")
        else:
            self.tAntiMuonTight_branch.SetAddress(<void*>&self.tAntiMuonTight_value)

        #print "making tAntiMuonTight2"
        self.tAntiMuonTight2_branch = the_tree.GetBranch("tAntiMuonTight2")
        #if not self.tAntiMuonTight2_branch and "tAntiMuonTight2" not in self.complained:
        if not self.tAntiMuonTight2_branch and "tAntiMuonTight2":
            warnings.warn( "MuMuETauTree: Expected branch tAntiMuonTight2 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tAntiMuonTight2")
        else:
            self.tAntiMuonTight2_branch.SetAddress(<void*>&self.tAntiMuonTight2_value)

        #print "making tCharge"
        self.tCharge_branch = the_tree.GetBranch("tCharge")
        #if not self.tCharge_branch and "tCharge" not in self.complained:
        if not self.tCharge_branch and "tCharge":
            warnings.warn( "MuMuETauTree: Expected branch tCharge does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tCharge")
        else:
            self.tCharge_branch.SetAddress(<void*>&self.tCharge_value)

        #print "making tCiCTightElecOverlap"
        self.tCiCTightElecOverlap_branch = the_tree.GetBranch("tCiCTightElecOverlap")
        #if not self.tCiCTightElecOverlap_branch and "tCiCTightElecOverlap" not in self.complained:
        if not self.tCiCTightElecOverlap_branch and "tCiCTightElecOverlap":
            warnings.warn( "MuMuETauTree: Expected branch tCiCTightElecOverlap does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tCiCTightElecOverlap")
        else:
            self.tCiCTightElecOverlap_branch.SetAddress(<void*>&self.tCiCTightElecOverlap_value)

        #print "making tDZ"
        self.tDZ_branch = the_tree.GetBranch("tDZ")
        #if not self.tDZ_branch and "tDZ" not in self.complained:
        if not self.tDZ_branch and "tDZ":
            warnings.warn( "MuMuETauTree: Expected branch tDZ does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tDZ")
        else:
            self.tDZ_branch.SetAddress(<void*>&self.tDZ_value)

        #print "making tDecayFinding"
        self.tDecayFinding_branch = the_tree.GetBranch("tDecayFinding")
        #if not self.tDecayFinding_branch and "tDecayFinding" not in self.complained:
        if not self.tDecayFinding_branch and "tDecayFinding":
            warnings.warn( "MuMuETauTree: Expected branch tDecayFinding does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tDecayFinding")
        else:
            self.tDecayFinding_branch.SetAddress(<void*>&self.tDecayFinding_value)

        #print "making tDecayMode"
        self.tDecayMode_branch = the_tree.GetBranch("tDecayMode")
        #if not self.tDecayMode_branch and "tDecayMode" not in self.complained:
        if not self.tDecayMode_branch and "tDecayMode":
            warnings.warn( "MuMuETauTree: Expected branch tDecayMode does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tDecayMode")
        else:
            self.tDecayMode_branch.SetAddress(<void*>&self.tDecayMode_value)

        #print "making tElecOverlap"
        self.tElecOverlap_branch = the_tree.GetBranch("tElecOverlap")
        #if not self.tElecOverlap_branch and "tElecOverlap" not in self.complained:
        if not self.tElecOverlap_branch and "tElecOverlap":
            warnings.warn( "MuMuETauTree: Expected branch tElecOverlap does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tElecOverlap")
        else:
            self.tElecOverlap_branch.SetAddress(<void*>&self.tElecOverlap_value)

        #print "making tEta"
        self.tEta_branch = the_tree.GetBranch("tEta")
        #if not self.tEta_branch and "tEta" not in self.complained:
        if not self.tEta_branch and "tEta":
            warnings.warn( "MuMuETauTree: Expected branch tEta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tEta")
        else:
            self.tEta_branch.SetAddress(<void*>&self.tEta_value)

        #print "making tGenDecayMode"
        self.tGenDecayMode_branch = the_tree.GetBranch("tGenDecayMode")
        #if not self.tGenDecayMode_branch and "tGenDecayMode" not in self.complained:
        if not self.tGenDecayMode_branch and "tGenDecayMode":
            warnings.warn( "MuMuETauTree: Expected branch tGenDecayMode does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tGenDecayMode")
        else:
            self.tGenDecayMode_branch.SetAddress(<void*>&self.tGenDecayMode_value)

        #print "making tIP3DS"
        self.tIP3DS_branch = the_tree.GetBranch("tIP3DS")
        #if not self.tIP3DS_branch and "tIP3DS" not in self.complained:
        if not self.tIP3DS_branch and "tIP3DS":
            warnings.warn( "MuMuETauTree: Expected branch tIP3DS does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tIP3DS")
        else:
            self.tIP3DS_branch.SetAddress(<void*>&self.tIP3DS_value)

        #print "making tJetArea"
        self.tJetArea_branch = the_tree.GetBranch("tJetArea")
        #if not self.tJetArea_branch and "tJetArea" not in self.complained:
        if not self.tJetArea_branch and "tJetArea":
            warnings.warn( "MuMuETauTree: Expected branch tJetArea does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tJetArea")
        else:
            self.tJetArea_branch.SetAddress(<void*>&self.tJetArea_value)

        #print "making tJetBtag"
        self.tJetBtag_branch = the_tree.GetBranch("tJetBtag")
        #if not self.tJetBtag_branch and "tJetBtag" not in self.complained:
        if not self.tJetBtag_branch and "tJetBtag":
            warnings.warn( "MuMuETauTree: Expected branch tJetBtag does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tJetBtag")
        else:
            self.tJetBtag_branch.SetAddress(<void*>&self.tJetBtag_value)

        #print "making tJetCSVBtag"
        self.tJetCSVBtag_branch = the_tree.GetBranch("tJetCSVBtag")
        #if not self.tJetCSVBtag_branch and "tJetCSVBtag" not in self.complained:
        if not self.tJetCSVBtag_branch and "tJetCSVBtag":
            warnings.warn( "MuMuETauTree: Expected branch tJetCSVBtag does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tJetCSVBtag")
        else:
            self.tJetCSVBtag_branch.SetAddress(<void*>&self.tJetCSVBtag_value)

        #print "making tJetEtaEtaMoment"
        self.tJetEtaEtaMoment_branch = the_tree.GetBranch("tJetEtaEtaMoment")
        #if not self.tJetEtaEtaMoment_branch and "tJetEtaEtaMoment" not in self.complained:
        if not self.tJetEtaEtaMoment_branch and "tJetEtaEtaMoment":
            warnings.warn( "MuMuETauTree: Expected branch tJetEtaEtaMoment does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tJetEtaEtaMoment")
        else:
            self.tJetEtaEtaMoment_branch.SetAddress(<void*>&self.tJetEtaEtaMoment_value)

        #print "making tJetEtaPhiMoment"
        self.tJetEtaPhiMoment_branch = the_tree.GetBranch("tJetEtaPhiMoment")
        #if not self.tJetEtaPhiMoment_branch and "tJetEtaPhiMoment" not in self.complained:
        if not self.tJetEtaPhiMoment_branch and "tJetEtaPhiMoment":
            warnings.warn( "MuMuETauTree: Expected branch tJetEtaPhiMoment does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tJetEtaPhiMoment")
        else:
            self.tJetEtaPhiMoment_branch.SetAddress(<void*>&self.tJetEtaPhiMoment_value)

        #print "making tJetEtaPhiSpread"
        self.tJetEtaPhiSpread_branch = the_tree.GetBranch("tJetEtaPhiSpread")
        #if not self.tJetEtaPhiSpread_branch and "tJetEtaPhiSpread" not in self.complained:
        if not self.tJetEtaPhiSpread_branch and "tJetEtaPhiSpread":
            warnings.warn( "MuMuETauTree: Expected branch tJetEtaPhiSpread does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tJetEtaPhiSpread")
        else:
            self.tJetEtaPhiSpread_branch.SetAddress(<void*>&self.tJetEtaPhiSpread_value)

        #print "making tJetPartonFlavour"
        self.tJetPartonFlavour_branch = the_tree.GetBranch("tJetPartonFlavour")
        #if not self.tJetPartonFlavour_branch and "tJetPartonFlavour" not in self.complained:
        if not self.tJetPartonFlavour_branch and "tJetPartonFlavour":
            warnings.warn( "MuMuETauTree: Expected branch tJetPartonFlavour does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tJetPartonFlavour")
        else:
            self.tJetPartonFlavour_branch.SetAddress(<void*>&self.tJetPartonFlavour_value)

        #print "making tJetPhiPhiMoment"
        self.tJetPhiPhiMoment_branch = the_tree.GetBranch("tJetPhiPhiMoment")
        #if not self.tJetPhiPhiMoment_branch and "tJetPhiPhiMoment" not in self.complained:
        if not self.tJetPhiPhiMoment_branch and "tJetPhiPhiMoment":
            warnings.warn( "MuMuETauTree: Expected branch tJetPhiPhiMoment does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tJetPhiPhiMoment")
        else:
            self.tJetPhiPhiMoment_branch.SetAddress(<void*>&self.tJetPhiPhiMoment_value)

        #print "making tJetPt"
        self.tJetPt_branch = the_tree.GetBranch("tJetPt")
        #if not self.tJetPt_branch and "tJetPt" not in self.complained:
        if not self.tJetPt_branch and "tJetPt":
            warnings.warn( "MuMuETauTree: Expected branch tJetPt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tJetPt")
        else:
            self.tJetPt_branch.SetAddress(<void*>&self.tJetPt_value)

        #print "making tJetQGLikelihoodID"
        self.tJetQGLikelihoodID_branch = the_tree.GetBranch("tJetQGLikelihoodID")
        #if not self.tJetQGLikelihoodID_branch and "tJetQGLikelihoodID" not in self.complained:
        if not self.tJetQGLikelihoodID_branch and "tJetQGLikelihoodID":
            warnings.warn( "MuMuETauTree: Expected branch tJetQGLikelihoodID does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tJetQGLikelihoodID")
        else:
            self.tJetQGLikelihoodID_branch.SetAddress(<void*>&self.tJetQGLikelihoodID_value)

        #print "making tJetQGMVAID"
        self.tJetQGMVAID_branch = the_tree.GetBranch("tJetQGMVAID")
        #if not self.tJetQGMVAID_branch and "tJetQGMVAID" not in self.complained:
        if not self.tJetQGMVAID_branch and "tJetQGMVAID":
            warnings.warn( "MuMuETauTree: Expected branch tJetQGMVAID does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tJetQGMVAID")
        else:
            self.tJetQGMVAID_branch.SetAddress(<void*>&self.tJetQGMVAID_value)

        #print "making tJetaxis1"
        self.tJetaxis1_branch = the_tree.GetBranch("tJetaxis1")
        #if not self.tJetaxis1_branch and "tJetaxis1" not in self.complained:
        if not self.tJetaxis1_branch and "tJetaxis1":
            warnings.warn( "MuMuETauTree: Expected branch tJetaxis1 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tJetaxis1")
        else:
            self.tJetaxis1_branch.SetAddress(<void*>&self.tJetaxis1_value)

        #print "making tJetaxis2"
        self.tJetaxis2_branch = the_tree.GetBranch("tJetaxis2")
        #if not self.tJetaxis2_branch and "tJetaxis2" not in self.complained:
        if not self.tJetaxis2_branch and "tJetaxis2":
            warnings.warn( "MuMuETauTree: Expected branch tJetaxis2 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tJetaxis2")
        else:
            self.tJetaxis2_branch.SetAddress(<void*>&self.tJetaxis2_value)

        #print "making tJetmult"
        self.tJetmult_branch = the_tree.GetBranch("tJetmult")
        #if not self.tJetmult_branch and "tJetmult" not in self.complained:
        if not self.tJetmult_branch and "tJetmult":
            warnings.warn( "MuMuETauTree: Expected branch tJetmult does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tJetmult")
        else:
            self.tJetmult_branch.SetAddress(<void*>&self.tJetmult_value)

        #print "making tJetmultMLP"
        self.tJetmultMLP_branch = the_tree.GetBranch("tJetmultMLP")
        #if not self.tJetmultMLP_branch and "tJetmultMLP" not in self.complained:
        if not self.tJetmultMLP_branch and "tJetmultMLP":
            warnings.warn( "MuMuETauTree: Expected branch tJetmultMLP does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tJetmultMLP")
        else:
            self.tJetmultMLP_branch.SetAddress(<void*>&self.tJetmultMLP_value)

        #print "making tJetmultMLPQC"
        self.tJetmultMLPQC_branch = the_tree.GetBranch("tJetmultMLPQC")
        #if not self.tJetmultMLPQC_branch and "tJetmultMLPQC" not in self.complained:
        if not self.tJetmultMLPQC_branch and "tJetmultMLPQC":
            warnings.warn( "MuMuETauTree: Expected branch tJetmultMLPQC does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tJetmultMLPQC")
        else:
            self.tJetmultMLPQC_branch.SetAddress(<void*>&self.tJetmultMLPQC_value)

        #print "making tJetptD"
        self.tJetptD_branch = the_tree.GetBranch("tJetptD")
        #if not self.tJetptD_branch and "tJetptD" not in self.complained:
        if not self.tJetptD_branch and "tJetptD":
            warnings.warn( "MuMuETauTree: Expected branch tJetptD does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tJetptD")
        else:
            self.tJetptD_branch.SetAddress(<void*>&self.tJetptD_value)

        #print "making tLeadTrackPt"
        self.tLeadTrackPt_branch = the_tree.GetBranch("tLeadTrackPt")
        #if not self.tLeadTrackPt_branch and "tLeadTrackPt" not in self.complained:
        if not self.tLeadTrackPt_branch and "tLeadTrackPt":
            warnings.warn( "MuMuETauTree: Expected branch tLeadTrackPt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tLeadTrackPt")
        else:
            self.tLeadTrackPt_branch.SetAddress(<void*>&self.tLeadTrackPt_value)

        #print "making tLooseIso"
        self.tLooseIso_branch = the_tree.GetBranch("tLooseIso")
        #if not self.tLooseIso_branch and "tLooseIso" not in self.complained:
        if not self.tLooseIso_branch and "tLooseIso":
            warnings.warn( "MuMuETauTree: Expected branch tLooseIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tLooseIso")
        else:
            self.tLooseIso_branch.SetAddress(<void*>&self.tLooseIso_value)

        #print "making tLooseIso3Hits"
        self.tLooseIso3Hits_branch = the_tree.GetBranch("tLooseIso3Hits")
        #if not self.tLooseIso3Hits_branch and "tLooseIso3Hits" not in self.complained:
        if not self.tLooseIso3Hits_branch and "tLooseIso3Hits":
            warnings.warn( "MuMuETauTree: Expected branch tLooseIso3Hits does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tLooseIso3Hits")
        else:
            self.tLooseIso3Hits_branch.SetAddress(<void*>&self.tLooseIso3Hits_value)

        #print "making tLooseMVA2Iso"
        self.tLooseMVA2Iso_branch = the_tree.GetBranch("tLooseMVA2Iso")
        #if not self.tLooseMVA2Iso_branch and "tLooseMVA2Iso" not in self.complained:
        if not self.tLooseMVA2Iso_branch and "tLooseMVA2Iso":
            warnings.warn( "MuMuETauTree: Expected branch tLooseMVA2Iso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tLooseMVA2Iso")
        else:
            self.tLooseMVA2Iso_branch.SetAddress(<void*>&self.tLooseMVA2Iso_value)

        #print "making tLooseMVAIso"
        self.tLooseMVAIso_branch = the_tree.GetBranch("tLooseMVAIso")
        #if not self.tLooseMVAIso_branch and "tLooseMVAIso" not in self.complained:
        if not self.tLooseMVAIso_branch and "tLooseMVAIso":
            warnings.warn( "MuMuETauTree: Expected branch tLooseMVAIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tLooseMVAIso")
        else:
            self.tLooseMVAIso_branch.SetAddress(<void*>&self.tLooseMVAIso_value)

        #print "making tMVA2IsoRaw"
        self.tMVA2IsoRaw_branch = the_tree.GetBranch("tMVA2IsoRaw")
        #if not self.tMVA2IsoRaw_branch and "tMVA2IsoRaw" not in self.complained:
        if not self.tMVA2IsoRaw_branch and "tMVA2IsoRaw":
            warnings.warn( "MuMuETauTree: Expected branch tMVA2IsoRaw does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tMVA2IsoRaw")
        else:
            self.tMVA2IsoRaw_branch.SetAddress(<void*>&self.tMVA2IsoRaw_value)

        #print "making tMass"
        self.tMass_branch = the_tree.GetBranch("tMass")
        #if not self.tMass_branch and "tMass" not in self.complained:
        if not self.tMass_branch and "tMass":
            warnings.warn( "MuMuETauTree: Expected branch tMass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tMass")
        else:
            self.tMass_branch.SetAddress(<void*>&self.tMass_value)

        #print "making tMediumIso"
        self.tMediumIso_branch = the_tree.GetBranch("tMediumIso")
        #if not self.tMediumIso_branch and "tMediumIso" not in self.complained:
        if not self.tMediumIso_branch and "tMediumIso":
            warnings.warn( "MuMuETauTree: Expected branch tMediumIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tMediumIso")
        else:
            self.tMediumIso_branch.SetAddress(<void*>&self.tMediumIso_value)

        #print "making tMediumIso3Hits"
        self.tMediumIso3Hits_branch = the_tree.GetBranch("tMediumIso3Hits")
        #if not self.tMediumIso3Hits_branch and "tMediumIso3Hits" not in self.complained:
        if not self.tMediumIso3Hits_branch and "tMediumIso3Hits":
            warnings.warn( "MuMuETauTree: Expected branch tMediumIso3Hits does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tMediumIso3Hits")
        else:
            self.tMediumIso3Hits_branch.SetAddress(<void*>&self.tMediumIso3Hits_value)

        #print "making tMediumMVA2Iso"
        self.tMediumMVA2Iso_branch = the_tree.GetBranch("tMediumMVA2Iso")
        #if not self.tMediumMVA2Iso_branch and "tMediumMVA2Iso" not in self.complained:
        if not self.tMediumMVA2Iso_branch and "tMediumMVA2Iso":
            warnings.warn( "MuMuETauTree: Expected branch tMediumMVA2Iso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tMediumMVA2Iso")
        else:
            self.tMediumMVA2Iso_branch.SetAddress(<void*>&self.tMediumMVA2Iso_value)

        #print "making tMediumMVAIso"
        self.tMediumMVAIso_branch = the_tree.GetBranch("tMediumMVAIso")
        #if not self.tMediumMVAIso_branch and "tMediumMVAIso" not in self.complained:
        if not self.tMediumMVAIso_branch and "tMediumMVAIso":
            warnings.warn( "MuMuETauTree: Expected branch tMediumMVAIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tMediumMVAIso")
        else:
            self.tMediumMVAIso_branch.SetAddress(<void*>&self.tMediumMVAIso_value)

        #print "making tMtToMET"
        self.tMtToMET_branch = the_tree.GetBranch("tMtToMET")
        #if not self.tMtToMET_branch and "tMtToMET" not in self.complained:
        if not self.tMtToMET_branch and "tMtToMET":
            warnings.warn( "MuMuETauTree: Expected branch tMtToMET does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tMtToMET")
        else:
            self.tMtToMET_branch.SetAddress(<void*>&self.tMtToMET_value)

        #print "making tMtToMVAMET"
        self.tMtToMVAMET_branch = the_tree.GetBranch("tMtToMVAMET")
        #if not self.tMtToMVAMET_branch and "tMtToMVAMET" not in self.complained:
        if not self.tMtToMVAMET_branch and "tMtToMVAMET":
            warnings.warn( "MuMuETauTree: Expected branch tMtToMVAMET does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tMtToMVAMET")
        else:
            self.tMtToMVAMET_branch.SetAddress(<void*>&self.tMtToMVAMET_value)

        #print "making tMtToPFMET"
        self.tMtToPFMET_branch = the_tree.GetBranch("tMtToPFMET")
        #if not self.tMtToPFMET_branch and "tMtToPFMET" not in self.complained:
        if not self.tMtToPFMET_branch and "tMtToPFMET":
            warnings.warn( "MuMuETauTree: Expected branch tMtToPFMET does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tMtToPFMET")
        else:
            self.tMtToPFMET_branch.SetAddress(<void*>&self.tMtToPFMET_value)

        #print "making tMtToPfMet_Ty1"
        self.tMtToPfMet_Ty1_branch = the_tree.GetBranch("tMtToPfMet_Ty1")
        #if not self.tMtToPfMet_Ty1_branch and "tMtToPfMet_Ty1" not in self.complained:
        if not self.tMtToPfMet_Ty1_branch and "tMtToPfMet_Ty1":
            warnings.warn( "MuMuETauTree: Expected branch tMtToPfMet_Ty1 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tMtToPfMet_Ty1")
        else:
            self.tMtToPfMet_Ty1_branch.SetAddress(<void*>&self.tMtToPfMet_Ty1_value)

        #print "making tMtToPfMet_jes"
        self.tMtToPfMet_jes_branch = the_tree.GetBranch("tMtToPfMet_jes")
        #if not self.tMtToPfMet_jes_branch and "tMtToPfMet_jes" not in self.complained:
        if not self.tMtToPfMet_jes_branch and "tMtToPfMet_jes":
            warnings.warn( "MuMuETauTree: Expected branch tMtToPfMet_jes does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tMtToPfMet_jes")
        else:
            self.tMtToPfMet_jes_branch.SetAddress(<void*>&self.tMtToPfMet_jes_value)

        #print "making tMtToPfMet_mes"
        self.tMtToPfMet_mes_branch = the_tree.GetBranch("tMtToPfMet_mes")
        #if not self.tMtToPfMet_mes_branch and "tMtToPfMet_mes" not in self.complained:
        if not self.tMtToPfMet_mes_branch and "tMtToPfMet_mes":
            warnings.warn( "MuMuETauTree: Expected branch tMtToPfMet_mes does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tMtToPfMet_mes")
        else:
            self.tMtToPfMet_mes_branch.SetAddress(<void*>&self.tMtToPfMet_mes_value)

        #print "making tMtToPfMet_tes"
        self.tMtToPfMet_tes_branch = the_tree.GetBranch("tMtToPfMet_tes")
        #if not self.tMtToPfMet_tes_branch and "tMtToPfMet_tes" not in self.complained:
        if not self.tMtToPfMet_tes_branch and "tMtToPfMet_tes":
            warnings.warn( "MuMuETauTree: Expected branch tMtToPfMet_tes does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tMtToPfMet_tes")
        else:
            self.tMtToPfMet_tes_branch.SetAddress(<void*>&self.tMtToPfMet_tes_value)

        #print "making tMtToPfMet_ues"
        self.tMtToPfMet_ues_branch = the_tree.GetBranch("tMtToPfMet_ues")
        #if not self.tMtToPfMet_ues_branch and "tMtToPfMet_ues" not in self.complained:
        if not self.tMtToPfMet_ues_branch and "tMtToPfMet_ues":
            warnings.warn( "MuMuETauTree: Expected branch tMtToPfMet_ues does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tMtToPfMet_ues")
        else:
            self.tMtToPfMet_ues_branch.SetAddress(<void*>&self.tMtToPfMet_ues_value)

        #print "making tMuOverlap"
        self.tMuOverlap_branch = the_tree.GetBranch("tMuOverlap")
        #if not self.tMuOverlap_branch and "tMuOverlap" not in self.complained:
        if not self.tMuOverlap_branch and "tMuOverlap":
            warnings.warn( "MuMuETauTree: Expected branch tMuOverlap does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tMuOverlap")
        else:
            self.tMuOverlap_branch.SetAddress(<void*>&self.tMuOverlap_value)

        #print "making tPhi"
        self.tPhi_branch = the_tree.GetBranch("tPhi")
        #if not self.tPhi_branch and "tPhi" not in self.complained:
        if not self.tPhi_branch and "tPhi":
            warnings.warn( "MuMuETauTree: Expected branch tPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tPhi")
        else:
            self.tPhi_branch.SetAddress(<void*>&self.tPhi_value)

        #print "making tPt"
        self.tPt_branch = the_tree.GetBranch("tPt")
        #if not self.tPt_branch and "tPt" not in self.complained:
        if not self.tPt_branch and "tPt":
            warnings.warn( "MuMuETauTree: Expected branch tPt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tPt")
        else:
            self.tPt_branch.SetAddress(<void*>&self.tPt_value)

        #print "making tRank"
        self.tRank_branch = the_tree.GetBranch("tRank")
        #if not self.tRank_branch and "tRank" not in self.complained:
        if not self.tRank_branch and "tRank":
            warnings.warn( "MuMuETauTree: Expected branch tRank does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tRank")
        else:
            self.tRank_branch.SetAddress(<void*>&self.tRank_value)

        #print "making tTNPId"
        self.tTNPId_branch = the_tree.GetBranch("tTNPId")
        #if not self.tTNPId_branch and "tTNPId" not in self.complained:
        if not self.tTNPId_branch and "tTNPId":
            warnings.warn( "MuMuETauTree: Expected branch tTNPId does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tTNPId")
        else:
            self.tTNPId_branch.SetAddress(<void*>&self.tTNPId_value)

        #print "making tTightIso"
        self.tTightIso_branch = the_tree.GetBranch("tTightIso")
        #if not self.tTightIso_branch and "tTightIso" not in self.complained:
        if not self.tTightIso_branch and "tTightIso":
            warnings.warn( "MuMuETauTree: Expected branch tTightIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tTightIso")
        else:
            self.tTightIso_branch.SetAddress(<void*>&self.tTightIso_value)

        #print "making tTightIso3Hits"
        self.tTightIso3Hits_branch = the_tree.GetBranch("tTightIso3Hits")
        #if not self.tTightIso3Hits_branch and "tTightIso3Hits" not in self.complained:
        if not self.tTightIso3Hits_branch and "tTightIso3Hits":
            warnings.warn( "MuMuETauTree: Expected branch tTightIso3Hits does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tTightIso3Hits")
        else:
            self.tTightIso3Hits_branch.SetAddress(<void*>&self.tTightIso3Hits_value)

        #print "making tTightMVA2Iso"
        self.tTightMVA2Iso_branch = the_tree.GetBranch("tTightMVA2Iso")
        #if not self.tTightMVA2Iso_branch and "tTightMVA2Iso" not in self.complained:
        if not self.tTightMVA2Iso_branch and "tTightMVA2Iso":
            warnings.warn( "MuMuETauTree: Expected branch tTightMVA2Iso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tTightMVA2Iso")
        else:
            self.tTightMVA2Iso_branch.SetAddress(<void*>&self.tTightMVA2Iso_value)

        #print "making tTightMVAIso"
        self.tTightMVAIso_branch = the_tree.GetBranch("tTightMVAIso")
        #if not self.tTightMVAIso_branch and "tTightMVAIso" not in self.complained:
        if not self.tTightMVAIso_branch and "tTightMVAIso":
            warnings.warn( "MuMuETauTree: Expected branch tTightMVAIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tTightMVAIso")
        else:
            self.tTightMVAIso_branch.SetAddress(<void*>&self.tTightMVAIso_value)

        #print "making tToMETDPhi"
        self.tToMETDPhi_branch = the_tree.GetBranch("tToMETDPhi")
        #if not self.tToMETDPhi_branch and "tToMETDPhi" not in self.complained:
        if not self.tToMETDPhi_branch and "tToMETDPhi":
            warnings.warn( "MuMuETauTree: Expected branch tToMETDPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tToMETDPhi")
        else:
            self.tToMETDPhi_branch.SetAddress(<void*>&self.tToMETDPhi_value)

        #print "making tVLooseIso"
        self.tVLooseIso_branch = the_tree.GetBranch("tVLooseIso")
        #if not self.tVLooseIso_branch and "tVLooseIso" not in self.complained:
        if not self.tVLooseIso_branch and "tVLooseIso":
            warnings.warn( "MuMuETauTree: Expected branch tVLooseIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tVLooseIso")
        else:
            self.tVLooseIso_branch.SetAddress(<void*>&self.tVLooseIso_value)

        #print "making tVZ"
        self.tVZ_branch = the_tree.GetBranch("tVZ")
        #if not self.tVZ_branch and "tVZ" not in self.complained:
        if not self.tVZ_branch and "tVZ":
            warnings.warn( "MuMuETauTree: Expected branch tVZ does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tVZ")
        else:
            self.tVZ_branch.SetAddress(<void*>&self.tVZ_value)

        #print "making tauHpsVetoPt20"
        self.tauHpsVetoPt20_branch = the_tree.GetBranch("tauHpsVetoPt20")
        #if not self.tauHpsVetoPt20_branch and "tauHpsVetoPt20" not in self.complained:
        if not self.tauHpsVetoPt20_branch and "tauHpsVetoPt20":
            warnings.warn( "MuMuETauTree: Expected branch tauHpsVetoPt20 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tauHpsVetoPt20")
        else:
            self.tauHpsVetoPt20_branch.SetAddress(<void*>&self.tauHpsVetoPt20_value)

        #print "making tauTightCountZH"
        self.tauTightCountZH_branch = the_tree.GetBranch("tauTightCountZH")
        #if not self.tauTightCountZH_branch and "tauTightCountZH" not in self.complained:
        if not self.tauTightCountZH_branch and "tauTightCountZH":
            warnings.warn( "MuMuETauTree: Expected branch tauTightCountZH does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tauTightCountZH")
        else:
            self.tauTightCountZH_branch.SetAddress(<void*>&self.tauTightCountZH_value)

        #print "making tauVetoPt20"
        self.tauVetoPt20_branch = the_tree.GetBranch("tauVetoPt20")
        #if not self.tauVetoPt20_branch and "tauVetoPt20" not in self.complained:
        if not self.tauVetoPt20_branch and "tauVetoPt20":
            warnings.warn( "MuMuETauTree: Expected branch tauVetoPt20 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tauVetoPt20")
        else:
            self.tauVetoPt20_branch.SetAddress(<void*>&self.tauVetoPt20_value)

        #print "making tauVetoPt20Loose3HitsVtx"
        self.tauVetoPt20Loose3HitsVtx_branch = the_tree.GetBranch("tauVetoPt20Loose3HitsVtx")
        #if not self.tauVetoPt20Loose3HitsVtx_branch and "tauVetoPt20Loose3HitsVtx" not in self.complained:
        if not self.tauVetoPt20Loose3HitsVtx_branch and "tauVetoPt20Loose3HitsVtx":
            warnings.warn( "MuMuETauTree: Expected branch tauVetoPt20Loose3HitsVtx does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tauVetoPt20Loose3HitsVtx")
        else:
            self.tauVetoPt20Loose3HitsVtx_branch.SetAddress(<void*>&self.tauVetoPt20Loose3HitsVtx_value)

        #print "making tauVetoPt20LooseMVA2Vtx"
        self.tauVetoPt20LooseMVA2Vtx_branch = the_tree.GetBranch("tauVetoPt20LooseMVA2Vtx")
        #if not self.tauVetoPt20LooseMVA2Vtx_branch and "tauVetoPt20LooseMVA2Vtx" not in self.complained:
        if not self.tauVetoPt20LooseMVA2Vtx_branch and "tauVetoPt20LooseMVA2Vtx":
            warnings.warn( "MuMuETauTree: Expected branch tauVetoPt20LooseMVA2Vtx does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tauVetoPt20LooseMVA2Vtx")
        else:
            self.tauVetoPt20LooseMVA2Vtx_branch.SetAddress(<void*>&self.tauVetoPt20LooseMVA2Vtx_value)

        #print "making tauVetoPt20LooseMVAVtx"
        self.tauVetoPt20LooseMVAVtx_branch = the_tree.GetBranch("tauVetoPt20LooseMVAVtx")
        #if not self.tauVetoPt20LooseMVAVtx_branch and "tauVetoPt20LooseMVAVtx" not in self.complained:
        if not self.tauVetoPt20LooseMVAVtx_branch and "tauVetoPt20LooseMVAVtx":
            warnings.warn( "MuMuETauTree: Expected branch tauVetoPt20LooseMVAVtx does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tauVetoPt20LooseMVAVtx")
        else:
            self.tauVetoPt20LooseMVAVtx_branch.SetAddress(<void*>&self.tauVetoPt20LooseMVAVtx_value)

        #print "making tauVetoPt20VLooseHPSVtx"
        self.tauVetoPt20VLooseHPSVtx_branch = the_tree.GetBranch("tauVetoPt20VLooseHPSVtx")
        #if not self.tauVetoPt20VLooseHPSVtx_branch and "tauVetoPt20VLooseHPSVtx" not in self.complained:
        if not self.tauVetoPt20VLooseHPSVtx_branch and "tauVetoPt20VLooseHPSVtx":
            warnings.warn( "MuMuETauTree: Expected branch tauVetoPt20VLooseHPSVtx does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tauVetoPt20VLooseHPSVtx")
        else:
            self.tauVetoPt20VLooseHPSVtx_branch.SetAddress(<void*>&self.tauVetoPt20VLooseHPSVtx_value)

        #print "making tauVetoZH"
        self.tauVetoZH_branch = the_tree.GetBranch("tauVetoZH")
        #if not self.tauVetoZH_branch and "tauVetoZH" not in self.complained:
        if not self.tauVetoZH_branch and "tauVetoZH":
            warnings.warn( "MuMuETauTree: Expected branch tauVetoZH does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tauVetoZH")
        else:
            self.tauVetoZH_branch.SetAddress(<void*>&self.tauVetoZH_value)

        #print "making type1_pfMetEt"
        self.type1_pfMetEt_branch = the_tree.GetBranch("type1_pfMetEt")
        #if not self.type1_pfMetEt_branch and "type1_pfMetEt" not in self.complained:
        if not self.type1_pfMetEt_branch and "type1_pfMetEt":
            warnings.warn( "MuMuETauTree: Expected branch type1_pfMetEt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMetEt")
        else:
            self.type1_pfMetEt_branch.SetAddress(<void*>&self.type1_pfMetEt_value)

        #print "making type1_pfMetPhi"
        self.type1_pfMetPhi_branch = the_tree.GetBranch("type1_pfMetPhi")
        #if not self.type1_pfMetPhi_branch and "type1_pfMetPhi" not in self.complained:
        if not self.type1_pfMetPhi_branch and "type1_pfMetPhi":
            warnings.warn( "MuMuETauTree: Expected branch type1_pfMetPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMetPhi")
        else:
            self.type1_pfMetPhi_branch.SetAddress(<void*>&self.type1_pfMetPhi_value)

        #print "making idx"
        self.idx_branch = the_tree.GetBranch("idx")
        #if not self.idx_branch and "idx" not in self.complained:
        if not self.idx_branch and "idx":
            warnings.warn( "MuMuETauTree: Expected branch idx does not exist!"                " It will crash if you try and use it!",Warning)
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

    property eAbsEta:
        def __get__(self):
            self.eAbsEta_branch.GetEntry(self.localentry, 0)
            return self.eAbsEta_value

    property eCBID_LOOSE:
        def __get__(self):
            self.eCBID_LOOSE_branch.GetEntry(self.localentry, 0)
            return self.eCBID_LOOSE_value

    property eCBID_MEDIUM:
        def __get__(self):
            self.eCBID_MEDIUM_branch.GetEntry(self.localentry, 0)
            return self.eCBID_MEDIUM_value

    property eCBID_TIGHT:
        def __get__(self):
            self.eCBID_TIGHT_branch.GetEntry(self.localentry, 0)
            return self.eCBID_TIGHT_value

    property eCBID_VETO:
        def __get__(self):
            self.eCBID_VETO_branch.GetEntry(self.localentry, 0)
            return self.eCBID_VETO_value

    property eCharge:
        def __get__(self):
            self.eCharge_branch.GetEntry(self.localentry, 0)
            return self.eCharge_value

    property eChargeIdLoose:
        def __get__(self):
            self.eChargeIdLoose_branch.GetEntry(self.localentry, 0)
            return self.eChargeIdLoose_value

    property eChargeIdMed:
        def __get__(self):
            self.eChargeIdMed_branch.GetEntry(self.localentry, 0)
            return self.eChargeIdMed_value

    property eChargeIdTight:
        def __get__(self):
            self.eChargeIdTight_branch.GetEntry(self.localentry, 0)
            return self.eChargeIdTight_value

    property eCiCTight:
        def __get__(self):
            self.eCiCTight_branch.GetEntry(self.localentry, 0)
            return self.eCiCTight_value

    property eComesFromHiggs:
        def __get__(self):
            self.eComesFromHiggs_branch.GetEntry(self.localentry, 0)
            return self.eComesFromHiggs_value

    property eDZ:
        def __get__(self):
            self.eDZ_branch.GetEntry(self.localentry, 0)
            return self.eDZ_value

    property eE1x5:
        def __get__(self):
            self.eE1x5_branch.GetEntry(self.localentry, 0)
            return self.eE1x5_value

    property eE2x5Max:
        def __get__(self):
            self.eE2x5Max_branch.GetEntry(self.localentry, 0)
            return self.eE2x5Max_value

    property eE5x5:
        def __get__(self):
            self.eE5x5_branch.GetEntry(self.localentry, 0)
            return self.eE5x5_value

    property eECorrReg_2012Jul13ReReco:
        def __get__(self):
            self.eECorrReg_2012Jul13ReReco_branch.GetEntry(self.localentry, 0)
            return self.eECorrReg_2012Jul13ReReco_value

    property eECorrReg_Fall11:
        def __get__(self):
            self.eECorrReg_Fall11_branch.GetEntry(self.localentry, 0)
            return self.eECorrReg_Fall11_value

    property eECorrReg_Jan16ReReco:
        def __get__(self):
            self.eECorrReg_Jan16ReReco_branch.GetEntry(self.localentry, 0)
            return self.eECorrReg_Jan16ReReco_value

    property eECorrReg_Summer12_DR53X_HCP2012:
        def __get__(self):
            self.eECorrReg_Summer12_DR53X_HCP2012_branch.GetEntry(self.localentry, 0)
            return self.eECorrReg_Summer12_DR53X_HCP2012_value

    property eECorrSmearedNoReg_2012Jul13ReReco:
        def __get__(self):
            self.eECorrSmearedNoReg_2012Jul13ReReco_branch.GetEntry(self.localentry, 0)
            return self.eECorrSmearedNoReg_2012Jul13ReReco_value

    property eECorrSmearedNoReg_Fall11:
        def __get__(self):
            self.eECorrSmearedNoReg_Fall11_branch.GetEntry(self.localentry, 0)
            return self.eECorrSmearedNoReg_Fall11_value

    property eECorrSmearedNoReg_Jan16ReReco:
        def __get__(self):
            self.eECorrSmearedNoReg_Jan16ReReco_branch.GetEntry(self.localentry, 0)
            return self.eECorrSmearedNoReg_Jan16ReReco_value

    property eECorrSmearedNoReg_Summer12_DR53X_HCP2012:
        def __get__(self):
            self.eECorrSmearedNoReg_Summer12_DR53X_HCP2012_branch.GetEntry(self.localentry, 0)
            return self.eECorrSmearedNoReg_Summer12_DR53X_HCP2012_value

    property eECorrSmearedReg_2012Jul13ReReco:
        def __get__(self):
            self.eECorrSmearedReg_2012Jul13ReReco_branch.GetEntry(self.localentry, 0)
            return self.eECorrSmearedReg_2012Jul13ReReco_value

    property eECorrSmearedReg_Fall11:
        def __get__(self):
            self.eECorrSmearedReg_Fall11_branch.GetEntry(self.localentry, 0)
            return self.eECorrSmearedReg_Fall11_value

    property eECorrSmearedReg_Jan16ReReco:
        def __get__(self):
            self.eECorrSmearedReg_Jan16ReReco_branch.GetEntry(self.localentry, 0)
            return self.eECorrSmearedReg_Jan16ReReco_value

    property eECorrSmearedReg_Summer12_DR53X_HCP2012:
        def __get__(self):
            self.eECorrSmearedReg_Summer12_DR53X_HCP2012_branch.GetEntry(self.localentry, 0)
            return self.eECorrSmearedReg_Summer12_DR53X_HCP2012_value

    property eEcalIsoDR03:
        def __get__(self):
            self.eEcalIsoDR03_branch.GetEntry(self.localentry, 0)
            return self.eEcalIsoDR03_value

    property eEffectiveArea2011Data:
        def __get__(self):
            self.eEffectiveArea2011Data_branch.GetEntry(self.localentry, 0)
            return self.eEffectiveArea2011Data_value

    property eEffectiveArea2012Data:
        def __get__(self):
            self.eEffectiveArea2012Data_branch.GetEntry(self.localentry, 0)
            return self.eEffectiveArea2012Data_value

    property eEffectiveAreaFall11MC:
        def __get__(self):
            self.eEffectiveAreaFall11MC_branch.GetEntry(self.localentry, 0)
            return self.eEffectiveAreaFall11MC_value

    property eEle27WP80PFMT50PFMTFilter:
        def __get__(self):
            self.eEle27WP80PFMT50PFMTFilter_branch.GetEntry(self.localentry, 0)
            return self.eEle27WP80PFMT50PFMTFilter_value

    property eEle27WP80TrackIsoMatchFilter:
        def __get__(self):
            self.eEle27WP80TrackIsoMatchFilter_branch.GetEntry(self.localentry, 0)
            return self.eEle27WP80TrackIsoMatchFilter_value

    property eEle32WP70PFMT50PFMTFilter:
        def __get__(self):
            self.eEle32WP70PFMT50PFMTFilter_branch.GetEntry(self.localentry, 0)
            return self.eEle32WP70PFMT50PFMTFilter_value

    property eEnergyError:
        def __get__(self):
            self.eEnergyError_branch.GetEntry(self.localentry, 0)
            return self.eEnergyError_value

    property eEta:
        def __get__(self):
            self.eEta_branch.GetEntry(self.localentry, 0)
            return self.eEta_value

    property eEtaCorrReg_2012Jul13ReReco:
        def __get__(self):
            self.eEtaCorrReg_2012Jul13ReReco_branch.GetEntry(self.localentry, 0)
            return self.eEtaCorrReg_2012Jul13ReReco_value

    property eEtaCorrReg_Fall11:
        def __get__(self):
            self.eEtaCorrReg_Fall11_branch.GetEntry(self.localentry, 0)
            return self.eEtaCorrReg_Fall11_value

    property eEtaCorrReg_Jan16ReReco:
        def __get__(self):
            self.eEtaCorrReg_Jan16ReReco_branch.GetEntry(self.localentry, 0)
            return self.eEtaCorrReg_Jan16ReReco_value

    property eEtaCorrReg_Summer12_DR53X_HCP2012:
        def __get__(self):
            self.eEtaCorrReg_Summer12_DR53X_HCP2012_branch.GetEntry(self.localentry, 0)
            return self.eEtaCorrReg_Summer12_DR53X_HCP2012_value

    property eEtaCorrSmearedNoReg_2012Jul13ReReco:
        def __get__(self):
            self.eEtaCorrSmearedNoReg_2012Jul13ReReco_branch.GetEntry(self.localentry, 0)
            return self.eEtaCorrSmearedNoReg_2012Jul13ReReco_value

    property eEtaCorrSmearedNoReg_Fall11:
        def __get__(self):
            self.eEtaCorrSmearedNoReg_Fall11_branch.GetEntry(self.localentry, 0)
            return self.eEtaCorrSmearedNoReg_Fall11_value

    property eEtaCorrSmearedNoReg_Jan16ReReco:
        def __get__(self):
            self.eEtaCorrSmearedNoReg_Jan16ReReco_branch.GetEntry(self.localentry, 0)
            return self.eEtaCorrSmearedNoReg_Jan16ReReco_value

    property eEtaCorrSmearedNoReg_Summer12_DR53X_HCP2012:
        def __get__(self):
            self.eEtaCorrSmearedNoReg_Summer12_DR53X_HCP2012_branch.GetEntry(self.localentry, 0)
            return self.eEtaCorrSmearedNoReg_Summer12_DR53X_HCP2012_value

    property eEtaCorrSmearedReg_2012Jul13ReReco:
        def __get__(self):
            self.eEtaCorrSmearedReg_2012Jul13ReReco_branch.GetEntry(self.localentry, 0)
            return self.eEtaCorrSmearedReg_2012Jul13ReReco_value

    property eEtaCorrSmearedReg_Fall11:
        def __get__(self):
            self.eEtaCorrSmearedReg_Fall11_branch.GetEntry(self.localentry, 0)
            return self.eEtaCorrSmearedReg_Fall11_value

    property eEtaCorrSmearedReg_Jan16ReReco:
        def __get__(self):
            self.eEtaCorrSmearedReg_Jan16ReReco_branch.GetEntry(self.localentry, 0)
            return self.eEtaCorrSmearedReg_Jan16ReReco_value

    property eEtaCorrSmearedReg_Summer12_DR53X_HCP2012:
        def __get__(self):
            self.eEtaCorrSmearedReg_Summer12_DR53X_HCP2012_branch.GetEntry(self.localentry, 0)
            return self.eEtaCorrSmearedReg_Summer12_DR53X_HCP2012_value

    property eGenCharge:
        def __get__(self):
            self.eGenCharge_branch.GetEntry(self.localentry, 0)
            return self.eGenCharge_value

    property eGenEnergy:
        def __get__(self):
            self.eGenEnergy_branch.GetEntry(self.localentry, 0)
            return self.eGenEnergy_value

    property eGenEta:
        def __get__(self):
            self.eGenEta_branch.GetEntry(self.localentry, 0)
            return self.eGenEta_value

    property eGenMotherPdgId:
        def __get__(self):
            self.eGenMotherPdgId_branch.GetEntry(self.localentry, 0)
            return self.eGenMotherPdgId_value

    property eGenPdgId:
        def __get__(self):
            self.eGenPdgId_branch.GetEntry(self.localentry, 0)
            return self.eGenPdgId_value

    property eGenPhi:
        def __get__(self):
            self.eGenPhi_branch.GetEntry(self.localentry, 0)
            return self.eGenPhi_value

    property eHadronicDepth1OverEm:
        def __get__(self):
            self.eHadronicDepth1OverEm_branch.GetEntry(self.localentry, 0)
            return self.eHadronicDepth1OverEm_value

    property eHadronicDepth2OverEm:
        def __get__(self):
            self.eHadronicDepth2OverEm_branch.GetEntry(self.localentry, 0)
            return self.eHadronicDepth2OverEm_value

    property eHadronicOverEM:
        def __get__(self):
            self.eHadronicOverEM_branch.GetEntry(self.localentry, 0)
            return self.eHadronicOverEM_value

    property eHasConversion:
        def __get__(self):
            self.eHasConversion_branch.GetEntry(self.localentry, 0)
            return self.eHasConversion_value

    property eHasMatchedConversion:
        def __get__(self):
            self.eHasMatchedConversion_branch.GetEntry(self.localentry, 0)
            return self.eHasMatchedConversion_value

    property eHcalIsoDR03:
        def __get__(self):
            self.eHcalIsoDR03_branch.GetEntry(self.localentry, 0)
            return self.eHcalIsoDR03_value

    property eIP3DS:
        def __get__(self):
            self.eIP3DS_branch.GetEntry(self.localentry, 0)
            return self.eIP3DS_value

    property eJetArea:
        def __get__(self):
            self.eJetArea_branch.GetEntry(self.localentry, 0)
            return self.eJetArea_value

    property eJetBtag:
        def __get__(self):
            self.eJetBtag_branch.GetEntry(self.localentry, 0)
            return self.eJetBtag_value

    property eJetCSVBtag:
        def __get__(self):
            self.eJetCSVBtag_branch.GetEntry(self.localentry, 0)
            return self.eJetCSVBtag_value

    property eJetEtaEtaMoment:
        def __get__(self):
            self.eJetEtaEtaMoment_branch.GetEntry(self.localentry, 0)
            return self.eJetEtaEtaMoment_value

    property eJetEtaPhiMoment:
        def __get__(self):
            self.eJetEtaPhiMoment_branch.GetEntry(self.localentry, 0)
            return self.eJetEtaPhiMoment_value

    property eJetEtaPhiSpread:
        def __get__(self):
            self.eJetEtaPhiSpread_branch.GetEntry(self.localentry, 0)
            return self.eJetEtaPhiSpread_value

    property eJetPartonFlavour:
        def __get__(self):
            self.eJetPartonFlavour_branch.GetEntry(self.localentry, 0)
            return self.eJetPartonFlavour_value

    property eJetPhiPhiMoment:
        def __get__(self):
            self.eJetPhiPhiMoment_branch.GetEntry(self.localentry, 0)
            return self.eJetPhiPhiMoment_value

    property eJetPt:
        def __get__(self):
            self.eJetPt_branch.GetEntry(self.localentry, 0)
            return self.eJetPt_value

    property eJetQGLikelihoodID:
        def __get__(self):
            self.eJetQGLikelihoodID_branch.GetEntry(self.localentry, 0)
            return self.eJetQGLikelihoodID_value

    property eJetQGMVAID:
        def __get__(self):
            self.eJetQGMVAID_branch.GetEntry(self.localentry, 0)
            return self.eJetQGMVAID_value

    property eJetaxis1:
        def __get__(self):
            self.eJetaxis1_branch.GetEntry(self.localentry, 0)
            return self.eJetaxis1_value

    property eJetaxis2:
        def __get__(self):
            self.eJetaxis2_branch.GetEntry(self.localentry, 0)
            return self.eJetaxis2_value

    property eJetmult:
        def __get__(self):
            self.eJetmult_branch.GetEntry(self.localentry, 0)
            return self.eJetmult_value

    property eJetmultMLP:
        def __get__(self):
            self.eJetmultMLP_branch.GetEntry(self.localentry, 0)
            return self.eJetmultMLP_value

    property eJetmultMLPQC:
        def __get__(self):
            self.eJetmultMLPQC_branch.GetEntry(self.localentry, 0)
            return self.eJetmultMLPQC_value

    property eJetptD:
        def __get__(self):
            self.eJetptD_branch.GetEntry(self.localentry, 0)
            return self.eJetptD_value

    property eL1NonIsoHLTNonIsoMu17Ele8PixelMatchFilter:
        def __get__(self):
            self.eL1NonIsoHLTNonIsoMu17Ele8PixelMatchFilter_branch.GetEntry(self.localentry, 0)
            return self.eL1NonIsoHLTNonIsoMu17Ele8PixelMatchFilter_value

    property eMITID:
        def __get__(self):
            self.eMITID_branch.GetEntry(self.localentry, 0)
            return self.eMITID_value

    property eMVAIDH2TauWP:
        def __get__(self):
            self.eMVAIDH2TauWP_branch.GetEntry(self.localentry, 0)
            return self.eMVAIDH2TauWP_value

    property eMVANonTrig:
        def __get__(self):
            self.eMVANonTrig_branch.GetEntry(self.localentry, 0)
            return self.eMVANonTrig_value

    property eMVATrig:
        def __get__(self):
            self.eMVATrig_branch.GetEntry(self.localentry, 0)
            return self.eMVATrig_value

    property eMVATrigIDISO:
        def __get__(self):
            self.eMVATrigIDISO_branch.GetEntry(self.localentry, 0)
            return self.eMVATrigIDISO_value

    property eMVATrigIDISOPUSUB:
        def __get__(self):
            self.eMVATrigIDISOPUSUB_branch.GetEntry(self.localentry, 0)
            return self.eMVATrigIDISOPUSUB_value

    property eMVATrigNoIP:
        def __get__(self):
            self.eMVATrigNoIP_branch.GetEntry(self.localentry, 0)
            return self.eMVATrigNoIP_value

    property eMass:
        def __get__(self):
            self.eMass_branch.GetEntry(self.localentry, 0)
            return self.eMass_value

    property eMatchesDoubleEPath:
        def __get__(self):
            self.eMatchesDoubleEPath_branch.GetEntry(self.localentry, 0)
            return self.eMatchesDoubleEPath_value

    property eMatchesMu17Ele8IsoPath:
        def __get__(self):
            self.eMatchesMu17Ele8IsoPath_branch.GetEntry(self.localentry, 0)
            return self.eMatchesMu17Ele8IsoPath_value

    property eMatchesMu17Ele8Path:
        def __get__(self):
            self.eMatchesMu17Ele8Path_branch.GetEntry(self.localentry, 0)
            return self.eMatchesMu17Ele8Path_value

    property eMatchesMu8Ele17IsoPath:
        def __get__(self):
            self.eMatchesMu8Ele17IsoPath_branch.GetEntry(self.localentry, 0)
            return self.eMatchesMu8Ele17IsoPath_value

    property eMatchesMu8Ele17Path:
        def __get__(self):
            self.eMatchesMu8Ele17Path_branch.GetEntry(self.localentry, 0)
            return self.eMatchesMu8Ele17Path_value

    property eMatchesSingleE:
        def __get__(self):
            self.eMatchesSingleE_branch.GetEntry(self.localentry, 0)
            return self.eMatchesSingleE_value

    property eMatchesSingleEPlusMET:
        def __get__(self):
            self.eMatchesSingleEPlusMET_branch.GetEntry(self.localentry, 0)
            return self.eMatchesSingleEPlusMET_value

    property eMissingHits:
        def __get__(self):
            self.eMissingHits_branch.GetEntry(self.localentry, 0)
            return self.eMissingHits_value

    property eMtToMET:
        def __get__(self):
            self.eMtToMET_branch.GetEntry(self.localentry, 0)
            return self.eMtToMET_value

    property eMtToMVAMET:
        def __get__(self):
            self.eMtToMVAMET_branch.GetEntry(self.localentry, 0)
            return self.eMtToMVAMET_value

    property eMtToPFMET:
        def __get__(self):
            self.eMtToPFMET_branch.GetEntry(self.localentry, 0)
            return self.eMtToPFMET_value

    property eMtToPfMet_Ty1:
        def __get__(self):
            self.eMtToPfMet_Ty1_branch.GetEntry(self.localentry, 0)
            return self.eMtToPfMet_Ty1_value

    property eMtToPfMet_jes:
        def __get__(self):
            self.eMtToPfMet_jes_branch.GetEntry(self.localentry, 0)
            return self.eMtToPfMet_jes_value

    property eMtToPfMet_mes:
        def __get__(self):
            self.eMtToPfMet_mes_branch.GetEntry(self.localentry, 0)
            return self.eMtToPfMet_mes_value

    property eMtToPfMet_tes:
        def __get__(self):
            self.eMtToPfMet_tes_branch.GetEntry(self.localentry, 0)
            return self.eMtToPfMet_tes_value

    property eMtToPfMet_ues:
        def __get__(self):
            self.eMtToPfMet_ues_branch.GetEntry(self.localentry, 0)
            return self.eMtToPfMet_ues_value

    property eMu17Ele8CaloIdTCaloIsoVLTrkIdVLTrkIsoVLTrackIsoFilter:
        def __get__(self):
            self.eMu17Ele8CaloIdTCaloIsoVLTrkIdVLTrkIsoVLTrackIsoFilter_branch.GetEntry(self.localentry, 0)
            return self.eMu17Ele8CaloIdTCaloIsoVLTrkIdVLTrkIsoVLTrackIsoFilter_value

    property eMu17Ele8CaloIdTPixelMatchFilter:
        def __get__(self):
            self.eMu17Ele8CaloIdTPixelMatchFilter_branch.GetEntry(self.localentry, 0)
            return self.eMu17Ele8CaloIdTPixelMatchFilter_value

    property eMu17Ele8dZFilter:
        def __get__(self):
            self.eMu17Ele8dZFilter_branch.GetEntry(self.localentry, 0)
            return self.eMu17Ele8dZFilter_value

    property eNearMuonVeto:
        def __get__(self):
            self.eNearMuonVeto_branch.GetEntry(self.localentry, 0)
            return self.eNearMuonVeto_value

    property ePFChargedIso:
        def __get__(self):
            self.ePFChargedIso_branch.GetEntry(self.localentry, 0)
            return self.ePFChargedIso_value

    property ePFNeutralIso:
        def __get__(self):
            self.ePFNeutralIso_branch.GetEntry(self.localentry, 0)
            return self.ePFNeutralIso_value

    property ePFPhotonIso:
        def __get__(self):
            self.ePFPhotonIso_branch.GetEntry(self.localentry, 0)
            return self.ePFPhotonIso_value

    property ePVDXY:
        def __get__(self):
            self.ePVDXY_branch.GetEntry(self.localentry, 0)
            return self.ePVDXY_value

    property ePVDZ:
        def __get__(self):
            self.ePVDZ_branch.GetEntry(self.localentry, 0)
            return self.ePVDZ_value

    property ePhi:
        def __get__(self):
            self.ePhi_branch.GetEntry(self.localentry, 0)
            return self.ePhi_value

    property ePhiCorrReg_2012Jul13ReReco:
        def __get__(self):
            self.ePhiCorrReg_2012Jul13ReReco_branch.GetEntry(self.localentry, 0)
            return self.ePhiCorrReg_2012Jul13ReReco_value

    property ePhiCorrReg_Fall11:
        def __get__(self):
            self.ePhiCorrReg_Fall11_branch.GetEntry(self.localentry, 0)
            return self.ePhiCorrReg_Fall11_value

    property ePhiCorrReg_Jan16ReReco:
        def __get__(self):
            self.ePhiCorrReg_Jan16ReReco_branch.GetEntry(self.localentry, 0)
            return self.ePhiCorrReg_Jan16ReReco_value

    property ePhiCorrReg_Summer12_DR53X_HCP2012:
        def __get__(self):
            self.ePhiCorrReg_Summer12_DR53X_HCP2012_branch.GetEntry(self.localentry, 0)
            return self.ePhiCorrReg_Summer12_DR53X_HCP2012_value

    property ePhiCorrSmearedNoReg_2012Jul13ReReco:
        def __get__(self):
            self.ePhiCorrSmearedNoReg_2012Jul13ReReco_branch.GetEntry(self.localentry, 0)
            return self.ePhiCorrSmearedNoReg_2012Jul13ReReco_value

    property ePhiCorrSmearedNoReg_Fall11:
        def __get__(self):
            self.ePhiCorrSmearedNoReg_Fall11_branch.GetEntry(self.localentry, 0)
            return self.ePhiCorrSmearedNoReg_Fall11_value

    property ePhiCorrSmearedNoReg_Jan16ReReco:
        def __get__(self):
            self.ePhiCorrSmearedNoReg_Jan16ReReco_branch.GetEntry(self.localentry, 0)
            return self.ePhiCorrSmearedNoReg_Jan16ReReco_value

    property ePhiCorrSmearedNoReg_Summer12_DR53X_HCP2012:
        def __get__(self):
            self.ePhiCorrSmearedNoReg_Summer12_DR53X_HCP2012_branch.GetEntry(self.localentry, 0)
            return self.ePhiCorrSmearedNoReg_Summer12_DR53X_HCP2012_value

    property ePhiCorrSmearedReg_2012Jul13ReReco:
        def __get__(self):
            self.ePhiCorrSmearedReg_2012Jul13ReReco_branch.GetEntry(self.localentry, 0)
            return self.ePhiCorrSmearedReg_2012Jul13ReReco_value

    property ePhiCorrSmearedReg_Fall11:
        def __get__(self):
            self.ePhiCorrSmearedReg_Fall11_branch.GetEntry(self.localentry, 0)
            return self.ePhiCorrSmearedReg_Fall11_value

    property ePhiCorrSmearedReg_Jan16ReReco:
        def __get__(self):
            self.ePhiCorrSmearedReg_Jan16ReReco_branch.GetEntry(self.localentry, 0)
            return self.ePhiCorrSmearedReg_Jan16ReReco_value

    property ePhiCorrSmearedReg_Summer12_DR53X_HCP2012:
        def __get__(self):
            self.ePhiCorrSmearedReg_Summer12_DR53X_HCP2012_branch.GetEntry(self.localentry, 0)
            return self.ePhiCorrSmearedReg_Summer12_DR53X_HCP2012_value

    property ePt:
        def __get__(self):
            self.ePt_branch.GetEntry(self.localentry, 0)
            return self.ePt_value

    property ePtCorrReg_2012Jul13ReReco:
        def __get__(self):
            self.ePtCorrReg_2012Jul13ReReco_branch.GetEntry(self.localentry, 0)
            return self.ePtCorrReg_2012Jul13ReReco_value

    property ePtCorrReg_Fall11:
        def __get__(self):
            self.ePtCorrReg_Fall11_branch.GetEntry(self.localentry, 0)
            return self.ePtCorrReg_Fall11_value

    property ePtCorrReg_Jan16ReReco:
        def __get__(self):
            self.ePtCorrReg_Jan16ReReco_branch.GetEntry(self.localentry, 0)
            return self.ePtCorrReg_Jan16ReReco_value

    property ePtCorrReg_Summer12_DR53X_HCP2012:
        def __get__(self):
            self.ePtCorrReg_Summer12_DR53X_HCP2012_branch.GetEntry(self.localentry, 0)
            return self.ePtCorrReg_Summer12_DR53X_HCP2012_value

    property ePtCorrSmearedNoReg_2012Jul13ReReco:
        def __get__(self):
            self.ePtCorrSmearedNoReg_2012Jul13ReReco_branch.GetEntry(self.localentry, 0)
            return self.ePtCorrSmearedNoReg_2012Jul13ReReco_value

    property ePtCorrSmearedNoReg_Fall11:
        def __get__(self):
            self.ePtCorrSmearedNoReg_Fall11_branch.GetEntry(self.localentry, 0)
            return self.ePtCorrSmearedNoReg_Fall11_value

    property ePtCorrSmearedNoReg_Jan16ReReco:
        def __get__(self):
            self.ePtCorrSmearedNoReg_Jan16ReReco_branch.GetEntry(self.localentry, 0)
            return self.ePtCorrSmearedNoReg_Jan16ReReco_value

    property ePtCorrSmearedNoReg_Summer12_DR53X_HCP2012:
        def __get__(self):
            self.ePtCorrSmearedNoReg_Summer12_DR53X_HCP2012_branch.GetEntry(self.localentry, 0)
            return self.ePtCorrSmearedNoReg_Summer12_DR53X_HCP2012_value

    property ePtCorrSmearedReg_2012Jul13ReReco:
        def __get__(self):
            self.ePtCorrSmearedReg_2012Jul13ReReco_branch.GetEntry(self.localentry, 0)
            return self.ePtCorrSmearedReg_2012Jul13ReReco_value

    property ePtCorrSmearedReg_Fall11:
        def __get__(self):
            self.ePtCorrSmearedReg_Fall11_branch.GetEntry(self.localentry, 0)
            return self.ePtCorrSmearedReg_Fall11_value

    property ePtCorrSmearedReg_Jan16ReReco:
        def __get__(self):
            self.ePtCorrSmearedReg_Jan16ReReco_branch.GetEntry(self.localentry, 0)
            return self.ePtCorrSmearedReg_Jan16ReReco_value

    property ePtCorrSmearedReg_Summer12_DR53X_HCP2012:
        def __get__(self):
            self.ePtCorrSmearedReg_Summer12_DR53X_HCP2012_branch.GetEntry(self.localentry, 0)
            return self.ePtCorrSmearedReg_Summer12_DR53X_HCP2012_value

    property eRank:
        def __get__(self):
            self.eRank_branch.GetEntry(self.localentry, 0)
            return self.eRank_value

    property eRelIso:
        def __get__(self):
            self.eRelIso_branch.GetEntry(self.localentry, 0)
            return self.eRelIso_value

    property eRelPFIsoDB:
        def __get__(self):
            self.eRelPFIsoDB_branch.GetEntry(self.localentry, 0)
            return self.eRelPFIsoDB_value

    property eRelPFIsoRho:
        def __get__(self):
            self.eRelPFIsoRho_branch.GetEntry(self.localentry, 0)
            return self.eRelPFIsoRho_value

    property eRelPFIsoRhoFSR:
        def __get__(self):
            self.eRelPFIsoRhoFSR_branch.GetEntry(self.localentry, 0)
            return self.eRelPFIsoRhoFSR_value

    property eRhoHZG2011:
        def __get__(self):
            self.eRhoHZG2011_branch.GetEntry(self.localentry, 0)
            return self.eRhoHZG2011_value

    property eRhoHZG2012:
        def __get__(self):
            self.eRhoHZG2012_branch.GetEntry(self.localentry, 0)
            return self.eRhoHZG2012_value

    property eSCEnergy:
        def __get__(self):
            self.eSCEnergy_branch.GetEntry(self.localentry, 0)
            return self.eSCEnergy_value

    property eSCEta:
        def __get__(self):
            self.eSCEta_branch.GetEntry(self.localentry, 0)
            return self.eSCEta_value

    property eSCEtaWidth:
        def __get__(self):
            self.eSCEtaWidth_branch.GetEntry(self.localentry, 0)
            return self.eSCEtaWidth_value

    property eSCPhi:
        def __get__(self):
            self.eSCPhi_branch.GetEntry(self.localentry, 0)
            return self.eSCPhi_value

    property eSCPhiWidth:
        def __get__(self):
            self.eSCPhiWidth_branch.GetEntry(self.localentry, 0)
            return self.eSCPhiWidth_value

    property eSCPreshowerEnergy:
        def __get__(self):
            self.eSCPreshowerEnergy_branch.GetEntry(self.localentry, 0)
            return self.eSCPreshowerEnergy_value

    property eSCRawEnergy:
        def __get__(self):
            self.eSCRawEnergy_branch.GetEntry(self.localentry, 0)
            return self.eSCRawEnergy_value

    property eSigmaIEtaIEta:
        def __get__(self):
            self.eSigmaIEtaIEta_branch.GetEntry(self.localentry, 0)
            return self.eSigmaIEtaIEta_value

    property eTightCountZH:
        def __get__(self):
            self.eTightCountZH_branch.GetEntry(self.localentry, 0)
            return self.eTightCountZH_value

    property eToMETDPhi:
        def __get__(self):
            self.eToMETDPhi_branch.GetEntry(self.localentry, 0)
            return self.eToMETDPhi_value

    property eTrkIsoDR03:
        def __get__(self):
            self.eTrkIsoDR03_branch.GetEntry(self.localentry, 0)
            return self.eTrkIsoDR03_value

    property eVZ:
        def __get__(self):
            self.eVZ_branch.GetEntry(self.localentry, 0)
            return self.eVZ_value

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

    property eWWID:
        def __get__(self):
            self.eWWID_branch.GetEntry(self.localentry, 0)
            return self.eWWID_value

    property e_m1_CosThetaStar:
        def __get__(self):
            self.e_m1_CosThetaStar_branch.GetEntry(self.localentry, 0)
            return self.e_m1_CosThetaStar_value

    property e_m1_DPhi:
        def __get__(self):
            self.e_m1_DPhi_branch.GetEntry(self.localentry, 0)
            return self.e_m1_DPhi_value

    property e_m1_DR:
        def __get__(self):
            self.e_m1_DR_branch.GetEntry(self.localentry, 0)
            return self.e_m1_DR_value

    property e_m1_Eta:
        def __get__(self):
            self.e_m1_Eta_branch.GetEntry(self.localentry, 0)
            return self.e_m1_Eta_value

    property e_m1_Mass:
        def __get__(self):
            self.e_m1_Mass_branch.GetEntry(self.localentry, 0)
            return self.e_m1_Mass_value

    property e_m1_MassFsr:
        def __get__(self):
            self.e_m1_MassFsr_branch.GetEntry(self.localentry, 0)
            return self.e_m1_MassFsr_value

    property e_m1_PZeta:
        def __get__(self):
            self.e_m1_PZeta_branch.GetEntry(self.localentry, 0)
            return self.e_m1_PZeta_value

    property e_m1_PZetaVis:
        def __get__(self):
            self.e_m1_PZetaVis_branch.GetEntry(self.localentry, 0)
            return self.e_m1_PZetaVis_value

    property e_m1_Phi:
        def __get__(self):
            self.e_m1_Phi_branch.GetEntry(self.localentry, 0)
            return self.e_m1_Phi_value

    property e_m1_Pt:
        def __get__(self):
            self.e_m1_Pt_branch.GetEntry(self.localentry, 0)
            return self.e_m1_Pt_value

    property e_m1_PtFsr:
        def __get__(self):
            self.e_m1_PtFsr_branch.GetEntry(self.localentry, 0)
            return self.e_m1_PtFsr_value

    property e_m1_SS:
        def __get__(self):
            self.e_m1_SS_branch.GetEntry(self.localentry, 0)
            return self.e_m1_SS_value

    property e_m1_SVfitEta:
        def __get__(self):
            self.e_m1_SVfitEta_branch.GetEntry(self.localentry, 0)
            return self.e_m1_SVfitEta_value

    property e_m1_SVfitMass:
        def __get__(self):
            self.e_m1_SVfitMass_branch.GetEntry(self.localentry, 0)
            return self.e_m1_SVfitMass_value

    property e_m1_SVfitPhi:
        def __get__(self):
            self.e_m1_SVfitPhi_branch.GetEntry(self.localentry, 0)
            return self.e_m1_SVfitPhi_value

    property e_m1_SVfitPt:
        def __get__(self):
            self.e_m1_SVfitPt_branch.GetEntry(self.localentry, 0)
            return self.e_m1_SVfitPt_value

    property e_m1_ToMETDPhi_Ty1:
        def __get__(self):
            self.e_m1_ToMETDPhi_Ty1_branch.GetEntry(self.localentry, 0)
            return self.e_m1_ToMETDPhi_Ty1_value

    property e_m1_Zcompat:
        def __get__(self):
            self.e_m1_Zcompat_branch.GetEntry(self.localentry, 0)
            return self.e_m1_Zcompat_value

    property e_m2_CosThetaStar:
        def __get__(self):
            self.e_m2_CosThetaStar_branch.GetEntry(self.localentry, 0)
            return self.e_m2_CosThetaStar_value

    property e_m2_DPhi:
        def __get__(self):
            self.e_m2_DPhi_branch.GetEntry(self.localentry, 0)
            return self.e_m2_DPhi_value

    property e_m2_DR:
        def __get__(self):
            self.e_m2_DR_branch.GetEntry(self.localentry, 0)
            return self.e_m2_DR_value

    property e_m2_Eta:
        def __get__(self):
            self.e_m2_Eta_branch.GetEntry(self.localentry, 0)
            return self.e_m2_Eta_value

    property e_m2_Mass:
        def __get__(self):
            self.e_m2_Mass_branch.GetEntry(self.localentry, 0)
            return self.e_m2_Mass_value

    property e_m2_MassFsr:
        def __get__(self):
            self.e_m2_MassFsr_branch.GetEntry(self.localentry, 0)
            return self.e_m2_MassFsr_value

    property e_m2_PZeta:
        def __get__(self):
            self.e_m2_PZeta_branch.GetEntry(self.localentry, 0)
            return self.e_m2_PZeta_value

    property e_m2_PZetaVis:
        def __get__(self):
            self.e_m2_PZetaVis_branch.GetEntry(self.localentry, 0)
            return self.e_m2_PZetaVis_value

    property e_m2_Phi:
        def __get__(self):
            self.e_m2_Phi_branch.GetEntry(self.localentry, 0)
            return self.e_m2_Phi_value

    property e_m2_Pt:
        def __get__(self):
            self.e_m2_Pt_branch.GetEntry(self.localentry, 0)
            return self.e_m2_Pt_value

    property e_m2_PtFsr:
        def __get__(self):
            self.e_m2_PtFsr_branch.GetEntry(self.localentry, 0)
            return self.e_m2_PtFsr_value

    property e_m2_SS:
        def __get__(self):
            self.e_m2_SS_branch.GetEntry(self.localentry, 0)
            return self.e_m2_SS_value

    property e_m2_ToMETDPhi_Ty1:
        def __get__(self):
            self.e_m2_ToMETDPhi_Ty1_branch.GetEntry(self.localentry, 0)
            return self.e_m2_ToMETDPhi_Ty1_value

    property e_m2_Zcompat:
        def __get__(self):
            self.e_m2_Zcompat_branch.GetEntry(self.localentry, 0)
            return self.e_m2_Zcompat_value

    property e_t_CosThetaStar:
        def __get__(self):
            self.e_t_CosThetaStar_branch.GetEntry(self.localentry, 0)
            return self.e_t_CosThetaStar_value

    property e_t_DPhi:
        def __get__(self):
            self.e_t_DPhi_branch.GetEntry(self.localentry, 0)
            return self.e_t_DPhi_value

    property e_t_DR:
        def __get__(self):
            self.e_t_DR_branch.GetEntry(self.localentry, 0)
            return self.e_t_DR_value

    property e_t_Eta:
        def __get__(self):
            self.e_t_Eta_branch.GetEntry(self.localentry, 0)
            return self.e_t_Eta_value

    property e_t_Mass:
        def __get__(self):
            self.e_t_Mass_branch.GetEntry(self.localentry, 0)
            return self.e_t_Mass_value

    property e_t_MassFsr:
        def __get__(self):
            self.e_t_MassFsr_branch.GetEntry(self.localentry, 0)
            return self.e_t_MassFsr_value

    property e_t_PZeta:
        def __get__(self):
            self.e_t_PZeta_branch.GetEntry(self.localentry, 0)
            return self.e_t_PZeta_value

    property e_t_PZetaVis:
        def __get__(self):
            self.e_t_PZetaVis_branch.GetEntry(self.localentry, 0)
            return self.e_t_PZetaVis_value

    property e_t_Phi:
        def __get__(self):
            self.e_t_Phi_branch.GetEntry(self.localentry, 0)
            return self.e_t_Phi_value

    property e_t_Pt:
        def __get__(self):
            self.e_t_Pt_branch.GetEntry(self.localentry, 0)
            return self.e_t_Pt_value

    property e_t_PtFsr:
        def __get__(self):
            self.e_t_PtFsr_branch.GetEntry(self.localentry, 0)
            return self.e_t_PtFsr_value

    property e_t_SS:
        def __get__(self):
            self.e_t_SS_branch.GetEntry(self.localentry, 0)
            return self.e_t_SS_value

    property e_t_SVfitEta:
        def __get__(self):
            self.e_t_SVfitEta_branch.GetEntry(self.localentry, 0)
            return self.e_t_SVfitEta_value

    property e_t_SVfitMass:
        def __get__(self):
            self.e_t_SVfitMass_branch.GetEntry(self.localentry, 0)
            return self.e_t_SVfitMass_value

    property e_t_SVfitPhi:
        def __get__(self):
            self.e_t_SVfitPhi_branch.GetEntry(self.localentry, 0)
            return self.e_t_SVfitPhi_value

    property e_t_SVfitPt:
        def __get__(self):
            self.e_t_SVfitPt_branch.GetEntry(self.localentry, 0)
            return self.e_t_SVfitPt_value

    property e_t_ToMETDPhi_Ty1:
        def __get__(self):
            self.e_t_ToMETDPhi_Ty1_branch.GetEntry(self.localentry, 0)
            return self.e_t_ToMETDPhi_Ty1_value

    property e_t_Zcompat:
        def __get__(self):
            self.e_t_Zcompat_branch.GetEntry(self.localentry, 0)
            return self.e_t_Zcompat_value

    property edECorrReg_2012Jul13ReReco:
        def __get__(self):
            self.edECorrReg_2012Jul13ReReco_branch.GetEntry(self.localentry, 0)
            return self.edECorrReg_2012Jul13ReReco_value

    property edECorrReg_Fall11:
        def __get__(self):
            self.edECorrReg_Fall11_branch.GetEntry(self.localentry, 0)
            return self.edECorrReg_Fall11_value

    property edECorrReg_Jan16ReReco:
        def __get__(self):
            self.edECorrReg_Jan16ReReco_branch.GetEntry(self.localentry, 0)
            return self.edECorrReg_Jan16ReReco_value

    property edECorrReg_Summer12_DR53X_HCP2012:
        def __get__(self):
            self.edECorrReg_Summer12_DR53X_HCP2012_branch.GetEntry(self.localentry, 0)
            return self.edECorrReg_Summer12_DR53X_HCP2012_value

    property edECorrSmearedNoReg_2012Jul13ReReco:
        def __get__(self):
            self.edECorrSmearedNoReg_2012Jul13ReReco_branch.GetEntry(self.localentry, 0)
            return self.edECorrSmearedNoReg_2012Jul13ReReco_value

    property edECorrSmearedNoReg_Fall11:
        def __get__(self):
            self.edECorrSmearedNoReg_Fall11_branch.GetEntry(self.localentry, 0)
            return self.edECorrSmearedNoReg_Fall11_value

    property edECorrSmearedNoReg_Jan16ReReco:
        def __get__(self):
            self.edECorrSmearedNoReg_Jan16ReReco_branch.GetEntry(self.localentry, 0)
            return self.edECorrSmearedNoReg_Jan16ReReco_value

    property edECorrSmearedNoReg_Summer12_DR53X_HCP2012:
        def __get__(self):
            self.edECorrSmearedNoReg_Summer12_DR53X_HCP2012_branch.GetEntry(self.localentry, 0)
            return self.edECorrSmearedNoReg_Summer12_DR53X_HCP2012_value

    property edECorrSmearedReg_2012Jul13ReReco:
        def __get__(self):
            self.edECorrSmearedReg_2012Jul13ReReco_branch.GetEntry(self.localentry, 0)
            return self.edECorrSmearedReg_2012Jul13ReReco_value

    property edECorrSmearedReg_Fall11:
        def __get__(self):
            self.edECorrSmearedReg_Fall11_branch.GetEntry(self.localentry, 0)
            return self.edECorrSmearedReg_Fall11_value

    property edECorrSmearedReg_Jan16ReReco:
        def __get__(self):
            self.edECorrSmearedReg_Jan16ReReco_branch.GetEntry(self.localentry, 0)
            return self.edECorrSmearedReg_Jan16ReReco_value

    property edECorrSmearedReg_Summer12_DR53X_HCP2012:
        def __get__(self):
            self.edECorrSmearedReg_Summer12_DR53X_HCP2012_branch.GetEntry(self.localentry, 0)
            return self.edECorrSmearedReg_Summer12_DR53X_HCP2012_value

    property edeltaEtaSuperClusterTrackAtVtx:
        def __get__(self):
            self.edeltaEtaSuperClusterTrackAtVtx_branch.GetEntry(self.localentry, 0)
            return self.edeltaEtaSuperClusterTrackAtVtx_value

    property edeltaPhiSuperClusterTrackAtVtx:
        def __get__(self):
            self.edeltaPhiSuperClusterTrackAtVtx_branch.GetEntry(self.localentry, 0)
            return self.edeltaPhiSuperClusterTrackAtVtx_value

    property eeSuperClusterOverP:
        def __get__(self):
            self.eeSuperClusterOverP_branch.GetEntry(self.localentry, 0)
            return self.eeSuperClusterOverP_value

    property eecalEnergy:
        def __get__(self):
            self.eecalEnergy_branch.GetEntry(self.localentry, 0)
            return self.eecalEnergy_value

    property efBrem:
        def __get__(self):
            self.efBrem_branch.GetEntry(self.localentry, 0)
            return self.efBrem_value

    property etrackMomentumAtVtxP:
        def __get__(self):
            self.etrackMomentumAtVtxP_branch.GetEntry(self.localentry, 0)
            return self.etrackMomentumAtVtxP_value

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

    property m2_t_SVfitEta:
        def __get__(self):
            self.m2_t_SVfitEta_branch.GetEntry(self.localentry, 0)
            return self.m2_t_SVfitEta_value

    property m2_t_SVfitMass:
        def __get__(self):
            self.m2_t_SVfitMass_branch.GetEntry(self.localentry, 0)
            return self.m2_t_SVfitMass_value

    property m2_t_SVfitPhi:
        def __get__(self):
            self.m2_t_SVfitPhi_branch.GetEntry(self.localentry, 0)
            return self.m2_t_SVfitPhi_value

    property m2_t_SVfitPt:
        def __get__(self):
            self.m2_t_SVfitPt_branch.GetEntry(self.localentry, 0)
            return self.m2_t_SVfitPt_value

    property m2_t_ToMETDPhi_Ty1:
        def __get__(self):
            self.m2_t_ToMETDPhi_Ty1_branch.GetEntry(self.localentry, 0)
            return self.m2_t_ToMETDPhi_Ty1_value

    property m2_t_Zcompat:
        def __get__(self):
            self.m2_t_Zcompat_branch.GetEntry(self.localentry, 0)
            return self.m2_t_Zcompat_value

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


