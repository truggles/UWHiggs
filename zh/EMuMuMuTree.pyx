

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

cdef class EMuMuMuTree:
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

    cdef TBranch* e_m3_CosThetaStar_branch
    cdef float e_m3_CosThetaStar_value

    cdef TBranch* e_m3_DPhi_branch
    cdef float e_m3_DPhi_value

    cdef TBranch* e_m3_DR_branch
    cdef float e_m3_DR_value

    cdef TBranch* e_m3_Eta_branch
    cdef float e_m3_Eta_value

    cdef TBranch* e_m3_Mass_branch
    cdef float e_m3_Mass_value

    cdef TBranch* e_m3_MassFsr_branch
    cdef float e_m3_MassFsr_value

    cdef TBranch* e_m3_PZeta_branch
    cdef float e_m3_PZeta_value

    cdef TBranch* e_m3_PZetaVis_branch
    cdef float e_m3_PZetaVis_value

    cdef TBranch* e_m3_Phi_branch
    cdef float e_m3_Phi_value

    cdef TBranch* e_m3_Pt_branch
    cdef float e_m3_Pt_value

    cdef TBranch* e_m3_PtFsr_branch
    cdef float e_m3_PtFsr_value

    cdef TBranch* e_m3_SS_branch
    cdef float e_m3_SS_value

    cdef TBranch* e_m3_SVfitEta_branch
    cdef float e_m3_SVfitEta_value

    cdef TBranch* e_m3_SVfitMass_branch
    cdef float e_m3_SVfitMass_value

    cdef TBranch* e_m3_SVfitPhi_branch
    cdef float e_m3_SVfitPhi_value

    cdef TBranch* e_m3_SVfitPt_branch
    cdef float e_m3_SVfitPt_value

    cdef TBranch* e_m3_ToMETDPhi_Ty1_branch
    cdef float e_m3_ToMETDPhi_Ty1_value

    cdef TBranch* e_m3_Zcompat_branch
    cdef float e_m3_Zcompat_value

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
            warnings.warn( "EMuMuMuTree: Expected branch EmbPtWeight does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("EmbPtWeight")
        else:
            self.EmbPtWeight_branch.SetAddress(<void*>&self.EmbPtWeight_value)

        #print "making LT"
        self.LT_branch = the_tree.GetBranch("LT")
        #if not self.LT_branch and "LT" not in self.complained:
        if not self.LT_branch and "LT":
            warnings.warn( "EMuMuMuTree: Expected branch LT does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("LT")
        else:
            self.LT_branch.SetAddress(<void*>&self.LT_value)

        #print "making Mass"
        self.Mass_branch = the_tree.GetBranch("Mass")
        #if not self.Mass_branch and "Mass" not in self.complained:
        if not self.Mass_branch and "Mass":
            warnings.warn( "EMuMuMuTree: Expected branch Mass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Mass")
        else:
            self.Mass_branch.SetAddress(<void*>&self.Mass_value)

        #print "making MassError"
        self.MassError_branch = the_tree.GetBranch("MassError")
        #if not self.MassError_branch and "MassError" not in self.complained:
        if not self.MassError_branch and "MassError":
            warnings.warn( "EMuMuMuTree: Expected branch MassError does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("MassError")
        else:
            self.MassError_branch.SetAddress(<void*>&self.MassError_value)

        #print "making MassErrord1"
        self.MassErrord1_branch = the_tree.GetBranch("MassErrord1")
        #if not self.MassErrord1_branch and "MassErrord1" not in self.complained:
        if not self.MassErrord1_branch and "MassErrord1":
            warnings.warn( "EMuMuMuTree: Expected branch MassErrord1 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("MassErrord1")
        else:
            self.MassErrord1_branch.SetAddress(<void*>&self.MassErrord1_value)

        #print "making MassErrord2"
        self.MassErrord2_branch = the_tree.GetBranch("MassErrord2")
        #if not self.MassErrord2_branch and "MassErrord2" not in self.complained:
        if not self.MassErrord2_branch and "MassErrord2":
            warnings.warn( "EMuMuMuTree: Expected branch MassErrord2 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("MassErrord2")
        else:
            self.MassErrord2_branch.SetAddress(<void*>&self.MassErrord2_value)

        #print "making MassErrord3"
        self.MassErrord3_branch = the_tree.GetBranch("MassErrord3")
        #if not self.MassErrord3_branch and "MassErrord3" not in self.complained:
        if not self.MassErrord3_branch and "MassErrord3":
            warnings.warn( "EMuMuMuTree: Expected branch MassErrord3 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("MassErrord3")
        else:
            self.MassErrord3_branch.SetAddress(<void*>&self.MassErrord3_value)

        #print "making MassErrord4"
        self.MassErrord4_branch = the_tree.GetBranch("MassErrord4")
        #if not self.MassErrord4_branch and "MassErrord4" not in self.complained:
        if not self.MassErrord4_branch and "MassErrord4":
            warnings.warn( "EMuMuMuTree: Expected branch MassErrord4 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("MassErrord4")
        else:
            self.MassErrord4_branch.SetAddress(<void*>&self.MassErrord4_value)

        #print "making NUP"
        self.NUP_branch = the_tree.GetBranch("NUP")
        #if not self.NUP_branch and "NUP" not in self.complained:
        if not self.NUP_branch and "NUP":
            warnings.warn( "EMuMuMuTree: Expected branch NUP does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("NUP")
        else:
            self.NUP_branch.SetAddress(<void*>&self.NUP_value)

        #print "making Pt"
        self.Pt_branch = the_tree.GetBranch("Pt")
        #if not self.Pt_branch and "Pt" not in self.complained:
        if not self.Pt_branch and "Pt":
            warnings.warn( "EMuMuMuTree: Expected branch Pt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Pt")
        else:
            self.Pt_branch.SetAddress(<void*>&self.Pt_value)

        #print "making bjetCSVVeto"
        self.bjetCSVVeto_branch = the_tree.GetBranch("bjetCSVVeto")
        #if not self.bjetCSVVeto_branch and "bjetCSVVeto" not in self.complained:
        if not self.bjetCSVVeto_branch and "bjetCSVVeto":
            warnings.warn( "EMuMuMuTree: Expected branch bjetCSVVeto does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("bjetCSVVeto")
        else:
            self.bjetCSVVeto_branch.SetAddress(<void*>&self.bjetCSVVeto_value)

        #print "making bjetCSVVeto30"
        self.bjetCSVVeto30_branch = the_tree.GetBranch("bjetCSVVeto30")
        #if not self.bjetCSVVeto30_branch and "bjetCSVVeto30" not in self.complained:
        if not self.bjetCSVVeto30_branch and "bjetCSVVeto30":
            warnings.warn( "EMuMuMuTree: Expected branch bjetCSVVeto30 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("bjetCSVVeto30")
        else:
            self.bjetCSVVeto30_branch.SetAddress(<void*>&self.bjetCSVVeto30_value)

        #print "making bjetCSVVetoZHLike"
        self.bjetCSVVetoZHLike_branch = the_tree.GetBranch("bjetCSVVetoZHLike")
        #if not self.bjetCSVVetoZHLike_branch and "bjetCSVVetoZHLike" not in self.complained:
        if not self.bjetCSVVetoZHLike_branch and "bjetCSVVetoZHLike":
            warnings.warn( "EMuMuMuTree: Expected branch bjetCSVVetoZHLike does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("bjetCSVVetoZHLike")
        else:
            self.bjetCSVVetoZHLike_branch.SetAddress(<void*>&self.bjetCSVVetoZHLike_value)

        #print "making bjetCSVVetoZHLikeNoJetId"
        self.bjetCSVVetoZHLikeNoJetId_branch = the_tree.GetBranch("bjetCSVVetoZHLikeNoJetId")
        #if not self.bjetCSVVetoZHLikeNoJetId_branch and "bjetCSVVetoZHLikeNoJetId" not in self.complained:
        if not self.bjetCSVVetoZHLikeNoJetId_branch and "bjetCSVVetoZHLikeNoJetId":
            warnings.warn( "EMuMuMuTree: Expected branch bjetCSVVetoZHLikeNoJetId does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("bjetCSVVetoZHLikeNoJetId")
        else:
            self.bjetCSVVetoZHLikeNoJetId_branch.SetAddress(<void*>&self.bjetCSVVetoZHLikeNoJetId_value)

        #print "making bjetCSVVetoZHLikeNoJetId_2"
        self.bjetCSVVetoZHLikeNoJetId_2_branch = the_tree.GetBranch("bjetCSVVetoZHLikeNoJetId_2")
        #if not self.bjetCSVVetoZHLikeNoJetId_2_branch and "bjetCSVVetoZHLikeNoJetId_2" not in self.complained:
        if not self.bjetCSVVetoZHLikeNoJetId_2_branch and "bjetCSVVetoZHLikeNoJetId_2":
            warnings.warn( "EMuMuMuTree: Expected branch bjetCSVVetoZHLikeNoJetId_2 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("bjetCSVVetoZHLikeNoJetId_2")
        else:
            self.bjetCSVVetoZHLikeNoJetId_2_branch.SetAddress(<void*>&self.bjetCSVVetoZHLikeNoJetId_2_value)

        #print "making bjetTightCountZH"
        self.bjetTightCountZH_branch = the_tree.GetBranch("bjetTightCountZH")
        #if not self.bjetTightCountZH_branch and "bjetTightCountZH" not in self.complained:
        if not self.bjetTightCountZH_branch and "bjetTightCountZH":
            warnings.warn( "EMuMuMuTree: Expected branch bjetTightCountZH does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("bjetTightCountZH")
        else:
            self.bjetTightCountZH_branch.SetAddress(<void*>&self.bjetTightCountZH_value)

        #print "making bjetVeto"
        self.bjetVeto_branch = the_tree.GetBranch("bjetVeto")
        #if not self.bjetVeto_branch and "bjetVeto" not in self.complained:
        if not self.bjetVeto_branch and "bjetVeto":
            warnings.warn( "EMuMuMuTree: Expected branch bjetVeto does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("bjetVeto")
        else:
            self.bjetVeto_branch.SetAddress(<void*>&self.bjetVeto_value)

        #print "making charge"
        self.charge_branch = the_tree.GetBranch("charge")
        #if not self.charge_branch and "charge" not in self.complained:
        if not self.charge_branch and "charge":
            warnings.warn( "EMuMuMuTree: Expected branch charge does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("charge")
        else:
            self.charge_branch.SetAddress(<void*>&self.charge_value)

        #print "making doubleEExtraGroup"
        self.doubleEExtraGroup_branch = the_tree.GetBranch("doubleEExtraGroup")
        #if not self.doubleEExtraGroup_branch and "doubleEExtraGroup" not in self.complained:
        if not self.doubleEExtraGroup_branch and "doubleEExtraGroup":
            warnings.warn( "EMuMuMuTree: Expected branch doubleEExtraGroup does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleEExtraGroup")
        else:
            self.doubleEExtraGroup_branch.SetAddress(<void*>&self.doubleEExtraGroup_value)

        #print "making doubleEExtraPass"
        self.doubleEExtraPass_branch = the_tree.GetBranch("doubleEExtraPass")
        #if not self.doubleEExtraPass_branch and "doubleEExtraPass" not in self.complained:
        if not self.doubleEExtraPass_branch and "doubleEExtraPass":
            warnings.warn( "EMuMuMuTree: Expected branch doubleEExtraPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleEExtraPass")
        else:
            self.doubleEExtraPass_branch.SetAddress(<void*>&self.doubleEExtraPass_value)

        #print "making doubleEExtraPrescale"
        self.doubleEExtraPrescale_branch = the_tree.GetBranch("doubleEExtraPrescale")
        #if not self.doubleEExtraPrescale_branch and "doubleEExtraPrescale" not in self.complained:
        if not self.doubleEExtraPrescale_branch and "doubleEExtraPrescale":
            warnings.warn( "EMuMuMuTree: Expected branch doubleEExtraPrescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleEExtraPrescale")
        else:
            self.doubleEExtraPrescale_branch.SetAddress(<void*>&self.doubleEExtraPrescale_value)

        #print "making doubleEGroup"
        self.doubleEGroup_branch = the_tree.GetBranch("doubleEGroup")
        #if not self.doubleEGroup_branch and "doubleEGroup" not in self.complained:
        if not self.doubleEGroup_branch and "doubleEGroup":
            warnings.warn( "EMuMuMuTree: Expected branch doubleEGroup does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleEGroup")
        else:
            self.doubleEGroup_branch.SetAddress(<void*>&self.doubleEGroup_value)

        #print "making doubleEPass"
        self.doubleEPass_branch = the_tree.GetBranch("doubleEPass")
        #if not self.doubleEPass_branch and "doubleEPass" not in self.complained:
        if not self.doubleEPass_branch and "doubleEPass":
            warnings.warn( "EMuMuMuTree: Expected branch doubleEPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleEPass")
        else:
            self.doubleEPass_branch.SetAddress(<void*>&self.doubleEPass_value)

        #print "making doubleEPrescale"
        self.doubleEPrescale_branch = the_tree.GetBranch("doubleEPrescale")
        #if not self.doubleEPrescale_branch and "doubleEPrescale" not in self.complained:
        if not self.doubleEPrescale_branch and "doubleEPrescale":
            warnings.warn( "EMuMuMuTree: Expected branch doubleEPrescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleEPrescale")
        else:
            self.doubleEPrescale_branch.SetAddress(<void*>&self.doubleEPrescale_value)

        #print "making doubleETightGroup"
        self.doubleETightGroup_branch = the_tree.GetBranch("doubleETightGroup")
        #if not self.doubleETightGroup_branch and "doubleETightGroup" not in self.complained:
        if not self.doubleETightGroup_branch and "doubleETightGroup":
            warnings.warn( "EMuMuMuTree: Expected branch doubleETightGroup does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleETightGroup")
        else:
            self.doubleETightGroup_branch.SetAddress(<void*>&self.doubleETightGroup_value)

        #print "making doubleETightPass"
        self.doubleETightPass_branch = the_tree.GetBranch("doubleETightPass")
        #if not self.doubleETightPass_branch and "doubleETightPass" not in self.complained:
        if not self.doubleETightPass_branch and "doubleETightPass":
            warnings.warn( "EMuMuMuTree: Expected branch doubleETightPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleETightPass")
        else:
            self.doubleETightPass_branch.SetAddress(<void*>&self.doubleETightPass_value)

        #print "making doubleETightPrescale"
        self.doubleETightPrescale_branch = the_tree.GetBranch("doubleETightPrescale")
        #if not self.doubleETightPrescale_branch and "doubleETightPrescale" not in self.complained:
        if not self.doubleETightPrescale_branch and "doubleETightPrescale":
            warnings.warn( "EMuMuMuTree: Expected branch doubleETightPrescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleETightPrescale")
        else:
            self.doubleETightPrescale_branch.SetAddress(<void*>&self.doubleETightPrescale_value)

        #print "making doubleMuGroup"
        self.doubleMuGroup_branch = the_tree.GetBranch("doubleMuGroup")
        #if not self.doubleMuGroup_branch and "doubleMuGroup" not in self.complained:
        if not self.doubleMuGroup_branch and "doubleMuGroup":
            warnings.warn( "EMuMuMuTree: Expected branch doubleMuGroup does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleMuGroup")
        else:
            self.doubleMuGroup_branch.SetAddress(<void*>&self.doubleMuGroup_value)

        #print "making doubleMuPass"
        self.doubleMuPass_branch = the_tree.GetBranch("doubleMuPass")
        #if not self.doubleMuPass_branch and "doubleMuPass" not in self.complained:
        if not self.doubleMuPass_branch and "doubleMuPass":
            warnings.warn( "EMuMuMuTree: Expected branch doubleMuPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleMuPass")
        else:
            self.doubleMuPass_branch.SetAddress(<void*>&self.doubleMuPass_value)

        #print "making doubleMuPrescale"
        self.doubleMuPrescale_branch = the_tree.GetBranch("doubleMuPrescale")
        #if not self.doubleMuPrescale_branch and "doubleMuPrescale" not in self.complained:
        if not self.doubleMuPrescale_branch and "doubleMuPrescale":
            warnings.warn( "EMuMuMuTree: Expected branch doubleMuPrescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleMuPrescale")
        else:
            self.doubleMuPrescale_branch.SetAddress(<void*>&self.doubleMuPrescale_value)

        #print "making doubleMuTrkGroup"
        self.doubleMuTrkGroup_branch = the_tree.GetBranch("doubleMuTrkGroup")
        #if not self.doubleMuTrkGroup_branch and "doubleMuTrkGroup" not in self.complained:
        if not self.doubleMuTrkGroup_branch and "doubleMuTrkGroup":
            warnings.warn( "EMuMuMuTree: Expected branch doubleMuTrkGroup does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleMuTrkGroup")
        else:
            self.doubleMuTrkGroup_branch.SetAddress(<void*>&self.doubleMuTrkGroup_value)

        #print "making doubleMuTrkPass"
        self.doubleMuTrkPass_branch = the_tree.GetBranch("doubleMuTrkPass")
        #if not self.doubleMuTrkPass_branch and "doubleMuTrkPass" not in self.complained:
        if not self.doubleMuTrkPass_branch and "doubleMuTrkPass":
            warnings.warn( "EMuMuMuTree: Expected branch doubleMuTrkPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleMuTrkPass")
        else:
            self.doubleMuTrkPass_branch.SetAddress(<void*>&self.doubleMuTrkPass_value)

        #print "making doubleMuTrkPrescale"
        self.doubleMuTrkPrescale_branch = the_tree.GetBranch("doubleMuTrkPrescale")
        #if not self.doubleMuTrkPrescale_branch and "doubleMuTrkPrescale" not in self.complained:
        if not self.doubleMuTrkPrescale_branch and "doubleMuTrkPrescale":
            warnings.warn( "EMuMuMuTree: Expected branch doubleMuTrkPrescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleMuTrkPrescale")
        else:
            self.doubleMuTrkPrescale_branch.SetAddress(<void*>&self.doubleMuTrkPrescale_value)

        #print "making doublePhoGroup"
        self.doublePhoGroup_branch = the_tree.GetBranch("doublePhoGroup")
        #if not self.doublePhoGroup_branch and "doublePhoGroup" not in self.complained:
        if not self.doublePhoGroup_branch and "doublePhoGroup":
            warnings.warn( "EMuMuMuTree: Expected branch doublePhoGroup does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doublePhoGroup")
        else:
            self.doublePhoGroup_branch.SetAddress(<void*>&self.doublePhoGroup_value)

        #print "making doublePhoPass"
        self.doublePhoPass_branch = the_tree.GetBranch("doublePhoPass")
        #if not self.doublePhoPass_branch and "doublePhoPass" not in self.complained:
        if not self.doublePhoPass_branch and "doublePhoPass":
            warnings.warn( "EMuMuMuTree: Expected branch doublePhoPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doublePhoPass")
        else:
            self.doublePhoPass_branch.SetAddress(<void*>&self.doublePhoPass_value)

        #print "making doublePhoPrescale"
        self.doublePhoPrescale_branch = the_tree.GetBranch("doublePhoPrescale")
        #if not self.doublePhoPrescale_branch and "doublePhoPrescale" not in self.complained:
        if not self.doublePhoPrescale_branch and "doublePhoPrescale":
            warnings.warn( "EMuMuMuTree: Expected branch doublePhoPrescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doublePhoPrescale")
        else:
            self.doublePhoPrescale_branch.SetAddress(<void*>&self.doublePhoPrescale_value)

        #print "making eAbsEta"
        self.eAbsEta_branch = the_tree.GetBranch("eAbsEta")
        #if not self.eAbsEta_branch and "eAbsEta" not in self.complained:
        if not self.eAbsEta_branch and "eAbsEta":
            warnings.warn( "EMuMuMuTree: Expected branch eAbsEta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eAbsEta")
        else:
            self.eAbsEta_branch.SetAddress(<void*>&self.eAbsEta_value)

        #print "making eCBID_LOOSE"
        self.eCBID_LOOSE_branch = the_tree.GetBranch("eCBID_LOOSE")
        #if not self.eCBID_LOOSE_branch and "eCBID_LOOSE" not in self.complained:
        if not self.eCBID_LOOSE_branch and "eCBID_LOOSE":
            warnings.warn( "EMuMuMuTree: Expected branch eCBID_LOOSE does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eCBID_LOOSE")
        else:
            self.eCBID_LOOSE_branch.SetAddress(<void*>&self.eCBID_LOOSE_value)

        #print "making eCBID_MEDIUM"
        self.eCBID_MEDIUM_branch = the_tree.GetBranch("eCBID_MEDIUM")
        #if not self.eCBID_MEDIUM_branch and "eCBID_MEDIUM" not in self.complained:
        if not self.eCBID_MEDIUM_branch and "eCBID_MEDIUM":
            warnings.warn( "EMuMuMuTree: Expected branch eCBID_MEDIUM does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eCBID_MEDIUM")
        else:
            self.eCBID_MEDIUM_branch.SetAddress(<void*>&self.eCBID_MEDIUM_value)

        #print "making eCBID_TIGHT"
        self.eCBID_TIGHT_branch = the_tree.GetBranch("eCBID_TIGHT")
        #if not self.eCBID_TIGHT_branch and "eCBID_TIGHT" not in self.complained:
        if not self.eCBID_TIGHT_branch and "eCBID_TIGHT":
            warnings.warn( "EMuMuMuTree: Expected branch eCBID_TIGHT does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eCBID_TIGHT")
        else:
            self.eCBID_TIGHT_branch.SetAddress(<void*>&self.eCBID_TIGHT_value)

        #print "making eCBID_VETO"
        self.eCBID_VETO_branch = the_tree.GetBranch("eCBID_VETO")
        #if not self.eCBID_VETO_branch and "eCBID_VETO" not in self.complained:
        if not self.eCBID_VETO_branch and "eCBID_VETO":
            warnings.warn( "EMuMuMuTree: Expected branch eCBID_VETO does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eCBID_VETO")
        else:
            self.eCBID_VETO_branch.SetAddress(<void*>&self.eCBID_VETO_value)

        #print "making eCharge"
        self.eCharge_branch = the_tree.GetBranch("eCharge")
        #if not self.eCharge_branch and "eCharge" not in self.complained:
        if not self.eCharge_branch and "eCharge":
            warnings.warn( "EMuMuMuTree: Expected branch eCharge does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eCharge")
        else:
            self.eCharge_branch.SetAddress(<void*>&self.eCharge_value)

        #print "making eChargeIdLoose"
        self.eChargeIdLoose_branch = the_tree.GetBranch("eChargeIdLoose")
        #if not self.eChargeIdLoose_branch and "eChargeIdLoose" not in self.complained:
        if not self.eChargeIdLoose_branch and "eChargeIdLoose":
            warnings.warn( "EMuMuMuTree: Expected branch eChargeIdLoose does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eChargeIdLoose")
        else:
            self.eChargeIdLoose_branch.SetAddress(<void*>&self.eChargeIdLoose_value)

        #print "making eChargeIdMed"
        self.eChargeIdMed_branch = the_tree.GetBranch("eChargeIdMed")
        #if not self.eChargeIdMed_branch and "eChargeIdMed" not in self.complained:
        if not self.eChargeIdMed_branch and "eChargeIdMed":
            warnings.warn( "EMuMuMuTree: Expected branch eChargeIdMed does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eChargeIdMed")
        else:
            self.eChargeIdMed_branch.SetAddress(<void*>&self.eChargeIdMed_value)

        #print "making eChargeIdTight"
        self.eChargeIdTight_branch = the_tree.GetBranch("eChargeIdTight")
        #if not self.eChargeIdTight_branch and "eChargeIdTight" not in self.complained:
        if not self.eChargeIdTight_branch and "eChargeIdTight":
            warnings.warn( "EMuMuMuTree: Expected branch eChargeIdTight does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eChargeIdTight")
        else:
            self.eChargeIdTight_branch.SetAddress(<void*>&self.eChargeIdTight_value)

        #print "making eCiCTight"
        self.eCiCTight_branch = the_tree.GetBranch("eCiCTight")
        #if not self.eCiCTight_branch and "eCiCTight" not in self.complained:
        if not self.eCiCTight_branch and "eCiCTight":
            warnings.warn( "EMuMuMuTree: Expected branch eCiCTight does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eCiCTight")
        else:
            self.eCiCTight_branch.SetAddress(<void*>&self.eCiCTight_value)

        #print "making eComesFromHiggs"
        self.eComesFromHiggs_branch = the_tree.GetBranch("eComesFromHiggs")
        #if not self.eComesFromHiggs_branch and "eComesFromHiggs" not in self.complained:
        if not self.eComesFromHiggs_branch and "eComesFromHiggs":
            warnings.warn( "EMuMuMuTree: Expected branch eComesFromHiggs does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eComesFromHiggs")
        else:
            self.eComesFromHiggs_branch.SetAddress(<void*>&self.eComesFromHiggs_value)

        #print "making eDZ"
        self.eDZ_branch = the_tree.GetBranch("eDZ")
        #if not self.eDZ_branch and "eDZ" not in self.complained:
        if not self.eDZ_branch and "eDZ":
            warnings.warn( "EMuMuMuTree: Expected branch eDZ does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eDZ")
        else:
            self.eDZ_branch.SetAddress(<void*>&self.eDZ_value)

        #print "making eE1x5"
        self.eE1x5_branch = the_tree.GetBranch("eE1x5")
        #if not self.eE1x5_branch and "eE1x5" not in self.complained:
        if not self.eE1x5_branch and "eE1x5":
            warnings.warn( "EMuMuMuTree: Expected branch eE1x5 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eE1x5")
        else:
            self.eE1x5_branch.SetAddress(<void*>&self.eE1x5_value)

        #print "making eE2x5Max"
        self.eE2x5Max_branch = the_tree.GetBranch("eE2x5Max")
        #if not self.eE2x5Max_branch and "eE2x5Max" not in self.complained:
        if not self.eE2x5Max_branch and "eE2x5Max":
            warnings.warn( "EMuMuMuTree: Expected branch eE2x5Max does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eE2x5Max")
        else:
            self.eE2x5Max_branch.SetAddress(<void*>&self.eE2x5Max_value)

        #print "making eE5x5"
        self.eE5x5_branch = the_tree.GetBranch("eE5x5")
        #if not self.eE5x5_branch and "eE5x5" not in self.complained:
        if not self.eE5x5_branch and "eE5x5":
            warnings.warn( "EMuMuMuTree: Expected branch eE5x5 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eE5x5")
        else:
            self.eE5x5_branch.SetAddress(<void*>&self.eE5x5_value)

        #print "making eECorrReg_2012Jul13ReReco"
        self.eECorrReg_2012Jul13ReReco_branch = the_tree.GetBranch("eECorrReg_2012Jul13ReReco")
        #if not self.eECorrReg_2012Jul13ReReco_branch and "eECorrReg_2012Jul13ReReco" not in self.complained:
        if not self.eECorrReg_2012Jul13ReReco_branch and "eECorrReg_2012Jul13ReReco":
            warnings.warn( "EMuMuMuTree: Expected branch eECorrReg_2012Jul13ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eECorrReg_2012Jul13ReReco")
        else:
            self.eECorrReg_2012Jul13ReReco_branch.SetAddress(<void*>&self.eECorrReg_2012Jul13ReReco_value)

        #print "making eECorrReg_Fall11"
        self.eECorrReg_Fall11_branch = the_tree.GetBranch("eECorrReg_Fall11")
        #if not self.eECorrReg_Fall11_branch and "eECorrReg_Fall11" not in self.complained:
        if not self.eECorrReg_Fall11_branch and "eECorrReg_Fall11":
            warnings.warn( "EMuMuMuTree: Expected branch eECorrReg_Fall11 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eECorrReg_Fall11")
        else:
            self.eECorrReg_Fall11_branch.SetAddress(<void*>&self.eECorrReg_Fall11_value)

        #print "making eECorrReg_Jan16ReReco"
        self.eECorrReg_Jan16ReReco_branch = the_tree.GetBranch("eECorrReg_Jan16ReReco")
        #if not self.eECorrReg_Jan16ReReco_branch and "eECorrReg_Jan16ReReco" not in self.complained:
        if not self.eECorrReg_Jan16ReReco_branch and "eECorrReg_Jan16ReReco":
            warnings.warn( "EMuMuMuTree: Expected branch eECorrReg_Jan16ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eECorrReg_Jan16ReReco")
        else:
            self.eECorrReg_Jan16ReReco_branch.SetAddress(<void*>&self.eECorrReg_Jan16ReReco_value)

        #print "making eECorrReg_Summer12_DR53X_HCP2012"
        self.eECorrReg_Summer12_DR53X_HCP2012_branch = the_tree.GetBranch("eECorrReg_Summer12_DR53X_HCP2012")
        #if not self.eECorrReg_Summer12_DR53X_HCP2012_branch and "eECorrReg_Summer12_DR53X_HCP2012" not in self.complained:
        if not self.eECorrReg_Summer12_DR53X_HCP2012_branch and "eECorrReg_Summer12_DR53X_HCP2012":
            warnings.warn( "EMuMuMuTree: Expected branch eECorrReg_Summer12_DR53X_HCP2012 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eECorrReg_Summer12_DR53X_HCP2012")
        else:
            self.eECorrReg_Summer12_DR53X_HCP2012_branch.SetAddress(<void*>&self.eECorrReg_Summer12_DR53X_HCP2012_value)

        #print "making eECorrSmearedNoReg_2012Jul13ReReco"
        self.eECorrSmearedNoReg_2012Jul13ReReco_branch = the_tree.GetBranch("eECorrSmearedNoReg_2012Jul13ReReco")
        #if not self.eECorrSmearedNoReg_2012Jul13ReReco_branch and "eECorrSmearedNoReg_2012Jul13ReReco" not in self.complained:
        if not self.eECorrSmearedNoReg_2012Jul13ReReco_branch and "eECorrSmearedNoReg_2012Jul13ReReco":
            warnings.warn( "EMuMuMuTree: Expected branch eECorrSmearedNoReg_2012Jul13ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eECorrSmearedNoReg_2012Jul13ReReco")
        else:
            self.eECorrSmearedNoReg_2012Jul13ReReco_branch.SetAddress(<void*>&self.eECorrSmearedNoReg_2012Jul13ReReco_value)

        #print "making eECorrSmearedNoReg_Fall11"
        self.eECorrSmearedNoReg_Fall11_branch = the_tree.GetBranch("eECorrSmearedNoReg_Fall11")
        #if not self.eECorrSmearedNoReg_Fall11_branch and "eECorrSmearedNoReg_Fall11" not in self.complained:
        if not self.eECorrSmearedNoReg_Fall11_branch and "eECorrSmearedNoReg_Fall11":
            warnings.warn( "EMuMuMuTree: Expected branch eECorrSmearedNoReg_Fall11 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eECorrSmearedNoReg_Fall11")
        else:
            self.eECorrSmearedNoReg_Fall11_branch.SetAddress(<void*>&self.eECorrSmearedNoReg_Fall11_value)

        #print "making eECorrSmearedNoReg_Jan16ReReco"
        self.eECorrSmearedNoReg_Jan16ReReco_branch = the_tree.GetBranch("eECorrSmearedNoReg_Jan16ReReco")
        #if not self.eECorrSmearedNoReg_Jan16ReReco_branch and "eECorrSmearedNoReg_Jan16ReReco" not in self.complained:
        if not self.eECorrSmearedNoReg_Jan16ReReco_branch and "eECorrSmearedNoReg_Jan16ReReco":
            warnings.warn( "EMuMuMuTree: Expected branch eECorrSmearedNoReg_Jan16ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eECorrSmearedNoReg_Jan16ReReco")
        else:
            self.eECorrSmearedNoReg_Jan16ReReco_branch.SetAddress(<void*>&self.eECorrSmearedNoReg_Jan16ReReco_value)

        #print "making eECorrSmearedNoReg_Summer12_DR53X_HCP2012"
        self.eECorrSmearedNoReg_Summer12_DR53X_HCP2012_branch = the_tree.GetBranch("eECorrSmearedNoReg_Summer12_DR53X_HCP2012")
        #if not self.eECorrSmearedNoReg_Summer12_DR53X_HCP2012_branch and "eECorrSmearedNoReg_Summer12_DR53X_HCP2012" not in self.complained:
        if not self.eECorrSmearedNoReg_Summer12_DR53X_HCP2012_branch and "eECorrSmearedNoReg_Summer12_DR53X_HCP2012":
            warnings.warn( "EMuMuMuTree: Expected branch eECorrSmearedNoReg_Summer12_DR53X_HCP2012 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eECorrSmearedNoReg_Summer12_DR53X_HCP2012")
        else:
            self.eECorrSmearedNoReg_Summer12_DR53X_HCP2012_branch.SetAddress(<void*>&self.eECorrSmearedNoReg_Summer12_DR53X_HCP2012_value)

        #print "making eECorrSmearedReg_2012Jul13ReReco"
        self.eECorrSmearedReg_2012Jul13ReReco_branch = the_tree.GetBranch("eECorrSmearedReg_2012Jul13ReReco")
        #if not self.eECorrSmearedReg_2012Jul13ReReco_branch and "eECorrSmearedReg_2012Jul13ReReco" not in self.complained:
        if not self.eECorrSmearedReg_2012Jul13ReReco_branch and "eECorrSmearedReg_2012Jul13ReReco":
            warnings.warn( "EMuMuMuTree: Expected branch eECorrSmearedReg_2012Jul13ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eECorrSmearedReg_2012Jul13ReReco")
        else:
            self.eECorrSmearedReg_2012Jul13ReReco_branch.SetAddress(<void*>&self.eECorrSmearedReg_2012Jul13ReReco_value)

        #print "making eECorrSmearedReg_Fall11"
        self.eECorrSmearedReg_Fall11_branch = the_tree.GetBranch("eECorrSmearedReg_Fall11")
        #if not self.eECorrSmearedReg_Fall11_branch and "eECorrSmearedReg_Fall11" not in self.complained:
        if not self.eECorrSmearedReg_Fall11_branch and "eECorrSmearedReg_Fall11":
            warnings.warn( "EMuMuMuTree: Expected branch eECorrSmearedReg_Fall11 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eECorrSmearedReg_Fall11")
        else:
            self.eECorrSmearedReg_Fall11_branch.SetAddress(<void*>&self.eECorrSmearedReg_Fall11_value)

        #print "making eECorrSmearedReg_Jan16ReReco"
        self.eECorrSmearedReg_Jan16ReReco_branch = the_tree.GetBranch("eECorrSmearedReg_Jan16ReReco")
        #if not self.eECorrSmearedReg_Jan16ReReco_branch and "eECorrSmearedReg_Jan16ReReco" not in self.complained:
        if not self.eECorrSmearedReg_Jan16ReReco_branch and "eECorrSmearedReg_Jan16ReReco":
            warnings.warn( "EMuMuMuTree: Expected branch eECorrSmearedReg_Jan16ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eECorrSmearedReg_Jan16ReReco")
        else:
            self.eECorrSmearedReg_Jan16ReReco_branch.SetAddress(<void*>&self.eECorrSmearedReg_Jan16ReReco_value)

        #print "making eECorrSmearedReg_Summer12_DR53X_HCP2012"
        self.eECorrSmearedReg_Summer12_DR53X_HCP2012_branch = the_tree.GetBranch("eECorrSmearedReg_Summer12_DR53X_HCP2012")
        #if not self.eECorrSmearedReg_Summer12_DR53X_HCP2012_branch and "eECorrSmearedReg_Summer12_DR53X_HCP2012" not in self.complained:
        if not self.eECorrSmearedReg_Summer12_DR53X_HCP2012_branch and "eECorrSmearedReg_Summer12_DR53X_HCP2012":
            warnings.warn( "EMuMuMuTree: Expected branch eECorrSmearedReg_Summer12_DR53X_HCP2012 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eECorrSmearedReg_Summer12_DR53X_HCP2012")
        else:
            self.eECorrSmearedReg_Summer12_DR53X_HCP2012_branch.SetAddress(<void*>&self.eECorrSmearedReg_Summer12_DR53X_HCP2012_value)

        #print "making eEcalIsoDR03"
        self.eEcalIsoDR03_branch = the_tree.GetBranch("eEcalIsoDR03")
        #if not self.eEcalIsoDR03_branch and "eEcalIsoDR03" not in self.complained:
        if not self.eEcalIsoDR03_branch and "eEcalIsoDR03":
            warnings.warn( "EMuMuMuTree: Expected branch eEcalIsoDR03 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eEcalIsoDR03")
        else:
            self.eEcalIsoDR03_branch.SetAddress(<void*>&self.eEcalIsoDR03_value)

        #print "making eEffectiveArea2011Data"
        self.eEffectiveArea2011Data_branch = the_tree.GetBranch("eEffectiveArea2011Data")
        #if not self.eEffectiveArea2011Data_branch and "eEffectiveArea2011Data" not in self.complained:
        if not self.eEffectiveArea2011Data_branch and "eEffectiveArea2011Data":
            warnings.warn( "EMuMuMuTree: Expected branch eEffectiveArea2011Data does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eEffectiveArea2011Data")
        else:
            self.eEffectiveArea2011Data_branch.SetAddress(<void*>&self.eEffectiveArea2011Data_value)

        #print "making eEffectiveArea2012Data"
        self.eEffectiveArea2012Data_branch = the_tree.GetBranch("eEffectiveArea2012Data")
        #if not self.eEffectiveArea2012Data_branch and "eEffectiveArea2012Data" not in self.complained:
        if not self.eEffectiveArea2012Data_branch and "eEffectiveArea2012Data":
            warnings.warn( "EMuMuMuTree: Expected branch eEffectiveArea2012Data does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eEffectiveArea2012Data")
        else:
            self.eEffectiveArea2012Data_branch.SetAddress(<void*>&self.eEffectiveArea2012Data_value)

        #print "making eEffectiveAreaFall11MC"
        self.eEffectiveAreaFall11MC_branch = the_tree.GetBranch("eEffectiveAreaFall11MC")
        #if not self.eEffectiveAreaFall11MC_branch and "eEffectiveAreaFall11MC" not in self.complained:
        if not self.eEffectiveAreaFall11MC_branch and "eEffectiveAreaFall11MC":
            warnings.warn( "EMuMuMuTree: Expected branch eEffectiveAreaFall11MC does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eEffectiveAreaFall11MC")
        else:
            self.eEffectiveAreaFall11MC_branch.SetAddress(<void*>&self.eEffectiveAreaFall11MC_value)

        #print "making eEle27WP80PFMT50PFMTFilter"
        self.eEle27WP80PFMT50PFMTFilter_branch = the_tree.GetBranch("eEle27WP80PFMT50PFMTFilter")
        #if not self.eEle27WP80PFMT50PFMTFilter_branch and "eEle27WP80PFMT50PFMTFilter" not in self.complained:
        if not self.eEle27WP80PFMT50PFMTFilter_branch and "eEle27WP80PFMT50PFMTFilter":
            warnings.warn( "EMuMuMuTree: Expected branch eEle27WP80PFMT50PFMTFilter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eEle27WP80PFMT50PFMTFilter")
        else:
            self.eEle27WP80PFMT50PFMTFilter_branch.SetAddress(<void*>&self.eEle27WP80PFMT50PFMTFilter_value)

        #print "making eEle27WP80TrackIsoMatchFilter"
        self.eEle27WP80TrackIsoMatchFilter_branch = the_tree.GetBranch("eEle27WP80TrackIsoMatchFilter")
        #if not self.eEle27WP80TrackIsoMatchFilter_branch and "eEle27WP80TrackIsoMatchFilter" not in self.complained:
        if not self.eEle27WP80TrackIsoMatchFilter_branch and "eEle27WP80TrackIsoMatchFilter":
            warnings.warn( "EMuMuMuTree: Expected branch eEle27WP80TrackIsoMatchFilter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eEle27WP80TrackIsoMatchFilter")
        else:
            self.eEle27WP80TrackIsoMatchFilter_branch.SetAddress(<void*>&self.eEle27WP80TrackIsoMatchFilter_value)

        #print "making eEle32WP70PFMT50PFMTFilter"
        self.eEle32WP70PFMT50PFMTFilter_branch = the_tree.GetBranch("eEle32WP70PFMT50PFMTFilter")
        #if not self.eEle32WP70PFMT50PFMTFilter_branch and "eEle32WP70PFMT50PFMTFilter" not in self.complained:
        if not self.eEle32WP70PFMT50PFMTFilter_branch and "eEle32WP70PFMT50PFMTFilter":
            warnings.warn( "EMuMuMuTree: Expected branch eEle32WP70PFMT50PFMTFilter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eEle32WP70PFMT50PFMTFilter")
        else:
            self.eEle32WP70PFMT50PFMTFilter_branch.SetAddress(<void*>&self.eEle32WP70PFMT50PFMTFilter_value)

        #print "making eEnergyError"
        self.eEnergyError_branch = the_tree.GetBranch("eEnergyError")
        #if not self.eEnergyError_branch and "eEnergyError" not in self.complained:
        if not self.eEnergyError_branch and "eEnergyError":
            warnings.warn( "EMuMuMuTree: Expected branch eEnergyError does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eEnergyError")
        else:
            self.eEnergyError_branch.SetAddress(<void*>&self.eEnergyError_value)

        #print "making eEta"
        self.eEta_branch = the_tree.GetBranch("eEta")
        #if not self.eEta_branch and "eEta" not in self.complained:
        if not self.eEta_branch and "eEta":
            warnings.warn( "EMuMuMuTree: Expected branch eEta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eEta")
        else:
            self.eEta_branch.SetAddress(<void*>&self.eEta_value)

        #print "making eEtaCorrReg_2012Jul13ReReco"
        self.eEtaCorrReg_2012Jul13ReReco_branch = the_tree.GetBranch("eEtaCorrReg_2012Jul13ReReco")
        #if not self.eEtaCorrReg_2012Jul13ReReco_branch and "eEtaCorrReg_2012Jul13ReReco" not in self.complained:
        if not self.eEtaCorrReg_2012Jul13ReReco_branch and "eEtaCorrReg_2012Jul13ReReco":
            warnings.warn( "EMuMuMuTree: Expected branch eEtaCorrReg_2012Jul13ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eEtaCorrReg_2012Jul13ReReco")
        else:
            self.eEtaCorrReg_2012Jul13ReReco_branch.SetAddress(<void*>&self.eEtaCorrReg_2012Jul13ReReco_value)

        #print "making eEtaCorrReg_Fall11"
        self.eEtaCorrReg_Fall11_branch = the_tree.GetBranch("eEtaCorrReg_Fall11")
        #if not self.eEtaCorrReg_Fall11_branch and "eEtaCorrReg_Fall11" not in self.complained:
        if not self.eEtaCorrReg_Fall11_branch and "eEtaCorrReg_Fall11":
            warnings.warn( "EMuMuMuTree: Expected branch eEtaCorrReg_Fall11 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eEtaCorrReg_Fall11")
        else:
            self.eEtaCorrReg_Fall11_branch.SetAddress(<void*>&self.eEtaCorrReg_Fall11_value)

        #print "making eEtaCorrReg_Jan16ReReco"
        self.eEtaCorrReg_Jan16ReReco_branch = the_tree.GetBranch("eEtaCorrReg_Jan16ReReco")
        #if not self.eEtaCorrReg_Jan16ReReco_branch and "eEtaCorrReg_Jan16ReReco" not in self.complained:
        if not self.eEtaCorrReg_Jan16ReReco_branch and "eEtaCorrReg_Jan16ReReco":
            warnings.warn( "EMuMuMuTree: Expected branch eEtaCorrReg_Jan16ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eEtaCorrReg_Jan16ReReco")
        else:
            self.eEtaCorrReg_Jan16ReReco_branch.SetAddress(<void*>&self.eEtaCorrReg_Jan16ReReco_value)

        #print "making eEtaCorrReg_Summer12_DR53X_HCP2012"
        self.eEtaCorrReg_Summer12_DR53X_HCP2012_branch = the_tree.GetBranch("eEtaCorrReg_Summer12_DR53X_HCP2012")
        #if not self.eEtaCorrReg_Summer12_DR53X_HCP2012_branch and "eEtaCorrReg_Summer12_DR53X_HCP2012" not in self.complained:
        if not self.eEtaCorrReg_Summer12_DR53X_HCP2012_branch and "eEtaCorrReg_Summer12_DR53X_HCP2012":
            warnings.warn( "EMuMuMuTree: Expected branch eEtaCorrReg_Summer12_DR53X_HCP2012 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eEtaCorrReg_Summer12_DR53X_HCP2012")
        else:
            self.eEtaCorrReg_Summer12_DR53X_HCP2012_branch.SetAddress(<void*>&self.eEtaCorrReg_Summer12_DR53X_HCP2012_value)

        #print "making eEtaCorrSmearedNoReg_2012Jul13ReReco"
        self.eEtaCorrSmearedNoReg_2012Jul13ReReco_branch = the_tree.GetBranch("eEtaCorrSmearedNoReg_2012Jul13ReReco")
        #if not self.eEtaCorrSmearedNoReg_2012Jul13ReReco_branch and "eEtaCorrSmearedNoReg_2012Jul13ReReco" not in self.complained:
        if not self.eEtaCorrSmearedNoReg_2012Jul13ReReco_branch and "eEtaCorrSmearedNoReg_2012Jul13ReReco":
            warnings.warn( "EMuMuMuTree: Expected branch eEtaCorrSmearedNoReg_2012Jul13ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eEtaCorrSmearedNoReg_2012Jul13ReReco")
        else:
            self.eEtaCorrSmearedNoReg_2012Jul13ReReco_branch.SetAddress(<void*>&self.eEtaCorrSmearedNoReg_2012Jul13ReReco_value)

        #print "making eEtaCorrSmearedNoReg_Fall11"
        self.eEtaCorrSmearedNoReg_Fall11_branch = the_tree.GetBranch("eEtaCorrSmearedNoReg_Fall11")
        #if not self.eEtaCorrSmearedNoReg_Fall11_branch and "eEtaCorrSmearedNoReg_Fall11" not in self.complained:
        if not self.eEtaCorrSmearedNoReg_Fall11_branch and "eEtaCorrSmearedNoReg_Fall11":
            warnings.warn( "EMuMuMuTree: Expected branch eEtaCorrSmearedNoReg_Fall11 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eEtaCorrSmearedNoReg_Fall11")
        else:
            self.eEtaCorrSmearedNoReg_Fall11_branch.SetAddress(<void*>&self.eEtaCorrSmearedNoReg_Fall11_value)

        #print "making eEtaCorrSmearedNoReg_Jan16ReReco"
        self.eEtaCorrSmearedNoReg_Jan16ReReco_branch = the_tree.GetBranch("eEtaCorrSmearedNoReg_Jan16ReReco")
        #if not self.eEtaCorrSmearedNoReg_Jan16ReReco_branch and "eEtaCorrSmearedNoReg_Jan16ReReco" not in self.complained:
        if not self.eEtaCorrSmearedNoReg_Jan16ReReco_branch and "eEtaCorrSmearedNoReg_Jan16ReReco":
            warnings.warn( "EMuMuMuTree: Expected branch eEtaCorrSmearedNoReg_Jan16ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eEtaCorrSmearedNoReg_Jan16ReReco")
        else:
            self.eEtaCorrSmearedNoReg_Jan16ReReco_branch.SetAddress(<void*>&self.eEtaCorrSmearedNoReg_Jan16ReReco_value)

        #print "making eEtaCorrSmearedNoReg_Summer12_DR53X_HCP2012"
        self.eEtaCorrSmearedNoReg_Summer12_DR53X_HCP2012_branch = the_tree.GetBranch("eEtaCorrSmearedNoReg_Summer12_DR53X_HCP2012")
        #if not self.eEtaCorrSmearedNoReg_Summer12_DR53X_HCP2012_branch and "eEtaCorrSmearedNoReg_Summer12_DR53X_HCP2012" not in self.complained:
        if not self.eEtaCorrSmearedNoReg_Summer12_DR53X_HCP2012_branch and "eEtaCorrSmearedNoReg_Summer12_DR53X_HCP2012":
            warnings.warn( "EMuMuMuTree: Expected branch eEtaCorrSmearedNoReg_Summer12_DR53X_HCP2012 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eEtaCorrSmearedNoReg_Summer12_DR53X_HCP2012")
        else:
            self.eEtaCorrSmearedNoReg_Summer12_DR53X_HCP2012_branch.SetAddress(<void*>&self.eEtaCorrSmearedNoReg_Summer12_DR53X_HCP2012_value)

        #print "making eEtaCorrSmearedReg_2012Jul13ReReco"
        self.eEtaCorrSmearedReg_2012Jul13ReReco_branch = the_tree.GetBranch("eEtaCorrSmearedReg_2012Jul13ReReco")
        #if not self.eEtaCorrSmearedReg_2012Jul13ReReco_branch and "eEtaCorrSmearedReg_2012Jul13ReReco" not in self.complained:
        if not self.eEtaCorrSmearedReg_2012Jul13ReReco_branch and "eEtaCorrSmearedReg_2012Jul13ReReco":
            warnings.warn( "EMuMuMuTree: Expected branch eEtaCorrSmearedReg_2012Jul13ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eEtaCorrSmearedReg_2012Jul13ReReco")
        else:
            self.eEtaCorrSmearedReg_2012Jul13ReReco_branch.SetAddress(<void*>&self.eEtaCorrSmearedReg_2012Jul13ReReco_value)

        #print "making eEtaCorrSmearedReg_Fall11"
        self.eEtaCorrSmearedReg_Fall11_branch = the_tree.GetBranch("eEtaCorrSmearedReg_Fall11")
        #if not self.eEtaCorrSmearedReg_Fall11_branch and "eEtaCorrSmearedReg_Fall11" not in self.complained:
        if not self.eEtaCorrSmearedReg_Fall11_branch and "eEtaCorrSmearedReg_Fall11":
            warnings.warn( "EMuMuMuTree: Expected branch eEtaCorrSmearedReg_Fall11 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eEtaCorrSmearedReg_Fall11")
        else:
            self.eEtaCorrSmearedReg_Fall11_branch.SetAddress(<void*>&self.eEtaCorrSmearedReg_Fall11_value)

        #print "making eEtaCorrSmearedReg_Jan16ReReco"
        self.eEtaCorrSmearedReg_Jan16ReReco_branch = the_tree.GetBranch("eEtaCorrSmearedReg_Jan16ReReco")
        #if not self.eEtaCorrSmearedReg_Jan16ReReco_branch and "eEtaCorrSmearedReg_Jan16ReReco" not in self.complained:
        if not self.eEtaCorrSmearedReg_Jan16ReReco_branch and "eEtaCorrSmearedReg_Jan16ReReco":
            warnings.warn( "EMuMuMuTree: Expected branch eEtaCorrSmearedReg_Jan16ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eEtaCorrSmearedReg_Jan16ReReco")
        else:
            self.eEtaCorrSmearedReg_Jan16ReReco_branch.SetAddress(<void*>&self.eEtaCorrSmearedReg_Jan16ReReco_value)

        #print "making eEtaCorrSmearedReg_Summer12_DR53X_HCP2012"
        self.eEtaCorrSmearedReg_Summer12_DR53X_HCP2012_branch = the_tree.GetBranch("eEtaCorrSmearedReg_Summer12_DR53X_HCP2012")
        #if not self.eEtaCorrSmearedReg_Summer12_DR53X_HCP2012_branch and "eEtaCorrSmearedReg_Summer12_DR53X_HCP2012" not in self.complained:
        if not self.eEtaCorrSmearedReg_Summer12_DR53X_HCP2012_branch and "eEtaCorrSmearedReg_Summer12_DR53X_HCP2012":
            warnings.warn( "EMuMuMuTree: Expected branch eEtaCorrSmearedReg_Summer12_DR53X_HCP2012 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eEtaCorrSmearedReg_Summer12_DR53X_HCP2012")
        else:
            self.eEtaCorrSmearedReg_Summer12_DR53X_HCP2012_branch.SetAddress(<void*>&self.eEtaCorrSmearedReg_Summer12_DR53X_HCP2012_value)

        #print "making eGenCharge"
        self.eGenCharge_branch = the_tree.GetBranch("eGenCharge")
        #if not self.eGenCharge_branch and "eGenCharge" not in self.complained:
        if not self.eGenCharge_branch and "eGenCharge":
            warnings.warn( "EMuMuMuTree: Expected branch eGenCharge does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eGenCharge")
        else:
            self.eGenCharge_branch.SetAddress(<void*>&self.eGenCharge_value)

        #print "making eGenEnergy"
        self.eGenEnergy_branch = the_tree.GetBranch("eGenEnergy")
        #if not self.eGenEnergy_branch and "eGenEnergy" not in self.complained:
        if not self.eGenEnergy_branch and "eGenEnergy":
            warnings.warn( "EMuMuMuTree: Expected branch eGenEnergy does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eGenEnergy")
        else:
            self.eGenEnergy_branch.SetAddress(<void*>&self.eGenEnergy_value)

        #print "making eGenEta"
        self.eGenEta_branch = the_tree.GetBranch("eGenEta")
        #if not self.eGenEta_branch and "eGenEta" not in self.complained:
        if not self.eGenEta_branch and "eGenEta":
            warnings.warn( "EMuMuMuTree: Expected branch eGenEta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eGenEta")
        else:
            self.eGenEta_branch.SetAddress(<void*>&self.eGenEta_value)

        #print "making eGenMotherPdgId"
        self.eGenMotherPdgId_branch = the_tree.GetBranch("eGenMotherPdgId")
        #if not self.eGenMotherPdgId_branch and "eGenMotherPdgId" not in self.complained:
        if not self.eGenMotherPdgId_branch and "eGenMotherPdgId":
            warnings.warn( "EMuMuMuTree: Expected branch eGenMotherPdgId does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eGenMotherPdgId")
        else:
            self.eGenMotherPdgId_branch.SetAddress(<void*>&self.eGenMotherPdgId_value)

        #print "making eGenPdgId"
        self.eGenPdgId_branch = the_tree.GetBranch("eGenPdgId")
        #if not self.eGenPdgId_branch and "eGenPdgId" not in self.complained:
        if not self.eGenPdgId_branch and "eGenPdgId":
            warnings.warn( "EMuMuMuTree: Expected branch eGenPdgId does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eGenPdgId")
        else:
            self.eGenPdgId_branch.SetAddress(<void*>&self.eGenPdgId_value)

        #print "making eGenPhi"
        self.eGenPhi_branch = the_tree.GetBranch("eGenPhi")
        #if not self.eGenPhi_branch and "eGenPhi" not in self.complained:
        if not self.eGenPhi_branch and "eGenPhi":
            warnings.warn( "EMuMuMuTree: Expected branch eGenPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eGenPhi")
        else:
            self.eGenPhi_branch.SetAddress(<void*>&self.eGenPhi_value)

        #print "making eHadronicDepth1OverEm"
        self.eHadronicDepth1OverEm_branch = the_tree.GetBranch("eHadronicDepth1OverEm")
        #if not self.eHadronicDepth1OverEm_branch and "eHadronicDepth1OverEm" not in self.complained:
        if not self.eHadronicDepth1OverEm_branch and "eHadronicDepth1OverEm":
            warnings.warn( "EMuMuMuTree: Expected branch eHadronicDepth1OverEm does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eHadronicDepth1OverEm")
        else:
            self.eHadronicDepth1OverEm_branch.SetAddress(<void*>&self.eHadronicDepth1OverEm_value)

        #print "making eHadronicDepth2OverEm"
        self.eHadronicDepth2OverEm_branch = the_tree.GetBranch("eHadronicDepth2OverEm")
        #if not self.eHadronicDepth2OverEm_branch and "eHadronicDepth2OverEm" not in self.complained:
        if not self.eHadronicDepth2OverEm_branch and "eHadronicDepth2OverEm":
            warnings.warn( "EMuMuMuTree: Expected branch eHadronicDepth2OverEm does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eHadronicDepth2OverEm")
        else:
            self.eHadronicDepth2OverEm_branch.SetAddress(<void*>&self.eHadronicDepth2OverEm_value)

        #print "making eHadronicOverEM"
        self.eHadronicOverEM_branch = the_tree.GetBranch("eHadronicOverEM")
        #if not self.eHadronicOverEM_branch and "eHadronicOverEM" not in self.complained:
        if not self.eHadronicOverEM_branch and "eHadronicOverEM":
            warnings.warn( "EMuMuMuTree: Expected branch eHadronicOverEM does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eHadronicOverEM")
        else:
            self.eHadronicOverEM_branch.SetAddress(<void*>&self.eHadronicOverEM_value)

        #print "making eHasConversion"
        self.eHasConversion_branch = the_tree.GetBranch("eHasConversion")
        #if not self.eHasConversion_branch and "eHasConversion" not in self.complained:
        if not self.eHasConversion_branch and "eHasConversion":
            warnings.warn( "EMuMuMuTree: Expected branch eHasConversion does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eHasConversion")
        else:
            self.eHasConversion_branch.SetAddress(<void*>&self.eHasConversion_value)

        #print "making eHasMatchedConversion"
        self.eHasMatchedConversion_branch = the_tree.GetBranch("eHasMatchedConversion")
        #if not self.eHasMatchedConversion_branch and "eHasMatchedConversion" not in self.complained:
        if not self.eHasMatchedConversion_branch and "eHasMatchedConversion":
            warnings.warn( "EMuMuMuTree: Expected branch eHasMatchedConversion does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eHasMatchedConversion")
        else:
            self.eHasMatchedConversion_branch.SetAddress(<void*>&self.eHasMatchedConversion_value)

        #print "making eHcalIsoDR03"
        self.eHcalIsoDR03_branch = the_tree.GetBranch("eHcalIsoDR03")
        #if not self.eHcalIsoDR03_branch and "eHcalIsoDR03" not in self.complained:
        if not self.eHcalIsoDR03_branch and "eHcalIsoDR03":
            warnings.warn( "EMuMuMuTree: Expected branch eHcalIsoDR03 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eHcalIsoDR03")
        else:
            self.eHcalIsoDR03_branch.SetAddress(<void*>&self.eHcalIsoDR03_value)

        #print "making eIP3DS"
        self.eIP3DS_branch = the_tree.GetBranch("eIP3DS")
        #if not self.eIP3DS_branch and "eIP3DS" not in self.complained:
        if not self.eIP3DS_branch and "eIP3DS":
            warnings.warn( "EMuMuMuTree: Expected branch eIP3DS does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eIP3DS")
        else:
            self.eIP3DS_branch.SetAddress(<void*>&self.eIP3DS_value)

        #print "making eJetArea"
        self.eJetArea_branch = the_tree.GetBranch("eJetArea")
        #if not self.eJetArea_branch and "eJetArea" not in self.complained:
        if not self.eJetArea_branch and "eJetArea":
            warnings.warn( "EMuMuMuTree: Expected branch eJetArea does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eJetArea")
        else:
            self.eJetArea_branch.SetAddress(<void*>&self.eJetArea_value)

        #print "making eJetBtag"
        self.eJetBtag_branch = the_tree.GetBranch("eJetBtag")
        #if not self.eJetBtag_branch and "eJetBtag" not in self.complained:
        if not self.eJetBtag_branch and "eJetBtag":
            warnings.warn( "EMuMuMuTree: Expected branch eJetBtag does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eJetBtag")
        else:
            self.eJetBtag_branch.SetAddress(<void*>&self.eJetBtag_value)

        #print "making eJetCSVBtag"
        self.eJetCSVBtag_branch = the_tree.GetBranch("eJetCSVBtag")
        #if not self.eJetCSVBtag_branch and "eJetCSVBtag" not in self.complained:
        if not self.eJetCSVBtag_branch and "eJetCSVBtag":
            warnings.warn( "EMuMuMuTree: Expected branch eJetCSVBtag does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eJetCSVBtag")
        else:
            self.eJetCSVBtag_branch.SetAddress(<void*>&self.eJetCSVBtag_value)

        #print "making eJetEtaEtaMoment"
        self.eJetEtaEtaMoment_branch = the_tree.GetBranch("eJetEtaEtaMoment")
        #if not self.eJetEtaEtaMoment_branch and "eJetEtaEtaMoment" not in self.complained:
        if not self.eJetEtaEtaMoment_branch and "eJetEtaEtaMoment":
            warnings.warn( "EMuMuMuTree: Expected branch eJetEtaEtaMoment does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eJetEtaEtaMoment")
        else:
            self.eJetEtaEtaMoment_branch.SetAddress(<void*>&self.eJetEtaEtaMoment_value)

        #print "making eJetEtaPhiMoment"
        self.eJetEtaPhiMoment_branch = the_tree.GetBranch("eJetEtaPhiMoment")
        #if not self.eJetEtaPhiMoment_branch and "eJetEtaPhiMoment" not in self.complained:
        if not self.eJetEtaPhiMoment_branch and "eJetEtaPhiMoment":
            warnings.warn( "EMuMuMuTree: Expected branch eJetEtaPhiMoment does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eJetEtaPhiMoment")
        else:
            self.eJetEtaPhiMoment_branch.SetAddress(<void*>&self.eJetEtaPhiMoment_value)

        #print "making eJetEtaPhiSpread"
        self.eJetEtaPhiSpread_branch = the_tree.GetBranch("eJetEtaPhiSpread")
        #if not self.eJetEtaPhiSpread_branch and "eJetEtaPhiSpread" not in self.complained:
        if not self.eJetEtaPhiSpread_branch and "eJetEtaPhiSpread":
            warnings.warn( "EMuMuMuTree: Expected branch eJetEtaPhiSpread does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eJetEtaPhiSpread")
        else:
            self.eJetEtaPhiSpread_branch.SetAddress(<void*>&self.eJetEtaPhiSpread_value)

        #print "making eJetPartonFlavour"
        self.eJetPartonFlavour_branch = the_tree.GetBranch("eJetPartonFlavour")
        #if not self.eJetPartonFlavour_branch and "eJetPartonFlavour" not in self.complained:
        if not self.eJetPartonFlavour_branch and "eJetPartonFlavour":
            warnings.warn( "EMuMuMuTree: Expected branch eJetPartonFlavour does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eJetPartonFlavour")
        else:
            self.eJetPartonFlavour_branch.SetAddress(<void*>&self.eJetPartonFlavour_value)

        #print "making eJetPhiPhiMoment"
        self.eJetPhiPhiMoment_branch = the_tree.GetBranch("eJetPhiPhiMoment")
        #if not self.eJetPhiPhiMoment_branch and "eJetPhiPhiMoment" not in self.complained:
        if not self.eJetPhiPhiMoment_branch and "eJetPhiPhiMoment":
            warnings.warn( "EMuMuMuTree: Expected branch eJetPhiPhiMoment does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eJetPhiPhiMoment")
        else:
            self.eJetPhiPhiMoment_branch.SetAddress(<void*>&self.eJetPhiPhiMoment_value)

        #print "making eJetPt"
        self.eJetPt_branch = the_tree.GetBranch("eJetPt")
        #if not self.eJetPt_branch and "eJetPt" not in self.complained:
        if not self.eJetPt_branch and "eJetPt":
            warnings.warn( "EMuMuMuTree: Expected branch eJetPt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eJetPt")
        else:
            self.eJetPt_branch.SetAddress(<void*>&self.eJetPt_value)

        #print "making eJetQGLikelihoodID"
        self.eJetQGLikelihoodID_branch = the_tree.GetBranch("eJetQGLikelihoodID")
        #if not self.eJetQGLikelihoodID_branch and "eJetQGLikelihoodID" not in self.complained:
        if not self.eJetQGLikelihoodID_branch and "eJetQGLikelihoodID":
            warnings.warn( "EMuMuMuTree: Expected branch eJetQGLikelihoodID does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eJetQGLikelihoodID")
        else:
            self.eJetQGLikelihoodID_branch.SetAddress(<void*>&self.eJetQGLikelihoodID_value)

        #print "making eJetQGMVAID"
        self.eJetQGMVAID_branch = the_tree.GetBranch("eJetQGMVAID")
        #if not self.eJetQGMVAID_branch and "eJetQGMVAID" not in self.complained:
        if not self.eJetQGMVAID_branch and "eJetQGMVAID":
            warnings.warn( "EMuMuMuTree: Expected branch eJetQGMVAID does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eJetQGMVAID")
        else:
            self.eJetQGMVAID_branch.SetAddress(<void*>&self.eJetQGMVAID_value)

        #print "making eJetaxis1"
        self.eJetaxis1_branch = the_tree.GetBranch("eJetaxis1")
        #if not self.eJetaxis1_branch and "eJetaxis1" not in self.complained:
        if not self.eJetaxis1_branch and "eJetaxis1":
            warnings.warn( "EMuMuMuTree: Expected branch eJetaxis1 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eJetaxis1")
        else:
            self.eJetaxis1_branch.SetAddress(<void*>&self.eJetaxis1_value)

        #print "making eJetaxis2"
        self.eJetaxis2_branch = the_tree.GetBranch("eJetaxis2")
        #if not self.eJetaxis2_branch and "eJetaxis2" not in self.complained:
        if not self.eJetaxis2_branch and "eJetaxis2":
            warnings.warn( "EMuMuMuTree: Expected branch eJetaxis2 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eJetaxis2")
        else:
            self.eJetaxis2_branch.SetAddress(<void*>&self.eJetaxis2_value)

        #print "making eJetmult"
        self.eJetmult_branch = the_tree.GetBranch("eJetmult")
        #if not self.eJetmult_branch and "eJetmult" not in self.complained:
        if not self.eJetmult_branch and "eJetmult":
            warnings.warn( "EMuMuMuTree: Expected branch eJetmult does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eJetmult")
        else:
            self.eJetmult_branch.SetAddress(<void*>&self.eJetmult_value)

        #print "making eJetmultMLP"
        self.eJetmultMLP_branch = the_tree.GetBranch("eJetmultMLP")
        #if not self.eJetmultMLP_branch and "eJetmultMLP" not in self.complained:
        if not self.eJetmultMLP_branch and "eJetmultMLP":
            warnings.warn( "EMuMuMuTree: Expected branch eJetmultMLP does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eJetmultMLP")
        else:
            self.eJetmultMLP_branch.SetAddress(<void*>&self.eJetmultMLP_value)

        #print "making eJetmultMLPQC"
        self.eJetmultMLPQC_branch = the_tree.GetBranch("eJetmultMLPQC")
        #if not self.eJetmultMLPQC_branch and "eJetmultMLPQC" not in self.complained:
        if not self.eJetmultMLPQC_branch and "eJetmultMLPQC":
            warnings.warn( "EMuMuMuTree: Expected branch eJetmultMLPQC does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eJetmultMLPQC")
        else:
            self.eJetmultMLPQC_branch.SetAddress(<void*>&self.eJetmultMLPQC_value)

        #print "making eJetptD"
        self.eJetptD_branch = the_tree.GetBranch("eJetptD")
        #if not self.eJetptD_branch and "eJetptD" not in self.complained:
        if not self.eJetptD_branch and "eJetptD":
            warnings.warn( "EMuMuMuTree: Expected branch eJetptD does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eJetptD")
        else:
            self.eJetptD_branch.SetAddress(<void*>&self.eJetptD_value)

        #print "making eL1NonIsoHLTNonIsoMu17Ele8PixelMatchFilter"
        self.eL1NonIsoHLTNonIsoMu17Ele8PixelMatchFilter_branch = the_tree.GetBranch("eL1NonIsoHLTNonIsoMu17Ele8PixelMatchFilter")
        #if not self.eL1NonIsoHLTNonIsoMu17Ele8PixelMatchFilter_branch and "eL1NonIsoHLTNonIsoMu17Ele8PixelMatchFilter" not in self.complained:
        if not self.eL1NonIsoHLTNonIsoMu17Ele8PixelMatchFilter_branch and "eL1NonIsoHLTNonIsoMu17Ele8PixelMatchFilter":
            warnings.warn( "EMuMuMuTree: Expected branch eL1NonIsoHLTNonIsoMu17Ele8PixelMatchFilter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eL1NonIsoHLTNonIsoMu17Ele8PixelMatchFilter")
        else:
            self.eL1NonIsoHLTNonIsoMu17Ele8PixelMatchFilter_branch.SetAddress(<void*>&self.eL1NonIsoHLTNonIsoMu17Ele8PixelMatchFilter_value)

        #print "making eMITID"
        self.eMITID_branch = the_tree.GetBranch("eMITID")
        #if not self.eMITID_branch and "eMITID" not in self.complained:
        if not self.eMITID_branch and "eMITID":
            warnings.warn( "EMuMuMuTree: Expected branch eMITID does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eMITID")
        else:
            self.eMITID_branch.SetAddress(<void*>&self.eMITID_value)

        #print "making eMVAIDH2TauWP"
        self.eMVAIDH2TauWP_branch = the_tree.GetBranch("eMVAIDH2TauWP")
        #if not self.eMVAIDH2TauWP_branch and "eMVAIDH2TauWP" not in self.complained:
        if not self.eMVAIDH2TauWP_branch and "eMVAIDH2TauWP":
            warnings.warn( "EMuMuMuTree: Expected branch eMVAIDH2TauWP does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eMVAIDH2TauWP")
        else:
            self.eMVAIDH2TauWP_branch.SetAddress(<void*>&self.eMVAIDH2TauWP_value)

        #print "making eMVANonTrig"
        self.eMVANonTrig_branch = the_tree.GetBranch("eMVANonTrig")
        #if not self.eMVANonTrig_branch and "eMVANonTrig" not in self.complained:
        if not self.eMVANonTrig_branch and "eMVANonTrig":
            warnings.warn( "EMuMuMuTree: Expected branch eMVANonTrig does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eMVANonTrig")
        else:
            self.eMVANonTrig_branch.SetAddress(<void*>&self.eMVANonTrig_value)

        #print "making eMVATrig"
        self.eMVATrig_branch = the_tree.GetBranch("eMVATrig")
        #if not self.eMVATrig_branch and "eMVATrig" not in self.complained:
        if not self.eMVATrig_branch and "eMVATrig":
            warnings.warn( "EMuMuMuTree: Expected branch eMVATrig does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eMVATrig")
        else:
            self.eMVATrig_branch.SetAddress(<void*>&self.eMVATrig_value)

        #print "making eMVATrigIDISO"
        self.eMVATrigIDISO_branch = the_tree.GetBranch("eMVATrigIDISO")
        #if not self.eMVATrigIDISO_branch and "eMVATrigIDISO" not in self.complained:
        if not self.eMVATrigIDISO_branch and "eMVATrigIDISO":
            warnings.warn( "EMuMuMuTree: Expected branch eMVATrigIDISO does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eMVATrigIDISO")
        else:
            self.eMVATrigIDISO_branch.SetAddress(<void*>&self.eMVATrigIDISO_value)

        #print "making eMVATrigIDISOPUSUB"
        self.eMVATrigIDISOPUSUB_branch = the_tree.GetBranch("eMVATrigIDISOPUSUB")
        #if not self.eMVATrigIDISOPUSUB_branch and "eMVATrigIDISOPUSUB" not in self.complained:
        if not self.eMVATrigIDISOPUSUB_branch and "eMVATrigIDISOPUSUB":
            warnings.warn( "EMuMuMuTree: Expected branch eMVATrigIDISOPUSUB does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eMVATrigIDISOPUSUB")
        else:
            self.eMVATrigIDISOPUSUB_branch.SetAddress(<void*>&self.eMVATrigIDISOPUSUB_value)

        #print "making eMVATrigNoIP"
        self.eMVATrigNoIP_branch = the_tree.GetBranch("eMVATrigNoIP")
        #if not self.eMVATrigNoIP_branch and "eMVATrigNoIP" not in self.complained:
        if not self.eMVATrigNoIP_branch and "eMVATrigNoIP":
            warnings.warn( "EMuMuMuTree: Expected branch eMVATrigNoIP does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eMVATrigNoIP")
        else:
            self.eMVATrigNoIP_branch.SetAddress(<void*>&self.eMVATrigNoIP_value)

        #print "making eMass"
        self.eMass_branch = the_tree.GetBranch("eMass")
        #if not self.eMass_branch and "eMass" not in self.complained:
        if not self.eMass_branch and "eMass":
            warnings.warn( "EMuMuMuTree: Expected branch eMass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eMass")
        else:
            self.eMass_branch.SetAddress(<void*>&self.eMass_value)

        #print "making eMatchesDoubleEPath"
        self.eMatchesDoubleEPath_branch = the_tree.GetBranch("eMatchesDoubleEPath")
        #if not self.eMatchesDoubleEPath_branch and "eMatchesDoubleEPath" not in self.complained:
        if not self.eMatchesDoubleEPath_branch and "eMatchesDoubleEPath":
            warnings.warn( "EMuMuMuTree: Expected branch eMatchesDoubleEPath does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eMatchesDoubleEPath")
        else:
            self.eMatchesDoubleEPath_branch.SetAddress(<void*>&self.eMatchesDoubleEPath_value)

        #print "making eMatchesMu17Ele8IsoPath"
        self.eMatchesMu17Ele8IsoPath_branch = the_tree.GetBranch("eMatchesMu17Ele8IsoPath")
        #if not self.eMatchesMu17Ele8IsoPath_branch and "eMatchesMu17Ele8IsoPath" not in self.complained:
        if not self.eMatchesMu17Ele8IsoPath_branch and "eMatchesMu17Ele8IsoPath":
            warnings.warn( "EMuMuMuTree: Expected branch eMatchesMu17Ele8IsoPath does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eMatchesMu17Ele8IsoPath")
        else:
            self.eMatchesMu17Ele8IsoPath_branch.SetAddress(<void*>&self.eMatchesMu17Ele8IsoPath_value)

        #print "making eMatchesMu17Ele8Path"
        self.eMatchesMu17Ele8Path_branch = the_tree.GetBranch("eMatchesMu17Ele8Path")
        #if not self.eMatchesMu17Ele8Path_branch and "eMatchesMu17Ele8Path" not in self.complained:
        if not self.eMatchesMu17Ele8Path_branch and "eMatchesMu17Ele8Path":
            warnings.warn( "EMuMuMuTree: Expected branch eMatchesMu17Ele8Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eMatchesMu17Ele8Path")
        else:
            self.eMatchesMu17Ele8Path_branch.SetAddress(<void*>&self.eMatchesMu17Ele8Path_value)

        #print "making eMatchesMu8Ele17IsoPath"
        self.eMatchesMu8Ele17IsoPath_branch = the_tree.GetBranch("eMatchesMu8Ele17IsoPath")
        #if not self.eMatchesMu8Ele17IsoPath_branch and "eMatchesMu8Ele17IsoPath" not in self.complained:
        if not self.eMatchesMu8Ele17IsoPath_branch and "eMatchesMu8Ele17IsoPath":
            warnings.warn( "EMuMuMuTree: Expected branch eMatchesMu8Ele17IsoPath does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eMatchesMu8Ele17IsoPath")
        else:
            self.eMatchesMu8Ele17IsoPath_branch.SetAddress(<void*>&self.eMatchesMu8Ele17IsoPath_value)

        #print "making eMatchesMu8Ele17Path"
        self.eMatchesMu8Ele17Path_branch = the_tree.GetBranch("eMatchesMu8Ele17Path")
        #if not self.eMatchesMu8Ele17Path_branch and "eMatchesMu8Ele17Path" not in self.complained:
        if not self.eMatchesMu8Ele17Path_branch and "eMatchesMu8Ele17Path":
            warnings.warn( "EMuMuMuTree: Expected branch eMatchesMu8Ele17Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eMatchesMu8Ele17Path")
        else:
            self.eMatchesMu8Ele17Path_branch.SetAddress(<void*>&self.eMatchesMu8Ele17Path_value)

        #print "making eMatchesSingleE"
        self.eMatchesSingleE_branch = the_tree.GetBranch("eMatchesSingleE")
        #if not self.eMatchesSingleE_branch and "eMatchesSingleE" not in self.complained:
        if not self.eMatchesSingleE_branch and "eMatchesSingleE":
            warnings.warn( "EMuMuMuTree: Expected branch eMatchesSingleE does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eMatchesSingleE")
        else:
            self.eMatchesSingleE_branch.SetAddress(<void*>&self.eMatchesSingleE_value)

        #print "making eMatchesSingleEPlusMET"
        self.eMatchesSingleEPlusMET_branch = the_tree.GetBranch("eMatchesSingleEPlusMET")
        #if not self.eMatchesSingleEPlusMET_branch and "eMatchesSingleEPlusMET" not in self.complained:
        if not self.eMatchesSingleEPlusMET_branch and "eMatchesSingleEPlusMET":
            warnings.warn( "EMuMuMuTree: Expected branch eMatchesSingleEPlusMET does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eMatchesSingleEPlusMET")
        else:
            self.eMatchesSingleEPlusMET_branch.SetAddress(<void*>&self.eMatchesSingleEPlusMET_value)

        #print "making eMissingHits"
        self.eMissingHits_branch = the_tree.GetBranch("eMissingHits")
        #if not self.eMissingHits_branch and "eMissingHits" not in self.complained:
        if not self.eMissingHits_branch and "eMissingHits":
            warnings.warn( "EMuMuMuTree: Expected branch eMissingHits does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eMissingHits")
        else:
            self.eMissingHits_branch.SetAddress(<void*>&self.eMissingHits_value)

        #print "making eMtToMET"
        self.eMtToMET_branch = the_tree.GetBranch("eMtToMET")
        #if not self.eMtToMET_branch and "eMtToMET" not in self.complained:
        if not self.eMtToMET_branch and "eMtToMET":
            warnings.warn( "EMuMuMuTree: Expected branch eMtToMET does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eMtToMET")
        else:
            self.eMtToMET_branch.SetAddress(<void*>&self.eMtToMET_value)

        #print "making eMtToMVAMET"
        self.eMtToMVAMET_branch = the_tree.GetBranch("eMtToMVAMET")
        #if not self.eMtToMVAMET_branch and "eMtToMVAMET" not in self.complained:
        if not self.eMtToMVAMET_branch and "eMtToMVAMET":
            warnings.warn( "EMuMuMuTree: Expected branch eMtToMVAMET does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eMtToMVAMET")
        else:
            self.eMtToMVAMET_branch.SetAddress(<void*>&self.eMtToMVAMET_value)

        #print "making eMtToPFMET"
        self.eMtToPFMET_branch = the_tree.GetBranch("eMtToPFMET")
        #if not self.eMtToPFMET_branch and "eMtToPFMET" not in self.complained:
        if not self.eMtToPFMET_branch and "eMtToPFMET":
            warnings.warn( "EMuMuMuTree: Expected branch eMtToPFMET does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eMtToPFMET")
        else:
            self.eMtToPFMET_branch.SetAddress(<void*>&self.eMtToPFMET_value)

        #print "making eMtToPfMet_Ty1"
        self.eMtToPfMet_Ty1_branch = the_tree.GetBranch("eMtToPfMet_Ty1")
        #if not self.eMtToPfMet_Ty1_branch and "eMtToPfMet_Ty1" not in self.complained:
        if not self.eMtToPfMet_Ty1_branch and "eMtToPfMet_Ty1":
            warnings.warn( "EMuMuMuTree: Expected branch eMtToPfMet_Ty1 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eMtToPfMet_Ty1")
        else:
            self.eMtToPfMet_Ty1_branch.SetAddress(<void*>&self.eMtToPfMet_Ty1_value)

        #print "making eMtToPfMet_jes"
        self.eMtToPfMet_jes_branch = the_tree.GetBranch("eMtToPfMet_jes")
        #if not self.eMtToPfMet_jes_branch and "eMtToPfMet_jes" not in self.complained:
        if not self.eMtToPfMet_jes_branch and "eMtToPfMet_jes":
            warnings.warn( "EMuMuMuTree: Expected branch eMtToPfMet_jes does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eMtToPfMet_jes")
        else:
            self.eMtToPfMet_jes_branch.SetAddress(<void*>&self.eMtToPfMet_jes_value)

        #print "making eMtToPfMet_mes"
        self.eMtToPfMet_mes_branch = the_tree.GetBranch("eMtToPfMet_mes")
        #if not self.eMtToPfMet_mes_branch and "eMtToPfMet_mes" not in self.complained:
        if not self.eMtToPfMet_mes_branch and "eMtToPfMet_mes":
            warnings.warn( "EMuMuMuTree: Expected branch eMtToPfMet_mes does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eMtToPfMet_mes")
        else:
            self.eMtToPfMet_mes_branch.SetAddress(<void*>&self.eMtToPfMet_mes_value)

        #print "making eMtToPfMet_tes"
        self.eMtToPfMet_tes_branch = the_tree.GetBranch("eMtToPfMet_tes")
        #if not self.eMtToPfMet_tes_branch and "eMtToPfMet_tes" not in self.complained:
        if not self.eMtToPfMet_tes_branch and "eMtToPfMet_tes":
            warnings.warn( "EMuMuMuTree: Expected branch eMtToPfMet_tes does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eMtToPfMet_tes")
        else:
            self.eMtToPfMet_tes_branch.SetAddress(<void*>&self.eMtToPfMet_tes_value)

        #print "making eMtToPfMet_ues"
        self.eMtToPfMet_ues_branch = the_tree.GetBranch("eMtToPfMet_ues")
        #if not self.eMtToPfMet_ues_branch and "eMtToPfMet_ues" not in self.complained:
        if not self.eMtToPfMet_ues_branch and "eMtToPfMet_ues":
            warnings.warn( "EMuMuMuTree: Expected branch eMtToPfMet_ues does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eMtToPfMet_ues")
        else:
            self.eMtToPfMet_ues_branch.SetAddress(<void*>&self.eMtToPfMet_ues_value)

        #print "making eMu17Ele8CaloIdTCaloIsoVLTrkIdVLTrkIsoVLTrackIsoFilter"
        self.eMu17Ele8CaloIdTCaloIsoVLTrkIdVLTrkIsoVLTrackIsoFilter_branch = the_tree.GetBranch("eMu17Ele8CaloIdTCaloIsoVLTrkIdVLTrkIsoVLTrackIsoFilter")
        #if not self.eMu17Ele8CaloIdTCaloIsoVLTrkIdVLTrkIsoVLTrackIsoFilter_branch and "eMu17Ele8CaloIdTCaloIsoVLTrkIdVLTrkIsoVLTrackIsoFilter" not in self.complained:
        if not self.eMu17Ele8CaloIdTCaloIsoVLTrkIdVLTrkIsoVLTrackIsoFilter_branch and "eMu17Ele8CaloIdTCaloIsoVLTrkIdVLTrkIsoVLTrackIsoFilter":
            warnings.warn( "EMuMuMuTree: Expected branch eMu17Ele8CaloIdTCaloIsoVLTrkIdVLTrkIsoVLTrackIsoFilter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eMu17Ele8CaloIdTCaloIsoVLTrkIdVLTrkIsoVLTrackIsoFilter")
        else:
            self.eMu17Ele8CaloIdTCaloIsoVLTrkIdVLTrkIsoVLTrackIsoFilter_branch.SetAddress(<void*>&self.eMu17Ele8CaloIdTCaloIsoVLTrkIdVLTrkIsoVLTrackIsoFilter_value)

        #print "making eMu17Ele8CaloIdTPixelMatchFilter"
        self.eMu17Ele8CaloIdTPixelMatchFilter_branch = the_tree.GetBranch("eMu17Ele8CaloIdTPixelMatchFilter")
        #if not self.eMu17Ele8CaloIdTPixelMatchFilter_branch and "eMu17Ele8CaloIdTPixelMatchFilter" not in self.complained:
        if not self.eMu17Ele8CaloIdTPixelMatchFilter_branch and "eMu17Ele8CaloIdTPixelMatchFilter":
            warnings.warn( "EMuMuMuTree: Expected branch eMu17Ele8CaloIdTPixelMatchFilter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eMu17Ele8CaloIdTPixelMatchFilter")
        else:
            self.eMu17Ele8CaloIdTPixelMatchFilter_branch.SetAddress(<void*>&self.eMu17Ele8CaloIdTPixelMatchFilter_value)

        #print "making eMu17Ele8dZFilter"
        self.eMu17Ele8dZFilter_branch = the_tree.GetBranch("eMu17Ele8dZFilter")
        #if not self.eMu17Ele8dZFilter_branch and "eMu17Ele8dZFilter" not in self.complained:
        if not self.eMu17Ele8dZFilter_branch and "eMu17Ele8dZFilter":
            warnings.warn( "EMuMuMuTree: Expected branch eMu17Ele8dZFilter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eMu17Ele8dZFilter")
        else:
            self.eMu17Ele8dZFilter_branch.SetAddress(<void*>&self.eMu17Ele8dZFilter_value)

        #print "making eNearMuonVeto"
        self.eNearMuonVeto_branch = the_tree.GetBranch("eNearMuonVeto")
        #if not self.eNearMuonVeto_branch and "eNearMuonVeto" not in self.complained:
        if not self.eNearMuonVeto_branch and "eNearMuonVeto":
            warnings.warn( "EMuMuMuTree: Expected branch eNearMuonVeto does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eNearMuonVeto")
        else:
            self.eNearMuonVeto_branch.SetAddress(<void*>&self.eNearMuonVeto_value)

        #print "making ePFChargedIso"
        self.ePFChargedIso_branch = the_tree.GetBranch("ePFChargedIso")
        #if not self.ePFChargedIso_branch and "ePFChargedIso" not in self.complained:
        if not self.ePFChargedIso_branch and "ePFChargedIso":
            warnings.warn( "EMuMuMuTree: Expected branch ePFChargedIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("ePFChargedIso")
        else:
            self.ePFChargedIso_branch.SetAddress(<void*>&self.ePFChargedIso_value)

        #print "making ePFNeutralIso"
        self.ePFNeutralIso_branch = the_tree.GetBranch("ePFNeutralIso")
        #if not self.ePFNeutralIso_branch and "ePFNeutralIso" not in self.complained:
        if not self.ePFNeutralIso_branch and "ePFNeutralIso":
            warnings.warn( "EMuMuMuTree: Expected branch ePFNeutralIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("ePFNeutralIso")
        else:
            self.ePFNeutralIso_branch.SetAddress(<void*>&self.ePFNeutralIso_value)

        #print "making ePFPhotonIso"
        self.ePFPhotonIso_branch = the_tree.GetBranch("ePFPhotonIso")
        #if not self.ePFPhotonIso_branch and "ePFPhotonIso" not in self.complained:
        if not self.ePFPhotonIso_branch and "ePFPhotonIso":
            warnings.warn( "EMuMuMuTree: Expected branch ePFPhotonIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("ePFPhotonIso")
        else:
            self.ePFPhotonIso_branch.SetAddress(<void*>&self.ePFPhotonIso_value)

        #print "making ePVDXY"
        self.ePVDXY_branch = the_tree.GetBranch("ePVDXY")
        #if not self.ePVDXY_branch and "ePVDXY" not in self.complained:
        if not self.ePVDXY_branch and "ePVDXY":
            warnings.warn( "EMuMuMuTree: Expected branch ePVDXY does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("ePVDXY")
        else:
            self.ePVDXY_branch.SetAddress(<void*>&self.ePVDXY_value)

        #print "making ePVDZ"
        self.ePVDZ_branch = the_tree.GetBranch("ePVDZ")
        #if not self.ePVDZ_branch and "ePVDZ" not in self.complained:
        if not self.ePVDZ_branch and "ePVDZ":
            warnings.warn( "EMuMuMuTree: Expected branch ePVDZ does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("ePVDZ")
        else:
            self.ePVDZ_branch.SetAddress(<void*>&self.ePVDZ_value)

        #print "making ePhi"
        self.ePhi_branch = the_tree.GetBranch("ePhi")
        #if not self.ePhi_branch and "ePhi" not in self.complained:
        if not self.ePhi_branch and "ePhi":
            warnings.warn( "EMuMuMuTree: Expected branch ePhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("ePhi")
        else:
            self.ePhi_branch.SetAddress(<void*>&self.ePhi_value)

        #print "making ePhiCorrReg_2012Jul13ReReco"
        self.ePhiCorrReg_2012Jul13ReReco_branch = the_tree.GetBranch("ePhiCorrReg_2012Jul13ReReco")
        #if not self.ePhiCorrReg_2012Jul13ReReco_branch and "ePhiCorrReg_2012Jul13ReReco" not in self.complained:
        if not self.ePhiCorrReg_2012Jul13ReReco_branch and "ePhiCorrReg_2012Jul13ReReco":
            warnings.warn( "EMuMuMuTree: Expected branch ePhiCorrReg_2012Jul13ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("ePhiCorrReg_2012Jul13ReReco")
        else:
            self.ePhiCorrReg_2012Jul13ReReco_branch.SetAddress(<void*>&self.ePhiCorrReg_2012Jul13ReReco_value)

        #print "making ePhiCorrReg_Fall11"
        self.ePhiCorrReg_Fall11_branch = the_tree.GetBranch("ePhiCorrReg_Fall11")
        #if not self.ePhiCorrReg_Fall11_branch and "ePhiCorrReg_Fall11" not in self.complained:
        if not self.ePhiCorrReg_Fall11_branch and "ePhiCorrReg_Fall11":
            warnings.warn( "EMuMuMuTree: Expected branch ePhiCorrReg_Fall11 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("ePhiCorrReg_Fall11")
        else:
            self.ePhiCorrReg_Fall11_branch.SetAddress(<void*>&self.ePhiCorrReg_Fall11_value)

        #print "making ePhiCorrReg_Jan16ReReco"
        self.ePhiCorrReg_Jan16ReReco_branch = the_tree.GetBranch("ePhiCorrReg_Jan16ReReco")
        #if not self.ePhiCorrReg_Jan16ReReco_branch and "ePhiCorrReg_Jan16ReReco" not in self.complained:
        if not self.ePhiCorrReg_Jan16ReReco_branch and "ePhiCorrReg_Jan16ReReco":
            warnings.warn( "EMuMuMuTree: Expected branch ePhiCorrReg_Jan16ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("ePhiCorrReg_Jan16ReReco")
        else:
            self.ePhiCorrReg_Jan16ReReco_branch.SetAddress(<void*>&self.ePhiCorrReg_Jan16ReReco_value)

        #print "making ePhiCorrReg_Summer12_DR53X_HCP2012"
        self.ePhiCorrReg_Summer12_DR53X_HCP2012_branch = the_tree.GetBranch("ePhiCorrReg_Summer12_DR53X_HCP2012")
        #if not self.ePhiCorrReg_Summer12_DR53X_HCP2012_branch and "ePhiCorrReg_Summer12_DR53X_HCP2012" not in self.complained:
        if not self.ePhiCorrReg_Summer12_DR53X_HCP2012_branch and "ePhiCorrReg_Summer12_DR53X_HCP2012":
            warnings.warn( "EMuMuMuTree: Expected branch ePhiCorrReg_Summer12_DR53X_HCP2012 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("ePhiCorrReg_Summer12_DR53X_HCP2012")
        else:
            self.ePhiCorrReg_Summer12_DR53X_HCP2012_branch.SetAddress(<void*>&self.ePhiCorrReg_Summer12_DR53X_HCP2012_value)

        #print "making ePhiCorrSmearedNoReg_2012Jul13ReReco"
        self.ePhiCorrSmearedNoReg_2012Jul13ReReco_branch = the_tree.GetBranch("ePhiCorrSmearedNoReg_2012Jul13ReReco")
        #if not self.ePhiCorrSmearedNoReg_2012Jul13ReReco_branch and "ePhiCorrSmearedNoReg_2012Jul13ReReco" not in self.complained:
        if not self.ePhiCorrSmearedNoReg_2012Jul13ReReco_branch and "ePhiCorrSmearedNoReg_2012Jul13ReReco":
            warnings.warn( "EMuMuMuTree: Expected branch ePhiCorrSmearedNoReg_2012Jul13ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("ePhiCorrSmearedNoReg_2012Jul13ReReco")
        else:
            self.ePhiCorrSmearedNoReg_2012Jul13ReReco_branch.SetAddress(<void*>&self.ePhiCorrSmearedNoReg_2012Jul13ReReco_value)

        #print "making ePhiCorrSmearedNoReg_Fall11"
        self.ePhiCorrSmearedNoReg_Fall11_branch = the_tree.GetBranch("ePhiCorrSmearedNoReg_Fall11")
        #if not self.ePhiCorrSmearedNoReg_Fall11_branch and "ePhiCorrSmearedNoReg_Fall11" not in self.complained:
        if not self.ePhiCorrSmearedNoReg_Fall11_branch and "ePhiCorrSmearedNoReg_Fall11":
            warnings.warn( "EMuMuMuTree: Expected branch ePhiCorrSmearedNoReg_Fall11 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("ePhiCorrSmearedNoReg_Fall11")
        else:
            self.ePhiCorrSmearedNoReg_Fall11_branch.SetAddress(<void*>&self.ePhiCorrSmearedNoReg_Fall11_value)

        #print "making ePhiCorrSmearedNoReg_Jan16ReReco"
        self.ePhiCorrSmearedNoReg_Jan16ReReco_branch = the_tree.GetBranch("ePhiCorrSmearedNoReg_Jan16ReReco")
        #if not self.ePhiCorrSmearedNoReg_Jan16ReReco_branch and "ePhiCorrSmearedNoReg_Jan16ReReco" not in self.complained:
        if not self.ePhiCorrSmearedNoReg_Jan16ReReco_branch and "ePhiCorrSmearedNoReg_Jan16ReReco":
            warnings.warn( "EMuMuMuTree: Expected branch ePhiCorrSmearedNoReg_Jan16ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("ePhiCorrSmearedNoReg_Jan16ReReco")
        else:
            self.ePhiCorrSmearedNoReg_Jan16ReReco_branch.SetAddress(<void*>&self.ePhiCorrSmearedNoReg_Jan16ReReco_value)

        #print "making ePhiCorrSmearedNoReg_Summer12_DR53X_HCP2012"
        self.ePhiCorrSmearedNoReg_Summer12_DR53X_HCP2012_branch = the_tree.GetBranch("ePhiCorrSmearedNoReg_Summer12_DR53X_HCP2012")
        #if not self.ePhiCorrSmearedNoReg_Summer12_DR53X_HCP2012_branch and "ePhiCorrSmearedNoReg_Summer12_DR53X_HCP2012" not in self.complained:
        if not self.ePhiCorrSmearedNoReg_Summer12_DR53X_HCP2012_branch and "ePhiCorrSmearedNoReg_Summer12_DR53X_HCP2012":
            warnings.warn( "EMuMuMuTree: Expected branch ePhiCorrSmearedNoReg_Summer12_DR53X_HCP2012 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("ePhiCorrSmearedNoReg_Summer12_DR53X_HCP2012")
        else:
            self.ePhiCorrSmearedNoReg_Summer12_DR53X_HCP2012_branch.SetAddress(<void*>&self.ePhiCorrSmearedNoReg_Summer12_DR53X_HCP2012_value)

        #print "making ePhiCorrSmearedReg_2012Jul13ReReco"
        self.ePhiCorrSmearedReg_2012Jul13ReReco_branch = the_tree.GetBranch("ePhiCorrSmearedReg_2012Jul13ReReco")
        #if not self.ePhiCorrSmearedReg_2012Jul13ReReco_branch and "ePhiCorrSmearedReg_2012Jul13ReReco" not in self.complained:
        if not self.ePhiCorrSmearedReg_2012Jul13ReReco_branch and "ePhiCorrSmearedReg_2012Jul13ReReco":
            warnings.warn( "EMuMuMuTree: Expected branch ePhiCorrSmearedReg_2012Jul13ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("ePhiCorrSmearedReg_2012Jul13ReReco")
        else:
            self.ePhiCorrSmearedReg_2012Jul13ReReco_branch.SetAddress(<void*>&self.ePhiCorrSmearedReg_2012Jul13ReReco_value)

        #print "making ePhiCorrSmearedReg_Fall11"
        self.ePhiCorrSmearedReg_Fall11_branch = the_tree.GetBranch("ePhiCorrSmearedReg_Fall11")
        #if not self.ePhiCorrSmearedReg_Fall11_branch and "ePhiCorrSmearedReg_Fall11" not in self.complained:
        if not self.ePhiCorrSmearedReg_Fall11_branch and "ePhiCorrSmearedReg_Fall11":
            warnings.warn( "EMuMuMuTree: Expected branch ePhiCorrSmearedReg_Fall11 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("ePhiCorrSmearedReg_Fall11")
        else:
            self.ePhiCorrSmearedReg_Fall11_branch.SetAddress(<void*>&self.ePhiCorrSmearedReg_Fall11_value)

        #print "making ePhiCorrSmearedReg_Jan16ReReco"
        self.ePhiCorrSmearedReg_Jan16ReReco_branch = the_tree.GetBranch("ePhiCorrSmearedReg_Jan16ReReco")
        #if not self.ePhiCorrSmearedReg_Jan16ReReco_branch and "ePhiCorrSmearedReg_Jan16ReReco" not in self.complained:
        if not self.ePhiCorrSmearedReg_Jan16ReReco_branch and "ePhiCorrSmearedReg_Jan16ReReco":
            warnings.warn( "EMuMuMuTree: Expected branch ePhiCorrSmearedReg_Jan16ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("ePhiCorrSmearedReg_Jan16ReReco")
        else:
            self.ePhiCorrSmearedReg_Jan16ReReco_branch.SetAddress(<void*>&self.ePhiCorrSmearedReg_Jan16ReReco_value)

        #print "making ePhiCorrSmearedReg_Summer12_DR53X_HCP2012"
        self.ePhiCorrSmearedReg_Summer12_DR53X_HCP2012_branch = the_tree.GetBranch("ePhiCorrSmearedReg_Summer12_DR53X_HCP2012")
        #if not self.ePhiCorrSmearedReg_Summer12_DR53X_HCP2012_branch and "ePhiCorrSmearedReg_Summer12_DR53X_HCP2012" not in self.complained:
        if not self.ePhiCorrSmearedReg_Summer12_DR53X_HCP2012_branch and "ePhiCorrSmearedReg_Summer12_DR53X_HCP2012":
            warnings.warn( "EMuMuMuTree: Expected branch ePhiCorrSmearedReg_Summer12_DR53X_HCP2012 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("ePhiCorrSmearedReg_Summer12_DR53X_HCP2012")
        else:
            self.ePhiCorrSmearedReg_Summer12_DR53X_HCP2012_branch.SetAddress(<void*>&self.ePhiCorrSmearedReg_Summer12_DR53X_HCP2012_value)

        #print "making ePt"
        self.ePt_branch = the_tree.GetBranch("ePt")
        #if not self.ePt_branch and "ePt" not in self.complained:
        if not self.ePt_branch and "ePt":
            warnings.warn( "EMuMuMuTree: Expected branch ePt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("ePt")
        else:
            self.ePt_branch.SetAddress(<void*>&self.ePt_value)

        #print "making ePtCorrReg_2012Jul13ReReco"
        self.ePtCorrReg_2012Jul13ReReco_branch = the_tree.GetBranch("ePtCorrReg_2012Jul13ReReco")
        #if not self.ePtCorrReg_2012Jul13ReReco_branch and "ePtCorrReg_2012Jul13ReReco" not in self.complained:
        if not self.ePtCorrReg_2012Jul13ReReco_branch and "ePtCorrReg_2012Jul13ReReco":
            warnings.warn( "EMuMuMuTree: Expected branch ePtCorrReg_2012Jul13ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("ePtCorrReg_2012Jul13ReReco")
        else:
            self.ePtCorrReg_2012Jul13ReReco_branch.SetAddress(<void*>&self.ePtCorrReg_2012Jul13ReReco_value)

        #print "making ePtCorrReg_Fall11"
        self.ePtCorrReg_Fall11_branch = the_tree.GetBranch("ePtCorrReg_Fall11")
        #if not self.ePtCorrReg_Fall11_branch and "ePtCorrReg_Fall11" not in self.complained:
        if not self.ePtCorrReg_Fall11_branch and "ePtCorrReg_Fall11":
            warnings.warn( "EMuMuMuTree: Expected branch ePtCorrReg_Fall11 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("ePtCorrReg_Fall11")
        else:
            self.ePtCorrReg_Fall11_branch.SetAddress(<void*>&self.ePtCorrReg_Fall11_value)

        #print "making ePtCorrReg_Jan16ReReco"
        self.ePtCorrReg_Jan16ReReco_branch = the_tree.GetBranch("ePtCorrReg_Jan16ReReco")
        #if not self.ePtCorrReg_Jan16ReReco_branch and "ePtCorrReg_Jan16ReReco" not in self.complained:
        if not self.ePtCorrReg_Jan16ReReco_branch and "ePtCorrReg_Jan16ReReco":
            warnings.warn( "EMuMuMuTree: Expected branch ePtCorrReg_Jan16ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("ePtCorrReg_Jan16ReReco")
        else:
            self.ePtCorrReg_Jan16ReReco_branch.SetAddress(<void*>&self.ePtCorrReg_Jan16ReReco_value)

        #print "making ePtCorrReg_Summer12_DR53X_HCP2012"
        self.ePtCorrReg_Summer12_DR53X_HCP2012_branch = the_tree.GetBranch("ePtCorrReg_Summer12_DR53X_HCP2012")
        #if not self.ePtCorrReg_Summer12_DR53X_HCP2012_branch and "ePtCorrReg_Summer12_DR53X_HCP2012" not in self.complained:
        if not self.ePtCorrReg_Summer12_DR53X_HCP2012_branch and "ePtCorrReg_Summer12_DR53X_HCP2012":
            warnings.warn( "EMuMuMuTree: Expected branch ePtCorrReg_Summer12_DR53X_HCP2012 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("ePtCorrReg_Summer12_DR53X_HCP2012")
        else:
            self.ePtCorrReg_Summer12_DR53X_HCP2012_branch.SetAddress(<void*>&self.ePtCorrReg_Summer12_DR53X_HCP2012_value)

        #print "making ePtCorrSmearedNoReg_2012Jul13ReReco"
        self.ePtCorrSmearedNoReg_2012Jul13ReReco_branch = the_tree.GetBranch("ePtCorrSmearedNoReg_2012Jul13ReReco")
        #if not self.ePtCorrSmearedNoReg_2012Jul13ReReco_branch and "ePtCorrSmearedNoReg_2012Jul13ReReco" not in self.complained:
        if not self.ePtCorrSmearedNoReg_2012Jul13ReReco_branch and "ePtCorrSmearedNoReg_2012Jul13ReReco":
            warnings.warn( "EMuMuMuTree: Expected branch ePtCorrSmearedNoReg_2012Jul13ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("ePtCorrSmearedNoReg_2012Jul13ReReco")
        else:
            self.ePtCorrSmearedNoReg_2012Jul13ReReco_branch.SetAddress(<void*>&self.ePtCorrSmearedNoReg_2012Jul13ReReco_value)

        #print "making ePtCorrSmearedNoReg_Fall11"
        self.ePtCorrSmearedNoReg_Fall11_branch = the_tree.GetBranch("ePtCorrSmearedNoReg_Fall11")
        #if not self.ePtCorrSmearedNoReg_Fall11_branch and "ePtCorrSmearedNoReg_Fall11" not in self.complained:
        if not self.ePtCorrSmearedNoReg_Fall11_branch and "ePtCorrSmearedNoReg_Fall11":
            warnings.warn( "EMuMuMuTree: Expected branch ePtCorrSmearedNoReg_Fall11 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("ePtCorrSmearedNoReg_Fall11")
        else:
            self.ePtCorrSmearedNoReg_Fall11_branch.SetAddress(<void*>&self.ePtCorrSmearedNoReg_Fall11_value)

        #print "making ePtCorrSmearedNoReg_Jan16ReReco"
        self.ePtCorrSmearedNoReg_Jan16ReReco_branch = the_tree.GetBranch("ePtCorrSmearedNoReg_Jan16ReReco")
        #if not self.ePtCorrSmearedNoReg_Jan16ReReco_branch and "ePtCorrSmearedNoReg_Jan16ReReco" not in self.complained:
        if not self.ePtCorrSmearedNoReg_Jan16ReReco_branch and "ePtCorrSmearedNoReg_Jan16ReReco":
            warnings.warn( "EMuMuMuTree: Expected branch ePtCorrSmearedNoReg_Jan16ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("ePtCorrSmearedNoReg_Jan16ReReco")
        else:
            self.ePtCorrSmearedNoReg_Jan16ReReco_branch.SetAddress(<void*>&self.ePtCorrSmearedNoReg_Jan16ReReco_value)

        #print "making ePtCorrSmearedNoReg_Summer12_DR53X_HCP2012"
        self.ePtCorrSmearedNoReg_Summer12_DR53X_HCP2012_branch = the_tree.GetBranch("ePtCorrSmearedNoReg_Summer12_DR53X_HCP2012")
        #if not self.ePtCorrSmearedNoReg_Summer12_DR53X_HCP2012_branch and "ePtCorrSmearedNoReg_Summer12_DR53X_HCP2012" not in self.complained:
        if not self.ePtCorrSmearedNoReg_Summer12_DR53X_HCP2012_branch and "ePtCorrSmearedNoReg_Summer12_DR53X_HCP2012":
            warnings.warn( "EMuMuMuTree: Expected branch ePtCorrSmearedNoReg_Summer12_DR53X_HCP2012 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("ePtCorrSmearedNoReg_Summer12_DR53X_HCP2012")
        else:
            self.ePtCorrSmearedNoReg_Summer12_DR53X_HCP2012_branch.SetAddress(<void*>&self.ePtCorrSmearedNoReg_Summer12_DR53X_HCP2012_value)

        #print "making ePtCorrSmearedReg_2012Jul13ReReco"
        self.ePtCorrSmearedReg_2012Jul13ReReco_branch = the_tree.GetBranch("ePtCorrSmearedReg_2012Jul13ReReco")
        #if not self.ePtCorrSmearedReg_2012Jul13ReReco_branch and "ePtCorrSmearedReg_2012Jul13ReReco" not in self.complained:
        if not self.ePtCorrSmearedReg_2012Jul13ReReco_branch and "ePtCorrSmearedReg_2012Jul13ReReco":
            warnings.warn( "EMuMuMuTree: Expected branch ePtCorrSmearedReg_2012Jul13ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("ePtCorrSmearedReg_2012Jul13ReReco")
        else:
            self.ePtCorrSmearedReg_2012Jul13ReReco_branch.SetAddress(<void*>&self.ePtCorrSmearedReg_2012Jul13ReReco_value)

        #print "making ePtCorrSmearedReg_Fall11"
        self.ePtCorrSmearedReg_Fall11_branch = the_tree.GetBranch("ePtCorrSmearedReg_Fall11")
        #if not self.ePtCorrSmearedReg_Fall11_branch and "ePtCorrSmearedReg_Fall11" not in self.complained:
        if not self.ePtCorrSmearedReg_Fall11_branch and "ePtCorrSmearedReg_Fall11":
            warnings.warn( "EMuMuMuTree: Expected branch ePtCorrSmearedReg_Fall11 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("ePtCorrSmearedReg_Fall11")
        else:
            self.ePtCorrSmearedReg_Fall11_branch.SetAddress(<void*>&self.ePtCorrSmearedReg_Fall11_value)

        #print "making ePtCorrSmearedReg_Jan16ReReco"
        self.ePtCorrSmearedReg_Jan16ReReco_branch = the_tree.GetBranch("ePtCorrSmearedReg_Jan16ReReco")
        #if not self.ePtCorrSmearedReg_Jan16ReReco_branch and "ePtCorrSmearedReg_Jan16ReReco" not in self.complained:
        if not self.ePtCorrSmearedReg_Jan16ReReco_branch and "ePtCorrSmearedReg_Jan16ReReco":
            warnings.warn( "EMuMuMuTree: Expected branch ePtCorrSmearedReg_Jan16ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("ePtCorrSmearedReg_Jan16ReReco")
        else:
            self.ePtCorrSmearedReg_Jan16ReReco_branch.SetAddress(<void*>&self.ePtCorrSmearedReg_Jan16ReReco_value)

        #print "making ePtCorrSmearedReg_Summer12_DR53X_HCP2012"
        self.ePtCorrSmearedReg_Summer12_DR53X_HCP2012_branch = the_tree.GetBranch("ePtCorrSmearedReg_Summer12_DR53X_HCP2012")
        #if not self.ePtCorrSmearedReg_Summer12_DR53X_HCP2012_branch and "ePtCorrSmearedReg_Summer12_DR53X_HCP2012" not in self.complained:
        if not self.ePtCorrSmearedReg_Summer12_DR53X_HCP2012_branch and "ePtCorrSmearedReg_Summer12_DR53X_HCP2012":
            warnings.warn( "EMuMuMuTree: Expected branch ePtCorrSmearedReg_Summer12_DR53X_HCP2012 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("ePtCorrSmearedReg_Summer12_DR53X_HCP2012")
        else:
            self.ePtCorrSmearedReg_Summer12_DR53X_HCP2012_branch.SetAddress(<void*>&self.ePtCorrSmearedReg_Summer12_DR53X_HCP2012_value)

        #print "making eRank"
        self.eRank_branch = the_tree.GetBranch("eRank")
        #if not self.eRank_branch and "eRank" not in self.complained:
        if not self.eRank_branch and "eRank":
            warnings.warn( "EMuMuMuTree: Expected branch eRank does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eRank")
        else:
            self.eRank_branch.SetAddress(<void*>&self.eRank_value)

        #print "making eRelIso"
        self.eRelIso_branch = the_tree.GetBranch("eRelIso")
        #if not self.eRelIso_branch and "eRelIso" not in self.complained:
        if not self.eRelIso_branch and "eRelIso":
            warnings.warn( "EMuMuMuTree: Expected branch eRelIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eRelIso")
        else:
            self.eRelIso_branch.SetAddress(<void*>&self.eRelIso_value)

        #print "making eRelPFIsoDB"
        self.eRelPFIsoDB_branch = the_tree.GetBranch("eRelPFIsoDB")
        #if not self.eRelPFIsoDB_branch and "eRelPFIsoDB" not in self.complained:
        if not self.eRelPFIsoDB_branch and "eRelPFIsoDB":
            warnings.warn( "EMuMuMuTree: Expected branch eRelPFIsoDB does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eRelPFIsoDB")
        else:
            self.eRelPFIsoDB_branch.SetAddress(<void*>&self.eRelPFIsoDB_value)

        #print "making eRelPFIsoRho"
        self.eRelPFIsoRho_branch = the_tree.GetBranch("eRelPFIsoRho")
        #if not self.eRelPFIsoRho_branch and "eRelPFIsoRho" not in self.complained:
        if not self.eRelPFIsoRho_branch and "eRelPFIsoRho":
            warnings.warn( "EMuMuMuTree: Expected branch eRelPFIsoRho does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eRelPFIsoRho")
        else:
            self.eRelPFIsoRho_branch.SetAddress(<void*>&self.eRelPFIsoRho_value)

        #print "making eRelPFIsoRhoFSR"
        self.eRelPFIsoRhoFSR_branch = the_tree.GetBranch("eRelPFIsoRhoFSR")
        #if not self.eRelPFIsoRhoFSR_branch and "eRelPFIsoRhoFSR" not in self.complained:
        if not self.eRelPFIsoRhoFSR_branch and "eRelPFIsoRhoFSR":
            warnings.warn( "EMuMuMuTree: Expected branch eRelPFIsoRhoFSR does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eRelPFIsoRhoFSR")
        else:
            self.eRelPFIsoRhoFSR_branch.SetAddress(<void*>&self.eRelPFIsoRhoFSR_value)

        #print "making eRhoHZG2011"
        self.eRhoHZG2011_branch = the_tree.GetBranch("eRhoHZG2011")
        #if not self.eRhoHZG2011_branch and "eRhoHZG2011" not in self.complained:
        if not self.eRhoHZG2011_branch and "eRhoHZG2011":
            warnings.warn( "EMuMuMuTree: Expected branch eRhoHZG2011 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eRhoHZG2011")
        else:
            self.eRhoHZG2011_branch.SetAddress(<void*>&self.eRhoHZG2011_value)

        #print "making eRhoHZG2012"
        self.eRhoHZG2012_branch = the_tree.GetBranch("eRhoHZG2012")
        #if not self.eRhoHZG2012_branch and "eRhoHZG2012" not in self.complained:
        if not self.eRhoHZG2012_branch and "eRhoHZG2012":
            warnings.warn( "EMuMuMuTree: Expected branch eRhoHZG2012 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eRhoHZG2012")
        else:
            self.eRhoHZG2012_branch.SetAddress(<void*>&self.eRhoHZG2012_value)

        #print "making eSCEnergy"
        self.eSCEnergy_branch = the_tree.GetBranch("eSCEnergy")
        #if not self.eSCEnergy_branch and "eSCEnergy" not in self.complained:
        if not self.eSCEnergy_branch and "eSCEnergy":
            warnings.warn( "EMuMuMuTree: Expected branch eSCEnergy does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eSCEnergy")
        else:
            self.eSCEnergy_branch.SetAddress(<void*>&self.eSCEnergy_value)

        #print "making eSCEta"
        self.eSCEta_branch = the_tree.GetBranch("eSCEta")
        #if not self.eSCEta_branch and "eSCEta" not in self.complained:
        if not self.eSCEta_branch and "eSCEta":
            warnings.warn( "EMuMuMuTree: Expected branch eSCEta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eSCEta")
        else:
            self.eSCEta_branch.SetAddress(<void*>&self.eSCEta_value)

        #print "making eSCEtaWidth"
        self.eSCEtaWidth_branch = the_tree.GetBranch("eSCEtaWidth")
        #if not self.eSCEtaWidth_branch and "eSCEtaWidth" not in self.complained:
        if not self.eSCEtaWidth_branch and "eSCEtaWidth":
            warnings.warn( "EMuMuMuTree: Expected branch eSCEtaWidth does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eSCEtaWidth")
        else:
            self.eSCEtaWidth_branch.SetAddress(<void*>&self.eSCEtaWidth_value)

        #print "making eSCPhi"
        self.eSCPhi_branch = the_tree.GetBranch("eSCPhi")
        #if not self.eSCPhi_branch and "eSCPhi" not in self.complained:
        if not self.eSCPhi_branch and "eSCPhi":
            warnings.warn( "EMuMuMuTree: Expected branch eSCPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eSCPhi")
        else:
            self.eSCPhi_branch.SetAddress(<void*>&self.eSCPhi_value)

        #print "making eSCPhiWidth"
        self.eSCPhiWidth_branch = the_tree.GetBranch("eSCPhiWidth")
        #if not self.eSCPhiWidth_branch and "eSCPhiWidth" not in self.complained:
        if not self.eSCPhiWidth_branch and "eSCPhiWidth":
            warnings.warn( "EMuMuMuTree: Expected branch eSCPhiWidth does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eSCPhiWidth")
        else:
            self.eSCPhiWidth_branch.SetAddress(<void*>&self.eSCPhiWidth_value)

        #print "making eSCPreshowerEnergy"
        self.eSCPreshowerEnergy_branch = the_tree.GetBranch("eSCPreshowerEnergy")
        #if not self.eSCPreshowerEnergy_branch and "eSCPreshowerEnergy" not in self.complained:
        if not self.eSCPreshowerEnergy_branch and "eSCPreshowerEnergy":
            warnings.warn( "EMuMuMuTree: Expected branch eSCPreshowerEnergy does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eSCPreshowerEnergy")
        else:
            self.eSCPreshowerEnergy_branch.SetAddress(<void*>&self.eSCPreshowerEnergy_value)

        #print "making eSCRawEnergy"
        self.eSCRawEnergy_branch = the_tree.GetBranch("eSCRawEnergy")
        #if not self.eSCRawEnergy_branch and "eSCRawEnergy" not in self.complained:
        if not self.eSCRawEnergy_branch and "eSCRawEnergy":
            warnings.warn( "EMuMuMuTree: Expected branch eSCRawEnergy does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eSCRawEnergy")
        else:
            self.eSCRawEnergy_branch.SetAddress(<void*>&self.eSCRawEnergy_value)

        #print "making eSigmaIEtaIEta"
        self.eSigmaIEtaIEta_branch = the_tree.GetBranch("eSigmaIEtaIEta")
        #if not self.eSigmaIEtaIEta_branch and "eSigmaIEtaIEta" not in self.complained:
        if not self.eSigmaIEtaIEta_branch and "eSigmaIEtaIEta":
            warnings.warn( "EMuMuMuTree: Expected branch eSigmaIEtaIEta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eSigmaIEtaIEta")
        else:
            self.eSigmaIEtaIEta_branch.SetAddress(<void*>&self.eSigmaIEtaIEta_value)

        #print "making eTightCountZH"
        self.eTightCountZH_branch = the_tree.GetBranch("eTightCountZH")
        #if not self.eTightCountZH_branch and "eTightCountZH" not in self.complained:
        if not self.eTightCountZH_branch and "eTightCountZH":
            warnings.warn( "EMuMuMuTree: Expected branch eTightCountZH does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eTightCountZH")
        else:
            self.eTightCountZH_branch.SetAddress(<void*>&self.eTightCountZH_value)

        #print "making eToMETDPhi"
        self.eToMETDPhi_branch = the_tree.GetBranch("eToMETDPhi")
        #if not self.eToMETDPhi_branch and "eToMETDPhi" not in self.complained:
        if not self.eToMETDPhi_branch and "eToMETDPhi":
            warnings.warn( "EMuMuMuTree: Expected branch eToMETDPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eToMETDPhi")
        else:
            self.eToMETDPhi_branch.SetAddress(<void*>&self.eToMETDPhi_value)

        #print "making eTrkIsoDR03"
        self.eTrkIsoDR03_branch = the_tree.GetBranch("eTrkIsoDR03")
        #if not self.eTrkIsoDR03_branch and "eTrkIsoDR03" not in self.complained:
        if not self.eTrkIsoDR03_branch and "eTrkIsoDR03":
            warnings.warn( "EMuMuMuTree: Expected branch eTrkIsoDR03 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eTrkIsoDR03")
        else:
            self.eTrkIsoDR03_branch.SetAddress(<void*>&self.eTrkIsoDR03_value)

        #print "making eVZ"
        self.eVZ_branch = the_tree.GetBranch("eVZ")
        #if not self.eVZ_branch and "eVZ" not in self.complained:
        if not self.eVZ_branch and "eVZ":
            warnings.warn( "EMuMuMuTree: Expected branch eVZ does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eVZ")
        else:
            self.eVZ_branch.SetAddress(<void*>&self.eVZ_value)

        #print "making eVetoCicTightIso"
        self.eVetoCicTightIso_branch = the_tree.GetBranch("eVetoCicTightIso")
        #if not self.eVetoCicTightIso_branch and "eVetoCicTightIso" not in self.complained:
        if not self.eVetoCicTightIso_branch and "eVetoCicTightIso":
            warnings.warn( "EMuMuMuTree: Expected branch eVetoCicTightIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eVetoCicTightIso")
        else:
            self.eVetoCicTightIso_branch.SetAddress(<void*>&self.eVetoCicTightIso_value)

        #print "making eVetoMVAIso"
        self.eVetoMVAIso_branch = the_tree.GetBranch("eVetoMVAIso")
        #if not self.eVetoMVAIso_branch and "eVetoMVAIso" not in self.complained:
        if not self.eVetoMVAIso_branch and "eVetoMVAIso":
            warnings.warn( "EMuMuMuTree: Expected branch eVetoMVAIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eVetoMVAIso")
        else:
            self.eVetoMVAIso_branch.SetAddress(<void*>&self.eVetoMVAIso_value)

        #print "making eVetoMVAIsoVtx"
        self.eVetoMVAIsoVtx_branch = the_tree.GetBranch("eVetoMVAIsoVtx")
        #if not self.eVetoMVAIsoVtx_branch and "eVetoMVAIsoVtx" not in self.complained:
        if not self.eVetoMVAIsoVtx_branch and "eVetoMVAIsoVtx":
            warnings.warn( "EMuMuMuTree: Expected branch eVetoMVAIsoVtx does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eVetoMVAIsoVtx")
        else:
            self.eVetoMVAIsoVtx_branch.SetAddress(<void*>&self.eVetoMVAIsoVtx_value)

        #print "making eVetoZH"
        self.eVetoZH_branch = the_tree.GetBranch("eVetoZH")
        #if not self.eVetoZH_branch and "eVetoZH" not in self.complained:
        if not self.eVetoZH_branch and "eVetoZH":
            warnings.warn( "EMuMuMuTree: Expected branch eVetoZH does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eVetoZH")
        else:
            self.eVetoZH_branch.SetAddress(<void*>&self.eVetoZH_value)

        #print "making eVetoZH_smallDR"
        self.eVetoZH_smallDR_branch = the_tree.GetBranch("eVetoZH_smallDR")
        #if not self.eVetoZH_smallDR_branch and "eVetoZH_smallDR" not in self.complained:
        if not self.eVetoZH_smallDR_branch and "eVetoZH_smallDR":
            warnings.warn( "EMuMuMuTree: Expected branch eVetoZH_smallDR does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eVetoZH_smallDR")
        else:
            self.eVetoZH_smallDR_branch.SetAddress(<void*>&self.eVetoZH_smallDR_value)

        #print "making eWWID"
        self.eWWID_branch = the_tree.GetBranch("eWWID")
        #if not self.eWWID_branch and "eWWID" not in self.complained:
        if not self.eWWID_branch and "eWWID":
            warnings.warn( "EMuMuMuTree: Expected branch eWWID does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eWWID")
        else:
            self.eWWID_branch.SetAddress(<void*>&self.eWWID_value)

        #print "making e_m1_CosThetaStar"
        self.e_m1_CosThetaStar_branch = the_tree.GetBranch("e_m1_CosThetaStar")
        #if not self.e_m1_CosThetaStar_branch and "e_m1_CosThetaStar" not in self.complained:
        if not self.e_m1_CosThetaStar_branch and "e_m1_CosThetaStar":
            warnings.warn( "EMuMuMuTree: Expected branch e_m1_CosThetaStar does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e_m1_CosThetaStar")
        else:
            self.e_m1_CosThetaStar_branch.SetAddress(<void*>&self.e_m1_CosThetaStar_value)

        #print "making e_m1_DPhi"
        self.e_m1_DPhi_branch = the_tree.GetBranch("e_m1_DPhi")
        #if not self.e_m1_DPhi_branch and "e_m1_DPhi" not in self.complained:
        if not self.e_m1_DPhi_branch and "e_m1_DPhi":
            warnings.warn( "EMuMuMuTree: Expected branch e_m1_DPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e_m1_DPhi")
        else:
            self.e_m1_DPhi_branch.SetAddress(<void*>&self.e_m1_DPhi_value)

        #print "making e_m1_DR"
        self.e_m1_DR_branch = the_tree.GetBranch("e_m1_DR")
        #if not self.e_m1_DR_branch and "e_m1_DR" not in self.complained:
        if not self.e_m1_DR_branch and "e_m1_DR":
            warnings.warn( "EMuMuMuTree: Expected branch e_m1_DR does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e_m1_DR")
        else:
            self.e_m1_DR_branch.SetAddress(<void*>&self.e_m1_DR_value)

        #print "making e_m1_Eta"
        self.e_m1_Eta_branch = the_tree.GetBranch("e_m1_Eta")
        #if not self.e_m1_Eta_branch and "e_m1_Eta" not in self.complained:
        if not self.e_m1_Eta_branch and "e_m1_Eta":
            warnings.warn( "EMuMuMuTree: Expected branch e_m1_Eta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e_m1_Eta")
        else:
            self.e_m1_Eta_branch.SetAddress(<void*>&self.e_m1_Eta_value)

        #print "making e_m1_Mass"
        self.e_m1_Mass_branch = the_tree.GetBranch("e_m1_Mass")
        #if not self.e_m1_Mass_branch and "e_m1_Mass" not in self.complained:
        if not self.e_m1_Mass_branch and "e_m1_Mass":
            warnings.warn( "EMuMuMuTree: Expected branch e_m1_Mass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e_m1_Mass")
        else:
            self.e_m1_Mass_branch.SetAddress(<void*>&self.e_m1_Mass_value)

        #print "making e_m1_MassFsr"
        self.e_m1_MassFsr_branch = the_tree.GetBranch("e_m1_MassFsr")
        #if not self.e_m1_MassFsr_branch and "e_m1_MassFsr" not in self.complained:
        if not self.e_m1_MassFsr_branch and "e_m1_MassFsr":
            warnings.warn( "EMuMuMuTree: Expected branch e_m1_MassFsr does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e_m1_MassFsr")
        else:
            self.e_m1_MassFsr_branch.SetAddress(<void*>&self.e_m1_MassFsr_value)

        #print "making e_m1_PZeta"
        self.e_m1_PZeta_branch = the_tree.GetBranch("e_m1_PZeta")
        #if not self.e_m1_PZeta_branch and "e_m1_PZeta" not in self.complained:
        if not self.e_m1_PZeta_branch and "e_m1_PZeta":
            warnings.warn( "EMuMuMuTree: Expected branch e_m1_PZeta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e_m1_PZeta")
        else:
            self.e_m1_PZeta_branch.SetAddress(<void*>&self.e_m1_PZeta_value)

        #print "making e_m1_PZetaVis"
        self.e_m1_PZetaVis_branch = the_tree.GetBranch("e_m1_PZetaVis")
        #if not self.e_m1_PZetaVis_branch and "e_m1_PZetaVis" not in self.complained:
        if not self.e_m1_PZetaVis_branch and "e_m1_PZetaVis":
            warnings.warn( "EMuMuMuTree: Expected branch e_m1_PZetaVis does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e_m1_PZetaVis")
        else:
            self.e_m1_PZetaVis_branch.SetAddress(<void*>&self.e_m1_PZetaVis_value)

        #print "making e_m1_Phi"
        self.e_m1_Phi_branch = the_tree.GetBranch("e_m1_Phi")
        #if not self.e_m1_Phi_branch and "e_m1_Phi" not in self.complained:
        if not self.e_m1_Phi_branch and "e_m1_Phi":
            warnings.warn( "EMuMuMuTree: Expected branch e_m1_Phi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e_m1_Phi")
        else:
            self.e_m1_Phi_branch.SetAddress(<void*>&self.e_m1_Phi_value)

        #print "making e_m1_Pt"
        self.e_m1_Pt_branch = the_tree.GetBranch("e_m1_Pt")
        #if not self.e_m1_Pt_branch and "e_m1_Pt" not in self.complained:
        if not self.e_m1_Pt_branch and "e_m1_Pt":
            warnings.warn( "EMuMuMuTree: Expected branch e_m1_Pt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e_m1_Pt")
        else:
            self.e_m1_Pt_branch.SetAddress(<void*>&self.e_m1_Pt_value)

        #print "making e_m1_PtFsr"
        self.e_m1_PtFsr_branch = the_tree.GetBranch("e_m1_PtFsr")
        #if not self.e_m1_PtFsr_branch and "e_m1_PtFsr" not in self.complained:
        if not self.e_m1_PtFsr_branch and "e_m1_PtFsr":
            warnings.warn( "EMuMuMuTree: Expected branch e_m1_PtFsr does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e_m1_PtFsr")
        else:
            self.e_m1_PtFsr_branch.SetAddress(<void*>&self.e_m1_PtFsr_value)

        #print "making e_m1_SS"
        self.e_m1_SS_branch = the_tree.GetBranch("e_m1_SS")
        #if not self.e_m1_SS_branch and "e_m1_SS" not in self.complained:
        if not self.e_m1_SS_branch and "e_m1_SS":
            warnings.warn( "EMuMuMuTree: Expected branch e_m1_SS does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e_m1_SS")
        else:
            self.e_m1_SS_branch.SetAddress(<void*>&self.e_m1_SS_value)

        #print "making e_m1_SVfitEta"
        self.e_m1_SVfitEta_branch = the_tree.GetBranch("e_m1_SVfitEta")
        #if not self.e_m1_SVfitEta_branch and "e_m1_SVfitEta" not in self.complained:
        if not self.e_m1_SVfitEta_branch and "e_m1_SVfitEta":
            warnings.warn( "EMuMuMuTree: Expected branch e_m1_SVfitEta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e_m1_SVfitEta")
        else:
            self.e_m1_SVfitEta_branch.SetAddress(<void*>&self.e_m1_SVfitEta_value)

        #print "making e_m1_SVfitMass"
        self.e_m1_SVfitMass_branch = the_tree.GetBranch("e_m1_SVfitMass")
        #if not self.e_m1_SVfitMass_branch and "e_m1_SVfitMass" not in self.complained:
        if not self.e_m1_SVfitMass_branch and "e_m1_SVfitMass":
            warnings.warn( "EMuMuMuTree: Expected branch e_m1_SVfitMass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e_m1_SVfitMass")
        else:
            self.e_m1_SVfitMass_branch.SetAddress(<void*>&self.e_m1_SVfitMass_value)

        #print "making e_m1_SVfitPhi"
        self.e_m1_SVfitPhi_branch = the_tree.GetBranch("e_m1_SVfitPhi")
        #if not self.e_m1_SVfitPhi_branch and "e_m1_SVfitPhi" not in self.complained:
        if not self.e_m1_SVfitPhi_branch and "e_m1_SVfitPhi":
            warnings.warn( "EMuMuMuTree: Expected branch e_m1_SVfitPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e_m1_SVfitPhi")
        else:
            self.e_m1_SVfitPhi_branch.SetAddress(<void*>&self.e_m1_SVfitPhi_value)

        #print "making e_m1_SVfitPt"
        self.e_m1_SVfitPt_branch = the_tree.GetBranch("e_m1_SVfitPt")
        #if not self.e_m1_SVfitPt_branch and "e_m1_SVfitPt" not in self.complained:
        if not self.e_m1_SVfitPt_branch and "e_m1_SVfitPt":
            warnings.warn( "EMuMuMuTree: Expected branch e_m1_SVfitPt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e_m1_SVfitPt")
        else:
            self.e_m1_SVfitPt_branch.SetAddress(<void*>&self.e_m1_SVfitPt_value)

        #print "making e_m1_ToMETDPhi_Ty1"
        self.e_m1_ToMETDPhi_Ty1_branch = the_tree.GetBranch("e_m1_ToMETDPhi_Ty1")
        #if not self.e_m1_ToMETDPhi_Ty1_branch and "e_m1_ToMETDPhi_Ty1" not in self.complained:
        if not self.e_m1_ToMETDPhi_Ty1_branch and "e_m1_ToMETDPhi_Ty1":
            warnings.warn( "EMuMuMuTree: Expected branch e_m1_ToMETDPhi_Ty1 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e_m1_ToMETDPhi_Ty1")
        else:
            self.e_m1_ToMETDPhi_Ty1_branch.SetAddress(<void*>&self.e_m1_ToMETDPhi_Ty1_value)

        #print "making e_m1_Zcompat"
        self.e_m1_Zcompat_branch = the_tree.GetBranch("e_m1_Zcompat")
        #if not self.e_m1_Zcompat_branch and "e_m1_Zcompat" not in self.complained:
        if not self.e_m1_Zcompat_branch and "e_m1_Zcompat":
            warnings.warn( "EMuMuMuTree: Expected branch e_m1_Zcompat does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e_m1_Zcompat")
        else:
            self.e_m1_Zcompat_branch.SetAddress(<void*>&self.e_m1_Zcompat_value)

        #print "making e_m2_CosThetaStar"
        self.e_m2_CosThetaStar_branch = the_tree.GetBranch("e_m2_CosThetaStar")
        #if not self.e_m2_CosThetaStar_branch and "e_m2_CosThetaStar" not in self.complained:
        if not self.e_m2_CosThetaStar_branch and "e_m2_CosThetaStar":
            warnings.warn( "EMuMuMuTree: Expected branch e_m2_CosThetaStar does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e_m2_CosThetaStar")
        else:
            self.e_m2_CosThetaStar_branch.SetAddress(<void*>&self.e_m2_CosThetaStar_value)

        #print "making e_m2_DPhi"
        self.e_m2_DPhi_branch = the_tree.GetBranch("e_m2_DPhi")
        #if not self.e_m2_DPhi_branch and "e_m2_DPhi" not in self.complained:
        if not self.e_m2_DPhi_branch and "e_m2_DPhi":
            warnings.warn( "EMuMuMuTree: Expected branch e_m2_DPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e_m2_DPhi")
        else:
            self.e_m2_DPhi_branch.SetAddress(<void*>&self.e_m2_DPhi_value)

        #print "making e_m2_DR"
        self.e_m2_DR_branch = the_tree.GetBranch("e_m2_DR")
        #if not self.e_m2_DR_branch and "e_m2_DR" not in self.complained:
        if not self.e_m2_DR_branch and "e_m2_DR":
            warnings.warn( "EMuMuMuTree: Expected branch e_m2_DR does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e_m2_DR")
        else:
            self.e_m2_DR_branch.SetAddress(<void*>&self.e_m2_DR_value)

        #print "making e_m2_Eta"
        self.e_m2_Eta_branch = the_tree.GetBranch("e_m2_Eta")
        #if not self.e_m2_Eta_branch and "e_m2_Eta" not in self.complained:
        if not self.e_m2_Eta_branch and "e_m2_Eta":
            warnings.warn( "EMuMuMuTree: Expected branch e_m2_Eta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e_m2_Eta")
        else:
            self.e_m2_Eta_branch.SetAddress(<void*>&self.e_m2_Eta_value)

        #print "making e_m2_Mass"
        self.e_m2_Mass_branch = the_tree.GetBranch("e_m2_Mass")
        #if not self.e_m2_Mass_branch and "e_m2_Mass" not in self.complained:
        if not self.e_m2_Mass_branch and "e_m2_Mass":
            warnings.warn( "EMuMuMuTree: Expected branch e_m2_Mass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e_m2_Mass")
        else:
            self.e_m2_Mass_branch.SetAddress(<void*>&self.e_m2_Mass_value)

        #print "making e_m2_MassFsr"
        self.e_m2_MassFsr_branch = the_tree.GetBranch("e_m2_MassFsr")
        #if not self.e_m2_MassFsr_branch and "e_m2_MassFsr" not in self.complained:
        if not self.e_m2_MassFsr_branch and "e_m2_MassFsr":
            warnings.warn( "EMuMuMuTree: Expected branch e_m2_MassFsr does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e_m2_MassFsr")
        else:
            self.e_m2_MassFsr_branch.SetAddress(<void*>&self.e_m2_MassFsr_value)

        #print "making e_m2_PZeta"
        self.e_m2_PZeta_branch = the_tree.GetBranch("e_m2_PZeta")
        #if not self.e_m2_PZeta_branch and "e_m2_PZeta" not in self.complained:
        if not self.e_m2_PZeta_branch and "e_m2_PZeta":
            warnings.warn( "EMuMuMuTree: Expected branch e_m2_PZeta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e_m2_PZeta")
        else:
            self.e_m2_PZeta_branch.SetAddress(<void*>&self.e_m2_PZeta_value)

        #print "making e_m2_PZetaVis"
        self.e_m2_PZetaVis_branch = the_tree.GetBranch("e_m2_PZetaVis")
        #if not self.e_m2_PZetaVis_branch and "e_m2_PZetaVis" not in self.complained:
        if not self.e_m2_PZetaVis_branch and "e_m2_PZetaVis":
            warnings.warn( "EMuMuMuTree: Expected branch e_m2_PZetaVis does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e_m2_PZetaVis")
        else:
            self.e_m2_PZetaVis_branch.SetAddress(<void*>&self.e_m2_PZetaVis_value)

        #print "making e_m2_Phi"
        self.e_m2_Phi_branch = the_tree.GetBranch("e_m2_Phi")
        #if not self.e_m2_Phi_branch and "e_m2_Phi" not in self.complained:
        if not self.e_m2_Phi_branch and "e_m2_Phi":
            warnings.warn( "EMuMuMuTree: Expected branch e_m2_Phi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e_m2_Phi")
        else:
            self.e_m2_Phi_branch.SetAddress(<void*>&self.e_m2_Phi_value)

        #print "making e_m2_Pt"
        self.e_m2_Pt_branch = the_tree.GetBranch("e_m2_Pt")
        #if not self.e_m2_Pt_branch and "e_m2_Pt" not in self.complained:
        if not self.e_m2_Pt_branch and "e_m2_Pt":
            warnings.warn( "EMuMuMuTree: Expected branch e_m2_Pt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e_m2_Pt")
        else:
            self.e_m2_Pt_branch.SetAddress(<void*>&self.e_m2_Pt_value)

        #print "making e_m2_PtFsr"
        self.e_m2_PtFsr_branch = the_tree.GetBranch("e_m2_PtFsr")
        #if not self.e_m2_PtFsr_branch and "e_m2_PtFsr" not in self.complained:
        if not self.e_m2_PtFsr_branch and "e_m2_PtFsr":
            warnings.warn( "EMuMuMuTree: Expected branch e_m2_PtFsr does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e_m2_PtFsr")
        else:
            self.e_m2_PtFsr_branch.SetAddress(<void*>&self.e_m2_PtFsr_value)

        #print "making e_m2_SS"
        self.e_m2_SS_branch = the_tree.GetBranch("e_m2_SS")
        #if not self.e_m2_SS_branch and "e_m2_SS" not in self.complained:
        if not self.e_m2_SS_branch and "e_m2_SS":
            warnings.warn( "EMuMuMuTree: Expected branch e_m2_SS does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e_m2_SS")
        else:
            self.e_m2_SS_branch.SetAddress(<void*>&self.e_m2_SS_value)

        #print "making e_m2_ToMETDPhi_Ty1"
        self.e_m2_ToMETDPhi_Ty1_branch = the_tree.GetBranch("e_m2_ToMETDPhi_Ty1")
        #if not self.e_m2_ToMETDPhi_Ty1_branch and "e_m2_ToMETDPhi_Ty1" not in self.complained:
        if not self.e_m2_ToMETDPhi_Ty1_branch and "e_m2_ToMETDPhi_Ty1":
            warnings.warn( "EMuMuMuTree: Expected branch e_m2_ToMETDPhi_Ty1 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e_m2_ToMETDPhi_Ty1")
        else:
            self.e_m2_ToMETDPhi_Ty1_branch.SetAddress(<void*>&self.e_m2_ToMETDPhi_Ty1_value)

        #print "making e_m2_Zcompat"
        self.e_m2_Zcompat_branch = the_tree.GetBranch("e_m2_Zcompat")
        #if not self.e_m2_Zcompat_branch and "e_m2_Zcompat" not in self.complained:
        if not self.e_m2_Zcompat_branch and "e_m2_Zcompat":
            warnings.warn( "EMuMuMuTree: Expected branch e_m2_Zcompat does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e_m2_Zcompat")
        else:
            self.e_m2_Zcompat_branch.SetAddress(<void*>&self.e_m2_Zcompat_value)

        #print "making e_m3_CosThetaStar"
        self.e_m3_CosThetaStar_branch = the_tree.GetBranch("e_m3_CosThetaStar")
        #if not self.e_m3_CosThetaStar_branch and "e_m3_CosThetaStar" not in self.complained:
        if not self.e_m3_CosThetaStar_branch and "e_m3_CosThetaStar":
            warnings.warn( "EMuMuMuTree: Expected branch e_m3_CosThetaStar does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e_m3_CosThetaStar")
        else:
            self.e_m3_CosThetaStar_branch.SetAddress(<void*>&self.e_m3_CosThetaStar_value)

        #print "making e_m3_DPhi"
        self.e_m3_DPhi_branch = the_tree.GetBranch("e_m3_DPhi")
        #if not self.e_m3_DPhi_branch and "e_m3_DPhi" not in self.complained:
        if not self.e_m3_DPhi_branch and "e_m3_DPhi":
            warnings.warn( "EMuMuMuTree: Expected branch e_m3_DPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e_m3_DPhi")
        else:
            self.e_m3_DPhi_branch.SetAddress(<void*>&self.e_m3_DPhi_value)

        #print "making e_m3_DR"
        self.e_m3_DR_branch = the_tree.GetBranch("e_m3_DR")
        #if not self.e_m3_DR_branch and "e_m3_DR" not in self.complained:
        if not self.e_m3_DR_branch and "e_m3_DR":
            warnings.warn( "EMuMuMuTree: Expected branch e_m3_DR does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e_m3_DR")
        else:
            self.e_m3_DR_branch.SetAddress(<void*>&self.e_m3_DR_value)

        #print "making e_m3_Eta"
        self.e_m3_Eta_branch = the_tree.GetBranch("e_m3_Eta")
        #if not self.e_m3_Eta_branch and "e_m3_Eta" not in self.complained:
        if not self.e_m3_Eta_branch and "e_m3_Eta":
            warnings.warn( "EMuMuMuTree: Expected branch e_m3_Eta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e_m3_Eta")
        else:
            self.e_m3_Eta_branch.SetAddress(<void*>&self.e_m3_Eta_value)

        #print "making e_m3_Mass"
        self.e_m3_Mass_branch = the_tree.GetBranch("e_m3_Mass")
        #if not self.e_m3_Mass_branch and "e_m3_Mass" not in self.complained:
        if not self.e_m3_Mass_branch and "e_m3_Mass":
            warnings.warn( "EMuMuMuTree: Expected branch e_m3_Mass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e_m3_Mass")
        else:
            self.e_m3_Mass_branch.SetAddress(<void*>&self.e_m3_Mass_value)

        #print "making e_m3_MassFsr"
        self.e_m3_MassFsr_branch = the_tree.GetBranch("e_m3_MassFsr")
        #if not self.e_m3_MassFsr_branch and "e_m3_MassFsr" not in self.complained:
        if not self.e_m3_MassFsr_branch and "e_m3_MassFsr":
            warnings.warn( "EMuMuMuTree: Expected branch e_m3_MassFsr does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e_m3_MassFsr")
        else:
            self.e_m3_MassFsr_branch.SetAddress(<void*>&self.e_m3_MassFsr_value)

        #print "making e_m3_PZeta"
        self.e_m3_PZeta_branch = the_tree.GetBranch("e_m3_PZeta")
        #if not self.e_m3_PZeta_branch and "e_m3_PZeta" not in self.complained:
        if not self.e_m3_PZeta_branch and "e_m3_PZeta":
            warnings.warn( "EMuMuMuTree: Expected branch e_m3_PZeta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e_m3_PZeta")
        else:
            self.e_m3_PZeta_branch.SetAddress(<void*>&self.e_m3_PZeta_value)

        #print "making e_m3_PZetaVis"
        self.e_m3_PZetaVis_branch = the_tree.GetBranch("e_m3_PZetaVis")
        #if not self.e_m3_PZetaVis_branch and "e_m3_PZetaVis" not in self.complained:
        if not self.e_m3_PZetaVis_branch and "e_m3_PZetaVis":
            warnings.warn( "EMuMuMuTree: Expected branch e_m3_PZetaVis does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e_m3_PZetaVis")
        else:
            self.e_m3_PZetaVis_branch.SetAddress(<void*>&self.e_m3_PZetaVis_value)

        #print "making e_m3_Phi"
        self.e_m3_Phi_branch = the_tree.GetBranch("e_m3_Phi")
        #if not self.e_m3_Phi_branch and "e_m3_Phi" not in self.complained:
        if not self.e_m3_Phi_branch and "e_m3_Phi":
            warnings.warn( "EMuMuMuTree: Expected branch e_m3_Phi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e_m3_Phi")
        else:
            self.e_m3_Phi_branch.SetAddress(<void*>&self.e_m3_Phi_value)

        #print "making e_m3_Pt"
        self.e_m3_Pt_branch = the_tree.GetBranch("e_m3_Pt")
        #if not self.e_m3_Pt_branch and "e_m3_Pt" not in self.complained:
        if not self.e_m3_Pt_branch and "e_m3_Pt":
            warnings.warn( "EMuMuMuTree: Expected branch e_m3_Pt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e_m3_Pt")
        else:
            self.e_m3_Pt_branch.SetAddress(<void*>&self.e_m3_Pt_value)

        #print "making e_m3_PtFsr"
        self.e_m3_PtFsr_branch = the_tree.GetBranch("e_m3_PtFsr")
        #if not self.e_m3_PtFsr_branch and "e_m3_PtFsr" not in self.complained:
        if not self.e_m3_PtFsr_branch and "e_m3_PtFsr":
            warnings.warn( "EMuMuMuTree: Expected branch e_m3_PtFsr does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e_m3_PtFsr")
        else:
            self.e_m3_PtFsr_branch.SetAddress(<void*>&self.e_m3_PtFsr_value)

        #print "making e_m3_SS"
        self.e_m3_SS_branch = the_tree.GetBranch("e_m3_SS")
        #if not self.e_m3_SS_branch and "e_m3_SS" not in self.complained:
        if not self.e_m3_SS_branch and "e_m3_SS":
            warnings.warn( "EMuMuMuTree: Expected branch e_m3_SS does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e_m3_SS")
        else:
            self.e_m3_SS_branch.SetAddress(<void*>&self.e_m3_SS_value)

        #print "making e_m3_SVfitEta"
        self.e_m3_SVfitEta_branch = the_tree.GetBranch("e_m3_SVfitEta")
        #if not self.e_m3_SVfitEta_branch and "e_m3_SVfitEta" not in self.complained:
        if not self.e_m3_SVfitEta_branch and "e_m3_SVfitEta":
            warnings.warn( "EMuMuMuTree: Expected branch e_m3_SVfitEta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e_m3_SVfitEta")
        else:
            self.e_m3_SVfitEta_branch.SetAddress(<void*>&self.e_m3_SVfitEta_value)

        #print "making e_m3_SVfitMass"
        self.e_m3_SVfitMass_branch = the_tree.GetBranch("e_m3_SVfitMass")
        #if not self.e_m3_SVfitMass_branch and "e_m3_SVfitMass" not in self.complained:
        if not self.e_m3_SVfitMass_branch and "e_m3_SVfitMass":
            warnings.warn( "EMuMuMuTree: Expected branch e_m3_SVfitMass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e_m3_SVfitMass")
        else:
            self.e_m3_SVfitMass_branch.SetAddress(<void*>&self.e_m3_SVfitMass_value)

        #print "making e_m3_SVfitPhi"
        self.e_m3_SVfitPhi_branch = the_tree.GetBranch("e_m3_SVfitPhi")
        #if not self.e_m3_SVfitPhi_branch and "e_m3_SVfitPhi" not in self.complained:
        if not self.e_m3_SVfitPhi_branch and "e_m3_SVfitPhi":
            warnings.warn( "EMuMuMuTree: Expected branch e_m3_SVfitPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e_m3_SVfitPhi")
        else:
            self.e_m3_SVfitPhi_branch.SetAddress(<void*>&self.e_m3_SVfitPhi_value)

        #print "making e_m3_SVfitPt"
        self.e_m3_SVfitPt_branch = the_tree.GetBranch("e_m3_SVfitPt")
        #if not self.e_m3_SVfitPt_branch and "e_m3_SVfitPt" not in self.complained:
        if not self.e_m3_SVfitPt_branch and "e_m3_SVfitPt":
            warnings.warn( "EMuMuMuTree: Expected branch e_m3_SVfitPt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e_m3_SVfitPt")
        else:
            self.e_m3_SVfitPt_branch.SetAddress(<void*>&self.e_m3_SVfitPt_value)

        #print "making e_m3_ToMETDPhi_Ty1"
        self.e_m3_ToMETDPhi_Ty1_branch = the_tree.GetBranch("e_m3_ToMETDPhi_Ty1")
        #if not self.e_m3_ToMETDPhi_Ty1_branch and "e_m3_ToMETDPhi_Ty1" not in self.complained:
        if not self.e_m3_ToMETDPhi_Ty1_branch and "e_m3_ToMETDPhi_Ty1":
            warnings.warn( "EMuMuMuTree: Expected branch e_m3_ToMETDPhi_Ty1 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e_m3_ToMETDPhi_Ty1")
        else:
            self.e_m3_ToMETDPhi_Ty1_branch.SetAddress(<void*>&self.e_m3_ToMETDPhi_Ty1_value)

        #print "making e_m3_Zcompat"
        self.e_m3_Zcompat_branch = the_tree.GetBranch("e_m3_Zcompat")
        #if not self.e_m3_Zcompat_branch and "e_m3_Zcompat" not in self.complained:
        if not self.e_m3_Zcompat_branch and "e_m3_Zcompat":
            warnings.warn( "EMuMuMuTree: Expected branch e_m3_Zcompat does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e_m3_Zcompat")
        else:
            self.e_m3_Zcompat_branch.SetAddress(<void*>&self.e_m3_Zcompat_value)

        #print "making edECorrReg_2012Jul13ReReco"
        self.edECorrReg_2012Jul13ReReco_branch = the_tree.GetBranch("edECorrReg_2012Jul13ReReco")
        #if not self.edECorrReg_2012Jul13ReReco_branch and "edECorrReg_2012Jul13ReReco" not in self.complained:
        if not self.edECorrReg_2012Jul13ReReco_branch and "edECorrReg_2012Jul13ReReco":
            warnings.warn( "EMuMuMuTree: Expected branch edECorrReg_2012Jul13ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("edECorrReg_2012Jul13ReReco")
        else:
            self.edECorrReg_2012Jul13ReReco_branch.SetAddress(<void*>&self.edECorrReg_2012Jul13ReReco_value)

        #print "making edECorrReg_Fall11"
        self.edECorrReg_Fall11_branch = the_tree.GetBranch("edECorrReg_Fall11")
        #if not self.edECorrReg_Fall11_branch and "edECorrReg_Fall11" not in self.complained:
        if not self.edECorrReg_Fall11_branch and "edECorrReg_Fall11":
            warnings.warn( "EMuMuMuTree: Expected branch edECorrReg_Fall11 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("edECorrReg_Fall11")
        else:
            self.edECorrReg_Fall11_branch.SetAddress(<void*>&self.edECorrReg_Fall11_value)

        #print "making edECorrReg_Jan16ReReco"
        self.edECorrReg_Jan16ReReco_branch = the_tree.GetBranch("edECorrReg_Jan16ReReco")
        #if not self.edECorrReg_Jan16ReReco_branch and "edECorrReg_Jan16ReReco" not in self.complained:
        if not self.edECorrReg_Jan16ReReco_branch and "edECorrReg_Jan16ReReco":
            warnings.warn( "EMuMuMuTree: Expected branch edECorrReg_Jan16ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("edECorrReg_Jan16ReReco")
        else:
            self.edECorrReg_Jan16ReReco_branch.SetAddress(<void*>&self.edECorrReg_Jan16ReReco_value)

        #print "making edECorrReg_Summer12_DR53X_HCP2012"
        self.edECorrReg_Summer12_DR53X_HCP2012_branch = the_tree.GetBranch("edECorrReg_Summer12_DR53X_HCP2012")
        #if not self.edECorrReg_Summer12_DR53X_HCP2012_branch and "edECorrReg_Summer12_DR53X_HCP2012" not in self.complained:
        if not self.edECorrReg_Summer12_DR53X_HCP2012_branch and "edECorrReg_Summer12_DR53X_HCP2012":
            warnings.warn( "EMuMuMuTree: Expected branch edECorrReg_Summer12_DR53X_HCP2012 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("edECorrReg_Summer12_DR53X_HCP2012")
        else:
            self.edECorrReg_Summer12_DR53X_HCP2012_branch.SetAddress(<void*>&self.edECorrReg_Summer12_DR53X_HCP2012_value)

        #print "making edECorrSmearedNoReg_2012Jul13ReReco"
        self.edECorrSmearedNoReg_2012Jul13ReReco_branch = the_tree.GetBranch("edECorrSmearedNoReg_2012Jul13ReReco")
        #if not self.edECorrSmearedNoReg_2012Jul13ReReco_branch and "edECorrSmearedNoReg_2012Jul13ReReco" not in self.complained:
        if not self.edECorrSmearedNoReg_2012Jul13ReReco_branch and "edECorrSmearedNoReg_2012Jul13ReReco":
            warnings.warn( "EMuMuMuTree: Expected branch edECorrSmearedNoReg_2012Jul13ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("edECorrSmearedNoReg_2012Jul13ReReco")
        else:
            self.edECorrSmearedNoReg_2012Jul13ReReco_branch.SetAddress(<void*>&self.edECorrSmearedNoReg_2012Jul13ReReco_value)

        #print "making edECorrSmearedNoReg_Fall11"
        self.edECorrSmearedNoReg_Fall11_branch = the_tree.GetBranch("edECorrSmearedNoReg_Fall11")
        #if not self.edECorrSmearedNoReg_Fall11_branch and "edECorrSmearedNoReg_Fall11" not in self.complained:
        if not self.edECorrSmearedNoReg_Fall11_branch and "edECorrSmearedNoReg_Fall11":
            warnings.warn( "EMuMuMuTree: Expected branch edECorrSmearedNoReg_Fall11 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("edECorrSmearedNoReg_Fall11")
        else:
            self.edECorrSmearedNoReg_Fall11_branch.SetAddress(<void*>&self.edECorrSmearedNoReg_Fall11_value)

        #print "making edECorrSmearedNoReg_Jan16ReReco"
        self.edECorrSmearedNoReg_Jan16ReReco_branch = the_tree.GetBranch("edECorrSmearedNoReg_Jan16ReReco")
        #if not self.edECorrSmearedNoReg_Jan16ReReco_branch and "edECorrSmearedNoReg_Jan16ReReco" not in self.complained:
        if not self.edECorrSmearedNoReg_Jan16ReReco_branch and "edECorrSmearedNoReg_Jan16ReReco":
            warnings.warn( "EMuMuMuTree: Expected branch edECorrSmearedNoReg_Jan16ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("edECorrSmearedNoReg_Jan16ReReco")
        else:
            self.edECorrSmearedNoReg_Jan16ReReco_branch.SetAddress(<void*>&self.edECorrSmearedNoReg_Jan16ReReco_value)

        #print "making edECorrSmearedNoReg_Summer12_DR53X_HCP2012"
        self.edECorrSmearedNoReg_Summer12_DR53X_HCP2012_branch = the_tree.GetBranch("edECorrSmearedNoReg_Summer12_DR53X_HCP2012")
        #if not self.edECorrSmearedNoReg_Summer12_DR53X_HCP2012_branch and "edECorrSmearedNoReg_Summer12_DR53X_HCP2012" not in self.complained:
        if not self.edECorrSmearedNoReg_Summer12_DR53X_HCP2012_branch and "edECorrSmearedNoReg_Summer12_DR53X_HCP2012":
            warnings.warn( "EMuMuMuTree: Expected branch edECorrSmearedNoReg_Summer12_DR53X_HCP2012 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("edECorrSmearedNoReg_Summer12_DR53X_HCP2012")
        else:
            self.edECorrSmearedNoReg_Summer12_DR53X_HCP2012_branch.SetAddress(<void*>&self.edECorrSmearedNoReg_Summer12_DR53X_HCP2012_value)

        #print "making edECorrSmearedReg_2012Jul13ReReco"
        self.edECorrSmearedReg_2012Jul13ReReco_branch = the_tree.GetBranch("edECorrSmearedReg_2012Jul13ReReco")
        #if not self.edECorrSmearedReg_2012Jul13ReReco_branch and "edECorrSmearedReg_2012Jul13ReReco" not in self.complained:
        if not self.edECorrSmearedReg_2012Jul13ReReco_branch and "edECorrSmearedReg_2012Jul13ReReco":
            warnings.warn( "EMuMuMuTree: Expected branch edECorrSmearedReg_2012Jul13ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("edECorrSmearedReg_2012Jul13ReReco")
        else:
            self.edECorrSmearedReg_2012Jul13ReReco_branch.SetAddress(<void*>&self.edECorrSmearedReg_2012Jul13ReReco_value)

        #print "making edECorrSmearedReg_Fall11"
        self.edECorrSmearedReg_Fall11_branch = the_tree.GetBranch("edECorrSmearedReg_Fall11")
        #if not self.edECorrSmearedReg_Fall11_branch and "edECorrSmearedReg_Fall11" not in self.complained:
        if not self.edECorrSmearedReg_Fall11_branch and "edECorrSmearedReg_Fall11":
            warnings.warn( "EMuMuMuTree: Expected branch edECorrSmearedReg_Fall11 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("edECorrSmearedReg_Fall11")
        else:
            self.edECorrSmearedReg_Fall11_branch.SetAddress(<void*>&self.edECorrSmearedReg_Fall11_value)

        #print "making edECorrSmearedReg_Jan16ReReco"
        self.edECorrSmearedReg_Jan16ReReco_branch = the_tree.GetBranch("edECorrSmearedReg_Jan16ReReco")
        #if not self.edECorrSmearedReg_Jan16ReReco_branch and "edECorrSmearedReg_Jan16ReReco" not in self.complained:
        if not self.edECorrSmearedReg_Jan16ReReco_branch and "edECorrSmearedReg_Jan16ReReco":
            warnings.warn( "EMuMuMuTree: Expected branch edECorrSmearedReg_Jan16ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("edECorrSmearedReg_Jan16ReReco")
        else:
            self.edECorrSmearedReg_Jan16ReReco_branch.SetAddress(<void*>&self.edECorrSmearedReg_Jan16ReReco_value)

        #print "making edECorrSmearedReg_Summer12_DR53X_HCP2012"
        self.edECorrSmearedReg_Summer12_DR53X_HCP2012_branch = the_tree.GetBranch("edECorrSmearedReg_Summer12_DR53X_HCP2012")
        #if not self.edECorrSmearedReg_Summer12_DR53X_HCP2012_branch and "edECorrSmearedReg_Summer12_DR53X_HCP2012" not in self.complained:
        if not self.edECorrSmearedReg_Summer12_DR53X_HCP2012_branch and "edECorrSmearedReg_Summer12_DR53X_HCP2012":
            warnings.warn( "EMuMuMuTree: Expected branch edECorrSmearedReg_Summer12_DR53X_HCP2012 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("edECorrSmearedReg_Summer12_DR53X_HCP2012")
        else:
            self.edECorrSmearedReg_Summer12_DR53X_HCP2012_branch.SetAddress(<void*>&self.edECorrSmearedReg_Summer12_DR53X_HCP2012_value)

        #print "making edeltaEtaSuperClusterTrackAtVtx"
        self.edeltaEtaSuperClusterTrackAtVtx_branch = the_tree.GetBranch("edeltaEtaSuperClusterTrackAtVtx")
        #if not self.edeltaEtaSuperClusterTrackAtVtx_branch and "edeltaEtaSuperClusterTrackAtVtx" not in self.complained:
        if not self.edeltaEtaSuperClusterTrackAtVtx_branch and "edeltaEtaSuperClusterTrackAtVtx":
            warnings.warn( "EMuMuMuTree: Expected branch edeltaEtaSuperClusterTrackAtVtx does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("edeltaEtaSuperClusterTrackAtVtx")
        else:
            self.edeltaEtaSuperClusterTrackAtVtx_branch.SetAddress(<void*>&self.edeltaEtaSuperClusterTrackAtVtx_value)

        #print "making edeltaPhiSuperClusterTrackAtVtx"
        self.edeltaPhiSuperClusterTrackAtVtx_branch = the_tree.GetBranch("edeltaPhiSuperClusterTrackAtVtx")
        #if not self.edeltaPhiSuperClusterTrackAtVtx_branch and "edeltaPhiSuperClusterTrackAtVtx" not in self.complained:
        if not self.edeltaPhiSuperClusterTrackAtVtx_branch and "edeltaPhiSuperClusterTrackAtVtx":
            warnings.warn( "EMuMuMuTree: Expected branch edeltaPhiSuperClusterTrackAtVtx does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("edeltaPhiSuperClusterTrackAtVtx")
        else:
            self.edeltaPhiSuperClusterTrackAtVtx_branch.SetAddress(<void*>&self.edeltaPhiSuperClusterTrackAtVtx_value)

        #print "making eeSuperClusterOverP"
        self.eeSuperClusterOverP_branch = the_tree.GetBranch("eeSuperClusterOverP")
        #if not self.eeSuperClusterOverP_branch and "eeSuperClusterOverP" not in self.complained:
        if not self.eeSuperClusterOverP_branch and "eeSuperClusterOverP":
            warnings.warn( "EMuMuMuTree: Expected branch eeSuperClusterOverP does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eeSuperClusterOverP")
        else:
            self.eeSuperClusterOverP_branch.SetAddress(<void*>&self.eeSuperClusterOverP_value)

        #print "making eecalEnergy"
        self.eecalEnergy_branch = the_tree.GetBranch("eecalEnergy")
        #if not self.eecalEnergy_branch and "eecalEnergy" not in self.complained:
        if not self.eecalEnergy_branch and "eecalEnergy":
            warnings.warn( "EMuMuMuTree: Expected branch eecalEnergy does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eecalEnergy")
        else:
            self.eecalEnergy_branch.SetAddress(<void*>&self.eecalEnergy_value)

        #print "making efBrem"
        self.efBrem_branch = the_tree.GetBranch("efBrem")
        #if not self.efBrem_branch and "efBrem" not in self.complained:
        if not self.efBrem_branch and "efBrem":
            warnings.warn( "EMuMuMuTree: Expected branch efBrem does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("efBrem")
        else:
            self.efBrem_branch.SetAddress(<void*>&self.efBrem_value)

        #print "making etrackMomentumAtVtxP"
        self.etrackMomentumAtVtxP_branch = the_tree.GetBranch("etrackMomentumAtVtxP")
        #if not self.etrackMomentumAtVtxP_branch and "etrackMomentumAtVtxP" not in self.complained:
        if not self.etrackMomentumAtVtxP_branch and "etrackMomentumAtVtxP":
            warnings.warn( "EMuMuMuTree: Expected branch etrackMomentumAtVtxP does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("etrackMomentumAtVtxP")
        else:
            self.etrackMomentumAtVtxP_branch.SetAddress(<void*>&self.etrackMomentumAtVtxP_value)

        #print "making evt"
        self.evt_branch = the_tree.GetBranch("evt")
        #if not self.evt_branch and "evt" not in self.complained:
        if not self.evt_branch and "evt":
            warnings.warn( "EMuMuMuTree: Expected branch evt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("evt")
        else:
            self.evt_branch.SetAddress(<void*>&self.evt_value)

        #print "making isGtautau"
        self.isGtautau_branch = the_tree.GetBranch("isGtautau")
        #if not self.isGtautau_branch and "isGtautau" not in self.complained:
        if not self.isGtautau_branch and "isGtautau":
            warnings.warn( "EMuMuMuTree: Expected branch isGtautau does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("isGtautau")
        else:
            self.isGtautau_branch.SetAddress(<void*>&self.isGtautau_value)

        #print "making isWmunu"
        self.isWmunu_branch = the_tree.GetBranch("isWmunu")
        #if not self.isWmunu_branch and "isWmunu" not in self.complained:
        if not self.isWmunu_branch and "isWmunu":
            warnings.warn( "EMuMuMuTree: Expected branch isWmunu does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("isWmunu")
        else:
            self.isWmunu_branch.SetAddress(<void*>&self.isWmunu_value)

        #print "making isWtaunu"
        self.isWtaunu_branch = the_tree.GetBranch("isWtaunu")
        #if not self.isWtaunu_branch and "isWtaunu" not in self.complained:
        if not self.isWtaunu_branch and "isWtaunu":
            warnings.warn( "EMuMuMuTree: Expected branch isWtaunu does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("isWtaunu")
        else:
            self.isWtaunu_branch.SetAddress(<void*>&self.isWtaunu_value)

        #print "making isZtautau"
        self.isZtautau_branch = the_tree.GetBranch("isZtautau")
        #if not self.isZtautau_branch and "isZtautau" not in self.complained:
        if not self.isZtautau_branch and "isZtautau":
            warnings.warn( "EMuMuMuTree: Expected branch isZtautau does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("isZtautau")
        else:
            self.isZtautau_branch.SetAddress(<void*>&self.isZtautau_value)

        #print "making isdata"
        self.isdata_branch = the_tree.GetBranch("isdata")
        #if not self.isdata_branch and "isdata" not in self.complained:
        if not self.isdata_branch and "isdata":
            warnings.warn( "EMuMuMuTree: Expected branch isdata does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("isdata")
        else:
            self.isdata_branch.SetAddress(<void*>&self.isdata_value)

        #print "making isoMu24eta2p1Group"
        self.isoMu24eta2p1Group_branch = the_tree.GetBranch("isoMu24eta2p1Group")
        #if not self.isoMu24eta2p1Group_branch and "isoMu24eta2p1Group" not in self.complained:
        if not self.isoMu24eta2p1Group_branch and "isoMu24eta2p1Group":
            warnings.warn( "EMuMuMuTree: Expected branch isoMu24eta2p1Group does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("isoMu24eta2p1Group")
        else:
            self.isoMu24eta2p1Group_branch.SetAddress(<void*>&self.isoMu24eta2p1Group_value)

        #print "making isoMu24eta2p1Pass"
        self.isoMu24eta2p1Pass_branch = the_tree.GetBranch("isoMu24eta2p1Pass")
        #if not self.isoMu24eta2p1Pass_branch and "isoMu24eta2p1Pass" not in self.complained:
        if not self.isoMu24eta2p1Pass_branch and "isoMu24eta2p1Pass":
            warnings.warn( "EMuMuMuTree: Expected branch isoMu24eta2p1Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("isoMu24eta2p1Pass")
        else:
            self.isoMu24eta2p1Pass_branch.SetAddress(<void*>&self.isoMu24eta2p1Pass_value)

        #print "making isoMu24eta2p1Prescale"
        self.isoMu24eta2p1Prescale_branch = the_tree.GetBranch("isoMu24eta2p1Prescale")
        #if not self.isoMu24eta2p1Prescale_branch and "isoMu24eta2p1Prescale" not in self.complained:
        if not self.isoMu24eta2p1Prescale_branch and "isoMu24eta2p1Prescale":
            warnings.warn( "EMuMuMuTree: Expected branch isoMu24eta2p1Prescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("isoMu24eta2p1Prescale")
        else:
            self.isoMu24eta2p1Prescale_branch.SetAddress(<void*>&self.isoMu24eta2p1Prescale_value)

        #print "making isoMuGroup"
        self.isoMuGroup_branch = the_tree.GetBranch("isoMuGroup")
        #if not self.isoMuGroup_branch and "isoMuGroup" not in self.complained:
        if not self.isoMuGroup_branch and "isoMuGroup":
            warnings.warn( "EMuMuMuTree: Expected branch isoMuGroup does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("isoMuGroup")
        else:
            self.isoMuGroup_branch.SetAddress(<void*>&self.isoMuGroup_value)

        #print "making isoMuPass"
        self.isoMuPass_branch = the_tree.GetBranch("isoMuPass")
        #if not self.isoMuPass_branch and "isoMuPass" not in self.complained:
        if not self.isoMuPass_branch and "isoMuPass":
            warnings.warn( "EMuMuMuTree: Expected branch isoMuPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("isoMuPass")
        else:
            self.isoMuPass_branch.SetAddress(<void*>&self.isoMuPass_value)

        #print "making isoMuPrescale"
        self.isoMuPrescale_branch = the_tree.GetBranch("isoMuPrescale")
        #if not self.isoMuPrescale_branch and "isoMuPrescale" not in self.complained:
        if not self.isoMuPrescale_branch and "isoMuPrescale":
            warnings.warn( "EMuMuMuTree: Expected branch isoMuPrescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("isoMuPrescale")
        else:
            self.isoMuPrescale_branch.SetAddress(<void*>&self.isoMuPrescale_value)

        #print "making isoMuTauGroup"
        self.isoMuTauGroup_branch = the_tree.GetBranch("isoMuTauGroup")
        #if not self.isoMuTauGroup_branch and "isoMuTauGroup" not in self.complained:
        if not self.isoMuTauGroup_branch and "isoMuTauGroup":
            warnings.warn( "EMuMuMuTree: Expected branch isoMuTauGroup does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("isoMuTauGroup")
        else:
            self.isoMuTauGroup_branch.SetAddress(<void*>&self.isoMuTauGroup_value)

        #print "making isoMuTauPass"
        self.isoMuTauPass_branch = the_tree.GetBranch("isoMuTauPass")
        #if not self.isoMuTauPass_branch and "isoMuTauPass" not in self.complained:
        if not self.isoMuTauPass_branch and "isoMuTauPass":
            warnings.warn( "EMuMuMuTree: Expected branch isoMuTauPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("isoMuTauPass")
        else:
            self.isoMuTauPass_branch.SetAddress(<void*>&self.isoMuTauPass_value)

        #print "making isoMuTauPrescale"
        self.isoMuTauPrescale_branch = the_tree.GetBranch("isoMuTauPrescale")
        #if not self.isoMuTauPrescale_branch and "isoMuTauPrescale" not in self.complained:
        if not self.isoMuTauPrescale_branch and "isoMuTauPrescale":
            warnings.warn( "EMuMuMuTree: Expected branch isoMuTauPrescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("isoMuTauPrescale")
        else:
            self.isoMuTauPrescale_branch.SetAddress(<void*>&self.isoMuTauPrescale_value)

        #print "making jetVeto20"
        self.jetVeto20_branch = the_tree.GetBranch("jetVeto20")
        #if not self.jetVeto20_branch and "jetVeto20" not in self.complained:
        if not self.jetVeto20_branch and "jetVeto20":
            warnings.warn( "EMuMuMuTree: Expected branch jetVeto20 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto20")
        else:
            self.jetVeto20_branch.SetAddress(<void*>&self.jetVeto20_value)

        #print "making jetVeto20_DR05"
        self.jetVeto20_DR05_branch = the_tree.GetBranch("jetVeto20_DR05")
        #if not self.jetVeto20_DR05_branch and "jetVeto20_DR05" not in self.complained:
        if not self.jetVeto20_DR05_branch and "jetVeto20_DR05":
            warnings.warn( "EMuMuMuTree: Expected branch jetVeto20_DR05 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto20_DR05")
        else:
            self.jetVeto20_DR05_branch.SetAddress(<void*>&self.jetVeto20_DR05_value)

        #print "making jetVeto30"
        self.jetVeto30_branch = the_tree.GetBranch("jetVeto30")
        #if not self.jetVeto30_branch and "jetVeto30" not in self.complained:
        if not self.jetVeto30_branch and "jetVeto30":
            warnings.warn( "EMuMuMuTree: Expected branch jetVeto30 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30")
        else:
            self.jetVeto30_branch.SetAddress(<void*>&self.jetVeto30_value)

        #print "making jetVeto30_DR05"
        self.jetVeto30_DR05_branch = the_tree.GetBranch("jetVeto30_DR05")
        #if not self.jetVeto30_DR05_branch and "jetVeto30_DR05" not in self.complained:
        if not self.jetVeto30_DR05_branch and "jetVeto30_DR05":
            warnings.warn( "EMuMuMuTree: Expected branch jetVeto30_DR05 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_DR05")
        else:
            self.jetVeto30_DR05_branch.SetAddress(<void*>&self.jetVeto30_DR05_value)

        #print "making jetVeto40"
        self.jetVeto40_branch = the_tree.GetBranch("jetVeto40")
        #if not self.jetVeto40_branch and "jetVeto40" not in self.complained:
        if not self.jetVeto40_branch and "jetVeto40":
            warnings.warn( "EMuMuMuTree: Expected branch jetVeto40 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto40")
        else:
            self.jetVeto40_branch.SetAddress(<void*>&self.jetVeto40_value)

        #print "making jetVeto40_DR05"
        self.jetVeto40_DR05_branch = the_tree.GetBranch("jetVeto40_DR05")
        #if not self.jetVeto40_DR05_branch and "jetVeto40_DR05" not in self.complained:
        if not self.jetVeto40_DR05_branch and "jetVeto40_DR05":
            warnings.warn( "EMuMuMuTree: Expected branch jetVeto40_DR05 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto40_DR05")
        else:
            self.jetVeto40_DR05_branch.SetAddress(<void*>&self.jetVeto40_DR05_value)

        #print "making lumi"
        self.lumi_branch = the_tree.GetBranch("lumi")
        #if not self.lumi_branch and "lumi" not in self.complained:
        if not self.lumi_branch and "lumi":
            warnings.warn( "EMuMuMuTree: Expected branch lumi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lumi")
        else:
            self.lumi_branch.SetAddress(<void*>&self.lumi_value)

        #print "making m1AbsEta"
        self.m1AbsEta_branch = the_tree.GetBranch("m1AbsEta")
        #if not self.m1AbsEta_branch and "m1AbsEta" not in self.complained:
        if not self.m1AbsEta_branch and "m1AbsEta":
            warnings.warn( "EMuMuMuTree: Expected branch m1AbsEta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1AbsEta")
        else:
            self.m1AbsEta_branch.SetAddress(<void*>&self.m1AbsEta_value)

        #print "making m1Charge"
        self.m1Charge_branch = the_tree.GetBranch("m1Charge")
        #if not self.m1Charge_branch and "m1Charge" not in self.complained:
        if not self.m1Charge_branch and "m1Charge":
            warnings.warn( "EMuMuMuTree: Expected branch m1Charge does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1Charge")
        else:
            self.m1Charge_branch.SetAddress(<void*>&self.m1Charge_value)

        #print "making m1ComesFromHiggs"
        self.m1ComesFromHiggs_branch = the_tree.GetBranch("m1ComesFromHiggs")
        #if not self.m1ComesFromHiggs_branch and "m1ComesFromHiggs" not in self.complained:
        if not self.m1ComesFromHiggs_branch and "m1ComesFromHiggs":
            warnings.warn( "EMuMuMuTree: Expected branch m1ComesFromHiggs does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1ComesFromHiggs")
        else:
            self.m1ComesFromHiggs_branch.SetAddress(<void*>&self.m1ComesFromHiggs_value)

        #print "making m1D0"
        self.m1D0_branch = the_tree.GetBranch("m1D0")
        #if not self.m1D0_branch and "m1D0" not in self.complained:
        if not self.m1D0_branch and "m1D0":
            warnings.warn( "EMuMuMuTree: Expected branch m1D0 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1D0")
        else:
            self.m1D0_branch.SetAddress(<void*>&self.m1D0_value)

        #print "making m1DZ"
        self.m1DZ_branch = the_tree.GetBranch("m1DZ")
        #if not self.m1DZ_branch and "m1DZ" not in self.complained:
        if not self.m1DZ_branch and "m1DZ":
            warnings.warn( "EMuMuMuTree: Expected branch m1DZ does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1DZ")
        else:
            self.m1DZ_branch.SetAddress(<void*>&self.m1DZ_value)

        #print "making m1DiMuonL3PreFiltered7"
        self.m1DiMuonL3PreFiltered7_branch = the_tree.GetBranch("m1DiMuonL3PreFiltered7")
        #if not self.m1DiMuonL3PreFiltered7_branch and "m1DiMuonL3PreFiltered7" not in self.complained:
        if not self.m1DiMuonL3PreFiltered7_branch and "m1DiMuonL3PreFiltered7":
            warnings.warn( "EMuMuMuTree: Expected branch m1DiMuonL3PreFiltered7 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1DiMuonL3PreFiltered7")
        else:
            self.m1DiMuonL3PreFiltered7_branch.SetAddress(<void*>&self.m1DiMuonL3PreFiltered7_value)

        #print "making m1DiMuonL3p5PreFiltered8"
        self.m1DiMuonL3p5PreFiltered8_branch = the_tree.GetBranch("m1DiMuonL3p5PreFiltered8")
        #if not self.m1DiMuonL3p5PreFiltered8_branch and "m1DiMuonL3p5PreFiltered8" not in self.complained:
        if not self.m1DiMuonL3p5PreFiltered8_branch and "m1DiMuonL3p5PreFiltered8":
            warnings.warn( "EMuMuMuTree: Expected branch m1DiMuonL3p5PreFiltered8 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1DiMuonL3p5PreFiltered8")
        else:
            self.m1DiMuonL3p5PreFiltered8_branch.SetAddress(<void*>&self.m1DiMuonL3p5PreFiltered8_value)

        #print "making m1DiMuonMu17Mu8DzFiltered0p2"
        self.m1DiMuonMu17Mu8DzFiltered0p2_branch = the_tree.GetBranch("m1DiMuonMu17Mu8DzFiltered0p2")
        #if not self.m1DiMuonMu17Mu8DzFiltered0p2_branch and "m1DiMuonMu17Mu8DzFiltered0p2" not in self.complained:
        if not self.m1DiMuonMu17Mu8DzFiltered0p2_branch and "m1DiMuonMu17Mu8DzFiltered0p2":
            warnings.warn( "EMuMuMuTree: Expected branch m1DiMuonMu17Mu8DzFiltered0p2 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1DiMuonMu17Mu8DzFiltered0p2")
        else:
            self.m1DiMuonMu17Mu8DzFiltered0p2_branch.SetAddress(<void*>&self.m1DiMuonMu17Mu8DzFiltered0p2_value)

        #print "making m1EErrRochCor2011A"
        self.m1EErrRochCor2011A_branch = the_tree.GetBranch("m1EErrRochCor2011A")
        #if not self.m1EErrRochCor2011A_branch and "m1EErrRochCor2011A" not in self.complained:
        if not self.m1EErrRochCor2011A_branch and "m1EErrRochCor2011A":
            warnings.warn( "EMuMuMuTree: Expected branch m1EErrRochCor2011A does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1EErrRochCor2011A")
        else:
            self.m1EErrRochCor2011A_branch.SetAddress(<void*>&self.m1EErrRochCor2011A_value)

        #print "making m1EErrRochCor2011B"
        self.m1EErrRochCor2011B_branch = the_tree.GetBranch("m1EErrRochCor2011B")
        #if not self.m1EErrRochCor2011B_branch and "m1EErrRochCor2011B" not in self.complained:
        if not self.m1EErrRochCor2011B_branch and "m1EErrRochCor2011B":
            warnings.warn( "EMuMuMuTree: Expected branch m1EErrRochCor2011B does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1EErrRochCor2011B")
        else:
            self.m1EErrRochCor2011B_branch.SetAddress(<void*>&self.m1EErrRochCor2011B_value)

        #print "making m1EErrRochCor2012"
        self.m1EErrRochCor2012_branch = the_tree.GetBranch("m1EErrRochCor2012")
        #if not self.m1EErrRochCor2012_branch and "m1EErrRochCor2012" not in self.complained:
        if not self.m1EErrRochCor2012_branch and "m1EErrRochCor2012":
            warnings.warn( "EMuMuMuTree: Expected branch m1EErrRochCor2012 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1EErrRochCor2012")
        else:
            self.m1EErrRochCor2012_branch.SetAddress(<void*>&self.m1EErrRochCor2012_value)

        #print "making m1ERochCor2011A"
        self.m1ERochCor2011A_branch = the_tree.GetBranch("m1ERochCor2011A")
        #if not self.m1ERochCor2011A_branch and "m1ERochCor2011A" not in self.complained:
        if not self.m1ERochCor2011A_branch and "m1ERochCor2011A":
            warnings.warn( "EMuMuMuTree: Expected branch m1ERochCor2011A does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1ERochCor2011A")
        else:
            self.m1ERochCor2011A_branch.SetAddress(<void*>&self.m1ERochCor2011A_value)

        #print "making m1ERochCor2011B"
        self.m1ERochCor2011B_branch = the_tree.GetBranch("m1ERochCor2011B")
        #if not self.m1ERochCor2011B_branch and "m1ERochCor2011B" not in self.complained:
        if not self.m1ERochCor2011B_branch and "m1ERochCor2011B":
            warnings.warn( "EMuMuMuTree: Expected branch m1ERochCor2011B does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1ERochCor2011B")
        else:
            self.m1ERochCor2011B_branch.SetAddress(<void*>&self.m1ERochCor2011B_value)

        #print "making m1ERochCor2012"
        self.m1ERochCor2012_branch = the_tree.GetBranch("m1ERochCor2012")
        #if not self.m1ERochCor2012_branch and "m1ERochCor2012" not in self.complained:
        if not self.m1ERochCor2012_branch and "m1ERochCor2012":
            warnings.warn( "EMuMuMuTree: Expected branch m1ERochCor2012 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1ERochCor2012")
        else:
            self.m1ERochCor2012_branch.SetAddress(<void*>&self.m1ERochCor2012_value)

        #print "making m1EffectiveArea2011"
        self.m1EffectiveArea2011_branch = the_tree.GetBranch("m1EffectiveArea2011")
        #if not self.m1EffectiveArea2011_branch and "m1EffectiveArea2011" not in self.complained:
        if not self.m1EffectiveArea2011_branch and "m1EffectiveArea2011":
            warnings.warn( "EMuMuMuTree: Expected branch m1EffectiveArea2011 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1EffectiveArea2011")
        else:
            self.m1EffectiveArea2011_branch.SetAddress(<void*>&self.m1EffectiveArea2011_value)

        #print "making m1EffectiveArea2012"
        self.m1EffectiveArea2012_branch = the_tree.GetBranch("m1EffectiveArea2012")
        #if not self.m1EffectiveArea2012_branch and "m1EffectiveArea2012" not in self.complained:
        if not self.m1EffectiveArea2012_branch and "m1EffectiveArea2012":
            warnings.warn( "EMuMuMuTree: Expected branch m1EffectiveArea2012 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1EffectiveArea2012")
        else:
            self.m1EffectiveArea2012_branch.SetAddress(<void*>&self.m1EffectiveArea2012_value)

        #print "making m1Eta"
        self.m1Eta_branch = the_tree.GetBranch("m1Eta")
        #if not self.m1Eta_branch and "m1Eta" not in self.complained:
        if not self.m1Eta_branch and "m1Eta":
            warnings.warn( "EMuMuMuTree: Expected branch m1Eta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1Eta")
        else:
            self.m1Eta_branch.SetAddress(<void*>&self.m1Eta_value)

        #print "making m1EtaRochCor2011A"
        self.m1EtaRochCor2011A_branch = the_tree.GetBranch("m1EtaRochCor2011A")
        #if not self.m1EtaRochCor2011A_branch and "m1EtaRochCor2011A" not in self.complained:
        if not self.m1EtaRochCor2011A_branch and "m1EtaRochCor2011A":
            warnings.warn( "EMuMuMuTree: Expected branch m1EtaRochCor2011A does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1EtaRochCor2011A")
        else:
            self.m1EtaRochCor2011A_branch.SetAddress(<void*>&self.m1EtaRochCor2011A_value)

        #print "making m1EtaRochCor2011B"
        self.m1EtaRochCor2011B_branch = the_tree.GetBranch("m1EtaRochCor2011B")
        #if not self.m1EtaRochCor2011B_branch and "m1EtaRochCor2011B" not in self.complained:
        if not self.m1EtaRochCor2011B_branch and "m1EtaRochCor2011B":
            warnings.warn( "EMuMuMuTree: Expected branch m1EtaRochCor2011B does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1EtaRochCor2011B")
        else:
            self.m1EtaRochCor2011B_branch.SetAddress(<void*>&self.m1EtaRochCor2011B_value)

        #print "making m1EtaRochCor2012"
        self.m1EtaRochCor2012_branch = the_tree.GetBranch("m1EtaRochCor2012")
        #if not self.m1EtaRochCor2012_branch and "m1EtaRochCor2012" not in self.complained:
        if not self.m1EtaRochCor2012_branch and "m1EtaRochCor2012":
            warnings.warn( "EMuMuMuTree: Expected branch m1EtaRochCor2012 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1EtaRochCor2012")
        else:
            self.m1EtaRochCor2012_branch.SetAddress(<void*>&self.m1EtaRochCor2012_value)

        #print "making m1GenCharge"
        self.m1GenCharge_branch = the_tree.GetBranch("m1GenCharge")
        #if not self.m1GenCharge_branch and "m1GenCharge" not in self.complained:
        if not self.m1GenCharge_branch and "m1GenCharge":
            warnings.warn( "EMuMuMuTree: Expected branch m1GenCharge does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1GenCharge")
        else:
            self.m1GenCharge_branch.SetAddress(<void*>&self.m1GenCharge_value)

        #print "making m1GenEnergy"
        self.m1GenEnergy_branch = the_tree.GetBranch("m1GenEnergy")
        #if not self.m1GenEnergy_branch and "m1GenEnergy" not in self.complained:
        if not self.m1GenEnergy_branch and "m1GenEnergy":
            warnings.warn( "EMuMuMuTree: Expected branch m1GenEnergy does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1GenEnergy")
        else:
            self.m1GenEnergy_branch.SetAddress(<void*>&self.m1GenEnergy_value)

        #print "making m1GenEta"
        self.m1GenEta_branch = the_tree.GetBranch("m1GenEta")
        #if not self.m1GenEta_branch and "m1GenEta" not in self.complained:
        if not self.m1GenEta_branch and "m1GenEta":
            warnings.warn( "EMuMuMuTree: Expected branch m1GenEta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1GenEta")
        else:
            self.m1GenEta_branch.SetAddress(<void*>&self.m1GenEta_value)

        #print "making m1GenMotherPdgId"
        self.m1GenMotherPdgId_branch = the_tree.GetBranch("m1GenMotherPdgId")
        #if not self.m1GenMotherPdgId_branch and "m1GenMotherPdgId" not in self.complained:
        if not self.m1GenMotherPdgId_branch and "m1GenMotherPdgId":
            warnings.warn( "EMuMuMuTree: Expected branch m1GenMotherPdgId does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1GenMotherPdgId")
        else:
            self.m1GenMotherPdgId_branch.SetAddress(<void*>&self.m1GenMotherPdgId_value)

        #print "making m1GenPdgId"
        self.m1GenPdgId_branch = the_tree.GetBranch("m1GenPdgId")
        #if not self.m1GenPdgId_branch and "m1GenPdgId" not in self.complained:
        if not self.m1GenPdgId_branch and "m1GenPdgId":
            warnings.warn( "EMuMuMuTree: Expected branch m1GenPdgId does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1GenPdgId")
        else:
            self.m1GenPdgId_branch.SetAddress(<void*>&self.m1GenPdgId_value)

        #print "making m1GenPhi"
        self.m1GenPhi_branch = the_tree.GetBranch("m1GenPhi")
        #if not self.m1GenPhi_branch and "m1GenPhi" not in self.complained:
        if not self.m1GenPhi_branch and "m1GenPhi":
            warnings.warn( "EMuMuMuTree: Expected branch m1GenPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1GenPhi")
        else:
            self.m1GenPhi_branch.SetAddress(<void*>&self.m1GenPhi_value)

        #print "making m1GlbTrkHits"
        self.m1GlbTrkHits_branch = the_tree.GetBranch("m1GlbTrkHits")
        #if not self.m1GlbTrkHits_branch and "m1GlbTrkHits" not in self.complained:
        if not self.m1GlbTrkHits_branch and "m1GlbTrkHits":
            warnings.warn( "EMuMuMuTree: Expected branch m1GlbTrkHits does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1GlbTrkHits")
        else:
            self.m1GlbTrkHits_branch.SetAddress(<void*>&self.m1GlbTrkHits_value)

        #print "making m1IDHZG2011"
        self.m1IDHZG2011_branch = the_tree.GetBranch("m1IDHZG2011")
        #if not self.m1IDHZG2011_branch and "m1IDHZG2011" not in self.complained:
        if not self.m1IDHZG2011_branch and "m1IDHZG2011":
            warnings.warn( "EMuMuMuTree: Expected branch m1IDHZG2011 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1IDHZG2011")
        else:
            self.m1IDHZG2011_branch.SetAddress(<void*>&self.m1IDHZG2011_value)

        #print "making m1IDHZG2012"
        self.m1IDHZG2012_branch = the_tree.GetBranch("m1IDHZG2012")
        #if not self.m1IDHZG2012_branch and "m1IDHZG2012" not in self.complained:
        if not self.m1IDHZG2012_branch and "m1IDHZG2012":
            warnings.warn( "EMuMuMuTree: Expected branch m1IDHZG2012 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1IDHZG2012")
        else:
            self.m1IDHZG2012_branch.SetAddress(<void*>&self.m1IDHZG2012_value)

        #print "making m1IP3DS"
        self.m1IP3DS_branch = the_tree.GetBranch("m1IP3DS")
        #if not self.m1IP3DS_branch and "m1IP3DS" not in self.complained:
        if not self.m1IP3DS_branch and "m1IP3DS":
            warnings.warn( "EMuMuMuTree: Expected branch m1IP3DS does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1IP3DS")
        else:
            self.m1IP3DS_branch.SetAddress(<void*>&self.m1IP3DS_value)

        #print "making m1IsGlobal"
        self.m1IsGlobal_branch = the_tree.GetBranch("m1IsGlobal")
        #if not self.m1IsGlobal_branch and "m1IsGlobal" not in self.complained:
        if not self.m1IsGlobal_branch and "m1IsGlobal":
            warnings.warn( "EMuMuMuTree: Expected branch m1IsGlobal does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1IsGlobal")
        else:
            self.m1IsGlobal_branch.SetAddress(<void*>&self.m1IsGlobal_value)

        #print "making m1IsPFMuon"
        self.m1IsPFMuon_branch = the_tree.GetBranch("m1IsPFMuon")
        #if not self.m1IsPFMuon_branch and "m1IsPFMuon" not in self.complained:
        if not self.m1IsPFMuon_branch and "m1IsPFMuon":
            warnings.warn( "EMuMuMuTree: Expected branch m1IsPFMuon does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1IsPFMuon")
        else:
            self.m1IsPFMuon_branch.SetAddress(<void*>&self.m1IsPFMuon_value)

        #print "making m1IsTracker"
        self.m1IsTracker_branch = the_tree.GetBranch("m1IsTracker")
        #if not self.m1IsTracker_branch and "m1IsTracker" not in self.complained:
        if not self.m1IsTracker_branch and "m1IsTracker":
            warnings.warn( "EMuMuMuTree: Expected branch m1IsTracker does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1IsTracker")
        else:
            self.m1IsTracker_branch.SetAddress(<void*>&self.m1IsTracker_value)

        #print "making m1JetArea"
        self.m1JetArea_branch = the_tree.GetBranch("m1JetArea")
        #if not self.m1JetArea_branch and "m1JetArea" not in self.complained:
        if not self.m1JetArea_branch and "m1JetArea":
            warnings.warn( "EMuMuMuTree: Expected branch m1JetArea does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1JetArea")
        else:
            self.m1JetArea_branch.SetAddress(<void*>&self.m1JetArea_value)

        #print "making m1JetBtag"
        self.m1JetBtag_branch = the_tree.GetBranch("m1JetBtag")
        #if not self.m1JetBtag_branch and "m1JetBtag" not in self.complained:
        if not self.m1JetBtag_branch and "m1JetBtag":
            warnings.warn( "EMuMuMuTree: Expected branch m1JetBtag does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1JetBtag")
        else:
            self.m1JetBtag_branch.SetAddress(<void*>&self.m1JetBtag_value)

        #print "making m1JetCSVBtag"
        self.m1JetCSVBtag_branch = the_tree.GetBranch("m1JetCSVBtag")
        #if not self.m1JetCSVBtag_branch and "m1JetCSVBtag" not in self.complained:
        if not self.m1JetCSVBtag_branch and "m1JetCSVBtag":
            warnings.warn( "EMuMuMuTree: Expected branch m1JetCSVBtag does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1JetCSVBtag")
        else:
            self.m1JetCSVBtag_branch.SetAddress(<void*>&self.m1JetCSVBtag_value)

        #print "making m1JetEtaEtaMoment"
        self.m1JetEtaEtaMoment_branch = the_tree.GetBranch("m1JetEtaEtaMoment")
        #if not self.m1JetEtaEtaMoment_branch and "m1JetEtaEtaMoment" not in self.complained:
        if not self.m1JetEtaEtaMoment_branch and "m1JetEtaEtaMoment":
            warnings.warn( "EMuMuMuTree: Expected branch m1JetEtaEtaMoment does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1JetEtaEtaMoment")
        else:
            self.m1JetEtaEtaMoment_branch.SetAddress(<void*>&self.m1JetEtaEtaMoment_value)

        #print "making m1JetEtaPhiMoment"
        self.m1JetEtaPhiMoment_branch = the_tree.GetBranch("m1JetEtaPhiMoment")
        #if not self.m1JetEtaPhiMoment_branch and "m1JetEtaPhiMoment" not in self.complained:
        if not self.m1JetEtaPhiMoment_branch and "m1JetEtaPhiMoment":
            warnings.warn( "EMuMuMuTree: Expected branch m1JetEtaPhiMoment does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1JetEtaPhiMoment")
        else:
            self.m1JetEtaPhiMoment_branch.SetAddress(<void*>&self.m1JetEtaPhiMoment_value)

        #print "making m1JetEtaPhiSpread"
        self.m1JetEtaPhiSpread_branch = the_tree.GetBranch("m1JetEtaPhiSpread")
        #if not self.m1JetEtaPhiSpread_branch and "m1JetEtaPhiSpread" not in self.complained:
        if not self.m1JetEtaPhiSpread_branch and "m1JetEtaPhiSpread":
            warnings.warn( "EMuMuMuTree: Expected branch m1JetEtaPhiSpread does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1JetEtaPhiSpread")
        else:
            self.m1JetEtaPhiSpread_branch.SetAddress(<void*>&self.m1JetEtaPhiSpread_value)

        #print "making m1JetPartonFlavour"
        self.m1JetPartonFlavour_branch = the_tree.GetBranch("m1JetPartonFlavour")
        #if not self.m1JetPartonFlavour_branch and "m1JetPartonFlavour" not in self.complained:
        if not self.m1JetPartonFlavour_branch and "m1JetPartonFlavour":
            warnings.warn( "EMuMuMuTree: Expected branch m1JetPartonFlavour does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1JetPartonFlavour")
        else:
            self.m1JetPartonFlavour_branch.SetAddress(<void*>&self.m1JetPartonFlavour_value)

        #print "making m1JetPhiPhiMoment"
        self.m1JetPhiPhiMoment_branch = the_tree.GetBranch("m1JetPhiPhiMoment")
        #if not self.m1JetPhiPhiMoment_branch and "m1JetPhiPhiMoment" not in self.complained:
        if not self.m1JetPhiPhiMoment_branch and "m1JetPhiPhiMoment":
            warnings.warn( "EMuMuMuTree: Expected branch m1JetPhiPhiMoment does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1JetPhiPhiMoment")
        else:
            self.m1JetPhiPhiMoment_branch.SetAddress(<void*>&self.m1JetPhiPhiMoment_value)

        #print "making m1JetPt"
        self.m1JetPt_branch = the_tree.GetBranch("m1JetPt")
        #if not self.m1JetPt_branch and "m1JetPt" not in self.complained:
        if not self.m1JetPt_branch and "m1JetPt":
            warnings.warn( "EMuMuMuTree: Expected branch m1JetPt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1JetPt")
        else:
            self.m1JetPt_branch.SetAddress(<void*>&self.m1JetPt_value)

        #print "making m1JetQGLikelihoodID"
        self.m1JetQGLikelihoodID_branch = the_tree.GetBranch("m1JetQGLikelihoodID")
        #if not self.m1JetQGLikelihoodID_branch and "m1JetQGLikelihoodID" not in self.complained:
        if not self.m1JetQGLikelihoodID_branch and "m1JetQGLikelihoodID":
            warnings.warn( "EMuMuMuTree: Expected branch m1JetQGLikelihoodID does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1JetQGLikelihoodID")
        else:
            self.m1JetQGLikelihoodID_branch.SetAddress(<void*>&self.m1JetQGLikelihoodID_value)

        #print "making m1JetQGMVAID"
        self.m1JetQGMVAID_branch = the_tree.GetBranch("m1JetQGMVAID")
        #if not self.m1JetQGMVAID_branch and "m1JetQGMVAID" not in self.complained:
        if not self.m1JetQGMVAID_branch and "m1JetQGMVAID":
            warnings.warn( "EMuMuMuTree: Expected branch m1JetQGMVAID does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1JetQGMVAID")
        else:
            self.m1JetQGMVAID_branch.SetAddress(<void*>&self.m1JetQGMVAID_value)

        #print "making m1Jetaxis1"
        self.m1Jetaxis1_branch = the_tree.GetBranch("m1Jetaxis1")
        #if not self.m1Jetaxis1_branch and "m1Jetaxis1" not in self.complained:
        if not self.m1Jetaxis1_branch and "m1Jetaxis1":
            warnings.warn( "EMuMuMuTree: Expected branch m1Jetaxis1 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1Jetaxis1")
        else:
            self.m1Jetaxis1_branch.SetAddress(<void*>&self.m1Jetaxis1_value)

        #print "making m1Jetaxis2"
        self.m1Jetaxis2_branch = the_tree.GetBranch("m1Jetaxis2")
        #if not self.m1Jetaxis2_branch and "m1Jetaxis2" not in self.complained:
        if not self.m1Jetaxis2_branch and "m1Jetaxis2":
            warnings.warn( "EMuMuMuTree: Expected branch m1Jetaxis2 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1Jetaxis2")
        else:
            self.m1Jetaxis2_branch.SetAddress(<void*>&self.m1Jetaxis2_value)

        #print "making m1Jetmult"
        self.m1Jetmult_branch = the_tree.GetBranch("m1Jetmult")
        #if not self.m1Jetmult_branch and "m1Jetmult" not in self.complained:
        if not self.m1Jetmult_branch and "m1Jetmult":
            warnings.warn( "EMuMuMuTree: Expected branch m1Jetmult does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1Jetmult")
        else:
            self.m1Jetmult_branch.SetAddress(<void*>&self.m1Jetmult_value)

        #print "making m1JetmultMLP"
        self.m1JetmultMLP_branch = the_tree.GetBranch("m1JetmultMLP")
        #if not self.m1JetmultMLP_branch and "m1JetmultMLP" not in self.complained:
        if not self.m1JetmultMLP_branch and "m1JetmultMLP":
            warnings.warn( "EMuMuMuTree: Expected branch m1JetmultMLP does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1JetmultMLP")
        else:
            self.m1JetmultMLP_branch.SetAddress(<void*>&self.m1JetmultMLP_value)

        #print "making m1JetmultMLPQC"
        self.m1JetmultMLPQC_branch = the_tree.GetBranch("m1JetmultMLPQC")
        #if not self.m1JetmultMLPQC_branch and "m1JetmultMLPQC" not in self.complained:
        if not self.m1JetmultMLPQC_branch and "m1JetmultMLPQC":
            warnings.warn( "EMuMuMuTree: Expected branch m1JetmultMLPQC does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1JetmultMLPQC")
        else:
            self.m1JetmultMLPQC_branch.SetAddress(<void*>&self.m1JetmultMLPQC_value)

        #print "making m1JetptD"
        self.m1JetptD_branch = the_tree.GetBranch("m1JetptD")
        #if not self.m1JetptD_branch and "m1JetptD" not in self.complained:
        if not self.m1JetptD_branch and "m1JetptD":
            warnings.warn( "EMuMuMuTree: Expected branch m1JetptD does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1JetptD")
        else:
            self.m1JetptD_branch.SetAddress(<void*>&self.m1JetptD_value)

        #print "making m1L1Mu3EG5L3Filtered17"
        self.m1L1Mu3EG5L3Filtered17_branch = the_tree.GetBranch("m1L1Mu3EG5L3Filtered17")
        #if not self.m1L1Mu3EG5L3Filtered17_branch and "m1L1Mu3EG5L3Filtered17" not in self.complained:
        if not self.m1L1Mu3EG5L3Filtered17_branch and "m1L1Mu3EG5L3Filtered17":
            warnings.warn( "EMuMuMuTree: Expected branch m1L1Mu3EG5L3Filtered17 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1L1Mu3EG5L3Filtered17")
        else:
            self.m1L1Mu3EG5L3Filtered17_branch.SetAddress(<void*>&self.m1L1Mu3EG5L3Filtered17_value)

        #print "making m1L3fL1DoubleMu10MuOpenL1f0L2f10L3Filtered17"
        self.m1L3fL1DoubleMu10MuOpenL1f0L2f10L3Filtered17_branch = the_tree.GetBranch("m1L3fL1DoubleMu10MuOpenL1f0L2f10L3Filtered17")
        #if not self.m1L3fL1DoubleMu10MuOpenL1f0L2f10L3Filtered17_branch and "m1L3fL1DoubleMu10MuOpenL1f0L2f10L3Filtered17" not in self.complained:
        if not self.m1L3fL1DoubleMu10MuOpenL1f0L2f10L3Filtered17_branch and "m1L3fL1DoubleMu10MuOpenL1f0L2f10L3Filtered17":
            warnings.warn( "EMuMuMuTree: Expected branch m1L3fL1DoubleMu10MuOpenL1f0L2f10L3Filtered17 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1L3fL1DoubleMu10MuOpenL1f0L2f10L3Filtered17")
        else:
            self.m1L3fL1DoubleMu10MuOpenL1f0L2f10L3Filtered17_branch.SetAddress(<void*>&self.m1L3fL1DoubleMu10MuOpenL1f0L2f10L3Filtered17_value)

        #print "making m1Mass"
        self.m1Mass_branch = the_tree.GetBranch("m1Mass")
        #if not self.m1Mass_branch and "m1Mass" not in self.complained:
        if not self.m1Mass_branch and "m1Mass":
            warnings.warn( "EMuMuMuTree: Expected branch m1Mass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1Mass")
        else:
            self.m1Mass_branch.SetAddress(<void*>&self.m1Mass_value)

        #print "making m1MatchedStations"
        self.m1MatchedStations_branch = the_tree.GetBranch("m1MatchedStations")
        #if not self.m1MatchedStations_branch and "m1MatchedStations" not in self.complained:
        if not self.m1MatchedStations_branch and "m1MatchedStations":
            warnings.warn( "EMuMuMuTree: Expected branch m1MatchedStations does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1MatchedStations")
        else:
            self.m1MatchedStations_branch.SetAddress(<void*>&self.m1MatchedStations_value)

        #print "making m1MatchesDoubleMuPaths"
        self.m1MatchesDoubleMuPaths_branch = the_tree.GetBranch("m1MatchesDoubleMuPaths")
        #if not self.m1MatchesDoubleMuPaths_branch and "m1MatchesDoubleMuPaths" not in self.complained:
        if not self.m1MatchesDoubleMuPaths_branch and "m1MatchesDoubleMuPaths":
            warnings.warn( "EMuMuMuTree: Expected branch m1MatchesDoubleMuPaths does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1MatchesDoubleMuPaths")
        else:
            self.m1MatchesDoubleMuPaths_branch.SetAddress(<void*>&self.m1MatchesDoubleMuPaths_value)

        #print "making m1MatchesDoubleMuTrkPaths"
        self.m1MatchesDoubleMuTrkPaths_branch = the_tree.GetBranch("m1MatchesDoubleMuTrkPaths")
        #if not self.m1MatchesDoubleMuTrkPaths_branch and "m1MatchesDoubleMuTrkPaths" not in self.complained:
        if not self.m1MatchesDoubleMuTrkPaths_branch and "m1MatchesDoubleMuTrkPaths":
            warnings.warn( "EMuMuMuTree: Expected branch m1MatchesDoubleMuTrkPaths does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1MatchesDoubleMuTrkPaths")
        else:
            self.m1MatchesDoubleMuTrkPaths_branch.SetAddress(<void*>&self.m1MatchesDoubleMuTrkPaths_value)

        #print "making m1MatchesIsoMu24eta2p1"
        self.m1MatchesIsoMu24eta2p1_branch = the_tree.GetBranch("m1MatchesIsoMu24eta2p1")
        #if not self.m1MatchesIsoMu24eta2p1_branch and "m1MatchesIsoMu24eta2p1" not in self.complained:
        if not self.m1MatchesIsoMu24eta2p1_branch and "m1MatchesIsoMu24eta2p1":
            warnings.warn( "EMuMuMuTree: Expected branch m1MatchesIsoMu24eta2p1 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1MatchesIsoMu24eta2p1")
        else:
            self.m1MatchesIsoMu24eta2p1_branch.SetAddress(<void*>&self.m1MatchesIsoMu24eta2p1_value)

        #print "making m1MatchesIsoMuGroup"
        self.m1MatchesIsoMuGroup_branch = the_tree.GetBranch("m1MatchesIsoMuGroup")
        #if not self.m1MatchesIsoMuGroup_branch and "m1MatchesIsoMuGroup" not in self.complained:
        if not self.m1MatchesIsoMuGroup_branch and "m1MatchesIsoMuGroup":
            warnings.warn( "EMuMuMuTree: Expected branch m1MatchesIsoMuGroup does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1MatchesIsoMuGroup")
        else:
            self.m1MatchesIsoMuGroup_branch.SetAddress(<void*>&self.m1MatchesIsoMuGroup_value)

        #print "making m1MatchesMu17Ele8IsoPath"
        self.m1MatchesMu17Ele8IsoPath_branch = the_tree.GetBranch("m1MatchesMu17Ele8IsoPath")
        #if not self.m1MatchesMu17Ele8IsoPath_branch and "m1MatchesMu17Ele8IsoPath" not in self.complained:
        if not self.m1MatchesMu17Ele8IsoPath_branch and "m1MatchesMu17Ele8IsoPath":
            warnings.warn( "EMuMuMuTree: Expected branch m1MatchesMu17Ele8IsoPath does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1MatchesMu17Ele8IsoPath")
        else:
            self.m1MatchesMu17Ele8IsoPath_branch.SetAddress(<void*>&self.m1MatchesMu17Ele8IsoPath_value)

        #print "making m1MatchesMu17Ele8Path"
        self.m1MatchesMu17Ele8Path_branch = the_tree.GetBranch("m1MatchesMu17Ele8Path")
        #if not self.m1MatchesMu17Ele8Path_branch and "m1MatchesMu17Ele8Path" not in self.complained:
        if not self.m1MatchesMu17Ele8Path_branch and "m1MatchesMu17Ele8Path":
            warnings.warn( "EMuMuMuTree: Expected branch m1MatchesMu17Ele8Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1MatchesMu17Ele8Path")
        else:
            self.m1MatchesMu17Ele8Path_branch.SetAddress(<void*>&self.m1MatchesMu17Ele8Path_value)

        #print "making m1MatchesMu17Mu8Path"
        self.m1MatchesMu17Mu8Path_branch = the_tree.GetBranch("m1MatchesMu17Mu8Path")
        #if not self.m1MatchesMu17Mu8Path_branch and "m1MatchesMu17Mu8Path" not in self.complained:
        if not self.m1MatchesMu17Mu8Path_branch and "m1MatchesMu17Mu8Path":
            warnings.warn( "EMuMuMuTree: Expected branch m1MatchesMu17Mu8Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1MatchesMu17Mu8Path")
        else:
            self.m1MatchesMu17Mu8Path_branch.SetAddress(<void*>&self.m1MatchesMu17Mu8Path_value)

        #print "making m1MatchesMu17TrkMu8Path"
        self.m1MatchesMu17TrkMu8Path_branch = the_tree.GetBranch("m1MatchesMu17TrkMu8Path")
        #if not self.m1MatchesMu17TrkMu8Path_branch and "m1MatchesMu17TrkMu8Path" not in self.complained:
        if not self.m1MatchesMu17TrkMu8Path_branch and "m1MatchesMu17TrkMu8Path":
            warnings.warn( "EMuMuMuTree: Expected branch m1MatchesMu17TrkMu8Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1MatchesMu17TrkMu8Path")
        else:
            self.m1MatchesMu17TrkMu8Path_branch.SetAddress(<void*>&self.m1MatchesMu17TrkMu8Path_value)

        #print "making m1MatchesMu8Ele17IsoPath"
        self.m1MatchesMu8Ele17IsoPath_branch = the_tree.GetBranch("m1MatchesMu8Ele17IsoPath")
        #if not self.m1MatchesMu8Ele17IsoPath_branch and "m1MatchesMu8Ele17IsoPath" not in self.complained:
        if not self.m1MatchesMu8Ele17IsoPath_branch and "m1MatchesMu8Ele17IsoPath":
            warnings.warn( "EMuMuMuTree: Expected branch m1MatchesMu8Ele17IsoPath does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1MatchesMu8Ele17IsoPath")
        else:
            self.m1MatchesMu8Ele17IsoPath_branch.SetAddress(<void*>&self.m1MatchesMu8Ele17IsoPath_value)

        #print "making m1MatchesMu8Ele17Path"
        self.m1MatchesMu8Ele17Path_branch = the_tree.GetBranch("m1MatchesMu8Ele17Path")
        #if not self.m1MatchesMu8Ele17Path_branch and "m1MatchesMu8Ele17Path" not in self.complained:
        if not self.m1MatchesMu8Ele17Path_branch and "m1MatchesMu8Ele17Path":
            warnings.warn( "EMuMuMuTree: Expected branch m1MatchesMu8Ele17Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1MatchesMu8Ele17Path")
        else:
            self.m1MatchesMu8Ele17Path_branch.SetAddress(<void*>&self.m1MatchesMu8Ele17Path_value)

        #print "making m1MtToMET"
        self.m1MtToMET_branch = the_tree.GetBranch("m1MtToMET")
        #if not self.m1MtToMET_branch and "m1MtToMET" not in self.complained:
        if not self.m1MtToMET_branch and "m1MtToMET":
            warnings.warn( "EMuMuMuTree: Expected branch m1MtToMET does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1MtToMET")
        else:
            self.m1MtToMET_branch.SetAddress(<void*>&self.m1MtToMET_value)

        #print "making m1MtToMVAMET"
        self.m1MtToMVAMET_branch = the_tree.GetBranch("m1MtToMVAMET")
        #if not self.m1MtToMVAMET_branch and "m1MtToMVAMET" not in self.complained:
        if not self.m1MtToMVAMET_branch and "m1MtToMVAMET":
            warnings.warn( "EMuMuMuTree: Expected branch m1MtToMVAMET does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1MtToMVAMET")
        else:
            self.m1MtToMVAMET_branch.SetAddress(<void*>&self.m1MtToMVAMET_value)

        #print "making m1MtToPFMET"
        self.m1MtToPFMET_branch = the_tree.GetBranch("m1MtToPFMET")
        #if not self.m1MtToPFMET_branch and "m1MtToPFMET" not in self.complained:
        if not self.m1MtToPFMET_branch and "m1MtToPFMET":
            warnings.warn( "EMuMuMuTree: Expected branch m1MtToPFMET does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1MtToPFMET")
        else:
            self.m1MtToPFMET_branch.SetAddress(<void*>&self.m1MtToPFMET_value)

        #print "making m1MtToPfMet_Ty1"
        self.m1MtToPfMet_Ty1_branch = the_tree.GetBranch("m1MtToPfMet_Ty1")
        #if not self.m1MtToPfMet_Ty1_branch and "m1MtToPfMet_Ty1" not in self.complained:
        if not self.m1MtToPfMet_Ty1_branch and "m1MtToPfMet_Ty1":
            warnings.warn( "EMuMuMuTree: Expected branch m1MtToPfMet_Ty1 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1MtToPfMet_Ty1")
        else:
            self.m1MtToPfMet_Ty1_branch.SetAddress(<void*>&self.m1MtToPfMet_Ty1_value)

        #print "making m1MtToPfMet_jes"
        self.m1MtToPfMet_jes_branch = the_tree.GetBranch("m1MtToPfMet_jes")
        #if not self.m1MtToPfMet_jes_branch and "m1MtToPfMet_jes" not in self.complained:
        if not self.m1MtToPfMet_jes_branch and "m1MtToPfMet_jes":
            warnings.warn( "EMuMuMuTree: Expected branch m1MtToPfMet_jes does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1MtToPfMet_jes")
        else:
            self.m1MtToPfMet_jes_branch.SetAddress(<void*>&self.m1MtToPfMet_jes_value)

        #print "making m1MtToPfMet_mes"
        self.m1MtToPfMet_mes_branch = the_tree.GetBranch("m1MtToPfMet_mes")
        #if not self.m1MtToPfMet_mes_branch and "m1MtToPfMet_mes" not in self.complained:
        if not self.m1MtToPfMet_mes_branch and "m1MtToPfMet_mes":
            warnings.warn( "EMuMuMuTree: Expected branch m1MtToPfMet_mes does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1MtToPfMet_mes")
        else:
            self.m1MtToPfMet_mes_branch.SetAddress(<void*>&self.m1MtToPfMet_mes_value)

        #print "making m1MtToPfMet_tes"
        self.m1MtToPfMet_tes_branch = the_tree.GetBranch("m1MtToPfMet_tes")
        #if not self.m1MtToPfMet_tes_branch and "m1MtToPfMet_tes" not in self.complained:
        if not self.m1MtToPfMet_tes_branch and "m1MtToPfMet_tes":
            warnings.warn( "EMuMuMuTree: Expected branch m1MtToPfMet_tes does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1MtToPfMet_tes")
        else:
            self.m1MtToPfMet_tes_branch.SetAddress(<void*>&self.m1MtToPfMet_tes_value)

        #print "making m1MtToPfMet_ues"
        self.m1MtToPfMet_ues_branch = the_tree.GetBranch("m1MtToPfMet_ues")
        #if not self.m1MtToPfMet_ues_branch and "m1MtToPfMet_ues" not in self.complained:
        if not self.m1MtToPfMet_ues_branch and "m1MtToPfMet_ues":
            warnings.warn( "EMuMuMuTree: Expected branch m1MtToPfMet_ues does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1MtToPfMet_ues")
        else:
            self.m1MtToPfMet_ues_branch.SetAddress(<void*>&self.m1MtToPfMet_ues_value)

        #print "making m1Mu17Ele8dZFilter"
        self.m1Mu17Ele8dZFilter_branch = the_tree.GetBranch("m1Mu17Ele8dZFilter")
        #if not self.m1Mu17Ele8dZFilter_branch and "m1Mu17Ele8dZFilter" not in self.complained:
        if not self.m1Mu17Ele8dZFilter_branch and "m1Mu17Ele8dZFilter":
            warnings.warn( "EMuMuMuTree: Expected branch m1Mu17Ele8dZFilter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1Mu17Ele8dZFilter")
        else:
            self.m1Mu17Ele8dZFilter_branch.SetAddress(<void*>&self.m1Mu17Ele8dZFilter_value)

        #print "making m1MuonHits"
        self.m1MuonHits_branch = the_tree.GetBranch("m1MuonHits")
        #if not self.m1MuonHits_branch and "m1MuonHits" not in self.complained:
        if not self.m1MuonHits_branch and "m1MuonHits":
            warnings.warn( "EMuMuMuTree: Expected branch m1MuonHits does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1MuonHits")
        else:
            self.m1MuonHits_branch.SetAddress(<void*>&self.m1MuonHits_value)

        #print "making m1NormTrkChi2"
        self.m1NormTrkChi2_branch = the_tree.GetBranch("m1NormTrkChi2")
        #if not self.m1NormTrkChi2_branch and "m1NormTrkChi2" not in self.complained:
        if not self.m1NormTrkChi2_branch and "m1NormTrkChi2":
            warnings.warn( "EMuMuMuTree: Expected branch m1NormTrkChi2 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1NormTrkChi2")
        else:
            self.m1NormTrkChi2_branch.SetAddress(<void*>&self.m1NormTrkChi2_value)

        #print "making m1PFChargedIso"
        self.m1PFChargedIso_branch = the_tree.GetBranch("m1PFChargedIso")
        #if not self.m1PFChargedIso_branch and "m1PFChargedIso" not in self.complained:
        if not self.m1PFChargedIso_branch and "m1PFChargedIso":
            warnings.warn( "EMuMuMuTree: Expected branch m1PFChargedIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1PFChargedIso")
        else:
            self.m1PFChargedIso_branch.SetAddress(<void*>&self.m1PFChargedIso_value)

        #print "making m1PFIDTight"
        self.m1PFIDTight_branch = the_tree.GetBranch("m1PFIDTight")
        #if not self.m1PFIDTight_branch and "m1PFIDTight" not in self.complained:
        if not self.m1PFIDTight_branch and "m1PFIDTight":
            warnings.warn( "EMuMuMuTree: Expected branch m1PFIDTight does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1PFIDTight")
        else:
            self.m1PFIDTight_branch.SetAddress(<void*>&self.m1PFIDTight_value)

        #print "making m1PFNeutralIso"
        self.m1PFNeutralIso_branch = the_tree.GetBranch("m1PFNeutralIso")
        #if not self.m1PFNeutralIso_branch and "m1PFNeutralIso" not in self.complained:
        if not self.m1PFNeutralIso_branch and "m1PFNeutralIso":
            warnings.warn( "EMuMuMuTree: Expected branch m1PFNeutralIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1PFNeutralIso")
        else:
            self.m1PFNeutralIso_branch.SetAddress(<void*>&self.m1PFNeutralIso_value)

        #print "making m1PFPUChargedIso"
        self.m1PFPUChargedIso_branch = the_tree.GetBranch("m1PFPUChargedIso")
        #if not self.m1PFPUChargedIso_branch and "m1PFPUChargedIso" not in self.complained:
        if not self.m1PFPUChargedIso_branch and "m1PFPUChargedIso":
            warnings.warn( "EMuMuMuTree: Expected branch m1PFPUChargedIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1PFPUChargedIso")
        else:
            self.m1PFPUChargedIso_branch.SetAddress(<void*>&self.m1PFPUChargedIso_value)

        #print "making m1PFPhotonIso"
        self.m1PFPhotonIso_branch = the_tree.GetBranch("m1PFPhotonIso")
        #if not self.m1PFPhotonIso_branch and "m1PFPhotonIso" not in self.complained:
        if not self.m1PFPhotonIso_branch and "m1PFPhotonIso":
            warnings.warn( "EMuMuMuTree: Expected branch m1PFPhotonIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1PFPhotonIso")
        else:
            self.m1PFPhotonIso_branch.SetAddress(<void*>&self.m1PFPhotonIso_value)

        #print "making m1PVDXY"
        self.m1PVDXY_branch = the_tree.GetBranch("m1PVDXY")
        #if not self.m1PVDXY_branch and "m1PVDXY" not in self.complained:
        if not self.m1PVDXY_branch and "m1PVDXY":
            warnings.warn( "EMuMuMuTree: Expected branch m1PVDXY does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1PVDXY")
        else:
            self.m1PVDXY_branch.SetAddress(<void*>&self.m1PVDXY_value)

        #print "making m1PVDZ"
        self.m1PVDZ_branch = the_tree.GetBranch("m1PVDZ")
        #if not self.m1PVDZ_branch and "m1PVDZ" not in self.complained:
        if not self.m1PVDZ_branch and "m1PVDZ":
            warnings.warn( "EMuMuMuTree: Expected branch m1PVDZ does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1PVDZ")
        else:
            self.m1PVDZ_branch.SetAddress(<void*>&self.m1PVDZ_value)

        #print "making m1Phi"
        self.m1Phi_branch = the_tree.GetBranch("m1Phi")
        #if not self.m1Phi_branch and "m1Phi" not in self.complained:
        if not self.m1Phi_branch and "m1Phi":
            warnings.warn( "EMuMuMuTree: Expected branch m1Phi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1Phi")
        else:
            self.m1Phi_branch.SetAddress(<void*>&self.m1Phi_value)

        #print "making m1PhiRochCor2011A"
        self.m1PhiRochCor2011A_branch = the_tree.GetBranch("m1PhiRochCor2011A")
        #if not self.m1PhiRochCor2011A_branch and "m1PhiRochCor2011A" not in self.complained:
        if not self.m1PhiRochCor2011A_branch and "m1PhiRochCor2011A":
            warnings.warn( "EMuMuMuTree: Expected branch m1PhiRochCor2011A does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1PhiRochCor2011A")
        else:
            self.m1PhiRochCor2011A_branch.SetAddress(<void*>&self.m1PhiRochCor2011A_value)

        #print "making m1PhiRochCor2011B"
        self.m1PhiRochCor2011B_branch = the_tree.GetBranch("m1PhiRochCor2011B")
        #if not self.m1PhiRochCor2011B_branch and "m1PhiRochCor2011B" not in self.complained:
        if not self.m1PhiRochCor2011B_branch and "m1PhiRochCor2011B":
            warnings.warn( "EMuMuMuTree: Expected branch m1PhiRochCor2011B does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1PhiRochCor2011B")
        else:
            self.m1PhiRochCor2011B_branch.SetAddress(<void*>&self.m1PhiRochCor2011B_value)

        #print "making m1PhiRochCor2012"
        self.m1PhiRochCor2012_branch = the_tree.GetBranch("m1PhiRochCor2012")
        #if not self.m1PhiRochCor2012_branch and "m1PhiRochCor2012" not in self.complained:
        if not self.m1PhiRochCor2012_branch and "m1PhiRochCor2012":
            warnings.warn( "EMuMuMuTree: Expected branch m1PhiRochCor2012 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1PhiRochCor2012")
        else:
            self.m1PhiRochCor2012_branch.SetAddress(<void*>&self.m1PhiRochCor2012_value)

        #print "making m1PixHits"
        self.m1PixHits_branch = the_tree.GetBranch("m1PixHits")
        #if not self.m1PixHits_branch and "m1PixHits" not in self.complained:
        if not self.m1PixHits_branch and "m1PixHits":
            warnings.warn( "EMuMuMuTree: Expected branch m1PixHits does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1PixHits")
        else:
            self.m1PixHits_branch.SetAddress(<void*>&self.m1PixHits_value)

        #print "making m1Pt"
        self.m1Pt_branch = the_tree.GetBranch("m1Pt")
        #if not self.m1Pt_branch and "m1Pt" not in self.complained:
        if not self.m1Pt_branch and "m1Pt":
            warnings.warn( "EMuMuMuTree: Expected branch m1Pt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1Pt")
        else:
            self.m1Pt_branch.SetAddress(<void*>&self.m1Pt_value)

        #print "making m1PtRochCor2011A"
        self.m1PtRochCor2011A_branch = the_tree.GetBranch("m1PtRochCor2011A")
        #if not self.m1PtRochCor2011A_branch and "m1PtRochCor2011A" not in self.complained:
        if not self.m1PtRochCor2011A_branch and "m1PtRochCor2011A":
            warnings.warn( "EMuMuMuTree: Expected branch m1PtRochCor2011A does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1PtRochCor2011A")
        else:
            self.m1PtRochCor2011A_branch.SetAddress(<void*>&self.m1PtRochCor2011A_value)

        #print "making m1PtRochCor2011B"
        self.m1PtRochCor2011B_branch = the_tree.GetBranch("m1PtRochCor2011B")
        #if not self.m1PtRochCor2011B_branch and "m1PtRochCor2011B" not in self.complained:
        if not self.m1PtRochCor2011B_branch and "m1PtRochCor2011B":
            warnings.warn( "EMuMuMuTree: Expected branch m1PtRochCor2011B does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1PtRochCor2011B")
        else:
            self.m1PtRochCor2011B_branch.SetAddress(<void*>&self.m1PtRochCor2011B_value)

        #print "making m1PtRochCor2012"
        self.m1PtRochCor2012_branch = the_tree.GetBranch("m1PtRochCor2012")
        #if not self.m1PtRochCor2012_branch and "m1PtRochCor2012" not in self.complained:
        if not self.m1PtRochCor2012_branch and "m1PtRochCor2012":
            warnings.warn( "EMuMuMuTree: Expected branch m1PtRochCor2012 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1PtRochCor2012")
        else:
            self.m1PtRochCor2012_branch.SetAddress(<void*>&self.m1PtRochCor2012_value)

        #print "making m1Rank"
        self.m1Rank_branch = the_tree.GetBranch("m1Rank")
        #if not self.m1Rank_branch and "m1Rank" not in self.complained:
        if not self.m1Rank_branch and "m1Rank":
            warnings.warn( "EMuMuMuTree: Expected branch m1Rank does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1Rank")
        else:
            self.m1Rank_branch.SetAddress(<void*>&self.m1Rank_value)

        #print "making m1RelPFIsoDB"
        self.m1RelPFIsoDB_branch = the_tree.GetBranch("m1RelPFIsoDB")
        #if not self.m1RelPFIsoDB_branch and "m1RelPFIsoDB" not in self.complained:
        if not self.m1RelPFIsoDB_branch and "m1RelPFIsoDB":
            warnings.warn( "EMuMuMuTree: Expected branch m1RelPFIsoDB does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1RelPFIsoDB")
        else:
            self.m1RelPFIsoDB_branch.SetAddress(<void*>&self.m1RelPFIsoDB_value)

        #print "making m1RelPFIsoRho"
        self.m1RelPFIsoRho_branch = the_tree.GetBranch("m1RelPFIsoRho")
        #if not self.m1RelPFIsoRho_branch and "m1RelPFIsoRho" not in self.complained:
        if not self.m1RelPFIsoRho_branch and "m1RelPFIsoRho":
            warnings.warn( "EMuMuMuTree: Expected branch m1RelPFIsoRho does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1RelPFIsoRho")
        else:
            self.m1RelPFIsoRho_branch.SetAddress(<void*>&self.m1RelPFIsoRho_value)

        #print "making m1RelPFIsoRhoFSR"
        self.m1RelPFIsoRhoFSR_branch = the_tree.GetBranch("m1RelPFIsoRhoFSR")
        #if not self.m1RelPFIsoRhoFSR_branch and "m1RelPFIsoRhoFSR" not in self.complained:
        if not self.m1RelPFIsoRhoFSR_branch and "m1RelPFIsoRhoFSR":
            warnings.warn( "EMuMuMuTree: Expected branch m1RelPFIsoRhoFSR does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1RelPFIsoRhoFSR")
        else:
            self.m1RelPFIsoRhoFSR_branch.SetAddress(<void*>&self.m1RelPFIsoRhoFSR_value)

        #print "making m1RhoHZG2011"
        self.m1RhoHZG2011_branch = the_tree.GetBranch("m1RhoHZG2011")
        #if not self.m1RhoHZG2011_branch and "m1RhoHZG2011" not in self.complained:
        if not self.m1RhoHZG2011_branch and "m1RhoHZG2011":
            warnings.warn( "EMuMuMuTree: Expected branch m1RhoHZG2011 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1RhoHZG2011")
        else:
            self.m1RhoHZG2011_branch.SetAddress(<void*>&self.m1RhoHZG2011_value)

        #print "making m1RhoHZG2012"
        self.m1RhoHZG2012_branch = the_tree.GetBranch("m1RhoHZG2012")
        #if not self.m1RhoHZG2012_branch and "m1RhoHZG2012" not in self.complained:
        if not self.m1RhoHZG2012_branch and "m1RhoHZG2012":
            warnings.warn( "EMuMuMuTree: Expected branch m1RhoHZG2012 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1RhoHZG2012")
        else:
            self.m1RhoHZG2012_branch.SetAddress(<void*>&self.m1RhoHZG2012_value)

        #print "making m1SingleMu13L3Filtered13"
        self.m1SingleMu13L3Filtered13_branch = the_tree.GetBranch("m1SingleMu13L3Filtered13")
        #if not self.m1SingleMu13L3Filtered13_branch and "m1SingleMu13L3Filtered13" not in self.complained:
        if not self.m1SingleMu13L3Filtered13_branch and "m1SingleMu13L3Filtered13":
            warnings.warn( "EMuMuMuTree: Expected branch m1SingleMu13L3Filtered13 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1SingleMu13L3Filtered13")
        else:
            self.m1SingleMu13L3Filtered13_branch.SetAddress(<void*>&self.m1SingleMu13L3Filtered13_value)

        #print "making m1SingleMu13L3Filtered17"
        self.m1SingleMu13L3Filtered17_branch = the_tree.GetBranch("m1SingleMu13L3Filtered17")
        #if not self.m1SingleMu13L3Filtered17_branch and "m1SingleMu13L3Filtered17" not in self.complained:
        if not self.m1SingleMu13L3Filtered17_branch and "m1SingleMu13L3Filtered17":
            warnings.warn( "EMuMuMuTree: Expected branch m1SingleMu13L3Filtered17 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1SingleMu13L3Filtered17")
        else:
            self.m1SingleMu13L3Filtered17_branch.SetAddress(<void*>&self.m1SingleMu13L3Filtered17_value)

        #print "making m1TkLayersWithMeasurement"
        self.m1TkLayersWithMeasurement_branch = the_tree.GetBranch("m1TkLayersWithMeasurement")
        #if not self.m1TkLayersWithMeasurement_branch and "m1TkLayersWithMeasurement" not in self.complained:
        if not self.m1TkLayersWithMeasurement_branch and "m1TkLayersWithMeasurement":
            warnings.warn( "EMuMuMuTree: Expected branch m1TkLayersWithMeasurement does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1TkLayersWithMeasurement")
        else:
            self.m1TkLayersWithMeasurement_branch.SetAddress(<void*>&self.m1TkLayersWithMeasurement_value)

        #print "making m1ToMETDPhi"
        self.m1ToMETDPhi_branch = the_tree.GetBranch("m1ToMETDPhi")
        #if not self.m1ToMETDPhi_branch and "m1ToMETDPhi" not in self.complained:
        if not self.m1ToMETDPhi_branch and "m1ToMETDPhi":
            warnings.warn( "EMuMuMuTree: Expected branch m1ToMETDPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1ToMETDPhi")
        else:
            self.m1ToMETDPhi_branch.SetAddress(<void*>&self.m1ToMETDPhi_value)

        #print "making m1TypeCode"
        self.m1TypeCode_branch = the_tree.GetBranch("m1TypeCode")
        #if not self.m1TypeCode_branch and "m1TypeCode" not in self.complained:
        if not self.m1TypeCode_branch and "m1TypeCode":
            warnings.warn( "EMuMuMuTree: Expected branch m1TypeCode does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1TypeCode")
        else:
            self.m1TypeCode_branch.SetAddress(<void*>&self.m1TypeCode_value)

        #print "making m1VBTFID"
        self.m1VBTFID_branch = the_tree.GetBranch("m1VBTFID")
        #if not self.m1VBTFID_branch and "m1VBTFID" not in self.complained:
        if not self.m1VBTFID_branch and "m1VBTFID":
            warnings.warn( "EMuMuMuTree: Expected branch m1VBTFID does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1VBTFID")
        else:
            self.m1VBTFID_branch.SetAddress(<void*>&self.m1VBTFID_value)

        #print "making m1VZ"
        self.m1VZ_branch = the_tree.GetBranch("m1VZ")
        #if not self.m1VZ_branch and "m1VZ" not in self.complained:
        if not self.m1VZ_branch and "m1VZ":
            warnings.warn( "EMuMuMuTree: Expected branch m1VZ does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1VZ")
        else:
            self.m1VZ_branch.SetAddress(<void*>&self.m1VZ_value)

        #print "making m1WWID"
        self.m1WWID_branch = the_tree.GetBranch("m1WWID")
        #if not self.m1WWID_branch and "m1WWID" not in self.complained:
        if not self.m1WWID_branch and "m1WWID":
            warnings.warn( "EMuMuMuTree: Expected branch m1WWID does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1WWID")
        else:
            self.m1WWID_branch.SetAddress(<void*>&self.m1WWID_value)

        #print "making m1_m2_CosThetaStar"
        self.m1_m2_CosThetaStar_branch = the_tree.GetBranch("m1_m2_CosThetaStar")
        #if not self.m1_m2_CosThetaStar_branch and "m1_m2_CosThetaStar" not in self.complained:
        if not self.m1_m2_CosThetaStar_branch and "m1_m2_CosThetaStar":
            warnings.warn( "EMuMuMuTree: Expected branch m1_m2_CosThetaStar does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_m2_CosThetaStar")
        else:
            self.m1_m2_CosThetaStar_branch.SetAddress(<void*>&self.m1_m2_CosThetaStar_value)

        #print "making m1_m2_DPhi"
        self.m1_m2_DPhi_branch = the_tree.GetBranch("m1_m2_DPhi")
        #if not self.m1_m2_DPhi_branch and "m1_m2_DPhi" not in self.complained:
        if not self.m1_m2_DPhi_branch and "m1_m2_DPhi":
            warnings.warn( "EMuMuMuTree: Expected branch m1_m2_DPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_m2_DPhi")
        else:
            self.m1_m2_DPhi_branch.SetAddress(<void*>&self.m1_m2_DPhi_value)

        #print "making m1_m2_DR"
        self.m1_m2_DR_branch = the_tree.GetBranch("m1_m2_DR")
        #if not self.m1_m2_DR_branch and "m1_m2_DR" not in self.complained:
        if not self.m1_m2_DR_branch and "m1_m2_DR":
            warnings.warn( "EMuMuMuTree: Expected branch m1_m2_DR does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_m2_DR")
        else:
            self.m1_m2_DR_branch.SetAddress(<void*>&self.m1_m2_DR_value)

        #print "making m1_m2_Eta"
        self.m1_m2_Eta_branch = the_tree.GetBranch("m1_m2_Eta")
        #if not self.m1_m2_Eta_branch and "m1_m2_Eta" not in self.complained:
        if not self.m1_m2_Eta_branch and "m1_m2_Eta":
            warnings.warn( "EMuMuMuTree: Expected branch m1_m2_Eta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_m2_Eta")
        else:
            self.m1_m2_Eta_branch.SetAddress(<void*>&self.m1_m2_Eta_value)

        #print "making m1_m2_Mass"
        self.m1_m2_Mass_branch = the_tree.GetBranch("m1_m2_Mass")
        #if not self.m1_m2_Mass_branch and "m1_m2_Mass" not in self.complained:
        if not self.m1_m2_Mass_branch and "m1_m2_Mass":
            warnings.warn( "EMuMuMuTree: Expected branch m1_m2_Mass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_m2_Mass")
        else:
            self.m1_m2_Mass_branch.SetAddress(<void*>&self.m1_m2_Mass_value)

        #print "making m1_m2_MassFsr"
        self.m1_m2_MassFsr_branch = the_tree.GetBranch("m1_m2_MassFsr")
        #if not self.m1_m2_MassFsr_branch and "m1_m2_MassFsr" not in self.complained:
        if not self.m1_m2_MassFsr_branch and "m1_m2_MassFsr":
            warnings.warn( "EMuMuMuTree: Expected branch m1_m2_MassFsr does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_m2_MassFsr")
        else:
            self.m1_m2_MassFsr_branch.SetAddress(<void*>&self.m1_m2_MassFsr_value)

        #print "making m1_m2_PZeta"
        self.m1_m2_PZeta_branch = the_tree.GetBranch("m1_m2_PZeta")
        #if not self.m1_m2_PZeta_branch and "m1_m2_PZeta" not in self.complained:
        if not self.m1_m2_PZeta_branch and "m1_m2_PZeta":
            warnings.warn( "EMuMuMuTree: Expected branch m1_m2_PZeta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_m2_PZeta")
        else:
            self.m1_m2_PZeta_branch.SetAddress(<void*>&self.m1_m2_PZeta_value)

        #print "making m1_m2_PZetaVis"
        self.m1_m2_PZetaVis_branch = the_tree.GetBranch("m1_m2_PZetaVis")
        #if not self.m1_m2_PZetaVis_branch and "m1_m2_PZetaVis" not in self.complained:
        if not self.m1_m2_PZetaVis_branch and "m1_m2_PZetaVis":
            warnings.warn( "EMuMuMuTree: Expected branch m1_m2_PZetaVis does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_m2_PZetaVis")
        else:
            self.m1_m2_PZetaVis_branch.SetAddress(<void*>&self.m1_m2_PZetaVis_value)

        #print "making m1_m2_Phi"
        self.m1_m2_Phi_branch = the_tree.GetBranch("m1_m2_Phi")
        #if not self.m1_m2_Phi_branch and "m1_m2_Phi" not in self.complained:
        if not self.m1_m2_Phi_branch and "m1_m2_Phi":
            warnings.warn( "EMuMuMuTree: Expected branch m1_m2_Phi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_m2_Phi")
        else:
            self.m1_m2_Phi_branch.SetAddress(<void*>&self.m1_m2_Phi_value)

        #print "making m1_m2_Pt"
        self.m1_m2_Pt_branch = the_tree.GetBranch("m1_m2_Pt")
        #if not self.m1_m2_Pt_branch and "m1_m2_Pt" not in self.complained:
        if not self.m1_m2_Pt_branch and "m1_m2_Pt":
            warnings.warn( "EMuMuMuTree: Expected branch m1_m2_Pt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_m2_Pt")
        else:
            self.m1_m2_Pt_branch.SetAddress(<void*>&self.m1_m2_Pt_value)

        #print "making m1_m2_PtFsr"
        self.m1_m2_PtFsr_branch = the_tree.GetBranch("m1_m2_PtFsr")
        #if not self.m1_m2_PtFsr_branch and "m1_m2_PtFsr" not in self.complained:
        if not self.m1_m2_PtFsr_branch and "m1_m2_PtFsr":
            warnings.warn( "EMuMuMuTree: Expected branch m1_m2_PtFsr does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_m2_PtFsr")
        else:
            self.m1_m2_PtFsr_branch.SetAddress(<void*>&self.m1_m2_PtFsr_value)

        #print "making m1_m2_SS"
        self.m1_m2_SS_branch = the_tree.GetBranch("m1_m2_SS")
        #if not self.m1_m2_SS_branch and "m1_m2_SS" not in self.complained:
        if not self.m1_m2_SS_branch and "m1_m2_SS":
            warnings.warn( "EMuMuMuTree: Expected branch m1_m2_SS does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_m2_SS")
        else:
            self.m1_m2_SS_branch.SetAddress(<void*>&self.m1_m2_SS_value)

        #print "making m1_m2_ToMETDPhi_Ty1"
        self.m1_m2_ToMETDPhi_Ty1_branch = the_tree.GetBranch("m1_m2_ToMETDPhi_Ty1")
        #if not self.m1_m2_ToMETDPhi_Ty1_branch and "m1_m2_ToMETDPhi_Ty1" not in self.complained:
        if not self.m1_m2_ToMETDPhi_Ty1_branch and "m1_m2_ToMETDPhi_Ty1":
            warnings.warn( "EMuMuMuTree: Expected branch m1_m2_ToMETDPhi_Ty1 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_m2_ToMETDPhi_Ty1")
        else:
            self.m1_m2_ToMETDPhi_Ty1_branch.SetAddress(<void*>&self.m1_m2_ToMETDPhi_Ty1_value)

        #print "making m1_m2_Zcompat"
        self.m1_m2_Zcompat_branch = the_tree.GetBranch("m1_m2_Zcompat")
        #if not self.m1_m2_Zcompat_branch and "m1_m2_Zcompat" not in self.complained:
        if not self.m1_m2_Zcompat_branch and "m1_m2_Zcompat":
            warnings.warn( "EMuMuMuTree: Expected branch m1_m2_Zcompat does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_m2_Zcompat")
        else:
            self.m1_m2_Zcompat_branch.SetAddress(<void*>&self.m1_m2_Zcompat_value)

        #print "making m1_m3_CosThetaStar"
        self.m1_m3_CosThetaStar_branch = the_tree.GetBranch("m1_m3_CosThetaStar")
        #if not self.m1_m3_CosThetaStar_branch and "m1_m3_CosThetaStar" not in self.complained:
        if not self.m1_m3_CosThetaStar_branch and "m1_m3_CosThetaStar":
            warnings.warn( "EMuMuMuTree: Expected branch m1_m3_CosThetaStar does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_m3_CosThetaStar")
        else:
            self.m1_m3_CosThetaStar_branch.SetAddress(<void*>&self.m1_m3_CosThetaStar_value)

        #print "making m1_m3_DPhi"
        self.m1_m3_DPhi_branch = the_tree.GetBranch("m1_m3_DPhi")
        #if not self.m1_m3_DPhi_branch and "m1_m3_DPhi" not in self.complained:
        if not self.m1_m3_DPhi_branch and "m1_m3_DPhi":
            warnings.warn( "EMuMuMuTree: Expected branch m1_m3_DPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_m3_DPhi")
        else:
            self.m1_m3_DPhi_branch.SetAddress(<void*>&self.m1_m3_DPhi_value)

        #print "making m1_m3_DR"
        self.m1_m3_DR_branch = the_tree.GetBranch("m1_m3_DR")
        #if not self.m1_m3_DR_branch and "m1_m3_DR" not in self.complained:
        if not self.m1_m3_DR_branch and "m1_m3_DR":
            warnings.warn( "EMuMuMuTree: Expected branch m1_m3_DR does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_m3_DR")
        else:
            self.m1_m3_DR_branch.SetAddress(<void*>&self.m1_m3_DR_value)

        #print "making m1_m3_Eta"
        self.m1_m3_Eta_branch = the_tree.GetBranch("m1_m3_Eta")
        #if not self.m1_m3_Eta_branch and "m1_m3_Eta" not in self.complained:
        if not self.m1_m3_Eta_branch and "m1_m3_Eta":
            warnings.warn( "EMuMuMuTree: Expected branch m1_m3_Eta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_m3_Eta")
        else:
            self.m1_m3_Eta_branch.SetAddress(<void*>&self.m1_m3_Eta_value)

        #print "making m1_m3_Mass"
        self.m1_m3_Mass_branch = the_tree.GetBranch("m1_m3_Mass")
        #if not self.m1_m3_Mass_branch and "m1_m3_Mass" not in self.complained:
        if not self.m1_m3_Mass_branch and "m1_m3_Mass":
            warnings.warn( "EMuMuMuTree: Expected branch m1_m3_Mass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_m3_Mass")
        else:
            self.m1_m3_Mass_branch.SetAddress(<void*>&self.m1_m3_Mass_value)

        #print "making m1_m3_MassFsr"
        self.m1_m3_MassFsr_branch = the_tree.GetBranch("m1_m3_MassFsr")
        #if not self.m1_m3_MassFsr_branch and "m1_m3_MassFsr" not in self.complained:
        if not self.m1_m3_MassFsr_branch and "m1_m3_MassFsr":
            warnings.warn( "EMuMuMuTree: Expected branch m1_m3_MassFsr does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_m3_MassFsr")
        else:
            self.m1_m3_MassFsr_branch.SetAddress(<void*>&self.m1_m3_MassFsr_value)

        #print "making m1_m3_PZeta"
        self.m1_m3_PZeta_branch = the_tree.GetBranch("m1_m3_PZeta")
        #if not self.m1_m3_PZeta_branch and "m1_m3_PZeta" not in self.complained:
        if not self.m1_m3_PZeta_branch and "m1_m3_PZeta":
            warnings.warn( "EMuMuMuTree: Expected branch m1_m3_PZeta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_m3_PZeta")
        else:
            self.m1_m3_PZeta_branch.SetAddress(<void*>&self.m1_m3_PZeta_value)

        #print "making m1_m3_PZetaVis"
        self.m1_m3_PZetaVis_branch = the_tree.GetBranch("m1_m3_PZetaVis")
        #if not self.m1_m3_PZetaVis_branch and "m1_m3_PZetaVis" not in self.complained:
        if not self.m1_m3_PZetaVis_branch and "m1_m3_PZetaVis":
            warnings.warn( "EMuMuMuTree: Expected branch m1_m3_PZetaVis does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_m3_PZetaVis")
        else:
            self.m1_m3_PZetaVis_branch.SetAddress(<void*>&self.m1_m3_PZetaVis_value)

        #print "making m1_m3_Phi"
        self.m1_m3_Phi_branch = the_tree.GetBranch("m1_m3_Phi")
        #if not self.m1_m3_Phi_branch and "m1_m3_Phi" not in self.complained:
        if not self.m1_m3_Phi_branch and "m1_m3_Phi":
            warnings.warn( "EMuMuMuTree: Expected branch m1_m3_Phi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_m3_Phi")
        else:
            self.m1_m3_Phi_branch.SetAddress(<void*>&self.m1_m3_Phi_value)

        #print "making m1_m3_Pt"
        self.m1_m3_Pt_branch = the_tree.GetBranch("m1_m3_Pt")
        #if not self.m1_m3_Pt_branch and "m1_m3_Pt" not in self.complained:
        if not self.m1_m3_Pt_branch and "m1_m3_Pt":
            warnings.warn( "EMuMuMuTree: Expected branch m1_m3_Pt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_m3_Pt")
        else:
            self.m1_m3_Pt_branch.SetAddress(<void*>&self.m1_m3_Pt_value)

        #print "making m1_m3_PtFsr"
        self.m1_m3_PtFsr_branch = the_tree.GetBranch("m1_m3_PtFsr")
        #if not self.m1_m3_PtFsr_branch and "m1_m3_PtFsr" not in self.complained:
        if not self.m1_m3_PtFsr_branch and "m1_m3_PtFsr":
            warnings.warn( "EMuMuMuTree: Expected branch m1_m3_PtFsr does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_m3_PtFsr")
        else:
            self.m1_m3_PtFsr_branch.SetAddress(<void*>&self.m1_m3_PtFsr_value)

        #print "making m1_m3_SS"
        self.m1_m3_SS_branch = the_tree.GetBranch("m1_m3_SS")
        #if not self.m1_m3_SS_branch and "m1_m3_SS" not in self.complained:
        if not self.m1_m3_SS_branch and "m1_m3_SS":
            warnings.warn( "EMuMuMuTree: Expected branch m1_m3_SS does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_m3_SS")
        else:
            self.m1_m3_SS_branch.SetAddress(<void*>&self.m1_m3_SS_value)

        #print "making m1_m3_ToMETDPhi_Ty1"
        self.m1_m3_ToMETDPhi_Ty1_branch = the_tree.GetBranch("m1_m3_ToMETDPhi_Ty1")
        #if not self.m1_m3_ToMETDPhi_Ty1_branch and "m1_m3_ToMETDPhi_Ty1" not in self.complained:
        if not self.m1_m3_ToMETDPhi_Ty1_branch and "m1_m3_ToMETDPhi_Ty1":
            warnings.warn( "EMuMuMuTree: Expected branch m1_m3_ToMETDPhi_Ty1 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_m3_ToMETDPhi_Ty1")
        else:
            self.m1_m3_ToMETDPhi_Ty1_branch.SetAddress(<void*>&self.m1_m3_ToMETDPhi_Ty1_value)

        #print "making m1_m3_Zcompat"
        self.m1_m3_Zcompat_branch = the_tree.GetBranch("m1_m3_Zcompat")
        #if not self.m1_m3_Zcompat_branch and "m1_m3_Zcompat" not in self.complained:
        if not self.m1_m3_Zcompat_branch and "m1_m3_Zcompat":
            warnings.warn( "EMuMuMuTree: Expected branch m1_m3_Zcompat does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_m3_Zcompat")
        else:
            self.m1_m3_Zcompat_branch.SetAddress(<void*>&self.m1_m3_Zcompat_value)

        #print "making m2AbsEta"
        self.m2AbsEta_branch = the_tree.GetBranch("m2AbsEta")
        #if not self.m2AbsEta_branch and "m2AbsEta" not in self.complained:
        if not self.m2AbsEta_branch and "m2AbsEta":
            warnings.warn( "EMuMuMuTree: Expected branch m2AbsEta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2AbsEta")
        else:
            self.m2AbsEta_branch.SetAddress(<void*>&self.m2AbsEta_value)

        #print "making m2Charge"
        self.m2Charge_branch = the_tree.GetBranch("m2Charge")
        #if not self.m2Charge_branch and "m2Charge" not in self.complained:
        if not self.m2Charge_branch and "m2Charge":
            warnings.warn( "EMuMuMuTree: Expected branch m2Charge does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2Charge")
        else:
            self.m2Charge_branch.SetAddress(<void*>&self.m2Charge_value)

        #print "making m2ComesFromHiggs"
        self.m2ComesFromHiggs_branch = the_tree.GetBranch("m2ComesFromHiggs")
        #if not self.m2ComesFromHiggs_branch and "m2ComesFromHiggs" not in self.complained:
        if not self.m2ComesFromHiggs_branch and "m2ComesFromHiggs":
            warnings.warn( "EMuMuMuTree: Expected branch m2ComesFromHiggs does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2ComesFromHiggs")
        else:
            self.m2ComesFromHiggs_branch.SetAddress(<void*>&self.m2ComesFromHiggs_value)

        #print "making m2D0"
        self.m2D0_branch = the_tree.GetBranch("m2D0")
        #if not self.m2D0_branch and "m2D0" not in self.complained:
        if not self.m2D0_branch and "m2D0":
            warnings.warn( "EMuMuMuTree: Expected branch m2D0 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2D0")
        else:
            self.m2D0_branch.SetAddress(<void*>&self.m2D0_value)

        #print "making m2DZ"
        self.m2DZ_branch = the_tree.GetBranch("m2DZ")
        #if not self.m2DZ_branch and "m2DZ" not in self.complained:
        if not self.m2DZ_branch and "m2DZ":
            warnings.warn( "EMuMuMuTree: Expected branch m2DZ does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2DZ")
        else:
            self.m2DZ_branch.SetAddress(<void*>&self.m2DZ_value)

        #print "making m2DiMuonL3PreFiltered7"
        self.m2DiMuonL3PreFiltered7_branch = the_tree.GetBranch("m2DiMuonL3PreFiltered7")
        #if not self.m2DiMuonL3PreFiltered7_branch and "m2DiMuonL3PreFiltered7" not in self.complained:
        if not self.m2DiMuonL3PreFiltered7_branch and "m2DiMuonL3PreFiltered7":
            warnings.warn( "EMuMuMuTree: Expected branch m2DiMuonL3PreFiltered7 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2DiMuonL3PreFiltered7")
        else:
            self.m2DiMuonL3PreFiltered7_branch.SetAddress(<void*>&self.m2DiMuonL3PreFiltered7_value)

        #print "making m2DiMuonL3p5PreFiltered8"
        self.m2DiMuonL3p5PreFiltered8_branch = the_tree.GetBranch("m2DiMuonL3p5PreFiltered8")
        #if not self.m2DiMuonL3p5PreFiltered8_branch and "m2DiMuonL3p5PreFiltered8" not in self.complained:
        if not self.m2DiMuonL3p5PreFiltered8_branch and "m2DiMuonL3p5PreFiltered8":
            warnings.warn( "EMuMuMuTree: Expected branch m2DiMuonL3p5PreFiltered8 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2DiMuonL3p5PreFiltered8")
        else:
            self.m2DiMuonL3p5PreFiltered8_branch.SetAddress(<void*>&self.m2DiMuonL3p5PreFiltered8_value)

        #print "making m2DiMuonMu17Mu8DzFiltered0p2"
        self.m2DiMuonMu17Mu8DzFiltered0p2_branch = the_tree.GetBranch("m2DiMuonMu17Mu8DzFiltered0p2")
        #if not self.m2DiMuonMu17Mu8DzFiltered0p2_branch and "m2DiMuonMu17Mu8DzFiltered0p2" not in self.complained:
        if not self.m2DiMuonMu17Mu8DzFiltered0p2_branch and "m2DiMuonMu17Mu8DzFiltered0p2":
            warnings.warn( "EMuMuMuTree: Expected branch m2DiMuonMu17Mu8DzFiltered0p2 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2DiMuonMu17Mu8DzFiltered0p2")
        else:
            self.m2DiMuonMu17Mu8DzFiltered0p2_branch.SetAddress(<void*>&self.m2DiMuonMu17Mu8DzFiltered0p2_value)

        #print "making m2EErrRochCor2011A"
        self.m2EErrRochCor2011A_branch = the_tree.GetBranch("m2EErrRochCor2011A")
        #if not self.m2EErrRochCor2011A_branch and "m2EErrRochCor2011A" not in self.complained:
        if not self.m2EErrRochCor2011A_branch and "m2EErrRochCor2011A":
            warnings.warn( "EMuMuMuTree: Expected branch m2EErrRochCor2011A does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2EErrRochCor2011A")
        else:
            self.m2EErrRochCor2011A_branch.SetAddress(<void*>&self.m2EErrRochCor2011A_value)

        #print "making m2EErrRochCor2011B"
        self.m2EErrRochCor2011B_branch = the_tree.GetBranch("m2EErrRochCor2011B")
        #if not self.m2EErrRochCor2011B_branch and "m2EErrRochCor2011B" not in self.complained:
        if not self.m2EErrRochCor2011B_branch and "m2EErrRochCor2011B":
            warnings.warn( "EMuMuMuTree: Expected branch m2EErrRochCor2011B does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2EErrRochCor2011B")
        else:
            self.m2EErrRochCor2011B_branch.SetAddress(<void*>&self.m2EErrRochCor2011B_value)

        #print "making m2EErrRochCor2012"
        self.m2EErrRochCor2012_branch = the_tree.GetBranch("m2EErrRochCor2012")
        #if not self.m2EErrRochCor2012_branch and "m2EErrRochCor2012" not in self.complained:
        if not self.m2EErrRochCor2012_branch and "m2EErrRochCor2012":
            warnings.warn( "EMuMuMuTree: Expected branch m2EErrRochCor2012 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2EErrRochCor2012")
        else:
            self.m2EErrRochCor2012_branch.SetAddress(<void*>&self.m2EErrRochCor2012_value)

        #print "making m2ERochCor2011A"
        self.m2ERochCor2011A_branch = the_tree.GetBranch("m2ERochCor2011A")
        #if not self.m2ERochCor2011A_branch and "m2ERochCor2011A" not in self.complained:
        if not self.m2ERochCor2011A_branch and "m2ERochCor2011A":
            warnings.warn( "EMuMuMuTree: Expected branch m2ERochCor2011A does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2ERochCor2011A")
        else:
            self.m2ERochCor2011A_branch.SetAddress(<void*>&self.m2ERochCor2011A_value)

        #print "making m2ERochCor2011B"
        self.m2ERochCor2011B_branch = the_tree.GetBranch("m2ERochCor2011B")
        #if not self.m2ERochCor2011B_branch and "m2ERochCor2011B" not in self.complained:
        if not self.m2ERochCor2011B_branch and "m2ERochCor2011B":
            warnings.warn( "EMuMuMuTree: Expected branch m2ERochCor2011B does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2ERochCor2011B")
        else:
            self.m2ERochCor2011B_branch.SetAddress(<void*>&self.m2ERochCor2011B_value)

        #print "making m2ERochCor2012"
        self.m2ERochCor2012_branch = the_tree.GetBranch("m2ERochCor2012")
        #if not self.m2ERochCor2012_branch and "m2ERochCor2012" not in self.complained:
        if not self.m2ERochCor2012_branch and "m2ERochCor2012":
            warnings.warn( "EMuMuMuTree: Expected branch m2ERochCor2012 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2ERochCor2012")
        else:
            self.m2ERochCor2012_branch.SetAddress(<void*>&self.m2ERochCor2012_value)

        #print "making m2EffectiveArea2011"
        self.m2EffectiveArea2011_branch = the_tree.GetBranch("m2EffectiveArea2011")
        #if not self.m2EffectiveArea2011_branch and "m2EffectiveArea2011" not in self.complained:
        if not self.m2EffectiveArea2011_branch and "m2EffectiveArea2011":
            warnings.warn( "EMuMuMuTree: Expected branch m2EffectiveArea2011 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2EffectiveArea2011")
        else:
            self.m2EffectiveArea2011_branch.SetAddress(<void*>&self.m2EffectiveArea2011_value)

        #print "making m2EffectiveArea2012"
        self.m2EffectiveArea2012_branch = the_tree.GetBranch("m2EffectiveArea2012")
        #if not self.m2EffectiveArea2012_branch and "m2EffectiveArea2012" not in self.complained:
        if not self.m2EffectiveArea2012_branch and "m2EffectiveArea2012":
            warnings.warn( "EMuMuMuTree: Expected branch m2EffectiveArea2012 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2EffectiveArea2012")
        else:
            self.m2EffectiveArea2012_branch.SetAddress(<void*>&self.m2EffectiveArea2012_value)

        #print "making m2Eta"
        self.m2Eta_branch = the_tree.GetBranch("m2Eta")
        #if not self.m2Eta_branch and "m2Eta" not in self.complained:
        if not self.m2Eta_branch and "m2Eta":
            warnings.warn( "EMuMuMuTree: Expected branch m2Eta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2Eta")
        else:
            self.m2Eta_branch.SetAddress(<void*>&self.m2Eta_value)

        #print "making m2EtaRochCor2011A"
        self.m2EtaRochCor2011A_branch = the_tree.GetBranch("m2EtaRochCor2011A")
        #if not self.m2EtaRochCor2011A_branch and "m2EtaRochCor2011A" not in self.complained:
        if not self.m2EtaRochCor2011A_branch and "m2EtaRochCor2011A":
            warnings.warn( "EMuMuMuTree: Expected branch m2EtaRochCor2011A does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2EtaRochCor2011A")
        else:
            self.m2EtaRochCor2011A_branch.SetAddress(<void*>&self.m2EtaRochCor2011A_value)

        #print "making m2EtaRochCor2011B"
        self.m2EtaRochCor2011B_branch = the_tree.GetBranch("m2EtaRochCor2011B")
        #if not self.m2EtaRochCor2011B_branch and "m2EtaRochCor2011B" not in self.complained:
        if not self.m2EtaRochCor2011B_branch and "m2EtaRochCor2011B":
            warnings.warn( "EMuMuMuTree: Expected branch m2EtaRochCor2011B does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2EtaRochCor2011B")
        else:
            self.m2EtaRochCor2011B_branch.SetAddress(<void*>&self.m2EtaRochCor2011B_value)

        #print "making m2EtaRochCor2012"
        self.m2EtaRochCor2012_branch = the_tree.GetBranch("m2EtaRochCor2012")
        #if not self.m2EtaRochCor2012_branch and "m2EtaRochCor2012" not in self.complained:
        if not self.m2EtaRochCor2012_branch and "m2EtaRochCor2012":
            warnings.warn( "EMuMuMuTree: Expected branch m2EtaRochCor2012 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2EtaRochCor2012")
        else:
            self.m2EtaRochCor2012_branch.SetAddress(<void*>&self.m2EtaRochCor2012_value)

        #print "making m2GenCharge"
        self.m2GenCharge_branch = the_tree.GetBranch("m2GenCharge")
        #if not self.m2GenCharge_branch and "m2GenCharge" not in self.complained:
        if not self.m2GenCharge_branch and "m2GenCharge":
            warnings.warn( "EMuMuMuTree: Expected branch m2GenCharge does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2GenCharge")
        else:
            self.m2GenCharge_branch.SetAddress(<void*>&self.m2GenCharge_value)

        #print "making m2GenEnergy"
        self.m2GenEnergy_branch = the_tree.GetBranch("m2GenEnergy")
        #if not self.m2GenEnergy_branch and "m2GenEnergy" not in self.complained:
        if not self.m2GenEnergy_branch and "m2GenEnergy":
            warnings.warn( "EMuMuMuTree: Expected branch m2GenEnergy does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2GenEnergy")
        else:
            self.m2GenEnergy_branch.SetAddress(<void*>&self.m2GenEnergy_value)

        #print "making m2GenEta"
        self.m2GenEta_branch = the_tree.GetBranch("m2GenEta")
        #if not self.m2GenEta_branch and "m2GenEta" not in self.complained:
        if not self.m2GenEta_branch and "m2GenEta":
            warnings.warn( "EMuMuMuTree: Expected branch m2GenEta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2GenEta")
        else:
            self.m2GenEta_branch.SetAddress(<void*>&self.m2GenEta_value)

        #print "making m2GenMotherPdgId"
        self.m2GenMotherPdgId_branch = the_tree.GetBranch("m2GenMotherPdgId")
        #if not self.m2GenMotherPdgId_branch and "m2GenMotherPdgId" not in self.complained:
        if not self.m2GenMotherPdgId_branch and "m2GenMotherPdgId":
            warnings.warn( "EMuMuMuTree: Expected branch m2GenMotherPdgId does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2GenMotherPdgId")
        else:
            self.m2GenMotherPdgId_branch.SetAddress(<void*>&self.m2GenMotherPdgId_value)

        #print "making m2GenPdgId"
        self.m2GenPdgId_branch = the_tree.GetBranch("m2GenPdgId")
        #if not self.m2GenPdgId_branch and "m2GenPdgId" not in self.complained:
        if not self.m2GenPdgId_branch and "m2GenPdgId":
            warnings.warn( "EMuMuMuTree: Expected branch m2GenPdgId does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2GenPdgId")
        else:
            self.m2GenPdgId_branch.SetAddress(<void*>&self.m2GenPdgId_value)

        #print "making m2GenPhi"
        self.m2GenPhi_branch = the_tree.GetBranch("m2GenPhi")
        #if not self.m2GenPhi_branch and "m2GenPhi" not in self.complained:
        if not self.m2GenPhi_branch and "m2GenPhi":
            warnings.warn( "EMuMuMuTree: Expected branch m2GenPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2GenPhi")
        else:
            self.m2GenPhi_branch.SetAddress(<void*>&self.m2GenPhi_value)

        #print "making m2GlbTrkHits"
        self.m2GlbTrkHits_branch = the_tree.GetBranch("m2GlbTrkHits")
        #if not self.m2GlbTrkHits_branch and "m2GlbTrkHits" not in self.complained:
        if not self.m2GlbTrkHits_branch and "m2GlbTrkHits":
            warnings.warn( "EMuMuMuTree: Expected branch m2GlbTrkHits does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2GlbTrkHits")
        else:
            self.m2GlbTrkHits_branch.SetAddress(<void*>&self.m2GlbTrkHits_value)

        #print "making m2IDHZG2011"
        self.m2IDHZG2011_branch = the_tree.GetBranch("m2IDHZG2011")
        #if not self.m2IDHZG2011_branch and "m2IDHZG2011" not in self.complained:
        if not self.m2IDHZG2011_branch and "m2IDHZG2011":
            warnings.warn( "EMuMuMuTree: Expected branch m2IDHZG2011 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2IDHZG2011")
        else:
            self.m2IDHZG2011_branch.SetAddress(<void*>&self.m2IDHZG2011_value)

        #print "making m2IDHZG2012"
        self.m2IDHZG2012_branch = the_tree.GetBranch("m2IDHZG2012")
        #if not self.m2IDHZG2012_branch and "m2IDHZG2012" not in self.complained:
        if not self.m2IDHZG2012_branch and "m2IDHZG2012":
            warnings.warn( "EMuMuMuTree: Expected branch m2IDHZG2012 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2IDHZG2012")
        else:
            self.m2IDHZG2012_branch.SetAddress(<void*>&self.m2IDHZG2012_value)

        #print "making m2IP3DS"
        self.m2IP3DS_branch = the_tree.GetBranch("m2IP3DS")
        #if not self.m2IP3DS_branch and "m2IP3DS" not in self.complained:
        if not self.m2IP3DS_branch and "m2IP3DS":
            warnings.warn( "EMuMuMuTree: Expected branch m2IP3DS does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2IP3DS")
        else:
            self.m2IP3DS_branch.SetAddress(<void*>&self.m2IP3DS_value)

        #print "making m2IsGlobal"
        self.m2IsGlobal_branch = the_tree.GetBranch("m2IsGlobal")
        #if not self.m2IsGlobal_branch and "m2IsGlobal" not in self.complained:
        if not self.m2IsGlobal_branch and "m2IsGlobal":
            warnings.warn( "EMuMuMuTree: Expected branch m2IsGlobal does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2IsGlobal")
        else:
            self.m2IsGlobal_branch.SetAddress(<void*>&self.m2IsGlobal_value)

        #print "making m2IsPFMuon"
        self.m2IsPFMuon_branch = the_tree.GetBranch("m2IsPFMuon")
        #if not self.m2IsPFMuon_branch and "m2IsPFMuon" not in self.complained:
        if not self.m2IsPFMuon_branch and "m2IsPFMuon":
            warnings.warn( "EMuMuMuTree: Expected branch m2IsPFMuon does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2IsPFMuon")
        else:
            self.m2IsPFMuon_branch.SetAddress(<void*>&self.m2IsPFMuon_value)

        #print "making m2IsTracker"
        self.m2IsTracker_branch = the_tree.GetBranch("m2IsTracker")
        #if not self.m2IsTracker_branch and "m2IsTracker" not in self.complained:
        if not self.m2IsTracker_branch and "m2IsTracker":
            warnings.warn( "EMuMuMuTree: Expected branch m2IsTracker does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2IsTracker")
        else:
            self.m2IsTracker_branch.SetAddress(<void*>&self.m2IsTracker_value)

        #print "making m2JetArea"
        self.m2JetArea_branch = the_tree.GetBranch("m2JetArea")
        #if not self.m2JetArea_branch and "m2JetArea" not in self.complained:
        if not self.m2JetArea_branch and "m2JetArea":
            warnings.warn( "EMuMuMuTree: Expected branch m2JetArea does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2JetArea")
        else:
            self.m2JetArea_branch.SetAddress(<void*>&self.m2JetArea_value)

        #print "making m2JetBtag"
        self.m2JetBtag_branch = the_tree.GetBranch("m2JetBtag")
        #if not self.m2JetBtag_branch and "m2JetBtag" not in self.complained:
        if not self.m2JetBtag_branch and "m2JetBtag":
            warnings.warn( "EMuMuMuTree: Expected branch m2JetBtag does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2JetBtag")
        else:
            self.m2JetBtag_branch.SetAddress(<void*>&self.m2JetBtag_value)

        #print "making m2JetCSVBtag"
        self.m2JetCSVBtag_branch = the_tree.GetBranch("m2JetCSVBtag")
        #if not self.m2JetCSVBtag_branch and "m2JetCSVBtag" not in self.complained:
        if not self.m2JetCSVBtag_branch and "m2JetCSVBtag":
            warnings.warn( "EMuMuMuTree: Expected branch m2JetCSVBtag does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2JetCSVBtag")
        else:
            self.m2JetCSVBtag_branch.SetAddress(<void*>&self.m2JetCSVBtag_value)

        #print "making m2JetEtaEtaMoment"
        self.m2JetEtaEtaMoment_branch = the_tree.GetBranch("m2JetEtaEtaMoment")
        #if not self.m2JetEtaEtaMoment_branch and "m2JetEtaEtaMoment" not in self.complained:
        if not self.m2JetEtaEtaMoment_branch and "m2JetEtaEtaMoment":
            warnings.warn( "EMuMuMuTree: Expected branch m2JetEtaEtaMoment does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2JetEtaEtaMoment")
        else:
            self.m2JetEtaEtaMoment_branch.SetAddress(<void*>&self.m2JetEtaEtaMoment_value)

        #print "making m2JetEtaPhiMoment"
        self.m2JetEtaPhiMoment_branch = the_tree.GetBranch("m2JetEtaPhiMoment")
        #if not self.m2JetEtaPhiMoment_branch and "m2JetEtaPhiMoment" not in self.complained:
        if not self.m2JetEtaPhiMoment_branch and "m2JetEtaPhiMoment":
            warnings.warn( "EMuMuMuTree: Expected branch m2JetEtaPhiMoment does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2JetEtaPhiMoment")
        else:
            self.m2JetEtaPhiMoment_branch.SetAddress(<void*>&self.m2JetEtaPhiMoment_value)

        #print "making m2JetEtaPhiSpread"
        self.m2JetEtaPhiSpread_branch = the_tree.GetBranch("m2JetEtaPhiSpread")
        #if not self.m2JetEtaPhiSpread_branch and "m2JetEtaPhiSpread" not in self.complained:
        if not self.m2JetEtaPhiSpread_branch and "m2JetEtaPhiSpread":
            warnings.warn( "EMuMuMuTree: Expected branch m2JetEtaPhiSpread does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2JetEtaPhiSpread")
        else:
            self.m2JetEtaPhiSpread_branch.SetAddress(<void*>&self.m2JetEtaPhiSpread_value)

        #print "making m2JetPartonFlavour"
        self.m2JetPartonFlavour_branch = the_tree.GetBranch("m2JetPartonFlavour")
        #if not self.m2JetPartonFlavour_branch and "m2JetPartonFlavour" not in self.complained:
        if not self.m2JetPartonFlavour_branch and "m2JetPartonFlavour":
            warnings.warn( "EMuMuMuTree: Expected branch m2JetPartonFlavour does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2JetPartonFlavour")
        else:
            self.m2JetPartonFlavour_branch.SetAddress(<void*>&self.m2JetPartonFlavour_value)

        #print "making m2JetPhiPhiMoment"
        self.m2JetPhiPhiMoment_branch = the_tree.GetBranch("m2JetPhiPhiMoment")
        #if not self.m2JetPhiPhiMoment_branch and "m2JetPhiPhiMoment" not in self.complained:
        if not self.m2JetPhiPhiMoment_branch and "m2JetPhiPhiMoment":
            warnings.warn( "EMuMuMuTree: Expected branch m2JetPhiPhiMoment does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2JetPhiPhiMoment")
        else:
            self.m2JetPhiPhiMoment_branch.SetAddress(<void*>&self.m2JetPhiPhiMoment_value)

        #print "making m2JetPt"
        self.m2JetPt_branch = the_tree.GetBranch("m2JetPt")
        #if not self.m2JetPt_branch and "m2JetPt" not in self.complained:
        if not self.m2JetPt_branch and "m2JetPt":
            warnings.warn( "EMuMuMuTree: Expected branch m2JetPt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2JetPt")
        else:
            self.m2JetPt_branch.SetAddress(<void*>&self.m2JetPt_value)

        #print "making m2JetQGLikelihoodID"
        self.m2JetQGLikelihoodID_branch = the_tree.GetBranch("m2JetQGLikelihoodID")
        #if not self.m2JetQGLikelihoodID_branch and "m2JetQGLikelihoodID" not in self.complained:
        if not self.m2JetQGLikelihoodID_branch and "m2JetQGLikelihoodID":
            warnings.warn( "EMuMuMuTree: Expected branch m2JetQGLikelihoodID does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2JetQGLikelihoodID")
        else:
            self.m2JetQGLikelihoodID_branch.SetAddress(<void*>&self.m2JetQGLikelihoodID_value)

        #print "making m2JetQGMVAID"
        self.m2JetQGMVAID_branch = the_tree.GetBranch("m2JetQGMVAID")
        #if not self.m2JetQGMVAID_branch and "m2JetQGMVAID" not in self.complained:
        if not self.m2JetQGMVAID_branch and "m2JetQGMVAID":
            warnings.warn( "EMuMuMuTree: Expected branch m2JetQGMVAID does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2JetQGMVAID")
        else:
            self.m2JetQGMVAID_branch.SetAddress(<void*>&self.m2JetQGMVAID_value)

        #print "making m2Jetaxis1"
        self.m2Jetaxis1_branch = the_tree.GetBranch("m2Jetaxis1")
        #if not self.m2Jetaxis1_branch and "m2Jetaxis1" not in self.complained:
        if not self.m2Jetaxis1_branch and "m2Jetaxis1":
            warnings.warn( "EMuMuMuTree: Expected branch m2Jetaxis1 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2Jetaxis1")
        else:
            self.m2Jetaxis1_branch.SetAddress(<void*>&self.m2Jetaxis1_value)

        #print "making m2Jetaxis2"
        self.m2Jetaxis2_branch = the_tree.GetBranch("m2Jetaxis2")
        #if not self.m2Jetaxis2_branch and "m2Jetaxis2" not in self.complained:
        if not self.m2Jetaxis2_branch and "m2Jetaxis2":
            warnings.warn( "EMuMuMuTree: Expected branch m2Jetaxis2 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2Jetaxis2")
        else:
            self.m2Jetaxis2_branch.SetAddress(<void*>&self.m2Jetaxis2_value)

        #print "making m2Jetmult"
        self.m2Jetmult_branch = the_tree.GetBranch("m2Jetmult")
        #if not self.m2Jetmult_branch and "m2Jetmult" not in self.complained:
        if not self.m2Jetmult_branch and "m2Jetmult":
            warnings.warn( "EMuMuMuTree: Expected branch m2Jetmult does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2Jetmult")
        else:
            self.m2Jetmult_branch.SetAddress(<void*>&self.m2Jetmult_value)

        #print "making m2JetmultMLP"
        self.m2JetmultMLP_branch = the_tree.GetBranch("m2JetmultMLP")
        #if not self.m2JetmultMLP_branch and "m2JetmultMLP" not in self.complained:
        if not self.m2JetmultMLP_branch and "m2JetmultMLP":
            warnings.warn( "EMuMuMuTree: Expected branch m2JetmultMLP does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2JetmultMLP")
        else:
            self.m2JetmultMLP_branch.SetAddress(<void*>&self.m2JetmultMLP_value)

        #print "making m2JetmultMLPQC"
        self.m2JetmultMLPQC_branch = the_tree.GetBranch("m2JetmultMLPQC")
        #if not self.m2JetmultMLPQC_branch and "m2JetmultMLPQC" not in self.complained:
        if not self.m2JetmultMLPQC_branch and "m2JetmultMLPQC":
            warnings.warn( "EMuMuMuTree: Expected branch m2JetmultMLPQC does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2JetmultMLPQC")
        else:
            self.m2JetmultMLPQC_branch.SetAddress(<void*>&self.m2JetmultMLPQC_value)

        #print "making m2JetptD"
        self.m2JetptD_branch = the_tree.GetBranch("m2JetptD")
        #if not self.m2JetptD_branch and "m2JetptD" not in self.complained:
        if not self.m2JetptD_branch and "m2JetptD":
            warnings.warn( "EMuMuMuTree: Expected branch m2JetptD does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2JetptD")
        else:
            self.m2JetptD_branch.SetAddress(<void*>&self.m2JetptD_value)

        #print "making m2L1Mu3EG5L3Filtered17"
        self.m2L1Mu3EG5L3Filtered17_branch = the_tree.GetBranch("m2L1Mu3EG5L3Filtered17")
        #if not self.m2L1Mu3EG5L3Filtered17_branch and "m2L1Mu3EG5L3Filtered17" not in self.complained:
        if not self.m2L1Mu3EG5L3Filtered17_branch and "m2L1Mu3EG5L3Filtered17":
            warnings.warn( "EMuMuMuTree: Expected branch m2L1Mu3EG5L3Filtered17 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2L1Mu3EG5L3Filtered17")
        else:
            self.m2L1Mu3EG5L3Filtered17_branch.SetAddress(<void*>&self.m2L1Mu3EG5L3Filtered17_value)

        #print "making m2L3fL1DoubleMu10MuOpenL1f0L2f10L3Filtered17"
        self.m2L3fL1DoubleMu10MuOpenL1f0L2f10L3Filtered17_branch = the_tree.GetBranch("m2L3fL1DoubleMu10MuOpenL1f0L2f10L3Filtered17")
        #if not self.m2L3fL1DoubleMu10MuOpenL1f0L2f10L3Filtered17_branch and "m2L3fL1DoubleMu10MuOpenL1f0L2f10L3Filtered17" not in self.complained:
        if not self.m2L3fL1DoubleMu10MuOpenL1f0L2f10L3Filtered17_branch and "m2L3fL1DoubleMu10MuOpenL1f0L2f10L3Filtered17":
            warnings.warn( "EMuMuMuTree: Expected branch m2L3fL1DoubleMu10MuOpenL1f0L2f10L3Filtered17 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2L3fL1DoubleMu10MuOpenL1f0L2f10L3Filtered17")
        else:
            self.m2L3fL1DoubleMu10MuOpenL1f0L2f10L3Filtered17_branch.SetAddress(<void*>&self.m2L3fL1DoubleMu10MuOpenL1f0L2f10L3Filtered17_value)

        #print "making m2Mass"
        self.m2Mass_branch = the_tree.GetBranch("m2Mass")
        #if not self.m2Mass_branch and "m2Mass" not in self.complained:
        if not self.m2Mass_branch and "m2Mass":
            warnings.warn( "EMuMuMuTree: Expected branch m2Mass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2Mass")
        else:
            self.m2Mass_branch.SetAddress(<void*>&self.m2Mass_value)

        #print "making m2MatchedStations"
        self.m2MatchedStations_branch = the_tree.GetBranch("m2MatchedStations")
        #if not self.m2MatchedStations_branch and "m2MatchedStations" not in self.complained:
        if not self.m2MatchedStations_branch and "m2MatchedStations":
            warnings.warn( "EMuMuMuTree: Expected branch m2MatchedStations does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2MatchedStations")
        else:
            self.m2MatchedStations_branch.SetAddress(<void*>&self.m2MatchedStations_value)

        #print "making m2MatchesDoubleMuPaths"
        self.m2MatchesDoubleMuPaths_branch = the_tree.GetBranch("m2MatchesDoubleMuPaths")
        #if not self.m2MatchesDoubleMuPaths_branch and "m2MatchesDoubleMuPaths" not in self.complained:
        if not self.m2MatchesDoubleMuPaths_branch and "m2MatchesDoubleMuPaths":
            warnings.warn( "EMuMuMuTree: Expected branch m2MatchesDoubleMuPaths does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2MatchesDoubleMuPaths")
        else:
            self.m2MatchesDoubleMuPaths_branch.SetAddress(<void*>&self.m2MatchesDoubleMuPaths_value)

        #print "making m2MatchesDoubleMuTrkPaths"
        self.m2MatchesDoubleMuTrkPaths_branch = the_tree.GetBranch("m2MatchesDoubleMuTrkPaths")
        #if not self.m2MatchesDoubleMuTrkPaths_branch and "m2MatchesDoubleMuTrkPaths" not in self.complained:
        if not self.m2MatchesDoubleMuTrkPaths_branch and "m2MatchesDoubleMuTrkPaths":
            warnings.warn( "EMuMuMuTree: Expected branch m2MatchesDoubleMuTrkPaths does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2MatchesDoubleMuTrkPaths")
        else:
            self.m2MatchesDoubleMuTrkPaths_branch.SetAddress(<void*>&self.m2MatchesDoubleMuTrkPaths_value)

        #print "making m2MatchesIsoMu24eta2p1"
        self.m2MatchesIsoMu24eta2p1_branch = the_tree.GetBranch("m2MatchesIsoMu24eta2p1")
        #if not self.m2MatchesIsoMu24eta2p1_branch and "m2MatchesIsoMu24eta2p1" not in self.complained:
        if not self.m2MatchesIsoMu24eta2p1_branch and "m2MatchesIsoMu24eta2p1":
            warnings.warn( "EMuMuMuTree: Expected branch m2MatchesIsoMu24eta2p1 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2MatchesIsoMu24eta2p1")
        else:
            self.m2MatchesIsoMu24eta2p1_branch.SetAddress(<void*>&self.m2MatchesIsoMu24eta2p1_value)

        #print "making m2MatchesIsoMuGroup"
        self.m2MatchesIsoMuGroup_branch = the_tree.GetBranch("m2MatchesIsoMuGroup")
        #if not self.m2MatchesIsoMuGroup_branch and "m2MatchesIsoMuGroup" not in self.complained:
        if not self.m2MatchesIsoMuGroup_branch and "m2MatchesIsoMuGroup":
            warnings.warn( "EMuMuMuTree: Expected branch m2MatchesIsoMuGroup does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2MatchesIsoMuGroup")
        else:
            self.m2MatchesIsoMuGroup_branch.SetAddress(<void*>&self.m2MatchesIsoMuGroup_value)

        #print "making m2MatchesMu17Ele8IsoPath"
        self.m2MatchesMu17Ele8IsoPath_branch = the_tree.GetBranch("m2MatchesMu17Ele8IsoPath")
        #if not self.m2MatchesMu17Ele8IsoPath_branch and "m2MatchesMu17Ele8IsoPath" not in self.complained:
        if not self.m2MatchesMu17Ele8IsoPath_branch and "m2MatchesMu17Ele8IsoPath":
            warnings.warn( "EMuMuMuTree: Expected branch m2MatchesMu17Ele8IsoPath does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2MatchesMu17Ele8IsoPath")
        else:
            self.m2MatchesMu17Ele8IsoPath_branch.SetAddress(<void*>&self.m2MatchesMu17Ele8IsoPath_value)

        #print "making m2MatchesMu17Ele8Path"
        self.m2MatchesMu17Ele8Path_branch = the_tree.GetBranch("m2MatchesMu17Ele8Path")
        #if not self.m2MatchesMu17Ele8Path_branch and "m2MatchesMu17Ele8Path" not in self.complained:
        if not self.m2MatchesMu17Ele8Path_branch and "m2MatchesMu17Ele8Path":
            warnings.warn( "EMuMuMuTree: Expected branch m2MatchesMu17Ele8Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2MatchesMu17Ele8Path")
        else:
            self.m2MatchesMu17Ele8Path_branch.SetAddress(<void*>&self.m2MatchesMu17Ele8Path_value)

        #print "making m2MatchesMu17Mu8Path"
        self.m2MatchesMu17Mu8Path_branch = the_tree.GetBranch("m2MatchesMu17Mu8Path")
        #if not self.m2MatchesMu17Mu8Path_branch and "m2MatchesMu17Mu8Path" not in self.complained:
        if not self.m2MatchesMu17Mu8Path_branch and "m2MatchesMu17Mu8Path":
            warnings.warn( "EMuMuMuTree: Expected branch m2MatchesMu17Mu8Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2MatchesMu17Mu8Path")
        else:
            self.m2MatchesMu17Mu8Path_branch.SetAddress(<void*>&self.m2MatchesMu17Mu8Path_value)

        #print "making m2MatchesMu17TrkMu8Path"
        self.m2MatchesMu17TrkMu8Path_branch = the_tree.GetBranch("m2MatchesMu17TrkMu8Path")
        #if not self.m2MatchesMu17TrkMu8Path_branch and "m2MatchesMu17TrkMu8Path" not in self.complained:
        if not self.m2MatchesMu17TrkMu8Path_branch and "m2MatchesMu17TrkMu8Path":
            warnings.warn( "EMuMuMuTree: Expected branch m2MatchesMu17TrkMu8Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2MatchesMu17TrkMu8Path")
        else:
            self.m2MatchesMu17TrkMu8Path_branch.SetAddress(<void*>&self.m2MatchesMu17TrkMu8Path_value)

        #print "making m2MatchesMu8Ele17IsoPath"
        self.m2MatchesMu8Ele17IsoPath_branch = the_tree.GetBranch("m2MatchesMu8Ele17IsoPath")
        #if not self.m2MatchesMu8Ele17IsoPath_branch and "m2MatchesMu8Ele17IsoPath" not in self.complained:
        if not self.m2MatchesMu8Ele17IsoPath_branch and "m2MatchesMu8Ele17IsoPath":
            warnings.warn( "EMuMuMuTree: Expected branch m2MatchesMu8Ele17IsoPath does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2MatchesMu8Ele17IsoPath")
        else:
            self.m2MatchesMu8Ele17IsoPath_branch.SetAddress(<void*>&self.m2MatchesMu8Ele17IsoPath_value)

        #print "making m2MatchesMu8Ele17Path"
        self.m2MatchesMu8Ele17Path_branch = the_tree.GetBranch("m2MatchesMu8Ele17Path")
        #if not self.m2MatchesMu8Ele17Path_branch and "m2MatchesMu8Ele17Path" not in self.complained:
        if not self.m2MatchesMu8Ele17Path_branch and "m2MatchesMu8Ele17Path":
            warnings.warn( "EMuMuMuTree: Expected branch m2MatchesMu8Ele17Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2MatchesMu8Ele17Path")
        else:
            self.m2MatchesMu8Ele17Path_branch.SetAddress(<void*>&self.m2MatchesMu8Ele17Path_value)

        #print "making m2MtToMET"
        self.m2MtToMET_branch = the_tree.GetBranch("m2MtToMET")
        #if not self.m2MtToMET_branch and "m2MtToMET" not in self.complained:
        if not self.m2MtToMET_branch and "m2MtToMET":
            warnings.warn( "EMuMuMuTree: Expected branch m2MtToMET does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2MtToMET")
        else:
            self.m2MtToMET_branch.SetAddress(<void*>&self.m2MtToMET_value)

        #print "making m2MtToMVAMET"
        self.m2MtToMVAMET_branch = the_tree.GetBranch("m2MtToMVAMET")
        #if not self.m2MtToMVAMET_branch and "m2MtToMVAMET" not in self.complained:
        if not self.m2MtToMVAMET_branch and "m2MtToMVAMET":
            warnings.warn( "EMuMuMuTree: Expected branch m2MtToMVAMET does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2MtToMVAMET")
        else:
            self.m2MtToMVAMET_branch.SetAddress(<void*>&self.m2MtToMVAMET_value)

        #print "making m2MtToPFMET"
        self.m2MtToPFMET_branch = the_tree.GetBranch("m2MtToPFMET")
        #if not self.m2MtToPFMET_branch and "m2MtToPFMET" not in self.complained:
        if not self.m2MtToPFMET_branch and "m2MtToPFMET":
            warnings.warn( "EMuMuMuTree: Expected branch m2MtToPFMET does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2MtToPFMET")
        else:
            self.m2MtToPFMET_branch.SetAddress(<void*>&self.m2MtToPFMET_value)

        #print "making m2MtToPfMet_Ty1"
        self.m2MtToPfMet_Ty1_branch = the_tree.GetBranch("m2MtToPfMet_Ty1")
        #if not self.m2MtToPfMet_Ty1_branch and "m2MtToPfMet_Ty1" not in self.complained:
        if not self.m2MtToPfMet_Ty1_branch and "m2MtToPfMet_Ty1":
            warnings.warn( "EMuMuMuTree: Expected branch m2MtToPfMet_Ty1 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2MtToPfMet_Ty1")
        else:
            self.m2MtToPfMet_Ty1_branch.SetAddress(<void*>&self.m2MtToPfMet_Ty1_value)

        #print "making m2MtToPfMet_jes"
        self.m2MtToPfMet_jes_branch = the_tree.GetBranch("m2MtToPfMet_jes")
        #if not self.m2MtToPfMet_jes_branch and "m2MtToPfMet_jes" not in self.complained:
        if not self.m2MtToPfMet_jes_branch and "m2MtToPfMet_jes":
            warnings.warn( "EMuMuMuTree: Expected branch m2MtToPfMet_jes does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2MtToPfMet_jes")
        else:
            self.m2MtToPfMet_jes_branch.SetAddress(<void*>&self.m2MtToPfMet_jes_value)

        #print "making m2MtToPfMet_mes"
        self.m2MtToPfMet_mes_branch = the_tree.GetBranch("m2MtToPfMet_mes")
        #if not self.m2MtToPfMet_mes_branch and "m2MtToPfMet_mes" not in self.complained:
        if not self.m2MtToPfMet_mes_branch and "m2MtToPfMet_mes":
            warnings.warn( "EMuMuMuTree: Expected branch m2MtToPfMet_mes does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2MtToPfMet_mes")
        else:
            self.m2MtToPfMet_mes_branch.SetAddress(<void*>&self.m2MtToPfMet_mes_value)

        #print "making m2MtToPfMet_tes"
        self.m2MtToPfMet_tes_branch = the_tree.GetBranch("m2MtToPfMet_tes")
        #if not self.m2MtToPfMet_tes_branch and "m2MtToPfMet_tes" not in self.complained:
        if not self.m2MtToPfMet_tes_branch and "m2MtToPfMet_tes":
            warnings.warn( "EMuMuMuTree: Expected branch m2MtToPfMet_tes does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2MtToPfMet_tes")
        else:
            self.m2MtToPfMet_tes_branch.SetAddress(<void*>&self.m2MtToPfMet_tes_value)

        #print "making m2MtToPfMet_ues"
        self.m2MtToPfMet_ues_branch = the_tree.GetBranch("m2MtToPfMet_ues")
        #if not self.m2MtToPfMet_ues_branch and "m2MtToPfMet_ues" not in self.complained:
        if not self.m2MtToPfMet_ues_branch and "m2MtToPfMet_ues":
            warnings.warn( "EMuMuMuTree: Expected branch m2MtToPfMet_ues does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2MtToPfMet_ues")
        else:
            self.m2MtToPfMet_ues_branch.SetAddress(<void*>&self.m2MtToPfMet_ues_value)

        #print "making m2Mu17Ele8dZFilter"
        self.m2Mu17Ele8dZFilter_branch = the_tree.GetBranch("m2Mu17Ele8dZFilter")
        #if not self.m2Mu17Ele8dZFilter_branch and "m2Mu17Ele8dZFilter" not in self.complained:
        if not self.m2Mu17Ele8dZFilter_branch and "m2Mu17Ele8dZFilter":
            warnings.warn( "EMuMuMuTree: Expected branch m2Mu17Ele8dZFilter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2Mu17Ele8dZFilter")
        else:
            self.m2Mu17Ele8dZFilter_branch.SetAddress(<void*>&self.m2Mu17Ele8dZFilter_value)

        #print "making m2MuonHits"
        self.m2MuonHits_branch = the_tree.GetBranch("m2MuonHits")
        #if not self.m2MuonHits_branch and "m2MuonHits" not in self.complained:
        if not self.m2MuonHits_branch and "m2MuonHits":
            warnings.warn( "EMuMuMuTree: Expected branch m2MuonHits does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2MuonHits")
        else:
            self.m2MuonHits_branch.SetAddress(<void*>&self.m2MuonHits_value)

        #print "making m2NormTrkChi2"
        self.m2NormTrkChi2_branch = the_tree.GetBranch("m2NormTrkChi2")
        #if not self.m2NormTrkChi2_branch and "m2NormTrkChi2" not in self.complained:
        if not self.m2NormTrkChi2_branch and "m2NormTrkChi2":
            warnings.warn( "EMuMuMuTree: Expected branch m2NormTrkChi2 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2NormTrkChi2")
        else:
            self.m2NormTrkChi2_branch.SetAddress(<void*>&self.m2NormTrkChi2_value)

        #print "making m2PFChargedIso"
        self.m2PFChargedIso_branch = the_tree.GetBranch("m2PFChargedIso")
        #if not self.m2PFChargedIso_branch and "m2PFChargedIso" not in self.complained:
        if not self.m2PFChargedIso_branch and "m2PFChargedIso":
            warnings.warn( "EMuMuMuTree: Expected branch m2PFChargedIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2PFChargedIso")
        else:
            self.m2PFChargedIso_branch.SetAddress(<void*>&self.m2PFChargedIso_value)

        #print "making m2PFIDTight"
        self.m2PFIDTight_branch = the_tree.GetBranch("m2PFIDTight")
        #if not self.m2PFIDTight_branch and "m2PFIDTight" not in self.complained:
        if not self.m2PFIDTight_branch and "m2PFIDTight":
            warnings.warn( "EMuMuMuTree: Expected branch m2PFIDTight does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2PFIDTight")
        else:
            self.m2PFIDTight_branch.SetAddress(<void*>&self.m2PFIDTight_value)

        #print "making m2PFNeutralIso"
        self.m2PFNeutralIso_branch = the_tree.GetBranch("m2PFNeutralIso")
        #if not self.m2PFNeutralIso_branch and "m2PFNeutralIso" not in self.complained:
        if not self.m2PFNeutralIso_branch and "m2PFNeutralIso":
            warnings.warn( "EMuMuMuTree: Expected branch m2PFNeutralIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2PFNeutralIso")
        else:
            self.m2PFNeutralIso_branch.SetAddress(<void*>&self.m2PFNeutralIso_value)

        #print "making m2PFPUChargedIso"
        self.m2PFPUChargedIso_branch = the_tree.GetBranch("m2PFPUChargedIso")
        #if not self.m2PFPUChargedIso_branch and "m2PFPUChargedIso" not in self.complained:
        if not self.m2PFPUChargedIso_branch and "m2PFPUChargedIso":
            warnings.warn( "EMuMuMuTree: Expected branch m2PFPUChargedIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2PFPUChargedIso")
        else:
            self.m2PFPUChargedIso_branch.SetAddress(<void*>&self.m2PFPUChargedIso_value)

        #print "making m2PFPhotonIso"
        self.m2PFPhotonIso_branch = the_tree.GetBranch("m2PFPhotonIso")
        #if not self.m2PFPhotonIso_branch and "m2PFPhotonIso" not in self.complained:
        if not self.m2PFPhotonIso_branch and "m2PFPhotonIso":
            warnings.warn( "EMuMuMuTree: Expected branch m2PFPhotonIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2PFPhotonIso")
        else:
            self.m2PFPhotonIso_branch.SetAddress(<void*>&self.m2PFPhotonIso_value)

        #print "making m2PVDXY"
        self.m2PVDXY_branch = the_tree.GetBranch("m2PVDXY")
        #if not self.m2PVDXY_branch and "m2PVDXY" not in self.complained:
        if not self.m2PVDXY_branch and "m2PVDXY":
            warnings.warn( "EMuMuMuTree: Expected branch m2PVDXY does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2PVDXY")
        else:
            self.m2PVDXY_branch.SetAddress(<void*>&self.m2PVDXY_value)

        #print "making m2PVDZ"
        self.m2PVDZ_branch = the_tree.GetBranch("m2PVDZ")
        #if not self.m2PVDZ_branch and "m2PVDZ" not in self.complained:
        if not self.m2PVDZ_branch and "m2PVDZ":
            warnings.warn( "EMuMuMuTree: Expected branch m2PVDZ does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2PVDZ")
        else:
            self.m2PVDZ_branch.SetAddress(<void*>&self.m2PVDZ_value)

        #print "making m2Phi"
        self.m2Phi_branch = the_tree.GetBranch("m2Phi")
        #if not self.m2Phi_branch and "m2Phi" not in self.complained:
        if not self.m2Phi_branch and "m2Phi":
            warnings.warn( "EMuMuMuTree: Expected branch m2Phi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2Phi")
        else:
            self.m2Phi_branch.SetAddress(<void*>&self.m2Phi_value)

        #print "making m2PhiRochCor2011A"
        self.m2PhiRochCor2011A_branch = the_tree.GetBranch("m2PhiRochCor2011A")
        #if not self.m2PhiRochCor2011A_branch and "m2PhiRochCor2011A" not in self.complained:
        if not self.m2PhiRochCor2011A_branch and "m2PhiRochCor2011A":
            warnings.warn( "EMuMuMuTree: Expected branch m2PhiRochCor2011A does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2PhiRochCor2011A")
        else:
            self.m2PhiRochCor2011A_branch.SetAddress(<void*>&self.m2PhiRochCor2011A_value)

        #print "making m2PhiRochCor2011B"
        self.m2PhiRochCor2011B_branch = the_tree.GetBranch("m2PhiRochCor2011B")
        #if not self.m2PhiRochCor2011B_branch and "m2PhiRochCor2011B" not in self.complained:
        if not self.m2PhiRochCor2011B_branch and "m2PhiRochCor2011B":
            warnings.warn( "EMuMuMuTree: Expected branch m2PhiRochCor2011B does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2PhiRochCor2011B")
        else:
            self.m2PhiRochCor2011B_branch.SetAddress(<void*>&self.m2PhiRochCor2011B_value)

        #print "making m2PhiRochCor2012"
        self.m2PhiRochCor2012_branch = the_tree.GetBranch("m2PhiRochCor2012")
        #if not self.m2PhiRochCor2012_branch and "m2PhiRochCor2012" not in self.complained:
        if not self.m2PhiRochCor2012_branch and "m2PhiRochCor2012":
            warnings.warn( "EMuMuMuTree: Expected branch m2PhiRochCor2012 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2PhiRochCor2012")
        else:
            self.m2PhiRochCor2012_branch.SetAddress(<void*>&self.m2PhiRochCor2012_value)

        #print "making m2PixHits"
        self.m2PixHits_branch = the_tree.GetBranch("m2PixHits")
        #if not self.m2PixHits_branch and "m2PixHits" not in self.complained:
        if not self.m2PixHits_branch and "m2PixHits":
            warnings.warn( "EMuMuMuTree: Expected branch m2PixHits does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2PixHits")
        else:
            self.m2PixHits_branch.SetAddress(<void*>&self.m2PixHits_value)

        #print "making m2Pt"
        self.m2Pt_branch = the_tree.GetBranch("m2Pt")
        #if not self.m2Pt_branch and "m2Pt" not in self.complained:
        if not self.m2Pt_branch and "m2Pt":
            warnings.warn( "EMuMuMuTree: Expected branch m2Pt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2Pt")
        else:
            self.m2Pt_branch.SetAddress(<void*>&self.m2Pt_value)

        #print "making m2PtRochCor2011A"
        self.m2PtRochCor2011A_branch = the_tree.GetBranch("m2PtRochCor2011A")
        #if not self.m2PtRochCor2011A_branch and "m2PtRochCor2011A" not in self.complained:
        if not self.m2PtRochCor2011A_branch and "m2PtRochCor2011A":
            warnings.warn( "EMuMuMuTree: Expected branch m2PtRochCor2011A does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2PtRochCor2011A")
        else:
            self.m2PtRochCor2011A_branch.SetAddress(<void*>&self.m2PtRochCor2011A_value)

        #print "making m2PtRochCor2011B"
        self.m2PtRochCor2011B_branch = the_tree.GetBranch("m2PtRochCor2011B")
        #if not self.m2PtRochCor2011B_branch and "m2PtRochCor2011B" not in self.complained:
        if not self.m2PtRochCor2011B_branch and "m2PtRochCor2011B":
            warnings.warn( "EMuMuMuTree: Expected branch m2PtRochCor2011B does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2PtRochCor2011B")
        else:
            self.m2PtRochCor2011B_branch.SetAddress(<void*>&self.m2PtRochCor2011B_value)

        #print "making m2PtRochCor2012"
        self.m2PtRochCor2012_branch = the_tree.GetBranch("m2PtRochCor2012")
        #if not self.m2PtRochCor2012_branch and "m2PtRochCor2012" not in self.complained:
        if not self.m2PtRochCor2012_branch and "m2PtRochCor2012":
            warnings.warn( "EMuMuMuTree: Expected branch m2PtRochCor2012 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2PtRochCor2012")
        else:
            self.m2PtRochCor2012_branch.SetAddress(<void*>&self.m2PtRochCor2012_value)

        #print "making m2Rank"
        self.m2Rank_branch = the_tree.GetBranch("m2Rank")
        #if not self.m2Rank_branch and "m2Rank" not in self.complained:
        if not self.m2Rank_branch and "m2Rank":
            warnings.warn( "EMuMuMuTree: Expected branch m2Rank does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2Rank")
        else:
            self.m2Rank_branch.SetAddress(<void*>&self.m2Rank_value)

        #print "making m2RelPFIsoDB"
        self.m2RelPFIsoDB_branch = the_tree.GetBranch("m2RelPFIsoDB")
        #if not self.m2RelPFIsoDB_branch and "m2RelPFIsoDB" not in self.complained:
        if not self.m2RelPFIsoDB_branch and "m2RelPFIsoDB":
            warnings.warn( "EMuMuMuTree: Expected branch m2RelPFIsoDB does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2RelPFIsoDB")
        else:
            self.m2RelPFIsoDB_branch.SetAddress(<void*>&self.m2RelPFIsoDB_value)

        #print "making m2RelPFIsoRho"
        self.m2RelPFIsoRho_branch = the_tree.GetBranch("m2RelPFIsoRho")
        #if not self.m2RelPFIsoRho_branch and "m2RelPFIsoRho" not in self.complained:
        if not self.m2RelPFIsoRho_branch and "m2RelPFIsoRho":
            warnings.warn( "EMuMuMuTree: Expected branch m2RelPFIsoRho does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2RelPFIsoRho")
        else:
            self.m2RelPFIsoRho_branch.SetAddress(<void*>&self.m2RelPFIsoRho_value)

        #print "making m2RelPFIsoRhoFSR"
        self.m2RelPFIsoRhoFSR_branch = the_tree.GetBranch("m2RelPFIsoRhoFSR")
        #if not self.m2RelPFIsoRhoFSR_branch and "m2RelPFIsoRhoFSR" not in self.complained:
        if not self.m2RelPFIsoRhoFSR_branch and "m2RelPFIsoRhoFSR":
            warnings.warn( "EMuMuMuTree: Expected branch m2RelPFIsoRhoFSR does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2RelPFIsoRhoFSR")
        else:
            self.m2RelPFIsoRhoFSR_branch.SetAddress(<void*>&self.m2RelPFIsoRhoFSR_value)

        #print "making m2RhoHZG2011"
        self.m2RhoHZG2011_branch = the_tree.GetBranch("m2RhoHZG2011")
        #if not self.m2RhoHZG2011_branch and "m2RhoHZG2011" not in self.complained:
        if not self.m2RhoHZG2011_branch and "m2RhoHZG2011":
            warnings.warn( "EMuMuMuTree: Expected branch m2RhoHZG2011 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2RhoHZG2011")
        else:
            self.m2RhoHZG2011_branch.SetAddress(<void*>&self.m2RhoHZG2011_value)

        #print "making m2RhoHZG2012"
        self.m2RhoHZG2012_branch = the_tree.GetBranch("m2RhoHZG2012")
        #if not self.m2RhoHZG2012_branch and "m2RhoHZG2012" not in self.complained:
        if not self.m2RhoHZG2012_branch and "m2RhoHZG2012":
            warnings.warn( "EMuMuMuTree: Expected branch m2RhoHZG2012 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2RhoHZG2012")
        else:
            self.m2RhoHZG2012_branch.SetAddress(<void*>&self.m2RhoHZG2012_value)

        #print "making m2SingleMu13L3Filtered13"
        self.m2SingleMu13L3Filtered13_branch = the_tree.GetBranch("m2SingleMu13L3Filtered13")
        #if not self.m2SingleMu13L3Filtered13_branch and "m2SingleMu13L3Filtered13" not in self.complained:
        if not self.m2SingleMu13L3Filtered13_branch and "m2SingleMu13L3Filtered13":
            warnings.warn( "EMuMuMuTree: Expected branch m2SingleMu13L3Filtered13 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2SingleMu13L3Filtered13")
        else:
            self.m2SingleMu13L3Filtered13_branch.SetAddress(<void*>&self.m2SingleMu13L3Filtered13_value)

        #print "making m2SingleMu13L3Filtered17"
        self.m2SingleMu13L3Filtered17_branch = the_tree.GetBranch("m2SingleMu13L3Filtered17")
        #if not self.m2SingleMu13L3Filtered17_branch and "m2SingleMu13L3Filtered17" not in self.complained:
        if not self.m2SingleMu13L3Filtered17_branch and "m2SingleMu13L3Filtered17":
            warnings.warn( "EMuMuMuTree: Expected branch m2SingleMu13L3Filtered17 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2SingleMu13L3Filtered17")
        else:
            self.m2SingleMu13L3Filtered17_branch.SetAddress(<void*>&self.m2SingleMu13L3Filtered17_value)

        #print "making m2TkLayersWithMeasurement"
        self.m2TkLayersWithMeasurement_branch = the_tree.GetBranch("m2TkLayersWithMeasurement")
        #if not self.m2TkLayersWithMeasurement_branch and "m2TkLayersWithMeasurement" not in self.complained:
        if not self.m2TkLayersWithMeasurement_branch and "m2TkLayersWithMeasurement":
            warnings.warn( "EMuMuMuTree: Expected branch m2TkLayersWithMeasurement does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2TkLayersWithMeasurement")
        else:
            self.m2TkLayersWithMeasurement_branch.SetAddress(<void*>&self.m2TkLayersWithMeasurement_value)

        #print "making m2ToMETDPhi"
        self.m2ToMETDPhi_branch = the_tree.GetBranch("m2ToMETDPhi")
        #if not self.m2ToMETDPhi_branch and "m2ToMETDPhi" not in self.complained:
        if not self.m2ToMETDPhi_branch and "m2ToMETDPhi":
            warnings.warn( "EMuMuMuTree: Expected branch m2ToMETDPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2ToMETDPhi")
        else:
            self.m2ToMETDPhi_branch.SetAddress(<void*>&self.m2ToMETDPhi_value)

        #print "making m2TypeCode"
        self.m2TypeCode_branch = the_tree.GetBranch("m2TypeCode")
        #if not self.m2TypeCode_branch and "m2TypeCode" not in self.complained:
        if not self.m2TypeCode_branch and "m2TypeCode":
            warnings.warn( "EMuMuMuTree: Expected branch m2TypeCode does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2TypeCode")
        else:
            self.m2TypeCode_branch.SetAddress(<void*>&self.m2TypeCode_value)

        #print "making m2VBTFID"
        self.m2VBTFID_branch = the_tree.GetBranch("m2VBTFID")
        #if not self.m2VBTFID_branch and "m2VBTFID" not in self.complained:
        if not self.m2VBTFID_branch and "m2VBTFID":
            warnings.warn( "EMuMuMuTree: Expected branch m2VBTFID does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2VBTFID")
        else:
            self.m2VBTFID_branch.SetAddress(<void*>&self.m2VBTFID_value)

        #print "making m2VZ"
        self.m2VZ_branch = the_tree.GetBranch("m2VZ")
        #if not self.m2VZ_branch and "m2VZ" not in self.complained:
        if not self.m2VZ_branch and "m2VZ":
            warnings.warn( "EMuMuMuTree: Expected branch m2VZ does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2VZ")
        else:
            self.m2VZ_branch.SetAddress(<void*>&self.m2VZ_value)

        #print "making m2WWID"
        self.m2WWID_branch = the_tree.GetBranch("m2WWID")
        #if not self.m2WWID_branch and "m2WWID" not in self.complained:
        if not self.m2WWID_branch and "m2WWID":
            warnings.warn( "EMuMuMuTree: Expected branch m2WWID does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2WWID")
        else:
            self.m2WWID_branch.SetAddress(<void*>&self.m2WWID_value)

        #print "making m2_m3_CosThetaStar"
        self.m2_m3_CosThetaStar_branch = the_tree.GetBranch("m2_m3_CosThetaStar")
        #if not self.m2_m3_CosThetaStar_branch and "m2_m3_CosThetaStar" not in self.complained:
        if not self.m2_m3_CosThetaStar_branch and "m2_m3_CosThetaStar":
            warnings.warn( "EMuMuMuTree: Expected branch m2_m3_CosThetaStar does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2_m3_CosThetaStar")
        else:
            self.m2_m3_CosThetaStar_branch.SetAddress(<void*>&self.m2_m3_CosThetaStar_value)

        #print "making m2_m3_DPhi"
        self.m2_m3_DPhi_branch = the_tree.GetBranch("m2_m3_DPhi")
        #if not self.m2_m3_DPhi_branch and "m2_m3_DPhi" not in self.complained:
        if not self.m2_m3_DPhi_branch and "m2_m3_DPhi":
            warnings.warn( "EMuMuMuTree: Expected branch m2_m3_DPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2_m3_DPhi")
        else:
            self.m2_m3_DPhi_branch.SetAddress(<void*>&self.m2_m3_DPhi_value)

        #print "making m2_m3_DR"
        self.m2_m3_DR_branch = the_tree.GetBranch("m2_m3_DR")
        #if not self.m2_m3_DR_branch and "m2_m3_DR" not in self.complained:
        if not self.m2_m3_DR_branch and "m2_m3_DR":
            warnings.warn( "EMuMuMuTree: Expected branch m2_m3_DR does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2_m3_DR")
        else:
            self.m2_m3_DR_branch.SetAddress(<void*>&self.m2_m3_DR_value)

        #print "making m2_m3_Eta"
        self.m2_m3_Eta_branch = the_tree.GetBranch("m2_m3_Eta")
        #if not self.m2_m3_Eta_branch and "m2_m3_Eta" not in self.complained:
        if not self.m2_m3_Eta_branch and "m2_m3_Eta":
            warnings.warn( "EMuMuMuTree: Expected branch m2_m3_Eta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2_m3_Eta")
        else:
            self.m2_m3_Eta_branch.SetAddress(<void*>&self.m2_m3_Eta_value)

        #print "making m2_m3_Mass"
        self.m2_m3_Mass_branch = the_tree.GetBranch("m2_m3_Mass")
        #if not self.m2_m3_Mass_branch and "m2_m3_Mass" not in self.complained:
        if not self.m2_m3_Mass_branch and "m2_m3_Mass":
            warnings.warn( "EMuMuMuTree: Expected branch m2_m3_Mass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2_m3_Mass")
        else:
            self.m2_m3_Mass_branch.SetAddress(<void*>&self.m2_m3_Mass_value)

        #print "making m2_m3_MassFsr"
        self.m2_m3_MassFsr_branch = the_tree.GetBranch("m2_m3_MassFsr")
        #if not self.m2_m3_MassFsr_branch and "m2_m3_MassFsr" not in self.complained:
        if not self.m2_m3_MassFsr_branch and "m2_m3_MassFsr":
            warnings.warn( "EMuMuMuTree: Expected branch m2_m3_MassFsr does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2_m3_MassFsr")
        else:
            self.m2_m3_MassFsr_branch.SetAddress(<void*>&self.m2_m3_MassFsr_value)

        #print "making m2_m3_PZeta"
        self.m2_m3_PZeta_branch = the_tree.GetBranch("m2_m3_PZeta")
        #if not self.m2_m3_PZeta_branch and "m2_m3_PZeta" not in self.complained:
        if not self.m2_m3_PZeta_branch and "m2_m3_PZeta":
            warnings.warn( "EMuMuMuTree: Expected branch m2_m3_PZeta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2_m3_PZeta")
        else:
            self.m2_m3_PZeta_branch.SetAddress(<void*>&self.m2_m3_PZeta_value)

        #print "making m2_m3_PZetaVis"
        self.m2_m3_PZetaVis_branch = the_tree.GetBranch("m2_m3_PZetaVis")
        #if not self.m2_m3_PZetaVis_branch and "m2_m3_PZetaVis" not in self.complained:
        if not self.m2_m3_PZetaVis_branch and "m2_m3_PZetaVis":
            warnings.warn( "EMuMuMuTree: Expected branch m2_m3_PZetaVis does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2_m3_PZetaVis")
        else:
            self.m2_m3_PZetaVis_branch.SetAddress(<void*>&self.m2_m3_PZetaVis_value)

        #print "making m2_m3_Phi"
        self.m2_m3_Phi_branch = the_tree.GetBranch("m2_m3_Phi")
        #if not self.m2_m3_Phi_branch and "m2_m3_Phi" not in self.complained:
        if not self.m2_m3_Phi_branch and "m2_m3_Phi":
            warnings.warn( "EMuMuMuTree: Expected branch m2_m3_Phi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2_m3_Phi")
        else:
            self.m2_m3_Phi_branch.SetAddress(<void*>&self.m2_m3_Phi_value)

        #print "making m2_m3_Pt"
        self.m2_m3_Pt_branch = the_tree.GetBranch("m2_m3_Pt")
        #if not self.m2_m3_Pt_branch and "m2_m3_Pt" not in self.complained:
        if not self.m2_m3_Pt_branch and "m2_m3_Pt":
            warnings.warn( "EMuMuMuTree: Expected branch m2_m3_Pt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2_m3_Pt")
        else:
            self.m2_m3_Pt_branch.SetAddress(<void*>&self.m2_m3_Pt_value)

        #print "making m2_m3_PtFsr"
        self.m2_m3_PtFsr_branch = the_tree.GetBranch("m2_m3_PtFsr")
        #if not self.m2_m3_PtFsr_branch and "m2_m3_PtFsr" not in self.complained:
        if not self.m2_m3_PtFsr_branch and "m2_m3_PtFsr":
            warnings.warn( "EMuMuMuTree: Expected branch m2_m3_PtFsr does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2_m3_PtFsr")
        else:
            self.m2_m3_PtFsr_branch.SetAddress(<void*>&self.m2_m3_PtFsr_value)

        #print "making m2_m3_SS"
        self.m2_m3_SS_branch = the_tree.GetBranch("m2_m3_SS")
        #if not self.m2_m3_SS_branch and "m2_m3_SS" not in self.complained:
        if not self.m2_m3_SS_branch and "m2_m3_SS":
            warnings.warn( "EMuMuMuTree: Expected branch m2_m3_SS does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2_m3_SS")
        else:
            self.m2_m3_SS_branch.SetAddress(<void*>&self.m2_m3_SS_value)

        #print "making m2_m3_ToMETDPhi_Ty1"
        self.m2_m3_ToMETDPhi_Ty1_branch = the_tree.GetBranch("m2_m3_ToMETDPhi_Ty1")
        #if not self.m2_m3_ToMETDPhi_Ty1_branch and "m2_m3_ToMETDPhi_Ty1" not in self.complained:
        if not self.m2_m3_ToMETDPhi_Ty1_branch and "m2_m3_ToMETDPhi_Ty1":
            warnings.warn( "EMuMuMuTree: Expected branch m2_m3_ToMETDPhi_Ty1 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2_m3_ToMETDPhi_Ty1")
        else:
            self.m2_m3_ToMETDPhi_Ty1_branch.SetAddress(<void*>&self.m2_m3_ToMETDPhi_Ty1_value)

        #print "making m2_m3_Zcompat"
        self.m2_m3_Zcompat_branch = the_tree.GetBranch("m2_m3_Zcompat")
        #if not self.m2_m3_Zcompat_branch and "m2_m3_Zcompat" not in self.complained:
        if not self.m2_m3_Zcompat_branch and "m2_m3_Zcompat":
            warnings.warn( "EMuMuMuTree: Expected branch m2_m3_Zcompat does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2_m3_Zcompat")
        else:
            self.m2_m3_Zcompat_branch.SetAddress(<void*>&self.m2_m3_Zcompat_value)

        #print "making m3AbsEta"
        self.m3AbsEta_branch = the_tree.GetBranch("m3AbsEta")
        #if not self.m3AbsEta_branch and "m3AbsEta" not in self.complained:
        if not self.m3AbsEta_branch and "m3AbsEta":
            warnings.warn( "EMuMuMuTree: Expected branch m3AbsEta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3AbsEta")
        else:
            self.m3AbsEta_branch.SetAddress(<void*>&self.m3AbsEta_value)

        #print "making m3Charge"
        self.m3Charge_branch = the_tree.GetBranch("m3Charge")
        #if not self.m3Charge_branch and "m3Charge" not in self.complained:
        if not self.m3Charge_branch and "m3Charge":
            warnings.warn( "EMuMuMuTree: Expected branch m3Charge does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3Charge")
        else:
            self.m3Charge_branch.SetAddress(<void*>&self.m3Charge_value)

        #print "making m3ComesFromHiggs"
        self.m3ComesFromHiggs_branch = the_tree.GetBranch("m3ComesFromHiggs")
        #if not self.m3ComesFromHiggs_branch and "m3ComesFromHiggs" not in self.complained:
        if not self.m3ComesFromHiggs_branch and "m3ComesFromHiggs":
            warnings.warn( "EMuMuMuTree: Expected branch m3ComesFromHiggs does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3ComesFromHiggs")
        else:
            self.m3ComesFromHiggs_branch.SetAddress(<void*>&self.m3ComesFromHiggs_value)

        #print "making m3D0"
        self.m3D0_branch = the_tree.GetBranch("m3D0")
        #if not self.m3D0_branch and "m3D0" not in self.complained:
        if not self.m3D0_branch and "m3D0":
            warnings.warn( "EMuMuMuTree: Expected branch m3D0 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3D0")
        else:
            self.m3D0_branch.SetAddress(<void*>&self.m3D0_value)

        #print "making m3DZ"
        self.m3DZ_branch = the_tree.GetBranch("m3DZ")
        #if not self.m3DZ_branch and "m3DZ" not in self.complained:
        if not self.m3DZ_branch and "m3DZ":
            warnings.warn( "EMuMuMuTree: Expected branch m3DZ does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3DZ")
        else:
            self.m3DZ_branch.SetAddress(<void*>&self.m3DZ_value)

        #print "making m3DiMuonL3PreFiltered7"
        self.m3DiMuonL3PreFiltered7_branch = the_tree.GetBranch("m3DiMuonL3PreFiltered7")
        #if not self.m3DiMuonL3PreFiltered7_branch and "m3DiMuonL3PreFiltered7" not in self.complained:
        if not self.m3DiMuonL3PreFiltered7_branch and "m3DiMuonL3PreFiltered7":
            warnings.warn( "EMuMuMuTree: Expected branch m3DiMuonL3PreFiltered7 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3DiMuonL3PreFiltered7")
        else:
            self.m3DiMuonL3PreFiltered7_branch.SetAddress(<void*>&self.m3DiMuonL3PreFiltered7_value)

        #print "making m3DiMuonL3p5PreFiltered8"
        self.m3DiMuonL3p5PreFiltered8_branch = the_tree.GetBranch("m3DiMuonL3p5PreFiltered8")
        #if not self.m3DiMuonL3p5PreFiltered8_branch and "m3DiMuonL3p5PreFiltered8" not in self.complained:
        if not self.m3DiMuonL3p5PreFiltered8_branch and "m3DiMuonL3p5PreFiltered8":
            warnings.warn( "EMuMuMuTree: Expected branch m3DiMuonL3p5PreFiltered8 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3DiMuonL3p5PreFiltered8")
        else:
            self.m3DiMuonL3p5PreFiltered8_branch.SetAddress(<void*>&self.m3DiMuonL3p5PreFiltered8_value)

        #print "making m3DiMuonMu17Mu8DzFiltered0p2"
        self.m3DiMuonMu17Mu8DzFiltered0p2_branch = the_tree.GetBranch("m3DiMuonMu17Mu8DzFiltered0p2")
        #if not self.m3DiMuonMu17Mu8DzFiltered0p2_branch and "m3DiMuonMu17Mu8DzFiltered0p2" not in self.complained:
        if not self.m3DiMuonMu17Mu8DzFiltered0p2_branch and "m3DiMuonMu17Mu8DzFiltered0p2":
            warnings.warn( "EMuMuMuTree: Expected branch m3DiMuonMu17Mu8DzFiltered0p2 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3DiMuonMu17Mu8DzFiltered0p2")
        else:
            self.m3DiMuonMu17Mu8DzFiltered0p2_branch.SetAddress(<void*>&self.m3DiMuonMu17Mu8DzFiltered0p2_value)

        #print "making m3EErrRochCor2011A"
        self.m3EErrRochCor2011A_branch = the_tree.GetBranch("m3EErrRochCor2011A")
        #if not self.m3EErrRochCor2011A_branch and "m3EErrRochCor2011A" not in self.complained:
        if not self.m3EErrRochCor2011A_branch and "m3EErrRochCor2011A":
            warnings.warn( "EMuMuMuTree: Expected branch m3EErrRochCor2011A does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3EErrRochCor2011A")
        else:
            self.m3EErrRochCor2011A_branch.SetAddress(<void*>&self.m3EErrRochCor2011A_value)

        #print "making m3EErrRochCor2011B"
        self.m3EErrRochCor2011B_branch = the_tree.GetBranch("m3EErrRochCor2011B")
        #if not self.m3EErrRochCor2011B_branch and "m3EErrRochCor2011B" not in self.complained:
        if not self.m3EErrRochCor2011B_branch and "m3EErrRochCor2011B":
            warnings.warn( "EMuMuMuTree: Expected branch m3EErrRochCor2011B does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3EErrRochCor2011B")
        else:
            self.m3EErrRochCor2011B_branch.SetAddress(<void*>&self.m3EErrRochCor2011B_value)

        #print "making m3EErrRochCor2012"
        self.m3EErrRochCor2012_branch = the_tree.GetBranch("m3EErrRochCor2012")
        #if not self.m3EErrRochCor2012_branch and "m3EErrRochCor2012" not in self.complained:
        if not self.m3EErrRochCor2012_branch and "m3EErrRochCor2012":
            warnings.warn( "EMuMuMuTree: Expected branch m3EErrRochCor2012 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3EErrRochCor2012")
        else:
            self.m3EErrRochCor2012_branch.SetAddress(<void*>&self.m3EErrRochCor2012_value)

        #print "making m3ERochCor2011A"
        self.m3ERochCor2011A_branch = the_tree.GetBranch("m3ERochCor2011A")
        #if not self.m3ERochCor2011A_branch and "m3ERochCor2011A" not in self.complained:
        if not self.m3ERochCor2011A_branch and "m3ERochCor2011A":
            warnings.warn( "EMuMuMuTree: Expected branch m3ERochCor2011A does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3ERochCor2011A")
        else:
            self.m3ERochCor2011A_branch.SetAddress(<void*>&self.m3ERochCor2011A_value)

        #print "making m3ERochCor2011B"
        self.m3ERochCor2011B_branch = the_tree.GetBranch("m3ERochCor2011B")
        #if not self.m3ERochCor2011B_branch and "m3ERochCor2011B" not in self.complained:
        if not self.m3ERochCor2011B_branch and "m3ERochCor2011B":
            warnings.warn( "EMuMuMuTree: Expected branch m3ERochCor2011B does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3ERochCor2011B")
        else:
            self.m3ERochCor2011B_branch.SetAddress(<void*>&self.m3ERochCor2011B_value)

        #print "making m3ERochCor2012"
        self.m3ERochCor2012_branch = the_tree.GetBranch("m3ERochCor2012")
        #if not self.m3ERochCor2012_branch and "m3ERochCor2012" not in self.complained:
        if not self.m3ERochCor2012_branch and "m3ERochCor2012":
            warnings.warn( "EMuMuMuTree: Expected branch m3ERochCor2012 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3ERochCor2012")
        else:
            self.m3ERochCor2012_branch.SetAddress(<void*>&self.m3ERochCor2012_value)

        #print "making m3EffectiveArea2011"
        self.m3EffectiveArea2011_branch = the_tree.GetBranch("m3EffectiveArea2011")
        #if not self.m3EffectiveArea2011_branch and "m3EffectiveArea2011" not in self.complained:
        if not self.m3EffectiveArea2011_branch and "m3EffectiveArea2011":
            warnings.warn( "EMuMuMuTree: Expected branch m3EffectiveArea2011 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3EffectiveArea2011")
        else:
            self.m3EffectiveArea2011_branch.SetAddress(<void*>&self.m3EffectiveArea2011_value)

        #print "making m3EffectiveArea2012"
        self.m3EffectiveArea2012_branch = the_tree.GetBranch("m3EffectiveArea2012")
        #if not self.m3EffectiveArea2012_branch and "m3EffectiveArea2012" not in self.complained:
        if not self.m3EffectiveArea2012_branch and "m3EffectiveArea2012":
            warnings.warn( "EMuMuMuTree: Expected branch m3EffectiveArea2012 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3EffectiveArea2012")
        else:
            self.m3EffectiveArea2012_branch.SetAddress(<void*>&self.m3EffectiveArea2012_value)

        #print "making m3Eta"
        self.m3Eta_branch = the_tree.GetBranch("m3Eta")
        #if not self.m3Eta_branch and "m3Eta" not in self.complained:
        if not self.m3Eta_branch and "m3Eta":
            warnings.warn( "EMuMuMuTree: Expected branch m3Eta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3Eta")
        else:
            self.m3Eta_branch.SetAddress(<void*>&self.m3Eta_value)

        #print "making m3EtaRochCor2011A"
        self.m3EtaRochCor2011A_branch = the_tree.GetBranch("m3EtaRochCor2011A")
        #if not self.m3EtaRochCor2011A_branch and "m3EtaRochCor2011A" not in self.complained:
        if not self.m3EtaRochCor2011A_branch and "m3EtaRochCor2011A":
            warnings.warn( "EMuMuMuTree: Expected branch m3EtaRochCor2011A does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3EtaRochCor2011A")
        else:
            self.m3EtaRochCor2011A_branch.SetAddress(<void*>&self.m3EtaRochCor2011A_value)

        #print "making m3EtaRochCor2011B"
        self.m3EtaRochCor2011B_branch = the_tree.GetBranch("m3EtaRochCor2011B")
        #if not self.m3EtaRochCor2011B_branch and "m3EtaRochCor2011B" not in self.complained:
        if not self.m3EtaRochCor2011B_branch and "m3EtaRochCor2011B":
            warnings.warn( "EMuMuMuTree: Expected branch m3EtaRochCor2011B does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3EtaRochCor2011B")
        else:
            self.m3EtaRochCor2011B_branch.SetAddress(<void*>&self.m3EtaRochCor2011B_value)

        #print "making m3EtaRochCor2012"
        self.m3EtaRochCor2012_branch = the_tree.GetBranch("m3EtaRochCor2012")
        #if not self.m3EtaRochCor2012_branch and "m3EtaRochCor2012" not in self.complained:
        if not self.m3EtaRochCor2012_branch and "m3EtaRochCor2012":
            warnings.warn( "EMuMuMuTree: Expected branch m3EtaRochCor2012 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3EtaRochCor2012")
        else:
            self.m3EtaRochCor2012_branch.SetAddress(<void*>&self.m3EtaRochCor2012_value)

        #print "making m3GenCharge"
        self.m3GenCharge_branch = the_tree.GetBranch("m3GenCharge")
        #if not self.m3GenCharge_branch and "m3GenCharge" not in self.complained:
        if not self.m3GenCharge_branch and "m3GenCharge":
            warnings.warn( "EMuMuMuTree: Expected branch m3GenCharge does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3GenCharge")
        else:
            self.m3GenCharge_branch.SetAddress(<void*>&self.m3GenCharge_value)

        #print "making m3GenEnergy"
        self.m3GenEnergy_branch = the_tree.GetBranch("m3GenEnergy")
        #if not self.m3GenEnergy_branch and "m3GenEnergy" not in self.complained:
        if not self.m3GenEnergy_branch and "m3GenEnergy":
            warnings.warn( "EMuMuMuTree: Expected branch m3GenEnergy does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3GenEnergy")
        else:
            self.m3GenEnergy_branch.SetAddress(<void*>&self.m3GenEnergy_value)

        #print "making m3GenEta"
        self.m3GenEta_branch = the_tree.GetBranch("m3GenEta")
        #if not self.m3GenEta_branch and "m3GenEta" not in self.complained:
        if not self.m3GenEta_branch and "m3GenEta":
            warnings.warn( "EMuMuMuTree: Expected branch m3GenEta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3GenEta")
        else:
            self.m3GenEta_branch.SetAddress(<void*>&self.m3GenEta_value)

        #print "making m3GenMotherPdgId"
        self.m3GenMotherPdgId_branch = the_tree.GetBranch("m3GenMotherPdgId")
        #if not self.m3GenMotherPdgId_branch and "m3GenMotherPdgId" not in self.complained:
        if not self.m3GenMotherPdgId_branch and "m3GenMotherPdgId":
            warnings.warn( "EMuMuMuTree: Expected branch m3GenMotherPdgId does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3GenMotherPdgId")
        else:
            self.m3GenMotherPdgId_branch.SetAddress(<void*>&self.m3GenMotherPdgId_value)

        #print "making m3GenPdgId"
        self.m3GenPdgId_branch = the_tree.GetBranch("m3GenPdgId")
        #if not self.m3GenPdgId_branch and "m3GenPdgId" not in self.complained:
        if not self.m3GenPdgId_branch and "m3GenPdgId":
            warnings.warn( "EMuMuMuTree: Expected branch m3GenPdgId does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3GenPdgId")
        else:
            self.m3GenPdgId_branch.SetAddress(<void*>&self.m3GenPdgId_value)

        #print "making m3GenPhi"
        self.m3GenPhi_branch = the_tree.GetBranch("m3GenPhi")
        #if not self.m3GenPhi_branch and "m3GenPhi" not in self.complained:
        if not self.m3GenPhi_branch and "m3GenPhi":
            warnings.warn( "EMuMuMuTree: Expected branch m3GenPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3GenPhi")
        else:
            self.m3GenPhi_branch.SetAddress(<void*>&self.m3GenPhi_value)

        #print "making m3GlbTrkHits"
        self.m3GlbTrkHits_branch = the_tree.GetBranch("m3GlbTrkHits")
        #if not self.m3GlbTrkHits_branch and "m3GlbTrkHits" not in self.complained:
        if not self.m3GlbTrkHits_branch and "m3GlbTrkHits":
            warnings.warn( "EMuMuMuTree: Expected branch m3GlbTrkHits does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3GlbTrkHits")
        else:
            self.m3GlbTrkHits_branch.SetAddress(<void*>&self.m3GlbTrkHits_value)

        #print "making m3IDHZG2011"
        self.m3IDHZG2011_branch = the_tree.GetBranch("m3IDHZG2011")
        #if not self.m3IDHZG2011_branch and "m3IDHZG2011" not in self.complained:
        if not self.m3IDHZG2011_branch and "m3IDHZG2011":
            warnings.warn( "EMuMuMuTree: Expected branch m3IDHZG2011 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3IDHZG2011")
        else:
            self.m3IDHZG2011_branch.SetAddress(<void*>&self.m3IDHZG2011_value)

        #print "making m3IDHZG2012"
        self.m3IDHZG2012_branch = the_tree.GetBranch("m3IDHZG2012")
        #if not self.m3IDHZG2012_branch and "m3IDHZG2012" not in self.complained:
        if not self.m3IDHZG2012_branch and "m3IDHZG2012":
            warnings.warn( "EMuMuMuTree: Expected branch m3IDHZG2012 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3IDHZG2012")
        else:
            self.m3IDHZG2012_branch.SetAddress(<void*>&self.m3IDHZG2012_value)

        #print "making m3IP3DS"
        self.m3IP3DS_branch = the_tree.GetBranch("m3IP3DS")
        #if not self.m3IP3DS_branch and "m3IP3DS" not in self.complained:
        if not self.m3IP3DS_branch and "m3IP3DS":
            warnings.warn( "EMuMuMuTree: Expected branch m3IP3DS does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3IP3DS")
        else:
            self.m3IP3DS_branch.SetAddress(<void*>&self.m3IP3DS_value)

        #print "making m3IsGlobal"
        self.m3IsGlobal_branch = the_tree.GetBranch("m3IsGlobal")
        #if not self.m3IsGlobal_branch and "m3IsGlobal" not in self.complained:
        if not self.m3IsGlobal_branch and "m3IsGlobal":
            warnings.warn( "EMuMuMuTree: Expected branch m3IsGlobal does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3IsGlobal")
        else:
            self.m3IsGlobal_branch.SetAddress(<void*>&self.m3IsGlobal_value)

        #print "making m3IsPFMuon"
        self.m3IsPFMuon_branch = the_tree.GetBranch("m3IsPFMuon")
        #if not self.m3IsPFMuon_branch and "m3IsPFMuon" not in self.complained:
        if not self.m3IsPFMuon_branch and "m3IsPFMuon":
            warnings.warn( "EMuMuMuTree: Expected branch m3IsPFMuon does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3IsPFMuon")
        else:
            self.m3IsPFMuon_branch.SetAddress(<void*>&self.m3IsPFMuon_value)

        #print "making m3IsTracker"
        self.m3IsTracker_branch = the_tree.GetBranch("m3IsTracker")
        #if not self.m3IsTracker_branch and "m3IsTracker" not in self.complained:
        if not self.m3IsTracker_branch and "m3IsTracker":
            warnings.warn( "EMuMuMuTree: Expected branch m3IsTracker does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3IsTracker")
        else:
            self.m3IsTracker_branch.SetAddress(<void*>&self.m3IsTracker_value)

        #print "making m3JetArea"
        self.m3JetArea_branch = the_tree.GetBranch("m3JetArea")
        #if not self.m3JetArea_branch and "m3JetArea" not in self.complained:
        if not self.m3JetArea_branch and "m3JetArea":
            warnings.warn( "EMuMuMuTree: Expected branch m3JetArea does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3JetArea")
        else:
            self.m3JetArea_branch.SetAddress(<void*>&self.m3JetArea_value)

        #print "making m3JetBtag"
        self.m3JetBtag_branch = the_tree.GetBranch("m3JetBtag")
        #if not self.m3JetBtag_branch and "m3JetBtag" not in self.complained:
        if not self.m3JetBtag_branch and "m3JetBtag":
            warnings.warn( "EMuMuMuTree: Expected branch m3JetBtag does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3JetBtag")
        else:
            self.m3JetBtag_branch.SetAddress(<void*>&self.m3JetBtag_value)

        #print "making m3JetCSVBtag"
        self.m3JetCSVBtag_branch = the_tree.GetBranch("m3JetCSVBtag")
        #if not self.m3JetCSVBtag_branch and "m3JetCSVBtag" not in self.complained:
        if not self.m3JetCSVBtag_branch and "m3JetCSVBtag":
            warnings.warn( "EMuMuMuTree: Expected branch m3JetCSVBtag does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3JetCSVBtag")
        else:
            self.m3JetCSVBtag_branch.SetAddress(<void*>&self.m3JetCSVBtag_value)

        #print "making m3JetEtaEtaMoment"
        self.m3JetEtaEtaMoment_branch = the_tree.GetBranch("m3JetEtaEtaMoment")
        #if not self.m3JetEtaEtaMoment_branch and "m3JetEtaEtaMoment" not in self.complained:
        if not self.m3JetEtaEtaMoment_branch and "m3JetEtaEtaMoment":
            warnings.warn( "EMuMuMuTree: Expected branch m3JetEtaEtaMoment does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3JetEtaEtaMoment")
        else:
            self.m3JetEtaEtaMoment_branch.SetAddress(<void*>&self.m3JetEtaEtaMoment_value)

        #print "making m3JetEtaPhiMoment"
        self.m3JetEtaPhiMoment_branch = the_tree.GetBranch("m3JetEtaPhiMoment")
        #if not self.m3JetEtaPhiMoment_branch and "m3JetEtaPhiMoment" not in self.complained:
        if not self.m3JetEtaPhiMoment_branch and "m3JetEtaPhiMoment":
            warnings.warn( "EMuMuMuTree: Expected branch m3JetEtaPhiMoment does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3JetEtaPhiMoment")
        else:
            self.m3JetEtaPhiMoment_branch.SetAddress(<void*>&self.m3JetEtaPhiMoment_value)

        #print "making m3JetEtaPhiSpread"
        self.m3JetEtaPhiSpread_branch = the_tree.GetBranch("m3JetEtaPhiSpread")
        #if not self.m3JetEtaPhiSpread_branch and "m3JetEtaPhiSpread" not in self.complained:
        if not self.m3JetEtaPhiSpread_branch and "m3JetEtaPhiSpread":
            warnings.warn( "EMuMuMuTree: Expected branch m3JetEtaPhiSpread does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3JetEtaPhiSpread")
        else:
            self.m3JetEtaPhiSpread_branch.SetAddress(<void*>&self.m3JetEtaPhiSpread_value)

        #print "making m3JetPartonFlavour"
        self.m3JetPartonFlavour_branch = the_tree.GetBranch("m3JetPartonFlavour")
        #if not self.m3JetPartonFlavour_branch and "m3JetPartonFlavour" not in self.complained:
        if not self.m3JetPartonFlavour_branch and "m3JetPartonFlavour":
            warnings.warn( "EMuMuMuTree: Expected branch m3JetPartonFlavour does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3JetPartonFlavour")
        else:
            self.m3JetPartonFlavour_branch.SetAddress(<void*>&self.m3JetPartonFlavour_value)

        #print "making m3JetPhiPhiMoment"
        self.m3JetPhiPhiMoment_branch = the_tree.GetBranch("m3JetPhiPhiMoment")
        #if not self.m3JetPhiPhiMoment_branch and "m3JetPhiPhiMoment" not in self.complained:
        if not self.m3JetPhiPhiMoment_branch and "m3JetPhiPhiMoment":
            warnings.warn( "EMuMuMuTree: Expected branch m3JetPhiPhiMoment does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3JetPhiPhiMoment")
        else:
            self.m3JetPhiPhiMoment_branch.SetAddress(<void*>&self.m3JetPhiPhiMoment_value)

        #print "making m3JetPt"
        self.m3JetPt_branch = the_tree.GetBranch("m3JetPt")
        #if not self.m3JetPt_branch and "m3JetPt" not in self.complained:
        if not self.m3JetPt_branch and "m3JetPt":
            warnings.warn( "EMuMuMuTree: Expected branch m3JetPt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3JetPt")
        else:
            self.m3JetPt_branch.SetAddress(<void*>&self.m3JetPt_value)

        #print "making m3JetQGLikelihoodID"
        self.m3JetQGLikelihoodID_branch = the_tree.GetBranch("m3JetQGLikelihoodID")
        #if not self.m3JetQGLikelihoodID_branch and "m3JetQGLikelihoodID" not in self.complained:
        if not self.m3JetQGLikelihoodID_branch and "m3JetQGLikelihoodID":
            warnings.warn( "EMuMuMuTree: Expected branch m3JetQGLikelihoodID does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3JetQGLikelihoodID")
        else:
            self.m3JetQGLikelihoodID_branch.SetAddress(<void*>&self.m3JetQGLikelihoodID_value)

        #print "making m3JetQGMVAID"
        self.m3JetQGMVAID_branch = the_tree.GetBranch("m3JetQGMVAID")
        #if not self.m3JetQGMVAID_branch and "m3JetQGMVAID" not in self.complained:
        if not self.m3JetQGMVAID_branch and "m3JetQGMVAID":
            warnings.warn( "EMuMuMuTree: Expected branch m3JetQGMVAID does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3JetQGMVAID")
        else:
            self.m3JetQGMVAID_branch.SetAddress(<void*>&self.m3JetQGMVAID_value)

        #print "making m3Jetaxis1"
        self.m3Jetaxis1_branch = the_tree.GetBranch("m3Jetaxis1")
        #if not self.m3Jetaxis1_branch and "m3Jetaxis1" not in self.complained:
        if not self.m3Jetaxis1_branch and "m3Jetaxis1":
            warnings.warn( "EMuMuMuTree: Expected branch m3Jetaxis1 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3Jetaxis1")
        else:
            self.m3Jetaxis1_branch.SetAddress(<void*>&self.m3Jetaxis1_value)

        #print "making m3Jetaxis2"
        self.m3Jetaxis2_branch = the_tree.GetBranch("m3Jetaxis2")
        #if not self.m3Jetaxis2_branch and "m3Jetaxis2" not in self.complained:
        if not self.m3Jetaxis2_branch and "m3Jetaxis2":
            warnings.warn( "EMuMuMuTree: Expected branch m3Jetaxis2 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3Jetaxis2")
        else:
            self.m3Jetaxis2_branch.SetAddress(<void*>&self.m3Jetaxis2_value)

        #print "making m3Jetmult"
        self.m3Jetmult_branch = the_tree.GetBranch("m3Jetmult")
        #if not self.m3Jetmult_branch and "m3Jetmult" not in self.complained:
        if not self.m3Jetmult_branch and "m3Jetmult":
            warnings.warn( "EMuMuMuTree: Expected branch m3Jetmult does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3Jetmult")
        else:
            self.m3Jetmult_branch.SetAddress(<void*>&self.m3Jetmult_value)

        #print "making m3JetmultMLP"
        self.m3JetmultMLP_branch = the_tree.GetBranch("m3JetmultMLP")
        #if not self.m3JetmultMLP_branch and "m3JetmultMLP" not in self.complained:
        if not self.m3JetmultMLP_branch and "m3JetmultMLP":
            warnings.warn( "EMuMuMuTree: Expected branch m3JetmultMLP does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3JetmultMLP")
        else:
            self.m3JetmultMLP_branch.SetAddress(<void*>&self.m3JetmultMLP_value)

        #print "making m3JetmultMLPQC"
        self.m3JetmultMLPQC_branch = the_tree.GetBranch("m3JetmultMLPQC")
        #if not self.m3JetmultMLPQC_branch and "m3JetmultMLPQC" not in self.complained:
        if not self.m3JetmultMLPQC_branch and "m3JetmultMLPQC":
            warnings.warn( "EMuMuMuTree: Expected branch m3JetmultMLPQC does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3JetmultMLPQC")
        else:
            self.m3JetmultMLPQC_branch.SetAddress(<void*>&self.m3JetmultMLPQC_value)

        #print "making m3JetptD"
        self.m3JetptD_branch = the_tree.GetBranch("m3JetptD")
        #if not self.m3JetptD_branch and "m3JetptD" not in self.complained:
        if not self.m3JetptD_branch and "m3JetptD":
            warnings.warn( "EMuMuMuTree: Expected branch m3JetptD does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3JetptD")
        else:
            self.m3JetptD_branch.SetAddress(<void*>&self.m3JetptD_value)

        #print "making m3L1Mu3EG5L3Filtered17"
        self.m3L1Mu3EG5L3Filtered17_branch = the_tree.GetBranch("m3L1Mu3EG5L3Filtered17")
        #if not self.m3L1Mu3EG5L3Filtered17_branch and "m3L1Mu3EG5L3Filtered17" not in self.complained:
        if not self.m3L1Mu3EG5L3Filtered17_branch and "m3L1Mu3EG5L3Filtered17":
            warnings.warn( "EMuMuMuTree: Expected branch m3L1Mu3EG5L3Filtered17 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3L1Mu3EG5L3Filtered17")
        else:
            self.m3L1Mu3EG5L3Filtered17_branch.SetAddress(<void*>&self.m3L1Mu3EG5L3Filtered17_value)

        #print "making m3L3fL1DoubleMu10MuOpenL1f0L2f10L3Filtered17"
        self.m3L3fL1DoubleMu10MuOpenL1f0L2f10L3Filtered17_branch = the_tree.GetBranch("m3L3fL1DoubleMu10MuOpenL1f0L2f10L3Filtered17")
        #if not self.m3L3fL1DoubleMu10MuOpenL1f0L2f10L3Filtered17_branch and "m3L3fL1DoubleMu10MuOpenL1f0L2f10L3Filtered17" not in self.complained:
        if not self.m3L3fL1DoubleMu10MuOpenL1f0L2f10L3Filtered17_branch and "m3L3fL1DoubleMu10MuOpenL1f0L2f10L3Filtered17":
            warnings.warn( "EMuMuMuTree: Expected branch m3L3fL1DoubleMu10MuOpenL1f0L2f10L3Filtered17 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3L3fL1DoubleMu10MuOpenL1f0L2f10L3Filtered17")
        else:
            self.m3L3fL1DoubleMu10MuOpenL1f0L2f10L3Filtered17_branch.SetAddress(<void*>&self.m3L3fL1DoubleMu10MuOpenL1f0L2f10L3Filtered17_value)

        #print "making m3Mass"
        self.m3Mass_branch = the_tree.GetBranch("m3Mass")
        #if not self.m3Mass_branch and "m3Mass" not in self.complained:
        if not self.m3Mass_branch and "m3Mass":
            warnings.warn( "EMuMuMuTree: Expected branch m3Mass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3Mass")
        else:
            self.m3Mass_branch.SetAddress(<void*>&self.m3Mass_value)

        #print "making m3MatchedStations"
        self.m3MatchedStations_branch = the_tree.GetBranch("m3MatchedStations")
        #if not self.m3MatchedStations_branch and "m3MatchedStations" not in self.complained:
        if not self.m3MatchedStations_branch and "m3MatchedStations":
            warnings.warn( "EMuMuMuTree: Expected branch m3MatchedStations does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3MatchedStations")
        else:
            self.m3MatchedStations_branch.SetAddress(<void*>&self.m3MatchedStations_value)

        #print "making m3MatchesDoubleMuPaths"
        self.m3MatchesDoubleMuPaths_branch = the_tree.GetBranch("m3MatchesDoubleMuPaths")
        #if not self.m3MatchesDoubleMuPaths_branch and "m3MatchesDoubleMuPaths" not in self.complained:
        if not self.m3MatchesDoubleMuPaths_branch and "m3MatchesDoubleMuPaths":
            warnings.warn( "EMuMuMuTree: Expected branch m3MatchesDoubleMuPaths does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3MatchesDoubleMuPaths")
        else:
            self.m3MatchesDoubleMuPaths_branch.SetAddress(<void*>&self.m3MatchesDoubleMuPaths_value)

        #print "making m3MatchesDoubleMuTrkPaths"
        self.m3MatchesDoubleMuTrkPaths_branch = the_tree.GetBranch("m3MatchesDoubleMuTrkPaths")
        #if not self.m3MatchesDoubleMuTrkPaths_branch and "m3MatchesDoubleMuTrkPaths" not in self.complained:
        if not self.m3MatchesDoubleMuTrkPaths_branch and "m3MatchesDoubleMuTrkPaths":
            warnings.warn( "EMuMuMuTree: Expected branch m3MatchesDoubleMuTrkPaths does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3MatchesDoubleMuTrkPaths")
        else:
            self.m3MatchesDoubleMuTrkPaths_branch.SetAddress(<void*>&self.m3MatchesDoubleMuTrkPaths_value)

        #print "making m3MatchesIsoMu24eta2p1"
        self.m3MatchesIsoMu24eta2p1_branch = the_tree.GetBranch("m3MatchesIsoMu24eta2p1")
        #if not self.m3MatchesIsoMu24eta2p1_branch and "m3MatchesIsoMu24eta2p1" not in self.complained:
        if not self.m3MatchesIsoMu24eta2p1_branch and "m3MatchesIsoMu24eta2p1":
            warnings.warn( "EMuMuMuTree: Expected branch m3MatchesIsoMu24eta2p1 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3MatchesIsoMu24eta2p1")
        else:
            self.m3MatchesIsoMu24eta2p1_branch.SetAddress(<void*>&self.m3MatchesIsoMu24eta2p1_value)

        #print "making m3MatchesIsoMuGroup"
        self.m3MatchesIsoMuGroup_branch = the_tree.GetBranch("m3MatchesIsoMuGroup")
        #if not self.m3MatchesIsoMuGroup_branch and "m3MatchesIsoMuGroup" not in self.complained:
        if not self.m3MatchesIsoMuGroup_branch and "m3MatchesIsoMuGroup":
            warnings.warn( "EMuMuMuTree: Expected branch m3MatchesIsoMuGroup does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3MatchesIsoMuGroup")
        else:
            self.m3MatchesIsoMuGroup_branch.SetAddress(<void*>&self.m3MatchesIsoMuGroup_value)

        #print "making m3MatchesMu17Ele8IsoPath"
        self.m3MatchesMu17Ele8IsoPath_branch = the_tree.GetBranch("m3MatchesMu17Ele8IsoPath")
        #if not self.m3MatchesMu17Ele8IsoPath_branch and "m3MatchesMu17Ele8IsoPath" not in self.complained:
        if not self.m3MatchesMu17Ele8IsoPath_branch and "m3MatchesMu17Ele8IsoPath":
            warnings.warn( "EMuMuMuTree: Expected branch m3MatchesMu17Ele8IsoPath does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3MatchesMu17Ele8IsoPath")
        else:
            self.m3MatchesMu17Ele8IsoPath_branch.SetAddress(<void*>&self.m3MatchesMu17Ele8IsoPath_value)

        #print "making m3MatchesMu17Ele8Path"
        self.m3MatchesMu17Ele8Path_branch = the_tree.GetBranch("m3MatchesMu17Ele8Path")
        #if not self.m3MatchesMu17Ele8Path_branch and "m3MatchesMu17Ele8Path" not in self.complained:
        if not self.m3MatchesMu17Ele8Path_branch and "m3MatchesMu17Ele8Path":
            warnings.warn( "EMuMuMuTree: Expected branch m3MatchesMu17Ele8Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3MatchesMu17Ele8Path")
        else:
            self.m3MatchesMu17Ele8Path_branch.SetAddress(<void*>&self.m3MatchesMu17Ele8Path_value)

        #print "making m3MatchesMu17Mu8Path"
        self.m3MatchesMu17Mu8Path_branch = the_tree.GetBranch("m3MatchesMu17Mu8Path")
        #if not self.m3MatchesMu17Mu8Path_branch and "m3MatchesMu17Mu8Path" not in self.complained:
        if not self.m3MatchesMu17Mu8Path_branch and "m3MatchesMu17Mu8Path":
            warnings.warn( "EMuMuMuTree: Expected branch m3MatchesMu17Mu8Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3MatchesMu17Mu8Path")
        else:
            self.m3MatchesMu17Mu8Path_branch.SetAddress(<void*>&self.m3MatchesMu17Mu8Path_value)

        #print "making m3MatchesMu17TrkMu8Path"
        self.m3MatchesMu17TrkMu8Path_branch = the_tree.GetBranch("m3MatchesMu17TrkMu8Path")
        #if not self.m3MatchesMu17TrkMu8Path_branch and "m3MatchesMu17TrkMu8Path" not in self.complained:
        if not self.m3MatchesMu17TrkMu8Path_branch and "m3MatchesMu17TrkMu8Path":
            warnings.warn( "EMuMuMuTree: Expected branch m3MatchesMu17TrkMu8Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3MatchesMu17TrkMu8Path")
        else:
            self.m3MatchesMu17TrkMu8Path_branch.SetAddress(<void*>&self.m3MatchesMu17TrkMu8Path_value)

        #print "making m3MatchesMu8Ele17IsoPath"
        self.m3MatchesMu8Ele17IsoPath_branch = the_tree.GetBranch("m3MatchesMu8Ele17IsoPath")
        #if not self.m3MatchesMu8Ele17IsoPath_branch and "m3MatchesMu8Ele17IsoPath" not in self.complained:
        if not self.m3MatchesMu8Ele17IsoPath_branch and "m3MatchesMu8Ele17IsoPath":
            warnings.warn( "EMuMuMuTree: Expected branch m3MatchesMu8Ele17IsoPath does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3MatchesMu8Ele17IsoPath")
        else:
            self.m3MatchesMu8Ele17IsoPath_branch.SetAddress(<void*>&self.m3MatchesMu8Ele17IsoPath_value)

        #print "making m3MatchesMu8Ele17Path"
        self.m3MatchesMu8Ele17Path_branch = the_tree.GetBranch("m3MatchesMu8Ele17Path")
        #if not self.m3MatchesMu8Ele17Path_branch and "m3MatchesMu8Ele17Path" not in self.complained:
        if not self.m3MatchesMu8Ele17Path_branch and "m3MatchesMu8Ele17Path":
            warnings.warn( "EMuMuMuTree: Expected branch m3MatchesMu8Ele17Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3MatchesMu8Ele17Path")
        else:
            self.m3MatchesMu8Ele17Path_branch.SetAddress(<void*>&self.m3MatchesMu8Ele17Path_value)

        #print "making m3MtToMET"
        self.m3MtToMET_branch = the_tree.GetBranch("m3MtToMET")
        #if not self.m3MtToMET_branch and "m3MtToMET" not in self.complained:
        if not self.m3MtToMET_branch and "m3MtToMET":
            warnings.warn( "EMuMuMuTree: Expected branch m3MtToMET does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3MtToMET")
        else:
            self.m3MtToMET_branch.SetAddress(<void*>&self.m3MtToMET_value)

        #print "making m3MtToMVAMET"
        self.m3MtToMVAMET_branch = the_tree.GetBranch("m3MtToMVAMET")
        #if not self.m3MtToMVAMET_branch and "m3MtToMVAMET" not in self.complained:
        if not self.m3MtToMVAMET_branch and "m3MtToMVAMET":
            warnings.warn( "EMuMuMuTree: Expected branch m3MtToMVAMET does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3MtToMVAMET")
        else:
            self.m3MtToMVAMET_branch.SetAddress(<void*>&self.m3MtToMVAMET_value)

        #print "making m3MtToPFMET"
        self.m3MtToPFMET_branch = the_tree.GetBranch("m3MtToPFMET")
        #if not self.m3MtToPFMET_branch and "m3MtToPFMET" not in self.complained:
        if not self.m3MtToPFMET_branch and "m3MtToPFMET":
            warnings.warn( "EMuMuMuTree: Expected branch m3MtToPFMET does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3MtToPFMET")
        else:
            self.m3MtToPFMET_branch.SetAddress(<void*>&self.m3MtToPFMET_value)

        #print "making m3MtToPfMet_Ty1"
        self.m3MtToPfMet_Ty1_branch = the_tree.GetBranch("m3MtToPfMet_Ty1")
        #if not self.m3MtToPfMet_Ty1_branch and "m3MtToPfMet_Ty1" not in self.complained:
        if not self.m3MtToPfMet_Ty1_branch and "m3MtToPfMet_Ty1":
            warnings.warn( "EMuMuMuTree: Expected branch m3MtToPfMet_Ty1 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3MtToPfMet_Ty1")
        else:
            self.m3MtToPfMet_Ty1_branch.SetAddress(<void*>&self.m3MtToPfMet_Ty1_value)

        #print "making m3MtToPfMet_jes"
        self.m3MtToPfMet_jes_branch = the_tree.GetBranch("m3MtToPfMet_jes")
        #if not self.m3MtToPfMet_jes_branch and "m3MtToPfMet_jes" not in self.complained:
        if not self.m3MtToPfMet_jes_branch and "m3MtToPfMet_jes":
            warnings.warn( "EMuMuMuTree: Expected branch m3MtToPfMet_jes does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3MtToPfMet_jes")
        else:
            self.m3MtToPfMet_jes_branch.SetAddress(<void*>&self.m3MtToPfMet_jes_value)

        #print "making m3MtToPfMet_mes"
        self.m3MtToPfMet_mes_branch = the_tree.GetBranch("m3MtToPfMet_mes")
        #if not self.m3MtToPfMet_mes_branch and "m3MtToPfMet_mes" not in self.complained:
        if not self.m3MtToPfMet_mes_branch and "m3MtToPfMet_mes":
            warnings.warn( "EMuMuMuTree: Expected branch m3MtToPfMet_mes does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3MtToPfMet_mes")
        else:
            self.m3MtToPfMet_mes_branch.SetAddress(<void*>&self.m3MtToPfMet_mes_value)

        #print "making m3MtToPfMet_tes"
        self.m3MtToPfMet_tes_branch = the_tree.GetBranch("m3MtToPfMet_tes")
        #if not self.m3MtToPfMet_tes_branch and "m3MtToPfMet_tes" not in self.complained:
        if not self.m3MtToPfMet_tes_branch and "m3MtToPfMet_tes":
            warnings.warn( "EMuMuMuTree: Expected branch m3MtToPfMet_tes does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3MtToPfMet_tes")
        else:
            self.m3MtToPfMet_tes_branch.SetAddress(<void*>&self.m3MtToPfMet_tes_value)

        #print "making m3MtToPfMet_ues"
        self.m3MtToPfMet_ues_branch = the_tree.GetBranch("m3MtToPfMet_ues")
        #if not self.m3MtToPfMet_ues_branch and "m3MtToPfMet_ues" not in self.complained:
        if not self.m3MtToPfMet_ues_branch and "m3MtToPfMet_ues":
            warnings.warn( "EMuMuMuTree: Expected branch m3MtToPfMet_ues does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3MtToPfMet_ues")
        else:
            self.m3MtToPfMet_ues_branch.SetAddress(<void*>&self.m3MtToPfMet_ues_value)

        #print "making m3Mu17Ele8dZFilter"
        self.m3Mu17Ele8dZFilter_branch = the_tree.GetBranch("m3Mu17Ele8dZFilter")
        #if not self.m3Mu17Ele8dZFilter_branch and "m3Mu17Ele8dZFilter" not in self.complained:
        if not self.m3Mu17Ele8dZFilter_branch and "m3Mu17Ele8dZFilter":
            warnings.warn( "EMuMuMuTree: Expected branch m3Mu17Ele8dZFilter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3Mu17Ele8dZFilter")
        else:
            self.m3Mu17Ele8dZFilter_branch.SetAddress(<void*>&self.m3Mu17Ele8dZFilter_value)

        #print "making m3MuonHits"
        self.m3MuonHits_branch = the_tree.GetBranch("m3MuonHits")
        #if not self.m3MuonHits_branch and "m3MuonHits" not in self.complained:
        if not self.m3MuonHits_branch and "m3MuonHits":
            warnings.warn( "EMuMuMuTree: Expected branch m3MuonHits does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3MuonHits")
        else:
            self.m3MuonHits_branch.SetAddress(<void*>&self.m3MuonHits_value)

        #print "making m3NormTrkChi2"
        self.m3NormTrkChi2_branch = the_tree.GetBranch("m3NormTrkChi2")
        #if not self.m3NormTrkChi2_branch and "m3NormTrkChi2" not in self.complained:
        if not self.m3NormTrkChi2_branch and "m3NormTrkChi2":
            warnings.warn( "EMuMuMuTree: Expected branch m3NormTrkChi2 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3NormTrkChi2")
        else:
            self.m3NormTrkChi2_branch.SetAddress(<void*>&self.m3NormTrkChi2_value)

        #print "making m3PFChargedIso"
        self.m3PFChargedIso_branch = the_tree.GetBranch("m3PFChargedIso")
        #if not self.m3PFChargedIso_branch and "m3PFChargedIso" not in self.complained:
        if not self.m3PFChargedIso_branch and "m3PFChargedIso":
            warnings.warn( "EMuMuMuTree: Expected branch m3PFChargedIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3PFChargedIso")
        else:
            self.m3PFChargedIso_branch.SetAddress(<void*>&self.m3PFChargedIso_value)

        #print "making m3PFIDTight"
        self.m3PFIDTight_branch = the_tree.GetBranch("m3PFIDTight")
        #if not self.m3PFIDTight_branch and "m3PFIDTight" not in self.complained:
        if not self.m3PFIDTight_branch and "m3PFIDTight":
            warnings.warn( "EMuMuMuTree: Expected branch m3PFIDTight does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3PFIDTight")
        else:
            self.m3PFIDTight_branch.SetAddress(<void*>&self.m3PFIDTight_value)

        #print "making m3PFNeutralIso"
        self.m3PFNeutralIso_branch = the_tree.GetBranch("m3PFNeutralIso")
        #if not self.m3PFNeutralIso_branch and "m3PFNeutralIso" not in self.complained:
        if not self.m3PFNeutralIso_branch and "m3PFNeutralIso":
            warnings.warn( "EMuMuMuTree: Expected branch m3PFNeutralIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3PFNeutralIso")
        else:
            self.m3PFNeutralIso_branch.SetAddress(<void*>&self.m3PFNeutralIso_value)

        #print "making m3PFPUChargedIso"
        self.m3PFPUChargedIso_branch = the_tree.GetBranch("m3PFPUChargedIso")
        #if not self.m3PFPUChargedIso_branch and "m3PFPUChargedIso" not in self.complained:
        if not self.m3PFPUChargedIso_branch and "m3PFPUChargedIso":
            warnings.warn( "EMuMuMuTree: Expected branch m3PFPUChargedIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3PFPUChargedIso")
        else:
            self.m3PFPUChargedIso_branch.SetAddress(<void*>&self.m3PFPUChargedIso_value)

        #print "making m3PFPhotonIso"
        self.m3PFPhotonIso_branch = the_tree.GetBranch("m3PFPhotonIso")
        #if not self.m3PFPhotonIso_branch and "m3PFPhotonIso" not in self.complained:
        if not self.m3PFPhotonIso_branch and "m3PFPhotonIso":
            warnings.warn( "EMuMuMuTree: Expected branch m3PFPhotonIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3PFPhotonIso")
        else:
            self.m3PFPhotonIso_branch.SetAddress(<void*>&self.m3PFPhotonIso_value)

        #print "making m3PVDXY"
        self.m3PVDXY_branch = the_tree.GetBranch("m3PVDXY")
        #if not self.m3PVDXY_branch and "m3PVDXY" not in self.complained:
        if not self.m3PVDXY_branch and "m3PVDXY":
            warnings.warn( "EMuMuMuTree: Expected branch m3PVDXY does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3PVDXY")
        else:
            self.m3PVDXY_branch.SetAddress(<void*>&self.m3PVDXY_value)

        #print "making m3PVDZ"
        self.m3PVDZ_branch = the_tree.GetBranch("m3PVDZ")
        #if not self.m3PVDZ_branch and "m3PVDZ" not in self.complained:
        if not self.m3PVDZ_branch and "m3PVDZ":
            warnings.warn( "EMuMuMuTree: Expected branch m3PVDZ does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3PVDZ")
        else:
            self.m3PVDZ_branch.SetAddress(<void*>&self.m3PVDZ_value)

        #print "making m3Phi"
        self.m3Phi_branch = the_tree.GetBranch("m3Phi")
        #if not self.m3Phi_branch and "m3Phi" not in self.complained:
        if not self.m3Phi_branch and "m3Phi":
            warnings.warn( "EMuMuMuTree: Expected branch m3Phi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3Phi")
        else:
            self.m3Phi_branch.SetAddress(<void*>&self.m3Phi_value)

        #print "making m3PhiRochCor2011A"
        self.m3PhiRochCor2011A_branch = the_tree.GetBranch("m3PhiRochCor2011A")
        #if not self.m3PhiRochCor2011A_branch and "m3PhiRochCor2011A" not in self.complained:
        if not self.m3PhiRochCor2011A_branch and "m3PhiRochCor2011A":
            warnings.warn( "EMuMuMuTree: Expected branch m3PhiRochCor2011A does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3PhiRochCor2011A")
        else:
            self.m3PhiRochCor2011A_branch.SetAddress(<void*>&self.m3PhiRochCor2011A_value)

        #print "making m3PhiRochCor2011B"
        self.m3PhiRochCor2011B_branch = the_tree.GetBranch("m3PhiRochCor2011B")
        #if not self.m3PhiRochCor2011B_branch and "m3PhiRochCor2011B" not in self.complained:
        if not self.m3PhiRochCor2011B_branch and "m3PhiRochCor2011B":
            warnings.warn( "EMuMuMuTree: Expected branch m3PhiRochCor2011B does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3PhiRochCor2011B")
        else:
            self.m3PhiRochCor2011B_branch.SetAddress(<void*>&self.m3PhiRochCor2011B_value)

        #print "making m3PhiRochCor2012"
        self.m3PhiRochCor2012_branch = the_tree.GetBranch("m3PhiRochCor2012")
        #if not self.m3PhiRochCor2012_branch and "m3PhiRochCor2012" not in self.complained:
        if not self.m3PhiRochCor2012_branch and "m3PhiRochCor2012":
            warnings.warn( "EMuMuMuTree: Expected branch m3PhiRochCor2012 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3PhiRochCor2012")
        else:
            self.m3PhiRochCor2012_branch.SetAddress(<void*>&self.m3PhiRochCor2012_value)

        #print "making m3PixHits"
        self.m3PixHits_branch = the_tree.GetBranch("m3PixHits")
        #if not self.m3PixHits_branch and "m3PixHits" not in self.complained:
        if not self.m3PixHits_branch and "m3PixHits":
            warnings.warn( "EMuMuMuTree: Expected branch m3PixHits does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3PixHits")
        else:
            self.m3PixHits_branch.SetAddress(<void*>&self.m3PixHits_value)

        #print "making m3Pt"
        self.m3Pt_branch = the_tree.GetBranch("m3Pt")
        #if not self.m3Pt_branch and "m3Pt" not in self.complained:
        if not self.m3Pt_branch and "m3Pt":
            warnings.warn( "EMuMuMuTree: Expected branch m3Pt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3Pt")
        else:
            self.m3Pt_branch.SetAddress(<void*>&self.m3Pt_value)

        #print "making m3PtRochCor2011A"
        self.m3PtRochCor2011A_branch = the_tree.GetBranch("m3PtRochCor2011A")
        #if not self.m3PtRochCor2011A_branch and "m3PtRochCor2011A" not in self.complained:
        if not self.m3PtRochCor2011A_branch and "m3PtRochCor2011A":
            warnings.warn( "EMuMuMuTree: Expected branch m3PtRochCor2011A does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3PtRochCor2011A")
        else:
            self.m3PtRochCor2011A_branch.SetAddress(<void*>&self.m3PtRochCor2011A_value)

        #print "making m3PtRochCor2011B"
        self.m3PtRochCor2011B_branch = the_tree.GetBranch("m3PtRochCor2011B")
        #if not self.m3PtRochCor2011B_branch and "m3PtRochCor2011B" not in self.complained:
        if not self.m3PtRochCor2011B_branch and "m3PtRochCor2011B":
            warnings.warn( "EMuMuMuTree: Expected branch m3PtRochCor2011B does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3PtRochCor2011B")
        else:
            self.m3PtRochCor2011B_branch.SetAddress(<void*>&self.m3PtRochCor2011B_value)

        #print "making m3PtRochCor2012"
        self.m3PtRochCor2012_branch = the_tree.GetBranch("m3PtRochCor2012")
        #if not self.m3PtRochCor2012_branch and "m3PtRochCor2012" not in self.complained:
        if not self.m3PtRochCor2012_branch and "m3PtRochCor2012":
            warnings.warn( "EMuMuMuTree: Expected branch m3PtRochCor2012 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3PtRochCor2012")
        else:
            self.m3PtRochCor2012_branch.SetAddress(<void*>&self.m3PtRochCor2012_value)

        #print "making m3Rank"
        self.m3Rank_branch = the_tree.GetBranch("m3Rank")
        #if not self.m3Rank_branch and "m3Rank" not in self.complained:
        if not self.m3Rank_branch and "m3Rank":
            warnings.warn( "EMuMuMuTree: Expected branch m3Rank does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3Rank")
        else:
            self.m3Rank_branch.SetAddress(<void*>&self.m3Rank_value)

        #print "making m3RelPFIsoDB"
        self.m3RelPFIsoDB_branch = the_tree.GetBranch("m3RelPFIsoDB")
        #if not self.m3RelPFIsoDB_branch and "m3RelPFIsoDB" not in self.complained:
        if not self.m3RelPFIsoDB_branch and "m3RelPFIsoDB":
            warnings.warn( "EMuMuMuTree: Expected branch m3RelPFIsoDB does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3RelPFIsoDB")
        else:
            self.m3RelPFIsoDB_branch.SetAddress(<void*>&self.m3RelPFIsoDB_value)

        #print "making m3RelPFIsoRho"
        self.m3RelPFIsoRho_branch = the_tree.GetBranch("m3RelPFIsoRho")
        #if not self.m3RelPFIsoRho_branch and "m3RelPFIsoRho" not in self.complained:
        if not self.m3RelPFIsoRho_branch and "m3RelPFIsoRho":
            warnings.warn( "EMuMuMuTree: Expected branch m3RelPFIsoRho does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3RelPFIsoRho")
        else:
            self.m3RelPFIsoRho_branch.SetAddress(<void*>&self.m3RelPFIsoRho_value)

        #print "making m3RelPFIsoRhoFSR"
        self.m3RelPFIsoRhoFSR_branch = the_tree.GetBranch("m3RelPFIsoRhoFSR")
        #if not self.m3RelPFIsoRhoFSR_branch and "m3RelPFIsoRhoFSR" not in self.complained:
        if not self.m3RelPFIsoRhoFSR_branch and "m3RelPFIsoRhoFSR":
            warnings.warn( "EMuMuMuTree: Expected branch m3RelPFIsoRhoFSR does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3RelPFIsoRhoFSR")
        else:
            self.m3RelPFIsoRhoFSR_branch.SetAddress(<void*>&self.m3RelPFIsoRhoFSR_value)

        #print "making m3RhoHZG2011"
        self.m3RhoHZG2011_branch = the_tree.GetBranch("m3RhoHZG2011")
        #if not self.m3RhoHZG2011_branch and "m3RhoHZG2011" not in self.complained:
        if not self.m3RhoHZG2011_branch and "m3RhoHZG2011":
            warnings.warn( "EMuMuMuTree: Expected branch m3RhoHZG2011 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3RhoHZG2011")
        else:
            self.m3RhoHZG2011_branch.SetAddress(<void*>&self.m3RhoHZG2011_value)

        #print "making m3RhoHZG2012"
        self.m3RhoHZG2012_branch = the_tree.GetBranch("m3RhoHZG2012")
        #if not self.m3RhoHZG2012_branch and "m3RhoHZG2012" not in self.complained:
        if not self.m3RhoHZG2012_branch and "m3RhoHZG2012":
            warnings.warn( "EMuMuMuTree: Expected branch m3RhoHZG2012 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3RhoHZG2012")
        else:
            self.m3RhoHZG2012_branch.SetAddress(<void*>&self.m3RhoHZG2012_value)

        #print "making m3SingleMu13L3Filtered13"
        self.m3SingleMu13L3Filtered13_branch = the_tree.GetBranch("m3SingleMu13L3Filtered13")
        #if not self.m3SingleMu13L3Filtered13_branch and "m3SingleMu13L3Filtered13" not in self.complained:
        if not self.m3SingleMu13L3Filtered13_branch and "m3SingleMu13L3Filtered13":
            warnings.warn( "EMuMuMuTree: Expected branch m3SingleMu13L3Filtered13 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3SingleMu13L3Filtered13")
        else:
            self.m3SingleMu13L3Filtered13_branch.SetAddress(<void*>&self.m3SingleMu13L3Filtered13_value)

        #print "making m3SingleMu13L3Filtered17"
        self.m3SingleMu13L3Filtered17_branch = the_tree.GetBranch("m3SingleMu13L3Filtered17")
        #if not self.m3SingleMu13L3Filtered17_branch and "m3SingleMu13L3Filtered17" not in self.complained:
        if not self.m3SingleMu13L3Filtered17_branch and "m3SingleMu13L3Filtered17":
            warnings.warn( "EMuMuMuTree: Expected branch m3SingleMu13L3Filtered17 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3SingleMu13L3Filtered17")
        else:
            self.m3SingleMu13L3Filtered17_branch.SetAddress(<void*>&self.m3SingleMu13L3Filtered17_value)

        #print "making m3TkLayersWithMeasurement"
        self.m3TkLayersWithMeasurement_branch = the_tree.GetBranch("m3TkLayersWithMeasurement")
        #if not self.m3TkLayersWithMeasurement_branch and "m3TkLayersWithMeasurement" not in self.complained:
        if not self.m3TkLayersWithMeasurement_branch and "m3TkLayersWithMeasurement":
            warnings.warn( "EMuMuMuTree: Expected branch m3TkLayersWithMeasurement does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3TkLayersWithMeasurement")
        else:
            self.m3TkLayersWithMeasurement_branch.SetAddress(<void*>&self.m3TkLayersWithMeasurement_value)

        #print "making m3ToMETDPhi"
        self.m3ToMETDPhi_branch = the_tree.GetBranch("m3ToMETDPhi")
        #if not self.m3ToMETDPhi_branch and "m3ToMETDPhi" not in self.complained:
        if not self.m3ToMETDPhi_branch and "m3ToMETDPhi":
            warnings.warn( "EMuMuMuTree: Expected branch m3ToMETDPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3ToMETDPhi")
        else:
            self.m3ToMETDPhi_branch.SetAddress(<void*>&self.m3ToMETDPhi_value)

        #print "making m3TypeCode"
        self.m3TypeCode_branch = the_tree.GetBranch("m3TypeCode")
        #if not self.m3TypeCode_branch and "m3TypeCode" not in self.complained:
        if not self.m3TypeCode_branch and "m3TypeCode":
            warnings.warn( "EMuMuMuTree: Expected branch m3TypeCode does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3TypeCode")
        else:
            self.m3TypeCode_branch.SetAddress(<void*>&self.m3TypeCode_value)

        #print "making m3VBTFID"
        self.m3VBTFID_branch = the_tree.GetBranch("m3VBTFID")
        #if not self.m3VBTFID_branch and "m3VBTFID" not in self.complained:
        if not self.m3VBTFID_branch and "m3VBTFID":
            warnings.warn( "EMuMuMuTree: Expected branch m3VBTFID does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3VBTFID")
        else:
            self.m3VBTFID_branch.SetAddress(<void*>&self.m3VBTFID_value)

        #print "making m3VZ"
        self.m3VZ_branch = the_tree.GetBranch("m3VZ")
        #if not self.m3VZ_branch and "m3VZ" not in self.complained:
        if not self.m3VZ_branch and "m3VZ":
            warnings.warn( "EMuMuMuTree: Expected branch m3VZ does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3VZ")
        else:
            self.m3VZ_branch.SetAddress(<void*>&self.m3VZ_value)

        #print "making m3WWID"
        self.m3WWID_branch = the_tree.GetBranch("m3WWID")
        #if not self.m3WWID_branch and "m3WWID" not in self.complained:
        if not self.m3WWID_branch and "m3WWID":
            warnings.warn( "EMuMuMuTree: Expected branch m3WWID does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3WWID")
        else:
            self.m3WWID_branch.SetAddress(<void*>&self.m3WWID_value)

        #print "making mu17ele8Group"
        self.mu17ele8Group_branch = the_tree.GetBranch("mu17ele8Group")
        #if not self.mu17ele8Group_branch and "mu17ele8Group" not in self.complained:
        if not self.mu17ele8Group_branch and "mu17ele8Group":
            warnings.warn( "EMuMuMuTree: Expected branch mu17ele8Group does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mu17ele8Group")
        else:
            self.mu17ele8Group_branch.SetAddress(<void*>&self.mu17ele8Group_value)

        #print "making mu17ele8Pass"
        self.mu17ele8Pass_branch = the_tree.GetBranch("mu17ele8Pass")
        #if not self.mu17ele8Pass_branch and "mu17ele8Pass" not in self.complained:
        if not self.mu17ele8Pass_branch and "mu17ele8Pass":
            warnings.warn( "EMuMuMuTree: Expected branch mu17ele8Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mu17ele8Pass")
        else:
            self.mu17ele8Pass_branch.SetAddress(<void*>&self.mu17ele8Pass_value)

        #print "making mu17ele8Prescale"
        self.mu17ele8Prescale_branch = the_tree.GetBranch("mu17ele8Prescale")
        #if not self.mu17ele8Prescale_branch and "mu17ele8Prescale" not in self.complained:
        if not self.mu17ele8Prescale_branch and "mu17ele8Prescale":
            warnings.warn( "EMuMuMuTree: Expected branch mu17ele8Prescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mu17ele8Prescale")
        else:
            self.mu17ele8Prescale_branch.SetAddress(<void*>&self.mu17ele8Prescale_value)

        #print "making mu17ele8isoGroup"
        self.mu17ele8isoGroup_branch = the_tree.GetBranch("mu17ele8isoGroup")
        #if not self.mu17ele8isoGroup_branch and "mu17ele8isoGroup" not in self.complained:
        if not self.mu17ele8isoGroup_branch and "mu17ele8isoGroup":
            warnings.warn( "EMuMuMuTree: Expected branch mu17ele8isoGroup does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mu17ele8isoGroup")
        else:
            self.mu17ele8isoGroup_branch.SetAddress(<void*>&self.mu17ele8isoGroup_value)

        #print "making mu17ele8isoPass"
        self.mu17ele8isoPass_branch = the_tree.GetBranch("mu17ele8isoPass")
        #if not self.mu17ele8isoPass_branch and "mu17ele8isoPass" not in self.complained:
        if not self.mu17ele8isoPass_branch and "mu17ele8isoPass":
            warnings.warn( "EMuMuMuTree: Expected branch mu17ele8isoPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mu17ele8isoPass")
        else:
            self.mu17ele8isoPass_branch.SetAddress(<void*>&self.mu17ele8isoPass_value)

        #print "making mu17ele8isoPrescale"
        self.mu17ele8isoPrescale_branch = the_tree.GetBranch("mu17ele8isoPrescale")
        #if not self.mu17ele8isoPrescale_branch and "mu17ele8isoPrescale" not in self.complained:
        if not self.mu17ele8isoPrescale_branch and "mu17ele8isoPrescale":
            warnings.warn( "EMuMuMuTree: Expected branch mu17ele8isoPrescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mu17ele8isoPrescale")
        else:
            self.mu17ele8isoPrescale_branch.SetAddress(<void*>&self.mu17ele8isoPrescale_value)

        #print "making mu17mu8Group"
        self.mu17mu8Group_branch = the_tree.GetBranch("mu17mu8Group")
        #if not self.mu17mu8Group_branch and "mu17mu8Group" not in self.complained:
        if not self.mu17mu8Group_branch and "mu17mu8Group":
            warnings.warn( "EMuMuMuTree: Expected branch mu17mu8Group does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mu17mu8Group")
        else:
            self.mu17mu8Group_branch.SetAddress(<void*>&self.mu17mu8Group_value)

        #print "making mu17mu8Pass"
        self.mu17mu8Pass_branch = the_tree.GetBranch("mu17mu8Pass")
        #if not self.mu17mu8Pass_branch and "mu17mu8Pass" not in self.complained:
        if not self.mu17mu8Pass_branch and "mu17mu8Pass":
            warnings.warn( "EMuMuMuTree: Expected branch mu17mu8Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mu17mu8Pass")
        else:
            self.mu17mu8Pass_branch.SetAddress(<void*>&self.mu17mu8Pass_value)

        #print "making mu17mu8Prescale"
        self.mu17mu8Prescale_branch = the_tree.GetBranch("mu17mu8Prescale")
        #if not self.mu17mu8Prescale_branch and "mu17mu8Prescale" not in self.complained:
        if not self.mu17mu8Prescale_branch and "mu17mu8Prescale":
            warnings.warn( "EMuMuMuTree: Expected branch mu17mu8Prescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mu17mu8Prescale")
        else:
            self.mu17mu8Prescale_branch.SetAddress(<void*>&self.mu17mu8Prescale_value)

        #print "making mu8ele17Group"
        self.mu8ele17Group_branch = the_tree.GetBranch("mu8ele17Group")
        #if not self.mu8ele17Group_branch and "mu8ele17Group" not in self.complained:
        if not self.mu8ele17Group_branch and "mu8ele17Group":
            warnings.warn( "EMuMuMuTree: Expected branch mu8ele17Group does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mu8ele17Group")
        else:
            self.mu8ele17Group_branch.SetAddress(<void*>&self.mu8ele17Group_value)

        #print "making mu8ele17Pass"
        self.mu8ele17Pass_branch = the_tree.GetBranch("mu8ele17Pass")
        #if not self.mu8ele17Pass_branch and "mu8ele17Pass" not in self.complained:
        if not self.mu8ele17Pass_branch and "mu8ele17Pass":
            warnings.warn( "EMuMuMuTree: Expected branch mu8ele17Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mu8ele17Pass")
        else:
            self.mu8ele17Pass_branch.SetAddress(<void*>&self.mu8ele17Pass_value)

        #print "making mu8ele17Prescale"
        self.mu8ele17Prescale_branch = the_tree.GetBranch("mu8ele17Prescale")
        #if not self.mu8ele17Prescale_branch and "mu8ele17Prescale" not in self.complained:
        if not self.mu8ele17Prescale_branch and "mu8ele17Prescale":
            warnings.warn( "EMuMuMuTree: Expected branch mu8ele17Prescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mu8ele17Prescale")
        else:
            self.mu8ele17Prescale_branch.SetAddress(<void*>&self.mu8ele17Prescale_value)

        #print "making mu8ele17isoGroup"
        self.mu8ele17isoGroup_branch = the_tree.GetBranch("mu8ele17isoGroup")
        #if not self.mu8ele17isoGroup_branch and "mu8ele17isoGroup" not in self.complained:
        if not self.mu8ele17isoGroup_branch and "mu8ele17isoGroup":
            warnings.warn( "EMuMuMuTree: Expected branch mu8ele17isoGroup does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mu8ele17isoGroup")
        else:
            self.mu8ele17isoGroup_branch.SetAddress(<void*>&self.mu8ele17isoGroup_value)

        #print "making mu8ele17isoPass"
        self.mu8ele17isoPass_branch = the_tree.GetBranch("mu8ele17isoPass")
        #if not self.mu8ele17isoPass_branch and "mu8ele17isoPass" not in self.complained:
        if not self.mu8ele17isoPass_branch and "mu8ele17isoPass":
            warnings.warn( "EMuMuMuTree: Expected branch mu8ele17isoPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mu8ele17isoPass")
        else:
            self.mu8ele17isoPass_branch.SetAddress(<void*>&self.mu8ele17isoPass_value)

        #print "making mu8ele17isoPrescale"
        self.mu8ele17isoPrescale_branch = the_tree.GetBranch("mu8ele17isoPrescale")
        #if not self.mu8ele17isoPrescale_branch and "mu8ele17isoPrescale" not in self.complained:
        if not self.mu8ele17isoPrescale_branch and "mu8ele17isoPrescale":
            warnings.warn( "EMuMuMuTree: Expected branch mu8ele17isoPrescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mu8ele17isoPrescale")
        else:
            self.mu8ele17isoPrescale_branch.SetAddress(<void*>&self.mu8ele17isoPrescale_value)

        #print "making muGlbIsoVetoPt10"
        self.muGlbIsoVetoPt10_branch = the_tree.GetBranch("muGlbIsoVetoPt10")
        #if not self.muGlbIsoVetoPt10_branch and "muGlbIsoVetoPt10" not in self.complained:
        if not self.muGlbIsoVetoPt10_branch and "muGlbIsoVetoPt10":
            warnings.warn( "EMuMuMuTree: Expected branch muGlbIsoVetoPt10 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("muGlbIsoVetoPt10")
        else:
            self.muGlbIsoVetoPt10_branch.SetAddress(<void*>&self.muGlbIsoVetoPt10_value)

        #print "making muTauGroup"
        self.muTauGroup_branch = the_tree.GetBranch("muTauGroup")
        #if not self.muTauGroup_branch and "muTauGroup" not in self.complained:
        if not self.muTauGroup_branch and "muTauGroup":
            warnings.warn( "EMuMuMuTree: Expected branch muTauGroup does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("muTauGroup")
        else:
            self.muTauGroup_branch.SetAddress(<void*>&self.muTauGroup_value)

        #print "making muTauPass"
        self.muTauPass_branch = the_tree.GetBranch("muTauPass")
        #if not self.muTauPass_branch and "muTauPass" not in self.complained:
        if not self.muTauPass_branch and "muTauPass":
            warnings.warn( "EMuMuMuTree: Expected branch muTauPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("muTauPass")
        else:
            self.muTauPass_branch.SetAddress(<void*>&self.muTauPass_value)

        #print "making muTauPrescale"
        self.muTauPrescale_branch = the_tree.GetBranch("muTauPrescale")
        #if not self.muTauPrescale_branch and "muTauPrescale" not in self.complained:
        if not self.muTauPrescale_branch and "muTauPrescale":
            warnings.warn( "EMuMuMuTree: Expected branch muTauPrescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("muTauPrescale")
        else:
            self.muTauPrescale_branch.SetAddress(<void*>&self.muTauPrescale_value)

        #print "making muTauTestGroup"
        self.muTauTestGroup_branch = the_tree.GetBranch("muTauTestGroup")
        #if not self.muTauTestGroup_branch and "muTauTestGroup" not in self.complained:
        if not self.muTauTestGroup_branch and "muTauTestGroup":
            warnings.warn( "EMuMuMuTree: Expected branch muTauTestGroup does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("muTauTestGroup")
        else:
            self.muTauTestGroup_branch.SetAddress(<void*>&self.muTauTestGroup_value)

        #print "making muTauTestPass"
        self.muTauTestPass_branch = the_tree.GetBranch("muTauTestPass")
        #if not self.muTauTestPass_branch and "muTauTestPass" not in self.complained:
        if not self.muTauTestPass_branch and "muTauTestPass":
            warnings.warn( "EMuMuMuTree: Expected branch muTauTestPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("muTauTestPass")
        else:
            self.muTauTestPass_branch.SetAddress(<void*>&self.muTauTestPass_value)

        #print "making muTauTestPrescale"
        self.muTauTestPrescale_branch = the_tree.GetBranch("muTauTestPrescale")
        #if not self.muTauTestPrescale_branch and "muTauTestPrescale" not in self.complained:
        if not self.muTauTestPrescale_branch and "muTauTestPrescale":
            warnings.warn( "EMuMuMuTree: Expected branch muTauTestPrescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("muTauTestPrescale")
        else:
            self.muTauTestPrescale_branch.SetAddress(<void*>&self.muTauTestPrescale_value)

        #print "making muTightCountZH"
        self.muTightCountZH_branch = the_tree.GetBranch("muTightCountZH")
        #if not self.muTightCountZH_branch and "muTightCountZH" not in self.complained:
        if not self.muTightCountZH_branch and "muTightCountZH":
            warnings.warn( "EMuMuMuTree: Expected branch muTightCountZH does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("muTightCountZH")
        else:
            self.muTightCountZH_branch.SetAddress(<void*>&self.muTightCountZH_value)

        #print "making muVetoPt15IsoIdVtx"
        self.muVetoPt15IsoIdVtx_branch = the_tree.GetBranch("muVetoPt15IsoIdVtx")
        #if not self.muVetoPt15IsoIdVtx_branch and "muVetoPt15IsoIdVtx" not in self.complained:
        if not self.muVetoPt15IsoIdVtx_branch and "muVetoPt15IsoIdVtx":
            warnings.warn( "EMuMuMuTree: Expected branch muVetoPt15IsoIdVtx does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("muVetoPt15IsoIdVtx")
        else:
            self.muVetoPt15IsoIdVtx_branch.SetAddress(<void*>&self.muVetoPt15IsoIdVtx_value)

        #print "making muVetoPt5"
        self.muVetoPt5_branch = the_tree.GetBranch("muVetoPt5")
        #if not self.muVetoPt5_branch and "muVetoPt5" not in self.complained:
        if not self.muVetoPt5_branch and "muVetoPt5":
            warnings.warn( "EMuMuMuTree: Expected branch muVetoPt5 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("muVetoPt5")
        else:
            self.muVetoPt5_branch.SetAddress(<void*>&self.muVetoPt5_value)

        #print "making muVetoPt5IsoIdVtx"
        self.muVetoPt5IsoIdVtx_branch = the_tree.GetBranch("muVetoPt5IsoIdVtx")
        #if not self.muVetoPt5IsoIdVtx_branch and "muVetoPt5IsoIdVtx" not in self.complained:
        if not self.muVetoPt5IsoIdVtx_branch and "muVetoPt5IsoIdVtx":
            warnings.warn( "EMuMuMuTree: Expected branch muVetoPt5IsoIdVtx does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("muVetoPt5IsoIdVtx")
        else:
            self.muVetoPt5IsoIdVtx_branch.SetAddress(<void*>&self.muVetoPt5IsoIdVtx_value)

        #print "making muVetoZH"
        self.muVetoZH_branch = the_tree.GetBranch("muVetoZH")
        #if not self.muVetoZH_branch and "muVetoZH" not in self.complained:
        if not self.muVetoZH_branch and "muVetoZH":
            warnings.warn( "EMuMuMuTree: Expected branch muVetoZH does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("muVetoZH")
        else:
            self.muVetoZH_branch.SetAddress(<void*>&self.muVetoZH_value)

        #print "making mva_metEt"
        self.mva_metEt_branch = the_tree.GetBranch("mva_metEt")
        #if not self.mva_metEt_branch and "mva_metEt" not in self.complained:
        if not self.mva_metEt_branch and "mva_metEt":
            warnings.warn( "EMuMuMuTree: Expected branch mva_metEt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mva_metEt")
        else:
            self.mva_metEt_branch.SetAddress(<void*>&self.mva_metEt_value)

        #print "making mva_metPhi"
        self.mva_metPhi_branch = the_tree.GetBranch("mva_metPhi")
        #if not self.mva_metPhi_branch and "mva_metPhi" not in self.complained:
        if not self.mva_metPhi_branch and "mva_metPhi":
            warnings.warn( "EMuMuMuTree: Expected branch mva_metPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mva_metPhi")
        else:
            self.mva_metPhi_branch.SetAddress(<void*>&self.mva_metPhi_value)

        #print "making nTruePU"
        self.nTruePU_branch = the_tree.GetBranch("nTruePU")
        #if not self.nTruePU_branch and "nTruePU" not in self.complained:
        if not self.nTruePU_branch and "nTruePU":
            warnings.warn( "EMuMuMuTree: Expected branch nTruePU does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("nTruePU")
        else:
            self.nTruePU_branch.SetAddress(<void*>&self.nTruePU_value)

        #print "making nvtx"
        self.nvtx_branch = the_tree.GetBranch("nvtx")
        #if not self.nvtx_branch and "nvtx" not in self.complained:
        if not self.nvtx_branch and "nvtx":
            warnings.warn( "EMuMuMuTree: Expected branch nvtx does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("nvtx")
        else:
            self.nvtx_branch.SetAddress(<void*>&self.nvtx_value)

        #print "making pfMetEt"
        self.pfMetEt_branch = the_tree.GetBranch("pfMetEt")
        #if not self.pfMetEt_branch and "pfMetEt" not in self.complained:
        if not self.pfMetEt_branch and "pfMetEt":
            warnings.warn( "EMuMuMuTree: Expected branch pfMetEt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pfMetEt")
        else:
            self.pfMetEt_branch.SetAddress(<void*>&self.pfMetEt_value)

        #print "making pfMetPhi"
        self.pfMetPhi_branch = the_tree.GetBranch("pfMetPhi")
        #if not self.pfMetPhi_branch and "pfMetPhi" not in self.complained:
        if not self.pfMetPhi_branch and "pfMetPhi":
            warnings.warn( "EMuMuMuTree: Expected branch pfMetPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pfMetPhi")
        else:
            self.pfMetPhi_branch.SetAddress(<void*>&self.pfMetPhi_value)

        #print "making pfMet_jes_Et"
        self.pfMet_jes_Et_branch = the_tree.GetBranch("pfMet_jes_Et")
        #if not self.pfMet_jes_Et_branch and "pfMet_jes_Et" not in self.complained:
        if not self.pfMet_jes_Et_branch and "pfMet_jes_Et":
            warnings.warn( "EMuMuMuTree: Expected branch pfMet_jes_Et does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pfMet_jes_Et")
        else:
            self.pfMet_jes_Et_branch.SetAddress(<void*>&self.pfMet_jes_Et_value)

        #print "making pfMet_jes_Phi"
        self.pfMet_jes_Phi_branch = the_tree.GetBranch("pfMet_jes_Phi")
        #if not self.pfMet_jes_Phi_branch and "pfMet_jes_Phi" not in self.complained:
        if not self.pfMet_jes_Phi_branch and "pfMet_jes_Phi":
            warnings.warn( "EMuMuMuTree: Expected branch pfMet_jes_Phi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pfMet_jes_Phi")
        else:
            self.pfMet_jes_Phi_branch.SetAddress(<void*>&self.pfMet_jes_Phi_value)

        #print "making pfMet_mes_Et"
        self.pfMet_mes_Et_branch = the_tree.GetBranch("pfMet_mes_Et")
        #if not self.pfMet_mes_Et_branch and "pfMet_mes_Et" not in self.complained:
        if not self.pfMet_mes_Et_branch and "pfMet_mes_Et":
            warnings.warn( "EMuMuMuTree: Expected branch pfMet_mes_Et does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pfMet_mes_Et")
        else:
            self.pfMet_mes_Et_branch.SetAddress(<void*>&self.pfMet_mes_Et_value)

        #print "making pfMet_mes_Phi"
        self.pfMet_mes_Phi_branch = the_tree.GetBranch("pfMet_mes_Phi")
        #if not self.pfMet_mes_Phi_branch and "pfMet_mes_Phi" not in self.complained:
        if not self.pfMet_mes_Phi_branch and "pfMet_mes_Phi":
            warnings.warn( "EMuMuMuTree: Expected branch pfMet_mes_Phi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pfMet_mes_Phi")
        else:
            self.pfMet_mes_Phi_branch.SetAddress(<void*>&self.pfMet_mes_Phi_value)

        #print "making pfMet_tes_Et"
        self.pfMet_tes_Et_branch = the_tree.GetBranch("pfMet_tes_Et")
        #if not self.pfMet_tes_Et_branch and "pfMet_tes_Et" not in self.complained:
        if not self.pfMet_tes_Et_branch and "pfMet_tes_Et":
            warnings.warn( "EMuMuMuTree: Expected branch pfMet_tes_Et does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pfMet_tes_Et")
        else:
            self.pfMet_tes_Et_branch.SetAddress(<void*>&self.pfMet_tes_Et_value)

        #print "making pfMet_tes_Phi"
        self.pfMet_tes_Phi_branch = the_tree.GetBranch("pfMet_tes_Phi")
        #if not self.pfMet_tes_Phi_branch and "pfMet_tes_Phi" not in self.complained:
        if not self.pfMet_tes_Phi_branch and "pfMet_tes_Phi":
            warnings.warn( "EMuMuMuTree: Expected branch pfMet_tes_Phi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pfMet_tes_Phi")
        else:
            self.pfMet_tes_Phi_branch.SetAddress(<void*>&self.pfMet_tes_Phi_value)

        #print "making pfMet_ues_Et"
        self.pfMet_ues_Et_branch = the_tree.GetBranch("pfMet_ues_Et")
        #if not self.pfMet_ues_Et_branch and "pfMet_ues_Et" not in self.complained:
        if not self.pfMet_ues_Et_branch and "pfMet_ues_Et":
            warnings.warn( "EMuMuMuTree: Expected branch pfMet_ues_Et does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pfMet_ues_Et")
        else:
            self.pfMet_ues_Et_branch.SetAddress(<void*>&self.pfMet_ues_Et_value)

        #print "making pfMet_ues_Phi"
        self.pfMet_ues_Phi_branch = the_tree.GetBranch("pfMet_ues_Phi")
        #if not self.pfMet_ues_Phi_branch and "pfMet_ues_Phi" not in self.complained:
        if not self.pfMet_ues_Phi_branch and "pfMet_ues_Phi":
            warnings.warn( "EMuMuMuTree: Expected branch pfMet_ues_Phi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pfMet_ues_Phi")
        else:
            self.pfMet_ues_Phi_branch.SetAddress(<void*>&self.pfMet_ues_Phi_value)

        #print "making processID"
        self.processID_branch = the_tree.GetBranch("processID")
        #if not self.processID_branch and "processID" not in self.complained:
        if not self.processID_branch and "processID":
            warnings.warn( "EMuMuMuTree: Expected branch processID does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("processID")
        else:
            self.processID_branch.SetAddress(<void*>&self.processID_value)

        #print "making pvChi2"
        self.pvChi2_branch = the_tree.GetBranch("pvChi2")
        #if not self.pvChi2_branch and "pvChi2" not in self.complained:
        if not self.pvChi2_branch and "pvChi2":
            warnings.warn( "EMuMuMuTree: Expected branch pvChi2 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pvChi2")
        else:
            self.pvChi2_branch.SetAddress(<void*>&self.pvChi2_value)

        #print "making pvDX"
        self.pvDX_branch = the_tree.GetBranch("pvDX")
        #if not self.pvDX_branch and "pvDX" not in self.complained:
        if not self.pvDX_branch and "pvDX":
            warnings.warn( "EMuMuMuTree: Expected branch pvDX does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pvDX")
        else:
            self.pvDX_branch.SetAddress(<void*>&self.pvDX_value)

        #print "making pvDY"
        self.pvDY_branch = the_tree.GetBranch("pvDY")
        #if not self.pvDY_branch and "pvDY" not in self.complained:
        if not self.pvDY_branch and "pvDY":
            warnings.warn( "EMuMuMuTree: Expected branch pvDY does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pvDY")
        else:
            self.pvDY_branch.SetAddress(<void*>&self.pvDY_value)

        #print "making pvDZ"
        self.pvDZ_branch = the_tree.GetBranch("pvDZ")
        #if not self.pvDZ_branch and "pvDZ" not in self.complained:
        if not self.pvDZ_branch and "pvDZ":
            warnings.warn( "EMuMuMuTree: Expected branch pvDZ does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pvDZ")
        else:
            self.pvDZ_branch.SetAddress(<void*>&self.pvDZ_value)

        #print "making pvIsFake"
        self.pvIsFake_branch = the_tree.GetBranch("pvIsFake")
        #if not self.pvIsFake_branch and "pvIsFake" not in self.complained:
        if not self.pvIsFake_branch and "pvIsFake":
            warnings.warn( "EMuMuMuTree: Expected branch pvIsFake does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pvIsFake")
        else:
            self.pvIsFake_branch.SetAddress(<void*>&self.pvIsFake_value)

        #print "making pvIsValid"
        self.pvIsValid_branch = the_tree.GetBranch("pvIsValid")
        #if not self.pvIsValid_branch and "pvIsValid" not in self.complained:
        if not self.pvIsValid_branch and "pvIsValid":
            warnings.warn( "EMuMuMuTree: Expected branch pvIsValid does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pvIsValid")
        else:
            self.pvIsValid_branch.SetAddress(<void*>&self.pvIsValid_value)

        #print "making pvNormChi2"
        self.pvNormChi2_branch = the_tree.GetBranch("pvNormChi2")
        #if not self.pvNormChi2_branch and "pvNormChi2" not in self.complained:
        if not self.pvNormChi2_branch and "pvNormChi2":
            warnings.warn( "EMuMuMuTree: Expected branch pvNormChi2 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pvNormChi2")
        else:
            self.pvNormChi2_branch.SetAddress(<void*>&self.pvNormChi2_value)

        #print "making pvX"
        self.pvX_branch = the_tree.GetBranch("pvX")
        #if not self.pvX_branch and "pvX" not in self.complained:
        if not self.pvX_branch and "pvX":
            warnings.warn( "EMuMuMuTree: Expected branch pvX does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pvX")
        else:
            self.pvX_branch.SetAddress(<void*>&self.pvX_value)

        #print "making pvY"
        self.pvY_branch = the_tree.GetBranch("pvY")
        #if not self.pvY_branch and "pvY" not in self.complained:
        if not self.pvY_branch and "pvY":
            warnings.warn( "EMuMuMuTree: Expected branch pvY does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pvY")
        else:
            self.pvY_branch.SetAddress(<void*>&self.pvY_value)

        #print "making pvZ"
        self.pvZ_branch = the_tree.GetBranch("pvZ")
        #if not self.pvZ_branch and "pvZ" not in self.complained:
        if not self.pvZ_branch and "pvZ":
            warnings.warn( "EMuMuMuTree: Expected branch pvZ does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pvZ")
        else:
            self.pvZ_branch.SetAddress(<void*>&self.pvZ_value)

        #print "making pvndof"
        self.pvndof_branch = the_tree.GetBranch("pvndof")
        #if not self.pvndof_branch and "pvndof" not in self.complained:
        if not self.pvndof_branch and "pvndof":
            warnings.warn( "EMuMuMuTree: Expected branch pvndof does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pvndof")
        else:
            self.pvndof_branch.SetAddress(<void*>&self.pvndof_value)

        #print "making recoilDaught"
        self.recoilDaught_branch = the_tree.GetBranch("recoilDaught")
        #if not self.recoilDaught_branch and "recoilDaught" not in self.complained:
        if not self.recoilDaught_branch and "recoilDaught":
            warnings.warn( "EMuMuMuTree: Expected branch recoilDaught does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("recoilDaught")
        else:
            self.recoilDaught_branch.SetAddress(<void*>&self.recoilDaught_value)

        #print "making recoilWithMet"
        self.recoilWithMet_branch = the_tree.GetBranch("recoilWithMet")
        #if not self.recoilWithMet_branch and "recoilWithMet" not in self.complained:
        if not self.recoilWithMet_branch and "recoilWithMet":
            warnings.warn( "EMuMuMuTree: Expected branch recoilWithMet does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("recoilWithMet")
        else:
            self.recoilWithMet_branch.SetAddress(<void*>&self.recoilWithMet_value)

        #print "making rho"
        self.rho_branch = the_tree.GetBranch("rho")
        #if not self.rho_branch and "rho" not in self.complained:
        if not self.rho_branch and "rho":
            warnings.warn( "EMuMuMuTree: Expected branch rho does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("rho")
        else:
            self.rho_branch.SetAddress(<void*>&self.rho_value)

        #print "making run"
        self.run_branch = the_tree.GetBranch("run")
        #if not self.run_branch and "run" not in self.complained:
        if not self.run_branch and "run":
            warnings.warn( "EMuMuMuTree: Expected branch run does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("run")
        else:
            self.run_branch.SetAddress(<void*>&self.run_value)

        #print "making singleEGroup"
        self.singleEGroup_branch = the_tree.GetBranch("singleEGroup")
        #if not self.singleEGroup_branch and "singleEGroup" not in self.complained:
        if not self.singleEGroup_branch and "singleEGroup":
            warnings.warn( "EMuMuMuTree: Expected branch singleEGroup does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleEGroup")
        else:
            self.singleEGroup_branch.SetAddress(<void*>&self.singleEGroup_value)

        #print "making singleEPFMTGroup"
        self.singleEPFMTGroup_branch = the_tree.GetBranch("singleEPFMTGroup")
        #if not self.singleEPFMTGroup_branch and "singleEPFMTGroup" not in self.complained:
        if not self.singleEPFMTGroup_branch and "singleEPFMTGroup":
            warnings.warn( "EMuMuMuTree: Expected branch singleEPFMTGroup does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleEPFMTGroup")
        else:
            self.singleEPFMTGroup_branch.SetAddress(<void*>&self.singleEPFMTGroup_value)

        #print "making singleEPFMTPass"
        self.singleEPFMTPass_branch = the_tree.GetBranch("singleEPFMTPass")
        #if not self.singleEPFMTPass_branch and "singleEPFMTPass" not in self.complained:
        if not self.singleEPFMTPass_branch and "singleEPFMTPass":
            warnings.warn( "EMuMuMuTree: Expected branch singleEPFMTPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleEPFMTPass")
        else:
            self.singleEPFMTPass_branch.SetAddress(<void*>&self.singleEPFMTPass_value)

        #print "making singleEPFMTPrescale"
        self.singleEPFMTPrescale_branch = the_tree.GetBranch("singleEPFMTPrescale")
        #if not self.singleEPFMTPrescale_branch and "singleEPFMTPrescale" not in self.complained:
        if not self.singleEPFMTPrescale_branch and "singleEPFMTPrescale":
            warnings.warn( "EMuMuMuTree: Expected branch singleEPFMTPrescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleEPFMTPrescale")
        else:
            self.singleEPFMTPrescale_branch.SetAddress(<void*>&self.singleEPFMTPrescale_value)

        #print "making singleEPass"
        self.singleEPass_branch = the_tree.GetBranch("singleEPass")
        #if not self.singleEPass_branch and "singleEPass" not in self.complained:
        if not self.singleEPass_branch and "singleEPass":
            warnings.warn( "EMuMuMuTree: Expected branch singleEPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleEPass")
        else:
            self.singleEPass_branch.SetAddress(<void*>&self.singleEPass_value)

        #print "making singleEPrescale"
        self.singleEPrescale_branch = the_tree.GetBranch("singleEPrescale")
        #if not self.singleEPrescale_branch and "singleEPrescale" not in self.complained:
        if not self.singleEPrescale_branch and "singleEPrescale":
            warnings.warn( "EMuMuMuTree: Expected branch singleEPrescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleEPrescale")
        else:
            self.singleEPrescale_branch.SetAddress(<void*>&self.singleEPrescale_value)

        #print "making singleMuGroup"
        self.singleMuGroup_branch = the_tree.GetBranch("singleMuGroup")
        #if not self.singleMuGroup_branch and "singleMuGroup" not in self.complained:
        if not self.singleMuGroup_branch and "singleMuGroup":
            warnings.warn( "EMuMuMuTree: Expected branch singleMuGroup does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleMuGroup")
        else:
            self.singleMuGroup_branch.SetAddress(<void*>&self.singleMuGroup_value)

        #print "making singleMuPass"
        self.singleMuPass_branch = the_tree.GetBranch("singleMuPass")
        #if not self.singleMuPass_branch and "singleMuPass" not in self.complained:
        if not self.singleMuPass_branch and "singleMuPass":
            warnings.warn( "EMuMuMuTree: Expected branch singleMuPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleMuPass")
        else:
            self.singleMuPass_branch.SetAddress(<void*>&self.singleMuPass_value)

        #print "making singleMuPrescale"
        self.singleMuPrescale_branch = the_tree.GetBranch("singleMuPrescale")
        #if not self.singleMuPrescale_branch and "singleMuPrescale" not in self.complained:
        if not self.singleMuPrescale_branch and "singleMuPrescale":
            warnings.warn( "EMuMuMuTree: Expected branch singleMuPrescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleMuPrescale")
        else:
            self.singleMuPrescale_branch.SetAddress(<void*>&self.singleMuPrescale_value)

        #print "making singlePhoGroup"
        self.singlePhoGroup_branch = the_tree.GetBranch("singlePhoGroup")
        #if not self.singlePhoGroup_branch and "singlePhoGroup" not in self.complained:
        if not self.singlePhoGroup_branch and "singlePhoGroup":
            warnings.warn( "EMuMuMuTree: Expected branch singlePhoGroup does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singlePhoGroup")
        else:
            self.singlePhoGroup_branch.SetAddress(<void*>&self.singlePhoGroup_value)

        #print "making singlePhoPass"
        self.singlePhoPass_branch = the_tree.GetBranch("singlePhoPass")
        #if not self.singlePhoPass_branch and "singlePhoPass" not in self.complained:
        if not self.singlePhoPass_branch and "singlePhoPass":
            warnings.warn( "EMuMuMuTree: Expected branch singlePhoPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singlePhoPass")
        else:
            self.singlePhoPass_branch.SetAddress(<void*>&self.singlePhoPass_value)

        #print "making singlePhoPrescale"
        self.singlePhoPrescale_branch = the_tree.GetBranch("singlePhoPrescale")
        #if not self.singlePhoPrescale_branch and "singlePhoPrescale" not in self.complained:
        if not self.singlePhoPrescale_branch and "singlePhoPrescale":
            warnings.warn( "EMuMuMuTree: Expected branch singlePhoPrescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singlePhoPrescale")
        else:
            self.singlePhoPrescale_branch.SetAddress(<void*>&self.singlePhoPrescale_value)

        #print "making tauHpsVetoPt20"
        self.tauHpsVetoPt20_branch = the_tree.GetBranch("tauHpsVetoPt20")
        #if not self.tauHpsVetoPt20_branch and "tauHpsVetoPt20" not in self.complained:
        if not self.tauHpsVetoPt20_branch and "tauHpsVetoPt20":
            warnings.warn( "EMuMuMuTree: Expected branch tauHpsVetoPt20 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tauHpsVetoPt20")
        else:
            self.tauHpsVetoPt20_branch.SetAddress(<void*>&self.tauHpsVetoPt20_value)

        #print "making tauTightCountZH"
        self.tauTightCountZH_branch = the_tree.GetBranch("tauTightCountZH")
        #if not self.tauTightCountZH_branch and "tauTightCountZH" not in self.complained:
        if not self.tauTightCountZH_branch and "tauTightCountZH":
            warnings.warn( "EMuMuMuTree: Expected branch tauTightCountZH does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tauTightCountZH")
        else:
            self.tauTightCountZH_branch.SetAddress(<void*>&self.tauTightCountZH_value)

        #print "making tauVetoPt20"
        self.tauVetoPt20_branch = the_tree.GetBranch("tauVetoPt20")
        #if not self.tauVetoPt20_branch and "tauVetoPt20" not in self.complained:
        if not self.tauVetoPt20_branch and "tauVetoPt20":
            warnings.warn( "EMuMuMuTree: Expected branch tauVetoPt20 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tauVetoPt20")
        else:
            self.tauVetoPt20_branch.SetAddress(<void*>&self.tauVetoPt20_value)

        #print "making tauVetoPt20Loose3HitsVtx"
        self.tauVetoPt20Loose3HitsVtx_branch = the_tree.GetBranch("tauVetoPt20Loose3HitsVtx")
        #if not self.tauVetoPt20Loose3HitsVtx_branch and "tauVetoPt20Loose3HitsVtx" not in self.complained:
        if not self.tauVetoPt20Loose3HitsVtx_branch and "tauVetoPt20Loose3HitsVtx":
            warnings.warn( "EMuMuMuTree: Expected branch tauVetoPt20Loose3HitsVtx does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tauVetoPt20Loose3HitsVtx")
        else:
            self.tauVetoPt20Loose3HitsVtx_branch.SetAddress(<void*>&self.tauVetoPt20Loose3HitsVtx_value)

        #print "making tauVetoPt20LooseMVA2Vtx"
        self.tauVetoPt20LooseMVA2Vtx_branch = the_tree.GetBranch("tauVetoPt20LooseMVA2Vtx")
        #if not self.tauVetoPt20LooseMVA2Vtx_branch and "tauVetoPt20LooseMVA2Vtx" not in self.complained:
        if not self.tauVetoPt20LooseMVA2Vtx_branch and "tauVetoPt20LooseMVA2Vtx":
            warnings.warn( "EMuMuMuTree: Expected branch tauVetoPt20LooseMVA2Vtx does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tauVetoPt20LooseMVA2Vtx")
        else:
            self.tauVetoPt20LooseMVA2Vtx_branch.SetAddress(<void*>&self.tauVetoPt20LooseMVA2Vtx_value)

        #print "making tauVetoPt20LooseMVAVtx"
        self.tauVetoPt20LooseMVAVtx_branch = the_tree.GetBranch("tauVetoPt20LooseMVAVtx")
        #if not self.tauVetoPt20LooseMVAVtx_branch and "tauVetoPt20LooseMVAVtx" not in self.complained:
        if not self.tauVetoPt20LooseMVAVtx_branch and "tauVetoPt20LooseMVAVtx":
            warnings.warn( "EMuMuMuTree: Expected branch tauVetoPt20LooseMVAVtx does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tauVetoPt20LooseMVAVtx")
        else:
            self.tauVetoPt20LooseMVAVtx_branch.SetAddress(<void*>&self.tauVetoPt20LooseMVAVtx_value)

        #print "making tauVetoPt20VLooseHPSVtx"
        self.tauVetoPt20VLooseHPSVtx_branch = the_tree.GetBranch("tauVetoPt20VLooseHPSVtx")
        #if not self.tauVetoPt20VLooseHPSVtx_branch and "tauVetoPt20VLooseHPSVtx" not in self.complained:
        if not self.tauVetoPt20VLooseHPSVtx_branch and "tauVetoPt20VLooseHPSVtx":
            warnings.warn( "EMuMuMuTree: Expected branch tauVetoPt20VLooseHPSVtx does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tauVetoPt20VLooseHPSVtx")
        else:
            self.tauVetoPt20VLooseHPSVtx_branch.SetAddress(<void*>&self.tauVetoPt20VLooseHPSVtx_value)

        #print "making tauVetoZH"
        self.tauVetoZH_branch = the_tree.GetBranch("tauVetoZH")
        #if not self.tauVetoZH_branch and "tauVetoZH" not in self.complained:
        if not self.tauVetoZH_branch and "tauVetoZH":
            warnings.warn( "EMuMuMuTree: Expected branch tauVetoZH does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tauVetoZH")
        else:
            self.tauVetoZH_branch.SetAddress(<void*>&self.tauVetoZH_value)

        #print "making type1_pfMetEt"
        self.type1_pfMetEt_branch = the_tree.GetBranch("type1_pfMetEt")
        #if not self.type1_pfMetEt_branch and "type1_pfMetEt" not in self.complained:
        if not self.type1_pfMetEt_branch and "type1_pfMetEt":
            warnings.warn( "EMuMuMuTree: Expected branch type1_pfMetEt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMetEt")
        else:
            self.type1_pfMetEt_branch.SetAddress(<void*>&self.type1_pfMetEt_value)

        #print "making type1_pfMetPhi"
        self.type1_pfMetPhi_branch = the_tree.GetBranch("type1_pfMetPhi")
        #if not self.type1_pfMetPhi_branch and "type1_pfMetPhi" not in self.complained:
        if not self.type1_pfMetPhi_branch and "type1_pfMetPhi":
            warnings.warn( "EMuMuMuTree: Expected branch type1_pfMetPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMetPhi")
        else:
            self.type1_pfMetPhi_branch.SetAddress(<void*>&self.type1_pfMetPhi_value)

        #print "making idx"
        self.idx_branch = the_tree.GetBranch("idx")
        #if not self.idx_branch and "idx" not in self.complained:
        if not self.idx_branch and "idx":
            warnings.warn( "EMuMuMuTree: Expected branch idx does not exist!"                " It will crash if you try and use it!",Warning)
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

    property e_m3_CosThetaStar:
        def __get__(self):
            self.e_m3_CosThetaStar_branch.GetEntry(self.localentry, 0)
            return self.e_m3_CosThetaStar_value

    property e_m3_DPhi:
        def __get__(self):
            self.e_m3_DPhi_branch.GetEntry(self.localentry, 0)
            return self.e_m3_DPhi_value

    property e_m3_DR:
        def __get__(self):
            self.e_m3_DR_branch.GetEntry(self.localentry, 0)
            return self.e_m3_DR_value

    property e_m3_Eta:
        def __get__(self):
            self.e_m3_Eta_branch.GetEntry(self.localentry, 0)
            return self.e_m3_Eta_value

    property e_m3_Mass:
        def __get__(self):
            self.e_m3_Mass_branch.GetEntry(self.localentry, 0)
            return self.e_m3_Mass_value

    property e_m3_MassFsr:
        def __get__(self):
            self.e_m3_MassFsr_branch.GetEntry(self.localentry, 0)
            return self.e_m3_MassFsr_value

    property e_m3_PZeta:
        def __get__(self):
            self.e_m3_PZeta_branch.GetEntry(self.localentry, 0)
            return self.e_m3_PZeta_value

    property e_m3_PZetaVis:
        def __get__(self):
            self.e_m3_PZetaVis_branch.GetEntry(self.localentry, 0)
            return self.e_m3_PZetaVis_value

    property e_m3_Phi:
        def __get__(self):
            self.e_m3_Phi_branch.GetEntry(self.localentry, 0)
            return self.e_m3_Phi_value

    property e_m3_Pt:
        def __get__(self):
            self.e_m3_Pt_branch.GetEntry(self.localentry, 0)
            return self.e_m3_Pt_value

    property e_m3_PtFsr:
        def __get__(self):
            self.e_m3_PtFsr_branch.GetEntry(self.localentry, 0)
            return self.e_m3_PtFsr_value

    property e_m3_SS:
        def __get__(self):
            self.e_m3_SS_branch.GetEntry(self.localentry, 0)
            return self.e_m3_SS_value

    property e_m3_SVfitEta:
        def __get__(self):
            self.e_m3_SVfitEta_branch.GetEntry(self.localentry, 0)
            return self.e_m3_SVfitEta_value

    property e_m3_SVfitMass:
        def __get__(self):
            self.e_m3_SVfitMass_branch.GetEntry(self.localentry, 0)
            return self.e_m3_SVfitMass_value

    property e_m3_SVfitPhi:
        def __get__(self):
            self.e_m3_SVfitPhi_branch.GetEntry(self.localentry, 0)
            return self.e_m3_SVfitPhi_value

    property e_m3_SVfitPt:
        def __get__(self):
            self.e_m3_SVfitPt_branch.GetEntry(self.localentry, 0)
            return self.e_m3_SVfitPt_value

    property e_m3_ToMETDPhi_Ty1:
        def __get__(self):
            self.e_m3_ToMETDPhi_Ty1_branch.GetEntry(self.localentry, 0)
            return self.e_m3_ToMETDPhi_Ty1_value

    property e_m3_Zcompat:
        def __get__(self):
            self.e_m3_Zcompat_branch.GetEntry(self.localentry, 0)
            return self.e_m3_Zcompat_value

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


