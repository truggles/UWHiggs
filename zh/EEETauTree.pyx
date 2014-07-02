

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

cdef class EEETauTree:
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

    cdef TBranch* e1AbsEta_branch
    cdef float e1AbsEta_value

    cdef TBranch* e1CBID_LOOSE_branch
    cdef float e1CBID_LOOSE_value

    cdef TBranch* e1CBID_MEDIUM_branch
    cdef float e1CBID_MEDIUM_value

    cdef TBranch* e1CBID_TIGHT_branch
    cdef float e1CBID_TIGHT_value

    cdef TBranch* e1CBID_VETO_branch
    cdef float e1CBID_VETO_value

    cdef TBranch* e1Charge_branch
    cdef float e1Charge_value

    cdef TBranch* e1ChargeIdLoose_branch
    cdef float e1ChargeIdLoose_value

    cdef TBranch* e1ChargeIdMed_branch
    cdef float e1ChargeIdMed_value

    cdef TBranch* e1ChargeIdTight_branch
    cdef float e1ChargeIdTight_value

    cdef TBranch* e1CiCTight_branch
    cdef float e1CiCTight_value

    cdef TBranch* e1CiCTightElecOverlap_branch
    cdef float e1CiCTightElecOverlap_value

    cdef TBranch* e1ComesFromHiggs_branch
    cdef float e1ComesFromHiggs_value

    cdef TBranch* e1DZ_branch
    cdef float e1DZ_value

    cdef TBranch* e1E1x5_branch
    cdef float e1E1x5_value

    cdef TBranch* e1E2x5Max_branch
    cdef float e1E2x5Max_value

    cdef TBranch* e1E5x5_branch
    cdef float e1E5x5_value

    cdef TBranch* e1ECorrReg_2012Jul13ReReco_branch
    cdef float e1ECorrReg_2012Jul13ReReco_value

    cdef TBranch* e1ECorrReg_Fall11_branch
    cdef float e1ECorrReg_Fall11_value

    cdef TBranch* e1ECorrReg_Jan16ReReco_branch
    cdef float e1ECorrReg_Jan16ReReco_value

    cdef TBranch* e1ECorrReg_Summer12_DR53X_HCP2012_branch
    cdef float e1ECorrReg_Summer12_DR53X_HCP2012_value

    cdef TBranch* e1ECorrSmearedNoReg_2012Jul13ReReco_branch
    cdef float e1ECorrSmearedNoReg_2012Jul13ReReco_value

    cdef TBranch* e1ECorrSmearedNoReg_Fall11_branch
    cdef float e1ECorrSmearedNoReg_Fall11_value

    cdef TBranch* e1ECorrSmearedNoReg_Jan16ReReco_branch
    cdef float e1ECorrSmearedNoReg_Jan16ReReco_value

    cdef TBranch* e1ECorrSmearedNoReg_Summer12_DR53X_HCP2012_branch
    cdef float e1ECorrSmearedNoReg_Summer12_DR53X_HCP2012_value

    cdef TBranch* e1ECorrSmearedReg_2012Jul13ReReco_branch
    cdef float e1ECorrSmearedReg_2012Jul13ReReco_value

    cdef TBranch* e1ECorrSmearedReg_Fall11_branch
    cdef float e1ECorrSmearedReg_Fall11_value

    cdef TBranch* e1ECorrSmearedReg_Jan16ReReco_branch
    cdef float e1ECorrSmearedReg_Jan16ReReco_value

    cdef TBranch* e1ECorrSmearedReg_Summer12_DR53X_HCP2012_branch
    cdef float e1ECorrSmearedReg_Summer12_DR53X_HCP2012_value

    cdef TBranch* e1EcalIsoDR03_branch
    cdef float e1EcalIsoDR03_value

    cdef TBranch* e1EffectiveArea2011Data_branch
    cdef float e1EffectiveArea2011Data_value

    cdef TBranch* e1EffectiveArea2012Data_branch
    cdef float e1EffectiveArea2012Data_value

    cdef TBranch* e1EffectiveAreaFall11MC_branch
    cdef float e1EffectiveAreaFall11MC_value

    cdef TBranch* e1Ele27WP80PFMT50PFMTFilter_branch
    cdef float e1Ele27WP80PFMT50PFMTFilter_value

    cdef TBranch* e1Ele27WP80TrackIsoMatchFilter_branch
    cdef float e1Ele27WP80TrackIsoMatchFilter_value

    cdef TBranch* e1Ele32WP70PFMT50PFMTFilter_branch
    cdef float e1Ele32WP70PFMT50PFMTFilter_value

    cdef TBranch* e1ElecOverlap_branch
    cdef float e1ElecOverlap_value

    cdef TBranch* e1ElecOverlapZHLoose_branch
    cdef float e1ElecOverlapZHLoose_value

    cdef TBranch* e1ElecOverlapZHTight_branch
    cdef float e1ElecOverlapZHTight_value

    cdef TBranch* e1EnergyError_branch
    cdef float e1EnergyError_value

    cdef TBranch* e1Eta_branch
    cdef float e1Eta_value

    cdef TBranch* e1EtaCorrReg_2012Jul13ReReco_branch
    cdef float e1EtaCorrReg_2012Jul13ReReco_value

    cdef TBranch* e1EtaCorrReg_Fall11_branch
    cdef float e1EtaCorrReg_Fall11_value

    cdef TBranch* e1EtaCorrReg_Jan16ReReco_branch
    cdef float e1EtaCorrReg_Jan16ReReco_value

    cdef TBranch* e1EtaCorrReg_Summer12_DR53X_HCP2012_branch
    cdef float e1EtaCorrReg_Summer12_DR53X_HCP2012_value

    cdef TBranch* e1EtaCorrSmearedNoReg_2012Jul13ReReco_branch
    cdef float e1EtaCorrSmearedNoReg_2012Jul13ReReco_value

    cdef TBranch* e1EtaCorrSmearedNoReg_Fall11_branch
    cdef float e1EtaCorrSmearedNoReg_Fall11_value

    cdef TBranch* e1EtaCorrSmearedNoReg_Jan16ReReco_branch
    cdef float e1EtaCorrSmearedNoReg_Jan16ReReco_value

    cdef TBranch* e1EtaCorrSmearedNoReg_Summer12_DR53X_HCP2012_branch
    cdef float e1EtaCorrSmearedNoReg_Summer12_DR53X_HCP2012_value

    cdef TBranch* e1EtaCorrSmearedReg_2012Jul13ReReco_branch
    cdef float e1EtaCorrSmearedReg_2012Jul13ReReco_value

    cdef TBranch* e1EtaCorrSmearedReg_Fall11_branch
    cdef float e1EtaCorrSmearedReg_Fall11_value

    cdef TBranch* e1EtaCorrSmearedReg_Jan16ReReco_branch
    cdef float e1EtaCorrSmearedReg_Jan16ReReco_value

    cdef TBranch* e1EtaCorrSmearedReg_Summer12_DR53X_HCP2012_branch
    cdef float e1EtaCorrSmearedReg_Summer12_DR53X_HCP2012_value

    cdef TBranch* e1GenCharge_branch
    cdef float e1GenCharge_value

    cdef TBranch* e1GenEnergy_branch
    cdef float e1GenEnergy_value

    cdef TBranch* e1GenEta_branch
    cdef float e1GenEta_value

    cdef TBranch* e1GenMotherPdgId_branch
    cdef float e1GenMotherPdgId_value

    cdef TBranch* e1GenPdgId_branch
    cdef float e1GenPdgId_value

    cdef TBranch* e1GenPhi_branch
    cdef float e1GenPhi_value

    cdef TBranch* e1HadronicDepth1OverEm_branch
    cdef float e1HadronicDepth1OverEm_value

    cdef TBranch* e1HadronicDepth2OverEm_branch
    cdef float e1HadronicDepth2OverEm_value

    cdef TBranch* e1HadronicOverEM_branch
    cdef float e1HadronicOverEM_value

    cdef TBranch* e1HasConversion_branch
    cdef float e1HasConversion_value

    cdef TBranch* e1HasMatchedConversion_branch
    cdef int e1HasMatchedConversion_value

    cdef TBranch* e1HcalIsoDR03_branch
    cdef float e1HcalIsoDR03_value

    cdef TBranch* e1IP3DS_branch
    cdef float e1IP3DS_value

    cdef TBranch* e1JetArea_branch
    cdef float e1JetArea_value

    cdef TBranch* e1JetBtag_branch
    cdef float e1JetBtag_value

    cdef TBranch* e1JetCSVBtag_branch
    cdef float e1JetCSVBtag_value

    cdef TBranch* e1JetEtaEtaMoment_branch
    cdef float e1JetEtaEtaMoment_value

    cdef TBranch* e1JetEtaPhiMoment_branch
    cdef float e1JetEtaPhiMoment_value

    cdef TBranch* e1JetEtaPhiSpread_branch
    cdef float e1JetEtaPhiSpread_value

    cdef TBranch* e1JetPartonFlavour_branch
    cdef float e1JetPartonFlavour_value

    cdef TBranch* e1JetPhiPhiMoment_branch
    cdef float e1JetPhiPhiMoment_value

    cdef TBranch* e1JetPt_branch
    cdef float e1JetPt_value

    cdef TBranch* e1JetQGLikelihoodID_branch
    cdef float e1JetQGLikelihoodID_value

    cdef TBranch* e1JetQGMVAID_branch
    cdef float e1JetQGMVAID_value

    cdef TBranch* e1Jetaxis1_branch
    cdef float e1Jetaxis1_value

    cdef TBranch* e1Jetaxis2_branch
    cdef float e1Jetaxis2_value

    cdef TBranch* e1Jetmult_branch
    cdef float e1Jetmult_value

    cdef TBranch* e1JetmultMLP_branch
    cdef float e1JetmultMLP_value

    cdef TBranch* e1JetmultMLPQC_branch
    cdef float e1JetmultMLPQC_value

    cdef TBranch* e1JetptD_branch
    cdef float e1JetptD_value

    cdef TBranch* e1L1NonIsoHLTNonIsoMu17Ele8PixelMatchFilter_branch
    cdef float e1L1NonIsoHLTNonIsoMu17Ele8PixelMatchFilter_value

    cdef TBranch* e1MITID_branch
    cdef float e1MITID_value

    cdef TBranch* e1MVAIDH2TauWP_branch
    cdef float e1MVAIDH2TauWP_value

    cdef TBranch* e1MVANonTrig_branch
    cdef float e1MVANonTrig_value

    cdef TBranch* e1MVATrig_branch
    cdef float e1MVATrig_value

    cdef TBranch* e1MVATrigIDISO_branch
    cdef float e1MVATrigIDISO_value

    cdef TBranch* e1MVATrigIDISOPUSUB_branch
    cdef float e1MVATrigIDISOPUSUB_value

    cdef TBranch* e1MVATrigNoIP_branch
    cdef float e1MVATrigNoIP_value

    cdef TBranch* e1Mass_branch
    cdef float e1Mass_value

    cdef TBranch* e1MatchesDoubleEPath_branch
    cdef float e1MatchesDoubleEPath_value

    cdef TBranch* e1MatchesMu17Ele8IsoPath_branch
    cdef float e1MatchesMu17Ele8IsoPath_value

    cdef TBranch* e1MatchesMu17Ele8Path_branch
    cdef float e1MatchesMu17Ele8Path_value

    cdef TBranch* e1MatchesMu8Ele17IsoPath_branch
    cdef float e1MatchesMu8Ele17IsoPath_value

    cdef TBranch* e1MatchesMu8Ele17Path_branch
    cdef float e1MatchesMu8Ele17Path_value

    cdef TBranch* e1MatchesSingleE_branch
    cdef float e1MatchesSingleE_value

    cdef TBranch* e1MatchesSingleEPlusMET_branch
    cdef float e1MatchesSingleEPlusMET_value

    cdef TBranch* e1MissingHits_branch
    cdef float e1MissingHits_value

    cdef TBranch* e1MtToMET_branch
    cdef float e1MtToMET_value

    cdef TBranch* e1MtToMVAMET_branch
    cdef float e1MtToMVAMET_value

    cdef TBranch* e1MtToPFMET_branch
    cdef float e1MtToPFMET_value

    cdef TBranch* e1MtToPfMet_Ty1_branch
    cdef float e1MtToPfMet_Ty1_value

    cdef TBranch* e1MtToPfMet_jes_branch
    cdef float e1MtToPfMet_jes_value

    cdef TBranch* e1MtToPfMet_mes_branch
    cdef float e1MtToPfMet_mes_value

    cdef TBranch* e1MtToPfMet_tes_branch
    cdef float e1MtToPfMet_tes_value

    cdef TBranch* e1MtToPfMet_ues_branch
    cdef float e1MtToPfMet_ues_value

    cdef TBranch* e1Mu17Ele8CaloIdTCaloIsoVLTrkIdVLTrkIsoVLTrackIsoFilter_branch
    cdef float e1Mu17Ele8CaloIdTCaloIsoVLTrkIdVLTrkIsoVLTrackIsoFilter_value

    cdef TBranch* e1Mu17Ele8CaloIdTPixelMatchFilter_branch
    cdef float e1Mu17Ele8CaloIdTPixelMatchFilter_value

    cdef TBranch* e1Mu17Ele8dZFilter_branch
    cdef float e1Mu17Ele8dZFilter_value

    cdef TBranch* e1MuOverlap_branch
    cdef float e1MuOverlap_value

    cdef TBranch* e1MuOverlapZHLoose_branch
    cdef float e1MuOverlapZHLoose_value

    cdef TBranch* e1MuOverlapZHTight_branch
    cdef float e1MuOverlapZHTight_value

    cdef TBranch* e1NearMuonVeto_branch
    cdef float e1NearMuonVeto_value

    cdef TBranch* e1PFChargedIso_branch
    cdef float e1PFChargedIso_value

    cdef TBranch* e1PFNeutralIso_branch
    cdef float e1PFNeutralIso_value

    cdef TBranch* e1PFPhotonIso_branch
    cdef float e1PFPhotonIso_value

    cdef TBranch* e1PVDXY_branch
    cdef float e1PVDXY_value

    cdef TBranch* e1PVDZ_branch
    cdef float e1PVDZ_value

    cdef TBranch* e1Phi_branch
    cdef float e1Phi_value

    cdef TBranch* e1PhiCorrReg_2012Jul13ReReco_branch
    cdef float e1PhiCorrReg_2012Jul13ReReco_value

    cdef TBranch* e1PhiCorrReg_Fall11_branch
    cdef float e1PhiCorrReg_Fall11_value

    cdef TBranch* e1PhiCorrReg_Jan16ReReco_branch
    cdef float e1PhiCorrReg_Jan16ReReco_value

    cdef TBranch* e1PhiCorrReg_Summer12_DR53X_HCP2012_branch
    cdef float e1PhiCorrReg_Summer12_DR53X_HCP2012_value

    cdef TBranch* e1PhiCorrSmearedNoReg_2012Jul13ReReco_branch
    cdef float e1PhiCorrSmearedNoReg_2012Jul13ReReco_value

    cdef TBranch* e1PhiCorrSmearedNoReg_Fall11_branch
    cdef float e1PhiCorrSmearedNoReg_Fall11_value

    cdef TBranch* e1PhiCorrSmearedNoReg_Jan16ReReco_branch
    cdef float e1PhiCorrSmearedNoReg_Jan16ReReco_value

    cdef TBranch* e1PhiCorrSmearedNoReg_Summer12_DR53X_HCP2012_branch
    cdef float e1PhiCorrSmearedNoReg_Summer12_DR53X_HCP2012_value

    cdef TBranch* e1PhiCorrSmearedReg_2012Jul13ReReco_branch
    cdef float e1PhiCorrSmearedReg_2012Jul13ReReco_value

    cdef TBranch* e1PhiCorrSmearedReg_Fall11_branch
    cdef float e1PhiCorrSmearedReg_Fall11_value

    cdef TBranch* e1PhiCorrSmearedReg_Jan16ReReco_branch
    cdef float e1PhiCorrSmearedReg_Jan16ReReco_value

    cdef TBranch* e1PhiCorrSmearedReg_Summer12_DR53X_HCP2012_branch
    cdef float e1PhiCorrSmearedReg_Summer12_DR53X_HCP2012_value

    cdef TBranch* e1Pt_branch
    cdef float e1Pt_value

    cdef TBranch* e1PtCorrReg_2012Jul13ReReco_branch
    cdef float e1PtCorrReg_2012Jul13ReReco_value

    cdef TBranch* e1PtCorrReg_Fall11_branch
    cdef float e1PtCorrReg_Fall11_value

    cdef TBranch* e1PtCorrReg_Jan16ReReco_branch
    cdef float e1PtCorrReg_Jan16ReReco_value

    cdef TBranch* e1PtCorrReg_Summer12_DR53X_HCP2012_branch
    cdef float e1PtCorrReg_Summer12_DR53X_HCP2012_value

    cdef TBranch* e1PtCorrSmearedNoReg_2012Jul13ReReco_branch
    cdef float e1PtCorrSmearedNoReg_2012Jul13ReReco_value

    cdef TBranch* e1PtCorrSmearedNoReg_Fall11_branch
    cdef float e1PtCorrSmearedNoReg_Fall11_value

    cdef TBranch* e1PtCorrSmearedNoReg_Jan16ReReco_branch
    cdef float e1PtCorrSmearedNoReg_Jan16ReReco_value

    cdef TBranch* e1PtCorrSmearedNoReg_Summer12_DR53X_HCP2012_branch
    cdef float e1PtCorrSmearedNoReg_Summer12_DR53X_HCP2012_value

    cdef TBranch* e1PtCorrSmearedReg_2012Jul13ReReco_branch
    cdef float e1PtCorrSmearedReg_2012Jul13ReReco_value

    cdef TBranch* e1PtCorrSmearedReg_Fall11_branch
    cdef float e1PtCorrSmearedReg_Fall11_value

    cdef TBranch* e1PtCorrSmearedReg_Jan16ReReco_branch
    cdef float e1PtCorrSmearedReg_Jan16ReReco_value

    cdef TBranch* e1PtCorrSmearedReg_Summer12_DR53X_HCP2012_branch
    cdef float e1PtCorrSmearedReg_Summer12_DR53X_HCP2012_value

    cdef TBranch* e1Rank_branch
    cdef float e1Rank_value

    cdef TBranch* e1RelIso_branch
    cdef float e1RelIso_value

    cdef TBranch* e1RelPFIsoDB_branch
    cdef float e1RelPFIsoDB_value

    cdef TBranch* e1RelPFIsoRho_branch
    cdef float e1RelPFIsoRho_value

    cdef TBranch* e1RelPFIsoRhoFSR_branch
    cdef float e1RelPFIsoRhoFSR_value

    cdef TBranch* e1RhoHZG2011_branch
    cdef float e1RhoHZG2011_value

    cdef TBranch* e1RhoHZG2012_branch
    cdef float e1RhoHZG2012_value

    cdef TBranch* e1SCEnergy_branch
    cdef float e1SCEnergy_value

    cdef TBranch* e1SCEta_branch
    cdef float e1SCEta_value

    cdef TBranch* e1SCEtaWidth_branch
    cdef float e1SCEtaWidth_value

    cdef TBranch* e1SCPhi_branch
    cdef float e1SCPhi_value

    cdef TBranch* e1SCPhiWidth_branch
    cdef float e1SCPhiWidth_value

    cdef TBranch* e1SCPreshowerEnergy_branch
    cdef float e1SCPreshowerEnergy_value

    cdef TBranch* e1SCRawEnergy_branch
    cdef float e1SCRawEnergy_value

    cdef TBranch* e1SigmaIEtaIEta_branch
    cdef float e1SigmaIEtaIEta_value

    cdef TBranch* e1ToMETDPhi_branch
    cdef float e1ToMETDPhi_value

    cdef TBranch* e1TrkIsoDR03_branch
    cdef float e1TrkIsoDR03_value

    cdef TBranch* e1VZ_branch
    cdef float e1VZ_value

    cdef TBranch* e1WWID_branch
    cdef float e1WWID_value

    cdef TBranch* e1_e2_CosThetaStar_branch
    cdef float e1_e2_CosThetaStar_value

    cdef TBranch* e1_e2_DPhi_branch
    cdef float e1_e2_DPhi_value

    cdef TBranch* e1_e2_DR_branch
    cdef float e1_e2_DR_value

    cdef TBranch* e1_e2_Eta_branch
    cdef float e1_e2_Eta_value

    cdef TBranch* e1_e2_Mass_branch
    cdef float e1_e2_Mass_value

    cdef TBranch* e1_e2_MassFsr_branch
    cdef float e1_e2_MassFsr_value

    cdef TBranch* e1_e2_PZeta_branch
    cdef float e1_e2_PZeta_value

    cdef TBranch* e1_e2_PZetaVis_branch
    cdef float e1_e2_PZetaVis_value

    cdef TBranch* e1_e2_Phi_branch
    cdef float e1_e2_Phi_value

    cdef TBranch* e1_e2_Pt_branch
    cdef float e1_e2_Pt_value

    cdef TBranch* e1_e2_PtFsr_branch
    cdef float e1_e2_PtFsr_value

    cdef TBranch* e1_e2_SS_branch
    cdef float e1_e2_SS_value

    cdef TBranch* e1_e2_ToMETDPhi_Ty1_branch
    cdef float e1_e2_ToMETDPhi_Ty1_value

    cdef TBranch* e1_e2_Zcompat_branch
    cdef float e1_e2_Zcompat_value

    cdef TBranch* e1_e3_CosThetaStar_branch
    cdef float e1_e3_CosThetaStar_value

    cdef TBranch* e1_e3_DPhi_branch
    cdef float e1_e3_DPhi_value

    cdef TBranch* e1_e3_DR_branch
    cdef float e1_e3_DR_value

    cdef TBranch* e1_e3_Eta_branch
    cdef float e1_e3_Eta_value

    cdef TBranch* e1_e3_Mass_branch
    cdef float e1_e3_Mass_value

    cdef TBranch* e1_e3_MassFsr_branch
    cdef float e1_e3_MassFsr_value

    cdef TBranch* e1_e3_PZeta_branch
    cdef float e1_e3_PZeta_value

    cdef TBranch* e1_e3_PZetaVis_branch
    cdef float e1_e3_PZetaVis_value

    cdef TBranch* e1_e3_Phi_branch
    cdef float e1_e3_Phi_value

    cdef TBranch* e1_e3_Pt_branch
    cdef float e1_e3_Pt_value

    cdef TBranch* e1_e3_PtFsr_branch
    cdef float e1_e3_PtFsr_value

    cdef TBranch* e1_e3_SS_branch
    cdef float e1_e3_SS_value

    cdef TBranch* e1_e3_ToMETDPhi_Ty1_branch
    cdef float e1_e3_ToMETDPhi_Ty1_value

    cdef TBranch* e1_e3_Zcompat_branch
    cdef float e1_e3_Zcompat_value

    cdef TBranch* e1_t_CosThetaStar_branch
    cdef float e1_t_CosThetaStar_value

    cdef TBranch* e1_t_DPhi_branch
    cdef float e1_t_DPhi_value

    cdef TBranch* e1_t_DR_branch
    cdef float e1_t_DR_value

    cdef TBranch* e1_t_Eta_branch
    cdef float e1_t_Eta_value

    cdef TBranch* e1_t_Mass_branch
    cdef float e1_t_Mass_value

    cdef TBranch* e1_t_MassFsr_branch
    cdef float e1_t_MassFsr_value

    cdef TBranch* e1_t_PZeta_branch
    cdef float e1_t_PZeta_value

    cdef TBranch* e1_t_PZetaVis_branch
    cdef float e1_t_PZetaVis_value

    cdef TBranch* e1_t_Phi_branch
    cdef float e1_t_Phi_value

    cdef TBranch* e1_t_Pt_branch
    cdef float e1_t_Pt_value

    cdef TBranch* e1_t_PtFsr_branch
    cdef float e1_t_PtFsr_value

    cdef TBranch* e1_t_SS_branch
    cdef float e1_t_SS_value

    cdef TBranch* e1_t_ToMETDPhi_Ty1_branch
    cdef float e1_t_ToMETDPhi_Ty1_value

    cdef TBranch* e1_t_Zcompat_branch
    cdef float e1_t_Zcompat_value

    cdef TBranch* e1dECorrReg_2012Jul13ReReco_branch
    cdef float e1dECorrReg_2012Jul13ReReco_value

    cdef TBranch* e1dECorrReg_Fall11_branch
    cdef float e1dECorrReg_Fall11_value

    cdef TBranch* e1dECorrReg_Jan16ReReco_branch
    cdef float e1dECorrReg_Jan16ReReco_value

    cdef TBranch* e1dECorrReg_Summer12_DR53X_HCP2012_branch
    cdef float e1dECorrReg_Summer12_DR53X_HCP2012_value

    cdef TBranch* e1dECorrSmearedNoReg_2012Jul13ReReco_branch
    cdef float e1dECorrSmearedNoReg_2012Jul13ReReco_value

    cdef TBranch* e1dECorrSmearedNoReg_Fall11_branch
    cdef float e1dECorrSmearedNoReg_Fall11_value

    cdef TBranch* e1dECorrSmearedNoReg_Jan16ReReco_branch
    cdef float e1dECorrSmearedNoReg_Jan16ReReco_value

    cdef TBranch* e1dECorrSmearedNoReg_Summer12_DR53X_HCP2012_branch
    cdef float e1dECorrSmearedNoReg_Summer12_DR53X_HCP2012_value

    cdef TBranch* e1dECorrSmearedReg_2012Jul13ReReco_branch
    cdef float e1dECorrSmearedReg_2012Jul13ReReco_value

    cdef TBranch* e1dECorrSmearedReg_Fall11_branch
    cdef float e1dECorrSmearedReg_Fall11_value

    cdef TBranch* e1dECorrSmearedReg_Jan16ReReco_branch
    cdef float e1dECorrSmearedReg_Jan16ReReco_value

    cdef TBranch* e1dECorrSmearedReg_Summer12_DR53X_HCP2012_branch
    cdef float e1dECorrSmearedReg_Summer12_DR53X_HCP2012_value

    cdef TBranch* e1deltaEtaSuperClusterTrackAtVtx_branch
    cdef float e1deltaEtaSuperClusterTrackAtVtx_value

    cdef TBranch* e1deltaPhiSuperClusterTrackAtVtx_branch
    cdef float e1deltaPhiSuperClusterTrackAtVtx_value

    cdef TBranch* e1eSuperClusterOverP_branch
    cdef float e1eSuperClusterOverP_value

    cdef TBranch* e1ecalEnergy_branch
    cdef float e1ecalEnergy_value

    cdef TBranch* e1fBrem_branch
    cdef float e1fBrem_value

    cdef TBranch* e1trackMomentumAtVtxP_branch
    cdef float e1trackMomentumAtVtxP_value

    cdef TBranch* e2AbsEta_branch
    cdef float e2AbsEta_value

    cdef TBranch* e2CBID_LOOSE_branch
    cdef float e2CBID_LOOSE_value

    cdef TBranch* e2CBID_MEDIUM_branch
    cdef float e2CBID_MEDIUM_value

    cdef TBranch* e2CBID_TIGHT_branch
    cdef float e2CBID_TIGHT_value

    cdef TBranch* e2CBID_VETO_branch
    cdef float e2CBID_VETO_value

    cdef TBranch* e2Charge_branch
    cdef float e2Charge_value

    cdef TBranch* e2ChargeIdLoose_branch
    cdef float e2ChargeIdLoose_value

    cdef TBranch* e2ChargeIdMed_branch
    cdef float e2ChargeIdMed_value

    cdef TBranch* e2ChargeIdTight_branch
    cdef float e2ChargeIdTight_value

    cdef TBranch* e2CiCTight_branch
    cdef float e2CiCTight_value

    cdef TBranch* e2CiCTightElecOverlap_branch
    cdef float e2CiCTightElecOverlap_value

    cdef TBranch* e2ComesFromHiggs_branch
    cdef float e2ComesFromHiggs_value

    cdef TBranch* e2DZ_branch
    cdef float e2DZ_value

    cdef TBranch* e2E1x5_branch
    cdef float e2E1x5_value

    cdef TBranch* e2E2x5Max_branch
    cdef float e2E2x5Max_value

    cdef TBranch* e2E5x5_branch
    cdef float e2E5x5_value

    cdef TBranch* e2ECorrReg_2012Jul13ReReco_branch
    cdef float e2ECorrReg_2012Jul13ReReco_value

    cdef TBranch* e2ECorrReg_Fall11_branch
    cdef float e2ECorrReg_Fall11_value

    cdef TBranch* e2ECorrReg_Jan16ReReco_branch
    cdef float e2ECorrReg_Jan16ReReco_value

    cdef TBranch* e2ECorrReg_Summer12_DR53X_HCP2012_branch
    cdef float e2ECorrReg_Summer12_DR53X_HCP2012_value

    cdef TBranch* e2ECorrSmearedNoReg_2012Jul13ReReco_branch
    cdef float e2ECorrSmearedNoReg_2012Jul13ReReco_value

    cdef TBranch* e2ECorrSmearedNoReg_Fall11_branch
    cdef float e2ECorrSmearedNoReg_Fall11_value

    cdef TBranch* e2ECorrSmearedNoReg_Jan16ReReco_branch
    cdef float e2ECorrSmearedNoReg_Jan16ReReco_value

    cdef TBranch* e2ECorrSmearedNoReg_Summer12_DR53X_HCP2012_branch
    cdef float e2ECorrSmearedNoReg_Summer12_DR53X_HCP2012_value

    cdef TBranch* e2ECorrSmearedReg_2012Jul13ReReco_branch
    cdef float e2ECorrSmearedReg_2012Jul13ReReco_value

    cdef TBranch* e2ECorrSmearedReg_Fall11_branch
    cdef float e2ECorrSmearedReg_Fall11_value

    cdef TBranch* e2ECorrSmearedReg_Jan16ReReco_branch
    cdef float e2ECorrSmearedReg_Jan16ReReco_value

    cdef TBranch* e2ECorrSmearedReg_Summer12_DR53X_HCP2012_branch
    cdef float e2ECorrSmearedReg_Summer12_DR53X_HCP2012_value

    cdef TBranch* e2EcalIsoDR03_branch
    cdef float e2EcalIsoDR03_value

    cdef TBranch* e2EffectiveArea2011Data_branch
    cdef float e2EffectiveArea2011Data_value

    cdef TBranch* e2EffectiveArea2012Data_branch
    cdef float e2EffectiveArea2012Data_value

    cdef TBranch* e2EffectiveAreaFall11MC_branch
    cdef float e2EffectiveAreaFall11MC_value

    cdef TBranch* e2Ele27WP80PFMT50PFMTFilter_branch
    cdef float e2Ele27WP80PFMT50PFMTFilter_value

    cdef TBranch* e2Ele27WP80TrackIsoMatchFilter_branch
    cdef float e2Ele27WP80TrackIsoMatchFilter_value

    cdef TBranch* e2Ele32WP70PFMT50PFMTFilter_branch
    cdef float e2Ele32WP70PFMT50PFMTFilter_value

    cdef TBranch* e2ElecOverlap_branch
    cdef float e2ElecOverlap_value

    cdef TBranch* e2ElecOverlapZHLoose_branch
    cdef float e2ElecOverlapZHLoose_value

    cdef TBranch* e2ElecOverlapZHTight_branch
    cdef float e2ElecOverlapZHTight_value

    cdef TBranch* e2EnergyError_branch
    cdef float e2EnergyError_value

    cdef TBranch* e2Eta_branch
    cdef float e2Eta_value

    cdef TBranch* e2EtaCorrReg_2012Jul13ReReco_branch
    cdef float e2EtaCorrReg_2012Jul13ReReco_value

    cdef TBranch* e2EtaCorrReg_Fall11_branch
    cdef float e2EtaCorrReg_Fall11_value

    cdef TBranch* e2EtaCorrReg_Jan16ReReco_branch
    cdef float e2EtaCorrReg_Jan16ReReco_value

    cdef TBranch* e2EtaCorrReg_Summer12_DR53X_HCP2012_branch
    cdef float e2EtaCorrReg_Summer12_DR53X_HCP2012_value

    cdef TBranch* e2EtaCorrSmearedNoReg_2012Jul13ReReco_branch
    cdef float e2EtaCorrSmearedNoReg_2012Jul13ReReco_value

    cdef TBranch* e2EtaCorrSmearedNoReg_Fall11_branch
    cdef float e2EtaCorrSmearedNoReg_Fall11_value

    cdef TBranch* e2EtaCorrSmearedNoReg_Jan16ReReco_branch
    cdef float e2EtaCorrSmearedNoReg_Jan16ReReco_value

    cdef TBranch* e2EtaCorrSmearedNoReg_Summer12_DR53X_HCP2012_branch
    cdef float e2EtaCorrSmearedNoReg_Summer12_DR53X_HCP2012_value

    cdef TBranch* e2EtaCorrSmearedReg_2012Jul13ReReco_branch
    cdef float e2EtaCorrSmearedReg_2012Jul13ReReco_value

    cdef TBranch* e2EtaCorrSmearedReg_Fall11_branch
    cdef float e2EtaCorrSmearedReg_Fall11_value

    cdef TBranch* e2EtaCorrSmearedReg_Jan16ReReco_branch
    cdef float e2EtaCorrSmearedReg_Jan16ReReco_value

    cdef TBranch* e2EtaCorrSmearedReg_Summer12_DR53X_HCP2012_branch
    cdef float e2EtaCorrSmearedReg_Summer12_DR53X_HCP2012_value

    cdef TBranch* e2GenCharge_branch
    cdef float e2GenCharge_value

    cdef TBranch* e2GenEnergy_branch
    cdef float e2GenEnergy_value

    cdef TBranch* e2GenEta_branch
    cdef float e2GenEta_value

    cdef TBranch* e2GenMotherPdgId_branch
    cdef float e2GenMotherPdgId_value

    cdef TBranch* e2GenPdgId_branch
    cdef float e2GenPdgId_value

    cdef TBranch* e2GenPhi_branch
    cdef float e2GenPhi_value

    cdef TBranch* e2HadronicDepth1OverEm_branch
    cdef float e2HadronicDepth1OverEm_value

    cdef TBranch* e2HadronicDepth2OverEm_branch
    cdef float e2HadronicDepth2OverEm_value

    cdef TBranch* e2HadronicOverEM_branch
    cdef float e2HadronicOverEM_value

    cdef TBranch* e2HasConversion_branch
    cdef float e2HasConversion_value

    cdef TBranch* e2HasMatchedConversion_branch
    cdef int e2HasMatchedConversion_value

    cdef TBranch* e2HcalIsoDR03_branch
    cdef float e2HcalIsoDR03_value

    cdef TBranch* e2IP3DS_branch
    cdef float e2IP3DS_value

    cdef TBranch* e2JetArea_branch
    cdef float e2JetArea_value

    cdef TBranch* e2JetBtag_branch
    cdef float e2JetBtag_value

    cdef TBranch* e2JetCSVBtag_branch
    cdef float e2JetCSVBtag_value

    cdef TBranch* e2JetEtaEtaMoment_branch
    cdef float e2JetEtaEtaMoment_value

    cdef TBranch* e2JetEtaPhiMoment_branch
    cdef float e2JetEtaPhiMoment_value

    cdef TBranch* e2JetEtaPhiSpread_branch
    cdef float e2JetEtaPhiSpread_value

    cdef TBranch* e2JetPartonFlavour_branch
    cdef float e2JetPartonFlavour_value

    cdef TBranch* e2JetPhiPhiMoment_branch
    cdef float e2JetPhiPhiMoment_value

    cdef TBranch* e2JetPt_branch
    cdef float e2JetPt_value

    cdef TBranch* e2JetQGLikelihoodID_branch
    cdef float e2JetQGLikelihoodID_value

    cdef TBranch* e2JetQGMVAID_branch
    cdef float e2JetQGMVAID_value

    cdef TBranch* e2Jetaxis1_branch
    cdef float e2Jetaxis1_value

    cdef TBranch* e2Jetaxis2_branch
    cdef float e2Jetaxis2_value

    cdef TBranch* e2Jetmult_branch
    cdef float e2Jetmult_value

    cdef TBranch* e2JetmultMLP_branch
    cdef float e2JetmultMLP_value

    cdef TBranch* e2JetmultMLPQC_branch
    cdef float e2JetmultMLPQC_value

    cdef TBranch* e2JetptD_branch
    cdef float e2JetptD_value

    cdef TBranch* e2L1NonIsoHLTNonIsoMu17Ele8PixelMatchFilter_branch
    cdef float e2L1NonIsoHLTNonIsoMu17Ele8PixelMatchFilter_value

    cdef TBranch* e2MITID_branch
    cdef float e2MITID_value

    cdef TBranch* e2MVAIDH2TauWP_branch
    cdef float e2MVAIDH2TauWP_value

    cdef TBranch* e2MVANonTrig_branch
    cdef float e2MVANonTrig_value

    cdef TBranch* e2MVATrig_branch
    cdef float e2MVATrig_value

    cdef TBranch* e2MVATrigIDISO_branch
    cdef float e2MVATrigIDISO_value

    cdef TBranch* e2MVATrigIDISOPUSUB_branch
    cdef float e2MVATrigIDISOPUSUB_value

    cdef TBranch* e2MVATrigNoIP_branch
    cdef float e2MVATrigNoIP_value

    cdef TBranch* e2Mass_branch
    cdef float e2Mass_value

    cdef TBranch* e2MatchesDoubleEPath_branch
    cdef float e2MatchesDoubleEPath_value

    cdef TBranch* e2MatchesMu17Ele8IsoPath_branch
    cdef float e2MatchesMu17Ele8IsoPath_value

    cdef TBranch* e2MatchesMu17Ele8Path_branch
    cdef float e2MatchesMu17Ele8Path_value

    cdef TBranch* e2MatchesMu8Ele17IsoPath_branch
    cdef float e2MatchesMu8Ele17IsoPath_value

    cdef TBranch* e2MatchesMu8Ele17Path_branch
    cdef float e2MatchesMu8Ele17Path_value

    cdef TBranch* e2MatchesSingleE_branch
    cdef float e2MatchesSingleE_value

    cdef TBranch* e2MatchesSingleEPlusMET_branch
    cdef float e2MatchesSingleEPlusMET_value

    cdef TBranch* e2MissingHits_branch
    cdef float e2MissingHits_value

    cdef TBranch* e2MtToMET_branch
    cdef float e2MtToMET_value

    cdef TBranch* e2MtToMVAMET_branch
    cdef float e2MtToMVAMET_value

    cdef TBranch* e2MtToPFMET_branch
    cdef float e2MtToPFMET_value

    cdef TBranch* e2MtToPfMet_Ty1_branch
    cdef float e2MtToPfMet_Ty1_value

    cdef TBranch* e2MtToPfMet_jes_branch
    cdef float e2MtToPfMet_jes_value

    cdef TBranch* e2MtToPfMet_mes_branch
    cdef float e2MtToPfMet_mes_value

    cdef TBranch* e2MtToPfMet_tes_branch
    cdef float e2MtToPfMet_tes_value

    cdef TBranch* e2MtToPfMet_ues_branch
    cdef float e2MtToPfMet_ues_value

    cdef TBranch* e2Mu17Ele8CaloIdTCaloIsoVLTrkIdVLTrkIsoVLTrackIsoFilter_branch
    cdef float e2Mu17Ele8CaloIdTCaloIsoVLTrkIdVLTrkIsoVLTrackIsoFilter_value

    cdef TBranch* e2Mu17Ele8CaloIdTPixelMatchFilter_branch
    cdef float e2Mu17Ele8CaloIdTPixelMatchFilter_value

    cdef TBranch* e2Mu17Ele8dZFilter_branch
    cdef float e2Mu17Ele8dZFilter_value

    cdef TBranch* e2MuOverlap_branch
    cdef float e2MuOverlap_value

    cdef TBranch* e2MuOverlapZHLoose_branch
    cdef float e2MuOverlapZHLoose_value

    cdef TBranch* e2MuOverlapZHTight_branch
    cdef float e2MuOverlapZHTight_value

    cdef TBranch* e2NearMuonVeto_branch
    cdef float e2NearMuonVeto_value

    cdef TBranch* e2PFChargedIso_branch
    cdef float e2PFChargedIso_value

    cdef TBranch* e2PFNeutralIso_branch
    cdef float e2PFNeutralIso_value

    cdef TBranch* e2PFPhotonIso_branch
    cdef float e2PFPhotonIso_value

    cdef TBranch* e2PVDXY_branch
    cdef float e2PVDXY_value

    cdef TBranch* e2PVDZ_branch
    cdef float e2PVDZ_value

    cdef TBranch* e2Phi_branch
    cdef float e2Phi_value

    cdef TBranch* e2PhiCorrReg_2012Jul13ReReco_branch
    cdef float e2PhiCorrReg_2012Jul13ReReco_value

    cdef TBranch* e2PhiCorrReg_Fall11_branch
    cdef float e2PhiCorrReg_Fall11_value

    cdef TBranch* e2PhiCorrReg_Jan16ReReco_branch
    cdef float e2PhiCorrReg_Jan16ReReco_value

    cdef TBranch* e2PhiCorrReg_Summer12_DR53X_HCP2012_branch
    cdef float e2PhiCorrReg_Summer12_DR53X_HCP2012_value

    cdef TBranch* e2PhiCorrSmearedNoReg_2012Jul13ReReco_branch
    cdef float e2PhiCorrSmearedNoReg_2012Jul13ReReco_value

    cdef TBranch* e2PhiCorrSmearedNoReg_Fall11_branch
    cdef float e2PhiCorrSmearedNoReg_Fall11_value

    cdef TBranch* e2PhiCorrSmearedNoReg_Jan16ReReco_branch
    cdef float e2PhiCorrSmearedNoReg_Jan16ReReco_value

    cdef TBranch* e2PhiCorrSmearedNoReg_Summer12_DR53X_HCP2012_branch
    cdef float e2PhiCorrSmearedNoReg_Summer12_DR53X_HCP2012_value

    cdef TBranch* e2PhiCorrSmearedReg_2012Jul13ReReco_branch
    cdef float e2PhiCorrSmearedReg_2012Jul13ReReco_value

    cdef TBranch* e2PhiCorrSmearedReg_Fall11_branch
    cdef float e2PhiCorrSmearedReg_Fall11_value

    cdef TBranch* e2PhiCorrSmearedReg_Jan16ReReco_branch
    cdef float e2PhiCorrSmearedReg_Jan16ReReco_value

    cdef TBranch* e2PhiCorrSmearedReg_Summer12_DR53X_HCP2012_branch
    cdef float e2PhiCorrSmearedReg_Summer12_DR53X_HCP2012_value

    cdef TBranch* e2Pt_branch
    cdef float e2Pt_value

    cdef TBranch* e2PtCorrReg_2012Jul13ReReco_branch
    cdef float e2PtCorrReg_2012Jul13ReReco_value

    cdef TBranch* e2PtCorrReg_Fall11_branch
    cdef float e2PtCorrReg_Fall11_value

    cdef TBranch* e2PtCorrReg_Jan16ReReco_branch
    cdef float e2PtCorrReg_Jan16ReReco_value

    cdef TBranch* e2PtCorrReg_Summer12_DR53X_HCP2012_branch
    cdef float e2PtCorrReg_Summer12_DR53X_HCP2012_value

    cdef TBranch* e2PtCorrSmearedNoReg_2012Jul13ReReco_branch
    cdef float e2PtCorrSmearedNoReg_2012Jul13ReReco_value

    cdef TBranch* e2PtCorrSmearedNoReg_Fall11_branch
    cdef float e2PtCorrSmearedNoReg_Fall11_value

    cdef TBranch* e2PtCorrSmearedNoReg_Jan16ReReco_branch
    cdef float e2PtCorrSmearedNoReg_Jan16ReReco_value

    cdef TBranch* e2PtCorrSmearedNoReg_Summer12_DR53X_HCP2012_branch
    cdef float e2PtCorrSmearedNoReg_Summer12_DR53X_HCP2012_value

    cdef TBranch* e2PtCorrSmearedReg_2012Jul13ReReco_branch
    cdef float e2PtCorrSmearedReg_2012Jul13ReReco_value

    cdef TBranch* e2PtCorrSmearedReg_Fall11_branch
    cdef float e2PtCorrSmearedReg_Fall11_value

    cdef TBranch* e2PtCorrSmearedReg_Jan16ReReco_branch
    cdef float e2PtCorrSmearedReg_Jan16ReReco_value

    cdef TBranch* e2PtCorrSmearedReg_Summer12_DR53X_HCP2012_branch
    cdef float e2PtCorrSmearedReg_Summer12_DR53X_HCP2012_value

    cdef TBranch* e2Rank_branch
    cdef float e2Rank_value

    cdef TBranch* e2RelIso_branch
    cdef float e2RelIso_value

    cdef TBranch* e2RelPFIsoDB_branch
    cdef float e2RelPFIsoDB_value

    cdef TBranch* e2RelPFIsoRho_branch
    cdef float e2RelPFIsoRho_value

    cdef TBranch* e2RelPFIsoRhoFSR_branch
    cdef float e2RelPFIsoRhoFSR_value

    cdef TBranch* e2RhoHZG2011_branch
    cdef float e2RhoHZG2011_value

    cdef TBranch* e2RhoHZG2012_branch
    cdef float e2RhoHZG2012_value

    cdef TBranch* e2SCEnergy_branch
    cdef float e2SCEnergy_value

    cdef TBranch* e2SCEta_branch
    cdef float e2SCEta_value

    cdef TBranch* e2SCEtaWidth_branch
    cdef float e2SCEtaWidth_value

    cdef TBranch* e2SCPhi_branch
    cdef float e2SCPhi_value

    cdef TBranch* e2SCPhiWidth_branch
    cdef float e2SCPhiWidth_value

    cdef TBranch* e2SCPreshowerEnergy_branch
    cdef float e2SCPreshowerEnergy_value

    cdef TBranch* e2SCRawEnergy_branch
    cdef float e2SCRawEnergy_value

    cdef TBranch* e2SigmaIEtaIEta_branch
    cdef float e2SigmaIEtaIEta_value

    cdef TBranch* e2ToMETDPhi_branch
    cdef float e2ToMETDPhi_value

    cdef TBranch* e2TrkIsoDR03_branch
    cdef float e2TrkIsoDR03_value

    cdef TBranch* e2VZ_branch
    cdef float e2VZ_value

    cdef TBranch* e2WWID_branch
    cdef float e2WWID_value

    cdef TBranch* e2_e3_CosThetaStar_branch
    cdef float e2_e3_CosThetaStar_value

    cdef TBranch* e2_e3_DPhi_branch
    cdef float e2_e3_DPhi_value

    cdef TBranch* e2_e3_DR_branch
    cdef float e2_e3_DR_value

    cdef TBranch* e2_e3_Eta_branch
    cdef float e2_e3_Eta_value

    cdef TBranch* e2_e3_Mass_branch
    cdef float e2_e3_Mass_value

    cdef TBranch* e2_e3_MassFsr_branch
    cdef float e2_e3_MassFsr_value

    cdef TBranch* e2_e3_PZeta_branch
    cdef float e2_e3_PZeta_value

    cdef TBranch* e2_e3_PZetaVis_branch
    cdef float e2_e3_PZetaVis_value

    cdef TBranch* e2_e3_Phi_branch
    cdef float e2_e3_Phi_value

    cdef TBranch* e2_e3_Pt_branch
    cdef float e2_e3_Pt_value

    cdef TBranch* e2_e3_PtFsr_branch
    cdef float e2_e3_PtFsr_value

    cdef TBranch* e2_e3_SS_branch
    cdef float e2_e3_SS_value

    cdef TBranch* e2_e3_ToMETDPhi_Ty1_branch
    cdef float e2_e3_ToMETDPhi_Ty1_value

    cdef TBranch* e2_e3_Zcompat_branch
    cdef float e2_e3_Zcompat_value

    cdef TBranch* e2_t_CosThetaStar_branch
    cdef float e2_t_CosThetaStar_value

    cdef TBranch* e2_t_DPhi_branch
    cdef float e2_t_DPhi_value

    cdef TBranch* e2_t_DR_branch
    cdef float e2_t_DR_value

    cdef TBranch* e2_t_Eta_branch
    cdef float e2_t_Eta_value

    cdef TBranch* e2_t_Mass_branch
    cdef float e2_t_Mass_value

    cdef TBranch* e2_t_MassFsr_branch
    cdef float e2_t_MassFsr_value

    cdef TBranch* e2_t_PZeta_branch
    cdef float e2_t_PZeta_value

    cdef TBranch* e2_t_PZetaVis_branch
    cdef float e2_t_PZetaVis_value

    cdef TBranch* e2_t_Phi_branch
    cdef float e2_t_Phi_value

    cdef TBranch* e2_t_Pt_branch
    cdef float e2_t_Pt_value

    cdef TBranch* e2_t_PtFsr_branch
    cdef float e2_t_PtFsr_value

    cdef TBranch* e2_t_SS_branch
    cdef float e2_t_SS_value

    cdef TBranch* e2_t_ToMETDPhi_Ty1_branch
    cdef float e2_t_ToMETDPhi_Ty1_value

    cdef TBranch* e2_t_Zcompat_branch
    cdef float e2_t_Zcompat_value

    cdef TBranch* e2dECorrReg_2012Jul13ReReco_branch
    cdef float e2dECorrReg_2012Jul13ReReco_value

    cdef TBranch* e2dECorrReg_Fall11_branch
    cdef float e2dECorrReg_Fall11_value

    cdef TBranch* e2dECorrReg_Jan16ReReco_branch
    cdef float e2dECorrReg_Jan16ReReco_value

    cdef TBranch* e2dECorrReg_Summer12_DR53X_HCP2012_branch
    cdef float e2dECorrReg_Summer12_DR53X_HCP2012_value

    cdef TBranch* e2dECorrSmearedNoReg_2012Jul13ReReco_branch
    cdef float e2dECorrSmearedNoReg_2012Jul13ReReco_value

    cdef TBranch* e2dECorrSmearedNoReg_Fall11_branch
    cdef float e2dECorrSmearedNoReg_Fall11_value

    cdef TBranch* e2dECorrSmearedNoReg_Jan16ReReco_branch
    cdef float e2dECorrSmearedNoReg_Jan16ReReco_value

    cdef TBranch* e2dECorrSmearedNoReg_Summer12_DR53X_HCP2012_branch
    cdef float e2dECorrSmearedNoReg_Summer12_DR53X_HCP2012_value

    cdef TBranch* e2dECorrSmearedReg_2012Jul13ReReco_branch
    cdef float e2dECorrSmearedReg_2012Jul13ReReco_value

    cdef TBranch* e2dECorrSmearedReg_Fall11_branch
    cdef float e2dECorrSmearedReg_Fall11_value

    cdef TBranch* e2dECorrSmearedReg_Jan16ReReco_branch
    cdef float e2dECorrSmearedReg_Jan16ReReco_value

    cdef TBranch* e2dECorrSmearedReg_Summer12_DR53X_HCP2012_branch
    cdef float e2dECorrSmearedReg_Summer12_DR53X_HCP2012_value

    cdef TBranch* e2deltaEtaSuperClusterTrackAtVtx_branch
    cdef float e2deltaEtaSuperClusterTrackAtVtx_value

    cdef TBranch* e2deltaPhiSuperClusterTrackAtVtx_branch
    cdef float e2deltaPhiSuperClusterTrackAtVtx_value

    cdef TBranch* e2eSuperClusterOverP_branch
    cdef float e2eSuperClusterOverP_value

    cdef TBranch* e2ecalEnergy_branch
    cdef float e2ecalEnergy_value

    cdef TBranch* e2fBrem_branch
    cdef float e2fBrem_value

    cdef TBranch* e2trackMomentumAtVtxP_branch
    cdef float e2trackMomentumAtVtxP_value

    cdef TBranch* e3AbsEta_branch
    cdef float e3AbsEta_value

    cdef TBranch* e3CBID_LOOSE_branch
    cdef float e3CBID_LOOSE_value

    cdef TBranch* e3CBID_MEDIUM_branch
    cdef float e3CBID_MEDIUM_value

    cdef TBranch* e3CBID_TIGHT_branch
    cdef float e3CBID_TIGHT_value

    cdef TBranch* e3CBID_VETO_branch
    cdef float e3CBID_VETO_value

    cdef TBranch* e3Charge_branch
    cdef float e3Charge_value

    cdef TBranch* e3ChargeIdLoose_branch
    cdef float e3ChargeIdLoose_value

    cdef TBranch* e3ChargeIdMed_branch
    cdef float e3ChargeIdMed_value

    cdef TBranch* e3ChargeIdTight_branch
    cdef float e3ChargeIdTight_value

    cdef TBranch* e3CiCTight_branch
    cdef float e3CiCTight_value

    cdef TBranch* e3CiCTightElecOverlap_branch
    cdef float e3CiCTightElecOverlap_value

    cdef TBranch* e3ComesFromHiggs_branch
    cdef float e3ComesFromHiggs_value

    cdef TBranch* e3DZ_branch
    cdef float e3DZ_value

    cdef TBranch* e3E1x5_branch
    cdef float e3E1x5_value

    cdef TBranch* e3E2x5Max_branch
    cdef float e3E2x5Max_value

    cdef TBranch* e3E5x5_branch
    cdef float e3E5x5_value

    cdef TBranch* e3ECorrReg_2012Jul13ReReco_branch
    cdef float e3ECorrReg_2012Jul13ReReco_value

    cdef TBranch* e3ECorrReg_Fall11_branch
    cdef float e3ECorrReg_Fall11_value

    cdef TBranch* e3ECorrReg_Jan16ReReco_branch
    cdef float e3ECorrReg_Jan16ReReco_value

    cdef TBranch* e3ECorrReg_Summer12_DR53X_HCP2012_branch
    cdef float e3ECorrReg_Summer12_DR53X_HCP2012_value

    cdef TBranch* e3ECorrSmearedNoReg_2012Jul13ReReco_branch
    cdef float e3ECorrSmearedNoReg_2012Jul13ReReco_value

    cdef TBranch* e3ECorrSmearedNoReg_Fall11_branch
    cdef float e3ECorrSmearedNoReg_Fall11_value

    cdef TBranch* e3ECorrSmearedNoReg_Jan16ReReco_branch
    cdef float e3ECorrSmearedNoReg_Jan16ReReco_value

    cdef TBranch* e3ECorrSmearedNoReg_Summer12_DR53X_HCP2012_branch
    cdef float e3ECorrSmearedNoReg_Summer12_DR53X_HCP2012_value

    cdef TBranch* e3ECorrSmearedReg_2012Jul13ReReco_branch
    cdef float e3ECorrSmearedReg_2012Jul13ReReco_value

    cdef TBranch* e3ECorrSmearedReg_Fall11_branch
    cdef float e3ECorrSmearedReg_Fall11_value

    cdef TBranch* e3ECorrSmearedReg_Jan16ReReco_branch
    cdef float e3ECorrSmearedReg_Jan16ReReco_value

    cdef TBranch* e3ECorrSmearedReg_Summer12_DR53X_HCP2012_branch
    cdef float e3ECorrSmearedReg_Summer12_DR53X_HCP2012_value

    cdef TBranch* e3EcalIsoDR03_branch
    cdef float e3EcalIsoDR03_value

    cdef TBranch* e3EffectiveArea2011Data_branch
    cdef float e3EffectiveArea2011Data_value

    cdef TBranch* e3EffectiveArea2012Data_branch
    cdef float e3EffectiveArea2012Data_value

    cdef TBranch* e3EffectiveAreaFall11MC_branch
    cdef float e3EffectiveAreaFall11MC_value

    cdef TBranch* e3Ele27WP80PFMT50PFMTFilter_branch
    cdef float e3Ele27WP80PFMT50PFMTFilter_value

    cdef TBranch* e3Ele27WP80TrackIsoMatchFilter_branch
    cdef float e3Ele27WP80TrackIsoMatchFilter_value

    cdef TBranch* e3Ele32WP70PFMT50PFMTFilter_branch
    cdef float e3Ele32WP70PFMT50PFMTFilter_value

    cdef TBranch* e3ElecOverlap_branch
    cdef float e3ElecOverlap_value

    cdef TBranch* e3ElecOverlapZHLoose_branch
    cdef float e3ElecOverlapZHLoose_value

    cdef TBranch* e3ElecOverlapZHTight_branch
    cdef float e3ElecOverlapZHTight_value

    cdef TBranch* e3EnergyError_branch
    cdef float e3EnergyError_value

    cdef TBranch* e3Eta_branch
    cdef float e3Eta_value

    cdef TBranch* e3EtaCorrReg_2012Jul13ReReco_branch
    cdef float e3EtaCorrReg_2012Jul13ReReco_value

    cdef TBranch* e3EtaCorrReg_Fall11_branch
    cdef float e3EtaCorrReg_Fall11_value

    cdef TBranch* e3EtaCorrReg_Jan16ReReco_branch
    cdef float e3EtaCorrReg_Jan16ReReco_value

    cdef TBranch* e3EtaCorrReg_Summer12_DR53X_HCP2012_branch
    cdef float e3EtaCorrReg_Summer12_DR53X_HCP2012_value

    cdef TBranch* e3EtaCorrSmearedNoReg_2012Jul13ReReco_branch
    cdef float e3EtaCorrSmearedNoReg_2012Jul13ReReco_value

    cdef TBranch* e3EtaCorrSmearedNoReg_Fall11_branch
    cdef float e3EtaCorrSmearedNoReg_Fall11_value

    cdef TBranch* e3EtaCorrSmearedNoReg_Jan16ReReco_branch
    cdef float e3EtaCorrSmearedNoReg_Jan16ReReco_value

    cdef TBranch* e3EtaCorrSmearedNoReg_Summer12_DR53X_HCP2012_branch
    cdef float e3EtaCorrSmearedNoReg_Summer12_DR53X_HCP2012_value

    cdef TBranch* e3EtaCorrSmearedReg_2012Jul13ReReco_branch
    cdef float e3EtaCorrSmearedReg_2012Jul13ReReco_value

    cdef TBranch* e3EtaCorrSmearedReg_Fall11_branch
    cdef float e3EtaCorrSmearedReg_Fall11_value

    cdef TBranch* e3EtaCorrSmearedReg_Jan16ReReco_branch
    cdef float e3EtaCorrSmearedReg_Jan16ReReco_value

    cdef TBranch* e3EtaCorrSmearedReg_Summer12_DR53X_HCP2012_branch
    cdef float e3EtaCorrSmearedReg_Summer12_DR53X_HCP2012_value

    cdef TBranch* e3GenCharge_branch
    cdef float e3GenCharge_value

    cdef TBranch* e3GenEnergy_branch
    cdef float e3GenEnergy_value

    cdef TBranch* e3GenEta_branch
    cdef float e3GenEta_value

    cdef TBranch* e3GenMotherPdgId_branch
    cdef float e3GenMotherPdgId_value

    cdef TBranch* e3GenPdgId_branch
    cdef float e3GenPdgId_value

    cdef TBranch* e3GenPhi_branch
    cdef float e3GenPhi_value

    cdef TBranch* e3HadronicDepth1OverEm_branch
    cdef float e3HadronicDepth1OverEm_value

    cdef TBranch* e3HadronicDepth2OverEm_branch
    cdef float e3HadronicDepth2OverEm_value

    cdef TBranch* e3HadronicOverEM_branch
    cdef float e3HadronicOverEM_value

    cdef TBranch* e3HasConversion_branch
    cdef float e3HasConversion_value

    cdef TBranch* e3HasMatchedConversion_branch
    cdef int e3HasMatchedConversion_value

    cdef TBranch* e3HcalIsoDR03_branch
    cdef float e3HcalIsoDR03_value

    cdef TBranch* e3IP3DS_branch
    cdef float e3IP3DS_value

    cdef TBranch* e3JetArea_branch
    cdef float e3JetArea_value

    cdef TBranch* e3JetBtag_branch
    cdef float e3JetBtag_value

    cdef TBranch* e3JetCSVBtag_branch
    cdef float e3JetCSVBtag_value

    cdef TBranch* e3JetEtaEtaMoment_branch
    cdef float e3JetEtaEtaMoment_value

    cdef TBranch* e3JetEtaPhiMoment_branch
    cdef float e3JetEtaPhiMoment_value

    cdef TBranch* e3JetEtaPhiSpread_branch
    cdef float e3JetEtaPhiSpread_value

    cdef TBranch* e3JetPartonFlavour_branch
    cdef float e3JetPartonFlavour_value

    cdef TBranch* e3JetPhiPhiMoment_branch
    cdef float e3JetPhiPhiMoment_value

    cdef TBranch* e3JetPt_branch
    cdef float e3JetPt_value

    cdef TBranch* e3JetQGLikelihoodID_branch
    cdef float e3JetQGLikelihoodID_value

    cdef TBranch* e3JetQGMVAID_branch
    cdef float e3JetQGMVAID_value

    cdef TBranch* e3Jetaxis1_branch
    cdef float e3Jetaxis1_value

    cdef TBranch* e3Jetaxis2_branch
    cdef float e3Jetaxis2_value

    cdef TBranch* e3Jetmult_branch
    cdef float e3Jetmult_value

    cdef TBranch* e3JetmultMLP_branch
    cdef float e3JetmultMLP_value

    cdef TBranch* e3JetmultMLPQC_branch
    cdef float e3JetmultMLPQC_value

    cdef TBranch* e3JetptD_branch
    cdef float e3JetptD_value

    cdef TBranch* e3L1NonIsoHLTNonIsoMu17Ele8PixelMatchFilter_branch
    cdef float e3L1NonIsoHLTNonIsoMu17Ele8PixelMatchFilter_value

    cdef TBranch* e3MITID_branch
    cdef float e3MITID_value

    cdef TBranch* e3MVAIDH2TauWP_branch
    cdef float e3MVAIDH2TauWP_value

    cdef TBranch* e3MVANonTrig_branch
    cdef float e3MVANonTrig_value

    cdef TBranch* e3MVATrig_branch
    cdef float e3MVATrig_value

    cdef TBranch* e3MVATrigIDISO_branch
    cdef float e3MVATrigIDISO_value

    cdef TBranch* e3MVATrigIDISOPUSUB_branch
    cdef float e3MVATrigIDISOPUSUB_value

    cdef TBranch* e3MVATrigNoIP_branch
    cdef float e3MVATrigNoIP_value

    cdef TBranch* e3Mass_branch
    cdef float e3Mass_value

    cdef TBranch* e3MatchesDoubleEPath_branch
    cdef float e3MatchesDoubleEPath_value

    cdef TBranch* e3MatchesMu17Ele8IsoPath_branch
    cdef float e3MatchesMu17Ele8IsoPath_value

    cdef TBranch* e3MatchesMu17Ele8Path_branch
    cdef float e3MatchesMu17Ele8Path_value

    cdef TBranch* e3MatchesMu8Ele17IsoPath_branch
    cdef float e3MatchesMu8Ele17IsoPath_value

    cdef TBranch* e3MatchesMu8Ele17Path_branch
    cdef float e3MatchesMu8Ele17Path_value

    cdef TBranch* e3MatchesSingleE_branch
    cdef float e3MatchesSingleE_value

    cdef TBranch* e3MatchesSingleEPlusMET_branch
    cdef float e3MatchesSingleEPlusMET_value

    cdef TBranch* e3MissingHits_branch
    cdef float e3MissingHits_value

    cdef TBranch* e3MtToMET_branch
    cdef float e3MtToMET_value

    cdef TBranch* e3MtToMVAMET_branch
    cdef float e3MtToMVAMET_value

    cdef TBranch* e3MtToPFMET_branch
    cdef float e3MtToPFMET_value

    cdef TBranch* e3MtToPfMet_Ty1_branch
    cdef float e3MtToPfMet_Ty1_value

    cdef TBranch* e3MtToPfMet_jes_branch
    cdef float e3MtToPfMet_jes_value

    cdef TBranch* e3MtToPfMet_mes_branch
    cdef float e3MtToPfMet_mes_value

    cdef TBranch* e3MtToPfMet_tes_branch
    cdef float e3MtToPfMet_tes_value

    cdef TBranch* e3MtToPfMet_ues_branch
    cdef float e3MtToPfMet_ues_value

    cdef TBranch* e3Mu17Ele8CaloIdTCaloIsoVLTrkIdVLTrkIsoVLTrackIsoFilter_branch
    cdef float e3Mu17Ele8CaloIdTCaloIsoVLTrkIdVLTrkIsoVLTrackIsoFilter_value

    cdef TBranch* e3Mu17Ele8CaloIdTPixelMatchFilter_branch
    cdef float e3Mu17Ele8CaloIdTPixelMatchFilter_value

    cdef TBranch* e3Mu17Ele8dZFilter_branch
    cdef float e3Mu17Ele8dZFilter_value

    cdef TBranch* e3MuOverlap_branch
    cdef float e3MuOverlap_value

    cdef TBranch* e3MuOverlapZHLoose_branch
    cdef float e3MuOverlapZHLoose_value

    cdef TBranch* e3MuOverlapZHTight_branch
    cdef float e3MuOverlapZHTight_value

    cdef TBranch* e3NearMuonVeto_branch
    cdef float e3NearMuonVeto_value

    cdef TBranch* e3PFChargedIso_branch
    cdef float e3PFChargedIso_value

    cdef TBranch* e3PFNeutralIso_branch
    cdef float e3PFNeutralIso_value

    cdef TBranch* e3PFPhotonIso_branch
    cdef float e3PFPhotonIso_value

    cdef TBranch* e3PVDXY_branch
    cdef float e3PVDXY_value

    cdef TBranch* e3PVDZ_branch
    cdef float e3PVDZ_value

    cdef TBranch* e3Phi_branch
    cdef float e3Phi_value

    cdef TBranch* e3PhiCorrReg_2012Jul13ReReco_branch
    cdef float e3PhiCorrReg_2012Jul13ReReco_value

    cdef TBranch* e3PhiCorrReg_Fall11_branch
    cdef float e3PhiCorrReg_Fall11_value

    cdef TBranch* e3PhiCorrReg_Jan16ReReco_branch
    cdef float e3PhiCorrReg_Jan16ReReco_value

    cdef TBranch* e3PhiCorrReg_Summer12_DR53X_HCP2012_branch
    cdef float e3PhiCorrReg_Summer12_DR53X_HCP2012_value

    cdef TBranch* e3PhiCorrSmearedNoReg_2012Jul13ReReco_branch
    cdef float e3PhiCorrSmearedNoReg_2012Jul13ReReco_value

    cdef TBranch* e3PhiCorrSmearedNoReg_Fall11_branch
    cdef float e3PhiCorrSmearedNoReg_Fall11_value

    cdef TBranch* e3PhiCorrSmearedNoReg_Jan16ReReco_branch
    cdef float e3PhiCorrSmearedNoReg_Jan16ReReco_value

    cdef TBranch* e3PhiCorrSmearedNoReg_Summer12_DR53X_HCP2012_branch
    cdef float e3PhiCorrSmearedNoReg_Summer12_DR53X_HCP2012_value

    cdef TBranch* e3PhiCorrSmearedReg_2012Jul13ReReco_branch
    cdef float e3PhiCorrSmearedReg_2012Jul13ReReco_value

    cdef TBranch* e3PhiCorrSmearedReg_Fall11_branch
    cdef float e3PhiCorrSmearedReg_Fall11_value

    cdef TBranch* e3PhiCorrSmearedReg_Jan16ReReco_branch
    cdef float e3PhiCorrSmearedReg_Jan16ReReco_value

    cdef TBranch* e3PhiCorrSmearedReg_Summer12_DR53X_HCP2012_branch
    cdef float e3PhiCorrSmearedReg_Summer12_DR53X_HCP2012_value

    cdef TBranch* e3Pt_branch
    cdef float e3Pt_value

    cdef TBranch* e3PtCorrReg_2012Jul13ReReco_branch
    cdef float e3PtCorrReg_2012Jul13ReReco_value

    cdef TBranch* e3PtCorrReg_Fall11_branch
    cdef float e3PtCorrReg_Fall11_value

    cdef TBranch* e3PtCorrReg_Jan16ReReco_branch
    cdef float e3PtCorrReg_Jan16ReReco_value

    cdef TBranch* e3PtCorrReg_Summer12_DR53X_HCP2012_branch
    cdef float e3PtCorrReg_Summer12_DR53X_HCP2012_value

    cdef TBranch* e3PtCorrSmearedNoReg_2012Jul13ReReco_branch
    cdef float e3PtCorrSmearedNoReg_2012Jul13ReReco_value

    cdef TBranch* e3PtCorrSmearedNoReg_Fall11_branch
    cdef float e3PtCorrSmearedNoReg_Fall11_value

    cdef TBranch* e3PtCorrSmearedNoReg_Jan16ReReco_branch
    cdef float e3PtCorrSmearedNoReg_Jan16ReReco_value

    cdef TBranch* e3PtCorrSmearedNoReg_Summer12_DR53X_HCP2012_branch
    cdef float e3PtCorrSmearedNoReg_Summer12_DR53X_HCP2012_value

    cdef TBranch* e3PtCorrSmearedReg_2012Jul13ReReco_branch
    cdef float e3PtCorrSmearedReg_2012Jul13ReReco_value

    cdef TBranch* e3PtCorrSmearedReg_Fall11_branch
    cdef float e3PtCorrSmearedReg_Fall11_value

    cdef TBranch* e3PtCorrSmearedReg_Jan16ReReco_branch
    cdef float e3PtCorrSmearedReg_Jan16ReReco_value

    cdef TBranch* e3PtCorrSmearedReg_Summer12_DR53X_HCP2012_branch
    cdef float e3PtCorrSmearedReg_Summer12_DR53X_HCP2012_value

    cdef TBranch* e3Rank_branch
    cdef float e3Rank_value

    cdef TBranch* e3RelIso_branch
    cdef float e3RelIso_value

    cdef TBranch* e3RelPFIsoDB_branch
    cdef float e3RelPFIsoDB_value

    cdef TBranch* e3RelPFIsoRho_branch
    cdef float e3RelPFIsoRho_value

    cdef TBranch* e3RelPFIsoRhoFSR_branch
    cdef float e3RelPFIsoRhoFSR_value

    cdef TBranch* e3RhoHZG2011_branch
    cdef float e3RhoHZG2011_value

    cdef TBranch* e3RhoHZG2012_branch
    cdef float e3RhoHZG2012_value

    cdef TBranch* e3SCEnergy_branch
    cdef float e3SCEnergy_value

    cdef TBranch* e3SCEta_branch
    cdef float e3SCEta_value

    cdef TBranch* e3SCEtaWidth_branch
    cdef float e3SCEtaWidth_value

    cdef TBranch* e3SCPhi_branch
    cdef float e3SCPhi_value

    cdef TBranch* e3SCPhiWidth_branch
    cdef float e3SCPhiWidth_value

    cdef TBranch* e3SCPreshowerEnergy_branch
    cdef float e3SCPreshowerEnergy_value

    cdef TBranch* e3SCRawEnergy_branch
    cdef float e3SCRawEnergy_value

    cdef TBranch* e3SigmaIEtaIEta_branch
    cdef float e3SigmaIEtaIEta_value

    cdef TBranch* e3ToMETDPhi_branch
    cdef float e3ToMETDPhi_value

    cdef TBranch* e3TrkIsoDR03_branch
    cdef float e3TrkIsoDR03_value

    cdef TBranch* e3VZ_branch
    cdef float e3VZ_value

    cdef TBranch* e3WWID_branch
    cdef float e3WWID_value

    cdef TBranch* e3_t_CosThetaStar_branch
    cdef float e3_t_CosThetaStar_value

    cdef TBranch* e3_t_DPhi_branch
    cdef float e3_t_DPhi_value

    cdef TBranch* e3_t_DR_branch
    cdef float e3_t_DR_value

    cdef TBranch* e3_t_Eta_branch
    cdef float e3_t_Eta_value

    cdef TBranch* e3_t_Mass_branch
    cdef float e3_t_Mass_value

    cdef TBranch* e3_t_MassFsr_branch
    cdef float e3_t_MassFsr_value

    cdef TBranch* e3_t_PZeta_branch
    cdef float e3_t_PZeta_value

    cdef TBranch* e3_t_PZetaVis_branch
    cdef float e3_t_PZetaVis_value

    cdef TBranch* e3_t_Phi_branch
    cdef float e3_t_Phi_value

    cdef TBranch* e3_t_Pt_branch
    cdef float e3_t_Pt_value

    cdef TBranch* e3_t_PtFsr_branch
    cdef float e3_t_PtFsr_value

    cdef TBranch* e3_t_SS_branch
    cdef float e3_t_SS_value

    cdef TBranch* e3_t_SVfitEta_branch
    cdef float e3_t_SVfitEta_value

    cdef TBranch* e3_t_SVfitMass_branch
    cdef float e3_t_SVfitMass_value

    cdef TBranch* e3_t_SVfitPhi_branch
    cdef float e3_t_SVfitPhi_value

    cdef TBranch* e3_t_SVfitPt_branch
    cdef float e3_t_SVfitPt_value

    cdef TBranch* e3_t_ToMETDPhi_Ty1_branch
    cdef float e3_t_ToMETDPhi_Ty1_value

    cdef TBranch* e3_t_Zcompat_branch
    cdef float e3_t_Zcompat_value

    cdef TBranch* e3dECorrReg_2012Jul13ReReco_branch
    cdef float e3dECorrReg_2012Jul13ReReco_value

    cdef TBranch* e3dECorrReg_Fall11_branch
    cdef float e3dECorrReg_Fall11_value

    cdef TBranch* e3dECorrReg_Jan16ReReco_branch
    cdef float e3dECorrReg_Jan16ReReco_value

    cdef TBranch* e3dECorrReg_Summer12_DR53X_HCP2012_branch
    cdef float e3dECorrReg_Summer12_DR53X_HCP2012_value

    cdef TBranch* e3dECorrSmearedNoReg_2012Jul13ReReco_branch
    cdef float e3dECorrSmearedNoReg_2012Jul13ReReco_value

    cdef TBranch* e3dECorrSmearedNoReg_Fall11_branch
    cdef float e3dECorrSmearedNoReg_Fall11_value

    cdef TBranch* e3dECorrSmearedNoReg_Jan16ReReco_branch
    cdef float e3dECorrSmearedNoReg_Jan16ReReco_value

    cdef TBranch* e3dECorrSmearedNoReg_Summer12_DR53X_HCP2012_branch
    cdef float e3dECorrSmearedNoReg_Summer12_DR53X_HCP2012_value

    cdef TBranch* e3dECorrSmearedReg_2012Jul13ReReco_branch
    cdef float e3dECorrSmearedReg_2012Jul13ReReco_value

    cdef TBranch* e3dECorrSmearedReg_Fall11_branch
    cdef float e3dECorrSmearedReg_Fall11_value

    cdef TBranch* e3dECorrSmearedReg_Jan16ReReco_branch
    cdef float e3dECorrSmearedReg_Jan16ReReco_value

    cdef TBranch* e3dECorrSmearedReg_Summer12_DR53X_HCP2012_branch
    cdef float e3dECorrSmearedReg_Summer12_DR53X_HCP2012_value

    cdef TBranch* e3deltaEtaSuperClusterTrackAtVtx_branch
    cdef float e3deltaEtaSuperClusterTrackAtVtx_value

    cdef TBranch* e3deltaPhiSuperClusterTrackAtVtx_branch
    cdef float e3deltaPhiSuperClusterTrackAtVtx_value

    cdef TBranch* e3eSuperClusterOverP_branch
    cdef float e3eSuperClusterOverP_value

    cdef TBranch* e3ecalEnergy_branch
    cdef float e3ecalEnergy_value

    cdef TBranch* e3fBrem_branch
    cdef float e3fBrem_value

    cdef TBranch* e3trackMomentumAtVtxP_branch
    cdef float e3trackMomentumAtVtxP_value

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
            warnings.warn( "EEETauTree: Expected branch EmbPtWeight does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("EmbPtWeight")
        else:
            self.EmbPtWeight_branch.SetAddress(<void*>&self.EmbPtWeight_value)

        #print "making LT"
        self.LT_branch = the_tree.GetBranch("LT")
        #if not self.LT_branch and "LT" not in self.complained:
        if not self.LT_branch and "LT":
            warnings.warn( "EEETauTree: Expected branch LT does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("LT")
        else:
            self.LT_branch.SetAddress(<void*>&self.LT_value)

        #print "making Mass"
        self.Mass_branch = the_tree.GetBranch("Mass")
        #if not self.Mass_branch and "Mass" not in self.complained:
        if not self.Mass_branch and "Mass":
            warnings.warn( "EEETauTree: Expected branch Mass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Mass")
        else:
            self.Mass_branch.SetAddress(<void*>&self.Mass_value)

        #print "making MassError"
        self.MassError_branch = the_tree.GetBranch("MassError")
        #if not self.MassError_branch and "MassError" not in self.complained:
        if not self.MassError_branch and "MassError":
            warnings.warn( "EEETauTree: Expected branch MassError does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("MassError")
        else:
            self.MassError_branch.SetAddress(<void*>&self.MassError_value)

        #print "making MassErrord1"
        self.MassErrord1_branch = the_tree.GetBranch("MassErrord1")
        #if not self.MassErrord1_branch and "MassErrord1" not in self.complained:
        if not self.MassErrord1_branch and "MassErrord1":
            warnings.warn( "EEETauTree: Expected branch MassErrord1 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("MassErrord1")
        else:
            self.MassErrord1_branch.SetAddress(<void*>&self.MassErrord1_value)

        #print "making MassErrord2"
        self.MassErrord2_branch = the_tree.GetBranch("MassErrord2")
        #if not self.MassErrord2_branch and "MassErrord2" not in self.complained:
        if not self.MassErrord2_branch and "MassErrord2":
            warnings.warn( "EEETauTree: Expected branch MassErrord2 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("MassErrord2")
        else:
            self.MassErrord2_branch.SetAddress(<void*>&self.MassErrord2_value)

        #print "making MassErrord3"
        self.MassErrord3_branch = the_tree.GetBranch("MassErrord3")
        #if not self.MassErrord3_branch and "MassErrord3" not in self.complained:
        if not self.MassErrord3_branch and "MassErrord3":
            warnings.warn( "EEETauTree: Expected branch MassErrord3 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("MassErrord3")
        else:
            self.MassErrord3_branch.SetAddress(<void*>&self.MassErrord3_value)

        #print "making MassErrord4"
        self.MassErrord4_branch = the_tree.GetBranch("MassErrord4")
        #if not self.MassErrord4_branch and "MassErrord4" not in self.complained:
        if not self.MassErrord4_branch and "MassErrord4":
            warnings.warn( "EEETauTree: Expected branch MassErrord4 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("MassErrord4")
        else:
            self.MassErrord4_branch.SetAddress(<void*>&self.MassErrord4_value)

        #print "making NUP"
        self.NUP_branch = the_tree.GetBranch("NUP")
        #if not self.NUP_branch and "NUP" not in self.complained:
        if not self.NUP_branch and "NUP":
            warnings.warn( "EEETauTree: Expected branch NUP does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("NUP")
        else:
            self.NUP_branch.SetAddress(<void*>&self.NUP_value)

        #print "making Pt"
        self.Pt_branch = the_tree.GetBranch("Pt")
        #if not self.Pt_branch and "Pt" not in self.complained:
        if not self.Pt_branch and "Pt":
            warnings.warn( "EEETauTree: Expected branch Pt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Pt")
        else:
            self.Pt_branch.SetAddress(<void*>&self.Pt_value)

        #print "making bjetCSVVeto"
        self.bjetCSVVeto_branch = the_tree.GetBranch("bjetCSVVeto")
        #if not self.bjetCSVVeto_branch and "bjetCSVVeto" not in self.complained:
        if not self.bjetCSVVeto_branch and "bjetCSVVeto":
            warnings.warn( "EEETauTree: Expected branch bjetCSVVeto does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("bjetCSVVeto")
        else:
            self.bjetCSVVeto_branch.SetAddress(<void*>&self.bjetCSVVeto_value)

        #print "making bjetCSVVeto30"
        self.bjetCSVVeto30_branch = the_tree.GetBranch("bjetCSVVeto30")
        #if not self.bjetCSVVeto30_branch and "bjetCSVVeto30" not in self.complained:
        if not self.bjetCSVVeto30_branch and "bjetCSVVeto30":
            warnings.warn( "EEETauTree: Expected branch bjetCSVVeto30 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("bjetCSVVeto30")
        else:
            self.bjetCSVVeto30_branch.SetAddress(<void*>&self.bjetCSVVeto30_value)

        #print "making bjetCSVVetoZHLike"
        self.bjetCSVVetoZHLike_branch = the_tree.GetBranch("bjetCSVVetoZHLike")
        #if not self.bjetCSVVetoZHLike_branch and "bjetCSVVetoZHLike" not in self.complained:
        if not self.bjetCSVVetoZHLike_branch and "bjetCSVVetoZHLike":
            warnings.warn( "EEETauTree: Expected branch bjetCSVVetoZHLike does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("bjetCSVVetoZHLike")
        else:
            self.bjetCSVVetoZHLike_branch.SetAddress(<void*>&self.bjetCSVVetoZHLike_value)

        #print "making bjetCSVVetoZHLikeNoJetId"
        self.bjetCSVVetoZHLikeNoJetId_branch = the_tree.GetBranch("bjetCSVVetoZHLikeNoJetId")
        #if not self.bjetCSVVetoZHLikeNoJetId_branch and "bjetCSVVetoZHLikeNoJetId" not in self.complained:
        if not self.bjetCSVVetoZHLikeNoJetId_branch and "bjetCSVVetoZHLikeNoJetId":
            warnings.warn( "EEETauTree: Expected branch bjetCSVVetoZHLikeNoJetId does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("bjetCSVVetoZHLikeNoJetId")
        else:
            self.bjetCSVVetoZHLikeNoJetId_branch.SetAddress(<void*>&self.bjetCSVVetoZHLikeNoJetId_value)

        #print "making bjetCSVVetoZHLikeNoJetId_2"
        self.bjetCSVVetoZHLikeNoJetId_2_branch = the_tree.GetBranch("bjetCSVVetoZHLikeNoJetId_2")
        #if not self.bjetCSVVetoZHLikeNoJetId_2_branch and "bjetCSVVetoZHLikeNoJetId_2" not in self.complained:
        if not self.bjetCSVVetoZHLikeNoJetId_2_branch and "bjetCSVVetoZHLikeNoJetId_2":
            warnings.warn( "EEETauTree: Expected branch bjetCSVVetoZHLikeNoJetId_2 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("bjetCSVVetoZHLikeNoJetId_2")
        else:
            self.bjetCSVVetoZHLikeNoJetId_2_branch.SetAddress(<void*>&self.bjetCSVVetoZHLikeNoJetId_2_value)

        #print "making bjetTightCountZH"
        self.bjetTightCountZH_branch = the_tree.GetBranch("bjetTightCountZH")
        #if not self.bjetTightCountZH_branch and "bjetTightCountZH" not in self.complained:
        if not self.bjetTightCountZH_branch and "bjetTightCountZH":
            warnings.warn( "EEETauTree: Expected branch bjetTightCountZH does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("bjetTightCountZH")
        else:
            self.bjetTightCountZH_branch.SetAddress(<void*>&self.bjetTightCountZH_value)

        #print "making bjetVeto"
        self.bjetVeto_branch = the_tree.GetBranch("bjetVeto")
        #if not self.bjetVeto_branch and "bjetVeto" not in self.complained:
        if not self.bjetVeto_branch and "bjetVeto":
            warnings.warn( "EEETauTree: Expected branch bjetVeto does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("bjetVeto")
        else:
            self.bjetVeto_branch.SetAddress(<void*>&self.bjetVeto_value)

        #print "making charge"
        self.charge_branch = the_tree.GetBranch("charge")
        #if not self.charge_branch and "charge" not in self.complained:
        if not self.charge_branch and "charge":
            warnings.warn( "EEETauTree: Expected branch charge does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("charge")
        else:
            self.charge_branch.SetAddress(<void*>&self.charge_value)

        #print "making doubleEExtraGroup"
        self.doubleEExtraGroup_branch = the_tree.GetBranch("doubleEExtraGroup")
        #if not self.doubleEExtraGroup_branch and "doubleEExtraGroup" not in self.complained:
        if not self.doubleEExtraGroup_branch and "doubleEExtraGroup":
            warnings.warn( "EEETauTree: Expected branch doubleEExtraGroup does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleEExtraGroup")
        else:
            self.doubleEExtraGroup_branch.SetAddress(<void*>&self.doubleEExtraGroup_value)

        #print "making doubleEExtraPass"
        self.doubleEExtraPass_branch = the_tree.GetBranch("doubleEExtraPass")
        #if not self.doubleEExtraPass_branch and "doubleEExtraPass" not in self.complained:
        if not self.doubleEExtraPass_branch and "doubleEExtraPass":
            warnings.warn( "EEETauTree: Expected branch doubleEExtraPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleEExtraPass")
        else:
            self.doubleEExtraPass_branch.SetAddress(<void*>&self.doubleEExtraPass_value)

        #print "making doubleEExtraPrescale"
        self.doubleEExtraPrescale_branch = the_tree.GetBranch("doubleEExtraPrescale")
        #if not self.doubleEExtraPrescale_branch and "doubleEExtraPrescale" not in self.complained:
        if not self.doubleEExtraPrescale_branch and "doubleEExtraPrescale":
            warnings.warn( "EEETauTree: Expected branch doubleEExtraPrescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleEExtraPrescale")
        else:
            self.doubleEExtraPrescale_branch.SetAddress(<void*>&self.doubleEExtraPrescale_value)

        #print "making doubleEGroup"
        self.doubleEGroup_branch = the_tree.GetBranch("doubleEGroup")
        #if not self.doubleEGroup_branch and "doubleEGroup" not in self.complained:
        if not self.doubleEGroup_branch and "doubleEGroup":
            warnings.warn( "EEETauTree: Expected branch doubleEGroup does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleEGroup")
        else:
            self.doubleEGroup_branch.SetAddress(<void*>&self.doubleEGroup_value)

        #print "making doubleEPass"
        self.doubleEPass_branch = the_tree.GetBranch("doubleEPass")
        #if not self.doubleEPass_branch and "doubleEPass" not in self.complained:
        if not self.doubleEPass_branch and "doubleEPass":
            warnings.warn( "EEETauTree: Expected branch doubleEPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleEPass")
        else:
            self.doubleEPass_branch.SetAddress(<void*>&self.doubleEPass_value)

        #print "making doubleEPrescale"
        self.doubleEPrescale_branch = the_tree.GetBranch("doubleEPrescale")
        #if not self.doubleEPrescale_branch and "doubleEPrescale" not in self.complained:
        if not self.doubleEPrescale_branch and "doubleEPrescale":
            warnings.warn( "EEETauTree: Expected branch doubleEPrescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleEPrescale")
        else:
            self.doubleEPrescale_branch.SetAddress(<void*>&self.doubleEPrescale_value)

        #print "making doubleETightGroup"
        self.doubleETightGroup_branch = the_tree.GetBranch("doubleETightGroup")
        #if not self.doubleETightGroup_branch and "doubleETightGroup" not in self.complained:
        if not self.doubleETightGroup_branch and "doubleETightGroup":
            warnings.warn( "EEETauTree: Expected branch doubleETightGroup does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleETightGroup")
        else:
            self.doubleETightGroup_branch.SetAddress(<void*>&self.doubleETightGroup_value)

        #print "making doubleETightPass"
        self.doubleETightPass_branch = the_tree.GetBranch("doubleETightPass")
        #if not self.doubleETightPass_branch and "doubleETightPass" not in self.complained:
        if not self.doubleETightPass_branch and "doubleETightPass":
            warnings.warn( "EEETauTree: Expected branch doubleETightPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleETightPass")
        else:
            self.doubleETightPass_branch.SetAddress(<void*>&self.doubleETightPass_value)

        #print "making doubleETightPrescale"
        self.doubleETightPrescale_branch = the_tree.GetBranch("doubleETightPrescale")
        #if not self.doubleETightPrescale_branch and "doubleETightPrescale" not in self.complained:
        if not self.doubleETightPrescale_branch and "doubleETightPrescale":
            warnings.warn( "EEETauTree: Expected branch doubleETightPrescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleETightPrescale")
        else:
            self.doubleETightPrescale_branch.SetAddress(<void*>&self.doubleETightPrescale_value)

        #print "making doubleMuGroup"
        self.doubleMuGroup_branch = the_tree.GetBranch("doubleMuGroup")
        #if not self.doubleMuGroup_branch and "doubleMuGroup" not in self.complained:
        if not self.doubleMuGroup_branch and "doubleMuGroup":
            warnings.warn( "EEETauTree: Expected branch doubleMuGroup does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleMuGroup")
        else:
            self.doubleMuGroup_branch.SetAddress(<void*>&self.doubleMuGroup_value)

        #print "making doubleMuPass"
        self.doubleMuPass_branch = the_tree.GetBranch("doubleMuPass")
        #if not self.doubleMuPass_branch and "doubleMuPass" not in self.complained:
        if not self.doubleMuPass_branch and "doubleMuPass":
            warnings.warn( "EEETauTree: Expected branch doubleMuPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleMuPass")
        else:
            self.doubleMuPass_branch.SetAddress(<void*>&self.doubleMuPass_value)

        #print "making doubleMuPrescale"
        self.doubleMuPrescale_branch = the_tree.GetBranch("doubleMuPrescale")
        #if not self.doubleMuPrescale_branch and "doubleMuPrescale" not in self.complained:
        if not self.doubleMuPrescale_branch and "doubleMuPrescale":
            warnings.warn( "EEETauTree: Expected branch doubleMuPrescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleMuPrescale")
        else:
            self.doubleMuPrescale_branch.SetAddress(<void*>&self.doubleMuPrescale_value)

        #print "making doubleMuTrkGroup"
        self.doubleMuTrkGroup_branch = the_tree.GetBranch("doubleMuTrkGroup")
        #if not self.doubleMuTrkGroup_branch and "doubleMuTrkGroup" not in self.complained:
        if not self.doubleMuTrkGroup_branch and "doubleMuTrkGroup":
            warnings.warn( "EEETauTree: Expected branch doubleMuTrkGroup does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleMuTrkGroup")
        else:
            self.doubleMuTrkGroup_branch.SetAddress(<void*>&self.doubleMuTrkGroup_value)

        #print "making doubleMuTrkPass"
        self.doubleMuTrkPass_branch = the_tree.GetBranch("doubleMuTrkPass")
        #if not self.doubleMuTrkPass_branch and "doubleMuTrkPass" not in self.complained:
        if not self.doubleMuTrkPass_branch and "doubleMuTrkPass":
            warnings.warn( "EEETauTree: Expected branch doubleMuTrkPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleMuTrkPass")
        else:
            self.doubleMuTrkPass_branch.SetAddress(<void*>&self.doubleMuTrkPass_value)

        #print "making doubleMuTrkPrescale"
        self.doubleMuTrkPrescale_branch = the_tree.GetBranch("doubleMuTrkPrescale")
        #if not self.doubleMuTrkPrescale_branch and "doubleMuTrkPrescale" not in self.complained:
        if not self.doubleMuTrkPrescale_branch and "doubleMuTrkPrescale":
            warnings.warn( "EEETauTree: Expected branch doubleMuTrkPrescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleMuTrkPrescale")
        else:
            self.doubleMuTrkPrescale_branch.SetAddress(<void*>&self.doubleMuTrkPrescale_value)

        #print "making doublePhoGroup"
        self.doublePhoGroup_branch = the_tree.GetBranch("doublePhoGroup")
        #if not self.doublePhoGroup_branch and "doublePhoGroup" not in self.complained:
        if not self.doublePhoGroup_branch and "doublePhoGroup":
            warnings.warn( "EEETauTree: Expected branch doublePhoGroup does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doublePhoGroup")
        else:
            self.doublePhoGroup_branch.SetAddress(<void*>&self.doublePhoGroup_value)

        #print "making doublePhoPass"
        self.doublePhoPass_branch = the_tree.GetBranch("doublePhoPass")
        #if not self.doublePhoPass_branch and "doublePhoPass" not in self.complained:
        if not self.doublePhoPass_branch and "doublePhoPass":
            warnings.warn( "EEETauTree: Expected branch doublePhoPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doublePhoPass")
        else:
            self.doublePhoPass_branch.SetAddress(<void*>&self.doublePhoPass_value)

        #print "making doublePhoPrescale"
        self.doublePhoPrescale_branch = the_tree.GetBranch("doublePhoPrescale")
        #if not self.doublePhoPrescale_branch and "doublePhoPrescale" not in self.complained:
        if not self.doublePhoPrescale_branch and "doublePhoPrescale":
            warnings.warn( "EEETauTree: Expected branch doublePhoPrescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doublePhoPrescale")
        else:
            self.doublePhoPrescale_branch.SetAddress(<void*>&self.doublePhoPrescale_value)

        #print "making e1AbsEta"
        self.e1AbsEta_branch = the_tree.GetBranch("e1AbsEta")
        #if not self.e1AbsEta_branch and "e1AbsEta" not in self.complained:
        if not self.e1AbsEta_branch and "e1AbsEta":
            warnings.warn( "EEETauTree: Expected branch e1AbsEta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1AbsEta")
        else:
            self.e1AbsEta_branch.SetAddress(<void*>&self.e1AbsEta_value)

        #print "making e1CBID_LOOSE"
        self.e1CBID_LOOSE_branch = the_tree.GetBranch("e1CBID_LOOSE")
        #if not self.e1CBID_LOOSE_branch and "e1CBID_LOOSE" not in self.complained:
        if not self.e1CBID_LOOSE_branch and "e1CBID_LOOSE":
            warnings.warn( "EEETauTree: Expected branch e1CBID_LOOSE does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1CBID_LOOSE")
        else:
            self.e1CBID_LOOSE_branch.SetAddress(<void*>&self.e1CBID_LOOSE_value)

        #print "making e1CBID_MEDIUM"
        self.e1CBID_MEDIUM_branch = the_tree.GetBranch("e1CBID_MEDIUM")
        #if not self.e1CBID_MEDIUM_branch and "e1CBID_MEDIUM" not in self.complained:
        if not self.e1CBID_MEDIUM_branch and "e1CBID_MEDIUM":
            warnings.warn( "EEETauTree: Expected branch e1CBID_MEDIUM does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1CBID_MEDIUM")
        else:
            self.e1CBID_MEDIUM_branch.SetAddress(<void*>&self.e1CBID_MEDIUM_value)

        #print "making e1CBID_TIGHT"
        self.e1CBID_TIGHT_branch = the_tree.GetBranch("e1CBID_TIGHT")
        #if not self.e1CBID_TIGHT_branch and "e1CBID_TIGHT" not in self.complained:
        if not self.e1CBID_TIGHT_branch and "e1CBID_TIGHT":
            warnings.warn( "EEETauTree: Expected branch e1CBID_TIGHT does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1CBID_TIGHT")
        else:
            self.e1CBID_TIGHT_branch.SetAddress(<void*>&self.e1CBID_TIGHT_value)

        #print "making e1CBID_VETO"
        self.e1CBID_VETO_branch = the_tree.GetBranch("e1CBID_VETO")
        #if not self.e1CBID_VETO_branch and "e1CBID_VETO" not in self.complained:
        if not self.e1CBID_VETO_branch and "e1CBID_VETO":
            warnings.warn( "EEETauTree: Expected branch e1CBID_VETO does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1CBID_VETO")
        else:
            self.e1CBID_VETO_branch.SetAddress(<void*>&self.e1CBID_VETO_value)

        #print "making e1Charge"
        self.e1Charge_branch = the_tree.GetBranch("e1Charge")
        #if not self.e1Charge_branch and "e1Charge" not in self.complained:
        if not self.e1Charge_branch and "e1Charge":
            warnings.warn( "EEETauTree: Expected branch e1Charge does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1Charge")
        else:
            self.e1Charge_branch.SetAddress(<void*>&self.e1Charge_value)

        #print "making e1ChargeIdLoose"
        self.e1ChargeIdLoose_branch = the_tree.GetBranch("e1ChargeIdLoose")
        #if not self.e1ChargeIdLoose_branch and "e1ChargeIdLoose" not in self.complained:
        if not self.e1ChargeIdLoose_branch and "e1ChargeIdLoose":
            warnings.warn( "EEETauTree: Expected branch e1ChargeIdLoose does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1ChargeIdLoose")
        else:
            self.e1ChargeIdLoose_branch.SetAddress(<void*>&self.e1ChargeIdLoose_value)

        #print "making e1ChargeIdMed"
        self.e1ChargeIdMed_branch = the_tree.GetBranch("e1ChargeIdMed")
        #if not self.e1ChargeIdMed_branch and "e1ChargeIdMed" not in self.complained:
        if not self.e1ChargeIdMed_branch and "e1ChargeIdMed":
            warnings.warn( "EEETauTree: Expected branch e1ChargeIdMed does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1ChargeIdMed")
        else:
            self.e1ChargeIdMed_branch.SetAddress(<void*>&self.e1ChargeIdMed_value)

        #print "making e1ChargeIdTight"
        self.e1ChargeIdTight_branch = the_tree.GetBranch("e1ChargeIdTight")
        #if not self.e1ChargeIdTight_branch and "e1ChargeIdTight" not in self.complained:
        if not self.e1ChargeIdTight_branch and "e1ChargeIdTight":
            warnings.warn( "EEETauTree: Expected branch e1ChargeIdTight does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1ChargeIdTight")
        else:
            self.e1ChargeIdTight_branch.SetAddress(<void*>&self.e1ChargeIdTight_value)

        #print "making e1CiCTight"
        self.e1CiCTight_branch = the_tree.GetBranch("e1CiCTight")
        #if not self.e1CiCTight_branch and "e1CiCTight" not in self.complained:
        if not self.e1CiCTight_branch and "e1CiCTight":
            warnings.warn( "EEETauTree: Expected branch e1CiCTight does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1CiCTight")
        else:
            self.e1CiCTight_branch.SetAddress(<void*>&self.e1CiCTight_value)

        #print "making e1CiCTightElecOverlap"
        self.e1CiCTightElecOverlap_branch = the_tree.GetBranch("e1CiCTightElecOverlap")
        #if not self.e1CiCTightElecOverlap_branch and "e1CiCTightElecOverlap" not in self.complained:
        if not self.e1CiCTightElecOverlap_branch and "e1CiCTightElecOverlap":
            warnings.warn( "EEETauTree: Expected branch e1CiCTightElecOverlap does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1CiCTightElecOverlap")
        else:
            self.e1CiCTightElecOverlap_branch.SetAddress(<void*>&self.e1CiCTightElecOverlap_value)

        #print "making e1ComesFromHiggs"
        self.e1ComesFromHiggs_branch = the_tree.GetBranch("e1ComesFromHiggs")
        #if not self.e1ComesFromHiggs_branch and "e1ComesFromHiggs" not in self.complained:
        if not self.e1ComesFromHiggs_branch and "e1ComesFromHiggs":
            warnings.warn( "EEETauTree: Expected branch e1ComesFromHiggs does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1ComesFromHiggs")
        else:
            self.e1ComesFromHiggs_branch.SetAddress(<void*>&self.e1ComesFromHiggs_value)

        #print "making e1DZ"
        self.e1DZ_branch = the_tree.GetBranch("e1DZ")
        #if not self.e1DZ_branch and "e1DZ" not in self.complained:
        if not self.e1DZ_branch and "e1DZ":
            warnings.warn( "EEETauTree: Expected branch e1DZ does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1DZ")
        else:
            self.e1DZ_branch.SetAddress(<void*>&self.e1DZ_value)

        #print "making e1E1x5"
        self.e1E1x5_branch = the_tree.GetBranch("e1E1x5")
        #if not self.e1E1x5_branch and "e1E1x5" not in self.complained:
        if not self.e1E1x5_branch and "e1E1x5":
            warnings.warn( "EEETauTree: Expected branch e1E1x5 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1E1x5")
        else:
            self.e1E1x5_branch.SetAddress(<void*>&self.e1E1x5_value)

        #print "making e1E2x5Max"
        self.e1E2x5Max_branch = the_tree.GetBranch("e1E2x5Max")
        #if not self.e1E2x5Max_branch and "e1E2x5Max" not in self.complained:
        if not self.e1E2x5Max_branch and "e1E2x5Max":
            warnings.warn( "EEETauTree: Expected branch e1E2x5Max does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1E2x5Max")
        else:
            self.e1E2x5Max_branch.SetAddress(<void*>&self.e1E2x5Max_value)

        #print "making e1E5x5"
        self.e1E5x5_branch = the_tree.GetBranch("e1E5x5")
        #if not self.e1E5x5_branch and "e1E5x5" not in self.complained:
        if not self.e1E5x5_branch and "e1E5x5":
            warnings.warn( "EEETauTree: Expected branch e1E5x5 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1E5x5")
        else:
            self.e1E5x5_branch.SetAddress(<void*>&self.e1E5x5_value)

        #print "making e1ECorrReg_2012Jul13ReReco"
        self.e1ECorrReg_2012Jul13ReReco_branch = the_tree.GetBranch("e1ECorrReg_2012Jul13ReReco")
        #if not self.e1ECorrReg_2012Jul13ReReco_branch and "e1ECorrReg_2012Jul13ReReco" not in self.complained:
        if not self.e1ECorrReg_2012Jul13ReReco_branch and "e1ECorrReg_2012Jul13ReReco":
            warnings.warn( "EEETauTree: Expected branch e1ECorrReg_2012Jul13ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1ECorrReg_2012Jul13ReReco")
        else:
            self.e1ECorrReg_2012Jul13ReReco_branch.SetAddress(<void*>&self.e1ECorrReg_2012Jul13ReReco_value)

        #print "making e1ECorrReg_Fall11"
        self.e1ECorrReg_Fall11_branch = the_tree.GetBranch("e1ECorrReg_Fall11")
        #if not self.e1ECorrReg_Fall11_branch and "e1ECorrReg_Fall11" not in self.complained:
        if not self.e1ECorrReg_Fall11_branch and "e1ECorrReg_Fall11":
            warnings.warn( "EEETauTree: Expected branch e1ECorrReg_Fall11 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1ECorrReg_Fall11")
        else:
            self.e1ECorrReg_Fall11_branch.SetAddress(<void*>&self.e1ECorrReg_Fall11_value)

        #print "making e1ECorrReg_Jan16ReReco"
        self.e1ECorrReg_Jan16ReReco_branch = the_tree.GetBranch("e1ECorrReg_Jan16ReReco")
        #if not self.e1ECorrReg_Jan16ReReco_branch and "e1ECorrReg_Jan16ReReco" not in self.complained:
        if not self.e1ECorrReg_Jan16ReReco_branch and "e1ECorrReg_Jan16ReReco":
            warnings.warn( "EEETauTree: Expected branch e1ECorrReg_Jan16ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1ECorrReg_Jan16ReReco")
        else:
            self.e1ECorrReg_Jan16ReReco_branch.SetAddress(<void*>&self.e1ECorrReg_Jan16ReReco_value)

        #print "making e1ECorrReg_Summer12_DR53X_HCP2012"
        self.e1ECorrReg_Summer12_DR53X_HCP2012_branch = the_tree.GetBranch("e1ECorrReg_Summer12_DR53X_HCP2012")
        #if not self.e1ECorrReg_Summer12_DR53X_HCP2012_branch and "e1ECorrReg_Summer12_DR53X_HCP2012" not in self.complained:
        if not self.e1ECorrReg_Summer12_DR53X_HCP2012_branch and "e1ECorrReg_Summer12_DR53X_HCP2012":
            warnings.warn( "EEETauTree: Expected branch e1ECorrReg_Summer12_DR53X_HCP2012 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1ECorrReg_Summer12_DR53X_HCP2012")
        else:
            self.e1ECorrReg_Summer12_DR53X_HCP2012_branch.SetAddress(<void*>&self.e1ECorrReg_Summer12_DR53X_HCP2012_value)

        #print "making e1ECorrSmearedNoReg_2012Jul13ReReco"
        self.e1ECorrSmearedNoReg_2012Jul13ReReco_branch = the_tree.GetBranch("e1ECorrSmearedNoReg_2012Jul13ReReco")
        #if not self.e1ECorrSmearedNoReg_2012Jul13ReReco_branch and "e1ECorrSmearedNoReg_2012Jul13ReReco" not in self.complained:
        if not self.e1ECorrSmearedNoReg_2012Jul13ReReco_branch and "e1ECorrSmearedNoReg_2012Jul13ReReco":
            warnings.warn( "EEETauTree: Expected branch e1ECorrSmearedNoReg_2012Jul13ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1ECorrSmearedNoReg_2012Jul13ReReco")
        else:
            self.e1ECorrSmearedNoReg_2012Jul13ReReco_branch.SetAddress(<void*>&self.e1ECorrSmearedNoReg_2012Jul13ReReco_value)

        #print "making e1ECorrSmearedNoReg_Fall11"
        self.e1ECorrSmearedNoReg_Fall11_branch = the_tree.GetBranch("e1ECorrSmearedNoReg_Fall11")
        #if not self.e1ECorrSmearedNoReg_Fall11_branch and "e1ECorrSmearedNoReg_Fall11" not in self.complained:
        if not self.e1ECorrSmearedNoReg_Fall11_branch and "e1ECorrSmearedNoReg_Fall11":
            warnings.warn( "EEETauTree: Expected branch e1ECorrSmearedNoReg_Fall11 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1ECorrSmearedNoReg_Fall11")
        else:
            self.e1ECorrSmearedNoReg_Fall11_branch.SetAddress(<void*>&self.e1ECorrSmearedNoReg_Fall11_value)

        #print "making e1ECorrSmearedNoReg_Jan16ReReco"
        self.e1ECorrSmearedNoReg_Jan16ReReco_branch = the_tree.GetBranch("e1ECorrSmearedNoReg_Jan16ReReco")
        #if not self.e1ECorrSmearedNoReg_Jan16ReReco_branch and "e1ECorrSmearedNoReg_Jan16ReReco" not in self.complained:
        if not self.e1ECorrSmearedNoReg_Jan16ReReco_branch and "e1ECorrSmearedNoReg_Jan16ReReco":
            warnings.warn( "EEETauTree: Expected branch e1ECorrSmearedNoReg_Jan16ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1ECorrSmearedNoReg_Jan16ReReco")
        else:
            self.e1ECorrSmearedNoReg_Jan16ReReco_branch.SetAddress(<void*>&self.e1ECorrSmearedNoReg_Jan16ReReco_value)

        #print "making e1ECorrSmearedNoReg_Summer12_DR53X_HCP2012"
        self.e1ECorrSmearedNoReg_Summer12_DR53X_HCP2012_branch = the_tree.GetBranch("e1ECorrSmearedNoReg_Summer12_DR53X_HCP2012")
        #if not self.e1ECorrSmearedNoReg_Summer12_DR53X_HCP2012_branch and "e1ECorrSmearedNoReg_Summer12_DR53X_HCP2012" not in self.complained:
        if not self.e1ECorrSmearedNoReg_Summer12_DR53X_HCP2012_branch and "e1ECorrSmearedNoReg_Summer12_DR53X_HCP2012":
            warnings.warn( "EEETauTree: Expected branch e1ECorrSmearedNoReg_Summer12_DR53X_HCP2012 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1ECorrSmearedNoReg_Summer12_DR53X_HCP2012")
        else:
            self.e1ECorrSmearedNoReg_Summer12_DR53X_HCP2012_branch.SetAddress(<void*>&self.e1ECorrSmearedNoReg_Summer12_DR53X_HCP2012_value)

        #print "making e1ECorrSmearedReg_2012Jul13ReReco"
        self.e1ECorrSmearedReg_2012Jul13ReReco_branch = the_tree.GetBranch("e1ECorrSmearedReg_2012Jul13ReReco")
        #if not self.e1ECorrSmearedReg_2012Jul13ReReco_branch and "e1ECorrSmearedReg_2012Jul13ReReco" not in self.complained:
        if not self.e1ECorrSmearedReg_2012Jul13ReReco_branch and "e1ECorrSmearedReg_2012Jul13ReReco":
            warnings.warn( "EEETauTree: Expected branch e1ECorrSmearedReg_2012Jul13ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1ECorrSmearedReg_2012Jul13ReReco")
        else:
            self.e1ECorrSmearedReg_2012Jul13ReReco_branch.SetAddress(<void*>&self.e1ECorrSmearedReg_2012Jul13ReReco_value)

        #print "making e1ECorrSmearedReg_Fall11"
        self.e1ECorrSmearedReg_Fall11_branch = the_tree.GetBranch("e1ECorrSmearedReg_Fall11")
        #if not self.e1ECorrSmearedReg_Fall11_branch and "e1ECorrSmearedReg_Fall11" not in self.complained:
        if not self.e1ECorrSmearedReg_Fall11_branch and "e1ECorrSmearedReg_Fall11":
            warnings.warn( "EEETauTree: Expected branch e1ECorrSmearedReg_Fall11 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1ECorrSmearedReg_Fall11")
        else:
            self.e1ECorrSmearedReg_Fall11_branch.SetAddress(<void*>&self.e1ECorrSmearedReg_Fall11_value)

        #print "making e1ECorrSmearedReg_Jan16ReReco"
        self.e1ECorrSmearedReg_Jan16ReReco_branch = the_tree.GetBranch("e1ECorrSmearedReg_Jan16ReReco")
        #if not self.e1ECorrSmearedReg_Jan16ReReco_branch and "e1ECorrSmearedReg_Jan16ReReco" not in self.complained:
        if not self.e1ECorrSmearedReg_Jan16ReReco_branch and "e1ECorrSmearedReg_Jan16ReReco":
            warnings.warn( "EEETauTree: Expected branch e1ECorrSmearedReg_Jan16ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1ECorrSmearedReg_Jan16ReReco")
        else:
            self.e1ECorrSmearedReg_Jan16ReReco_branch.SetAddress(<void*>&self.e1ECorrSmearedReg_Jan16ReReco_value)

        #print "making e1ECorrSmearedReg_Summer12_DR53X_HCP2012"
        self.e1ECorrSmearedReg_Summer12_DR53X_HCP2012_branch = the_tree.GetBranch("e1ECorrSmearedReg_Summer12_DR53X_HCP2012")
        #if not self.e1ECorrSmearedReg_Summer12_DR53X_HCP2012_branch and "e1ECorrSmearedReg_Summer12_DR53X_HCP2012" not in self.complained:
        if not self.e1ECorrSmearedReg_Summer12_DR53X_HCP2012_branch and "e1ECorrSmearedReg_Summer12_DR53X_HCP2012":
            warnings.warn( "EEETauTree: Expected branch e1ECorrSmearedReg_Summer12_DR53X_HCP2012 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1ECorrSmearedReg_Summer12_DR53X_HCP2012")
        else:
            self.e1ECorrSmearedReg_Summer12_DR53X_HCP2012_branch.SetAddress(<void*>&self.e1ECorrSmearedReg_Summer12_DR53X_HCP2012_value)

        #print "making e1EcalIsoDR03"
        self.e1EcalIsoDR03_branch = the_tree.GetBranch("e1EcalIsoDR03")
        #if not self.e1EcalIsoDR03_branch and "e1EcalIsoDR03" not in self.complained:
        if not self.e1EcalIsoDR03_branch and "e1EcalIsoDR03":
            warnings.warn( "EEETauTree: Expected branch e1EcalIsoDR03 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1EcalIsoDR03")
        else:
            self.e1EcalIsoDR03_branch.SetAddress(<void*>&self.e1EcalIsoDR03_value)

        #print "making e1EffectiveArea2011Data"
        self.e1EffectiveArea2011Data_branch = the_tree.GetBranch("e1EffectiveArea2011Data")
        #if not self.e1EffectiveArea2011Data_branch and "e1EffectiveArea2011Data" not in self.complained:
        if not self.e1EffectiveArea2011Data_branch and "e1EffectiveArea2011Data":
            warnings.warn( "EEETauTree: Expected branch e1EffectiveArea2011Data does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1EffectiveArea2011Data")
        else:
            self.e1EffectiveArea2011Data_branch.SetAddress(<void*>&self.e1EffectiveArea2011Data_value)

        #print "making e1EffectiveArea2012Data"
        self.e1EffectiveArea2012Data_branch = the_tree.GetBranch("e1EffectiveArea2012Data")
        #if not self.e1EffectiveArea2012Data_branch and "e1EffectiveArea2012Data" not in self.complained:
        if not self.e1EffectiveArea2012Data_branch and "e1EffectiveArea2012Data":
            warnings.warn( "EEETauTree: Expected branch e1EffectiveArea2012Data does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1EffectiveArea2012Data")
        else:
            self.e1EffectiveArea2012Data_branch.SetAddress(<void*>&self.e1EffectiveArea2012Data_value)

        #print "making e1EffectiveAreaFall11MC"
        self.e1EffectiveAreaFall11MC_branch = the_tree.GetBranch("e1EffectiveAreaFall11MC")
        #if not self.e1EffectiveAreaFall11MC_branch and "e1EffectiveAreaFall11MC" not in self.complained:
        if not self.e1EffectiveAreaFall11MC_branch and "e1EffectiveAreaFall11MC":
            warnings.warn( "EEETauTree: Expected branch e1EffectiveAreaFall11MC does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1EffectiveAreaFall11MC")
        else:
            self.e1EffectiveAreaFall11MC_branch.SetAddress(<void*>&self.e1EffectiveAreaFall11MC_value)

        #print "making e1Ele27WP80PFMT50PFMTFilter"
        self.e1Ele27WP80PFMT50PFMTFilter_branch = the_tree.GetBranch("e1Ele27WP80PFMT50PFMTFilter")
        #if not self.e1Ele27WP80PFMT50PFMTFilter_branch and "e1Ele27WP80PFMT50PFMTFilter" not in self.complained:
        if not self.e1Ele27WP80PFMT50PFMTFilter_branch and "e1Ele27WP80PFMT50PFMTFilter":
            warnings.warn( "EEETauTree: Expected branch e1Ele27WP80PFMT50PFMTFilter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1Ele27WP80PFMT50PFMTFilter")
        else:
            self.e1Ele27WP80PFMT50PFMTFilter_branch.SetAddress(<void*>&self.e1Ele27WP80PFMT50PFMTFilter_value)

        #print "making e1Ele27WP80TrackIsoMatchFilter"
        self.e1Ele27WP80TrackIsoMatchFilter_branch = the_tree.GetBranch("e1Ele27WP80TrackIsoMatchFilter")
        #if not self.e1Ele27WP80TrackIsoMatchFilter_branch and "e1Ele27WP80TrackIsoMatchFilter" not in self.complained:
        if not self.e1Ele27WP80TrackIsoMatchFilter_branch and "e1Ele27WP80TrackIsoMatchFilter":
            warnings.warn( "EEETauTree: Expected branch e1Ele27WP80TrackIsoMatchFilter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1Ele27WP80TrackIsoMatchFilter")
        else:
            self.e1Ele27WP80TrackIsoMatchFilter_branch.SetAddress(<void*>&self.e1Ele27WP80TrackIsoMatchFilter_value)

        #print "making e1Ele32WP70PFMT50PFMTFilter"
        self.e1Ele32WP70PFMT50PFMTFilter_branch = the_tree.GetBranch("e1Ele32WP70PFMT50PFMTFilter")
        #if not self.e1Ele32WP70PFMT50PFMTFilter_branch and "e1Ele32WP70PFMT50PFMTFilter" not in self.complained:
        if not self.e1Ele32WP70PFMT50PFMTFilter_branch and "e1Ele32WP70PFMT50PFMTFilter":
            warnings.warn( "EEETauTree: Expected branch e1Ele32WP70PFMT50PFMTFilter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1Ele32WP70PFMT50PFMTFilter")
        else:
            self.e1Ele32WP70PFMT50PFMTFilter_branch.SetAddress(<void*>&self.e1Ele32WP70PFMT50PFMTFilter_value)

        #print "making e1ElecOverlap"
        self.e1ElecOverlap_branch = the_tree.GetBranch("e1ElecOverlap")
        #if not self.e1ElecOverlap_branch and "e1ElecOverlap" not in self.complained:
        if not self.e1ElecOverlap_branch and "e1ElecOverlap":
            warnings.warn( "EEETauTree: Expected branch e1ElecOverlap does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1ElecOverlap")
        else:
            self.e1ElecOverlap_branch.SetAddress(<void*>&self.e1ElecOverlap_value)

        #print "making e1ElecOverlapZHLoose"
        self.e1ElecOverlapZHLoose_branch = the_tree.GetBranch("e1ElecOverlapZHLoose")
        #if not self.e1ElecOverlapZHLoose_branch and "e1ElecOverlapZHLoose" not in self.complained:
        if not self.e1ElecOverlapZHLoose_branch and "e1ElecOverlapZHLoose":
            warnings.warn( "EEETauTree: Expected branch e1ElecOverlapZHLoose does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1ElecOverlapZHLoose")
        else:
            self.e1ElecOverlapZHLoose_branch.SetAddress(<void*>&self.e1ElecOverlapZHLoose_value)

        #print "making e1ElecOverlapZHTight"
        self.e1ElecOverlapZHTight_branch = the_tree.GetBranch("e1ElecOverlapZHTight")
        #if not self.e1ElecOverlapZHTight_branch and "e1ElecOverlapZHTight" not in self.complained:
        if not self.e1ElecOverlapZHTight_branch and "e1ElecOverlapZHTight":
            warnings.warn( "EEETauTree: Expected branch e1ElecOverlapZHTight does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1ElecOverlapZHTight")
        else:
            self.e1ElecOverlapZHTight_branch.SetAddress(<void*>&self.e1ElecOverlapZHTight_value)

        #print "making e1EnergyError"
        self.e1EnergyError_branch = the_tree.GetBranch("e1EnergyError")
        #if not self.e1EnergyError_branch and "e1EnergyError" not in self.complained:
        if not self.e1EnergyError_branch and "e1EnergyError":
            warnings.warn( "EEETauTree: Expected branch e1EnergyError does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1EnergyError")
        else:
            self.e1EnergyError_branch.SetAddress(<void*>&self.e1EnergyError_value)

        #print "making e1Eta"
        self.e1Eta_branch = the_tree.GetBranch("e1Eta")
        #if not self.e1Eta_branch and "e1Eta" not in self.complained:
        if not self.e1Eta_branch and "e1Eta":
            warnings.warn( "EEETauTree: Expected branch e1Eta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1Eta")
        else:
            self.e1Eta_branch.SetAddress(<void*>&self.e1Eta_value)

        #print "making e1EtaCorrReg_2012Jul13ReReco"
        self.e1EtaCorrReg_2012Jul13ReReco_branch = the_tree.GetBranch("e1EtaCorrReg_2012Jul13ReReco")
        #if not self.e1EtaCorrReg_2012Jul13ReReco_branch and "e1EtaCorrReg_2012Jul13ReReco" not in self.complained:
        if not self.e1EtaCorrReg_2012Jul13ReReco_branch and "e1EtaCorrReg_2012Jul13ReReco":
            warnings.warn( "EEETauTree: Expected branch e1EtaCorrReg_2012Jul13ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1EtaCorrReg_2012Jul13ReReco")
        else:
            self.e1EtaCorrReg_2012Jul13ReReco_branch.SetAddress(<void*>&self.e1EtaCorrReg_2012Jul13ReReco_value)

        #print "making e1EtaCorrReg_Fall11"
        self.e1EtaCorrReg_Fall11_branch = the_tree.GetBranch("e1EtaCorrReg_Fall11")
        #if not self.e1EtaCorrReg_Fall11_branch and "e1EtaCorrReg_Fall11" not in self.complained:
        if not self.e1EtaCorrReg_Fall11_branch and "e1EtaCorrReg_Fall11":
            warnings.warn( "EEETauTree: Expected branch e1EtaCorrReg_Fall11 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1EtaCorrReg_Fall11")
        else:
            self.e1EtaCorrReg_Fall11_branch.SetAddress(<void*>&self.e1EtaCorrReg_Fall11_value)

        #print "making e1EtaCorrReg_Jan16ReReco"
        self.e1EtaCorrReg_Jan16ReReco_branch = the_tree.GetBranch("e1EtaCorrReg_Jan16ReReco")
        #if not self.e1EtaCorrReg_Jan16ReReco_branch and "e1EtaCorrReg_Jan16ReReco" not in self.complained:
        if not self.e1EtaCorrReg_Jan16ReReco_branch and "e1EtaCorrReg_Jan16ReReco":
            warnings.warn( "EEETauTree: Expected branch e1EtaCorrReg_Jan16ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1EtaCorrReg_Jan16ReReco")
        else:
            self.e1EtaCorrReg_Jan16ReReco_branch.SetAddress(<void*>&self.e1EtaCorrReg_Jan16ReReco_value)

        #print "making e1EtaCorrReg_Summer12_DR53X_HCP2012"
        self.e1EtaCorrReg_Summer12_DR53X_HCP2012_branch = the_tree.GetBranch("e1EtaCorrReg_Summer12_DR53X_HCP2012")
        #if not self.e1EtaCorrReg_Summer12_DR53X_HCP2012_branch and "e1EtaCorrReg_Summer12_DR53X_HCP2012" not in self.complained:
        if not self.e1EtaCorrReg_Summer12_DR53X_HCP2012_branch and "e1EtaCorrReg_Summer12_DR53X_HCP2012":
            warnings.warn( "EEETauTree: Expected branch e1EtaCorrReg_Summer12_DR53X_HCP2012 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1EtaCorrReg_Summer12_DR53X_HCP2012")
        else:
            self.e1EtaCorrReg_Summer12_DR53X_HCP2012_branch.SetAddress(<void*>&self.e1EtaCorrReg_Summer12_DR53X_HCP2012_value)

        #print "making e1EtaCorrSmearedNoReg_2012Jul13ReReco"
        self.e1EtaCorrSmearedNoReg_2012Jul13ReReco_branch = the_tree.GetBranch("e1EtaCorrSmearedNoReg_2012Jul13ReReco")
        #if not self.e1EtaCorrSmearedNoReg_2012Jul13ReReco_branch and "e1EtaCorrSmearedNoReg_2012Jul13ReReco" not in self.complained:
        if not self.e1EtaCorrSmearedNoReg_2012Jul13ReReco_branch and "e1EtaCorrSmearedNoReg_2012Jul13ReReco":
            warnings.warn( "EEETauTree: Expected branch e1EtaCorrSmearedNoReg_2012Jul13ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1EtaCorrSmearedNoReg_2012Jul13ReReco")
        else:
            self.e1EtaCorrSmearedNoReg_2012Jul13ReReco_branch.SetAddress(<void*>&self.e1EtaCorrSmearedNoReg_2012Jul13ReReco_value)

        #print "making e1EtaCorrSmearedNoReg_Fall11"
        self.e1EtaCorrSmearedNoReg_Fall11_branch = the_tree.GetBranch("e1EtaCorrSmearedNoReg_Fall11")
        #if not self.e1EtaCorrSmearedNoReg_Fall11_branch and "e1EtaCorrSmearedNoReg_Fall11" not in self.complained:
        if not self.e1EtaCorrSmearedNoReg_Fall11_branch and "e1EtaCorrSmearedNoReg_Fall11":
            warnings.warn( "EEETauTree: Expected branch e1EtaCorrSmearedNoReg_Fall11 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1EtaCorrSmearedNoReg_Fall11")
        else:
            self.e1EtaCorrSmearedNoReg_Fall11_branch.SetAddress(<void*>&self.e1EtaCorrSmearedNoReg_Fall11_value)

        #print "making e1EtaCorrSmearedNoReg_Jan16ReReco"
        self.e1EtaCorrSmearedNoReg_Jan16ReReco_branch = the_tree.GetBranch("e1EtaCorrSmearedNoReg_Jan16ReReco")
        #if not self.e1EtaCorrSmearedNoReg_Jan16ReReco_branch and "e1EtaCorrSmearedNoReg_Jan16ReReco" not in self.complained:
        if not self.e1EtaCorrSmearedNoReg_Jan16ReReco_branch and "e1EtaCorrSmearedNoReg_Jan16ReReco":
            warnings.warn( "EEETauTree: Expected branch e1EtaCorrSmearedNoReg_Jan16ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1EtaCorrSmearedNoReg_Jan16ReReco")
        else:
            self.e1EtaCorrSmearedNoReg_Jan16ReReco_branch.SetAddress(<void*>&self.e1EtaCorrSmearedNoReg_Jan16ReReco_value)

        #print "making e1EtaCorrSmearedNoReg_Summer12_DR53X_HCP2012"
        self.e1EtaCorrSmearedNoReg_Summer12_DR53X_HCP2012_branch = the_tree.GetBranch("e1EtaCorrSmearedNoReg_Summer12_DR53X_HCP2012")
        #if not self.e1EtaCorrSmearedNoReg_Summer12_DR53X_HCP2012_branch and "e1EtaCorrSmearedNoReg_Summer12_DR53X_HCP2012" not in self.complained:
        if not self.e1EtaCorrSmearedNoReg_Summer12_DR53X_HCP2012_branch and "e1EtaCorrSmearedNoReg_Summer12_DR53X_HCP2012":
            warnings.warn( "EEETauTree: Expected branch e1EtaCorrSmearedNoReg_Summer12_DR53X_HCP2012 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1EtaCorrSmearedNoReg_Summer12_DR53X_HCP2012")
        else:
            self.e1EtaCorrSmearedNoReg_Summer12_DR53X_HCP2012_branch.SetAddress(<void*>&self.e1EtaCorrSmearedNoReg_Summer12_DR53X_HCP2012_value)

        #print "making e1EtaCorrSmearedReg_2012Jul13ReReco"
        self.e1EtaCorrSmearedReg_2012Jul13ReReco_branch = the_tree.GetBranch("e1EtaCorrSmearedReg_2012Jul13ReReco")
        #if not self.e1EtaCorrSmearedReg_2012Jul13ReReco_branch and "e1EtaCorrSmearedReg_2012Jul13ReReco" not in self.complained:
        if not self.e1EtaCorrSmearedReg_2012Jul13ReReco_branch and "e1EtaCorrSmearedReg_2012Jul13ReReco":
            warnings.warn( "EEETauTree: Expected branch e1EtaCorrSmearedReg_2012Jul13ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1EtaCorrSmearedReg_2012Jul13ReReco")
        else:
            self.e1EtaCorrSmearedReg_2012Jul13ReReco_branch.SetAddress(<void*>&self.e1EtaCorrSmearedReg_2012Jul13ReReco_value)

        #print "making e1EtaCorrSmearedReg_Fall11"
        self.e1EtaCorrSmearedReg_Fall11_branch = the_tree.GetBranch("e1EtaCorrSmearedReg_Fall11")
        #if not self.e1EtaCorrSmearedReg_Fall11_branch and "e1EtaCorrSmearedReg_Fall11" not in self.complained:
        if not self.e1EtaCorrSmearedReg_Fall11_branch and "e1EtaCorrSmearedReg_Fall11":
            warnings.warn( "EEETauTree: Expected branch e1EtaCorrSmearedReg_Fall11 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1EtaCorrSmearedReg_Fall11")
        else:
            self.e1EtaCorrSmearedReg_Fall11_branch.SetAddress(<void*>&self.e1EtaCorrSmearedReg_Fall11_value)

        #print "making e1EtaCorrSmearedReg_Jan16ReReco"
        self.e1EtaCorrSmearedReg_Jan16ReReco_branch = the_tree.GetBranch("e1EtaCorrSmearedReg_Jan16ReReco")
        #if not self.e1EtaCorrSmearedReg_Jan16ReReco_branch and "e1EtaCorrSmearedReg_Jan16ReReco" not in self.complained:
        if not self.e1EtaCorrSmearedReg_Jan16ReReco_branch and "e1EtaCorrSmearedReg_Jan16ReReco":
            warnings.warn( "EEETauTree: Expected branch e1EtaCorrSmearedReg_Jan16ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1EtaCorrSmearedReg_Jan16ReReco")
        else:
            self.e1EtaCorrSmearedReg_Jan16ReReco_branch.SetAddress(<void*>&self.e1EtaCorrSmearedReg_Jan16ReReco_value)

        #print "making e1EtaCorrSmearedReg_Summer12_DR53X_HCP2012"
        self.e1EtaCorrSmearedReg_Summer12_DR53X_HCP2012_branch = the_tree.GetBranch("e1EtaCorrSmearedReg_Summer12_DR53X_HCP2012")
        #if not self.e1EtaCorrSmearedReg_Summer12_DR53X_HCP2012_branch and "e1EtaCorrSmearedReg_Summer12_DR53X_HCP2012" not in self.complained:
        if not self.e1EtaCorrSmearedReg_Summer12_DR53X_HCP2012_branch and "e1EtaCorrSmearedReg_Summer12_DR53X_HCP2012":
            warnings.warn( "EEETauTree: Expected branch e1EtaCorrSmearedReg_Summer12_DR53X_HCP2012 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1EtaCorrSmearedReg_Summer12_DR53X_HCP2012")
        else:
            self.e1EtaCorrSmearedReg_Summer12_DR53X_HCP2012_branch.SetAddress(<void*>&self.e1EtaCorrSmearedReg_Summer12_DR53X_HCP2012_value)

        #print "making e1GenCharge"
        self.e1GenCharge_branch = the_tree.GetBranch("e1GenCharge")
        #if not self.e1GenCharge_branch and "e1GenCharge" not in self.complained:
        if not self.e1GenCharge_branch and "e1GenCharge":
            warnings.warn( "EEETauTree: Expected branch e1GenCharge does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1GenCharge")
        else:
            self.e1GenCharge_branch.SetAddress(<void*>&self.e1GenCharge_value)

        #print "making e1GenEnergy"
        self.e1GenEnergy_branch = the_tree.GetBranch("e1GenEnergy")
        #if not self.e1GenEnergy_branch and "e1GenEnergy" not in self.complained:
        if not self.e1GenEnergy_branch and "e1GenEnergy":
            warnings.warn( "EEETauTree: Expected branch e1GenEnergy does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1GenEnergy")
        else:
            self.e1GenEnergy_branch.SetAddress(<void*>&self.e1GenEnergy_value)

        #print "making e1GenEta"
        self.e1GenEta_branch = the_tree.GetBranch("e1GenEta")
        #if not self.e1GenEta_branch and "e1GenEta" not in self.complained:
        if not self.e1GenEta_branch and "e1GenEta":
            warnings.warn( "EEETauTree: Expected branch e1GenEta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1GenEta")
        else:
            self.e1GenEta_branch.SetAddress(<void*>&self.e1GenEta_value)

        #print "making e1GenMotherPdgId"
        self.e1GenMotherPdgId_branch = the_tree.GetBranch("e1GenMotherPdgId")
        #if not self.e1GenMotherPdgId_branch and "e1GenMotherPdgId" not in self.complained:
        if not self.e1GenMotherPdgId_branch and "e1GenMotherPdgId":
            warnings.warn( "EEETauTree: Expected branch e1GenMotherPdgId does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1GenMotherPdgId")
        else:
            self.e1GenMotherPdgId_branch.SetAddress(<void*>&self.e1GenMotherPdgId_value)

        #print "making e1GenPdgId"
        self.e1GenPdgId_branch = the_tree.GetBranch("e1GenPdgId")
        #if not self.e1GenPdgId_branch and "e1GenPdgId" not in self.complained:
        if not self.e1GenPdgId_branch and "e1GenPdgId":
            warnings.warn( "EEETauTree: Expected branch e1GenPdgId does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1GenPdgId")
        else:
            self.e1GenPdgId_branch.SetAddress(<void*>&self.e1GenPdgId_value)

        #print "making e1GenPhi"
        self.e1GenPhi_branch = the_tree.GetBranch("e1GenPhi")
        #if not self.e1GenPhi_branch and "e1GenPhi" not in self.complained:
        if not self.e1GenPhi_branch and "e1GenPhi":
            warnings.warn( "EEETauTree: Expected branch e1GenPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1GenPhi")
        else:
            self.e1GenPhi_branch.SetAddress(<void*>&self.e1GenPhi_value)

        #print "making e1HadronicDepth1OverEm"
        self.e1HadronicDepth1OverEm_branch = the_tree.GetBranch("e1HadronicDepth1OverEm")
        #if not self.e1HadronicDepth1OverEm_branch and "e1HadronicDepth1OverEm" not in self.complained:
        if not self.e1HadronicDepth1OverEm_branch and "e1HadronicDepth1OverEm":
            warnings.warn( "EEETauTree: Expected branch e1HadronicDepth1OverEm does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1HadronicDepth1OverEm")
        else:
            self.e1HadronicDepth1OverEm_branch.SetAddress(<void*>&self.e1HadronicDepth1OverEm_value)

        #print "making e1HadronicDepth2OverEm"
        self.e1HadronicDepth2OverEm_branch = the_tree.GetBranch("e1HadronicDepth2OverEm")
        #if not self.e1HadronicDepth2OverEm_branch and "e1HadronicDepth2OverEm" not in self.complained:
        if not self.e1HadronicDepth2OverEm_branch and "e1HadronicDepth2OverEm":
            warnings.warn( "EEETauTree: Expected branch e1HadronicDepth2OverEm does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1HadronicDepth2OverEm")
        else:
            self.e1HadronicDepth2OverEm_branch.SetAddress(<void*>&self.e1HadronicDepth2OverEm_value)

        #print "making e1HadronicOverEM"
        self.e1HadronicOverEM_branch = the_tree.GetBranch("e1HadronicOverEM")
        #if not self.e1HadronicOverEM_branch and "e1HadronicOverEM" not in self.complained:
        if not self.e1HadronicOverEM_branch and "e1HadronicOverEM":
            warnings.warn( "EEETauTree: Expected branch e1HadronicOverEM does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1HadronicOverEM")
        else:
            self.e1HadronicOverEM_branch.SetAddress(<void*>&self.e1HadronicOverEM_value)

        #print "making e1HasConversion"
        self.e1HasConversion_branch = the_tree.GetBranch("e1HasConversion")
        #if not self.e1HasConversion_branch and "e1HasConversion" not in self.complained:
        if not self.e1HasConversion_branch and "e1HasConversion":
            warnings.warn( "EEETauTree: Expected branch e1HasConversion does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1HasConversion")
        else:
            self.e1HasConversion_branch.SetAddress(<void*>&self.e1HasConversion_value)

        #print "making e1HasMatchedConversion"
        self.e1HasMatchedConversion_branch = the_tree.GetBranch("e1HasMatchedConversion")
        #if not self.e1HasMatchedConversion_branch and "e1HasMatchedConversion" not in self.complained:
        if not self.e1HasMatchedConversion_branch and "e1HasMatchedConversion":
            warnings.warn( "EEETauTree: Expected branch e1HasMatchedConversion does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1HasMatchedConversion")
        else:
            self.e1HasMatchedConversion_branch.SetAddress(<void*>&self.e1HasMatchedConversion_value)

        #print "making e1HcalIsoDR03"
        self.e1HcalIsoDR03_branch = the_tree.GetBranch("e1HcalIsoDR03")
        #if not self.e1HcalIsoDR03_branch and "e1HcalIsoDR03" not in self.complained:
        if not self.e1HcalIsoDR03_branch and "e1HcalIsoDR03":
            warnings.warn( "EEETauTree: Expected branch e1HcalIsoDR03 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1HcalIsoDR03")
        else:
            self.e1HcalIsoDR03_branch.SetAddress(<void*>&self.e1HcalIsoDR03_value)

        #print "making e1IP3DS"
        self.e1IP3DS_branch = the_tree.GetBranch("e1IP3DS")
        #if not self.e1IP3DS_branch and "e1IP3DS" not in self.complained:
        if not self.e1IP3DS_branch and "e1IP3DS":
            warnings.warn( "EEETauTree: Expected branch e1IP3DS does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1IP3DS")
        else:
            self.e1IP3DS_branch.SetAddress(<void*>&self.e1IP3DS_value)

        #print "making e1JetArea"
        self.e1JetArea_branch = the_tree.GetBranch("e1JetArea")
        #if not self.e1JetArea_branch and "e1JetArea" not in self.complained:
        if not self.e1JetArea_branch and "e1JetArea":
            warnings.warn( "EEETauTree: Expected branch e1JetArea does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1JetArea")
        else:
            self.e1JetArea_branch.SetAddress(<void*>&self.e1JetArea_value)

        #print "making e1JetBtag"
        self.e1JetBtag_branch = the_tree.GetBranch("e1JetBtag")
        #if not self.e1JetBtag_branch and "e1JetBtag" not in self.complained:
        if not self.e1JetBtag_branch and "e1JetBtag":
            warnings.warn( "EEETauTree: Expected branch e1JetBtag does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1JetBtag")
        else:
            self.e1JetBtag_branch.SetAddress(<void*>&self.e1JetBtag_value)

        #print "making e1JetCSVBtag"
        self.e1JetCSVBtag_branch = the_tree.GetBranch("e1JetCSVBtag")
        #if not self.e1JetCSVBtag_branch and "e1JetCSVBtag" not in self.complained:
        if not self.e1JetCSVBtag_branch and "e1JetCSVBtag":
            warnings.warn( "EEETauTree: Expected branch e1JetCSVBtag does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1JetCSVBtag")
        else:
            self.e1JetCSVBtag_branch.SetAddress(<void*>&self.e1JetCSVBtag_value)

        #print "making e1JetEtaEtaMoment"
        self.e1JetEtaEtaMoment_branch = the_tree.GetBranch("e1JetEtaEtaMoment")
        #if not self.e1JetEtaEtaMoment_branch and "e1JetEtaEtaMoment" not in self.complained:
        if not self.e1JetEtaEtaMoment_branch and "e1JetEtaEtaMoment":
            warnings.warn( "EEETauTree: Expected branch e1JetEtaEtaMoment does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1JetEtaEtaMoment")
        else:
            self.e1JetEtaEtaMoment_branch.SetAddress(<void*>&self.e1JetEtaEtaMoment_value)

        #print "making e1JetEtaPhiMoment"
        self.e1JetEtaPhiMoment_branch = the_tree.GetBranch("e1JetEtaPhiMoment")
        #if not self.e1JetEtaPhiMoment_branch and "e1JetEtaPhiMoment" not in self.complained:
        if not self.e1JetEtaPhiMoment_branch and "e1JetEtaPhiMoment":
            warnings.warn( "EEETauTree: Expected branch e1JetEtaPhiMoment does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1JetEtaPhiMoment")
        else:
            self.e1JetEtaPhiMoment_branch.SetAddress(<void*>&self.e1JetEtaPhiMoment_value)

        #print "making e1JetEtaPhiSpread"
        self.e1JetEtaPhiSpread_branch = the_tree.GetBranch("e1JetEtaPhiSpread")
        #if not self.e1JetEtaPhiSpread_branch and "e1JetEtaPhiSpread" not in self.complained:
        if not self.e1JetEtaPhiSpread_branch and "e1JetEtaPhiSpread":
            warnings.warn( "EEETauTree: Expected branch e1JetEtaPhiSpread does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1JetEtaPhiSpread")
        else:
            self.e1JetEtaPhiSpread_branch.SetAddress(<void*>&self.e1JetEtaPhiSpread_value)

        #print "making e1JetPartonFlavour"
        self.e1JetPartonFlavour_branch = the_tree.GetBranch("e1JetPartonFlavour")
        #if not self.e1JetPartonFlavour_branch and "e1JetPartonFlavour" not in self.complained:
        if not self.e1JetPartonFlavour_branch and "e1JetPartonFlavour":
            warnings.warn( "EEETauTree: Expected branch e1JetPartonFlavour does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1JetPartonFlavour")
        else:
            self.e1JetPartonFlavour_branch.SetAddress(<void*>&self.e1JetPartonFlavour_value)

        #print "making e1JetPhiPhiMoment"
        self.e1JetPhiPhiMoment_branch = the_tree.GetBranch("e1JetPhiPhiMoment")
        #if not self.e1JetPhiPhiMoment_branch and "e1JetPhiPhiMoment" not in self.complained:
        if not self.e1JetPhiPhiMoment_branch and "e1JetPhiPhiMoment":
            warnings.warn( "EEETauTree: Expected branch e1JetPhiPhiMoment does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1JetPhiPhiMoment")
        else:
            self.e1JetPhiPhiMoment_branch.SetAddress(<void*>&self.e1JetPhiPhiMoment_value)

        #print "making e1JetPt"
        self.e1JetPt_branch = the_tree.GetBranch("e1JetPt")
        #if not self.e1JetPt_branch and "e1JetPt" not in self.complained:
        if not self.e1JetPt_branch and "e1JetPt":
            warnings.warn( "EEETauTree: Expected branch e1JetPt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1JetPt")
        else:
            self.e1JetPt_branch.SetAddress(<void*>&self.e1JetPt_value)

        #print "making e1JetQGLikelihoodID"
        self.e1JetQGLikelihoodID_branch = the_tree.GetBranch("e1JetQGLikelihoodID")
        #if not self.e1JetQGLikelihoodID_branch and "e1JetQGLikelihoodID" not in self.complained:
        if not self.e1JetQGLikelihoodID_branch and "e1JetQGLikelihoodID":
            warnings.warn( "EEETauTree: Expected branch e1JetQGLikelihoodID does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1JetQGLikelihoodID")
        else:
            self.e1JetQGLikelihoodID_branch.SetAddress(<void*>&self.e1JetQGLikelihoodID_value)

        #print "making e1JetQGMVAID"
        self.e1JetQGMVAID_branch = the_tree.GetBranch("e1JetQGMVAID")
        #if not self.e1JetQGMVAID_branch and "e1JetQGMVAID" not in self.complained:
        if not self.e1JetQGMVAID_branch and "e1JetQGMVAID":
            warnings.warn( "EEETauTree: Expected branch e1JetQGMVAID does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1JetQGMVAID")
        else:
            self.e1JetQGMVAID_branch.SetAddress(<void*>&self.e1JetQGMVAID_value)

        #print "making e1Jetaxis1"
        self.e1Jetaxis1_branch = the_tree.GetBranch("e1Jetaxis1")
        #if not self.e1Jetaxis1_branch and "e1Jetaxis1" not in self.complained:
        if not self.e1Jetaxis1_branch and "e1Jetaxis1":
            warnings.warn( "EEETauTree: Expected branch e1Jetaxis1 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1Jetaxis1")
        else:
            self.e1Jetaxis1_branch.SetAddress(<void*>&self.e1Jetaxis1_value)

        #print "making e1Jetaxis2"
        self.e1Jetaxis2_branch = the_tree.GetBranch("e1Jetaxis2")
        #if not self.e1Jetaxis2_branch and "e1Jetaxis2" not in self.complained:
        if not self.e1Jetaxis2_branch and "e1Jetaxis2":
            warnings.warn( "EEETauTree: Expected branch e1Jetaxis2 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1Jetaxis2")
        else:
            self.e1Jetaxis2_branch.SetAddress(<void*>&self.e1Jetaxis2_value)

        #print "making e1Jetmult"
        self.e1Jetmult_branch = the_tree.GetBranch("e1Jetmult")
        #if not self.e1Jetmult_branch and "e1Jetmult" not in self.complained:
        if not self.e1Jetmult_branch and "e1Jetmult":
            warnings.warn( "EEETauTree: Expected branch e1Jetmult does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1Jetmult")
        else:
            self.e1Jetmult_branch.SetAddress(<void*>&self.e1Jetmult_value)

        #print "making e1JetmultMLP"
        self.e1JetmultMLP_branch = the_tree.GetBranch("e1JetmultMLP")
        #if not self.e1JetmultMLP_branch and "e1JetmultMLP" not in self.complained:
        if not self.e1JetmultMLP_branch and "e1JetmultMLP":
            warnings.warn( "EEETauTree: Expected branch e1JetmultMLP does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1JetmultMLP")
        else:
            self.e1JetmultMLP_branch.SetAddress(<void*>&self.e1JetmultMLP_value)

        #print "making e1JetmultMLPQC"
        self.e1JetmultMLPQC_branch = the_tree.GetBranch("e1JetmultMLPQC")
        #if not self.e1JetmultMLPQC_branch and "e1JetmultMLPQC" not in self.complained:
        if not self.e1JetmultMLPQC_branch and "e1JetmultMLPQC":
            warnings.warn( "EEETauTree: Expected branch e1JetmultMLPQC does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1JetmultMLPQC")
        else:
            self.e1JetmultMLPQC_branch.SetAddress(<void*>&self.e1JetmultMLPQC_value)

        #print "making e1JetptD"
        self.e1JetptD_branch = the_tree.GetBranch("e1JetptD")
        #if not self.e1JetptD_branch and "e1JetptD" not in self.complained:
        if not self.e1JetptD_branch and "e1JetptD":
            warnings.warn( "EEETauTree: Expected branch e1JetptD does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1JetptD")
        else:
            self.e1JetptD_branch.SetAddress(<void*>&self.e1JetptD_value)

        #print "making e1L1NonIsoHLTNonIsoMu17Ele8PixelMatchFilter"
        self.e1L1NonIsoHLTNonIsoMu17Ele8PixelMatchFilter_branch = the_tree.GetBranch("e1L1NonIsoHLTNonIsoMu17Ele8PixelMatchFilter")
        #if not self.e1L1NonIsoHLTNonIsoMu17Ele8PixelMatchFilter_branch and "e1L1NonIsoHLTNonIsoMu17Ele8PixelMatchFilter" not in self.complained:
        if not self.e1L1NonIsoHLTNonIsoMu17Ele8PixelMatchFilter_branch and "e1L1NonIsoHLTNonIsoMu17Ele8PixelMatchFilter":
            warnings.warn( "EEETauTree: Expected branch e1L1NonIsoHLTNonIsoMu17Ele8PixelMatchFilter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1L1NonIsoHLTNonIsoMu17Ele8PixelMatchFilter")
        else:
            self.e1L1NonIsoHLTNonIsoMu17Ele8PixelMatchFilter_branch.SetAddress(<void*>&self.e1L1NonIsoHLTNonIsoMu17Ele8PixelMatchFilter_value)

        #print "making e1MITID"
        self.e1MITID_branch = the_tree.GetBranch("e1MITID")
        #if not self.e1MITID_branch and "e1MITID" not in self.complained:
        if not self.e1MITID_branch and "e1MITID":
            warnings.warn( "EEETauTree: Expected branch e1MITID does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1MITID")
        else:
            self.e1MITID_branch.SetAddress(<void*>&self.e1MITID_value)

        #print "making e1MVAIDH2TauWP"
        self.e1MVAIDH2TauWP_branch = the_tree.GetBranch("e1MVAIDH2TauWP")
        #if not self.e1MVAIDH2TauWP_branch and "e1MVAIDH2TauWP" not in self.complained:
        if not self.e1MVAIDH2TauWP_branch and "e1MVAIDH2TauWP":
            warnings.warn( "EEETauTree: Expected branch e1MVAIDH2TauWP does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1MVAIDH2TauWP")
        else:
            self.e1MVAIDH2TauWP_branch.SetAddress(<void*>&self.e1MVAIDH2TauWP_value)

        #print "making e1MVANonTrig"
        self.e1MVANonTrig_branch = the_tree.GetBranch("e1MVANonTrig")
        #if not self.e1MVANonTrig_branch and "e1MVANonTrig" not in self.complained:
        if not self.e1MVANonTrig_branch and "e1MVANonTrig":
            warnings.warn( "EEETauTree: Expected branch e1MVANonTrig does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1MVANonTrig")
        else:
            self.e1MVANonTrig_branch.SetAddress(<void*>&self.e1MVANonTrig_value)

        #print "making e1MVATrig"
        self.e1MVATrig_branch = the_tree.GetBranch("e1MVATrig")
        #if not self.e1MVATrig_branch and "e1MVATrig" not in self.complained:
        if not self.e1MVATrig_branch and "e1MVATrig":
            warnings.warn( "EEETauTree: Expected branch e1MVATrig does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1MVATrig")
        else:
            self.e1MVATrig_branch.SetAddress(<void*>&self.e1MVATrig_value)

        #print "making e1MVATrigIDISO"
        self.e1MVATrigIDISO_branch = the_tree.GetBranch("e1MVATrigIDISO")
        #if not self.e1MVATrigIDISO_branch and "e1MVATrigIDISO" not in self.complained:
        if not self.e1MVATrigIDISO_branch and "e1MVATrigIDISO":
            warnings.warn( "EEETauTree: Expected branch e1MVATrigIDISO does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1MVATrigIDISO")
        else:
            self.e1MVATrigIDISO_branch.SetAddress(<void*>&self.e1MVATrigIDISO_value)

        #print "making e1MVATrigIDISOPUSUB"
        self.e1MVATrigIDISOPUSUB_branch = the_tree.GetBranch("e1MVATrigIDISOPUSUB")
        #if not self.e1MVATrigIDISOPUSUB_branch and "e1MVATrigIDISOPUSUB" not in self.complained:
        if not self.e1MVATrigIDISOPUSUB_branch and "e1MVATrigIDISOPUSUB":
            warnings.warn( "EEETauTree: Expected branch e1MVATrigIDISOPUSUB does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1MVATrigIDISOPUSUB")
        else:
            self.e1MVATrigIDISOPUSUB_branch.SetAddress(<void*>&self.e1MVATrigIDISOPUSUB_value)

        #print "making e1MVATrigNoIP"
        self.e1MVATrigNoIP_branch = the_tree.GetBranch("e1MVATrigNoIP")
        #if not self.e1MVATrigNoIP_branch and "e1MVATrigNoIP" not in self.complained:
        if not self.e1MVATrigNoIP_branch and "e1MVATrigNoIP":
            warnings.warn( "EEETauTree: Expected branch e1MVATrigNoIP does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1MVATrigNoIP")
        else:
            self.e1MVATrigNoIP_branch.SetAddress(<void*>&self.e1MVATrigNoIP_value)

        #print "making e1Mass"
        self.e1Mass_branch = the_tree.GetBranch("e1Mass")
        #if not self.e1Mass_branch and "e1Mass" not in self.complained:
        if not self.e1Mass_branch and "e1Mass":
            warnings.warn( "EEETauTree: Expected branch e1Mass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1Mass")
        else:
            self.e1Mass_branch.SetAddress(<void*>&self.e1Mass_value)

        #print "making e1MatchesDoubleEPath"
        self.e1MatchesDoubleEPath_branch = the_tree.GetBranch("e1MatchesDoubleEPath")
        #if not self.e1MatchesDoubleEPath_branch and "e1MatchesDoubleEPath" not in self.complained:
        if not self.e1MatchesDoubleEPath_branch and "e1MatchesDoubleEPath":
            warnings.warn( "EEETauTree: Expected branch e1MatchesDoubleEPath does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1MatchesDoubleEPath")
        else:
            self.e1MatchesDoubleEPath_branch.SetAddress(<void*>&self.e1MatchesDoubleEPath_value)

        #print "making e1MatchesMu17Ele8IsoPath"
        self.e1MatchesMu17Ele8IsoPath_branch = the_tree.GetBranch("e1MatchesMu17Ele8IsoPath")
        #if not self.e1MatchesMu17Ele8IsoPath_branch and "e1MatchesMu17Ele8IsoPath" not in self.complained:
        if not self.e1MatchesMu17Ele8IsoPath_branch and "e1MatchesMu17Ele8IsoPath":
            warnings.warn( "EEETauTree: Expected branch e1MatchesMu17Ele8IsoPath does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1MatchesMu17Ele8IsoPath")
        else:
            self.e1MatchesMu17Ele8IsoPath_branch.SetAddress(<void*>&self.e1MatchesMu17Ele8IsoPath_value)

        #print "making e1MatchesMu17Ele8Path"
        self.e1MatchesMu17Ele8Path_branch = the_tree.GetBranch("e1MatchesMu17Ele8Path")
        #if not self.e1MatchesMu17Ele8Path_branch and "e1MatchesMu17Ele8Path" not in self.complained:
        if not self.e1MatchesMu17Ele8Path_branch and "e1MatchesMu17Ele8Path":
            warnings.warn( "EEETauTree: Expected branch e1MatchesMu17Ele8Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1MatchesMu17Ele8Path")
        else:
            self.e1MatchesMu17Ele8Path_branch.SetAddress(<void*>&self.e1MatchesMu17Ele8Path_value)

        #print "making e1MatchesMu8Ele17IsoPath"
        self.e1MatchesMu8Ele17IsoPath_branch = the_tree.GetBranch("e1MatchesMu8Ele17IsoPath")
        #if not self.e1MatchesMu8Ele17IsoPath_branch and "e1MatchesMu8Ele17IsoPath" not in self.complained:
        if not self.e1MatchesMu8Ele17IsoPath_branch and "e1MatchesMu8Ele17IsoPath":
            warnings.warn( "EEETauTree: Expected branch e1MatchesMu8Ele17IsoPath does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1MatchesMu8Ele17IsoPath")
        else:
            self.e1MatchesMu8Ele17IsoPath_branch.SetAddress(<void*>&self.e1MatchesMu8Ele17IsoPath_value)

        #print "making e1MatchesMu8Ele17Path"
        self.e1MatchesMu8Ele17Path_branch = the_tree.GetBranch("e1MatchesMu8Ele17Path")
        #if not self.e1MatchesMu8Ele17Path_branch and "e1MatchesMu8Ele17Path" not in self.complained:
        if not self.e1MatchesMu8Ele17Path_branch and "e1MatchesMu8Ele17Path":
            warnings.warn( "EEETauTree: Expected branch e1MatchesMu8Ele17Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1MatchesMu8Ele17Path")
        else:
            self.e1MatchesMu8Ele17Path_branch.SetAddress(<void*>&self.e1MatchesMu8Ele17Path_value)

        #print "making e1MatchesSingleE"
        self.e1MatchesSingleE_branch = the_tree.GetBranch("e1MatchesSingleE")
        #if not self.e1MatchesSingleE_branch and "e1MatchesSingleE" not in self.complained:
        if not self.e1MatchesSingleE_branch and "e1MatchesSingleE":
            warnings.warn( "EEETauTree: Expected branch e1MatchesSingleE does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1MatchesSingleE")
        else:
            self.e1MatchesSingleE_branch.SetAddress(<void*>&self.e1MatchesSingleE_value)

        #print "making e1MatchesSingleEPlusMET"
        self.e1MatchesSingleEPlusMET_branch = the_tree.GetBranch("e1MatchesSingleEPlusMET")
        #if not self.e1MatchesSingleEPlusMET_branch and "e1MatchesSingleEPlusMET" not in self.complained:
        if not self.e1MatchesSingleEPlusMET_branch and "e1MatchesSingleEPlusMET":
            warnings.warn( "EEETauTree: Expected branch e1MatchesSingleEPlusMET does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1MatchesSingleEPlusMET")
        else:
            self.e1MatchesSingleEPlusMET_branch.SetAddress(<void*>&self.e1MatchesSingleEPlusMET_value)

        #print "making e1MissingHits"
        self.e1MissingHits_branch = the_tree.GetBranch("e1MissingHits")
        #if not self.e1MissingHits_branch and "e1MissingHits" not in self.complained:
        if not self.e1MissingHits_branch and "e1MissingHits":
            warnings.warn( "EEETauTree: Expected branch e1MissingHits does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1MissingHits")
        else:
            self.e1MissingHits_branch.SetAddress(<void*>&self.e1MissingHits_value)

        #print "making e1MtToMET"
        self.e1MtToMET_branch = the_tree.GetBranch("e1MtToMET")
        #if not self.e1MtToMET_branch and "e1MtToMET" not in self.complained:
        if not self.e1MtToMET_branch and "e1MtToMET":
            warnings.warn( "EEETauTree: Expected branch e1MtToMET does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1MtToMET")
        else:
            self.e1MtToMET_branch.SetAddress(<void*>&self.e1MtToMET_value)

        #print "making e1MtToMVAMET"
        self.e1MtToMVAMET_branch = the_tree.GetBranch("e1MtToMVAMET")
        #if not self.e1MtToMVAMET_branch and "e1MtToMVAMET" not in self.complained:
        if not self.e1MtToMVAMET_branch and "e1MtToMVAMET":
            warnings.warn( "EEETauTree: Expected branch e1MtToMVAMET does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1MtToMVAMET")
        else:
            self.e1MtToMVAMET_branch.SetAddress(<void*>&self.e1MtToMVAMET_value)

        #print "making e1MtToPFMET"
        self.e1MtToPFMET_branch = the_tree.GetBranch("e1MtToPFMET")
        #if not self.e1MtToPFMET_branch and "e1MtToPFMET" not in self.complained:
        if not self.e1MtToPFMET_branch and "e1MtToPFMET":
            warnings.warn( "EEETauTree: Expected branch e1MtToPFMET does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1MtToPFMET")
        else:
            self.e1MtToPFMET_branch.SetAddress(<void*>&self.e1MtToPFMET_value)

        #print "making e1MtToPfMet_Ty1"
        self.e1MtToPfMet_Ty1_branch = the_tree.GetBranch("e1MtToPfMet_Ty1")
        #if not self.e1MtToPfMet_Ty1_branch and "e1MtToPfMet_Ty1" not in self.complained:
        if not self.e1MtToPfMet_Ty1_branch and "e1MtToPfMet_Ty1":
            warnings.warn( "EEETauTree: Expected branch e1MtToPfMet_Ty1 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1MtToPfMet_Ty1")
        else:
            self.e1MtToPfMet_Ty1_branch.SetAddress(<void*>&self.e1MtToPfMet_Ty1_value)

        #print "making e1MtToPfMet_jes"
        self.e1MtToPfMet_jes_branch = the_tree.GetBranch("e1MtToPfMet_jes")
        #if not self.e1MtToPfMet_jes_branch and "e1MtToPfMet_jes" not in self.complained:
        if not self.e1MtToPfMet_jes_branch and "e1MtToPfMet_jes":
            warnings.warn( "EEETauTree: Expected branch e1MtToPfMet_jes does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1MtToPfMet_jes")
        else:
            self.e1MtToPfMet_jes_branch.SetAddress(<void*>&self.e1MtToPfMet_jes_value)

        #print "making e1MtToPfMet_mes"
        self.e1MtToPfMet_mes_branch = the_tree.GetBranch("e1MtToPfMet_mes")
        #if not self.e1MtToPfMet_mes_branch and "e1MtToPfMet_mes" not in self.complained:
        if not self.e1MtToPfMet_mes_branch and "e1MtToPfMet_mes":
            warnings.warn( "EEETauTree: Expected branch e1MtToPfMet_mes does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1MtToPfMet_mes")
        else:
            self.e1MtToPfMet_mes_branch.SetAddress(<void*>&self.e1MtToPfMet_mes_value)

        #print "making e1MtToPfMet_tes"
        self.e1MtToPfMet_tes_branch = the_tree.GetBranch("e1MtToPfMet_tes")
        #if not self.e1MtToPfMet_tes_branch and "e1MtToPfMet_tes" not in self.complained:
        if not self.e1MtToPfMet_tes_branch and "e1MtToPfMet_tes":
            warnings.warn( "EEETauTree: Expected branch e1MtToPfMet_tes does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1MtToPfMet_tes")
        else:
            self.e1MtToPfMet_tes_branch.SetAddress(<void*>&self.e1MtToPfMet_tes_value)

        #print "making e1MtToPfMet_ues"
        self.e1MtToPfMet_ues_branch = the_tree.GetBranch("e1MtToPfMet_ues")
        #if not self.e1MtToPfMet_ues_branch and "e1MtToPfMet_ues" not in self.complained:
        if not self.e1MtToPfMet_ues_branch and "e1MtToPfMet_ues":
            warnings.warn( "EEETauTree: Expected branch e1MtToPfMet_ues does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1MtToPfMet_ues")
        else:
            self.e1MtToPfMet_ues_branch.SetAddress(<void*>&self.e1MtToPfMet_ues_value)

        #print "making e1Mu17Ele8CaloIdTCaloIsoVLTrkIdVLTrkIsoVLTrackIsoFilter"
        self.e1Mu17Ele8CaloIdTCaloIsoVLTrkIdVLTrkIsoVLTrackIsoFilter_branch = the_tree.GetBranch("e1Mu17Ele8CaloIdTCaloIsoVLTrkIdVLTrkIsoVLTrackIsoFilter")
        #if not self.e1Mu17Ele8CaloIdTCaloIsoVLTrkIdVLTrkIsoVLTrackIsoFilter_branch and "e1Mu17Ele8CaloIdTCaloIsoVLTrkIdVLTrkIsoVLTrackIsoFilter" not in self.complained:
        if not self.e1Mu17Ele8CaloIdTCaloIsoVLTrkIdVLTrkIsoVLTrackIsoFilter_branch and "e1Mu17Ele8CaloIdTCaloIsoVLTrkIdVLTrkIsoVLTrackIsoFilter":
            warnings.warn( "EEETauTree: Expected branch e1Mu17Ele8CaloIdTCaloIsoVLTrkIdVLTrkIsoVLTrackIsoFilter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1Mu17Ele8CaloIdTCaloIsoVLTrkIdVLTrkIsoVLTrackIsoFilter")
        else:
            self.e1Mu17Ele8CaloIdTCaloIsoVLTrkIdVLTrkIsoVLTrackIsoFilter_branch.SetAddress(<void*>&self.e1Mu17Ele8CaloIdTCaloIsoVLTrkIdVLTrkIsoVLTrackIsoFilter_value)

        #print "making e1Mu17Ele8CaloIdTPixelMatchFilter"
        self.e1Mu17Ele8CaloIdTPixelMatchFilter_branch = the_tree.GetBranch("e1Mu17Ele8CaloIdTPixelMatchFilter")
        #if not self.e1Mu17Ele8CaloIdTPixelMatchFilter_branch and "e1Mu17Ele8CaloIdTPixelMatchFilter" not in self.complained:
        if not self.e1Mu17Ele8CaloIdTPixelMatchFilter_branch and "e1Mu17Ele8CaloIdTPixelMatchFilter":
            warnings.warn( "EEETauTree: Expected branch e1Mu17Ele8CaloIdTPixelMatchFilter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1Mu17Ele8CaloIdTPixelMatchFilter")
        else:
            self.e1Mu17Ele8CaloIdTPixelMatchFilter_branch.SetAddress(<void*>&self.e1Mu17Ele8CaloIdTPixelMatchFilter_value)

        #print "making e1Mu17Ele8dZFilter"
        self.e1Mu17Ele8dZFilter_branch = the_tree.GetBranch("e1Mu17Ele8dZFilter")
        #if not self.e1Mu17Ele8dZFilter_branch and "e1Mu17Ele8dZFilter" not in self.complained:
        if not self.e1Mu17Ele8dZFilter_branch and "e1Mu17Ele8dZFilter":
            warnings.warn( "EEETauTree: Expected branch e1Mu17Ele8dZFilter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1Mu17Ele8dZFilter")
        else:
            self.e1Mu17Ele8dZFilter_branch.SetAddress(<void*>&self.e1Mu17Ele8dZFilter_value)

        #print "making e1MuOverlap"
        self.e1MuOverlap_branch = the_tree.GetBranch("e1MuOverlap")
        #if not self.e1MuOverlap_branch and "e1MuOverlap" not in self.complained:
        if not self.e1MuOverlap_branch and "e1MuOverlap":
            warnings.warn( "EEETauTree: Expected branch e1MuOverlap does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1MuOverlap")
        else:
            self.e1MuOverlap_branch.SetAddress(<void*>&self.e1MuOverlap_value)

        #print "making e1MuOverlapZHLoose"
        self.e1MuOverlapZHLoose_branch = the_tree.GetBranch("e1MuOverlapZHLoose")
        #if not self.e1MuOverlapZHLoose_branch and "e1MuOverlapZHLoose" not in self.complained:
        if not self.e1MuOverlapZHLoose_branch and "e1MuOverlapZHLoose":
            warnings.warn( "EEETauTree: Expected branch e1MuOverlapZHLoose does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1MuOverlapZHLoose")
        else:
            self.e1MuOverlapZHLoose_branch.SetAddress(<void*>&self.e1MuOverlapZHLoose_value)

        #print "making e1MuOverlapZHTight"
        self.e1MuOverlapZHTight_branch = the_tree.GetBranch("e1MuOverlapZHTight")
        #if not self.e1MuOverlapZHTight_branch and "e1MuOverlapZHTight" not in self.complained:
        if not self.e1MuOverlapZHTight_branch and "e1MuOverlapZHTight":
            warnings.warn( "EEETauTree: Expected branch e1MuOverlapZHTight does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1MuOverlapZHTight")
        else:
            self.e1MuOverlapZHTight_branch.SetAddress(<void*>&self.e1MuOverlapZHTight_value)

        #print "making e1NearMuonVeto"
        self.e1NearMuonVeto_branch = the_tree.GetBranch("e1NearMuonVeto")
        #if not self.e1NearMuonVeto_branch and "e1NearMuonVeto" not in self.complained:
        if not self.e1NearMuonVeto_branch and "e1NearMuonVeto":
            warnings.warn( "EEETauTree: Expected branch e1NearMuonVeto does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1NearMuonVeto")
        else:
            self.e1NearMuonVeto_branch.SetAddress(<void*>&self.e1NearMuonVeto_value)

        #print "making e1PFChargedIso"
        self.e1PFChargedIso_branch = the_tree.GetBranch("e1PFChargedIso")
        #if not self.e1PFChargedIso_branch and "e1PFChargedIso" not in self.complained:
        if not self.e1PFChargedIso_branch and "e1PFChargedIso":
            warnings.warn( "EEETauTree: Expected branch e1PFChargedIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1PFChargedIso")
        else:
            self.e1PFChargedIso_branch.SetAddress(<void*>&self.e1PFChargedIso_value)

        #print "making e1PFNeutralIso"
        self.e1PFNeutralIso_branch = the_tree.GetBranch("e1PFNeutralIso")
        #if not self.e1PFNeutralIso_branch and "e1PFNeutralIso" not in self.complained:
        if not self.e1PFNeutralIso_branch and "e1PFNeutralIso":
            warnings.warn( "EEETauTree: Expected branch e1PFNeutralIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1PFNeutralIso")
        else:
            self.e1PFNeutralIso_branch.SetAddress(<void*>&self.e1PFNeutralIso_value)

        #print "making e1PFPhotonIso"
        self.e1PFPhotonIso_branch = the_tree.GetBranch("e1PFPhotonIso")
        #if not self.e1PFPhotonIso_branch and "e1PFPhotonIso" not in self.complained:
        if not self.e1PFPhotonIso_branch and "e1PFPhotonIso":
            warnings.warn( "EEETauTree: Expected branch e1PFPhotonIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1PFPhotonIso")
        else:
            self.e1PFPhotonIso_branch.SetAddress(<void*>&self.e1PFPhotonIso_value)

        #print "making e1PVDXY"
        self.e1PVDXY_branch = the_tree.GetBranch("e1PVDXY")
        #if not self.e1PVDXY_branch and "e1PVDXY" not in self.complained:
        if not self.e1PVDXY_branch and "e1PVDXY":
            warnings.warn( "EEETauTree: Expected branch e1PVDXY does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1PVDXY")
        else:
            self.e1PVDXY_branch.SetAddress(<void*>&self.e1PVDXY_value)

        #print "making e1PVDZ"
        self.e1PVDZ_branch = the_tree.GetBranch("e1PVDZ")
        #if not self.e1PVDZ_branch and "e1PVDZ" not in self.complained:
        if not self.e1PVDZ_branch and "e1PVDZ":
            warnings.warn( "EEETauTree: Expected branch e1PVDZ does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1PVDZ")
        else:
            self.e1PVDZ_branch.SetAddress(<void*>&self.e1PVDZ_value)

        #print "making e1Phi"
        self.e1Phi_branch = the_tree.GetBranch("e1Phi")
        #if not self.e1Phi_branch and "e1Phi" not in self.complained:
        if not self.e1Phi_branch and "e1Phi":
            warnings.warn( "EEETauTree: Expected branch e1Phi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1Phi")
        else:
            self.e1Phi_branch.SetAddress(<void*>&self.e1Phi_value)

        #print "making e1PhiCorrReg_2012Jul13ReReco"
        self.e1PhiCorrReg_2012Jul13ReReco_branch = the_tree.GetBranch("e1PhiCorrReg_2012Jul13ReReco")
        #if not self.e1PhiCorrReg_2012Jul13ReReco_branch and "e1PhiCorrReg_2012Jul13ReReco" not in self.complained:
        if not self.e1PhiCorrReg_2012Jul13ReReco_branch and "e1PhiCorrReg_2012Jul13ReReco":
            warnings.warn( "EEETauTree: Expected branch e1PhiCorrReg_2012Jul13ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1PhiCorrReg_2012Jul13ReReco")
        else:
            self.e1PhiCorrReg_2012Jul13ReReco_branch.SetAddress(<void*>&self.e1PhiCorrReg_2012Jul13ReReco_value)

        #print "making e1PhiCorrReg_Fall11"
        self.e1PhiCorrReg_Fall11_branch = the_tree.GetBranch("e1PhiCorrReg_Fall11")
        #if not self.e1PhiCorrReg_Fall11_branch and "e1PhiCorrReg_Fall11" not in self.complained:
        if not self.e1PhiCorrReg_Fall11_branch and "e1PhiCorrReg_Fall11":
            warnings.warn( "EEETauTree: Expected branch e1PhiCorrReg_Fall11 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1PhiCorrReg_Fall11")
        else:
            self.e1PhiCorrReg_Fall11_branch.SetAddress(<void*>&self.e1PhiCorrReg_Fall11_value)

        #print "making e1PhiCorrReg_Jan16ReReco"
        self.e1PhiCorrReg_Jan16ReReco_branch = the_tree.GetBranch("e1PhiCorrReg_Jan16ReReco")
        #if not self.e1PhiCorrReg_Jan16ReReco_branch and "e1PhiCorrReg_Jan16ReReco" not in self.complained:
        if not self.e1PhiCorrReg_Jan16ReReco_branch and "e1PhiCorrReg_Jan16ReReco":
            warnings.warn( "EEETauTree: Expected branch e1PhiCorrReg_Jan16ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1PhiCorrReg_Jan16ReReco")
        else:
            self.e1PhiCorrReg_Jan16ReReco_branch.SetAddress(<void*>&self.e1PhiCorrReg_Jan16ReReco_value)

        #print "making e1PhiCorrReg_Summer12_DR53X_HCP2012"
        self.e1PhiCorrReg_Summer12_DR53X_HCP2012_branch = the_tree.GetBranch("e1PhiCorrReg_Summer12_DR53X_HCP2012")
        #if not self.e1PhiCorrReg_Summer12_DR53X_HCP2012_branch and "e1PhiCorrReg_Summer12_DR53X_HCP2012" not in self.complained:
        if not self.e1PhiCorrReg_Summer12_DR53X_HCP2012_branch and "e1PhiCorrReg_Summer12_DR53X_HCP2012":
            warnings.warn( "EEETauTree: Expected branch e1PhiCorrReg_Summer12_DR53X_HCP2012 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1PhiCorrReg_Summer12_DR53X_HCP2012")
        else:
            self.e1PhiCorrReg_Summer12_DR53X_HCP2012_branch.SetAddress(<void*>&self.e1PhiCorrReg_Summer12_DR53X_HCP2012_value)

        #print "making e1PhiCorrSmearedNoReg_2012Jul13ReReco"
        self.e1PhiCorrSmearedNoReg_2012Jul13ReReco_branch = the_tree.GetBranch("e1PhiCorrSmearedNoReg_2012Jul13ReReco")
        #if not self.e1PhiCorrSmearedNoReg_2012Jul13ReReco_branch and "e1PhiCorrSmearedNoReg_2012Jul13ReReco" not in self.complained:
        if not self.e1PhiCorrSmearedNoReg_2012Jul13ReReco_branch and "e1PhiCorrSmearedNoReg_2012Jul13ReReco":
            warnings.warn( "EEETauTree: Expected branch e1PhiCorrSmearedNoReg_2012Jul13ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1PhiCorrSmearedNoReg_2012Jul13ReReco")
        else:
            self.e1PhiCorrSmearedNoReg_2012Jul13ReReco_branch.SetAddress(<void*>&self.e1PhiCorrSmearedNoReg_2012Jul13ReReco_value)

        #print "making e1PhiCorrSmearedNoReg_Fall11"
        self.e1PhiCorrSmearedNoReg_Fall11_branch = the_tree.GetBranch("e1PhiCorrSmearedNoReg_Fall11")
        #if not self.e1PhiCorrSmearedNoReg_Fall11_branch and "e1PhiCorrSmearedNoReg_Fall11" not in self.complained:
        if not self.e1PhiCorrSmearedNoReg_Fall11_branch and "e1PhiCorrSmearedNoReg_Fall11":
            warnings.warn( "EEETauTree: Expected branch e1PhiCorrSmearedNoReg_Fall11 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1PhiCorrSmearedNoReg_Fall11")
        else:
            self.e1PhiCorrSmearedNoReg_Fall11_branch.SetAddress(<void*>&self.e1PhiCorrSmearedNoReg_Fall11_value)

        #print "making e1PhiCorrSmearedNoReg_Jan16ReReco"
        self.e1PhiCorrSmearedNoReg_Jan16ReReco_branch = the_tree.GetBranch("e1PhiCorrSmearedNoReg_Jan16ReReco")
        #if not self.e1PhiCorrSmearedNoReg_Jan16ReReco_branch and "e1PhiCorrSmearedNoReg_Jan16ReReco" not in self.complained:
        if not self.e1PhiCorrSmearedNoReg_Jan16ReReco_branch and "e1PhiCorrSmearedNoReg_Jan16ReReco":
            warnings.warn( "EEETauTree: Expected branch e1PhiCorrSmearedNoReg_Jan16ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1PhiCorrSmearedNoReg_Jan16ReReco")
        else:
            self.e1PhiCorrSmearedNoReg_Jan16ReReco_branch.SetAddress(<void*>&self.e1PhiCorrSmearedNoReg_Jan16ReReco_value)

        #print "making e1PhiCorrSmearedNoReg_Summer12_DR53X_HCP2012"
        self.e1PhiCorrSmearedNoReg_Summer12_DR53X_HCP2012_branch = the_tree.GetBranch("e1PhiCorrSmearedNoReg_Summer12_DR53X_HCP2012")
        #if not self.e1PhiCorrSmearedNoReg_Summer12_DR53X_HCP2012_branch and "e1PhiCorrSmearedNoReg_Summer12_DR53X_HCP2012" not in self.complained:
        if not self.e1PhiCorrSmearedNoReg_Summer12_DR53X_HCP2012_branch and "e1PhiCorrSmearedNoReg_Summer12_DR53X_HCP2012":
            warnings.warn( "EEETauTree: Expected branch e1PhiCorrSmearedNoReg_Summer12_DR53X_HCP2012 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1PhiCorrSmearedNoReg_Summer12_DR53X_HCP2012")
        else:
            self.e1PhiCorrSmearedNoReg_Summer12_DR53X_HCP2012_branch.SetAddress(<void*>&self.e1PhiCorrSmearedNoReg_Summer12_DR53X_HCP2012_value)

        #print "making e1PhiCorrSmearedReg_2012Jul13ReReco"
        self.e1PhiCorrSmearedReg_2012Jul13ReReco_branch = the_tree.GetBranch("e1PhiCorrSmearedReg_2012Jul13ReReco")
        #if not self.e1PhiCorrSmearedReg_2012Jul13ReReco_branch and "e1PhiCorrSmearedReg_2012Jul13ReReco" not in self.complained:
        if not self.e1PhiCorrSmearedReg_2012Jul13ReReco_branch and "e1PhiCorrSmearedReg_2012Jul13ReReco":
            warnings.warn( "EEETauTree: Expected branch e1PhiCorrSmearedReg_2012Jul13ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1PhiCorrSmearedReg_2012Jul13ReReco")
        else:
            self.e1PhiCorrSmearedReg_2012Jul13ReReco_branch.SetAddress(<void*>&self.e1PhiCorrSmearedReg_2012Jul13ReReco_value)

        #print "making e1PhiCorrSmearedReg_Fall11"
        self.e1PhiCorrSmearedReg_Fall11_branch = the_tree.GetBranch("e1PhiCorrSmearedReg_Fall11")
        #if not self.e1PhiCorrSmearedReg_Fall11_branch and "e1PhiCorrSmearedReg_Fall11" not in self.complained:
        if not self.e1PhiCorrSmearedReg_Fall11_branch and "e1PhiCorrSmearedReg_Fall11":
            warnings.warn( "EEETauTree: Expected branch e1PhiCorrSmearedReg_Fall11 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1PhiCorrSmearedReg_Fall11")
        else:
            self.e1PhiCorrSmearedReg_Fall11_branch.SetAddress(<void*>&self.e1PhiCorrSmearedReg_Fall11_value)

        #print "making e1PhiCorrSmearedReg_Jan16ReReco"
        self.e1PhiCorrSmearedReg_Jan16ReReco_branch = the_tree.GetBranch("e1PhiCorrSmearedReg_Jan16ReReco")
        #if not self.e1PhiCorrSmearedReg_Jan16ReReco_branch and "e1PhiCorrSmearedReg_Jan16ReReco" not in self.complained:
        if not self.e1PhiCorrSmearedReg_Jan16ReReco_branch and "e1PhiCorrSmearedReg_Jan16ReReco":
            warnings.warn( "EEETauTree: Expected branch e1PhiCorrSmearedReg_Jan16ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1PhiCorrSmearedReg_Jan16ReReco")
        else:
            self.e1PhiCorrSmearedReg_Jan16ReReco_branch.SetAddress(<void*>&self.e1PhiCorrSmearedReg_Jan16ReReco_value)

        #print "making e1PhiCorrSmearedReg_Summer12_DR53X_HCP2012"
        self.e1PhiCorrSmearedReg_Summer12_DR53X_HCP2012_branch = the_tree.GetBranch("e1PhiCorrSmearedReg_Summer12_DR53X_HCP2012")
        #if not self.e1PhiCorrSmearedReg_Summer12_DR53X_HCP2012_branch and "e1PhiCorrSmearedReg_Summer12_DR53X_HCP2012" not in self.complained:
        if not self.e1PhiCorrSmearedReg_Summer12_DR53X_HCP2012_branch and "e1PhiCorrSmearedReg_Summer12_DR53X_HCP2012":
            warnings.warn( "EEETauTree: Expected branch e1PhiCorrSmearedReg_Summer12_DR53X_HCP2012 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1PhiCorrSmearedReg_Summer12_DR53X_HCP2012")
        else:
            self.e1PhiCorrSmearedReg_Summer12_DR53X_HCP2012_branch.SetAddress(<void*>&self.e1PhiCorrSmearedReg_Summer12_DR53X_HCP2012_value)

        #print "making e1Pt"
        self.e1Pt_branch = the_tree.GetBranch("e1Pt")
        #if not self.e1Pt_branch and "e1Pt" not in self.complained:
        if not self.e1Pt_branch and "e1Pt":
            warnings.warn( "EEETauTree: Expected branch e1Pt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1Pt")
        else:
            self.e1Pt_branch.SetAddress(<void*>&self.e1Pt_value)

        #print "making e1PtCorrReg_2012Jul13ReReco"
        self.e1PtCorrReg_2012Jul13ReReco_branch = the_tree.GetBranch("e1PtCorrReg_2012Jul13ReReco")
        #if not self.e1PtCorrReg_2012Jul13ReReco_branch and "e1PtCorrReg_2012Jul13ReReco" not in self.complained:
        if not self.e1PtCorrReg_2012Jul13ReReco_branch and "e1PtCorrReg_2012Jul13ReReco":
            warnings.warn( "EEETauTree: Expected branch e1PtCorrReg_2012Jul13ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1PtCorrReg_2012Jul13ReReco")
        else:
            self.e1PtCorrReg_2012Jul13ReReco_branch.SetAddress(<void*>&self.e1PtCorrReg_2012Jul13ReReco_value)

        #print "making e1PtCorrReg_Fall11"
        self.e1PtCorrReg_Fall11_branch = the_tree.GetBranch("e1PtCorrReg_Fall11")
        #if not self.e1PtCorrReg_Fall11_branch and "e1PtCorrReg_Fall11" not in self.complained:
        if not self.e1PtCorrReg_Fall11_branch and "e1PtCorrReg_Fall11":
            warnings.warn( "EEETauTree: Expected branch e1PtCorrReg_Fall11 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1PtCorrReg_Fall11")
        else:
            self.e1PtCorrReg_Fall11_branch.SetAddress(<void*>&self.e1PtCorrReg_Fall11_value)

        #print "making e1PtCorrReg_Jan16ReReco"
        self.e1PtCorrReg_Jan16ReReco_branch = the_tree.GetBranch("e1PtCorrReg_Jan16ReReco")
        #if not self.e1PtCorrReg_Jan16ReReco_branch and "e1PtCorrReg_Jan16ReReco" not in self.complained:
        if not self.e1PtCorrReg_Jan16ReReco_branch and "e1PtCorrReg_Jan16ReReco":
            warnings.warn( "EEETauTree: Expected branch e1PtCorrReg_Jan16ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1PtCorrReg_Jan16ReReco")
        else:
            self.e1PtCorrReg_Jan16ReReco_branch.SetAddress(<void*>&self.e1PtCorrReg_Jan16ReReco_value)

        #print "making e1PtCorrReg_Summer12_DR53X_HCP2012"
        self.e1PtCorrReg_Summer12_DR53X_HCP2012_branch = the_tree.GetBranch("e1PtCorrReg_Summer12_DR53X_HCP2012")
        #if not self.e1PtCorrReg_Summer12_DR53X_HCP2012_branch and "e1PtCorrReg_Summer12_DR53X_HCP2012" not in self.complained:
        if not self.e1PtCorrReg_Summer12_DR53X_HCP2012_branch and "e1PtCorrReg_Summer12_DR53X_HCP2012":
            warnings.warn( "EEETauTree: Expected branch e1PtCorrReg_Summer12_DR53X_HCP2012 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1PtCorrReg_Summer12_DR53X_HCP2012")
        else:
            self.e1PtCorrReg_Summer12_DR53X_HCP2012_branch.SetAddress(<void*>&self.e1PtCorrReg_Summer12_DR53X_HCP2012_value)

        #print "making e1PtCorrSmearedNoReg_2012Jul13ReReco"
        self.e1PtCorrSmearedNoReg_2012Jul13ReReco_branch = the_tree.GetBranch("e1PtCorrSmearedNoReg_2012Jul13ReReco")
        #if not self.e1PtCorrSmearedNoReg_2012Jul13ReReco_branch and "e1PtCorrSmearedNoReg_2012Jul13ReReco" not in self.complained:
        if not self.e1PtCorrSmearedNoReg_2012Jul13ReReco_branch and "e1PtCorrSmearedNoReg_2012Jul13ReReco":
            warnings.warn( "EEETauTree: Expected branch e1PtCorrSmearedNoReg_2012Jul13ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1PtCorrSmearedNoReg_2012Jul13ReReco")
        else:
            self.e1PtCorrSmearedNoReg_2012Jul13ReReco_branch.SetAddress(<void*>&self.e1PtCorrSmearedNoReg_2012Jul13ReReco_value)

        #print "making e1PtCorrSmearedNoReg_Fall11"
        self.e1PtCorrSmearedNoReg_Fall11_branch = the_tree.GetBranch("e1PtCorrSmearedNoReg_Fall11")
        #if not self.e1PtCorrSmearedNoReg_Fall11_branch and "e1PtCorrSmearedNoReg_Fall11" not in self.complained:
        if not self.e1PtCorrSmearedNoReg_Fall11_branch and "e1PtCorrSmearedNoReg_Fall11":
            warnings.warn( "EEETauTree: Expected branch e1PtCorrSmearedNoReg_Fall11 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1PtCorrSmearedNoReg_Fall11")
        else:
            self.e1PtCorrSmearedNoReg_Fall11_branch.SetAddress(<void*>&self.e1PtCorrSmearedNoReg_Fall11_value)

        #print "making e1PtCorrSmearedNoReg_Jan16ReReco"
        self.e1PtCorrSmearedNoReg_Jan16ReReco_branch = the_tree.GetBranch("e1PtCorrSmearedNoReg_Jan16ReReco")
        #if not self.e1PtCorrSmearedNoReg_Jan16ReReco_branch and "e1PtCorrSmearedNoReg_Jan16ReReco" not in self.complained:
        if not self.e1PtCorrSmearedNoReg_Jan16ReReco_branch and "e1PtCorrSmearedNoReg_Jan16ReReco":
            warnings.warn( "EEETauTree: Expected branch e1PtCorrSmearedNoReg_Jan16ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1PtCorrSmearedNoReg_Jan16ReReco")
        else:
            self.e1PtCorrSmearedNoReg_Jan16ReReco_branch.SetAddress(<void*>&self.e1PtCorrSmearedNoReg_Jan16ReReco_value)

        #print "making e1PtCorrSmearedNoReg_Summer12_DR53X_HCP2012"
        self.e1PtCorrSmearedNoReg_Summer12_DR53X_HCP2012_branch = the_tree.GetBranch("e1PtCorrSmearedNoReg_Summer12_DR53X_HCP2012")
        #if not self.e1PtCorrSmearedNoReg_Summer12_DR53X_HCP2012_branch and "e1PtCorrSmearedNoReg_Summer12_DR53X_HCP2012" not in self.complained:
        if not self.e1PtCorrSmearedNoReg_Summer12_DR53X_HCP2012_branch and "e1PtCorrSmearedNoReg_Summer12_DR53X_HCP2012":
            warnings.warn( "EEETauTree: Expected branch e1PtCorrSmearedNoReg_Summer12_DR53X_HCP2012 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1PtCorrSmearedNoReg_Summer12_DR53X_HCP2012")
        else:
            self.e1PtCorrSmearedNoReg_Summer12_DR53X_HCP2012_branch.SetAddress(<void*>&self.e1PtCorrSmearedNoReg_Summer12_DR53X_HCP2012_value)

        #print "making e1PtCorrSmearedReg_2012Jul13ReReco"
        self.e1PtCorrSmearedReg_2012Jul13ReReco_branch = the_tree.GetBranch("e1PtCorrSmearedReg_2012Jul13ReReco")
        #if not self.e1PtCorrSmearedReg_2012Jul13ReReco_branch and "e1PtCorrSmearedReg_2012Jul13ReReco" not in self.complained:
        if not self.e1PtCorrSmearedReg_2012Jul13ReReco_branch and "e1PtCorrSmearedReg_2012Jul13ReReco":
            warnings.warn( "EEETauTree: Expected branch e1PtCorrSmearedReg_2012Jul13ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1PtCorrSmearedReg_2012Jul13ReReco")
        else:
            self.e1PtCorrSmearedReg_2012Jul13ReReco_branch.SetAddress(<void*>&self.e1PtCorrSmearedReg_2012Jul13ReReco_value)

        #print "making e1PtCorrSmearedReg_Fall11"
        self.e1PtCorrSmearedReg_Fall11_branch = the_tree.GetBranch("e1PtCorrSmearedReg_Fall11")
        #if not self.e1PtCorrSmearedReg_Fall11_branch and "e1PtCorrSmearedReg_Fall11" not in self.complained:
        if not self.e1PtCorrSmearedReg_Fall11_branch and "e1PtCorrSmearedReg_Fall11":
            warnings.warn( "EEETauTree: Expected branch e1PtCorrSmearedReg_Fall11 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1PtCorrSmearedReg_Fall11")
        else:
            self.e1PtCorrSmearedReg_Fall11_branch.SetAddress(<void*>&self.e1PtCorrSmearedReg_Fall11_value)

        #print "making e1PtCorrSmearedReg_Jan16ReReco"
        self.e1PtCorrSmearedReg_Jan16ReReco_branch = the_tree.GetBranch("e1PtCorrSmearedReg_Jan16ReReco")
        #if not self.e1PtCorrSmearedReg_Jan16ReReco_branch and "e1PtCorrSmearedReg_Jan16ReReco" not in self.complained:
        if not self.e1PtCorrSmearedReg_Jan16ReReco_branch and "e1PtCorrSmearedReg_Jan16ReReco":
            warnings.warn( "EEETauTree: Expected branch e1PtCorrSmearedReg_Jan16ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1PtCorrSmearedReg_Jan16ReReco")
        else:
            self.e1PtCorrSmearedReg_Jan16ReReco_branch.SetAddress(<void*>&self.e1PtCorrSmearedReg_Jan16ReReco_value)

        #print "making e1PtCorrSmearedReg_Summer12_DR53X_HCP2012"
        self.e1PtCorrSmearedReg_Summer12_DR53X_HCP2012_branch = the_tree.GetBranch("e1PtCorrSmearedReg_Summer12_DR53X_HCP2012")
        #if not self.e1PtCorrSmearedReg_Summer12_DR53X_HCP2012_branch and "e1PtCorrSmearedReg_Summer12_DR53X_HCP2012" not in self.complained:
        if not self.e1PtCorrSmearedReg_Summer12_DR53X_HCP2012_branch and "e1PtCorrSmearedReg_Summer12_DR53X_HCP2012":
            warnings.warn( "EEETauTree: Expected branch e1PtCorrSmearedReg_Summer12_DR53X_HCP2012 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1PtCorrSmearedReg_Summer12_DR53X_HCP2012")
        else:
            self.e1PtCorrSmearedReg_Summer12_DR53X_HCP2012_branch.SetAddress(<void*>&self.e1PtCorrSmearedReg_Summer12_DR53X_HCP2012_value)

        #print "making e1Rank"
        self.e1Rank_branch = the_tree.GetBranch("e1Rank")
        #if not self.e1Rank_branch and "e1Rank" not in self.complained:
        if not self.e1Rank_branch and "e1Rank":
            warnings.warn( "EEETauTree: Expected branch e1Rank does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1Rank")
        else:
            self.e1Rank_branch.SetAddress(<void*>&self.e1Rank_value)

        #print "making e1RelIso"
        self.e1RelIso_branch = the_tree.GetBranch("e1RelIso")
        #if not self.e1RelIso_branch and "e1RelIso" not in self.complained:
        if not self.e1RelIso_branch and "e1RelIso":
            warnings.warn( "EEETauTree: Expected branch e1RelIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1RelIso")
        else:
            self.e1RelIso_branch.SetAddress(<void*>&self.e1RelIso_value)

        #print "making e1RelPFIsoDB"
        self.e1RelPFIsoDB_branch = the_tree.GetBranch("e1RelPFIsoDB")
        #if not self.e1RelPFIsoDB_branch and "e1RelPFIsoDB" not in self.complained:
        if not self.e1RelPFIsoDB_branch and "e1RelPFIsoDB":
            warnings.warn( "EEETauTree: Expected branch e1RelPFIsoDB does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1RelPFIsoDB")
        else:
            self.e1RelPFIsoDB_branch.SetAddress(<void*>&self.e1RelPFIsoDB_value)

        #print "making e1RelPFIsoRho"
        self.e1RelPFIsoRho_branch = the_tree.GetBranch("e1RelPFIsoRho")
        #if not self.e1RelPFIsoRho_branch and "e1RelPFIsoRho" not in self.complained:
        if not self.e1RelPFIsoRho_branch and "e1RelPFIsoRho":
            warnings.warn( "EEETauTree: Expected branch e1RelPFIsoRho does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1RelPFIsoRho")
        else:
            self.e1RelPFIsoRho_branch.SetAddress(<void*>&self.e1RelPFIsoRho_value)

        #print "making e1RelPFIsoRhoFSR"
        self.e1RelPFIsoRhoFSR_branch = the_tree.GetBranch("e1RelPFIsoRhoFSR")
        #if not self.e1RelPFIsoRhoFSR_branch and "e1RelPFIsoRhoFSR" not in self.complained:
        if not self.e1RelPFIsoRhoFSR_branch and "e1RelPFIsoRhoFSR":
            warnings.warn( "EEETauTree: Expected branch e1RelPFIsoRhoFSR does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1RelPFIsoRhoFSR")
        else:
            self.e1RelPFIsoRhoFSR_branch.SetAddress(<void*>&self.e1RelPFIsoRhoFSR_value)

        #print "making e1RhoHZG2011"
        self.e1RhoHZG2011_branch = the_tree.GetBranch("e1RhoHZG2011")
        #if not self.e1RhoHZG2011_branch and "e1RhoHZG2011" not in self.complained:
        if not self.e1RhoHZG2011_branch and "e1RhoHZG2011":
            warnings.warn( "EEETauTree: Expected branch e1RhoHZG2011 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1RhoHZG2011")
        else:
            self.e1RhoHZG2011_branch.SetAddress(<void*>&self.e1RhoHZG2011_value)

        #print "making e1RhoHZG2012"
        self.e1RhoHZG2012_branch = the_tree.GetBranch("e1RhoHZG2012")
        #if not self.e1RhoHZG2012_branch and "e1RhoHZG2012" not in self.complained:
        if not self.e1RhoHZG2012_branch and "e1RhoHZG2012":
            warnings.warn( "EEETauTree: Expected branch e1RhoHZG2012 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1RhoHZG2012")
        else:
            self.e1RhoHZG2012_branch.SetAddress(<void*>&self.e1RhoHZG2012_value)

        #print "making e1SCEnergy"
        self.e1SCEnergy_branch = the_tree.GetBranch("e1SCEnergy")
        #if not self.e1SCEnergy_branch and "e1SCEnergy" not in self.complained:
        if not self.e1SCEnergy_branch and "e1SCEnergy":
            warnings.warn( "EEETauTree: Expected branch e1SCEnergy does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1SCEnergy")
        else:
            self.e1SCEnergy_branch.SetAddress(<void*>&self.e1SCEnergy_value)

        #print "making e1SCEta"
        self.e1SCEta_branch = the_tree.GetBranch("e1SCEta")
        #if not self.e1SCEta_branch and "e1SCEta" not in self.complained:
        if not self.e1SCEta_branch and "e1SCEta":
            warnings.warn( "EEETauTree: Expected branch e1SCEta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1SCEta")
        else:
            self.e1SCEta_branch.SetAddress(<void*>&self.e1SCEta_value)

        #print "making e1SCEtaWidth"
        self.e1SCEtaWidth_branch = the_tree.GetBranch("e1SCEtaWidth")
        #if not self.e1SCEtaWidth_branch and "e1SCEtaWidth" not in self.complained:
        if not self.e1SCEtaWidth_branch and "e1SCEtaWidth":
            warnings.warn( "EEETauTree: Expected branch e1SCEtaWidth does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1SCEtaWidth")
        else:
            self.e1SCEtaWidth_branch.SetAddress(<void*>&self.e1SCEtaWidth_value)

        #print "making e1SCPhi"
        self.e1SCPhi_branch = the_tree.GetBranch("e1SCPhi")
        #if not self.e1SCPhi_branch and "e1SCPhi" not in self.complained:
        if not self.e1SCPhi_branch and "e1SCPhi":
            warnings.warn( "EEETauTree: Expected branch e1SCPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1SCPhi")
        else:
            self.e1SCPhi_branch.SetAddress(<void*>&self.e1SCPhi_value)

        #print "making e1SCPhiWidth"
        self.e1SCPhiWidth_branch = the_tree.GetBranch("e1SCPhiWidth")
        #if not self.e1SCPhiWidth_branch and "e1SCPhiWidth" not in self.complained:
        if not self.e1SCPhiWidth_branch and "e1SCPhiWidth":
            warnings.warn( "EEETauTree: Expected branch e1SCPhiWidth does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1SCPhiWidth")
        else:
            self.e1SCPhiWidth_branch.SetAddress(<void*>&self.e1SCPhiWidth_value)

        #print "making e1SCPreshowerEnergy"
        self.e1SCPreshowerEnergy_branch = the_tree.GetBranch("e1SCPreshowerEnergy")
        #if not self.e1SCPreshowerEnergy_branch and "e1SCPreshowerEnergy" not in self.complained:
        if not self.e1SCPreshowerEnergy_branch and "e1SCPreshowerEnergy":
            warnings.warn( "EEETauTree: Expected branch e1SCPreshowerEnergy does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1SCPreshowerEnergy")
        else:
            self.e1SCPreshowerEnergy_branch.SetAddress(<void*>&self.e1SCPreshowerEnergy_value)

        #print "making e1SCRawEnergy"
        self.e1SCRawEnergy_branch = the_tree.GetBranch("e1SCRawEnergy")
        #if not self.e1SCRawEnergy_branch and "e1SCRawEnergy" not in self.complained:
        if not self.e1SCRawEnergy_branch and "e1SCRawEnergy":
            warnings.warn( "EEETauTree: Expected branch e1SCRawEnergy does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1SCRawEnergy")
        else:
            self.e1SCRawEnergy_branch.SetAddress(<void*>&self.e1SCRawEnergy_value)

        #print "making e1SigmaIEtaIEta"
        self.e1SigmaIEtaIEta_branch = the_tree.GetBranch("e1SigmaIEtaIEta")
        #if not self.e1SigmaIEtaIEta_branch and "e1SigmaIEtaIEta" not in self.complained:
        if not self.e1SigmaIEtaIEta_branch and "e1SigmaIEtaIEta":
            warnings.warn( "EEETauTree: Expected branch e1SigmaIEtaIEta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1SigmaIEtaIEta")
        else:
            self.e1SigmaIEtaIEta_branch.SetAddress(<void*>&self.e1SigmaIEtaIEta_value)

        #print "making e1ToMETDPhi"
        self.e1ToMETDPhi_branch = the_tree.GetBranch("e1ToMETDPhi")
        #if not self.e1ToMETDPhi_branch and "e1ToMETDPhi" not in self.complained:
        if not self.e1ToMETDPhi_branch and "e1ToMETDPhi":
            warnings.warn( "EEETauTree: Expected branch e1ToMETDPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1ToMETDPhi")
        else:
            self.e1ToMETDPhi_branch.SetAddress(<void*>&self.e1ToMETDPhi_value)

        #print "making e1TrkIsoDR03"
        self.e1TrkIsoDR03_branch = the_tree.GetBranch("e1TrkIsoDR03")
        #if not self.e1TrkIsoDR03_branch and "e1TrkIsoDR03" not in self.complained:
        if not self.e1TrkIsoDR03_branch and "e1TrkIsoDR03":
            warnings.warn( "EEETauTree: Expected branch e1TrkIsoDR03 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1TrkIsoDR03")
        else:
            self.e1TrkIsoDR03_branch.SetAddress(<void*>&self.e1TrkIsoDR03_value)

        #print "making e1VZ"
        self.e1VZ_branch = the_tree.GetBranch("e1VZ")
        #if not self.e1VZ_branch and "e1VZ" not in self.complained:
        if not self.e1VZ_branch and "e1VZ":
            warnings.warn( "EEETauTree: Expected branch e1VZ does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1VZ")
        else:
            self.e1VZ_branch.SetAddress(<void*>&self.e1VZ_value)

        #print "making e1WWID"
        self.e1WWID_branch = the_tree.GetBranch("e1WWID")
        #if not self.e1WWID_branch and "e1WWID" not in self.complained:
        if not self.e1WWID_branch and "e1WWID":
            warnings.warn( "EEETauTree: Expected branch e1WWID does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1WWID")
        else:
            self.e1WWID_branch.SetAddress(<void*>&self.e1WWID_value)

        #print "making e1_e2_CosThetaStar"
        self.e1_e2_CosThetaStar_branch = the_tree.GetBranch("e1_e2_CosThetaStar")
        #if not self.e1_e2_CosThetaStar_branch and "e1_e2_CosThetaStar" not in self.complained:
        if not self.e1_e2_CosThetaStar_branch and "e1_e2_CosThetaStar":
            warnings.warn( "EEETauTree: Expected branch e1_e2_CosThetaStar does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1_e2_CosThetaStar")
        else:
            self.e1_e2_CosThetaStar_branch.SetAddress(<void*>&self.e1_e2_CosThetaStar_value)

        #print "making e1_e2_DPhi"
        self.e1_e2_DPhi_branch = the_tree.GetBranch("e1_e2_DPhi")
        #if not self.e1_e2_DPhi_branch and "e1_e2_DPhi" not in self.complained:
        if not self.e1_e2_DPhi_branch and "e1_e2_DPhi":
            warnings.warn( "EEETauTree: Expected branch e1_e2_DPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1_e2_DPhi")
        else:
            self.e1_e2_DPhi_branch.SetAddress(<void*>&self.e1_e2_DPhi_value)

        #print "making e1_e2_DR"
        self.e1_e2_DR_branch = the_tree.GetBranch("e1_e2_DR")
        #if not self.e1_e2_DR_branch and "e1_e2_DR" not in self.complained:
        if not self.e1_e2_DR_branch and "e1_e2_DR":
            warnings.warn( "EEETauTree: Expected branch e1_e2_DR does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1_e2_DR")
        else:
            self.e1_e2_DR_branch.SetAddress(<void*>&self.e1_e2_DR_value)

        #print "making e1_e2_Eta"
        self.e1_e2_Eta_branch = the_tree.GetBranch("e1_e2_Eta")
        #if not self.e1_e2_Eta_branch and "e1_e2_Eta" not in self.complained:
        if not self.e1_e2_Eta_branch and "e1_e2_Eta":
            warnings.warn( "EEETauTree: Expected branch e1_e2_Eta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1_e2_Eta")
        else:
            self.e1_e2_Eta_branch.SetAddress(<void*>&self.e1_e2_Eta_value)

        #print "making e1_e2_Mass"
        self.e1_e2_Mass_branch = the_tree.GetBranch("e1_e2_Mass")
        #if not self.e1_e2_Mass_branch and "e1_e2_Mass" not in self.complained:
        if not self.e1_e2_Mass_branch and "e1_e2_Mass":
            warnings.warn( "EEETauTree: Expected branch e1_e2_Mass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1_e2_Mass")
        else:
            self.e1_e2_Mass_branch.SetAddress(<void*>&self.e1_e2_Mass_value)

        #print "making e1_e2_MassFsr"
        self.e1_e2_MassFsr_branch = the_tree.GetBranch("e1_e2_MassFsr")
        #if not self.e1_e2_MassFsr_branch and "e1_e2_MassFsr" not in self.complained:
        if not self.e1_e2_MassFsr_branch and "e1_e2_MassFsr":
            warnings.warn( "EEETauTree: Expected branch e1_e2_MassFsr does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1_e2_MassFsr")
        else:
            self.e1_e2_MassFsr_branch.SetAddress(<void*>&self.e1_e2_MassFsr_value)

        #print "making e1_e2_PZeta"
        self.e1_e2_PZeta_branch = the_tree.GetBranch("e1_e2_PZeta")
        #if not self.e1_e2_PZeta_branch and "e1_e2_PZeta" not in self.complained:
        if not self.e1_e2_PZeta_branch and "e1_e2_PZeta":
            warnings.warn( "EEETauTree: Expected branch e1_e2_PZeta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1_e2_PZeta")
        else:
            self.e1_e2_PZeta_branch.SetAddress(<void*>&self.e1_e2_PZeta_value)

        #print "making e1_e2_PZetaVis"
        self.e1_e2_PZetaVis_branch = the_tree.GetBranch("e1_e2_PZetaVis")
        #if not self.e1_e2_PZetaVis_branch and "e1_e2_PZetaVis" not in self.complained:
        if not self.e1_e2_PZetaVis_branch and "e1_e2_PZetaVis":
            warnings.warn( "EEETauTree: Expected branch e1_e2_PZetaVis does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1_e2_PZetaVis")
        else:
            self.e1_e2_PZetaVis_branch.SetAddress(<void*>&self.e1_e2_PZetaVis_value)

        #print "making e1_e2_Phi"
        self.e1_e2_Phi_branch = the_tree.GetBranch("e1_e2_Phi")
        #if not self.e1_e2_Phi_branch and "e1_e2_Phi" not in self.complained:
        if not self.e1_e2_Phi_branch and "e1_e2_Phi":
            warnings.warn( "EEETauTree: Expected branch e1_e2_Phi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1_e2_Phi")
        else:
            self.e1_e2_Phi_branch.SetAddress(<void*>&self.e1_e2_Phi_value)

        #print "making e1_e2_Pt"
        self.e1_e2_Pt_branch = the_tree.GetBranch("e1_e2_Pt")
        #if not self.e1_e2_Pt_branch and "e1_e2_Pt" not in self.complained:
        if not self.e1_e2_Pt_branch and "e1_e2_Pt":
            warnings.warn( "EEETauTree: Expected branch e1_e2_Pt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1_e2_Pt")
        else:
            self.e1_e2_Pt_branch.SetAddress(<void*>&self.e1_e2_Pt_value)

        #print "making e1_e2_PtFsr"
        self.e1_e2_PtFsr_branch = the_tree.GetBranch("e1_e2_PtFsr")
        #if not self.e1_e2_PtFsr_branch and "e1_e2_PtFsr" not in self.complained:
        if not self.e1_e2_PtFsr_branch and "e1_e2_PtFsr":
            warnings.warn( "EEETauTree: Expected branch e1_e2_PtFsr does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1_e2_PtFsr")
        else:
            self.e1_e2_PtFsr_branch.SetAddress(<void*>&self.e1_e2_PtFsr_value)

        #print "making e1_e2_SS"
        self.e1_e2_SS_branch = the_tree.GetBranch("e1_e2_SS")
        #if not self.e1_e2_SS_branch and "e1_e2_SS" not in self.complained:
        if not self.e1_e2_SS_branch and "e1_e2_SS":
            warnings.warn( "EEETauTree: Expected branch e1_e2_SS does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1_e2_SS")
        else:
            self.e1_e2_SS_branch.SetAddress(<void*>&self.e1_e2_SS_value)

        #print "making e1_e2_ToMETDPhi_Ty1"
        self.e1_e2_ToMETDPhi_Ty1_branch = the_tree.GetBranch("e1_e2_ToMETDPhi_Ty1")
        #if not self.e1_e2_ToMETDPhi_Ty1_branch and "e1_e2_ToMETDPhi_Ty1" not in self.complained:
        if not self.e1_e2_ToMETDPhi_Ty1_branch and "e1_e2_ToMETDPhi_Ty1":
            warnings.warn( "EEETauTree: Expected branch e1_e2_ToMETDPhi_Ty1 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1_e2_ToMETDPhi_Ty1")
        else:
            self.e1_e2_ToMETDPhi_Ty1_branch.SetAddress(<void*>&self.e1_e2_ToMETDPhi_Ty1_value)

        #print "making e1_e2_Zcompat"
        self.e1_e2_Zcompat_branch = the_tree.GetBranch("e1_e2_Zcompat")
        #if not self.e1_e2_Zcompat_branch and "e1_e2_Zcompat" not in self.complained:
        if not self.e1_e2_Zcompat_branch and "e1_e2_Zcompat":
            warnings.warn( "EEETauTree: Expected branch e1_e2_Zcompat does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1_e2_Zcompat")
        else:
            self.e1_e2_Zcompat_branch.SetAddress(<void*>&self.e1_e2_Zcompat_value)

        #print "making e1_e3_CosThetaStar"
        self.e1_e3_CosThetaStar_branch = the_tree.GetBranch("e1_e3_CosThetaStar")
        #if not self.e1_e3_CosThetaStar_branch and "e1_e3_CosThetaStar" not in self.complained:
        if not self.e1_e3_CosThetaStar_branch and "e1_e3_CosThetaStar":
            warnings.warn( "EEETauTree: Expected branch e1_e3_CosThetaStar does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1_e3_CosThetaStar")
        else:
            self.e1_e3_CosThetaStar_branch.SetAddress(<void*>&self.e1_e3_CosThetaStar_value)

        #print "making e1_e3_DPhi"
        self.e1_e3_DPhi_branch = the_tree.GetBranch("e1_e3_DPhi")
        #if not self.e1_e3_DPhi_branch and "e1_e3_DPhi" not in self.complained:
        if not self.e1_e3_DPhi_branch and "e1_e3_DPhi":
            warnings.warn( "EEETauTree: Expected branch e1_e3_DPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1_e3_DPhi")
        else:
            self.e1_e3_DPhi_branch.SetAddress(<void*>&self.e1_e3_DPhi_value)

        #print "making e1_e3_DR"
        self.e1_e3_DR_branch = the_tree.GetBranch("e1_e3_DR")
        #if not self.e1_e3_DR_branch and "e1_e3_DR" not in self.complained:
        if not self.e1_e3_DR_branch and "e1_e3_DR":
            warnings.warn( "EEETauTree: Expected branch e1_e3_DR does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1_e3_DR")
        else:
            self.e1_e3_DR_branch.SetAddress(<void*>&self.e1_e3_DR_value)

        #print "making e1_e3_Eta"
        self.e1_e3_Eta_branch = the_tree.GetBranch("e1_e3_Eta")
        #if not self.e1_e3_Eta_branch and "e1_e3_Eta" not in self.complained:
        if not self.e1_e3_Eta_branch and "e1_e3_Eta":
            warnings.warn( "EEETauTree: Expected branch e1_e3_Eta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1_e3_Eta")
        else:
            self.e1_e3_Eta_branch.SetAddress(<void*>&self.e1_e3_Eta_value)

        #print "making e1_e3_Mass"
        self.e1_e3_Mass_branch = the_tree.GetBranch("e1_e3_Mass")
        #if not self.e1_e3_Mass_branch and "e1_e3_Mass" not in self.complained:
        if not self.e1_e3_Mass_branch and "e1_e3_Mass":
            warnings.warn( "EEETauTree: Expected branch e1_e3_Mass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1_e3_Mass")
        else:
            self.e1_e3_Mass_branch.SetAddress(<void*>&self.e1_e3_Mass_value)

        #print "making e1_e3_MassFsr"
        self.e1_e3_MassFsr_branch = the_tree.GetBranch("e1_e3_MassFsr")
        #if not self.e1_e3_MassFsr_branch and "e1_e3_MassFsr" not in self.complained:
        if not self.e1_e3_MassFsr_branch and "e1_e3_MassFsr":
            warnings.warn( "EEETauTree: Expected branch e1_e3_MassFsr does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1_e3_MassFsr")
        else:
            self.e1_e3_MassFsr_branch.SetAddress(<void*>&self.e1_e3_MassFsr_value)

        #print "making e1_e3_PZeta"
        self.e1_e3_PZeta_branch = the_tree.GetBranch("e1_e3_PZeta")
        #if not self.e1_e3_PZeta_branch and "e1_e3_PZeta" not in self.complained:
        if not self.e1_e3_PZeta_branch and "e1_e3_PZeta":
            warnings.warn( "EEETauTree: Expected branch e1_e3_PZeta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1_e3_PZeta")
        else:
            self.e1_e3_PZeta_branch.SetAddress(<void*>&self.e1_e3_PZeta_value)

        #print "making e1_e3_PZetaVis"
        self.e1_e3_PZetaVis_branch = the_tree.GetBranch("e1_e3_PZetaVis")
        #if not self.e1_e3_PZetaVis_branch and "e1_e3_PZetaVis" not in self.complained:
        if not self.e1_e3_PZetaVis_branch and "e1_e3_PZetaVis":
            warnings.warn( "EEETauTree: Expected branch e1_e3_PZetaVis does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1_e3_PZetaVis")
        else:
            self.e1_e3_PZetaVis_branch.SetAddress(<void*>&self.e1_e3_PZetaVis_value)

        #print "making e1_e3_Phi"
        self.e1_e3_Phi_branch = the_tree.GetBranch("e1_e3_Phi")
        #if not self.e1_e3_Phi_branch and "e1_e3_Phi" not in self.complained:
        if not self.e1_e3_Phi_branch and "e1_e3_Phi":
            warnings.warn( "EEETauTree: Expected branch e1_e3_Phi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1_e3_Phi")
        else:
            self.e1_e3_Phi_branch.SetAddress(<void*>&self.e1_e3_Phi_value)

        #print "making e1_e3_Pt"
        self.e1_e3_Pt_branch = the_tree.GetBranch("e1_e3_Pt")
        #if not self.e1_e3_Pt_branch and "e1_e3_Pt" not in self.complained:
        if not self.e1_e3_Pt_branch and "e1_e3_Pt":
            warnings.warn( "EEETauTree: Expected branch e1_e3_Pt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1_e3_Pt")
        else:
            self.e1_e3_Pt_branch.SetAddress(<void*>&self.e1_e3_Pt_value)

        #print "making e1_e3_PtFsr"
        self.e1_e3_PtFsr_branch = the_tree.GetBranch("e1_e3_PtFsr")
        #if not self.e1_e3_PtFsr_branch and "e1_e3_PtFsr" not in self.complained:
        if not self.e1_e3_PtFsr_branch and "e1_e3_PtFsr":
            warnings.warn( "EEETauTree: Expected branch e1_e3_PtFsr does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1_e3_PtFsr")
        else:
            self.e1_e3_PtFsr_branch.SetAddress(<void*>&self.e1_e3_PtFsr_value)

        #print "making e1_e3_SS"
        self.e1_e3_SS_branch = the_tree.GetBranch("e1_e3_SS")
        #if not self.e1_e3_SS_branch and "e1_e3_SS" not in self.complained:
        if not self.e1_e3_SS_branch and "e1_e3_SS":
            warnings.warn( "EEETauTree: Expected branch e1_e3_SS does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1_e3_SS")
        else:
            self.e1_e3_SS_branch.SetAddress(<void*>&self.e1_e3_SS_value)

        #print "making e1_e3_ToMETDPhi_Ty1"
        self.e1_e3_ToMETDPhi_Ty1_branch = the_tree.GetBranch("e1_e3_ToMETDPhi_Ty1")
        #if not self.e1_e3_ToMETDPhi_Ty1_branch and "e1_e3_ToMETDPhi_Ty1" not in self.complained:
        if not self.e1_e3_ToMETDPhi_Ty1_branch and "e1_e3_ToMETDPhi_Ty1":
            warnings.warn( "EEETauTree: Expected branch e1_e3_ToMETDPhi_Ty1 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1_e3_ToMETDPhi_Ty1")
        else:
            self.e1_e3_ToMETDPhi_Ty1_branch.SetAddress(<void*>&self.e1_e3_ToMETDPhi_Ty1_value)

        #print "making e1_e3_Zcompat"
        self.e1_e3_Zcompat_branch = the_tree.GetBranch("e1_e3_Zcompat")
        #if not self.e1_e3_Zcompat_branch and "e1_e3_Zcompat" not in self.complained:
        if not self.e1_e3_Zcompat_branch and "e1_e3_Zcompat":
            warnings.warn( "EEETauTree: Expected branch e1_e3_Zcompat does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1_e3_Zcompat")
        else:
            self.e1_e3_Zcompat_branch.SetAddress(<void*>&self.e1_e3_Zcompat_value)

        #print "making e1_t_CosThetaStar"
        self.e1_t_CosThetaStar_branch = the_tree.GetBranch("e1_t_CosThetaStar")
        #if not self.e1_t_CosThetaStar_branch and "e1_t_CosThetaStar" not in self.complained:
        if not self.e1_t_CosThetaStar_branch and "e1_t_CosThetaStar":
            warnings.warn( "EEETauTree: Expected branch e1_t_CosThetaStar does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1_t_CosThetaStar")
        else:
            self.e1_t_CosThetaStar_branch.SetAddress(<void*>&self.e1_t_CosThetaStar_value)

        #print "making e1_t_DPhi"
        self.e1_t_DPhi_branch = the_tree.GetBranch("e1_t_DPhi")
        #if not self.e1_t_DPhi_branch and "e1_t_DPhi" not in self.complained:
        if not self.e1_t_DPhi_branch and "e1_t_DPhi":
            warnings.warn( "EEETauTree: Expected branch e1_t_DPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1_t_DPhi")
        else:
            self.e1_t_DPhi_branch.SetAddress(<void*>&self.e1_t_DPhi_value)

        #print "making e1_t_DR"
        self.e1_t_DR_branch = the_tree.GetBranch("e1_t_DR")
        #if not self.e1_t_DR_branch and "e1_t_DR" not in self.complained:
        if not self.e1_t_DR_branch and "e1_t_DR":
            warnings.warn( "EEETauTree: Expected branch e1_t_DR does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1_t_DR")
        else:
            self.e1_t_DR_branch.SetAddress(<void*>&self.e1_t_DR_value)

        #print "making e1_t_Eta"
        self.e1_t_Eta_branch = the_tree.GetBranch("e1_t_Eta")
        #if not self.e1_t_Eta_branch and "e1_t_Eta" not in self.complained:
        if not self.e1_t_Eta_branch and "e1_t_Eta":
            warnings.warn( "EEETauTree: Expected branch e1_t_Eta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1_t_Eta")
        else:
            self.e1_t_Eta_branch.SetAddress(<void*>&self.e1_t_Eta_value)

        #print "making e1_t_Mass"
        self.e1_t_Mass_branch = the_tree.GetBranch("e1_t_Mass")
        #if not self.e1_t_Mass_branch and "e1_t_Mass" not in self.complained:
        if not self.e1_t_Mass_branch and "e1_t_Mass":
            warnings.warn( "EEETauTree: Expected branch e1_t_Mass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1_t_Mass")
        else:
            self.e1_t_Mass_branch.SetAddress(<void*>&self.e1_t_Mass_value)

        #print "making e1_t_MassFsr"
        self.e1_t_MassFsr_branch = the_tree.GetBranch("e1_t_MassFsr")
        #if not self.e1_t_MassFsr_branch and "e1_t_MassFsr" not in self.complained:
        if not self.e1_t_MassFsr_branch and "e1_t_MassFsr":
            warnings.warn( "EEETauTree: Expected branch e1_t_MassFsr does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1_t_MassFsr")
        else:
            self.e1_t_MassFsr_branch.SetAddress(<void*>&self.e1_t_MassFsr_value)

        #print "making e1_t_PZeta"
        self.e1_t_PZeta_branch = the_tree.GetBranch("e1_t_PZeta")
        #if not self.e1_t_PZeta_branch and "e1_t_PZeta" not in self.complained:
        if not self.e1_t_PZeta_branch and "e1_t_PZeta":
            warnings.warn( "EEETauTree: Expected branch e1_t_PZeta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1_t_PZeta")
        else:
            self.e1_t_PZeta_branch.SetAddress(<void*>&self.e1_t_PZeta_value)

        #print "making e1_t_PZetaVis"
        self.e1_t_PZetaVis_branch = the_tree.GetBranch("e1_t_PZetaVis")
        #if not self.e1_t_PZetaVis_branch and "e1_t_PZetaVis" not in self.complained:
        if not self.e1_t_PZetaVis_branch and "e1_t_PZetaVis":
            warnings.warn( "EEETauTree: Expected branch e1_t_PZetaVis does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1_t_PZetaVis")
        else:
            self.e1_t_PZetaVis_branch.SetAddress(<void*>&self.e1_t_PZetaVis_value)

        #print "making e1_t_Phi"
        self.e1_t_Phi_branch = the_tree.GetBranch("e1_t_Phi")
        #if not self.e1_t_Phi_branch and "e1_t_Phi" not in self.complained:
        if not self.e1_t_Phi_branch and "e1_t_Phi":
            warnings.warn( "EEETauTree: Expected branch e1_t_Phi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1_t_Phi")
        else:
            self.e1_t_Phi_branch.SetAddress(<void*>&self.e1_t_Phi_value)

        #print "making e1_t_Pt"
        self.e1_t_Pt_branch = the_tree.GetBranch("e1_t_Pt")
        #if not self.e1_t_Pt_branch and "e1_t_Pt" not in self.complained:
        if not self.e1_t_Pt_branch and "e1_t_Pt":
            warnings.warn( "EEETauTree: Expected branch e1_t_Pt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1_t_Pt")
        else:
            self.e1_t_Pt_branch.SetAddress(<void*>&self.e1_t_Pt_value)

        #print "making e1_t_PtFsr"
        self.e1_t_PtFsr_branch = the_tree.GetBranch("e1_t_PtFsr")
        #if not self.e1_t_PtFsr_branch and "e1_t_PtFsr" not in self.complained:
        if not self.e1_t_PtFsr_branch and "e1_t_PtFsr":
            warnings.warn( "EEETauTree: Expected branch e1_t_PtFsr does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1_t_PtFsr")
        else:
            self.e1_t_PtFsr_branch.SetAddress(<void*>&self.e1_t_PtFsr_value)

        #print "making e1_t_SS"
        self.e1_t_SS_branch = the_tree.GetBranch("e1_t_SS")
        #if not self.e1_t_SS_branch and "e1_t_SS" not in self.complained:
        if not self.e1_t_SS_branch and "e1_t_SS":
            warnings.warn( "EEETauTree: Expected branch e1_t_SS does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1_t_SS")
        else:
            self.e1_t_SS_branch.SetAddress(<void*>&self.e1_t_SS_value)

        #print "making e1_t_ToMETDPhi_Ty1"
        self.e1_t_ToMETDPhi_Ty1_branch = the_tree.GetBranch("e1_t_ToMETDPhi_Ty1")
        #if not self.e1_t_ToMETDPhi_Ty1_branch and "e1_t_ToMETDPhi_Ty1" not in self.complained:
        if not self.e1_t_ToMETDPhi_Ty1_branch and "e1_t_ToMETDPhi_Ty1":
            warnings.warn( "EEETauTree: Expected branch e1_t_ToMETDPhi_Ty1 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1_t_ToMETDPhi_Ty1")
        else:
            self.e1_t_ToMETDPhi_Ty1_branch.SetAddress(<void*>&self.e1_t_ToMETDPhi_Ty1_value)

        #print "making e1_t_Zcompat"
        self.e1_t_Zcompat_branch = the_tree.GetBranch("e1_t_Zcompat")
        #if not self.e1_t_Zcompat_branch and "e1_t_Zcompat" not in self.complained:
        if not self.e1_t_Zcompat_branch and "e1_t_Zcompat":
            warnings.warn( "EEETauTree: Expected branch e1_t_Zcompat does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1_t_Zcompat")
        else:
            self.e1_t_Zcompat_branch.SetAddress(<void*>&self.e1_t_Zcompat_value)

        #print "making e1dECorrReg_2012Jul13ReReco"
        self.e1dECorrReg_2012Jul13ReReco_branch = the_tree.GetBranch("e1dECorrReg_2012Jul13ReReco")
        #if not self.e1dECorrReg_2012Jul13ReReco_branch and "e1dECorrReg_2012Jul13ReReco" not in self.complained:
        if not self.e1dECorrReg_2012Jul13ReReco_branch and "e1dECorrReg_2012Jul13ReReco":
            warnings.warn( "EEETauTree: Expected branch e1dECorrReg_2012Jul13ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1dECorrReg_2012Jul13ReReco")
        else:
            self.e1dECorrReg_2012Jul13ReReco_branch.SetAddress(<void*>&self.e1dECorrReg_2012Jul13ReReco_value)

        #print "making e1dECorrReg_Fall11"
        self.e1dECorrReg_Fall11_branch = the_tree.GetBranch("e1dECorrReg_Fall11")
        #if not self.e1dECorrReg_Fall11_branch and "e1dECorrReg_Fall11" not in self.complained:
        if not self.e1dECorrReg_Fall11_branch and "e1dECorrReg_Fall11":
            warnings.warn( "EEETauTree: Expected branch e1dECorrReg_Fall11 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1dECorrReg_Fall11")
        else:
            self.e1dECorrReg_Fall11_branch.SetAddress(<void*>&self.e1dECorrReg_Fall11_value)

        #print "making e1dECorrReg_Jan16ReReco"
        self.e1dECorrReg_Jan16ReReco_branch = the_tree.GetBranch("e1dECorrReg_Jan16ReReco")
        #if not self.e1dECorrReg_Jan16ReReco_branch and "e1dECorrReg_Jan16ReReco" not in self.complained:
        if not self.e1dECorrReg_Jan16ReReco_branch and "e1dECorrReg_Jan16ReReco":
            warnings.warn( "EEETauTree: Expected branch e1dECorrReg_Jan16ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1dECorrReg_Jan16ReReco")
        else:
            self.e1dECorrReg_Jan16ReReco_branch.SetAddress(<void*>&self.e1dECorrReg_Jan16ReReco_value)

        #print "making e1dECorrReg_Summer12_DR53X_HCP2012"
        self.e1dECorrReg_Summer12_DR53X_HCP2012_branch = the_tree.GetBranch("e1dECorrReg_Summer12_DR53X_HCP2012")
        #if not self.e1dECorrReg_Summer12_DR53X_HCP2012_branch and "e1dECorrReg_Summer12_DR53X_HCP2012" not in self.complained:
        if not self.e1dECorrReg_Summer12_DR53X_HCP2012_branch and "e1dECorrReg_Summer12_DR53X_HCP2012":
            warnings.warn( "EEETauTree: Expected branch e1dECorrReg_Summer12_DR53X_HCP2012 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1dECorrReg_Summer12_DR53X_HCP2012")
        else:
            self.e1dECorrReg_Summer12_DR53X_HCP2012_branch.SetAddress(<void*>&self.e1dECorrReg_Summer12_DR53X_HCP2012_value)

        #print "making e1dECorrSmearedNoReg_2012Jul13ReReco"
        self.e1dECorrSmearedNoReg_2012Jul13ReReco_branch = the_tree.GetBranch("e1dECorrSmearedNoReg_2012Jul13ReReco")
        #if not self.e1dECorrSmearedNoReg_2012Jul13ReReco_branch and "e1dECorrSmearedNoReg_2012Jul13ReReco" not in self.complained:
        if not self.e1dECorrSmearedNoReg_2012Jul13ReReco_branch and "e1dECorrSmearedNoReg_2012Jul13ReReco":
            warnings.warn( "EEETauTree: Expected branch e1dECorrSmearedNoReg_2012Jul13ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1dECorrSmearedNoReg_2012Jul13ReReco")
        else:
            self.e1dECorrSmearedNoReg_2012Jul13ReReco_branch.SetAddress(<void*>&self.e1dECorrSmearedNoReg_2012Jul13ReReco_value)

        #print "making e1dECorrSmearedNoReg_Fall11"
        self.e1dECorrSmearedNoReg_Fall11_branch = the_tree.GetBranch("e1dECorrSmearedNoReg_Fall11")
        #if not self.e1dECorrSmearedNoReg_Fall11_branch and "e1dECorrSmearedNoReg_Fall11" not in self.complained:
        if not self.e1dECorrSmearedNoReg_Fall11_branch and "e1dECorrSmearedNoReg_Fall11":
            warnings.warn( "EEETauTree: Expected branch e1dECorrSmearedNoReg_Fall11 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1dECorrSmearedNoReg_Fall11")
        else:
            self.e1dECorrSmearedNoReg_Fall11_branch.SetAddress(<void*>&self.e1dECorrSmearedNoReg_Fall11_value)

        #print "making e1dECorrSmearedNoReg_Jan16ReReco"
        self.e1dECorrSmearedNoReg_Jan16ReReco_branch = the_tree.GetBranch("e1dECorrSmearedNoReg_Jan16ReReco")
        #if not self.e1dECorrSmearedNoReg_Jan16ReReco_branch and "e1dECorrSmearedNoReg_Jan16ReReco" not in self.complained:
        if not self.e1dECorrSmearedNoReg_Jan16ReReco_branch and "e1dECorrSmearedNoReg_Jan16ReReco":
            warnings.warn( "EEETauTree: Expected branch e1dECorrSmearedNoReg_Jan16ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1dECorrSmearedNoReg_Jan16ReReco")
        else:
            self.e1dECorrSmearedNoReg_Jan16ReReco_branch.SetAddress(<void*>&self.e1dECorrSmearedNoReg_Jan16ReReco_value)

        #print "making e1dECorrSmearedNoReg_Summer12_DR53X_HCP2012"
        self.e1dECorrSmearedNoReg_Summer12_DR53X_HCP2012_branch = the_tree.GetBranch("e1dECorrSmearedNoReg_Summer12_DR53X_HCP2012")
        #if not self.e1dECorrSmearedNoReg_Summer12_DR53X_HCP2012_branch and "e1dECorrSmearedNoReg_Summer12_DR53X_HCP2012" not in self.complained:
        if not self.e1dECorrSmearedNoReg_Summer12_DR53X_HCP2012_branch and "e1dECorrSmearedNoReg_Summer12_DR53X_HCP2012":
            warnings.warn( "EEETauTree: Expected branch e1dECorrSmearedNoReg_Summer12_DR53X_HCP2012 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1dECorrSmearedNoReg_Summer12_DR53X_HCP2012")
        else:
            self.e1dECorrSmearedNoReg_Summer12_DR53X_HCP2012_branch.SetAddress(<void*>&self.e1dECorrSmearedNoReg_Summer12_DR53X_HCP2012_value)

        #print "making e1dECorrSmearedReg_2012Jul13ReReco"
        self.e1dECorrSmearedReg_2012Jul13ReReco_branch = the_tree.GetBranch("e1dECorrSmearedReg_2012Jul13ReReco")
        #if not self.e1dECorrSmearedReg_2012Jul13ReReco_branch and "e1dECorrSmearedReg_2012Jul13ReReco" not in self.complained:
        if not self.e1dECorrSmearedReg_2012Jul13ReReco_branch and "e1dECorrSmearedReg_2012Jul13ReReco":
            warnings.warn( "EEETauTree: Expected branch e1dECorrSmearedReg_2012Jul13ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1dECorrSmearedReg_2012Jul13ReReco")
        else:
            self.e1dECorrSmearedReg_2012Jul13ReReco_branch.SetAddress(<void*>&self.e1dECorrSmearedReg_2012Jul13ReReco_value)

        #print "making e1dECorrSmearedReg_Fall11"
        self.e1dECorrSmearedReg_Fall11_branch = the_tree.GetBranch("e1dECorrSmearedReg_Fall11")
        #if not self.e1dECorrSmearedReg_Fall11_branch and "e1dECorrSmearedReg_Fall11" not in self.complained:
        if not self.e1dECorrSmearedReg_Fall11_branch and "e1dECorrSmearedReg_Fall11":
            warnings.warn( "EEETauTree: Expected branch e1dECorrSmearedReg_Fall11 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1dECorrSmearedReg_Fall11")
        else:
            self.e1dECorrSmearedReg_Fall11_branch.SetAddress(<void*>&self.e1dECorrSmearedReg_Fall11_value)

        #print "making e1dECorrSmearedReg_Jan16ReReco"
        self.e1dECorrSmearedReg_Jan16ReReco_branch = the_tree.GetBranch("e1dECorrSmearedReg_Jan16ReReco")
        #if not self.e1dECorrSmearedReg_Jan16ReReco_branch and "e1dECorrSmearedReg_Jan16ReReco" not in self.complained:
        if not self.e1dECorrSmearedReg_Jan16ReReco_branch and "e1dECorrSmearedReg_Jan16ReReco":
            warnings.warn( "EEETauTree: Expected branch e1dECorrSmearedReg_Jan16ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1dECorrSmearedReg_Jan16ReReco")
        else:
            self.e1dECorrSmearedReg_Jan16ReReco_branch.SetAddress(<void*>&self.e1dECorrSmearedReg_Jan16ReReco_value)

        #print "making e1dECorrSmearedReg_Summer12_DR53X_HCP2012"
        self.e1dECorrSmearedReg_Summer12_DR53X_HCP2012_branch = the_tree.GetBranch("e1dECorrSmearedReg_Summer12_DR53X_HCP2012")
        #if not self.e1dECorrSmearedReg_Summer12_DR53X_HCP2012_branch and "e1dECorrSmearedReg_Summer12_DR53X_HCP2012" not in self.complained:
        if not self.e1dECorrSmearedReg_Summer12_DR53X_HCP2012_branch and "e1dECorrSmearedReg_Summer12_DR53X_HCP2012":
            warnings.warn( "EEETauTree: Expected branch e1dECorrSmearedReg_Summer12_DR53X_HCP2012 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1dECorrSmearedReg_Summer12_DR53X_HCP2012")
        else:
            self.e1dECorrSmearedReg_Summer12_DR53X_HCP2012_branch.SetAddress(<void*>&self.e1dECorrSmearedReg_Summer12_DR53X_HCP2012_value)

        #print "making e1deltaEtaSuperClusterTrackAtVtx"
        self.e1deltaEtaSuperClusterTrackAtVtx_branch = the_tree.GetBranch("e1deltaEtaSuperClusterTrackAtVtx")
        #if not self.e1deltaEtaSuperClusterTrackAtVtx_branch and "e1deltaEtaSuperClusterTrackAtVtx" not in self.complained:
        if not self.e1deltaEtaSuperClusterTrackAtVtx_branch and "e1deltaEtaSuperClusterTrackAtVtx":
            warnings.warn( "EEETauTree: Expected branch e1deltaEtaSuperClusterTrackAtVtx does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1deltaEtaSuperClusterTrackAtVtx")
        else:
            self.e1deltaEtaSuperClusterTrackAtVtx_branch.SetAddress(<void*>&self.e1deltaEtaSuperClusterTrackAtVtx_value)

        #print "making e1deltaPhiSuperClusterTrackAtVtx"
        self.e1deltaPhiSuperClusterTrackAtVtx_branch = the_tree.GetBranch("e1deltaPhiSuperClusterTrackAtVtx")
        #if not self.e1deltaPhiSuperClusterTrackAtVtx_branch and "e1deltaPhiSuperClusterTrackAtVtx" not in self.complained:
        if not self.e1deltaPhiSuperClusterTrackAtVtx_branch and "e1deltaPhiSuperClusterTrackAtVtx":
            warnings.warn( "EEETauTree: Expected branch e1deltaPhiSuperClusterTrackAtVtx does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1deltaPhiSuperClusterTrackAtVtx")
        else:
            self.e1deltaPhiSuperClusterTrackAtVtx_branch.SetAddress(<void*>&self.e1deltaPhiSuperClusterTrackAtVtx_value)

        #print "making e1eSuperClusterOverP"
        self.e1eSuperClusterOverP_branch = the_tree.GetBranch("e1eSuperClusterOverP")
        #if not self.e1eSuperClusterOverP_branch and "e1eSuperClusterOverP" not in self.complained:
        if not self.e1eSuperClusterOverP_branch and "e1eSuperClusterOverP":
            warnings.warn( "EEETauTree: Expected branch e1eSuperClusterOverP does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1eSuperClusterOverP")
        else:
            self.e1eSuperClusterOverP_branch.SetAddress(<void*>&self.e1eSuperClusterOverP_value)

        #print "making e1ecalEnergy"
        self.e1ecalEnergy_branch = the_tree.GetBranch("e1ecalEnergy")
        #if not self.e1ecalEnergy_branch and "e1ecalEnergy" not in self.complained:
        if not self.e1ecalEnergy_branch and "e1ecalEnergy":
            warnings.warn( "EEETauTree: Expected branch e1ecalEnergy does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1ecalEnergy")
        else:
            self.e1ecalEnergy_branch.SetAddress(<void*>&self.e1ecalEnergy_value)

        #print "making e1fBrem"
        self.e1fBrem_branch = the_tree.GetBranch("e1fBrem")
        #if not self.e1fBrem_branch and "e1fBrem" not in self.complained:
        if not self.e1fBrem_branch and "e1fBrem":
            warnings.warn( "EEETauTree: Expected branch e1fBrem does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1fBrem")
        else:
            self.e1fBrem_branch.SetAddress(<void*>&self.e1fBrem_value)

        #print "making e1trackMomentumAtVtxP"
        self.e1trackMomentumAtVtxP_branch = the_tree.GetBranch("e1trackMomentumAtVtxP")
        #if not self.e1trackMomentumAtVtxP_branch and "e1trackMomentumAtVtxP" not in self.complained:
        if not self.e1trackMomentumAtVtxP_branch and "e1trackMomentumAtVtxP":
            warnings.warn( "EEETauTree: Expected branch e1trackMomentumAtVtxP does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1trackMomentumAtVtxP")
        else:
            self.e1trackMomentumAtVtxP_branch.SetAddress(<void*>&self.e1trackMomentumAtVtxP_value)

        #print "making e2AbsEta"
        self.e2AbsEta_branch = the_tree.GetBranch("e2AbsEta")
        #if not self.e2AbsEta_branch and "e2AbsEta" not in self.complained:
        if not self.e2AbsEta_branch and "e2AbsEta":
            warnings.warn( "EEETauTree: Expected branch e2AbsEta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2AbsEta")
        else:
            self.e2AbsEta_branch.SetAddress(<void*>&self.e2AbsEta_value)

        #print "making e2CBID_LOOSE"
        self.e2CBID_LOOSE_branch = the_tree.GetBranch("e2CBID_LOOSE")
        #if not self.e2CBID_LOOSE_branch and "e2CBID_LOOSE" not in self.complained:
        if not self.e2CBID_LOOSE_branch and "e2CBID_LOOSE":
            warnings.warn( "EEETauTree: Expected branch e2CBID_LOOSE does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2CBID_LOOSE")
        else:
            self.e2CBID_LOOSE_branch.SetAddress(<void*>&self.e2CBID_LOOSE_value)

        #print "making e2CBID_MEDIUM"
        self.e2CBID_MEDIUM_branch = the_tree.GetBranch("e2CBID_MEDIUM")
        #if not self.e2CBID_MEDIUM_branch and "e2CBID_MEDIUM" not in self.complained:
        if not self.e2CBID_MEDIUM_branch and "e2CBID_MEDIUM":
            warnings.warn( "EEETauTree: Expected branch e2CBID_MEDIUM does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2CBID_MEDIUM")
        else:
            self.e2CBID_MEDIUM_branch.SetAddress(<void*>&self.e2CBID_MEDIUM_value)

        #print "making e2CBID_TIGHT"
        self.e2CBID_TIGHT_branch = the_tree.GetBranch("e2CBID_TIGHT")
        #if not self.e2CBID_TIGHT_branch and "e2CBID_TIGHT" not in self.complained:
        if not self.e2CBID_TIGHT_branch and "e2CBID_TIGHT":
            warnings.warn( "EEETauTree: Expected branch e2CBID_TIGHT does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2CBID_TIGHT")
        else:
            self.e2CBID_TIGHT_branch.SetAddress(<void*>&self.e2CBID_TIGHT_value)

        #print "making e2CBID_VETO"
        self.e2CBID_VETO_branch = the_tree.GetBranch("e2CBID_VETO")
        #if not self.e2CBID_VETO_branch and "e2CBID_VETO" not in self.complained:
        if not self.e2CBID_VETO_branch and "e2CBID_VETO":
            warnings.warn( "EEETauTree: Expected branch e2CBID_VETO does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2CBID_VETO")
        else:
            self.e2CBID_VETO_branch.SetAddress(<void*>&self.e2CBID_VETO_value)

        #print "making e2Charge"
        self.e2Charge_branch = the_tree.GetBranch("e2Charge")
        #if not self.e2Charge_branch and "e2Charge" not in self.complained:
        if not self.e2Charge_branch and "e2Charge":
            warnings.warn( "EEETauTree: Expected branch e2Charge does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2Charge")
        else:
            self.e2Charge_branch.SetAddress(<void*>&self.e2Charge_value)

        #print "making e2ChargeIdLoose"
        self.e2ChargeIdLoose_branch = the_tree.GetBranch("e2ChargeIdLoose")
        #if not self.e2ChargeIdLoose_branch and "e2ChargeIdLoose" not in self.complained:
        if not self.e2ChargeIdLoose_branch and "e2ChargeIdLoose":
            warnings.warn( "EEETauTree: Expected branch e2ChargeIdLoose does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2ChargeIdLoose")
        else:
            self.e2ChargeIdLoose_branch.SetAddress(<void*>&self.e2ChargeIdLoose_value)

        #print "making e2ChargeIdMed"
        self.e2ChargeIdMed_branch = the_tree.GetBranch("e2ChargeIdMed")
        #if not self.e2ChargeIdMed_branch and "e2ChargeIdMed" not in self.complained:
        if not self.e2ChargeIdMed_branch and "e2ChargeIdMed":
            warnings.warn( "EEETauTree: Expected branch e2ChargeIdMed does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2ChargeIdMed")
        else:
            self.e2ChargeIdMed_branch.SetAddress(<void*>&self.e2ChargeIdMed_value)

        #print "making e2ChargeIdTight"
        self.e2ChargeIdTight_branch = the_tree.GetBranch("e2ChargeIdTight")
        #if not self.e2ChargeIdTight_branch and "e2ChargeIdTight" not in self.complained:
        if not self.e2ChargeIdTight_branch and "e2ChargeIdTight":
            warnings.warn( "EEETauTree: Expected branch e2ChargeIdTight does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2ChargeIdTight")
        else:
            self.e2ChargeIdTight_branch.SetAddress(<void*>&self.e2ChargeIdTight_value)

        #print "making e2CiCTight"
        self.e2CiCTight_branch = the_tree.GetBranch("e2CiCTight")
        #if not self.e2CiCTight_branch and "e2CiCTight" not in self.complained:
        if not self.e2CiCTight_branch and "e2CiCTight":
            warnings.warn( "EEETauTree: Expected branch e2CiCTight does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2CiCTight")
        else:
            self.e2CiCTight_branch.SetAddress(<void*>&self.e2CiCTight_value)

        #print "making e2CiCTightElecOverlap"
        self.e2CiCTightElecOverlap_branch = the_tree.GetBranch("e2CiCTightElecOverlap")
        #if not self.e2CiCTightElecOverlap_branch and "e2CiCTightElecOverlap" not in self.complained:
        if not self.e2CiCTightElecOverlap_branch and "e2CiCTightElecOverlap":
            warnings.warn( "EEETauTree: Expected branch e2CiCTightElecOverlap does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2CiCTightElecOverlap")
        else:
            self.e2CiCTightElecOverlap_branch.SetAddress(<void*>&self.e2CiCTightElecOverlap_value)

        #print "making e2ComesFromHiggs"
        self.e2ComesFromHiggs_branch = the_tree.GetBranch("e2ComesFromHiggs")
        #if not self.e2ComesFromHiggs_branch and "e2ComesFromHiggs" not in self.complained:
        if not self.e2ComesFromHiggs_branch and "e2ComesFromHiggs":
            warnings.warn( "EEETauTree: Expected branch e2ComesFromHiggs does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2ComesFromHiggs")
        else:
            self.e2ComesFromHiggs_branch.SetAddress(<void*>&self.e2ComesFromHiggs_value)

        #print "making e2DZ"
        self.e2DZ_branch = the_tree.GetBranch("e2DZ")
        #if not self.e2DZ_branch and "e2DZ" not in self.complained:
        if not self.e2DZ_branch and "e2DZ":
            warnings.warn( "EEETauTree: Expected branch e2DZ does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2DZ")
        else:
            self.e2DZ_branch.SetAddress(<void*>&self.e2DZ_value)

        #print "making e2E1x5"
        self.e2E1x5_branch = the_tree.GetBranch("e2E1x5")
        #if not self.e2E1x5_branch and "e2E1x5" not in self.complained:
        if not self.e2E1x5_branch and "e2E1x5":
            warnings.warn( "EEETauTree: Expected branch e2E1x5 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2E1x5")
        else:
            self.e2E1x5_branch.SetAddress(<void*>&self.e2E1x5_value)

        #print "making e2E2x5Max"
        self.e2E2x5Max_branch = the_tree.GetBranch("e2E2x5Max")
        #if not self.e2E2x5Max_branch and "e2E2x5Max" not in self.complained:
        if not self.e2E2x5Max_branch and "e2E2x5Max":
            warnings.warn( "EEETauTree: Expected branch e2E2x5Max does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2E2x5Max")
        else:
            self.e2E2x5Max_branch.SetAddress(<void*>&self.e2E2x5Max_value)

        #print "making e2E5x5"
        self.e2E5x5_branch = the_tree.GetBranch("e2E5x5")
        #if not self.e2E5x5_branch and "e2E5x5" not in self.complained:
        if not self.e2E5x5_branch and "e2E5x5":
            warnings.warn( "EEETauTree: Expected branch e2E5x5 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2E5x5")
        else:
            self.e2E5x5_branch.SetAddress(<void*>&self.e2E5x5_value)

        #print "making e2ECorrReg_2012Jul13ReReco"
        self.e2ECorrReg_2012Jul13ReReco_branch = the_tree.GetBranch("e2ECorrReg_2012Jul13ReReco")
        #if not self.e2ECorrReg_2012Jul13ReReco_branch and "e2ECorrReg_2012Jul13ReReco" not in self.complained:
        if not self.e2ECorrReg_2012Jul13ReReco_branch and "e2ECorrReg_2012Jul13ReReco":
            warnings.warn( "EEETauTree: Expected branch e2ECorrReg_2012Jul13ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2ECorrReg_2012Jul13ReReco")
        else:
            self.e2ECorrReg_2012Jul13ReReco_branch.SetAddress(<void*>&self.e2ECorrReg_2012Jul13ReReco_value)

        #print "making e2ECorrReg_Fall11"
        self.e2ECorrReg_Fall11_branch = the_tree.GetBranch("e2ECorrReg_Fall11")
        #if not self.e2ECorrReg_Fall11_branch and "e2ECorrReg_Fall11" not in self.complained:
        if not self.e2ECorrReg_Fall11_branch and "e2ECorrReg_Fall11":
            warnings.warn( "EEETauTree: Expected branch e2ECorrReg_Fall11 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2ECorrReg_Fall11")
        else:
            self.e2ECorrReg_Fall11_branch.SetAddress(<void*>&self.e2ECorrReg_Fall11_value)

        #print "making e2ECorrReg_Jan16ReReco"
        self.e2ECorrReg_Jan16ReReco_branch = the_tree.GetBranch("e2ECorrReg_Jan16ReReco")
        #if not self.e2ECorrReg_Jan16ReReco_branch and "e2ECorrReg_Jan16ReReco" not in self.complained:
        if not self.e2ECorrReg_Jan16ReReco_branch and "e2ECorrReg_Jan16ReReco":
            warnings.warn( "EEETauTree: Expected branch e2ECorrReg_Jan16ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2ECorrReg_Jan16ReReco")
        else:
            self.e2ECorrReg_Jan16ReReco_branch.SetAddress(<void*>&self.e2ECorrReg_Jan16ReReco_value)

        #print "making e2ECorrReg_Summer12_DR53X_HCP2012"
        self.e2ECorrReg_Summer12_DR53X_HCP2012_branch = the_tree.GetBranch("e2ECorrReg_Summer12_DR53X_HCP2012")
        #if not self.e2ECorrReg_Summer12_DR53X_HCP2012_branch and "e2ECorrReg_Summer12_DR53X_HCP2012" not in self.complained:
        if not self.e2ECorrReg_Summer12_DR53X_HCP2012_branch and "e2ECorrReg_Summer12_DR53X_HCP2012":
            warnings.warn( "EEETauTree: Expected branch e2ECorrReg_Summer12_DR53X_HCP2012 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2ECorrReg_Summer12_DR53X_HCP2012")
        else:
            self.e2ECorrReg_Summer12_DR53X_HCP2012_branch.SetAddress(<void*>&self.e2ECorrReg_Summer12_DR53X_HCP2012_value)

        #print "making e2ECorrSmearedNoReg_2012Jul13ReReco"
        self.e2ECorrSmearedNoReg_2012Jul13ReReco_branch = the_tree.GetBranch("e2ECorrSmearedNoReg_2012Jul13ReReco")
        #if not self.e2ECorrSmearedNoReg_2012Jul13ReReco_branch and "e2ECorrSmearedNoReg_2012Jul13ReReco" not in self.complained:
        if not self.e2ECorrSmearedNoReg_2012Jul13ReReco_branch and "e2ECorrSmearedNoReg_2012Jul13ReReco":
            warnings.warn( "EEETauTree: Expected branch e2ECorrSmearedNoReg_2012Jul13ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2ECorrSmearedNoReg_2012Jul13ReReco")
        else:
            self.e2ECorrSmearedNoReg_2012Jul13ReReco_branch.SetAddress(<void*>&self.e2ECorrSmearedNoReg_2012Jul13ReReco_value)

        #print "making e2ECorrSmearedNoReg_Fall11"
        self.e2ECorrSmearedNoReg_Fall11_branch = the_tree.GetBranch("e2ECorrSmearedNoReg_Fall11")
        #if not self.e2ECorrSmearedNoReg_Fall11_branch and "e2ECorrSmearedNoReg_Fall11" not in self.complained:
        if not self.e2ECorrSmearedNoReg_Fall11_branch and "e2ECorrSmearedNoReg_Fall11":
            warnings.warn( "EEETauTree: Expected branch e2ECorrSmearedNoReg_Fall11 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2ECorrSmearedNoReg_Fall11")
        else:
            self.e2ECorrSmearedNoReg_Fall11_branch.SetAddress(<void*>&self.e2ECorrSmearedNoReg_Fall11_value)

        #print "making e2ECorrSmearedNoReg_Jan16ReReco"
        self.e2ECorrSmearedNoReg_Jan16ReReco_branch = the_tree.GetBranch("e2ECorrSmearedNoReg_Jan16ReReco")
        #if not self.e2ECorrSmearedNoReg_Jan16ReReco_branch and "e2ECorrSmearedNoReg_Jan16ReReco" not in self.complained:
        if not self.e2ECorrSmearedNoReg_Jan16ReReco_branch and "e2ECorrSmearedNoReg_Jan16ReReco":
            warnings.warn( "EEETauTree: Expected branch e2ECorrSmearedNoReg_Jan16ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2ECorrSmearedNoReg_Jan16ReReco")
        else:
            self.e2ECorrSmearedNoReg_Jan16ReReco_branch.SetAddress(<void*>&self.e2ECorrSmearedNoReg_Jan16ReReco_value)

        #print "making e2ECorrSmearedNoReg_Summer12_DR53X_HCP2012"
        self.e2ECorrSmearedNoReg_Summer12_DR53X_HCP2012_branch = the_tree.GetBranch("e2ECorrSmearedNoReg_Summer12_DR53X_HCP2012")
        #if not self.e2ECorrSmearedNoReg_Summer12_DR53X_HCP2012_branch and "e2ECorrSmearedNoReg_Summer12_DR53X_HCP2012" not in self.complained:
        if not self.e2ECorrSmearedNoReg_Summer12_DR53X_HCP2012_branch and "e2ECorrSmearedNoReg_Summer12_DR53X_HCP2012":
            warnings.warn( "EEETauTree: Expected branch e2ECorrSmearedNoReg_Summer12_DR53X_HCP2012 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2ECorrSmearedNoReg_Summer12_DR53X_HCP2012")
        else:
            self.e2ECorrSmearedNoReg_Summer12_DR53X_HCP2012_branch.SetAddress(<void*>&self.e2ECorrSmearedNoReg_Summer12_DR53X_HCP2012_value)

        #print "making e2ECorrSmearedReg_2012Jul13ReReco"
        self.e2ECorrSmearedReg_2012Jul13ReReco_branch = the_tree.GetBranch("e2ECorrSmearedReg_2012Jul13ReReco")
        #if not self.e2ECorrSmearedReg_2012Jul13ReReco_branch and "e2ECorrSmearedReg_2012Jul13ReReco" not in self.complained:
        if not self.e2ECorrSmearedReg_2012Jul13ReReco_branch and "e2ECorrSmearedReg_2012Jul13ReReco":
            warnings.warn( "EEETauTree: Expected branch e2ECorrSmearedReg_2012Jul13ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2ECorrSmearedReg_2012Jul13ReReco")
        else:
            self.e2ECorrSmearedReg_2012Jul13ReReco_branch.SetAddress(<void*>&self.e2ECorrSmearedReg_2012Jul13ReReco_value)

        #print "making e2ECorrSmearedReg_Fall11"
        self.e2ECorrSmearedReg_Fall11_branch = the_tree.GetBranch("e2ECorrSmearedReg_Fall11")
        #if not self.e2ECorrSmearedReg_Fall11_branch and "e2ECorrSmearedReg_Fall11" not in self.complained:
        if not self.e2ECorrSmearedReg_Fall11_branch and "e2ECorrSmearedReg_Fall11":
            warnings.warn( "EEETauTree: Expected branch e2ECorrSmearedReg_Fall11 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2ECorrSmearedReg_Fall11")
        else:
            self.e2ECorrSmearedReg_Fall11_branch.SetAddress(<void*>&self.e2ECorrSmearedReg_Fall11_value)

        #print "making e2ECorrSmearedReg_Jan16ReReco"
        self.e2ECorrSmearedReg_Jan16ReReco_branch = the_tree.GetBranch("e2ECorrSmearedReg_Jan16ReReco")
        #if not self.e2ECorrSmearedReg_Jan16ReReco_branch and "e2ECorrSmearedReg_Jan16ReReco" not in self.complained:
        if not self.e2ECorrSmearedReg_Jan16ReReco_branch and "e2ECorrSmearedReg_Jan16ReReco":
            warnings.warn( "EEETauTree: Expected branch e2ECorrSmearedReg_Jan16ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2ECorrSmearedReg_Jan16ReReco")
        else:
            self.e2ECorrSmearedReg_Jan16ReReco_branch.SetAddress(<void*>&self.e2ECorrSmearedReg_Jan16ReReco_value)

        #print "making e2ECorrSmearedReg_Summer12_DR53X_HCP2012"
        self.e2ECorrSmearedReg_Summer12_DR53X_HCP2012_branch = the_tree.GetBranch("e2ECorrSmearedReg_Summer12_DR53X_HCP2012")
        #if not self.e2ECorrSmearedReg_Summer12_DR53X_HCP2012_branch and "e2ECorrSmearedReg_Summer12_DR53X_HCP2012" not in self.complained:
        if not self.e2ECorrSmearedReg_Summer12_DR53X_HCP2012_branch and "e2ECorrSmearedReg_Summer12_DR53X_HCP2012":
            warnings.warn( "EEETauTree: Expected branch e2ECorrSmearedReg_Summer12_DR53X_HCP2012 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2ECorrSmearedReg_Summer12_DR53X_HCP2012")
        else:
            self.e2ECorrSmearedReg_Summer12_DR53X_HCP2012_branch.SetAddress(<void*>&self.e2ECorrSmearedReg_Summer12_DR53X_HCP2012_value)

        #print "making e2EcalIsoDR03"
        self.e2EcalIsoDR03_branch = the_tree.GetBranch("e2EcalIsoDR03")
        #if not self.e2EcalIsoDR03_branch and "e2EcalIsoDR03" not in self.complained:
        if not self.e2EcalIsoDR03_branch and "e2EcalIsoDR03":
            warnings.warn( "EEETauTree: Expected branch e2EcalIsoDR03 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2EcalIsoDR03")
        else:
            self.e2EcalIsoDR03_branch.SetAddress(<void*>&self.e2EcalIsoDR03_value)

        #print "making e2EffectiveArea2011Data"
        self.e2EffectiveArea2011Data_branch = the_tree.GetBranch("e2EffectiveArea2011Data")
        #if not self.e2EffectiveArea2011Data_branch and "e2EffectiveArea2011Data" not in self.complained:
        if not self.e2EffectiveArea2011Data_branch and "e2EffectiveArea2011Data":
            warnings.warn( "EEETauTree: Expected branch e2EffectiveArea2011Data does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2EffectiveArea2011Data")
        else:
            self.e2EffectiveArea2011Data_branch.SetAddress(<void*>&self.e2EffectiveArea2011Data_value)

        #print "making e2EffectiveArea2012Data"
        self.e2EffectiveArea2012Data_branch = the_tree.GetBranch("e2EffectiveArea2012Data")
        #if not self.e2EffectiveArea2012Data_branch and "e2EffectiveArea2012Data" not in self.complained:
        if not self.e2EffectiveArea2012Data_branch and "e2EffectiveArea2012Data":
            warnings.warn( "EEETauTree: Expected branch e2EffectiveArea2012Data does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2EffectiveArea2012Data")
        else:
            self.e2EffectiveArea2012Data_branch.SetAddress(<void*>&self.e2EffectiveArea2012Data_value)

        #print "making e2EffectiveAreaFall11MC"
        self.e2EffectiveAreaFall11MC_branch = the_tree.GetBranch("e2EffectiveAreaFall11MC")
        #if not self.e2EffectiveAreaFall11MC_branch and "e2EffectiveAreaFall11MC" not in self.complained:
        if not self.e2EffectiveAreaFall11MC_branch and "e2EffectiveAreaFall11MC":
            warnings.warn( "EEETauTree: Expected branch e2EffectiveAreaFall11MC does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2EffectiveAreaFall11MC")
        else:
            self.e2EffectiveAreaFall11MC_branch.SetAddress(<void*>&self.e2EffectiveAreaFall11MC_value)

        #print "making e2Ele27WP80PFMT50PFMTFilter"
        self.e2Ele27WP80PFMT50PFMTFilter_branch = the_tree.GetBranch("e2Ele27WP80PFMT50PFMTFilter")
        #if not self.e2Ele27WP80PFMT50PFMTFilter_branch and "e2Ele27WP80PFMT50PFMTFilter" not in self.complained:
        if not self.e2Ele27WP80PFMT50PFMTFilter_branch and "e2Ele27WP80PFMT50PFMTFilter":
            warnings.warn( "EEETauTree: Expected branch e2Ele27WP80PFMT50PFMTFilter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2Ele27WP80PFMT50PFMTFilter")
        else:
            self.e2Ele27WP80PFMT50PFMTFilter_branch.SetAddress(<void*>&self.e2Ele27WP80PFMT50PFMTFilter_value)

        #print "making e2Ele27WP80TrackIsoMatchFilter"
        self.e2Ele27WP80TrackIsoMatchFilter_branch = the_tree.GetBranch("e2Ele27WP80TrackIsoMatchFilter")
        #if not self.e2Ele27WP80TrackIsoMatchFilter_branch and "e2Ele27WP80TrackIsoMatchFilter" not in self.complained:
        if not self.e2Ele27WP80TrackIsoMatchFilter_branch and "e2Ele27WP80TrackIsoMatchFilter":
            warnings.warn( "EEETauTree: Expected branch e2Ele27WP80TrackIsoMatchFilter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2Ele27WP80TrackIsoMatchFilter")
        else:
            self.e2Ele27WP80TrackIsoMatchFilter_branch.SetAddress(<void*>&self.e2Ele27WP80TrackIsoMatchFilter_value)

        #print "making e2Ele32WP70PFMT50PFMTFilter"
        self.e2Ele32WP70PFMT50PFMTFilter_branch = the_tree.GetBranch("e2Ele32WP70PFMT50PFMTFilter")
        #if not self.e2Ele32WP70PFMT50PFMTFilter_branch and "e2Ele32WP70PFMT50PFMTFilter" not in self.complained:
        if not self.e2Ele32WP70PFMT50PFMTFilter_branch and "e2Ele32WP70PFMT50PFMTFilter":
            warnings.warn( "EEETauTree: Expected branch e2Ele32WP70PFMT50PFMTFilter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2Ele32WP70PFMT50PFMTFilter")
        else:
            self.e2Ele32WP70PFMT50PFMTFilter_branch.SetAddress(<void*>&self.e2Ele32WP70PFMT50PFMTFilter_value)

        #print "making e2ElecOverlap"
        self.e2ElecOverlap_branch = the_tree.GetBranch("e2ElecOverlap")
        #if not self.e2ElecOverlap_branch and "e2ElecOverlap" not in self.complained:
        if not self.e2ElecOverlap_branch and "e2ElecOverlap":
            warnings.warn( "EEETauTree: Expected branch e2ElecOverlap does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2ElecOverlap")
        else:
            self.e2ElecOverlap_branch.SetAddress(<void*>&self.e2ElecOverlap_value)

        #print "making e2ElecOverlapZHLoose"
        self.e2ElecOverlapZHLoose_branch = the_tree.GetBranch("e2ElecOverlapZHLoose")
        #if not self.e2ElecOverlapZHLoose_branch and "e2ElecOverlapZHLoose" not in self.complained:
        if not self.e2ElecOverlapZHLoose_branch and "e2ElecOverlapZHLoose":
            warnings.warn( "EEETauTree: Expected branch e2ElecOverlapZHLoose does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2ElecOverlapZHLoose")
        else:
            self.e2ElecOverlapZHLoose_branch.SetAddress(<void*>&self.e2ElecOverlapZHLoose_value)

        #print "making e2ElecOverlapZHTight"
        self.e2ElecOverlapZHTight_branch = the_tree.GetBranch("e2ElecOverlapZHTight")
        #if not self.e2ElecOverlapZHTight_branch and "e2ElecOverlapZHTight" not in self.complained:
        if not self.e2ElecOverlapZHTight_branch and "e2ElecOverlapZHTight":
            warnings.warn( "EEETauTree: Expected branch e2ElecOverlapZHTight does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2ElecOverlapZHTight")
        else:
            self.e2ElecOverlapZHTight_branch.SetAddress(<void*>&self.e2ElecOverlapZHTight_value)

        #print "making e2EnergyError"
        self.e2EnergyError_branch = the_tree.GetBranch("e2EnergyError")
        #if not self.e2EnergyError_branch and "e2EnergyError" not in self.complained:
        if not self.e2EnergyError_branch and "e2EnergyError":
            warnings.warn( "EEETauTree: Expected branch e2EnergyError does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2EnergyError")
        else:
            self.e2EnergyError_branch.SetAddress(<void*>&self.e2EnergyError_value)

        #print "making e2Eta"
        self.e2Eta_branch = the_tree.GetBranch("e2Eta")
        #if not self.e2Eta_branch and "e2Eta" not in self.complained:
        if not self.e2Eta_branch and "e2Eta":
            warnings.warn( "EEETauTree: Expected branch e2Eta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2Eta")
        else:
            self.e2Eta_branch.SetAddress(<void*>&self.e2Eta_value)

        #print "making e2EtaCorrReg_2012Jul13ReReco"
        self.e2EtaCorrReg_2012Jul13ReReco_branch = the_tree.GetBranch("e2EtaCorrReg_2012Jul13ReReco")
        #if not self.e2EtaCorrReg_2012Jul13ReReco_branch and "e2EtaCorrReg_2012Jul13ReReco" not in self.complained:
        if not self.e2EtaCorrReg_2012Jul13ReReco_branch and "e2EtaCorrReg_2012Jul13ReReco":
            warnings.warn( "EEETauTree: Expected branch e2EtaCorrReg_2012Jul13ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2EtaCorrReg_2012Jul13ReReco")
        else:
            self.e2EtaCorrReg_2012Jul13ReReco_branch.SetAddress(<void*>&self.e2EtaCorrReg_2012Jul13ReReco_value)

        #print "making e2EtaCorrReg_Fall11"
        self.e2EtaCorrReg_Fall11_branch = the_tree.GetBranch("e2EtaCorrReg_Fall11")
        #if not self.e2EtaCorrReg_Fall11_branch and "e2EtaCorrReg_Fall11" not in self.complained:
        if not self.e2EtaCorrReg_Fall11_branch and "e2EtaCorrReg_Fall11":
            warnings.warn( "EEETauTree: Expected branch e2EtaCorrReg_Fall11 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2EtaCorrReg_Fall11")
        else:
            self.e2EtaCorrReg_Fall11_branch.SetAddress(<void*>&self.e2EtaCorrReg_Fall11_value)

        #print "making e2EtaCorrReg_Jan16ReReco"
        self.e2EtaCorrReg_Jan16ReReco_branch = the_tree.GetBranch("e2EtaCorrReg_Jan16ReReco")
        #if not self.e2EtaCorrReg_Jan16ReReco_branch and "e2EtaCorrReg_Jan16ReReco" not in self.complained:
        if not self.e2EtaCorrReg_Jan16ReReco_branch and "e2EtaCorrReg_Jan16ReReco":
            warnings.warn( "EEETauTree: Expected branch e2EtaCorrReg_Jan16ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2EtaCorrReg_Jan16ReReco")
        else:
            self.e2EtaCorrReg_Jan16ReReco_branch.SetAddress(<void*>&self.e2EtaCorrReg_Jan16ReReco_value)

        #print "making e2EtaCorrReg_Summer12_DR53X_HCP2012"
        self.e2EtaCorrReg_Summer12_DR53X_HCP2012_branch = the_tree.GetBranch("e2EtaCorrReg_Summer12_DR53X_HCP2012")
        #if not self.e2EtaCorrReg_Summer12_DR53X_HCP2012_branch and "e2EtaCorrReg_Summer12_DR53X_HCP2012" not in self.complained:
        if not self.e2EtaCorrReg_Summer12_DR53X_HCP2012_branch and "e2EtaCorrReg_Summer12_DR53X_HCP2012":
            warnings.warn( "EEETauTree: Expected branch e2EtaCorrReg_Summer12_DR53X_HCP2012 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2EtaCorrReg_Summer12_DR53X_HCP2012")
        else:
            self.e2EtaCorrReg_Summer12_DR53X_HCP2012_branch.SetAddress(<void*>&self.e2EtaCorrReg_Summer12_DR53X_HCP2012_value)

        #print "making e2EtaCorrSmearedNoReg_2012Jul13ReReco"
        self.e2EtaCorrSmearedNoReg_2012Jul13ReReco_branch = the_tree.GetBranch("e2EtaCorrSmearedNoReg_2012Jul13ReReco")
        #if not self.e2EtaCorrSmearedNoReg_2012Jul13ReReco_branch and "e2EtaCorrSmearedNoReg_2012Jul13ReReco" not in self.complained:
        if not self.e2EtaCorrSmearedNoReg_2012Jul13ReReco_branch and "e2EtaCorrSmearedNoReg_2012Jul13ReReco":
            warnings.warn( "EEETauTree: Expected branch e2EtaCorrSmearedNoReg_2012Jul13ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2EtaCorrSmearedNoReg_2012Jul13ReReco")
        else:
            self.e2EtaCorrSmearedNoReg_2012Jul13ReReco_branch.SetAddress(<void*>&self.e2EtaCorrSmearedNoReg_2012Jul13ReReco_value)

        #print "making e2EtaCorrSmearedNoReg_Fall11"
        self.e2EtaCorrSmearedNoReg_Fall11_branch = the_tree.GetBranch("e2EtaCorrSmearedNoReg_Fall11")
        #if not self.e2EtaCorrSmearedNoReg_Fall11_branch and "e2EtaCorrSmearedNoReg_Fall11" not in self.complained:
        if not self.e2EtaCorrSmearedNoReg_Fall11_branch and "e2EtaCorrSmearedNoReg_Fall11":
            warnings.warn( "EEETauTree: Expected branch e2EtaCorrSmearedNoReg_Fall11 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2EtaCorrSmearedNoReg_Fall11")
        else:
            self.e2EtaCorrSmearedNoReg_Fall11_branch.SetAddress(<void*>&self.e2EtaCorrSmearedNoReg_Fall11_value)

        #print "making e2EtaCorrSmearedNoReg_Jan16ReReco"
        self.e2EtaCorrSmearedNoReg_Jan16ReReco_branch = the_tree.GetBranch("e2EtaCorrSmearedNoReg_Jan16ReReco")
        #if not self.e2EtaCorrSmearedNoReg_Jan16ReReco_branch and "e2EtaCorrSmearedNoReg_Jan16ReReco" not in self.complained:
        if not self.e2EtaCorrSmearedNoReg_Jan16ReReco_branch and "e2EtaCorrSmearedNoReg_Jan16ReReco":
            warnings.warn( "EEETauTree: Expected branch e2EtaCorrSmearedNoReg_Jan16ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2EtaCorrSmearedNoReg_Jan16ReReco")
        else:
            self.e2EtaCorrSmearedNoReg_Jan16ReReco_branch.SetAddress(<void*>&self.e2EtaCorrSmearedNoReg_Jan16ReReco_value)

        #print "making e2EtaCorrSmearedNoReg_Summer12_DR53X_HCP2012"
        self.e2EtaCorrSmearedNoReg_Summer12_DR53X_HCP2012_branch = the_tree.GetBranch("e2EtaCorrSmearedNoReg_Summer12_DR53X_HCP2012")
        #if not self.e2EtaCorrSmearedNoReg_Summer12_DR53X_HCP2012_branch and "e2EtaCorrSmearedNoReg_Summer12_DR53X_HCP2012" not in self.complained:
        if not self.e2EtaCorrSmearedNoReg_Summer12_DR53X_HCP2012_branch and "e2EtaCorrSmearedNoReg_Summer12_DR53X_HCP2012":
            warnings.warn( "EEETauTree: Expected branch e2EtaCorrSmearedNoReg_Summer12_DR53X_HCP2012 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2EtaCorrSmearedNoReg_Summer12_DR53X_HCP2012")
        else:
            self.e2EtaCorrSmearedNoReg_Summer12_DR53X_HCP2012_branch.SetAddress(<void*>&self.e2EtaCorrSmearedNoReg_Summer12_DR53X_HCP2012_value)

        #print "making e2EtaCorrSmearedReg_2012Jul13ReReco"
        self.e2EtaCorrSmearedReg_2012Jul13ReReco_branch = the_tree.GetBranch("e2EtaCorrSmearedReg_2012Jul13ReReco")
        #if not self.e2EtaCorrSmearedReg_2012Jul13ReReco_branch and "e2EtaCorrSmearedReg_2012Jul13ReReco" not in self.complained:
        if not self.e2EtaCorrSmearedReg_2012Jul13ReReco_branch and "e2EtaCorrSmearedReg_2012Jul13ReReco":
            warnings.warn( "EEETauTree: Expected branch e2EtaCorrSmearedReg_2012Jul13ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2EtaCorrSmearedReg_2012Jul13ReReco")
        else:
            self.e2EtaCorrSmearedReg_2012Jul13ReReco_branch.SetAddress(<void*>&self.e2EtaCorrSmearedReg_2012Jul13ReReco_value)

        #print "making e2EtaCorrSmearedReg_Fall11"
        self.e2EtaCorrSmearedReg_Fall11_branch = the_tree.GetBranch("e2EtaCorrSmearedReg_Fall11")
        #if not self.e2EtaCorrSmearedReg_Fall11_branch and "e2EtaCorrSmearedReg_Fall11" not in self.complained:
        if not self.e2EtaCorrSmearedReg_Fall11_branch and "e2EtaCorrSmearedReg_Fall11":
            warnings.warn( "EEETauTree: Expected branch e2EtaCorrSmearedReg_Fall11 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2EtaCorrSmearedReg_Fall11")
        else:
            self.e2EtaCorrSmearedReg_Fall11_branch.SetAddress(<void*>&self.e2EtaCorrSmearedReg_Fall11_value)

        #print "making e2EtaCorrSmearedReg_Jan16ReReco"
        self.e2EtaCorrSmearedReg_Jan16ReReco_branch = the_tree.GetBranch("e2EtaCorrSmearedReg_Jan16ReReco")
        #if not self.e2EtaCorrSmearedReg_Jan16ReReco_branch and "e2EtaCorrSmearedReg_Jan16ReReco" not in self.complained:
        if not self.e2EtaCorrSmearedReg_Jan16ReReco_branch and "e2EtaCorrSmearedReg_Jan16ReReco":
            warnings.warn( "EEETauTree: Expected branch e2EtaCorrSmearedReg_Jan16ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2EtaCorrSmearedReg_Jan16ReReco")
        else:
            self.e2EtaCorrSmearedReg_Jan16ReReco_branch.SetAddress(<void*>&self.e2EtaCorrSmearedReg_Jan16ReReco_value)

        #print "making e2EtaCorrSmearedReg_Summer12_DR53X_HCP2012"
        self.e2EtaCorrSmearedReg_Summer12_DR53X_HCP2012_branch = the_tree.GetBranch("e2EtaCorrSmearedReg_Summer12_DR53X_HCP2012")
        #if not self.e2EtaCorrSmearedReg_Summer12_DR53X_HCP2012_branch and "e2EtaCorrSmearedReg_Summer12_DR53X_HCP2012" not in self.complained:
        if not self.e2EtaCorrSmearedReg_Summer12_DR53X_HCP2012_branch and "e2EtaCorrSmearedReg_Summer12_DR53X_HCP2012":
            warnings.warn( "EEETauTree: Expected branch e2EtaCorrSmearedReg_Summer12_DR53X_HCP2012 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2EtaCorrSmearedReg_Summer12_DR53X_HCP2012")
        else:
            self.e2EtaCorrSmearedReg_Summer12_DR53X_HCP2012_branch.SetAddress(<void*>&self.e2EtaCorrSmearedReg_Summer12_DR53X_HCP2012_value)

        #print "making e2GenCharge"
        self.e2GenCharge_branch = the_tree.GetBranch("e2GenCharge")
        #if not self.e2GenCharge_branch and "e2GenCharge" not in self.complained:
        if not self.e2GenCharge_branch and "e2GenCharge":
            warnings.warn( "EEETauTree: Expected branch e2GenCharge does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2GenCharge")
        else:
            self.e2GenCharge_branch.SetAddress(<void*>&self.e2GenCharge_value)

        #print "making e2GenEnergy"
        self.e2GenEnergy_branch = the_tree.GetBranch("e2GenEnergy")
        #if not self.e2GenEnergy_branch and "e2GenEnergy" not in self.complained:
        if not self.e2GenEnergy_branch and "e2GenEnergy":
            warnings.warn( "EEETauTree: Expected branch e2GenEnergy does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2GenEnergy")
        else:
            self.e2GenEnergy_branch.SetAddress(<void*>&self.e2GenEnergy_value)

        #print "making e2GenEta"
        self.e2GenEta_branch = the_tree.GetBranch("e2GenEta")
        #if not self.e2GenEta_branch and "e2GenEta" not in self.complained:
        if not self.e2GenEta_branch and "e2GenEta":
            warnings.warn( "EEETauTree: Expected branch e2GenEta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2GenEta")
        else:
            self.e2GenEta_branch.SetAddress(<void*>&self.e2GenEta_value)

        #print "making e2GenMotherPdgId"
        self.e2GenMotherPdgId_branch = the_tree.GetBranch("e2GenMotherPdgId")
        #if not self.e2GenMotherPdgId_branch and "e2GenMotherPdgId" not in self.complained:
        if not self.e2GenMotherPdgId_branch and "e2GenMotherPdgId":
            warnings.warn( "EEETauTree: Expected branch e2GenMotherPdgId does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2GenMotherPdgId")
        else:
            self.e2GenMotherPdgId_branch.SetAddress(<void*>&self.e2GenMotherPdgId_value)

        #print "making e2GenPdgId"
        self.e2GenPdgId_branch = the_tree.GetBranch("e2GenPdgId")
        #if not self.e2GenPdgId_branch and "e2GenPdgId" not in self.complained:
        if not self.e2GenPdgId_branch and "e2GenPdgId":
            warnings.warn( "EEETauTree: Expected branch e2GenPdgId does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2GenPdgId")
        else:
            self.e2GenPdgId_branch.SetAddress(<void*>&self.e2GenPdgId_value)

        #print "making e2GenPhi"
        self.e2GenPhi_branch = the_tree.GetBranch("e2GenPhi")
        #if not self.e2GenPhi_branch and "e2GenPhi" not in self.complained:
        if not self.e2GenPhi_branch and "e2GenPhi":
            warnings.warn( "EEETauTree: Expected branch e2GenPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2GenPhi")
        else:
            self.e2GenPhi_branch.SetAddress(<void*>&self.e2GenPhi_value)

        #print "making e2HadronicDepth1OverEm"
        self.e2HadronicDepth1OverEm_branch = the_tree.GetBranch("e2HadronicDepth1OverEm")
        #if not self.e2HadronicDepth1OverEm_branch and "e2HadronicDepth1OverEm" not in self.complained:
        if not self.e2HadronicDepth1OverEm_branch and "e2HadronicDepth1OverEm":
            warnings.warn( "EEETauTree: Expected branch e2HadronicDepth1OverEm does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2HadronicDepth1OverEm")
        else:
            self.e2HadronicDepth1OverEm_branch.SetAddress(<void*>&self.e2HadronicDepth1OverEm_value)

        #print "making e2HadronicDepth2OverEm"
        self.e2HadronicDepth2OverEm_branch = the_tree.GetBranch("e2HadronicDepth2OverEm")
        #if not self.e2HadronicDepth2OverEm_branch and "e2HadronicDepth2OverEm" not in self.complained:
        if not self.e2HadronicDepth2OverEm_branch and "e2HadronicDepth2OverEm":
            warnings.warn( "EEETauTree: Expected branch e2HadronicDepth2OverEm does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2HadronicDepth2OverEm")
        else:
            self.e2HadronicDepth2OverEm_branch.SetAddress(<void*>&self.e2HadronicDepth2OverEm_value)

        #print "making e2HadronicOverEM"
        self.e2HadronicOverEM_branch = the_tree.GetBranch("e2HadronicOverEM")
        #if not self.e2HadronicOverEM_branch and "e2HadronicOverEM" not in self.complained:
        if not self.e2HadronicOverEM_branch and "e2HadronicOverEM":
            warnings.warn( "EEETauTree: Expected branch e2HadronicOverEM does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2HadronicOverEM")
        else:
            self.e2HadronicOverEM_branch.SetAddress(<void*>&self.e2HadronicOverEM_value)

        #print "making e2HasConversion"
        self.e2HasConversion_branch = the_tree.GetBranch("e2HasConversion")
        #if not self.e2HasConversion_branch and "e2HasConversion" not in self.complained:
        if not self.e2HasConversion_branch and "e2HasConversion":
            warnings.warn( "EEETauTree: Expected branch e2HasConversion does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2HasConversion")
        else:
            self.e2HasConversion_branch.SetAddress(<void*>&self.e2HasConversion_value)

        #print "making e2HasMatchedConversion"
        self.e2HasMatchedConversion_branch = the_tree.GetBranch("e2HasMatchedConversion")
        #if not self.e2HasMatchedConversion_branch and "e2HasMatchedConversion" not in self.complained:
        if not self.e2HasMatchedConversion_branch and "e2HasMatchedConversion":
            warnings.warn( "EEETauTree: Expected branch e2HasMatchedConversion does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2HasMatchedConversion")
        else:
            self.e2HasMatchedConversion_branch.SetAddress(<void*>&self.e2HasMatchedConversion_value)

        #print "making e2HcalIsoDR03"
        self.e2HcalIsoDR03_branch = the_tree.GetBranch("e2HcalIsoDR03")
        #if not self.e2HcalIsoDR03_branch and "e2HcalIsoDR03" not in self.complained:
        if not self.e2HcalIsoDR03_branch and "e2HcalIsoDR03":
            warnings.warn( "EEETauTree: Expected branch e2HcalIsoDR03 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2HcalIsoDR03")
        else:
            self.e2HcalIsoDR03_branch.SetAddress(<void*>&self.e2HcalIsoDR03_value)

        #print "making e2IP3DS"
        self.e2IP3DS_branch = the_tree.GetBranch("e2IP3DS")
        #if not self.e2IP3DS_branch and "e2IP3DS" not in self.complained:
        if not self.e2IP3DS_branch and "e2IP3DS":
            warnings.warn( "EEETauTree: Expected branch e2IP3DS does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2IP3DS")
        else:
            self.e2IP3DS_branch.SetAddress(<void*>&self.e2IP3DS_value)

        #print "making e2JetArea"
        self.e2JetArea_branch = the_tree.GetBranch("e2JetArea")
        #if not self.e2JetArea_branch and "e2JetArea" not in self.complained:
        if not self.e2JetArea_branch and "e2JetArea":
            warnings.warn( "EEETauTree: Expected branch e2JetArea does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2JetArea")
        else:
            self.e2JetArea_branch.SetAddress(<void*>&self.e2JetArea_value)

        #print "making e2JetBtag"
        self.e2JetBtag_branch = the_tree.GetBranch("e2JetBtag")
        #if not self.e2JetBtag_branch and "e2JetBtag" not in self.complained:
        if not self.e2JetBtag_branch and "e2JetBtag":
            warnings.warn( "EEETauTree: Expected branch e2JetBtag does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2JetBtag")
        else:
            self.e2JetBtag_branch.SetAddress(<void*>&self.e2JetBtag_value)

        #print "making e2JetCSVBtag"
        self.e2JetCSVBtag_branch = the_tree.GetBranch("e2JetCSVBtag")
        #if not self.e2JetCSVBtag_branch and "e2JetCSVBtag" not in self.complained:
        if not self.e2JetCSVBtag_branch and "e2JetCSVBtag":
            warnings.warn( "EEETauTree: Expected branch e2JetCSVBtag does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2JetCSVBtag")
        else:
            self.e2JetCSVBtag_branch.SetAddress(<void*>&self.e2JetCSVBtag_value)

        #print "making e2JetEtaEtaMoment"
        self.e2JetEtaEtaMoment_branch = the_tree.GetBranch("e2JetEtaEtaMoment")
        #if not self.e2JetEtaEtaMoment_branch and "e2JetEtaEtaMoment" not in self.complained:
        if not self.e2JetEtaEtaMoment_branch and "e2JetEtaEtaMoment":
            warnings.warn( "EEETauTree: Expected branch e2JetEtaEtaMoment does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2JetEtaEtaMoment")
        else:
            self.e2JetEtaEtaMoment_branch.SetAddress(<void*>&self.e2JetEtaEtaMoment_value)

        #print "making e2JetEtaPhiMoment"
        self.e2JetEtaPhiMoment_branch = the_tree.GetBranch("e2JetEtaPhiMoment")
        #if not self.e2JetEtaPhiMoment_branch and "e2JetEtaPhiMoment" not in self.complained:
        if not self.e2JetEtaPhiMoment_branch and "e2JetEtaPhiMoment":
            warnings.warn( "EEETauTree: Expected branch e2JetEtaPhiMoment does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2JetEtaPhiMoment")
        else:
            self.e2JetEtaPhiMoment_branch.SetAddress(<void*>&self.e2JetEtaPhiMoment_value)

        #print "making e2JetEtaPhiSpread"
        self.e2JetEtaPhiSpread_branch = the_tree.GetBranch("e2JetEtaPhiSpread")
        #if not self.e2JetEtaPhiSpread_branch and "e2JetEtaPhiSpread" not in self.complained:
        if not self.e2JetEtaPhiSpread_branch and "e2JetEtaPhiSpread":
            warnings.warn( "EEETauTree: Expected branch e2JetEtaPhiSpread does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2JetEtaPhiSpread")
        else:
            self.e2JetEtaPhiSpread_branch.SetAddress(<void*>&self.e2JetEtaPhiSpread_value)

        #print "making e2JetPartonFlavour"
        self.e2JetPartonFlavour_branch = the_tree.GetBranch("e2JetPartonFlavour")
        #if not self.e2JetPartonFlavour_branch and "e2JetPartonFlavour" not in self.complained:
        if not self.e2JetPartonFlavour_branch and "e2JetPartonFlavour":
            warnings.warn( "EEETauTree: Expected branch e2JetPartonFlavour does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2JetPartonFlavour")
        else:
            self.e2JetPartonFlavour_branch.SetAddress(<void*>&self.e2JetPartonFlavour_value)

        #print "making e2JetPhiPhiMoment"
        self.e2JetPhiPhiMoment_branch = the_tree.GetBranch("e2JetPhiPhiMoment")
        #if not self.e2JetPhiPhiMoment_branch and "e2JetPhiPhiMoment" not in self.complained:
        if not self.e2JetPhiPhiMoment_branch and "e2JetPhiPhiMoment":
            warnings.warn( "EEETauTree: Expected branch e2JetPhiPhiMoment does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2JetPhiPhiMoment")
        else:
            self.e2JetPhiPhiMoment_branch.SetAddress(<void*>&self.e2JetPhiPhiMoment_value)

        #print "making e2JetPt"
        self.e2JetPt_branch = the_tree.GetBranch("e2JetPt")
        #if not self.e2JetPt_branch and "e2JetPt" not in self.complained:
        if not self.e2JetPt_branch and "e2JetPt":
            warnings.warn( "EEETauTree: Expected branch e2JetPt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2JetPt")
        else:
            self.e2JetPt_branch.SetAddress(<void*>&self.e2JetPt_value)

        #print "making e2JetQGLikelihoodID"
        self.e2JetQGLikelihoodID_branch = the_tree.GetBranch("e2JetQGLikelihoodID")
        #if not self.e2JetQGLikelihoodID_branch and "e2JetQGLikelihoodID" not in self.complained:
        if not self.e2JetQGLikelihoodID_branch and "e2JetQGLikelihoodID":
            warnings.warn( "EEETauTree: Expected branch e2JetQGLikelihoodID does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2JetQGLikelihoodID")
        else:
            self.e2JetQGLikelihoodID_branch.SetAddress(<void*>&self.e2JetQGLikelihoodID_value)

        #print "making e2JetQGMVAID"
        self.e2JetQGMVAID_branch = the_tree.GetBranch("e2JetQGMVAID")
        #if not self.e2JetQGMVAID_branch and "e2JetQGMVAID" not in self.complained:
        if not self.e2JetQGMVAID_branch and "e2JetQGMVAID":
            warnings.warn( "EEETauTree: Expected branch e2JetQGMVAID does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2JetQGMVAID")
        else:
            self.e2JetQGMVAID_branch.SetAddress(<void*>&self.e2JetQGMVAID_value)

        #print "making e2Jetaxis1"
        self.e2Jetaxis1_branch = the_tree.GetBranch("e2Jetaxis1")
        #if not self.e2Jetaxis1_branch and "e2Jetaxis1" not in self.complained:
        if not self.e2Jetaxis1_branch and "e2Jetaxis1":
            warnings.warn( "EEETauTree: Expected branch e2Jetaxis1 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2Jetaxis1")
        else:
            self.e2Jetaxis1_branch.SetAddress(<void*>&self.e2Jetaxis1_value)

        #print "making e2Jetaxis2"
        self.e2Jetaxis2_branch = the_tree.GetBranch("e2Jetaxis2")
        #if not self.e2Jetaxis2_branch and "e2Jetaxis2" not in self.complained:
        if not self.e2Jetaxis2_branch and "e2Jetaxis2":
            warnings.warn( "EEETauTree: Expected branch e2Jetaxis2 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2Jetaxis2")
        else:
            self.e2Jetaxis2_branch.SetAddress(<void*>&self.e2Jetaxis2_value)

        #print "making e2Jetmult"
        self.e2Jetmult_branch = the_tree.GetBranch("e2Jetmult")
        #if not self.e2Jetmult_branch and "e2Jetmult" not in self.complained:
        if not self.e2Jetmult_branch and "e2Jetmult":
            warnings.warn( "EEETauTree: Expected branch e2Jetmult does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2Jetmult")
        else:
            self.e2Jetmult_branch.SetAddress(<void*>&self.e2Jetmult_value)

        #print "making e2JetmultMLP"
        self.e2JetmultMLP_branch = the_tree.GetBranch("e2JetmultMLP")
        #if not self.e2JetmultMLP_branch and "e2JetmultMLP" not in self.complained:
        if not self.e2JetmultMLP_branch and "e2JetmultMLP":
            warnings.warn( "EEETauTree: Expected branch e2JetmultMLP does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2JetmultMLP")
        else:
            self.e2JetmultMLP_branch.SetAddress(<void*>&self.e2JetmultMLP_value)

        #print "making e2JetmultMLPQC"
        self.e2JetmultMLPQC_branch = the_tree.GetBranch("e2JetmultMLPQC")
        #if not self.e2JetmultMLPQC_branch and "e2JetmultMLPQC" not in self.complained:
        if not self.e2JetmultMLPQC_branch and "e2JetmultMLPQC":
            warnings.warn( "EEETauTree: Expected branch e2JetmultMLPQC does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2JetmultMLPQC")
        else:
            self.e2JetmultMLPQC_branch.SetAddress(<void*>&self.e2JetmultMLPQC_value)

        #print "making e2JetptD"
        self.e2JetptD_branch = the_tree.GetBranch("e2JetptD")
        #if not self.e2JetptD_branch and "e2JetptD" not in self.complained:
        if not self.e2JetptD_branch and "e2JetptD":
            warnings.warn( "EEETauTree: Expected branch e2JetptD does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2JetptD")
        else:
            self.e2JetptD_branch.SetAddress(<void*>&self.e2JetptD_value)

        #print "making e2L1NonIsoHLTNonIsoMu17Ele8PixelMatchFilter"
        self.e2L1NonIsoHLTNonIsoMu17Ele8PixelMatchFilter_branch = the_tree.GetBranch("e2L1NonIsoHLTNonIsoMu17Ele8PixelMatchFilter")
        #if not self.e2L1NonIsoHLTNonIsoMu17Ele8PixelMatchFilter_branch and "e2L1NonIsoHLTNonIsoMu17Ele8PixelMatchFilter" not in self.complained:
        if not self.e2L1NonIsoHLTNonIsoMu17Ele8PixelMatchFilter_branch and "e2L1NonIsoHLTNonIsoMu17Ele8PixelMatchFilter":
            warnings.warn( "EEETauTree: Expected branch e2L1NonIsoHLTNonIsoMu17Ele8PixelMatchFilter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2L1NonIsoHLTNonIsoMu17Ele8PixelMatchFilter")
        else:
            self.e2L1NonIsoHLTNonIsoMu17Ele8PixelMatchFilter_branch.SetAddress(<void*>&self.e2L1NonIsoHLTNonIsoMu17Ele8PixelMatchFilter_value)

        #print "making e2MITID"
        self.e2MITID_branch = the_tree.GetBranch("e2MITID")
        #if not self.e2MITID_branch and "e2MITID" not in self.complained:
        if not self.e2MITID_branch and "e2MITID":
            warnings.warn( "EEETauTree: Expected branch e2MITID does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2MITID")
        else:
            self.e2MITID_branch.SetAddress(<void*>&self.e2MITID_value)

        #print "making e2MVAIDH2TauWP"
        self.e2MVAIDH2TauWP_branch = the_tree.GetBranch("e2MVAIDH2TauWP")
        #if not self.e2MVAIDH2TauWP_branch and "e2MVAIDH2TauWP" not in self.complained:
        if not self.e2MVAIDH2TauWP_branch and "e2MVAIDH2TauWP":
            warnings.warn( "EEETauTree: Expected branch e2MVAIDH2TauWP does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2MVAIDH2TauWP")
        else:
            self.e2MVAIDH2TauWP_branch.SetAddress(<void*>&self.e2MVAIDH2TauWP_value)

        #print "making e2MVANonTrig"
        self.e2MVANonTrig_branch = the_tree.GetBranch("e2MVANonTrig")
        #if not self.e2MVANonTrig_branch and "e2MVANonTrig" not in self.complained:
        if not self.e2MVANonTrig_branch and "e2MVANonTrig":
            warnings.warn( "EEETauTree: Expected branch e2MVANonTrig does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2MVANonTrig")
        else:
            self.e2MVANonTrig_branch.SetAddress(<void*>&self.e2MVANonTrig_value)

        #print "making e2MVATrig"
        self.e2MVATrig_branch = the_tree.GetBranch("e2MVATrig")
        #if not self.e2MVATrig_branch and "e2MVATrig" not in self.complained:
        if not self.e2MVATrig_branch and "e2MVATrig":
            warnings.warn( "EEETauTree: Expected branch e2MVATrig does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2MVATrig")
        else:
            self.e2MVATrig_branch.SetAddress(<void*>&self.e2MVATrig_value)

        #print "making e2MVATrigIDISO"
        self.e2MVATrigIDISO_branch = the_tree.GetBranch("e2MVATrigIDISO")
        #if not self.e2MVATrigIDISO_branch and "e2MVATrigIDISO" not in self.complained:
        if not self.e2MVATrigIDISO_branch and "e2MVATrigIDISO":
            warnings.warn( "EEETauTree: Expected branch e2MVATrigIDISO does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2MVATrigIDISO")
        else:
            self.e2MVATrigIDISO_branch.SetAddress(<void*>&self.e2MVATrigIDISO_value)

        #print "making e2MVATrigIDISOPUSUB"
        self.e2MVATrigIDISOPUSUB_branch = the_tree.GetBranch("e2MVATrigIDISOPUSUB")
        #if not self.e2MVATrigIDISOPUSUB_branch and "e2MVATrigIDISOPUSUB" not in self.complained:
        if not self.e2MVATrigIDISOPUSUB_branch and "e2MVATrigIDISOPUSUB":
            warnings.warn( "EEETauTree: Expected branch e2MVATrigIDISOPUSUB does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2MVATrigIDISOPUSUB")
        else:
            self.e2MVATrigIDISOPUSUB_branch.SetAddress(<void*>&self.e2MVATrigIDISOPUSUB_value)

        #print "making e2MVATrigNoIP"
        self.e2MVATrigNoIP_branch = the_tree.GetBranch("e2MVATrigNoIP")
        #if not self.e2MVATrigNoIP_branch and "e2MVATrigNoIP" not in self.complained:
        if not self.e2MVATrigNoIP_branch and "e2MVATrigNoIP":
            warnings.warn( "EEETauTree: Expected branch e2MVATrigNoIP does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2MVATrigNoIP")
        else:
            self.e2MVATrigNoIP_branch.SetAddress(<void*>&self.e2MVATrigNoIP_value)

        #print "making e2Mass"
        self.e2Mass_branch = the_tree.GetBranch("e2Mass")
        #if not self.e2Mass_branch and "e2Mass" not in self.complained:
        if not self.e2Mass_branch and "e2Mass":
            warnings.warn( "EEETauTree: Expected branch e2Mass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2Mass")
        else:
            self.e2Mass_branch.SetAddress(<void*>&self.e2Mass_value)

        #print "making e2MatchesDoubleEPath"
        self.e2MatchesDoubleEPath_branch = the_tree.GetBranch("e2MatchesDoubleEPath")
        #if not self.e2MatchesDoubleEPath_branch and "e2MatchesDoubleEPath" not in self.complained:
        if not self.e2MatchesDoubleEPath_branch and "e2MatchesDoubleEPath":
            warnings.warn( "EEETauTree: Expected branch e2MatchesDoubleEPath does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2MatchesDoubleEPath")
        else:
            self.e2MatchesDoubleEPath_branch.SetAddress(<void*>&self.e2MatchesDoubleEPath_value)

        #print "making e2MatchesMu17Ele8IsoPath"
        self.e2MatchesMu17Ele8IsoPath_branch = the_tree.GetBranch("e2MatchesMu17Ele8IsoPath")
        #if not self.e2MatchesMu17Ele8IsoPath_branch and "e2MatchesMu17Ele8IsoPath" not in self.complained:
        if not self.e2MatchesMu17Ele8IsoPath_branch and "e2MatchesMu17Ele8IsoPath":
            warnings.warn( "EEETauTree: Expected branch e2MatchesMu17Ele8IsoPath does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2MatchesMu17Ele8IsoPath")
        else:
            self.e2MatchesMu17Ele8IsoPath_branch.SetAddress(<void*>&self.e2MatchesMu17Ele8IsoPath_value)

        #print "making e2MatchesMu17Ele8Path"
        self.e2MatchesMu17Ele8Path_branch = the_tree.GetBranch("e2MatchesMu17Ele8Path")
        #if not self.e2MatchesMu17Ele8Path_branch and "e2MatchesMu17Ele8Path" not in self.complained:
        if not self.e2MatchesMu17Ele8Path_branch and "e2MatchesMu17Ele8Path":
            warnings.warn( "EEETauTree: Expected branch e2MatchesMu17Ele8Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2MatchesMu17Ele8Path")
        else:
            self.e2MatchesMu17Ele8Path_branch.SetAddress(<void*>&self.e2MatchesMu17Ele8Path_value)

        #print "making e2MatchesMu8Ele17IsoPath"
        self.e2MatchesMu8Ele17IsoPath_branch = the_tree.GetBranch("e2MatchesMu8Ele17IsoPath")
        #if not self.e2MatchesMu8Ele17IsoPath_branch and "e2MatchesMu8Ele17IsoPath" not in self.complained:
        if not self.e2MatchesMu8Ele17IsoPath_branch and "e2MatchesMu8Ele17IsoPath":
            warnings.warn( "EEETauTree: Expected branch e2MatchesMu8Ele17IsoPath does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2MatchesMu8Ele17IsoPath")
        else:
            self.e2MatchesMu8Ele17IsoPath_branch.SetAddress(<void*>&self.e2MatchesMu8Ele17IsoPath_value)

        #print "making e2MatchesMu8Ele17Path"
        self.e2MatchesMu8Ele17Path_branch = the_tree.GetBranch("e2MatchesMu8Ele17Path")
        #if not self.e2MatchesMu8Ele17Path_branch and "e2MatchesMu8Ele17Path" not in self.complained:
        if not self.e2MatchesMu8Ele17Path_branch and "e2MatchesMu8Ele17Path":
            warnings.warn( "EEETauTree: Expected branch e2MatchesMu8Ele17Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2MatchesMu8Ele17Path")
        else:
            self.e2MatchesMu8Ele17Path_branch.SetAddress(<void*>&self.e2MatchesMu8Ele17Path_value)

        #print "making e2MatchesSingleE"
        self.e2MatchesSingleE_branch = the_tree.GetBranch("e2MatchesSingleE")
        #if not self.e2MatchesSingleE_branch and "e2MatchesSingleE" not in self.complained:
        if not self.e2MatchesSingleE_branch and "e2MatchesSingleE":
            warnings.warn( "EEETauTree: Expected branch e2MatchesSingleE does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2MatchesSingleE")
        else:
            self.e2MatchesSingleE_branch.SetAddress(<void*>&self.e2MatchesSingleE_value)

        #print "making e2MatchesSingleEPlusMET"
        self.e2MatchesSingleEPlusMET_branch = the_tree.GetBranch("e2MatchesSingleEPlusMET")
        #if not self.e2MatchesSingleEPlusMET_branch and "e2MatchesSingleEPlusMET" not in self.complained:
        if not self.e2MatchesSingleEPlusMET_branch and "e2MatchesSingleEPlusMET":
            warnings.warn( "EEETauTree: Expected branch e2MatchesSingleEPlusMET does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2MatchesSingleEPlusMET")
        else:
            self.e2MatchesSingleEPlusMET_branch.SetAddress(<void*>&self.e2MatchesSingleEPlusMET_value)

        #print "making e2MissingHits"
        self.e2MissingHits_branch = the_tree.GetBranch("e2MissingHits")
        #if not self.e2MissingHits_branch and "e2MissingHits" not in self.complained:
        if not self.e2MissingHits_branch and "e2MissingHits":
            warnings.warn( "EEETauTree: Expected branch e2MissingHits does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2MissingHits")
        else:
            self.e2MissingHits_branch.SetAddress(<void*>&self.e2MissingHits_value)

        #print "making e2MtToMET"
        self.e2MtToMET_branch = the_tree.GetBranch("e2MtToMET")
        #if not self.e2MtToMET_branch and "e2MtToMET" not in self.complained:
        if not self.e2MtToMET_branch and "e2MtToMET":
            warnings.warn( "EEETauTree: Expected branch e2MtToMET does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2MtToMET")
        else:
            self.e2MtToMET_branch.SetAddress(<void*>&self.e2MtToMET_value)

        #print "making e2MtToMVAMET"
        self.e2MtToMVAMET_branch = the_tree.GetBranch("e2MtToMVAMET")
        #if not self.e2MtToMVAMET_branch and "e2MtToMVAMET" not in self.complained:
        if not self.e2MtToMVAMET_branch and "e2MtToMVAMET":
            warnings.warn( "EEETauTree: Expected branch e2MtToMVAMET does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2MtToMVAMET")
        else:
            self.e2MtToMVAMET_branch.SetAddress(<void*>&self.e2MtToMVAMET_value)

        #print "making e2MtToPFMET"
        self.e2MtToPFMET_branch = the_tree.GetBranch("e2MtToPFMET")
        #if not self.e2MtToPFMET_branch and "e2MtToPFMET" not in self.complained:
        if not self.e2MtToPFMET_branch and "e2MtToPFMET":
            warnings.warn( "EEETauTree: Expected branch e2MtToPFMET does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2MtToPFMET")
        else:
            self.e2MtToPFMET_branch.SetAddress(<void*>&self.e2MtToPFMET_value)

        #print "making e2MtToPfMet_Ty1"
        self.e2MtToPfMet_Ty1_branch = the_tree.GetBranch("e2MtToPfMet_Ty1")
        #if not self.e2MtToPfMet_Ty1_branch and "e2MtToPfMet_Ty1" not in self.complained:
        if not self.e2MtToPfMet_Ty1_branch and "e2MtToPfMet_Ty1":
            warnings.warn( "EEETauTree: Expected branch e2MtToPfMet_Ty1 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2MtToPfMet_Ty1")
        else:
            self.e2MtToPfMet_Ty1_branch.SetAddress(<void*>&self.e2MtToPfMet_Ty1_value)

        #print "making e2MtToPfMet_jes"
        self.e2MtToPfMet_jes_branch = the_tree.GetBranch("e2MtToPfMet_jes")
        #if not self.e2MtToPfMet_jes_branch and "e2MtToPfMet_jes" not in self.complained:
        if not self.e2MtToPfMet_jes_branch and "e2MtToPfMet_jes":
            warnings.warn( "EEETauTree: Expected branch e2MtToPfMet_jes does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2MtToPfMet_jes")
        else:
            self.e2MtToPfMet_jes_branch.SetAddress(<void*>&self.e2MtToPfMet_jes_value)

        #print "making e2MtToPfMet_mes"
        self.e2MtToPfMet_mes_branch = the_tree.GetBranch("e2MtToPfMet_mes")
        #if not self.e2MtToPfMet_mes_branch and "e2MtToPfMet_mes" not in self.complained:
        if not self.e2MtToPfMet_mes_branch and "e2MtToPfMet_mes":
            warnings.warn( "EEETauTree: Expected branch e2MtToPfMet_mes does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2MtToPfMet_mes")
        else:
            self.e2MtToPfMet_mes_branch.SetAddress(<void*>&self.e2MtToPfMet_mes_value)

        #print "making e2MtToPfMet_tes"
        self.e2MtToPfMet_tes_branch = the_tree.GetBranch("e2MtToPfMet_tes")
        #if not self.e2MtToPfMet_tes_branch and "e2MtToPfMet_tes" not in self.complained:
        if not self.e2MtToPfMet_tes_branch and "e2MtToPfMet_tes":
            warnings.warn( "EEETauTree: Expected branch e2MtToPfMet_tes does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2MtToPfMet_tes")
        else:
            self.e2MtToPfMet_tes_branch.SetAddress(<void*>&self.e2MtToPfMet_tes_value)

        #print "making e2MtToPfMet_ues"
        self.e2MtToPfMet_ues_branch = the_tree.GetBranch("e2MtToPfMet_ues")
        #if not self.e2MtToPfMet_ues_branch and "e2MtToPfMet_ues" not in self.complained:
        if not self.e2MtToPfMet_ues_branch and "e2MtToPfMet_ues":
            warnings.warn( "EEETauTree: Expected branch e2MtToPfMet_ues does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2MtToPfMet_ues")
        else:
            self.e2MtToPfMet_ues_branch.SetAddress(<void*>&self.e2MtToPfMet_ues_value)

        #print "making e2Mu17Ele8CaloIdTCaloIsoVLTrkIdVLTrkIsoVLTrackIsoFilter"
        self.e2Mu17Ele8CaloIdTCaloIsoVLTrkIdVLTrkIsoVLTrackIsoFilter_branch = the_tree.GetBranch("e2Mu17Ele8CaloIdTCaloIsoVLTrkIdVLTrkIsoVLTrackIsoFilter")
        #if not self.e2Mu17Ele8CaloIdTCaloIsoVLTrkIdVLTrkIsoVLTrackIsoFilter_branch and "e2Mu17Ele8CaloIdTCaloIsoVLTrkIdVLTrkIsoVLTrackIsoFilter" not in self.complained:
        if not self.e2Mu17Ele8CaloIdTCaloIsoVLTrkIdVLTrkIsoVLTrackIsoFilter_branch and "e2Mu17Ele8CaloIdTCaloIsoVLTrkIdVLTrkIsoVLTrackIsoFilter":
            warnings.warn( "EEETauTree: Expected branch e2Mu17Ele8CaloIdTCaloIsoVLTrkIdVLTrkIsoVLTrackIsoFilter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2Mu17Ele8CaloIdTCaloIsoVLTrkIdVLTrkIsoVLTrackIsoFilter")
        else:
            self.e2Mu17Ele8CaloIdTCaloIsoVLTrkIdVLTrkIsoVLTrackIsoFilter_branch.SetAddress(<void*>&self.e2Mu17Ele8CaloIdTCaloIsoVLTrkIdVLTrkIsoVLTrackIsoFilter_value)

        #print "making e2Mu17Ele8CaloIdTPixelMatchFilter"
        self.e2Mu17Ele8CaloIdTPixelMatchFilter_branch = the_tree.GetBranch("e2Mu17Ele8CaloIdTPixelMatchFilter")
        #if not self.e2Mu17Ele8CaloIdTPixelMatchFilter_branch and "e2Mu17Ele8CaloIdTPixelMatchFilter" not in self.complained:
        if not self.e2Mu17Ele8CaloIdTPixelMatchFilter_branch and "e2Mu17Ele8CaloIdTPixelMatchFilter":
            warnings.warn( "EEETauTree: Expected branch e2Mu17Ele8CaloIdTPixelMatchFilter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2Mu17Ele8CaloIdTPixelMatchFilter")
        else:
            self.e2Mu17Ele8CaloIdTPixelMatchFilter_branch.SetAddress(<void*>&self.e2Mu17Ele8CaloIdTPixelMatchFilter_value)

        #print "making e2Mu17Ele8dZFilter"
        self.e2Mu17Ele8dZFilter_branch = the_tree.GetBranch("e2Mu17Ele8dZFilter")
        #if not self.e2Mu17Ele8dZFilter_branch and "e2Mu17Ele8dZFilter" not in self.complained:
        if not self.e2Mu17Ele8dZFilter_branch and "e2Mu17Ele8dZFilter":
            warnings.warn( "EEETauTree: Expected branch e2Mu17Ele8dZFilter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2Mu17Ele8dZFilter")
        else:
            self.e2Mu17Ele8dZFilter_branch.SetAddress(<void*>&self.e2Mu17Ele8dZFilter_value)

        #print "making e2MuOverlap"
        self.e2MuOverlap_branch = the_tree.GetBranch("e2MuOverlap")
        #if not self.e2MuOverlap_branch and "e2MuOverlap" not in self.complained:
        if not self.e2MuOverlap_branch and "e2MuOverlap":
            warnings.warn( "EEETauTree: Expected branch e2MuOverlap does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2MuOverlap")
        else:
            self.e2MuOverlap_branch.SetAddress(<void*>&self.e2MuOverlap_value)

        #print "making e2MuOverlapZHLoose"
        self.e2MuOverlapZHLoose_branch = the_tree.GetBranch("e2MuOverlapZHLoose")
        #if not self.e2MuOverlapZHLoose_branch and "e2MuOverlapZHLoose" not in self.complained:
        if not self.e2MuOverlapZHLoose_branch and "e2MuOverlapZHLoose":
            warnings.warn( "EEETauTree: Expected branch e2MuOverlapZHLoose does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2MuOverlapZHLoose")
        else:
            self.e2MuOverlapZHLoose_branch.SetAddress(<void*>&self.e2MuOverlapZHLoose_value)

        #print "making e2MuOverlapZHTight"
        self.e2MuOverlapZHTight_branch = the_tree.GetBranch("e2MuOverlapZHTight")
        #if not self.e2MuOverlapZHTight_branch and "e2MuOverlapZHTight" not in self.complained:
        if not self.e2MuOverlapZHTight_branch and "e2MuOverlapZHTight":
            warnings.warn( "EEETauTree: Expected branch e2MuOverlapZHTight does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2MuOverlapZHTight")
        else:
            self.e2MuOverlapZHTight_branch.SetAddress(<void*>&self.e2MuOverlapZHTight_value)

        #print "making e2NearMuonVeto"
        self.e2NearMuonVeto_branch = the_tree.GetBranch("e2NearMuonVeto")
        #if not self.e2NearMuonVeto_branch and "e2NearMuonVeto" not in self.complained:
        if not self.e2NearMuonVeto_branch and "e2NearMuonVeto":
            warnings.warn( "EEETauTree: Expected branch e2NearMuonVeto does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2NearMuonVeto")
        else:
            self.e2NearMuonVeto_branch.SetAddress(<void*>&self.e2NearMuonVeto_value)

        #print "making e2PFChargedIso"
        self.e2PFChargedIso_branch = the_tree.GetBranch("e2PFChargedIso")
        #if not self.e2PFChargedIso_branch and "e2PFChargedIso" not in self.complained:
        if not self.e2PFChargedIso_branch and "e2PFChargedIso":
            warnings.warn( "EEETauTree: Expected branch e2PFChargedIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2PFChargedIso")
        else:
            self.e2PFChargedIso_branch.SetAddress(<void*>&self.e2PFChargedIso_value)

        #print "making e2PFNeutralIso"
        self.e2PFNeutralIso_branch = the_tree.GetBranch("e2PFNeutralIso")
        #if not self.e2PFNeutralIso_branch and "e2PFNeutralIso" not in self.complained:
        if not self.e2PFNeutralIso_branch and "e2PFNeutralIso":
            warnings.warn( "EEETauTree: Expected branch e2PFNeutralIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2PFNeutralIso")
        else:
            self.e2PFNeutralIso_branch.SetAddress(<void*>&self.e2PFNeutralIso_value)

        #print "making e2PFPhotonIso"
        self.e2PFPhotonIso_branch = the_tree.GetBranch("e2PFPhotonIso")
        #if not self.e2PFPhotonIso_branch and "e2PFPhotonIso" not in self.complained:
        if not self.e2PFPhotonIso_branch and "e2PFPhotonIso":
            warnings.warn( "EEETauTree: Expected branch e2PFPhotonIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2PFPhotonIso")
        else:
            self.e2PFPhotonIso_branch.SetAddress(<void*>&self.e2PFPhotonIso_value)

        #print "making e2PVDXY"
        self.e2PVDXY_branch = the_tree.GetBranch("e2PVDXY")
        #if not self.e2PVDXY_branch and "e2PVDXY" not in self.complained:
        if not self.e2PVDXY_branch and "e2PVDXY":
            warnings.warn( "EEETauTree: Expected branch e2PVDXY does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2PVDXY")
        else:
            self.e2PVDXY_branch.SetAddress(<void*>&self.e2PVDXY_value)

        #print "making e2PVDZ"
        self.e2PVDZ_branch = the_tree.GetBranch("e2PVDZ")
        #if not self.e2PVDZ_branch and "e2PVDZ" not in self.complained:
        if not self.e2PVDZ_branch and "e2PVDZ":
            warnings.warn( "EEETauTree: Expected branch e2PVDZ does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2PVDZ")
        else:
            self.e2PVDZ_branch.SetAddress(<void*>&self.e2PVDZ_value)

        #print "making e2Phi"
        self.e2Phi_branch = the_tree.GetBranch("e2Phi")
        #if not self.e2Phi_branch and "e2Phi" not in self.complained:
        if not self.e2Phi_branch and "e2Phi":
            warnings.warn( "EEETauTree: Expected branch e2Phi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2Phi")
        else:
            self.e2Phi_branch.SetAddress(<void*>&self.e2Phi_value)

        #print "making e2PhiCorrReg_2012Jul13ReReco"
        self.e2PhiCorrReg_2012Jul13ReReco_branch = the_tree.GetBranch("e2PhiCorrReg_2012Jul13ReReco")
        #if not self.e2PhiCorrReg_2012Jul13ReReco_branch and "e2PhiCorrReg_2012Jul13ReReco" not in self.complained:
        if not self.e2PhiCorrReg_2012Jul13ReReco_branch and "e2PhiCorrReg_2012Jul13ReReco":
            warnings.warn( "EEETauTree: Expected branch e2PhiCorrReg_2012Jul13ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2PhiCorrReg_2012Jul13ReReco")
        else:
            self.e2PhiCorrReg_2012Jul13ReReco_branch.SetAddress(<void*>&self.e2PhiCorrReg_2012Jul13ReReco_value)

        #print "making e2PhiCorrReg_Fall11"
        self.e2PhiCorrReg_Fall11_branch = the_tree.GetBranch("e2PhiCorrReg_Fall11")
        #if not self.e2PhiCorrReg_Fall11_branch and "e2PhiCorrReg_Fall11" not in self.complained:
        if not self.e2PhiCorrReg_Fall11_branch and "e2PhiCorrReg_Fall11":
            warnings.warn( "EEETauTree: Expected branch e2PhiCorrReg_Fall11 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2PhiCorrReg_Fall11")
        else:
            self.e2PhiCorrReg_Fall11_branch.SetAddress(<void*>&self.e2PhiCorrReg_Fall11_value)

        #print "making e2PhiCorrReg_Jan16ReReco"
        self.e2PhiCorrReg_Jan16ReReco_branch = the_tree.GetBranch("e2PhiCorrReg_Jan16ReReco")
        #if not self.e2PhiCorrReg_Jan16ReReco_branch and "e2PhiCorrReg_Jan16ReReco" not in self.complained:
        if not self.e2PhiCorrReg_Jan16ReReco_branch and "e2PhiCorrReg_Jan16ReReco":
            warnings.warn( "EEETauTree: Expected branch e2PhiCorrReg_Jan16ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2PhiCorrReg_Jan16ReReco")
        else:
            self.e2PhiCorrReg_Jan16ReReco_branch.SetAddress(<void*>&self.e2PhiCorrReg_Jan16ReReco_value)

        #print "making e2PhiCorrReg_Summer12_DR53X_HCP2012"
        self.e2PhiCorrReg_Summer12_DR53X_HCP2012_branch = the_tree.GetBranch("e2PhiCorrReg_Summer12_DR53X_HCP2012")
        #if not self.e2PhiCorrReg_Summer12_DR53X_HCP2012_branch and "e2PhiCorrReg_Summer12_DR53X_HCP2012" not in self.complained:
        if not self.e2PhiCorrReg_Summer12_DR53X_HCP2012_branch and "e2PhiCorrReg_Summer12_DR53X_HCP2012":
            warnings.warn( "EEETauTree: Expected branch e2PhiCorrReg_Summer12_DR53X_HCP2012 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2PhiCorrReg_Summer12_DR53X_HCP2012")
        else:
            self.e2PhiCorrReg_Summer12_DR53X_HCP2012_branch.SetAddress(<void*>&self.e2PhiCorrReg_Summer12_DR53X_HCP2012_value)

        #print "making e2PhiCorrSmearedNoReg_2012Jul13ReReco"
        self.e2PhiCorrSmearedNoReg_2012Jul13ReReco_branch = the_tree.GetBranch("e2PhiCorrSmearedNoReg_2012Jul13ReReco")
        #if not self.e2PhiCorrSmearedNoReg_2012Jul13ReReco_branch and "e2PhiCorrSmearedNoReg_2012Jul13ReReco" not in self.complained:
        if not self.e2PhiCorrSmearedNoReg_2012Jul13ReReco_branch and "e2PhiCorrSmearedNoReg_2012Jul13ReReco":
            warnings.warn( "EEETauTree: Expected branch e2PhiCorrSmearedNoReg_2012Jul13ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2PhiCorrSmearedNoReg_2012Jul13ReReco")
        else:
            self.e2PhiCorrSmearedNoReg_2012Jul13ReReco_branch.SetAddress(<void*>&self.e2PhiCorrSmearedNoReg_2012Jul13ReReco_value)

        #print "making e2PhiCorrSmearedNoReg_Fall11"
        self.e2PhiCorrSmearedNoReg_Fall11_branch = the_tree.GetBranch("e2PhiCorrSmearedNoReg_Fall11")
        #if not self.e2PhiCorrSmearedNoReg_Fall11_branch and "e2PhiCorrSmearedNoReg_Fall11" not in self.complained:
        if not self.e2PhiCorrSmearedNoReg_Fall11_branch and "e2PhiCorrSmearedNoReg_Fall11":
            warnings.warn( "EEETauTree: Expected branch e2PhiCorrSmearedNoReg_Fall11 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2PhiCorrSmearedNoReg_Fall11")
        else:
            self.e2PhiCorrSmearedNoReg_Fall11_branch.SetAddress(<void*>&self.e2PhiCorrSmearedNoReg_Fall11_value)

        #print "making e2PhiCorrSmearedNoReg_Jan16ReReco"
        self.e2PhiCorrSmearedNoReg_Jan16ReReco_branch = the_tree.GetBranch("e2PhiCorrSmearedNoReg_Jan16ReReco")
        #if not self.e2PhiCorrSmearedNoReg_Jan16ReReco_branch and "e2PhiCorrSmearedNoReg_Jan16ReReco" not in self.complained:
        if not self.e2PhiCorrSmearedNoReg_Jan16ReReco_branch and "e2PhiCorrSmearedNoReg_Jan16ReReco":
            warnings.warn( "EEETauTree: Expected branch e2PhiCorrSmearedNoReg_Jan16ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2PhiCorrSmearedNoReg_Jan16ReReco")
        else:
            self.e2PhiCorrSmearedNoReg_Jan16ReReco_branch.SetAddress(<void*>&self.e2PhiCorrSmearedNoReg_Jan16ReReco_value)

        #print "making e2PhiCorrSmearedNoReg_Summer12_DR53X_HCP2012"
        self.e2PhiCorrSmearedNoReg_Summer12_DR53X_HCP2012_branch = the_tree.GetBranch("e2PhiCorrSmearedNoReg_Summer12_DR53X_HCP2012")
        #if not self.e2PhiCorrSmearedNoReg_Summer12_DR53X_HCP2012_branch and "e2PhiCorrSmearedNoReg_Summer12_DR53X_HCP2012" not in self.complained:
        if not self.e2PhiCorrSmearedNoReg_Summer12_DR53X_HCP2012_branch and "e2PhiCorrSmearedNoReg_Summer12_DR53X_HCP2012":
            warnings.warn( "EEETauTree: Expected branch e2PhiCorrSmearedNoReg_Summer12_DR53X_HCP2012 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2PhiCorrSmearedNoReg_Summer12_DR53X_HCP2012")
        else:
            self.e2PhiCorrSmearedNoReg_Summer12_DR53X_HCP2012_branch.SetAddress(<void*>&self.e2PhiCorrSmearedNoReg_Summer12_DR53X_HCP2012_value)

        #print "making e2PhiCorrSmearedReg_2012Jul13ReReco"
        self.e2PhiCorrSmearedReg_2012Jul13ReReco_branch = the_tree.GetBranch("e2PhiCorrSmearedReg_2012Jul13ReReco")
        #if not self.e2PhiCorrSmearedReg_2012Jul13ReReco_branch and "e2PhiCorrSmearedReg_2012Jul13ReReco" not in self.complained:
        if not self.e2PhiCorrSmearedReg_2012Jul13ReReco_branch and "e2PhiCorrSmearedReg_2012Jul13ReReco":
            warnings.warn( "EEETauTree: Expected branch e2PhiCorrSmearedReg_2012Jul13ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2PhiCorrSmearedReg_2012Jul13ReReco")
        else:
            self.e2PhiCorrSmearedReg_2012Jul13ReReco_branch.SetAddress(<void*>&self.e2PhiCorrSmearedReg_2012Jul13ReReco_value)

        #print "making e2PhiCorrSmearedReg_Fall11"
        self.e2PhiCorrSmearedReg_Fall11_branch = the_tree.GetBranch("e2PhiCorrSmearedReg_Fall11")
        #if not self.e2PhiCorrSmearedReg_Fall11_branch and "e2PhiCorrSmearedReg_Fall11" not in self.complained:
        if not self.e2PhiCorrSmearedReg_Fall11_branch and "e2PhiCorrSmearedReg_Fall11":
            warnings.warn( "EEETauTree: Expected branch e2PhiCorrSmearedReg_Fall11 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2PhiCorrSmearedReg_Fall11")
        else:
            self.e2PhiCorrSmearedReg_Fall11_branch.SetAddress(<void*>&self.e2PhiCorrSmearedReg_Fall11_value)

        #print "making e2PhiCorrSmearedReg_Jan16ReReco"
        self.e2PhiCorrSmearedReg_Jan16ReReco_branch = the_tree.GetBranch("e2PhiCorrSmearedReg_Jan16ReReco")
        #if not self.e2PhiCorrSmearedReg_Jan16ReReco_branch and "e2PhiCorrSmearedReg_Jan16ReReco" not in self.complained:
        if not self.e2PhiCorrSmearedReg_Jan16ReReco_branch and "e2PhiCorrSmearedReg_Jan16ReReco":
            warnings.warn( "EEETauTree: Expected branch e2PhiCorrSmearedReg_Jan16ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2PhiCorrSmearedReg_Jan16ReReco")
        else:
            self.e2PhiCorrSmearedReg_Jan16ReReco_branch.SetAddress(<void*>&self.e2PhiCorrSmearedReg_Jan16ReReco_value)

        #print "making e2PhiCorrSmearedReg_Summer12_DR53X_HCP2012"
        self.e2PhiCorrSmearedReg_Summer12_DR53X_HCP2012_branch = the_tree.GetBranch("e2PhiCorrSmearedReg_Summer12_DR53X_HCP2012")
        #if not self.e2PhiCorrSmearedReg_Summer12_DR53X_HCP2012_branch and "e2PhiCorrSmearedReg_Summer12_DR53X_HCP2012" not in self.complained:
        if not self.e2PhiCorrSmearedReg_Summer12_DR53X_HCP2012_branch and "e2PhiCorrSmearedReg_Summer12_DR53X_HCP2012":
            warnings.warn( "EEETauTree: Expected branch e2PhiCorrSmearedReg_Summer12_DR53X_HCP2012 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2PhiCorrSmearedReg_Summer12_DR53X_HCP2012")
        else:
            self.e2PhiCorrSmearedReg_Summer12_DR53X_HCP2012_branch.SetAddress(<void*>&self.e2PhiCorrSmearedReg_Summer12_DR53X_HCP2012_value)

        #print "making e2Pt"
        self.e2Pt_branch = the_tree.GetBranch("e2Pt")
        #if not self.e2Pt_branch and "e2Pt" not in self.complained:
        if not self.e2Pt_branch and "e2Pt":
            warnings.warn( "EEETauTree: Expected branch e2Pt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2Pt")
        else:
            self.e2Pt_branch.SetAddress(<void*>&self.e2Pt_value)

        #print "making e2PtCorrReg_2012Jul13ReReco"
        self.e2PtCorrReg_2012Jul13ReReco_branch = the_tree.GetBranch("e2PtCorrReg_2012Jul13ReReco")
        #if not self.e2PtCorrReg_2012Jul13ReReco_branch and "e2PtCorrReg_2012Jul13ReReco" not in self.complained:
        if not self.e2PtCorrReg_2012Jul13ReReco_branch and "e2PtCorrReg_2012Jul13ReReco":
            warnings.warn( "EEETauTree: Expected branch e2PtCorrReg_2012Jul13ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2PtCorrReg_2012Jul13ReReco")
        else:
            self.e2PtCorrReg_2012Jul13ReReco_branch.SetAddress(<void*>&self.e2PtCorrReg_2012Jul13ReReco_value)

        #print "making e2PtCorrReg_Fall11"
        self.e2PtCorrReg_Fall11_branch = the_tree.GetBranch("e2PtCorrReg_Fall11")
        #if not self.e2PtCorrReg_Fall11_branch and "e2PtCorrReg_Fall11" not in self.complained:
        if not self.e2PtCorrReg_Fall11_branch and "e2PtCorrReg_Fall11":
            warnings.warn( "EEETauTree: Expected branch e2PtCorrReg_Fall11 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2PtCorrReg_Fall11")
        else:
            self.e2PtCorrReg_Fall11_branch.SetAddress(<void*>&self.e2PtCorrReg_Fall11_value)

        #print "making e2PtCorrReg_Jan16ReReco"
        self.e2PtCorrReg_Jan16ReReco_branch = the_tree.GetBranch("e2PtCorrReg_Jan16ReReco")
        #if not self.e2PtCorrReg_Jan16ReReco_branch and "e2PtCorrReg_Jan16ReReco" not in self.complained:
        if not self.e2PtCorrReg_Jan16ReReco_branch and "e2PtCorrReg_Jan16ReReco":
            warnings.warn( "EEETauTree: Expected branch e2PtCorrReg_Jan16ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2PtCorrReg_Jan16ReReco")
        else:
            self.e2PtCorrReg_Jan16ReReco_branch.SetAddress(<void*>&self.e2PtCorrReg_Jan16ReReco_value)

        #print "making e2PtCorrReg_Summer12_DR53X_HCP2012"
        self.e2PtCorrReg_Summer12_DR53X_HCP2012_branch = the_tree.GetBranch("e2PtCorrReg_Summer12_DR53X_HCP2012")
        #if not self.e2PtCorrReg_Summer12_DR53X_HCP2012_branch and "e2PtCorrReg_Summer12_DR53X_HCP2012" not in self.complained:
        if not self.e2PtCorrReg_Summer12_DR53X_HCP2012_branch and "e2PtCorrReg_Summer12_DR53X_HCP2012":
            warnings.warn( "EEETauTree: Expected branch e2PtCorrReg_Summer12_DR53X_HCP2012 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2PtCorrReg_Summer12_DR53X_HCP2012")
        else:
            self.e2PtCorrReg_Summer12_DR53X_HCP2012_branch.SetAddress(<void*>&self.e2PtCorrReg_Summer12_DR53X_HCP2012_value)

        #print "making e2PtCorrSmearedNoReg_2012Jul13ReReco"
        self.e2PtCorrSmearedNoReg_2012Jul13ReReco_branch = the_tree.GetBranch("e2PtCorrSmearedNoReg_2012Jul13ReReco")
        #if not self.e2PtCorrSmearedNoReg_2012Jul13ReReco_branch and "e2PtCorrSmearedNoReg_2012Jul13ReReco" not in self.complained:
        if not self.e2PtCorrSmearedNoReg_2012Jul13ReReco_branch and "e2PtCorrSmearedNoReg_2012Jul13ReReco":
            warnings.warn( "EEETauTree: Expected branch e2PtCorrSmearedNoReg_2012Jul13ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2PtCorrSmearedNoReg_2012Jul13ReReco")
        else:
            self.e2PtCorrSmearedNoReg_2012Jul13ReReco_branch.SetAddress(<void*>&self.e2PtCorrSmearedNoReg_2012Jul13ReReco_value)

        #print "making e2PtCorrSmearedNoReg_Fall11"
        self.e2PtCorrSmearedNoReg_Fall11_branch = the_tree.GetBranch("e2PtCorrSmearedNoReg_Fall11")
        #if not self.e2PtCorrSmearedNoReg_Fall11_branch and "e2PtCorrSmearedNoReg_Fall11" not in self.complained:
        if not self.e2PtCorrSmearedNoReg_Fall11_branch and "e2PtCorrSmearedNoReg_Fall11":
            warnings.warn( "EEETauTree: Expected branch e2PtCorrSmearedNoReg_Fall11 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2PtCorrSmearedNoReg_Fall11")
        else:
            self.e2PtCorrSmearedNoReg_Fall11_branch.SetAddress(<void*>&self.e2PtCorrSmearedNoReg_Fall11_value)

        #print "making e2PtCorrSmearedNoReg_Jan16ReReco"
        self.e2PtCorrSmearedNoReg_Jan16ReReco_branch = the_tree.GetBranch("e2PtCorrSmearedNoReg_Jan16ReReco")
        #if not self.e2PtCorrSmearedNoReg_Jan16ReReco_branch and "e2PtCorrSmearedNoReg_Jan16ReReco" not in self.complained:
        if not self.e2PtCorrSmearedNoReg_Jan16ReReco_branch and "e2PtCorrSmearedNoReg_Jan16ReReco":
            warnings.warn( "EEETauTree: Expected branch e2PtCorrSmearedNoReg_Jan16ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2PtCorrSmearedNoReg_Jan16ReReco")
        else:
            self.e2PtCorrSmearedNoReg_Jan16ReReco_branch.SetAddress(<void*>&self.e2PtCorrSmearedNoReg_Jan16ReReco_value)

        #print "making e2PtCorrSmearedNoReg_Summer12_DR53X_HCP2012"
        self.e2PtCorrSmearedNoReg_Summer12_DR53X_HCP2012_branch = the_tree.GetBranch("e2PtCorrSmearedNoReg_Summer12_DR53X_HCP2012")
        #if not self.e2PtCorrSmearedNoReg_Summer12_DR53X_HCP2012_branch and "e2PtCorrSmearedNoReg_Summer12_DR53X_HCP2012" not in self.complained:
        if not self.e2PtCorrSmearedNoReg_Summer12_DR53X_HCP2012_branch and "e2PtCorrSmearedNoReg_Summer12_DR53X_HCP2012":
            warnings.warn( "EEETauTree: Expected branch e2PtCorrSmearedNoReg_Summer12_DR53X_HCP2012 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2PtCorrSmearedNoReg_Summer12_DR53X_HCP2012")
        else:
            self.e2PtCorrSmearedNoReg_Summer12_DR53X_HCP2012_branch.SetAddress(<void*>&self.e2PtCorrSmearedNoReg_Summer12_DR53X_HCP2012_value)

        #print "making e2PtCorrSmearedReg_2012Jul13ReReco"
        self.e2PtCorrSmearedReg_2012Jul13ReReco_branch = the_tree.GetBranch("e2PtCorrSmearedReg_2012Jul13ReReco")
        #if not self.e2PtCorrSmearedReg_2012Jul13ReReco_branch and "e2PtCorrSmearedReg_2012Jul13ReReco" not in self.complained:
        if not self.e2PtCorrSmearedReg_2012Jul13ReReco_branch and "e2PtCorrSmearedReg_2012Jul13ReReco":
            warnings.warn( "EEETauTree: Expected branch e2PtCorrSmearedReg_2012Jul13ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2PtCorrSmearedReg_2012Jul13ReReco")
        else:
            self.e2PtCorrSmearedReg_2012Jul13ReReco_branch.SetAddress(<void*>&self.e2PtCorrSmearedReg_2012Jul13ReReco_value)

        #print "making e2PtCorrSmearedReg_Fall11"
        self.e2PtCorrSmearedReg_Fall11_branch = the_tree.GetBranch("e2PtCorrSmearedReg_Fall11")
        #if not self.e2PtCorrSmearedReg_Fall11_branch and "e2PtCorrSmearedReg_Fall11" not in self.complained:
        if not self.e2PtCorrSmearedReg_Fall11_branch and "e2PtCorrSmearedReg_Fall11":
            warnings.warn( "EEETauTree: Expected branch e2PtCorrSmearedReg_Fall11 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2PtCorrSmearedReg_Fall11")
        else:
            self.e2PtCorrSmearedReg_Fall11_branch.SetAddress(<void*>&self.e2PtCorrSmearedReg_Fall11_value)

        #print "making e2PtCorrSmearedReg_Jan16ReReco"
        self.e2PtCorrSmearedReg_Jan16ReReco_branch = the_tree.GetBranch("e2PtCorrSmearedReg_Jan16ReReco")
        #if not self.e2PtCorrSmearedReg_Jan16ReReco_branch and "e2PtCorrSmearedReg_Jan16ReReco" not in self.complained:
        if not self.e2PtCorrSmearedReg_Jan16ReReco_branch and "e2PtCorrSmearedReg_Jan16ReReco":
            warnings.warn( "EEETauTree: Expected branch e2PtCorrSmearedReg_Jan16ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2PtCorrSmearedReg_Jan16ReReco")
        else:
            self.e2PtCorrSmearedReg_Jan16ReReco_branch.SetAddress(<void*>&self.e2PtCorrSmearedReg_Jan16ReReco_value)

        #print "making e2PtCorrSmearedReg_Summer12_DR53X_HCP2012"
        self.e2PtCorrSmearedReg_Summer12_DR53X_HCP2012_branch = the_tree.GetBranch("e2PtCorrSmearedReg_Summer12_DR53X_HCP2012")
        #if not self.e2PtCorrSmearedReg_Summer12_DR53X_HCP2012_branch and "e2PtCorrSmearedReg_Summer12_DR53X_HCP2012" not in self.complained:
        if not self.e2PtCorrSmearedReg_Summer12_DR53X_HCP2012_branch and "e2PtCorrSmearedReg_Summer12_DR53X_HCP2012":
            warnings.warn( "EEETauTree: Expected branch e2PtCorrSmearedReg_Summer12_DR53X_HCP2012 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2PtCorrSmearedReg_Summer12_DR53X_HCP2012")
        else:
            self.e2PtCorrSmearedReg_Summer12_DR53X_HCP2012_branch.SetAddress(<void*>&self.e2PtCorrSmearedReg_Summer12_DR53X_HCP2012_value)

        #print "making e2Rank"
        self.e2Rank_branch = the_tree.GetBranch("e2Rank")
        #if not self.e2Rank_branch and "e2Rank" not in self.complained:
        if not self.e2Rank_branch and "e2Rank":
            warnings.warn( "EEETauTree: Expected branch e2Rank does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2Rank")
        else:
            self.e2Rank_branch.SetAddress(<void*>&self.e2Rank_value)

        #print "making e2RelIso"
        self.e2RelIso_branch = the_tree.GetBranch("e2RelIso")
        #if not self.e2RelIso_branch and "e2RelIso" not in self.complained:
        if not self.e2RelIso_branch and "e2RelIso":
            warnings.warn( "EEETauTree: Expected branch e2RelIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2RelIso")
        else:
            self.e2RelIso_branch.SetAddress(<void*>&self.e2RelIso_value)

        #print "making e2RelPFIsoDB"
        self.e2RelPFIsoDB_branch = the_tree.GetBranch("e2RelPFIsoDB")
        #if not self.e2RelPFIsoDB_branch and "e2RelPFIsoDB" not in self.complained:
        if not self.e2RelPFIsoDB_branch and "e2RelPFIsoDB":
            warnings.warn( "EEETauTree: Expected branch e2RelPFIsoDB does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2RelPFIsoDB")
        else:
            self.e2RelPFIsoDB_branch.SetAddress(<void*>&self.e2RelPFIsoDB_value)

        #print "making e2RelPFIsoRho"
        self.e2RelPFIsoRho_branch = the_tree.GetBranch("e2RelPFIsoRho")
        #if not self.e2RelPFIsoRho_branch and "e2RelPFIsoRho" not in self.complained:
        if not self.e2RelPFIsoRho_branch and "e2RelPFIsoRho":
            warnings.warn( "EEETauTree: Expected branch e2RelPFIsoRho does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2RelPFIsoRho")
        else:
            self.e2RelPFIsoRho_branch.SetAddress(<void*>&self.e2RelPFIsoRho_value)

        #print "making e2RelPFIsoRhoFSR"
        self.e2RelPFIsoRhoFSR_branch = the_tree.GetBranch("e2RelPFIsoRhoFSR")
        #if not self.e2RelPFIsoRhoFSR_branch and "e2RelPFIsoRhoFSR" not in self.complained:
        if not self.e2RelPFIsoRhoFSR_branch and "e2RelPFIsoRhoFSR":
            warnings.warn( "EEETauTree: Expected branch e2RelPFIsoRhoFSR does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2RelPFIsoRhoFSR")
        else:
            self.e2RelPFIsoRhoFSR_branch.SetAddress(<void*>&self.e2RelPFIsoRhoFSR_value)

        #print "making e2RhoHZG2011"
        self.e2RhoHZG2011_branch = the_tree.GetBranch("e2RhoHZG2011")
        #if not self.e2RhoHZG2011_branch and "e2RhoHZG2011" not in self.complained:
        if not self.e2RhoHZG2011_branch and "e2RhoHZG2011":
            warnings.warn( "EEETauTree: Expected branch e2RhoHZG2011 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2RhoHZG2011")
        else:
            self.e2RhoHZG2011_branch.SetAddress(<void*>&self.e2RhoHZG2011_value)

        #print "making e2RhoHZG2012"
        self.e2RhoHZG2012_branch = the_tree.GetBranch("e2RhoHZG2012")
        #if not self.e2RhoHZG2012_branch and "e2RhoHZG2012" not in self.complained:
        if not self.e2RhoHZG2012_branch and "e2RhoHZG2012":
            warnings.warn( "EEETauTree: Expected branch e2RhoHZG2012 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2RhoHZG2012")
        else:
            self.e2RhoHZG2012_branch.SetAddress(<void*>&self.e2RhoHZG2012_value)

        #print "making e2SCEnergy"
        self.e2SCEnergy_branch = the_tree.GetBranch("e2SCEnergy")
        #if not self.e2SCEnergy_branch and "e2SCEnergy" not in self.complained:
        if not self.e2SCEnergy_branch and "e2SCEnergy":
            warnings.warn( "EEETauTree: Expected branch e2SCEnergy does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2SCEnergy")
        else:
            self.e2SCEnergy_branch.SetAddress(<void*>&self.e2SCEnergy_value)

        #print "making e2SCEta"
        self.e2SCEta_branch = the_tree.GetBranch("e2SCEta")
        #if not self.e2SCEta_branch and "e2SCEta" not in self.complained:
        if not self.e2SCEta_branch and "e2SCEta":
            warnings.warn( "EEETauTree: Expected branch e2SCEta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2SCEta")
        else:
            self.e2SCEta_branch.SetAddress(<void*>&self.e2SCEta_value)

        #print "making e2SCEtaWidth"
        self.e2SCEtaWidth_branch = the_tree.GetBranch("e2SCEtaWidth")
        #if not self.e2SCEtaWidth_branch and "e2SCEtaWidth" not in self.complained:
        if not self.e2SCEtaWidth_branch and "e2SCEtaWidth":
            warnings.warn( "EEETauTree: Expected branch e2SCEtaWidth does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2SCEtaWidth")
        else:
            self.e2SCEtaWidth_branch.SetAddress(<void*>&self.e2SCEtaWidth_value)

        #print "making e2SCPhi"
        self.e2SCPhi_branch = the_tree.GetBranch("e2SCPhi")
        #if not self.e2SCPhi_branch and "e2SCPhi" not in self.complained:
        if not self.e2SCPhi_branch and "e2SCPhi":
            warnings.warn( "EEETauTree: Expected branch e2SCPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2SCPhi")
        else:
            self.e2SCPhi_branch.SetAddress(<void*>&self.e2SCPhi_value)

        #print "making e2SCPhiWidth"
        self.e2SCPhiWidth_branch = the_tree.GetBranch("e2SCPhiWidth")
        #if not self.e2SCPhiWidth_branch and "e2SCPhiWidth" not in self.complained:
        if not self.e2SCPhiWidth_branch and "e2SCPhiWidth":
            warnings.warn( "EEETauTree: Expected branch e2SCPhiWidth does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2SCPhiWidth")
        else:
            self.e2SCPhiWidth_branch.SetAddress(<void*>&self.e2SCPhiWidth_value)

        #print "making e2SCPreshowerEnergy"
        self.e2SCPreshowerEnergy_branch = the_tree.GetBranch("e2SCPreshowerEnergy")
        #if not self.e2SCPreshowerEnergy_branch and "e2SCPreshowerEnergy" not in self.complained:
        if not self.e2SCPreshowerEnergy_branch and "e2SCPreshowerEnergy":
            warnings.warn( "EEETauTree: Expected branch e2SCPreshowerEnergy does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2SCPreshowerEnergy")
        else:
            self.e2SCPreshowerEnergy_branch.SetAddress(<void*>&self.e2SCPreshowerEnergy_value)

        #print "making e2SCRawEnergy"
        self.e2SCRawEnergy_branch = the_tree.GetBranch("e2SCRawEnergy")
        #if not self.e2SCRawEnergy_branch and "e2SCRawEnergy" not in self.complained:
        if not self.e2SCRawEnergy_branch and "e2SCRawEnergy":
            warnings.warn( "EEETauTree: Expected branch e2SCRawEnergy does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2SCRawEnergy")
        else:
            self.e2SCRawEnergy_branch.SetAddress(<void*>&self.e2SCRawEnergy_value)

        #print "making e2SigmaIEtaIEta"
        self.e2SigmaIEtaIEta_branch = the_tree.GetBranch("e2SigmaIEtaIEta")
        #if not self.e2SigmaIEtaIEta_branch and "e2SigmaIEtaIEta" not in self.complained:
        if not self.e2SigmaIEtaIEta_branch and "e2SigmaIEtaIEta":
            warnings.warn( "EEETauTree: Expected branch e2SigmaIEtaIEta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2SigmaIEtaIEta")
        else:
            self.e2SigmaIEtaIEta_branch.SetAddress(<void*>&self.e2SigmaIEtaIEta_value)

        #print "making e2ToMETDPhi"
        self.e2ToMETDPhi_branch = the_tree.GetBranch("e2ToMETDPhi")
        #if not self.e2ToMETDPhi_branch and "e2ToMETDPhi" not in self.complained:
        if not self.e2ToMETDPhi_branch and "e2ToMETDPhi":
            warnings.warn( "EEETauTree: Expected branch e2ToMETDPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2ToMETDPhi")
        else:
            self.e2ToMETDPhi_branch.SetAddress(<void*>&self.e2ToMETDPhi_value)

        #print "making e2TrkIsoDR03"
        self.e2TrkIsoDR03_branch = the_tree.GetBranch("e2TrkIsoDR03")
        #if not self.e2TrkIsoDR03_branch and "e2TrkIsoDR03" not in self.complained:
        if not self.e2TrkIsoDR03_branch and "e2TrkIsoDR03":
            warnings.warn( "EEETauTree: Expected branch e2TrkIsoDR03 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2TrkIsoDR03")
        else:
            self.e2TrkIsoDR03_branch.SetAddress(<void*>&self.e2TrkIsoDR03_value)

        #print "making e2VZ"
        self.e2VZ_branch = the_tree.GetBranch("e2VZ")
        #if not self.e2VZ_branch and "e2VZ" not in self.complained:
        if not self.e2VZ_branch and "e2VZ":
            warnings.warn( "EEETauTree: Expected branch e2VZ does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2VZ")
        else:
            self.e2VZ_branch.SetAddress(<void*>&self.e2VZ_value)

        #print "making e2WWID"
        self.e2WWID_branch = the_tree.GetBranch("e2WWID")
        #if not self.e2WWID_branch and "e2WWID" not in self.complained:
        if not self.e2WWID_branch and "e2WWID":
            warnings.warn( "EEETauTree: Expected branch e2WWID does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2WWID")
        else:
            self.e2WWID_branch.SetAddress(<void*>&self.e2WWID_value)

        #print "making e2_e3_CosThetaStar"
        self.e2_e3_CosThetaStar_branch = the_tree.GetBranch("e2_e3_CosThetaStar")
        #if not self.e2_e3_CosThetaStar_branch and "e2_e3_CosThetaStar" not in self.complained:
        if not self.e2_e3_CosThetaStar_branch and "e2_e3_CosThetaStar":
            warnings.warn( "EEETauTree: Expected branch e2_e3_CosThetaStar does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2_e3_CosThetaStar")
        else:
            self.e2_e3_CosThetaStar_branch.SetAddress(<void*>&self.e2_e3_CosThetaStar_value)

        #print "making e2_e3_DPhi"
        self.e2_e3_DPhi_branch = the_tree.GetBranch("e2_e3_DPhi")
        #if not self.e2_e3_DPhi_branch and "e2_e3_DPhi" not in self.complained:
        if not self.e2_e3_DPhi_branch and "e2_e3_DPhi":
            warnings.warn( "EEETauTree: Expected branch e2_e3_DPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2_e3_DPhi")
        else:
            self.e2_e3_DPhi_branch.SetAddress(<void*>&self.e2_e3_DPhi_value)

        #print "making e2_e3_DR"
        self.e2_e3_DR_branch = the_tree.GetBranch("e2_e3_DR")
        #if not self.e2_e3_DR_branch and "e2_e3_DR" not in self.complained:
        if not self.e2_e3_DR_branch and "e2_e3_DR":
            warnings.warn( "EEETauTree: Expected branch e2_e3_DR does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2_e3_DR")
        else:
            self.e2_e3_DR_branch.SetAddress(<void*>&self.e2_e3_DR_value)

        #print "making e2_e3_Eta"
        self.e2_e3_Eta_branch = the_tree.GetBranch("e2_e3_Eta")
        #if not self.e2_e3_Eta_branch and "e2_e3_Eta" not in self.complained:
        if not self.e2_e3_Eta_branch and "e2_e3_Eta":
            warnings.warn( "EEETauTree: Expected branch e2_e3_Eta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2_e3_Eta")
        else:
            self.e2_e3_Eta_branch.SetAddress(<void*>&self.e2_e3_Eta_value)

        #print "making e2_e3_Mass"
        self.e2_e3_Mass_branch = the_tree.GetBranch("e2_e3_Mass")
        #if not self.e2_e3_Mass_branch and "e2_e3_Mass" not in self.complained:
        if not self.e2_e3_Mass_branch and "e2_e3_Mass":
            warnings.warn( "EEETauTree: Expected branch e2_e3_Mass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2_e3_Mass")
        else:
            self.e2_e3_Mass_branch.SetAddress(<void*>&self.e2_e3_Mass_value)

        #print "making e2_e3_MassFsr"
        self.e2_e3_MassFsr_branch = the_tree.GetBranch("e2_e3_MassFsr")
        #if not self.e2_e3_MassFsr_branch and "e2_e3_MassFsr" not in self.complained:
        if not self.e2_e3_MassFsr_branch and "e2_e3_MassFsr":
            warnings.warn( "EEETauTree: Expected branch e2_e3_MassFsr does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2_e3_MassFsr")
        else:
            self.e2_e3_MassFsr_branch.SetAddress(<void*>&self.e2_e3_MassFsr_value)

        #print "making e2_e3_PZeta"
        self.e2_e3_PZeta_branch = the_tree.GetBranch("e2_e3_PZeta")
        #if not self.e2_e3_PZeta_branch and "e2_e3_PZeta" not in self.complained:
        if not self.e2_e3_PZeta_branch and "e2_e3_PZeta":
            warnings.warn( "EEETauTree: Expected branch e2_e3_PZeta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2_e3_PZeta")
        else:
            self.e2_e3_PZeta_branch.SetAddress(<void*>&self.e2_e3_PZeta_value)

        #print "making e2_e3_PZetaVis"
        self.e2_e3_PZetaVis_branch = the_tree.GetBranch("e2_e3_PZetaVis")
        #if not self.e2_e3_PZetaVis_branch and "e2_e3_PZetaVis" not in self.complained:
        if not self.e2_e3_PZetaVis_branch and "e2_e3_PZetaVis":
            warnings.warn( "EEETauTree: Expected branch e2_e3_PZetaVis does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2_e3_PZetaVis")
        else:
            self.e2_e3_PZetaVis_branch.SetAddress(<void*>&self.e2_e3_PZetaVis_value)

        #print "making e2_e3_Phi"
        self.e2_e3_Phi_branch = the_tree.GetBranch("e2_e3_Phi")
        #if not self.e2_e3_Phi_branch and "e2_e3_Phi" not in self.complained:
        if not self.e2_e3_Phi_branch and "e2_e3_Phi":
            warnings.warn( "EEETauTree: Expected branch e2_e3_Phi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2_e3_Phi")
        else:
            self.e2_e3_Phi_branch.SetAddress(<void*>&self.e2_e3_Phi_value)

        #print "making e2_e3_Pt"
        self.e2_e3_Pt_branch = the_tree.GetBranch("e2_e3_Pt")
        #if not self.e2_e3_Pt_branch and "e2_e3_Pt" not in self.complained:
        if not self.e2_e3_Pt_branch and "e2_e3_Pt":
            warnings.warn( "EEETauTree: Expected branch e2_e3_Pt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2_e3_Pt")
        else:
            self.e2_e3_Pt_branch.SetAddress(<void*>&self.e2_e3_Pt_value)

        #print "making e2_e3_PtFsr"
        self.e2_e3_PtFsr_branch = the_tree.GetBranch("e2_e3_PtFsr")
        #if not self.e2_e3_PtFsr_branch and "e2_e3_PtFsr" not in self.complained:
        if not self.e2_e3_PtFsr_branch and "e2_e3_PtFsr":
            warnings.warn( "EEETauTree: Expected branch e2_e3_PtFsr does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2_e3_PtFsr")
        else:
            self.e2_e3_PtFsr_branch.SetAddress(<void*>&self.e2_e3_PtFsr_value)

        #print "making e2_e3_SS"
        self.e2_e3_SS_branch = the_tree.GetBranch("e2_e3_SS")
        #if not self.e2_e3_SS_branch and "e2_e3_SS" not in self.complained:
        if not self.e2_e3_SS_branch and "e2_e3_SS":
            warnings.warn( "EEETauTree: Expected branch e2_e3_SS does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2_e3_SS")
        else:
            self.e2_e3_SS_branch.SetAddress(<void*>&self.e2_e3_SS_value)

        #print "making e2_e3_ToMETDPhi_Ty1"
        self.e2_e3_ToMETDPhi_Ty1_branch = the_tree.GetBranch("e2_e3_ToMETDPhi_Ty1")
        #if not self.e2_e3_ToMETDPhi_Ty1_branch and "e2_e3_ToMETDPhi_Ty1" not in self.complained:
        if not self.e2_e3_ToMETDPhi_Ty1_branch and "e2_e3_ToMETDPhi_Ty1":
            warnings.warn( "EEETauTree: Expected branch e2_e3_ToMETDPhi_Ty1 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2_e3_ToMETDPhi_Ty1")
        else:
            self.e2_e3_ToMETDPhi_Ty1_branch.SetAddress(<void*>&self.e2_e3_ToMETDPhi_Ty1_value)

        #print "making e2_e3_Zcompat"
        self.e2_e3_Zcompat_branch = the_tree.GetBranch("e2_e3_Zcompat")
        #if not self.e2_e3_Zcompat_branch and "e2_e3_Zcompat" not in self.complained:
        if not self.e2_e3_Zcompat_branch and "e2_e3_Zcompat":
            warnings.warn( "EEETauTree: Expected branch e2_e3_Zcompat does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2_e3_Zcompat")
        else:
            self.e2_e3_Zcompat_branch.SetAddress(<void*>&self.e2_e3_Zcompat_value)

        #print "making e2_t_CosThetaStar"
        self.e2_t_CosThetaStar_branch = the_tree.GetBranch("e2_t_CosThetaStar")
        #if not self.e2_t_CosThetaStar_branch and "e2_t_CosThetaStar" not in self.complained:
        if not self.e2_t_CosThetaStar_branch and "e2_t_CosThetaStar":
            warnings.warn( "EEETauTree: Expected branch e2_t_CosThetaStar does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2_t_CosThetaStar")
        else:
            self.e2_t_CosThetaStar_branch.SetAddress(<void*>&self.e2_t_CosThetaStar_value)

        #print "making e2_t_DPhi"
        self.e2_t_DPhi_branch = the_tree.GetBranch("e2_t_DPhi")
        #if not self.e2_t_DPhi_branch and "e2_t_DPhi" not in self.complained:
        if not self.e2_t_DPhi_branch and "e2_t_DPhi":
            warnings.warn( "EEETauTree: Expected branch e2_t_DPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2_t_DPhi")
        else:
            self.e2_t_DPhi_branch.SetAddress(<void*>&self.e2_t_DPhi_value)

        #print "making e2_t_DR"
        self.e2_t_DR_branch = the_tree.GetBranch("e2_t_DR")
        #if not self.e2_t_DR_branch and "e2_t_DR" not in self.complained:
        if not self.e2_t_DR_branch and "e2_t_DR":
            warnings.warn( "EEETauTree: Expected branch e2_t_DR does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2_t_DR")
        else:
            self.e2_t_DR_branch.SetAddress(<void*>&self.e2_t_DR_value)

        #print "making e2_t_Eta"
        self.e2_t_Eta_branch = the_tree.GetBranch("e2_t_Eta")
        #if not self.e2_t_Eta_branch and "e2_t_Eta" not in self.complained:
        if not self.e2_t_Eta_branch and "e2_t_Eta":
            warnings.warn( "EEETauTree: Expected branch e2_t_Eta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2_t_Eta")
        else:
            self.e2_t_Eta_branch.SetAddress(<void*>&self.e2_t_Eta_value)

        #print "making e2_t_Mass"
        self.e2_t_Mass_branch = the_tree.GetBranch("e2_t_Mass")
        #if not self.e2_t_Mass_branch and "e2_t_Mass" not in self.complained:
        if not self.e2_t_Mass_branch and "e2_t_Mass":
            warnings.warn( "EEETauTree: Expected branch e2_t_Mass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2_t_Mass")
        else:
            self.e2_t_Mass_branch.SetAddress(<void*>&self.e2_t_Mass_value)

        #print "making e2_t_MassFsr"
        self.e2_t_MassFsr_branch = the_tree.GetBranch("e2_t_MassFsr")
        #if not self.e2_t_MassFsr_branch and "e2_t_MassFsr" not in self.complained:
        if not self.e2_t_MassFsr_branch and "e2_t_MassFsr":
            warnings.warn( "EEETauTree: Expected branch e2_t_MassFsr does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2_t_MassFsr")
        else:
            self.e2_t_MassFsr_branch.SetAddress(<void*>&self.e2_t_MassFsr_value)

        #print "making e2_t_PZeta"
        self.e2_t_PZeta_branch = the_tree.GetBranch("e2_t_PZeta")
        #if not self.e2_t_PZeta_branch and "e2_t_PZeta" not in self.complained:
        if not self.e2_t_PZeta_branch and "e2_t_PZeta":
            warnings.warn( "EEETauTree: Expected branch e2_t_PZeta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2_t_PZeta")
        else:
            self.e2_t_PZeta_branch.SetAddress(<void*>&self.e2_t_PZeta_value)

        #print "making e2_t_PZetaVis"
        self.e2_t_PZetaVis_branch = the_tree.GetBranch("e2_t_PZetaVis")
        #if not self.e2_t_PZetaVis_branch and "e2_t_PZetaVis" not in self.complained:
        if not self.e2_t_PZetaVis_branch and "e2_t_PZetaVis":
            warnings.warn( "EEETauTree: Expected branch e2_t_PZetaVis does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2_t_PZetaVis")
        else:
            self.e2_t_PZetaVis_branch.SetAddress(<void*>&self.e2_t_PZetaVis_value)

        #print "making e2_t_Phi"
        self.e2_t_Phi_branch = the_tree.GetBranch("e2_t_Phi")
        #if not self.e2_t_Phi_branch and "e2_t_Phi" not in self.complained:
        if not self.e2_t_Phi_branch and "e2_t_Phi":
            warnings.warn( "EEETauTree: Expected branch e2_t_Phi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2_t_Phi")
        else:
            self.e2_t_Phi_branch.SetAddress(<void*>&self.e2_t_Phi_value)

        #print "making e2_t_Pt"
        self.e2_t_Pt_branch = the_tree.GetBranch("e2_t_Pt")
        #if not self.e2_t_Pt_branch and "e2_t_Pt" not in self.complained:
        if not self.e2_t_Pt_branch and "e2_t_Pt":
            warnings.warn( "EEETauTree: Expected branch e2_t_Pt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2_t_Pt")
        else:
            self.e2_t_Pt_branch.SetAddress(<void*>&self.e2_t_Pt_value)

        #print "making e2_t_PtFsr"
        self.e2_t_PtFsr_branch = the_tree.GetBranch("e2_t_PtFsr")
        #if not self.e2_t_PtFsr_branch and "e2_t_PtFsr" not in self.complained:
        if not self.e2_t_PtFsr_branch and "e2_t_PtFsr":
            warnings.warn( "EEETauTree: Expected branch e2_t_PtFsr does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2_t_PtFsr")
        else:
            self.e2_t_PtFsr_branch.SetAddress(<void*>&self.e2_t_PtFsr_value)

        #print "making e2_t_SS"
        self.e2_t_SS_branch = the_tree.GetBranch("e2_t_SS")
        #if not self.e2_t_SS_branch and "e2_t_SS" not in self.complained:
        if not self.e2_t_SS_branch and "e2_t_SS":
            warnings.warn( "EEETauTree: Expected branch e2_t_SS does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2_t_SS")
        else:
            self.e2_t_SS_branch.SetAddress(<void*>&self.e2_t_SS_value)

        #print "making e2_t_ToMETDPhi_Ty1"
        self.e2_t_ToMETDPhi_Ty1_branch = the_tree.GetBranch("e2_t_ToMETDPhi_Ty1")
        #if not self.e2_t_ToMETDPhi_Ty1_branch and "e2_t_ToMETDPhi_Ty1" not in self.complained:
        if not self.e2_t_ToMETDPhi_Ty1_branch and "e2_t_ToMETDPhi_Ty1":
            warnings.warn( "EEETauTree: Expected branch e2_t_ToMETDPhi_Ty1 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2_t_ToMETDPhi_Ty1")
        else:
            self.e2_t_ToMETDPhi_Ty1_branch.SetAddress(<void*>&self.e2_t_ToMETDPhi_Ty1_value)

        #print "making e2_t_Zcompat"
        self.e2_t_Zcompat_branch = the_tree.GetBranch("e2_t_Zcompat")
        #if not self.e2_t_Zcompat_branch and "e2_t_Zcompat" not in self.complained:
        if not self.e2_t_Zcompat_branch and "e2_t_Zcompat":
            warnings.warn( "EEETauTree: Expected branch e2_t_Zcompat does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2_t_Zcompat")
        else:
            self.e2_t_Zcompat_branch.SetAddress(<void*>&self.e2_t_Zcompat_value)

        #print "making e2dECorrReg_2012Jul13ReReco"
        self.e2dECorrReg_2012Jul13ReReco_branch = the_tree.GetBranch("e2dECorrReg_2012Jul13ReReco")
        #if not self.e2dECorrReg_2012Jul13ReReco_branch and "e2dECorrReg_2012Jul13ReReco" not in self.complained:
        if not self.e2dECorrReg_2012Jul13ReReco_branch and "e2dECorrReg_2012Jul13ReReco":
            warnings.warn( "EEETauTree: Expected branch e2dECorrReg_2012Jul13ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2dECorrReg_2012Jul13ReReco")
        else:
            self.e2dECorrReg_2012Jul13ReReco_branch.SetAddress(<void*>&self.e2dECorrReg_2012Jul13ReReco_value)

        #print "making e2dECorrReg_Fall11"
        self.e2dECorrReg_Fall11_branch = the_tree.GetBranch("e2dECorrReg_Fall11")
        #if not self.e2dECorrReg_Fall11_branch and "e2dECorrReg_Fall11" not in self.complained:
        if not self.e2dECorrReg_Fall11_branch and "e2dECorrReg_Fall11":
            warnings.warn( "EEETauTree: Expected branch e2dECorrReg_Fall11 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2dECorrReg_Fall11")
        else:
            self.e2dECorrReg_Fall11_branch.SetAddress(<void*>&self.e2dECorrReg_Fall11_value)

        #print "making e2dECorrReg_Jan16ReReco"
        self.e2dECorrReg_Jan16ReReco_branch = the_tree.GetBranch("e2dECorrReg_Jan16ReReco")
        #if not self.e2dECorrReg_Jan16ReReco_branch and "e2dECorrReg_Jan16ReReco" not in self.complained:
        if not self.e2dECorrReg_Jan16ReReco_branch and "e2dECorrReg_Jan16ReReco":
            warnings.warn( "EEETauTree: Expected branch e2dECorrReg_Jan16ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2dECorrReg_Jan16ReReco")
        else:
            self.e2dECorrReg_Jan16ReReco_branch.SetAddress(<void*>&self.e2dECorrReg_Jan16ReReco_value)

        #print "making e2dECorrReg_Summer12_DR53X_HCP2012"
        self.e2dECorrReg_Summer12_DR53X_HCP2012_branch = the_tree.GetBranch("e2dECorrReg_Summer12_DR53X_HCP2012")
        #if not self.e2dECorrReg_Summer12_DR53X_HCP2012_branch and "e2dECorrReg_Summer12_DR53X_HCP2012" not in self.complained:
        if not self.e2dECorrReg_Summer12_DR53X_HCP2012_branch and "e2dECorrReg_Summer12_DR53X_HCP2012":
            warnings.warn( "EEETauTree: Expected branch e2dECorrReg_Summer12_DR53X_HCP2012 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2dECorrReg_Summer12_DR53X_HCP2012")
        else:
            self.e2dECorrReg_Summer12_DR53X_HCP2012_branch.SetAddress(<void*>&self.e2dECorrReg_Summer12_DR53X_HCP2012_value)

        #print "making e2dECorrSmearedNoReg_2012Jul13ReReco"
        self.e2dECorrSmearedNoReg_2012Jul13ReReco_branch = the_tree.GetBranch("e2dECorrSmearedNoReg_2012Jul13ReReco")
        #if not self.e2dECorrSmearedNoReg_2012Jul13ReReco_branch and "e2dECorrSmearedNoReg_2012Jul13ReReco" not in self.complained:
        if not self.e2dECorrSmearedNoReg_2012Jul13ReReco_branch and "e2dECorrSmearedNoReg_2012Jul13ReReco":
            warnings.warn( "EEETauTree: Expected branch e2dECorrSmearedNoReg_2012Jul13ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2dECorrSmearedNoReg_2012Jul13ReReco")
        else:
            self.e2dECorrSmearedNoReg_2012Jul13ReReco_branch.SetAddress(<void*>&self.e2dECorrSmearedNoReg_2012Jul13ReReco_value)

        #print "making e2dECorrSmearedNoReg_Fall11"
        self.e2dECorrSmearedNoReg_Fall11_branch = the_tree.GetBranch("e2dECorrSmearedNoReg_Fall11")
        #if not self.e2dECorrSmearedNoReg_Fall11_branch and "e2dECorrSmearedNoReg_Fall11" not in self.complained:
        if not self.e2dECorrSmearedNoReg_Fall11_branch and "e2dECorrSmearedNoReg_Fall11":
            warnings.warn( "EEETauTree: Expected branch e2dECorrSmearedNoReg_Fall11 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2dECorrSmearedNoReg_Fall11")
        else:
            self.e2dECorrSmearedNoReg_Fall11_branch.SetAddress(<void*>&self.e2dECorrSmearedNoReg_Fall11_value)

        #print "making e2dECorrSmearedNoReg_Jan16ReReco"
        self.e2dECorrSmearedNoReg_Jan16ReReco_branch = the_tree.GetBranch("e2dECorrSmearedNoReg_Jan16ReReco")
        #if not self.e2dECorrSmearedNoReg_Jan16ReReco_branch and "e2dECorrSmearedNoReg_Jan16ReReco" not in self.complained:
        if not self.e2dECorrSmearedNoReg_Jan16ReReco_branch and "e2dECorrSmearedNoReg_Jan16ReReco":
            warnings.warn( "EEETauTree: Expected branch e2dECorrSmearedNoReg_Jan16ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2dECorrSmearedNoReg_Jan16ReReco")
        else:
            self.e2dECorrSmearedNoReg_Jan16ReReco_branch.SetAddress(<void*>&self.e2dECorrSmearedNoReg_Jan16ReReco_value)

        #print "making e2dECorrSmearedNoReg_Summer12_DR53X_HCP2012"
        self.e2dECorrSmearedNoReg_Summer12_DR53X_HCP2012_branch = the_tree.GetBranch("e2dECorrSmearedNoReg_Summer12_DR53X_HCP2012")
        #if not self.e2dECorrSmearedNoReg_Summer12_DR53X_HCP2012_branch and "e2dECorrSmearedNoReg_Summer12_DR53X_HCP2012" not in self.complained:
        if not self.e2dECorrSmearedNoReg_Summer12_DR53X_HCP2012_branch and "e2dECorrSmearedNoReg_Summer12_DR53X_HCP2012":
            warnings.warn( "EEETauTree: Expected branch e2dECorrSmearedNoReg_Summer12_DR53X_HCP2012 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2dECorrSmearedNoReg_Summer12_DR53X_HCP2012")
        else:
            self.e2dECorrSmearedNoReg_Summer12_DR53X_HCP2012_branch.SetAddress(<void*>&self.e2dECorrSmearedNoReg_Summer12_DR53X_HCP2012_value)

        #print "making e2dECorrSmearedReg_2012Jul13ReReco"
        self.e2dECorrSmearedReg_2012Jul13ReReco_branch = the_tree.GetBranch("e2dECorrSmearedReg_2012Jul13ReReco")
        #if not self.e2dECorrSmearedReg_2012Jul13ReReco_branch and "e2dECorrSmearedReg_2012Jul13ReReco" not in self.complained:
        if not self.e2dECorrSmearedReg_2012Jul13ReReco_branch and "e2dECorrSmearedReg_2012Jul13ReReco":
            warnings.warn( "EEETauTree: Expected branch e2dECorrSmearedReg_2012Jul13ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2dECorrSmearedReg_2012Jul13ReReco")
        else:
            self.e2dECorrSmearedReg_2012Jul13ReReco_branch.SetAddress(<void*>&self.e2dECorrSmearedReg_2012Jul13ReReco_value)

        #print "making e2dECorrSmearedReg_Fall11"
        self.e2dECorrSmearedReg_Fall11_branch = the_tree.GetBranch("e2dECorrSmearedReg_Fall11")
        #if not self.e2dECorrSmearedReg_Fall11_branch and "e2dECorrSmearedReg_Fall11" not in self.complained:
        if not self.e2dECorrSmearedReg_Fall11_branch and "e2dECorrSmearedReg_Fall11":
            warnings.warn( "EEETauTree: Expected branch e2dECorrSmearedReg_Fall11 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2dECorrSmearedReg_Fall11")
        else:
            self.e2dECorrSmearedReg_Fall11_branch.SetAddress(<void*>&self.e2dECorrSmearedReg_Fall11_value)

        #print "making e2dECorrSmearedReg_Jan16ReReco"
        self.e2dECorrSmearedReg_Jan16ReReco_branch = the_tree.GetBranch("e2dECorrSmearedReg_Jan16ReReco")
        #if not self.e2dECorrSmearedReg_Jan16ReReco_branch and "e2dECorrSmearedReg_Jan16ReReco" not in self.complained:
        if not self.e2dECorrSmearedReg_Jan16ReReco_branch and "e2dECorrSmearedReg_Jan16ReReco":
            warnings.warn( "EEETauTree: Expected branch e2dECorrSmearedReg_Jan16ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2dECorrSmearedReg_Jan16ReReco")
        else:
            self.e2dECorrSmearedReg_Jan16ReReco_branch.SetAddress(<void*>&self.e2dECorrSmearedReg_Jan16ReReco_value)

        #print "making e2dECorrSmearedReg_Summer12_DR53X_HCP2012"
        self.e2dECorrSmearedReg_Summer12_DR53X_HCP2012_branch = the_tree.GetBranch("e2dECorrSmearedReg_Summer12_DR53X_HCP2012")
        #if not self.e2dECorrSmearedReg_Summer12_DR53X_HCP2012_branch and "e2dECorrSmearedReg_Summer12_DR53X_HCP2012" not in self.complained:
        if not self.e2dECorrSmearedReg_Summer12_DR53X_HCP2012_branch and "e2dECorrSmearedReg_Summer12_DR53X_HCP2012":
            warnings.warn( "EEETauTree: Expected branch e2dECorrSmearedReg_Summer12_DR53X_HCP2012 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2dECorrSmearedReg_Summer12_DR53X_HCP2012")
        else:
            self.e2dECorrSmearedReg_Summer12_DR53X_HCP2012_branch.SetAddress(<void*>&self.e2dECorrSmearedReg_Summer12_DR53X_HCP2012_value)

        #print "making e2deltaEtaSuperClusterTrackAtVtx"
        self.e2deltaEtaSuperClusterTrackAtVtx_branch = the_tree.GetBranch("e2deltaEtaSuperClusterTrackAtVtx")
        #if not self.e2deltaEtaSuperClusterTrackAtVtx_branch and "e2deltaEtaSuperClusterTrackAtVtx" not in self.complained:
        if not self.e2deltaEtaSuperClusterTrackAtVtx_branch and "e2deltaEtaSuperClusterTrackAtVtx":
            warnings.warn( "EEETauTree: Expected branch e2deltaEtaSuperClusterTrackAtVtx does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2deltaEtaSuperClusterTrackAtVtx")
        else:
            self.e2deltaEtaSuperClusterTrackAtVtx_branch.SetAddress(<void*>&self.e2deltaEtaSuperClusterTrackAtVtx_value)

        #print "making e2deltaPhiSuperClusterTrackAtVtx"
        self.e2deltaPhiSuperClusterTrackAtVtx_branch = the_tree.GetBranch("e2deltaPhiSuperClusterTrackAtVtx")
        #if not self.e2deltaPhiSuperClusterTrackAtVtx_branch and "e2deltaPhiSuperClusterTrackAtVtx" not in self.complained:
        if not self.e2deltaPhiSuperClusterTrackAtVtx_branch and "e2deltaPhiSuperClusterTrackAtVtx":
            warnings.warn( "EEETauTree: Expected branch e2deltaPhiSuperClusterTrackAtVtx does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2deltaPhiSuperClusterTrackAtVtx")
        else:
            self.e2deltaPhiSuperClusterTrackAtVtx_branch.SetAddress(<void*>&self.e2deltaPhiSuperClusterTrackAtVtx_value)

        #print "making e2eSuperClusterOverP"
        self.e2eSuperClusterOverP_branch = the_tree.GetBranch("e2eSuperClusterOverP")
        #if not self.e2eSuperClusterOverP_branch and "e2eSuperClusterOverP" not in self.complained:
        if not self.e2eSuperClusterOverP_branch and "e2eSuperClusterOverP":
            warnings.warn( "EEETauTree: Expected branch e2eSuperClusterOverP does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2eSuperClusterOverP")
        else:
            self.e2eSuperClusterOverP_branch.SetAddress(<void*>&self.e2eSuperClusterOverP_value)

        #print "making e2ecalEnergy"
        self.e2ecalEnergy_branch = the_tree.GetBranch("e2ecalEnergy")
        #if not self.e2ecalEnergy_branch and "e2ecalEnergy" not in self.complained:
        if not self.e2ecalEnergy_branch and "e2ecalEnergy":
            warnings.warn( "EEETauTree: Expected branch e2ecalEnergy does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2ecalEnergy")
        else:
            self.e2ecalEnergy_branch.SetAddress(<void*>&self.e2ecalEnergy_value)

        #print "making e2fBrem"
        self.e2fBrem_branch = the_tree.GetBranch("e2fBrem")
        #if not self.e2fBrem_branch and "e2fBrem" not in self.complained:
        if not self.e2fBrem_branch and "e2fBrem":
            warnings.warn( "EEETauTree: Expected branch e2fBrem does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2fBrem")
        else:
            self.e2fBrem_branch.SetAddress(<void*>&self.e2fBrem_value)

        #print "making e2trackMomentumAtVtxP"
        self.e2trackMomentumAtVtxP_branch = the_tree.GetBranch("e2trackMomentumAtVtxP")
        #if not self.e2trackMomentumAtVtxP_branch and "e2trackMomentumAtVtxP" not in self.complained:
        if not self.e2trackMomentumAtVtxP_branch and "e2trackMomentumAtVtxP":
            warnings.warn( "EEETauTree: Expected branch e2trackMomentumAtVtxP does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2trackMomentumAtVtxP")
        else:
            self.e2trackMomentumAtVtxP_branch.SetAddress(<void*>&self.e2trackMomentumAtVtxP_value)

        #print "making e3AbsEta"
        self.e3AbsEta_branch = the_tree.GetBranch("e3AbsEta")
        #if not self.e3AbsEta_branch and "e3AbsEta" not in self.complained:
        if not self.e3AbsEta_branch and "e3AbsEta":
            warnings.warn( "EEETauTree: Expected branch e3AbsEta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3AbsEta")
        else:
            self.e3AbsEta_branch.SetAddress(<void*>&self.e3AbsEta_value)

        #print "making e3CBID_LOOSE"
        self.e3CBID_LOOSE_branch = the_tree.GetBranch("e3CBID_LOOSE")
        #if not self.e3CBID_LOOSE_branch and "e3CBID_LOOSE" not in self.complained:
        if not self.e3CBID_LOOSE_branch and "e3CBID_LOOSE":
            warnings.warn( "EEETauTree: Expected branch e3CBID_LOOSE does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3CBID_LOOSE")
        else:
            self.e3CBID_LOOSE_branch.SetAddress(<void*>&self.e3CBID_LOOSE_value)

        #print "making e3CBID_MEDIUM"
        self.e3CBID_MEDIUM_branch = the_tree.GetBranch("e3CBID_MEDIUM")
        #if not self.e3CBID_MEDIUM_branch and "e3CBID_MEDIUM" not in self.complained:
        if not self.e3CBID_MEDIUM_branch and "e3CBID_MEDIUM":
            warnings.warn( "EEETauTree: Expected branch e3CBID_MEDIUM does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3CBID_MEDIUM")
        else:
            self.e3CBID_MEDIUM_branch.SetAddress(<void*>&self.e3CBID_MEDIUM_value)

        #print "making e3CBID_TIGHT"
        self.e3CBID_TIGHT_branch = the_tree.GetBranch("e3CBID_TIGHT")
        #if not self.e3CBID_TIGHT_branch and "e3CBID_TIGHT" not in self.complained:
        if not self.e3CBID_TIGHT_branch and "e3CBID_TIGHT":
            warnings.warn( "EEETauTree: Expected branch e3CBID_TIGHT does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3CBID_TIGHT")
        else:
            self.e3CBID_TIGHT_branch.SetAddress(<void*>&self.e3CBID_TIGHT_value)

        #print "making e3CBID_VETO"
        self.e3CBID_VETO_branch = the_tree.GetBranch("e3CBID_VETO")
        #if not self.e3CBID_VETO_branch and "e3CBID_VETO" not in self.complained:
        if not self.e3CBID_VETO_branch and "e3CBID_VETO":
            warnings.warn( "EEETauTree: Expected branch e3CBID_VETO does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3CBID_VETO")
        else:
            self.e3CBID_VETO_branch.SetAddress(<void*>&self.e3CBID_VETO_value)

        #print "making e3Charge"
        self.e3Charge_branch = the_tree.GetBranch("e3Charge")
        #if not self.e3Charge_branch and "e3Charge" not in self.complained:
        if not self.e3Charge_branch and "e3Charge":
            warnings.warn( "EEETauTree: Expected branch e3Charge does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3Charge")
        else:
            self.e3Charge_branch.SetAddress(<void*>&self.e3Charge_value)

        #print "making e3ChargeIdLoose"
        self.e3ChargeIdLoose_branch = the_tree.GetBranch("e3ChargeIdLoose")
        #if not self.e3ChargeIdLoose_branch and "e3ChargeIdLoose" not in self.complained:
        if not self.e3ChargeIdLoose_branch and "e3ChargeIdLoose":
            warnings.warn( "EEETauTree: Expected branch e3ChargeIdLoose does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3ChargeIdLoose")
        else:
            self.e3ChargeIdLoose_branch.SetAddress(<void*>&self.e3ChargeIdLoose_value)

        #print "making e3ChargeIdMed"
        self.e3ChargeIdMed_branch = the_tree.GetBranch("e3ChargeIdMed")
        #if not self.e3ChargeIdMed_branch and "e3ChargeIdMed" not in self.complained:
        if not self.e3ChargeIdMed_branch and "e3ChargeIdMed":
            warnings.warn( "EEETauTree: Expected branch e3ChargeIdMed does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3ChargeIdMed")
        else:
            self.e3ChargeIdMed_branch.SetAddress(<void*>&self.e3ChargeIdMed_value)

        #print "making e3ChargeIdTight"
        self.e3ChargeIdTight_branch = the_tree.GetBranch("e3ChargeIdTight")
        #if not self.e3ChargeIdTight_branch and "e3ChargeIdTight" not in self.complained:
        if not self.e3ChargeIdTight_branch and "e3ChargeIdTight":
            warnings.warn( "EEETauTree: Expected branch e3ChargeIdTight does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3ChargeIdTight")
        else:
            self.e3ChargeIdTight_branch.SetAddress(<void*>&self.e3ChargeIdTight_value)

        #print "making e3CiCTight"
        self.e3CiCTight_branch = the_tree.GetBranch("e3CiCTight")
        #if not self.e3CiCTight_branch and "e3CiCTight" not in self.complained:
        if not self.e3CiCTight_branch and "e3CiCTight":
            warnings.warn( "EEETauTree: Expected branch e3CiCTight does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3CiCTight")
        else:
            self.e3CiCTight_branch.SetAddress(<void*>&self.e3CiCTight_value)

        #print "making e3CiCTightElecOverlap"
        self.e3CiCTightElecOverlap_branch = the_tree.GetBranch("e3CiCTightElecOverlap")
        #if not self.e3CiCTightElecOverlap_branch and "e3CiCTightElecOverlap" not in self.complained:
        if not self.e3CiCTightElecOverlap_branch and "e3CiCTightElecOverlap":
            warnings.warn( "EEETauTree: Expected branch e3CiCTightElecOverlap does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3CiCTightElecOverlap")
        else:
            self.e3CiCTightElecOverlap_branch.SetAddress(<void*>&self.e3CiCTightElecOverlap_value)

        #print "making e3ComesFromHiggs"
        self.e3ComesFromHiggs_branch = the_tree.GetBranch("e3ComesFromHiggs")
        #if not self.e3ComesFromHiggs_branch and "e3ComesFromHiggs" not in self.complained:
        if not self.e3ComesFromHiggs_branch and "e3ComesFromHiggs":
            warnings.warn( "EEETauTree: Expected branch e3ComesFromHiggs does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3ComesFromHiggs")
        else:
            self.e3ComesFromHiggs_branch.SetAddress(<void*>&self.e3ComesFromHiggs_value)

        #print "making e3DZ"
        self.e3DZ_branch = the_tree.GetBranch("e3DZ")
        #if not self.e3DZ_branch and "e3DZ" not in self.complained:
        if not self.e3DZ_branch and "e3DZ":
            warnings.warn( "EEETauTree: Expected branch e3DZ does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3DZ")
        else:
            self.e3DZ_branch.SetAddress(<void*>&self.e3DZ_value)

        #print "making e3E1x5"
        self.e3E1x5_branch = the_tree.GetBranch("e3E1x5")
        #if not self.e3E1x5_branch and "e3E1x5" not in self.complained:
        if not self.e3E1x5_branch and "e3E1x5":
            warnings.warn( "EEETauTree: Expected branch e3E1x5 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3E1x5")
        else:
            self.e3E1x5_branch.SetAddress(<void*>&self.e3E1x5_value)

        #print "making e3E2x5Max"
        self.e3E2x5Max_branch = the_tree.GetBranch("e3E2x5Max")
        #if not self.e3E2x5Max_branch and "e3E2x5Max" not in self.complained:
        if not self.e3E2x5Max_branch and "e3E2x5Max":
            warnings.warn( "EEETauTree: Expected branch e3E2x5Max does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3E2x5Max")
        else:
            self.e3E2x5Max_branch.SetAddress(<void*>&self.e3E2x5Max_value)

        #print "making e3E5x5"
        self.e3E5x5_branch = the_tree.GetBranch("e3E5x5")
        #if not self.e3E5x5_branch and "e3E5x5" not in self.complained:
        if not self.e3E5x5_branch and "e3E5x5":
            warnings.warn( "EEETauTree: Expected branch e3E5x5 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3E5x5")
        else:
            self.e3E5x5_branch.SetAddress(<void*>&self.e3E5x5_value)

        #print "making e3ECorrReg_2012Jul13ReReco"
        self.e3ECorrReg_2012Jul13ReReco_branch = the_tree.GetBranch("e3ECorrReg_2012Jul13ReReco")
        #if not self.e3ECorrReg_2012Jul13ReReco_branch and "e3ECorrReg_2012Jul13ReReco" not in self.complained:
        if not self.e3ECorrReg_2012Jul13ReReco_branch and "e3ECorrReg_2012Jul13ReReco":
            warnings.warn( "EEETauTree: Expected branch e3ECorrReg_2012Jul13ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3ECorrReg_2012Jul13ReReco")
        else:
            self.e3ECorrReg_2012Jul13ReReco_branch.SetAddress(<void*>&self.e3ECorrReg_2012Jul13ReReco_value)

        #print "making e3ECorrReg_Fall11"
        self.e3ECorrReg_Fall11_branch = the_tree.GetBranch("e3ECorrReg_Fall11")
        #if not self.e3ECorrReg_Fall11_branch and "e3ECorrReg_Fall11" not in self.complained:
        if not self.e3ECorrReg_Fall11_branch and "e3ECorrReg_Fall11":
            warnings.warn( "EEETauTree: Expected branch e3ECorrReg_Fall11 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3ECorrReg_Fall11")
        else:
            self.e3ECorrReg_Fall11_branch.SetAddress(<void*>&self.e3ECorrReg_Fall11_value)

        #print "making e3ECorrReg_Jan16ReReco"
        self.e3ECorrReg_Jan16ReReco_branch = the_tree.GetBranch("e3ECorrReg_Jan16ReReco")
        #if not self.e3ECorrReg_Jan16ReReco_branch and "e3ECorrReg_Jan16ReReco" not in self.complained:
        if not self.e3ECorrReg_Jan16ReReco_branch and "e3ECorrReg_Jan16ReReco":
            warnings.warn( "EEETauTree: Expected branch e3ECorrReg_Jan16ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3ECorrReg_Jan16ReReco")
        else:
            self.e3ECorrReg_Jan16ReReco_branch.SetAddress(<void*>&self.e3ECorrReg_Jan16ReReco_value)

        #print "making e3ECorrReg_Summer12_DR53X_HCP2012"
        self.e3ECorrReg_Summer12_DR53X_HCP2012_branch = the_tree.GetBranch("e3ECorrReg_Summer12_DR53X_HCP2012")
        #if not self.e3ECorrReg_Summer12_DR53X_HCP2012_branch and "e3ECorrReg_Summer12_DR53X_HCP2012" not in self.complained:
        if not self.e3ECorrReg_Summer12_DR53X_HCP2012_branch and "e3ECorrReg_Summer12_DR53X_HCP2012":
            warnings.warn( "EEETauTree: Expected branch e3ECorrReg_Summer12_DR53X_HCP2012 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3ECorrReg_Summer12_DR53X_HCP2012")
        else:
            self.e3ECorrReg_Summer12_DR53X_HCP2012_branch.SetAddress(<void*>&self.e3ECorrReg_Summer12_DR53X_HCP2012_value)

        #print "making e3ECorrSmearedNoReg_2012Jul13ReReco"
        self.e3ECorrSmearedNoReg_2012Jul13ReReco_branch = the_tree.GetBranch("e3ECorrSmearedNoReg_2012Jul13ReReco")
        #if not self.e3ECorrSmearedNoReg_2012Jul13ReReco_branch and "e3ECorrSmearedNoReg_2012Jul13ReReco" not in self.complained:
        if not self.e3ECorrSmearedNoReg_2012Jul13ReReco_branch and "e3ECorrSmearedNoReg_2012Jul13ReReco":
            warnings.warn( "EEETauTree: Expected branch e3ECorrSmearedNoReg_2012Jul13ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3ECorrSmearedNoReg_2012Jul13ReReco")
        else:
            self.e3ECorrSmearedNoReg_2012Jul13ReReco_branch.SetAddress(<void*>&self.e3ECorrSmearedNoReg_2012Jul13ReReco_value)

        #print "making e3ECorrSmearedNoReg_Fall11"
        self.e3ECorrSmearedNoReg_Fall11_branch = the_tree.GetBranch("e3ECorrSmearedNoReg_Fall11")
        #if not self.e3ECorrSmearedNoReg_Fall11_branch and "e3ECorrSmearedNoReg_Fall11" not in self.complained:
        if not self.e3ECorrSmearedNoReg_Fall11_branch and "e3ECorrSmearedNoReg_Fall11":
            warnings.warn( "EEETauTree: Expected branch e3ECorrSmearedNoReg_Fall11 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3ECorrSmearedNoReg_Fall11")
        else:
            self.e3ECorrSmearedNoReg_Fall11_branch.SetAddress(<void*>&self.e3ECorrSmearedNoReg_Fall11_value)

        #print "making e3ECorrSmearedNoReg_Jan16ReReco"
        self.e3ECorrSmearedNoReg_Jan16ReReco_branch = the_tree.GetBranch("e3ECorrSmearedNoReg_Jan16ReReco")
        #if not self.e3ECorrSmearedNoReg_Jan16ReReco_branch and "e3ECorrSmearedNoReg_Jan16ReReco" not in self.complained:
        if not self.e3ECorrSmearedNoReg_Jan16ReReco_branch and "e3ECorrSmearedNoReg_Jan16ReReco":
            warnings.warn( "EEETauTree: Expected branch e3ECorrSmearedNoReg_Jan16ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3ECorrSmearedNoReg_Jan16ReReco")
        else:
            self.e3ECorrSmearedNoReg_Jan16ReReco_branch.SetAddress(<void*>&self.e3ECorrSmearedNoReg_Jan16ReReco_value)

        #print "making e3ECorrSmearedNoReg_Summer12_DR53X_HCP2012"
        self.e3ECorrSmearedNoReg_Summer12_DR53X_HCP2012_branch = the_tree.GetBranch("e3ECorrSmearedNoReg_Summer12_DR53X_HCP2012")
        #if not self.e3ECorrSmearedNoReg_Summer12_DR53X_HCP2012_branch and "e3ECorrSmearedNoReg_Summer12_DR53X_HCP2012" not in self.complained:
        if not self.e3ECorrSmearedNoReg_Summer12_DR53X_HCP2012_branch and "e3ECorrSmearedNoReg_Summer12_DR53X_HCP2012":
            warnings.warn( "EEETauTree: Expected branch e3ECorrSmearedNoReg_Summer12_DR53X_HCP2012 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3ECorrSmearedNoReg_Summer12_DR53X_HCP2012")
        else:
            self.e3ECorrSmearedNoReg_Summer12_DR53X_HCP2012_branch.SetAddress(<void*>&self.e3ECorrSmearedNoReg_Summer12_DR53X_HCP2012_value)

        #print "making e3ECorrSmearedReg_2012Jul13ReReco"
        self.e3ECorrSmearedReg_2012Jul13ReReco_branch = the_tree.GetBranch("e3ECorrSmearedReg_2012Jul13ReReco")
        #if not self.e3ECorrSmearedReg_2012Jul13ReReco_branch and "e3ECorrSmearedReg_2012Jul13ReReco" not in self.complained:
        if not self.e3ECorrSmearedReg_2012Jul13ReReco_branch and "e3ECorrSmearedReg_2012Jul13ReReco":
            warnings.warn( "EEETauTree: Expected branch e3ECorrSmearedReg_2012Jul13ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3ECorrSmearedReg_2012Jul13ReReco")
        else:
            self.e3ECorrSmearedReg_2012Jul13ReReco_branch.SetAddress(<void*>&self.e3ECorrSmearedReg_2012Jul13ReReco_value)

        #print "making e3ECorrSmearedReg_Fall11"
        self.e3ECorrSmearedReg_Fall11_branch = the_tree.GetBranch("e3ECorrSmearedReg_Fall11")
        #if not self.e3ECorrSmearedReg_Fall11_branch and "e3ECorrSmearedReg_Fall11" not in self.complained:
        if not self.e3ECorrSmearedReg_Fall11_branch and "e3ECorrSmearedReg_Fall11":
            warnings.warn( "EEETauTree: Expected branch e3ECorrSmearedReg_Fall11 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3ECorrSmearedReg_Fall11")
        else:
            self.e3ECorrSmearedReg_Fall11_branch.SetAddress(<void*>&self.e3ECorrSmearedReg_Fall11_value)

        #print "making e3ECorrSmearedReg_Jan16ReReco"
        self.e3ECorrSmearedReg_Jan16ReReco_branch = the_tree.GetBranch("e3ECorrSmearedReg_Jan16ReReco")
        #if not self.e3ECorrSmearedReg_Jan16ReReco_branch and "e3ECorrSmearedReg_Jan16ReReco" not in self.complained:
        if not self.e3ECorrSmearedReg_Jan16ReReco_branch and "e3ECorrSmearedReg_Jan16ReReco":
            warnings.warn( "EEETauTree: Expected branch e3ECorrSmearedReg_Jan16ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3ECorrSmearedReg_Jan16ReReco")
        else:
            self.e3ECorrSmearedReg_Jan16ReReco_branch.SetAddress(<void*>&self.e3ECorrSmearedReg_Jan16ReReco_value)

        #print "making e3ECorrSmearedReg_Summer12_DR53X_HCP2012"
        self.e3ECorrSmearedReg_Summer12_DR53X_HCP2012_branch = the_tree.GetBranch("e3ECorrSmearedReg_Summer12_DR53X_HCP2012")
        #if not self.e3ECorrSmearedReg_Summer12_DR53X_HCP2012_branch and "e3ECorrSmearedReg_Summer12_DR53X_HCP2012" not in self.complained:
        if not self.e3ECorrSmearedReg_Summer12_DR53X_HCP2012_branch and "e3ECorrSmearedReg_Summer12_DR53X_HCP2012":
            warnings.warn( "EEETauTree: Expected branch e3ECorrSmearedReg_Summer12_DR53X_HCP2012 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3ECorrSmearedReg_Summer12_DR53X_HCP2012")
        else:
            self.e3ECorrSmearedReg_Summer12_DR53X_HCP2012_branch.SetAddress(<void*>&self.e3ECorrSmearedReg_Summer12_DR53X_HCP2012_value)

        #print "making e3EcalIsoDR03"
        self.e3EcalIsoDR03_branch = the_tree.GetBranch("e3EcalIsoDR03")
        #if not self.e3EcalIsoDR03_branch and "e3EcalIsoDR03" not in self.complained:
        if not self.e3EcalIsoDR03_branch and "e3EcalIsoDR03":
            warnings.warn( "EEETauTree: Expected branch e3EcalIsoDR03 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3EcalIsoDR03")
        else:
            self.e3EcalIsoDR03_branch.SetAddress(<void*>&self.e3EcalIsoDR03_value)

        #print "making e3EffectiveArea2011Data"
        self.e3EffectiveArea2011Data_branch = the_tree.GetBranch("e3EffectiveArea2011Data")
        #if not self.e3EffectiveArea2011Data_branch and "e3EffectiveArea2011Data" not in self.complained:
        if not self.e3EffectiveArea2011Data_branch and "e3EffectiveArea2011Data":
            warnings.warn( "EEETauTree: Expected branch e3EffectiveArea2011Data does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3EffectiveArea2011Data")
        else:
            self.e3EffectiveArea2011Data_branch.SetAddress(<void*>&self.e3EffectiveArea2011Data_value)

        #print "making e3EffectiveArea2012Data"
        self.e3EffectiveArea2012Data_branch = the_tree.GetBranch("e3EffectiveArea2012Data")
        #if not self.e3EffectiveArea2012Data_branch and "e3EffectiveArea2012Data" not in self.complained:
        if not self.e3EffectiveArea2012Data_branch and "e3EffectiveArea2012Data":
            warnings.warn( "EEETauTree: Expected branch e3EffectiveArea2012Data does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3EffectiveArea2012Data")
        else:
            self.e3EffectiveArea2012Data_branch.SetAddress(<void*>&self.e3EffectiveArea2012Data_value)

        #print "making e3EffectiveAreaFall11MC"
        self.e3EffectiveAreaFall11MC_branch = the_tree.GetBranch("e3EffectiveAreaFall11MC")
        #if not self.e3EffectiveAreaFall11MC_branch and "e3EffectiveAreaFall11MC" not in self.complained:
        if not self.e3EffectiveAreaFall11MC_branch and "e3EffectiveAreaFall11MC":
            warnings.warn( "EEETauTree: Expected branch e3EffectiveAreaFall11MC does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3EffectiveAreaFall11MC")
        else:
            self.e3EffectiveAreaFall11MC_branch.SetAddress(<void*>&self.e3EffectiveAreaFall11MC_value)

        #print "making e3Ele27WP80PFMT50PFMTFilter"
        self.e3Ele27WP80PFMT50PFMTFilter_branch = the_tree.GetBranch("e3Ele27WP80PFMT50PFMTFilter")
        #if not self.e3Ele27WP80PFMT50PFMTFilter_branch and "e3Ele27WP80PFMT50PFMTFilter" not in self.complained:
        if not self.e3Ele27WP80PFMT50PFMTFilter_branch and "e3Ele27WP80PFMT50PFMTFilter":
            warnings.warn( "EEETauTree: Expected branch e3Ele27WP80PFMT50PFMTFilter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3Ele27WP80PFMT50PFMTFilter")
        else:
            self.e3Ele27WP80PFMT50PFMTFilter_branch.SetAddress(<void*>&self.e3Ele27WP80PFMT50PFMTFilter_value)

        #print "making e3Ele27WP80TrackIsoMatchFilter"
        self.e3Ele27WP80TrackIsoMatchFilter_branch = the_tree.GetBranch("e3Ele27WP80TrackIsoMatchFilter")
        #if not self.e3Ele27WP80TrackIsoMatchFilter_branch and "e3Ele27WP80TrackIsoMatchFilter" not in self.complained:
        if not self.e3Ele27WP80TrackIsoMatchFilter_branch and "e3Ele27WP80TrackIsoMatchFilter":
            warnings.warn( "EEETauTree: Expected branch e3Ele27WP80TrackIsoMatchFilter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3Ele27WP80TrackIsoMatchFilter")
        else:
            self.e3Ele27WP80TrackIsoMatchFilter_branch.SetAddress(<void*>&self.e3Ele27WP80TrackIsoMatchFilter_value)

        #print "making e3Ele32WP70PFMT50PFMTFilter"
        self.e3Ele32WP70PFMT50PFMTFilter_branch = the_tree.GetBranch("e3Ele32WP70PFMT50PFMTFilter")
        #if not self.e3Ele32WP70PFMT50PFMTFilter_branch and "e3Ele32WP70PFMT50PFMTFilter" not in self.complained:
        if not self.e3Ele32WP70PFMT50PFMTFilter_branch and "e3Ele32WP70PFMT50PFMTFilter":
            warnings.warn( "EEETauTree: Expected branch e3Ele32WP70PFMT50PFMTFilter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3Ele32WP70PFMT50PFMTFilter")
        else:
            self.e3Ele32WP70PFMT50PFMTFilter_branch.SetAddress(<void*>&self.e3Ele32WP70PFMT50PFMTFilter_value)

        #print "making e3ElecOverlap"
        self.e3ElecOverlap_branch = the_tree.GetBranch("e3ElecOverlap")
        #if not self.e3ElecOverlap_branch and "e3ElecOverlap" not in self.complained:
        if not self.e3ElecOverlap_branch and "e3ElecOverlap":
            warnings.warn( "EEETauTree: Expected branch e3ElecOverlap does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3ElecOverlap")
        else:
            self.e3ElecOverlap_branch.SetAddress(<void*>&self.e3ElecOverlap_value)

        #print "making e3ElecOverlapZHLoose"
        self.e3ElecOverlapZHLoose_branch = the_tree.GetBranch("e3ElecOverlapZHLoose")
        #if not self.e3ElecOverlapZHLoose_branch and "e3ElecOverlapZHLoose" not in self.complained:
        if not self.e3ElecOverlapZHLoose_branch and "e3ElecOverlapZHLoose":
            warnings.warn( "EEETauTree: Expected branch e3ElecOverlapZHLoose does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3ElecOverlapZHLoose")
        else:
            self.e3ElecOverlapZHLoose_branch.SetAddress(<void*>&self.e3ElecOverlapZHLoose_value)

        #print "making e3ElecOverlapZHTight"
        self.e3ElecOverlapZHTight_branch = the_tree.GetBranch("e3ElecOverlapZHTight")
        #if not self.e3ElecOverlapZHTight_branch and "e3ElecOverlapZHTight" not in self.complained:
        if not self.e3ElecOverlapZHTight_branch and "e3ElecOverlapZHTight":
            warnings.warn( "EEETauTree: Expected branch e3ElecOverlapZHTight does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3ElecOverlapZHTight")
        else:
            self.e3ElecOverlapZHTight_branch.SetAddress(<void*>&self.e3ElecOverlapZHTight_value)

        #print "making e3EnergyError"
        self.e3EnergyError_branch = the_tree.GetBranch("e3EnergyError")
        #if not self.e3EnergyError_branch and "e3EnergyError" not in self.complained:
        if not self.e3EnergyError_branch and "e3EnergyError":
            warnings.warn( "EEETauTree: Expected branch e3EnergyError does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3EnergyError")
        else:
            self.e3EnergyError_branch.SetAddress(<void*>&self.e3EnergyError_value)

        #print "making e3Eta"
        self.e3Eta_branch = the_tree.GetBranch("e3Eta")
        #if not self.e3Eta_branch and "e3Eta" not in self.complained:
        if not self.e3Eta_branch and "e3Eta":
            warnings.warn( "EEETauTree: Expected branch e3Eta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3Eta")
        else:
            self.e3Eta_branch.SetAddress(<void*>&self.e3Eta_value)

        #print "making e3EtaCorrReg_2012Jul13ReReco"
        self.e3EtaCorrReg_2012Jul13ReReco_branch = the_tree.GetBranch("e3EtaCorrReg_2012Jul13ReReco")
        #if not self.e3EtaCorrReg_2012Jul13ReReco_branch and "e3EtaCorrReg_2012Jul13ReReco" not in self.complained:
        if not self.e3EtaCorrReg_2012Jul13ReReco_branch and "e3EtaCorrReg_2012Jul13ReReco":
            warnings.warn( "EEETauTree: Expected branch e3EtaCorrReg_2012Jul13ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3EtaCorrReg_2012Jul13ReReco")
        else:
            self.e3EtaCorrReg_2012Jul13ReReco_branch.SetAddress(<void*>&self.e3EtaCorrReg_2012Jul13ReReco_value)

        #print "making e3EtaCorrReg_Fall11"
        self.e3EtaCorrReg_Fall11_branch = the_tree.GetBranch("e3EtaCorrReg_Fall11")
        #if not self.e3EtaCorrReg_Fall11_branch and "e3EtaCorrReg_Fall11" not in self.complained:
        if not self.e3EtaCorrReg_Fall11_branch and "e3EtaCorrReg_Fall11":
            warnings.warn( "EEETauTree: Expected branch e3EtaCorrReg_Fall11 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3EtaCorrReg_Fall11")
        else:
            self.e3EtaCorrReg_Fall11_branch.SetAddress(<void*>&self.e3EtaCorrReg_Fall11_value)

        #print "making e3EtaCorrReg_Jan16ReReco"
        self.e3EtaCorrReg_Jan16ReReco_branch = the_tree.GetBranch("e3EtaCorrReg_Jan16ReReco")
        #if not self.e3EtaCorrReg_Jan16ReReco_branch and "e3EtaCorrReg_Jan16ReReco" not in self.complained:
        if not self.e3EtaCorrReg_Jan16ReReco_branch and "e3EtaCorrReg_Jan16ReReco":
            warnings.warn( "EEETauTree: Expected branch e3EtaCorrReg_Jan16ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3EtaCorrReg_Jan16ReReco")
        else:
            self.e3EtaCorrReg_Jan16ReReco_branch.SetAddress(<void*>&self.e3EtaCorrReg_Jan16ReReco_value)

        #print "making e3EtaCorrReg_Summer12_DR53X_HCP2012"
        self.e3EtaCorrReg_Summer12_DR53X_HCP2012_branch = the_tree.GetBranch("e3EtaCorrReg_Summer12_DR53X_HCP2012")
        #if not self.e3EtaCorrReg_Summer12_DR53X_HCP2012_branch and "e3EtaCorrReg_Summer12_DR53X_HCP2012" not in self.complained:
        if not self.e3EtaCorrReg_Summer12_DR53X_HCP2012_branch and "e3EtaCorrReg_Summer12_DR53X_HCP2012":
            warnings.warn( "EEETauTree: Expected branch e3EtaCorrReg_Summer12_DR53X_HCP2012 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3EtaCorrReg_Summer12_DR53X_HCP2012")
        else:
            self.e3EtaCorrReg_Summer12_DR53X_HCP2012_branch.SetAddress(<void*>&self.e3EtaCorrReg_Summer12_DR53X_HCP2012_value)

        #print "making e3EtaCorrSmearedNoReg_2012Jul13ReReco"
        self.e3EtaCorrSmearedNoReg_2012Jul13ReReco_branch = the_tree.GetBranch("e3EtaCorrSmearedNoReg_2012Jul13ReReco")
        #if not self.e3EtaCorrSmearedNoReg_2012Jul13ReReco_branch and "e3EtaCorrSmearedNoReg_2012Jul13ReReco" not in self.complained:
        if not self.e3EtaCorrSmearedNoReg_2012Jul13ReReco_branch and "e3EtaCorrSmearedNoReg_2012Jul13ReReco":
            warnings.warn( "EEETauTree: Expected branch e3EtaCorrSmearedNoReg_2012Jul13ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3EtaCorrSmearedNoReg_2012Jul13ReReco")
        else:
            self.e3EtaCorrSmearedNoReg_2012Jul13ReReco_branch.SetAddress(<void*>&self.e3EtaCorrSmearedNoReg_2012Jul13ReReco_value)

        #print "making e3EtaCorrSmearedNoReg_Fall11"
        self.e3EtaCorrSmearedNoReg_Fall11_branch = the_tree.GetBranch("e3EtaCorrSmearedNoReg_Fall11")
        #if not self.e3EtaCorrSmearedNoReg_Fall11_branch and "e3EtaCorrSmearedNoReg_Fall11" not in self.complained:
        if not self.e3EtaCorrSmearedNoReg_Fall11_branch and "e3EtaCorrSmearedNoReg_Fall11":
            warnings.warn( "EEETauTree: Expected branch e3EtaCorrSmearedNoReg_Fall11 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3EtaCorrSmearedNoReg_Fall11")
        else:
            self.e3EtaCorrSmearedNoReg_Fall11_branch.SetAddress(<void*>&self.e3EtaCorrSmearedNoReg_Fall11_value)

        #print "making e3EtaCorrSmearedNoReg_Jan16ReReco"
        self.e3EtaCorrSmearedNoReg_Jan16ReReco_branch = the_tree.GetBranch("e3EtaCorrSmearedNoReg_Jan16ReReco")
        #if not self.e3EtaCorrSmearedNoReg_Jan16ReReco_branch and "e3EtaCorrSmearedNoReg_Jan16ReReco" not in self.complained:
        if not self.e3EtaCorrSmearedNoReg_Jan16ReReco_branch and "e3EtaCorrSmearedNoReg_Jan16ReReco":
            warnings.warn( "EEETauTree: Expected branch e3EtaCorrSmearedNoReg_Jan16ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3EtaCorrSmearedNoReg_Jan16ReReco")
        else:
            self.e3EtaCorrSmearedNoReg_Jan16ReReco_branch.SetAddress(<void*>&self.e3EtaCorrSmearedNoReg_Jan16ReReco_value)

        #print "making e3EtaCorrSmearedNoReg_Summer12_DR53X_HCP2012"
        self.e3EtaCorrSmearedNoReg_Summer12_DR53X_HCP2012_branch = the_tree.GetBranch("e3EtaCorrSmearedNoReg_Summer12_DR53X_HCP2012")
        #if not self.e3EtaCorrSmearedNoReg_Summer12_DR53X_HCP2012_branch and "e3EtaCorrSmearedNoReg_Summer12_DR53X_HCP2012" not in self.complained:
        if not self.e3EtaCorrSmearedNoReg_Summer12_DR53X_HCP2012_branch and "e3EtaCorrSmearedNoReg_Summer12_DR53X_HCP2012":
            warnings.warn( "EEETauTree: Expected branch e3EtaCorrSmearedNoReg_Summer12_DR53X_HCP2012 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3EtaCorrSmearedNoReg_Summer12_DR53X_HCP2012")
        else:
            self.e3EtaCorrSmearedNoReg_Summer12_DR53X_HCP2012_branch.SetAddress(<void*>&self.e3EtaCorrSmearedNoReg_Summer12_DR53X_HCP2012_value)

        #print "making e3EtaCorrSmearedReg_2012Jul13ReReco"
        self.e3EtaCorrSmearedReg_2012Jul13ReReco_branch = the_tree.GetBranch("e3EtaCorrSmearedReg_2012Jul13ReReco")
        #if not self.e3EtaCorrSmearedReg_2012Jul13ReReco_branch and "e3EtaCorrSmearedReg_2012Jul13ReReco" not in self.complained:
        if not self.e3EtaCorrSmearedReg_2012Jul13ReReco_branch and "e3EtaCorrSmearedReg_2012Jul13ReReco":
            warnings.warn( "EEETauTree: Expected branch e3EtaCorrSmearedReg_2012Jul13ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3EtaCorrSmearedReg_2012Jul13ReReco")
        else:
            self.e3EtaCorrSmearedReg_2012Jul13ReReco_branch.SetAddress(<void*>&self.e3EtaCorrSmearedReg_2012Jul13ReReco_value)

        #print "making e3EtaCorrSmearedReg_Fall11"
        self.e3EtaCorrSmearedReg_Fall11_branch = the_tree.GetBranch("e3EtaCorrSmearedReg_Fall11")
        #if not self.e3EtaCorrSmearedReg_Fall11_branch and "e3EtaCorrSmearedReg_Fall11" not in self.complained:
        if not self.e3EtaCorrSmearedReg_Fall11_branch and "e3EtaCorrSmearedReg_Fall11":
            warnings.warn( "EEETauTree: Expected branch e3EtaCorrSmearedReg_Fall11 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3EtaCorrSmearedReg_Fall11")
        else:
            self.e3EtaCorrSmearedReg_Fall11_branch.SetAddress(<void*>&self.e3EtaCorrSmearedReg_Fall11_value)

        #print "making e3EtaCorrSmearedReg_Jan16ReReco"
        self.e3EtaCorrSmearedReg_Jan16ReReco_branch = the_tree.GetBranch("e3EtaCorrSmearedReg_Jan16ReReco")
        #if not self.e3EtaCorrSmearedReg_Jan16ReReco_branch and "e3EtaCorrSmearedReg_Jan16ReReco" not in self.complained:
        if not self.e3EtaCorrSmearedReg_Jan16ReReco_branch and "e3EtaCorrSmearedReg_Jan16ReReco":
            warnings.warn( "EEETauTree: Expected branch e3EtaCorrSmearedReg_Jan16ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3EtaCorrSmearedReg_Jan16ReReco")
        else:
            self.e3EtaCorrSmearedReg_Jan16ReReco_branch.SetAddress(<void*>&self.e3EtaCorrSmearedReg_Jan16ReReco_value)

        #print "making e3EtaCorrSmearedReg_Summer12_DR53X_HCP2012"
        self.e3EtaCorrSmearedReg_Summer12_DR53X_HCP2012_branch = the_tree.GetBranch("e3EtaCorrSmearedReg_Summer12_DR53X_HCP2012")
        #if not self.e3EtaCorrSmearedReg_Summer12_DR53X_HCP2012_branch and "e3EtaCorrSmearedReg_Summer12_DR53X_HCP2012" not in self.complained:
        if not self.e3EtaCorrSmearedReg_Summer12_DR53X_HCP2012_branch and "e3EtaCorrSmearedReg_Summer12_DR53X_HCP2012":
            warnings.warn( "EEETauTree: Expected branch e3EtaCorrSmearedReg_Summer12_DR53X_HCP2012 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3EtaCorrSmearedReg_Summer12_DR53X_HCP2012")
        else:
            self.e3EtaCorrSmearedReg_Summer12_DR53X_HCP2012_branch.SetAddress(<void*>&self.e3EtaCorrSmearedReg_Summer12_DR53X_HCP2012_value)

        #print "making e3GenCharge"
        self.e3GenCharge_branch = the_tree.GetBranch("e3GenCharge")
        #if not self.e3GenCharge_branch and "e3GenCharge" not in self.complained:
        if not self.e3GenCharge_branch and "e3GenCharge":
            warnings.warn( "EEETauTree: Expected branch e3GenCharge does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3GenCharge")
        else:
            self.e3GenCharge_branch.SetAddress(<void*>&self.e3GenCharge_value)

        #print "making e3GenEnergy"
        self.e3GenEnergy_branch = the_tree.GetBranch("e3GenEnergy")
        #if not self.e3GenEnergy_branch and "e3GenEnergy" not in self.complained:
        if not self.e3GenEnergy_branch and "e3GenEnergy":
            warnings.warn( "EEETauTree: Expected branch e3GenEnergy does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3GenEnergy")
        else:
            self.e3GenEnergy_branch.SetAddress(<void*>&self.e3GenEnergy_value)

        #print "making e3GenEta"
        self.e3GenEta_branch = the_tree.GetBranch("e3GenEta")
        #if not self.e3GenEta_branch and "e3GenEta" not in self.complained:
        if not self.e3GenEta_branch and "e3GenEta":
            warnings.warn( "EEETauTree: Expected branch e3GenEta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3GenEta")
        else:
            self.e3GenEta_branch.SetAddress(<void*>&self.e3GenEta_value)

        #print "making e3GenMotherPdgId"
        self.e3GenMotherPdgId_branch = the_tree.GetBranch("e3GenMotherPdgId")
        #if not self.e3GenMotherPdgId_branch and "e3GenMotherPdgId" not in self.complained:
        if not self.e3GenMotherPdgId_branch and "e3GenMotherPdgId":
            warnings.warn( "EEETauTree: Expected branch e3GenMotherPdgId does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3GenMotherPdgId")
        else:
            self.e3GenMotherPdgId_branch.SetAddress(<void*>&self.e3GenMotherPdgId_value)

        #print "making e3GenPdgId"
        self.e3GenPdgId_branch = the_tree.GetBranch("e3GenPdgId")
        #if not self.e3GenPdgId_branch and "e3GenPdgId" not in self.complained:
        if not self.e3GenPdgId_branch and "e3GenPdgId":
            warnings.warn( "EEETauTree: Expected branch e3GenPdgId does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3GenPdgId")
        else:
            self.e3GenPdgId_branch.SetAddress(<void*>&self.e3GenPdgId_value)

        #print "making e3GenPhi"
        self.e3GenPhi_branch = the_tree.GetBranch("e3GenPhi")
        #if not self.e3GenPhi_branch and "e3GenPhi" not in self.complained:
        if not self.e3GenPhi_branch and "e3GenPhi":
            warnings.warn( "EEETauTree: Expected branch e3GenPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3GenPhi")
        else:
            self.e3GenPhi_branch.SetAddress(<void*>&self.e3GenPhi_value)

        #print "making e3HadronicDepth1OverEm"
        self.e3HadronicDepth1OverEm_branch = the_tree.GetBranch("e3HadronicDepth1OverEm")
        #if not self.e3HadronicDepth1OverEm_branch and "e3HadronicDepth1OverEm" not in self.complained:
        if not self.e3HadronicDepth1OverEm_branch and "e3HadronicDepth1OverEm":
            warnings.warn( "EEETauTree: Expected branch e3HadronicDepth1OverEm does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3HadronicDepth1OverEm")
        else:
            self.e3HadronicDepth1OverEm_branch.SetAddress(<void*>&self.e3HadronicDepth1OverEm_value)

        #print "making e3HadronicDepth2OverEm"
        self.e3HadronicDepth2OverEm_branch = the_tree.GetBranch("e3HadronicDepth2OverEm")
        #if not self.e3HadronicDepth2OverEm_branch and "e3HadronicDepth2OverEm" not in self.complained:
        if not self.e3HadronicDepth2OverEm_branch and "e3HadronicDepth2OverEm":
            warnings.warn( "EEETauTree: Expected branch e3HadronicDepth2OverEm does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3HadronicDepth2OverEm")
        else:
            self.e3HadronicDepth2OverEm_branch.SetAddress(<void*>&self.e3HadronicDepth2OverEm_value)

        #print "making e3HadronicOverEM"
        self.e3HadronicOverEM_branch = the_tree.GetBranch("e3HadronicOverEM")
        #if not self.e3HadronicOverEM_branch and "e3HadronicOverEM" not in self.complained:
        if not self.e3HadronicOverEM_branch and "e3HadronicOverEM":
            warnings.warn( "EEETauTree: Expected branch e3HadronicOverEM does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3HadronicOverEM")
        else:
            self.e3HadronicOverEM_branch.SetAddress(<void*>&self.e3HadronicOverEM_value)

        #print "making e3HasConversion"
        self.e3HasConversion_branch = the_tree.GetBranch("e3HasConversion")
        #if not self.e3HasConversion_branch and "e3HasConversion" not in self.complained:
        if not self.e3HasConversion_branch and "e3HasConversion":
            warnings.warn( "EEETauTree: Expected branch e3HasConversion does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3HasConversion")
        else:
            self.e3HasConversion_branch.SetAddress(<void*>&self.e3HasConversion_value)

        #print "making e3HasMatchedConversion"
        self.e3HasMatchedConversion_branch = the_tree.GetBranch("e3HasMatchedConversion")
        #if not self.e3HasMatchedConversion_branch and "e3HasMatchedConversion" not in self.complained:
        if not self.e3HasMatchedConversion_branch and "e3HasMatchedConversion":
            warnings.warn( "EEETauTree: Expected branch e3HasMatchedConversion does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3HasMatchedConversion")
        else:
            self.e3HasMatchedConversion_branch.SetAddress(<void*>&self.e3HasMatchedConversion_value)

        #print "making e3HcalIsoDR03"
        self.e3HcalIsoDR03_branch = the_tree.GetBranch("e3HcalIsoDR03")
        #if not self.e3HcalIsoDR03_branch and "e3HcalIsoDR03" not in self.complained:
        if not self.e3HcalIsoDR03_branch and "e3HcalIsoDR03":
            warnings.warn( "EEETauTree: Expected branch e3HcalIsoDR03 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3HcalIsoDR03")
        else:
            self.e3HcalIsoDR03_branch.SetAddress(<void*>&self.e3HcalIsoDR03_value)

        #print "making e3IP3DS"
        self.e3IP3DS_branch = the_tree.GetBranch("e3IP3DS")
        #if not self.e3IP3DS_branch and "e3IP3DS" not in self.complained:
        if not self.e3IP3DS_branch and "e3IP3DS":
            warnings.warn( "EEETauTree: Expected branch e3IP3DS does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3IP3DS")
        else:
            self.e3IP3DS_branch.SetAddress(<void*>&self.e3IP3DS_value)

        #print "making e3JetArea"
        self.e3JetArea_branch = the_tree.GetBranch("e3JetArea")
        #if not self.e3JetArea_branch and "e3JetArea" not in self.complained:
        if not self.e3JetArea_branch and "e3JetArea":
            warnings.warn( "EEETauTree: Expected branch e3JetArea does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3JetArea")
        else:
            self.e3JetArea_branch.SetAddress(<void*>&self.e3JetArea_value)

        #print "making e3JetBtag"
        self.e3JetBtag_branch = the_tree.GetBranch("e3JetBtag")
        #if not self.e3JetBtag_branch and "e3JetBtag" not in self.complained:
        if not self.e3JetBtag_branch and "e3JetBtag":
            warnings.warn( "EEETauTree: Expected branch e3JetBtag does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3JetBtag")
        else:
            self.e3JetBtag_branch.SetAddress(<void*>&self.e3JetBtag_value)

        #print "making e3JetCSVBtag"
        self.e3JetCSVBtag_branch = the_tree.GetBranch("e3JetCSVBtag")
        #if not self.e3JetCSVBtag_branch and "e3JetCSVBtag" not in self.complained:
        if not self.e3JetCSVBtag_branch and "e3JetCSVBtag":
            warnings.warn( "EEETauTree: Expected branch e3JetCSVBtag does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3JetCSVBtag")
        else:
            self.e3JetCSVBtag_branch.SetAddress(<void*>&self.e3JetCSVBtag_value)

        #print "making e3JetEtaEtaMoment"
        self.e3JetEtaEtaMoment_branch = the_tree.GetBranch("e3JetEtaEtaMoment")
        #if not self.e3JetEtaEtaMoment_branch and "e3JetEtaEtaMoment" not in self.complained:
        if not self.e3JetEtaEtaMoment_branch and "e3JetEtaEtaMoment":
            warnings.warn( "EEETauTree: Expected branch e3JetEtaEtaMoment does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3JetEtaEtaMoment")
        else:
            self.e3JetEtaEtaMoment_branch.SetAddress(<void*>&self.e3JetEtaEtaMoment_value)

        #print "making e3JetEtaPhiMoment"
        self.e3JetEtaPhiMoment_branch = the_tree.GetBranch("e3JetEtaPhiMoment")
        #if not self.e3JetEtaPhiMoment_branch and "e3JetEtaPhiMoment" not in self.complained:
        if not self.e3JetEtaPhiMoment_branch and "e3JetEtaPhiMoment":
            warnings.warn( "EEETauTree: Expected branch e3JetEtaPhiMoment does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3JetEtaPhiMoment")
        else:
            self.e3JetEtaPhiMoment_branch.SetAddress(<void*>&self.e3JetEtaPhiMoment_value)

        #print "making e3JetEtaPhiSpread"
        self.e3JetEtaPhiSpread_branch = the_tree.GetBranch("e3JetEtaPhiSpread")
        #if not self.e3JetEtaPhiSpread_branch and "e3JetEtaPhiSpread" not in self.complained:
        if not self.e3JetEtaPhiSpread_branch and "e3JetEtaPhiSpread":
            warnings.warn( "EEETauTree: Expected branch e3JetEtaPhiSpread does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3JetEtaPhiSpread")
        else:
            self.e3JetEtaPhiSpread_branch.SetAddress(<void*>&self.e3JetEtaPhiSpread_value)

        #print "making e3JetPartonFlavour"
        self.e3JetPartonFlavour_branch = the_tree.GetBranch("e3JetPartonFlavour")
        #if not self.e3JetPartonFlavour_branch and "e3JetPartonFlavour" not in self.complained:
        if not self.e3JetPartonFlavour_branch and "e3JetPartonFlavour":
            warnings.warn( "EEETauTree: Expected branch e3JetPartonFlavour does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3JetPartonFlavour")
        else:
            self.e3JetPartonFlavour_branch.SetAddress(<void*>&self.e3JetPartonFlavour_value)

        #print "making e3JetPhiPhiMoment"
        self.e3JetPhiPhiMoment_branch = the_tree.GetBranch("e3JetPhiPhiMoment")
        #if not self.e3JetPhiPhiMoment_branch and "e3JetPhiPhiMoment" not in self.complained:
        if not self.e3JetPhiPhiMoment_branch and "e3JetPhiPhiMoment":
            warnings.warn( "EEETauTree: Expected branch e3JetPhiPhiMoment does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3JetPhiPhiMoment")
        else:
            self.e3JetPhiPhiMoment_branch.SetAddress(<void*>&self.e3JetPhiPhiMoment_value)

        #print "making e3JetPt"
        self.e3JetPt_branch = the_tree.GetBranch("e3JetPt")
        #if not self.e3JetPt_branch and "e3JetPt" not in self.complained:
        if not self.e3JetPt_branch and "e3JetPt":
            warnings.warn( "EEETauTree: Expected branch e3JetPt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3JetPt")
        else:
            self.e3JetPt_branch.SetAddress(<void*>&self.e3JetPt_value)

        #print "making e3JetQGLikelihoodID"
        self.e3JetQGLikelihoodID_branch = the_tree.GetBranch("e3JetQGLikelihoodID")
        #if not self.e3JetQGLikelihoodID_branch and "e3JetQGLikelihoodID" not in self.complained:
        if not self.e3JetQGLikelihoodID_branch and "e3JetQGLikelihoodID":
            warnings.warn( "EEETauTree: Expected branch e3JetQGLikelihoodID does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3JetQGLikelihoodID")
        else:
            self.e3JetQGLikelihoodID_branch.SetAddress(<void*>&self.e3JetQGLikelihoodID_value)

        #print "making e3JetQGMVAID"
        self.e3JetQGMVAID_branch = the_tree.GetBranch("e3JetQGMVAID")
        #if not self.e3JetQGMVAID_branch and "e3JetQGMVAID" not in self.complained:
        if not self.e3JetQGMVAID_branch and "e3JetQGMVAID":
            warnings.warn( "EEETauTree: Expected branch e3JetQGMVAID does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3JetQGMVAID")
        else:
            self.e3JetQGMVAID_branch.SetAddress(<void*>&self.e3JetQGMVAID_value)

        #print "making e3Jetaxis1"
        self.e3Jetaxis1_branch = the_tree.GetBranch("e3Jetaxis1")
        #if not self.e3Jetaxis1_branch and "e3Jetaxis1" not in self.complained:
        if not self.e3Jetaxis1_branch and "e3Jetaxis1":
            warnings.warn( "EEETauTree: Expected branch e3Jetaxis1 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3Jetaxis1")
        else:
            self.e3Jetaxis1_branch.SetAddress(<void*>&self.e3Jetaxis1_value)

        #print "making e3Jetaxis2"
        self.e3Jetaxis2_branch = the_tree.GetBranch("e3Jetaxis2")
        #if not self.e3Jetaxis2_branch and "e3Jetaxis2" not in self.complained:
        if not self.e3Jetaxis2_branch and "e3Jetaxis2":
            warnings.warn( "EEETauTree: Expected branch e3Jetaxis2 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3Jetaxis2")
        else:
            self.e3Jetaxis2_branch.SetAddress(<void*>&self.e3Jetaxis2_value)

        #print "making e3Jetmult"
        self.e3Jetmult_branch = the_tree.GetBranch("e3Jetmult")
        #if not self.e3Jetmult_branch and "e3Jetmult" not in self.complained:
        if not self.e3Jetmult_branch and "e3Jetmult":
            warnings.warn( "EEETauTree: Expected branch e3Jetmult does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3Jetmult")
        else:
            self.e3Jetmult_branch.SetAddress(<void*>&self.e3Jetmult_value)

        #print "making e3JetmultMLP"
        self.e3JetmultMLP_branch = the_tree.GetBranch("e3JetmultMLP")
        #if not self.e3JetmultMLP_branch and "e3JetmultMLP" not in self.complained:
        if not self.e3JetmultMLP_branch and "e3JetmultMLP":
            warnings.warn( "EEETauTree: Expected branch e3JetmultMLP does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3JetmultMLP")
        else:
            self.e3JetmultMLP_branch.SetAddress(<void*>&self.e3JetmultMLP_value)

        #print "making e3JetmultMLPQC"
        self.e3JetmultMLPQC_branch = the_tree.GetBranch("e3JetmultMLPQC")
        #if not self.e3JetmultMLPQC_branch and "e3JetmultMLPQC" not in self.complained:
        if not self.e3JetmultMLPQC_branch and "e3JetmultMLPQC":
            warnings.warn( "EEETauTree: Expected branch e3JetmultMLPQC does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3JetmultMLPQC")
        else:
            self.e3JetmultMLPQC_branch.SetAddress(<void*>&self.e3JetmultMLPQC_value)

        #print "making e3JetptD"
        self.e3JetptD_branch = the_tree.GetBranch("e3JetptD")
        #if not self.e3JetptD_branch and "e3JetptD" not in self.complained:
        if not self.e3JetptD_branch and "e3JetptD":
            warnings.warn( "EEETauTree: Expected branch e3JetptD does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3JetptD")
        else:
            self.e3JetptD_branch.SetAddress(<void*>&self.e3JetptD_value)

        #print "making e3L1NonIsoHLTNonIsoMu17Ele8PixelMatchFilter"
        self.e3L1NonIsoHLTNonIsoMu17Ele8PixelMatchFilter_branch = the_tree.GetBranch("e3L1NonIsoHLTNonIsoMu17Ele8PixelMatchFilter")
        #if not self.e3L1NonIsoHLTNonIsoMu17Ele8PixelMatchFilter_branch and "e3L1NonIsoHLTNonIsoMu17Ele8PixelMatchFilter" not in self.complained:
        if not self.e3L1NonIsoHLTNonIsoMu17Ele8PixelMatchFilter_branch and "e3L1NonIsoHLTNonIsoMu17Ele8PixelMatchFilter":
            warnings.warn( "EEETauTree: Expected branch e3L1NonIsoHLTNonIsoMu17Ele8PixelMatchFilter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3L1NonIsoHLTNonIsoMu17Ele8PixelMatchFilter")
        else:
            self.e3L1NonIsoHLTNonIsoMu17Ele8PixelMatchFilter_branch.SetAddress(<void*>&self.e3L1NonIsoHLTNonIsoMu17Ele8PixelMatchFilter_value)

        #print "making e3MITID"
        self.e3MITID_branch = the_tree.GetBranch("e3MITID")
        #if not self.e3MITID_branch and "e3MITID" not in self.complained:
        if not self.e3MITID_branch and "e3MITID":
            warnings.warn( "EEETauTree: Expected branch e3MITID does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3MITID")
        else:
            self.e3MITID_branch.SetAddress(<void*>&self.e3MITID_value)

        #print "making e3MVAIDH2TauWP"
        self.e3MVAIDH2TauWP_branch = the_tree.GetBranch("e3MVAIDH2TauWP")
        #if not self.e3MVAIDH2TauWP_branch and "e3MVAIDH2TauWP" not in self.complained:
        if not self.e3MVAIDH2TauWP_branch and "e3MVAIDH2TauWP":
            warnings.warn( "EEETauTree: Expected branch e3MVAIDH2TauWP does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3MVAIDH2TauWP")
        else:
            self.e3MVAIDH2TauWP_branch.SetAddress(<void*>&self.e3MVAIDH2TauWP_value)

        #print "making e3MVANonTrig"
        self.e3MVANonTrig_branch = the_tree.GetBranch("e3MVANonTrig")
        #if not self.e3MVANonTrig_branch and "e3MVANonTrig" not in self.complained:
        if not self.e3MVANonTrig_branch and "e3MVANonTrig":
            warnings.warn( "EEETauTree: Expected branch e3MVANonTrig does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3MVANonTrig")
        else:
            self.e3MVANonTrig_branch.SetAddress(<void*>&self.e3MVANonTrig_value)

        #print "making e3MVATrig"
        self.e3MVATrig_branch = the_tree.GetBranch("e3MVATrig")
        #if not self.e3MVATrig_branch and "e3MVATrig" not in self.complained:
        if not self.e3MVATrig_branch and "e3MVATrig":
            warnings.warn( "EEETauTree: Expected branch e3MVATrig does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3MVATrig")
        else:
            self.e3MVATrig_branch.SetAddress(<void*>&self.e3MVATrig_value)

        #print "making e3MVATrigIDISO"
        self.e3MVATrigIDISO_branch = the_tree.GetBranch("e3MVATrigIDISO")
        #if not self.e3MVATrigIDISO_branch and "e3MVATrigIDISO" not in self.complained:
        if not self.e3MVATrigIDISO_branch and "e3MVATrigIDISO":
            warnings.warn( "EEETauTree: Expected branch e3MVATrigIDISO does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3MVATrigIDISO")
        else:
            self.e3MVATrigIDISO_branch.SetAddress(<void*>&self.e3MVATrigIDISO_value)

        #print "making e3MVATrigIDISOPUSUB"
        self.e3MVATrigIDISOPUSUB_branch = the_tree.GetBranch("e3MVATrigIDISOPUSUB")
        #if not self.e3MVATrigIDISOPUSUB_branch and "e3MVATrigIDISOPUSUB" not in self.complained:
        if not self.e3MVATrigIDISOPUSUB_branch and "e3MVATrigIDISOPUSUB":
            warnings.warn( "EEETauTree: Expected branch e3MVATrigIDISOPUSUB does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3MVATrigIDISOPUSUB")
        else:
            self.e3MVATrigIDISOPUSUB_branch.SetAddress(<void*>&self.e3MVATrigIDISOPUSUB_value)

        #print "making e3MVATrigNoIP"
        self.e3MVATrigNoIP_branch = the_tree.GetBranch("e3MVATrigNoIP")
        #if not self.e3MVATrigNoIP_branch and "e3MVATrigNoIP" not in self.complained:
        if not self.e3MVATrigNoIP_branch and "e3MVATrigNoIP":
            warnings.warn( "EEETauTree: Expected branch e3MVATrigNoIP does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3MVATrigNoIP")
        else:
            self.e3MVATrigNoIP_branch.SetAddress(<void*>&self.e3MVATrigNoIP_value)

        #print "making e3Mass"
        self.e3Mass_branch = the_tree.GetBranch("e3Mass")
        #if not self.e3Mass_branch and "e3Mass" not in self.complained:
        if not self.e3Mass_branch and "e3Mass":
            warnings.warn( "EEETauTree: Expected branch e3Mass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3Mass")
        else:
            self.e3Mass_branch.SetAddress(<void*>&self.e3Mass_value)

        #print "making e3MatchesDoubleEPath"
        self.e3MatchesDoubleEPath_branch = the_tree.GetBranch("e3MatchesDoubleEPath")
        #if not self.e3MatchesDoubleEPath_branch and "e3MatchesDoubleEPath" not in self.complained:
        if not self.e3MatchesDoubleEPath_branch and "e3MatchesDoubleEPath":
            warnings.warn( "EEETauTree: Expected branch e3MatchesDoubleEPath does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3MatchesDoubleEPath")
        else:
            self.e3MatchesDoubleEPath_branch.SetAddress(<void*>&self.e3MatchesDoubleEPath_value)

        #print "making e3MatchesMu17Ele8IsoPath"
        self.e3MatchesMu17Ele8IsoPath_branch = the_tree.GetBranch("e3MatchesMu17Ele8IsoPath")
        #if not self.e3MatchesMu17Ele8IsoPath_branch and "e3MatchesMu17Ele8IsoPath" not in self.complained:
        if not self.e3MatchesMu17Ele8IsoPath_branch and "e3MatchesMu17Ele8IsoPath":
            warnings.warn( "EEETauTree: Expected branch e3MatchesMu17Ele8IsoPath does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3MatchesMu17Ele8IsoPath")
        else:
            self.e3MatchesMu17Ele8IsoPath_branch.SetAddress(<void*>&self.e3MatchesMu17Ele8IsoPath_value)

        #print "making e3MatchesMu17Ele8Path"
        self.e3MatchesMu17Ele8Path_branch = the_tree.GetBranch("e3MatchesMu17Ele8Path")
        #if not self.e3MatchesMu17Ele8Path_branch and "e3MatchesMu17Ele8Path" not in self.complained:
        if not self.e3MatchesMu17Ele8Path_branch and "e3MatchesMu17Ele8Path":
            warnings.warn( "EEETauTree: Expected branch e3MatchesMu17Ele8Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3MatchesMu17Ele8Path")
        else:
            self.e3MatchesMu17Ele8Path_branch.SetAddress(<void*>&self.e3MatchesMu17Ele8Path_value)

        #print "making e3MatchesMu8Ele17IsoPath"
        self.e3MatchesMu8Ele17IsoPath_branch = the_tree.GetBranch("e3MatchesMu8Ele17IsoPath")
        #if not self.e3MatchesMu8Ele17IsoPath_branch and "e3MatchesMu8Ele17IsoPath" not in self.complained:
        if not self.e3MatchesMu8Ele17IsoPath_branch and "e3MatchesMu8Ele17IsoPath":
            warnings.warn( "EEETauTree: Expected branch e3MatchesMu8Ele17IsoPath does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3MatchesMu8Ele17IsoPath")
        else:
            self.e3MatchesMu8Ele17IsoPath_branch.SetAddress(<void*>&self.e3MatchesMu8Ele17IsoPath_value)

        #print "making e3MatchesMu8Ele17Path"
        self.e3MatchesMu8Ele17Path_branch = the_tree.GetBranch("e3MatchesMu8Ele17Path")
        #if not self.e3MatchesMu8Ele17Path_branch and "e3MatchesMu8Ele17Path" not in self.complained:
        if not self.e3MatchesMu8Ele17Path_branch and "e3MatchesMu8Ele17Path":
            warnings.warn( "EEETauTree: Expected branch e3MatchesMu8Ele17Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3MatchesMu8Ele17Path")
        else:
            self.e3MatchesMu8Ele17Path_branch.SetAddress(<void*>&self.e3MatchesMu8Ele17Path_value)

        #print "making e3MatchesSingleE"
        self.e3MatchesSingleE_branch = the_tree.GetBranch("e3MatchesSingleE")
        #if not self.e3MatchesSingleE_branch and "e3MatchesSingleE" not in self.complained:
        if not self.e3MatchesSingleE_branch and "e3MatchesSingleE":
            warnings.warn( "EEETauTree: Expected branch e3MatchesSingleE does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3MatchesSingleE")
        else:
            self.e3MatchesSingleE_branch.SetAddress(<void*>&self.e3MatchesSingleE_value)

        #print "making e3MatchesSingleEPlusMET"
        self.e3MatchesSingleEPlusMET_branch = the_tree.GetBranch("e3MatchesSingleEPlusMET")
        #if not self.e3MatchesSingleEPlusMET_branch and "e3MatchesSingleEPlusMET" not in self.complained:
        if not self.e3MatchesSingleEPlusMET_branch and "e3MatchesSingleEPlusMET":
            warnings.warn( "EEETauTree: Expected branch e3MatchesSingleEPlusMET does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3MatchesSingleEPlusMET")
        else:
            self.e3MatchesSingleEPlusMET_branch.SetAddress(<void*>&self.e3MatchesSingleEPlusMET_value)

        #print "making e3MissingHits"
        self.e3MissingHits_branch = the_tree.GetBranch("e3MissingHits")
        #if not self.e3MissingHits_branch and "e3MissingHits" not in self.complained:
        if not self.e3MissingHits_branch and "e3MissingHits":
            warnings.warn( "EEETauTree: Expected branch e3MissingHits does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3MissingHits")
        else:
            self.e3MissingHits_branch.SetAddress(<void*>&self.e3MissingHits_value)

        #print "making e3MtToMET"
        self.e3MtToMET_branch = the_tree.GetBranch("e3MtToMET")
        #if not self.e3MtToMET_branch and "e3MtToMET" not in self.complained:
        if not self.e3MtToMET_branch and "e3MtToMET":
            warnings.warn( "EEETauTree: Expected branch e3MtToMET does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3MtToMET")
        else:
            self.e3MtToMET_branch.SetAddress(<void*>&self.e3MtToMET_value)

        #print "making e3MtToMVAMET"
        self.e3MtToMVAMET_branch = the_tree.GetBranch("e3MtToMVAMET")
        #if not self.e3MtToMVAMET_branch and "e3MtToMVAMET" not in self.complained:
        if not self.e3MtToMVAMET_branch and "e3MtToMVAMET":
            warnings.warn( "EEETauTree: Expected branch e3MtToMVAMET does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3MtToMVAMET")
        else:
            self.e3MtToMVAMET_branch.SetAddress(<void*>&self.e3MtToMVAMET_value)

        #print "making e3MtToPFMET"
        self.e3MtToPFMET_branch = the_tree.GetBranch("e3MtToPFMET")
        #if not self.e3MtToPFMET_branch and "e3MtToPFMET" not in self.complained:
        if not self.e3MtToPFMET_branch and "e3MtToPFMET":
            warnings.warn( "EEETauTree: Expected branch e3MtToPFMET does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3MtToPFMET")
        else:
            self.e3MtToPFMET_branch.SetAddress(<void*>&self.e3MtToPFMET_value)

        #print "making e3MtToPfMet_Ty1"
        self.e3MtToPfMet_Ty1_branch = the_tree.GetBranch("e3MtToPfMet_Ty1")
        #if not self.e3MtToPfMet_Ty1_branch and "e3MtToPfMet_Ty1" not in self.complained:
        if not self.e3MtToPfMet_Ty1_branch and "e3MtToPfMet_Ty1":
            warnings.warn( "EEETauTree: Expected branch e3MtToPfMet_Ty1 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3MtToPfMet_Ty1")
        else:
            self.e3MtToPfMet_Ty1_branch.SetAddress(<void*>&self.e3MtToPfMet_Ty1_value)

        #print "making e3MtToPfMet_jes"
        self.e3MtToPfMet_jes_branch = the_tree.GetBranch("e3MtToPfMet_jes")
        #if not self.e3MtToPfMet_jes_branch and "e3MtToPfMet_jes" not in self.complained:
        if not self.e3MtToPfMet_jes_branch and "e3MtToPfMet_jes":
            warnings.warn( "EEETauTree: Expected branch e3MtToPfMet_jes does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3MtToPfMet_jes")
        else:
            self.e3MtToPfMet_jes_branch.SetAddress(<void*>&self.e3MtToPfMet_jes_value)

        #print "making e3MtToPfMet_mes"
        self.e3MtToPfMet_mes_branch = the_tree.GetBranch("e3MtToPfMet_mes")
        #if not self.e3MtToPfMet_mes_branch and "e3MtToPfMet_mes" not in self.complained:
        if not self.e3MtToPfMet_mes_branch and "e3MtToPfMet_mes":
            warnings.warn( "EEETauTree: Expected branch e3MtToPfMet_mes does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3MtToPfMet_mes")
        else:
            self.e3MtToPfMet_mes_branch.SetAddress(<void*>&self.e3MtToPfMet_mes_value)

        #print "making e3MtToPfMet_tes"
        self.e3MtToPfMet_tes_branch = the_tree.GetBranch("e3MtToPfMet_tes")
        #if not self.e3MtToPfMet_tes_branch and "e3MtToPfMet_tes" not in self.complained:
        if not self.e3MtToPfMet_tes_branch and "e3MtToPfMet_tes":
            warnings.warn( "EEETauTree: Expected branch e3MtToPfMet_tes does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3MtToPfMet_tes")
        else:
            self.e3MtToPfMet_tes_branch.SetAddress(<void*>&self.e3MtToPfMet_tes_value)

        #print "making e3MtToPfMet_ues"
        self.e3MtToPfMet_ues_branch = the_tree.GetBranch("e3MtToPfMet_ues")
        #if not self.e3MtToPfMet_ues_branch and "e3MtToPfMet_ues" not in self.complained:
        if not self.e3MtToPfMet_ues_branch and "e3MtToPfMet_ues":
            warnings.warn( "EEETauTree: Expected branch e3MtToPfMet_ues does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3MtToPfMet_ues")
        else:
            self.e3MtToPfMet_ues_branch.SetAddress(<void*>&self.e3MtToPfMet_ues_value)

        #print "making e3Mu17Ele8CaloIdTCaloIsoVLTrkIdVLTrkIsoVLTrackIsoFilter"
        self.e3Mu17Ele8CaloIdTCaloIsoVLTrkIdVLTrkIsoVLTrackIsoFilter_branch = the_tree.GetBranch("e3Mu17Ele8CaloIdTCaloIsoVLTrkIdVLTrkIsoVLTrackIsoFilter")
        #if not self.e3Mu17Ele8CaloIdTCaloIsoVLTrkIdVLTrkIsoVLTrackIsoFilter_branch and "e3Mu17Ele8CaloIdTCaloIsoVLTrkIdVLTrkIsoVLTrackIsoFilter" not in self.complained:
        if not self.e3Mu17Ele8CaloIdTCaloIsoVLTrkIdVLTrkIsoVLTrackIsoFilter_branch and "e3Mu17Ele8CaloIdTCaloIsoVLTrkIdVLTrkIsoVLTrackIsoFilter":
            warnings.warn( "EEETauTree: Expected branch e3Mu17Ele8CaloIdTCaloIsoVLTrkIdVLTrkIsoVLTrackIsoFilter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3Mu17Ele8CaloIdTCaloIsoVLTrkIdVLTrkIsoVLTrackIsoFilter")
        else:
            self.e3Mu17Ele8CaloIdTCaloIsoVLTrkIdVLTrkIsoVLTrackIsoFilter_branch.SetAddress(<void*>&self.e3Mu17Ele8CaloIdTCaloIsoVLTrkIdVLTrkIsoVLTrackIsoFilter_value)

        #print "making e3Mu17Ele8CaloIdTPixelMatchFilter"
        self.e3Mu17Ele8CaloIdTPixelMatchFilter_branch = the_tree.GetBranch("e3Mu17Ele8CaloIdTPixelMatchFilter")
        #if not self.e3Mu17Ele8CaloIdTPixelMatchFilter_branch and "e3Mu17Ele8CaloIdTPixelMatchFilter" not in self.complained:
        if not self.e3Mu17Ele8CaloIdTPixelMatchFilter_branch and "e3Mu17Ele8CaloIdTPixelMatchFilter":
            warnings.warn( "EEETauTree: Expected branch e3Mu17Ele8CaloIdTPixelMatchFilter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3Mu17Ele8CaloIdTPixelMatchFilter")
        else:
            self.e3Mu17Ele8CaloIdTPixelMatchFilter_branch.SetAddress(<void*>&self.e3Mu17Ele8CaloIdTPixelMatchFilter_value)

        #print "making e3Mu17Ele8dZFilter"
        self.e3Mu17Ele8dZFilter_branch = the_tree.GetBranch("e3Mu17Ele8dZFilter")
        #if not self.e3Mu17Ele8dZFilter_branch and "e3Mu17Ele8dZFilter" not in self.complained:
        if not self.e3Mu17Ele8dZFilter_branch and "e3Mu17Ele8dZFilter":
            warnings.warn( "EEETauTree: Expected branch e3Mu17Ele8dZFilter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3Mu17Ele8dZFilter")
        else:
            self.e3Mu17Ele8dZFilter_branch.SetAddress(<void*>&self.e3Mu17Ele8dZFilter_value)

        #print "making e3MuOverlap"
        self.e3MuOverlap_branch = the_tree.GetBranch("e3MuOverlap")
        #if not self.e3MuOverlap_branch and "e3MuOverlap" not in self.complained:
        if not self.e3MuOverlap_branch and "e3MuOverlap":
            warnings.warn( "EEETauTree: Expected branch e3MuOverlap does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3MuOverlap")
        else:
            self.e3MuOverlap_branch.SetAddress(<void*>&self.e3MuOverlap_value)

        #print "making e3MuOverlapZHLoose"
        self.e3MuOverlapZHLoose_branch = the_tree.GetBranch("e3MuOverlapZHLoose")
        #if not self.e3MuOverlapZHLoose_branch and "e3MuOverlapZHLoose" not in self.complained:
        if not self.e3MuOverlapZHLoose_branch and "e3MuOverlapZHLoose":
            warnings.warn( "EEETauTree: Expected branch e3MuOverlapZHLoose does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3MuOverlapZHLoose")
        else:
            self.e3MuOverlapZHLoose_branch.SetAddress(<void*>&self.e3MuOverlapZHLoose_value)

        #print "making e3MuOverlapZHTight"
        self.e3MuOverlapZHTight_branch = the_tree.GetBranch("e3MuOverlapZHTight")
        #if not self.e3MuOverlapZHTight_branch and "e3MuOverlapZHTight" not in self.complained:
        if not self.e3MuOverlapZHTight_branch and "e3MuOverlapZHTight":
            warnings.warn( "EEETauTree: Expected branch e3MuOverlapZHTight does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3MuOverlapZHTight")
        else:
            self.e3MuOverlapZHTight_branch.SetAddress(<void*>&self.e3MuOverlapZHTight_value)

        #print "making e3NearMuonVeto"
        self.e3NearMuonVeto_branch = the_tree.GetBranch("e3NearMuonVeto")
        #if not self.e3NearMuonVeto_branch and "e3NearMuonVeto" not in self.complained:
        if not self.e3NearMuonVeto_branch and "e3NearMuonVeto":
            warnings.warn( "EEETauTree: Expected branch e3NearMuonVeto does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3NearMuonVeto")
        else:
            self.e3NearMuonVeto_branch.SetAddress(<void*>&self.e3NearMuonVeto_value)

        #print "making e3PFChargedIso"
        self.e3PFChargedIso_branch = the_tree.GetBranch("e3PFChargedIso")
        #if not self.e3PFChargedIso_branch and "e3PFChargedIso" not in self.complained:
        if not self.e3PFChargedIso_branch and "e3PFChargedIso":
            warnings.warn( "EEETauTree: Expected branch e3PFChargedIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3PFChargedIso")
        else:
            self.e3PFChargedIso_branch.SetAddress(<void*>&self.e3PFChargedIso_value)

        #print "making e3PFNeutralIso"
        self.e3PFNeutralIso_branch = the_tree.GetBranch("e3PFNeutralIso")
        #if not self.e3PFNeutralIso_branch and "e3PFNeutralIso" not in self.complained:
        if not self.e3PFNeutralIso_branch and "e3PFNeutralIso":
            warnings.warn( "EEETauTree: Expected branch e3PFNeutralIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3PFNeutralIso")
        else:
            self.e3PFNeutralIso_branch.SetAddress(<void*>&self.e3PFNeutralIso_value)

        #print "making e3PFPhotonIso"
        self.e3PFPhotonIso_branch = the_tree.GetBranch("e3PFPhotonIso")
        #if not self.e3PFPhotonIso_branch and "e3PFPhotonIso" not in self.complained:
        if not self.e3PFPhotonIso_branch and "e3PFPhotonIso":
            warnings.warn( "EEETauTree: Expected branch e3PFPhotonIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3PFPhotonIso")
        else:
            self.e3PFPhotonIso_branch.SetAddress(<void*>&self.e3PFPhotonIso_value)

        #print "making e3PVDXY"
        self.e3PVDXY_branch = the_tree.GetBranch("e3PVDXY")
        #if not self.e3PVDXY_branch and "e3PVDXY" not in self.complained:
        if not self.e3PVDXY_branch and "e3PVDXY":
            warnings.warn( "EEETauTree: Expected branch e3PVDXY does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3PVDXY")
        else:
            self.e3PVDXY_branch.SetAddress(<void*>&self.e3PVDXY_value)

        #print "making e3PVDZ"
        self.e3PVDZ_branch = the_tree.GetBranch("e3PVDZ")
        #if not self.e3PVDZ_branch and "e3PVDZ" not in self.complained:
        if not self.e3PVDZ_branch and "e3PVDZ":
            warnings.warn( "EEETauTree: Expected branch e3PVDZ does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3PVDZ")
        else:
            self.e3PVDZ_branch.SetAddress(<void*>&self.e3PVDZ_value)

        #print "making e3Phi"
        self.e3Phi_branch = the_tree.GetBranch("e3Phi")
        #if not self.e3Phi_branch and "e3Phi" not in self.complained:
        if not self.e3Phi_branch and "e3Phi":
            warnings.warn( "EEETauTree: Expected branch e3Phi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3Phi")
        else:
            self.e3Phi_branch.SetAddress(<void*>&self.e3Phi_value)

        #print "making e3PhiCorrReg_2012Jul13ReReco"
        self.e3PhiCorrReg_2012Jul13ReReco_branch = the_tree.GetBranch("e3PhiCorrReg_2012Jul13ReReco")
        #if not self.e3PhiCorrReg_2012Jul13ReReco_branch and "e3PhiCorrReg_2012Jul13ReReco" not in self.complained:
        if not self.e3PhiCorrReg_2012Jul13ReReco_branch and "e3PhiCorrReg_2012Jul13ReReco":
            warnings.warn( "EEETauTree: Expected branch e3PhiCorrReg_2012Jul13ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3PhiCorrReg_2012Jul13ReReco")
        else:
            self.e3PhiCorrReg_2012Jul13ReReco_branch.SetAddress(<void*>&self.e3PhiCorrReg_2012Jul13ReReco_value)

        #print "making e3PhiCorrReg_Fall11"
        self.e3PhiCorrReg_Fall11_branch = the_tree.GetBranch("e3PhiCorrReg_Fall11")
        #if not self.e3PhiCorrReg_Fall11_branch and "e3PhiCorrReg_Fall11" not in self.complained:
        if not self.e3PhiCorrReg_Fall11_branch and "e3PhiCorrReg_Fall11":
            warnings.warn( "EEETauTree: Expected branch e3PhiCorrReg_Fall11 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3PhiCorrReg_Fall11")
        else:
            self.e3PhiCorrReg_Fall11_branch.SetAddress(<void*>&self.e3PhiCorrReg_Fall11_value)

        #print "making e3PhiCorrReg_Jan16ReReco"
        self.e3PhiCorrReg_Jan16ReReco_branch = the_tree.GetBranch("e3PhiCorrReg_Jan16ReReco")
        #if not self.e3PhiCorrReg_Jan16ReReco_branch and "e3PhiCorrReg_Jan16ReReco" not in self.complained:
        if not self.e3PhiCorrReg_Jan16ReReco_branch and "e3PhiCorrReg_Jan16ReReco":
            warnings.warn( "EEETauTree: Expected branch e3PhiCorrReg_Jan16ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3PhiCorrReg_Jan16ReReco")
        else:
            self.e3PhiCorrReg_Jan16ReReco_branch.SetAddress(<void*>&self.e3PhiCorrReg_Jan16ReReco_value)

        #print "making e3PhiCorrReg_Summer12_DR53X_HCP2012"
        self.e3PhiCorrReg_Summer12_DR53X_HCP2012_branch = the_tree.GetBranch("e3PhiCorrReg_Summer12_DR53X_HCP2012")
        #if not self.e3PhiCorrReg_Summer12_DR53X_HCP2012_branch and "e3PhiCorrReg_Summer12_DR53X_HCP2012" not in self.complained:
        if not self.e3PhiCorrReg_Summer12_DR53X_HCP2012_branch and "e3PhiCorrReg_Summer12_DR53X_HCP2012":
            warnings.warn( "EEETauTree: Expected branch e3PhiCorrReg_Summer12_DR53X_HCP2012 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3PhiCorrReg_Summer12_DR53X_HCP2012")
        else:
            self.e3PhiCorrReg_Summer12_DR53X_HCP2012_branch.SetAddress(<void*>&self.e3PhiCorrReg_Summer12_DR53X_HCP2012_value)

        #print "making e3PhiCorrSmearedNoReg_2012Jul13ReReco"
        self.e3PhiCorrSmearedNoReg_2012Jul13ReReco_branch = the_tree.GetBranch("e3PhiCorrSmearedNoReg_2012Jul13ReReco")
        #if not self.e3PhiCorrSmearedNoReg_2012Jul13ReReco_branch and "e3PhiCorrSmearedNoReg_2012Jul13ReReco" not in self.complained:
        if not self.e3PhiCorrSmearedNoReg_2012Jul13ReReco_branch and "e3PhiCorrSmearedNoReg_2012Jul13ReReco":
            warnings.warn( "EEETauTree: Expected branch e3PhiCorrSmearedNoReg_2012Jul13ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3PhiCorrSmearedNoReg_2012Jul13ReReco")
        else:
            self.e3PhiCorrSmearedNoReg_2012Jul13ReReco_branch.SetAddress(<void*>&self.e3PhiCorrSmearedNoReg_2012Jul13ReReco_value)

        #print "making e3PhiCorrSmearedNoReg_Fall11"
        self.e3PhiCorrSmearedNoReg_Fall11_branch = the_tree.GetBranch("e3PhiCorrSmearedNoReg_Fall11")
        #if not self.e3PhiCorrSmearedNoReg_Fall11_branch and "e3PhiCorrSmearedNoReg_Fall11" not in self.complained:
        if not self.e3PhiCorrSmearedNoReg_Fall11_branch and "e3PhiCorrSmearedNoReg_Fall11":
            warnings.warn( "EEETauTree: Expected branch e3PhiCorrSmearedNoReg_Fall11 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3PhiCorrSmearedNoReg_Fall11")
        else:
            self.e3PhiCorrSmearedNoReg_Fall11_branch.SetAddress(<void*>&self.e3PhiCorrSmearedNoReg_Fall11_value)

        #print "making e3PhiCorrSmearedNoReg_Jan16ReReco"
        self.e3PhiCorrSmearedNoReg_Jan16ReReco_branch = the_tree.GetBranch("e3PhiCorrSmearedNoReg_Jan16ReReco")
        #if not self.e3PhiCorrSmearedNoReg_Jan16ReReco_branch and "e3PhiCorrSmearedNoReg_Jan16ReReco" not in self.complained:
        if not self.e3PhiCorrSmearedNoReg_Jan16ReReco_branch and "e3PhiCorrSmearedNoReg_Jan16ReReco":
            warnings.warn( "EEETauTree: Expected branch e3PhiCorrSmearedNoReg_Jan16ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3PhiCorrSmearedNoReg_Jan16ReReco")
        else:
            self.e3PhiCorrSmearedNoReg_Jan16ReReco_branch.SetAddress(<void*>&self.e3PhiCorrSmearedNoReg_Jan16ReReco_value)

        #print "making e3PhiCorrSmearedNoReg_Summer12_DR53X_HCP2012"
        self.e3PhiCorrSmearedNoReg_Summer12_DR53X_HCP2012_branch = the_tree.GetBranch("e3PhiCorrSmearedNoReg_Summer12_DR53X_HCP2012")
        #if not self.e3PhiCorrSmearedNoReg_Summer12_DR53X_HCP2012_branch and "e3PhiCorrSmearedNoReg_Summer12_DR53X_HCP2012" not in self.complained:
        if not self.e3PhiCorrSmearedNoReg_Summer12_DR53X_HCP2012_branch and "e3PhiCorrSmearedNoReg_Summer12_DR53X_HCP2012":
            warnings.warn( "EEETauTree: Expected branch e3PhiCorrSmearedNoReg_Summer12_DR53X_HCP2012 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3PhiCorrSmearedNoReg_Summer12_DR53X_HCP2012")
        else:
            self.e3PhiCorrSmearedNoReg_Summer12_DR53X_HCP2012_branch.SetAddress(<void*>&self.e3PhiCorrSmearedNoReg_Summer12_DR53X_HCP2012_value)

        #print "making e3PhiCorrSmearedReg_2012Jul13ReReco"
        self.e3PhiCorrSmearedReg_2012Jul13ReReco_branch = the_tree.GetBranch("e3PhiCorrSmearedReg_2012Jul13ReReco")
        #if not self.e3PhiCorrSmearedReg_2012Jul13ReReco_branch and "e3PhiCorrSmearedReg_2012Jul13ReReco" not in self.complained:
        if not self.e3PhiCorrSmearedReg_2012Jul13ReReco_branch and "e3PhiCorrSmearedReg_2012Jul13ReReco":
            warnings.warn( "EEETauTree: Expected branch e3PhiCorrSmearedReg_2012Jul13ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3PhiCorrSmearedReg_2012Jul13ReReco")
        else:
            self.e3PhiCorrSmearedReg_2012Jul13ReReco_branch.SetAddress(<void*>&self.e3PhiCorrSmearedReg_2012Jul13ReReco_value)

        #print "making e3PhiCorrSmearedReg_Fall11"
        self.e3PhiCorrSmearedReg_Fall11_branch = the_tree.GetBranch("e3PhiCorrSmearedReg_Fall11")
        #if not self.e3PhiCorrSmearedReg_Fall11_branch and "e3PhiCorrSmearedReg_Fall11" not in self.complained:
        if not self.e3PhiCorrSmearedReg_Fall11_branch and "e3PhiCorrSmearedReg_Fall11":
            warnings.warn( "EEETauTree: Expected branch e3PhiCorrSmearedReg_Fall11 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3PhiCorrSmearedReg_Fall11")
        else:
            self.e3PhiCorrSmearedReg_Fall11_branch.SetAddress(<void*>&self.e3PhiCorrSmearedReg_Fall11_value)

        #print "making e3PhiCorrSmearedReg_Jan16ReReco"
        self.e3PhiCorrSmearedReg_Jan16ReReco_branch = the_tree.GetBranch("e3PhiCorrSmearedReg_Jan16ReReco")
        #if not self.e3PhiCorrSmearedReg_Jan16ReReco_branch and "e3PhiCorrSmearedReg_Jan16ReReco" not in self.complained:
        if not self.e3PhiCorrSmearedReg_Jan16ReReco_branch and "e3PhiCorrSmearedReg_Jan16ReReco":
            warnings.warn( "EEETauTree: Expected branch e3PhiCorrSmearedReg_Jan16ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3PhiCorrSmearedReg_Jan16ReReco")
        else:
            self.e3PhiCorrSmearedReg_Jan16ReReco_branch.SetAddress(<void*>&self.e3PhiCorrSmearedReg_Jan16ReReco_value)

        #print "making e3PhiCorrSmearedReg_Summer12_DR53X_HCP2012"
        self.e3PhiCorrSmearedReg_Summer12_DR53X_HCP2012_branch = the_tree.GetBranch("e3PhiCorrSmearedReg_Summer12_DR53X_HCP2012")
        #if not self.e3PhiCorrSmearedReg_Summer12_DR53X_HCP2012_branch and "e3PhiCorrSmearedReg_Summer12_DR53X_HCP2012" not in self.complained:
        if not self.e3PhiCorrSmearedReg_Summer12_DR53X_HCP2012_branch and "e3PhiCorrSmearedReg_Summer12_DR53X_HCP2012":
            warnings.warn( "EEETauTree: Expected branch e3PhiCorrSmearedReg_Summer12_DR53X_HCP2012 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3PhiCorrSmearedReg_Summer12_DR53X_HCP2012")
        else:
            self.e3PhiCorrSmearedReg_Summer12_DR53X_HCP2012_branch.SetAddress(<void*>&self.e3PhiCorrSmearedReg_Summer12_DR53X_HCP2012_value)

        #print "making e3Pt"
        self.e3Pt_branch = the_tree.GetBranch("e3Pt")
        #if not self.e3Pt_branch and "e3Pt" not in self.complained:
        if not self.e3Pt_branch and "e3Pt":
            warnings.warn( "EEETauTree: Expected branch e3Pt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3Pt")
        else:
            self.e3Pt_branch.SetAddress(<void*>&self.e3Pt_value)

        #print "making e3PtCorrReg_2012Jul13ReReco"
        self.e3PtCorrReg_2012Jul13ReReco_branch = the_tree.GetBranch("e3PtCorrReg_2012Jul13ReReco")
        #if not self.e3PtCorrReg_2012Jul13ReReco_branch and "e3PtCorrReg_2012Jul13ReReco" not in self.complained:
        if not self.e3PtCorrReg_2012Jul13ReReco_branch and "e3PtCorrReg_2012Jul13ReReco":
            warnings.warn( "EEETauTree: Expected branch e3PtCorrReg_2012Jul13ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3PtCorrReg_2012Jul13ReReco")
        else:
            self.e3PtCorrReg_2012Jul13ReReco_branch.SetAddress(<void*>&self.e3PtCorrReg_2012Jul13ReReco_value)

        #print "making e3PtCorrReg_Fall11"
        self.e3PtCorrReg_Fall11_branch = the_tree.GetBranch("e3PtCorrReg_Fall11")
        #if not self.e3PtCorrReg_Fall11_branch and "e3PtCorrReg_Fall11" not in self.complained:
        if not self.e3PtCorrReg_Fall11_branch and "e3PtCorrReg_Fall11":
            warnings.warn( "EEETauTree: Expected branch e3PtCorrReg_Fall11 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3PtCorrReg_Fall11")
        else:
            self.e3PtCorrReg_Fall11_branch.SetAddress(<void*>&self.e3PtCorrReg_Fall11_value)

        #print "making e3PtCorrReg_Jan16ReReco"
        self.e3PtCorrReg_Jan16ReReco_branch = the_tree.GetBranch("e3PtCorrReg_Jan16ReReco")
        #if not self.e3PtCorrReg_Jan16ReReco_branch and "e3PtCorrReg_Jan16ReReco" not in self.complained:
        if not self.e3PtCorrReg_Jan16ReReco_branch and "e3PtCorrReg_Jan16ReReco":
            warnings.warn( "EEETauTree: Expected branch e3PtCorrReg_Jan16ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3PtCorrReg_Jan16ReReco")
        else:
            self.e3PtCorrReg_Jan16ReReco_branch.SetAddress(<void*>&self.e3PtCorrReg_Jan16ReReco_value)

        #print "making e3PtCorrReg_Summer12_DR53X_HCP2012"
        self.e3PtCorrReg_Summer12_DR53X_HCP2012_branch = the_tree.GetBranch("e3PtCorrReg_Summer12_DR53X_HCP2012")
        #if not self.e3PtCorrReg_Summer12_DR53X_HCP2012_branch and "e3PtCorrReg_Summer12_DR53X_HCP2012" not in self.complained:
        if not self.e3PtCorrReg_Summer12_DR53X_HCP2012_branch and "e3PtCorrReg_Summer12_DR53X_HCP2012":
            warnings.warn( "EEETauTree: Expected branch e3PtCorrReg_Summer12_DR53X_HCP2012 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3PtCorrReg_Summer12_DR53X_HCP2012")
        else:
            self.e3PtCorrReg_Summer12_DR53X_HCP2012_branch.SetAddress(<void*>&self.e3PtCorrReg_Summer12_DR53X_HCP2012_value)

        #print "making e3PtCorrSmearedNoReg_2012Jul13ReReco"
        self.e3PtCorrSmearedNoReg_2012Jul13ReReco_branch = the_tree.GetBranch("e3PtCorrSmearedNoReg_2012Jul13ReReco")
        #if not self.e3PtCorrSmearedNoReg_2012Jul13ReReco_branch and "e3PtCorrSmearedNoReg_2012Jul13ReReco" not in self.complained:
        if not self.e3PtCorrSmearedNoReg_2012Jul13ReReco_branch and "e3PtCorrSmearedNoReg_2012Jul13ReReco":
            warnings.warn( "EEETauTree: Expected branch e3PtCorrSmearedNoReg_2012Jul13ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3PtCorrSmearedNoReg_2012Jul13ReReco")
        else:
            self.e3PtCorrSmearedNoReg_2012Jul13ReReco_branch.SetAddress(<void*>&self.e3PtCorrSmearedNoReg_2012Jul13ReReco_value)

        #print "making e3PtCorrSmearedNoReg_Fall11"
        self.e3PtCorrSmearedNoReg_Fall11_branch = the_tree.GetBranch("e3PtCorrSmearedNoReg_Fall11")
        #if not self.e3PtCorrSmearedNoReg_Fall11_branch and "e3PtCorrSmearedNoReg_Fall11" not in self.complained:
        if not self.e3PtCorrSmearedNoReg_Fall11_branch and "e3PtCorrSmearedNoReg_Fall11":
            warnings.warn( "EEETauTree: Expected branch e3PtCorrSmearedNoReg_Fall11 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3PtCorrSmearedNoReg_Fall11")
        else:
            self.e3PtCorrSmearedNoReg_Fall11_branch.SetAddress(<void*>&self.e3PtCorrSmearedNoReg_Fall11_value)

        #print "making e3PtCorrSmearedNoReg_Jan16ReReco"
        self.e3PtCorrSmearedNoReg_Jan16ReReco_branch = the_tree.GetBranch("e3PtCorrSmearedNoReg_Jan16ReReco")
        #if not self.e3PtCorrSmearedNoReg_Jan16ReReco_branch and "e3PtCorrSmearedNoReg_Jan16ReReco" not in self.complained:
        if not self.e3PtCorrSmearedNoReg_Jan16ReReco_branch and "e3PtCorrSmearedNoReg_Jan16ReReco":
            warnings.warn( "EEETauTree: Expected branch e3PtCorrSmearedNoReg_Jan16ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3PtCorrSmearedNoReg_Jan16ReReco")
        else:
            self.e3PtCorrSmearedNoReg_Jan16ReReco_branch.SetAddress(<void*>&self.e3PtCorrSmearedNoReg_Jan16ReReco_value)

        #print "making e3PtCorrSmearedNoReg_Summer12_DR53X_HCP2012"
        self.e3PtCorrSmearedNoReg_Summer12_DR53X_HCP2012_branch = the_tree.GetBranch("e3PtCorrSmearedNoReg_Summer12_DR53X_HCP2012")
        #if not self.e3PtCorrSmearedNoReg_Summer12_DR53X_HCP2012_branch and "e3PtCorrSmearedNoReg_Summer12_DR53X_HCP2012" not in self.complained:
        if not self.e3PtCorrSmearedNoReg_Summer12_DR53X_HCP2012_branch and "e3PtCorrSmearedNoReg_Summer12_DR53X_HCP2012":
            warnings.warn( "EEETauTree: Expected branch e3PtCorrSmearedNoReg_Summer12_DR53X_HCP2012 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3PtCorrSmearedNoReg_Summer12_DR53X_HCP2012")
        else:
            self.e3PtCorrSmearedNoReg_Summer12_DR53X_HCP2012_branch.SetAddress(<void*>&self.e3PtCorrSmearedNoReg_Summer12_DR53X_HCP2012_value)

        #print "making e3PtCorrSmearedReg_2012Jul13ReReco"
        self.e3PtCorrSmearedReg_2012Jul13ReReco_branch = the_tree.GetBranch("e3PtCorrSmearedReg_2012Jul13ReReco")
        #if not self.e3PtCorrSmearedReg_2012Jul13ReReco_branch and "e3PtCorrSmearedReg_2012Jul13ReReco" not in self.complained:
        if not self.e3PtCorrSmearedReg_2012Jul13ReReco_branch and "e3PtCorrSmearedReg_2012Jul13ReReco":
            warnings.warn( "EEETauTree: Expected branch e3PtCorrSmearedReg_2012Jul13ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3PtCorrSmearedReg_2012Jul13ReReco")
        else:
            self.e3PtCorrSmearedReg_2012Jul13ReReco_branch.SetAddress(<void*>&self.e3PtCorrSmearedReg_2012Jul13ReReco_value)

        #print "making e3PtCorrSmearedReg_Fall11"
        self.e3PtCorrSmearedReg_Fall11_branch = the_tree.GetBranch("e3PtCorrSmearedReg_Fall11")
        #if not self.e3PtCorrSmearedReg_Fall11_branch and "e3PtCorrSmearedReg_Fall11" not in self.complained:
        if not self.e3PtCorrSmearedReg_Fall11_branch and "e3PtCorrSmearedReg_Fall11":
            warnings.warn( "EEETauTree: Expected branch e3PtCorrSmearedReg_Fall11 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3PtCorrSmearedReg_Fall11")
        else:
            self.e3PtCorrSmearedReg_Fall11_branch.SetAddress(<void*>&self.e3PtCorrSmearedReg_Fall11_value)

        #print "making e3PtCorrSmearedReg_Jan16ReReco"
        self.e3PtCorrSmearedReg_Jan16ReReco_branch = the_tree.GetBranch("e3PtCorrSmearedReg_Jan16ReReco")
        #if not self.e3PtCorrSmearedReg_Jan16ReReco_branch and "e3PtCorrSmearedReg_Jan16ReReco" not in self.complained:
        if not self.e3PtCorrSmearedReg_Jan16ReReco_branch and "e3PtCorrSmearedReg_Jan16ReReco":
            warnings.warn( "EEETauTree: Expected branch e3PtCorrSmearedReg_Jan16ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3PtCorrSmearedReg_Jan16ReReco")
        else:
            self.e3PtCorrSmearedReg_Jan16ReReco_branch.SetAddress(<void*>&self.e3PtCorrSmearedReg_Jan16ReReco_value)

        #print "making e3PtCorrSmearedReg_Summer12_DR53X_HCP2012"
        self.e3PtCorrSmearedReg_Summer12_DR53X_HCP2012_branch = the_tree.GetBranch("e3PtCorrSmearedReg_Summer12_DR53X_HCP2012")
        #if not self.e3PtCorrSmearedReg_Summer12_DR53X_HCP2012_branch and "e3PtCorrSmearedReg_Summer12_DR53X_HCP2012" not in self.complained:
        if not self.e3PtCorrSmearedReg_Summer12_DR53X_HCP2012_branch and "e3PtCorrSmearedReg_Summer12_DR53X_HCP2012":
            warnings.warn( "EEETauTree: Expected branch e3PtCorrSmearedReg_Summer12_DR53X_HCP2012 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3PtCorrSmearedReg_Summer12_DR53X_HCP2012")
        else:
            self.e3PtCorrSmearedReg_Summer12_DR53X_HCP2012_branch.SetAddress(<void*>&self.e3PtCorrSmearedReg_Summer12_DR53X_HCP2012_value)

        #print "making e3Rank"
        self.e3Rank_branch = the_tree.GetBranch("e3Rank")
        #if not self.e3Rank_branch and "e3Rank" not in self.complained:
        if not self.e3Rank_branch and "e3Rank":
            warnings.warn( "EEETauTree: Expected branch e3Rank does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3Rank")
        else:
            self.e3Rank_branch.SetAddress(<void*>&self.e3Rank_value)

        #print "making e3RelIso"
        self.e3RelIso_branch = the_tree.GetBranch("e3RelIso")
        #if not self.e3RelIso_branch and "e3RelIso" not in self.complained:
        if not self.e3RelIso_branch and "e3RelIso":
            warnings.warn( "EEETauTree: Expected branch e3RelIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3RelIso")
        else:
            self.e3RelIso_branch.SetAddress(<void*>&self.e3RelIso_value)

        #print "making e3RelPFIsoDB"
        self.e3RelPFIsoDB_branch = the_tree.GetBranch("e3RelPFIsoDB")
        #if not self.e3RelPFIsoDB_branch and "e3RelPFIsoDB" not in self.complained:
        if not self.e3RelPFIsoDB_branch and "e3RelPFIsoDB":
            warnings.warn( "EEETauTree: Expected branch e3RelPFIsoDB does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3RelPFIsoDB")
        else:
            self.e3RelPFIsoDB_branch.SetAddress(<void*>&self.e3RelPFIsoDB_value)

        #print "making e3RelPFIsoRho"
        self.e3RelPFIsoRho_branch = the_tree.GetBranch("e3RelPFIsoRho")
        #if not self.e3RelPFIsoRho_branch and "e3RelPFIsoRho" not in self.complained:
        if not self.e3RelPFIsoRho_branch and "e3RelPFIsoRho":
            warnings.warn( "EEETauTree: Expected branch e3RelPFIsoRho does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3RelPFIsoRho")
        else:
            self.e3RelPFIsoRho_branch.SetAddress(<void*>&self.e3RelPFIsoRho_value)

        #print "making e3RelPFIsoRhoFSR"
        self.e3RelPFIsoRhoFSR_branch = the_tree.GetBranch("e3RelPFIsoRhoFSR")
        #if not self.e3RelPFIsoRhoFSR_branch and "e3RelPFIsoRhoFSR" not in self.complained:
        if not self.e3RelPFIsoRhoFSR_branch and "e3RelPFIsoRhoFSR":
            warnings.warn( "EEETauTree: Expected branch e3RelPFIsoRhoFSR does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3RelPFIsoRhoFSR")
        else:
            self.e3RelPFIsoRhoFSR_branch.SetAddress(<void*>&self.e3RelPFIsoRhoFSR_value)

        #print "making e3RhoHZG2011"
        self.e3RhoHZG2011_branch = the_tree.GetBranch("e3RhoHZG2011")
        #if not self.e3RhoHZG2011_branch and "e3RhoHZG2011" not in self.complained:
        if not self.e3RhoHZG2011_branch and "e3RhoHZG2011":
            warnings.warn( "EEETauTree: Expected branch e3RhoHZG2011 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3RhoHZG2011")
        else:
            self.e3RhoHZG2011_branch.SetAddress(<void*>&self.e3RhoHZG2011_value)

        #print "making e3RhoHZG2012"
        self.e3RhoHZG2012_branch = the_tree.GetBranch("e3RhoHZG2012")
        #if not self.e3RhoHZG2012_branch and "e3RhoHZG2012" not in self.complained:
        if not self.e3RhoHZG2012_branch and "e3RhoHZG2012":
            warnings.warn( "EEETauTree: Expected branch e3RhoHZG2012 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3RhoHZG2012")
        else:
            self.e3RhoHZG2012_branch.SetAddress(<void*>&self.e3RhoHZG2012_value)

        #print "making e3SCEnergy"
        self.e3SCEnergy_branch = the_tree.GetBranch("e3SCEnergy")
        #if not self.e3SCEnergy_branch and "e3SCEnergy" not in self.complained:
        if not self.e3SCEnergy_branch and "e3SCEnergy":
            warnings.warn( "EEETauTree: Expected branch e3SCEnergy does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3SCEnergy")
        else:
            self.e3SCEnergy_branch.SetAddress(<void*>&self.e3SCEnergy_value)

        #print "making e3SCEta"
        self.e3SCEta_branch = the_tree.GetBranch("e3SCEta")
        #if not self.e3SCEta_branch and "e3SCEta" not in self.complained:
        if not self.e3SCEta_branch and "e3SCEta":
            warnings.warn( "EEETauTree: Expected branch e3SCEta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3SCEta")
        else:
            self.e3SCEta_branch.SetAddress(<void*>&self.e3SCEta_value)

        #print "making e3SCEtaWidth"
        self.e3SCEtaWidth_branch = the_tree.GetBranch("e3SCEtaWidth")
        #if not self.e3SCEtaWidth_branch and "e3SCEtaWidth" not in self.complained:
        if not self.e3SCEtaWidth_branch and "e3SCEtaWidth":
            warnings.warn( "EEETauTree: Expected branch e3SCEtaWidth does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3SCEtaWidth")
        else:
            self.e3SCEtaWidth_branch.SetAddress(<void*>&self.e3SCEtaWidth_value)

        #print "making e3SCPhi"
        self.e3SCPhi_branch = the_tree.GetBranch("e3SCPhi")
        #if not self.e3SCPhi_branch and "e3SCPhi" not in self.complained:
        if not self.e3SCPhi_branch and "e3SCPhi":
            warnings.warn( "EEETauTree: Expected branch e3SCPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3SCPhi")
        else:
            self.e3SCPhi_branch.SetAddress(<void*>&self.e3SCPhi_value)

        #print "making e3SCPhiWidth"
        self.e3SCPhiWidth_branch = the_tree.GetBranch("e3SCPhiWidth")
        #if not self.e3SCPhiWidth_branch and "e3SCPhiWidth" not in self.complained:
        if not self.e3SCPhiWidth_branch and "e3SCPhiWidth":
            warnings.warn( "EEETauTree: Expected branch e3SCPhiWidth does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3SCPhiWidth")
        else:
            self.e3SCPhiWidth_branch.SetAddress(<void*>&self.e3SCPhiWidth_value)

        #print "making e3SCPreshowerEnergy"
        self.e3SCPreshowerEnergy_branch = the_tree.GetBranch("e3SCPreshowerEnergy")
        #if not self.e3SCPreshowerEnergy_branch and "e3SCPreshowerEnergy" not in self.complained:
        if not self.e3SCPreshowerEnergy_branch and "e3SCPreshowerEnergy":
            warnings.warn( "EEETauTree: Expected branch e3SCPreshowerEnergy does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3SCPreshowerEnergy")
        else:
            self.e3SCPreshowerEnergy_branch.SetAddress(<void*>&self.e3SCPreshowerEnergy_value)

        #print "making e3SCRawEnergy"
        self.e3SCRawEnergy_branch = the_tree.GetBranch("e3SCRawEnergy")
        #if not self.e3SCRawEnergy_branch and "e3SCRawEnergy" not in self.complained:
        if not self.e3SCRawEnergy_branch and "e3SCRawEnergy":
            warnings.warn( "EEETauTree: Expected branch e3SCRawEnergy does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3SCRawEnergy")
        else:
            self.e3SCRawEnergy_branch.SetAddress(<void*>&self.e3SCRawEnergy_value)

        #print "making e3SigmaIEtaIEta"
        self.e3SigmaIEtaIEta_branch = the_tree.GetBranch("e3SigmaIEtaIEta")
        #if not self.e3SigmaIEtaIEta_branch and "e3SigmaIEtaIEta" not in self.complained:
        if not self.e3SigmaIEtaIEta_branch and "e3SigmaIEtaIEta":
            warnings.warn( "EEETauTree: Expected branch e3SigmaIEtaIEta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3SigmaIEtaIEta")
        else:
            self.e3SigmaIEtaIEta_branch.SetAddress(<void*>&self.e3SigmaIEtaIEta_value)

        #print "making e3ToMETDPhi"
        self.e3ToMETDPhi_branch = the_tree.GetBranch("e3ToMETDPhi")
        #if not self.e3ToMETDPhi_branch and "e3ToMETDPhi" not in self.complained:
        if not self.e3ToMETDPhi_branch and "e3ToMETDPhi":
            warnings.warn( "EEETauTree: Expected branch e3ToMETDPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3ToMETDPhi")
        else:
            self.e3ToMETDPhi_branch.SetAddress(<void*>&self.e3ToMETDPhi_value)

        #print "making e3TrkIsoDR03"
        self.e3TrkIsoDR03_branch = the_tree.GetBranch("e3TrkIsoDR03")
        #if not self.e3TrkIsoDR03_branch and "e3TrkIsoDR03" not in self.complained:
        if not self.e3TrkIsoDR03_branch and "e3TrkIsoDR03":
            warnings.warn( "EEETauTree: Expected branch e3TrkIsoDR03 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3TrkIsoDR03")
        else:
            self.e3TrkIsoDR03_branch.SetAddress(<void*>&self.e3TrkIsoDR03_value)

        #print "making e3VZ"
        self.e3VZ_branch = the_tree.GetBranch("e3VZ")
        #if not self.e3VZ_branch and "e3VZ" not in self.complained:
        if not self.e3VZ_branch and "e3VZ":
            warnings.warn( "EEETauTree: Expected branch e3VZ does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3VZ")
        else:
            self.e3VZ_branch.SetAddress(<void*>&self.e3VZ_value)

        #print "making e3WWID"
        self.e3WWID_branch = the_tree.GetBranch("e3WWID")
        #if not self.e3WWID_branch and "e3WWID" not in self.complained:
        if not self.e3WWID_branch and "e3WWID":
            warnings.warn( "EEETauTree: Expected branch e3WWID does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3WWID")
        else:
            self.e3WWID_branch.SetAddress(<void*>&self.e3WWID_value)

        #print "making e3_t_CosThetaStar"
        self.e3_t_CosThetaStar_branch = the_tree.GetBranch("e3_t_CosThetaStar")
        #if not self.e3_t_CosThetaStar_branch and "e3_t_CosThetaStar" not in self.complained:
        if not self.e3_t_CosThetaStar_branch and "e3_t_CosThetaStar":
            warnings.warn( "EEETauTree: Expected branch e3_t_CosThetaStar does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3_t_CosThetaStar")
        else:
            self.e3_t_CosThetaStar_branch.SetAddress(<void*>&self.e3_t_CosThetaStar_value)

        #print "making e3_t_DPhi"
        self.e3_t_DPhi_branch = the_tree.GetBranch("e3_t_DPhi")
        #if not self.e3_t_DPhi_branch and "e3_t_DPhi" not in self.complained:
        if not self.e3_t_DPhi_branch and "e3_t_DPhi":
            warnings.warn( "EEETauTree: Expected branch e3_t_DPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3_t_DPhi")
        else:
            self.e3_t_DPhi_branch.SetAddress(<void*>&self.e3_t_DPhi_value)

        #print "making e3_t_DR"
        self.e3_t_DR_branch = the_tree.GetBranch("e3_t_DR")
        #if not self.e3_t_DR_branch and "e3_t_DR" not in self.complained:
        if not self.e3_t_DR_branch and "e3_t_DR":
            warnings.warn( "EEETauTree: Expected branch e3_t_DR does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3_t_DR")
        else:
            self.e3_t_DR_branch.SetAddress(<void*>&self.e3_t_DR_value)

        #print "making e3_t_Eta"
        self.e3_t_Eta_branch = the_tree.GetBranch("e3_t_Eta")
        #if not self.e3_t_Eta_branch and "e3_t_Eta" not in self.complained:
        if not self.e3_t_Eta_branch and "e3_t_Eta":
            warnings.warn( "EEETauTree: Expected branch e3_t_Eta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3_t_Eta")
        else:
            self.e3_t_Eta_branch.SetAddress(<void*>&self.e3_t_Eta_value)

        #print "making e3_t_Mass"
        self.e3_t_Mass_branch = the_tree.GetBranch("e3_t_Mass")
        #if not self.e3_t_Mass_branch and "e3_t_Mass" not in self.complained:
        if not self.e3_t_Mass_branch and "e3_t_Mass":
            warnings.warn( "EEETauTree: Expected branch e3_t_Mass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3_t_Mass")
        else:
            self.e3_t_Mass_branch.SetAddress(<void*>&self.e3_t_Mass_value)

        #print "making e3_t_MassFsr"
        self.e3_t_MassFsr_branch = the_tree.GetBranch("e3_t_MassFsr")
        #if not self.e3_t_MassFsr_branch and "e3_t_MassFsr" not in self.complained:
        if not self.e3_t_MassFsr_branch and "e3_t_MassFsr":
            warnings.warn( "EEETauTree: Expected branch e3_t_MassFsr does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3_t_MassFsr")
        else:
            self.e3_t_MassFsr_branch.SetAddress(<void*>&self.e3_t_MassFsr_value)

        #print "making e3_t_PZeta"
        self.e3_t_PZeta_branch = the_tree.GetBranch("e3_t_PZeta")
        #if not self.e3_t_PZeta_branch and "e3_t_PZeta" not in self.complained:
        if not self.e3_t_PZeta_branch and "e3_t_PZeta":
            warnings.warn( "EEETauTree: Expected branch e3_t_PZeta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3_t_PZeta")
        else:
            self.e3_t_PZeta_branch.SetAddress(<void*>&self.e3_t_PZeta_value)

        #print "making e3_t_PZetaVis"
        self.e3_t_PZetaVis_branch = the_tree.GetBranch("e3_t_PZetaVis")
        #if not self.e3_t_PZetaVis_branch and "e3_t_PZetaVis" not in self.complained:
        if not self.e3_t_PZetaVis_branch and "e3_t_PZetaVis":
            warnings.warn( "EEETauTree: Expected branch e3_t_PZetaVis does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3_t_PZetaVis")
        else:
            self.e3_t_PZetaVis_branch.SetAddress(<void*>&self.e3_t_PZetaVis_value)

        #print "making e3_t_Phi"
        self.e3_t_Phi_branch = the_tree.GetBranch("e3_t_Phi")
        #if not self.e3_t_Phi_branch and "e3_t_Phi" not in self.complained:
        if not self.e3_t_Phi_branch and "e3_t_Phi":
            warnings.warn( "EEETauTree: Expected branch e3_t_Phi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3_t_Phi")
        else:
            self.e3_t_Phi_branch.SetAddress(<void*>&self.e3_t_Phi_value)

        #print "making e3_t_Pt"
        self.e3_t_Pt_branch = the_tree.GetBranch("e3_t_Pt")
        #if not self.e3_t_Pt_branch and "e3_t_Pt" not in self.complained:
        if not self.e3_t_Pt_branch and "e3_t_Pt":
            warnings.warn( "EEETauTree: Expected branch e3_t_Pt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3_t_Pt")
        else:
            self.e3_t_Pt_branch.SetAddress(<void*>&self.e3_t_Pt_value)

        #print "making e3_t_PtFsr"
        self.e3_t_PtFsr_branch = the_tree.GetBranch("e3_t_PtFsr")
        #if not self.e3_t_PtFsr_branch and "e3_t_PtFsr" not in self.complained:
        if not self.e3_t_PtFsr_branch and "e3_t_PtFsr":
            warnings.warn( "EEETauTree: Expected branch e3_t_PtFsr does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3_t_PtFsr")
        else:
            self.e3_t_PtFsr_branch.SetAddress(<void*>&self.e3_t_PtFsr_value)

        #print "making e3_t_SS"
        self.e3_t_SS_branch = the_tree.GetBranch("e3_t_SS")
        #if not self.e3_t_SS_branch and "e3_t_SS" not in self.complained:
        if not self.e3_t_SS_branch and "e3_t_SS":
            warnings.warn( "EEETauTree: Expected branch e3_t_SS does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3_t_SS")
        else:
            self.e3_t_SS_branch.SetAddress(<void*>&self.e3_t_SS_value)

        #print "making e3_t_SVfitEta"
        self.e3_t_SVfitEta_branch = the_tree.GetBranch("e3_t_SVfitEta")
        #if not self.e3_t_SVfitEta_branch and "e3_t_SVfitEta" not in self.complained:
        if not self.e3_t_SVfitEta_branch and "e3_t_SVfitEta":
            warnings.warn( "EEETauTree: Expected branch e3_t_SVfitEta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3_t_SVfitEta")
        else:
            self.e3_t_SVfitEta_branch.SetAddress(<void*>&self.e3_t_SVfitEta_value)

        #print "making e3_t_SVfitMass"
        self.e3_t_SVfitMass_branch = the_tree.GetBranch("e3_t_SVfitMass")
        #if not self.e3_t_SVfitMass_branch and "e3_t_SVfitMass" not in self.complained:
        if not self.e3_t_SVfitMass_branch and "e3_t_SVfitMass":
            warnings.warn( "EEETauTree: Expected branch e3_t_SVfitMass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3_t_SVfitMass")
        else:
            self.e3_t_SVfitMass_branch.SetAddress(<void*>&self.e3_t_SVfitMass_value)

        #print "making e3_t_SVfitPhi"
        self.e3_t_SVfitPhi_branch = the_tree.GetBranch("e3_t_SVfitPhi")
        #if not self.e3_t_SVfitPhi_branch and "e3_t_SVfitPhi" not in self.complained:
        if not self.e3_t_SVfitPhi_branch and "e3_t_SVfitPhi":
            warnings.warn( "EEETauTree: Expected branch e3_t_SVfitPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3_t_SVfitPhi")
        else:
            self.e3_t_SVfitPhi_branch.SetAddress(<void*>&self.e3_t_SVfitPhi_value)

        #print "making e3_t_SVfitPt"
        self.e3_t_SVfitPt_branch = the_tree.GetBranch("e3_t_SVfitPt")
        #if not self.e3_t_SVfitPt_branch and "e3_t_SVfitPt" not in self.complained:
        if not self.e3_t_SVfitPt_branch and "e3_t_SVfitPt":
            warnings.warn( "EEETauTree: Expected branch e3_t_SVfitPt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3_t_SVfitPt")
        else:
            self.e3_t_SVfitPt_branch.SetAddress(<void*>&self.e3_t_SVfitPt_value)

        #print "making e3_t_ToMETDPhi_Ty1"
        self.e3_t_ToMETDPhi_Ty1_branch = the_tree.GetBranch("e3_t_ToMETDPhi_Ty1")
        #if not self.e3_t_ToMETDPhi_Ty1_branch and "e3_t_ToMETDPhi_Ty1" not in self.complained:
        if not self.e3_t_ToMETDPhi_Ty1_branch and "e3_t_ToMETDPhi_Ty1":
            warnings.warn( "EEETauTree: Expected branch e3_t_ToMETDPhi_Ty1 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3_t_ToMETDPhi_Ty1")
        else:
            self.e3_t_ToMETDPhi_Ty1_branch.SetAddress(<void*>&self.e3_t_ToMETDPhi_Ty1_value)

        #print "making e3_t_Zcompat"
        self.e3_t_Zcompat_branch = the_tree.GetBranch("e3_t_Zcompat")
        #if not self.e3_t_Zcompat_branch and "e3_t_Zcompat" not in self.complained:
        if not self.e3_t_Zcompat_branch and "e3_t_Zcompat":
            warnings.warn( "EEETauTree: Expected branch e3_t_Zcompat does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3_t_Zcompat")
        else:
            self.e3_t_Zcompat_branch.SetAddress(<void*>&self.e3_t_Zcompat_value)

        #print "making e3dECorrReg_2012Jul13ReReco"
        self.e3dECorrReg_2012Jul13ReReco_branch = the_tree.GetBranch("e3dECorrReg_2012Jul13ReReco")
        #if not self.e3dECorrReg_2012Jul13ReReco_branch and "e3dECorrReg_2012Jul13ReReco" not in self.complained:
        if not self.e3dECorrReg_2012Jul13ReReco_branch and "e3dECorrReg_2012Jul13ReReco":
            warnings.warn( "EEETauTree: Expected branch e3dECorrReg_2012Jul13ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3dECorrReg_2012Jul13ReReco")
        else:
            self.e3dECorrReg_2012Jul13ReReco_branch.SetAddress(<void*>&self.e3dECorrReg_2012Jul13ReReco_value)

        #print "making e3dECorrReg_Fall11"
        self.e3dECorrReg_Fall11_branch = the_tree.GetBranch("e3dECorrReg_Fall11")
        #if not self.e3dECorrReg_Fall11_branch and "e3dECorrReg_Fall11" not in self.complained:
        if not self.e3dECorrReg_Fall11_branch and "e3dECorrReg_Fall11":
            warnings.warn( "EEETauTree: Expected branch e3dECorrReg_Fall11 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3dECorrReg_Fall11")
        else:
            self.e3dECorrReg_Fall11_branch.SetAddress(<void*>&self.e3dECorrReg_Fall11_value)

        #print "making e3dECorrReg_Jan16ReReco"
        self.e3dECorrReg_Jan16ReReco_branch = the_tree.GetBranch("e3dECorrReg_Jan16ReReco")
        #if not self.e3dECorrReg_Jan16ReReco_branch and "e3dECorrReg_Jan16ReReco" not in self.complained:
        if not self.e3dECorrReg_Jan16ReReco_branch and "e3dECorrReg_Jan16ReReco":
            warnings.warn( "EEETauTree: Expected branch e3dECorrReg_Jan16ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3dECorrReg_Jan16ReReco")
        else:
            self.e3dECorrReg_Jan16ReReco_branch.SetAddress(<void*>&self.e3dECorrReg_Jan16ReReco_value)

        #print "making e3dECorrReg_Summer12_DR53X_HCP2012"
        self.e3dECorrReg_Summer12_DR53X_HCP2012_branch = the_tree.GetBranch("e3dECorrReg_Summer12_DR53X_HCP2012")
        #if not self.e3dECorrReg_Summer12_DR53X_HCP2012_branch and "e3dECorrReg_Summer12_DR53X_HCP2012" not in self.complained:
        if not self.e3dECorrReg_Summer12_DR53X_HCP2012_branch and "e3dECorrReg_Summer12_DR53X_HCP2012":
            warnings.warn( "EEETauTree: Expected branch e3dECorrReg_Summer12_DR53X_HCP2012 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3dECorrReg_Summer12_DR53X_HCP2012")
        else:
            self.e3dECorrReg_Summer12_DR53X_HCP2012_branch.SetAddress(<void*>&self.e3dECorrReg_Summer12_DR53X_HCP2012_value)

        #print "making e3dECorrSmearedNoReg_2012Jul13ReReco"
        self.e3dECorrSmearedNoReg_2012Jul13ReReco_branch = the_tree.GetBranch("e3dECorrSmearedNoReg_2012Jul13ReReco")
        #if not self.e3dECorrSmearedNoReg_2012Jul13ReReco_branch and "e3dECorrSmearedNoReg_2012Jul13ReReco" not in self.complained:
        if not self.e3dECorrSmearedNoReg_2012Jul13ReReco_branch and "e3dECorrSmearedNoReg_2012Jul13ReReco":
            warnings.warn( "EEETauTree: Expected branch e3dECorrSmearedNoReg_2012Jul13ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3dECorrSmearedNoReg_2012Jul13ReReco")
        else:
            self.e3dECorrSmearedNoReg_2012Jul13ReReco_branch.SetAddress(<void*>&self.e3dECorrSmearedNoReg_2012Jul13ReReco_value)

        #print "making e3dECorrSmearedNoReg_Fall11"
        self.e3dECorrSmearedNoReg_Fall11_branch = the_tree.GetBranch("e3dECorrSmearedNoReg_Fall11")
        #if not self.e3dECorrSmearedNoReg_Fall11_branch and "e3dECorrSmearedNoReg_Fall11" not in self.complained:
        if not self.e3dECorrSmearedNoReg_Fall11_branch and "e3dECorrSmearedNoReg_Fall11":
            warnings.warn( "EEETauTree: Expected branch e3dECorrSmearedNoReg_Fall11 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3dECorrSmearedNoReg_Fall11")
        else:
            self.e3dECorrSmearedNoReg_Fall11_branch.SetAddress(<void*>&self.e3dECorrSmearedNoReg_Fall11_value)

        #print "making e3dECorrSmearedNoReg_Jan16ReReco"
        self.e3dECorrSmearedNoReg_Jan16ReReco_branch = the_tree.GetBranch("e3dECorrSmearedNoReg_Jan16ReReco")
        #if not self.e3dECorrSmearedNoReg_Jan16ReReco_branch and "e3dECorrSmearedNoReg_Jan16ReReco" not in self.complained:
        if not self.e3dECorrSmearedNoReg_Jan16ReReco_branch and "e3dECorrSmearedNoReg_Jan16ReReco":
            warnings.warn( "EEETauTree: Expected branch e3dECorrSmearedNoReg_Jan16ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3dECorrSmearedNoReg_Jan16ReReco")
        else:
            self.e3dECorrSmearedNoReg_Jan16ReReco_branch.SetAddress(<void*>&self.e3dECorrSmearedNoReg_Jan16ReReco_value)

        #print "making e3dECorrSmearedNoReg_Summer12_DR53X_HCP2012"
        self.e3dECorrSmearedNoReg_Summer12_DR53X_HCP2012_branch = the_tree.GetBranch("e3dECorrSmearedNoReg_Summer12_DR53X_HCP2012")
        #if not self.e3dECorrSmearedNoReg_Summer12_DR53X_HCP2012_branch and "e3dECorrSmearedNoReg_Summer12_DR53X_HCP2012" not in self.complained:
        if not self.e3dECorrSmearedNoReg_Summer12_DR53X_HCP2012_branch and "e3dECorrSmearedNoReg_Summer12_DR53X_HCP2012":
            warnings.warn( "EEETauTree: Expected branch e3dECorrSmearedNoReg_Summer12_DR53X_HCP2012 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3dECorrSmearedNoReg_Summer12_DR53X_HCP2012")
        else:
            self.e3dECorrSmearedNoReg_Summer12_DR53X_HCP2012_branch.SetAddress(<void*>&self.e3dECorrSmearedNoReg_Summer12_DR53X_HCP2012_value)

        #print "making e3dECorrSmearedReg_2012Jul13ReReco"
        self.e3dECorrSmearedReg_2012Jul13ReReco_branch = the_tree.GetBranch("e3dECorrSmearedReg_2012Jul13ReReco")
        #if not self.e3dECorrSmearedReg_2012Jul13ReReco_branch and "e3dECorrSmearedReg_2012Jul13ReReco" not in self.complained:
        if not self.e3dECorrSmearedReg_2012Jul13ReReco_branch and "e3dECorrSmearedReg_2012Jul13ReReco":
            warnings.warn( "EEETauTree: Expected branch e3dECorrSmearedReg_2012Jul13ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3dECorrSmearedReg_2012Jul13ReReco")
        else:
            self.e3dECorrSmearedReg_2012Jul13ReReco_branch.SetAddress(<void*>&self.e3dECorrSmearedReg_2012Jul13ReReco_value)

        #print "making e3dECorrSmearedReg_Fall11"
        self.e3dECorrSmearedReg_Fall11_branch = the_tree.GetBranch("e3dECorrSmearedReg_Fall11")
        #if not self.e3dECorrSmearedReg_Fall11_branch and "e3dECorrSmearedReg_Fall11" not in self.complained:
        if not self.e3dECorrSmearedReg_Fall11_branch and "e3dECorrSmearedReg_Fall11":
            warnings.warn( "EEETauTree: Expected branch e3dECorrSmearedReg_Fall11 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3dECorrSmearedReg_Fall11")
        else:
            self.e3dECorrSmearedReg_Fall11_branch.SetAddress(<void*>&self.e3dECorrSmearedReg_Fall11_value)

        #print "making e3dECorrSmearedReg_Jan16ReReco"
        self.e3dECorrSmearedReg_Jan16ReReco_branch = the_tree.GetBranch("e3dECorrSmearedReg_Jan16ReReco")
        #if not self.e3dECorrSmearedReg_Jan16ReReco_branch and "e3dECorrSmearedReg_Jan16ReReco" not in self.complained:
        if not self.e3dECorrSmearedReg_Jan16ReReco_branch and "e3dECorrSmearedReg_Jan16ReReco":
            warnings.warn( "EEETauTree: Expected branch e3dECorrSmearedReg_Jan16ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3dECorrSmearedReg_Jan16ReReco")
        else:
            self.e3dECorrSmearedReg_Jan16ReReco_branch.SetAddress(<void*>&self.e3dECorrSmearedReg_Jan16ReReco_value)

        #print "making e3dECorrSmearedReg_Summer12_DR53X_HCP2012"
        self.e3dECorrSmearedReg_Summer12_DR53X_HCP2012_branch = the_tree.GetBranch("e3dECorrSmearedReg_Summer12_DR53X_HCP2012")
        #if not self.e3dECorrSmearedReg_Summer12_DR53X_HCP2012_branch and "e3dECorrSmearedReg_Summer12_DR53X_HCP2012" not in self.complained:
        if not self.e3dECorrSmearedReg_Summer12_DR53X_HCP2012_branch and "e3dECorrSmearedReg_Summer12_DR53X_HCP2012":
            warnings.warn( "EEETauTree: Expected branch e3dECorrSmearedReg_Summer12_DR53X_HCP2012 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3dECorrSmearedReg_Summer12_DR53X_HCP2012")
        else:
            self.e3dECorrSmearedReg_Summer12_DR53X_HCP2012_branch.SetAddress(<void*>&self.e3dECorrSmearedReg_Summer12_DR53X_HCP2012_value)

        #print "making e3deltaEtaSuperClusterTrackAtVtx"
        self.e3deltaEtaSuperClusterTrackAtVtx_branch = the_tree.GetBranch("e3deltaEtaSuperClusterTrackAtVtx")
        #if not self.e3deltaEtaSuperClusterTrackAtVtx_branch and "e3deltaEtaSuperClusterTrackAtVtx" not in self.complained:
        if not self.e3deltaEtaSuperClusterTrackAtVtx_branch and "e3deltaEtaSuperClusterTrackAtVtx":
            warnings.warn( "EEETauTree: Expected branch e3deltaEtaSuperClusterTrackAtVtx does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3deltaEtaSuperClusterTrackAtVtx")
        else:
            self.e3deltaEtaSuperClusterTrackAtVtx_branch.SetAddress(<void*>&self.e3deltaEtaSuperClusterTrackAtVtx_value)

        #print "making e3deltaPhiSuperClusterTrackAtVtx"
        self.e3deltaPhiSuperClusterTrackAtVtx_branch = the_tree.GetBranch("e3deltaPhiSuperClusterTrackAtVtx")
        #if not self.e3deltaPhiSuperClusterTrackAtVtx_branch and "e3deltaPhiSuperClusterTrackAtVtx" not in self.complained:
        if not self.e3deltaPhiSuperClusterTrackAtVtx_branch and "e3deltaPhiSuperClusterTrackAtVtx":
            warnings.warn( "EEETauTree: Expected branch e3deltaPhiSuperClusterTrackAtVtx does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3deltaPhiSuperClusterTrackAtVtx")
        else:
            self.e3deltaPhiSuperClusterTrackAtVtx_branch.SetAddress(<void*>&self.e3deltaPhiSuperClusterTrackAtVtx_value)

        #print "making e3eSuperClusterOverP"
        self.e3eSuperClusterOverP_branch = the_tree.GetBranch("e3eSuperClusterOverP")
        #if not self.e3eSuperClusterOverP_branch and "e3eSuperClusterOverP" not in self.complained:
        if not self.e3eSuperClusterOverP_branch and "e3eSuperClusterOverP":
            warnings.warn( "EEETauTree: Expected branch e3eSuperClusterOverP does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3eSuperClusterOverP")
        else:
            self.e3eSuperClusterOverP_branch.SetAddress(<void*>&self.e3eSuperClusterOverP_value)

        #print "making e3ecalEnergy"
        self.e3ecalEnergy_branch = the_tree.GetBranch("e3ecalEnergy")
        #if not self.e3ecalEnergy_branch and "e3ecalEnergy" not in self.complained:
        if not self.e3ecalEnergy_branch and "e3ecalEnergy":
            warnings.warn( "EEETauTree: Expected branch e3ecalEnergy does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3ecalEnergy")
        else:
            self.e3ecalEnergy_branch.SetAddress(<void*>&self.e3ecalEnergy_value)

        #print "making e3fBrem"
        self.e3fBrem_branch = the_tree.GetBranch("e3fBrem")
        #if not self.e3fBrem_branch and "e3fBrem" not in self.complained:
        if not self.e3fBrem_branch and "e3fBrem":
            warnings.warn( "EEETauTree: Expected branch e3fBrem does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3fBrem")
        else:
            self.e3fBrem_branch.SetAddress(<void*>&self.e3fBrem_value)

        #print "making e3trackMomentumAtVtxP"
        self.e3trackMomentumAtVtxP_branch = the_tree.GetBranch("e3trackMomentumAtVtxP")
        #if not self.e3trackMomentumAtVtxP_branch and "e3trackMomentumAtVtxP" not in self.complained:
        if not self.e3trackMomentumAtVtxP_branch and "e3trackMomentumAtVtxP":
            warnings.warn( "EEETauTree: Expected branch e3trackMomentumAtVtxP does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3trackMomentumAtVtxP")
        else:
            self.e3trackMomentumAtVtxP_branch.SetAddress(<void*>&self.e3trackMomentumAtVtxP_value)

        #print "making eTightCountZH"
        self.eTightCountZH_branch = the_tree.GetBranch("eTightCountZH")
        #if not self.eTightCountZH_branch and "eTightCountZH" not in self.complained:
        if not self.eTightCountZH_branch and "eTightCountZH":
            warnings.warn( "EEETauTree: Expected branch eTightCountZH does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eTightCountZH")
        else:
            self.eTightCountZH_branch.SetAddress(<void*>&self.eTightCountZH_value)

        #print "making eVetoCicTightIso"
        self.eVetoCicTightIso_branch = the_tree.GetBranch("eVetoCicTightIso")
        #if not self.eVetoCicTightIso_branch and "eVetoCicTightIso" not in self.complained:
        if not self.eVetoCicTightIso_branch and "eVetoCicTightIso":
            warnings.warn( "EEETauTree: Expected branch eVetoCicTightIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eVetoCicTightIso")
        else:
            self.eVetoCicTightIso_branch.SetAddress(<void*>&self.eVetoCicTightIso_value)

        #print "making eVetoMVAIso"
        self.eVetoMVAIso_branch = the_tree.GetBranch("eVetoMVAIso")
        #if not self.eVetoMVAIso_branch and "eVetoMVAIso" not in self.complained:
        if not self.eVetoMVAIso_branch and "eVetoMVAIso":
            warnings.warn( "EEETauTree: Expected branch eVetoMVAIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eVetoMVAIso")
        else:
            self.eVetoMVAIso_branch.SetAddress(<void*>&self.eVetoMVAIso_value)

        #print "making eVetoMVAIsoVtx"
        self.eVetoMVAIsoVtx_branch = the_tree.GetBranch("eVetoMVAIsoVtx")
        #if not self.eVetoMVAIsoVtx_branch and "eVetoMVAIsoVtx" not in self.complained:
        if not self.eVetoMVAIsoVtx_branch and "eVetoMVAIsoVtx":
            warnings.warn( "EEETauTree: Expected branch eVetoMVAIsoVtx does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eVetoMVAIsoVtx")
        else:
            self.eVetoMVAIsoVtx_branch.SetAddress(<void*>&self.eVetoMVAIsoVtx_value)

        #print "making eVetoZH"
        self.eVetoZH_branch = the_tree.GetBranch("eVetoZH")
        #if not self.eVetoZH_branch and "eVetoZH" not in self.complained:
        if not self.eVetoZH_branch and "eVetoZH":
            warnings.warn( "EEETauTree: Expected branch eVetoZH does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eVetoZH")
        else:
            self.eVetoZH_branch.SetAddress(<void*>&self.eVetoZH_value)

        #print "making eVetoZH_smallDR"
        self.eVetoZH_smallDR_branch = the_tree.GetBranch("eVetoZH_smallDR")
        #if not self.eVetoZH_smallDR_branch and "eVetoZH_smallDR" not in self.complained:
        if not self.eVetoZH_smallDR_branch and "eVetoZH_smallDR":
            warnings.warn( "EEETauTree: Expected branch eVetoZH_smallDR does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eVetoZH_smallDR")
        else:
            self.eVetoZH_smallDR_branch.SetAddress(<void*>&self.eVetoZH_smallDR_value)

        #print "making evt"
        self.evt_branch = the_tree.GetBranch("evt")
        #if not self.evt_branch and "evt" not in self.complained:
        if not self.evt_branch and "evt":
            warnings.warn( "EEETauTree: Expected branch evt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("evt")
        else:
            self.evt_branch.SetAddress(<void*>&self.evt_value)

        #print "making isGtautau"
        self.isGtautau_branch = the_tree.GetBranch("isGtautau")
        #if not self.isGtautau_branch and "isGtautau" not in self.complained:
        if not self.isGtautau_branch and "isGtautau":
            warnings.warn( "EEETauTree: Expected branch isGtautau does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("isGtautau")
        else:
            self.isGtautau_branch.SetAddress(<void*>&self.isGtautau_value)

        #print "making isWmunu"
        self.isWmunu_branch = the_tree.GetBranch("isWmunu")
        #if not self.isWmunu_branch and "isWmunu" not in self.complained:
        if not self.isWmunu_branch and "isWmunu":
            warnings.warn( "EEETauTree: Expected branch isWmunu does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("isWmunu")
        else:
            self.isWmunu_branch.SetAddress(<void*>&self.isWmunu_value)

        #print "making isWtaunu"
        self.isWtaunu_branch = the_tree.GetBranch("isWtaunu")
        #if not self.isWtaunu_branch and "isWtaunu" not in self.complained:
        if not self.isWtaunu_branch and "isWtaunu":
            warnings.warn( "EEETauTree: Expected branch isWtaunu does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("isWtaunu")
        else:
            self.isWtaunu_branch.SetAddress(<void*>&self.isWtaunu_value)

        #print "making isZtautau"
        self.isZtautau_branch = the_tree.GetBranch("isZtautau")
        #if not self.isZtautau_branch and "isZtautau" not in self.complained:
        if not self.isZtautau_branch and "isZtautau":
            warnings.warn( "EEETauTree: Expected branch isZtautau does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("isZtautau")
        else:
            self.isZtautau_branch.SetAddress(<void*>&self.isZtautau_value)

        #print "making isdata"
        self.isdata_branch = the_tree.GetBranch("isdata")
        #if not self.isdata_branch and "isdata" not in self.complained:
        if not self.isdata_branch and "isdata":
            warnings.warn( "EEETauTree: Expected branch isdata does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("isdata")
        else:
            self.isdata_branch.SetAddress(<void*>&self.isdata_value)

        #print "making isoMu24eta2p1Group"
        self.isoMu24eta2p1Group_branch = the_tree.GetBranch("isoMu24eta2p1Group")
        #if not self.isoMu24eta2p1Group_branch and "isoMu24eta2p1Group" not in self.complained:
        if not self.isoMu24eta2p1Group_branch and "isoMu24eta2p1Group":
            warnings.warn( "EEETauTree: Expected branch isoMu24eta2p1Group does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("isoMu24eta2p1Group")
        else:
            self.isoMu24eta2p1Group_branch.SetAddress(<void*>&self.isoMu24eta2p1Group_value)

        #print "making isoMu24eta2p1Pass"
        self.isoMu24eta2p1Pass_branch = the_tree.GetBranch("isoMu24eta2p1Pass")
        #if not self.isoMu24eta2p1Pass_branch and "isoMu24eta2p1Pass" not in self.complained:
        if not self.isoMu24eta2p1Pass_branch and "isoMu24eta2p1Pass":
            warnings.warn( "EEETauTree: Expected branch isoMu24eta2p1Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("isoMu24eta2p1Pass")
        else:
            self.isoMu24eta2p1Pass_branch.SetAddress(<void*>&self.isoMu24eta2p1Pass_value)

        #print "making isoMu24eta2p1Prescale"
        self.isoMu24eta2p1Prescale_branch = the_tree.GetBranch("isoMu24eta2p1Prescale")
        #if not self.isoMu24eta2p1Prescale_branch and "isoMu24eta2p1Prescale" not in self.complained:
        if not self.isoMu24eta2p1Prescale_branch and "isoMu24eta2p1Prescale":
            warnings.warn( "EEETauTree: Expected branch isoMu24eta2p1Prescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("isoMu24eta2p1Prescale")
        else:
            self.isoMu24eta2p1Prescale_branch.SetAddress(<void*>&self.isoMu24eta2p1Prescale_value)

        #print "making isoMuGroup"
        self.isoMuGroup_branch = the_tree.GetBranch("isoMuGroup")
        #if not self.isoMuGroup_branch and "isoMuGroup" not in self.complained:
        if not self.isoMuGroup_branch and "isoMuGroup":
            warnings.warn( "EEETauTree: Expected branch isoMuGroup does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("isoMuGroup")
        else:
            self.isoMuGroup_branch.SetAddress(<void*>&self.isoMuGroup_value)

        #print "making isoMuPass"
        self.isoMuPass_branch = the_tree.GetBranch("isoMuPass")
        #if not self.isoMuPass_branch and "isoMuPass" not in self.complained:
        if not self.isoMuPass_branch and "isoMuPass":
            warnings.warn( "EEETauTree: Expected branch isoMuPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("isoMuPass")
        else:
            self.isoMuPass_branch.SetAddress(<void*>&self.isoMuPass_value)

        #print "making isoMuPrescale"
        self.isoMuPrescale_branch = the_tree.GetBranch("isoMuPrescale")
        #if not self.isoMuPrescale_branch and "isoMuPrescale" not in self.complained:
        if not self.isoMuPrescale_branch and "isoMuPrescale":
            warnings.warn( "EEETauTree: Expected branch isoMuPrescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("isoMuPrescale")
        else:
            self.isoMuPrescale_branch.SetAddress(<void*>&self.isoMuPrescale_value)

        #print "making isoMuTauGroup"
        self.isoMuTauGroup_branch = the_tree.GetBranch("isoMuTauGroup")
        #if not self.isoMuTauGroup_branch and "isoMuTauGroup" not in self.complained:
        if not self.isoMuTauGroup_branch and "isoMuTauGroup":
            warnings.warn( "EEETauTree: Expected branch isoMuTauGroup does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("isoMuTauGroup")
        else:
            self.isoMuTauGroup_branch.SetAddress(<void*>&self.isoMuTauGroup_value)

        #print "making isoMuTauPass"
        self.isoMuTauPass_branch = the_tree.GetBranch("isoMuTauPass")
        #if not self.isoMuTauPass_branch and "isoMuTauPass" not in self.complained:
        if not self.isoMuTauPass_branch and "isoMuTauPass":
            warnings.warn( "EEETauTree: Expected branch isoMuTauPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("isoMuTauPass")
        else:
            self.isoMuTauPass_branch.SetAddress(<void*>&self.isoMuTauPass_value)

        #print "making isoMuTauPrescale"
        self.isoMuTauPrescale_branch = the_tree.GetBranch("isoMuTauPrescale")
        #if not self.isoMuTauPrescale_branch and "isoMuTauPrescale" not in self.complained:
        if not self.isoMuTauPrescale_branch and "isoMuTauPrescale":
            warnings.warn( "EEETauTree: Expected branch isoMuTauPrescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("isoMuTauPrescale")
        else:
            self.isoMuTauPrescale_branch.SetAddress(<void*>&self.isoMuTauPrescale_value)

        #print "making jetVeto20"
        self.jetVeto20_branch = the_tree.GetBranch("jetVeto20")
        #if not self.jetVeto20_branch and "jetVeto20" not in self.complained:
        if not self.jetVeto20_branch and "jetVeto20":
            warnings.warn( "EEETauTree: Expected branch jetVeto20 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto20")
        else:
            self.jetVeto20_branch.SetAddress(<void*>&self.jetVeto20_value)

        #print "making jetVeto20_DR05"
        self.jetVeto20_DR05_branch = the_tree.GetBranch("jetVeto20_DR05")
        #if not self.jetVeto20_DR05_branch and "jetVeto20_DR05" not in self.complained:
        if not self.jetVeto20_DR05_branch and "jetVeto20_DR05":
            warnings.warn( "EEETauTree: Expected branch jetVeto20_DR05 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto20_DR05")
        else:
            self.jetVeto20_DR05_branch.SetAddress(<void*>&self.jetVeto20_DR05_value)

        #print "making jetVeto30"
        self.jetVeto30_branch = the_tree.GetBranch("jetVeto30")
        #if not self.jetVeto30_branch and "jetVeto30" not in self.complained:
        if not self.jetVeto30_branch and "jetVeto30":
            warnings.warn( "EEETauTree: Expected branch jetVeto30 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30")
        else:
            self.jetVeto30_branch.SetAddress(<void*>&self.jetVeto30_value)

        #print "making jetVeto30_DR05"
        self.jetVeto30_DR05_branch = the_tree.GetBranch("jetVeto30_DR05")
        #if not self.jetVeto30_DR05_branch and "jetVeto30_DR05" not in self.complained:
        if not self.jetVeto30_DR05_branch and "jetVeto30_DR05":
            warnings.warn( "EEETauTree: Expected branch jetVeto30_DR05 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_DR05")
        else:
            self.jetVeto30_DR05_branch.SetAddress(<void*>&self.jetVeto30_DR05_value)

        #print "making jetVeto40"
        self.jetVeto40_branch = the_tree.GetBranch("jetVeto40")
        #if not self.jetVeto40_branch and "jetVeto40" not in self.complained:
        if not self.jetVeto40_branch and "jetVeto40":
            warnings.warn( "EEETauTree: Expected branch jetVeto40 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto40")
        else:
            self.jetVeto40_branch.SetAddress(<void*>&self.jetVeto40_value)

        #print "making jetVeto40_DR05"
        self.jetVeto40_DR05_branch = the_tree.GetBranch("jetVeto40_DR05")
        #if not self.jetVeto40_DR05_branch and "jetVeto40_DR05" not in self.complained:
        if not self.jetVeto40_DR05_branch and "jetVeto40_DR05":
            warnings.warn( "EEETauTree: Expected branch jetVeto40_DR05 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto40_DR05")
        else:
            self.jetVeto40_DR05_branch.SetAddress(<void*>&self.jetVeto40_DR05_value)

        #print "making lumi"
        self.lumi_branch = the_tree.GetBranch("lumi")
        #if not self.lumi_branch and "lumi" not in self.complained:
        if not self.lumi_branch and "lumi":
            warnings.warn( "EEETauTree: Expected branch lumi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lumi")
        else:
            self.lumi_branch.SetAddress(<void*>&self.lumi_value)

        #print "making mu17ele8Group"
        self.mu17ele8Group_branch = the_tree.GetBranch("mu17ele8Group")
        #if not self.mu17ele8Group_branch and "mu17ele8Group" not in self.complained:
        if not self.mu17ele8Group_branch and "mu17ele8Group":
            warnings.warn( "EEETauTree: Expected branch mu17ele8Group does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mu17ele8Group")
        else:
            self.mu17ele8Group_branch.SetAddress(<void*>&self.mu17ele8Group_value)

        #print "making mu17ele8Pass"
        self.mu17ele8Pass_branch = the_tree.GetBranch("mu17ele8Pass")
        #if not self.mu17ele8Pass_branch and "mu17ele8Pass" not in self.complained:
        if not self.mu17ele8Pass_branch and "mu17ele8Pass":
            warnings.warn( "EEETauTree: Expected branch mu17ele8Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mu17ele8Pass")
        else:
            self.mu17ele8Pass_branch.SetAddress(<void*>&self.mu17ele8Pass_value)

        #print "making mu17ele8Prescale"
        self.mu17ele8Prescale_branch = the_tree.GetBranch("mu17ele8Prescale")
        #if not self.mu17ele8Prescale_branch and "mu17ele8Prescale" not in self.complained:
        if not self.mu17ele8Prescale_branch and "mu17ele8Prescale":
            warnings.warn( "EEETauTree: Expected branch mu17ele8Prescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mu17ele8Prescale")
        else:
            self.mu17ele8Prescale_branch.SetAddress(<void*>&self.mu17ele8Prescale_value)

        #print "making mu17ele8isoGroup"
        self.mu17ele8isoGroup_branch = the_tree.GetBranch("mu17ele8isoGroup")
        #if not self.mu17ele8isoGroup_branch and "mu17ele8isoGroup" not in self.complained:
        if not self.mu17ele8isoGroup_branch and "mu17ele8isoGroup":
            warnings.warn( "EEETauTree: Expected branch mu17ele8isoGroup does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mu17ele8isoGroup")
        else:
            self.mu17ele8isoGroup_branch.SetAddress(<void*>&self.mu17ele8isoGroup_value)

        #print "making mu17ele8isoPass"
        self.mu17ele8isoPass_branch = the_tree.GetBranch("mu17ele8isoPass")
        #if not self.mu17ele8isoPass_branch and "mu17ele8isoPass" not in self.complained:
        if not self.mu17ele8isoPass_branch and "mu17ele8isoPass":
            warnings.warn( "EEETauTree: Expected branch mu17ele8isoPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mu17ele8isoPass")
        else:
            self.mu17ele8isoPass_branch.SetAddress(<void*>&self.mu17ele8isoPass_value)

        #print "making mu17ele8isoPrescale"
        self.mu17ele8isoPrescale_branch = the_tree.GetBranch("mu17ele8isoPrescale")
        #if not self.mu17ele8isoPrescale_branch and "mu17ele8isoPrescale" not in self.complained:
        if not self.mu17ele8isoPrescale_branch and "mu17ele8isoPrescale":
            warnings.warn( "EEETauTree: Expected branch mu17ele8isoPrescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mu17ele8isoPrescale")
        else:
            self.mu17ele8isoPrescale_branch.SetAddress(<void*>&self.mu17ele8isoPrescale_value)

        #print "making mu17mu8Group"
        self.mu17mu8Group_branch = the_tree.GetBranch("mu17mu8Group")
        #if not self.mu17mu8Group_branch and "mu17mu8Group" not in self.complained:
        if not self.mu17mu8Group_branch and "mu17mu8Group":
            warnings.warn( "EEETauTree: Expected branch mu17mu8Group does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mu17mu8Group")
        else:
            self.mu17mu8Group_branch.SetAddress(<void*>&self.mu17mu8Group_value)

        #print "making mu17mu8Pass"
        self.mu17mu8Pass_branch = the_tree.GetBranch("mu17mu8Pass")
        #if not self.mu17mu8Pass_branch and "mu17mu8Pass" not in self.complained:
        if not self.mu17mu8Pass_branch and "mu17mu8Pass":
            warnings.warn( "EEETauTree: Expected branch mu17mu8Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mu17mu8Pass")
        else:
            self.mu17mu8Pass_branch.SetAddress(<void*>&self.mu17mu8Pass_value)

        #print "making mu17mu8Prescale"
        self.mu17mu8Prescale_branch = the_tree.GetBranch("mu17mu8Prescale")
        #if not self.mu17mu8Prescale_branch and "mu17mu8Prescale" not in self.complained:
        if not self.mu17mu8Prescale_branch and "mu17mu8Prescale":
            warnings.warn( "EEETauTree: Expected branch mu17mu8Prescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mu17mu8Prescale")
        else:
            self.mu17mu8Prescale_branch.SetAddress(<void*>&self.mu17mu8Prescale_value)

        #print "making mu8ele17Group"
        self.mu8ele17Group_branch = the_tree.GetBranch("mu8ele17Group")
        #if not self.mu8ele17Group_branch and "mu8ele17Group" not in self.complained:
        if not self.mu8ele17Group_branch and "mu8ele17Group":
            warnings.warn( "EEETauTree: Expected branch mu8ele17Group does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mu8ele17Group")
        else:
            self.mu8ele17Group_branch.SetAddress(<void*>&self.mu8ele17Group_value)

        #print "making mu8ele17Pass"
        self.mu8ele17Pass_branch = the_tree.GetBranch("mu8ele17Pass")
        #if not self.mu8ele17Pass_branch and "mu8ele17Pass" not in self.complained:
        if not self.mu8ele17Pass_branch and "mu8ele17Pass":
            warnings.warn( "EEETauTree: Expected branch mu8ele17Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mu8ele17Pass")
        else:
            self.mu8ele17Pass_branch.SetAddress(<void*>&self.mu8ele17Pass_value)

        #print "making mu8ele17Prescale"
        self.mu8ele17Prescale_branch = the_tree.GetBranch("mu8ele17Prescale")
        #if not self.mu8ele17Prescale_branch and "mu8ele17Prescale" not in self.complained:
        if not self.mu8ele17Prescale_branch and "mu8ele17Prescale":
            warnings.warn( "EEETauTree: Expected branch mu8ele17Prescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mu8ele17Prescale")
        else:
            self.mu8ele17Prescale_branch.SetAddress(<void*>&self.mu8ele17Prescale_value)

        #print "making mu8ele17isoGroup"
        self.mu8ele17isoGroup_branch = the_tree.GetBranch("mu8ele17isoGroup")
        #if not self.mu8ele17isoGroup_branch and "mu8ele17isoGroup" not in self.complained:
        if not self.mu8ele17isoGroup_branch and "mu8ele17isoGroup":
            warnings.warn( "EEETauTree: Expected branch mu8ele17isoGroup does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mu8ele17isoGroup")
        else:
            self.mu8ele17isoGroup_branch.SetAddress(<void*>&self.mu8ele17isoGroup_value)

        #print "making mu8ele17isoPass"
        self.mu8ele17isoPass_branch = the_tree.GetBranch("mu8ele17isoPass")
        #if not self.mu8ele17isoPass_branch and "mu8ele17isoPass" not in self.complained:
        if not self.mu8ele17isoPass_branch and "mu8ele17isoPass":
            warnings.warn( "EEETauTree: Expected branch mu8ele17isoPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mu8ele17isoPass")
        else:
            self.mu8ele17isoPass_branch.SetAddress(<void*>&self.mu8ele17isoPass_value)

        #print "making mu8ele17isoPrescale"
        self.mu8ele17isoPrescale_branch = the_tree.GetBranch("mu8ele17isoPrescale")
        #if not self.mu8ele17isoPrescale_branch and "mu8ele17isoPrescale" not in self.complained:
        if not self.mu8ele17isoPrescale_branch and "mu8ele17isoPrescale":
            warnings.warn( "EEETauTree: Expected branch mu8ele17isoPrescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mu8ele17isoPrescale")
        else:
            self.mu8ele17isoPrescale_branch.SetAddress(<void*>&self.mu8ele17isoPrescale_value)

        #print "making muGlbIsoVetoPt10"
        self.muGlbIsoVetoPt10_branch = the_tree.GetBranch("muGlbIsoVetoPt10")
        #if not self.muGlbIsoVetoPt10_branch and "muGlbIsoVetoPt10" not in self.complained:
        if not self.muGlbIsoVetoPt10_branch and "muGlbIsoVetoPt10":
            warnings.warn( "EEETauTree: Expected branch muGlbIsoVetoPt10 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("muGlbIsoVetoPt10")
        else:
            self.muGlbIsoVetoPt10_branch.SetAddress(<void*>&self.muGlbIsoVetoPt10_value)

        #print "making muTauGroup"
        self.muTauGroup_branch = the_tree.GetBranch("muTauGroup")
        #if not self.muTauGroup_branch and "muTauGroup" not in self.complained:
        if not self.muTauGroup_branch and "muTauGroup":
            warnings.warn( "EEETauTree: Expected branch muTauGroup does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("muTauGroup")
        else:
            self.muTauGroup_branch.SetAddress(<void*>&self.muTauGroup_value)

        #print "making muTauPass"
        self.muTauPass_branch = the_tree.GetBranch("muTauPass")
        #if not self.muTauPass_branch and "muTauPass" not in self.complained:
        if not self.muTauPass_branch and "muTauPass":
            warnings.warn( "EEETauTree: Expected branch muTauPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("muTauPass")
        else:
            self.muTauPass_branch.SetAddress(<void*>&self.muTauPass_value)

        #print "making muTauPrescale"
        self.muTauPrescale_branch = the_tree.GetBranch("muTauPrescale")
        #if not self.muTauPrescale_branch and "muTauPrescale" not in self.complained:
        if not self.muTauPrescale_branch and "muTauPrescale":
            warnings.warn( "EEETauTree: Expected branch muTauPrescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("muTauPrescale")
        else:
            self.muTauPrescale_branch.SetAddress(<void*>&self.muTauPrescale_value)

        #print "making muTauTestGroup"
        self.muTauTestGroup_branch = the_tree.GetBranch("muTauTestGroup")
        #if not self.muTauTestGroup_branch and "muTauTestGroup" not in self.complained:
        if not self.muTauTestGroup_branch and "muTauTestGroup":
            warnings.warn( "EEETauTree: Expected branch muTauTestGroup does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("muTauTestGroup")
        else:
            self.muTauTestGroup_branch.SetAddress(<void*>&self.muTauTestGroup_value)

        #print "making muTauTestPass"
        self.muTauTestPass_branch = the_tree.GetBranch("muTauTestPass")
        #if not self.muTauTestPass_branch and "muTauTestPass" not in self.complained:
        if not self.muTauTestPass_branch and "muTauTestPass":
            warnings.warn( "EEETauTree: Expected branch muTauTestPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("muTauTestPass")
        else:
            self.muTauTestPass_branch.SetAddress(<void*>&self.muTauTestPass_value)

        #print "making muTauTestPrescale"
        self.muTauTestPrescale_branch = the_tree.GetBranch("muTauTestPrescale")
        #if not self.muTauTestPrescale_branch and "muTauTestPrescale" not in self.complained:
        if not self.muTauTestPrescale_branch and "muTauTestPrescale":
            warnings.warn( "EEETauTree: Expected branch muTauTestPrescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("muTauTestPrescale")
        else:
            self.muTauTestPrescale_branch.SetAddress(<void*>&self.muTauTestPrescale_value)

        #print "making muTightCountZH"
        self.muTightCountZH_branch = the_tree.GetBranch("muTightCountZH")
        #if not self.muTightCountZH_branch and "muTightCountZH" not in self.complained:
        if not self.muTightCountZH_branch and "muTightCountZH":
            warnings.warn( "EEETauTree: Expected branch muTightCountZH does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("muTightCountZH")
        else:
            self.muTightCountZH_branch.SetAddress(<void*>&self.muTightCountZH_value)

        #print "making muVetoPt15IsoIdVtx"
        self.muVetoPt15IsoIdVtx_branch = the_tree.GetBranch("muVetoPt15IsoIdVtx")
        #if not self.muVetoPt15IsoIdVtx_branch and "muVetoPt15IsoIdVtx" not in self.complained:
        if not self.muVetoPt15IsoIdVtx_branch and "muVetoPt15IsoIdVtx":
            warnings.warn( "EEETauTree: Expected branch muVetoPt15IsoIdVtx does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("muVetoPt15IsoIdVtx")
        else:
            self.muVetoPt15IsoIdVtx_branch.SetAddress(<void*>&self.muVetoPt15IsoIdVtx_value)

        #print "making muVetoPt5"
        self.muVetoPt5_branch = the_tree.GetBranch("muVetoPt5")
        #if not self.muVetoPt5_branch and "muVetoPt5" not in self.complained:
        if not self.muVetoPt5_branch and "muVetoPt5":
            warnings.warn( "EEETauTree: Expected branch muVetoPt5 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("muVetoPt5")
        else:
            self.muVetoPt5_branch.SetAddress(<void*>&self.muVetoPt5_value)

        #print "making muVetoPt5IsoIdVtx"
        self.muVetoPt5IsoIdVtx_branch = the_tree.GetBranch("muVetoPt5IsoIdVtx")
        #if not self.muVetoPt5IsoIdVtx_branch and "muVetoPt5IsoIdVtx" not in self.complained:
        if not self.muVetoPt5IsoIdVtx_branch and "muVetoPt5IsoIdVtx":
            warnings.warn( "EEETauTree: Expected branch muVetoPt5IsoIdVtx does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("muVetoPt5IsoIdVtx")
        else:
            self.muVetoPt5IsoIdVtx_branch.SetAddress(<void*>&self.muVetoPt5IsoIdVtx_value)

        #print "making muVetoZH"
        self.muVetoZH_branch = the_tree.GetBranch("muVetoZH")
        #if not self.muVetoZH_branch and "muVetoZH" not in self.complained:
        if not self.muVetoZH_branch and "muVetoZH":
            warnings.warn( "EEETauTree: Expected branch muVetoZH does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("muVetoZH")
        else:
            self.muVetoZH_branch.SetAddress(<void*>&self.muVetoZH_value)

        #print "making mva_metEt"
        self.mva_metEt_branch = the_tree.GetBranch("mva_metEt")
        #if not self.mva_metEt_branch and "mva_metEt" not in self.complained:
        if not self.mva_metEt_branch and "mva_metEt":
            warnings.warn( "EEETauTree: Expected branch mva_metEt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mva_metEt")
        else:
            self.mva_metEt_branch.SetAddress(<void*>&self.mva_metEt_value)

        #print "making mva_metPhi"
        self.mva_metPhi_branch = the_tree.GetBranch("mva_metPhi")
        #if not self.mva_metPhi_branch and "mva_metPhi" not in self.complained:
        if not self.mva_metPhi_branch and "mva_metPhi":
            warnings.warn( "EEETauTree: Expected branch mva_metPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mva_metPhi")
        else:
            self.mva_metPhi_branch.SetAddress(<void*>&self.mva_metPhi_value)

        #print "making nTruePU"
        self.nTruePU_branch = the_tree.GetBranch("nTruePU")
        #if not self.nTruePU_branch and "nTruePU" not in self.complained:
        if not self.nTruePU_branch and "nTruePU":
            warnings.warn( "EEETauTree: Expected branch nTruePU does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("nTruePU")
        else:
            self.nTruePU_branch.SetAddress(<void*>&self.nTruePU_value)

        #print "making nvtx"
        self.nvtx_branch = the_tree.GetBranch("nvtx")
        #if not self.nvtx_branch and "nvtx" not in self.complained:
        if not self.nvtx_branch and "nvtx":
            warnings.warn( "EEETauTree: Expected branch nvtx does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("nvtx")
        else:
            self.nvtx_branch.SetAddress(<void*>&self.nvtx_value)

        #print "making pfMetEt"
        self.pfMetEt_branch = the_tree.GetBranch("pfMetEt")
        #if not self.pfMetEt_branch and "pfMetEt" not in self.complained:
        if not self.pfMetEt_branch and "pfMetEt":
            warnings.warn( "EEETauTree: Expected branch pfMetEt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pfMetEt")
        else:
            self.pfMetEt_branch.SetAddress(<void*>&self.pfMetEt_value)

        #print "making pfMetPhi"
        self.pfMetPhi_branch = the_tree.GetBranch("pfMetPhi")
        #if not self.pfMetPhi_branch and "pfMetPhi" not in self.complained:
        if not self.pfMetPhi_branch and "pfMetPhi":
            warnings.warn( "EEETauTree: Expected branch pfMetPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pfMetPhi")
        else:
            self.pfMetPhi_branch.SetAddress(<void*>&self.pfMetPhi_value)

        #print "making pfMet_jes_Et"
        self.pfMet_jes_Et_branch = the_tree.GetBranch("pfMet_jes_Et")
        #if not self.pfMet_jes_Et_branch and "pfMet_jes_Et" not in self.complained:
        if not self.pfMet_jes_Et_branch and "pfMet_jes_Et":
            warnings.warn( "EEETauTree: Expected branch pfMet_jes_Et does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pfMet_jes_Et")
        else:
            self.pfMet_jes_Et_branch.SetAddress(<void*>&self.pfMet_jes_Et_value)

        #print "making pfMet_jes_Phi"
        self.pfMet_jes_Phi_branch = the_tree.GetBranch("pfMet_jes_Phi")
        #if not self.pfMet_jes_Phi_branch and "pfMet_jes_Phi" not in self.complained:
        if not self.pfMet_jes_Phi_branch and "pfMet_jes_Phi":
            warnings.warn( "EEETauTree: Expected branch pfMet_jes_Phi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pfMet_jes_Phi")
        else:
            self.pfMet_jes_Phi_branch.SetAddress(<void*>&self.pfMet_jes_Phi_value)

        #print "making pfMet_mes_Et"
        self.pfMet_mes_Et_branch = the_tree.GetBranch("pfMet_mes_Et")
        #if not self.pfMet_mes_Et_branch and "pfMet_mes_Et" not in self.complained:
        if not self.pfMet_mes_Et_branch and "pfMet_mes_Et":
            warnings.warn( "EEETauTree: Expected branch pfMet_mes_Et does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pfMet_mes_Et")
        else:
            self.pfMet_mes_Et_branch.SetAddress(<void*>&self.pfMet_mes_Et_value)

        #print "making pfMet_mes_Phi"
        self.pfMet_mes_Phi_branch = the_tree.GetBranch("pfMet_mes_Phi")
        #if not self.pfMet_mes_Phi_branch and "pfMet_mes_Phi" not in self.complained:
        if not self.pfMet_mes_Phi_branch and "pfMet_mes_Phi":
            warnings.warn( "EEETauTree: Expected branch pfMet_mes_Phi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pfMet_mes_Phi")
        else:
            self.pfMet_mes_Phi_branch.SetAddress(<void*>&self.pfMet_mes_Phi_value)

        #print "making pfMet_tes_Et"
        self.pfMet_tes_Et_branch = the_tree.GetBranch("pfMet_tes_Et")
        #if not self.pfMet_tes_Et_branch and "pfMet_tes_Et" not in self.complained:
        if not self.pfMet_tes_Et_branch and "pfMet_tes_Et":
            warnings.warn( "EEETauTree: Expected branch pfMet_tes_Et does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pfMet_tes_Et")
        else:
            self.pfMet_tes_Et_branch.SetAddress(<void*>&self.pfMet_tes_Et_value)

        #print "making pfMet_tes_Phi"
        self.pfMet_tes_Phi_branch = the_tree.GetBranch("pfMet_tes_Phi")
        #if not self.pfMet_tes_Phi_branch and "pfMet_tes_Phi" not in self.complained:
        if not self.pfMet_tes_Phi_branch and "pfMet_tes_Phi":
            warnings.warn( "EEETauTree: Expected branch pfMet_tes_Phi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pfMet_tes_Phi")
        else:
            self.pfMet_tes_Phi_branch.SetAddress(<void*>&self.pfMet_tes_Phi_value)

        #print "making pfMet_ues_Et"
        self.pfMet_ues_Et_branch = the_tree.GetBranch("pfMet_ues_Et")
        #if not self.pfMet_ues_Et_branch and "pfMet_ues_Et" not in self.complained:
        if not self.pfMet_ues_Et_branch and "pfMet_ues_Et":
            warnings.warn( "EEETauTree: Expected branch pfMet_ues_Et does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pfMet_ues_Et")
        else:
            self.pfMet_ues_Et_branch.SetAddress(<void*>&self.pfMet_ues_Et_value)

        #print "making pfMet_ues_Phi"
        self.pfMet_ues_Phi_branch = the_tree.GetBranch("pfMet_ues_Phi")
        #if not self.pfMet_ues_Phi_branch and "pfMet_ues_Phi" not in self.complained:
        if not self.pfMet_ues_Phi_branch and "pfMet_ues_Phi":
            warnings.warn( "EEETauTree: Expected branch pfMet_ues_Phi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pfMet_ues_Phi")
        else:
            self.pfMet_ues_Phi_branch.SetAddress(<void*>&self.pfMet_ues_Phi_value)

        #print "making processID"
        self.processID_branch = the_tree.GetBranch("processID")
        #if not self.processID_branch and "processID" not in self.complained:
        if not self.processID_branch and "processID":
            warnings.warn( "EEETauTree: Expected branch processID does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("processID")
        else:
            self.processID_branch.SetAddress(<void*>&self.processID_value)

        #print "making pvChi2"
        self.pvChi2_branch = the_tree.GetBranch("pvChi2")
        #if not self.pvChi2_branch and "pvChi2" not in self.complained:
        if not self.pvChi2_branch and "pvChi2":
            warnings.warn( "EEETauTree: Expected branch pvChi2 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pvChi2")
        else:
            self.pvChi2_branch.SetAddress(<void*>&self.pvChi2_value)

        #print "making pvDX"
        self.pvDX_branch = the_tree.GetBranch("pvDX")
        #if not self.pvDX_branch and "pvDX" not in self.complained:
        if not self.pvDX_branch and "pvDX":
            warnings.warn( "EEETauTree: Expected branch pvDX does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pvDX")
        else:
            self.pvDX_branch.SetAddress(<void*>&self.pvDX_value)

        #print "making pvDY"
        self.pvDY_branch = the_tree.GetBranch("pvDY")
        #if not self.pvDY_branch and "pvDY" not in self.complained:
        if not self.pvDY_branch and "pvDY":
            warnings.warn( "EEETauTree: Expected branch pvDY does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pvDY")
        else:
            self.pvDY_branch.SetAddress(<void*>&self.pvDY_value)

        #print "making pvDZ"
        self.pvDZ_branch = the_tree.GetBranch("pvDZ")
        #if not self.pvDZ_branch and "pvDZ" not in self.complained:
        if not self.pvDZ_branch and "pvDZ":
            warnings.warn( "EEETauTree: Expected branch pvDZ does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pvDZ")
        else:
            self.pvDZ_branch.SetAddress(<void*>&self.pvDZ_value)

        #print "making pvIsFake"
        self.pvIsFake_branch = the_tree.GetBranch("pvIsFake")
        #if not self.pvIsFake_branch and "pvIsFake" not in self.complained:
        if not self.pvIsFake_branch and "pvIsFake":
            warnings.warn( "EEETauTree: Expected branch pvIsFake does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pvIsFake")
        else:
            self.pvIsFake_branch.SetAddress(<void*>&self.pvIsFake_value)

        #print "making pvIsValid"
        self.pvIsValid_branch = the_tree.GetBranch("pvIsValid")
        #if not self.pvIsValid_branch and "pvIsValid" not in self.complained:
        if not self.pvIsValid_branch and "pvIsValid":
            warnings.warn( "EEETauTree: Expected branch pvIsValid does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pvIsValid")
        else:
            self.pvIsValid_branch.SetAddress(<void*>&self.pvIsValid_value)

        #print "making pvNormChi2"
        self.pvNormChi2_branch = the_tree.GetBranch("pvNormChi2")
        #if not self.pvNormChi2_branch and "pvNormChi2" not in self.complained:
        if not self.pvNormChi2_branch and "pvNormChi2":
            warnings.warn( "EEETauTree: Expected branch pvNormChi2 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pvNormChi2")
        else:
            self.pvNormChi2_branch.SetAddress(<void*>&self.pvNormChi2_value)

        #print "making pvX"
        self.pvX_branch = the_tree.GetBranch("pvX")
        #if not self.pvX_branch and "pvX" not in self.complained:
        if not self.pvX_branch and "pvX":
            warnings.warn( "EEETauTree: Expected branch pvX does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pvX")
        else:
            self.pvX_branch.SetAddress(<void*>&self.pvX_value)

        #print "making pvY"
        self.pvY_branch = the_tree.GetBranch("pvY")
        #if not self.pvY_branch and "pvY" not in self.complained:
        if not self.pvY_branch and "pvY":
            warnings.warn( "EEETauTree: Expected branch pvY does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pvY")
        else:
            self.pvY_branch.SetAddress(<void*>&self.pvY_value)

        #print "making pvZ"
        self.pvZ_branch = the_tree.GetBranch("pvZ")
        #if not self.pvZ_branch and "pvZ" not in self.complained:
        if not self.pvZ_branch and "pvZ":
            warnings.warn( "EEETauTree: Expected branch pvZ does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pvZ")
        else:
            self.pvZ_branch.SetAddress(<void*>&self.pvZ_value)

        #print "making pvndof"
        self.pvndof_branch = the_tree.GetBranch("pvndof")
        #if not self.pvndof_branch and "pvndof" not in self.complained:
        if not self.pvndof_branch and "pvndof":
            warnings.warn( "EEETauTree: Expected branch pvndof does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pvndof")
        else:
            self.pvndof_branch.SetAddress(<void*>&self.pvndof_value)

        #print "making recoilDaught"
        self.recoilDaught_branch = the_tree.GetBranch("recoilDaught")
        #if not self.recoilDaught_branch and "recoilDaught" not in self.complained:
        if not self.recoilDaught_branch and "recoilDaught":
            warnings.warn( "EEETauTree: Expected branch recoilDaught does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("recoilDaught")
        else:
            self.recoilDaught_branch.SetAddress(<void*>&self.recoilDaught_value)

        #print "making recoilWithMet"
        self.recoilWithMet_branch = the_tree.GetBranch("recoilWithMet")
        #if not self.recoilWithMet_branch and "recoilWithMet" not in self.complained:
        if not self.recoilWithMet_branch and "recoilWithMet":
            warnings.warn( "EEETauTree: Expected branch recoilWithMet does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("recoilWithMet")
        else:
            self.recoilWithMet_branch.SetAddress(<void*>&self.recoilWithMet_value)

        #print "making rho"
        self.rho_branch = the_tree.GetBranch("rho")
        #if not self.rho_branch and "rho" not in self.complained:
        if not self.rho_branch and "rho":
            warnings.warn( "EEETauTree: Expected branch rho does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("rho")
        else:
            self.rho_branch.SetAddress(<void*>&self.rho_value)

        #print "making run"
        self.run_branch = the_tree.GetBranch("run")
        #if not self.run_branch and "run" not in self.complained:
        if not self.run_branch and "run":
            warnings.warn( "EEETauTree: Expected branch run does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("run")
        else:
            self.run_branch.SetAddress(<void*>&self.run_value)

        #print "making singleEGroup"
        self.singleEGroup_branch = the_tree.GetBranch("singleEGroup")
        #if not self.singleEGroup_branch and "singleEGroup" not in self.complained:
        if not self.singleEGroup_branch and "singleEGroup":
            warnings.warn( "EEETauTree: Expected branch singleEGroup does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleEGroup")
        else:
            self.singleEGroup_branch.SetAddress(<void*>&self.singleEGroup_value)

        #print "making singleEPFMTGroup"
        self.singleEPFMTGroup_branch = the_tree.GetBranch("singleEPFMTGroup")
        #if not self.singleEPFMTGroup_branch and "singleEPFMTGroup" not in self.complained:
        if not self.singleEPFMTGroup_branch and "singleEPFMTGroup":
            warnings.warn( "EEETauTree: Expected branch singleEPFMTGroup does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleEPFMTGroup")
        else:
            self.singleEPFMTGroup_branch.SetAddress(<void*>&self.singleEPFMTGroup_value)

        #print "making singleEPFMTPass"
        self.singleEPFMTPass_branch = the_tree.GetBranch("singleEPFMTPass")
        #if not self.singleEPFMTPass_branch and "singleEPFMTPass" not in self.complained:
        if not self.singleEPFMTPass_branch and "singleEPFMTPass":
            warnings.warn( "EEETauTree: Expected branch singleEPFMTPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleEPFMTPass")
        else:
            self.singleEPFMTPass_branch.SetAddress(<void*>&self.singleEPFMTPass_value)

        #print "making singleEPFMTPrescale"
        self.singleEPFMTPrescale_branch = the_tree.GetBranch("singleEPFMTPrescale")
        #if not self.singleEPFMTPrescale_branch and "singleEPFMTPrescale" not in self.complained:
        if not self.singleEPFMTPrescale_branch and "singleEPFMTPrescale":
            warnings.warn( "EEETauTree: Expected branch singleEPFMTPrescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleEPFMTPrescale")
        else:
            self.singleEPFMTPrescale_branch.SetAddress(<void*>&self.singleEPFMTPrescale_value)

        #print "making singleEPass"
        self.singleEPass_branch = the_tree.GetBranch("singleEPass")
        #if not self.singleEPass_branch and "singleEPass" not in self.complained:
        if not self.singleEPass_branch and "singleEPass":
            warnings.warn( "EEETauTree: Expected branch singleEPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleEPass")
        else:
            self.singleEPass_branch.SetAddress(<void*>&self.singleEPass_value)

        #print "making singleEPrescale"
        self.singleEPrescale_branch = the_tree.GetBranch("singleEPrescale")
        #if not self.singleEPrescale_branch and "singleEPrescale" not in self.complained:
        if not self.singleEPrescale_branch and "singleEPrescale":
            warnings.warn( "EEETauTree: Expected branch singleEPrescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleEPrescale")
        else:
            self.singleEPrescale_branch.SetAddress(<void*>&self.singleEPrescale_value)

        #print "making singleMuGroup"
        self.singleMuGroup_branch = the_tree.GetBranch("singleMuGroup")
        #if not self.singleMuGroup_branch and "singleMuGroup" not in self.complained:
        if not self.singleMuGroup_branch and "singleMuGroup":
            warnings.warn( "EEETauTree: Expected branch singleMuGroup does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleMuGroup")
        else:
            self.singleMuGroup_branch.SetAddress(<void*>&self.singleMuGroup_value)

        #print "making singleMuPass"
        self.singleMuPass_branch = the_tree.GetBranch("singleMuPass")
        #if not self.singleMuPass_branch and "singleMuPass" not in self.complained:
        if not self.singleMuPass_branch and "singleMuPass":
            warnings.warn( "EEETauTree: Expected branch singleMuPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleMuPass")
        else:
            self.singleMuPass_branch.SetAddress(<void*>&self.singleMuPass_value)

        #print "making singleMuPrescale"
        self.singleMuPrescale_branch = the_tree.GetBranch("singleMuPrescale")
        #if not self.singleMuPrescale_branch and "singleMuPrescale" not in self.complained:
        if not self.singleMuPrescale_branch and "singleMuPrescale":
            warnings.warn( "EEETauTree: Expected branch singleMuPrescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleMuPrescale")
        else:
            self.singleMuPrescale_branch.SetAddress(<void*>&self.singleMuPrescale_value)

        #print "making singlePhoGroup"
        self.singlePhoGroup_branch = the_tree.GetBranch("singlePhoGroup")
        #if not self.singlePhoGroup_branch and "singlePhoGroup" not in self.complained:
        if not self.singlePhoGroup_branch and "singlePhoGroup":
            warnings.warn( "EEETauTree: Expected branch singlePhoGroup does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singlePhoGroup")
        else:
            self.singlePhoGroup_branch.SetAddress(<void*>&self.singlePhoGroup_value)

        #print "making singlePhoPass"
        self.singlePhoPass_branch = the_tree.GetBranch("singlePhoPass")
        #if not self.singlePhoPass_branch and "singlePhoPass" not in self.complained:
        if not self.singlePhoPass_branch and "singlePhoPass":
            warnings.warn( "EEETauTree: Expected branch singlePhoPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singlePhoPass")
        else:
            self.singlePhoPass_branch.SetAddress(<void*>&self.singlePhoPass_value)

        #print "making singlePhoPrescale"
        self.singlePhoPrescale_branch = the_tree.GetBranch("singlePhoPrescale")
        #if not self.singlePhoPrescale_branch and "singlePhoPrescale" not in self.complained:
        if not self.singlePhoPrescale_branch and "singlePhoPrescale":
            warnings.warn( "EEETauTree: Expected branch singlePhoPrescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singlePhoPrescale")
        else:
            self.singlePhoPrescale_branch.SetAddress(<void*>&self.singlePhoPrescale_value)

        #print "making tAbsEta"
        self.tAbsEta_branch = the_tree.GetBranch("tAbsEta")
        #if not self.tAbsEta_branch and "tAbsEta" not in self.complained:
        if not self.tAbsEta_branch and "tAbsEta":
            warnings.warn( "EEETauTree: Expected branch tAbsEta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tAbsEta")
        else:
            self.tAbsEta_branch.SetAddress(<void*>&self.tAbsEta_value)

        #print "making tAntiElectronLoose"
        self.tAntiElectronLoose_branch = the_tree.GetBranch("tAntiElectronLoose")
        #if not self.tAntiElectronLoose_branch and "tAntiElectronLoose" not in self.complained:
        if not self.tAntiElectronLoose_branch and "tAntiElectronLoose":
            warnings.warn( "EEETauTree: Expected branch tAntiElectronLoose does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tAntiElectronLoose")
        else:
            self.tAntiElectronLoose_branch.SetAddress(<void*>&self.tAntiElectronLoose_value)

        #print "making tAntiElectronMVA3Loose"
        self.tAntiElectronMVA3Loose_branch = the_tree.GetBranch("tAntiElectronMVA3Loose")
        #if not self.tAntiElectronMVA3Loose_branch and "tAntiElectronMVA3Loose" not in self.complained:
        if not self.tAntiElectronMVA3Loose_branch and "tAntiElectronMVA3Loose":
            warnings.warn( "EEETauTree: Expected branch tAntiElectronMVA3Loose does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tAntiElectronMVA3Loose")
        else:
            self.tAntiElectronMVA3Loose_branch.SetAddress(<void*>&self.tAntiElectronMVA3Loose_value)

        #print "making tAntiElectronMVA3Medium"
        self.tAntiElectronMVA3Medium_branch = the_tree.GetBranch("tAntiElectronMVA3Medium")
        #if not self.tAntiElectronMVA3Medium_branch and "tAntiElectronMVA3Medium" not in self.complained:
        if not self.tAntiElectronMVA3Medium_branch and "tAntiElectronMVA3Medium":
            warnings.warn( "EEETauTree: Expected branch tAntiElectronMVA3Medium does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tAntiElectronMVA3Medium")
        else:
            self.tAntiElectronMVA3Medium_branch.SetAddress(<void*>&self.tAntiElectronMVA3Medium_value)

        #print "making tAntiElectronMVA3Raw"
        self.tAntiElectronMVA3Raw_branch = the_tree.GetBranch("tAntiElectronMVA3Raw")
        #if not self.tAntiElectronMVA3Raw_branch and "tAntiElectronMVA3Raw" not in self.complained:
        if not self.tAntiElectronMVA3Raw_branch and "tAntiElectronMVA3Raw":
            warnings.warn( "EEETauTree: Expected branch tAntiElectronMVA3Raw does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tAntiElectronMVA3Raw")
        else:
            self.tAntiElectronMVA3Raw_branch.SetAddress(<void*>&self.tAntiElectronMVA3Raw_value)

        #print "making tAntiElectronMVA3Tight"
        self.tAntiElectronMVA3Tight_branch = the_tree.GetBranch("tAntiElectronMVA3Tight")
        #if not self.tAntiElectronMVA3Tight_branch and "tAntiElectronMVA3Tight" not in self.complained:
        if not self.tAntiElectronMVA3Tight_branch and "tAntiElectronMVA3Tight":
            warnings.warn( "EEETauTree: Expected branch tAntiElectronMVA3Tight does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tAntiElectronMVA3Tight")
        else:
            self.tAntiElectronMVA3Tight_branch.SetAddress(<void*>&self.tAntiElectronMVA3Tight_value)

        #print "making tAntiElectronMVA3VTight"
        self.tAntiElectronMVA3VTight_branch = the_tree.GetBranch("tAntiElectronMVA3VTight")
        #if not self.tAntiElectronMVA3VTight_branch and "tAntiElectronMVA3VTight" not in self.complained:
        if not self.tAntiElectronMVA3VTight_branch and "tAntiElectronMVA3VTight":
            warnings.warn( "EEETauTree: Expected branch tAntiElectronMVA3VTight does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tAntiElectronMVA3VTight")
        else:
            self.tAntiElectronMVA3VTight_branch.SetAddress(<void*>&self.tAntiElectronMVA3VTight_value)

        #print "making tAntiElectronMedium"
        self.tAntiElectronMedium_branch = the_tree.GetBranch("tAntiElectronMedium")
        #if not self.tAntiElectronMedium_branch and "tAntiElectronMedium" not in self.complained:
        if not self.tAntiElectronMedium_branch and "tAntiElectronMedium":
            warnings.warn( "EEETauTree: Expected branch tAntiElectronMedium does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tAntiElectronMedium")
        else:
            self.tAntiElectronMedium_branch.SetAddress(<void*>&self.tAntiElectronMedium_value)

        #print "making tAntiElectronTight"
        self.tAntiElectronTight_branch = the_tree.GetBranch("tAntiElectronTight")
        #if not self.tAntiElectronTight_branch and "tAntiElectronTight" not in self.complained:
        if not self.tAntiElectronTight_branch and "tAntiElectronTight":
            warnings.warn( "EEETauTree: Expected branch tAntiElectronTight does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tAntiElectronTight")
        else:
            self.tAntiElectronTight_branch.SetAddress(<void*>&self.tAntiElectronTight_value)

        #print "making tAntiMuonLoose"
        self.tAntiMuonLoose_branch = the_tree.GetBranch("tAntiMuonLoose")
        #if not self.tAntiMuonLoose_branch and "tAntiMuonLoose" not in self.complained:
        if not self.tAntiMuonLoose_branch and "tAntiMuonLoose":
            warnings.warn( "EEETauTree: Expected branch tAntiMuonLoose does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tAntiMuonLoose")
        else:
            self.tAntiMuonLoose_branch.SetAddress(<void*>&self.tAntiMuonLoose_value)

        #print "making tAntiMuonLoose2"
        self.tAntiMuonLoose2_branch = the_tree.GetBranch("tAntiMuonLoose2")
        #if not self.tAntiMuonLoose2_branch and "tAntiMuonLoose2" not in self.complained:
        if not self.tAntiMuonLoose2_branch and "tAntiMuonLoose2":
            warnings.warn( "EEETauTree: Expected branch tAntiMuonLoose2 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tAntiMuonLoose2")
        else:
            self.tAntiMuonLoose2_branch.SetAddress(<void*>&self.tAntiMuonLoose2_value)

        #print "making tAntiMuonMedium"
        self.tAntiMuonMedium_branch = the_tree.GetBranch("tAntiMuonMedium")
        #if not self.tAntiMuonMedium_branch and "tAntiMuonMedium" not in self.complained:
        if not self.tAntiMuonMedium_branch and "tAntiMuonMedium":
            warnings.warn( "EEETauTree: Expected branch tAntiMuonMedium does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tAntiMuonMedium")
        else:
            self.tAntiMuonMedium_branch.SetAddress(<void*>&self.tAntiMuonMedium_value)

        #print "making tAntiMuonMedium2"
        self.tAntiMuonMedium2_branch = the_tree.GetBranch("tAntiMuonMedium2")
        #if not self.tAntiMuonMedium2_branch and "tAntiMuonMedium2" not in self.complained:
        if not self.tAntiMuonMedium2_branch and "tAntiMuonMedium2":
            warnings.warn( "EEETauTree: Expected branch tAntiMuonMedium2 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tAntiMuonMedium2")
        else:
            self.tAntiMuonMedium2_branch.SetAddress(<void*>&self.tAntiMuonMedium2_value)

        #print "making tAntiMuonTight"
        self.tAntiMuonTight_branch = the_tree.GetBranch("tAntiMuonTight")
        #if not self.tAntiMuonTight_branch and "tAntiMuonTight" not in self.complained:
        if not self.tAntiMuonTight_branch and "tAntiMuonTight":
            warnings.warn( "EEETauTree: Expected branch tAntiMuonTight does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tAntiMuonTight")
        else:
            self.tAntiMuonTight_branch.SetAddress(<void*>&self.tAntiMuonTight_value)

        #print "making tAntiMuonTight2"
        self.tAntiMuonTight2_branch = the_tree.GetBranch("tAntiMuonTight2")
        #if not self.tAntiMuonTight2_branch and "tAntiMuonTight2" not in self.complained:
        if not self.tAntiMuonTight2_branch and "tAntiMuonTight2":
            warnings.warn( "EEETauTree: Expected branch tAntiMuonTight2 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tAntiMuonTight2")
        else:
            self.tAntiMuonTight2_branch.SetAddress(<void*>&self.tAntiMuonTight2_value)

        #print "making tCharge"
        self.tCharge_branch = the_tree.GetBranch("tCharge")
        #if not self.tCharge_branch and "tCharge" not in self.complained:
        if not self.tCharge_branch and "tCharge":
            warnings.warn( "EEETauTree: Expected branch tCharge does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tCharge")
        else:
            self.tCharge_branch.SetAddress(<void*>&self.tCharge_value)

        #print "making tCiCTightElecOverlap"
        self.tCiCTightElecOverlap_branch = the_tree.GetBranch("tCiCTightElecOverlap")
        #if not self.tCiCTightElecOverlap_branch and "tCiCTightElecOverlap" not in self.complained:
        if not self.tCiCTightElecOverlap_branch and "tCiCTightElecOverlap":
            warnings.warn( "EEETauTree: Expected branch tCiCTightElecOverlap does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tCiCTightElecOverlap")
        else:
            self.tCiCTightElecOverlap_branch.SetAddress(<void*>&self.tCiCTightElecOverlap_value)

        #print "making tDZ"
        self.tDZ_branch = the_tree.GetBranch("tDZ")
        #if not self.tDZ_branch and "tDZ" not in self.complained:
        if not self.tDZ_branch and "tDZ":
            warnings.warn( "EEETauTree: Expected branch tDZ does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tDZ")
        else:
            self.tDZ_branch.SetAddress(<void*>&self.tDZ_value)

        #print "making tDecayFinding"
        self.tDecayFinding_branch = the_tree.GetBranch("tDecayFinding")
        #if not self.tDecayFinding_branch and "tDecayFinding" not in self.complained:
        if not self.tDecayFinding_branch and "tDecayFinding":
            warnings.warn( "EEETauTree: Expected branch tDecayFinding does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tDecayFinding")
        else:
            self.tDecayFinding_branch.SetAddress(<void*>&self.tDecayFinding_value)

        #print "making tDecayMode"
        self.tDecayMode_branch = the_tree.GetBranch("tDecayMode")
        #if not self.tDecayMode_branch and "tDecayMode" not in self.complained:
        if not self.tDecayMode_branch and "tDecayMode":
            warnings.warn( "EEETauTree: Expected branch tDecayMode does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tDecayMode")
        else:
            self.tDecayMode_branch.SetAddress(<void*>&self.tDecayMode_value)

        #print "making tElecOverlap"
        self.tElecOverlap_branch = the_tree.GetBranch("tElecOverlap")
        #if not self.tElecOverlap_branch and "tElecOverlap" not in self.complained:
        if not self.tElecOverlap_branch and "tElecOverlap":
            warnings.warn( "EEETauTree: Expected branch tElecOverlap does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tElecOverlap")
        else:
            self.tElecOverlap_branch.SetAddress(<void*>&self.tElecOverlap_value)

        #print "making tElecOverlapZHLoose"
        self.tElecOverlapZHLoose_branch = the_tree.GetBranch("tElecOverlapZHLoose")
        #if not self.tElecOverlapZHLoose_branch and "tElecOverlapZHLoose" not in self.complained:
        if not self.tElecOverlapZHLoose_branch and "tElecOverlapZHLoose":
            warnings.warn( "EEETauTree: Expected branch tElecOverlapZHLoose does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tElecOverlapZHLoose")
        else:
            self.tElecOverlapZHLoose_branch.SetAddress(<void*>&self.tElecOverlapZHLoose_value)

        #print "making tElecOverlapZHTight"
        self.tElecOverlapZHTight_branch = the_tree.GetBranch("tElecOverlapZHTight")
        #if not self.tElecOverlapZHTight_branch and "tElecOverlapZHTight" not in self.complained:
        if not self.tElecOverlapZHTight_branch and "tElecOverlapZHTight":
            warnings.warn( "EEETauTree: Expected branch tElecOverlapZHTight does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tElecOverlapZHTight")
        else:
            self.tElecOverlapZHTight_branch.SetAddress(<void*>&self.tElecOverlapZHTight_value)

        #print "making tEta"
        self.tEta_branch = the_tree.GetBranch("tEta")
        #if not self.tEta_branch and "tEta" not in self.complained:
        if not self.tEta_branch and "tEta":
            warnings.warn( "EEETauTree: Expected branch tEta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tEta")
        else:
            self.tEta_branch.SetAddress(<void*>&self.tEta_value)

        #print "making tGenDecayMode"
        self.tGenDecayMode_branch = the_tree.GetBranch("tGenDecayMode")
        #if not self.tGenDecayMode_branch and "tGenDecayMode" not in self.complained:
        if not self.tGenDecayMode_branch and "tGenDecayMode":
            warnings.warn( "EEETauTree: Expected branch tGenDecayMode does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tGenDecayMode")
        else:
            self.tGenDecayMode_branch.SetAddress(<void*>&self.tGenDecayMode_value)

        #print "making tIP3DS"
        self.tIP3DS_branch = the_tree.GetBranch("tIP3DS")
        #if not self.tIP3DS_branch and "tIP3DS" not in self.complained:
        if not self.tIP3DS_branch and "tIP3DS":
            warnings.warn( "EEETauTree: Expected branch tIP3DS does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tIP3DS")
        else:
            self.tIP3DS_branch.SetAddress(<void*>&self.tIP3DS_value)

        #print "making tJetArea"
        self.tJetArea_branch = the_tree.GetBranch("tJetArea")
        #if not self.tJetArea_branch and "tJetArea" not in self.complained:
        if not self.tJetArea_branch and "tJetArea":
            warnings.warn( "EEETauTree: Expected branch tJetArea does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tJetArea")
        else:
            self.tJetArea_branch.SetAddress(<void*>&self.tJetArea_value)

        #print "making tJetBtag"
        self.tJetBtag_branch = the_tree.GetBranch("tJetBtag")
        #if not self.tJetBtag_branch and "tJetBtag" not in self.complained:
        if not self.tJetBtag_branch and "tJetBtag":
            warnings.warn( "EEETauTree: Expected branch tJetBtag does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tJetBtag")
        else:
            self.tJetBtag_branch.SetAddress(<void*>&self.tJetBtag_value)

        #print "making tJetCSVBtag"
        self.tJetCSVBtag_branch = the_tree.GetBranch("tJetCSVBtag")
        #if not self.tJetCSVBtag_branch and "tJetCSVBtag" not in self.complained:
        if not self.tJetCSVBtag_branch and "tJetCSVBtag":
            warnings.warn( "EEETauTree: Expected branch tJetCSVBtag does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tJetCSVBtag")
        else:
            self.tJetCSVBtag_branch.SetAddress(<void*>&self.tJetCSVBtag_value)

        #print "making tJetEtaEtaMoment"
        self.tJetEtaEtaMoment_branch = the_tree.GetBranch("tJetEtaEtaMoment")
        #if not self.tJetEtaEtaMoment_branch and "tJetEtaEtaMoment" not in self.complained:
        if not self.tJetEtaEtaMoment_branch and "tJetEtaEtaMoment":
            warnings.warn( "EEETauTree: Expected branch tJetEtaEtaMoment does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tJetEtaEtaMoment")
        else:
            self.tJetEtaEtaMoment_branch.SetAddress(<void*>&self.tJetEtaEtaMoment_value)

        #print "making tJetEtaPhiMoment"
        self.tJetEtaPhiMoment_branch = the_tree.GetBranch("tJetEtaPhiMoment")
        #if not self.tJetEtaPhiMoment_branch and "tJetEtaPhiMoment" not in self.complained:
        if not self.tJetEtaPhiMoment_branch and "tJetEtaPhiMoment":
            warnings.warn( "EEETauTree: Expected branch tJetEtaPhiMoment does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tJetEtaPhiMoment")
        else:
            self.tJetEtaPhiMoment_branch.SetAddress(<void*>&self.tJetEtaPhiMoment_value)

        #print "making tJetEtaPhiSpread"
        self.tJetEtaPhiSpread_branch = the_tree.GetBranch("tJetEtaPhiSpread")
        #if not self.tJetEtaPhiSpread_branch and "tJetEtaPhiSpread" not in self.complained:
        if not self.tJetEtaPhiSpread_branch and "tJetEtaPhiSpread":
            warnings.warn( "EEETauTree: Expected branch tJetEtaPhiSpread does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tJetEtaPhiSpread")
        else:
            self.tJetEtaPhiSpread_branch.SetAddress(<void*>&self.tJetEtaPhiSpread_value)

        #print "making tJetPartonFlavour"
        self.tJetPartonFlavour_branch = the_tree.GetBranch("tJetPartonFlavour")
        #if not self.tJetPartonFlavour_branch and "tJetPartonFlavour" not in self.complained:
        if not self.tJetPartonFlavour_branch and "tJetPartonFlavour":
            warnings.warn( "EEETauTree: Expected branch tJetPartonFlavour does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tJetPartonFlavour")
        else:
            self.tJetPartonFlavour_branch.SetAddress(<void*>&self.tJetPartonFlavour_value)

        #print "making tJetPhiPhiMoment"
        self.tJetPhiPhiMoment_branch = the_tree.GetBranch("tJetPhiPhiMoment")
        #if not self.tJetPhiPhiMoment_branch and "tJetPhiPhiMoment" not in self.complained:
        if not self.tJetPhiPhiMoment_branch and "tJetPhiPhiMoment":
            warnings.warn( "EEETauTree: Expected branch tJetPhiPhiMoment does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tJetPhiPhiMoment")
        else:
            self.tJetPhiPhiMoment_branch.SetAddress(<void*>&self.tJetPhiPhiMoment_value)

        #print "making tJetPt"
        self.tJetPt_branch = the_tree.GetBranch("tJetPt")
        #if not self.tJetPt_branch and "tJetPt" not in self.complained:
        if not self.tJetPt_branch and "tJetPt":
            warnings.warn( "EEETauTree: Expected branch tJetPt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tJetPt")
        else:
            self.tJetPt_branch.SetAddress(<void*>&self.tJetPt_value)

        #print "making tJetQGLikelihoodID"
        self.tJetQGLikelihoodID_branch = the_tree.GetBranch("tJetQGLikelihoodID")
        #if not self.tJetQGLikelihoodID_branch and "tJetQGLikelihoodID" not in self.complained:
        if not self.tJetQGLikelihoodID_branch and "tJetQGLikelihoodID":
            warnings.warn( "EEETauTree: Expected branch tJetQGLikelihoodID does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tJetQGLikelihoodID")
        else:
            self.tJetQGLikelihoodID_branch.SetAddress(<void*>&self.tJetQGLikelihoodID_value)

        #print "making tJetQGMVAID"
        self.tJetQGMVAID_branch = the_tree.GetBranch("tJetQGMVAID")
        #if not self.tJetQGMVAID_branch and "tJetQGMVAID" not in self.complained:
        if not self.tJetQGMVAID_branch and "tJetQGMVAID":
            warnings.warn( "EEETauTree: Expected branch tJetQGMVAID does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tJetQGMVAID")
        else:
            self.tJetQGMVAID_branch.SetAddress(<void*>&self.tJetQGMVAID_value)

        #print "making tJetaxis1"
        self.tJetaxis1_branch = the_tree.GetBranch("tJetaxis1")
        #if not self.tJetaxis1_branch and "tJetaxis1" not in self.complained:
        if not self.tJetaxis1_branch and "tJetaxis1":
            warnings.warn( "EEETauTree: Expected branch tJetaxis1 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tJetaxis1")
        else:
            self.tJetaxis1_branch.SetAddress(<void*>&self.tJetaxis1_value)

        #print "making tJetaxis2"
        self.tJetaxis2_branch = the_tree.GetBranch("tJetaxis2")
        #if not self.tJetaxis2_branch and "tJetaxis2" not in self.complained:
        if not self.tJetaxis2_branch and "tJetaxis2":
            warnings.warn( "EEETauTree: Expected branch tJetaxis2 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tJetaxis2")
        else:
            self.tJetaxis2_branch.SetAddress(<void*>&self.tJetaxis2_value)

        #print "making tJetmult"
        self.tJetmult_branch = the_tree.GetBranch("tJetmult")
        #if not self.tJetmult_branch and "tJetmult" not in self.complained:
        if not self.tJetmult_branch and "tJetmult":
            warnings.warn( "EEETauTree: Expected branch tJetmult does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tJetmult")
        else:
            self.tJetmult_branch.SetAddress(<void*>&self.tJetmult_value)

        #print "making tJetmultMLP"
        self.tJetmultMLP_branch = the_tree.GetBranch("tJetmultMLP")
        #if not self.tJetmultMLP_branch and "tJetmultMLP" not in self.complained:
        if not self.tJetmultMLP_branch and "tJetmultMLP":
            warnings.warn( "EEETauTree: Expected branch tJetmultMLP does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tJetmultMLP")
        else:
            self.tJetmultMLP_branch.SetAddress(<void*>&self.tJetmultMLP_value)

        #print "making tJetmultMLPQC"
        self.tJetmultMLPQC_branch = the_tree.GetBranch("tJetmultMLPQC")
        #if not self.tJetmultMLPQC_branch and "tJetmultMLPQC" not in self.complained:
        if not self.tJetmultMLPQC_branch and "tJetmultMLPQC":
            warnings.warn( "EEETauTree: Expected branch tJetmultMLPQC does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tJetmultMLPQC")
        else:
            self.tJetmultMLPQC_branch.SetAddress(<void*>&self.tJetmultMLPQC_value)

        #print "making tJetptD"
        self.tJetptD_branch = the_tree.GetBranch("tJetptD")
        #if not self.tJetptD_branch and "tJetptD" not in self.complained:
        if not self.tJetptD_branch and "tJetptD":
            warnings.warn( "EEETauTree: Expected branch tJetptD does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tJetptD")
        else:
            self.tJetptD_branch.SetAddress(<void*>&self.tJetptD_value)

        #print "making tLeadTrackPt"
        self.tLeadTrackPt_branch = the_tree.GetBranch("tLeadTrackPt")
        #if not self.tLeadTrackPt_branch and "tLeadTrackPt" not in self.complained:
        if not self.tLeadTrackPt_branch and "tLeadTrackPt":
            warnings.warn( "EEETauTree: Expected branch tLeadTrackPt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tLeadTrackPt")
        else:
            self.tLeadTrackPt_branch.SetAddress(<void*>&self.tLeadTrackPt_value)

        #print "making tLooseIso"
        self.tLooseIso_branch = the_tree.GetBranch("tLooseIso")
        #if not self.tLooseIso_branch and "tLooseIso" not in self.complained:
        if not self.tLooseIso_branch and "tLooseIso":
            warnings.warn( "EEETauTree: Expected branch tLooseIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tLooseIso")
        else:
            self.tLooseIso_branch.SetAddress(<void*>&self.tLooseIso_value)

        #print "making tLooseIso3Hits"
        self.tLooseIso3Hits_branch = the_tree.GetBranch("tLooseIso3Hits")
        #if not self.tLooseIso3Hits_branch and "tLooseIso3Hits" not in self.complained:
        if not self.tLooseIso3Hits_branch and "tLooseIso3Hits":
            warnings.warn( "EEETauTree: Expected branch tLooseIso3Hits does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tLooseIso3Hits")
        else:
            self.tLooseIso3Hits_branch.SetAddress(<void*>&self.tLooseIso3Hits_value)

        #print "making tLooseMVA2Iso"
        self.tLooseMVA2Iso_branch = the_tree.GetBranch("tLooseMVA2Iso")
        #if not self.tLooseMVA2Iso_branch and "tLooseMVA2Iso" not in self.complained:
        if not self.tLooseMVA2Iso_branch and "tLooseMVA2Iso":
            warnings.warn( "EEETauTree: Expected branch tLooseMVA2Iso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tLooseMVA2Iso")
        else:
            self.tLooseMVA2Iso_branch.SetAddress(<void*>&self.tLooseMVA2Iso_value)

        #print "making tLooseMVAIso"
        self.tLooseMVAIso_branch = the_tree.GetBranch("tLooseMVAIso")
        #if not self.tLooseMVAIso_branch and "tLooseMVAIso" not in self.complained:
        if not self.tLooseMVAIso_branch and "tLooseMVAIso":
            warnings.warn( "EEETauTree: Expected branch tLooseMVAIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tLooseMVAIso")
        else:
            self.tLooseMVAIso_branch.SetAddress(<void*>&self.tLooseMVAIso_value)

        #print "making tMVA2IsoRaw"
        self.tMVA2IsoRaw_branch = the_tree.GetBranch("tMVA2IsoRaw")
        #if not self.tMVA2IsoRaw_branch and "tMVA2IsoRaw" not in self.complained:
        if not self.tMVA2IsoRaw_branch and "tMVA2IsoRaw":
            warnings.warn( "EEETauTree: Expected branch tMVA2IsoRaw does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tMVA2IsoRaw")
        else:
            self.tMVA2IsoRaw_branch.SetAddress(<void*>&self.tMVA2IsoRaw_value)

        #print "making tMass"
        self.tMass_branch = the_tree.GetBranch("tMass")
        #if not self.tMass_branch and "tMass" not in self.complained:
        if not self.tMass_branch and "tMass":
            warnings.warn( "EEETauTree: Expected branch tMass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tMass")
        else:
            self.tMass_branch.SetAddress(<void*>&self.tMass_value)

        #print "making tMediumIso"
        self.tMediumIso_branch = the_tree.GetBranch("tMediumIso")
        #if not self.tMediumIso_branch and "tMediumIso" not in self.complained:
        if not self.tMediumIso_branch and "tMediumIso":
            warnings.warn( "EEETauTree: Expected branch tMediumIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tMediumIso")
        else:
            self.tMediumIso_branch.SetAddress(<void*>&self.tMediumIso_value)

        #print "making tMediumIso3Hits"
        self.tMediumIso3Hits_branch = the_tree.GetBranch("tMediumIso3Hits")
        #if not self.tMediumIso3Hits_branch and "tMediumIso3Hits" not in self.complained:
        if not self.tMediumIso3Hits_branch and "tMediumIso3Hits":
            warnings.warn( "EEETauTree: Expected branch tMediumIso3Hits does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tMediumIso3Hits")
        else:
            self.tMediumIso3Hits_branch.SetAddress(<void*>&self.tMediumIso3Hits_value)

        #print "making tMediumMVA2Iso"
        self.tMediumMVA2Iso_branch = the_tree.GetBranch("tMediumMVA2Iso")
        #if not self.tMediumMVA2Iso_branch and "tMediumMVA2Iso" not in self.complained:
        if not self.tMediumMVA2Iso_branch and "tMediumMVA2Iso":
            warnings.warn( "EEETauTree: Expected branch tMediumMVA2Iso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tMediumMVA2Iso")
        else:
            self.tMediumMVA2Iso_branch.SetAddress(<void*>&self.tMediumMVA2Iso_value)

        #print "making tMediumMVAIso"
        self.tMediumMVAIso_branch = the_tree.GetBranch("tMediumMVAIso")
        #if not self.tMediumMVAIso_branch and "tMediumMVAIso" not in self.complained:
        if not self.tMediumMVAIso_branch and "tMediumMVAIso":
            warnings.warn( "EEETauTree: Expected branch tMediumMVAIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tMediumMVAIso")
        else:
            self.tMediumMVAIso_branch.SetAddress(<void*>&self.tMediumMVAIso_value)

        #print "making tMtToMET"
        self.tMtToMET_branch = the_tree.GetBranch("tMtToMET")
        #if not self.tMtToMET_branch and "tMtToMET" not in self.complained:
        if not self.tMtToMET_branch and "tMtToMET":
            warnings.warn( "EEETauTree: Expected branch tMtToMET does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tMtToMET")
        else:
            self.tMtToMET_branch.SetAddress(<void*>&self.tMtToMET_value)

        #print "making tMtToMVAMET"
        self.tMtToMVAMET_branch = the_tree.GetBranch("tMtToMVAMET")
        #if not self.tMtToMVAMET_branch and "tMtToMVAMET" not in self.complained:
        if not self.tMtToMVAMET_branch and "tMtToMVAMET":
            warnings.warn( "EEETauTree: Expected branch tMtToMVAMET does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tMtToMVAMET")
        else:
            self.tMtToMVAMET_branch.SetAddress(<void*>&self.tMtToMVAMET_value)

        #print "making tMtToPFMET"
        self.tMtToPFMET_branch = the_tree.GetBranch("tMtToPFMET")
        #if not self.tMtToPFMET_branch and "tMtToPFMET" not in self.complained:
        if not self.tMtToPFMET_branch and "tMtToPFMET":
            warnings.warn( "EEETauTree: Expected branch tMtToPFMET does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tMtToPFMET")
        else:
            self.tMtToPFMET_branch.SetAddress(<void*>&self.tMtToPFMET_value)

        #print "making tMtToPfMet_Ty1"
        self.tMtToPfMet_Ty1_branch = the_tree.GetBranch("tMtToPfMet_Ty1")
        #if not self.tMtToPfMet_Ty1_branch and "tMtToPfMet_Ty1" not in self.complained:
        if not self.tMtToPfMet_Ty1_branch and "tMtToPfMet_Ty1":
            warnings.warn( "EEETauTree: Expected branch tMtToPfMet_Ty1 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tMtToPfMet_Ty1")
        else:
            self.tMtToPfMet_Ty1_branch.SetAddress(<void*>&self.tMtToPfMet_Ty1_value)

        #print "making tMtToPfMet_jes"
        self.tMtToPfMet_jes_branch = the_tree.GetBranch("tMtToPfMet_jes")
        #if not self.tMtToPfMet_jes_branch and "tMtToPfMet_jes" not in self.complained:
        if not self.tMtToPfMet_jes_branch and "tMtToPfMet_jes":
            warnings.warn( "EEETauTree: Expected branch tMtToPfMet_jes does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tMtToPfMet_jes")
        else:
            self.tMtToPfMet_jes_branch.SetAddress(<void*>&self.tMtToPfMet_jes_value)

        #print "making tMtToPfMet_mes"
        self.tMtToPfMet_mes_branch = the_tree.GetBranch("tMtToPfMet_mes")
        #if not self.tMtToPfMet_mes_branch and "tMtToPfMet_mes" not in self.complained:
        if not self.tMtToPfMet_mes_branch and "tMtToPfMet_mes":
            warnings.warn( "EEETauTree: Expected branch tMtToPfMet_mes does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tMtToPfMet_mes")
        else:
            self.tMtToPfMet_mes_branch.SetAddress(<void*>&self.tMtToPfMet_mes_value)

        #print "making tMtToPfMet_tes"
        self.tMtToPfMet_tes_branch = the_tree.GetBranch("tMtToPfMet_tes")
        #if not self.tMtToPfMet_tes_branch and "tMtToPfMet_tes" not in self.complained:
        if not self.tMtToPfMet_tes_branch and "tMtToPfMet_tes":
            warnings.warn( "EEETauTree: Expected branch tMtToPfMet_tes does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tMtToPfMet_tes")
        else:
            self.tMtToPfMet_tes_branch.SetAddress(<void*>&self.tMtToPfMet_tes_value)

        #print "making tMtToPfMet_ues"
        self.tMtToPfMet_ues_branch = the_tree.GetBranch("tMtToPfMet_ues")
        #if not self.tMtToPfMet_ues_branch and "tMtToPfMet_ues" not in self.complained:
        if not self.tMtToPfMet_ues_branch and "tMtToPfMet_ues":
            warnings.warn( "EEETauTree: Expected branch tMtToPfMet_ues does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tMtToPfMet_ues")
        else:
            self.tMtToPfMet_ues_branch.SetAddress(<void*>&self.tMtToPfMet_ues_value)

        #print "making tMuOverlap"
        self.tMuOverlap_branch = the_tree.GetBranch("tMuOverlap")
        #if not self.tMuOverlap_branch and "tMuOverlap" not in self.complained:
        if not self.tMuOverlap_branch and "tMuOverlap":
            warnings.warn( "EEETauTree: Expected branch tMuOverlap does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tMuOverlap")
        else:
            self.tMuOverlap_branch.SetAddress(<void*>&self.tMuOverlap_value)

        #print "making tMuOverlapZHLoose"
        self.tMuOverlapZHLoose_branch = the_tree.GetBranch("tMuOverlapZHLoose")
        #if not self.tMuOverlapZHLoose_branch and "tMuOverlapZHLoose" not in self.complained:
        if not self.tMuOverlapZHLoose_branch and "tMuOverlapZHLoose":
            warnings.warn( "EEETauTree: Expected branch tMuOverlapZHLoose does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tMuOverlapZHLoose")
        else:
            self.tMuOverlapZHLoose_branch.SetAddress(<void*>&self.tMuOverlapZHLoose_value)

        #print "making tMuOverlapZHTight"
        self.tMuOverlapZHTight_branch = the_tree.GetBranch("tMuOverlapZHTight")
        #if not self.tMuOverlapZHTight_branch and "tMuOverlapZHTight" not in self.complained:
        if not self.tMuOverlapZHTight_branch and "tMuOverlapZHTight":
            warnings.warn( "EEETauTree: Expected branch tMuOverlapZHTight does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tMuOverlapZHTight")
        else:
            self.tMuOverlapZHTight_branch.SetAddress(<void*>&self.tMuOverlapZHTight_value)

        #print "making tPhi"
        self.tPhi_branch = the_tree.GetBranch("tPhi")
        #if not self.tPhi_branch and "tPhi" not in self.complained:
        if not self.tPhi_branch and "tPhi":
            warnings.warn( "EEETauTree: Expected branch tPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tPhi")
        else:
            self.tPhi_branch.SetAddress(<void*>&self.tPhi_value)

        #print "making tPt"
        self.tPt_branch = the_tree.GetBranch("tPt")
        #if not self.tPt_branch and "tPt" not in self.complained:
        if not self.tPt_branch and "tPt":
            warnings.warn( "EEETauTree: Expected branch tPt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tPt")
        else:
            self.tPt_branch.SetAddress(<void*>&self.tPt_value)

        #print "making tRank"
        self.tRank_branch = the_tree.GetBranch("tRank")
        #if not self.tRank_branch and "tRank" not in self.complained:
        if not self.tRank_branch and "tRank":
            warnings.warn( "EEETauTree: Expected branch tRank does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tRank")
        else:
            self.tRank_branch.SetAddress(<void*>&self.tRank_value)

        #print "making tTNPId"
        self.tTNPId_branch = the_tree.GetBranch("tTNPId")
        #if not self.tTNPId_branch and "tTNPId" not in self.complained:
        if not self.tTNPId_branch and "tTNPId":
            warnings.warn( "EEETauTree: Expected branch tTNPId does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tTNPId")
        else:
            self.tTNPId_branch.SetAddress(<void*>&self.tTNPId_value)

        #print "making tTightIso"
        self.tTightIso_branch = the_tree.GetBranch("tTightIso")
        #if not self.tTightIso_branch and "tTightIso" not in self.complained:
        if not self.tTightIso_branch and "tTightIso":
            warnings.warn( "EEETauTree: Expected branch tTightIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tTightIso")
        else:
            self.tTightIso_branch.SetAddress(<void*>&self.tTightIso_value)

        #print "making tTightIso3Hits"
        self.tTightIso3Hits_branch = the_tree.GetBranch("tTightIso3Hits")
        #if not self.tTightIso3Hits_branch and "tTightIso3Hits" not in self.complained:
        if not self.tTightIso3Hits_branch and "tTightIso3Hits":
            warnings.warn( "EEETauTree: Expected branch tTightIso3Hits does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tTightIso3Hits")
        else:
            self.tTightIso3Hits_branch.SetAddress(<void*>&self.tTightIso3Hits_value)

        #print "making tTightMVA2Iso"
        self.tTightMVA2Iso_branch = the_tree.GetBranch("tTightMVA2Iso")
        #if not self.tTightMVA2Iso_branch and "tTightMVA2Iso" not in self.complained:
        if not self.tTightMVA2Iso_branch and "tTightMVA2Iso":
            warnings.warn( "EEETauTree: Expected branch tTightMVA2Iso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tTightMVA2Iso")
        else:
            self.tTightMVA2Iso_branch.SetAddress(<void*>&self.tTightMVA2Iso_value)

        #print "making tTightMVAIso"
        self.tTightMVAIso_branch = the_tree.GetBranch("tTightMVAIso")
        #if not self.tTightMVAIso_branch and "tTightMVAIso" not in self.complained:
        if not self.tTightMVAIso_branch and "tTightMVAIso":
            warnings.warn( "EEETauTree: Expected branch tTightMVAIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tTightMVAIso")
        else:
            self.tTightMVAIso_branch.SetAddress(<void*>&self.tTightMVAIso_value)

        #print "making tToMETDPhi"
        self.tToMETDPhi_branch = the_tree.GetBranch("tToMETDPhi")
        #if not self.tToMETDPhi_branch and "tToMETDPhi" not in self.complained:
        if not self.tToMETDPhi_branch and "tToMETDPhi":
            warnings.warn( "EEETauTree: Expected branch tToMETDPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tToMETDPhi")
        else:
            self.tToMETDPhi_branch.SetAddress(<void*>&self.tToMETDPhi_value)

        #print "making tVLooseIso"
        self.tVLooseIso_branch = the_tree.GetBranch("tVLooseIso")
        #if not self.tVLooseIso_branch and "tVLooseIso" not in self.complained:
        if not self.tVLooseIso_branch and "tVLooseIso":
            warnings.warn( "EEETauTree: Expected branch tVLooseIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tVLooseIso")
        else:
            self.tVLooseIso_branch.SetAddress(<void*>&self.tVLooseIso_value)

        #print "making tVZ"
        self.tVZ_branch = the_tree.GetBranch("tVZ")
        #if not self.tVZ_branch and "tVZ" not in self.complained:
        if not self.tVZ_branch and "tVZ":
            warnings.warn( "EEETauTree: Expected branch tVZ does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tVZ")
        else:
            self.tVZ_branch.SetAddress(<void*>&self.tVZ_value)

        #print "making tauHpsVetoPt20"
        self.tauHpsVetoPt20_branch = the_tree.GetBranch("tauHpsVetoPt20")
        #if not self.tauHpsVetoPt20_branch and "tauHpsVetoPt20" not in self.complained:
        if not self.tauHpsVetoPt20_branch and "tauHpsVetoPt20":
            warnings.warn( "EEETauTree: Expected branch tauHpsVetoPt20 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tauHpsVetoPt20")
        else:
            self.tauHpsVetoPt20_branch.SetAddress(<void*>&self.tauHpsVetoPt20_value)

        #print "making tauTightCountZH"
        self.tauTightCountZH_branch = the_tree.GetBranch("tauTightCountZH")
        #if not self.tauTightCountZH_branch and "tauTightCountZH" not in self.complained:
        if not self.tauTightCountZH_branch and "tauTightCountZH":
            warnings.warn( "EEETauTree: Expected branch tauTightCountZH does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tauTightCountZH")
        else:
            self.tauTightCountZH_branch.SetAddress(<void*>&self.tauTightCountZH_value)

        #print "making tauVetoPt20"
        self.tauVetoPt20_branch = the_tree.GetBranch("tauVetoPt20")
        #if not self.tauVetoPt20_branch and "tauVetoPt20" not in self.complained:
        if not self.tauVetoPt20_branch and "tauVetoPt20":
            warnings.warn( "EEETauTree: Expected branch tauVetoPt20 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tauVetoPt20")
        else:
            self.tauVetoPt20_branch.SetAddress(<void*>&self.tauVetoPt20_value)

        #print "making tauVetoPt20Loose3HitsVtx"
        self.tauVetoPt20Loose3HitsVtx_branch = the_tree.GetBranch("tauVetoPt20Loose3HitsVtx")
        #if not self.tauVetoPt20Loose3HitsVtx_branch and "tauVetoPt20Loose3HitsVtx" not in self.complained:
        if not self.tauVetoPt20Loose3HitsVtx_branch and "tauVetoPt20Loose3HitsVtx":
            warnings.warn( "EEETauTree: Expected branch tauVetoPt20Loose3HitsVtx does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tauVetoPt20Loose3HitsVtx")
        else:
            self.tauVetoPt20Loose3HitsVtx_branch.SetAddress(<void*>&self.tauVetoPt20Loose3HitsVtx_value)

        #print "making tauVetoPt20LooseMVA2Vtx"
        self.tauVetoPt20LooseMVA2Vtx_branch = the_tree.GetBranch("tauVetoPt20LooseMVA2Vtx")
        #if not self.tauVetoPt20LooseMVA2Vtx_branch and "tauVetoPt20LooseMVA2Vtx" not in self.complained:
        if not self.tauVetoPt20LooseMVA2Vtx_branch and "tauVetoPt20LooseMVA2Vtx":
            warnings.warn( "EEETauTree: Expected branch tauVetoPt20LooseMVA2Vtx does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tauVetoPt20LooseMVA2Vtx")
        else:
            self.tauVetoPt20LooseMVA2Vtx_branch.SetAddress(<void*>&self.tauVetoPt20LooseMVA2Vtx_value)

        #print "making tauVetoPt20LooseMVAVtx"
        self.tauVetoPt20LooseMVAVtx_branch = the_tree.GetBranch("tauVetoPt20LooseMVAVtx")
        #if not self.tauVetoPt20LooseMVAVtx_branch and "tauVetoPt20LooseMVAVtx" not in self.complained:
        if not self.tauVetoPt20LooseMVAVtx_branch and "tauVetoPt20LooseMVAVtx":
            warnings.warn( "EEETauTree: Expected branch tauVetoPt20LooseMVAVtx does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tauVetoPt20LooseMVAVtx")
        else:
            self.tauVetoPt20LooseMVAVtx_branch.SetAddress(<void*>&self.tauVetoPt20LooseMVAVtx_value)

        #print "making tauVetoPt20VLooseHPSVtx"
        self.tauVetoPt20VLooseHPSVtx_branch = the_tree.GetBranch("tauVetoPt20VLooseHPSVtx")
        #if not self.tauVetoPt20VLooseHPSVtx_branch and "tauVetoPt20VLooseHPSVtx" not in self.complained:
        if not self.tauVetoPt20VLooseHPSVtx_branch and "tauVetoPt20VLooseHPSVtx":
            warnings.warn( "EEETauTree: Expected branch tauVetoPt20VLooseHPSVtx does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tauVetoPt20VLooseHPSVtx")
        else:
            self.tauVetoPt20VLooseHPSVtx_branch.SetAddress(<void*>&self.tauVetoPt20VLooseHPSVtx_value)

        #print "making tauVetoZH"
        self.tauVetoZH_branch = the_tree.GetBranch("tauVetoZH")
        #if not self.tauVetoZH_branch and "tauVetoZH" not in self.complained:
        if not self.tauVetoZH_branch and "tauVetoZH":
            warnings.warn( "EEETauTree: Expected branch tauVetoZH does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tauVetoZH")
        else:
            self.tauVetoZH_branch.SetAddress(<void*>&self.tauVetoZH_value)

        #print "making type1_pfMetEt"
        self.type1_pfMetEt_branch = the_tree.GetBranch("type1_pfMetEt")
        #if not self.type1_pfMetEt_branch and "type1_pfMetEt" not in self.complained:
        if not self.type1_pfMetEt_branch and "type1_pfMetEt":
            warnings.warn( "EEETauTree: Expected branch type1_pfMetEt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMetEt")
        else:
            self.type1_pfMetEt_branch.SetAddress(<void*>&self.type1_pfMetEt_value)

        #print "making type1_pfMetPhi"
        self.type1_pfMetPhi_branch = the_tree.GetBranch("type1_pfMetPhi")
        #if not self.type1_pfMetPhi_branch and "type1_pfMetPhi" not in self.complained:
        if not self.type1_pfMetPhi_branch and "type1_pfMetPhi":
            warnings.warn( "EEETauTree: Expected branch type1_pfMetPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMetPhi")
        else:
            self.type1_pfMetPhi_branch.SetAddress(<void*>&self.type1_pfMetPhi_value)

        #print "making idx"
        self.idx_branch = the_tree.GetBranch("idx")
        #if not self.idx_branch and "idx" not in self.complained:
        if not self.idx_branch and "idx":
            warnings.warn( "EEETauTree: Expected branch idx does not exist!"                " It will crash if you try and use it!",Warning)
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

    property e1AbsEta:
        def __get__(self):
            self.e1AbsEta_branch.GetEntry(self.localentry, 0)
            return self.e1AbsEta_value

    property e1CBID_LOOSE:
        def __get__(self):
            self.e1CBID_LOOSE_branch.GetEntry(self.localentry, 0)
            return self.e1CBID_LOOSE_value

    property e1CBID_MEDIUM:
        def __get__(self):
            self.e1CBID_MEDIUM_branch.GetEntry(self.localentry, 0)
            return self.e1CBID_MEDIUM_value

    property e1CBID_TIGHT:
        def __get__(self):
            self.e1CBID_TIGHT_branch.GetEntry(self.localentry, 0)
            return self.e1CBID_TIGHT_value

    property e1CBID_VETO:
        def __get__(self):
            self.e1CBID_VETO_branch.GetEntry(self.localentry, 0)
            return self.e1CBID_VETO_value

    property e1Charge:
        def __get__(self):
            self.e1Charge_branch.GetEntry(self.localentry, 0)
            return self.e1Charge_value

    property e1ChargeIdLoose:
        def __get__(self):
            self.e1ChargeIdLoose_branch.GetEntry(self.localentry, 0)
            return self.e1ChargeIdLoose_value

    property e1ChargeIdMed:
        def __get__(self):
            self.e1ChargeIdMed_branch.GetEntry(self.localentry, 0)
            return self.e1ChargeIdMed_value

    property e1ChargeIdTight:
        def __get__(self):
            self.e1ChargeIdTight_branch.GetEntry(self.localentry, 0)
            return self.e1ChargeIdTight_value

    property e1CiCTight:
        def __get__(self):
            self.e1CiCTight_branch.GetEntry(self.localentry, 0)
            return self.e1CiCTight_value

    property e1CiCTightElecOverlap:
        def __get__(self):
            self.e1CiCTightElecOverlap_branch.GetEntry(self.localentry, 0)
            return self.e1CiCTightElecOverlap_value

    property e1ComesFromHiggs:
        def __get__(self):
            self.e1ComesFromHiggs_branch.GetEntry(self.localentry, 0)
            return self.e1ComesFromHiggs_value

    property e1DZ:
        def __get__(self):
            self.e1DZ_branch.GetEntry(self.localentry, 0)
            return self.e1DZ_value

    property e1E1x5:
        def __get__(self):
            self.e1E1x5_branch.GetEntry(self.localentry, 0)
            return self.e1E1x5_value

    property e1E2x5Max:
        def __get__(self):
            self.e1E2x5Max_branch.GetEntry(self.localentry, 0)
            return self.e1E2x5Max_value

    property e1E5x5:
        def __get__(self):
            self.e1E5x5_branch.GetEntry(self.localentry, 0)
            return self.e1E5x5_value

    property e1ECorrReg_2012Jul13ReReco:
        def __get__(self):
            self.e1ECorrReg_2012Jul13ReReco_branch.GetEntry(self.localentry, 0)
            return self.e1ECorrReg_2012Jul13ReReco_value

    property e1ECorrReg_Fall11:
        def __get__(self):
            self.e1ECorrReg_Fall11_branch.GetEntry(self.localentry, 0)
            return self.e1ECorrReg_Fall11_value

    property e1ECorrReg_Jan16ReReco:
        def __get__(self):
            self.e1ECorrReg_Jan16ReReco_branch.GetEntry(self.localentry, 0)
            return self.e1ECorrReg_Jan16ReReco_value

    property e1ECorrReg_Summer12_DR53X_HCP2012:
        def __get__(self):
            self.e1ECorrReg_Summer12_DR53X_HCP2012_branch.GetEntry(self.localentry, 0)
            return self.e1ECorrReg_Summer12_DR53X_HCP2012_value

    property e1ECorrSmearedNoReg_2012Jul13ReReco:
        def __get__(self):
            self.e1ECorrSmearedNoReg_2012Jul13ReReco_branch.GetEntry(self.localentry, 0)
            return self.e1ECorrSmearedNoReg_2012Jul13ReReco_value

    property e1ECorrSmearedNoReg_Fall11:
        def __get__(self):
            self.e1ECorrSmearedNoReg_Fall11_branch.GetEntry(self.localentry, 0)
            return self.e1ECorrSmearedNoReg_Fall11_value

    property e1ECorrSmearedNoReg_Jan16ReReco:
        def __get__(self):
            self.e1ECorrSmearedNoReg_Jan16ReReco_branch.GetEntry(self.localentry, 0)
            return self.e1ECorrSmearedNoReg_Jan16ReReco_value

    property e1ECorrSmearedNoReg_Summer12_DR53X_HCP2012:
        def __get__(self):
            self.e1ECorrSmearedNoReg_Summer12_DR53X_HCP2012_branch.GetEntry(self.localentry, 0)
            return self.e1ECorrSmearedNoReg_Summer12_DR53X_HCP2012_value

    property e1ECorrSmearedReg_2012Jul13ReReco:
        def __get__(self):
            self.e1ECorrSmearedReg_2012Jul13ReReco_branch.GetEntry(self.localentry, 0)
            return self.e1ECorrSmearedReg_2012Jul13ReReco_value

    property e1ECorrSmearedReg_Fall11:
        def __get__(self):
            self.e1ECorrSmearedReg_Fall11_branch.GetEntry(self.localentry, 0)
            return self.e1ECorrSmearedReg_Fall11_value

    property e1ECorrSmearedReg_Jan16ReReco:
        def __get__(self):
            self.e1ECorrSmearedReg_Jan16ReReco_branch.GetEntry(self.localentry, 0)
            return self.e1ECorrSmearedReg_Jan16ReReco_value

    property e1ECorrSmearedReg_Summer12_DR53X_HCP2012:
        def __get__(self):
            self.e1ECorrSmearedReg_Summer12_DR53X_HCP2012_branch.GetEntry(self.localentry, 0)
            return self.e1ECorrSmearedReg_Summer12_DR53X_HCP2012_value

    property e1EcalIsoDR03:
        def __get__(self):
            self.e1EcalIsoDR03_branch.GetEntry(self.localentry, 0)
            return self.e1EcalIsoDR03_value

    property e1EffectiveArea2011Data:
        def __get__(self):
            self.e1EffectiveArea2011Data_branch.GetEntry(self.localentry, 0)
            return self.e1EffectiveArea2011Data_value

    property e1EffectiveArea2012Data:
        def __get__(self):
            self.e1EffectiveArea2012Data_branch.GetEntry(self.localentry, 0)
            return self.e1EffectiveArea2012Data_value

    property e1EffectiveAreaFall11MC:
        def __get__(self):
            self.e1EffectiveAreaFall11MC_branch.GetEntry(self.localentry, 0)
            return self.e1EffectiveAreaFall11MC_value

    property e1Ele27WP80PFMT50PFMTFilter:
        def __get__(self):
            self.e1Ele27WP80PFMT50PFMTFilter_branch.GetEntry(self.localentry, 0)
            return self.e1Ele27WP80PFMT50PFMTFilter_value

    property e1Ele27WP80TrackIsoMatchFilter:
        def __get__(self):
            self.e1Ele27WP80TrackIsoMatchFilter_branch.GetEntry(self.localentry, 0)
            return self.e1Ele27WP80TrackIsoMatchFilter_value

    property e1Ele32WP70PFMT50PFMTFilter:
        def __get__(self):
            self.e1Ele32WP70PFMT50PFMTFilter_branch.GetEntry(self.localentry, 0)
            return self.e1Ele32WP70PFMT50PFMTFilter_value

    property e1ElecOverlap:
        def __get__(self):
            self.e1ElecOverlap_branch.GetEntry(self.localentry, 0)
            return self.e1ElecOverlap_value

    property e1ElecOverlapZHLoose:
        def __get__(self):
            self.e1ElecOverlapZHLoose_branch.GetEntry(self.localentry, 0)
            return self.e1ElecOverlapZHLoose_value

    property e1ElecOverlapZHTight:
        def __get__(self):
            self.e1ElecOverlapZHTight_branch.GetEntry(self.localentry, 0)
            return self.e1ElecOverlapZHTight_value

    property e1EnergyError:
        def __get__(self):
            self.e1EnergyError_branch.GetEntry(self.localentry, 0)
            return self.e1EnergyError_value

    property e1Eta:
        def __get__(self):
            self.e1Eta_branch.GetEntry(self.localentry, 0)
            return self.e1Eta_value

    property e1EtaCorrReg_2012Jul13ReReco:
        def __get__(self):
            self.e1EtaCorrReg_2012Jul13ReReco_branch.GetEntry(self.localentry, 0)
            return self.e1EtaCorrReg_2012Jul13ReReco_value

    property e1EtaCorrReg_Fall11:
        def __get__(self):
            self.e1EtaCorrReg_Fall11_branch.GetEntry(self.localentry, 0)
            return self.e1EtaCorrReg_Fall11_value

    property e1EtaCorrReg_Jan16ReReco:
        def __get__(self):
            self.e1EtaCorrReg_Jan16ReReco_branch.GetEntry(self.localentry, 0)
            return self.e1EtaCorrReg_Jan16ReReco_value

    property e1EtaCorrReg_Summer12_DR53X_HCP2012:
        def __get__(self):
            self.e1EtaCorrReg_Summer12_DR53X_HCP2012_branch.GetEntry(self.localentry, 0)
            return self.e1EtaCorrReg_Summer12_DR53X_HCP2012_value

    property e1EtaCorrSmearedNoReg_2012Jul13ReReco:
        def __get__(self):
            self.e1EtaCorrSmearedNoReg_2012Jul13ReReco_branch.GetEntry(self.localentry, 0)
            return self.e1EtaCorrSmearedNoReg_2012Jul13ReReco_value

    property e1EtaCorrSmearedNoReg_Fall11:
        def __get__(self):
            self.e1EtaCorrSmearedNoReg_Fall11_branch.GetEntry(self.localentry, 0)
            return self.e1EtaCorrSmearedNoReg_Fall11_value

    property e1EtaCorrSmearedNoReg_Jan16ReReco:
        def __get__(self):
            self.e1EtaCorrSmearedNoReg_Jan16ReReco_branch.GetEntry(self.localentry, 0)
            return self.e1EtaCorrSmearedNoReg_Jan16ReReco_value

    property e1EtaCorrSmearedNoReg_Summer12_DR53X_HCP2012:
        def __get__(self):
            self.e1EtaCorrSmearedNoReg_Summer12_DR53X_HCP2012_branch.GetEntry(self.localentry, 0)
            return self.e1EtaCorrSmearedNoReg_Summer12_DR53X_HCP2012_value

    property e1EtaCorrSmearedReg_2012Jul13ReReco:
        def __get__(self):
            self.e1EtaCorrSmearedReg_2012Jul13ReReco_branch.GetEntry(self.localentry, 0)
            return self.e1EtaCorrSmearedReg_2012Jul13ReReco_value

    property e1EtaCorrSmearedReg_Fall11:
        def __get__(self):
            self.e1EtaCorrSmearedReg_Fall11_branch.GetEntry(self.localentry, 0)
            return self.e1EtaCorrSmearedReg_Fall11_value

    property e1EtaCorrSmearedReg_Jan16ReReco:
        def __get__(self):
            self.e1EtaCorrSmearedReg_Jan16ReReco_branch.GetEntry(self.localentry, 0)
            return self.e1EtaCorrSmearedReg_Jan16ReReco_value

    property e1EtaCorrSmearedReg_Summer12_DR53X_HCP2012:
        def __get__(self):
            self.e1EtaCorrSmearedReg_Summer12_DR53X_HCP2012_branch.GetEntry(self.localentry, 0)
            return self.e1EtaCorrSmearedReg_Summer12_DR53X_HCP2012_value

    property e1GenCharge:
        def __get__(self):
            self.e1GenCharge_branch.GetEntry(self.localentry, 0)
            return self.e1GenCharge_value

    property e1GenEnergy:
        def __get__(self):
            self.e1GenEnergy_branch.GetEntry(self.localentry, 0)
            return self.e1GenEnergy_value

    property e1GenEta:
        def __get__(self):
            self.e1GenEta_branch.GetEntry(self.localentry, 0)
            return self.e1GenEta_value

    property e1GenMotherPdgId:
        def __get__(self):
            self.e1GenMotherPdgId_branch.GetEntry(self.localentry, 0)
            return self.e1GenMotherPdgId_value

    property e1GenPdgId:
        def __get__(self):
            self.e1GenPdgId_branch.GetEntry(self.localentry, 0)
            return self.e1GenPdgId_value

    property e1GenPhi:
        def __get__(self):
            self.e1GenPhi_branch.GetEntry(self.localentry, 0)
            return self.e1GenPhi_value

    property e1HadronicDepth1OverEm:
        def __get__(self):
            self.e1HadronicDepth1OverEm_branch.GetEntry(self.localentry, 0)
            return self.e1HadronicDepth1OverEm_value

    property e1HadronicDepth2OverEm:
        def __get__(self):
            self.e1HadronicDepth2OverEm_branch.GetEntry(self.localentry, 0)
            return self.e1HadronicDepth2OverEm_value

    property e1HadronicOverEM:
        def __get__(self):
            self.e1HadronicOverEM_branch.GetEntry(self.localentry, 0)
            return self.e1HadronicOverEM_value

    property e1HasConversion:
        def __get__(self):
            self.e1HasConversion_branch.GetEntry(self.localentry, 0)
            return self.e1HasConversion_value

    property e1HasMatchedConversion:
        def __get__(self):
            self.e1HasMatchedConversion_branch.GetEntry(self.localentry, 0)
            return self.e1HasMatchedConversion_value

    property e1HcalIsoDR03:
        def __get__(self):
            self.e1HcalIsoDR03_branch.GetEntry(self.localentry, 0)
            return self.e1HcalIsoDR03_value

    property e1IP3DS:
        def __get__(self):
            self.e1IP3DS_branch.GetEntry(self.localentry, 0)
            return self.e1IP3DS_value

    property e1JetArea:
        def __get__(self):
            self.e1JetArea_branch.GetEntry(self.localentry, 0)
            return self.e1JetArea_value

    property e1JetBtag:
        def __get__(self):
            self.e1JetBtag_branch.GetEntry(self.localentry, 0)
            return self.e1JetBtag_value

    property e1JetCSVBtag:
        def __get__(self):
            self.e1JetCSVBtag_branch.GetEntry(self.localentry, 0)
            return self.e1JetCSVBtag_value

    property e1JetEtaEtaMoment:
        def __get__(self):
            self.e1JetEtaEtaMoment_branch.GetEntry(self.localentry, 0)
            return self.e1JetEtaEtaMoment_value

    property e1JetEtaPhiMoment:
        def __get__(self):
            self.e1JetEtaPhiMoment_branch.GetEntry(self.localentry, 0)
            return self.e1JetEtaPhiMoment_value

    property e1JetEtaPhiSpread:
        def __get__(self):
            self.e1JetEtaPhiSpread_branch.GetEntry(self.localentry, 0)
            return self.e1JetEtaPhiSpread_value

    property e1JetPartonFlavour:
        def __get__(self):
            self.e1JetPartonFlavour_branch.GetEntry(self.localentry, 0)
            return self.e1JetPartonFlavour_value

    property e1JetPhiPhiMoment:
        def __get__(self):
            self.e1JetPhiPhiMoment_branch.GetEntry(self.localentry, 0)
            return self.e1JetPhiPhiMoment_value

    property e1JetPt:
        def __get__(self):
            self.e1JetPt_branch.GetEntry(self.localentry, 0)
            return self.e1JetPt_value

    property e1JetQGLikelihoodID:
        def __get__(self):
            self.e1JetQGLikelihoodID_branch.GetEntry(self.localentry, 0)
            return self.e1JetQGLikelihoodID_value

    property e1JetQGMVAID:
        def __get__(self):
            self.e1JetQGMVAID_branch.GetEntry(self.localentry, 0)
            return self.e1JetQGMVAID_value

    property e1Jetaxis1:
        def __get__(self):
            self.e1Jetaxis1_branch.GetEntry(self.localentry, 0)
            return self.e1Jetaxis1_value

    property e1Jetaxis2:
        def __get__(self):
            self.e1Jetaxis2_branch.GetEntry(self.localentry, 0)
            return self.e1Jetaxis2_value

    property e1Jetmult:
        def __get__(self):
            self.e1Jetmult_branch.GetEntry(self.localentry, 0)
            return self.e1Jetmult_value

    property e1JetmultMLP:
        def __get__(self):
            self.e1JetmultMLP_branch.GetEntry(self.localentry, 0)
            return self.e1JetmultMLP_value

    property e1JetmultMLPQC:
        def __get__(self):
            self.e1JetmultMLPQC_branch.GetEntry(self.localentry, 0)
            return self.e1JetmultMLPQC_value

    property e1JetptD:
        def __get__(self):
            self.e1JetptD_branch.GetEntry(self.localentry, 0)
            return self.e1JetptD_value

    property e1L1NonIsoHLTNonIsoMu17Ele8PixelMatchFilter:
        def __get__(self):
            self.e1L1NonIsoHLTNonIsoMu17Ele8PixelMatchFilter_branch.GetEntry(self.localentry, 0)
            return self.e1L1NonIsoHLTNonIsoMu17Ele8PixelMatchFilter_value

    property e1MITID:
        def __get__(self):
            self.e1MITID_branch.GetEntry(self.localentry, 0)
            return self.e1MITID_value

    property e1MVAIDH2TauWP:
        def __get__(self):
            self.e1MVAIDH2TauWP_branch.GetEntry(self.localentry, 0)
            return self.e1MVAIDH2TauWP_value

    property e1MVANonTrig:
        def __get__(self):
            self.e1MVANonTrig_branch.GetEntry(self.localentry, 0)
            return self.e1MVANonTrig_value

    property e1MVATrig:
        def __get__(self):
            self.e1MVATrig_branch.GetEntry(self.localentry, 0)
            return self.e1MVATrig_value

    property e1MVATrigIDISO:
        def __get__(self):
            self.e1MVATrigIDISO_branch.GetEntry(self.localentry, 0)
            return self.e1MVATrigIDISO_value

    property e1MVATrigIDISOPUSUB:
        def __get__(self):
            self.e1MVATrigIDISOPUSUB_branch.GetEntry(self.localentry, 0)
            return self.e1MVATrigIDISOPUSUB_value

    property e1MVATrigNoIP:
        def __get__(self):
            self.e1MVATrigNoIP_branch.GetEntry(self.localentry, 0)
            return self.e1MVATrigNoIP_value

    property e1Mass:
        def __get__(self):
            self.e1Mass_branch.GetEntry(self.localentry, 0)
            return self.e1Mass_value

    property e1MatchesDoubleEPath:
        def __get__(self):
            self.e1MatchesDoubleEPath_branch.GetEntry(self.localentry, 0)
            return self.e1MatchesDoubleEPath_value

    property e1MatchesMu17Ele8IsoPath:
        def __get__(self):
            self.e1MatchesMu17Ele8IsoPath_branch.GetEntry(self.localentry, 0)
            return self.e1MatchesMu17Ele8IsoPath_value

    property e1MatchesMu17Ele8Path:
        def __get__(self):
            self.e1MatchesMu17Ele8Path_branch.GetEntry(self.localentry, 0)
            return self.e1MatchesMu17Ele8Path_value

    property e1MatchesMu8Ele17IsoPath:
        def __get__(self):
            self.e1MatchesMu8Ele17IsoPath_branch.GetEntry(self.localentry, 0)
            return self.e1MatchesMu8Ele17IsoPath_value

    property e1MatchesMu8Ele17Path:
        def __get__(self):
            self.e1MatchesMu8Ele17Path_branch.GetEntry(self.localentry, 0)
            return self.e1MatchesMu8Ele17Path_value

    property e1MatchesSingleE:
        def __get__(self):
            self.e1MatchesSingleE_branch.GetEntry(self.localentry, 0)
            return self.e1MatchesSingleE_value

    property e1MatchesSingleEPlusMET:
        def __get__(self):
            self.e1MatchesSingleEPlusMET_branch.GetEntry(self.localentry, 0)
            return self.e1MatchesSingleEPlusMET_value

    property e1MissingHits:
        def __get__(self):
            self.e1MissingHits_branch.GetEntry(self.localentry, 0)
            return self.e1MissingHits_value

    property e1MtToMET:
        def __get__(self):
            self.e1MtToMET_branch.GetEntry(self.localentry, 0)
            return self.e1MtToMET_value

    property e1MtToMVAMET:
        def __get__(self):
            self.e1MtToMVAMET_branch.GetEntry(self.localentry, 0)
            return self.e1MtToMVAMET_value

    property e1MtToPFMET:
        def __get__(self):
            self.e1MtToPFMET_branch.GetEntry(self.localentry, 0)
            return self.e1MtToPFMET_value

    property e1MtToPfMet_Ty1:
        def __get__(self):
            self.e1MtToPfMet_Ty1_branch.GetEntry(self.localentry, 0)
            return self.e1MtToPfMet_Ty1_value

    property e1MtToPfMet_jes:
        def __get__(self):
            self.e1MtToPfMet_jes_branch.GetEntry(self.localentry, 0)
            return self.e1MtToPfMet_jes_value

    property e1MtToPfMet_mes:
        def __get__(self):
            self.e1MtToPfMet_mes_branch.GetEntry(self.localentry, 0)
            return self.e1MtToPfMet_mes_value

    property e1MtToPfMet_tes:
        def __get__(self):
            self.e1MtToPfMet_tes_branch.GetEntry(self.localentry, 0)
            return self.e1MtToPfMet_tes_value

    property e1MtToPfMet_ues:
        def __get__(self):
            self.e1MtToPfMet_ues_branch.GetEntry(self.localentry, 0)
            return self.e1MtToPfMet_ues_value

    property e1Mu17Ele8CaloIdTCaloIsoVLTrkIdVLTrkIsoVLTrackIsoFilter:
        def __get__(self):
            self.e1Mu17Ele8CaloIdTCaloIsoVLTrkIdVLTrkIsoVLTrackIsoFilter_branch.GetEntry(self.localentry, 0)
            return self.e1Mu17Ele8CaloIdTCaloIsoVLTrkIdVLTrkIsoVLTrackIsoFilter_value

    property e1Mu17Ele8CaloIdTPixelMatchFilter:
        def __get__(self):
            self.e1Mu17Ele8CaloIdTPixelMatchFilter_branch.GetEntry(self.localentry, 0)
            return self.e1Mu17Ele8CaloIdTPixelMatchFilter_value

    property e1Mu17Ele8dZFilter:
        def __get__(self):
            self.e1Mu17Ele8dZFilter_branch.GetEntry(self.localentry, 0)
            return self.e1Mu17Ele8dZFilter_value

    property e1MuOverlap:
        def __get__(self):
            self.e1MuOverlap_branch.GetEntry(self.localentry, 0)
            return self.e1MuOverlap_value

    property e1MuOverlapZHLoose:
        def __get__(self):
            self.e1MuOverlapZHLoose_branch.GetEntry(self.localentry, 0)
            return self.e1MuOverlapZHLoose_value

    property e1MuOverlapZHTight:
        def __get__(self):
            self.e1MuOverlapZHTight_branch.GetEntry(self.localentry, 0)
            return self.e1MuOverlapZHTight_value

    property e1NearMuonVeto:
        def __get__(self):
            self.e1NearMuonVeto_branch.GetEntry(self.localentry, 0)
            return self.e1NearMuonVeto_value

    property e1PFChargedIso:
        def __get__(self):
            self.e1PFChargedIso_branch.GetEntry(self.localentry, 0)
            return self.e1PFChargedIso_value

    property e1PFNeutralIso:
        def __get__(self):
            self.e1PFNeutralIso_branch.GetEntry(self.localentry, 0)
            return self.e1PFNeutralIso_value

    property e1PFPhotonIso:
        def __get__(self):
            self.e1PFPhotonIso_branch.GetEntry(self.localentry, 0)
            return self.e1PFPhotonIso_value

    property e1PVDXY:
        def __get__(self):
            self.e1PVDXY_branch.GetEntry(self.localentry, 0)
            return self.e1PVDXY_value

    property e1PVDZ:
        def __get__(self):
            self.e1PVDZ_branch.GetEntry(self.localentry, 0)
            return self.e1PVDZ_value

    property e1Phi:
        def __get__(self):
            self.e1Phi_branch.GetEntry(self.localentry, 0)
            return self.e1Phi_value

    property e1PhiCorrReg_2012Jul13ReReco:
        def __get__(self):
            self.e1PhiCorrReg_2012Jul13ReReco_branch.GetEntry(self.localentry, 0)
            return self.e1PhiCorrReg_2012Jul13ReReco_value

    property e1PhiCorrReg_Fall11:
        def __get__(self):
            self.e1PhiCorrReg_Fall11_branch.GetEntry(self.localentry, 0)
            return self.e1PhiCorrReg_Fall11_value

    property e1PhiCorrReg_Jan16ReReco:
        def __get__(self):
            self.e1PhiCorrReg_Jan16ReReco_branch.GetEntry(self.localentry, 0)
            return self.e1PhiCorrReg_Jan16ReReco_value

    property e1PhiCorrReg_Summer12_DR53X_HCP2012:
        def __get__(self):
            self.e1PhiCorrReg_Summer12_DR53X_HCP2012_branch.GetEntry(self.localentry, 0)
            return self.e1PhiCorrReg_Summer12_DR53X_HCP2012_value

    property e1PhiCorrSmearedNoReg_2012Jul13ReReco:
        def __get__(self):
            self.e1PhiCorrSmearedNoReg_2012Jul13ReReco_branch.GetEntry(self.localentry, 0)
            return self.e1PhiCorrSmearedNoReg_2012Jul13ReReco_value

    property e1PhiCorrSmearedNoReg_Fall11:
        def __get__(self):
            self.e1PhiCorrSmearedNoReg_Fall11_branch.GetEntry(self.localentry, 0)
            return self.e1PhiCorrSmearedNoReg_Fall11_value

    property e1PhiCorrSmearedNoReg_Jan16ReReco:
        def __get__(self):
            self.e1PhiCorrSmearedNoReg_Jan16ReReco_branch.GetEntry(self.localentry, 0)
            return self.e1PhiCorrSmearedNoReg_Jan16ReReco_value

    property e1PhiCorrSmearedNoReg_Summer12_DR53X_HCP2012:
        def __get__(self):
            self.e1PhiCorrSmearedNoReg_Summer12_DR53X_HCP2012_branch.GetEntry(self.localentry, 0)
            return self.e1PhiCorrSmearedNoReg_Summer12_DR53X_HCP2012_value

    property e1PhiCorrSmearedReg_2012Jul13ReReco:
        def __get__(self):
            self.e1PhiCorrSmearedReg_2012Jul13ReReco_branch.GetEntry(self.localentry, 0)
            return self.e1PhiCorrSmearedReg_2012Jul13ReReco_value

    property e1PhiCorrSmearedReg_Fall11:
        def __get__(self):
            self.e1PhiCorrSmearedReg_Fall11_branch.GetEntry(self.localentry, 0)
            return self.e1PhiCorrSmearedReg_Fall11_value

    property e1PhiCorrSmearedReg_Jan16ReReco:
        def __get__(self):
            self.e1PhiCorrSmearedReg_Jan16ReReco_branch.GetEntry(self.localentry, 0)
            return self.e1PhiCorrSmearedReg_Jan16ReReco_value

    property e1PhiCorrSmearedReg_Summer12_DR53X_HCP2012:
        def __get__(self):
            self.e1PhiCorrSmearedReg_Summer12_DR53X_HCP2012_branch.GetEntry(self.localentry, 0)
            return self.e1PhiCorrSmearedReg_Summer12_DR53X_HCP2012_value

    property e1Pt:
        def __get__(self):
            self.e1Pt_branch.GetEntry(self.localentry, 0)
            return self.e1Pt_value

    property e1PtCorrReg_2012Jul13ReReco:
        def __get__(self):
            self.e1PtCorrReg_2012Jul13ReReco_branch.GetEntry(self.localentry, 0)
            return self.e1PtCorrReg_2012Jul13ReReco_value

    property e1PtCorrReg_Fall11:
        def __get__(self):
            self.e1PtCorrReg_Fall11_branch.GetEntry(self.localentry, 0)
            return self.e1PtCorrReg_Fall11_value

    property e1PtCorrReg_Jan16ReReco:
        def __get__(self):
            self.e1PtCorrReg_Jan16ReReco_branch.GetEntry(self.localentry, 0)
            return self.e1PtCorrReg_Jan16ReReco_value

    property e1PtCorrReg_Summer12_DR53X_HCP2012:
        def __get__(self):
            self.e1PtCorrReg_Summer12_DR53X_HCP2012_branch.GetEntry(self.localentry, 0)
            return self.e1PtCorrReg_Summer12_DR53X_HCP2012_value

    property e1PtCorrSmearedNoReg_2012Jul13ReReco:
        def __get__(self):
            self.e1PtCorrSmearedNoReg_2012Jul13ReReco_branch.GetEntry(self.localentry, 0)
            return self.e1PtCorrSmearedNoReg_2012Jul13ReReco_value

    property e1PtCorrSmearedNoReg_Fall11:
        def __get__(self):
            self.e1PtCorrSmearedNoReg_Fall11_branch.GetEntry(self.localentry, 0)
            return self.e1PtCorrSmearedNoReg_Fall11_value

    property e1PtCorrSmearedNoReg_Jan16ReReco:
        def __get__(self):
            self.e1PtCorrSmearedNoReg_Jan16ReReco_branch.GetEntry(self.localentry, 0)
            return self.e1PtCorrSmearedNoReg_Jan16ReReco_value

    property e1PtCorrSmearedNoReg_Summer12_DR53X_HCP2012:
        def __get__(self):
            self.e1PtCorrSmearedNoReg_Summer12_DR53X_HCP2012_branch.GetEntry(self.localentry, 0)
            return self.e1PtCorrSmearedNoReg_Summer12_DR53X_HCP2012_value

    property e1PtCorrSmearedReg_2012Jul13ReReco:
        def __get__(self):
            self.e1PtCorrSmearedReg_2012Jul13ReReco_branch.GetEntry(self.localentry, 0)
            return self.e1PtCorrSmearedReg_2012Jul13ReReco_value

    property e1PtCorrSmearedReg_Fall11:
        def __get__(self):
            self.e1PtCorrSmearedReg_Fall11_branch.GetEntry(self.localentry, 0)
            return self.e1PtCorrSmearedReg_Fall11_value

    property e1PtCorrSmearedReg_Jan16ReReco:
        def __get__(self):
            self.e1PtCorrSmearedReg_Jan16ReReco_branch.GetEntry(self.localentry, 0)
            return self.e1PtCorrSmearedReg_Jan16ReReco_value

    property e1PtCorrSmearedReg_Summer12_DR53X_HCP2012:
        def __get__(self):
            self.e1PtCorrSmearedReg_Summer12_DR53X_HCP2012_branch.GetEntry(self.localentry, 0)
            return self.e1PtCorrSmearedReg_Summer12_DR53X_HCP2012_value

    property e1Rank:
        def __get__(self):
            self.e1Rank_branch.GetEntry(self.localentry, 0)
            return self.e1Rank_value

    property e1RelIso:
        def __get__(self):
            self.e1RelIso_branch.GetEntry(self.localentry, 0)
            return self.e1RelIso_value

    property e1RelPFIsoDB:
        def __get__(self):
            self.e1RelPFIsoDB_branch.GetEntry(self.localentry, 0)
            return self.e1RelPFIsoDB_value

    property e1RelPFIsoRho:
        def __get__(self):
            self.e1RelPFIsoRho_branch.GetEntry(self.localentry, 0)
            return self.e1RelPFIsoRho_value

    property e1RelPFIsoRhoFSR:
        def __get__(self):
            self.e1RelPFIsoRhoFSR_branch.GetEntry(self.localentry, 0)
            return self.e1RelPFIsoRhoFSR_value

    property e1RhoHZG2011:
        def __get__(self):
            self.e1RhoHZG2011_branch.GetEntry(self.localentry, 0)
            return self.e1RhoHZG2011_value

    property e1RhoHZG2012:
        def __get__(self):
            self.e1RhoHZG2012_branch.GetEntry(self.localentry, 0)
            return self.e1RhoHZG2012_value

    property e1SCEnergy:
        def __get__(self):
            self.e1SCEnergy_branch.GetEntry(self.localentry, 0)
            return self.e1SCEnergy_value

    property e1SCEta:
        def __get__(self):
            self.e1SCEta_branch.GetEntry(self.localentry, 0)
            return self.e1SCEta_value

    property e1SCEtaWidth:
        def __get__(self):
            self.e1SCEtaWidth_branch.GetEntry(self.localentry, 0)
            return self.e1SCEtaWidth_value

    property e1SCPhi:
        def __get__(self):
            self.e1SCPhi_branch.GetEntry(self.localentry, 0)
            return self.e1SCPhi_value

    property e1SCPhiWidth:
        def __get__(self):
            self.e1SCPhiWidth_branch.GetEntry(self.localentry, 0)
            return self.e1SCPhiWidth_value

    property e1SCPreshowerEnergy:
        def __get__(self):
            self.e1SCPreshowerEnergy_branch.GetEntry(self.localentry, 0)
            return self.e1SCPreshowerEnergy_value

    property e1SCRawEnergy:
        def __get__(self):
            self.e1SCRawEnergy_branch.GetEntry(self.localentry, 0)
            return self.e1SCRawEnergy_value

    property e1SigmaIEtaIEta:
        def __get__(self):
            self.e1SigmaIEtaIEta_branch.GetEntry(self.localentry, 0)
            return self.e1SigmaIEtaIEta_value

    property e1ToMETDPhi:
        def __get__(self):
            self.e1ToMETDPhi_branch.GetEntry(self.localentry, 0)
            return self.e1ToMETDPhi_value

    property e1TrkIsoDR03:
        def __get__(self):
            self.e1TrkIsoDR03_branch.GetEntry(self.localentry, 0)
            return self.e1TrkIsoDR03_value

    property e1VZ:
        def __get__(self):
            self.e1VZ_branch.GetEntry(self.localentry, 0)
            return self.e1VZ_value

    property e1WWID:
        def __get__(self):
            self.e1WWID_branch.GetEntry(self.localentry, 0)
            return self.e1WWID_value

    property e1_e2_CosThetaStar:
        def __get__(self):
            self.e1_e2_CosThetaStar_branch.GetEntry(self.localentry, 0)
            return self.e1_e2_CosThetaStar_value

    property e1_e2_DPhi:
        def __get__(self):
            self.e1_e2_DPhi_branch.GetEntry(self.localentry, 0)
            return self.e1_e2_DPhi_value

    property e1_e2_DR:
        def __get__(self):
            self.e1_e2_DR_branch.GetEntry(self.localentry, 0)
            return self.e1_e2_DR_value

    property e1_e2_Eta:
        def __get__(self):
            self.e1_e2_Eta_branch.GetEntry(self.localentry, 0)
            return self.e1_e2_Eta_value

    property e1_e2_Mass:
        def __get__(self):
            self.e1_e2_Mass_branch.GetEntry(self.localentry, 0)
            return self.e1_e2_Mass_value

    property e1_e2_MassFsr:
        def __get__(self):
            self.e1_e2_MassFsr_branch.GetEntry(self.localentry, 0)
            return self.e1_e2_MassFsr_value

    property e1_e2_PZeta:
        def __get__(self):
            self.e1_e2_PZeta_branch.GetEntry(self.localentry, 0)
            return self.e1_e2_PZeta_value

    property e1_e2_PZetaVis:
        def __get__(self):
            self.e1_e2_PZetaVis_branch.GetEntry(self.localentry, 0)
            return self.e1_e2_PZetaVis_value

    property e1_e2_Phi:
        def __get__(self):
            self.e1_e2_Phi_branch.GetEntry(self.localentry, 0)
            return self.e1_e2_Phi_value

    property e1_e2_Pt:
        def __get__(self):
            self.e1_e2_Pt_branch.GetEntry(self.localentry, 0)
            return self.e1_e2_Pt_value

    property e1_e2_PtFsr:
        def __get__(self):
            self.e1_e2_PtFsr_branch.GetEntry(self.localentry, 0)
            return self.e1_e2_PtFsr_value

    property e1_e2_SS:
        def __get__(self):
            self.e1_e2_SS_branch.GetEntry(self.localentry, 0)
            return self.e1_e2_SS_value

    property e1_e2_ToMETDPhi_Ty1:
        def __get__(self):
            self.e1_e2_ToMETDPhi_Ty1_branch.GetEntry(self.localentry, 0)
            return self.e1_e2_ToMETDPhi_Ty1_value

    property e1_e2_Zcompat:
        def __get__(self):
            self.e1_e2_Zcompat_branch.GetEntry(self.localentry, 0)
            return self.e1_e2_Zcompat_value

    property e1_e3_CosThetaStar:
        def __get__(self):
            self.e1_e3_CosThetaStar_branch.GetEntry(self.localentry, 0)
            return self.e1_e3_CosThetaStar_value

    property e1_e3_DPhi:
        def __get__(self):
            self.e1_e3_DPhi_branch.GetEntry(self.localentry, 0)
            return self.e1_e3_DPhi_value

    property e1_e3_DR:
        def __get__(self):
            self.e1_e3_DR_branch.GetEntry(self.localentry, 0)
            return self.e1_e3_DR_value

    property e1_e3_Eta:
        def __get__(self):
            self.e1_e3_Eta_branch.GetEntry(self.localentry, 0)
            return self.e1_e3_Eta_value

    property e1_e3_Mass:
        def __get__(self):
            self.e1_e3_Mass_branch.GetEntry(self.localentry, 0)
            return self.e1_e3_Mass_value

    property e1_e3_MassFsr:
        def __get__(self):
            self.e1_e3_MassFsr_branch.GetEntry(self.localentry, 0)
            return self.e1_e3_MassFsr_value

    property e1_e3_PZeta:
        def __get__(self):
            self.e1_e3_PZeta_branch.GetEntry(self.localentry, 0)
            return self.e1_e3_PZeta_value

    property e1_e3_PZetaVis:
        def __get__(self):
            self.e1_e3_PZetaVis_branch.GetEntry(self.localentry, 0)
            return self.e1_e3_PZetaVis_value

    property e1_e3_Phi:
        def __get__(self):
            self.e1_e3_Phi_branch.GetEntry(self.localentry, 0)
            return self.e1_e3_Phi_value

    property e1_e3_Pt:
        def __get__(self):
            self.e1_e3_Pt_branch.GetEntry(self.localentry, 0)
            return self.e1_e3_Pt_value

    property e1_e3_PtFsr:
        def __get__(self):
            self.e1_e3_PtFsr_branch.GetEntry(self.localentry, 0)
            return self.e1_e3_PtFsr_value

    property e1_e3_SS:
        def __get__(self):
            self.e1_e3_SS_branch.GetEntry(self.localentry, 0)
            return self.e1_e3_SS_value

    property e1_e3_ToMETDPhi_Ty1:
        def __get__(self):
            self.e1_e3_ToMETDPhi_Ty1_branch.GetEntry(self.localentry, 0)
            return self.e1_e3_ToMETDPhi_Ty1_value

    property e1_e3_Zcompat:
        def __get__(self):
            self.e1_e3_Zcompat_branch.GetEntry(self.localentry, 0)
            return self.e1_e3_Zcompat_value

    property e1_t_CosThetaStar:
        def __get__(self):
            self.e1_t_CosThetaStar_branch.GetEntry(self.localentry, 0)
            return self.e1_t_CosThetaStar_value

    property e1_t_DPhi:
        def __get__(self):
            self.e1_t_DPhi_branch.GetEntry(self.localentry, 0)
            return self.e1_t_DPhi_value

    property e1_t_DR:
        def __get__(self):
            self.e1_t_DR_branch.GetEntry(self.localentry, 0)
            return self.e1_t_DR_value

    property e1_t_Eta:
        def __get__(self):
            self.e1_t_Eta_branch.GetEntry(self.localentry, 0)
            return self.e1_t_Eta_value

    property e1_t_Mass:
        def __get__(self):
            self.e1_t_Mass_branch.GetEntry(self.localentry, 0)
            return self.e1_t_Mass_value

    property e1_t_MassFsr:
        def __get__(self):
            self.e1_t_MassFsr_branch.GetEntry(self.localentry, 0)
            return self.e1_t_MassFsr_value

    property e1_t_PZeta:
        def __get__(self):
            self.e1_t_PZeta_branch.GetEntry(self.localentry, 0)
            return self.e1_t_PZeta_value

    property e1_t_PZetaVis:
        def __get__(self):
            self.e1_t_PZetaVis_branch.GetEntry(self.localentry, 0)
            return self.e1_t_PZetaVis_value

    property e1_t_Phi:
        def __get__(self):
            self.e1_t_Phi_branch.GetEntry(self.localentry, 0)
            return self.e1_t_Phi_value

    property e1_t_Pt:
        def __get__(self):
            self.e1_t_Pt_branch.GetEntry(self.localentry, 0)
            return self.e1_t_Pt_value

    property e1_t_PtFsr:
        def __get__(self):
            self.e1_t_PtFsr_branch.GetEntry(self.localentry, 0)
            return self.e1_t_PtFsr_value

    property e1_t_SS:
        def __get__(self):
            self.e1_t_SS_branch.GetEntry(self.localentry, 0)
            return self.e1_t_SS_value

    property e1_t_ToMETDPhi_Ty1:
        def __get__(self):
            self.e1_t_ToMETDPhi_Ty1_branch.GetEntry(self.localentry, 0)
            return self.e1_t_ToMETDPhi_Ty1_value

    property e1_t_Zcompat:
        def __get__(self):
            self.e1_t_Zcompat_branch.GetEntry(self.localentry, 0)
            return self.e1_t_Zcompat_value

    property e1dECorrReg_2012Jul13ReReco:
        def __get__(self):
            self.e1dECorrReg_2012Jul13ReReco_branch.GetEntry(self.localentry, 0)
            return self.e1dECorrReg_2012Jul13ReReco_value

    property e1dECorrReg_Fall11:
        def __get__(self):
            self.e1dECorrReg_Fall11_branch.GetEntry(self.localentry, 0)
            return self.e1dECorrReg_Fall11_value

    property e1dECorrReg_Jan16ReReco:
        def __get__(self):
            self.e1dECorrReg_Jan16ReReco_branch.GetEntry(self.localentry, 0)
            return self.e1dECorrReg_Jan16ReReco_value

    property e1dECorrReg_Summer12_DR53X_HCP2012:
        def __get__(self):
            self.e1dECorrReg_Summer12_DR53X_HCP2012_branch.GetEntry(self.localentry, 0)
            return self.e1dECorrReg_Summer12_DR53X_HCP2012_value

    property e1dECorrSmearedNoReg_2012Jul13ReReco:
        def __get__(self):
            self.e1dECorrSmearedNoReg_2012Jul13ReReco_branch.GetEntry(self.localentry, 0)
            return self.e1dECorrSmearedNoReg_2012Jul13ReReco_value

    property e1dECorrSmearedNoReg_Fall11:
        def __get__(self):
            self.e1dECorrSmearedNoReg_Fall11_branch.GetEntry(self.localentry, 0)
            return self.e1dECorrSmearedNoReg_Fall11_value

    property e1dECorrSmearedNoReg_Jan16ReReco:
        def __get__(self):
            self.e1dECorrSmearedNoReg_Jan16ReReco_branch.GetEntry(self.localentry, 0)
            return self.e1dECorrSmearedNoReg_Jan16ReReco_value

    property e1dECorrSmearedNoReg_Summer12_DR53X_HCP2012:
        def __get__(self):
            self.e1dECorrSmearedNoReg_Summer12_DR53X_HCP2012_branch.GetEntry(self.localentry, 0)
            return self.e1dECorrSmearedNoReg_Summer12_DR53X_HCP2012_value

    property e1dECorrSmearedReg_2012Jul13ReReco:
        def __get__(self):
            self.e1dECorrSmearedReg_2012Jul13ReReco_branch.GetEntry(self.localentry, 0)
            return self.e1dECorrSmearedReg_2012Jul13ReReco_value

    property e1dECorrSmearedReg_Fall11:
        def __get__(self):
            self.e1dECorrSmearedReg_Fall11_branch.GetEntry(self.localentry, 0)
            return self.e1dECorrSmearedReg_Fall11_value

    property e1dECorrSmearedReg_Jan16ReReco:
        def __get__(self):
            self.e1dECorrSmearedReg_Jan16ReReco_branch.GetEntry(self.localentry, 0)
            return self.e1dECorrSmearedReg_Jan16ReReco_value

    property e1dECorrSmearedReg_Summer12_DR53X_HCP2012:
        def __get__(self):
            self.e1dECorrSmearedReg_Summer12_DR53X_HCP2012_branch.GetEntry(self.localentry, 0)
            return self.e1dECorrSmearedReg_Summer12_DR53X_HCP2012_value

    property e1deltaEtaSuperClusterTrackAtVtx:
        def __get__(self):
            self.e1deltaEtaSuperClusterTrackAtVtx_branch.GetEntry(self.localentry, 0)
            return self.e1deltaEtaSuperClusterTrackAtVtx_value

    property e1deltaPhiSuperClusterTrackAtVtx:
        def __get__(self):
            self.e1deltaPhiSuperClusterTrackAtVtx_branch.GetEntry(self.localentry, 0)
            return self.e1deltaPhiSuperClusterTrackAtVtx_value

    property e1eSuperClusterOverP:
        def __get__(self):
            self.e1eSuperClusterOverP_branch.GetEntry(self.localentry, 0)
            return self.e1eSuperClusterOverP_value

    property e1ecalEnergy:
        def __get__(self):
            self.e1ecalEnergy_branch.GetEntry(self.localentry, 0)
            return self.e1ecalEnergy_value

    property e1fBrem:
        def __get__(self):
            self.e1fBrem_branch.GetEntry(self.localentry, 0)
            return self.e1fBrem_value

    property e1trackMomentumAtVtxP:
        def __get__(self):
            self.e1trackMomentumAtVtxP_branch.GetEntry(self.localentry, 0)
            return self.e1trackMomentumAtVtxP_value

    property e2AbsEta:
        def __get__(self):
            self.e2AbsEta_branch.GetEntry(self.localentry, 0)
            return self.e2AbsEta_value

    property e2CBID_LOOSE:
        def __get__(self):
            self.e2CBID_LOOSE_branch.GetEntry(self.localentry, 0)
            return self.e2CBID_LOOSE_value

    property e2CBID_MEDIUM:
        def __get__(self):
            self.e2CBID_MEDIUM_branch.GetEntry(self.localentry, 0)
            return self.e2CBID_MEDIUM_value

    property e2CBID_TIGHT:
        def __get__(self):
            self.e2CBID_TIGHT_branch.GetEntry(self.localentry, 0)
            return self.e2CBID_TIGHT_value

    property e2CBID_VETO:
        def __get__(self):
            self.e2CBID_VETO_branch.GetEntry(self.localentry, 0)
            return self.e2CBID_VETO_value

    property e2Charge:
        def __get__(self):
            self.e2Charge_branch.GetEntry(self.localentry, 0)
            return self.e2Charge_value

    property e2ChargeIdLoose:
        def __get__(self):
            self.e2ChargeIdLoose_branch.GetEntry(self.localentry, 0)
            return self.e2ChargeIdLoose_value

    property e2ChargeIdMed:
        def __get__(self):
            self.e2ChargeIdMed_branch.GetEntry(self.localentry, 0)
            return self.e2ChargeIdMed_value

    property e2ChargeIdTight:
        def __get__(self):
            self.e2ChargeIdTight_branch.GetEntry(self.localentry, 0)
            return self.e2ChargeIdTight_value

    property e2CiCTight:
        def __get__(self):
            self.e2CiCTight_branch.GetEntry(self.localentry, 0)
            return self.e2CiCTight_value

    property e2CiCTightElecOverlap:
        def __get__(self):
            self.e2CiCTightElecOverlap_branch.GetEntry(self.localentry, 0)
            return self.e2CiCTightElecOverlap_value

    property e2ComesFromHiggs:
        def __get__(self):
            self.e2ComesFromHiggs_branch.GetEntry(self.localentry, 0)
            return self.e2ComesFromHiggs_value

    property e2DZ:
        def __get__(self):
            self.e2DZ_branch.GetEntry(self.localentry, 0)
            return self.e2DZ_value

    property e2E1x5:
        def __get__(self):
            self.e2E1x5_branch.GetEntry(self.localentry, 0)
            return self.e2E1x5_value

    property e2E2x5Max:
        def __get__(self):
            self.e2E2x5Max_branch.GetEntry(self.localentry, 0)
            return self.e2E2x5Max_value

    property e2E5x5:
        def __get__(self):
            self.e2E5x5_branch.GetEntry(self.localentry, 0)
            return self.e2E5x5_value

    property e2ECorrReg_2012Jul13ReReco:
        def __get__(self):
            self.e2ECorrReg_2012Jul13ReReco_branch.GetEntry(self.localentry, 0)
            return self.e2ECorrReg_2012Jul13ReReco_value

    property e2ECorrReg_Fall11:
        def __get__(self):
            self.e2ECorrReg_Fall11_branch.GetEntry(self.localentry, 0)
            return self.e2ECorrReg_Fall11_value

    property e2ECorrReg_Jan16ReReco:
        def __get__(self):
            self.e2ECorrReg_Jan16ReReco_branch.GetEntry(self.localentry, 0)
            return self.e2ECorrReg_Jan16ReReco_value

    property e2ECorrReg_Summer12_DR53X_HCP2012:
        def __get__(self):
            self.e2ECorrReg_Summer12_DR53X_HCP2012_branch.GetEntry(self.localentry, 0)
            return self.e2ECorrReg_Summer12_DR53X_HCP2012_value

    property e2ECorrSmearedNoReg_2012Jul13ReReco:
        def __get__(self):
            self.e2ECorrSmearedNoReg_2012Jul13ReReco_branch.GetEntry(self.localentry, 0)
            return self.e2ECorrSmearedNoReg_2012Jul13ReReco_value

    property e2ECorrSmearedNoReg_Fall11:
        def __get__(self):
            self.e2ECorrSmearedNoReg_Fall11_branch.GetEntry(self.localentry, 0)
            return self.e2ECorrSmearedNoReg_Fall11_value

    property e2ECorrSmearedNoReg_Jan16ReReco:
        def __get__(self):
            self.e2ECorrSmearedNoReg_Jan16ReReco_branch.GetEntry(self.localentry, 0)
            return self.e2ECorrSmearedNoReg_Jan16ReReco_value

    property e2ECorrSmearedNoReg_Summer12_DR53X_HCP2012:
        def __get__(self):
            self.e2ECorrSmearedNoReg_Summer12_DR53X_HCP2012_branch.GetEntry(self.localentry, 0)
            return self.e2ECorrSmearedNoReg_Summer12_DR53X_HCP2012_value

    property e2ECorrSmearedReg_2012Jul13ReReco:
        def __get__(self):
            self.e2ECorrSmearedReg_2012Jul13ReReco_branch.GetEntry(self.localentry, 0)
            return self.e2ECorrSmearedReg_2012Jul13ReReco_value

    property e2ECorrSmearedReg_Fall11:
        def __get__(self):
            self.e2ECorrSmearedReg_Fall11_branch.GetEntry(self.localentry, 0)
            return self.e2ECorrSmearedReg_Fall11_value

    property e2ECorrSmearedReg_Jan16ReReco:
        def __get__(self):
            self.e2ECorrSmearedReg_Jan16ReReco_branch.GetEntry(self.localentry, 0)
            return self.e2ECorrSmearedReg_Jan16ReReco_value

    property e2ECorrSmearedReg_Summer12_DR53X_HCP2012:
        def __get__(self):
            self.e2ECorrSmearedReg_Summer12_DR53X_HCP2012_branch.GetEntry(self.localentry, 0)
            return self.e2ECorrSmearedReg_Summer12_DR53X_HCP2012_value

    property e2EcalIsoDR03:
        def __get__(self):
            self.e2EcalIsoDR03_branch.GetEntry(self.localentry, 0)
            return self.e2EcalIsoDR03_value

    property e2EffectiveArea2011Data:
        def __get__(self):
            self.e2EffectiveArea2011Data_branch.GetEntry(self.localentry, 0)
            return self.e2EffectiveArea2011Data_value

    property e2EffectiveArea2012Data:
        def __get__(self):
            self.e2EffectiveArea2012Data_branch.GetEntry(self.localentry, 0)
            return self.e2EffectiveArea2012Data_value

    property e2EffectiveAreaFall11MC:
        def __get__(self):
            self.e2EffectiveAreaFall11MC_branch.GetEntry(self.localentry, 0)
            return self.e2EffectiveAreaFall11MC_value

    property e2Ele27WP80PFMT50PFMTFilter:
        def __get__(self):
            self.e2Ele27WP80PFMT50PFMTFilter_branch.GetEntry(self.localentry, 0)
            return self.e2Ele27WP80PFMT50PFMTFilter_value

    property e2Ele27WP80TrackIsoMatchFilter:
        def __get__(self):
            self.e2Ele27WP80TrackIsoMatchFilter_branch.GetEntry(self.localentry, 0)
            return self.e2Ele27WP80TrackIsoMatchFilter_value

    property e2Ele32WP70PFMT50PFMTFilter:
        def __get__(self):
            self.e2Ele32WP70PFMT50PFMTFilter_branch.GetEntry(self.localentry, 0)
            return self.e2Ele32WP70PFMT50PFMTFilter_value

    property e2ElecOverlap:
        def __get__(self):
            self.e2ElecOverlap_branch.GetEntry(self.localentry, 0)
            return self.e2ElecOverlap_value

    property e2ElecOverlapZHLoose:
        def __get__(self):
            self.e2ElecOverlapZHLoose_branch.GetEntry(self.localentry, 0)
            return self.e2ElecOverlapZHLoose_value

    property e2ElecOverlapZHTight:
        def __get__(self):
            self.e2ElecOverlapZHTight_branch.GetEntry(self.localentry, 0)
            return self.e2ElecOverlapZHTight_value

    property e2EnergyError:
        def __get__(self):
            self.e2EnergyError_branch.GetEntry(self.localentry, 0)
            return self.e2EnergyError_value

    property e2Eta:
        def __get__(self):
            self.e2Eta_branch.GetEntry(self.localentry, 0)
            return self.e2Eta_value

    property e2EtaCorrReg_2012Jul13ReReco:
        def __get__(self):
            self.e2EtaCorrReg_2012Jul13ReReco_branch.GetEntry(self.localentry, 0)
            return self.e2EtaCorrReg_2012Jul13ReReco_value

    property e2EtaCorrReg_Fall11:
        def __get__(self):
            self.e2EtaCorrReg_Fall11_branch.GetEntry(self.localentry, 0)
            return self.e2EtaCorrReg_Fall11_value

    property e2EtaCorrReg_Jan16ReReco:
        def __get__(self):
            self.e2EtaCorrReg_Jan16ReReco_branch.GetEntry(self.localentry, 0)
            return self.e2EtaCorrReg_Jan16ReReco_value

    property e2EtaCorrReg_Summer12_DR53X_HCP2012:
        def __get__(self):
            self.e2EtaCorrReg_Summer12_DR53X_HCP2012_branch.GetEntry(self.localentry, 0)
            return self.e2EtaCorrReg_Summer12_DR53X_HCP2012_value

    property e2EtaCorrSmearedNoReg_2012Jul13ReReco:
        def __get__(self):
            self.e2EtaCorrSmearedNoReg_2012Jul13ReReco_branch.GetEntry(self.localentry, 0)
            return self.e2EtaCorrSmearedNoReg_2012Jul13ReReco_value

    property e2EtaCorrSmearedNoReg_Fall11:
        def __get__(self):
            self.e2EtaCorrSmearedNoReg_Fall11_branch.GetEntry(self.localentry, 0)
            return self.e2EtaCorrSmearedNoReg_Fall11_value

    property e2EtaCorrSmearedNoReg_Jan16ReReco:
        def __get__(self):
            self.e2EtaCorrSmearedNoReg_Jan16ReReco_branch.GetEntry(self.localentry, 0)
            return self.e2EtaCorrSmearedNoReg_Jan16ReReco_value

    property e2EtaCorrSmearedNoReg_Summer12_DR53X_HCP2012:
        def __get__(self):
            self.e2EtaCorrSmearedNoReg_Summer12_DR53X_HCP2012_branch.GetEntry(self.localentry, 0)
            return self.e2EtaCorrSmearedNoReg_Summer12_DR53X_HCP2012_value

    property e2EtaCorrSmearedReg_2012Jul13ReReco:
        def __get__(self):
            self.e2EtaCorrSmearedReg_2012Jul13ReReco_branch.GetEntry(self.localentry, 0)
            return self.e2EtaCorrSmearedReg_2012Jul13ReReco_value

    property e2EtaCorrSmearedReg_Fall11:
        def __get__(self):
            self.e2EtaCorrSmearedReg_Fall11_branch.GetEntry(self.localentry, 0)
            return self.e2EtaCorrSmearedReg_Fall11_value

    property e2EtaCorrSmearedReg_Jan16ReReco:
        def __get__(self):
            self.e2EtaCorrSmearedReg_Jan16ReReco_branch.GetEntry(self.localentry, 0)
            return self.e2EtaCorrSmearedReg_Jan16ReReco_value

    property e2EtaCorrSmearedReg_Summer12_DR53X_HCP2012:
        def __get__(self):
            self.e2EtaCorrSmearedReg_Summer12_DR53X_HCP2012_branch.GetEntry(self.localentry, 0)
            return self.e2EtaCorrSmearedReg_Summer12_DR53X_HCP2012_value

    property e2GenCharge:
        def __get__(self):
            self.e2GenCharge_branch.GetEntry(self.localentry, 0)
            return self.e2GenCharge_value

    property e2GenEnergy:
        def __get__(self):
            self.e2GenEnergy_branch.GetEntry(self.localentry, 0)
            return self.e2GenEnergy_value

    property e2GenEta:
        def __get__(self):
            self.e2GenEta_branch.GetEntry(self.localentry, 0)
            return self.e2GenEta_value

    property e2GenMotherPdgId:
        def __get__(self):
            self.e2GenMotherPdgId_branch.GetEntry(self.localentry, 0)
            return self.e2GenMotherPdgId_value

    property e2GenPdgId:
        def __get__(self):
            self.e2GenPdgId_branch.GetEntry(self.localentry, 0)
            return self.e2GenPdgId_value

    property e2GenPhi:
        def __get__(self):
            self.e2GenPhi_branch.GetEntry(self.localentry, 0)
            return self.e2GenPhi_value

    property e2HadronicDepth1OverEm:
        def __get__(self):
            self.e2HadronicDepth1OverEm_branch.GetEntry(self.localentry, 0)
            return self.e2HadronicDepth1OverEm_value

    property e2HadronicDepth2OverEm:
        def __get__(self):
            self.e2HadronicDepth2OverEm_branch.GetEntry(self.localentry, 0)
            return self.e2HadronicDepth2OverEm_value

    property e2HadronicOverEM:
        def __get__(self):
            self.e2HadronicOverEM_branch.GetEntry(self.localentry, 0)
            return self.e2HadronicOverEM_value

    property e2HasConversion:
        def __get__(self):
            self.e2HasConversion_branch.GetEntry(self.localentry, 0)
            return self.e2HasConversion_value

    property e2HasMatchedConversion:
        def __get__(self):
            self.e2HasMatchedConversion_branch.GetEntry(self.localentry, 0)
            return self.e2HasMatchedConversion_value

    property e2HcalIsoDR03:
        def __get__(self):
            self.e2HcalIsoDR03_branch.GetEntry(self.localentry, 0)
            return self.e2HcalIsoDR03_value

    property e2IP3DS:
        def __get__(self):
            self.e2IP3DS_branch.GetEntry(self.localentry, 0)
            return self.e2IP3DS_value

    property e2JetArea:
        def __get__(self):
            self.e2JetArea_branch.GetEntry(self.localentry, 0)
            return self.e2JetArea_value

    property e2JetBtag:
        def __get__(self):
            self.e2JetBtag_branch.GetEntry(self.localentry, 0)
            return self.e2JetBtag_value

    property e2JetCSVBtag:
        def __get__(self):
            self.e2JetCSVBtag_branch.GetEntry(self.localentry, 0)
            return self.e2JetCSVBtag_value

    property e2JetEtaEtaMoment:
        def __get__(self):
            self.e2JetEtaEtaMoment_branch.GetEntry(self.localentry, 0)
            return self.e2JetEtaEtaMoment_value

    property e2JetEtaPhiMoment:
        def __get__(self):
            self.e2JetEtaPhiMoment_branch.GetEntry(self.localentry, 0)
            return self.e2JetEtaPhiMoment_value

    property e2JetEtaPhiSpread:
        def __get__(self):
            self.e2JetEtaPhiSpread_branch.GetEntry(self.localentry, 0)
            return self.e2JetEtaPhiSpread_value

    property e2JetPartonFlavour:
        def __get__(self):
            self.e2JetPartonFlavour_branch.GetEntry(self.localentry, 0)
            return self.e2JetPartonFlavour_value

    property e2JetPhiPhiMoment:
        def __get__(self):
            self.e2JetPhiPhiMoment_branch.GetEntry(self.localentry, 0)
            return self.e2JetPhiPhiMoment_value

    property e2JetPt:
        def __get__(self):
            self.e2JetPt_branch.GetEntry(self.localentry, 0)
            return self.e2JetPt_value

    property e2JetQGLikelihoodID:
        def __get__(self):
            self.e2JetQGLikelihoodID_branch.GetEntry(self.localentry, 0)
            return self.e2JetQGLikelihoodID_value

    property e2JetQGMVAID:
        def __get__(self):
            self.e2JetQGMVAID_branch.GetEntry(self.localentry, 0)
            return self.e2JetQGMVAID_value

    property e2Jetaxis1:
        def __get__(self):
            self.e2Jetaxis1_branch.GetEntry(self.localentry, 0)
            return self.e2Jetaxis1_value

    property e2Jetaxis2:
        def __get__(self):
            self.e2Jetaxis2_branch.GetEntry(self.localentry, 0)
            return self.e2Jetaxis2_value

    property e2Jetmult:
        def __get__(self):
            self.e2Jetmult_branch.GetEntry(self.localentry, 0)
            return self.e2Jetmult_value

    property e2JetmultMLP:
        def __get__(self):
            self.e2JetmultMLP_branch.GetEntry(self.localentry, 0)
            return self.e2JetmultMLP_value

    property e2JetmultMLPQC:
        def __get__(self):
            self.e2JetmultMLPQC_branch.GetEntry(self.localentry, 0)
            return self.e2JetmultMLPQC_value

    property e2JetptD:
        def __get__(self):
            self.e2JetptD_branch.GetEntry(self.localentry, 0)
            return self.e2JetptD_value

    property e2L1NonIsoHLTNonIsoMu17Ele8PixelMatchFilter:
        def __get__(self):
            self.e2L1NonIsoHLTNonIsoMu17Ele8PixelMatchFilter_branch.GetEntry(self.localentry, 0)
            return self.e2L1NonIsoHLTNonIsoMu17Ele8PixelMatchFilter_value

    property e2MITID:
        def __get__(self):
            self.e2MITID_branch.GetEntry(self.localentry, 0)
            return self.e2MITID_value

    property e2MVAIDH2TauWP:
        def __get__(self):
            self.e2MVAIDH2TauWP_branch.GetEntry(self.localentry, 0)
            return self.e2MVAIDH2TauWP_value

    property e2MVANonTrig:
        def __get__(self):
            self.e2MVANonTrig_branch.GetEntry(self.localentry, 0)
            return self.e2MVANonTrig_value

    property e2MVATrig:
        def __get__(self):
            self.e2MVATrig_branch.GetEntry(self.localentry, 0)
            return self.e2MVATrig_value

    property e2MVATrigIDISO:
        def __get__(self):
            self.e2MVATrigIDISO_branch.GetEntry(self.localentry, 0)
            return self.e2MVATrigIDISO_value

    property e2MVATrigIDISOPUSUB:
        def __get__(self):
            self.e2MVATrigIDISOPUSUB_branch.GetEntry(self.localentry, 0)
            return self.e2MVATrigIDISOPUSUB_value

    property e2MVATrigNoIP:
        def __get__(self):
            self.e2MVATrigNoIP_branch.GetEntry(self.localentry, 0)
            return self.e2MVATrigNoIP_value

    property e2Mass:
        def __get__(self):
            self.e2Mass_branch.GetEntry(self.localentry, 0)
            return self.e2Mass_value

    property e2MatchesDoubleEPath:
        def __get__(self):
            self.e2MatchesDoubleEPath_branch.GetEntry(self.localentry, 0)
            return self.e2MatchesDoubleEPath_value

    property e2MatchesMu17Ele8IsoPath:
        def __get__(self):
            self.e2MatchesMu17Ele8IsoPath_branch.GetEntry(self.localentry, 0)
            return self.e2MatchesMu17Ele8IsoPath_value

    property e2MatchesMu17Ele8Path:
        def __get__(self):
            self.e2MatchesMu17Ele8Path_branch.GetEntry(self.localentry, 0)
            return self.e2MatchesMu17Ele8Path_value

    property e2MatchesMu8Ele17IsoPath:
        def __get__(self):
            self.e2MatchesMu8Ele17IsoPath_branch.GetEntry(self.localentry, 0)
            return self.e2MatchesMu8Ele17IsoPath_value

    property e2MatchesMu8Ele17Path:
        def __get__(self):
            self.e2MatchesMu8Ele17Path_branch.GetEntry(self.localentry, 0)
            return self.e2MatchesMu8Ele17Path_value

    property e2MatchesSingleE:
        def __get__(self):
            self.e2MatchesSingleE_branch.GetEntry(self.localentry, 0)
            return self.e2MatchesSingleE_value

    property e2MatchesSingleEPlusMET:
        def __get__(self):
            self.e2MatchesSingleEPlusMET_branch.GetEntry(self.localentry, 0)
            return self.e2MatchesSingleEPlusMET_value

    property e2MissingHits:
        def __get__(self):
            self.e2MissingHits_branch.GetEntry(self.localentry, 0)
            return self.e2MissingHits_value

    property e2MtToMET:
        def __get__(self):
            self.e2MtToMET_branch.GetEntry(self.localentry, 0)
            return self.e2MtToMET_value

    property e2MtToMVAMET:
        def __get__(self):
            self.e2MtToMVAMET_branch.GetEntry(self.localentry, 0)
            return self.e2MtToMVAMET_value

    property e2MtToPFMET:
        def __get__(self):
            self.e2MtToPFMET_branch.GetEntry(self.localentry, 0)
            return self.e2MtToPFMET_value

    property e2MtToPfMet_Ty1:
        def __get__(self):
            self.e2MtToPfMet_Ty1_branch.GetEntry(self.localentry, 0)
            return self.e2MtToPfMet_Ty1_value

    property e2MtToPfMet_jes:
        def __get__(self):
            self.e2MtToPfMet_jes_branch.GetEntry(self.localentry, 0)
            return self.e2MtToPfMet_jes_value

    property e2MtToPfMet_mes:
        def __get__(self):
            self.e2MtToPfMet_mes_branch.GetEntry(self.localentry, 0)
            return self.e2MtToPfMet_mes_value

    property e2MtToPfMet_tes:
        def __get__(self):
            self.e2MtToPfMet_tes_branch.GetEntry(self.localentry, 0)
            return self.e2MtToPfMet_tes_value

    property e2MtToPfMet_ues:
        def __get__(self):
            self.e2MtToPfMet_ues_branch.GetEntry(self.localentry, 0)
            return self.e2MtToPfMet_ues_value

    property e2Mu17Ele8CaloIdTCaloIsoVLTrkIdVLTrkIsoVLTrackIsoFilter:
        def __get__(self):
            self.e2Mu17Ele8CaloIdTCaloIsoVLTrkIdVLTrkIsoVLTrackIsoFilter_branch.GetEntry(self.localentry, 0)
            return self.e2Mu17Ele8CaloIdTCaloIsoVLTrkIdVLTrkIsoVLTrackIsoFilter_value

    property e2Mu17Ele8CaloIdTPixelMatchFilter:
        def __get__(self):
            self.e2Mu17Ele8CaloIdTPixelMatchFilter_branch.GetEntry(self.localentry, 0)
            return self.e2Mu17Ele8CaloIdTPixelMatchFilter_value

    property e2Mu17Ele8dZFilter:
        def __get__(self):
            self.e2Mu17Ele8dZFilter_branch.GetEntry(self.localentry, 0)
            return self.e2Mu17Ele8dZFilter_value

    property e2MuOverlap:
        def __get__(self):
            self.e2MuOverlap_branch.GetEntry(self.localentry, 0)
            return self.e2MuOverlap_value

    property e2MuOverlapZHLoose:
        def __get__(self):
            self.e2MuOverlapZHLoose_branch.GetEntry(self.localentry, 0)
            return self.e2MuOverlapZHLoose_value

    property e2MuOverlapZHTight:
        def __get__(self):
            self.e2MuOverlapZHTight_branch.GetEntry(self.localentry, 0)
            return self.e2MuOverlapZHTight_value

    property e2NearMuonVeto:
        def __get__(self):
            self.e2NearMuonVeto_branch.GetEntry(self.localentry, 0)
            return self.e2NearMuonVeto_value

    property e2PFChargedIso:
        def __get__(self):
            self.e2PFChargedIso_branch.GetEntry(self.localentry, 0)
            return self.e2PFChargedIso_value

    property e2PFNeutralIso:
        def __get__(self):
            self.e2PFNeutralIso_branch.GetEntry(self.localentry, 0)
            return self.e2PFNeutralIso_value

    property e2PFPhotonIso:
        def __get__(self):
            self.e2PFPhotonIso_branch.GetEntry(self.localentry, 0)
            return self.e2PFPhotonIso_value

    property e2PVDXY:
        def __get__(self):
            self.e2PVDXY_branch.GetEntry(self.localentry, 0)
            return self.e2PVDXY_value

    property e2PVDZ:
        def __get__(self):
            self.e2PVDZ_branch.GetEntry(self.localentry, 0)
            return self.e2PVDZ_value

    property e2Phi:
        def __get__(self):
            self.e2Phi_branch.GetEntry(self.localentry, 0)
            return self.e2Phi_value

    property e2PhiCorrReg_2012Jul13ReReco:
        def __get__(self):
            self.e2PhiCorrReg_2012Jul13ReReco_branch.GetEntry(self.localentry, 0)
            return self.e2PhiCorrReg_2012Jul13ReReco_value

    property e2PhiCorrReg_Fall11:
        def __get__(self):
            self.e2PhiCorrReg_Fall11_branch.GetEntry(self.localentry, 0)
            return self.e2PhiCorrReg_Fall11_value

    property e2PhiCorrReg_Jan16ReReco:
        def __get__(self):
            self.e2PhiCorrReg_Jan16ReReco_branch.GetEntry(self.localentry, 0)
            return self.e2PhiCorrReg_Jan16ReReco_value

    property e2PhiCorrReg_Summer12_DR53X_HCP2012:
        def __get__(self):
            self.e2PhiCorrReg_Summer12_DR53X_HCP2012_branch.GetEntry(self.localentry, 0)
            return self.e2PhiCorrReg_Summer12_DR53X_HCP2012_value

    property e2PhiCorrSmearedNoReg_2012Jul13ReReco:
        def __get__(self):
            self.e2PhiCorrSmearedNoReg_2012Jul13ReReco_branch.GetEntry(self.localentry, 0)
            return self.e2PhiCorrSmearedNoReg_2012Jul13ReReco_value

    property e2PhiCorrSmearedNoReg_Fall11:
        def __get__(self):
            self.e2PhiCorrSmearedNoReg_Fall11_branch.GetEntry(self.localentry, 0)
            return self.e2PhiCorrSmearedNoReg_Fall11_value

    property e2PhiCorrSmearedNoReg_Jan16ReReco:
        def __get__(self):
            self.e2PhiCorrSmearedNoReg_Jan16ReReco_branch.GetEntry(self.localentry, 0)
            return self.e2PhiCorrSmearedNoReg_Jan16ReReco_value

    property e2PhiCorrSmearedNoReg_Summer12_DR53X_HCP2012:
        def __get__(self):
            self.e2PhiCorrSmearedNoReg_Summer12_DR53X_HCP2012_branch.GetEntry(self.localentry, 0)
            return self.e2PhiCorrSmearedNoReg_Summer12_DR53X_HCP2012_value

    property e2PhiCorrSmearedReg_2012Jul13ReReco:
        def __get__(self):
            self.e2PhiCorrSmearedReg_2012Jul13ReReco_branch.GetEntry(self.localentry, 0)
            return self.e2PhiCorrSmearedReg_2012Jul13ReReco_value

    property e2PhiCorrSmearedReg_Fall11:
        def __get__(self):
            self.e2PhiCorrSmearedReg_Fall11_branch.GetEntry(self.localentry, 0)
            return self.e2PhiCorrSmearedReg_Fall11_value

    property e2PhiCorrSmearedReg_Jan16ReReco:
        def __get__(self):
            self.e2PhiCorrSmearedReg_Jan16ReReco_branch.GetEntry(self.localentry, 0)
            return self.e2PhiCorrSmearedReg_Jan16ReReco_value

    property e2PhiCorrSmearedReg_Summer12_DR53X_HCP2012:
        def __get__(self):
            self.e2PhiCorrSmearedReg_Summer12_DR53X_HCP2012_branch.GetEntry(self.localentry, 0)
            return self.e2PhiCorrSmearedReg_Summer12_DR53X_HCP2012_value

    property e2Pt:
        def __get__(self):
            self.e2Pt_branch.GetEntry(self.localentry, 0)
            return self.e2Pt_value

    property e2PtCorrReg_2012Jul13ReReco:
        def __get__(self):
            self.e2PtCorrReg_2012Jul13ReReco_branch.GetEntry(self.localentry, 0)
            return self.e2PtCorrReg_2012Jul13ReReco_value

    property e2PtCorrReg_Fall11:
        def __get__(self):
            self.e2PtCorrReg_Fall11_branch.GetEntry(self.localentry, 0)
            return self.e2PtCorrReg_Fall11_value

    property e2PtCorrReg_Jan16ReReco:
        def __get__(self):
            self.e2PtCorrReg_Jan16ReReco_branch.GetEntry(self.localentry, 0)
            return self.e2PtCorrReg_Jan16ReReco_value

    property e2PtCorrReg_Summer12_DR53X_HCP2012:
        def __get__(self):
            self.e2PtCorrReg_Summer12_DR53X_HCP2012_branch.GetEntry(self.localentry, 0)
            return self.e2PtCorrReg_Summer12_DR53X_HCP2012_value

    property e2PtCorrSmearedNoReg_2012Jul13ReReco:
        def __get__(self):
            self.e2PtCorrSmearedNoReg_2012Jul13ReReco_branch.GetEntry(self.localentry, 0)
            return self.e2PtCorrSmearedNoReg_2012Jul13ReReco_value

    property e2PtCorrSmearedNoReg_Fall11:
        def __get__(self):
            self.e2PtCorrSmearedNoReg_Fall11_branch.GetEntry(self.localentry, 0)
            return self.e2PtCorrSmearedNoReg_Fall11_value

    property e2PtCorrSmearedNoReg_Jan16ReReco:
        def __get__(self):
            self.e2PtCorrSmearedNoReg_Jan16ReReco_branch.GetEntry(self.localentry, 0)
            return self.e2PtCorrSmearedNoReg_Jan16ReReco_value

    property e2PtCorrSmearedNoReg_Summer12_DR53X_HCP2012:
        def __get__(self):
            self.e2PtCorrSmearedNoReg_Summer12_DR53X_HCP2012_branch.GetEntry(self.localentry, 0)
            return self.e2PtCorrSmearedNoReg_Summer12_DR53X_HCP2012_value

    property e2PtCorrSmearedReg_2012Jul13ReReco:
        def __get__(self):
            self.e2PtCorrSmearedReg_2012Jul13ReReco_branch.GetEntry(self.localentry, 0)
            return self.e2PtCorrSmearedReg_2012Jul13ReReco_value

    property e2PtCorrSmearedReg_Fall11:
        def __get__(self):
            self.e2PtCorrSmearedReg_Fall11_branch.GetEntry(self.localentry, 0)
            return self.e2PtCorrSmearedReg_Fall11_value

    property e2PtCorrSmearedReg_Jan16ReReco:
        def __get__(self):
            self.e2PtCorrSmearedReg_Jan16ReReco_branch.GetEntry(self.localentry, 0)
            return self.e2PtCorrSmearedReg_Jan16ReReco_value

    property e2PtCorrSmearedReg_Summer12_DR53X_HCP2012:
        def __get__(self):
            self.e2PtCorrSmearedReg_Summer12_DR53X_HCP2012_branch.GetEntry(self.localentry, 0)
            return self.e2PtCorrSmearedReg_Summer12_DR53X_HCP2012_value

    property e2Rank:
        def __get__(self):
            self.e2Rank_branch.GetEntry(self.localentry, 0)
            return self.e2Rank_value

    property e2RelIso:
        def __get__(self):
            self.e2RelIso_branch.GetEntry(self.localentry, 0)
            return self.e2RelIso_value

    property e2RelPFIsoDB:
        def __get__(self):
            self.e2RelPFIsoDB_branch.GetEntry(self.localentry, 0)
            return self.e2RelPFIsoDB_value

    property e2RelPFIsoRho:
        def __get__(self):
            self.e2RelPFIsoRho_branch.GetEntry(self.localentry, 0)
            return self.e2RelPFIsoRho_value

    property e2RelPFIsoRhoFSR:
        def __get__(self):
            self.e2RelPFIsoRhoFSR_branch.GetEntry(self.localentry, 0)
            return self.e2RelPFIsoRhoFSR_value

    property e2RhoHZG2011:
        def __get__(self):
            self.e2RhoHZG2011_branch.GetEntry(self.localentry, 0)
            return self.e2RhoHZG2011_value

    property e2RhoHZG2012:
        def __get__(self):
            self.e2RhoHZG2012_branch.GetEntry(self.localentry, 0)
            return self.e2RhoHZG2012_value

    property e2SCEnergy:
        def __get__(self):
            self.e2SCEnergy_branch.GetEntry(self.localentry, 0)
            return self.e2SCEnergy_value

    property e2SCEta:
        def __get__(self):
            self.e2SCEta_branch.GetEntry(self.localentry, 0)
            return self.e2SCEta_value

    property e2SCEtaWidth:
        def __get__(self):
            self.e2SCEtaWidth_branch.GetEntry(self.localentry, 0)
            return self.e2SCEtaWidth_value

    property e2SCPhi:
        def __get__(self):
            self.e2SCPhi_branch.GetEntry(self.localentry, 0)
            return self.e2SCPhi_value

    property e2SCPhiWidth:
        def __get__(self):
            self.e2SCPhiWidth_branch.GetEntry(self.localentry, 0)
            return self.e2SCPhiWidth_value

    property e2SCPreshowerEnergy:
        def __get__(self):
            self.e2SCPreshowerEnergy_branch.GetEntry(self.localentry, 0)
            return self.e2SCPreshowerEnergy_value

    property e2SCRawEnergy:
        def __get__(self):
            self.e2SCRawEnergy_branch.GetEntry(self.localentry, 0)
            return self.e2SCRawEnergy_value

    property e2SigmaIEtaIEta:
        def __get__(self):
            self.e2SigmaIEtaIEta_branch.GetEntry(self.localentry, 0)
            return self.e2SigmaIEtaIEta_value

    property e2ToMETDPhi:
        def __get__(self):
            self.e2ToMETDPhi_branch.GetEntry(self.localentry, 0)
            return self.e2ToMETDPhi_value

    property e2TrkIsoDR03:
        def __get__(self):
            self.e2TrkIsoDR03_branch.GetEntry(self.localentry, 0)
            return self.e2TrkIsoDR03_value

    property e2VZ:
        def __get__(self):
            self.e2VZ_branch.GetEntry(self.localentry, 0)
            return self.e2VZ_value

    property e2WWID:
        def __get__(self):
            self.e2WWID_branch.GetEntry(self.localentry, 0)
            return self.e2WWID_value

    property e2_e3_CosThetaStar:
        def __get__(self):
            self.e2_e3_CosThetaStar_branch.GetEntry(self.localentry, 0)
            return self.e2_e3_CosThetaStar_value

    property e2_e3_DPhi:
        def __get__(self):
            self.e2_e3_DPhi_branch.GetEntry(self.localentry, 0)
            return self.e2_e3_DPhi_value

    property e2_e3_DR:
        def __get__(self):
            self.e2_e3_DR_branch.GetEntry(self.localentry, 0)
            return self.e2_e3_DR_value

    property e2_e3_Eta:
        def __get__(self):
            self.e2_e3_Eta_branch.GetEntry(self.localentry, 0)
            return self.e2_e3_Eta_value

    property e2_e3_Mass:
        def __get__(self):
            self.e2_e3_Mass_branch.GetEntry(self.localentry, 0)
            return self.e2_e3_Mass_value

    property e2_e3_MassFsr:
        def __get__(self):
            self.e2_e3_MassFsr_branch.GetEntry(self.localentry, 0)
            return self.e2_e3_MassFsr_value

    property e2_e3_PZeta:
        def __get__(self):
            self.e2_e3_PZeta_branch.GetEntry(self.localentry, 0)
            return self.e2_e3_PZeta_value

    property e2_e3_PZetaVis:
        def __get__(self):
            self.e2_e3_PZetaVis_branch.GetEntry(self.localentry, 0)
            return self.e2_e3_PZetaVis_value

    property e2_e3_Phi:
        def __get__(self):
            self.e2_e3_Phi_branch.GetEntry(self.localentry, 0)
            return self.e2_e3_Phi_value

    property e2_e3_Pt:
        def __get__(self):
            self.e2_e3_Pt_branch.GetEntry(self.localentry, 0)
            return self.e2_e3_Pt_value

    property e2_e3_PtFsr:
        def __get__(self):
            self.e2_e3_PtFsr_branch.GetEntry(self.localentry, 0)
            return self.e2_e3_PtFsr_value

    property e2_e3_SS:
        def __get__(self):
            self.e2_e3_SS_branch.GetEntry(self.localentry, 0)
            return self.e2_e3_SS_value

    property e2_e3_ToMETDPhi_Ty1:
        def __get__(self):
            self.e2_e3_ToMETDPhi_Ty1_branch.GetEntry(self.localentry, 0)
            return self.e2_e3_ToMETDPhi_Ty1_value

    property e2_e3_Zcompat:
        def __get__(self):
            self.e2_e3_Zcompat_branch.GetEntry(self.localentry, 0)
            return self.e2_e3_Zcompat_value

    property e2_t_CosThetaStar:
        def __get__(self):
            self.e2_t_CosThetaStar_branch.GetEntry(self.localentry, 0)
            return self.e2_t_CosThetaStar_value

    property e2_t_DPhi:
        def __get__(self):
            self.e2_t_DPhi_branch.GetEntry(self.localentry, 0)
            return self.e2_t_DPhi_value

    property e2_t_DR:
        def __get__(self):
            self.e2_t_DR_branch.GetEntry(self.localentry, 0)
            return self.e2_t_DR_value

    property e2_t_Eta:
        def __get__(self):
            self.e2_t_Eta_branch.GetEntry(self.localentry, 0)
            return self.e2_t_Eta_value

    property e2_t_Mass:
        def __get__(self):
            self.e2_t_Mass_branch.GetEntry(self.localentry, 0)
            return self.e2_t_Mass_value

    property e2_t_MassFsr:
        def __get__(self):
            self.e2_t_MassFsr_branch.GetEntry(self.localentry, 0)
            return self.e2_t_MassFsr_value

    property e2_t_PZeta:
        def __get__(self):
            self.e2_t_PZeta_branch.GetEntry(self.localentry, 0)
            return self.e2_t_PZeta_value

    property e2_t_PZetaVis:
        def __get__(self):
            self.e2_t_PZetaVis_branch.GetEntry(self.localentry, 0)
            return self.e2_t_PZetaVis_value

    property e2_t_Phi:
        def __get__(self):
            self.e2_t_Phi_branch.GetEntry(self.localentry, 0)
            return self.e2_t_Phi_value

    property e2_t_Pt:
        def __get__(self):
            self.e2_t_Pt_branch.GetEntry(self.localentry, 0)
            return self.e2_t_Pt_value

    property e2_t_PtFsr:
        def __get__(self):
            self.e2_t_PtFsr_branch.GetEntry(self.localentry, 0)
            return self.e2_t_PtFsr_value

    property e2_t_SS:
        def __get__(self):
            self.e2_t_SS_branch.GetEntry(self.localentry, 0)
            return self.e2_t_SS_value

    property e2_t_ToMETDPhi_Ty1:
        def __get__(self):
            self.e2_t_ToMETDPhi_Ty1_branch.GetEntry(self.localentry, 0)
            return self.e2_t_ToMETDPhi_Ty1_value

    property e2_t_Zcompat:
        def __get__(self):
            self.e2_t_Zcompat_branch.GetEntry(self.localentry, 0)
            return self.e2_t_Zcompat_value

    property e2dECorrReg_2012Jul13ReReco:
        def __get__(self):
            self.e2dECorrReg_2012Jul13ReReco_branch.GetEntry(self.localentry, 0)
            return self.e2dECorrReg_2012Jul13ReReco_value

    property e2dECorrReg_Fall11:
        def __get__(self):
            self.e2dECorrReg_Fall11_branch.GetEntry(self.localentry, 0)
            return self.e2dECorrReg_Fall11_value

    property e2dECorrReg_Jan16ReReco:
        def __get__(self):
            self.e2dECorrReg_Jan16ReReco_branch.GetEntry(self.localentry, 0)
            return self.e2dECorrReg_Jan16ReReco_value

    property e2dECorrReg_Summer12_DR53X_HCP2012:
        def __get__(self):
            self.e2dECorrReg_Summer12_DR53X_HCP2012_branch.GetEntry(self.localentry, 0)
            return self.e2dECorrReg_Summer12_DR53X_HCP2012_value

    property e2dECorrSmearedNoReg_2012Jul13ReReco:
        def __get__(self):
            self.e2dECorrSmearedNoReg_2012Jul13ReReco_branch.GetEntry(self.localentry, 0)
            return self.e2dECorrSmearedNoReg_2012Jul13ReReco_value

    property e2dECorrSmearedNoReg_Fall11:
        def __get__(self):
            self.e2dECorrSmearedNoReg_Fall11_branch.GetEntry(self.localentry, 0)
            return self.e2dECorrSmearedNoReg_Fall11_value

    property e2dECorrSmearedNoReg_Jan16ReReco:
        def __get__(self):
            self.e2dECorrSmearedNoReg_Jan16ReReco_branch.GetEntry(self.localentry, 0)
            return self.e2dECorrSmearedNoReg_Jan16ReReco_value

    property e2dECorrSmearedNoReg_Summer12_DR53X_HCP2012:
        def __get__(self):
            self.e2dECorrSmearedNoReg_Summer12_DR53X_HCP2012_branch.GetEntry(self.localentry, 0)
            return self.e2dECorrSmearedNoReg_Summer12_DR53X_HCP2012_value

    property e2dECorrSmearedReg_2012Jul13ReReco:
        def __get__(self):
            self.e2dECorrSmearedReg_2012Jul13ReReco_branch.GetEntry(self.localentry, 0)
            return self.e2dECorrSmearedReg_2012Jul13ReReco_value

    property e2dECorrSmearedReg_Fall11:
        def __get__(self):
            self.e2dECorrSmearedReg_Fall11_branch.GetEntry(self.localentry, 0)
            return self.e2dECorrSmearedReg_Fall11_value

    property e2dECorrSmearedReg_Jan16ReReco:
        def __get__(self):
            self.e2dECorrSmearedReg_Jan16ReReco_branch.GetEntry(self.localentry, 0)
            return self.e2dECorrSmearedReg_Jan16ReReco_value

    property e2dECorrSmearedReg_Summer12_DR53X_HCP2012:
        def __get__(self):
            self.e2dECorrSmearedReg_Summer12_DR53X_HCP2012_branch.GetEntry(self.localentry, 0)
            return self.e2dECorrSmearedReg_Summer12_DR53X_HCP2012_value

    property e2deltaEtaSuperClusterTrackAtVtx:
        def __get__(self):
            self.e2deltaEtaSuperClusterTrackAtVtx_branch.GetEntry(self.localentry, 0)
            return self.e2deltaEtaSuperClusterTrackAtVtx_value

    property e2deltaPhiSuperClusterTrackAtVtx:
        def __get__(self):
            self.e2deltaPhiSuperClusterTrackAtVtx_branch.GetEntry(self.localentry, 0)
            return self.e2deltaPhiSuperClusterTrackAtVtx_value

    property e2eSuperClusterOverP:
        def __get__(self):
            self.e2eSuperClusterOverP_branch.GetEntry(self.localentry, 0)
            return self.e2eSuperClusterOverP_value

    property e2ecalEnergy:
        def __get__(self):
            self.e2ecalEnergy_branch.GetEntry(self.localentry, 0)
            return self.e2ecalEnergy_value

    property e2fBrem:
        def __get__(self):
            self.e2fBrem_branch.GetEntry(self.localentry, 0)
            return self.e2fBrem_value

    property e2trackMomentumAtVtxP:
        def __get__(self):
            self.e2trackMomentumAtVtxP_branch.GetEntry(self.localentry, 0)
            return self.e2trackMomentumAtVtxP_value

    property e3AbsEta:
        def __get__(self):
            self.e3AbsEta_branch.GetEntry(self.localentry, 0)
            return self.e3AbsEta_value

    property e3CBID_LOOSE:
        def __get__(self):
            self.e3CBID_LOOSE_branch.GetEntry(self.localentry, 0)
            return self.e3CBID_LOOSE_value

    property e3CBID_MEDIUM:
        def __get__(self):
            self.e3CBID_MEDIUM_branch.GetEntry(self.localentry, 0)
            return self.e3CBID_MEDIUM_value

    property e3CBID_TIGHT:
        def __get__(self):
            self.e3CBID_TIGHT_branch.GetEntry(self.localentry, 0)
            return self.e3CBID_TIGHT_value

    property e3CBID_VETO:
        def __get__(self):
            self.e3CBID_VETO_branch.GetEntry(self.localentry, 0)
            return self.e3CBID_VETO_value

    property e3Charge:
        def __get__(self):
            self.e3Charge_branch.GetEntry(self.localentry, 0)
            return self.e3Charge_value

    property e3ChargeIdLoose:
        def __get__(self):
            self.e3ChargeIdLoose_branch.GetEntry(self.localentry, 0)
            return self.e3ChargeIdLoose_value

    property e3ChargeIdMed:
        def __get__(self):
            self.e3ChargeIdMed_branch.GetEntry(self.localentry, 0)
            return self.e3ChargeIdMed_value

    property e3ChargeIdTight:
        def __get__(self):
            self.e3ChargeIdTight_branch.GetEntry(self.localentry, 0)
            return self.e3ChargeIdTight_value

    property e3CiCTight:
        def __get__(self):
            self.e3CiCTight_branch.GetEntry(self.localentry, 0)
            return self.e3CiCTight_value

    property e3CiCTightElecOverlap:
        def __get__(self):
            self.e3CiCTightElecOverlap_branch.GetEntry(self.localentry, 0)
            return self.e3CiCTightElecOverlap_value

    property e3ComesFromHiggs:
        def __get__(self):
            self.e3ComesFromHiggs_branch.GetEntry(self.localentry, 0)
            return self.e3ComesFromHiggs_value

    property e3DZ:
        def __get__(self):
            self.e3DZ_branch.GetEntry(self.localentry, 0)
            return self.e3DZ_value

    property e3E1x5:
        def __get__(self):
            self.e3E1x5_branch.GetEntry(self.localentry, 0)
            return self.e3E1x5_value

    property e3E2x5Max:
        def __get__(self):
            self.e3E2x5Max_branch.GetEntry(self.localentry, 0)
            return self.e3E2x5Max_value

    property e3E5x5:
        def __get__(self):
            self.e3E5x5_branch.GetEntry(self.localentry, 0)
            return self.e3E5x5_value

    property e3ECorrReg_2012Jul13ReReco:
        def __get__(self):
            self.e3ECorrReg_2012Jul13ReReco_branch.GetEntry(self.localentry, 0)
            return self.e3ECorrReg_2012Jul13ReReco_value

    property e3ECorrReg_Fall11:
        def __get__(self):
            self.e3ECorrReg_Fall11_branch.GetEntry(self.localentry, 0)
            return self.e3ECorrReg_Fall11_value

    property e3ECorrReg_Jan16ReReco:
        def __get__(self):
            self.e3ECorrReg_Jan16ReReco_branch.GetEntry(self.localentry, 0)
            return self.e3ECorrReg_Jan16ReReco_value

    property e3ECorrReg_Summer12_DR53X_HCP2012:
        def __get__(self):
            self.e3ECorrReg_Summer12_DR53X_HCP2012_branch.GetEntry(self.localentry, 0)
            return self.e3ECorrReg_Summer12_DR53X_HCP2012_value

    property e3ECorrSmearedNoReg_2012Jul13ReReco:
        def __get__(self):
            self.e3ECorrSmearedNoReg_2012Jul13ReReco_branch.GetEntry(self.localentry, 0)
            return self.e3ECorrSmearedNoReg_2012Jul13ReReco_value

    property e3ECorrSmearedNoReg_Fall11:
        def __get__(self):
            self.e3ECorrSmearedNoReg_Fall11_branch.GetEntry(self.localentry, 0)
            return self.e3ECorrSmearedNoReg_Fall11_value

    property e3ECorrSmearedNoReg_Jan16ReReco:
        def __get__(self):
            self.e3ECorrSmearedNoReg_Jan16ReReco_branch.GetEntry(self.localentry, 0)
            return self.e3ECorrSmearedNoReg_Jan16ReReco_value

    property e3ECorrSmearedNoReg_Summer12_DR53X_HCP2012:
        def __get__(self):
            self.e3ECorrSmearedNoReg_Summer12_DR53X_HCP2012_branch.GetEntry(self.localentry, 0)
            return self.e3ECorrSmearedNoReg_Summer12_DR53X_HCP2012_value

    property e3ECorrSmearedReg_2012Jul13ReReco:
        def __get__(self):
            self.e3ECorrSmearedReg_2012Jul13ReReco_branch.GetEntry(self.localentry, 0)
            return self.e3ECorrSmearedReg_2012Jul13ReReco_value

    property e3ECorrSmearedReg_Fall11:
        def __get__(self):
            self.e3ECorrSmearedReg_Fall11_branch.GetEntry(self.localentry, 0)
            return self.e3ECorrSmearedReg_Fall11_value

    property e3ECorrSmearedReg_Jan16ReReco:
        def __get__(self):
            self.e3ECorrSmearedReg_Jan16ReReco_branch.GetEntry(self.localentry, 0)
            return self.e3ECorrSmearedReg_Jan16ReReco_value

    property e3ECorrSmearedReg_Summer12_DR53X_HCP2012:
        def __get__(self):
            self.e3ECorrSmearedReg_Summer12_DR53X_HCP2012_branch.GetEntry(self.localentry, 0)
            return self.e3ECorrSmearedReg_Summer12_DR53X_HCP2012_value

    property e3EcalIsoDR03:
        def __get__(self):
            self.e3EcalIsoDR03_branch.GetEntry(self.localentry, 0)
            return self.e3EcalIsoDR03_value

    property e3EffectiveArea2011Data:
        def __get__(self):
            self.e3EffectiveArea2011Data_branch.GetEntry(self.localentry, 0)
            return self.e3EffectiveArea2011Data_value

    property e3EffectiveArea2012Data:
        def __get__(self):
            self.e3EffectiveArea2012Data_branch.GetEntry(self.localentry, 0)
            return self.e3EffectiveArea2012Data_value

    property e3EffectiveAreaFall11MC:
        def __get__(self):
            self.e3EffectiveAreaFall11MC_branch.GetEntry(self.localentry, 0)
            return self.e3EffectiveAreaFall11MC_value

    property e3Ele27WP80PFMT50PFMTFilter:
        def __get__(self):
            self.e3Ele27WP80PFMT50PFMTFilter_branch.GetEntry(self.localentry, 0)
            return self.e3Ele27WP80PFMT50PFMTFilter_value

    property e3Ele27WP80TrackIsoMatchFilter:
        def __get__(self):
            self.e3Ele27WP80TrackIsoMatchFilter_branch.GetEntry(self.localentry, 0)
            return self.e3Ele27WP80TrackIsoMatchFilter_value

    property e3Ele32WP70PFMT50PFMTFilter:
        def __get__(self):
            self.e3Ele32WP70PFMT50PFMTFilter_branch.GetEntry(self.localentry, 0)
            return self.e3Ele32WP70PFMT50PFMTFilter_value

    property e3ElecOverlap:
        def __get__(self):
            self.e3ElecOverlap_branch.GetEntry(self.localentry, 0)
            return self.e3ElecOverlap_value

    property e3ElecOverlapZHLoose:
        def __get__(self):
            self.e3ElecOverlapZHLoose_branch.GetEntry(self.localentry, 0)
            return self.e3ElecOverlapZHLoose_value

    property e3ElecOverlapZHTight:
        def __get__(self):
            self.e3ElecOverlapZHTight_branch.GetEntry(self.localentry, 0)
            return self.e3ElecOverlapZHTight_value

    property e3EnergyError:
        def __get__(self):
            self.e3EnergyError_branch.GetEntry(self.localentry, 0)
            return self.e3EnergyError_value

    property e3Eta:
        def __get__(self):
            self.e3Eta_branch.GetEntry(self.localentry, 0)
            return self.e3Eta_value

    property e3EtaCorrReg_2012Jul13ReReco:
        def __get__(self):
            self.e3EtaCorrReg_2012Jul13ReReco_branch.GetEntry(self.localentry, 0)
            return self.e3EtaCorrReg_2012Jul13ReReco_value

    property e3EtaCorrReg_Fall11:
        def __get__(self):
            self.e3EtaCorrReg_Fall11_branch.GetEntry(self.localentry, 0)
            return self.e3EtaCorrReg_Fall11_value

    property e3EtaCorrReg_Jan16ReReco:
        def __get__(self):
            self.e3EtaCorrReg_Jan16ReReco_branch.GetEntry(self.localentry, 0)
            return self.e3EtaCorrReg_Jan16ReReco_value

    property e3EtaCorrReg_Summer12_DR53X_HCP2012:
        def __get__(self):
            self.e3EtaCorrReg_Summer12_DR53X_HCP2012_branch.GetEntry(self.localentry, 0)
            return self.e3EtaCorrReg_Summer12_DR53X_HCP2012_value

    property e3EtaCorrSmearedNoReg_2012Jul13ReReco:
        def __get__(self):
            self.e3EtaCorrSmearedNoReg_2012Jul13ReReco_branch.GetEntry(self.localentry, 0)
            return self.e3EtaCorrSmearedNoReg_2012Jul13ReReco_value

    property e3EtaCorrSmearedNoReg_Fall11:
        def __get__(self):
            self.e3EtaCorrSmearedNoReg_Fall11_branch.GetEntry(self.localentry, 0)
            return self.e3EtaCorrSmearedNoReg_Fall11_value

    property e3EtaCorrSmearedNoReg_Jan16ReReco:
        def __get__(self):
            self.e3EtaCorrSmearedNoReg_Jan16ReReco_branch.GetEntry(self.localentry, 0)
            return self.e3EtaCorrSmearedNoReg_Jan16ReReco_value

    property e3EtaCorrSmearedNoReg_Summer12_DR53X_HCP2012:
        def __get__(self):
            self.e3EtaCorrSmearedNoReg_Summer12_DR53X_HCP2012_branch.GetEntry(self.localentry, 0)
            return self.e3EtaCorrSmearedNoReg_Summer12_DR53X_HCP2012_value

    property e3EtaCorrSmearedReg_2012Jul13ReReco:
        def __get__(self):
            self.e3EtaCorrSmearedReg_2012Jul13ReReco_branch.GetEntry(self.localentry, 0)
            return self.e3EtaCorrSmearedReg_2012Jul13ReReco_value

    property e3EtaCorrSmearedReg_Fall11:
        def __get__(self):
            self.e3EtaCorrSmearedReg_Fall11_branch.GetEntry(self.localentry, 0)
            return self.e3EtaCorrSmearedReg_Fall11_value

    property e3EtaCorrSmearedReg_Jan16ReReco:
        def __get__(self):
            self.e3EtaCorrSmearedReg_Jan16ReReco_branch.GetEntry(self.localentry, 0)
            return self.e3EtaCorrSmearedReg_Jan16ReReco_value

    property e3EtaCorrSmearedReg_Summer12_DR53X_HCP2012:
        def __get__(self):
            self.e3EtaCorrSmearedReg_Summer12_DR53X_HCP2012_branch.GetEntry(self.localentry, 0)
            return self.e3EtaCorrSmearedReg_Summer12_DR53X_HCP2012_value

    property e3GenCharge:
        def __get__(self):
            self.e3GenCharge_branch.GetEntry(self.localentry, 0)
            return self.e3GenCharge_value

    property e3GenEnergy:
        def __get__(self):
            self.e3GenEnergy_branch.GetEntry(self.localentry, 0)
            return self.e3GenEnergy_value

    property e3GenEta:
        def __get__(self):
            self.e3GenEta_branch.GetEntry(self.localentry, 0)
            return self.e3GenEta_value

    property e3GenMotherPdgId:
        def __get__(self):
            self.e3GenMotherPdgId_branch.GetEntry(self.localentry, 0)
            return self.e3GenMotherPdgId_value

    property e3GenPdgId:
        def __get__(self):
            self.e3GenPdgId_branch.GetEntry(self.localentry, 0)
            return self.e3GenPdgId_value

    property e3GenPhi:
        def __get__(self):
            self.e3GenPhi_branch.GetEntry(self.localentry, 0)
            return self.e3GenPhi_value

    property e3HadronicDepth1OverEm:
        def __get__(self):
            self.e3HadronicDepth1OverEm_branch.GetEntry(self.localentry, 0)
            return self.e3HadronicDepth1OverEm_value

    property e3HadronicDepth2OverEm:
        def __get__(self):
            self.e3HadronicDepth2OverEm_branch.GetEntry(self.localentry, 0)
            return self.e3HadronicDepth2OverEm_value

    property e3HadronicOverEM:
        def __get__(self):
            self.e3HadronicOverEM_branch.GetEntry(self.localentry, 0)
            return self.e3HadronicOverEM_value

    property e3HasConversion:
        def __get__(self):
            self.e3HasConversion_branch.GetEntry(self.localentry, 0)
            return self.e3HasConversion_value

    property e3HasMatchedConversion:
        def __get__(self):
            self.e3HasMatchedConversion_branch.GetEntry(self.localentry, 0)
            return self.e3HasMatchedConversion_value

    property e3HcalIsoDR03:
        def __get__(self):
            self.e3HcalIsoDR03_branch.GetEntry(self.localentry, 0)
            return self.e3HcalIsoDR03_value

    property e3IP3DS:
        def __get__(self):
            self.e3IP3DS_branch.GetEntry(self.localentry, 0)
            return self.e3IP3DS_value

    property e3JetArea:
        def __get__(self):
            self.e3JetArea_branch.GetEntry(self.localentry, 0)
            return self.e3JetArea_value

    property e3JetBtag:
        def __get__(self):
            self.e3JetBtag_branch.GetEntry(self.localentry, 0)
            return self.e3JetBtag_value

    property e3JetCSVBtag:
        def __get__(self):
            self.e3JetCSVBtag_branch.GetEntry(self.localentry, 0)
            return self.e3JetCSVBtag_value

    property e3JetEtaEtaMoment:
        def __get__(self):
            self.e3JetEtaEtaMoment_branch.GetEntry(self.localentry, 0)
            return self.e3JetEtaEtaMoment_value

    property e3JetEtaPhiMoment:
        def __get__(self):
            self.e3JetEtaPhiMoment_branch.GetEntry(self.localentry, 0)
            return self.e3JetEtaPhiMoment_value

    property e3JetEtaPhiSpread:
        def __get__(self):
            self.e3JetEtaPhiSpread_branch.GetEntry(self.localentry, 0)
            return self.e3JetEtaPhiSpread_value

    property e3JetPartonFlavour:
        def __get__(self):
            self.e3JetPartonFlavour_branch.GetEntry(self.localentry, 0)
            return self.e3JetPartonFlavour_value

    property e3JetPhiPhiMoment:
        def __get__(self):
            self.e3JetPhiPhiMoment_branch.GetEntry(self.localentry, 0)
            return self.e3JetPhiPhiMoment_value

    property e3JetPt:
        def __get__(self):
            self.e3JetPt_branch.GetEntry(self.localentry, 0)
            return self.e3JetPt_value

    property e3JetQGLikelihoodID:
        def __get__(self):
            self.e3JetQGLikelihoodID_branch.GetEntry(self.localentry, 0)
            return self.e3JetQGLikelihoodID_value

    property e3JetQGMVAID:
        def __get__(self):
            self.e3JetQGMVAID_branch.GetEntry(self.localentry, 0)
            return self.e3JetQGMVAID_value

    property e3Jetaxis1:
        def __get__(self):
            self.e3Jetaxis1_branch.GetEntry(self.localentry, 0)
            return self.e3Jetaxis1_value

    property e3Jetaxis2:
        def __get__(self):
            self.e3Jetaxis2_branch.GetEntry(self.localentry, 0)
            return self.e3Jetaxis2_value

    property e3Jetmult:
        def __get__(self):
            self.e3Jetmult_branch.GetEntry(self.localentry, 0)
            return self.e3Jetmult_value

    property e3JetmultMLP:
        def __get__(self):
            self.e3JetmultMLP_branch.GetEntry(self.localentry, 0)
            return self.e3JetmultMLP_value

    property e3JetmultMLPQC:
        def __get__(self):
            self.e3JetmultMLPQC_branch.GetEntry(self.localentry, 0)
            return self.e3JetmultMLPQC_value

    property e3JetptD:
        def __get__(self):
            self.e3JetptD_branch.GetEntry(self.localentry, 0)
            return self.e3JetptD_value

    property e3L1NonIsoHLTNonIsoMu17Ele8PixelMatchFilter:
        def __get__(self):
            self.e3L1NonIsoHLTNonIsoMu17Ele8PixelMatchFilter_branch.GetEntry(self.localentry, 0)
            return self.e3L1NonIsoHLTNonIsoMu17Ele8PixelMatchFilter_value

    property e3MITID:
        def __get__(self):
            self.e3MITID_branch.GetEntry(self.localentry, 0)
            return self.e3MITID_value

    property e3MVAIDH2TauWP:
        def __get__(self):
            self.e3MVAIDH2TauWP_branch.GetEntry(self.localentry, 0)
            return self.e3MVAIDH2TauWP_value

    property e3MVANonTrig:
        def __get__(self):
            self.e3MVANonTrig_branch.GetEntry(self.localentry, 0)
            return self.e3MVANonTrig_value

    property e3MVATrig:
        def __get__(self):
            self.e3MVATrig_branch.GetEntry(self.localentry, 0)
            return self.e3MVATrig_value

    property e3MVATrigIDISO:
        def __get__(self):
            self.e3MVATrigIDISO_branch.GetEntry(self.localentry, 0)
            return self.e3MVATrigIDISO_value

    property e3MVATrigIDISOPUSUB:
        def __get__(self):
            self.e3MVATrigIDISOPUSUB_branch.GetEntry(self.localentry, 0)
            return self.e3MVATrigIDISOPUSUB_value

    property e3MVATrigNoIP:
        def __get__(self):
            self.e3MVATrigNoIP_branch.GetEntry(self.localentry, 0)
            return self.e3MVATrigNoIP_value

    property e3Mass:
        def __get__(self):
            self.e3Mass_branch.GetEntry(self.localentry, 0)
            return self.e3Mass_value

    property e3MatchesDoubleEPath:
        def __get__(self):
            self.e3MatchesDoubleEPath_branch.GetEntry(self.localentry, 0)
            return self.e3MatchesDoubleEPath_value

    property e3MatchesMu17Ele8IsoPath:
        def __get__(self):
            self.e3MatchesMu17Ele8IsoPath_branch.GetEntry(self.localentry, 0)
            return self.e3MatchesMu17Ele8IsoPath_value

    property e3MatchesMu17Ele8Path:
        def __get__(self):
            self.e3MatchesMu17Ele8Path_branch.GetEntry(self.localentry, 0)
            return self.e3MatchesMu17Ele8Path_value

    property e3MatchesMu8Ele17IsoPath:
        def __get__(self):
            self.e3MatchesMu8Ele17IsoPath_branch.GetEntry(self.localentry, 0)
            return self.e3MatchesMu8Ele17IsoPath_value

    property e3MatchesMu8Ele17Path:
        def __get__(self):
            self.e3MatchesMu8Ele17Path_branch.GetEntry(self.localentry, 0)
            return self.e3MatchesMu8Ele17Path_value

    property e3MatchesSingleE:
        def __get__(self):
            self.e3MatchesSingleE_branch.GetEntry(self.localentry, 0)
            return self.e3MatchesSingleE_value

    property e3MatchesSingleEPlusMET:
        def __get__(self):
            self.e3MatchesSingleEPlusMET_branch.GetEntry(self.localentry, 0)
            return self.e3MatchesSingleEPlusMET_value

    property e3MissingHits:
        def __get__(self):
            self.e3MissingHits_branch.GetEntry(self.localentry, 0)
            return self.e3MissingHits_value

    property e3MtToMET:
        def __get__(self):
            self.e3MtToMET_branch.GetEntry(self.localentry, 0)
            return self.e3MtToMET_value

    property e3MtToMVAMET:
        def __get__(self):
            self.e3MtToMVAMET_branch.GetEntry(self.localentry, 0)
            return self.e3MtToMVAMET_value

    property e3MtToPFMET:
        def __get__(self):
            self.e3MtToPFMET_branch.GetEntry(self.localentry, 0)
            return self.e3MtToPFMET_value

    property e3MtToPfMet_Ty1:
        def __get__(self):
            self.e3MtToPfMet_Ty1_branch.GetEntry(self.localentry, 0)
            return self.e3MtToPfMet_Ty1_value

    property e3MtToPfMet_jes:
        def __get__(self):
            self.e3MtToPfMet_jes_branch.GetEntry(self.localentry, 0)
            return self.e3MtToPfMet_jes_value

    property e3MtToPfMet_mes:
        def __get__(self):
            self.e3MtToPfMet_mes_branch.GetEntry(self.localentry, 0)
            return self.e3MtToPfMet_mes_value

    property e3MtToPfMet_tes:
        def __get__(self):
            self.e3MtToPfMet_tes_branch.GetEntry(self.localentry, 0)
            return self.e3MtToPfMet_tes_value

    property e3MtToPfMet_ues:
        def __get__(self):
            self.e3MtToPfMet_ues_branch.GetEntry(self.localentry, 0)
            return self.e3MtToPfMet_ues_value

    property e3Mu17Ele8CaloIdTCaloIsoVLTrkIdVLTrkIsoVLTrackIsoFilter:
        def __get__(self):
            self.e3Mu17Ele8CaloIdTCaloIsoVLTrkIdVLTrkIsoVLTrackIsoFilter_branch.GetEntry(self.localentry, 0)
            return self.e3Mu17Ele8CaloIdTCaloIsoVLTrkIdVLTrkIsoVLTrackIsoFilter_value

    property e3Mu17Ele8CaloIdTPixelMatchFilter:
        def __get__(self):
            self.e3Mu17Ele8CaloIdTPixelMatchFilter_branch.GetEntry(self.localentry, 0)
            return self.e3Mu17Ele8CaloIdTPixelMatchFilter_value

    property e3Mu17Ele8dZFilter:
        def __get__(self):
            self.e3Mu17Ele8dZFilter_branch.GetEntry(self.localentry, 0)
            return self.e3Mu17Ele8dZFilter_value

    property e3MuOverlap:
        def __get__(self):
            self.e3MuOverlap_branch.GetEntry(self.localentry, 0)
            return self.e3MuOverlap_value

    property e3MuOverlapZHLoose:
        def __get__(self):
            self.e3MuOverlapZHLoose_branch.GetEntry(self.localentry, 0)
            return self.e3MuOverlapZHLoose_value

    property e3MuOverlapZHTight:
        def __get__(self):
            self.e3MuOverlapZHTight_branch.GetEntry(self.localentry, 0)
            return self.e3MuOverlapZHTight_value

    property e3NearMuonVeto:
        def __get__(self):
            self.e3NearMuonVeto_branch.GetEntry(self.localentry, 0)
            return self.e3NearMuonVeto_value

    property e3PFChargedIso:
        def __get__(self):
            self.e3PFChargedIso_branch.GetEntry(self.localentry, 0)
            return self.e3PFChargedIso_value

    property e3PFNeutralIso:
        def __get__(self):
            self.e3PFNeutralIso_branch.GetEntry(self.localentry, 0)
            return self.e3PFNeutralIso_value

    property e3PFPhotonIso:
        def __get__(self):
            self.e3PFPhotonIso_branch.GetEntry(self.localentry, 0)
            return self.e3PFPhotonIso_value

    property e3PVDXY:
        def __get__(self):
            self.e3PVDXY_branch.GetEntry(self.localentry, 0)
            return self.e3PVDXY_value

    property e3PVDZ:
        def __get__(self):
            self.e3PVDZ_branch.GetEntry(self.localentry, 0)
            return self.e3PVDZ_value

    property e3Phi:
        def __get__(self):
            self.e3Phi_branch.GetEntry(self.localentry, 0)
            return self.e3Phi_value

    property e3PhiCorrReg_2012Jul13ReReco:
        def __get__(self):
            self.e3PhiCorrReg_2012Jul13ReReco_branch.GetEntry(self.localentry, 0)
            return self.e3PhiCorrReg_2012Jul13ReReco_value

    property e3PhiCorrReg_Fall11:
        def __get__(self):
            self.e3PhiCorrReg_Fall11_branch.GetEntry(self.localentry, 0)
            return self.e3PhiCorrReg_Fall11_value

    property e3PhiCorrReg_Jan16ReReco:
        def __get__(self):
            self.e3PhiCorrReg_Jan16ReReco_branch.GetEntry(self.localentry, 0)
            return self.e3PhiCorrReg_Jan16ReReco_value

    property e3PhiCorrReg_Summer12_DR53X_HCP2012:
        def __get__(self):
            self.e3PhiCorrReg_Summer12_DR53X_HCP2012_branch.GetEntry(self.localentry, 0)
            return self.e3PhiCorrReg_Summer12_DR53X_HCP2012_value

    property e3PhiCorrSmearedNoReg_2012Jul13ReReco:
        def __get__(self):
            self.e3PhiCorrSmearedNoReg_2012Jul13ReReco_branch.GetEntry(self.localentry, 0)
            return self.e3PhiCorrSmearedNoReg_2012Jul13ReReco_value

    property e3PhiCorrSmearedNoReg_Fall11:
        def __get__(self):
            self.e3PhiCorrSmearedNoReg_Fall11_branch.GetEntry(self.localentry, 0)
            return self.e3PhiCorrSmearedNoReg_Fall11_value

    property e3PhiCorrSmearedNoReg_Jan16ReReco:
        def __get__(self):
            self.e3PhiCorrSmearedNoReg_Jan16ReReco_branch.GetEntry(self.localentry, 0)
            return self.e3PhiCorrSmearedNoReg_Jan16ReReco_value

    property e3PhiCorrSmearedNoReg_Summer12_DR53X_HCP2012:
        def __get__(self):
            self.e3PhiCorrSmearedNoReg_Summer12_DR53X_HCP2012_branch.GetEntry(self.localentry, 0)
            return self.e3PhiCorrSmearedNoReg_Summer12_DR53X_HCP2012_value

    property e3PhiCorrSmearedReg_2012Jul13ReReco:
        def __get__(self):
            self.e3PhiCorrSmearedReg_2012Jul13ReReco_branch.GetEntry(self.localentry, 0)
            return self.e3PhiCorrSmearedReg_2012Jul13ReReco_value

    property e3PhiCorrSmearedReg_Fall11:
        def __get__(self):
            self.e3PhiCorrSmearedReg_Fall11_branch.GetEntry(self.localentry, 0)
            return self.e3PhiCorrSmearedReg_Fall11_value

    property e3PhiCorrSmearedReg_Jan16ReReco:
        def __get__(self):
            self.e3PhiCorrSmearedReg_Jan16ReReco_branch.GetEntry(self.localentry, 0)
            return self.e3PhiCorrSmearedReg_Jan16ReReco_value

    property e3PhiCorrSmearedReg_Summer12_DR53X_HCP2012:
        def __get__(self):
            self.e3PhiCorrSmearedReg_Summer12_DR53X_HCP2012_branch.GetEntry(self.localentry, 0)
            return self.e3PhiCorrSmearedReg_Summer12_DR53X_HCP2012_value

    property e3Pt:
        def __get__(self):
            self.e3Pt_branch.GetEntry(self.localentry, 0)
            return self.e3Pt_value

    property e3PtCorrReg_2012Jul13ReReco:
        def __get__(self):
            self.e3PtCorrReg_2012Jul13ReReco_branch.GetEntry(self.localentry, 0)
            return self.e3PtCorrReg_2012Jul13ReReco_value

    property e3PtCorrReg_Fall11:
        def __get__(self):
            self.e3PtCorrReg_Fall11_branch.GetEntry(self.localentry, 0)
            return self.e3PtCorrReg_Fall11_value

    property e3PtCorrReg_Jan16ReReco:
        def __get__(self):
            self.e3PtCorrReg_Jan16ReReco_branch.GetEntry(self.localentry, 0)
            return self.e3PtCorrReg_Jan16ReReco_value

    property e3PtCorrReg_Summer12_DR53X_HCP2012:
        def __get__(self):
            self.e3PtCorrReg_Summer12_DR53X_HCP2012_branch.GetEntry(self.localentry, 0)
            return self.e3PtCorrReg_Summer12_DR53X_HCP2012_value

    property e3PtCorrSmearedNoReg_2012Jul13ReReco:
        def __get__(self):
            self.e3PtCorrSmearedNoReg_2012Jul13ReReco_branch.GetEntry(self.localentry, 0)
            return self.e3PtCorrSmearedNoReg_2012Jul13ReReco_value

    property e3PtCorrSmearedNoReg_Fall11:
        def __get__(self):
            self.e3PtCorrSmearedNoReg_Fall11_branch.GetEntry(self.localentry, 0)
            return self.e3PtCorrSmearedNoReg_Fall11_value

    property e3PtCorrSmearedNoReg_Jan16ReReco:
        def __get__(self):
            self.e3PtCorrSmearedNoReg_Jan16ReReco_branch.GetEntry(self.localentry, 0)
            return self.e3PtCorrSmearedNoReg_Jan16ReReco_value

    property e3PtCorrSmearedNoReg_Summer12_DR53X_HCP2012:
        def __get__(self):
            self.e3PtCorrSmearedNoReg_Summer12_DR53X_HCP2012_branch.GetEntry(self.localentry, 0)
            return self.e3PtCorrSmearedNoReg_Summer12_DR53X_HCP2012_value

    property e3PtCorrSmearedReg_2012Jul13ReReco:
        def __get__(self):
            self.e3PtCorrSmearedReg_2012Jul13ReReco_branch.GetEntry(self.localentry, 0)
            return self.e3PtCorrSmearedReg_2012Jul13ReReco_value

    property e3PtCorrSmearedReg_Fall11:
        def __get__(self):
            self.e3PtCorrSmearedReg_Fall11_branch.GetEntry(self.localentry, 0)
            return self.e3PtCorrSmearedReg_Fall11_value

    property e3PtCorrSmearedReg_Jan16ReReco:
        def __get__(self):
            self.e3PtCorrSmearedReg_Jan16ReReco_branch.GetEntry(self.localentry, 0)
            return self.e3PtCorrSmearedReg_Jan16ReReco_value

    property e3PtCorrSmearedReg_Summer12_DR53X_HCP2012:
        def __get__(self):
            self.e3PtCorrSmearedReg_Summer12_DR53X_HCP2012_branch.GetEntry(self.localentry, 0)
            return self.e3PtCorrSmearedReg_Summer12_DR53X_HCP2012_value

    property e3Rank:
        def __get__(self):
            self.e3Rank_branch.GetEntry(self.localentry, 0)
            return self.e3Rank_value

    property e3RelIso:
        def __get__(self):
            self.e3RelIso_branch.GetEntry(self.localentry, 0)
            return self.e3RelIso_value

    property e3RelPFIsoDB:
        def __get__(self):
            self.e3RelPFIsoDB_branch.GetEntry(self.localentry, 0)
            return self.e3RelPFIsoDB_value

    property e3RelPFIsoRho:
        def __get__(self):
            self.e3RelPFIsoRho_branch.GetEntry(self.localentry, 0)
            return self.e3RelPFIsoRho_value

    property e3RelPFIsoRhoFSR:
        def __get__(self):
            self.e3RelPFIsoRhoFSR_branch.GetEntry(self.localentry, 0)
            return self.e3RelPFIsoRhoFSR_value

    property e3RhoHZG2011:
        def __get__(self):
            self.e3RhoHZG2011_branch.GetEntry(self.localentry, 0)
            return self.e3RhoHZG2011_value

    property e3RhoHZG2012:
        def __get__(self):
            self.e3RhoHZG2012_branch.GetEntry(self.localentry, 0)
            return self.e3RhoHZG2012_value

    property e3SCEnergy:
        def __get__(self):
            self.e3SCEnergy_branch.GetEntry(self.localentry, 0)
            return self.e3SCEnergy_value

    property e3SCEta:
        def __get__(self):
            self.e3SCEta_branch.GetEntry(self.localentry, 0)
            return self.e3SCEta_value

    property e3SCEtaWidth:
        def __get__(self):
            self.e3SCEtaWidth_branch.GetEntry(self.localentry, 0)
            return self.e3SCEtaWidth_value

    property e3SCPhi:
        def __get__(self):
            self.e3SCPhi_branch.GetEntry(self.localentry, 0)
            return self.e3SCPhi_value

    property e3SCPhiWidth:
        def __get__(self):
            self.e3SCPhiWidth_branch.GetEntry(self.localentry, 0)
            return self.e3SCPhiWidth_value

    property e3SCPreshowerEnergy:
        def __get__(self):
            self.e3SCPreshowerEnergy_branch.GetEntry(self.localentry, 0)
            return self.e3SCPreshowerEnergy_value

    property e3SCRawEnergy:
        def __get__(self):
            self.e3SCRawEnergy_branch.GetEntry(self.localentry, 0)
            return self.e3SCRawEnergy_value

    property e3SigmaIEtaIEta:
        def __get__(self):
            self.e3SigmaIEtaIEta_branch.GetEntry(self.localentry, 0)
            return self.e3SigmaIEtaIEta_value

    property e3ToMETDPhi:
        def __get__(self):
            self.e3ToMETDPhi_branch.GetEntry(self.localentry, 0)
            return self.e3ToMETDPhi_value

    property e3TrkIsoDR03:
        def __get__(self):
            self.e3TrkIsoDR03_branch.GetEntry(self.localentry, 0)
            return self.e3TrkIsoDR03_value

    property e3VZ:
        def __get__(self):
            self.e3VZ_branch.GetEntry(self.localentry, 0)
            return self.e3VZ_value

    property e3WWID:
        def __get__(self):
            self.e3WWID_branch.GetEntry(self.localentry, 0)
            return self.e3WWID_value

    property e3_t_CosThetaStar:
        def __get__(self):
            self.e3_t_CosThetaStar_branch.GetEntry(self.localentry, 0)
            return self.e3_t_CosThetaStar_value

    property e3_t_DPhi:
        def __get__(self):
            self.e3_t_DPhi_branch.GetEntry(self.localentry, 0)
            return self.e3_t_DPhi_value

    property e3_t_DR:
        def __get__(self):
            self.e3_t_DR_branch.GetEntry(self.localentry, 0)
            return self.e3_t_DR_value

    property e3_t_Eta:
        def __get__(self):
            self.e3_t_Eta_branch.GetEntry(self.localentry, 0)
            return self.e3_t_Eta_value

    property e3_t_Mass:
        def __get__(self):
            self.e3_t_Mass_branch.GetEntry(self.localentry, 0)
            return self.e3_t_Mass_value

    property e3_t_MassFsr:
        def __get__(self):
            self.e3_t_MassFsr_branch.GetEntry(self.localentry, 0)
            return self.e3_t_MassFsr_value

    property e3_t_PZeta:
        def __get__(self):
            self.e3_t_PZeta_branch.GetEntry(self.localentry, 0)
            return self.e3_t_PZeta_value

    property e3_t_PZetaVis:
        def __get__(self):
            self.e3_t_PZetaVis_branch.GetEntry(self.localentry, 0)
            return self.e3_t_PZetaVis_value

    property e3_t_Phi:
        def __get__(self):
            self.e3_t_Phi_branch.GetEntry(self.localentry, 0)
            return self.e3_t_Phi_value

    property e3_t_Pt:
        def __get__(self):
            self.e3_t_Pt_branch.GetEntry(self.localentry, 0)
            return self.e3_t_Pt_value

    property e3_t_PtFsr:
        def __get__(self):
            self.e3_t_PtFsr_branch.GetEntry(self.localentry, 0)
            return self.e3_t_PtFsr_value

    property e3_t_SS:
        def __get__(self):
            self.e3_t_SS_branch.GetEntry(self.localentry, 0)
            return self.e3_t_SS_value

    property e3_t_SVfitEta:
        def __get__(self):
            self.e3_t_SVfitEta_branch.GetEntry(self.localentry, 0)
            return self.e3_t_SVfitEta_value

    property e3_t_SVfitMass:
        def __get__(self):
            self.e3_t_SVfitMass_branch.GetEntry(self.localentry, 0)
            return self.e3_t_SVfitMass_value

    property e3_t_SVfitPhi:
        def __get__(self):
            self.e3_t_SVfitPhi_branch.GetEntry(self.localentry, 0)
            return self.e3_t_SVfitPhi_value

    property e3_t_SVfitPt:
        def __get__(self):
            self.e3_t_SVfitPt_branch.GetEntry(self.localentry, 0)
            return self.e3_t_SVfitPt_value

    property e3_t_ToMETDPhi_Ty1:
        def __get__(self):
            self.e3_t_ToMETDPhi_Ty1_branch.GetEntry(self.localentry, 0)
            return self.e3_t_ToMETDPhi_Ty1_value

    property e3_t_Zcompat:
        def __get__(self):
            self.e3_t_Zcompat_branch.GetEntry(self.localentry, 0)
            return self.e3_t_Zcompat_value

    property e3dECorrReg_2012Jul13ReReco:
        def __get__(self):
            self.e3dECorrReg_2012Jul13ReReco_branch.GetEntry(self.localentry, 0)
            return self.e3dECorrReg_2012Jul13ReReco_value

    property e3dECorrReg_Fall11:
        def __get__(self):
            self.e3dECorrReg_Fall11_branch.GetEntry(self.localentry, 0)
            return self.e3dECorrReg_Fall11_value

    property e3dECorrReg_Jan16ReReco:
        def __get__(self):
            self.e3dECorrReg_Jan16ReReco_branch.GetEntry(self.localentry, 0)
            return self.e3dECorrReg_Jan16ReReco_value

    property e3dECorrReg_Summer12_DR53X_HCP2012:
        def __get__(self):
            self.e3dECorrReg_Summer12_DR53X_HCP2012_branch.GetEntry(self.localentry, 0)
            return self.e3dECorrReg_Summer12_DR53X_HCP2012_value

    property e3dECorrSmearedNoReg_2012Jul13ReReco:
        def __get__(self):
            self.e3dECorrSmearedNoReg_2012Jul13ReReco_branch.GetEntry(self.localentry, 0)
            return self.e3dECorrSmearedNoReg_2012Jul13ReReco_value

    property e3dECorrSmearedNoReg_Fall11:
        def __get__(self):
            self.e3dECorrSmearedNoReg_Fall11_branch.GetEntry(self.localentry, 0)
            return self.e3dECorrSmearedNoReg_Fall11_value

    property e3dECorrSmearedNoReg_Jan16ReReco:
        def __get__(self):
            self.e3dECorrSmearedNoReg_Jan16ReReco_branch.GetEntry(self.localentry, 0)
            return self.e3dECorrSmearedNoReg_Jan16ReReco_value

    property e3dECorrSmearedNoReg_Summer12_DR53X_HCP2012:
        def __get__(self):
            self.e3dECorrSmearedNoReg_Summer12_DR53X_HCP2012_branch.GetEntry(self.localentry, 0)
            return self.e3dECorrSmearedNoReg_Summer12_DR53X_HCP2012_value

    property e3dECorrSmearedReg_2012Jul13ReReco:
        def __get__(self):
            self.e3dECorrSmearedReg_2012Jul13ReReco_branch.GetEntry(self.localentry, 0)
            return self.e3dECorrSmearedReg_2012Jul13ReReco_value

    property e3dECorrSmearedReg_Fall11:
        def __get__(self):
            self.e3dECorrSmearedReg_Fall11_branch.GetEntry(self.localentry, 0)
            return self.e3dECorrSmearedReg_Fall11_value

    property e3dECorrSmearedReg_Jan16ReReco:
        def __get__(self):
            self.e3dECorrSmearedReg_Jan16ReReco_branch.GetEntry(self.localentry, 0)
            return self.e3dECorrSmearedReg_Jan16ReReco_value

    property e3dECorrSmearedReg_Summer12_DR53X_HCP2012:
        def __get__(self):
            self.e3dECorrSmearedReg_Summer12_DR53X_HCP2012_branch.GetEntry(self.localentry, 0)
            return self.e3dECorrSmearedReg_Summer12_DR53X_HCP2012_value

    property e3deltaEtaSuperClusterTrackAtVtx:
        def __get__(self):
            self.e3deltaEtaSuperClusterTrackAtVtx_branch.GetEntry(self.localentry, 0)
            return self.e3deltaEtaSuperClusterTrackAtVtx_value

    property e3deltaPhiSuperClusterTrackAtVtx:
        def __get__(self):
            self.e3deltaPhiSuperClusterTrackAtVtx_branch.GetEntry(self.localentry, 0)
            return self.e3deltaPhiSuperClusterTrackAtVtx_value

    property e3eSuperClusterOverP:
        def __get__(self):
            self.e3eSuperClusterOverP_branch.GetEntry(self.localentry, 0)
            return self.e3eSuperClusterOverP_value

    property e3ecalEnergy:
        def __get__(self):
            self.e3ecalEnergy_branch.GetEntry(self.localentry, 0)
            return self.e3ecalEnergy_value

    property e3fBrem:
        def __get__(self):
            self.e3fBrem_branch.GetEntry(self.localentry, 0)
            return self.e3fBrem_value

    property e3trackMomentumAtVtxP:
        def __get__(self):
            self.e3trackMomentumAtVtxP_branch.GetEntry(self.localentry, 0)
            return self.e3trackMomentumAtVtxP_value

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


