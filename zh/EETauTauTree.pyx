

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

cdef class EETauTauTree:
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

    cdef TBranch* e1_t1_CosThetaStar_branch
    cdef float e1_t1_CosThetaStar_value

    cdef TBranch* e1_t1_DPhi_branch
    cdef float e1_t1_DPhi_value

    cdef TBranch* e1_t1_DR_branch
    cdef float e1_t1_DR_value

    cdef TBranch* e1_t1_Eta_branch
    cdef float e1_t1_Eta_value

    cdef TBranch* e1_t1_Mass_branch
    cdef float e1_t1_Mass_value

    cdef TBranch* e1_t1_MassFsr_branch
    cdef float e1_t1_MassFsr_value

    cdef TBranch* e1_t1_PZeta_branch
    cdef float e1_t1_PZeta_value

    cdef TBranch* e1_t1_PZetaVis_branch
    cdef float e1_t1_PZetaVis_value

    cdef TBranch* e1_t1_Phi_branch
    cdef float e1_t1_Phi_value

    cdef TBranch* e1_t1_Pt_branch
    cdef float e1_t1_Pt_value

    cdef TBranch* e1_t1_PtFsr_branch
    cdef float e1_t1_PtFsr_value

    cdef TBranch* e1_t1_SS_branch
    cdef float e1_t1_SS_value

    cdef TBranch* e1_t1_ToMETDPhi_Ty1_branch
    cdef float e1_t1_ToMETDPhi_Ty1_value

    cdef TBranch* e1_t1_Zcompat_branch
    cdef float e1_t1_Zcompat_value

    cdef TBranch* e1_t2_CosThetaStar_branch
    cdef float e1_t2_CosThetaStar_value

    cdef TBranch* e1_t2_DPhi_branch
    cdef float e1_t2_DPhi_value

    cdef TBranch* e1_t2_DR_branch
    cdef float e1_t2_DR_value

    cdef TBranch* e1_t2_Eta_branch
    cdef float e1_t2_Eta_value

    cdef TBranch* e1_t2_Mass_branch
    cdef float e1_t2_Mass_value

    cdef TBranch* e1_t2_MassFsr_branch
    cdef float e1_t2_MassFsr_value

    cdef TBranch* e1_t2_PZeta_branch
    cdef float e1_t2_PZeta_value

    cdef TBranch* e1_t2_PZetaVis_branch
    cdef float e1_t2_PZetaVis_value

    cdef TBranch* e1_t2_Phi_branch
    cdef float e1_t2_Phi_value

    cdef TBranch* e1_t2_Pt_branch
    cdef float e1_t2_Pt_value

    cdef TBranch* e1_t2_PtFsr_branch
    cdef float e1_t2_PtFsr_value

    cdef TBranch* e1_t2_SS_branch
    cdef float e1_t2_SS_value

    cdef TBranch* e1_t2_ToMETDPhi_Ty1_branch
    cdef float e1_t2_ToMETDPhi_Ty1_value

    cdef TBranch* e1_t2_Zcompat_branch
    cdef float e1_t2_Zcompat_value

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

    cdef TBranch* e2_t1_CosThetaStar_branch
    cdef float e2_t1_CosThetaStar_value

    cdef TBranch* e2_t1_DPhi_branch
    cdef float e2_t1_DPhi_value

    cdef TBranch* e2_t1_DR_branch
    cdef float e2_t1_DR_value

    cdef TBranch* e2_t1_Eta_branch
    cdef float e2_t1_Eta_value

    cdef TBranch* e2_t1_Mass_branch
    cdef float e2_t1_Mass_value

    cdef TBranch* e2_t1_MassFsr_branch
    cdef float e2_t1_MassFsr_value

    cdef TBranch* e2_t1_PZeta_branch
    cdef float e2_t1_PZeta_value

    cdef TBranch* e2_t1_PZetaVis_branch
    cdef float e2_t1_PZetaVis_value

    cdef TBranch* e2_t1_Phi_branch
    cdef float e2_t1_Phi_value

    cdef TBranch* e2_t1_Pt_branch
    cdef float e2_t1_Pt_value

    cdef TBranch* e2_t1_PtFsr_branch
    cdef float e2_t1_PtFsr_value

    cdef TBranch* e2_t1_SS_branch
    cdef float e2_t1_SS_value

    cdef TBranch* e2_t1_ToMETDPhi_Ty1_branch
    cdef float e2_t1_ToMETDPhi_Ty1_value

    cdef TBranch* e2_t1_Zcompat_branch
    cdef float e2_t1_Zcompat_value

    cdef TBranch* e2_t2_CosThetaStar_branch
    cdef float e2_t2_CosThetaStar_value

    cdef TBranch* e2_t2_DPhi_branch
    cdef float e2_t2_DPhi_value

    cdef TBranch* e2_t2_DR_branch
    cdef float e2_t2_DR_value

    cdef TBranch* e2_t2_Eta_branch
    cdef float e2_t2_Eta_value

    cdef TBranch* e2_t2_Mass_branch
    cdef float e2_t2_Mass_value

    cdef TBranch* e2_t2_MassFsr_branch
    cdef float e2_t2_MassFsr_value

    cdef TBranch* e2_t2_PZeta_branch
    cdef float e2_t2_PZeta_value

    cdef TBranch* e2_t2_PZetaVis_branch
    cdef float e2_t2_PZetaVis_value

    cdef TBranch* e2_t2_Phi_branch
    cdef float e2_t2_Phi_value

    cdef TBranch* e2_t2_Pt_branch
    cdef float e2_t2_Pt_value

    cdef TBranch* e2_t2_PtFsr_branch
    cdef float e2_t2_PtFsr_value

    cdef TBranch* e2_t2_SS_branch
    cdef float e2_t2_SS_value

    cdef TBranch* e2_t2_ToMETDPhi_Ty1_branch
    cdef float e2_t2_ToMETDPhi_Ty1_value

    cdef TBranch* e2_t2_Zcompat_branch
    cdef float e2_t2_Zcompat_value

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
            warnings.warn( "EETauTauTree: Expected branch EmbPtWeight does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("EmbPtWeight")
        else:
            self.EmbPtWeight_branch.SetAddress(<void*>&self.EmbPtWeight_value)

        #print "making LT"
        self.LT_branch = the_tree.GetBranch("LT")
        #if not self.LT_branch and "LT" not in self.complained:
        if not self.LT_branch and "LT":
            warnings.warn( "EETauTauTree: Expected branch LT does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("LT")
        else:
            self.LT_branch.SetAddress(<void*>&self.LT_value)

        #print "making Mass"
        self.Mass_branch = the_tree.GetBranch("Mass")
        #if not self.Mass_branch and "Mass" not in self.complained:
        if not self.Mass_branch and "Mass":
            warnings.warn( "EETauTauTree: Expected branch Mass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Mass")
        else:
            self.Mass_branch.SetAddress(<void*>&self.Mass_value)

        #print "making MassError"
        self.MassError_branch = the_tree.GetBranch("MassError")
        #if not self.MassError_branch and "MassError" not in self.complained:
        if not self.MassError_branch and "MassError":
            warnings.warn( "EETauTauTree: Expected branch MassError does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("MassError")
        else:
            self.MassError_branch.SetAddress(<void*>&self.MassError_value)

        #print "making MassErrord1"
        self.MassErrord1_branch = the_tree.GetBranch("MassErrord1")
        #if not self.MassErrord1_branch and "MassErrord1" not in self.complained:
        if not self.MassErrord1_branch and "MassErrord1":
            warnings.warn( "EETauTauTree: Expected branch MassErrord1 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("MassErrord1")
        else:
            self.MassErrord1_branch.SetAddress(<void*>&self.MassErrord1_value)

        #print "making MassErrord2"
        self.MassErrord2_branch = the_tree.GetBranch("MassErrord2")
        #if not self.MassErrord2_branch and "MassErrord2" not in self.complained:
        if not self.MassErrord2_branch and "MassErrord2":
            warnings.warn( "EETauTauTree: Expected branch MassErrord2 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("MassErrord2")
        else:
            self.MassErrord2_branch.SetAddress(<void*>&self.MassErrord2_value)

        #print "making MassErrord3"
        self.MassErrord3_branch = the_tree.GetBranch("MassErrord3")
        #if not self.MassErrord3_branch and "MassErrord3" not in self.complained:
        if not self.MassErrord3_branch and "MassErrord3":
            warnings.warn( "EETauTauTree: Expected branch MassErrord3 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("MassErrord3")
        else:
            self.MassErrord3_branch.SetAddress(<void*>&self.MassErrord3_value)

        #print "making MassErrord4"
        self.MassErrord4_branch = the_tree.GetBranch("MassErrord4")
        #if not self.MassErrord4_branch and "MassErrord4" not in self.complained:
        if not self.MassErrord4_branch and "MassErrord4":
            warnings.warn( "EETauTauTree: Expected branch MassErrord4 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("MassErrord4")
        else:
            self.MassErrord4_branch.SetAddress(<void*>&self.MassErrord4_value)

        #print "making NUP"
        self.NUP_branch = the_tree.GetBranch("NUP")
        #if not self.NUP_branch and "NUP" not in self.complained:
        if not self.NUP_branch and "NUP":
            warnings.warn( "EETauTauTree: Expected branch NUP does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("NUP")
        else:
            self.NUP_branch.SetAddress(<void*>&self.NUP_value)

        #print "making Pt"
        self.Pt_branch = the_tree.GetBranch("Pt")
        #if not self.Pt_branch and "Pt" not in self.complained:
        if not self.Pt_branch and "Pt":
            warnings.warn( "EETauTauTree: Expected branch Pt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Pt")
        else:
            self.Pt_branch.SetAddress(<void*>&self.Pt_value)

        #print "making bjetCSVVeto"
        self.bjetCSVVeto_branch = the_tree.GetBranch("bjetCSVVeto")
        #if not self.bjetCSVVeto_branch and "bjetCSVVeto" not in self.complained:
        if not self.bjetCSVVeto_branch and "bjetCSVVeto":
            warnings.warn( "EETauTauTree: Expected branch bjetCSVVeto does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("bjetCSVVeto")
        else:
            self.bjetCSVVeto_branch.SetAddress(<void*>&self.bjetCSVVeto_value)

        #print "making bjetCSVVeto30"
        self.bjetCSVVeto30_branch = the_tree.GetBranch("bjetCSVVeto30")
        #if not self.bjetCSVVeto30_branch and "bjetCSVVeto30" not in self.complained:
        if not self.bjetCSVVeto30_branch and "bjetCSVVeto30":
            warnings.warn( "EETauTauTree: Expected branch bjetCSVVeto30 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("bjetCSVVeto30")
        else:
            self.bjetCSVVeto30_branch.SetAddress(<void*>&self.bjetCSVVeto30_value)

        #print "making bjetCSVVetoZHLike"
        self.bjetCSVVetoZHLike_branch = the_tree.GetBranch("bjetCSVVetoZHLike")
        #if not self.bjetCSVVetoZHLike_branch and "bjetCSVVetoZHLike" not in self.complained:
        if not self.bjetCSVVetoZHLike_branch and "bjetCSVVetoZHLike":
            warnings.warn( "EETauTauTree: Expected branch bjetCSVVetoZHLike does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("bjetCSVVetoZHLike")
        else:
            self.bjetCSVVetoZHLike_branch.SetAddress(<void*>&self.bjetCSVVetoZHLike_value)

        #print "making bjetCSVVetoZHLikeNoJetId"
        self.bjetCSVVetoZHLikeNoJetId_branch = the_tree.GetBranch("bjetCSVVetoZHLikeNoJetId")
        #if not self.bjetCSVVetoZHLikeNoJetId_branch and "bjetCSVVetoZHLikeNoJetId" not in self.complained:
        if not self.bjetCSVVetoZHLikeNoJetId_branch and "bjetCSVVetoZHLikeNoJetId":
            warnings.warn( "EETauTauTree: Expected branch bjetCSVVetoZHLikeNoJetId does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("bjetCSVVetoZHLikeNoJetId")
        else:
            self.bjetCSVVetoZHLikeNoJetId_branch.SetAddress(<void*>&self.bjetCSVVetoZHLikeNoJetId_value)

        #print "making bjetCSVVetoZHLikeNoJetId_2"
        self.bjetCSVVetoZHLikeNoJetId_2_branch = the_tree.GetBranch("bjetCSVVetoZHLikeNoJetId_2")
        #if not self.bjetCSVVetoZHLikeNoJetId_2_branch and "bjetCSVVetoZHLikeNoJetId_2" not in self.complained:
        if not self.bjetCSVVetoZHLikeNoJetId_2_branch and "bjetCSVVetoZHLikeNoJetId_2":
            warnings.warn( "EETauTauTree: Expected branch bjetCSVVetoZHLikeNoJetId_2 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("bjetCSVVetoZHLikeNoJetId_2")
        else:
            self.bjetCSVVetoZHLikeNoJetId_2_branch.SetAddress(<void*>&self.bjetCSVVetoZHLikeNoJetId_2_value)

        #print "making bjetTightCountZH"
        self.bjetTightCountZH_branch = the_tree.GetBranch("bjetTightCountZH")
        #if not self.bjetTightCountZH_branch and "bjetTightCountZH" not in self.complained:
        if not self.bjetTightCountZH_branch and "bjetTightCountZH":
            warnings.warn( "EETauTauTree: Expected branch bjetTightCountZH does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("bjetTightCountZH")
        else:
            self.bjetTightCountZH_branch.SetAddress(<void*>&self.bjetTightCountZH_value)

        #print "making bjetVeto"
        self.bjetVeto_branch = the_tree.GetBranch("bjetVeto")
        #if not self.bjetVeto_branch and "bjetVeto" not in self.complained:
        if not self.bjetVeto_branch and "bjetVeto":
            warnings.warn( "EETauTauTree: Expected branch bjetVeto does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("bjetVeto")
        else:
            self.bjetVeto_branch.SetAddress(<void*>&self.bjetVeto_value)

        #print "making charge"
        self.charge_branch = the_tree.GetBranch("charge")
        #if not self.charge_branch and "charge" not in self.complained:
        if not self.charge_branch and "charge":
            warnings.warn( "EETauTauTree: Expected branch charge does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("charge")
        else:
            self.charge_branch.SetAddress(<void*>&self.charge_value)

        #print "making doubleEExtraGroup"
        self.doubleEExtraGroup_branch = the_tree.GetBranch("doubleEExtraGroup")
        #if not self.doubleEExtraGroup_branch and "doubleEExtraGroup" not in self.complained:
        if not self.doubleEExtraGroup_branch and "doubleEExtraGroup":
            warnings.warn( "EETauTauTree: Expected branch doubleEExtraGroup does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleEExtraGroup")
        else:
            self.doubleEExtraGroup_branch.SetAddress(<void*>&self.doubleEExtraGroup_value)

        #print "making doubleEExtraPass"
        self.doubleEExtraPass_branch = the_tree.GetBranch("doubleEExtraPass")
        #if not self.doubleEExtraPass_branch and "doubleEExtraPass" not in self.complained:
        if not self.doubleEExtraPass_branch and "doubleEExtraPass":
            warnings.warn( "EETauTauTree: Expected branch doubleEExtraPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleEExtraPass")
        else:
            self.doubleEExtraPass_branch.SetAddress(<void*>&self.doubleEExtraPass_value)

        #print "making doubleEExtraPrescale"
        self.doubleEExtraPrescale_branch = the_tree.GetBranch("doubleEExtraPrescale")
        #if not self.doubleEExtraPrescale_branch and "doubleEExtraPrescale" not in self.complained:
        if not self.doubleEExtraPrescale_branch and "doubleEExtraPrescale":
            warnings.warn( "EETauTauTree: Expected branch doubleEExtraPrescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleEExtraPrescale")
        else:
            self.doubleEExtraPrescale_branch.SetAddress(<void*>&self.doubleEExtraPrescale_value)

        #print "making doubleEGroup"
        self.doubleEGroup_branch = the_tree.GetBranch("doubleEGroup")
        #if not self.doubleEGroup_branch and "doubleEGroup" not in self.complained:
        if not self.doubleEGroup_branch and "doubleEGroup":
            warnings.warn( "EETauTauTree: Expected branch doubleEGroup does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleEGroup")
        else:
            self.doubleEGroup_branch.SetAddress(<void*>&self.doubleEGroup_value)

        #print "making doubleEPass"
        self.doubleEPass_branch = the_tree.GetBranch("doubleEPass")
        #if not self.doubleEPass_branch and "doubleEPass" not in self.complained:
        if not self.doubleEPass_branch and "doubleEPass":
            warnings.warn( "EETauTauTree: Expected branch doubleEPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleEPass")
        else:
            self.doubleEPass_branch.SetAddress(<void*>&self.doubleEPass_value)

        #print "making doubleEPrescale"
        self.doubleEPrescale_branch = the_tree.GetBranch("doubleEPrescale")
        #if not self.doubleEPrescale_branch and "doubleEPrescale" not in self.complained:
        if not self.doubleEPrescale_branch and "doubleEPrescale":
            warnings.warn( "EETauTauTree: Expected branch doubleEPrescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleEPrescale")
        else:
            self.doubleEPrescale_branch.SetAddress(<void*>&self.doubleEPrescale_value)

        #print "making doubleETightGroup"
        self.doubleETightGroup_branch = the_tree.GetBranch("doubleETightGroup")
        #if not self.doubleETightGroup_branch and "doubleETightGroup" not in self.complained:
        if not self.doubleETightGroup_branch and "doubleETightGroup":
            warnings.warn( "EETauTauTree: Expected branch doubleETightGroup does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleETightGroup")
        else:
            self.doubleETightGroup_branch.SetAddress(<void*>&self.doubleETightGroup_value)

        #print "making doubleETightPass"
        self.doubleETightPass_branch = the_tree.GetBranch("doubleETightPass")
        #if not self.doubleETightPass_branch and "doubleETightPass" not in self.complained:
        if not self.doubleETightPass_branch and "doubleETightPass":
            warnings.warn( "EETauTauTree: Expected branch doubleETightPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleETightPass")
        else:
            self.doubleETightPass_branch.SetAddress(<void*>&self.doubleETightPass_value)

        #print "making doubleETightPrescale"
        self.doubleETightPrescale_branch = the_tree.GetBranch("doubleETightPrescale")
        #if not self.doubleETightPrescale_branch and "doubleETightPrescale" not in self.complained:
        if not self.doubleETightPrescale_branch and "doubleETightPrescale":
            warnings.warn( "EETauTauTree: Expected branch doubleETightPrescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleETightPrescale")
        else:
            self.doubleETightPrescale_branch.SetAddress(<void*>&self.doubleETightPrescale_value)

        #print "making doubleMuGroup"
        self.doubleMuGroup_branch = the_tree.GetBranch("doubleMuGroup")
        #if not self.doubleMuGroup_branch and "doubleMuGroup" not in self.complained:
        if not self.doubleMuGroup_branch and "doubleMuGroup":
            warnings.warn( "EETauTauTree: Expected branch doubleMuGroup does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleMuGroup")
        else:
            self.doubleMuGroup_branch.SetAddress(<void*>&self.doubleMuGroup_value)

        #print "making doubleMuPass"
        self.doubleMuPass_branch = the_tree.GetBranch("doubleMuPass")
        #if not self.doubleMuPass_branch and "doubleMuPass" not in self.complained:
        if not self.doubleMuPass_branch and "doubleMuPass":
            warnings.warn( "EETauTauTree: Expected branch doubleMuPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleMuPass")
        else:
            self.doubleMuPass_branch.SetAddress(<void*>&self.doubleMuPass_value)

        #print "making doubleMuPrescale"
        self.doubleMuPrescale_branch = the_tree.GetBranch("doubleMuPrescale")
        #if not self.doubleMuPrescale_branch and "doubleMuPrescale" not in self.complained:
        if not self.doubleMuPrescale_branch and "doubleMuPrescale":
            warnings.warn( "EETauTauTree: Expected branch doubleMuPrescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleMuPrescale")
        else:
            self.doubleMuPrescale_branch.SetAddress(<void*>&self.doubleMuPrescale_value)

        #print "making doubleMuTrkGroup"
        self.doubleMuTrkGroup_branch = the_tree.GetBranch("doubleMuTrkGroup")
        #if not self.doubleMuTrkGroup_branch and "doubleMuTrkGroup" not in self.complained:
        if not self.doubleMuTrkGroup_branch and "doubleMuTrkGroup":
            warnings.warn( "EETauTauTree: Expected branch doubleMuTrkGroup does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleMuTrkGroup")
        else:
            self.doubleMuTrkGroup_branch.SetAddress(<void*>&self.doubleMuTrkGroup_value)

        #print "making doubleMuTrkPass"
        self.doubleMuTrkPass_branch = the_tree.GetBranch("doubleMuTrkPass")
        #if not self.doubleMuTrkPass_branch and "doubleMuTrkPass" not in self.complained:
        if not self.doubleMuTrkPass_branch and "doubleMuTrkPass":
            warnings.warn( "EETauTauTree: Expected branch doubleMuTrkPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleMuTrkPass")
        else:
            self.doubleMuTrkPass_branch.SetAddress(<void*>&self.doubleMuTrkPass_value)

        #print "making doubleMuTrkPrescale"
        self.doubleMuTrkPrescale_branch = the_tree.GetBranch("doubleMuTrkPrescale")
        #if not self.doubleMuTrkPrescale_branch and "doubleMuTrkPrescale" not in self.complained:
        if not self.doubleMuTrkPrescale_branch and "doubleMuTrkPrescale":
            warnings.warn( "EETauTauTree: Expected branch doubleMuTrkPrescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleMuTrkPrescale")
        else:
            self.doubleMuTrkPrescale_branch.SetAddress(<void*>&self.doubleMuTrkPrescale_value)

        #print "making doublePhoGroup"
        self.doublePhoGroup_branch = the_tree.GetBranch("doublePhoGroup")
        #if not self.doublePhoGroup_branch and "doublePhoGroup" not in self.complained:
        if not self.doublePhoGroup_branch and "doublePhoGroup":
            warnings.warn( "EETauTauTree: Expected branch doublePhoGroup does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doublePhoGroup")
        else:
            self.doublePhoGroup_branch.SetAddress(<void*>&self.doublePhoGroup_value)

        #print "making doublePhoPass"
        self.doublePhoPass_branch = the_tree.GetBranch("doublePhoPass")
        #if not self.doublePhoPass_branch and "doublePhoPass" not in self.complained:
        if not self.doublePhoPass_branch and "doublePhoPass":
            warnings.warn( "EETauTauTree: Expected branch doublePhoPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doublePhoPass")
        else:
            self.doublePhoPass_branch.SetAddress(<void*>&self.doublePhoPass_value)

        #print "making doublePhoPrescale"
        self.doublePhoPrescale_branch = the_tree.GetBranch("doublePhoPrescale")
        #if not self.doublePhoPrescale_branch and "doublePhoPrescale" not in self.complained:
        if not self.doublePhoPrescale_branch and "doublePhoPrescale":
            warnings.warn( "EETauTauTree: Expected branch doublePhoPrescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doublePhoPrescale")
        else:
            self.doublePhoPrescale_branch.SetAddress(<void*>&self.doublePhoPrescale_value)

        #print "making e1AbsEta"
        self.e1AbsEta_branch = the_tree.GetBranch("e1AbsEta")
        #if not self.e1AbsEta_branch and "e1AbsEta" not in self.complained:
        if not self.e1AbsEta_branch and "e1AbsEta":
            warnings.warn( "EETauTauTree: Expected branch e1AbsEta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1AbsEta")
        else:
            self.e1AbsEta_branch.SetAddress(<void*>&self.e1AbsEta_value)

        #print "making e1CBID_LOOSE"
        self.e1CBID_LOOSE_branch = the_tree.GetBranch("e1CBID_LOOSE")
        #if not self.e1CBID_LOOSE_branch and "e1CBID_LOOSE" not in self.complained:
        if not self.e1CBID_LOOSE_branch and "e1CBID_LOOSE":
            warnings.warn( "EETauTauTree: Expected branch e1CBID_LOOSE does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1CBID_LOOSE")
        else:
            self.e1CBID_LOOSE_branch.SetAddress(<void*>&self.e1CBID_LOOSE_value)

        #print "making e1CBID_MEDIUM"
        self.e1CBID_MEDIUM_branch = the_tree.GetBranch("e1CBID_MEDIUM")
        #if not self.e1CBID_MEDIUM_branch and "e1CBID_MEDIUM" not in self.complained:
        if not self.e1CBID_MEDIUM_branch and "e1CBID_MEDIUM":
            warnings.warn( "EETauTauTree: Expected branch e1CBID_MEDIUM does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1CBID_MEDIUM")
        else:
            self.e1CBID_MEDIUM_branch.SetAddress(<void*>&self.e1CBID_MEDIUM_value)

        #print "making e1CBID_TIGHT"
        self.e1CBID_TIGHT_branch = the_tree.GetBranch("e1CBID_TIGHT")
        #if not self.e1CBID_TIGHT_branch and "e1CBID_TIGHT" not in self.complained:
        if not self.e1CBID_TIGHT_branch and "e1CBID_TIGHT":
            warnings.warn( "EETauTauTree: Expected branch e1CBID_TIGHT does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1CBID_TIGHT")
        else:
            self.e1CBID_TIGHT_branch.SetAddress(<void*>&self.e1CBID_TIGHT_value)

        #print "making e1CBID_VETO"
        self.e1CBID_VETO_branch = the_tree.GetBranch("e1CBID_VETO")
        #if not self.e1CBID_VETO_branch and "e1CBID_VETO" not in self.complained:
        if not self.e1CBID_VETO_branch and "e1CBID_VETO":
            warnings.warn( "EETauTauTree: Expected branch e1CBID_VETO does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1CBID_VETO")
        else:
            self.e1CBID_VETO_branch.SetAddress(<void*>&self.e1CBID_VETO_value)

        #print "making e1Charge"
        self.e1Charge_branch = the_tree.GetBranch("e1Charge")
        #if not self.e1Charge_branch and "e1Charge" not in self.complained:
        if not self.e1Charge_branch and "e1Charge":
            warnings.warn( "EETauTauTree: Expected branch e1Charge does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1Charge")
        else:
            self.e1Charge_branch.SetAddress(<void*>&self.e1Charge_value)

        #print "making e1ChargeIdLoose"
        self.e1ChargeIdLoose_branch = the_tree.GetBranch("e1ChargeIdLoose")
        #if not self.e1ChargeIdLoose_branch and "e1ChargeIdLoose" not in self.complained:
        if not self.e1ChargeIdLoose_branch and "e1ChargeIdLoose":
            warnings.warn( "EETauTauTree: Expected branch e1ChargeIdLoose does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1ChargeIdLoose")
        else:
            self.e1ChargeIdLoose_branch.SetAddress(<void*>&self.e1ChargeIdLoose_value)

        #print "making e1ChargeIdMed"
        self.e1ChargeIdMed_branch = the_tree.GetBranch("e1ChargeIdMed")
        #if not self.e1ChargeIdMed_branch and "e1ChargeIdMed" not in self.complained:
        if not self.e1ChargeIdMed_branch and "e1ChargeIdMed":
            warnings.warn( "EETauTauTree: Expected branch e1ChargeIdMed does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1ChargeIdMed")
        else:
            self.e1ChargeIdMed_branch.SetAddress(<void*>&self.e1ChargeIdMed_value)

        #print "making e1ChargeIdTight"
        self.e1ChargeIdTight_branch = the_tree.GetBranch("e1ChargeIdTight")
        #if not self.e1ChargeIdTight_branch and "e1ChargeIdTight" not in self.complained:
        if not self.e1ChargeIdTight_branch and "e1ChargeIdTight":
            warnings.warn( "EETauTauTree: Expected branch e1ChargeIdTight does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1ChargeIdTight")
        else:
            self.e1ChargeIdTight_branch.SetAddress(<void*>&self.e1ChargeIdTight_value)

        #print "making e1CiCTight"
        self.e1CiCTight_branch = the_tree.GetBranch("e1CiCTight")
        #if not self.e1CiCTight_branch and "e1CiCTight" not in self.complained:
        if not self.e1CiCTight_branch and "e1CiCTight":
            warnings.warn( "EETauTauTree: Expected branch e1CiCTight does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1CiCTight")
        else:
            self.e1CiCTight_branch.SetAddress(<void*>&self.e1CiCTight_value)

        #print "making e1CiCTightElecOverlap"
        self.e1CiCTightElecOverlap_branch = the_tree.GetBranch("e1CiCTightElecOverlap")
        #if not self.e1CiCTightElecOverlap_branch and "e1CiCTightElecOverlap" not in self.complained:
        if not self.e1CiCTightElecOverlap_branch and "e1CiCTightElecOverlap":
            warnings.warn( "EETauTauTree: Expected branch e1CiCTightElecOverlap does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1CiCTightElecOverlap")
        else:
            self.e1CiCTightElecOverlap_branch.SetAddress(<void*>&self.e1CiCTightElecOverlap_value)

        #print "making e1ComesFromHiggs"
        self.e1ComesFromHiggs_branch = the_tree.GetBranch("e1ComesFromHiggs")
        #if not self.e1ComesFromHiggs_branch and "e1ComesFromHiggs" not in self.complained:
        if not self.e1ComesFromHiggs_branch and "e1ComesFromHiggs":
            warnings.warn( "EETauTauTree: Expected branch e1ComesFromHiggs does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1ComesFromHiggs")
        else:
            self.e1ComesFromHiggs_branch.SetAddress(<void*>&self.e1ComesFromHiggs_value)

        #print "making e1DZ"
        self.e1DZ_branch = the_tree.GetBranch("e1DZ")
        #if not self.e1DZ_branch and "e1DZ" not in self.complained:
        if not self.e1DZ_branch and "e1DZ":
            warnings.warn( "EETauTauTree: Expected branch e1DZ does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1DZ")
        else:
            self.e1DZ_branch.SetAddress(<void*>&self.e1DZ_value)

        #print "making e1E1x5"
        self.e1E1x5_branch = the_tree.GetBranch("e1E1x5")
        #if not self.e1E1x5_branch and "e1E1x5" not in self.complained:
        if not self.e1E1x5_branch and "e1E1x5":
            warnings.warn( "EETauTauTree: Expected branch e1E1x5 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1E1x5")
        else:
            self.e1E1x5_branch.SetAddress(<void*>&self.e1E1x5_value)

        #print "making e1E2x5Max"
        self.e1E2x5Max_branch = the_tree.GetBranch("e1E2x5Max")
        #if not self.e1E2x5Max_branch and "e1E2x5Max" not in self.complained:
        if not self.e1E2x5Max_branch and "e1E2x5Max":
            warnings.warn( "EETauTauTree: Expected branch e1E2x5Max does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1E2x5Max")
        else:
            self.e1E2x5Max_branch.SetAddress(<void*>&self.e1E2x5Max_value)

        #print "making e1E5x5"
        self.e1E5x5_branch = the_tree.GetBranch("e1E5x5")
        #if not self.e1E5x5_branch and "e1E5x5" not in self.complained:
        if not self.e1E5x5_branch and "e1E5x5":
            warnings.warn( "EETauTauTree: Expected branch e1E5x5 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1E5x5")
        else:
            self.e1E5x5_branch.SetAddress(<void*>&self.e1E5x5_value)

        #print "making e1ECorrReg_2012Jul13ReReco"
        self.e1ECorrReg_2012Jul13ReReco_branch = the_tree.GetBranch("e1ECorrReg_2012Jul13ReReco")
        #if not self.e1ECorrReg_2012Jul13ReReco_branch and "e1ECorrReg_2012Jul13ReReco" not in self.complained:
        if not self.e1ECorrReg_2012Jul13ReReco_branch and "e1ECorrReg_2012Jul13ReReco":
            warnings.warn( "EETauTauTree: Expected branch e1ECorrReg_2012Jul13ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1ECorrReg_2012Jul13ReReco")
        else:
            self.e1ECorrReg_2012Jul13ReReco_branch.SetAddress(<void*>&self.e1ECorrReg_2012Jul13ReReco_value)

        #print "making e1ECorrReg_Fall11"
        self.e1ECorrReg_Fall11_branch = the_tree.GetBranch("e1ECorrReg_Fall11")
        #if not self.e1ECorrReg_Fall11_branch and "e1ECorrReg_Fall11" not in self.complained:
        if not self.e1ECorrReg_Fall11_branch and "e1ECorrReg_Fall11":
            warnings.warn( "EETauTauTree: Expected branch e1ECorrReg_Fall11 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1ECorrReg_Fall11")
        else:
            self.e1ECorrReg_Fall11_branch.SetAddress(<void*>&self.e1ECorrReg_Fall11_value)

        #print "making e1ECorrReg_Jan16ReReco"
        self.e1ECorrReg_Jan16ReReco_branch = the_tree.GetBranch("e1ECorrReg_Jan16ReReco")
        #if not self.e1ECorrReg_Jan16ReReco_branch and "e1ECorrReg_Jan16ReReco" not in self.complained:
        if not self.e1ECorrReg_Jan16ReReco_branch and "e1ECorrReg_Jan16ReReco":
            warnings.warn( "EETauTauTree: Expected branch e1ECorrReg_Jan16ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1ECorrReg_Jan16ReReco")
        else:
            self.e1ECorrReg_Jan16ReReco_branch.SetAddress(<void*>&self.e1ECorrReg_Jan16ReReco_value)

        #print "making e1ECorrReg_Summer12_DR53X_HCP2012"
        self.e1ECorrReg_Summer12_DR53X_HCP2012_branch = the_tree.GetBranch("e1ECorrReg_Summer12_DR53X_HCP2012")
        #if not self.e1ECorrReg_Summer12_DR53X_HCP2012_branch and "e1ECorrReg_Summer12_DR53X_HCP2012" not in self.complained:
        if not self.e1ECorrReg_Summer12_DR53X_HCP2012_branch and "e1ECorrReg_Summer12_DR53X_HCP2012":
            warnings.warn( "EETauTauTree: Expected branch e1ECorrReg_Summer12_DR53X_HCP2012 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1ECorrReg_Summer12_DR53X_HCP2012")
        else:
            self.e1ECorrReg_Summer12_DR53X_HCP2012_branch.SetAddress(<void*>&self.e1ECorrReg_Summer12_DR53X_HCP2012_value)

        #print "making e1ECorrSmearedNoReg_2012Jul13ReReco"
        self.e1ECorrSmearedNoReg_2012Jul13ReReco_branch = the_tree.GetBranch("e1ECorrSmearedNoReg_2012Jul13ReReco")
        #if not self.e1ECorrSmearedNoReg_2012Jul13ReReco_branch and "e1ECorrSmearedNoReg_2012Jul13ReReco" not in self.complained:
        if not self.e1ECorrSmearedNoReg_2012Jul13ReReco_branch and "e1ECorrSmearedNoReg_2012Jul13ReReco":
            warnings.warn( "EETauTauTree: Expected branch e1ECorrSmearedNoReg_2012Jul13ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1ECorrSmearedNoReg_2012Jul13ReReco")
        else:
            self.e1ECorrSmearedNoReg_2012Jul13ReReco_branch.SetAddress(<void*>&self.e1ECorrSmearedNoReg_2012Jul13ReReco_value)

        #print "making e1ECorrSmearedNoReg_Fall11"
        self.e1ECorrSmearedNoReg_Fall11_branch = the_tree.GetBranch("e1ECorrSmearedNoReg_Fall11")
        #if not self.e1ECorrSmearedNoReg_Fall11_branch and "e1ECorrSmearedNoReg_Fall11" not in self.complained:
        if not self.e1ECorrSmearedNoReg_Fall11_branch and "e1ECorrSmearedNoReg_Fall11":
            warnings.warn( "EETauTauTree: Expected branch e1ECorrSmearedNoReg_Fall11 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1ECorrSmearedNoReg_Fall11")
        else:
            self.e1ECorrSmearedNoReg_Fall11_branch.SetAddress(<void*>&self.e1ECorrSmearedNoReg_Fall11_value)

        #print "making e1ECorrSmearedNoReg_Jan16ReReco"
        self.e1ECorrSmearedNoReg_Jan16ReReco_branch = the_tree.GetBranch("e1ECorrSmearedNoReg_Jan16ReReco")
        #if not self.e1ECorrSmearedNoReg_Jan16ReReco_branch and "e1ECorrSmearedNoReg_Jan16ReReco" not in self.complained:
        if not self.e1ECorrSmearedNoReg_Jan16ReReco_branch and "e1ECorrSmearedNoReg_Jan16ReReco":
            warnings.warn( "EETauTauTree: Expected branch e1ECorrSmearedNoReg_Jan16ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1ECorrSmearedNoReg_Jan16ReReco")
        else:
            self.e1ECorrSmearedNoReg_Jan16ReReco_branch.SetAddress(<void*>&self.e1ECorrSmearedNoReg_Jan16ReReco_value)

        #print "making e1ECorrSmearedNoReg_Summer12_DR53X_HCP2012"
        self.e1ECorrSmearedNoReg_Summer12_DR53X_HCP2012_branch = the_tree.GetBranch("e1ECorrSmearedNoReg_Summer12_DR53X_HCP2012")
        #if not self.e1ECorrSmearedNoReg_Summer12_DR53X_HCP2012_branch and "e1ECorrSmearedNoReg_Summer12_DR53X_HCP2012" not in self.complained:
        if not self.e1ECorrSmearedNoReg_Summer12_DR53X_HCP2012_branch and "e1ECorrSmearedNoReg_Summer12_DR53X_HCP2012":
            warnings.warn( "EETauTauTree: Expected branch e1ECorrSmearedNoReg_Summer12_DR53X_HCP2012 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1ECorrSmearedNoReg_Summer12_DR53X_HCP2012")
        else:
            self.e1ECorrSmearedNoReg_Summer12_DR53X_HCP2012_branch.SetAddress(<void*>&self.e1ECorrSmearedNoReg_Summer12_DR53X_HCP2012_value)

        #print "making e1ECorrSmearedReg_2012Jul13ReReco"
        self.e1ECorrSmearedReg_2012Jul13ReReco_branch = the_tree.GetBranch("e1ECorrSmearedReg_2012Jul13ReReco")
        #if not self.e1ECorrSmearedReg_2012Jul13ReReco_branch and "e1ECorrSmearedReg_2012Jul13ReReco" not in self.complained:
        if not self.e1ECorrSmearedReg_2012Jul13ReReco_branch and "e1ECorrSmearedReg_2012Jul13ReReco":
            warnings.warn( "EETauTauTree: Expected branch e1ECorrSmearedReg_2012Jul13ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1ECorrSmearedReg_2012Jul13ReReco")
        else:
            self.e1ECorrSmearedReg_2012Jul13ReReco_branch.SetAddress(<void*>&self.e1ECorrSmearedReg_2012Jul13ReReco_value)

        #print "making e1ECorrSmearedReg_Fall11"
        self.e1ECorrSmearedReg_Fall11_branch = the_tree.GetBranch("e1ECorrSmearedReg_Fall11")
        #if not self.e1ECorrSmearedReg_Fall11_branch and "e1ECorrSmearedReg_Fall11" not in self.complained:
        if not self.e1ECorrSmearedReg_Fall11_branch and "e1ECorrSmearedReg_Fall11":
            warnings.warn( "EETauTauTree: Expected branch e1ECorrSmearedReg_Fall11 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1ECorrSmearedReg_Fall11")
        else:
            self.e1ECorrSmearedReg_Fall11_branch.SetAddress(<void*>&self.e1ECorrSmearedReg_Fall11_value)

        #print "making e1ECorrSmearedReg_Jan16ReReco"
        self.e1ECorrSmearedReg_Jan16ReReco_branch = the_tree.GetBranch("e1ECorrSmearedReg_Jan16ReReco")
        #if not self.e1ECorrSmearedReg_Jan16ReReco_branch and "e1ECorrSmearedReg_Jan16ReReco" not in self.complained:
        if not self.e1ECorrSmearedReg_Jan16ReReco_branch and "e1ECorrSmearedReg_Jan16ReReco":
            warnings.warn( "EETauTauTree: Expected branch e1ECorrSmearedReg_Jan16ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1ECorrSmearedReg_Jan16ReReco")
        else:
            self.e1ECorrSmearedReg_Jan16ReReco_branch.SetAddress(<void*>&self.e1ECorrSmearedReg_Jan16ReReco_value)

        #print "making e1ECorrSmearedReg_Summer12_DR53X_HCP2012"
        self.e1ECorrSmearedReg_Summer12_DR53X_HCP2012_branch = the_tree.GetBranch("e1ECorrSmearedReg_Summer12_DR53X_HCP2012")
        #if not self.e1ECorrSmearedReg_Summer12_DR53X_HCP2012_branch and "e1ECorrSmearedReg_Summer12_DR53X_HCP2012" not in self.complained:
        if not self.e1ECorrSmearedReg_Summer12_DR53X_HCP2012_branch and "e1ECorrSmearedReg_Summer12_DR53X_HCP2012":
            warnings.warn( "EETauTauTree: Expected branch e1ECorrSmearedReg_Summer12_DR53X_HCP2012 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1ECorrSmearedReg_Summer12_DR53X_HCP2012")
        else:
            self.e1ECorrSmearedReg_Summer12_DR53X_HCP2012_branch.SetAddress(<void*>&self.e1ECorrSmearedReg_Summer12_DR53X_HCP2012_value)

        #print "making e1EcalIsoDR03"
        self.e1EcalIsoDR03_branch = the_tree.GetBranch("e1EcalIsoDR03")
        #if not self.e1EcalIsoDR03_branch and "e1EcalIsoDR03" not in self.complained:
        if not self.e1EcalIsoDR03_branch and "e1EcalIsoDR03":
            warnings.warn( "EETauTauTree: Expected branch e1EcalIsoDR03 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1EcalIsoDR03")
        else:
            self.e1EcalIsoDR03_branch.SetAddress(<void*>&self.e1EcalIsoDR03_value)

        #print "making e1EffectiveArea2011Data"
        self.e1EffectiveArea2011Data_branch = the_tree.GetBranch("e1EffectiveArea2011Data")
        #if not self.e1EffectiveArea2011Data_branch and "e1EffectiveArea2011Data" not in self.complained:
        if not self.e1EffectiveArea2011Data_branch and "e1EffectiveArea2011Data":
            warnings.warn( "EETauTauTree: Expected branch e1EffectiveArea2011Data does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1EffectiveArea2011Data")
        else:
            self.e1EffectiveArea2011Data_branch.SetAddress(<void*>&self.e1EffectiveArea2011Data_value)

        #print "making e1EffectiveArea2012Data"
        self.e1EffectiveArea2012Data_branch = the_tree.GetBranch("e1EffectiveArea2012Data")
        #if not self.e1EffectiveArea2012Data_branch and "e1EffectiveArea2012Data" not in self.complained:
        if not self.e1EffectiveArea2012Data_branch and "e1EffectiveArea2012Data":
            warnings.warn( "EETauTauTree: Expected branch e1EffectiveArea2012Data does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1EffectiveArea2012Data")
        else:
            self.e1EffectiveArea2012Data_branch.SetAddress(<void*>&self.e1EffectiveArea2012Data_value)

        #print "making e1EffectiveAreaFall11MC"
        self.e1EffectiveAreaFall11MC_branch = the_tree.GetBranch("e1EffectiveAreaFall11MC")
        #if not self.e1EffectiveAreaFall11MC_branch and "e1EffectiveAreaFall11MC" not in self.complained:
        if not self.e1EffectiveAreaFall11MC_branch and "e1EffectiveAreaFall11MC":
            warnings.warn( "EETauTauTree: Expected branch e1EffectiveAreaFall11MC does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1EffectiveAreaFall11MC")
        else:
            self.e1EffectiveAreaFall11MC_branch.SetAddress(<void*>&self.e1EffectiveAreaFall11MC_value)

        #print "making e1Ele27WP80PFMT50PFMTFilter"
        self.e1Ele27WP80PFMT50PFMTFilter_branch = the_tree.GetBranch("e1Ele27WP80PFMT50PFMTFilter")
        #if not self.e1Ele27WP80PFMT50PFMTFilter_branch and "e1Ele27WP80PFMT50PFMTFilter" not in self.complained:
        if not self.e1Ele27WP80PFMT50PFMTFilter_branch and "e1Ele27WP80PFMT50PFMTFilter":
            warnings.warn( "EETauTauTree: Expected branch e1Ele27WP80PFMT50PFMTFilter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1Ele27WP80PFMT50PFMTFilter")
        else:
            self.e1Ele27WP80PFMT50PFMTFilter_branch.SetAddress(<void*>&self.e1Ele27WP80PFMT50PFMTFilter_value)

        #print "making e1Ele27WP80TrackIsoMatchFilter"
        self.e1Ele27WP80TrackIsoMatchFilter_branch = the_tree.GetBranch("e1Ele27WP80TrackIsoMatchFilter")
        #if not self.e1Ele27WP80TrackIsoMatchFilter_branch and "e1Ele27WP80TrackIsoMatchFilter" not in self.complained:
        if not self.e1Ele27WP80TrackIsoMatchFilter_branch and "e1Ele27WP80TrackIsoMatchFilter":
            warnings.warn( "EETauTauTree: Expected branch e1Ele27WP80TrackIsoMatchFilter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1Ele27WP80TrackIsoMatchFilter")
        else:
            self.e1Ele27WP80TrackIsoMatchFilter_branch.SetAddress(<void*>&self.e1Ele27WP80TrackIsoMatchFilter_value)

        #print "making e1Ele32WP70PFMT50PFMTFilter"
        self.e1Ele32WP70PFMT50PFMTFilter_branch = the_tree.GetBranch("e1Ele32WP70PFMT50PFMTFilter")
        #if not self.e1Ele32WP70PFMT50PFMTFilter_branch and "e1Ele32WP70PFMT50PFMTFilter" not in self.complained:
        if not self.e1Ele32WP70PFMT50PFMTFilter_branch and "e1Ele32WP70PFMT50PFMTFilter":
            warnings.warn( "EETauTauTree: Expected branch e1Ele32WP70PFMT50PFMTFilter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1Ele32WP70PFMT50PFMTFilter")
        else:
            self.e1Ele32WP70PFMT50PFMTFilter_branch.SetAddress(<void*>&self.e1Ele32WP70PFMT50PFMTFilter_value)

        #print "making e1ElecOverlap"
        self.e1ElecOverlap_branch = the_tree.GetBranch("e1ElecOverlap")
        #if not self.e1ElecOverlap_branch and "e1ElecOverlap" not in self.complained:
        if not self.e1ElecOverlap_branch and "e1ElecOverlap":
            warnings.warn( "EETauTauTree: Expected branch e1ElecOverlap does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1ElecOverlap")
        else:
            self.e1ElecOverlap_branch.SetAddress(<void*>&self.e1ElecOverlap_value)

        #print "making e1ElecOverlapZHLoose"
        self.e1ElecOverlapZHLoose_branch = the_tree.GetBranch("e1ElecOverlapZHLoose")
        #if not self.e1ElecOverlapZHLoose_branch and "e1ElecOverlapZHLoose" not in self.complained:
        if not self.e1ElecOverlapZHLoose_branch and "e1ElecOverlapZHLoose":
            warnings.warn( "EETauTauTree: Expected branch e1ElecOverlapZHLoose does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1ElecOverlapZHLoose")
        else:
            self.e1ElecOverlapZHLoose_branch.SetAddress(<void*>&self.e1ElecOverlapZHLoose_value)

        #print "making e1ElecOverlapZHTight"
        self.e1ElecOverlapZHTight_branch = the_tree.GetBranch("e1ElecOverlapZHTight")
        #if not self.e1ElecOverlapZHTight_branch and "e1ElecOverlapZHTight" not in self.complained:
        if not self.e1ElecOverlapZHTight_branch and "e1ElecOverlapZHTight":
            warnings.warn( "EETauTauTree: Expected branch e1ElecOverlapZHTight does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1ElecOverlapZHTight")
        else:
            self.e1ElecOverlapZHTight_branch.SetAddress(<void*>&self.e1ElecOverlapZHTight_value)

        #print "making e1EnergyError"
        self.e1EnergyError_branch = the_tree.GetBranch("e1EnergyError")
        #if not self.e1EnergyError_branch and "e1EnergyError" not in self.complained:
        if not self.e1EnergyError_branch and "e1EnergyError":
            warnings.warn( "EETauTauTree: Expected branch e1EnergyError does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1EnergyError")
        else:
            self.e1EnergyError_branch.SetAddress(<void*>&self.e1EnergyError_value)

        #print "making e1Eta"
        self.e1Eta_branch = the_tree.GetBranch("e1Eta")
        #if not self.e1Eta_branch and "e1Eta" not in self.complained:
        if not self.e1Eta_branch and "e1Eta":
            warnings.warn( "EETauTauTree: Expected branch e1Eta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1Eta")
        else:
            self.e1Eta_branch.SetAddress(<void*>&self.e1Eta_value)

        #print "making e1EtaCorrReg_2012Jul13ReReco"
        self.e1EtaCorrReg_2012Jul13ReReco_branch = the_tree.GetBranch("e1EtaCorrReg_2012Jul13ReReco")
        #if not self.e1EtaCorrReg_2012Jul13ReReco_branch and "e1EtaCorrReg_2012Jul13ReReco" not in self.complained:
        if not self.e1EtaCorrReg_2012Jul13ReReco_branch and "e1EtaCorrReg_2012Jul13ReReco":
            warnings.warn( "EETauTauTree: Expected branch e1EtaCorrReg_2012Jul13ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1EtaCorrReg_2012Jul13ReReco")
        else:
            self.e1EtaCorrReg_2012Jul13ReReco_branch.SetAddress(<void*>&self.e1EtaCorrReg_2012Jul13ReReco_value)

        #print "making e1EtaCorrReg_Fall11"
        self.e1EtaCorrReg_Fall11_branch = the_tree.GetBranch("e1EtaCorrReg_Fall11")
        #if not self.e1EtaCorrReg_Fall11_branch and "e1EtaCorrReg_Fall11" not in self.complained:
        if not self.e1EtaCorrReg_Fall11_branch and "e1EtaCorrReg_Fall11":
            warnings.warn( "EETauTauTree: Expected branch e1EtaCorrReg_Fall11 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1EtaCorrReg_Fall11")
        else:
            self.e1EtaCorrReg_Fall11_branch.SetAddress(<void*>&self.e1EtaCorrReg_Fall11_value)

        #print "making e1EtaCorrReg_Jan16ReReco"
        self.e1EtaCorrReg_Jan16ReReco_branch = the_tree.GetBranch("e1EtaCorrReg_Jan16ReReco")
        #if not self.e1EtaCorrReg_Jan16ReReco_branch and "e1EtaCorrReg_Jan16ReReco" not in self.complained:
        if not self.e1EtaCorrReg_Jan16ReReco_branch and "e1EtaCorrReg_Jan16ReReco":
            warnings.warn( "EETauTauTree: Expected branch e1EtaCorrReg_Jan16ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1EtaCorrReg_Jan16ReReco")
        else:
            self.e1EtaCorrReg_Jan16ReReco_branch.SetAddress(<void*>&self.e1EtaCorrReg_Jan16ReReco_value)

        #print "making e1EtaCorrReg_Summer12_DR53X_HCP2012"
        self.e1EtaCorrReg_Summer12_DR53X_HCP2012_branch = the_tree.GetBranch("e1EtaCorrReg_Summer12_DR53X_HCP2012")
        #if not self.e1EtaCorrReg_Summer12_DR53X_HCP2012_branch and "e1EtaCorrReg_Summer12_DR53X_HCP2012" not in self.complained:
        if not self.e1EtaCorrReg_Summer12_DR53X_HCP2012_branch and "e1EtaCorrReg_Summer12_DR53X_HCP2012":
            warnings.warn( "EETauTauTree: Expected branch e1EtaCorrReg_Summer12_DR53X_HCP2012 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1EtaCorrReg_Summer12_DR53X_HCP2012")
        else:
            self.e1EtaCorrReg_Summer12_DR53X_HCP2012_branch.SetAddress(<void*>&self.e1EtaCorrReg_Summer12_DR53X_HCP2012_value)

        #print "making e1EtaCorrSmearedNoReg_2012Jul13ReReco"
        self.e1EtaCorrSmearedNoReg_2012Jul13ReReco_branch = the_tree.GetBranch("e1EtaCorrSmearedNoReg_2012Jul13ReReco")
        #if not self.e1EtaCorrSmearedNoReg_2012Jul13ReReco_branch and "e1EtaCorrSmearedNoReg_2012Jul13ReReco" not in self.complained:
        if not self.e1EtaCorrSmearedNoReg_2012Jul13ReReco_branch and "e1EtaCorrSmearedNoReg_2012Jul13ReReco":
            warnings.warn( "EETauTauTree: Expected branch e1EtaCorrSmearedNoReg_2012Jul13ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1EtaCorrSmearedNoReg_2012Jul13ReReco")
        else:
            self.e1EtaCorrSmearedNoReg_2012Jul13ReReco_branch.SetAddress(<void*>&self.e1EtaCorrSmearedNoReg_2012Jul13ReReco_value)

        #print "making e1EtaCorrSmearedNoReg_Fall11"
        self.e1EtaCorrSmearedNoReg_Fall11_branch = the_tree.GetBranch("e1EtaCorrSmearedNoReg_Fall11")
        #if not self.e1EtaCorrSmearedNoReg_Fall11_branch and "e1EtaCorrSmearedNoReg_Fall11" not in self.complained:
        if not self.e1EtaCorrSmearedNoReg_Fall11_branch and "e1EtaCorrSmearedNoReg_Fall11":
            warnings.warn( "EETauTauTree: Expected branch e1EtaCorrSmearedNoReg_Fall11 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1EtaCorrSmearedNoReg_Fall11")
        else:
            self.e1EtaCorrSmearedNoReg_Fall11_branch.SetAddress(<void*>&self.e1EtaCorrSmearedNoReg_Fall11_value)

        #print "making e1EtaCorrSmearedNoReg_Jan16ReReco"
        self.e1EtaCorrSmearedNoReg_Jan16ReReco_branch = the_tree.GetBranch("e1EtaCorrSmearedNoReg_Jan16ReReco")
        #if not self.e1EtaCorrSmearedNoReg_Jan16ReReco_branch and "e1EtaCorrSmearedNoReg_Jan16ReReco" not in self.complained:
        if not self.e1EtaCorrSmearedNoReg_Jan16ReReco_branch and "e1EtaCorrSmearedNoReg_Jan16ReReco":
            warnings.warn( "EETauTauTree: Expected branch e1EtaCorrSmearedNoReg_Jan16ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1EtaCorrSmearedNoReg_Jan16ReReco")
        else:
            self.e1EtaCorrSmearedNoReg_Jan16ReReco_branch.SetAddress(<void*>&self.e1EtaCorrSmearedNoReg_Jan16ReReco_value)

        #print "making e1EtaCorrSmearedNoReg_Summer12_DR53X_HCP2012"
        self.e1EtaCorrSmearedNoReg_Summer12_DR53X_HCP2012_branch = the_tree.GetBranch("e1EtaCorrSmearedNoReg_Summer12_DR53X_HCP2012")
        #if not self.e1EtaCorrSmearedNoReg_Summer12_DR53X_HCP2012_branch and "e1EtaCorrSmearedNoReg_Summer12_DR53X_HCP2012" not in self.complained:
        if not self.e1EtaCorrSmearedNoReg_Summer12_DR53X_HCP2012_branch and "e1EtaCorrSmearedNoReg_Summer12_DR53X_HCP2012":
            warnings.warn( "EETauTauTree: Expected branch e1EtaCorrSmearedNoReg_Summer12_DR53X_HCP2012 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1EtaCorrSmearedNoReg_Summer12_DR53X_HCP2012")
        else:
            self.e1EtaCorrSmearedNoReg_Summer12_DR53X_HCP2012_branch.SetAddress(<void*>&self.e1EtaCorrSmearedNoReg_Summer12_DR53X_HCP2012_value)

        #print "making e1EtaCorrSmearedReg_2012Jul13ReReco"
        self.e1EtaCorrSmearedReg_2012Jul13ReReco_branch = the_tree.GetBranch("e1EtaCorrSmearedReg_2012Jul13ReReco")
        #if not self.e1EtaCorrSmearedReg_2012Jul13ReReco_branch and "e1EtaCorrSmearedReg_2012Jul13ReReco" not in self.complained:
        if not self.e1EtaCorrSmearedReg_2012Jul13ReReco_branch and "e1EtaCorrSmearedReg_2012Jul13ReReco":
            warnings.warn( "EETauTauTree: Expected branch e1EtaCorrSmearedReg_2012Jul13ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1EtaCorrSmearedReg_2012Jul13ReReco")
        else:
            self.e1EtaCorrSmearedReg_2012Jul13ReReco_branch.SetAddress(<void*>&self.e1EtaCorrSmearedReg_2012Jul13ReReco_value)

        #print "making e1EtaCorrSmearedReg_Fall11"
        self.e1EtaCorrSmearedReg_Fall11_branch = the_tree.GetBranch("e1EtaCorrSmearedReg_Fall11")
        #if not self.e1EtaCorrSmearedReg_Fall11_branch and "e1EtaCorrSmearedReg_Fall11" not in self.complained:
        if not self.e1EtaCorrSmearedReg_Fall11_branch and "e1EtaCorrSmearedReg_Fall11":
            warnings.warn( "EETauTauTree: Expected branch e1EtaCorrSmearedReg_Fall11 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1EtaCorrSmearedReg_Fall11")
        else:
            self.e1EtaCorrSmearedReg_Fall11_branch.SetAddress(<void*>&self.e1EtaCorrSmearedReg_Fall11_value)

        #print "making e1EtaCorrSmearedReg_Jan16ReReco"
        self.e1EtaCorrSmearedReg_Jan16ReReco_branch = the_tree.GetBranch("e1EtaCorrSmearedReg_Jan16ReReco")
        #if not self.e1EtaCorrSmearedReg_Jan16ReReco_branch and "e1EtaCorrSmearedReg_Jan16ReReco" not in self.complained:
        if not self.e1EtaCorrSmearedReg_Jan16ReReco_branch and "e1EtaCorrSmearedReg_Jan16ReReco":
            warnings.warn( "EETauTauTree: Expected branch e1EtaCorrSmearedReg_Jan16ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1EtaCorrSmearedReg_Jan16ReReco")
        else:
            self.e1EtaCorrSmearedReg_Jan16ReReco_branch.SetAddress(<void*>&self.e1EtaCorrSmearedReg_Jan16ReReco_value)

        #print "making e1EtaCorrSmearedReg_Summer12_DR53X_HCP2012"
        self.e1EtaCorrSmearedReg_Summer12_DR53X_HCP2012_branch = the_tree.GetBranch("e1EtaCorrSmearedReg_Summer12_DR53X_HCP2012")
        #if not self.e1EtaCorrSmearedReg_Summer12_DR53X_HCP2012_branch and "e1EtaCorrSmearedReg_Summer12_DR53X_HCP2012" not in self.complained:
        if not self.e1EtaCorrSmearedReg_Summer12_DR53X_HCP2012_branch and "e1EtaCorrSmearedReg_Summer12_DR53X_HCP2012":
            warnings.warn( "EETauTauTree: Expected branch e1EtaCorrSmearedReg_Summer12_DR53X_HCP2012 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1EtaCorrSmearedReg_Summer12_DR53X_HCP2012")
        else:
            self.e1EtaCorrSmearedReg_Summer12_DR53X_HCP2012_branch.SetAddress(<void*>&self.e1EtaCorrSmearedReg_Summer12_DR53X_HCP2012_value)

        #print "making e1GenCharge"
        self.e1GenCharge_branch = the_tree.GetBranch("e1GenCharge")
        #if not self.e1GenCharge_branch and "e1GenCharge" not in self.complained:
        if not self.e1GenCharge_branch and "e1GenCharge":
            warnings.warn( "EETauTauTree: Expected branch e1GenCharge does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1GenCharge")
        else:
            self.e1GenCharge_branch.SetAddress(<void*>&self.e1GenCharge_value)

        #print "making e1GenEnergy"
        self.e1GenEnergy_branch = the_tree.GetBranch("e1GenEnergy")
        #if not self.e1GenEnergy_branch and "e1GenEnergy" not in self.complained:
        if not self.e1GenEnergy_branch and "e1GenEnergy":
            warnings.warn( "EETauTauTree: Expected branch e1GenEnergy does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1GenEnergy")
        else:
            self.e1GenEnergy_branch.SetAddress(<void*>&self.e1GenEnergy_value)

        #print "making e1GenEta"
        self.e1GenEta_branch = the_tree.GetBranch("e1GenEta")
        #if not self.e1GenEta_branch and "e1GenEta" not in self.complained:
        if not self.e1GenEta_branch and "e1GenEta":
            warnings.warn( "EETauTauTree: Expected branch e1GenEta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1GenEta")
        else:
            self.e1GenEta_branch.SetAddress(<void*>&self.e1GenEta_value)

        #print "making e1GenMotherPdgId"
        self.e1GenMotherPdgId_branch = the_tree.GetBranch("e1GenMotherPdgId")
        #if not self.e1GenMotherPdgId_branch and "e1GenMotherPdgId" not in self.complained:
        if not self.e1GenMotherPdgId_branch and "e1GenMotherPdgId":
            warnings.warn( "EETauTauTree: Expected branch e1GenMotherPdgId does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1GenMotherPdgId")
        else:
            self.e1GenMotherPdgId_branch.SetAddress(<void*>&self.e1GenMotherPdgId_value)

        #print "making e1GenPdgId"
        self.e1GenPdgId_branch = the_tree.GetBranch("e1GenPdgId")
        #if not self.e1GenPdgId_branch and "e1GenPdgId" not in self.complained:
        if not self.e1GenPdgId_branch and "e1GenPdgId":
            warnings.warn( "EETauTauTree: Expected branch e1GenPdgId does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1GenPdgId")
        else:
            self.e1GenPdgId_branch.SetAddress(<void*>&self.e1GenPdgId_value)

        #print "making e1GenPhi"
        self.e1GenPhi_branch = the_tree.GetBranch("e1GenPhi")
        #if not self.e1GenPhi_branch and "e1GenPhi" not in self.complained:
        if not self.e1GenPhi_branch and "e1GenPhi":
            warnings.warn( "EETauTauTree: Expected branch e1GenPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1GenPhi")
        else:
            self.e1GenPhi_branch.SetAddress(<void*>&self.e1GenPhi_value)

        #print "making e1HadronicDepth1OverEm"
        self.e1HadronicDepth1OverEm_branch = the_tree.GetBranch("e1HadronicDepth1OverEm")
        #if not self.e1HadronicDepth1OverEm_branch and "e1HadronicDepth1OverEm" not in self.complained:
        if not self.e1HadronicDepth1OverEm_branch and "e1HadronicDepth1OverEm":
            warnings.warn( "EETauTauTree: Expected branch e1HadronicDepth1OverEm does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1HadronicDepth1OverEm")
        else:
            self.e1HadronicDepth1OverEm_branch.SetAddress(<void*>&self.e1HadronicDepth1OverEm_value)

        #print "making e1HadronicDepth2OverEm"
        self.e1HadronicDepth2OverEm_branch = the_tree.GetBranch("e1HadronicDepth2OverEm")
        #if not self.e1HadronicDepth2OverEm_branch and "e1HadronicDepth2OverEm" not in self.complained:
        if not self.e1HadronicDepth2OverEm_branch and "e1HadronicDepth2OverEm":
            warnings.warn( "EETauTauTree: Expected branch e1HadronicDepth2OverEm does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1HadronicDepth2OverEm")
        else:
            self.e1HadronicDepth2OverEm_branch.SetAddress(<void*>&self.e1HadronicDepth2OverEm_value)

        #print "making e1HadronicOverEM"
        self.e1HadronicOverEM_branch = the_tree.GetBranch("e1HadronicOverEM")
        #if not self.e1HadronicOverEM_branch and "e1HadronicOverEM" not in self.complained:
        if not self.e1HadronicOverEM_branch and "e1HadronicOverEM":
            warnings.warn( "EETauTauTree: Expected branch e1HadronicOverEM does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1HadronicOverEM")
        else:
            self.e1HadronicOverEM_branch.SetAddress(<void*>&self.e1HadronicOverEM_value)

        #print "making e1HasConversion"
        self.e1HasConversion_branch = the_tree.GetBranch("e1HasConversion")
        #if not self.e1HasConversion_branch and "e1HasConversion" not in self.complained:
        if not self.e1HasConversion_branch and "e1HasConversion":
            warnings.warn( "EETauTauTree: Expected branch e1HasConversion does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1HasConversion")
        else:
            self.e1HasConversion_branch.SetAddress(<void*>&self.e1HasConversion_value)

        #print "making e1HasMatchedConversion"
        self.e1HasMatchedConversion_branch = the_tree.GetBranch("e1HasMatchedConversion")
        #if not self.e1HasMatchedConversion_branch and "e1HasMatchedConversion" not in self.complained:
        if not self.e1HasMatchedConversion_branch and "e1HasMatchedConversion":
            warnings.warn( "EETauTauTree: Expected branch e1HasMatchedConversion does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1HasMatchedConversion")
        else:
            self.e1HasMatchedConversion_branch.SetAddress(<void*>&self.e1HasMatchedConversion_value)

        #print "making e1HcalIsoDR03"
        self.e1HcalIsoDR03_branch = the_tree.GetBranch("e1HcalIsoDR03")
        #if not self.e1HcalIsoDR03_branch and "e1HcalIsoDR03" not in self.complained:
        if not self.e1HcalIsoDR03_branch and "e1HcalIsoDR03":
            warnings.warn( "EETauTauTree: Expected branch e1HcalIsoDR03 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1HcalIsoDR03")
        else:
            self.e1HcalIsoDR03_branch.SetAddress(<void*>&self.e1HcalIsoDR03_value)

        #print "making e1IP3DS"
        self.e1IP3DS_branch = the_tree.GetBranch("e1IP3DS")
        #if not self.e1IP3DS_branch and "e1IP3DS" not in self.complained:
        if not self.e1IP3DS_branch and "e1IP3DS":
            warnings.warn( "EETauTauTree: Expected branch e1IP3DS does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1IP3DS")
        else:
            self.e1IP3DS_branch.SetAddress(<void*>&self.e1IP3DS_value)

        #print "making e1JetArea"
        self.e1JetArea_branch = the_tree.GetBranch("e1JetArea")
        #if not self.e1JetArea_branch and "e1JetArea" not in self.complained:
        if not self.e1JetArea_branch and "e1JetArea":
            warnings.warn( "EETauTauTree: Expected branch e1JetArea does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1JetArea")
        else:
            self.e1JetArea_branch.SetAddress(<void*>&self.e1JetArea_value)

        #print "making e1JetBtag"
        self.e1JetBtag_branch = the_tree.GetBranch("e1JetBtag")
        #if not self.e1JetBtag_branch and "e1JetBtag" not in self.complained:
        if not self.e1JetBtag_branch and "e1JetBtag":
            warnings.warn( "EETauTauTree: Expected branch e1JetBtag does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1JetBtag")
        else:
            self.e1JetBtag_branch.SetAddress(<void*>&self.e1JetBtag_value)

        #print "making e1JetCSVBtag"
        self.e1JetCSVBtag_branch = the_tree.GetBranch("e1JetCSVBtag")
        #if not self.e1JetCSVBtag_branch and "e1JetCSVBtag" not in self.complained:
        if not self.e1JetCSVBtag_branch and "e1JetCSVBtag":
            warnings.warn( "EETauTauTree: Expected branch e1JetCSVBtag does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1JetCSVBtag")
        else:
            self.e1JetCSVBtag_branch.SetAddress(<void*>&self.e1JetCSVBtag_value)

        #print "making e1JetEtaEtaMoment"
        self.e1JetEtaEtaMoment_branch = the_tree.GetBranch("e1JetEtaEtaMoment")
        #if not self.e1JetEtaEtaMoment_branch and "e1JetEtaEtaMoment" not in self.complained:
        if not self.e1JetEtaEtaMoment_branch and "e1JetEtaEtaMoment":
            warnings.warn( "EETauTauTree: Expected branch e1JetEtaEtaMoment does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1JetEtaEtaMoment")
        else:
            self.e1JetEtaEtaMoment_branch.SetAddress(<void*>&self.e1JetEtaEtaMoment_value)

        #print "making e1JetEtaPhiMoment"
        self.e1JetEtaPhiMoment_branch = the_tree.GetBranch("e1JetEtaPhiMoment")
        #if not self.e1JetEtaPhiMoment_branch and "e1JetEtaPhiMoment" not in self.complained:
        if not self.e1JetEtaPhiMoment_branch and "e1JetEtaPhiMoment":
            warnings.warn( "EETauTauTree: Expected branch e1JetEtaPhiMoment does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1JetEtaPhiMoment")
        else:
            self.e1JetEtaPhiMoment_branch.SetAddress(<void*>&self.e1JetEtaPhiMoment_value)

        #print "making e1JetEtaPhiSpread"
        self.e1JetEtaPhiSpread_branch = the_tree.GetBranch("e1JetEtaPhiSpread")
        #if not self.e1JetEtaPhiSpread_branch and "e1JetEtaPhiSpread" not in self.complained:
        if not self.e1JetEtaPhiSpread_branch and "e1JetEtaPhiSpread":
            warnings.warn( "EETauTauTree: Expected branch e1JetEtaPhiSpread does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1JetEtaPhiSpread")
        else:
            self.e1JetEtaPhiSpread_branch.SetAddress(<void*>&self.e1JetEtaPhiSpread_value)

        #print "making e1JetPartonFlavour"
        self.e1JetPartonFlavour_branch = the_tree.GetBranch("e1JetPartonFlavour")
        #if not self.e1JetPartonFlavour_branch and "e1JetPartonFlavour" not in self.complained:
        if not self.e1JetPartonFlavour_branch and "e1JetPartonFlavour":
            warnings.warn( "EETauTauTree: Expected branch e1JetPartonFlavour does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1JetPartonFlavour")
        else:
            self.e1JetPartonFlavour_branch.SetAddress(<void*>&self.e1JetPartonFlavour_value)

        #print "making e1JetPhiPhiMoment"
        self.e1JetPhiPhiMoment_branch = the_tree.GetBranch("e1JetPhiPhiMoment")
        #if not self.e1JetPhiPhiMoment_branch and "e1JetPhiPhiMoment" not in self.complained:
        if not self.e1JetPhiPhiMoment_branch and "e1JetPhiPhiMoment":
            warnings.warn( "EETauTauTree: Expected branch e1JetPhiPhiMoment does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1JetPhiPhiMoment")
        else:
            self.e1JetPhiPhiMoment_branch.SetAddress(<void*>&self.e1JetPhiPhiMoment_value)

        #print "making e1JetPt"
        self.e1JetPt_branch = the_tree.GetBranch("e1JetPt")
        #if not self.e1JetPt_branch and "e1JetPt" not in self.complained:
        if not self.e1JetPt_branch and "e1JetPt":
            warnings.warn( "EETauTauTree: Expected branch e1JetPt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1JetPt")
        else:
            self.e1JetPt_branch.SetAddress(<void*>&self.e1JetPt_value)

        #print "making e1JetQGLikelihoodID"
        self.e1JetQGLikelihoodID_branch = the_tree.GetBranch("e1JetQGLikelihoodID")
        #if not self.e1JetQGLikelihoodID_branch and "e1JetQGLikelihoodID" not in self.complained:
        if not self.e1JetQGLikelihoodID_branch and "e1JetQGLikelihoodID":
            warnings.warn( "EETauTauTree: Expected branch e1JetQGLikelihoodID does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1JetQGLikelihoodID")
        else:
            self.e1JetQGLikelihoodID_branch.SetAddress(<void*>&self.e1JetQGLikelihoodID_value)

        #print "making e1JetQGMVAID"
        self.e1JetQGMVAID_branch = the_tree.GetBranch("e1JetQGMVAID")
        #if not self.e1JetQGMVAID_branch and "e1JetQGMVAID" not in self.complained:
        if not self.e1JetQGMVAID_branch and "e1JetQGMVAID":
            warnings.warn( "EETauTauTree: Expected branch e1JetQGMVAID does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1JetQGMVAID")
        else:
            self.e1JetQGMVAID_branch.SetAddress(<void*>&self.e1JetQGMVAID_value)

        #print "making e1Jetaxis1"
        self.e1Jetaxis1_branch = the_tree.GetBranch("e1Jetaxis1")
        #if not self.e1Jetaxis1_branch and "e1Jetaxis1" not in self.complained:
        if not self.e1Jetaxis1_branch and "e1Jetaxis1":
            warnings.warn( "EETauTauTree: Expected branch e1Jetaxis1 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1Jetaxis1")
        else:
            self.e1Jetaxis1_branch.SetAddress(<void*>&self.e1Jetaxis1_value)

        #print "making e1Jetaxis2"
        self.e1Jetaxis2_branch = the_tree.GetBranch("e1Jetaxis2")
        #if not self.e1Jetaxis2_branch and "e1Jetaxis2" not in self.complained:
        if not self.e1Jetaxis2_branch and "e1Jetaxis2":
            warnings.warn( "EETauTauTree: Expected branch e1Jetaxis2 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1Jetaxis2")
        else:
            self.e1Jetaxis2_branch.SetAddress(<void*>&self.e1Jetaxis2_value)

        #print "making e1Jetmult"
        self.e1Jetmult_branch = the_tree.GetBranch("e1Jetmult")
        #if not self.e1Jetmult_branch and "e1Jetmult" not in self.complained:
        if not self.e1Jetmult_branch and "e1Jetmult":
            warnings.warn( "EETauTauTree: Expected branch e1Jetmult does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1Jetmult")
        else:
            self.e1Jetmult_branch.SetAddress(<void*>&self.e1Jetmult_value)

        #print "making e1JetmultMLP"
        self.e1JetmultMLP_branch = the_tree.GetBranch("e1JetmultMLP")
        #if not self.e1JetmultMLP_branch and "e1JetmultMLP" not in self.complained:
        if not self.e1JetmultMLP_branch and "e1JetmultMLP":
            warnings.warn( "EETauTauTree: Expected branch e1JetmultMLP does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1JetmultMLP")
        else:
            self.e1JetmultMLP_branch.SetAddress(<void*>&self.e1JetmultMLP_value)

        #print "making e1JetmultMLPQC"
        self.e1JetmultMLPQC_branch = the_tree.GetBranch("e1JetmultMLPQC")
        #if not self.e1JetmultMLPQC_branch and "e1JetmultMLPQC" not in self.complained:
        if not self.e1JetmultMLPQC_branch and "e1JetmultMLPQC":
            warnings.warn( "EETauTauTree: Expected branch e1JetmultMLPQC does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1JetmultMLPQC")
        else:
            self.e1JetmultMLPQC_branch.SetAddress(<void*>&self.e1JetmultMLPQC_value)

        #print "making e1JetptD"
        self.e1JetptD_branch = the_tree.GetBranch("e1JetptD")
        #if not self.e1JetptD_branch and "e1JetptD" not in self.complained:
        if not self.e1JetptD_branch and "e1JetptD":
            warnings.warn( "EETauTauTree: Expected branch e1JetptD does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1JetptD")
        else:
            self.e1JetptD_branch.SetAddress(<void*>&self.e1JetptD_value)

        #print "making e1L1NonIsoHLTNonIsoMu17Ele8PixelMatchFilter"
        self.e1L1NonIsoHLTNonIsoMu17Ele8PixelMatchFilter_branch = the_tree.GetBranch("e1L1NonIsoHLTNonIsoMu17Ele8PixelMatchFilter")
        #if not self.e1L1NonIsoHLTNonIsoMu17Ele8PixelMatchFilter_branch and "e1L1NonIsoHLTNonIsoMu17Ele8PixelMatchFilter" not in self.complained:
        if not self.e1L1NonIsoHLTNonIsoMu17Ele8PixelMatchFilter_branch and "e1L1NonIsoHLTNonIsoMu17Ele8PixelMatchFilter":
            warnings.warn( "EETauTauTree: Expected branch e1L1NonIsoHLTNonIsoMu17Ele8PixelMatchFilter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1L1NonIsoHLTNonIsoMu17Ele8PixelMatchFilter")
        else:
            self.e1L1NonIsoHLTNonIsoMu17Ele8PixelMatchFilter_branch.SetAddress(<void*>&self.e1L1NonIsoHLTNonIsoMu17Ele8PixelMatchFilter_value)

        #print "making e1MITID"
        self.e1MITID_branch = the_tree.GetBranch("e1MITID")
        #if not self.e1MITID_branch and "e1MITID" not in self.complained:
        if not self.e1MITID_branch and "e1MITID":
            warnings.warn( "EETauTauTree: Expected branch e1MITID does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1MITID")
        else:
            self.e1MITID_branch.SetAddress(<void*>&self.e1MITID_value)

        #print "making e1MVAIDH2TauWP"
        self.e1MVAIDH2TauWP_branch = the_tree.GetBranch("e1MVAIDH2TauWP")
        #if not self.e1MVAIDH2TauWP_branch and "e1MVAIDH2TauWP" not in self.complained:
        if not self.e1MVAIDH2TauWP_branch and "e1MVAIDH2TauWP":
            warnings.warn( "EETauTauTree: Expected branch e1MVAIDH2TauWP does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1MVAIDH2TauWP")
        else:
            self.e1MVAIDH2TauWP_branch.SetAddress(<void*>&self.e1MVAIDH2TauWP_value)

        #print "making e1MVANonTrig"
        self.e1MVANonTrig_branch = the_tree.GetBranch("e1MVANonTrig")
        #if not self.e1MVANonTrig_branch and "e1MVANonTrig" not in self.complained:
        if not self.e1MVANonTrig_branch and "e1MVANonTrig":
            warnings.warn( "EETauTauTree: Expected branch e1MVANonTrig does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1MVANonTrig")
        else:
            self.e1MVANonTrig_branch.SetAddress(<void*>&self.e1MVANonTrig_value)

        #print "making e1MVATrig"
        self.e1MVATrig_branch = the_tree.GetBranch("e1MVATrig")
        #if not self.e1MVATrig_branch and "e1MVATrig" not in self.complained:
        if not self.e1MVATrig_branch and "e1MVATrig":
            warnings.warn( "EETauTauTree: Expected branch e1MVATrig does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1MVATrig")
        else:
            self.e1MVATrig_branch.SetAddress(<void*>&self.e1MVATrig_value)

        #print "making e1MVATrigIDISO"
        self.e1MVATrigIDISO_branch = the_tree.GetBranch("e1MVATrigIDISO")
        #if not self.e1MVATrigIDISO_branch and "e1MVATrigIDISO" not in self.complained:
        if not self.e1MVATrigIDISO_branch and "e1MVATrigIDISO":
            warnings.warn( "EETauTauTree: Expected branch e1MVATrigIDISO does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1MVATrigIDISO")
        else:
            self.e1MVATrigIDISO_branch.SetAddress(<void*>&self.e1MVATrigIDISO_value)

        #print "making e1MVATrigIDISOPUSUB"
        self.e1MVATrigIDISOPUSUB_branch = the_tree.GetBranch("e1MVATrigIDISOPUSUB")
        #if not self.e1MVATrigIDISOPUSUB_branch and "e1MVATrigIDISOPUSUB" not in self.complained:
        if not self.e1MVATrigIDISOPUSUB_branch and "e1MVATrigIDISOPUSUB":
            warnings.warn( "EETauTauTree: Expected branch e1MVATrigIDISOPUSUB does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1MVATrigIDISOPUSUB")
        else:
            self.e1MVATrigIDISOPUSUB_branch.SetAddress(<void*>&self.e1MVATrigIDISOPUSUB_value)

        #print "making e1MVATrigNoIP"
        self.e1MVATrigNoIP_branch = the_tree.GetBranch("e1MVATrigNoIP")
        #if not self.e1MVATrigNoIP_branch and "e1MVATrigNoIP" not in self.complained:
        if not self.e1MVATrigNoIP_branch and "e1MVATrigNoIP":
            warnings.warn( "EETauTauTree: Expected branch e1MVATrigNoIP does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1MVATrigNoIP")
        else:
            self.e1MVATrigNoIP_branch.SetAddress(<void*>&self.e1MVATrigNoIP_value)

        #print "making e1Mass"
        self.e1Mass_branch = the_tree.GetBranch("e1Mass")
        #if not self.e1Mass_branch and "e1Mass" not in self.complained:
        if not self.e1Mass_branch and "e1Mass":
            warnings.warn( "EETauTauTree: Expected branch e1Mass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1Mass")
        else:
            self.e1Mass_branch.SetAddress(<void*>&self.e1Mass_value)

        #print "making e1MatchesDoubleEPath"
        self.e1MatchesDoubleEPath_branch = the_tree.GetBranch("e1MatchesDoubleEPath")
        #if not self.e1MatchesDoubleEPath_branch and "e1MatchesDoubleEPath" not in self.complained:
        if not self.e1MatchesDoubleEPath_branch and "e1MatchesDoubleEPath":
            warnings.warn( "EETauTauTree: Expected branch e1MatchesDoubleEPath does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1MatchesDoubleEPath")
        else:
            self.e1MatchesDoubleEPath_branch.SetAddress(<void*>&self.e1MatchesDoubleEPath_value)

        #print "making e1MatchesMu17Ele8IsoPath"
        self.e1MatchesMu17Ele8IsoPath_branch = the_tree.GetBranch("e1MatchesMu17Ele8IsoPath")
        #if not self.e1MatchesMu17Ele8IsoPath_branch and "e1MatchesMu17Ele8IsoPath" not in self.complained:
        if not self.e1MatchesMu17Ele8IsoPath_branch and "e1MatchesMu17Ele8IsoPath":
            warnings.warn( "EETauTauTree: Expected branch e1MatchesMu17Ele8IsoPath does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1MatchesMu17Ele8IsoPath")
        else:
            self.e1MatchesMu17Ele8IsoPath_branch.SetAddress(<void*>&self.e1MatchesMu17Ele8IsoPath_value)

        #print "making e1MatchesMu17Ele8Path"
        self.e1MatchesMu17Ele8Path_branch = the_tree.GetBranch("e1MatchesMu17Ele8Path")
        #if not self.e1MatchesMu17Ele8Path_branch and "e1MatchesMu17Ele8Path" not in self.complained:
        if not self.e1MatchesMu17Ele8Path_branch and "e1MatchesMu17Ele8Path":
            warnings.warn( "EETauTauTree: Expected branch e1MatchesMu17Ele8Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1MatchesMu17Ele8Path")
        else:
            self.e1MatchesMu17Ele8Path_branch.SetAddress(<void*>&self.e1MatchesMu17Ele8Path_value)

        #print "making e1MatchesMu8Ele17IsoPath"
        self.e1MatchesMu8Ele17IsoPath_branch = the_tree.GetBranch("e1MatchesMu8Ele17IsoPath")
        #if not self.e1MatchesMu8Ele17IsoPath_branch and "e1MatchesMu8Ele17IsoPath" not in self.complained:
        if not self.e1MatchesMu8Ele17IsoPath_branch and "e1MatchesMu8Ele17IsoPath":
            warnings.warn( "EETauTauTree: Expected branch e1MatchesMu8Ele17IsoPath does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1MatchesMu8Ele17IsoPath")
        else:
            self.e1MatchesMu8Ele17IsoPath_branch.SetAddress(<void*>&self.e1MatchesMu8Ele17IsoPath_value)

        #print "making e1MatchesMu8Ele17Path"
        self.e1MatchesMu8Ele17Path_branch = the_tree.GetBranch("e1MatchesMu8Ele17Path")
        #if not self.e1MatchesMu8Ele17Path_branch and "e1MatchesMu8Ele17Path" not in self.complained:
        if not self.e1MatchesMu8Ele17Path_branch and "e1MatchesMu8Ele17Path":
            warnings.warn( "EETauTauTree: Expected branch e1MatchesMu8Ele17Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1MatchesMu8Ele17Path")
        else:
            self.e1MatchesMu8Ele17Path_branch.SetAddress(<void*>&self.e1MatchesMu8Ele17Path_value)

        #print "making e1MatchesSingleE"
        self.e1MatchesSingleE_branch = the_tree.GetBranch("e1MatchesSingleE")
        #if not self.e1MatchesSingleE_branch and "e1MatchesSingleE" not in self.complained:
        if not self.e1MatchesSingleE_branch and "e1MatchesSingleE":
            warnings.warn( "EETauTauTree: Expected branch e1MatchesSingleE does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1MatchesSingleE")
        else:
            self.e1MatchesSingleE_branch.SetAddress(<void*>&self.e1MatchesSingleE_value)

        #print "making e1MatchesSingleEPlusMET"
        self.e1MatchesSingleEPlusMET_branch = the_tree.GetBranch("e1MatchesSingleEPlusMET")
        #if not self.e1MatchesSingleEPlusMET_branch and "e1MatchesSingleEPlusMET" not in self.complained:
        if not self.e1MatchesSingleEPlusMET_branch and "e1MatchesSingleEPlusMET":
            warnings.warn( "EETauTauTree: Expected branch e1MatchesSingleEPlusMET does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1MatchesSingleEPlusMET")
        else:
            self.e1MatchesSingleEPlusMET_branch.SetAddress(<void*>&self.e1MatchesSingleEPlusMET_value)

        #print "making e1MissingHits"
        self.e1MissingHits_branch = the_tree.GetBranch("e1MissingHits")
        #if not self.e1MissingHits_branch and "e1MissingHits" not in self.complained:
        if not self.e1MissingHits_branch and "e1MissingHits":
            warnings.warn( "EETauTauTree: Expected branch e1MissingHits does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1MissingHits")
        else:
            self.e1MissingHits_branch.SetAddress(<void*>&self.e1MissingHits_value)

        #print "making e1MtToMET"
        self.e1MtToMET_branch = the_tree.GetBranch("e1MtToMET")
        #if not self.e1MtToMET_branch and "e1MtToMET" not in self.complained:
        if not self.e1MtToMET_branch and "e1MtToMET":
            warnings.warn( "EETauTauTree: Expected branch e1MtToMET does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1MtToMET")
        else:
            self.e1MtToMET_branch.SetAddress(<void*>&self.e1MtToMET_value)

        #print "making e1MtToMVAMET"
        self.e1MtToMVAMET_branch = the_tree.GetBranch("e1MtToMVAMET")
        #if not self.e1MtToMVAMET_branch and "e1MtToMVAMET" not in self.complained:
        if not self.e1MtToMVAMET_branch and "e1MtToMVAMET":
            warnings.warn( "EETauTauTree: Expected branch e1MtToMVAMET does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1MtToMVAMET")
        else:
            self.e1MtToMVAMET_branch.SetAddress(<void*>&self.e1MtToMVAMET_value)

        #print "making e1MtToPFMET"
        self.e1MtToPFMET_branch = the_tree.GetBranch("e1MtToPFMET")
        #if not self.e1MtToPFMET_branch and "e1MtToPFMET" not in self.complained:
        if not self.e1MtToPFMET_branch and "e1MtToPFMET":
            warnings.warn( "EETauTauTree: Expected branch e1MtToPFMET does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1MtToPFMET")
        else:
            self.e1MtToPFMET_branch.SetAddress(<void*>&self.e1MtToPFMET_value)

        #print "making e1MtToPfMet_Ty1"
        self.e1MtToPfMet_Ty1_branch = the_tree.GetBranch("e1MtToPfMet_Ty1")
        #if not self.e1MtToPfMet_Ty1_branch and "e1MtToPfMet_Ty1" not in self.complained:
        if not self.e1MtToPfMet_Ty1_branch and "e1MtToPfMet_Ty1":
            warnings.warn( "EETauTauTree: Expected branch e1MtToPfMet_Ty1 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1MtToPfMet_Ty1")
        else:
            self.e1MtToPfMet_Ty1_branch.SetAddress(<void*>&self.e1MtToPfMet_Ty1_value)

        #print "making e1MtToPfMet_jes"
        self.e1MtToPfMet_jes_branch = the_tree.GetBranch("e1MtToPfMet_jes")
        #if not self.e1MtToPfMet_jes_branch and "e1MtToPfMet_jes" not in self.complained:
        if not self.e1MtToPfMet_jes_branch and "e1MtToPfMet_jes":
            warnings.warn( "EETauTauTree: Expected branch e1MtToPfMet_jes does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1MtToPfMet_jes")
        else:
            self.e1MtToPfMet_jes_branch.SetAddress(<void*>&self.e1MtToPfMet_jes_value)

        #print "making e1MtToPfMet_mes"
        self.e1MtToPfMet_mes_branch = the_tree.GetBranch("e1MtToPfMet_mes")
        #if not self.e1MtToPfMet_mes_branch and "e1MtToPfMet_mes" not in self.complained:
        if not self.e1MtToPfMet_mes_branch and "e1MtToPfMet_mes":
            warnings.warn( "EETauTauTree: Expected branch e1MtToPfMet_mes does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1MtToPfMet_mes")
        else:
            self.e1MtToPfMet_mes_branch.SetAddress(<void*>&self.e1MtToPfMet_mes_value)

        #print "making e1MtToPfMet_tes"
        self.e1MtToPfMet_tes_branch = the_tree.GetBranch("e1MtToPfMet_tes")
        #if not self.e1MtToPfMet_tes_branch and "e1MtToPfMet_tes" not in self.complained:
        if not self.e1MtToPfMet_tes_branch and "e1MtToPfMet_tes":
            warnings.warn( "EETauTauTree: Expected branch e1MtToPfMet_tes does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1MtToPfMet_tes")
        else:
            self.e1MtToPfMet_tes_branch.SetAddress(<void*>&self.e1MtToPfMet_tes_value)

        #print "making e1MtToPfMet_ues"
        self.e1MtToPfMet_ues_branch = the_tree.GetBranch("e1MtToPfMet_ues")
        #if not self.e1MtToPfMet_ues_branch and "e1MtToPfMet_ues" not in self.complained:
        if not self.e1MtToPfMet_ues_branch and "e1MtToPfMet_ues":
            warnings.warn( "EETauTauTree: Expected branch e1MtToPfMet_ues does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1MtToPfMet_ues")
        else:
            self.e1MtToPfMet_ues_branch.SetAddress(<void*>&self.e1MtToPfMet_ues_value)

        #print "making e1Mu17Ele8CaloIdTCaloIsoVLTrkIdVLTrkIsoVLTrackIsoFilter"
        self.e1Mu17Ele8CaloIdTCaloIsoVLTrkIdVLTrkIsoVLTrackIsoFilter_branch = the_tree.GetBranch("e1Mu17Ele8CaloIdTCaloIsoVLTrkIdVLTrkIsoVLTrackIsoFilter")
        #if not self.e1Mu17Ele8CaloIdTCaloIsoVLTrkIdVLTrkIsoVLTrackIsoFilter_branch and "e1Mu17Ele8CaloIdTCaloIsoVLTrkIdVLTrkIsoVLTrackIsoFilter" not in self.complained:
        if not self.e1Mu17Ele8CaloIdTCaloIsoVLTrkIdVLTrkIsoVLTrackIsoFilter_branch and "e1Mu17Ele8CaloIdTCaloIsoVLTrkIdVLTrkIsoVLTrackIsoFilter":
            warnings.warn( "EETauTauTree: Expected branch e1Mu17Ele8CaloIdTCaloIsoVLTrkIdVLTrkIsoVLTrackIsoFilter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1Mu17Ele8CaloIdTCaloIsoVLTrkIdVLTrkIsoVLTrackIsoFilter")
        else:
            self.e1Mu17Ele8CaloIdTCaloIsoVLTrkIdVLTrkIsoVLTrackIsoFilter_branch.SetAddress(<void*>&self.e1Mu17Ele8CaloIdTCaloIsoVLTrkIdVLTrkIsoVLTrackIsoFilter_value)

        #print "making e1Mu17Ele8CaloIdTPixelMatchFilter"
        self.e1Mu17Ele8CaloIdTPixelMatchFilter_branch = the_tree.GetBranch("e1Mu17Ele8CaloIdTPixelMatchFilter")
        #if not self.e1Mu17Ele8CaloIdTPixelMatchFilter_branch and "e1Mu17Ele8CaloIdTPixelMatchFilter" not in self.complained:
        if not self.e1Mu17Ele8CaloIdTPixelMatchFilter_branch and "e1Mu17Ele8CaloIdTPixelMatchFilter":
            warnings.warn( "EETauTauTree: Expected branch e1Mu17Ele8CaloIdTPixelMatchFilter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1Mu17Ele8CaloIdTPixelMatchFilter")
        else:
            self.e1Mu17Ele8CaloIdTPixelMatchFilter_branch.SetAddress(<void*>&self.e1Mu17Ele8CaloIdTPixelMatchFilter_value)

        #print "making e1Mu17Ele8dZFilter"
        self.e1Mu17Ele8dZFilter_branch = the_tree.GetBranch("e1Mu17Ele8dZFilter")
        #if not self.e1Mu17Ele8dZFilter_branch and "e1Mu17Ele8dZFilter" not in self.complained:
        if not self.e1Mu17Ele8dZFilter_branch and "e1Mu17Ele8dZFilter":
            warnings.warn( "EETauTauTree: Expected branch e1Mu17Ele8dZFilter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1Mu17Ele8dZFilter")
        else:
            self.e1Mu17Ele8dZFilter_branch.SetAddress(<void*>&self.e1Mu17Ele8dZFilter_value)

        #print "making e1MuOverlap"
        self.e1MuOverlap_branch = the_tree.GetBranch("e1MuOverlap")
        #if not self.e1MuOverlap_branch and "e1MuOverlap" not in self.complained:
        if not self.e1MuOverlap_branch and "e1MuOverlap":
            warnings.warn( "EETauTauTree: Expected branch e1MuOverlap does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1MuOverlap")
        else:
            self.e1MuOverlap_branch.SetAddress(<void*>&self.e1MuOverlap_value)

        #print "making e1MuOverlapZHLoose"
        self.e1MuOverlapZHLoose_branch = the_tree.GetBranch("e1MuOverlapZHLoose")
        #if not self.e1MuOverlapZHLoose_branch and "e1MuOverlapZHLoose" not in self.complained:
        if not self.e1MuOverlapZHLoose_branch and "e1MuOverlapZHLoose":
            warnings.warn( "EETauTauTree: Expected branch e1MuOverlapZHLoose does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1MuOverlapZHLoose")
        else:
            self.e1MuOverlapZHLoose_branch.SetAddress(<void*>&self.e1MuOverlapZHLoose_value)

        #print "making e1MuOverlapZHTight"
        self.e1MuOverlapZHTight_branch = the_tree.GetBranch("e1MuOverlapZHTight")
        #if not self.e1MuOverlapZHTight_branch and "e1MuOverlapZHTight" not in self.complained:
        if not self.e1MuOverlapZHTight_branch and "e1MuOverlapZHTight":
            warnings.warn( "EETauTauTree: Expected branch e1MuOverlapZHTight does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1MuOverlapZHTight")
        else:
            self.e1MuOverlapZHTight_branch.SetAddress(<void*>&self.e1MuOverlapZHTight_value)

        #print "making e1NearMuonVeto"
        self.e1NearMuonVeto_branch = the_tree.GetBranch("e1NearMuonVeto")
        #if not self.e1NearMuonVeto_branch and "e1NearMuonVeto" not in self.complained:
        if not self.e1NearMuonVeto_branch and "e1NearMuonVeto":
            warnings.warn( "EETauTauTree: Expected branch e1NearMuonVeto does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1NearMuonVeto")
        else:
            self.e1NearMuonVeto_branch.SetAddress(<void*>&self.e1NearMuonVeto_value)

        #print "making e1PFChargedIso"
        self.e1PFChargedIso_branch = the_tree.GetBranch("e1PFChargedIso")
        #if not self.e1PFChargedIso_branch and "e1PFChargedIso" not in self.complained:
        if not self.e1PFChargedIso_branch and "e1PFChargedIso":
            warnings.warn( "EETauTauTree: Expected branch e1PFChargedIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1PFChargedIso")
        else:
            self.e1PFChargedIso_branch.SetAddress(<void*>&self.e1PFChargedIso_value)

        #print "making e1PFNeutralIso"
        self.e1PFNeutralIso_branch = the_tree.GetBranch("e1PFNeutralIso")
        #if not self.e1PFNeutralIso_branch and "e1PFNeutralIso" not in self.complained:
        if not self.e1PFNeutralIso_branch and "e1PFNeutralIso":
            warnings.warn( "EETauTauTree: Expected branch e1PFNeutralIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1PFNeutralIso")
        else:
            self.e1PFNeutralIso_branch.SetAddress(<void*>&self.e1PFNeutralIso_value)

        #print "making e1PFPhotonIso"
        self.e1PFPhotonIso_branch = the_tree.GetBranch("e1PFPhotonIso")
        #if not self.e1PFPhotonIso_branch and "e1PFPhotonIso" not in self.complained:
        if not self.e1PFPhotonIso_branch and "e1PFPhotonIso":
            warnings.warn( "EETauTauTree: Expected branch e1PFPhotonIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1PFPhotonIso")
        else:
            self.e1PFPhotonIso_branch.SetAddress(<void*>&self.e1PFPhotonIso_value)

        #print "making e1PVDXY"
        self.e1PVDXY_branch = the_tree.GetBranch("e1PVDXY")
        #if not self.e1PVDXY_branch and "e1PVDXY" not in self.complained:
        if not self.e1PVDXY_branch and "e1PVDXY":
            warnings.warn( "EETauTauTree: Expected branch e1PVDXY does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1PVDXY")
        else:
            self.e1PVDXY_branch.SetAddress(<void*>&self.e1PVDXY_value)

        #print "making e1PVDZ"
        self.e1PVDZ_branch = the_tree.GetBranch("e1PVDZ")
        #if not self.e1PVDZ_branch and "e1PVDZ" not in self.complained:
        if not self.e1PVDZ_branch and "e1PVDZ":
            warnings.warn( "EETauTauTree: Expected branch e1PVDZ does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1PVDZ")
        else:
            self.e1PVDZ_branch.SetAddress(<void*>&self.e1PVDZ_value)

        #print "making e1Phi"
        self.e1Phi_branch = the_tree.GetBranch("e1Phi")
        #if not self.e1Phi_branch and "e1Phi" not in self.complained:
        if not self.e1Phi_branch and "e1Phi":
            warnings.warn( "EETauTauTree: Expected branch e1Phi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1Phi")
        else:
            self.e1Phi_branch.SetAddress(<void*>&self.e1Phi_value)

        #print "making e1PhiCorrReg_2012Jul13ReReco"
        self.e1PhiCorrReg_2012Jul13ReReco_branch = the_tree.GetBranch("e1PhiCorrReg_2012Jul13ReReco")
        #if not self.e1PhiCorrReg_2012Jul13ReReco_branch and "e1PhiCorrReg_2012Jul13ReReco" not in self.complained:
        if not self.e1PhiCorrReg_2012Jul13ReReco_branch and "e1PhiCorrReg_2012Jul13ReReco":
            warnings.warn( "EETauTauTree: Expected branch e1PhiCorrReg_2012Jul13ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1PhiCorrReg_2012Jul13ReReco")
        else:
            self.e1PhiCorrReg_2012Jul13ReReco_branch.SetAddress(<void*>&self.e1PhiCorrReg_2012Jul13ReReco_value)

        #print "making e1PhiCorrReg_Fall11"
        self.e1PhiCorrReg_Fall11_branch = the_tree.GetBranch("e1PhiCorrReg_Fall11")
        #if not self.e1PhiCorrReg_Fall11_branch and "e1PhiCorrReg_Fall11" not in self.complained:
        if not self.e1PhiCorrReg_Fall11_branch and "e1PhiCorrReg_Fall11":
            warnings.warn( "EETauTauTree: Expected branch e1PhiCorrReg_Fall11 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1PhiCorrReg_Fall11")
        else:
            self.e1PhiCorrReg_Fall11_branch.SetAddress(<void*>&self.e1PhiCorrReg_Fall11_value)

        #print "making e1PhiCorrReg_Jan16ReReco"
        self.e1PhiCorrReg_Jan16ReReco_branch = the_tree.GetBranch("e1PhiCorrReg_Jan16ReReco")
        #if not self.e1PhiCorrReg_Jan16ReReco_branch and "e1PhiCorrReg_Jan16ReReco" not in self.complained:
        if not self.e1PhiCorrReg_Jan16ReReco_branch and "e1PhiCorrReg_Jan16ReReco":
            warnings.warn( "EETauTauTree: Expected branch e1PhiCorrReg_Jan16ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1PhiCorrReg_Jan16ReReco")
        else:
            self.e1PhiCorrReg_Jan16ReReco_branch.SetAddress(<void*>&self.e1PhiCorrReg_Jan16ReReco_value)

        #print "making e1PhiCorrReg_Summer12_DR53X_HCP2012"
        self.e1PhiCorrReg_Summer12_DR53X_HCP2012_branch = the_tree.GetBranch("e1PhiCorrReg_Summer12_DR53X_HCP2012")
        #if not self.e1PhiCorrReg_Summer12_DR53X_HCP2012_branch and "e1PhiCorrReg_Summer12_DR53X_HCP2012" not in self.complained:
        if not self.e1PhiCorrReg_Summer12_DR53X_HCP2012_branch and "e1PhiCorrReg_Summer12_DR53X_HCP2012":
            warnings.warn( "EETauTauTree: Expected branch e1PhiCorrReg_Summer12_DR53X_HCP2012 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1PhiCorrReg_Summer12_DR53X_HCP2012")
        else:
            self.e1PhiCorrReg_Summer12_DR53X_HCP2012_branch.SetAddress(<void*>&self.e1PhiCorrReg_Summer12_DR53X_HCP2012_value)

        #print "making e1PhiCorrSmearedNoReg_2012Jul13ReReco"
        self.e1PhiCorrSmearedNoReg_2012Jul13ReReco_branch = the_tree.GetBranch("e1PhiCorrSmearedNoReg_2012Jul13ReReco")
        #if not self.e1PhiCorrSmearedNoReg_2012Jul13ReReco_branch and "e1PhiCorrSmearedNoReg_2012Jul13ReReco" not in self.complained:
        if not self.e1PhiCorrSmearedNoReg_2012Jul13ReReco_branch and "e1PhiCorrSmearedNoReg_2012Jul13ReReco":
            warnings.warn( "EETauTauTree: Expected branch e1PhiCorrSmearedNoReg_2012Jul13ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1PhiCorrSmearedNoReg_2012Jul13ReReco")
        else:
            self.e1PhiCorrSmearedNoReg_2012Jul13ReReco_branch.SetAddress(<void*>&self.e1PhiCorrSmearedNoReg_2012Jul13ReReco_value)

        #print "making e1PhiCorrSmearedNoReg_Fall11"
        self.e1PhiCorrSmearedNoReg_Fall11_branch = the_tree.GetBranch("e1PhiCorrSmearedNoReg_Fall11")
        #if not self.e1PhiCorrSmearedNoReg_Fall11_branch and "e1PhiCorrSmearedNoReg_Fall11" not in self.complained:
        if not self.e1PhiCorrSmearedNoReg_Fall11_branch and "e1PhiCorrSmearedNoReg_Fall11":
            warnings.warn( "EETauTauTree: Expected branch e1PhiCorrSmearedNoReg_Fall11 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1PhiCorrSmearedNoReg_Fall11")
        else:
            self.e1PhiCorrSmearedNoReg_Fall11_branch.SetAddress(<void*>&self.e1PhiCorrSmearedNoReg_Fall11_value)

        #print "making e1PhiCorrSmearedNoReg_Jan16ReReco"
        self.e1PhiCorrSmearedNoReg_Jan16ReReco_branch = the_tree.GetBranch("e1PhiCorrSmearedNoReg_Jan16ReReco")
        #if not self.e1PhiCorrSmearedNoReg_Jan16ReReco_branch and "e1PhiCorrSmearedNoReg_Jan16ReReco" not in self.complained:
        if not self.e1PhiCorrSmearedNoReg_Jan16ReReco_branch and "e1PhiCorrSmearedNoReg_Jan16ReReco":
            warnings.warn( "EETauTauTree: Expected branch e1PhiCorrSmearedNoReg_Jan16ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1PhiCorrSmearedNoReg_Jan16ReReco")
        else:
            self.e1PhiCorrSmearedNoReg_Jan16ReReco_branch.SetAddress(<void*>&self.e1PhiCorrSmearedNoReg_Jan16ReReco_value)

        #print "making e1PhiCorrSmearedNoReg_Summer12_DR53X_HCP2012"
        self.e1PhiCorrSmearedNoReg_Summer12_DR53X_HCP2012_branch = the_tree.GetBranch("e1PhiCorrSmearedNoReg_Summer12_DR53X_HCP2012")
        #if not self.e1PhiCorrSmearedNoReg_Summer12_DR53X_HCP2012_branch and "e1PhiCorrSmearedNoReg_Summer12_DR53X_HCP2012" not in self.complained:
        if not self.e1PhiCorrSmearedNoReg_Summer12_DR53X_HCP2012_branch and "e1PhiCorrSmearedNoReg_Summer12_DR53X_HCP2012":
            warnings.warn( "EETauTauTree: Expected branch e1PhiCorrSmearedNoReg_Summer12_DR53X_HCP2012 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1PhiCorrSmearedNoReg_Summer12_DR53X_HCP2012")
        else:
            self.e1PhiCorrSmearedNoReg_Summer12_DR53X_HCP2012_branch.SetAddress(<void*>&self.e1PhiCorrSmearedNoReg_Summer12_DR53X_HCP2012_value)

        #print "making e1PhiCorrSmearedReg_2012Jul13ReReco"
        self.e1PhiCorrSmearedReg_2012Jul13ReReco_branch = the_tree.GetBranch("e1PhiCorrSmearedReg_2012Jul13ReReco")
        #if not self.e1PhiCorrSmearedReg_2012Jul13ReReco_branch and "e1PhiCorrSmearedReg_2012Jul13ReReco" not in self.complained:
        if not self.e1PhiCorrSmearedReg_2012Jul13ReReco_branch and "e1PhiCorrSmearedReg_2012Jul13ReReco":
            warnings.warn( "EETauTauTree: Expected branch e1PhiCorrSmearedReg_2012Jul13ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1PhiCorrSmearedReg_2012Jul13ReReco")
        else:
            self.e1PhiCorrSmearedReg_2012Jul13ReReco_branch.SetAddress(<void*>&self.e1PhiCorrSmearedReg_2012Jul13ReReco_value)

        #print "making e1PhiCorrSmearedReg_Fall11"
        self.e1PhiCorrSmearedReg_Fall11_branch = the_tree.GetBranch("e1PhiCorrSmearedReg_Fall11")
        #if not self.e1PhiCorrSmearedReg_Fall11_branch and "e1PhiCorrSmearedReg_Fall11" not in self.complained:
        if not self.e1PhiCorrSmearedReg_Fall11_branch and "e1PhiCorrSmearedReg_Fall11":
            warnings.warn( "EETauTauTree: Expected branch e1PhiCorrSmearedReg_Fall11 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1PhiCorrSmearedReg_Fall11")
        else:
            self.e1PhiCorrSmearedReg_Fall11_branch.SetAddress(<void*>&self.e1PhiCorrSmearedReg_Fall11_value)

        #print "making e1PhiCorrSmearedReg_Jan16ReReco"
        self.e1PhiCorrSmearedReg_Jan16ReReco_branch = the_tree.GetBranch("e1PhiCorrSmearedReg_Jan16ReReco")
        #if not self.e1PhiCorrSmearedReg_Jan16ReReco_branch and "e1PhiCorrSmearedReg_Jan16ReReco" not in self.complained:
        if not self.e1PhiCorrSmearedReg_Jan16ReReco_branch and "e1PhiCorrSmearedReg_Jan16ReReco":
            warnings.warn( "EETauTauTree: Expected branch e1PhiCorrSmearedReg_Jan16ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1PhiCorrSmearedReg_Jan16ReReco")
        else:
            self.e1PhiCorrSmearedReg_Jan16ReReco_branch.SetAddress(<void*>&self.e1PhiCorrSmearedReg_Jan16ReReco_value)

        #print "making e1PhiCorrSmearedReg_Summer12_DR53X_HCP2012"
        self.e1PhiCorrSmearedReg_Summer12_DR53X_HCP2012_branch = the_tree.GetBranch("e1PhiCorrSmearedReg_Summer12_DR53X_HCP2012")
        #if not self.e1PhiCorrSmearedReg_Summer12_DR53X_HCP2012_branch and "e1PhiCorrSmearedReg_Summer12_DR53X_HCP2012" not in self.complained:
        if not self.e1PhiCorrSmearedReg_Summer12_DR53X_HCP2012_branch and "e1PhiCorrSmearedReg_Summer12_DR53X_HCP2012":
            warnings.warn( "EETauTauTree: Expected branch e1PhiCorrSmearedReg_Summer12_DR53X_HCP2012 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1PhiCorrSmearedReg_Summer12_DR53X_HCP2012")
        else:
            self.e1PhiCorrSmearedReg_Summer12_DR53X_HCP2012_branch.SetAddress(<void*>&self.e1PhiCorrSmearedReg_Summer12_DR53X_HCP2012_value)

        #print "making e1Pt"
        self.e1Pt_branch = the_tree.GetBranch("e1Pt")
        #if not self.e1Pt_branch and "e1Pt" not in self.complained:
        if not self.e1Pt_branch and "e1Pt":
            warnings.warn( "EETauTauTree: Expected branch e1Pt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1Pt")
        else:
            self.e1Pt_branch.SetAddress(<void*>&self.e1Pt_value)

        #print "making e1PtCorrReg_2012Jul13ReReco"
        self.e1PtCorrReg_2012Jul13ReReco_branch = the_tree.GetBranch("e1PtCorrReg_2012Jul13ReReco")
        #if not self.e1PtCorrReg_2012Jul13ReReco_branch and "e1PtCorrReg_2012Jul13ReReco" not in self.complained:
        if not self.e1PtCorrReg_2012Jul13ReReco_branch and "e1PtCorrReg_2012Jul13ReReco":
            warnings.warn( "EETauTauTree: Expected branch e1PtCorrReg_2012Jul13ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1PtCorrReg_2012Jul13ReReco")
        else:
            self.e1PtCorrReg_2012Jul13ReReco_branch.SetAddress(<void*>&self.e1PtCorrReg_2012Jul13ReReco_value)

        #print "making e1PtCorrReg_Fall11"
        self.e1PtCorrReg_Fall11_branch = the_tree.GetBranch("e1PtCorrReg_Fall11")
        #if not self.e1PtCorrReg_Fall11_branch and "e1PtCorrReg_Fall11" not in self.complained:
        if not self.e1PtCorrReg_Fall11_branch and "e1PtCorrReg_Fall11":
            warnings.warn( "EETauTauTree: Expected branch e1PtCorrReg_Fall11 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1PtCorrReg_Fall11")
        else:
            self.e1PtCorrReg_Fall11_branch.SetAddress(<void*>&self.e1PtCorrReg_Fall11_value)

        #print "making e1PtCorrReg_Jan16ReReco"
        self.e1PtCorrReg_Jan16ReReco_branch = the_tree.GetBranch("e1PtCorrReg_Jan16ReReco")
        #if not self.e1PtCorrReg_Jan16ReReco_branch and "e1PtCorrReg_Jan16ReReco" not in self.complained:
        if not self.e1PtCorrReg_Jan16ReReco_branch and "e1PtCorrReg_Jan16ReReco":
            warnings.warn( "EETauTauTree: Expected branch e1PtCorrReg_Jan16ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1PtCorrReg_Jan16ReReco")
        else:
            self.e1PtCorrReg_Jan16ReReco_branch.SetAddress(<void*>&self.e1PtCorrReg_Jan16ReReco_value)

        #print "making e1PtCorrReg_Summer12_DR53X_HCP2012"
        self.e1PtCorrReg_Summer12_DR53X_HCP2012_branch = the_tree.GetBranch("e1PtCorrReg_Summer12_DR53X_HCP2012")
        #if not self.e1PtCorrReg_Summer12_DR53X_HCP2012_branch and "e1PtCorrReg_Summer12_DR53X_HCP2012" not in self.complained:
        if not self.e1PtCorrReg_Summer12_DR53X_HCP2012_branch and "e1PtCorrReg_Summer12_DR53X_HCP2012":
            warnings.warn( "EETauTauTree: Expected branch e1PtCorrReg_Summer12_DR53X_HCP2012 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1PtCorrReg_Summer12_DR53X_HCP2012")
        else:
            self.e1PtCorrReg_Summer12_DR53X_HCP2012_branch.SetAddress(<void*>&self.e1PtCorrReg_Summer12_DR53X_HCP2012_value)

        #print "making e1PtCorrSmearedNoReg_2012Jul13ReReco"
        self.e1PtCorrSmearedNoReg_2012Jul13ReReco_branch = the_tree.GetBranch("e1PtCorrSmearedNoReg_2012Jul13ReReco")
        #if not self.e1PtCorrSmearedNoReg_2012Jul13ReReco_branch and "e1PtCorrSmearedNoReg_2012Jul13ReReco" not in self.complained:
        if not self.e1PtCorrSmearedNoReg_2012Jul13ReReco_branch and "e1PtCorrSmearedNoReg_2012Jul13ReReco":
            warnings.warn( "EETauTauTree: Expected branch e1PtCorrSmearedNoReg_2012Jul13ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1PtCorrSmearedNoReg_2012Jul13ReReco")
        else:
            self.e1PtCorrSmearedNoReg_2012Jul13ReReco_branch.SetAddress(<void*>&self.e1PtCorrSmearedNoReg_2012Jul13ReReco_value)

        #print "making e1PtCorrSmearedNoReg_Fall11"
        self.e1PtCorrSmearedNoReg_Fall11_branch = the_tree.GetBranch("e1PtCorrSmearedNoReg_Fall11")
        #if not self.e1PtCorrSmearedNoReg_Fall11_branch and "e1PtCorrSmearedNoReg_Fall11" not in self.complained:
        if not self.e1PtCorrSmearedNoReg_Fall11_branch and "e1PtCorrSmearedNoReg_Fall11":
            warnings.warn( "EETauTauTree: Expected branch e1PtCorrSmearedNoReg_Fall11 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1PtCorrSmearedNoReg_Fall11")
        else:
            self.e1PtCorrSmearedNoReg_Fall11_branch.SetAddress(<void*>&self.e1PtCorrSmearedNoReg_Fall11_value)

        #print "making e1PtCorrSmearedNoReg_Jan16ReReco"
        self.e1PtCorrSmearedNoReg_Jan16ReReco_branch = the_tree.GetBranch("e1PtCorrSmearedNoReg_Jan16ReReco")
        #if not self.e1PtCorrSmearedNoReg_Jan16ReReco_branch and "e1PtCorrSmearedNoReg_Jan16ReReco" not in self.complained:
        if not self.e1PtCorrSmearedNoReg_Jan16ReReco_branch and "e1PtCorrSmearedNoReg_Jan16ReReco":
            warnings.warn( "EETauTauTree: Expected branch e1PtCorrSmearedNoReg_Jan16ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1PtCorrSmearedNoReg_Jan16ReReco")
        else:
            self.e1PtCorrSmearedNoReg_Jan16ReReco_branch.SetAddress(<void*>&self.e1PtCorrSmearedNoReg_Jan16ReReco_value)

        #print "making e1PtCorrSmearedNoReg_Summer12_DR53X_HCP2012"
        self.e1PtCorrSmearedNoReg_Summer12_DR53X_HCP2012_branch = the_tree.GetBranch("e1PtCorrSmearedNoReg_Summer12_DR53X_HCP2012")
        #if not self.e1PtCorrSmearedNoReg_Summer12_DR53X_HCP2012_branch and "e1PtCorrSmearedNoReg_Summer12_DR53X_HCP2012" not in self.complained:
        if not self.e1PtCorrSmearedNoReg_Summer12_DR53X_HCP2012_branch and "e1PtCorrSmearedNoReg_Summer12_DR53X_HCP2012":
            warnings.warn( "EETauTauTree: Expected branch e1PtCorrSmearedNoReg_Summer12_DR53X_HCP2012 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1PtCorrSmearedNoReg_Summer12_DR53X_HCP2012")
        else:
            self.e1PtCorrSmearedNoReg_Summer12_DR53X_HCP2012_branch.SetAddress(<void*>&self.e1PtCorrSmearedNoReg_Summer12_DR53X_HCP2012_value)

        #print "making e1PtCorrSmearedReg_2012Jul13ReReco"
        self.e1PtCorrSmearedReg_2012Jul13ReReco_branch = the_tree.GetBranch("e1PtCorrSmearedReg_2012Jul13ReReco")
        #if not self.e1PtCorrSmearedReg_2012Jul13ReReco_branch and "e1PtCorrSmearedReg_2012Jul13ReReco" not in self.complained:
        if not self.e1PtCorrSmearedReg_2012Jul13ReReco_branch and "e1PtCorrSmearedReg_2012Jul13ReReco":
            warnings.warn( "EETauTauTree: Expected branch e1PtCorrSmearedReg_2012Jul13ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1PtCorrSmearedReg_2012Jul13ReReco")
        else:
            self.e1PtCorrSmearedReg_2012Jul13ReReco_branch.SetAddress(<void*>&self.e1PtCorrSmearedReg_2012Jul13ReReco_value)

        #print "making e1PtCorrSmearedReg_Fall11"
        self.e1PtCorrSmearedReg_Fall11_branch = the_tree.GetBranch("e1PtCorrSmearedReg_Fall11")
        #if not self.e1PtCorrSmearedReg_Fall11_branch and "e1PtCorrSmearedReg_Fall11" not in self.complained:
        if not self.e1PtCorrSmearedReg_Fall11_branch and "e1PtCorrSmearedReg_Fall11":
            warnings.warn( "EETauTauTree: Expected branch e1PtCorrSmearedReg_Fall11 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1PtCorrSmearedReg_Fall11")
        else:
            self.e1PtCorrSmearedReg_Fall11_branch.SetAddress(<void*>&self.e1PtCorrSmearedReg_Fall11_value)

        #print "making e1PtCorrSmearedReg_Jan16ReReco"
        self.e1PtCorrSmearedReg_Jan16ReReco_branch = the_tree.GetBranch("e1PtCorrSmearedReg_Jan16ReReco")
        #if not self.e1PtCorrSmearedReg_Jan16ReReco_branch and "e1PtCorrSmearedReg_Jan16ReReco" not in self.complained:
        if not self.e1PtCorrSmearedReg_Jan16ReReco_branch and "e1PtCorrSmearedReg_Jan16ReReco":
            warnings.warn( "EETauTauTree: Expected branch e1PtCorrSmearedReg_Jan16ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1PtCorrSmearedReg_Jan16ReReco")
        else:
            self.e1PtCorrSmearedReg_Jan16ReReco_branch.SetAddress(<void*>&self.e1PtCorrSmearedReg_Jan16ReReco_value)

        #print "making e1PtCorrSmearedReg_Summer12_DR53X_HCP2012"
        self.e1PtCorrSmearedReg_Summer12_DR53X_HCP2012_branch = the_tree.GetBranch("e1PtCorrSmearedReg_Summer12_DR53X_HCP2012")
        #if not self.e1PtCorrSmearedReg_Summer12_DR53X_HCP2012_branch and "e1PtCorrSmearedReg_Summer12_DR53X_HCP2012" not in self.complained:
        if not self.e1PtCorrSmearedReg_Summer12_DR53X_HCP2012_branch and "e1PtCorrSmearedReg_Summer12_DR53X_HCP2012":
            warnings.warn( "EETauTauTree: Expected branch e1PtCorrSmearedReg_Summer12_DR53X_HCP2012 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1PtCorrSmearedReg_Summer12_DR53X_HCP2012")
        else:
            self.e1PtCorrSmearedReg_Summer12_DR53X_HCP2012_branch.SetAddress(<void*>&self.e1PtCorrSmearedReg_Summer12_DR53X_HCP2012_value)

        #print "making e1Rank"
        self.e1Rank_branch = the_tree.GetBranch("e1Rank")
        #if not self.e1Rank_branch and "e1Rank" not in self.complained:
        if not self.e1Rank_branch and "e1Rank":
            warnings.warn( "EETauTauTree: Expected branch e1Rank does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1Rank")
        else:
            self.e1Rank_branch.SetAddress(<void*>&self.e1Rank_value)

        #print "making e1RelIso"
        self.e1RelIso_branch = the_tree.GetBranch("e1RelIso")
        #if not self.e1RelIso_branch and "e1RelIso" not in self.complained:
        if not self.e1RelIso_branch and "e1RelIso":
            warnings.warn( "EETauTauTree: Expected branch e1RelIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1RelIso")
        else:
            self.e1RelIso_branch.SetAddress(<void*>&self.e1RelIso_value)

        #print "making e1RelPFIsoDB"
        self.e1RelPFIsoDB_branch = the_tree.GetBranch("e1RelPFIsoDB")
        #if not self.e1RelPFIsoDB_branch and "e1RelPFIsoDB" not in self.complained:
        if not self.e1RelPFIsoDB_branch and "e1RelPFIsoDB":
            warnings.warn( "EETauTauTree: Expected branch e1RelPFIsoDB does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1RelPFIsoDB")
        else:
            self.e1RelPFIsoDB_branch.SetAddress(<void*>&self.e1RelPFIsoDB_value)

        #print "making e1RelPFIsoRho"
        self.e1RelPFIsoRho_branch = the_tree.GetBranch("e1RelPFIsoRho")
        #if not self.e1RelPFIsoRho_branch and "e1RelPFIsoRho" not in self.complained:
        if not self.e1RelPFIsoRho_branch and "e1RelPFIsoRho":
            warnings.warn( "EETauTauTree: Expected branch e1RelPFIsoRho does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1RelPFIsoRho")
        else:
            self.e1RelPFIsoRho_branch.SetAddress(<void*>&self.e1RelPFIsoRho_value)

        #print "making e1RelPFIsoRhoFSR"
        self.e1RelPFIsoRhoFSR_branch = the_tree.GetBranch("e1RelPFIsoRhoFSR")
        #if not self.e1RelPFIsoRhoFSR_branch and "e1RelPFIsoRhoFSR" not in self.complained:
        if not self.e1RelPFIsoRhoFSR_branch and "e1RelPFIsoRhoFSR":
            warnings.warn( "EETauTauTree: Expected branch e1RelPFIsoRhoFSR does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1RelPFIsoRhoFSR")
        else:
            self.e1RelPFIsoRhoFSR_branch.SetAddress(<void*>&self.e1RelPFIsoRhoFSR_value)

        #print "making e1RhoHZG2011"
        self.e1RhoHZG2011_branch = the_tree.GetBranch("e1RhoHZG2011")
        #if not self.e1RhoHZG2011_branch and "e1RhoHZG2011" not in self.complained:
        if not self.e1RhoHZG2011_branch and "e1RhoHZG2011":
            warnings.warn( "EETauTauTree: Expected branch e1RhoHZG2011 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1RhoHZG2011")
        else:
            self.e1RhoHZG2011_branch.SetAddress(<void*>&self.e1RhoHZG2011_value)

        #print "making e1RhoHZG2012"
        self.e1RhoHZG2012_branch = the_tree.GetBranch("e1RhoHZG2012")
        #if not self.e1RhoHZG2012_branch and "e1RhoHZG2012" not in self.complained:
        if not self.e1RhoHZG2012_branch and "e1RhoHZG2012":
            warnings.warn( "EETauTauTree: Expected branch e1RhoHZG2012 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1RhoHZG2012")
        else:
            self.e1RhoHZG2012_branch.SetAddress(<void*>&self.e1RhoHZG2012_value)

        #print "making e1SCEnergy"
        self.e1SCEnergy_branch = the_tree.GetBranch("e1SCEnergy")
        #if not self.e1SCEnergy_branch and "e1SCEnergy" not in self.complained:
        if not self.e1SCEnergy_branch and "e1SCEnergy":
            warnings.warn( "EETauTauTree: Expected branch e1SCEnergy does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1SCEnergy")
        else:
            self.e1SCEnergy_branch.SetAddress(<void*>&self.e1SCEnergy_value)

        #print "making e1SCEta"
        self.e1SCEta_branch = the_tree.GetBranch("e1SCEta")
        #if not self.e1SCEta_branch and "e1SCEta" not in self.complained:
        if not self.e1SCEta_branch and "e1SCEta":
            warnings.warn( "EETauTauTree: Expected branch e1SCEta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1SCEta")
        else:
            self.e1SCEta_branch.SetAddress(<void*>&self.e1SCEta_value)

        #print "making e1SCEtaWidth"
        self.e1SCEtaWidth_branch = the_tree.GetBranch("e1SCEtaWidth")
        #if not self.e1SCEtaWidth_branch and "e1SCEtaWidth" not in self.complained:
        if not self.e1SCEtaWidth_branch and "e1SCEtaWidth":
            warnings.warn( "EETauTauTree: Expected branch e1SCEtaWidth does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1SCEtaWidth")
        else:
            self.e1SCEtaWidth_branch.SetAddress(<void*>&self.e1SCEtaWidth_value)

        #print "making e1SCPhi"
        self.e1SCPhi_branch = the_tree.GetBranch("e1SCPhi")
        #if not self.e1SCPhi_branch and "e1SCPhi" not in self.complained:
        if not self.e1SCPhi_branch and "e1SCPhi":
            warnings.warn( "EETauTauTree: Expected branch e1SCPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1SCPhi")
        else:
            self.e1SCPhi_branch.SetAddress(<void*>&self.e1SCPhi_value)

        #print "making e1SCPhiWidth"
        self.e1SCPhiWidth_branch = the_tree.GetBranch("e1SCPhiWidth")
        #if not self.e1SCPhiWidth_branch and "e1SCPhiWidth" not in self.complained:
        if not self.e1SCPhiWidth_branch and "e1SCPhiWidth":
            warnings.warn( "EETauTauTree: Expected branch e1SCPhiWidth does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1SCPhiWidth")
        else:
            self.e1SCPhiWidth_branch.SetAddress(<void*>&self.e1SCPhiWidth_value)

        #print "making e1SCPreshowerEnergy"
        self.e1SCPreshowerEnergy_branch = the_tree.GetBranch("e1SCPreshowerEnergy")
        #if not self.e1SCPreshowerEnergy_branch and "e1SCPreshowerEnergy" not in self.complained:
        if not self.e1SCPreshowerEnergy_branch and "e1SCPreshowerEnergy":
            warnings.warn( "EETauTauTree: Expected branch e1SCPreshowerEnergy does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1SCPreshowerEnergy")
        else:
            self.e1SCPreshowerEnergy_branch.SetAddress(<void*>&self.e1SCPreshowerEnergy_value)

        #print "making e1SCRawEnergy"
        self.e1SCRawEnergy_branch = the_tree.GetBranch("e1SCRawEnergy")
        #if not self.e1SCRawEnergy_branch and "e1SCRawEnergy" not in self.complained:
        if not self.e1SCRawEnergy_branch and "e1SCRawEnergy":
            warnings.warn( "EETauTauTree: Expected branch e1SCRawEnergy does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1SCRawEnergy")
        else:
            self.e1SCRawEnergy_branch.SetAddress(<void*>&self.e1SCRawEnergy_value)

        #print "making e1SigmaIEtaIEta"
        self.e1SigmaIEtaIEta_branch = the_tree.GetBranch("e1SigmaIEtaIEta")
        #if not self.e1SigmaIEtaIEta_branch and "e1SigmaIEtaIEta" not in self.complained:
        if not self.e1SigmaIEtaIEta_branch and "e1SigmaIEtaIEta":
            warnings.warn( "EETauTauTree: Expected branch e1SigmaIEtaIEta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1SigmaIEtaIEta")
        else:
            self.e1SigmaIEtaIEta_branch.SetAddress(<void*>&self.e1SigmaIEtaIEta_value)

        #print "making e1ToMETDPhi"
        self.e1ToMETDPhi_branch = the_tree.GetBranch("e1ToMETDPhi")
        #if not self.e1ToMETDPhi_branch and "e1ToMETDPhi" not in self.complained:
        if not self.e1ToMETDPhi_branch and "e1ToMETDPhi":
            warnings.warn( "EETauTauTree: Expected branch e1ToMETDPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1ToMETDPhi")
        else:
            self.e1ToMETDPhi_branch.SetAddress(<void*>&self.e1ToMETDPhi_value)

        #print "making e1TrkIsoDR03"
        self.e1TrkIsoDR03_branch = the_tree.GetBranch("e1TrkIsoDR03")
        #if not self.e1TrkIsoDR03_branch and "e1TrkIsoDR03" not in self.complained:
        if not self.e1TrkIsoDR03_branch and "e1TrkIsoDR03":
            warnings.warn( "EETauTauTree: Expected branch e1TrkIsoDR03 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1TrkIsoDR03")
        else:
            self.e1TrkIsoDR03_branch.SetAddress(<void*>&self.e1TrkIsoDR03_value)

        #print "making e1VZ"
        self.e1VZ_branch = the_tree.GetBranch("e1VZ")
        #if not self.e1VZ_branch and "e1VZ" not in self.complained:
        if not self.e1VZ_branch and "e1VZ":
            warnings.warn( "EETauTauTree: Expected branch e1VZ does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1VZ")
        else:
            self.e1VZ_branch.SetAddress(<void*>&self.e1VZ_value)

        #print "making e1WWID"
        self.e1WWID_branch = the_tree.GetBranch("e1WWID")
        #if not self.e1WWID_branch and "e1WWID" not in self.complained:
        if not self.e1WWID_branch and "e1WWID":
            warnings.warn( "EETauTauTree: Expected branch e1WWID does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1WWID")
        else:
            self.e1WWID_branch.SetAddress(<void*>&self.e1WWID_value)

        #print "making e1_e2_CosThetaStar"
        self.e1_e2_CosThetaStar_branch = the_tree.GetBranch("e1_e2_CosThetaStar")
        #if not self.e1_e2_CosThetaStar_branch and "e1_e2_CosThetaStar" not in self.complained:
        if not self.e1_e2_CosThetaStar_branch and "e1_e2_CosThetaStar":
            warnings.warn( "EETauTauTree: Expected branch e1_e2_CosThetaStar does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1_e2_CosThetaStar")
        else:
            self.e1_e2_CosThetaStar_branch.SetAddress(<void*>&self.e1_e2_CosThetaStar_value)

        #print "making e1_e2_DPhi"
        self.e1_e2_DPhi_branch = the_tree.GetBranch("e1_e2_DPhi")
        #if not self.e1_e2_DPhi_branch and "e1_e2_DPhi" not in self.complained:
        if not self.e1_e2_DPhi_branch and "e1_e2_DPhi":
            warnings.warn( "EETauTauTree: Expected branch e1_e2_DPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1_e2_DPhi")
        else:
            self.e1_e2_DPhi_branch.SetAddress(<void*>&self.e1_e2_DPhi_value)

        #print "making e1_e2_DR"
        self.e1_e2_DR_branch = the_tree.GetBranch("e1_e2_DR")
        #if not self.e1_e2_DR_branch and "e1_e2_DR" not in self.complained:
        if not self.e1_e2_DR_branch and "e1_e2_DR":
            warnings.warn( "EETauTauTree: Expected branch e1_e2_DR does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1_e2_DR")
        else:
            self.e1_e2_DR_branch.SetAddress(<void*>&self.e1_e2_DR_value)

        #print "making e1_e2_Eta"
        self.e1_e2_Eta_branch = the_tree.GetBranch("e1_e2_Eta")
        #if not self.e1_e2_Eta_branch and "e1_e2_Eta" not in self.complained:
        if not self.e1_e2_Eta_branch and "e1_e2_Eta":
            warnings.warn( "EETauTauTree: Expected branch e1_e2_Eta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1_e2_Eta")
        else:
            self.e1_e2_Eta_branch.SetAddress(<void*>&self.e1_e2_Eta_value)

        #print "making e1_e2_Mass"
        self.e1_e2_Mass_branch = the_tree.GetBranch("e1_e2_Mass")
        #if not self.e1_e2_Mass_branch and "e1_e2_Mass" not in self.complained:
        if not self.e1_e2_Mass_branch and "e1_e2_Mass":
            warnings.warn( "EETauTauTree: Expected branch e1_e2_Mass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1_e2_Mass")
        else:
            self.e1_e2_Mass_branch.SetAddress(<void*>&self.e1_e2_Mass_value)

        #print "making e1_e2_MassFsr"
        self.e1_e2_MassFsr_branch = the_tree.GetBranch("e1_e2_MassFsr")
        #if not self.e1_e2_MassFsr_branch and "e1_e2_MassFsr" not in self.complained:
        if not self.e1_e2_MassFsr_branch and "e1_e2_MassFsr":
            warnings.warn( "EETauTauTree: Expected branch e1_e2_MassFsr does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1_e2_MassFsr")
        else:
            self.e1_e2_MassFsr_branch.SetAddress(<void*>&self.e1_e2_MassFsr_value)

        #print "making e1_e2_PZeta"
        self.e1_e2_PZeta_branch = the_tree.GetBranch("e1_e2_PZeta")
        #if not self.e1_e2_PZeta_branch and "e1_e2_PZeta" not in self.complained:
        if not self.e1_e2_PZeta_branch and "e1_e2_PZeta":
            warnings.warn( "EETauTauTree: Expected branch e1_e2_PZeta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1_e2_PZeta")
        else:
            self.e1_e2_PZeta_branch.SetAddress(<void*>&self.e1_e2_PZeta_value)

        #print "making e1_e2_PZetaVis"
        self.e1_e2_PZetaVis_branch = the_tree.GetBranch("e1_e2_PZetaVis")
        #if not self.e1_e2_PZetaVis_branch and "e1_e2_PZetaVis" not in self.complained:
        if not self.e1_e2_PZetaVis_branch and "e1_e2_PZetaVis":
            warnings.warn( "EETauTauTree: Expected branch e1_e2_PZetaVis does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1_e2_PZetaVis")
        else:
            self.e1_e2_PZetaVis_branch.SetAddress(<void*>&self.e1_e2_PZetaVis_value)

        #print "making e1_e2_Phi"
        self.e1_e2_Phi_branch = the_tree.GetBranch("e1_e2_Phi")
        #if not self.e1_e2_Phi_branch and "e1_e2_Phi" not in self.complained:
        if not self.e1_e2_Phi_branch and "e1_e2_Phi":
            warnings.warn( "EETauTauTree: Expected branch e1_e2_Phi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1_e2_Phi")
        else:
            self.e1_e2_Phi_branch.SetAddress(<void*>&self.e1_e2_Phi_value)

        #print "making e1_e2_Pt"
        self.e1_e2_Pt_branch = the_tree.GetBranch("e1_e2_Pt")
        #if not self.e1_e2_Pt_branch and "e1_e2_Pt" not in self.complained:
        if not self.e1_e2_Pt_branch and "e1_e2_Pt":
            warnings.warn( "EETauTauTree: Expected branch e1_e2_Pt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1_e2_Pt")
        else:
            self.e1_e2_Pt_branch.SetAddress(<void*>&self.e1_e2_Pt_value)

        #print "making e1_e2_PtFsr"
        self.e1_e2_PtFsr_branch = the_tree.GetBranch("e1_e2_PtFsr")
        #if not self.e1_e2_PtFsr_branch and "e1_e2_PtFsr" not in self.complained:
        if not self.e1_e2_PtFsr_branch and "e1_e2_PtFsr":
            warnings.warn( "EETauTauTree: Expected branch e1_e2_PtFsr does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1_e2_PtFsr")
        else:
            self.e1_e2_PtFsr_branch.SetAddress(<void*>&self.e1_e2_PtFsr_value)

        #print "making e1_e2_SS"
        self.e1_e2_SS_branch = the_tree.GetBranch("e1_e2_SS")
        #if not self.e1_e2_SS_branch and "e1_e2_SS" not in self.complained:
        if not self.e1_e2_SS_branch and "e1_e2_SS":
            warnings.warn( "EETauTauTree: Expected branch e1_e2_SS does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1_e2_SS")
        else:
            self.e1_e2_SS_branch.SetAddress(<void*>&self.e1_e2_SS_value)

        #print "making e1_e2_ToMETDPhi_Ty1"
        self.e1_e2_ToMETDPhi_Ty1_branch = the_tree.GetBranch("e1_e2_ToMETDPhi_Ty1")
        #if not self.e1_e2_ToMETDPhi_Ty1_branch and "e1_e2_ToMETDPhi_Ty1" not in self.complained:
        if not self.e1_e2_ToMETDPhi_Ty1_branch and "e1_e2_ToMETDPhi_Ty1":
            warnings.warn( "EETauTauTree: Expected branch e1_e2_ToMETDPhi_Ty1 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1_e2_ToMETDPhi_Ty1")
        else:
            self.e1_e2_ToMETDPhi_Ty1_branch.SetAddress(<void*>&self.e1_e2_ToMETDPhi_Ty1_value)

        #print "making e1_e2_Zcompat"
        self.e1_e2_Zcompat_branch = the_tree.GetBranch("e1_e2_Zcompat")
        #if not self.e1_e2_Zcompat_branch and "e1_e2_Zcompat" not in self.complained:
        if not self.e1_e2_Zcompat_branch and "e1_e2_Zcompat":
            warnings.warn( "EETauTauTree: Expected branch e1_e2_Zcompat does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1_e2_Zcompat")
        else:
            self.e1_e2_Zcompat_branch.SetAddress(<void*>&self.e1_e2_Zcompat_value)

        #print "making e1_t1_CosThetaStar"
        self.e1_t1_CosThetaStar_branch = the_tree.GetBranch("e1_t1_CosThetaStar")
        #if not self.e1_t1_CosThetaStar_branch and "e1_t1_CosThetaStar" not in self.complained:
        if not self.e1_t1_CosThetaStar_branch and "e1_t1_CosThetaStar":
            warnings.warn( "EETauTauTree: Expected branch e1_t1_CosThetaStar does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1_t1_CosThetaStar")
        else:
            self.e1_t1_CosThetaStar_branch.SetAddress(<void*>&self.e1_t1_CosThetaStar_value)

        #print "making e1_t1_DPhi"
        self.e1_t1_DPhi_branch = the_tree.GetBranch("e1_t1_DPhi")
        #if not self.e1_t1_DPhi_branch and "e1_t1_DPhi" not in self.complained:
        if not self.e1_t1_DPhi_branch and "e1_t1_DPhi":
            warnings.warn( "EETauTauTree: Expected branch e1_t1_DPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1_t1_DPhi")
        else:
            self.e1_t1_DPhi_branch.SetAddress(<void*>&self.e1_t1_DPhi_value)

        #print "making e1_t1_DR"
        self.e1_t1_DR_branch = the_tree.GetBranch("e1_t1_DR")
        #if not self.e1_t1_DR_branch and "e1_t1_DR" not in self.complained:
        if not self.e1_t1_DR_branch and "e1_t1_DR":
            warnings.warn( "EETauTauTree: Expected branch e1_t1_DR does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1_t1_DR")
        else:
            self.e1_t1_DR_branch.SetAddress(<void*>&self.e1_t1_DR_value)

        #print "making e1_t1_Eta"
        self.e1_t1_Eta_branch = the_tree.GetBranch("e1_t1_Eta")
        #if not self.e1_t1_Eta_branch and "e1_t1_Eta" not in self.complained:
        if not self.e1_t1_Eta_branch and "e1_t1_Eta":
            warnings.warn( "EETauTauTree: Expected branch e1_t1_Eta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1_t1_Eta")
        else:
            self.e1_t1_Eta_branch.SetAddress(<void*>&self.e1_t1_Eta_value)

        #print "making e1_t1_Mass"
        self.e1_t1_Mass_branch = the_tree.GetBranch("e1_t1_Mass")
        #if not self.e1_t1_Mass_branch and "e1_t1_Mass" not in self.complained:
        if not self.e1_t1_Mass_branch and "e1_t1_Mass":
            warnings.warn( "EETauTauTree: Expected branch e1_t1_Mass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1_t1_Mass")
        else:
            self.e1_t1_Mass_branch.SetAddress(<void*>&self.e1_t1_Mass_value)

        #print "making e1_t1_MassFsr"
        self.e1_t1_MassFsr_branch = the_tree.GetBranch("e1_t1_MassFsr")
        #if not self.e1_t1_MassFsr_branch and "e1_t1_MassFsr" not in self.complained:
        if not self.e1_t1_MassFsr_branch and "e1_t1_MassFsr":
            warnings.warn( "EETauTauTree: Expected branch e1_t1_MassFsr does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1_t1_MassFsr")
        else:
            self.e1_t1_MassFsr_branch.SetAddress(<void*>&self.e1_t1_MassFsr_value)

        #print "making e1_t1_PZeta"
        self.e1_t1_PZeta_branch = the_tree.GetBranch("e1_t1_PZeta")
        #if not self.e1_t1_PZeta_branch and "e1_t1_PZeta" not in self.complained:
        if not self.e1_t1_PZeta_branch and "e1_t1_PZeta":
            warnings.warn( "EETauTauTree: Expected branch e1_t1_PZeta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1_t1_PZeta")
        else:
            self.e1_t1_PZeta_branch.SetAddress(<void*>&self.e1_t1_PZeta_value)

        #print "making e1_t1_PZetaVis"
        self.e1_t1_PZetaVis_branch = the_tree.GetBranch("e1_t1_PZetaVis")
        #if not self.e1_t1_PZetaVis_branch and "e1_t1_PZetaVis" not in self.complained:
        if not self.e1_t1_PZetaVis_branch and "e1_t1_PZetaVis":
            warnings.warn( "EETauTauTree: Expected branch e1_t1_PZetaVis does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1_t1_PZetaVis")
        else:
            self.e1_t1_PZetaVis_branch.SetAddress(<void*>&self.e1_t1_PZetaVis_value)

        #print "making e1_t1_Phi"
        self.e1_t1_Phi_branch = the_tree.GetBranch("e1_t1_Phi")
        #if not self.e1_t1_Phi_branch and "e1_t1_Phi" not in self.complained:
        if not self.e1_t1_Phi_branch and "e1_t1_Phi":
            warnings.warn( "EETauTauTree: Expected branch e1_t1_Phi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1_t1_Phi")
        else:
            self.e1_t1_Phi_branch.SetAddress(<void*>&self.e1_t1_Phi_value)

        #print "making e1_t1_Pt"
        self.e1_t1_Pt_branch = the_tree.GetBranch("e1_t1_Pt")
        #if not self.e1_t1_Pt_branch and "e1_t1_Pt" not in self.complained:
        if not self.e1_t1_Pt_branch and "e1_t1_Pt":
            warnings.warn( "EETauTauTree: Expected branch e1_t1_Pt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1_t1_Pt")
        else:
            self.e1_t1_Pt_branch.SetAddress(<void*>&self.e1_t1_Pt_value)

        #print "making e1_t1_PtFsr"
        self.e1_t1_PtFsr_branch = the_tree.GetBranch("e1_t1_PtFsr")
        #if not self.e1_t1_PtFsr_branch and "e1_t1_PtFsr" not in self.complained:
        if not self.e1_t1_PtFsr_branch and "e1_t1_PtFsr":
            warnings.warn( "EETauTauTree: Expected branch e1_t1_PtFsr does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1_t1_PtFsr")
        else:
            self.e1_t1_PtFsr_branch.SetAddress(<void*>&self.e1_t1_PtFsr_value)

        #print "making e1_t1_SS"
        self.e1_t1_SS_branch = the_tree.GetBranch("e1_t1_SS")
        #if not self.e1_t1_SS_branch and "e1_t1_SS" not in self.complained:
        if not self.e1_t1_SS_branch and "e1_t1_SS":
            warnings.warn( "EETauTauTree: Expected branch e1_t1_SS does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1_t1_SS")
        else:
            self.e1_t1_SS_branch.SetAddress(<void*>&self.e1_t1_SS_value)

        #print "making e1_t1_ToMETDPhi_Ty1"
        self.e1_t1_ToMETDPhi_Ty1_branch = the_tree.GetBranch("e1_t1_ToMETDPhi_Ty1")
        #if not self.e1_t1_ToMETDPhi_Ty1_branch and "e1_t1_ToMETDPhi_Ty1" not in self.complained:
        if not self.e1_t1_ToMETDPhi_Ty1_branch and "e1_t1_ToMETDPhi_Ty1":
            warnings.warn( "EETauTauTree: Expected branch e1_t1_ToMETDPhi_Ty1 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1_t1_ToMETDPhi_Ty1")
        else:
            self.e1_t1_ToMETDPhi_Ty1_branch.SetAddress(<void*>&self.e1_t1_ToMETDPhi_Ty1_value)

        #print "making e1_t1_Zcompat"
        self.e1_t1_Zcompat_branch = the_tree.GetBranch("e1_t1_Zcompat")
        #if not self.e1_t1_Zcompat_branch and "e1_t1_Zcompat" not in self.complained:
        if not self.e1_t1_Zcompat_branch and "e1_t1_Zcompat":
            warnings.warn( "EETauTauTree: Expected branch e1_t1_Zcompat does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1_t1_Zcompat")
        else:
            self.e1_t1_Zcompat_branch.SetAddress(<void*>&self.e1_t1_Zcompat_value)

        #print "making e1_t2_CosThetaStar"
        self.e1_t2_CosThetaStar_branch = the_tree.GetBranch("e1_t2_CosThetaStar")
        #if not self.e1_t2_CosThetaStar_branch and "e1_t2_CosThetaStar" not in self.complained:
        if not self.e1_t2_CosThetaStar_branch and "e1_t2_CosThetaStar":
            warnings.warn( "EETauTauTree: Expected branch e1_t2_CosThetaStar does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1_t2_CosThetaStar")
        else:
            self.e1_t2_CosThetaStar_branch.SetAddress(<void*>&self.e1_t2_CosThetaStar_value)

        #print "making e1_t2_DPhi"
        self.e1_t2_DPhi_branch = the_tree.GetBranch("e1_t2_DPhi")
        #if not self.e1_t2_DPhi_branch and "e1_t2_DPhi" not in self.complained:
        if not self.e1_t2_DPhi_branch and "e1_t2_DPhi":
            warnings.warn( "EETauTauTree: Expected branch e1_t2_DPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1_t2_DPhi")
        else:
            self.e1_t2_DPhi_branch.SetAddress(<void*>&self.e1_t2_DPhi_value)

        #print "making e1_t2_DR"
        self.e1_t2_DR_branch = the_tree.GetBranch("e1_t2_DR")
        #if not self.e1_t2_DR_branch and "e1_t2_DR" not in self.complained:
        if not self.e1_t2_DR_branch and "e1_t2_DR":
            warnings.warn( "EETauTauTree: Expected branch e1_t2_DR does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1_t2_DR")
        else:
            self.e1_t2_DR_branch.SetAddress(<void*>&self.e1_t2_DR_value)

        #print "making e1_t2_Eta"
        self.e1_t2_Eta_branch = the_tree.GetBranch("e1_t2_Eta")
        #if not self.e1_t2_Eta_branch and "e1_t2_Eta" not in self.complained:
        if not self.e1_t2_Eta_branch and "e1_t2_Eta":
            warnings.warn( "EETauTauTree: Expected branch e1_t2_Eta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1_t2_Eta")
        else:
            self.e1_t2_Eta_branch.SetAddress(<void*>&self.e1_t2_Eta_value)

        #print "making e1_t2_Mass"
        self.e1_t2_Mass_branch = the_tree.GetBranch("e1_t2_Mass")
        #if not self.e1_t2_Mass_branch and "e1_t2_Mass" not in self.complained:
        if not self.e1_t2_Mass_branch and "e1_t2_Mass":
            warnings.warn( "EETauTauTree: Expected branch e1_t2_Mass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1_t2_Mass")
        else:
            self.e1_t2_Mass_branch.SetAddress(<void*>&self.e1_t2_Mass_value)

        #print "making e1_t2_MassFsr"
        self.e1_t2_MassFsr_branch = the_tree.GetBranch("e1_t2_MassFsr")
        #if not self.e1_t2_MassFsr_branch and "e1_t2_MassFsr" not in self.complained:
        if not self.e1_t2_MassFsr_branch and "e1_t2_MassFsr":
            warnings.warn( "EETauTauTree: Expected branch e1_t2_MassFsr does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1_t2_MassFsr")
        else:
            self.e1_t2_MassFsr_branch.SetAddress(<void*>&self.e1_t2_MassFsr_value)

        #print "making e1_t2_PZeta"
        self.e1_t2_PZeta_branch = the_tree.GetBranch("e1_t2_PZeta")
        #if not self.e1_t2_PZeta_branch and "e1_t2_PZeta" not in self.complained:
        if not self.e1_t2_PZeta_branch and "e1_t2_PZeta":
            warnings.warn( "EETauTauTree: Expected branch e1_t2_PZeta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1_t2_PZeta")
        else:
            self.e1_t2_PZeta_branch.SetAddress(<void*>&self.e1_t2_PZeta_value)

        #print "making e1_t2_PZetaVis"
        self.e1_t2_PZetaVis_branch = the_tree.GetBranch("e1_t2_PZetaVis")
        #if not self.e1_t2_PZetaVis_branch and "e1_t2_PZetaVis" not in self.complained:
        if not self.e1_t2_PZetaVis_branch and "e1_t2_PZetaVis":
            warnings.warn( "EETauTauTree: Expected branch e1_t2_PZetaVis does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1_t2_PZetaVis")
        else:
            self.e1_t2_PZetaVis_branch.SetAddress(<void*>&self.e1_t2_PZetaVis_value)

        #print "making e1_t2_Phi"
        self.e1_t2_Phi_branch = the_tree.GetBranch("e1_t2_Phi")
        #if not self.e1_t2_Phi_branch and "e1_t2_Phi" not in self.complained:
        if not self.e1_t2_Phi_branch and "e1_t2_Phi":
            warnings.warn( "EETauTauTree: Expected branch e1_t2_Phi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1_t2_Phi")
        else:
            self.e1_t2_Phi_branch.SetAddress(<void*>&self.e1_t2_Phi_value)

        #print "making e1_t2_Pt"
        self.e1_t2_Pt_branch = the_tree.GetBranch("e1_t2_Pt")
        #if not self.e1_t2_Pt_branch and "e1_t2_Pt" not in self.complained:
        if not self.e1_t2_Pt_branch and "e1_t2_Pt":
            warnings.warn( "EETauTauTree: Expected branch e1_t2_Pt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1_t2_Pt")
        else:
            self.e1_t2_Pt_branch.SetAddress(<void*>&self.e1_t2_Pt_value)

        #print "making e1_t2_PtFsr"
        self.e1_t2_PtFsr_branch = the_tree.GetBranch("e1_t2_PtFsr")
        #if not self.e1_t2_PtFsr_branch and "e1_t2_PtFsr" not in self.complained:
        if not self.e1_t2_PtFsr_branch and "e1_t2_PtFsr":
            warnings.warn( "EETauTauTree: Expected branch e1_t2_PtFsr does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1_t2_PtFsr")
        else:
            self.e1_t2_PtFsr_branch.SetAddress(<void*>&self.e1_t2_PtFsr_value)

        #print "making e1_t2_SS"
        self.e1_t2_SS_branch = the_tree.GetBranch("e1_t2_SS")
        #if not self.e1_t2_SS_branch and "e1_t2_SS" not in self.complained:
        if not self.e1_t2_SS_branch and "e1_t2_SS":
            warnings.warn( "EETauTauTree: Expected branch e1_t2_SS does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1_t2_SS")
        else:
            self.e1_t2_SS_branch.SetAddress(<void*>&self.e1_t2_SS_value)

        #print "making e1_t2_ToMETDPhi_Ty1"
        self.e1_t2_ToMETDPhi_Ty1_branch = the_tree.GetBranch("e1_t2_ToMETDPhi_Ty1")
        #if not self.e1_t2_ToMETDPhi_Ty1_branch and "e1_t2_ToMETDPhi_Ty1" not in self.complained:
        if not self.e1_t2_ToMETDPhi_Ty1_branch and "e1_t2_ToMETDPhi_Ty1":
            warnings.warn( "EETauTauTree: Expected branch e1_t2_ToMETDPhi_Ty1 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1_t2_ToMETDPhi_Ty1")
        else:
            self.e1_t2_ToMETDPhi_Ty1_branch.SetAddress(<void*>&self.e1_t2_ToMETDPhi_Ty1_value)

        #print "making e1_t2_Zcompat"
        self.e1_t2_Zcompat_branch = the_tree.GetBranch("e1_t2_Zcompat")
        #if not self.e1_t2_Zcompat_branch and "e1_t2_Zcompat" not in self.complained:
        if not self.e1_t2_Zcompat_branch and "e1_t2_Zcompat":
            warnings.warn( "EETauTauTree: Expected branch e1_t2_Zcompat does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1_t2_Zcompat")
        else:
            self.e1_t2_Zcompat_branch.SetAddress(<void*>&self.e1_t2_Zcompat_value)

        #print "making e1dECorrReg_2012Jul13ReReco"
        self.e1dECorrReg_2012Jul13ReReco_branch = the_tree.GetBranch("e1dECorrReg_2012Jul13ReReco")
        #if not self.e1dECorrReg_2012Jul13ReReco_branch and "e1dECorrReg_2012Jul13ReReco" not in self.complained:
        if not self.e1dECorrReg_2012Jul13ReReco_branch and "e1dECorrReg_2012Jul13ReReco":
            warnings.warn( "EETauTauTree: Expected branch e1dECorrReg_2012Jul13ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1dECorrReg_2012Jul13ReReco")
        else:
            self.e1dECorrReg_2012Jul13ReReco_branch.SetAddress(<void*>&self.e1dECorrReg_2012Jul13ReReco_value)

        #print "making e1dECorrReg_Fall11"
        self.e1dECorrReg_Fall11_branch = the_tree.GetBranch("e1dECorrReg_Fall11")
        #if not self.e1dECorrReg_Fall11_branch and "e1dECorrReg_Fall11" not in self.complained:
        if not self.e1dECorrReg_Fall11_branch and "e1dECorrReg_Fall11":
            warnings.warn( "EETauTauTree: Expected branch e1dECorrReg_Fall11 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1dECorrReg_Fall11")
        else:
            self.e1dECorrReg_Fall11_branch.SetAddress(<void*>&self.e1dECorrReg_Fall11_value)

        #print "making e1dECorrReg_Jan16ReReco"
        self.e1dECorrReg_Jan16ReReco_branch = the_tree.GetBranch("e1dECorrReg_Jan16ReReco")
        #if not self.e1dECorrReg_Jan16ReReco_branch and "e1dECorrReg_Jan16ReReco" not in self.complained:
        if not self.e1dECorrReg_Jan16ReReco_branch and "e1dECorrReg_Jan16ReReco":
            warnings.warn( "EETauTauTree: Expected branch e1dECorrReg_Jan16ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1dECorrReg_Jan16ReReco")
        else:
            self.e1dECorrReg_Jan16ReReco_branch.SetAddress(<void*>&self.e1dECorrReg_Jan16ReReco_value)

        #print "making e1dECorrReg_Summer12_DR53X_HCP2012"
        self.e1dECorrReg_Summer12_DR53X_HCP2012_branch = the_tree.GetBranch("e1dECorrReg_Summer12_DR53X_HCP2012")
        #if not self.e1dECorrReg_Summer12_DR53X_HCP2012_branch and "e1dECorrReg_Summer12_DR53X_HCP2012" not in self.complained:
        if not self.e1dECorrReg_Summer12_DR53X_HCP2012_branch and "e1dECorrReg_Summer12_DR53X_HCP2012":
            warnings.warn( "EETauTauTree: Expected branch e1dECorrReg_Summer12_DR53X_HCP2012 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1dECorrReg_Summer12_DR53X_HCP2012")
        else:
            self.e1dECorrReg_Summer12_DR53X_HCP2012_branch.SetAddress(<void*>&self.e1dECorrReg_Summer12_DR53X_HCP2012_value)

        #print "making e1dECorrSmearedNoReg_2012Jul13ReReco"
        self.e1dECorrSmearedNoReg_2012Jul13ReReco_branch = the_tree.GetBranch("e1dECorrSmearedNoReg_2012Jul13ReReco")
        #if not self.e1dECorrSmearedNoReg_2012Jul13ReReco_branch and "e1dECorrSmearedNoReg_2012Jul13ReReco" not in self.complained:
        if not self.e1dECorrSmearedNoReg_2012Jul13ReReco_branch and "e1dECorrSmearedNoReg_2012Jul13ReReco":
            warnings.warn( "EETauTauTree: Expected branch e1dECorrSmearedNoReg_2012Jul13ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1dECorrSmearedNoReg_2012Jul13ReReco")
        else:
            self.e1dECorrSmearedNoReg_2012Jul13ReReco_branch.SetAddress(<void*>&self.e1dECorrSmearedNoReg_2012Jul13ReReco_value)

        #print "making e1dECorrSmearedNoReg_Fall11"
        self.e1dECorrSmearedNoReg_Fall11_branch = the_tree.GetBranch("e1dECorrSmearedNoReg_Fall11")
        #if not self.e1dECorrSmearedNoReg_Fall11_branch and "e1dECorrSmearedNoReg_Fall11" not in self.complained:
        if not self.e1dECorrSmearedNoReg_Fall11_branch and "e1dECorrSmearedNoReg_Fall11":
            warnings.warn( "EETauTauTree: Expected branch e1dECorrSmearedNoReg_Fall11 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1dECorrSmearedNoReg_Fall11")
        else:
            self.e1dECorrSmearedNoReg_Fall11_branch.SetAddress(<void*>&self.e1dECorrSmearedNoReg_Fall11_value)

        #print "making e1dECorrSmearedNoReg_Jan16ReReco"
        self.e1dECorrSmearedNoReg_Jan16ReReco_branch = the_tree.GetBranch("e1dECorrSmearedNoReg_Jan16ReReco")
        #if not self.e1dECorrSmearedNoReg_Jan16ReReco_branch and "e1dECorrSmearedNoReg_Jan16ReReco" not in self.complained:
        if not self.e1dECorrSmearedNoReg_Jan16ReReco_branch and "e1dECorrSmearedNoReg_Jan16ReReco":
            warnings.warn( "EETauTauTree: Expected branch e1dECorrSmearedNoReg_Jan16ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1dECorrSmearedNoReg_Jan16ReReco")
        else:
            self.e1dECorrSmearedNoReg_Jan16ReReco_branch.SetAddress(<void*>&self.e1dECorrSmearedNoReg_Jan16ReReco_value)

        #print "making e1dECorrSmearedNoReg_Summer12_DR53X_HCP2012"
        self.e1dECorrSmearedNoReg_Summer12_DR53X_HCP2012_branch = the_tree.GetBranch("e1dECorrSmearedNoReg_Summer12_DR53X_HCP2012")
        #if not self.e1dECorrSmearedNoReg_Summer12_DR53X_HCP2012_branch and "e1dECorrSmearedNoReg_Summer12_DR53X_HCP2012" not in self.complained:
        if not self.e1dECorrSmearedNoReg_Summer12_DR53X_HCP2012_branch and "e1dECorrSmearedNoReg_Summer12_DR53X_HCP2012":
            warnings.warn( "EETauTauTree: Expected branch e1dECorrSmearedNoReg_Summer12_DR53X_HCP2012 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1dECorrSmearedNoReg_Summer12_DR53X_HCP2012")
        else:
            self.e1dECorrSmearedNoReg_Summer12_DR53X_HCP2012_branch.SetAddress(<void*>&self.e1dECorrSmearedNoReg_Summer12_DR53X_HCP2012_value)

        #print "making e1dECorrSmearedReg_2012Jul13ReReco"
        self.e1dECorrSmearedReg_2012Jul13ReReco_branch = the_tree.GetBranch("e1dECorrSmearedReg_2012Jul13ReReco")
        #if not self.e1dECorrSmearedReg_2012Jul13ReReco_branch and "e1dECorrSmearedReg_2012Jul13ReReco" not in self.complained:
        if not self.e1dECorrSmearedReg_2012Jul13ReReco_branch and "e1dECorrSmearedReg_2012Jul13ReReco":
            warnings.warn( "EETauTauTree: Expected branch e1dECorrSmearedReg_2012Jul13ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1dECorrSmearedReg_2012Jul13ReReco")
        else:
            self.e1dECorrSmearedReg_2012Jul13ReReco_branch.SetAddress(<void*>&self.e1dECorrSmearedReg_2012Jul13ReReco_value)

        #print "making e1dECorrSmearedReg_Fall11"
        self.e1dECorrSmearedReg_Fall11_branch = the_tree.GetBranch("e1dECorrSmearedReg_Fall11")
        #if not self.e1dECorrSmearedReg_Fall11_branch and "e1dECorrSmearedReg_Fall11" not in self.complained:
        if not self.e1dECorrSmearedReg_Fall11_branch and "e1dECorrSmearedReg_Fall11":
            warnings.warn( "EETauTauTree: Expected branch e1dECorrSmearedReg_Fall11 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1dECorrSmearedReg_Fall11")
        else:
            self.e1dECorrSmearedReg_Fall11_branch.SetAddress(<void*>&self.e1dECorrSmearedReg_Fall11_value)

        #print "making e1dECorrSmearedReg_Jan16ReReco"
        self.e1dECorrSmearedReg_Jan16ReReco_branch = the_tree.GetBranch("e1dECorrSmearedReg_Jan16ReReco")
        #if not self.e1dECorrSmearedReg_Jan16ReReco_branch and "e1dECorrSmearedReg_Jan16ReReco" not in self.complained:
        if not self.e1dECorrSmearedReg_Jan16ReReco_branch and "e1dECorrSmearedReg_Jan16ReReco":
            warnings.warn( "EETauTauTree: Expected branch e1dECorrSmearedReg_Jan16ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1dECorrSmearedReg_Jan16ReReco")
        else:
            self.e1dECorrSmearedReg_Jan16ReReco_branch.SetAddress(<void*>&self.e1dECorrSmearedReg_Jan16ReReco_value)

        #print "making e1dECorrSmearedReg_Summer12_DR53X_HCP2012"
        self.e1dECorrSmearedReg_Summer12_DR53X_HCP2012_branch = the_tree.GetBranch("e1dECorrSmearedReg_Summer12_DR53X_HCP2012")
        #if not self.e1dECorrSmearedReg_Summer12_DR53X_HCP2012_branch and "e1dECorrSmearedReg_Summer12_DR53X_HCP2012" not in self.complained:
        if not self.e1dECorrSmearedReg_Summer12_DR53X_HCP2012_branch and "e1dECorrSmearedReg_Summer12_DR53X_HCP2012":
            warnings.warn( "EETauTauTree: Expected branch e1dECorrSmearedReg_Summer12_DR53X_HCP2012 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1dECorrSmearedReg_Summer12_DR53X_HCP2012")
        else:
            self.e1dECorrSmearedReg_Summer12_DR53X_HCP2012_branch.SetAddress(<void*>&self.e1dECorrSmearedReg_Summer12_DR53X_HCP2012_value)

        #print "making e1deltaEtaSuperClusterTrackAtVtx"
        self.e1deltaEtaSuperClusterTrackAtVtx_branch = the_tree.GetBranch("e1deltaEtaSuperClusterTrackAtVtx")
        #if not self.e1deltaEtaSuperClusterTrackAtVtx_branch and "e1deltaEtaSuperClusterTrackAtVtx" not in self.complained:
        if not self.e1deltaEtaSuperClusterTrackAtVtx_branch and "e1deltaEtaSuperClusterTrackAtVtx":
            warnings.warn( "EETauTauTree: Expected branch e1deltaEtaSuperClusterTrackAtVtx does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1deltaEtaSuperClusterTrackAtVtx")
        else:
            self.e1deltaEtaSuperClusterTrackAtVtx_branch.SetAddress(<void*>&self.e1deltaEtaSuperClusterTrackAtVtx_value)

        #print "making e1deltaPhiSuperClusterTrackAtVtx"
        self.e1deltaPhiSuperClusterTrackAtVtx_branch = the_tree.GetBranch("e1deltaPhiSuperClusterTrackAtVtx")
        #if not self.e1deltaPhiSuperClusterTrackAtVtx_branch and "e1deltaPhiSuperClusterTrackAtVtx" not in self.complained:
        if not self.e1deltaPhiSuperClusterTrackAtVtx_branch and "e1deltaPhiSuperClusterTrackAtVtx":
            warnings.warn( "EETauTauTree: Expected branch e1deltaPhiSuperClusterTrackAtVtx does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1deltaPhiSuperClusterTrackAtVtx")
        else:
            self.e1deltaPhiSuperClusterTrackAtVtx_branch.SetAddress(<void*>&self.e1deltaPhiSuperClusterTrackAtVtx_value)

        #print "making e1eSuperClusterOverP"
        self.e1eSuperClusterOverP_branch = the_tree.GetBranch("e1eSuperClusterOverP")
        #if not self.e1eSuperClusterOverP_branch and "e1eSuperClusterOverP" not in self.complained:
        if not self.e1eSuperClusterOverP_branch and "e1eSuperClusterOverP":
            warnings.warn( "EETauTauTree: Expected branch e1eSuperClusterOverP does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1eSuperClusterOverP")
        else:
            self.e1eSuperClusterOverP_branch.SetAddress(<void*>&self.e1eSuperClusterOverP_value)

        #print "making e1ecalEnergy"
        self.e1ecalEnergy_branch = the_tree.GetBranch("e1ecalEnergy")
        #if not self.e1ecalEnergy_branch and "e1ecalEnergy" not in self.complained:
        if not self.e1ecalEnergy_branch and "e1ecalEnergy":
            warnings.warn( "EETauTauTree: Expected branch e1ecalEnergy does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1ecalEnergy")
        else:
            self.e1ecalEnergy_branch.SetAddress(<void*>&self.e1ecalEnergy_value)

        #print "making e1fBrem"
        self.e1fBrem_branch = the_tree.GetBranch("e1fBrem")
        #if not self.e1fBrem_branch and "e1fBrem" not in self.complained:
        if not self.e1fBrem_branch and "e1fBrem":
            warnings.warn( "EETauTauTree: Expected branch e1fBrem does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1fBrem")
        else:
            self.e1fBrem_branch.SetAddress(<void*>&self.e1fBrem_value)

        #print "making e1trackMomentumAtVtxP"
        self.e1trackMomentumAtVtxP_branch = the_tree.GetBranch("e1trackMomentumAtVtxP")
        #if not self.e1trackMomentumAtVtxP_branch and "e1trackMomentumAtVtxP" not in self.complained:
        if not self.e1trackMomentumAtVtxP_branch and "e1trackMomentumAtVtxP":
            warnings.warn( "EETauTauTree: Expected branch e1trackMomentumAtVtxP does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1trackMomentumAtVtxP")
        else:
            self.e1trackMomentumAtVtxP_branch.SetAddress(<void*>&self.e1trackMomentumAtVtxP_value)

        #print "making e2AbsEta"
        self.e2AbsEta_branch = the_tree.GetBranch("e2AbsEta")
        #if not self.e2AbsEta_branch and "e2AbsEta" not in self.complained:
        if not self.e2AbsEta_branch and "e2AbsEta":
            warnings.warn( "EETauTauTree: Expected branch e2AbsEta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2AbsEta")
        else:
            self.e2AbsEta_branch.SetAddress(<void*>&self.e2AbsEta_value)

        #print "making e2CBID_LOOSE"
        self.e2CBID_LOOSE_branch = the_tree.GetBranch("e2CBID_LOOSE")
        #if not self.e2CBID_LOOSE_branch and "e2CBID_LOOSE" not in self.complained:
        if not self.e2CBID_LOOSE_branch and "e2CBID_LOOSE":
            warnings.warn( "EETauTauTree: Expected branch e2CBID_LOOSE does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2CBID_LOOSE")
        else:
            self.e2CBID_LOOSE_branch.SetAddress(<void*>&self.e2CBID_LOOSE_value)

        #print "making e2CBID_MEDIUM"
        self.e2CBID_MEDIUM_branch = the_tree.GetBranch("e2CBID_MEDIUM")
        #if not self.e2CBID_MEDIUM_branch and "e2CBID_MEDIUM" not in self.complained:
        if not self.e2CBID_MEDIUM_branch and "e2CBID_MEDIUM":
            warnings.warn( "EETauTauTree: Expected branch e2CBID_MEDIUM does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2CBID_MEDIUM")
        else:
            self.e2CBID_MEDIUM_branch.SetAddress(<void*>&self.e2CBID_MEDIUM_value)

        #print "making e2CBID_TIGHT"
        self.e2CBID_TIGHT_branch = the_tree.GetBranch("e2CBID_TIGHT")
        #if not self.e2CBID_TIGHT_branch and "e2CBID_TIGHT" not in self.complained:
        if not self.e2CBID_TIGHT_branch and "e2CBID_TIGHT":
            warnings.warn( "EETauTauTree: Expected branch e2CBID_TIGHT does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2CBID_TIGHT")
        else:
            self.e2CBID_TIGHT_branch.SetAddress(<void*>&self.e2CBID_TIGHT_value)

        #print "making e2CBID_VETO"
        self.e2CBID_VETO_branch = the_tree.GetBranch("e2CBID_VETO")
        #if not self.e2CBID_VETO_branch and "e2CBID_VETO" not in self.complained:
        if not self.e2CBID_VETO_branch and "e2CBID_VETO":
            warnings.warn( "EETauTauTree: Expected branch e2CBID_VETO does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2CBID_VETO")
        else:
            self.e2CBID_VETO_branch.SetAddress(<void*>&self.e2CBID_VETO_value)

        #print "making e2Charge"
        self.e2Charge_branch = the_tree.GetBranch("e2Charge")
        #if not self.e2Charge_branch and "e2Charge" not in self.complained:
        if not self.e2Charge_branch and "e2Charge":
            warnings.warn( "EETauTauTree: Expected branch e2Charge does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2Charge")
        else:
            self.e2Charge_branch.SetAddress(<void*>&self.e2Charge_value)

        #print "making e2ChargeIdLoose"
        self.e2ChargeIdLoose_branch = the_tree.GetBranch("e2ChargeIdLoose")
        #if not self.e2ChargeIdLoose_branch and "e2ChargeIdLoose" not in self.complained:
        if not self.e2ChargeIdLoose_branch and "e2ChargeIdLoose":
            warnings.warn( "EETauTauTree: Expected branch e2ChargeIdLoose does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2ChargeIdLoose")
        else:
            self.e2ChargeIdLoose_branch.SetAddress(<void*>&self.e2ChargeIdLoose_value)

        #print "making e2ChargeIdMed"
        self.e2ChargeIdMed_branch = the_tree.GetBranch("e2ChargeIdMed")
        #if not self.e2ChargeIdMed_branch and "e2ChargeIdMed" not in self.complained:
        if not self.e2ChargeIdMed_branch and "e2ChargeIdMed":
            warnings.warn( "EETauTauTree: Expected branch e2ChargeIdMed does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2ChargeIdMed")
        else:
            self.e2ChargeIdMed_branch.SetAddress(<void*>&self.e2ChargeIdMed_value)

        #print "making e2ChargeIdTight"
        self.e2ChargeIdTight_branch = the_tree.GetBranch("e2ChargeIdTight")
        #if not self.e2ChargeIdTight_branch and "e2ChargeIdTight" not in self.complained:
        if not self.e2ChargeIdTight_branch and "e2ChargeIdTight":
            warnings.warn( "EETauTauTree: Expected branch e2ChargeIdTight does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2ChargeIdTight")
        else:
            self.e2ChargeIdTight_branch.SetAddress(<void*>&self.e2ChargeIdTight_value)

        #print "making e2CiCTight"
        self.e2CiCTight_branch = the_tree.GetBranch("e2CiCTight")
        #if not self.e2CiCTight_branch and "e2CiCTight" not in self.complained:
        if not self.e2CiCTight_branch and "e2CiCTight":
            warnings.warn( "EETauTauTree: Expected branch e2CiCTight does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2CiCTight")
        else:
            self.e2CiCTight_branch.SetAddress(<void*>&self.e2CiCTight_value)

        #print "making e2CiCTightElecOverlap"
        self.e2CiCTightElecOverlap_branch = the_tree.GetBranch("e2CiCTightElecOverlap")
        #if not self.e2CiCTightElecOverlap_branch and "e2CiCTightElecOverlap" not in self.complained:
        if not self.e2CiCTightElecOverlap_branch and "e2CiCTightElecOverlap":
            warnings.warn( "EETauTauTree: Expected branch e2CiCTightElecOverlap does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2CiCTightElecOverlap")
        else:
            self.e2CiCTightElecOverlap_branch.SetAddress(<void*>&self.e2CiCTightElecOverlap_value)

        #print "making e2ComesFromHiggs"
        self.e2ComesFromHiggs_branch = the_tree.GetBranch("e2ComesFromHiggs")
        #if not self.e2ComesFromHiggs_branch and "e2ComesFromHiggs" not in self.complained:
        if not self.e2ComesFromHiggs_branch and "e2ComesFromHiggs":
            warnings.warn( "EETauTauTree: Expected branch e2ComesFromHiggs does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2ComesFromHiggs")
        else:
            self.e2ComesFromHiggs_branch.SetAddress(<void*>&self.e2ComesFromHiggs_value)

        #print "making e2DZ"
        self.e2DZ_branch = the_tree.GetBranch("e2DZ")
        #if not self.e2DZ_branch and "e2DZ" not in self.complained:
        if not self.e2DZ_branch and "e2DZ":
            warnings.warn( "EETauTauTree: Expected branch e2DZ does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2DZ")
        else:
            self.e2DZ_branch.SetAddress(<void*>&self.e2DZ_value)

        #print "making e2E1x5"
        self.e2E1x5_branch = the_tree.GetBranch("e2E1x5")
        #if not self.e2E1x5_branch and "e2E1x5" not in self.complained:
        if not self.e2E1x5_branch and "e2E1x5":
            warnings.warn( "EETauTauTree: Expected branch e2E1x5 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2E1x5")
        else:
            self.e2E1x5_branch.SetAddress(<void*>&self.e2E1x5_value)

        #print "making e2E2x5Max"
        self.e2E2x5Max_branch = the_tree.GetBranch("e2E2x5Max")
        #if not self.e2E2x5Max_branch and "e2E2x5Max" not in self.complained:
        if not self.e2E2x5Max_branch and "e2E2x5Max":
            warnings.warn( "EETauTauTree: Expected branch e2E2x5Max does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2E2x5Max")
        else:
            self.e2E2x5Max_branch.SetAddress(<void*>&self.e2E2x5Max_value)

        #print "making e2E5x5"
        self.e2E5x5_branch = the_tree.GetBranch("e2E5x5")
        #if not self.e2E5x5_branch and "e2E5x5" not in self.complained:
        if not self.e2E5x5_branch and "e2E5x5":
            warnings.warn( "EETauTauTree: Expected branch e2E5x5 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2E5x5")
        else:
            self.e2E5x5_branch.SetAddress(<void*>&self.e2E5x5_value)

        #print "making e2ECorrReg_2012Jul13ReReco"
        self.e2ECorrReg_2012Jul13ReReco_branch = the_tree.GetBranch("e2ECorrReg_2012Jul13ReReco")
        #if not self.e2ECorrReg_2012Jul13ReReco_branch and "e2ECorrReg_2012Jul13ReReco" not in self.complained:
        if not self.e2ECorrReg_2012Jul13ReReco_branch and "e2ECorrReg_2012Jul13ReReco":
            warnings.warn( "EETauTauTree: Expected branch e2ECorrReg_2012Jul13ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2ECorrReg_2012Jul13ReReco")
        else:
            self.e2ECorrReg_2012Jul13ReReco_branch.SetAddress(<void*>&self.e2ECorrReg_2012Jul13ReReco_value)

        #print "making e2ECorrReg_Fall11"
        self.e2ECorrReg_Fall11_branch = the_tree.GetBranch("e2ECorrReg_Fall11")
        #if not self.e2ECorrReg_Fall11_branch and "e2ECorrReg_Fall11" not in self.complained:
        if not self.e2ECorrReg_Fall11_branch and "e2ECorrReg_Fall11":
            warnings.warn( "EETauTauTree: Expected branch e2ECorrReg_Fall11 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2ECorrReg_Fall11")
        else:
            self.e2ECorrReg_Fall11_branch.SetAddress(<void*>&self.e2ECorrReg_Fall11_value)

        #print "making e2ECorrReg_Jan16ReReco"
        self.e2ECorrReg_Jan16ReReco_branch = the_tree.GetBranch("e2ECorrReg_Jan16ReReco")
        #if not self.e2ECorrReg_Jan16ReReco_branch and "e2ECorrReg_Jan16ReReco" not in self.complained:
        if not self.e2ECorrReg_Jan16ReReco_branch and "e2ECorrReg_Jan16ReReco":
            warnings.warn( "EETauTauTree: Expected branch e2ECorrReg_Jan16ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2ECorrReg_Jan16ReReco")
        else:
            self.e2ECorrReg_Jan16ReReco_branch.SetAddress(<void*>&self.e2ECorrReg_Jan16ReReco_value)

        #print "making e2ECorrReg_Summer12_DR53X_HCP2012"
        self.e2ECorrReg_Summer12_DR53X_HCP2012_branch = the_tree.GetBranch("e2ECorrReg_Summer12_DR53X_HCP2012")
        #if not self.e2ECorrReg_Summer12_DR53X_HCP2012_branch and "e2ECorrReg_Summer12_DR53X_HCP2012" not in self.complained:
        if not self.e2ECorrReg_Summer12_DR53X_HCP2012_branch and "e2ECorrReg_Summer12_DR53X_HCP2012":
            warnings.warn( "EETauTauTree: Expected branch e2ECorrReg_Summer12_DR53X_HCP2012 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2ECorrReg_Summer12_DR53X_HCP2012")
        else:
            self.e2ECorrReg_Summer12_DR53X_HCP2012_branch.SetAddress(<void*>&self.e2ECorrReg_Summer12_DR53X_HCP2012_value)

        #print "making e2ECorrSmearedNoReg_2012Jul13ReReco"
        self.e2ECorrSmearedNoReg_2012Jul13ReReco_branch = the_tree.GetBranch("e2ECorrSmearedNoReg_2012Jul13ReReco")
        #if not self.e2ECorrSmearedNoReg_2012Jul13ReReco_branch and "e2ECorrSmearedNoReg_2012Jul13ReReco" not in self.complained:
        if not self.e2ECorrSmearedNoReg_2012Jul13ReReco_branch and "e2ECorrSmearedNoReg_2012Jul13ReReco":
            warnings.warn( "EETauTauTree: Expected branch e2ECorrSmearedNoReg_2012Jul13ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2ECorrSmearedNoReg_2012Jul13ReReco")
        else:
            self.e2ECorrSmearedNoReg_2012Jul13ReReco_branch.SetAddress(<void*>&self.e2ECorrSmearedNoReg_2012Jul13ReReco_value)

        #print "making e2ECorrSmearedNoReg_Fall11"
        self.e2ECorrSmearedNoReg_Fall11_branch = the_tree.GetBranch("e2ECorrSmearedNoReg_Fall11")
        #if not self.e2ECorrSmearedNoReg_Fall11_branch and "e2ECorrSmearedNoReg_Fall11" not in self.complained:
        if not self.e2ECorrSmearedNoReg_Fall11_branch and "e2ECorrSmearedNoReg_Fall11":
            warnings.warn( "EETauTauTree: Expected branch e2ECorrSmearedNoReg_Fall11 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2ECorrSmearedNoReg_Fall11")
        else:
            self.e2ECorrSmearedNoReg_Fall11_branch.SetAddress(<void*>&self.e2ECorrSmearedNoReg_Fall11_value)

        #print "making e2ECorrSmearedNoReg_Jan16ReReco"
        self.e2ECorrSmearedNoReg_Jan16ReReco_branch = the_tree.GetBranch("e2ECorrSmearedNoReg_Jan16ReReco")
        #if not self.e2ECorrSmearedNoReg_Jan16ReReco_branch and "e2ECorrSmearedNoReg_Jan16ReReco" not in self.complained:
        if not self.e2ECorrSmearedNoReg_Jan16ReReco_branch and "e2ECorrSmearedNoReg_Jan16ReReco":
            warnings.warn( "EETauTauTree: Expected branch e2ECorrSmearedNoReg_Jan16ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2ECorrSmearedNoReg_Jan16ReReco")
        else:
            self.e2ECorrSmearedNoReg_Jan16ReReco_branch.SetAddress(<void*>&self.e2ECorrSmearedNoReg_Jan16ReReco_value)

        #print "making e2ECorrSmearedNoReg_Summer12_DR53X_HCP2012"
        self.e2ECorrSmearedNoReg_Summer12_DR53X_HCP2012_branch = the_tree.GetBranch("e2ECorrSmearedNoReg_Summer12_DR53X_HCP2012")
        #if not self.e2ECorrSmearedNoReg_Summer12_DR53X_HCP2012_branch and "e2ECorrSmearedNoReg_Summer12_DR53X_HCP2012" not in self.complained:
        if not self.e2ECorrSmearedNoReg_Summer12_DR53X_HCP2012_branch and "e2ECorrSmearedNoReg_Summer12_DR53X_HCP2012":
            warnings.warn( "EETauTauTree: Expected branch e2ECorrSmearedNoReg_Summer12_DR53X_HCP2012 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2ECorrSmearedNoReg_Summer12_DR53X_HCP2012")
        else:
            self.e2ECorrSmearedNoReg_Summer12_DR53X_HCP2012_branch.SetAddress(<void*>&self.e2ECorrSmearedNoReg_Summer12_DR53X_HCP2012_value)

        #print "making e2ECorrSmearedReg_2012Jul13ReReco"
        self.e2ECorrSmearedReg_2012Jul13ReReco_branch = the_tree.GetBranch("e2ECorrSmearedReg_2012Jul13ReReco")
        #if not self.e2ECorrSmearedReg_2012Jul13ReReco_branch and "e2ECorrSmearedReg_2012Jul13ReReco" not in self.complained:
        if not self.e2ECorrSmearedReg_2012Jul13ReReco_branch and "e2ECorrSmearedReg_2012Jul13ReReco":
            warnings.warn( "EETauTauTree: Expected branch e2ECorrSmearedReg_2012Jul13ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2ECorrSmearedReg_2012Jul13ReReco")
        else:
            self.e2ECorrSmearedReg_2012Jul13ReReco_branch.SetAddress(<void*>&self.e2ECorrSmearedReg_2012Jul13ReReco_value)

        #print "making e2ECorrSmearedReg_Fall11"
        self.e2ECorrSmearedReg_Fall11_branch = the_tree.GetBranch("e2ECorrSmearedReg_Fall11")
        #if not self.e2ECorrSmearedReg_Fall11_branch and "e2ECorrSmearedReg_Fall11" not in self.complained:
        if not self.e2ECorrSmearedReg_Fall11_branch and "e2ECorrSmearedReg_Fall11":
            warnings.warn( "EETauTauTree: Expected branch e2ECorrSmearedReg_Fall11 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2ECorrSmearedReg_Fall11")
        else:
            self.e2ECorrSmearedReg_Fall11_branch.SetAddress(<void*>&self.e2ECorrSmearedReg_Fall11_value)

        #print "making e2ECorrSmearedReg_Jan16ReReco"
        self.e2ECorrSmearedReg_Jan16ReReco_branch = the_tree.GetBranch("e2ECorrSmearedReg_Jan16ReReco")
        #if not self.e2ECorrSmearedReg_Jan16ReReco_branch and "e2ECorrSmearedReg_Jan16ReReco" not in self.complained:
        if not self.e2ECorrSmearedReg_Jan16ReReco_branch and "e2ECorrSmearedReg_Jan16ReReco":
            warnings.warn( "EETauTauTree: Expected branch e2ECorrSmearedReg_Jan16ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2ECorrSmearedReg_Jan16ReReco")
        else:
            self.e2ECorrSmearedReg_Jan16ReReco_branch.SetAddress(<void*>&self.e2ECorrSmearedReg_Jan16ReReco_value)

        #print "making e2ECorrSmearedReg_Summer12_DR53X_HCP2012"
        self.e2ECorrSmearedReg_Summer12_DR53X_HCP2012_branch = the_tree.GetBranch("e2ECorrSmearedReg_Summer12_DR53X_HCP2012")
        #if not self.e2ECorrSmearedReg_Summer12_DR53X_HCP2012_branch and "e2ECorrSmearedReg_Summer12_DR53X_HCP2012" not in self.complained:
        if not self.e2ECorrSmearedReg_Summer12_DR53X_HCP2012_branch and "e2ECorrSmearedReg_Summer12_DR53X_HCP2012":
            warnings.warn( "EETauTauTree: Expected branch e2ECorrSmearedReg_Summer12_DR53X_HCP2012 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2ECorrSmearedReg_Summer12_DR53X_HCP2012")
        else:
            self.e2ECorrSmearedReg_Summer12_DR53X_HCP2012_branch.SetAddress(<void*>&self.e2ECorrSmearedReg_Summer12_DR53X_HCP2012_value)

        #print "making e2EcalIsoDR03"
        self.e2EcalIsoDR03_branch = the_tree.GetBranch("e2EcalIsoDR03")
        #if not self.e2EcalIsoDR03_branch and "e2EcalIsoDR03" not in self.complained:
        if not self.e2EcalIsoDR03_branch and "e2EcalIsoDR03":
            warnings.warn( "EETauTauTree: Expected branch e2EcalIsoDR03 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2EcalIsoDR03")
        else:
            self.e2EcalIsoDR03_branch.SetAddress(<void*>&self.e2EcalIsoDR03_value)

        #print "making e2EffectiveArea2011Data"
        self.e2EffectiveArea2011Data_branch = the_tree.GetBranch("e2EffectiveArea2011Data")
        #if not self.e2EffectiveArea2011Data_branch and "e2EffectiveArea2011Data" not in self.complained:
        if not self.e2EffectiveArea2011Data_branch and "e2EffectiveArea2011Data":
            warnings.warn( "EETauTauTree: Expected branch e2EffectiveArea2011Data does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2EffectiveArea2011Data")
        else:
            self.e2EffectiveArea2011Data_branch.SetAddress(<void*>&self.e2EffectiveArea2011Data_value)

        #print "making e2EffectiveArea2012Data"
        self.e2EffectiveArea2012Data_branch = the_tree.GetBranch("e2EffectiveArea2012Data")
        #if not self.e2EffectiveArea2012Data_branch and "e2EffectiveArea2012Data" not in self.complained:
        if not self.e2EffectiveArea2012Data_branch and "e2EffectiveArea2012Data":
            warnings.warn( "EETauTauTree: Expected branch e2EffectiveArea2012Data does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2EffectiveArea2012Data")
        else:
            self.e2EffectiveArea2012Data_branch.SetAddress(<void*>&self.e2EffectiveArea2012Data_value)

        #print "making e2EffectiveAreaFall11MC"
        self.e2EffectiveAreaFall11MC_branch = the_tree.GetBranch("e2EffectiveAreaFall11MC")
        #if not self.e2EffectiveAreaFall11MC_branch and "e2EffectiveAreaFall11MC" not in self.complained:
        if not self.e2EffectiveAreaFall11MC_branch and "e2EffectiveAreaFall11MC":
            warnings.warn( "EETauTauTree: Expected branch e2EffectiveAreaFall11MC does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2EffectiveAreaFall11MC")
        else:
            self.e2EffectiveAreaFall11MC_branch.SetAddress(<void*>&self.e2EffectiveAreaFall11MC_value)

        #print "making e2Ele27WP80PFMT50PFMTFilter"
        self.e2Ele27WP80PFMT50PFMTFilter_branch = the_tree.GetBranch("e2Ele27WP80PFMT50PFMTFilter")
        #if not self.e2Ele27WP80PFMT50PFMTFilter_branch and "e2Ele27WP80PFMT50PFMTFilter" not in self.complained:
        if not self.e2Ele27WP80PFMT50PFMTFilter_branch and "e2Ele27WP80PFMT50PFMTFilter":
            warnings.warn( "EETauTauTree: Expected branch e2Ele27WP80PFMT50PFMTFilter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2Ele27WP80PFMT50PFMTFilter")
        else:
            self.e2Ele27WP80PFMT50PFMTFilter_branch.SetAddress(<void*>&self.e2Ele27WP80PFMT50PFMTFilter_value)

        #print "making e2Ele27WP80TrackIsoMatchFilter"
        self.e2Ele27WP80TrackIsoMatchFilter_branch = the_tree.GetBranch("e2Ele27WP80TrackIsoMatchFilter")
        #if not self.e2Ele27WP80TrackIsoMatchFilter_branch and "e2Ele27WP80TrackIsoMatchFilter" not in self.complained:
        if not self.e2Ele27WP80TrackIsoMatchFilter_branch and "e2Ele27WP80TrackIsoMatchFilter":
            warnings.warn( "EETauTauTree: Expected branch e2Ele27WP80TrackIsoMatchFilter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2Ele27WP80TrackIsoMatchFilter")
        else:
            self.e2Ele27WP80TrackIsoMatchFilter_branch.SetAddress(<void*>&self.e2Ele27WP80TrackIsoMatchFilter_value)

        #print "making e2Ele32WP70PFMT50PFMTFilter"
        self.e2Ele32WP70PFMT50PFMTFilter_branch = the_tree.GetBranch("e2Ele32WP70PFMT50PFMTFilter")
        #if not self.e2Ele32WP70PFMT50PFMTFilter_branch and "e2Ele32WP70PFMT50PFMTFilter" not in self.complained:
        if not self.e2Ele32WP70PFMT50PFMTFilter_branch and "e2Ele32WP70PFMT50PFMTFilter":
            warnings.warn( "EETauTauTree: Expected branch e2Ele32WP70PFMT50PFMTFilter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2Ele32WP70PFMT50PFMTFilter")
        else:
            self.e2Ele32WP70PFMT50PFMTFilter_branch.SetAddress(<void*>&self.e2Ele32WP70PFMT50PFMTFilter_value)

        #print "making e2ElecOverlap"
        self.e2ElecOverlap_branch = the_tree.GetBranch("e2ElecOverlap")
        #if not self.e2ElecOverlap_branch and "e2ElecOverlap" not in self.complained:
        if not self.e2ElecOverlap_branch and "e2ElecOverlap":
            warnings.warn( "EETauTauTree: Expected branch e2ElecOverlap does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2ElecOverlap")
        else:
            self.e2ElecOverlap_branch.SetAddress(<void*>&self.e2ElecOverlap_value)

        #print "making e2ElecOverlapZHLoose"
        self.e2ElecOverlapZHLoose_branch = the_tree.GetBranch("e2ElecOverlapZHLoose")
        #if not self.e2ElecOverlapZHLoose_branch and "e2ElecOverlapZHLoose" not in self.complained:
        if not self.e2ElecOverlapZHLoose_branch and "e2ElecOverlapZHLoose":
            warnings.warn( "EETauTauTree: Expected branch e2ElecOverlapZHLoose does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2ElecOverlapZHLoose")
        else:
            self.e2ElecOverlapZHLoose_branch.SetAddress(<void*>&self.e2ElecOverlapZHLoose_value)

        #print "making e2ElecOverlapZHTight"
        self.e2ElecOverlapZHTight_branch = the_tree.GetBranch("e2ElecOverlapZHTight")
        #if not self.e2ElecOverlapZHTight_branch and "e2ElecOverlapZHTight" not in self.complained:
        if not self.e2ElecOverlapZHTight_branch and "e2ElecOverlapZHTight":
            warnings.warn( "EETauTauTree: Expected branch e2ElecOverlapZHTight does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2ElecOverlapZHTight")
        else:
            self.e2ElecOverlapZHTight_branch.SetAddress(<void*>&self.e2ElecOverlapZHTight_value)

        #print "making e2EnergyError"
        self.e2EnergyError_branch = the_tree.GetBranch("e2EnergyError")
        #if not self.e2EnergyError_branch and "e2EnergyError" not in self.complained:
        if not self.e2EnergyError_branch and "e2EnergyError":
            warnings.warn( "EETauTauTree: Expected branch e2EnergyError does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2EnergyError")
        else:
            self.e2EnergyError_branch.SetAddress(<void*>&self.e2EnergyError_value)

        #print "making e2Eta"
        self.e2Eta_branch = the_tree.GetBranch("e2Eta")
        #if not self.e2Eta_branch and "e2Eta" not in self.complained:
        if not self.e2Eta_branch and "e2Eta":
            warnings.warn( "EETauTauTree: Expected branch e2Eta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2Eta")
        else:
            self.e2Eta_branch.SetAddress(<void*>&self.e2Eta_value)

        #print "making e2EtaCorrReg_2012Jul13ReReco"
        self.e2EtaCorrReg_2012Jul13ReReco_branch = the_tree.GetBranch("e2EtaCorrReg_2012Jul13ReReco")
        #if not self.e2EtaCorrReg_2012Jul13ReReco_branch and "e2EtaCorrReg_2012Jul13ReReco" not in self.complained:
        if not self.e2EtaCorrReg_2012Jul13ReReco_branch and "e2EtaCorrReg_2012Jul13ReReco":
            warnings.warn( "EETauTauTree: Expected branch e2EtaCorrReg_2012Jul13ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2EtaCorrReg_2012Jul13ReReco")
        else:
            self.e2EtaCorrReg_2012Jul13ReReco_branch.SetAddress(<void*>&self.e2EtaCorrReg_2012Jul13ReReco_value)

        #print "making e2EtaCorrReg_Fall11"
        self.e2EtaCorrReg_Fall11_branch = the_tree.GetBranch("e2EtaCorrReg_Fall11")
        #if not self.e2EtaCorrReg_Fall11_branch and "e2EtaCorrReg_Fall11" not in self.complained:
        if not self.e2EtaCorrReg_Fall11_branch and "e2EtaCorrReg_Fall11":
            warnings.warn( "EETauTauTree: Expected branch e2EtaCorrReg_Fall11 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2EtaCorrReg_Fall11")
        else:
            self.e2EtaCorrReg_Fall11_branch.SetAddress(<void*>&self.e2EtaCorrReg_Fall11_value)

        #print "making e2EtaCorrReg_Jan16ReReco"
        self.e2EtaCorrReg_Jan16ReReco_branch = the_tree.GetBranch("e2EtaCorrReg_Jan16ReReco")
        #if not self.e2EtaCorrReg_Jan16ReReco_branch and "e2EtaCorrReg_Jan16ReReco" not in self.complained:
        if not self.e2EtaCorrReg_Jan16ReReco_branch and "e2EtaCorrReg_Jan16ReReco":
            warnings.warn( "EETauTauTree: Expected branch e2EtaCorrReg_Jan16ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2EtaCorrReg_Jan16ReReco")
        else:
            self.e2EtaCorrReg_Jan16ReReco_branch.SetAddress(<void*>&self.e2EtaCorrReg_Jan16ReReco_value)

        #print "making e2EtaCorrReg_Summer12_DR53X_HCP2012"
        self.e2EtaCorrReg_Summer12_DR53X_HCP2012_branch = the_tree.GetBranch("e2EtaCorrReg_Summer12_DR53X_HCP2012")
        #if not self.e2EtaCorrReg_Summer12_DR53X_HCP2012_branch and "e2EtaCorrReg_Summer12_DR53X_HCP2012" not in self.complained:
        if not self.e2EtaCorrReg_Summer12_DR53X_HCP2012_branch and "e2EtaCorrReg_Summer12_DR53X_HCP2012":
            warnings.warn( "EETauTauTree: Expected branch e2EtaCorrReg_Summer12_DR53X_HCP2012 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2EtaCorrReg_Summer12_DR53X_HCP2012")
        else:
            self.e2EtaCorrReg_Summer12_DR53X_HCP2012_branch.SetAddress(<void*>&self.e2EtaCorrReg_Summer12_DR53X_HCP2012_value)

        #print "making e2EtaCorrSmearedNoReg_2012Jul13ReReco"
        self.e2EtaCorrSmearedNoReg_2012Jul13ReReco_branch = the_tree.GetBranch("e2EtaCorrSmearedNoReg_2012Jul13ReReco")
        #if not self.e2EtaCorrSmearedNoReg_2012Jul13ReReco_branch and "e2EtaCorrSmearedNoReg_2012Jul13ReReco" not in self.complained:
        if not self.e2EtaCorrSmearedNoReg_2012Jul13ReReco_branch and "e2EtaCorrSmearedNoReg_2012Jul13ReReco":
            warnings.warn( "EETauTauTree: Expected branch e2EtaCorrSmearedNoReg_2012Jul13ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2EtaCorrSmearedNoReg_2012Jul13ReReco")
        else:
            self.e2EtaCorrSmearedNoReg_2012Jul13ReReco_branch.SetAddress(<void*>&self.e2EtaCorrSmearedNoReg_2012Jul13ReReco_value)

        #print "making e2EtaCorrSmearedNoReg_Fall11"
        self.e2EtaCorrSmearedNoReg_Fall11_branch = the_tree.GetBranch("e2EtaCorrSmearedNoReg_Fall11")
        #if not self.e2EtaCorrSmearedNoReg_Fall11_branch and "e2EtaCorrSmearedNoReg_Fall11" not in self.complained:
        if not self.e2EtaCorrSmearedNoReg_Fall11_branch and "e2EtaCorrSmearedNoReg_Fall11":
            warnings.warn( "EETauTauTree: Expected branch e2EtaCorrSmearedNoReg_Fall11 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2EtaCorrSmearedNoReg_Fall11")
        else:
            self.e2EtaCorrSmearedNoReg_Fall11_branch.SetAddress(<void*>&self.e2EtaCorrSmearedNoReg_Fall11_value)

        #print "making e2EtaCorrSmearedNoReg_Jan16ReReco"
        self.e2EtaCorrSmearedNoReg_Jan16ReReco_branch = the_tree.GetBranch("e2EtaCorrSmearedNoReg_Jan16ReReco")
        #if not self.e2EtaCorrSmearedNoReg_Jan16ReReco_branch and "e2EtaCorrSmearedNoReg_Jan16ReReco" not in self.complained:
        if not self.e2EtaCorrSmearedNoReg_Jan16ReReco_branch and "e2EtaCorrSmearedNoReg_Jan16ReReco":
            warnings.warn( "EETauTauTree: Expected branch e2EtaCorrSmearedNoReg_Jan16ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2EtaCorrSmearedNoReg_Jan16ReReco")
        else:
            self.e2EtaCorrSmearedNoReg_Jan16ReReco_branch.SetAddress(<void*>&self.e2EtaCorrSmearedNoReg_Jan16ReReco_value)

        #print "making e2EtaCorrSmearedNoReg_Summer12_DR53X_HCP2012"
        self.e2EtaCorrSmearedNoReg_Summer12_DR53X_HCP2012_branch = the_tree.GetBranch("e2EtaCorrSmearedNoReg_Summer12_DR53X_HCP2012")
        #if not self.e2EtaCorrSmearedNoReg_Summer12_DR53X_HCP2012_branch and "e2EtaCorrSmearedNoReg_Summer12_DR53X_HCP2012" not in self.complained:
        if not self.e2EtaCorrSmearedNoReg_Summer12_DR53X_HCP2012_branch and "e2EtaCorrSmearedNoReg_Summer12_DR53X_HCP2012":
            warnings.warn( "EETauTauTree: Expected branch e2EtaCorrSmearedNoReg_Summer12_DR53X_HCP2012 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2EtaCorrSmearedNoReg_Summer12_DR53X_HCP2012")
        else:
            self.e2EtaCorrSmearedNoReg_Summer12_DR53X_HCP2012_branch.SetAddress(<void*>&self.e2EtaCorrSmearedNoReg_Summer12_DR53X_HCP2012_value)

        #print "making e2EtaCorrSmearedReg_2012Jul13ReReco"
        self.e2EtaCorrSmearedReg_2012Jul13ReReco_branch = the_tree.GetBranch("e2EtaCorrSmearedReg_2012Jul13ReReco")
        #if not self.e2EtaCorrSmearedReg_2012Jul13ReReco_branch and "e2EtaCorrSmearedReg_2012Jul13ReReco" not in self.complained:
        if not self.e2EtaCorrSmearedReg_2012Jul13ReReco_branch and "e2EtaCorrSmearedReg_2012Jul13ReReco":
            warnings.warn( "EETauTauTree: Expected branch e2EtaCorrSmearedReg_2012Jul13ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2EtaCorrSmearedReg_2012Jul13ReReco")
        else:
            self.e2EtaCorrSmearedReg_2012Jul13ReReco_branch.SetAddress(<void*>&self.e2EtaCorrSmearedReg_2012Jul13ReReco_value)

        #print "making e2EtaCorrSmearedReg_Fall11"
        self.e2EtaCorrSmearedReg_Fall11_branch = the_tree.GetBranch("e2EtaCorrSmearedReg_Fall11")
        #if not self.e2EtaCorrSmearedReg_Fall11_branch and "e2EtaCorrSmearedReg_Fall11" not in self.complained:
        if not self.e2EtaCorrSmearedReg_Fall11_branch and "e2EtaCorrSmearedReg_Fall11":
            warnings.warn( "EETauTauTree: Expected branch e2EtaCorrSmearedReg_Fall11 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2EtaCorrSmearedReg_Fall11")
        else:
            self.e2EtaCorrSmearedReg_Fall11_branch.SetAddress(<void*>&self.e2EtaCorrSmearedReg_Fall11_value)

        #print "making e2EtaCorrSmearedReg_Jan16ReReco"
        self.e2EtaCorrSmearedReg_Jan16ReReco_branch = the_tree.GetBranch("e2EtaCorrSmearedReg_Jan16ReReco")
        #if not self.e2EtaCorrSmearedReg_Jan16ReReco_branch and "e2EtaCorrSmearedReg_Jan16ReReco" not in self.complained:
        if not self.e2EtaCorrSmearedReg_Jan16ReReco_branch and "e2EtaCorrSmearedReg_Jan16ReReco":
            warnings.warn( "EETauTauTree: Expected branch e2EtaCorrSmearedReg_Jan16ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2EtaCorrSmearedReg_Jan16ReReco")
        else:
            self.e2EtaCorrSmearedReg_Jan16ReReco_branch.SetAddress(<void*>&self.e2EtaCorrSmearedReg_Jan16ReReco_value)

        #print "making e2EtaCorrSmearedReg_Summer12_DR53X_HCP2012"
        self.e2EtaCorrSmearedReg_Summer12_DR53X_HCP2012_branch = the_tree.GetBranch("e2EtaCorrSmearedReg_Summer12_DR53X_HCP2012")
        #if not self.e2EtaCorrSmearedReg_Summer12_DR53X_HCP2012_branch and "e2EtaCorrSmearedReg_Summer12_DR53X_HCP2012" not in self.complained:
        if not self.e2EtaCorrSmearedReg_Summer12_DR53X_HCP2012_branch and "e2EtaCorrSmearedReg_Summer12_DR53X_HCP2012":
            warnings.warn( "EETauTauTree: Expected branch e2EtaCorrSmearedReg_Summer12_DR53X_HCP2012 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2EtaCorrSmearedReg_Summer12_DR53X_HCP2012")
        else:
            self.e2EtaCorrSmearedReg_Summer12_DR53X_HCP2012_branch.SetAddress(<void*>&self.e2EtaCorrSmearedReg_Summer12_DR53X_HCP2012_value)

        #print "making e2GenCharge"
        self.e2GenCharge_branch = the_tree.GetBranch("e2GenCharge")
        #if not self.e2GenCharge_branch and "e2GenCharge" not in self.complained:
        if not self.e2GenCharge_branch and "e2GenCharge":
            warnings.warn( "EETauTauTree: Expected branch e2GenCharge does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2GenCharge")
        else:
            self.e2GenCharge_branch.SetAddress(<void*>&self.e2GenCharge_value)

        #print "making e2GenEnergy"
        self.e2GenEnergy_branch = the_tree.GetBranch("e2GenEnergy")
        #if not self.e2GenEnergy_branch and "e2GenEnergy" not in self.complained:
        if not self.e2GenEnergy_branch and "e2GenEnergy":
            warnings.warn( "EETauTauTree: Expected branch e2GenEnergy does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2GenEnergy")
        else:
            self.e2GenEnergy_branch.SetAddress(<void*>&self.e2GenEnergy_value)

        #print "making e2GenEta"
        self.e2GenEta_branch = the_tree.GetBranch("e2GenEta")
        #if not self.e2GenEta_branch and "e2GenEta" not in self.complained:
        if not self.e2GenEta_branch and "e2GenEta":
            warnings.warn( "EETauTauTree: Expected branch e2GenEta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2GenEta")
        else:
            self.e2GenEta_branch.SetAddress(<void*>&self.e2GenEta_value)

        #print "making e2GenMotherPdgId"
        self.e2GenMotherPdgId_branch = the_tree.GetBranch("e2GenMotherPdgId")
        #if not self.e2GenMotherPdgId_branch and "e2GenMotherPdgId" not in self.complained:
        if not self.e2GenMotherPdgId_branch and "e2GenMotherPdgId":
            warnings.warn( "EETauTauTree: Expected branch e2GenMotherPdgId does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2GenMotherPdgId")
        else:
            self.e2GenMotherPdgId_branch.SetAddress(<void*>&self.e2GenMotherPdgId_value)

        #print "making e2GenPdgId"
        self.e2GenPdgId_branch = the_tree.GetBranch("e2GenPdgId")
        #if not self.e2GenPdgId_branch and "e2GenPdgId" not in self.complained:
        if not self.e2GenPdgId_branch and "e2GenPdgId":
            warnings.warn( "EETauTauTree: Expected branch e2GenPdgId does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2GenPdgId")
        else:
            self.e2GenPdgId_branch.SetAddress(<void*>&self.e2GenPdgId_value)

        #print "making e2GenPhi"
        self.e2GenPhi_branch = the_tree.GetBranch("e2GenPhi")
        #if not self.e2GenPhi_branch and "e2GenPhi" not in self.complained:
        if not self.e2GenPhi_branch and "e2GenPhi":
            warnings.warn( "EETauTauTree: Expected branch e2GenPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2GenPhi")
        else:
            self.e2GenPhi_branch.SetAddress(<void*>&self.e2GenPhi_value)

        #print "making e2HadronicDepth1OverEm"
        self.e2HadronicDepth1OverEm_branch = the_tree.GetBranch("e2HadronicDepth1OverEm")
        #if not self.e2HadronicDepth1OverEm_branch and "e2HadronicDepth1OverEm" not in self.complained:
        if not self.e2HadronicDepth1OverEm_branch and "e2HadronicDepth1OverEm":
            warnings.warn( "EETauTauTree: Expected branch e2HadronicDepth1OverEm does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2HadronicDepth1OverEm")
        else:
            self.e2HadronicDepth1OverEm_branch.SetAddress(<void*>&self.e2HadronicDepth1OverEm_value)

        #print "making e2HadronicDepth2OverEm"
        self.e2HadronicDepth2OverEm_branch = the_tree.GetBranch("e2HadronicDepth2OverEm")
        #if not self.e2HadronicDepth2OverEm_branch and "e2HadronicDepth2OverEm" not in self.complained:
        if not self.e2HadronicDepth2OverEm_branch and "e2HadronicDepth2OverEm":
            warnings.warn( "EETauTauTree: Expected branch e2HadronicDepth2OverEm does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2HadronicDepth2OverEm")
        else:
            self.e2HadronicDepth2OverEm_branch.SetAddress(<void*>&self.e2HadronicDepth2OverEm_value)

        #print "making e2HadronicOverEM"
        self.e2HadronicOverEM_branch = the_tree.GetBranch("e2HadronicOverEM")
        #if not self.e2HadronicOverEM_branch and "e2HadronicOverEM" not in self.complained:
        if not self.e2HadronicOverEM_branch and "e2HadronicOverEM":
            warnings.warn( "EETauTauTree: Expected branch e2HadronicOverEM does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2HadronicOverEM")
        else:
            self.e2HadronicOverEM_branch.SetAddress(<void*>&self.e2HadronicOverEM_value)

        #print "making e2HasConversion"
        self.e2HasConversion_branch = the_tree.GetBranch("e2HasConversion")
        #if not self.e2HasConversion_branch and "e2HasConversion" not in self.complained:
        if not self.e2HasConversion_branch and "e2HasConversion":
            warnings.warn( "EETauTauTree: Expected branch e2HasConversion does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2HasConversion")
        else:
            self.e2HasConversion_branch.SetAddress(<void*>&self.e2HasConversion_value)

        #print "making e2HasMatchedConversion"
        self.e2HasMatchedConversion_branch = the_tree.GetBranch("e2HasMatchedConversion")
        #if not self.e2HasMatchedConversion_branch and "e2HasMatchedConversion" not in self.complained:
        if not self.e2HasMatchedConversion_branch and "e2HasMatchedConversion":
            warnings.warn( "EETauTauTree: Expected branch e2HasMatchedConversion does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2HasMatchedConversion")
        else:
            self.e2HasMatchedConversion_branch.SetAddress(<void*>&self.e2HasMatchedConversion_value)

        #print "making e2HcalIsoDR03"
        self.e2HcalIsoDR03_branch = the_tree.GetBranch("e2HcalIsoDR03")
        #if not self.e2HcalIsoDR03_branch and "e2HcalIsoDR03" not in self.complained:
        if not self.e2HcalIsoDR03_branch and "e2HcalIsoDR03":
            warnings.warn( "EETauTauTree: Expected branch e2HcalIsoDR03 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2HcalIsoDR03")
        else:
            self.e2HcalIsoDR03_branch.SetAddress(<void*>&self.e2HcalIsoDR03_value)

        #print "making e2IP3DS"
        self.e2IP3DS_branch = the_tree.GetBranch("e2IP3DS")
        #if not self.e2IP3DS_branch and "e2IP3DS" not in self.complained:
        if not self.e2IP3DS_branch and "e2IP3DS":
            warnings.warn( "EETauTauTree: Expected branch e2IP3DS does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2IP3DS")
        else:
            self.e2IP3DS_branch.SetAddress(<void*>&self.e2IP3DS_value)

        #print "making e2JetArea"
        self.e2JetArea_branch = the_tree.GetBranch("e2JetArea")
        #if not self.e2JetArea_branch and "e2JetArea" not in self.complained:
        if not self.e2JetArea_branch and "e2JetArea":
            warnings.warn( "EETauTauTree: Expected branch e2JetArea does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2JetArea")
        else:
            self.e2JetArea_branch.SetAddress(<void*>&self.e2JetArea_value)

        #print "making e2JetBtag"
        self.e2JetBtag_branch = the_tree.GetBranch("e2JetBtag")
        #if not self.e2JetBtag_branch and "e2JetBtag" not in self.complained:
        if not self.e2JetBtag_branch and "e2JetBtag":
            warnings.warn( "EETauTauTree: Expected branch e2JetBtag does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2JetBtag")
        else:
            self.e2JetBtag_branch.SetAddress(<void*>&self.e2JetBtag_value)

        #print "making e2JetCSVBtag"
        self.e2JetCSVBtag_branch = the_tree.GetBranch("e2JetCSVBtag")
        #if not self.e2JetCSVBtag_branch and "e2JetCSVBtag" not in self.complained:
        if not self.e2JetCSVBtag_branch and "e2JetCSVBtag":
            warnings.warn( "EETauTauTree: Expected branch e2JetCSVBtag does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2JetCSVBtag")
        else:
            self.e2JetCSVBtag_branch.SetAddress(<void*>&self.e2JetCSVBtag_value)

        #print "making e2JetEtaEtaMoment"
        self.e2JetEtaEtaMoment_branch = the_tree.GetBranch("e2JetEtaEtaMoment")
        #if not self.e2JetEtaEtaMoment_branch and "e2JetEtaEtaMoment" not in self.complained:
        if not self.e2JetEtaEtaMoment_branch and "e2JetEtaEtaMoment":
            warnings.warn( "EETauTauTree: Expected branch e2JetEtaEtaMoment does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2JetEtaEtaMoment")
        else:
            self.e2JetEtaEtaMoment_branch.SetAddress(<void*>&self.e2JetEtaEtaMoment_value)

        #print "making e2JetEtaPhiMoment"
        self.e2JetEtaPhiMoment_branch = the_tree.GetBranch("e2JetEtaPhiMoment")
        #if not self.e2JetEtaPhiMoment_branch and "e2JetEtaPhiMoment" not in self.complained:
        if not self.e2JetEtaPhiMoment_branch and "e2JetEtaPhiMoment":
            warnings.warn( "EETauTauTree: Expected branch e2JetEtaPhiMoment does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2JetEtaPhiMoment")
        else:
            self.e2JetEtaPhiMoment_branch.SetAddress(<void*>&self.e2JetEtaPhiMoment_value)

        #print "making e2JetEtaPhiSpread"
        self.e2JetEtaPhiSpread_branch = the_tree.GetBranch("e2JetEtaPhiSpread")
        #if not self.e2JetEtaPhiSpread_branch and "e2JetEtaPhiSpread" not in self.complained:
        if not self.e2JetEtaPhiSpread_branch and "e2JetEtaPhiSpread":
            warnings.warn( "EETauTauTree: Expected branch e2JetEtaPhiSpread does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2JetEtaPhiSpread")
        else:
            self.e2JetEtaPhiSpread_branch.SetAddress(<void*>&self.e2JetEtaPhiSpread_value)

        #print "making e2JetPartonFlavour"
        self.e2JetPartonFlavour_branch = the_tree.GetBranch("e2JetPartonFlavour")
        #if not self.e2JetPartonFlavour_branch and "e2JetPartonFlavour" not in self.complained:
        if not self.e2JetPartonFlavour_branch and "e2JetPartonFlavour":
            warnings.warn( "EETauTauTree: Expected branch e2JetPartonFlavour does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2JetPartonFlavour")
        else:
            self.e2JetPartonFlavour_branch.SetAddress(<void*>&self.e2JetPartonFlavour_value)

        #print "making e2JetPhiPhiMoment"
        self.e2JetPhiPhiMoment_branch = the_tree.GetBranch("e2JetPhiPhiMoment")
        #if not self.e2JetPhiPhiMoment_branch and "e2JetPhiPhiMoment" not in self.complained:
        if not self.e2JetPhiPhiMoment_branch and "e2JetPhiPhiMoment":
            warnings.warn( "EETauTauTree: Expected branch e2JetPhiPhiMoment does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2JetPhiPhiMoment")
        else:
            self.e2JetPhiPhiMoment_branch.SetAddress(<void*>&self.e2JetPhiPhiMoment_value)

        #print "making e2JetPt"
        self.e2JetPt_branch = the_tree.GetBranch("e2JetPt")
        #if not self.e2JetPt_branch and "e2JetPt" not in self.complained:
        if not self.e2JetPt_branch and "e2JetPt":
            warnings.warn( "EETauTauTree: Expected branch e2JetPt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2JetPt")
        else:
            self.e2JetPt_branch.SetAddress(<void*>&self.e2JetPt_value)

        #print "making e2JetQGLikelihoodID"
        self.e2JetQGLikelihoodID_branch = the_tree.GetBranch("e2JetQGLikelihoodID")
        #if not self.e2JetQGLikelihoodID_branch and "e2JetQGLikelihoodID" not in self.complained:
        if not self.e2JetQGLikelihoodID_branch and "e2JetQGLikelihoodID":
            warnings.warn( "EETauTauTree: Expected branch e2JetQGLikelihoodID does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2JetQGLikelihoodID")
        else:
            self.e2JetQGLikelihoodID_branch.SetAddress(<void*>&self.e2JetQGLikelihoodID_value)

        #print "making e2JetQGMVAID"
        self.e2JetQGMVAID_branch = the_tree.GetBranch("e2JetQGMVAID")
        #if not self.e2JetQGMVAID_branch and "e2JetQGMVAID" not in self.complained:
        if not self.e2JetQGMVAID_branch and "e2JetQGMVAID":
            warnings.warn( "EETauTauTree: Expected branch e2JetQGMVAID does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2JetQGMVAID")
        else:
            self.e2JetQGMVAID_branch.SetAddress(<void*>&self.e2JetQGMVAID_value)

        #print "making e2Jetaxis1"
        self.e2Jetaxis1_branch = the_tree.GetBranch("e2Jetaxis1")
        #if not self.e2Jetaxis1_branch and "e2Jetaxis1" not in self.complained:
        if not self.e2Jetaxis1_branch and "e2Jetaxis1":
            warnings.warn( "EETauTauTree: Expected branch e2Jetaxis1 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2Jetaxis1")
        else:
            self.e2Jetaxis1_branch.SetAddress(<void*>&self.e2Jetaxis1_value)

        #print "making e2Jetaxis2"
        self.e2Jetaxis2_branch = the_tree.GetBranch("e2Jetaxis2")
        #if not self.e2Jetaxis2_branch and "e2Jetaxis2" not in self.complained:
        if not self.e2Jetaxis2_branch and "e2Jetaxis2":
            warnings.warn( "EETauTauTree: Expected branch e2Jetaxis2 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2Jetaxis2")
        else:
            self.e2Jetaxis2_branch.SetAddress(<void*>&self.e2Jetaxis2_value)

        #print "making e2Jetmult"
        self.e2Jetmult_branch = the_tree.GetBranch("e2Jetmult")
        #if not self.e2Jetmult_branch and "e2Jetmult" not in self.complained:
        if not self.e2Jetmult_branch and "e2Jetmult":
            warnings.warn( "EETauTauTree: Expected branch e2Jetmult does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2Jetmult")
        else:
            self.e2Jetmult_branch.SetAddress(<void*>&self.e2Jetmult_value)

        #print "making e2JetmultMLP"
        self.e2JetmultMLP_branch = the_tree.GetBranch("e2JetmultMLP")
        #if not self.e2JetmultMLP_branch and "e2JetmultMLP" not in self.complained:
        if not self.e2JetmultMLP_branch and "e2JetmultMLP":
            warnings.warn( "EETauTauTree: Expected branch e2JetmultMLP does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2JetmultMLP")
        else:
            self.e2JetmultMLP_branch.SetAddress(<void*>&self.e2JetmultMLP_value)

        #print "making e2JetmultMLPQC"
        self.e2JetmultMLPQC_branch = the_tree.GetBranch("e2JetmultMLPQC")
        #if not self.e2JetmultMLPQC_branch and "e2JetmultMLPQC" not in self.complained:
        if not self.e2JetmultMLPQC_branch and "e2JetmultMLPQC":
            warnings.warn( "EETauTauTree: Expected branch e2JetmultMLPQC does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2JetmultMLPQC")
        else:
            self.e2JetmultMLPQC_branch.SetAddress(<void*>&self.e2JetmultMLPQC_value)

        #print "making e2JetptD"
        self.e2JetptD_branch = the_tree.GetBranch("e2JetptD")
        #if not self.e2JetptD_branch and "e2JetptD" not in self.complained:
        if not self.e2JetptD_branch and "e2JetptD":
            warnings.warn( "EETauTauTree: Expected branch e2JetptD does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2JetptD")
        else:
            self.e2JetptD_branch.SetAddress(<void*>&self.e2JetptD_value)

        #print "making e2L1NonIsoHLTNonIsoMu17Ele8PixelMatchFilter"
        self.e2L1NonIsoHLTNonIsoMu17Ele8PixelMatchFilter_branch = the_tree.GetBranch("e2L1NonIsoHLTNonIsoMu17Ele8PixelMatchFilter")
        #if not self.e2L1NonIsoHLTNonIsoMu17Ele8PixelMatchFilter_branch and "e2L1NonIsoHLTNonIsoMu17Ele8PixelMatchFilter" not in self.complained:
        if not self.e2L1NonIsoHLTNonIsoMu17Ele8PixelMatchFilter_branch and "e2L1NonIsoHLTNonIsoMu17Ele8PixelMatchFilter":
            warnings.warn( "EETauTauTree: Expected branch e2L1NonIsoHLTNonIsoMu17Ele8PixelMatchFilter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2L1NonIsoHLTNonIsoMu17Ele8PixelMatchFilter")
        else:
            self.e2L1NonIsoHLTNonIsoMu17Ele8PixelMatchFilter_branch.SetAddress(<void*>&self.e2L1NonIsoHLTNonIsoMu17Ele8PixelMatchFilter_value)

        #print "making e2MITID"
        self.e2MITID_branch = the_tree.GetBranch("e2MITID")
        #if not self.e2MITID_branch and "e2MITID" not in self.complained:
        if not self.e2MITID_branch and "e2MITID":
            warnings.warn( "EETauTauTree: Expected branch e2MITID does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2MITID")
        else:
            self.e2MITID_branch.SetAddress(<void*>&self.e2MITID_value)

        #print "making e2MVAIDH2TauWP"
        self.e2MVAIDH2TauWP_branch = the_tree.GetBranch("e2MVAIDH2TauWP")
        #if not self.e2MVAIDH2TauWP_branch and "e2MVAIDH2TauWP" not in self.complained:
        if not self.e2MVAIDH2TauWP_branch and "e2MVAIDH2TauWP":
            warnings.warn( "EETauTauTree: Expected branch e2MVAIDH2TauWP does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2MVAIDH2TauWP")
        else:
            self.e2MVAIDH2TauWP_branch.SetAddress(<void*>&self.e2MVAIDH2TauWP_value)

        #print "making e2MVANonTrig"
        self.e2MVANonTrig_branch = the_tree.GetBranch("e2MVANonTrig")
        #if not self.e2MVANonTrig_branch and "e2MVANonTrig" not in self.complained:
        if not self.e2MVANonTrig_branch and "e2MVANonTrig":
            warnings.warn( "EETauTauTree: Expected branch e2MVANonTrig does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2MVANonTrig")
        else:
            self.e2MVANonTrig_branch.SetAddress(<void*>&self.e2MVANonTrig_value)

        #print "making e2MVATrig"
        self.e2MVATrig_branch = the_tree.GetBranch("e2MVATrig")
        #if not self.e2MVATrig_branch and "e2MVATrig" not in self.complained:
        if not self.e2MVATrig_branch and "e2MVATrig":
            warnings.warn( "EETauTauTree: Expected branch e2MVATrig does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2MVATrig")
        else:
            self.e2MVATrig_branch.SetAddress(<void*>&self.e2MVATrig_value)

        #print "making e2MVATrigIDISO"
        self.e2MVATrigIDISO_branch = the_tree.GetBranch("e2MVATrigIDISO")
        #if not self.e2MVATrigIDISO_branch and "e2MVATrigIDISO" not in self.complained:
        if not self.e2MVATrigIDISO_branch and "e2MVATrigIDISO":
            warnings.warn( "EETauTauTree: Expected branch e2MVATrigIDISO does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2MVATrigIDISO")
        else:
            self.e2MVATrigIDISO_branch.SetAddress(<void*>&self.e2MVATrigIDISO_value)

        #print "making e2MVATrigIDISOPUSUB"
        self.e2MVATrigIDISOPUSUB_branch = the_tree.GetBranch("e2MVATrigIDISOPUSUB")
        #if not self.e2MVATrigIDISOPUSUB_branch and "e2MVATrigIDISOPUSUB" not in self.complained:
        if not self.e2MVATrigIDISOPUSUB_branch and "e2MVATrigIDISOPUSUB":
            warnings.warn( "EETauTauTree: Expected branch e2MVATrigIDISOPUSUB does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2MVATrigIDISOPUSUB")
        else:
            self.e2MVATrigIDISOPUSUB_branch.SetAddress(<void*>&self.e2MVATrigIDISOPUSUB_value)

        #print "making e2MVATrigNoIP"
        self.e2MVATrigNoIP_branch = the_tree.GetBranch("e2MVATrigNoIP")
        #if not self.e2MVATrigNoIP_branch and "e2MVATrigNoIP" not in self.complained:
        if not self.e2MVATrigNoIP_branch and "e2MVATrigNoIP":
            warnings.warn( "EETauTauTree: Expected branch e2MVATrigNoIP does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2MVATrigNoIP")
        else:
            self.e2MVATrigNoIP_branch.SetAddress(<void*>&self.e2MVATrigNoIP_value)

        #print "making e2Mass"
        self.e2Mass_branch = the_tree.GetBranch("e2Mass")
        #if not self.e2Mass_branch and "e2Mass" not in self.complained:
        if not self.e2Mass_branch and "e2Mass":
            warnings.warn( "EETauTauTree: Expected branch e2Mass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2Mass")
        else:
            self.e2Mass_branch.SetAddress(<void*>&self.e2Mass_value)

        #print "making e2MatchesDoubleEPath"
        self.e2MatchesDoubleEPath_branch = the_tree.GetBranch("e2MatchesDoubleEPath")
        #if not self.e2MatchesDoubleEPath_branch and "e2MatchesDoubleEPath" not in self.complained:
        if not self.e2MatchesDoubleEPath_branch and "e2MatchesDoubleEPath":
            warnings.warn( "EETauTauTree: Expected branch e2MatchesDoubleEPath does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2MatchesDoubleEPath")
        else:
            self.e2MatchesDoubleEPath_branch.SetAddress(<void*>&self.e2MatchesDoubleEPath_value)

        #print "making e2MatchesMu17Ele8IsoPath"
        self.e2MatchesMu17Ele8IsoPath_branch = the_tree.GetBranch("e2MatchesMu17Ele8IsoPath")
        #if not self.e2MatchesMu17Ele8IsoPath_branch and "e2MatchesMu17Ele8IsoPath" not in self.complained:
        if not self.e2MatchesMu17Ele8IsoPath_branch and "e2MatchesMu17Ele8IsoPath":
            warnings.warn( "EETauTauTree: Expected branch e2MatchesMu17Ele8IsoPath does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2MatchesMu17Ele8IsoPath")
        else:
            self.e2MatchesMu17Ele8IsoPath_branch.SetAddress(<void*>&self.e2MatchesMu17Ele8IsoPath_value)

        #print "making e2MatchesMu17Ele8Path"
        self.e2MatchesMu17Ele8Path_branch = the_tree.GetBranch("e2MatchesMu17Ele8Path")
        #if not self.e2MatchesMu17Ele8Path_branch and "e2MatchesMu17Ele8Path" not in self.complained:
        if not self.e2MatchesMu17Ele8Path_branch and "e2MatchesMu17Ele8Path":
            warnings.warn( "EETauTauTree: Expected branch e2MatchesMu17Ele8Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2MatchesMu17Ele8Path")
        else:
            self.e2MatchesMu17Ele8Path_branch.SetAddress(<void*>&self.e2MatchesMu17Ele8Path_value)

        #print "making e2MatchesMu8Ele17IsoPath"
        self.e2MatchesMu8Ele17IsoPath_branch = the_tree.GetBranch("e2MatchesMu8Ele17IsoPath")
        #if not self.e2MatchesMu8Ele17IsoPath_branch and "e2MatchesMu8Ele17IsoPath" not in self.complained:
        if not self.e2MatchesMu8Ele17IsoPath_branch and "e2MatchesMu8Ele17IsoPath":
            warnings.warn( "EETauTauTree: Expected branch e2MatchesMu8Ele17IsoPath does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2MatchesMu8Ele17IsoPath")
        else:
            self.e2MatchesMu8Ele17IsoPath_branch.SetAddress(<void*>&self.e2MatchesMu8Ele17IsoPath_value)

        #print "making e2MatchesMu8Ele17Path"
        self.e2MatchesMu8Ele17Path_branch = the_tree.GetBranch("e2MatchesMu8Ele17Path")
        #if not self.e2MatchesMu8Ele17Path_branch and "e2MatchesMu8Ele17Path" not in self.complained:
        if not self.e2MatchesMu8Ele17Path_branch and "e2MatchesMu8Ele17Path":
            warnings.warn( "EETauTauTree: Expected branch e2MatchesMu8Ele17Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2MatchesMu8Ele17Path")
        else:
            self.e2MatchesMu8Ele17Path_branch.SetAddress(<void*>&self.e2MatchesMu8Ele17Path_value)

        #print "making e2MatchesSingleE"
        self.e2MatchesSingleE_branch = the_tree.GetBranch("e2MatchesSingleE")
        #if not self.e2MatchesSingleE_branch and "e2MatchesSingleE" not in self.complained:
        if not self.e2MatchesSingleE_branch and "e2MatchesSingleE":
            warnings.warn( "EETauTauTree: Expected branch e2MatchesSingleE does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2MatchesSingleE")
        else:
            self.e2MatchesSingleE_branch.SetAddress(<void*>&self.e2MatchesSingleE_value)

        #print "making e2MatchesSingleEPlusMET"
        self.e2MatchesSingleEPlusMET_branch = the_tree.GetBranch("e2MatchesSingleEPlusMET")
        #if not self.e2MatchesSingleEPlusMET_branch and "e2MatchesSingleEPlusMET" not in self.complained:
        if not self.e2MatchesSingleEPlusMET_branch and "e2MatchesSingleEPlusMET":
            warnings.warn( "EETauTauTree: Expected branch e2MatchesSingleEPlusMET does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2MatchesSingleEPlusMET")
        else:
            self.e2MatchesSingleEPlusMET_branch.SetAddress(<void*>&self.e2MatchesSingleEPlusMET_value)

        #print "making e2MissingHits"
        self.e2MissingHits_branch = the_tree.GetBranch("e2MissingHits")
        #if not self.e2MissingHits_branch and "e2MissingHits" not in self.complained:
        if not self.e2MissingHits_branch and "e2MissingHits":
            warnings.warn( "EETauTauTree: Expected branch e2MissingHits does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2MissingHits")
        else:
            self.e2MissingHits_branch.SetAddress(<void*>&self.e2MissingHits_value)

        #print "making e2MtToMET"
        self.e2MtToMET_branch = the_tree.GetBranch("e2MtToMET")
        #if not self.e2MtToMET_branch and "e2MtToMET" not in self.complained:
        if not self.e2MtToMET_branch and "e2MtToMET":
            warnings.warn( "EETauTauTree: Expected branch e2MtToMET does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2MtToMET")
        else:
            self.e2MtToMET_branch.SetAddress(<void*>&self.e2MtToMET_value)

        #print "making e2MtToMVAMET"
        self.e2MtToMVAMET_branch = the_tree.GetBranch("e2MtToMVAMET")
        #if not self.e2MtToMVAMET_branch and "e2MtToMVAMET" not in self.complained:
        if not self.e2MtToMVAMET_branch and "e2MtToMVAMET":
            warnings.warn( "EETauTauTree: Expected branch e2MtToMVAMET does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2MtToMVAMET")
        else:
            self.e2MtToMVAMET_branch.SetAddress(<void*>&self.e2MtToMVAMET_value)

        #print "making e2MtToPFMET"
        self.e2MtToPFMET_branch = the_tree.GetBranch("e2MtToPFMET")
        #if not self.e2MtToPFMET_branch and "e2MtToPFMET" not in self.complained:
        if not self.e2MtToPFMET_branch and "e2MtToPFMET":
            warnings.warn( "EETauTauTree: Expected branch e2MtToPFMET does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2MtToPFMET")
        else:
            self.e2MtToPFMET_branch.SetAddress(<void*>&self.e2MtToPFMET_value)

        #print "making e2MtToPfMet_Ty1"
        self.e2MtToPfMet_Ty1_branch = the_tree.GetBranch("e2MtToPfMet_Ty1")
        #if not self.e2MtToPfMet_Ty1_branch and "e2MtToPfMet_Ty1" not in self.complained:
        if not self.e2MtToPfMet_Ty1_branch and "e2MtToPfMet_Ty1":
            warnings.warn( "EETauTauTree: Expected branch e2MtToPfMet_Ty1 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2MtToPfMet_Ty1")
        else:
            self.e2MtToPfMet_Ty1_branch.SetAddress(<void*>&self.e2MtToPfMet_Ty1_value)

        #print "making e2MtToPfMet_jes"
        self.e2MtToPfMet_jes_branch = the_tree.GetBranch("e2MtToPfMet_jes")
        #if not self.e2MtToPfMet_jes_branch and "e2MtToPfMet_jes" not in self.complained:
        if not self.e2MtToPfMet_jes_branch and "e2MtToPfMet_jes":
            warnings.warn( "EETauTauTree: Expected branch e2MtToPfMet_jes does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2MtToPfMet_jes")
        else:
            self.e2MtToPfMet_jes_branch.SetAddress(<void*>&self.e2MtToPfMet_jes_value)

        #print "making e2MtToPfMet_mes"
        self.e2MtToPfMet_mes_branch = the_tree.GetBranch("e2MtToPfMet_mes")
        #if not self.e2MtToPfMet_mes_branch and "e2MtToPfMet_mes" not in self.complained:
        if not self.e2MtToPfMet_mes_branch and "e2MtToPfMet_mes":
            warnings.warn( "EETauTauTree: Expected branch e2MtToPfMet_mes does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2MtToPfMet_mes")
        else:
            self.e2MtToPfMet_mes_branch.SetAddress(<void*>&self.e2MtToPfMet_mes_value)

        #print "making e2MtToPfMet_tes"
        self.e2MtToPfMet_tes_branch = the_tree.GetBranch("e2MtToPfMet_tes")
        #if not self.e2MtToPfMet_tes_branch and "e2MtToPfMet_tes" not in self.complained:
        if not self.e2MtToPfMet_tes_branch and "e2MtToPfMet_tes":
            warnings.warn( "EETauTauTree: Expected branch e2MtToPfMet_tes does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2MtToPfMet_tes")
        else:
            self.e2MtToPfMet_tes_branch.SetAddress(<void*>&self.e2MtToPfMet_tes_value)

        #print "making e2MtToPfMet_ues"
        self.e2MtToPfMet_ues_branch = the_tree.GetBranch("e2MtToPfMet_ues")
        #if not self.e2MtToPfMet_ues_branch and "e2MtToPfMet_ues" not in self.complained:
        if not self.e2MtToPfMet_ues_branch and "e2MtToPfMet_ues":
            warnings.warn( "EETauTauTree: Expected branch e2MtToPfMet_ues does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2MtToPfMet_ues")
        else:
            self.e2MtToPfMet_ues_branch.SetAddress(<void*>&self.e2MtToPfMet_ues_value)

        #print "making e2Mu17Ele8CaloIdTCaloIsoVLTrkIdVLTrkIsoVLTrackIsoFilter"
        self.e2Mu17Ele8CaloIdTCaloIsoVLTrkIdVLTrkIsoVLTrackIsoFilter_branch = the_tree.GetBranch("e2Mu17Ele8CaloIdTCaloIsoVLTrkIdVLTrkIsoVLTrackIsoFilter")
        #if not self.e2Mu17Ele8CaloIdTCaloIsoVLTrkIdVLTrkIsoVLTrackIsoFilter_branch and "e2Mu17Ele8CaloIdTCaloIsoVLTrkIdVLTrkIsoVLTrackIsoFilter" not in self.complained:
        if not self.e2Mu17Ele8CaloIdTCaloIsoVLTrkIdVLTrkIsoVLTrackIsoFilter_branch and "e2Mu17Ele8CaloIdTCaloIsoVLTrkIdVLTrkIsoVLTrackIsoFilter":
            warnings.warn( "EETauTauTree: Expected branch e2Mu17Ele8CaloIdTCaloIsoVLTrkIdVLTrkIsoVLTrackIsoFilter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2Mu17Ele8CaloIdTCaloIsoVLTrkIdVLTrkIsoVLTrackIsoFilter")
        else:
            self.e2Mu17Ele8CaloIdTCaloIsoVLTrkIdVLTrkIsoVLTrackIsoFilter_branch.SetAddress(<void*>&self.e2Mu17Ele8CaloIdTCaloIsoVLTrkIdVLTrkIsoVLTrackIsoFilter_value)

        #print "making e2Mu17Ele8CaloIdTPixelMatchFilter"
        self.e2Mu17Ele8CaloIdTPixelMatchFilter_branch = the_tree.GetBranch("e2Mu17Ele8CaloIdTPixelMatchFilter")
        #if not self.e2Mu17Ele8CaloIdTPixelMatchFilter_branch and "e2Mu17Ele8CaloIdTPixelMatchFilter" not in self.complained:
        if not self.e2Mu17Ele8CaloIdTPixelMatchFilter_branch and "e2Mu17Ele8CaloIdTPixelMatchFilter":
            warnings.warn( "EETauTauTree: Expected branch e2Mu17Ele8CaloIdTPixelMatchFilter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2Mu17Ele8CaloIdTPixelMatchFilter")
        else:
            self.e2Mu17Ele8CaloIdTPixelMatchFilter_branch.SetAddress(<void*>&self.e2Mu17Ele8CaloIdTPixelMatchFilter_value)

        #print "making e2Mu17Ele8dZFilter"
        self.e2Mu17Ele8dZFilter_branch = the_tree.GetBranch("e2Mu17Ele8dZFilter")
        #if not self.e2Mu17Ele8dZFilter_branch and "e2Mu17Ele8dZFilter" not in self.complained:
        if not self.e2Mu17Ele8dZFilter_branch and "e2Mu17Ele8dZFilter":
            warnings.warn( "EETauTauTree: Expected branch e2Mu17Ele8dZFilter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2Mu17Ele8dZFilter")
        else:
            self.e2Mu17Ele8dZFilter_branch.SetAddress(<void*>&self.e2Mu17Ele8dZFilter_value)

        #print "making e2MuOverlap"
        self.e2MuOverlap_branch = the_tree.GetBranch("e2MuOverlap")
        #if not self.e2MuOverlap_branch and "e2MuOverlap" not in self.complained:
        if not self.e2MuOverlap_branch and "e2MuOverlap":
            warnings.warn( "EETauTauTree: Expected branch e2MuOverlap does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2MuOverlap")
        else:
            self.e2MuOverlap_branch.SetAddress(<void*>&self.e2MuOverlap_value)

        #print "making e2MuOverlapZHLoose"
        self.e2MuOverlapZHLoose_branch = the_tree.GetBranch("e2MuOverlapZHLoose")
        #if not self.e2MuOverlapZHLoose_branch and "e2MuOverlapZHLoose" not in self.complained:
        if not self.e2MuOverlapZHLoose_branch and "e2MuOverlapZHLoose":
            warnings.warn( "EETauTauTree: Expected branch e2MuOverlapZHLoose does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2MuOverlapZHLoose")
        else:
            self.e2MuOverlapZHLoose_branch.SetAddress(<void*>&self.e2MuOverlapZHLoose_value)

        #print "making e2MuOverlapZHTight"
        self.e2MuOverlapZHTight_branch = the_tree.GetBranch("e2MuOverlapZHTight")
        #if not self.e2MuOverlapZHTight_branch and "e2MuOverlapZHTight" not in self.complained:
        if not self.e2MuOverlapZHTight_branch and "e2MuOverlapZHTight":
            warnings.warn( "EETauTauTree: Expected branch e2MuOverlapZHTight does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2MuOverlapZHTight")
        else:
            self.e2MuOverlapZHTight_branch.SetAddress(<void*>&self.e2MuOverlapZHTight_value)

        #print "making e2NearMuonVeto"
        self.e2NearMuonVeto_branch = the_tree.GetBranch("e2NearMuonVeto")
        #if not self.e2NearMuonVeto_branch and "e2NearMuonVeto" not in self.complained:
        if not self.e2NearMuonVeto_branch and "e2NearMuonVeto":
            warnings.warn( "EETauTauTree: Expected branch e2NearMuonVeto does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2NearMuonVeto")
        else:
            self.e2NearMuonVeto_branch.SetAddress(<void*>&self.e2NearMuonVeto_value)

        #print "making e2PFChargedIso"
        self.e2PFChargedIso_branch = the_tree.GetBranch("e2PFChargedIso")
        #if not self.e2PFChargedIso_branch and "e2PFChargedIso" not in self.complained:
        if not self.e2PFChargedIso_branch and "e2PFChargedIso":
            warnings.warn( "EETauTauTree: Expected branch e2PFChargedIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2PFChargedIso")
        else:
            self.e2PFChargedIso_branch.SetAddress(<void*>&self.e2PFChargedIso_value)

        #print "making e2PFNeutralIso"
        self.e2PFNeutralIso_branch = the_tree.GetBranch("e2PFNeutralIso")
        #if not self.e2PFNeutralIso_branch and "e2PFNeutralIso" not in self.complained:
        if not self.e2PFNeutralIso_branch and "e2PFNeutralIso":
            warnings.warn( "EETauTauTree: Expected branch e2PFNeutralIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2PFNeutralIso")
        else:
            self.e2PFNeutralIso_branch.SetAddress(<void*>&self.e2PFNeutralIso_value)

        #print "making e2PFPhotonIso"
        self.e2PFPhotonIso_branch = the_tree.GetBranch("e2PFPhotonIso")
        #if not self.e2PFPhotonIso_branch and "e2PFPhotonIso" not in self.complained:
        if not self.e2PFPhotonIso_branch and "e2PFPhotonIso":
            warnings.warn( "EETauTauTree: Expected branch e2PFPhotonIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2PFPhotonIso")
        else:
            self.e2PFPhotonIso_branch.SetAddress(<void*>&self.e2PFPhotonIso_value)

        #print "making e2PVDXY"
        self.e2PVDXY_branch = the_tree.GetBranch("e2PVDXY")
        #if not self.e2PVDXY_branch and "e2PVDXY" not in self.complained:
        if not self.e2PVDXY_branch and "e2PVDXY":
            warnings.warn( "EETauTauTree: Expected branch e2PVDXY does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2PVDXY")
        else:
            self.e2PVDXY_branch.SetAddress(<void*>&self.e2PVDXY_value)

        #print "making e2PVDZ"
        self.e2PVDZ_branch = the_tree.GetBranch("e2PVDZ")
        #if not self.e2PVDZ_branch and "e2PVDZ" not in self.complained:
        if not self.e2PVDZ_branch and "e2PVDZ":
            warnings.warn( "EETauTauTree: Expected branch e2PVDZ does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2PVDZ")
        else:
            self.e2PVDZ_branch.SetAddress(<void*>&self.e2PVDZ_value)

        #print "making e2Phi"
        self.e2Phi_branch = the_tree.GetBranch("e2Phi")
        #if not self.e2Phi_branch and "e2Phi" not in self.complained:
        if not self.e2Phi_branch and "e2Phi":
            warnings.warn( "EETauTauTree: Expected branch e2Phi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2Phi")
        else:
            self.e2Phi_branch.SetAddress(<void*>&self.e2Phi_value)

        #print "making e2PhiCorrReg_2012Jul13ReReco"
        self.e2PhiCorrReg_2012Jul13ReReco_branch = the_tree.GetBranch("e2PhiCorrReg_2012Jul13ReReco")
        #if not self.e2PhiCorrReg_2012Jul13ReReco_branch and "e2PhiCorrReg_2012Jul13ReReco" not in self.complained:
        if not self.e2PhiCorrReg_2012Jul13ReReco_branch and "e2PhiCorrReg_2012Jul13ReReco":
            warnings.warn( "EETauTauTree: Expected branch e2PhiCorrReg_2012Jul13ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2PhiCorrReg_2012Jul13ReReco")
        else:
            self.e2PhiCorrReg_2012Jul13ReReco_branch.SetAddress(<void*>&self.e2PhiCorrReg_2012Jul13ReReco_value)

        #print "making e2PhiCorrReg_Fall11"
        self.e2PhiCorrReg_Fall11_branch = the_tree.GetBranch("e2PhiCorrReg_Fall11")
        #if not self.e2PhiCorrReg_Fall11_branch and "e2PhiCorrReg_Fall11" not in self.complained:
        if not self.e2PhiCorrReg_Fall11_branch and "e2PhiCorrReg_Fall11":
            warnings.warn( "EETauTauTree: Expected branch e2PhiCorrReg_Fall11 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2PhiCorrReg_Fall11")
        else:
            self.e2PhiCorrReg_Fall11_branch.SetAddress(<void*>&self.e2PhiCorrReg_Fall11_value)

        #print "making e2PhiCorrReg_Jan16ReReco"
        self.e2PhiCorrReg_Jan16ReReco_branch = the_tree.GetBranch("e2PhiCorrReg_Jan16ReReco")
        #if not self.e2PhiCorrReg_Jan16ReReco_branch and "e2PhiCorrReg_Jan16ReReco" not in self.complained:
        if not self.e2PhiCorrReg_Jan16ReReco_branch and "e2PhiCorrReg_Jan16ReReco":
            warnings.warn( "EETauTauTree: Expected branch e2PhiCorrReg_Jan16ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2PhiCorrReg_Jan16ReReco")
        else:
            self.e2PhiCorrReg_Jan16ReReco_branch.SetAddress(<void*>&self.e2PhiCorrReg_Jan16ReReco_value)

        #print "making e2PhiCorrReg_Summer12_DR53X_HCP2012"
        self.e2PhiCorrReg_Summer12_DR53X_HCP2012_branch = the_tree.GetBranch("e2PhiCorrReg_Summer12_DR53X_HCP2012")
        #if not self.e2PhiCorrReg_Summer12_DR53X_HCP2012_branch and "e2PhiCorrReg_Summer12_DR53X_HCP2012" not in self.complained:
        if not self.e2PhiCorrReg_Summer12_DR53X_HCP2012_branch and "e2PhiCorrReg_Summer12_DR53X_HCP2012":
            warnings.warn( "EETauTauTree: Expected branch e2PhiCorrReg_Summer12_DR53X_HCP2012 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2PhiCorrReg_Summer12_DR53X_HCP2012")
        else:
            self.e2PhiCorrReg_Summer12_DR53X_HCP2012_branch.SetAddress(<void*>&self.e2PhiCorrReg_Summer12_DR53X_HCP2012_value)

        #print "making e2PhiCorrSmearedNoReg_2012Jul13ReReco"
        self.e2PhiCorrSmearedNoReg_2012Jul13ReReco_branch = the_tree.GetBranch("e2PhiCorrSmearedNoReg_2012Jul13ReReco")
        #if not self.e2PhiCorrSmearedNoReg_2012Jul13ReReco_branch and "e2PhiCorrSmearedNoReg_2012Jul13ReReco" not in self.complained:
        if not self.e2PhiCorrSmearedNoReg_2012Jul13ReReco_branch and "e2PhiCorrSmearedNoReg_2012Jul13ReReco":
            warnings.warn( "EETauTauTree: Expected branch e2PhiCorrSmearedNoReg_2012Jul13ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2PhiCorrSmearedNoReg_2012Jul13ReReco")
        else:
            self.e2PhiCorrSmearedNoReg_2012Jul13ReReco_branch.SetAddress(<void*>&self.e2PhiCorrSmearedNoReg_2012Jul13ReReco_value)

        #print "making e2PhiCorrSmearedNoReg_Fall11"
        self.e2PhiCorrSmearedNoReg_Fall11_branch = the_tree.GetBranch("e2PhiCorrSmearedNoReg_Fall11")
        #if not self.e2PhiCorrSmearedNoReg_Fall11_branch and "e2PhiCorrSmearedNoReg_Fall11" not in self.complained:
        if not self.e2PhiCorrSmearedNoReg_Fall11_branch and "e2PhiCorrSmearedNoReg_Fall11":
            warnings.warn( "EETauTauTree: Expected branch e2PhiCorrSmearedNoReg_Fall11 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2PhiCorrSmearedNoReg_Fall11")
        else:
            self.e2PhiCorrSmearedNoReg_Fall11_branch.SetAddress(<void*>&self.e2PhiCorrSmearedNoReg_Fall11_value)

        #print "making e2PhiCorrSmearedNoReg_Jan16ReReco"
        self.e2PhiCorrSmearedNoReg_Jan16ReReco_branch = the_tree.GetBranch("e2PhiCorrSmearedNoReg_Jan16ReReco")
        #if not self.e2PhiCorrSmearedNoReg_Jan16ReReco_branch and "e2PhiCorrSmearedNoReg_Jan16ReReco" not in self.complained:
        if not self.e2PhiCorrSmearedNoReg_Jan16ReReco_branch and "e2PhiCorrSmearedNoReg_Jan16ReReco":
            warnings.warn( "EETauTauTree: Expected branch e2PhiCorrSmearedNoReg_Jan16ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2PhiCorrSmearedNoReg_Jan16ReReco")
        else:
            self.e2PhiCorrSmearedNoReg_Jan16ReReco_branch.SetAddress(<void*>&self.e2PhiCorrSmearedNoReg_Jan16ReReco_value)

        #print "making e2PhiCorrSmearedNoReg_Summer12_DR53X_HCP2012"
        self.e2PhiCorrSmearedNoReg_Summer12_DR53X_HCP2012_branch = the_tree.GetBranch("e2PhiCorrSmearedNoReg_Summer12_DR53X_HCP2012")
        #if not self.e2PhiCorrSmearedNoReg_Summer12_DR53X_HCP2012_branch and "e2PhiCorrSmearedNoReg_Summer12_DR53X_HCP2012" not in self.complained:
        if not self.e2PhiCorrSmearedNoReg_Summer12_DR53X_HCP2012_branch and "e2PhiCorrSmearedNoReg_Summer12_DR53X_HCP2012":
            warnings.warn( "EETauTauTree: Expected branch e2PhiCorrSmearedNoReg_Summer12_DR53X_HCP2012 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2PhiCorrSmearedNoReg_Summer12_DR53X_HCP2012")
        else:
            self.e2PhiCorrSmearedNoReg_Summer12_DR53X_HCP2012_branch.SetAddress(<void*>&self.e2PhiCorrSmearedNoReg_Summer12_DR53X_HCP2012_value)

        #print "making e2PhiCorrSmearedReg_2012Jul13ReReco"
        self.e2PhiCorrSmearedReg_2012Jul13ReReco_branch = the_tree.GetBranch("e2PhiCorrSmearedReg_2012Jul13ReReco")
        #if not self.e2PhiCorrSmearedReg_2012Jul13ReReco_branch and "e2PhiCorrSmearedReg_2012Jul13ReReco" not in self.complained:
        if not self.e2PhiCorrSmearedReg_2012Jul13ReReco_branch and "e2PhiCorrSmearedReg_2012Jul13ReReco":
            warnings.warn( "EETauTauTree: Expected branch e2PhiCorrSmearedReg_2012Jul13ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2PhiCorrSmearedReg_2012Jul13ReReco")
        else:
            self.e2PhiCorrSmearedReg_2012Jul13ReReco_branch.SetAddress(<void*>&self.e2PhiCorrSmearedReg_2012Jul13ReReco_value)

        #print "making e2PhiCorrSmearedReg_Fall11"
        self.e2PhiCorrSmearedReg_Fall11_branch = the_tree.GetBranch("e2PhiCorrSmearedReg_Fall11")
        #if not self.e2PhiCorrSmearedReg_Fall11_branch and "e2PhiCorrSmearedReg_Fall11" not in self.complained:
        if not self.e2PhiCorrSmearedReg_Fall11_branch and "e2PhiCorrSmearedReg_Fall11":
            warnings.warn( "EETauTauTree: Expected branch e2PhiCorrSmearedReg_Fall11 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2PhiCorrSmearedReg_Fall11")
        else:
            self.e2PhiCorrSmearedReg_Fall11_branch.SetAddress(<void*>&self.e2PhiCorrSmearedReg_Fall11_value)

        #print "making e2PhiCorrSmearedReg_Jan16ReReco"
        self.e2PhiCorrSmearedReg_Jan16ReReco_branch = the_tree.GetBranch("e2PhiCorrSmearedReg_Jan16ReReco")
        #if not self.e2PhiCorrSmearedReg_Jan16ReReco_branch and "e2PhiCorrSmearedReg_Jan16ReReco" not in self.complained:
        if not self.e2PhiCorrSmearedReg_Jan16ReReco_branch and "e2PhiCorrSmearedReg_Jan16ReReco":
            warnings.warn( "EETauTauTree: Expected branch e2PhiCorrSmearedReg_Jan16ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2PhiCorrSmearedReg_Jan16ReReco")
        else:
            self.e2PhiCorrSmearedReg_Jan16ReReco_branch.SetAddress(<void*>&self.e2PhiCorrSmearedReg_Jan16ReReco_value)

        #print "making e2PhiCorrSmearedReg_Summer12_DR53X_HCP2012"
        self.e2PhiCorrSmearedReg_Summer12_DR53X_HCP2012_branch = the_tree.GetBranch("e2PhiCorrSmearedReg_Summer12_DR53X_HCP2012")
        #if not self.e2PhiCorrSmearedReg_Summer12_DR53X_HCP2012_branch and "e2PhiCorrSmearedReg_Summer12_DR53X_HCP2012" not in self.complained:
        if not self.e2PhiCorrSmearedReg_Summer12_DR53X_HCP2012_branch and "e2PhiCorrSmearedReg_Summer12_DR53X_HCP2012":
            warnings.warn( "EETauTauTree: Expected branch e2PhiCorrSmearedReg_Summer12_DR53X_HCP2012 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2PhiCorrSmearedReg_Summer12_DR53X_HCP2012")
        else:
            self.e2PhiCorrSmearedReg_Summer12_DR53X_HCP2012_branch.SetAddress(<void*>&self.e2PhiCorrSmearedReg_Summer12_DR53X_HCP2012_value)

        #print "making e2Pt"
        self.e2Pt_branch = the_tree.GetBranch("e2Pt")
        #if not self.e2Pt_branch and "e2Pt" not in self.complained:
        if not self.e2Pt_branch and "e2Pt":
            warnings.warn( "EETauTauTree: Expected branch e2Pt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2Pt")
        else:
            self.e2Pt_branch.SetAddress(<void*>&self.e2Pt_value)

        #print "making e2PtCorrReg_2012Jul13ReReco"
        self.e2PtCorrReg_2012Jul13ReReco_branch = the_tree.GetBranch("e2PtCorrReg_2012Jul13ReReco")
        #if not self.e2PtCorrReg_2012Jul13ReReco_branch and "e2PtCorrReg_2012Jul13ReReco" not in self.complained:
        if not self.e2PtCorrReg_2012Jul13ReReco_branch and "e2PtCorrReg_2012Jul13ReReco":
            warnings.warn( "EETauTauTree: Expected branch e2PtCorrReg_2012Jul13ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2PtCorrReg_2012Jul13ReReco")
        else:
            self.e2PtCorrReg_2012Jul13ReReco_branch.SetAddress(<void*>&self.e2PtCorrReg_2012Jul13ReReco_value)

        #print "making e2PtCorrReg_Fall11"
        self.e2PtCorrReg_Fall11_branch = the_tree.GetBranch("e2PtCorrReg_Fall11")
        #if not self.e2PtCorrReg_Fall11_branch and "e2PtCorrReg_Fall11" not in self.complained:
        if not self.e2PtCorrReg_Fall11_branch and "e2PtCorrReg_Fall11":
            warnings.warn( "EETauTauTree: Expected branch e2PtCorrReg_Fall11 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2PtCorrReg_Fall11")
        else:
            self.e2PtCorrReg_Fall11_branch.SetAddress(<void*>&self.e2PtCorrReg_Fall11_value)

        #print "making e2PtCorrReg_Jan16ReReco"
        self.e2PtCorrReg_Jan16ReReco_branch = the_tree.GetBranch("e2PtCorrReg_Jan16ReReco")
        #if not self.e2PtCorrReg_Jan16ReReco_branch and "e2PtCorrReg_Jan16ReReco" not in self.complained:
        if not self.e2PtCorrReg_Jan16ReReco_branch and "e2PtCorrReg_Jan16ReReco":
            warnings.warn( "EETauTauTree: Expected branch e2PtCorrReg_Jan16ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2PtCorrReg_Jan16ReReco")
        else:
            self.e2PtCorrReg_Jan16ReReco_branch.SetAddress(<void*>&self.e2PtCorrReg_Jan16ReReco_value)

        #print "making e2PtCorrReg_Summer12_DR53X_HCP2012"
        self.e2PtCorrReg_Summer12_DR53X_HCP2012_branch = the_tree.GetBranch("e2PtCorrReg_Summer12_DR53X_HCP2012")
        #if not self.e2PtCorrReg_Summer12_DR53X_HCP2012_branch and "e2PtCorrReg_Summer12_DR53X_HCP2012" not in self.complained:
        if not self.e2PtCorrReg_Summer12_DR53X_HCP2012_branch and "e2PtCorrReg_Summer12_DR53X_HCP2012":
            warnings.warn( "EETauTauTree: Expected branch e2PtCorrReg_Summer12_DR53X_HCP2012 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2PtCorrReg_Summer12_DR53X_HCP2012")
        else:
            self.e2PtCorrReg_Summer12_DR53X_HCP2012_branch.SetAddress(<void*>&self.e2PtCorrReg_Summer12_DR53X_HCP2012_value)

        #print "making e2PtCorrSmearedNoReg_2012Jul13ReReco"
        self.e2PtCorrSmearedNoReg_2012Jul13ReReco_branch = the_tree.GetBranch("e2PtCorrSmearedNoReg_2012Jul13ReReco")
        #if not self.e2PtCorrSmearedNoReg_2012Jul13ReReco_branch and "e2PtCorrSmearedNoReg_2012Jul13ReReco" not in self.complained:
        if not self.e2PtCorrSmearedNoReg_2012Jul13ReReco_branch and "e2PtCorrSmearedNoReg_2012Jul13ReReco":
            warnings.warn( "EETauTauTree: Expected branch e2PtCorrSmearedNoReg_2012Jul13ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2PtCorrSmearedNoReg_2012Jul13ReReco")
        else:
            self.e2PtCorrSmearedNoReg_2012Jul13ReReco_branch.SetAddress(<void*>&self.e2PtCorrSmearedNoReg_2012Jul13ReReco_value)

        #print "making e2PtCorrSmearedNoReg_Fall11"
        self.e2PtCorrSmearedNoReg_Fall11_branch = the_tree.GetBranch("e2PtCorrSmearedNoReg_Fall11")
        #if not self.e2PtCorrSmearedNoReg_Fall11_branch and "e2PtCorrSmearedNoReg_Fall11" not in self.complained:
        if not self.e2PtCorrSmearedNoReg_Fall11_branch and "e2PtCorrSmearedNoReg_Fall11":
            warnings.warn( "EETauTauTree: Expected branch e2PtCorrSmearedNoReg_Fall11 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2PtCorrSmearedNoReg_Fall11")
        else:
            self.e2PtCorrSmearedNoReg_Fall11_branch.SetAddress(<void*>&self.e2PtCorrSmearedNoReg_Fall11_value)

        #print "making e2PtCorrSmearedNoReg_Jan16ReReco"
        self.e2PtCorrSmearedNoReg_Jan16ReReco_branch = the_tree.GetBranch("e2PtCorrSmearedNoReg_Jan16ReReco")
        #if not self.e2PtCorrSmearedNoReg_Jan16ReReco_branch and "e2PtCorrSmearedNoReg_Jan16ReReco" not in self.complained:
        if not self.e2PtCorrSmearedNoReg_Jan16ReReco_branch and "e2PtCorrSmearedNoReg_Jan16ReReco":
            warnings.warn( "EETauTauTree: Expected branch e2PtCorrSmearedNoReg_Jan16ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2PtCorrSmearedNoReg_Jan16ReReco")
        else:
            self.e2PtCorrSmearedNoReg_Jan16ReReco_branch.SetAddress(<void*>&self.e2PtCorrSmearedNoReg_Jan16ReReco_value)

        #print "making e2PtCorrSmearedNoReg_Summer12_DR53X_HCP2012"
        self.e2PtCorrSmearedNoReg_Summer12_DR53X_HCP2012_branch = the_tree.GetBranch("e2PtCorrSmearedNoReg_Summer12_DR53X_HCP2012")
        #if not self.e2PtCorrSmearedNoReg_Summer12_DR53X_HCP2012_branch and "e2PtCorrSmearedNoReg_Summer12_DR53X_HCP2012" not in self.complained:
        if not self.e2PtCorrSmearedNoReg_Summer12_DR53X_HCP2012_branch and "e2PtCorrSmearedNoReg_Summer12_DR53X_HCP2012":
            warnings.warn( "EETauTauTree: Expected branch e2PtCorrSmearedNoReg_Summer12_DR53X_HCP2012 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2PtCorrSmearedNoReg_Summer12_DR53X_HCP2012")
        else:
            self.e2PtCorrSmearedNoReg_Summer12_DR53X_HCP2012_branch.SetAddress(<void*>&self.e2PtCorrSmearedNoReg_Summer12_DR53X_HCP2012_value)

        #print "making e2PtCorrSmearedReg_2012Jul13ReReco"
        self.e2PtCorrSmearedReg_2012Jul13ReReco_branch = the_tree.GetBranch("e2PtCorrSmearedReg_2012Jul13ReReco")
        #if not self.e2PtCorrSmearedReg_2012Jul13ReReco_branch and "e2PtCorrSmearedReg_2012Jul13ReReco" not in self.complained:
        if not self.e2PtCorrSmearedReg_2012Jul13ReReco_branch and "e2PtCorrSmearedReg_2012Jul13ReReco":
            warnings.warn( "EETauTauTree: Expected branch e2PtCorrSmearedReg_2012Jul13ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2PtCorrSmearedReg_2012Jul13ReReco")
        else:
            self.e2PtCorrSmearedReg_2012Jul13ReReco_branch.SetAddress(<void*>&self.e2PtCorrSmearedReg_2012Jul13ReReco_value)

        #print "making e2PtCorrSmearedReg_Fall11"
        self.e2PtCorrSmearedReg_Fall11_branch = the_tree.GetBranch("e2PtCorrSmearedReg_Fall11")
        #if not self.e2PtCorrSmearedReg_Fall11_branch and "e2PtCorrSmearedReg_Fall11" not in self.complained:
        if not self.e2PtCorrSmearedReg_Fall11_branch and "e2PtCorrSmearedReg_Fall11":
            warnings.warn( "EETauTauTree: Expected branch e2PtCorrSmearedReg_Fall11 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2PtCorrSmearedReg_Fall11")
        else:
            self.e2PtCorrSmearedReg_Fall11_branch.SetAddress(<void*>&self.e2PtCorrSmearedReg_Fall11_value)

        #print "making e2PtCorrSmearedReg_Jan16ReReco"
        self.e2PtCorrSmearedReg_Jan16ReReco_branch = the_tree.GetBranch("e2PtCorrSmearedReg_Jan16ReReco")
        #if not self.e2PtCorrSmearedReg_Jan16ReReco_branch and "e2PtCorrSmearedReg_Jan16ReReco" not in self.complained:
        if not self.e2PtCorrSmearedReg_Jan16ReReco_branch and "e2PtCorrSmearedReg_Jan16ReReco":
            warnings.warn( "EETauTauTree: Expected branch e2PtCorrSmearedReg_Jan16ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2PtCorrSmearedReg_Jan16ReReco")
        else:
            self.e2PtCorrSmearedReg_Jan16ReReco_branch.SetAddress(<void*>&self.e2PtCorrSmearedReg_Jan16ReReco_value)

        #print "making e2PtCorrSmearedReg_Summer12_DR53X_HCP2012"
        self.e2PtCorrSmearedReg_Summer12_DR53X_HCP2012_branch = the_tree.GetBranch("e2PtCorrSmearedReg_Summer12_DR53X_HCP2012")
        #if not self.e2PtCorrSmearedReg_Summer12_DR53X_HCP2012_branch and "e2PtCorrSmearedReg_Summer12_DR53X_HCP2012" not in self.complained:
        if not self.e2PtCorrSmearedReg_Summer12_DR53X_HCP2012_branch and "e2PtCorrSmearedReg_Summer12_DR53X_HCP2012":
            warnings.warn( "EETauTauTree: Expected branch e2PtCorrSmearedReg_Summer12_DR53X_HCP2012 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2PtCorrSmearedReg_Summer12_DR53X_HCP2012")
        else:
            self.e2PtCorrSmearedReg_Summer12_DR53X_HCP2012_branch.SetAddress(<void*>&self.e2PtCorrSmearedReg_Summer12_DR53X_HCP2012_value)

        #print "making e2Rank"
        self.e2Rank_branch = the_tree.GetBranch("e2Rank")
        #if not self.e2Rank_branch and "e2Rank" not in self.complained:
        if not self.e2Rank_branch and "e2Rank":
            warnings.warn( "EETauTauTree: Expected branch e2Rank does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2Rank")
        else:
            self.e2Rank_branch.SetAddress(<void*>&self.e2Rank_value)

        #print "making e2RelIso"
        self.e2RelIso_branch = the_tree.GetBranch("e2RelIso")
        #if not self.e2RelIso_branch and "e2RelIso" not in self.complained:
        if not self.e2RelIso_branch and "e2RelIso":
            warnings.warn( "EETauTauTree: Expected branch e2RelIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2RelIso")
        else:
            self.e2RelIso_branch.SetAddress(<void*>&self.e2RelIso_value)

        #print "making e2RelPFIsoDB"
        self.e2RelPFIsoDB_branch = the_tree.GetBranch("e2RelPFIsoDB")
        #if not self.e2RelPFIsoDB_branch and "e2RelPFIsoDB" not in self.complained:
        if not self.e2RelPFIsoDB_branch and "e2RelPFIsoDB":
            warnings.warn( "EETauTauTree: Expected branch e2RelPFIsoDB does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2RelPFIsoDB")
        else:
            self.e2RelPFIsoDB_branch.SetAddress(<void*>&self.e2RelPFIsoDB_value)

        #print "making e2RelPFIsoRho"
        self.e2RelPFIsoRho_branch = the_tree.GetBranch("e2RelPFIsoRho")
        #if not self.e2RelPFIsoRho_branch and "e2RelPFIsoRho" not in self.complained:
        if not self.e2RelPFIsoRho_branch and "e2RelPFIsoRho":
            warnings.warn( "EETauTauTree: Expected branch e2RelPFIsoRho does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2RelPFIsoRho")
        else:
            self.e2RelPFIsoRho_branch.SetAddress(<void*>&self.e2RelPFIsoRho_value)

        #print "making e2RelPFIsoRhoFSR"
        self.e2RelPFIsoRhoFSR_branch = the_tree.GetBranch("e2RelPFIsoRhoFSR")
        #if not self.e2RelPFIsoRhoFSR_branch and "e2RelPFIsoRhoFSR" not in self.complained:
        if not self.e2RelPFIsoRhoFSR_branch and "e2RelPFIsoRhoFSR":
            warnings.warn( "EETauTauTree: Expected branch e2RelPFIsoRhoFSR does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2RelPFIsoRhoFSR")
        else:
            self.e2RelPFIsoRhoFSR_branch.SetAddress(<void*>&self.e2RelPFIsoRhoFSR_value)

        #print "making e2RhoHZG2011"
        self.e2RhoHZG2011_branch = the_tree.GetBranch("e2RhoHZG2011")
        #if not self.e2RhoHZG2011_branch and "e2RhoHZG2011" not in self.complained:
        if not self.e2RhoHZG2011_branch and "e2RhoHZG2011":
            warnings.warn( "EETauTauTree: Expected branch e2RhoHZG2011 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2RhoHZG2011")
        else:
            self.e2RhoHZG2011_branch.SetAddress(<void*>&self.e2RhoHZG2011_value)

        #print "making e2RhoHZG2012"
        self.e2RhoHZG2012_branch = the_tree.GetBranch("e2RhoHZG2012")
        #if not self.e2RhoHZG2012_branch and "e2RhoHZG2012" not in self.complained:
        if not self.e2RhoHZG2012_branch and "e2RhoHZG2012":
            warnings.warn( "EETauTauTree: Expected branch e2RhoHZG2012 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2RhoHZG2012")
        else:
            self.e2RhoHZG2012_branch.SetAddress(<void*>&self.e2RhoHZG2012_value)

        #print "making e2SCEnergy"
        self.e2SCEnergy_branch = the_tree.GetBranch("e2SCEnergy")
        #if not self.e2SCEnergy_branch and "e2SCEnergy" not in self.complained:
        if not self.e2SCEnergy_branch and "e2SCEnergy":
            warnings.warn( "EETauTauTree: Expected branch e2SCEnergy does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2SCEnergy")
        else:
            self.e2SCEnergy_branch.SetAddress(<void*>&self.e2SCEnergy_value)

        #print "making e2SCEta"
        self.e2SCEta_branch = the_tree.GetBranch("e2SCEta")
        #if not self.e2SCEta_branch and "e2SCEta" not in self.complained:
        if not self.e2SCEta_branch and "e2SCEta":
            warnings.warn( "EETauTauTree: Expected branch e2SCEta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2SCEta")
        else:
            self.e2SCEta_branch.SetAddress(<void*>&self.e2SCEta_value)

        #print "making e2SCEtaWidth"
        self.e2SCEtaWidth_branch = the_tree.GetBranch("e2SCEtaWidth")
        #if not self.e2SCEtaWidth_branch and "e2SCEtaWidth" not in self.complained:
        if not self.e2SCEtaWidth_branch and "e2SCEtaWidth":
            warnings.warn( "EETauTauTree: Expected branch e2SCEtaWidth does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2SCEtaWidth")
        else:
            self.e2SCEtaWidth_branch.SetAddress(<void*>&self.e2SCEtaWidth_value)

        #print "making e2SCPhi"
        self.e2SCPhi_branch = the_tree.GetBranch("e2SCPhi")
        #if not self.e2SCPhi_branch and "e2SCPhi" not in self.complained:
        if not self.e2SCPhi_branch and "e2SCPhi":
            warnings.warn( "EETauTauTree: Expected branch e2SCPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2SCPhi")
        else:
            self.e2SCPhi_branch.SetAddress(<void*>&self.e2SCPhi_value)

        #print "making e2SCPhiWidth"
        self.e2SCPhiWidth_branch = the_tree.GetBranch("e2SCPhiWidth")
        #if not self.e2SCPhiWidth_branch and "e2SCPhiWidth" not in self.complained:
        if not self.e2SCPhiWidth_branch and "e2SCPhiWidth":
            warnings.warn( "EETauTauTree: Expected branch e2SCPhiWidth does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2SCPhiWidth")
        else:
            self.e2SCPhiWidth_branch.SetAddress(<void*>&self.e2SCPhiWidth_value)

        #print "making e2SCPreshowerEnergy"
        self.e2SCPreshowerEnergy_branch = the_tree.GetBranch("e2SCPreshowerEnergy")
        #if not self.e2SCPreshowerEnergy_branch and "e2SCPreshowerEnergy" not in self.complained:
        if not self.e2SCPreshowerEnergy_branch and "e2SCPreshowerEnergy":
            warnings.warn( "EETauTauTree: Expected branch e2SCPreshowerEnergy does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2SCPreshowerEnergy")
        else:
            self.e2SCPreshowerEnergy_branch.SetAddress(<void*>&self.e2SCPreshowerEnergy_value)

        #print "making e2SCRawEnergy"
        self.e2SCRawEnergy_branch = the_tree.GetBranch("e2SCRawEnergy")
        #if not self.e2SCRawEnergy_branch and "e2SCRawEnergy" not in self.complained:
        if not self.e2SCRawEnergy_branch and "e2SCRawEnergy":
            warnings.warn( "EETauTauTree: Expected branch e2SCRawEnergy does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2SCRawEnergy")
        else:
            self.e2SCRawEnergy_branch.SetAddress(<void*>&self.e2SCRawEnergy_value)

        #print "making e2SigmaIEtaIEta"
        self.e2SigmaIEtaIEta_branch = the_tree.GetBranch("e2SigmaIEtaIEta")
        #if not self.e2SigmaIEtaIEta_branch and "e2SigmaIEtaIEta" not in self.complained:
        if not self.e2SigmaIEtaIEta_branch and "e2SigmaIEtaIEta":
            warnings.warn( "EETauTauTree: Expected branch e2SigmaIEtaIEta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2SigmaIEtaIEta")
        else:
            self.e2SigmaIEtaIEta_branch.SetAddress(<void*>&self.e2SigmaIEtaIEta_value)

        #print "making e2ToMETDPhi"
        self.e2ToMETDPhi_branch = the_tree.GetBranch("e2ToMETDPhi")
        #if not self.e2ToMETDPhi_branch and "e2ToMETDPhi" not in self.complained:
        if not self.e2ToMETDPhi_branch and "e2ToMETDPhi":
            warnings.warn( "EETauTauTree: Expected branch e2ToMETDPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2ToMETDPhi")
        else:
            self.e2ToMETDPhi_branch.SetAddress(<void*>&self.e2ToMETDPhi_value)

        #print "making e2TrkIsoDR03"
        self.e2TrkIsoDR03_branch = the_tree.GetBranch("e2TrkIsoDR03")
        #if not self.e2TrkIsoDR03_branch and "e2TrkIsoDR03" not in self.complained:
        if not self.e2TrkIsoDR03_branch and "e2TrkIsoDR03":
            warnings.warn( "EETauTauTree: Expected branch e2TrkIsoDR03 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2TrkIsoDR03")
        else:
            self.e2TrkIsoDR03_branch.SetAddress(<void*>&self.e2TrkIsoDR03_value)

        #print "making e2VZ"
        self.e2VZ_branch = the_tree.GetBranch("e2VZ")
        #if not self.e2VZ_branch and "e2VZ" not in self.complained:
        if not self.e2VZ_branch and "e2VZ":
            warnings.warn( "EETauTauTree: Expected branch e2VZ does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2VZ")
        else:
            self.e2VZ_branch.SetAddress(<void*>&self.e2VZ_value)

        #print "making e2WWID"
        self.e2WWID_branch = the_tree.GetBranch("e2WWID")
        #if not self.e2WWID_branch and "e2WWID" not in self.complained:
        if not self.e2WWID_branch and "e2WWID":
            warnings.warn( "EETauTauTree: Expected branch e2WWID does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2WWID")
        else:
            self.e2WWID_branch.SetAddress(<void*>&self.e2WWID_value)

        #print "making e2_t1_CosThetaStar"
        self.e2_t1_CosThetaStar_branch = the_tree.GetBranch("e2_t1_CosThetaStar")
        #if not self.e2_t1_CosThetaStar_branch and "e2_t1_CosThetaStar" not in self.complained:
        if not self.e2_t1_CosThetaStar_branch and "e2_t1_CosThetaStar":
            warnings.warn( "EETauTauTree: Expected branch e2_t1_CosThetaStar does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2_t1_CosThetaStar")
        else:
            self.e2_t1_CosThetaStar_branch.SetAddress(<void*>&self.e2_t1_CosThetaStar_value)

        #print "making e2_t1_DPhi"
        self.e2_t1_DPhi_branch = the_tree.GetBranch("e2_t1_DPhi")
        #if not self.e2_t1_DPhi_branch and "e2_t1_DPhi" not in self.complained:
        if not self.e2_t1_DPhi_branch and "e2_t1_DPhi":
            warnings.warn( "EETauTauTree: Expected branch e2_t1_DPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2_t1_DPhi")
        else:
            self.e2_t1_DPhi_branch.SetAddress(<void*>&self.e2_t1_DPhi_value)

        #print "making e2_t1_DR"
        self.e2_t1_DR_branch = the_tree.GetBranch("e2_t1_DR")
        #if not self.e2_t1_DR_branch and "e2_t1_DR" not in self.complained:
        if not self.e2_t1_DR_branch and "e2_t1_DR":
            warnings.warn( "EETauTauTree: Expected branch e2_t1_DR does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2_t1_DR")
        else:
            self.e2_t1_DR_branch.SetAddress(<void*>&self.e2_t1_DR_value)

        #print "making e2_t1_Eta"
        self.e2_t1_Eta_branch = the_tree.GetBranch("e2_t1_Eta")
        #if not self.e2_t1_Eta_branch and "e2_t1_Eta" not in self.complained:
        if not self.e2_t1_Eta_branch and "e2_t1_Eta":
            warnings.warn( "EETauTauTree: Expected branch e2_t1_Eta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2_t1_Eta")
        else:
            self.e2_t1_Eta_branch.SetAddress(<void*>&self.e2_t1_Eta_value)

        #print "making e2_t1_Mass"
        self.e2_t1_Mass_branch = the_tree.GetBranch("e2_t1_Mass")
        #if not self.e2_t1_Mass_branch and "e2_t1_Mass" not in self.complained:
        if not self.e2_t1_Mass_branch and "e2_t1_Mass":
            warnings.warn( "EETauTauTree: Expected branch e2_t1_Mass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2_t1_Mass")
        else:
            self.e2_t1_Mass_branch.SetAddress(<void*>&self.e2_t1_Mass_value)

        #print "making e2_t1_MassFsr"
        self.e2_t1_MassFsr_branch = the_tree.GetBranch("e2_t1_MassFsr")
        #if not self.e2_t1_MassFsr_branch and "e2_t1_MassFsr" not in self.complained:
        if not self.e2_t1_MassFsr_branch and "e2_t1_MassFsr":
            warnings.warn( "EETauTauTree: Expected branch e2_t1_MassFsr does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2_t1_MassFsr")
        else:
            self.e2_t1_MassFsr_branch.SetAddress(<void*>&self.e2_t1_MassFsr_value)

        #print "making e2_t1_PZeta"
        self.e2_t1_PZeta_branch = the_tree.GetBranch("e2_t1_PZeta")
        #if not self.e2_t1_PZeta_branch and "e2_t1_PZeta" not in self.complained:
        if not self.e2_t1_PZeta_branch and "e2_t1_PZeta":
            warnings.warn( "EETauTauTree: Expected branch e2_t1_PZeta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2_t1_PZeta")
        else:
            self.e2_t1_PZeta_branch.SetAddress(<void*>&self.e2_t1_PZeta_value)

        #print "making e2_t1_PZetaVis"
        self.e2_t1_PZetaVis_branch = the_tree.GetBranch("e2_t1_PZetaVis")
        #if not self.e2_t1_PZetaVis_branch and "e2_t1_PZetaVis" not in self.complained:
        if not self.e2_t1_PZetaVis_branch and "e2_t1_PZetaVis":
            warnings.warn( "EETauTauTree: Expected branch e2_t1_PZetaVis does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2_t1_PZetaVis")
        else:
            self.e2_t1_PZetaVis_branch.SetAddress(<void*>&self.e2_t1_PZetaVis_value)

        #print "making e2_t1_Phi"
        self.e2_t1_Phi_branch = the_tree.GetBranch("e2_t1_Phi")
        #if not self.e2_t1_Phi_branch and "e2_t1_Phi" not in self.complained:
        if not self.e2_t1_Phi_branch and "e2_t1_Phi":
            warnings.warn( "EETauTauTree: Expected branch e2_t1_Phi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2_t1_Phi")
        else:
            self.e2_t1_Phi_branch.SetAddress(<void*>&self.e2_t1_Phi_value)

        #print "making e2_t1_Pt"
        self.e2_t1_Pt_branch = the_tree.GetBranch("e2_t1_Pt")
        #if not self.e2_t1_Pt_branch and "e2_t1_Pt" not in self.complained:
        if not self.e2_t1_Pt_branch and "e2_t1_Pt":
            warnings.warn( "EETauTauTree: Expected branch e2_t1_Pt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2_t1_Pt")
        else:
            self.e2_t1_Pt_branch.SetAddress(<void*>&self.e2_t1_Pt_value)

        #print "making e2_t1_PtFsr"
        self.e2_t1_PtFsr_branch = the_tree.GetBranch("e2_t1_PtFsr")
        #if not self.e2_t1_PtFsr_branch and "e2_t1_PtFsr" not in self.complained:
        if not self.e2_t1_PtFsr_branch and "e2_t1_PtFsr":
            warnings.warn( "EETauTauTree: Expected branch e2_t1_PtFsr does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2_t1_PtFsr")
        else:
            self.e2_t1_PtFsr_branch.SetAddress(<void*>&self.e2_t1_PtFsr_value)

        #print "making e2_t1_SS"
        self.e2_t1_SS_branch = the_tree.GetBranch("e2_t1_SS")
        #if not self.e2_t1_SS_branch and "e2_t1_SS" not in self.complained:
        if not self.e2_t1_SS_branch and "e2_t1_SS":
            warnings.warn( "EETauTauTree: Expected branch e2_t1_SS does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2_t1_SS")
        else:
            self.e2_t1_SS_branch.SetAddress(<void*>&self.e2_t1_SS_value)

        #print "making e2_t1_ToMETDPhi_Ty1"
        self.e2_t1_ToMETDPhi_Ty1_branch = the_tree.GetBranch("e2_t1_ToMETDPhi_Ty1")
        #if not self.e2_t1_ToMETDPhi_Ty1_branch and "e2_t1_ToMETDPhi_Ty1" not in self.complained:
        if not self.e2_t1_ToMETDPhi_Ty1_branch and "e2_t1_ToMETDPhi_Ty1":
            warnings.warn( "EETauTauTree: Expected branch e2_t1_ToMETDPhi_Ty1 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2_t1_ToMETDPhi_Ty1")
        else:
            self.e2_t1_ToMETDPhi_Ty1_branch.SetAddress(<void*>&self.e2_t1_ToMETDPhi_Ty1_value)

        #print "making e2_t1_Zcompat"
        self.e2_t1_Zcompat_branch = the_tree.GetBranch("e2_t1_Zcompat")
        #if not self.e2_t1_Zcompat_branch and "e2_t1_Zcompat" not in self.complained:
        if not self.e2_t1_Zcompat_branch and "e2_t1_Zcompat":
            warnings.warn( "EETauTauTree: Expected branch e2_t1_Zcompat does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2_t1_Zcompat")
        else:
            self.e2_t1_Zcompat_branch.SetAddress(<void*>&self.e2_t1_Zcompat_value)

        #print "making e2_t2_CosThetaStar"
        self.e2_t2_CosThetaStar_branch = the_tree.GetBranch("e2_t2_CosThetaStar")
        #if not self.e2_t2_CosThetaStar_branch and "e2_t2_CosThetaStar" not in self.complained:
        if not self.e2_t2_CosThetaStar_branch and "e2_t2_CosThetaStar":
            warnings.warn( "EETauTauTree: Expected branch e2_t2_CosThetaStar does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2_t2_CosThetaStar")
        else:
            self.e2_t2_CosThetaStar_branch.SetAddress(<void*>&self.e2_t2_CosThetaStar_value)

        #print "making e2_t2_DPhi"
        self.e2_t2_DPhi_branch = the_tree.GetBranch("e2_t2_DPhi")
        #if not self.e2_t2_DPhi_branch and "e2_t2_DPhi" not in self.complained:
        if not self.e2_t2_DPhi_branch and "e2_t2_DPhi":
            warnings.warn( "EETauTauTree: Expected branch e2_t2_DPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2_t2_DPhi")
        else:
            self.e2_t2_DPhi_branch.SetAddress(<void*>&self.e2_t2_DPhi_value)

        #print "making e2_t2_DR"
        self.e2_t2_DR_branch = the_tree.GetBranch("e2_t2_DR")
        #if not self.e2_t2_DR_branch and "e2_t2_DR" not in self.complained:
        if not self.e2_t2_DR_branch and "e2_t2_DR":
            warnings.warn( "EETauTauTree: Expected branch e2_t2_DR does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2_t2_DR")
        else:
            self.e2_t2_DR_branch.SetAddress(<void*>&self.e2_t2_DR_value)

        #print "making e2_t2_Eta"
        self.e2_t2_Eta_branch = the_tree.GetBranch("e2_t2_Eta")
        #if not self.e2_t2_Eta_branch and "e2_t2_Eta" not in self.complained:
        if not self.e2_t2_Eta_branch and "e2_t2_Eta":
            warnings.warn( "EETauTauTree: Expected branch e2_t2_Eta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2_t2_Eta")
        else:
            self.e2_t2_Eta_branch.SetAddress(<void*>&self.e2_t2_Eta_value)

        #print "making e2_t2_Mass"
        self.e2_t2_Mass_branch = the_tree.GetBranch("e2_t2_Mass")
        #if not self.e2_t2_Mass_branch and "e2_t2_Mass" not in self.complained:
        if not self.e2_t2_Mass_branch and "e2_t2_Mass":
            warnings.warn( "EETauTauTree: Expected branch e2_t2_Mass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2_t2_Mass")
        else:
            self.e2_t2_Mass_branch.SetAddress(<void*>&self.e2_t2_Mass_value)

        #print "making e2_t2_MassFsr"
        self.e2_t2_MassFsr_branch = the_tree.GetBranch("e2_t2_MassFsr")
        #if not self.e2_t2_MassFsr_branch and "e2_t2_MassFsr" not in self.complained:
        if not self.e2_t2_MassFsr_branch and "e2_t2_MassFsr":
            warnings.warn( "EETauTauTree: Expected branch e2_t2_MassFsr does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2_t2_MassFsr")
        else:
            self.e2_t2_MassFsr_branch.SetAddress(<void*>&self.e2_t2_MassFsr_value)

        #print "making e2_t2_PZeta"
        self.e2_t2_PZeta_branch = the_tree.GetBranch("e2_t2_PZeta")
        #if not self.e2_t2_PZeta_branch and "e2_t2_PZeta" not in self.complained:
        if not self.e2_t2_PZeta_branch and "e2_t2_PZeta":
            warnings.warn( "EETauTauTree: Expected branch e2_t2_PZeta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2_t2_PZeta")
        else:
            self.e2_t2_PZeta_branch.SetAddress(<void*>&self.e2_t2_PZeta_value)

        #print "making e2_t2_PZetaVis"
        self.e2_t2_PZetaVis_branch = the_tree.GetBranch("e2_t2_PZetaVis")
        #if not self.e2_t2_PZetaVis_branch and "e2_t2_PZetaVis" not in self.complained:
        if not self.e2_t2_PZetaVis_branch and "e2_t2_PZetaVis":
            warnings.warn( "EETauTauTree: Expected branch e2_t2_PZetaVis does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2_t2_PZetaVis")
        else:
            self.e2_t2_PZetaVis_branch.SetAddress(<void*>&self.e2_t2_PZetaVis_value)

        #print "making e2_t2_Phi"
        self.e2_t2_Phi_branch = the_tree.GetBranch("e2_t2_Phi")
        #if not self.e2_t2_Phi_branch and "e2_t2_Phi" not in self.complained:
        if not self.e2_t2_Phi_branch and "e2_t2_Phi":
            warnings.warn( "EETauTauTree: Expected branch e2_t2_Phi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2_t2_Phi")
        else:
            self.e2_t2_Phi_branch.SetAddress(<void*>&self.e2_t2_Phi_value)

        #print "making e2_t2_Pt"
        self.e2_t2_Pt_branch = the_tree.GetBranch("e2_t2_Pt")
        #if not self.e2_t2_Pt_branch and "e2_t2_Pt" not in self.complained:
        if not self.e2_t2_Pt_branch and "e2_t2_Pt":
            warnings.warn( "EETauTauTree: Expected branch e2_t2_Pt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2_t2_Pt")
        else:
            self.e2_t2_Pt_branch.SetAddress(<void*>&self.e2_t2_Pt_value)

        #print "making e2_t2_PtFsr"
        self.e2_t2_PtFsr_branch = the_tree.GetBranch("e2_t2_PtFsr")
        #if not self.e2_t2_PtFsr_branch and "e2_t2_PtFsr" not in self.complained:
        if not self.e2_t2_PtFsr_branch and "e2_t2_PtFsr":
            warnings.warn( "EETauTauTree: Expected branch e2_t2_PtFsr does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2_t2_PtFsr")
        else:
            self.e2_t2_PtFsr_branch.SetAddress(<void*>&self.e2_t2_PtFsr_value)

        #print "making e2_t2_SS"
        self.e2_t2_SS_branch = the_tree.GetBranch("e2_t2_SS")
        #if not self.e2_t2_SS_branch and "e2_t2_SS" not in self.complained:
        if not self.e2_t2_SS_branch and "e2_t2_SS":
            warnings.warn( "EETauTauTree: Expected branch e2_t2_SS does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2_t2_SS")
        else:
            self.e2_t2_SS_branch.SetAddress(<void*>&self.e2_t2_SS_value)

        #print "making e2_t2_ToMETDPhi_Ty1"
        self.e2_t2_ToMETDPhi_Ty1_branch = the_tree.GetBranch("e2_t2_ToMETDPhi_Ty1")
        #if not self.e2_t2_ToMETDPhi_Ty1_branch and "e2_t2_ToMETDPhi_Ty1" not in self.complained:
        if not self.e2_t2_ToMETDPhi_Ty1_branch and "e2_t2_ToMETDPhi_Ty1":
            warnings.warn( "EETauTauTree: Expected branch e2_t2_ToMETDPhi_Ty1 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2_t2_ToMETDPhi_Ty1")
        else:
            self.e2_t2_ToMETDPhi_Ty1_branch.SetAddress(<void*>&self.e2_t2_ToMETDPhi_Ty1_value)

        #print "making e2_t2_Zcompat"
        self.e2_t2_Zcompat_branch = the_tree.GetBranch("e2_t2_Zcompat")
        #if not self.e2_t2_Zcompat_branch and "e2_t2_Zcompat" not in self.complained:
        if not self.e2_t2_Zcompat_branch and "e2_t2_Zcompat":
            warnings.warn( "EETauTauTree: Expected branch e2_t2_Zcompat does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2_t2_Zcompat")
        else:
            self.e2_t2_Zcompat_branch.SetAddress(<void*>&self.e2_t2_Zcompat_value)

        #print "making e2dECorrReg_2012Jul13ReReco"
        self.e2dECorrReg_2012Jul13ReReco_branch = the_tree.GetBranch("e2dECorrReg_2012Jul13ReReco")
        #if not self.e2dECorrReg_2012Jul13ReReco_branch and "e2dECorrReg_2012Jul13ReReco" not in self.complained:
        if not self.e2dECorrReg_2012Jul13ReReco_branch and "e2dECorrReg_2012Jul13ReReco":
            warnings.warn( "EETauTauTree: Expected branch e2dECorrReg_2012Jul13ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2dECorrReg_2012Jul13ReReco")
        else:
            self.e2dECorrReg_2012Jul13ReReco_branch.SetAddress(<void*>&self.e2dECorrReg_2012Jul13ReReco_value)

        #print "making e2dECorrReg_Fall11"
        self.e2dECorrReg_Fall11_branch = the_tree.GetBranch("e2dECorrReg_Fall11")
        #if not self.e2dECorrReg_Fall11_branch and "e2dECorrReg_Fall11" not in self.complained:
        if not self.e2dECorrReg_Fall11_branch and "e2dECorrReg_Fall11":
            warnings.warn( "EETauTauTree: Expected branch e2dECorrReg_Fall11 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2dECorrReg_Fall11")
        else:
            self.e2dECorrReg_Fall11_branch.SetAddress(<void*>&self.e2dECorrReg_Fall11_value)

        #print "making e2dECorrReg_Jan16ReReco"
        self.e2dECorrReg_Jan16ReReco_branch = the_tree.GetBranch("e2dECorrReg_Jan16ReReco")
        #if not self.e2dECorrReg_Jan16ReReco_branch and "e2dECorrReg_Jan16ReReco" not in self.complained:
        if not self.e2dECorrReg_Jan16ReReco_branch and "e2dECorrReg_Jan16ReReco":
            warnings.warn( "EETauTauTree: Expected branch e2dECorrReg_Jan16ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2dECorrReg_Jan16ReReco")
        else:
            self.e2dECorrReg_Jan16ReReco_branch.SetAddress(<void*>&self.e2dECorrReg_Jan16ReReco_value)

        #print "making e2dECorrReg_Summer12_DR53X_HCP2012"
        self.e2dECorrReg_Summer12_DR53X_HCP2012_branch = the_tree.GetBranch("e2dECorrReg_Summer12_DR53X_HCP2012")
        #if not self.e2dECorrReg_Summer12_DR53X_HCP2012_branch and "e2dECorrReg_Summer12_DR53X_HCP2012" not in self.complained:
        if not self.e2dECorrReg_Summer12_DR53X_HCP2012_branch and "e2dECorrReg_Summer12_DR53X_HCP2012":
            warnings.warn( "EETauTauTree: Expected branch e2dECorrReg_Summer12_DR53X_HCP2012 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2dECorrReg_Summer12_DR53X_HCP2012")
        else:
            self.e2dECorrReg_Summer12_DR53X_HCP2012_branch.SetAddress(<void*>&self.e2dECorrReg_Summer12_DR53X_HCP2012_value)

        #print "making e2dECorrSmearedNoReg_2012Jul13ReReco"
        self.e2dECorrSmearedNoReg_2012Jul13ReReco_branch = the_tree.GetBranch("e2dECorrSmearedNoReg_2012Jul13ReReco")
        #if not self.e2dECorrSmearedNoReg_2012Jul13ReReco_branch and "e2dECorrSmearedNoReg_2012Jul13ReReco" not in self.complained:
        if not self.e2dECorrSmearedNoReg_2012Jul13ReReco_branch and "e2dECorrSmearedNoReg_2012Jul13ReReco":
            warnings.warn( "EETauTauTree: Expected branch e2dECorrSmearedNoReg_2012Jul13ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2dECorrSmearedNoReg_2012Jul13ReReco")
        else:
            self.e2dECorrSmearedNoReg_2012Jul13ReReco_branch.SetAddress(<void*>&self.e2dECorrSmearedNoReg_2012Jul13ReReco_value)

        #print "making e2dECorrSmearedNoReg_Fall11"
        self.e2dECorrSmearedNoReg_Fall11_branch = the_tree.GetBranch("e2dECorrSmearedNoReg_Fall11")
        #if not self.e2dECorrSmearedNoReg_Fall11_branch and "e2dECorrSmearedNoReg_Fall11" not in self.complained:
        if not self.e2dECorrSmearedNoReg_Fall11_branch and "e2dECorrSmearedNoReg_Fall11":
            warnings.warn( "EETauTauTree: Expected branch e2dECorrSmearedNoReg_Fall11 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2dECorrSmearedNoReg_Fall11")
        else:
            self.e2dECorrSmearedNoReg_Fall11_branch.SetAddress(<void*>&self.e2dECorrSmearedNoReg_Fall11_value)

        #print "making e2dECorrSmearedNoReg_Jan16ReReco"
        self.e2dECorrSmearedNoReg_Jan16ReReco_branch = the_tree.GetBranch("e2dECorrSmearedNoReg_Jan16ReReco")
        #if not self.e2dECorrSmearedNoReg_Jan16ReReco_branch and "e2dECorrSmearedNoReg_Jan16ReReco" not in self.complained:
        if not self.e2dECorrSmearedNoReg_Jan16ReReco_branch and "e2dECorrSmearedNoReg_Jan16ReReco":
            warnings.warn( "EETauTauTree: Expected branch e2dECorrSmearedNoReg_Jan16ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2dECorrSmearedNoReg_Jan16ReReco")
        else:
            self.e2dECorrSmearedNoReg_Jan16ReReco_branch.SetAddress(<void*>&self.e2dECorrSmearedNoReg_Jan16ReReco_value)

        #print "making e2dECorrSmearedNoReg_Summer12_DR53X_HCP2012"
        self.e2dECorrSmearedNoReg_Summer12_DR53X_HCP2012_branch = the_tree.GetBranch("e2dECorrSmearedNoReg_Summer12_DR53X_HCP2012")
        #if not self.e2dECorrSmearedNoReg_Summer12_DR53X_HCP2012_branch and "e2dECorrSmearedNoReg_Summer12_DR53X_HCP2012" not in self.complained:
        if not self.e2dECorrSmearedNoReg_Summer12_DR53X_HCP2012_branch and "e2dECorrSmearedNoReg_Summer12_DR53X_HCP2012":
            warnings.warn( "EETauTauTree: Expected branch e2dECorrSmearedNoReg_Summer12_DR53X_HCP2012 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2dECorrSmearedNoReg_Summer12_DR53X_HCP2012")
        else:
            self.e2dECorrSmearedNoReg_Summer12_DR53X_HCP2012_branch.SetAddress(<void*>&self.e2dECorrSmearedNoReg_Summer12_DR53X_HCP2012_value)

        #print "making e2dECorrSmearedReg_2012Jul13ReReco"
        self.e2dECorrSmearedReg_2012Jul13ReReco_branch = the_tree.GetBranch("e2dECorrSmearedReg_2012Jul13ReReco")
        #if not self.e2dECorrSmearedReg_2012Jul13ReReco_branch and "e2dECorrSmearedReg_2012Jul13ReReco" not in self.complained:
        if not self.e2dECorrSmearedReg_2012Jul13ReReco_branch and "e2dECorrSmearedReg_2012Jul13ReReco":
            warnings.warn( "EETauTauTree: Expected branch e2dECorrSmearedReg_2012Jul13ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2dECorrSmearedReg_2012Jul13ReReco")
        else:
            self.e2dECorrSmearedReg_2012Jul13ReReco_branch.SetAddress(<void*>&self.e2dECorrSmearedReg_2012Jul13ReReco_value)

        #print "making e2dECorrSmearedReg_Fall11"
        self.e2dECorrSmearedReg_Fall11_branch = the_tree.GetBranch("e2dECorrSmearedReg_Fall11")
        #if not self.e2dECorrSmearedReg_Fall11_branch and "e2dECorrSmearedReg_Fall11" not in self.complained:
        if not self.e2dECorrSmearedReg_Fall11_branch and "e2dECorrSmearedReg_Fall11":
            warnings.warn( "EETauTauTree: Expected branch e2dECorrSmearedReg_Fall11 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2dECorrSmearedReg_Fall11")
        else:
            self.e2dECorrSmearedReg_Fall11_branch.SetAddress(<void*>&self.e2dECorrSmearedReg_Fall11_value)

        #print "making e2dECorrSmearedReg_Jan16ReReco"
        self.e2dECorrSmearedReg_Jan16ReReco_branch = the_tree.GetBranch("e2dECorrSmearedReg_Jan16ReReco")
        #if not self.e2dECorrSmearedReg_Jan16ReReco_branch and "e2dECorrSmearedReg_Jan16ReReco" not in self.complained:
        if not self.e2dECorrSmearedReg_Jan16ReReco_branch and "e2dECorrSmearedReg_Jan16ReReco":
            warnings.warn( "EETauTauTree: Expected branch e2dECorrSmearedReg_Jan16ReReco does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2dECorrSmearedReg_Jan16ReReco")
        else:
            self.e2dECorrSmearedReg_Jan16ReReco_branch.SetAddress(<void*>&self.e2dECorrSmearedReg_Jan16ReReco_value)

        #print "making e2dECorrSmearedReg_Summer12_DR53X_HCP2012"
        self.e2dECorrSmearedReg_Summer12_DR53X_HCP2012_branch = the_tree.GetBranch("e2dECorrSmearedReg_Summer12_DR53X_HCP2012")
        #if not self.e2dECorrSmearedReg_Summer12_DR53X_HCP2012_branch and "e2dECorrSmearedReg_Summer12_DR53X_HCP2012" not in self.complained:
        if not self.e2dECorrSmearedReg_Summer12_DR53X_HCP2012_branch and "e2dECorrSmearedReg_Summer12_DR53X_HCP2012":
            warnings.warn( "EETauTauTree: Expected branch e2dECorrSmearedReg_Summer12_DR53X_HCP2012 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2dECorrSmearedReg_Summer12_DR53X_HCP2012")
        else:
            self.e2dECorrSmearedReg_Summer12_DR53X_HCP2012_branch.SetAddress(<void*>&self.e2dECorrSmearedReg_Summer12_DR53X_HCP2012_value)

        #print "making e2deltaEtaSuperClusterTrackAtVtx"
        self.e2deltaEtaSuperClusterTrackAtVtx_branch = the_tree.GetBranch("e2deltaEtaSuperClusterTrackAtVtx")
        #if not self.e2deltaEtaSuperClusterTrackAtVtx_branch and "e2deltaEtaSuperClusterTrackAtVtx" not in self.complained:
        if not self.e2deltaEtaSuperClusterTrackAtVtx_branch and "e2deltaEtaSuperClusterTrackAtVtx":
            warnings.warn( "EETauTauTree: Expected branch e2deltaEtaSuperClusterTrackAtVtx does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2deltaEtaSuperClusterTrackAtVtx")
        else:
            self.e2deltaEtaSuperClusterTrackAtVtx_branch.SetAddress(<void*>&self.e2deltaEtaSuperClusterTrackAtVtx_value)

        #print "making e2deltaPhiSuperClusterTrackAtVtx"
        self.e2deltaPhiSuperClusterTrackAtVtx_branch = the_tree.GetBranch("e2deltaPhiSuperClusterTrackAtVtx")
        #if not self.e2deltaPhiSuperClusterTrackAtVtx_branch and "e2deltaPhiSuperClusterTrackAtVtx" not in self.complained:
        if not self.e2deltaPhiSuperClusterTrackAtVtx_branch and "e2deltaPhiSuperClusterTrackAtVtx":
            warnings.warn( "EETauTauTree: Expected branch e2deltaPhiSuperClusterTrackAtVtx does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2deltaPhiSuperClusterTrackAtVtx")
        else:
            self.e2deltaPhiSuperClusterTrackAtVtx_branch.SetAddress(<void*>&self.e2deltaPhiSuperClusterTrackAtVtx_value)

        #print "making e2eSuperClusterOverP"
        self.e2eSuperClusterOverP_branch = the_tree.GetBranch("e2eSuperClusterOverP")
        #if not self.e2eSuperClusterOverP_branch and "e2eSuperClusterOverP" not in self.complained:
        if not self.e2eSuperClusterOverP_branch and "e2eSuperClusterOverP":
            warnings.warn( "EETauTauTree: Expected branch e2eSuperClusterOverP does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2eSuperClusterOverP")
        else:
            self.e2eSuperClusterOverP_branch.SetAddress(<void*>&self.e2eSuperClusterOverP_value)

        #print "making e2ecalEnergy"
        self.e2ecalEnergy_branch = the_tree.GetBranch("e2ecalEnergy")
        #if not self.e2ecalEnergy_branch and "e2ecalEnergy" not in self.complained:
        if not self.e2ecalEnergy_branch and "e2ecalEnergy":
            warnings.warn( "EETauTauTree: Expected branch e2ecalEnergy does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2ecalEnergy")
        else:
            self.e2ecalEnergy_branch.SetAddress(<void*>&self.e2ecalEnergy_value)

        #print "making e2fBrem"
        self.e2fBrem_branch = the_tree.GetBranch("e2fBrem")
        #if not self.e2fBrem_branch and "e2fBrem" not in self.complained:
        if not self.e2fBrem_branch and "e2fBrem":
            warnings.warn( "EETauTauTree: Expected branch e2fBrem does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2fBrem")
        else:
            self.e2fBrem_branch.SetAddress(<void*>&self.e2fBrem_value)

        #print "making e2trackMomentumAtVtxP"
        self.e2trackMomentumAtVtxP_branch = the_tree.GetBranch("e2trackMomentumAtVtxP")
        #if not self.e2trackMomentumAtVtxP_branch and "e2trackMomentumAtVtxP" not in self.complained:
        if not self.e2trackMomentumAtVtxP_branch and "e2trackMomentumAtVtxP":
            warnings.warn( "EETauTauTree: Expected branch e2trackMomentumAtVtxP does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2trackMomentumAtVtxP")
        else:
            self.e2trackMomentumAtVtxP_branch.SetAddress(<void*>&self.e2trackMomentumAtVtxP_value)

        #print "making eTightCountZH"
        self.eTightCountZH_branch = the_tree.GetBranch("eTightCountZH")
        #if not self.eTightCountZH_branch and "eTightCountZH" not in self.complained:
        if not self.eTightCountZH_branch and "eTightCountZH":
            warnings.warn( "EETauTauTree: Expected branch eTightCountZH does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eTightCountZH")
        else:
            self.eTightCountZH_branch.SetAddress(<void*>&self.eTightCountZH_value)

        #print "making eVetoCicTightIso"
        self.eVetoCicTightIso_branch = the_tree.GetBranch("eVetoCicTightIso")
        #if not self.eVetoCicTightIso_branch and "eVetoCicTightIso" not in self.complained:
        if not self.eVetoCicTightIso_branch and "eVetoCicTightIso":
            warnings.warn( "EETauTauTree: Expected branch eVetoCicTightIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eVetoCicTightIso")
        else:
            self.eVetoCicTightIso_branch.SetAddress(<void*>&self.eVetoCicTightIso_value)

        #print "making eVetoMVAIso"
        self.eVetoMVAIso_branch = the_tree.GetBranch("eVetoMVAIso")
        #if not self.eVetoMVAIso_branch and "eVetoMVAIso" not in self.complained:
        if not self.eVetoMVAIso_branch and "eVetoMVAIso":
            warnings.warn( "EETauTauTree: Expected branch eVetoMVAIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eVetoMVAIso")
        else:
            self.eVetoMVAIso_branch.SetAddress(<void*>&self.eVetoMVAIso_value)

        #print "making eVetoMVAIsoVtx"
        self.eVetoMVAIsoVtx_branch = the_tree.GetBranch("eVetoMVAIsoVtx")
        #if not self.eVetoMVAIsoVtx_branch and "eVetoMVAIsoVtx" not in self.complained:
        if not self.eVetoMVAIsoVtx_branch and "eVetoMVAIsoVtx":
            warnings.warn( "EETauTauTree: Expected branch eVetoMVAIsoVtx does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eVetoMVAIsoVtx")
        else:
            self.eVetoMVAIsoVtx_branch.SetAddress(<void*>&self.eVetoMVAIsoVtx_value)

        #print "making eVetoZH"
        self.eVetoZH_branch = the_tree.GetBranch("eVetoZH")
        #if not self.eVetoZH_branch and "eVetoZH" not in self.complained:
        if not self.eVetoZH_branch and "eVetoZH":
            warnings.warn( "EETauTauTree: Expected branch eVetoZH does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eVetoZH")
        else:
            self.eVetoZH_branch.SetAddress(<void*>&self.eVetoZH_value)

        #print "making eVetoZH_smallDR"
        self.eVetoZH_smallDR_branch = the_tree.GetBranch("eVetoZH_smallDR")
        #if not self.eVetoZH_smallDR_branch and "eVetoZH_smallDR" not in self.complained:
        if not self.eVetoZH_smallDR_branch and "eVetoZH_smallDR":
            warnings.warn( "EETauTauTree: Expected branch eVetoZH_smallDR does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eVetoZH_smallDR")
        else:
            self.eVetoZH_smallDR_branch.SetAddress(<void*>&self.eVetoZH_smallDR_value)

        #print "making evt"
        self.evt_branch = the_tree.GetBranch("evt")
        #if not self.evt_branch and "evt" not in self.complained:
        if not self.evt_branch and "evt":
            warnings.warn( "EETauTauTree: Expected branch evt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("evt")
        else:
            self.evt_branch.SetAddress(<void*>&self.evt_value)

        #print "making isGtautau"
        self.isGtautau_branch = the_tree.GetBranch("isGtautau")
        #if not self.isGtautau_branch and "isGtautau" not in self.complained:
        if not self.isGtautau_branch and "isGtautau":
            warnings.warn( "EETauTauTree: Expected branch isGtautau does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("isGtautau")
        else:
            self.isGtautau_branch.SetAddress(<void*>&self.isGtautau_value)

        #print "making isWmunu"
        self.isWmunu_branch = the_tree.GetBranch("isWmunu")
        #if not self.isWmunu_branch and "isWmunu" not in self.complained:
        if not self.isWmunu_branch and "isWmunu":
            warnings.warn( "EETauTauTree: Expected branch isWmunu does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("isWmunu")
        else:
            self.isWmunu_branch.SetAddress(<void*>&self.isWmunu_value)

        #print "making isWtaunu"
        self.isWtaunu_branch = the_tree.GetBranch("isWtaunu")
        #if not self.isWtaunu_branch and "isWtaunu" not in self.complained:
        if not self.isWtaunu_branch and "isWtaunu":
            warnings.warn( "EETauTauTree: Expected branch isWtaunu does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("isWtaunu")
        else:
            self.isWtaunu_branch.SetAddress(<void*>&self.isWtaunu_value)

        #print "making isZtautau"
        self.isZtautau_branch = the_tree.GetBranch("isZtautau")
        #if not self.isZtautau_branch and "isZtautau" not in self.complained:
        if not self.isZtautau_branch and "isZtautau":
            warnings.warn( "EETauTauTree: Expected branch isZtautau does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("isZtautau")
        else:
            self.isZtautau_branch.SetAddress(<void*>&self.isZtautau_value)

        #print "making isdata"
        self.isdata_branch = the_tree.GetBranch("isdata")
        #if not self.isdata_branch and "isdata" not in self.complained:
        if not self.isdata_branch and "isdata":
            warnings.warn( "EETauTauTree: Expected branch isdata does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("isdata")
        else:
            self.isdata_branch.SetAddress(<void*>&self.isdata_value)

        #print "making isoMu24eta2p1Group"
        self.isoMu24eta2p1Group_branch = the_tree.GetBranch("isoMu24eta2p1Group")
        #if not self.isoMu24eta2p1Group_branch and "isoMu24eta2p1Group" not in self.complained:
        if not self.isoMu24eta2p1Group_branch and "isoMu24eta2p1Group":
            warnings.warn( "EETauTauTree: Expected branch isoMu24eta2p1Group does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("isoMu24eta2p1Group")
        else:
            self.isoMu24eta2p1Group_branch.SetAddress(<void*>&self.isoMu24eta2p1Group_value)

        #print "making isoMu24eta2p1Pass"
        self.isoMu24eta2p1Pass_branch = the_tree.GetBranch("isoMu24eta2p1Pass")
        #if not self.isoMu24eta2p1Pass_branch and "isoMu24eta2p1Pass" not in self.complained:
        if not self.isoMu24eta2p1Pass_branch and "isoMu24eta2p1Pass":
            warnings.warn( "EETauTauTree: Expected branch isoMu24eta2p1Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("isoMu24eta2p1Pass")
        else:
            self.isoMu24eta2p1Pass_branch.SetAddress(<void*>&self.isoMu24eta2p1Pass_value)

        #print "making isoMu24eta2p1Prescale"
        self.isoMu24eta2p1Prescale_branch = the_tree.GetBranch("isoMu24eta2p1Prescale")
        #if not self.isoMu24eta2p1Prescale_branch and "isoMu24eta2p1Prescale" not in self.complained:
        if not self.isoMu24eta2p1Prescale_branch and "isoMu24eta2p1Prescale":
            warnings.warn( "EETauTauTree: Expected branch isoMu24eta2p1Prescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("isoMu24eta2p1Prescale")
        else:
            self.isoMu24eta2p1Prescale_branch.SetAddress(<void*>&self.isoMu24eta2p1Prescale_value)

        #print "making isoMuGroup"
        self.isoMuGroup_branch = the_tree.GetBranch("isoMuGroup")
        #if not self.isoMuGroup_branch and "isoMuGroup" not in self.complained:
        if not self.isoMuGroup_branch and "isoMuGroup":
            warnings.warn( "EETauTauTree: Expected branch isoMuGroup does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("isoMuGroup")
        else:
            self.isoMuGroup_branch.SetAddress(<void*>&self.isoMuGroup_value)

        #print "making isoMuPass"
        self.isoMuPass_branch = the_tree.GetBranch("isoMuPass")
        #if not self.isoMuPass_branch and "isoMuPass" not in self.complained:
        if not self.isoMuPass_branch and "isoMuPass":
            warnings.warn( "EETauTauTree: Expected branch isoMuPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("isoMuPass")
        else:
            self.isoMuPass_branch.SetAddress(<void*>&self.isoMuPass_value)

        #print "making isoMuPrescale"
        self.isoMuPrescale_branch = the_tree.GetBranch("isoMuPrescale")
        #if not self.isoMuPrescale_branch and "isoMuPrescale" not in self.complained:
        if not self.isoMuPrescale_branch and "isoMuPrescale":
            warnings.warn( "EETauTauTree: Expected branch isoMuPrescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("isoMuPrescale")
        else:
            self.isoMuPrescale_branch.SetAddress(<void*>&self.isoMuPrescale_value)

        #print "making isoMuTauGroup"
        self.isoMuTauGroup_branch = the_tree.GetBranch("isoMuTauGroup")
        #if not self.isoMuTauGroup_branch and "isoMuTauGroup" not in self.complained:
        if not self.isoMuTauGroup_branch and "isoMuTauGroup":
            warnings.warn( "EETauTauTree: Expected branch isoMuTauGroup does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("isoMuTauGroup")
        else:
            self.isoMuTauGroup_branch.SetAddress(<void*>&self.isoMuTauGroup_value)

        #print "making isoMuTauPass"
        self.isoMuTauPass_branch = the_tree.GetBranch("isoMuTauPass")
        #if not self.isoMuTauPass_branch and "isoMuTauPass" not in self.complained:
        if not self.isoMuTauPass_branch and "isoMuTauPass":
            warnings.warn( "EETauTauTree: Expected branch isoMuTauPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("isoMuTauPass")
        else:
            self.isoMuTauPass_branch.SetAddress(<void*>&self.isoMuTauPass_value)

        #print "making isoMuTauPrescale"
        self.isoMuTauPrescale_branch = the_tree.GetBranch("isoMuTauPrescale")
        #if not self.isoMuTauPrescale_branch and "isoMuTauPrescale" not in self.complained:
        if not self.isoMuTauPrescale_branch and "isoMuTauPrescale":
            warnings.warn( "EETauTauTree: Expected branch isoMuTauPrescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("isoMuTauPrescale")
        else:
            self.isoMuTauPrescale_branch.SetAddress(<void*>&self.isoMuTauPrescale_value)

        #print "making jetVeto20"
        self.jetVeto20_branch = the_tree.GetBranch("jetVeto20")
        #if not self.jetVeto20_branch and "jetVeto20" not in self.complained:
        if not self.jetVeto20_branch and "jetVeto20":
            warnings.warn( "EETauTauTree: Expected branch jetVeto20 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto20")
        else:
            self.jetVeto20_branch.SetAddress(<void*>&self.jetVeto20_value)

        #print "making jetVeto20_DR05"
        self.jetVeto20_DR05_branch = the_tree.GetBranch("jetVeto20_DR05")
        #if not self.jetVeto20_DR05_branch and "jetVeto20_DR05" not in self.complained:
        if not self.jetVeto20_DR05_branch and "jetVeto20_DR05":
            warnings.warn( "EETauTauTree: Expected branch jetVeto20_DR05 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto20_DR05")
        else:
            self.jetVeto20_DR05_branch.SetAddress(<void*>&self.jetVeto20_DR05_value)

        #print "making jetVeto30"
        self.jetVeto30_branch = the_tree.GetBranch("jetVeto30")
        #if not self.jetVeto30_branch and "jetVeto30" not in self.complained:
        if not self.jetVeto30_branch and "jetVeto30":
            warnings.warn( "EETauTauTree: Expected branch jetVeto30 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30")
        else:
            self.jetVeto30_branch.SetAddress(<void*>&self.jetVeto30_value)

        #print "making jetVeto30_DR05"
        self.jetVeto30_DR05_branch = the_tree.GetBranch("jetVeto30_DR05")
        #if not self.jetVeto30_DR05_branch and "jetVeto30_DR05" not in self.complained:
        if not self.jetVeto30_DR05_branch and "jetVeto30_DR05":
            warnings.warn( "EETauTauTree: Expected branch jetVeto30_DR05 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_DR05")
        else:
            self.jetVeto30_DR05_branch.SetAddress(<void*>&self.jetVeto30_DR05_value)

        #print "making jetVeto40"
        self.jetVeto40_branch = the_tree.GetBranch("jetVeto40")
        #if not self.jetVeto40_branch and "jetVeto40" not in self.complained:
        if not self.jetVeto40_branch and "jetVeto40":
            warnings.warn( "EETauTauTree: Expected branch jetVeto40 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto40")
        else:
            self.jetVeto40_branch.SetAddress(<void*>&self.jetVeto40_value)

        #print "making jetVeto40_DR05"
        self.jetVeto40_DR05_branch = the_tree.GetBranch("jetVeto40_DR05")
        #if not self.jetVeto40_DR05_branch and "jetVeto40_DR05" not in self.complained:
        if not self.jetVeto40_DR05_branch and "jetVeto40_DR05":
            warnings.warn( "EETauTauTree: Expected branch jetVeto40_DR05 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto40_DR05")
        else:
            self.jetVeto40_DR05_branch.SetAddress(<void*>&self.jetVeto40_DR05_value)

        #print "making lumi"
        self.lumi_branch = the_tree.GetBranch("lumi")
        #if not self.lumi_branch and "lumi" not in self.complained:
        if not self.lumi_branch and "lumi":
            warnings.warn( "EETauTauTree: Expected branch lumi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lumi")
        else:
            self.lumi_branch.SetAddress(<void*>&self.lumi_value)

        #print "making mu17ele8Group"
        self.mu17ele8Group_branch = the_tree.GetBranch("mu17ele8Group")
        #if not self.mu17ele8Group_branch and "mu17ele8Group" not in self.complained:
        if not self.mu17ele8Group_branch and "mu17ele8Group":
            warnings.warn( "EETauTauTree: Expected branch mu17ele8Group does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mu17ele8Group")
        else:
            self.mu17ele8Group_branch.SetAddress(<void*>&self.mu17ele8Group_value)

        #print "making mu17ele8Pass"
        self.mu17ele8Pass_branch = the_tree.GetBranch("mu17ele8Pass")
        #if not self.mu17ele8Pass_branch and "mu17ele8Pass" not in self.complained:
        if not self.mu17ele8Pass_branch and "mu17ele8Pass":
            warnings.warn( "EETauTauTree: Expected branch mu17ele8Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mu17ele8Pass")
        else:
            self.mu17ele8Pass_branch.SetAddress(<void*>&self.mu17ele8Pass_value)

        #print "making mu17ele8Prescale"
        self.mu17ele8Prescale_branch = the_tree.GetBranch("mu17ele8Prescale")
        #if not self.mu17ele8Prescale_branch and "mu17ele8Prescale" not in self.complained:
        if not self.mu17ele8Prescale_branch and "mu17ele8Prescale":
            warnings.warn( "EETauTauTree: Expected branch mu17ele8Prescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mu17ele8Prescale")
        else:
            self.mu17ele8Prescale_branch.SetAddress(<void*>&self.mu17ele8Prescale_value)

        #print "making mu17ele8isoGroup"
        self.mu17ele8isoGroup_branch = the_tree.GetBranch("mu17ele8isoGroup")
        #if not self.mu17ele8isoGroup_branch and "mu17ele8isoGroup" not in self.complained:
        if not self.mu17ele8isoGroup_branch and "mu17ele8isoGroup":
            warnings.warn( "EETauTauTree: Expected branch mu17ele8isoGroup does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mu17ele8isoGroup")
        else:
            self.mu17ele8isoGroup_branch.SetAddress(<void*>&self.mu17ele8isoGroup_value)

        #print "making mu17ele8isoPass"
        self.mu17ele8isoPass_branch = the_tree.GetBranch("mu17ele8isoPass")
        #if not self.mu17ele8isoPass_branch and "mu17ele8isoPass" not in self.complained:
        if not self.mu17ele8isoPass_branch and "mu17ele8isoPass":
            warnings.warn( "EETauTauTree: Expected branch mu17ele8isoPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mu17ele8isoPass")
        else:
            self.mu17ele8isoPass_branch.SetAddress(<void*>&self.mu17ele8isoPass_value)

        #print "making mu17ele8isoPrescale"
        self.mu17ele8isoPrescale_branch = the_tree.GetBranch("mu17ele8isoPrescale")
        #if not self.mu17ele8isoPrescale_branch and "mu17ele8isoPrescale" not in self.complained:
        if not self.mu17ele8isoPrescale_branch and "mu17ele8isoPrescale":
            warnings.warn( "EETauTauTree: Expected branch mu17ele8isoPrescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mu17ele8isoPrescale")
        else:
            self.mu17ele8isoPrescale_branch.SetAddress(<void*>&self.mu17ele8isoPrescale_value)

        #print "making mu17mu8Group"
        self.mu17mu8Group_branch = the_tree.GetBranch("mu17mu8Group")
        #if not self.mu17mu8Group_branch and "mu17mu8Group" not in self.complained:
        if not self.mu17mu8Group_branch and "mu17mu8Group":
            warnings.warn( "EETauTauTree: Expected branch mu17mu8Group does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mu17mu8Group")
        else:
            self.mu17mu8Group_branch.SetAddress(<void*>&self.mu17mu8Group_value)

        #print "making mu17mu8Pass"
        self.mu17mu8Pass_branch = the_tree.GetBranch("mu17mu8Pass")
        #if not self.mu17mu8Pass_branch and "mu17mu8Pass" not in self.complained:
        if not self.mu17mu8Pass_branch and "mu17mu8Pass":
            warnings.warn( "EETauTauTree: Expected branch mu17mu8Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mu17mu8Pass")
        else:
            self.mu17mu8Pass_branch.SetAddress(<void*>&self.mu17mu8Pass_value)

        #print "making mu17mu8Prescale"
        self.mu17mu8Prescale_branch = the_tree.GetBranch("mu17mu8Prescale")
        #if not self.mu17mu8Prescale_branch and "mu17mu8Prescale" not in self.complained:
        if not self.mu17mu8Prescale_branch and "mu17mu8Prescale":
            warnings.warn( "EETauTauTree: Expected branch mu17mu8Prescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mu17mu8Prescale")
        else:
            self.mu17mu8Prescale_branch.SetAddress(<void*>&self.mu17mu8Prescale_value)

        #print "making mu8ele17Group"
        self.mu8ele17Group_branch = the_tree.GetBranch("mu8ele17Group")
        #if not self.mu8ele17Group_branch and "mu8ele17Group" not in self.complained:
        if not self.mu8ele17Group_branch and "mu8ele17Group":
            warnings.warn( "EETauTauTree: Expected branch mu8ele17Group does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mu8ele17Group")
        else:
            self.mu8ele17Group_branch.SetAddress(<void*>&self.mu8ele17Group_value)

        #print "making mu8ele17Pass"
        self.mu8ele17Pass_branch = the_tree.GetBranch("mu8ele17Pass")
        #if not self.mu8ele17Pass_branch and "mu8ele17Pass" not in self.complained:
        if not self.mu8ele17Pass_branch and "mu8ele17Pass":
            warnings.warn( "EETauTauTree: Expected branch mu8ele17Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mu8ele17Pass")
        else:
            self.mu8ele17Pass_branch.SetAddress(<void*>&self.mu8ele17Pass_value)

        #print "making mu8ele17Prescale"
        self.mu8ele17Prescale_branch = the_tree.GetBranch("mu8ele17Prescale")
        #if not self.mu8ele17Prescale_branch and "mu8ele17Prescale" not in self.complained:
        if not self.mu8ele17Prescale_branch and "mu8ele17Prescale":
            warnings.warn( "EETauTauTree: Expected branch mu8ele17Prescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mu8ele17Prescale")
        else:
            self.mu8ele17Prescale_branch.SetAddress(<void*>&self.mu8ele17Prescale_value)

        #print "making mu8ele17isoGroup"
        self.mu8ele17isoGroup_branch = the_tree.GetBranch("mu8ele17isoGroup")
        #if not self.mu8ele17isoGroup_branch and "mu8ele17isoGroup" not in self.complained:
        if not self.mu8ele17isoGroup_branch and "mu8ele17isoGroup":
            warnings.warn( "EETauTauTree: Expected branch mu8ele17isoGroup does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mu8ele17isoGroup")
        else:
            self.mu8ele17isoGroup_branch.SetAddress(<void*>&self.mu8ele17isoGroup_value)

        #print "making mu8ele17isoPass"
        self.mu8ele17isoPass_branch = the_tree.GetBranch("mu8ele17isoPass")
        #if not self.mu8ele17isoPass_branch and "mu8ele17isoPass" not in self.complained:
        if not self.mu8ele17isoPass_branch and "mu8ele17isoPass":
            warnings.warn( "EETauTauTree: Expected branch mu8ele17isoPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mu8ele17isoPass")
        else:
            self.mu8ele17isoPass_branch.SetAddress(<void*>&self.mu8ele17isoPass_value)

        #print "making mu8ele17isoPrescale"
        self.mu8ele17isoPrescale_branch = the_tree.GetBranch("mu8ele17isoPrescale")
        #if not self.mu8ele17isoPrescale_branch and "mu8ele17isoPrescale" not in self.complained:
        if not self.mu8ele17isoPrescale_branch and "mu8ele17isoPrescale":
            warnings.warn( "EETauTauTree: Expected branch mu8ele17isoPrescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mu8ele17isoPrescale")
        else:
            self.mu8ele17isoPrescale_branch.SetAddress(<void*>&self.mu8ele17isoPrescale_value)

        #print "making muGlbIsoVetoPt10"
        self.muGlbIsoVetoPt10_branch = the_tree.GetBranch("muGlbIsoVetoPt10")
        #if not self.muGlbIsoVetoPt10_branch and "muGlbIsoVetoPt10" not in self.complained:
        if not self.muGlbIsoVetoPt10_branch and "muGlbIsoVetoPt10":
            warnings.warn( "EETauTauTree: Expected branch muGlbIsoVetoPt10 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("muGlbIsoVetoPt10")
        else:
            self.muGlbIsoVetoPt10_branch.SetAddress(<void*>&self.muGlbIsoVetoPt10_value)

        #print "making muTauGroup"
        self.muTauGroup_branch = the_tree.GetBranch("muTauGroup")
        #if not self.muTauGroup_branch and "muTauGroup" not in self.complained:
        if not self.muTauGroup_branch and "muTauGroup":
            warnings.warn( "EETauTauTree: Expected branch muTauGroup does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("muTauGroup")
        else:
            self.muTauGroup_branch.SetAddress(<void*>&self.muTauGroup_value)

        #print "making muTauPass"
        self.muTauPass_branch = the_tree.GetBranch("muTauPass")
        #if not self.muTauPass_branch and "muTauPass" not in self.complained:
        if not self.muTauPass_branch and "muTauPass":
            warnings.warn( "EETauTauTree: Expected branch muTauPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("muTauPass")
        else:
            self.muTauPass_branch.SetAddress(<void*>&self.muTauPass_value)

        #print "making muTauPrescale"
        self.muTauPrescale_branch = the_tree.GetBranch("muTauPrescale")
        #if not self.muTauPrescale_branch and "muTauPrescale" not in self.complained:
        if not self.muTauPrescale_branch and "muTauPrescale":
            warnings.warn( "EETauTauTree: Expected branch muTauPrescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("muTauPrescale")
        else:
            self.muTauPrescale_branch.SetAddress(<void*>&self.muTauPrescale_value)

        #print "making muTauTestGroup"
        self.muTauTestGroup_branch = the_tree.GetBranch("muTauTestGroup")
        #if not self.muTauTestGroup_branch and "muTauTestGroup" not in self.complained:
        if not self.muTauTestGroup_branch and "muTauTestGroup":
            warnings.warn( "EETauTauTree: Expected branch muTauTestGroup does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("muTauTestGroup")
        else:
            self.muTauTestGroup_branch.SetAddress(<void*>&self.muTauTestGroup_value)

        #print "making muTauTestPass"
        self.muTauTestPass_branch = the_tree.GetBranch("muTauTestPass")
        #if not self.muTauTestPass_branch and "muTauTestPass" not in self.complained:
        if not self.muTauTestPass_branch and "muTauTestPass":
            warnings.warn( "EETauTauTree: Expected branch muTauTestPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("muTauTestPass")
        else:
            self.muTauTestPass_branch.SetAddress(<void*>&self.muTauTestPass_value)

        #print "making muTauTestPrescale"
        self.muTauTestPrescale_branch = the_tree.GetBranch("muTauTestPrescale")
        #if not self.muTauTestPrescale_branch and "muTauTestPrescale" not in self.complained:
        if not self.muTauTestPrescale_branch and "muTauTestPrescale":
            warnings.warn( "EETauTauTree: Expected branch muTauTestPrescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("muTauTestPrescale")
        else:
            self.muTauTestPrescale_branch.SetAddress(<void*>&self.muTauTestPrescale_value)

        #print "making muTightCountZH"
        self.muTightCountZH_branch = the_tree.GetBranch("muTightCountZH")
        #if not self.muTightCountZH_branch and "muTightCountZH" not in self.complained:
        if not self.muTightCountZH_branch and "muTightCountZH":
            warnings.warn( "EETauTauTree: Expected branch muTightCountZH does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("muTightCountZH")
        else:
            self.muTightCountZH_branch.SetAddress(<void*>&self.muTightCountZH_value)

        #print "making muVetoPt15IsoIdVtx"
        self.muVetoPt15IsoIdVtx_branch = the_tree.GetBranch("muVetoPt15IsoIdVtx")
        #if not self.muVetoPt15IsoIdVtx_branch and "muVetoPt15IsoIdVtx" not in self.complained:
        if not self.muVetoPt15IsoIdVtx_branch and "muVetoPt15IsoIdVtx":
            warnings.warn( "EETauTauTree: Expected branch muVetoPt15IsoIdVtx does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("muVetoPt15IsoIdVtx")
        else:
            self.muVetoPt15IsoIdVtx_branch.SetAddress(<void*>&self.muVetoPt15IsoIdVtx_value)

        #print "making muVetoPt5"
        self.muVetoPt5_branch = the_tree.GetBranch("muVetoPt5")
        #if not self.muVetoPt5_branch and "muVetoPt5" not in self.complained:
        if not self.muVetoPt5_branch and "muVetoPt5":
            warnings.warn( "EETauTauTree: Expected branch muVetoPt5 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("muVetoPt5")
        else:
            self.muVetoPt5_branch.SetAddress(<void*>&self.muVetoPt5_value)

        #print "making muVetoPt5IsoIdVtx"
        self.muVetoPt5IsoIdVtx_branch = the_tree.GetBranch("muVetoPt5IsoIdVtx")
        #if not self.muVetoPt5IsoIdVtx_branch and "muVetoPt5IsoIdVtx" not in self.complained:
        if not self.muVetoPt5IsoIdVtx_branch and "muVetoPt5IsoIdVtx":
            warnings.warn( "EETauTauTree: Expected branch muVetoPt5IsoIdVtx does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("muVetoPt5IsoIdVtx")
        else:
            self.muVetoPt5IsoIdVtx_branch.SetAddress(<void*>&self.muVetoPt5IsoIdVtx_value)

        #print "making muVetoZH"
        self.muVetoZH_branch = the_tree.GetBranch("muVetoZH")
        #if not self.muVetoZH_branch and "muVetoZH" not in self.complained:
        if not self.muVetoZH_branch and "muVetoZH":
            warnings.warn( "EETauTauTree: Expected branch muVetoZH does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("muVetoZH")
        else:
            self.muVetoZH_branch.SetAddress(<void*>&self.muVetoZH_value)

        #print "making mva_metEt"
        self.mva_metEt_branch = the_tree.GetBranch("mva_metEt")
        #if not self.mva_metEt_branch and "mva_metEt" not in self.complained:
        if not self.mva_metEt_branch and "mva_metEt":
            warnings.warn( "EETauTauTree: Expected branch mva_metEt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mva_metEt")
        else:
            self.mva_metEt_branch.SetAddress(<void*>&self.mva_metEt_value)

        #print "making mva_metPhi"
        self.mva_metPhi_branch = the_tree.GetBranch("mva_metPhi")
        #if not self.mva_metPhi_branch and "mva_metPhi" not in self.complained:
        if not self.mva_metPhi_branch and "mva_metPhi":
            warnings.warn( "EETauTauTree: Expected branch mva_metPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mva_metPhi")
        else:
            self.mva_metPhi_branch.SetAddress(<void*>&self.mva_metPhi_value)

        #print "making nTruePU"
        self.nTruePU_branch = the_tree.GetBranch("nTruePU")
        #if not self.nTruePU_branch and "nTruePU" not in self.complained:
        if not self.nTruePU_branch and "nTruePU":
            warnings.warn( "EETauTauTree: Expected branch nTruePU does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("nTruePU")
        else:
            self.nTruePU_branch.SetAddress(<void*>&self.nTruePU_value)

        #print "making nvtx"
        self.nvtx_branch = the_tree.GetBranch("nvtx")
        #if not self.nvtx_branch and "nvtx" not in self.complained:
        if not self.nvtx_branch and "nvtx":
            warnings.warn( "EETauTauTree: Expected branch nvtx does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("nvtx")
        else:
            self.nvtx_branch.SetAddress(<void*>&self.nvtx_value)

        #print "making pfMetEt"
        self.pfMetEt_branch = the_tree.GetBranch("pfMetEt")
        #if not self.pfMetEt_branch and "pfMetEt" not in self.complained:
        if not self.pfMetEt_branch and "pfMetEt":
            warnings.warn( "EETauTauTree: Expected branch pfMetEt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pfMetEt")
        else:
            self.pfMetEt_branch.SetAddress(<void*>&self.pfMetEt_value)

        #print "making pfMetPhi"
        self.pfMetPhi_branch = the_tree.GetBranch("pfMetPhi")
        #if not self.pfMetPhi_branch and "pfMetPhi" not in self.complained:
        if not self.pfMetPhi_branch and "pfMetPhi":
            warnings.warn( "EETauTauTree: Expected branch pfMetPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pfMetPhi")
        else:
            self.pfMetPhi_branch.SetAddress(<void*>&self.pfMetPhi_value)

        #print "making pfMet_jes_Et"
        self.pfMet_jes_Et_branch = the_tree.GetBranch("pfMet_jes_Et")
        #if not self.pfMet_jes_Et_branch and "pfMet_jes_Et" not in self.complained:
        if not self.pfMet_jes_Et_branch and "pfMet_jes_Et":
            warnings.warn( "EETauTauTree: Expected branch pfMet_jes_Et does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pfMet_jes_Et")
        else:
            self.pfMet_jes_Et_branch.SetAddress(<void*>&self.pfMet_jes_Et_value)

        #print "making pfMet_jes_Phi"
        self.pfMet_jes_Phi_branch = the_tree.GetBranch("pfMet_jes_Phi")
        #if not self.pfMet_jes_Phi_branch and "pfMet_jes_Phi" not in self.complained:
        if not self.pfMet_jes_Phi_branch and "pfMet_jes_Phi":
            warnings.warn( "EETauTauTree: Expected branch pfMet_jes_Phi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pfMet_jes_Phi")
        else:
            self.pfMet_jes_Phi_branch.SetAddress(<void*>&self.pfMet_jes_Phi_value)

        #print "making pfMet_mes_Et"
        self.pfMet_mes_Et_branch = the_tree.GetBranch("pfMet_mes_Et")
        #if not self.pfMet_mes_Et_branch and "pfMet_mes_Et" not in self.complained:
        if not self.pfMet_mes_Et_branch and "pfMet_mes_Et":
            warnings.warn( "EETauTauTree: Expected branch pfMet_mes_Et does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pfMet_mes_Et")
        else:
            self.pfMet_mes_Et_branch.SetAddress(<void*>&self.pfMet_mes_Et_value)

        #print "making pfMet_mes_Phi"
        self.pfMet_mes_Phi_branch = the_tree.GetBranch("pfMet_mes_Phi")
        #if not self.pfMet_mes_Phi_branch and "pfMet_mes_Phi" not in self.complained:
        if not self.pfMet_mes_Phi_branch and "pfMet_mes_Phi":
            warnings.warn( "EETauTauTree: Expected branch pfMet_mes_Phi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pfMet_mes_Phi")
        else:
            self.pfMet_mes_Phi_branch.SetAddress(<void*>&self.pfMet_mes_Phi_value)

        #print "making pfMet_tes_Et"
        self.pfMet_tes_Et_branch = the_tree.GetBranch("pfMet_tes_Et")
        #if not self.pfMet_tes_Et_branch and "pfMet_tes_Et" not in self.complained:
        if not self.pfMet_tes_Et_branch and "pfMet_tes_Et":
            warnings.warn( "EETauTauTree: Expected branch pfMet_tes_Et does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pfMet_tes_Et")
        else:
            self.pfMet_tes_Et_branch.SetAddress(<void*>&self.pfMet_tes_Et_value)

        #print "making pfMet_tes_Phi"
        self.pfMet_tes_Phi_branch = the_tree.GetBranch("pfMet_tes_Phi")
        #if not self.pfMet_tes_Phi_branch and "pfMet_tes_Phi" not in self.complained:
        if not self.pfMet_tes_Phi_branch and "pfMet_tes_Phi":
            warnings.warn( "EETauTauTree: Expected branch pfMet_tes_Phi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pfMet_tes_Phi")
        else:
            self.pfMet_tes_Phi_branch.SetAddress(<void*>&self.pfMet_tes_Phi_value)

        #print "making pfMet_ues_Et"
        self.pfMet_ues_Et_branch = the_tree.GetBranch("pfMet_ues_Et")
        #if not self.pfMet_ues_Et_branch and "pfMet_ues_Et" not in self.complained:
        if not self.pfMet_ues_Et_branch and "pfMet_ues_Et":
            warnings.warn( "EETauTauTree: Expected branch pfMet_ues_Et does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pfMet_ues_Et")
        else:
            self.pfMet_ues_Et_branch.SetAddress(<void*>&self.pfMet_ues_Et_value)

        #print "making pfMet_ues_Phi"
        self.pfMet_ues_Phi_branch = the_tree.GetBranch("pfMet_ues_Phi")
        #if not self.pfMet_ues_Phi_branch and "pfMet_ues_Phi" not in self.complained:
        if not self.pfMet_ues_Phi_branch and "pfMet_ues_Phi":
            warnings.warn( "EETauTauTree: Expected branch pfMet_ues_Phi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pfMet_ues_Phi")
        else:
            self.pfMet_ues_Phi_branch.SetAddress(<void*>&self.pfMet_ues_Phi_value)

        #print "making processID"
        self.processID_branch = the_tree.GetBranch("processID")
        #if not self.processID_branch and "processID" not in self.complained:
        if not self.processID_branch and "processID":
            warnings.warn( "EETauTauTree: Expected branch processID does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("processID")
        else:
            self.processID_branch.SetAddress(<void*>&self.processID_value)

        #print "making pvChi2"
        self.pvChi2_branch = the_tree.GetBranch("pvChi2")
        #if not self.pvChi2_branch and "pvChi2" not in self.complained:
        if not self.pvChi2_branch and "pvChi2":
            warnings.warn( "EETauTauTree: Expected branch pvChi2 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pvChi2")
        else:
            self.pvChi2_branch.SetAddress(<void*>&self.pvChi2_value)

        #print "making pvDX"
        self.pvDX_branch = the_tree.GetBranch("pvDX")
        #if not self.pvDX_branch and "pvDX" not in self.complained:
        if not self.pvDX_branch and "pvDX":
            warnings.warn( "EETauTauTree: Expected branch pvDX does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pvDX")
        else:
            self.pvDX_branch.SetAddress(<void*>&self.pvDX_value)

        #print "making pvDY"
        self.pvDY_branch = the_tree.GetBranch("pvDY")
        #if not self.pvDY_branch and "pvDY" not in self.complained:
        if not self.pvDY_branch and "pvDY":
            warnings.warn( "EETauTauTree: Expected branch pvDY does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pvDY")
        else:
            self.pvDY_branch.SetAddress(<void*>&self.pvDY_value)

        #print "making pvDZ"
        self.pvDZ_branch = the_tree.GetBranch("pvDZ")
        #if not self.pvDZ_branch and "pvDZ" not in self.complained:
        if not self.pvDZ_branch and "pvDZ":
            warnings.warn( "EETauTauTree: Expected branch pvDZ does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pvDZ")
        else:
            self.pvDZ_branch.SetAddress(<void*>&self.pvDZ_value)

        #print "making pvIsFake"
        self.pvIsFake_branch = the_tree.GetBranch("pvIsFake")
        #if not self.pvIsFake_branch and "pvIsFake" not in self.complained:
        if not self.pvIsFake_branch and "pvIsFake":
            warnings.warn( "EETauTauTree: Expected branch pvIsFake does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pvIsFake")
        else:
            self.pvIsFake_branch.SetAddress(<void*>&self.pvIsFake_value)

        #print "making pvIsValid"
        self.pvIsValid_branch = the_tree.GetBranch("pvIsValid")
        #if not self.pvIsValid_branch and "pvIsValid" not in self.complained:
        if not self.pvIsValid_branch and "pvIsValid":
            warnings.warn( "EETauTauTree: Expected branch pvIsValid does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pvIsValid")
        else:
            self.pvIsValid_branch.SetAddress(<void*>&self.pvIsValid_value)

        #print "making pvNormChi2"
        self.pvNormChi2_branch = the_tree.GetBranch("pvNormChi2")
        #if not self.pvNormChi2_branch and "pvNormChi2" not in self.complained:
        if not self.pvNormChi2_branch and "pvNormChi2":
            warnings.warn( "EETauTauTree: Expected branch pvNormChi2 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pvNormChi2")
        else:
            self.pvNormChi2_branch.SetAddress(<void*>&self.pvNormChi2_value)

        #print "making pvX"
        self.pvX_branch = the_tree.GetBranch("pvX")
        #if not self.pvX_branch and "pvX" not in self.complained:
        if not self.pvX_branch and "pvX":
            warnings.warn( "EETauTauTree: Expected branch pvX does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pvX")
        else:
            self.pvX_branch.SetAddress(<void*>&self.pvX_value)

        #print "making pvY"
        self.pvY_branch = the_tree.GetBranch("pvY")
        #if not self.pvY_branch and "pvY" not in self.complained:
        if not self.pvY_branch and "pvY":
            warnings.warn( "EETauTauTree: Expected branch pvY does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pvY")
        else:
            self.pvY_branch.SetAddress(<void*>&self.pvY_value)

        #print "making pvZ"
        self.pvZ_branch = the_tree.GetBranch("pvZ")
        #if not self.pvZ_branch and "pvZ" not in self.complained:
        if not self.pvZ_branch and "pvZ":
            warnings.warn( "EETauTauTree: Expected branch pvZ does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pvZ")
        else:
            self.pvZ_branch.SetAddress(<void*>&self.pvZ_value)

        #print "making pvndof"
        self.pvndof_branch = the_tree.GetBranch("pvndof")
        #if not self.pvndof_branch and "pvndof" not in self.complained:
        if not self.pvndof_branch and "pvndof":
            warnings.warn( "EETauTauTree: Expected branch pvndof does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pvndof")
        else:
            self.pvndof_branch.SetAddress(<void*>&self.pvndof_value)

        #print "making recoilDaught"
        self.recoilDaught_branch = the_tree.GetBranch("recoilDaught")
        #if not self.recoilDaught_branch and "recoilDaught" not in self.complained:
        if not self.recoilDaught_branch and "recoilDaught":
            warnings.warn( "EETauTauTree: Expected branch recoilDaught does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("recoilDaught")
        else:
            self.recoilDaught_branch.SetAddress(<void*>&self.recoilDaught_value)

        #print "making recoilWithMet"
        self.recoilWithMet_branch = the_tree.GetBranch("recoilWithMet")
        #if not self.recoilWithMet_branch and "recoilWithMet" not in self.complained:
        if not self.recoilWithMet_branch and "recoilWithMet":
            warnings.warn( "EETauTauTree: Expected branch recoilWithMet does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("recoilWithMet")
        else:
            self.recoilWithMet_branch.SetAddress(<void*>&self.recoilWithMet_value)

        #print "making rho"
        self.rho_branch = the_tree.GetBranch("rho")
        #if not self.rho_branch and "rho" not in self.complained:
        if not self.rho_branch and "rho":
            warnings.warn( "EETauTauTree: Expected branch rho does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("rho")
        else:
            self.rho_branch.SetAddress(<void*>&self.rho_value)

        #print "making run"
        self.run_branch = the_tree.GetBranch("run")
        #if not self.run_branch and "run" not in self.complained:
        if not self.run_branch and "run":
            warnings.warn( "EETauTauTree: Expected branch run does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("run")
        else:
            self.run_branch.SetAddress(<void*>&self.run_value)

        #print "making singleEGroup"
        self.singleEGroup_branch = the_tree.GetBranch("singleEGroup")
        #if not self.singleEGroup_branch and "singleEGroup" not in self.complained:
        if not self.singleEGroup_branch and "singleEGroup":
            warnings.warn( "EETauTauTree: Expected branch singleEGroup does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleEGroup")
        else:
            self.singleEGroup_branch.SetAddress(<void*>&self.singleEGroup_value)

        #print "making singleEPFMTGroup"
        self.singleEPFMTGroup_branch = the_tree.GetBranch("singleEPFMTGroup")
        #if not self.singleEPFMTGroup_branch and "singleEPFMTGroup" not in self.complained:
        if not self.singleEPFMTGroup_branch and "singleEPFMTGroup":
            warnings.warn( "EETauTauTree: Expected branch singleEPFMTGroup does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleEPFMTGroup")
        else:
            self.singleEPFMTGroup_branch.SetAddress(<void*>&self.singleEPFMTGroup_value)

        #print "making singleEPFMTPass"
        self.singleEPFMTPass_branch = the_tree.GetBranch("singleEPFMTPass")
        #if not self.singleEPFMTPass_branch and "singleEPFMTPass" not in self.complained:
        if not self.singleEPFMTPass_branch and "singleEPFMTPass":
            warnings.warn( "EETauTauTree: Expected branch singleEPFMTPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleEPFMTPass")
        else:
            self.singleEPFMTPass_branch.SetAddress(<void*>&self.singleEPFMTPass_value)

        #print "making singleEPFMTPrescale"
        self.singleEPFMTPrescale_branch = the_tree.GetBranch("singleEPFMTPrescale")
        #if not self.singleEPFMTPrescale_branch and "singleEPFMTPrescale" not in self.complained:
        if not self.singleEPFMTPrescale_branch and "singleEPFMTPrescale":
            warnings.warn( "EETauTauTree: Expected branch singleEPFMTPrescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleEPFMTPrescale")
        else:
            self.singleEPFMTPrescale_branch.SetAddress(<void*>&self.singleEPFMTPrescale_value)

        #print "making singleEPass"
        self.singleEPass_branch = the_tree.GetBranch("singleEPass")
        #if not self.singleEPass_branch and "singleEPass" not in self.complained:
        if not self.singleEPass_branch and "singleEPass":
            warnings.warn( "EETauTauTree: Expected branch singleEPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleEPass")
        else:
            self.singleEPass_branch.SetAddress(<void*>&self.singleEPass_value)

        #print "making singleEPrescale"
        self.singleEPrescale_branch = the_tree.GetBranch("singleEPrescale")
        #if not self.singleEPrescale_branch and "singleEPrescale" not in self.complained:
        if not self.singleEPrescale_branch and "singleEPrescale":
            warnings.warn( "EETauTauTree: Expected branch singleEPrescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleEPrescale")
        else:
            self.singleEPrescale_branch.SetAddress(<void*>&self.singleEPrescale_value)

        #print "making singleMuGroup"
        self.singleMuGroup_branch = the_tree.GetBranch("singleMuGroup")
        #if not self.singleMuGroup_branch and "singleMuGroup" not in self.complained:
        if not self.singleMuGroup_branch and "singleMuGroup":
            warnings.warn( "EETauTauTree: Expected branch singleMuGroup does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleMuGroup")
        else:
            self.singleMuGroup_branch.SetAddress(<void*>&self.singleMuGroup_value)

        #print "making singleMuPass"
        self.singleMuPass_branch = the_tree.GetBranch("singleMuPass")
        #if not self.singleMuPass_branch and "singleMuPass" not in self.complained:
        if not self.singleMuPass_branch and "singleMuPass":
            warnings.warn( "EETauTauTree: Expected branch singleMuPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleMuPass")
        else:
            self.singleMuPass_branch.SetAddress(<void*>&self.singleMuPass_value)

        #print "making singleMuPrescale"
        self.singleMuPrescale_branch = the_tree.GetBranch("singleMuPrescale")
        #if not self.singleMuPrescale_branch and "singleMuPrescale" not in self.complained:
        if not self.singleMuPrescale_branch and "singleMuPrescale":
            warnings.warn( "EETauTauTree: Expected branch singleMuPrescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleMuPrescale")
        else:
            self.singleMuPrescale_branch.SetAddress(<void*>&self.singleMuPrescale_value)

        #print "making singlePhoGroup"
        self.singlePhoGroup_branch = the_tree.GetBranch("singlePhoGroup")
        #if not self.singlePhoGroup_branch and "singlePhoGroup" not in self.complained:
        if not self.singlePhoGroup_branch and "singlePhoGroup":
            warnings.warn( "EETauTauTree: Expected branch singlePhoGroup does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singlePhoGroup")
        else:
            self.singlePhoGroup_branch.SetAddress(<void*>&self.singlePhoGroup_value)

        #print "making singlePhoPass"
        self.singlePhoPass_branch = the_tree.GetBranch("singlePhoPass")
        #if not self.singlePhoPass_branch and "singlePhoPass" not in self.complained:
        if not self.singlePhoPass_branch and "singlePhoPass":
            warnings.warn( "EETauTauTree: Expected branch singlePhoPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singlePhoPass")
        else:
            self.singlePhoPass_branch.SetAddress(<void*>&self.singlePhoPass_value)

        #print "making singlePhoPrescale"
        self.singlePhoPrescale_branch = the_tree.GetBranch("singlePhoPrescale")
        #if not self.singlePhoPrescale_branch and "singlePhoPrescale" not in self.complained:
        if not self.singlePhoPrescale_branch and "singlePhoPrescale":
            warnings.warn( "EETauTauTree: Expected branch singlePhoPrescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singlePhoPrescale")
        else:
            self.singlePhoPrescale_branch.SetAddress(<void*>&self.singlePhoPrescale_value)

        #print "making t1AbsEta"
        self.t1AbsEta_branch = the_tree.GetBranch("t1AbsEta")
        #if not self.t1AbsEta_branch and "t1AbsEta" not in self.complained:
        if not self.t1AbsEta_branch and "t1AbsEta":
            warnings.warn( "EETauTauTree: Expected branch t1AbsEta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t1AbsEta")
        else:
            self.t1AbsEta_branch.SetAddress(<void*>&self.t1AbsEta_value)

        #print "making t1AntiElectronLoose"
        self.t1AntiElectronLoose_branch = the_tree.GetBranch("t1AntiElectronLoose")
        #if not self.t1AntiElectronLoose_branch and "t1AntiElectronLoose" not in self.complained:
        if not self.t1AntiElectronLoose_branch and "t1AntiElectronLoose":
            warnings.warn( "EETauTauTree: Expected branch t1AntiElectronLoose does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t1AntiElectronLoose")
        else:
            self.t1AntiElectronLoose_branch.SetAddress(<void*>&self.t1AntiElectronLoose_value)

        #print "making t1AntiElectronMVA3Loose"
        self.t1AntiElectronMVA3Loose_branch = the_tree.GetBranch("t1AntiElectronMVA3Loose")
        #if not self.t1AntiElectronMVA3Loose_branch and "t1AntiElectronMVA3Loose" not in self.complained:
        if not self.t1AntiElectronMVA3Loose_branch and "t1AntiElectronMVA3Loose":
            warnings.warn( "EETauTauTree: Expected branch t1AntiElectronMVA3Loose does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t1AntiElectronMVA3Loose")
        else:
            self.t1AntiElectronMVA3Loose_branch.SetAddress(<void*>&self.t1AntiElectronMVA3Loose_value)

        #print "making t1AntiElectronMVA3Medium"
        self.t1AntiElectronMVA3Medium_branch = the_tree.GetBranch("t1AntiElectronMVA3Medium")
        #if not self.t1AntiElectronMVA3Medium_branch and "t1AntiElectronMVA3Medium" not in self.complained:
        if not self.t1AntiElectronMVA3Medium_branch and "t1AntiElectronMVA3Medium":
            warnings.warn( "EETauTauTree: Expected branch t1AntiElectronMVA3Medium does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t1AntiElectronMVA3Medium")
        else:
            self.t1AntiElectronMVA3Medium_branch.SetAddress(<void*>&self.t1AntiElectronMVA3Medium_value)

        #print "making t1AntiElectronMVA3Raw"
        self.t1AntiElectronMVA3Raw_branch = the_tree.GetBranch("t1AntiElectronMVA3Raw")
        #if not self.t1AntiElectronMVA3Raw_branch and "t1AntiElectronMVA3Raw" not in self.complained:
        if not self.t1AntiElectronMVA3Raw_branch and "t1AntiElectronMVA3Raw":
            warnings.warn( "EETauTauTree: Expected branch t1AntiElectronMVA3Raw does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t1AntiElectronMVA3Raw")
        else:
            self.t1AntiElectronMVA3Raw_branch.SetAddress(<void*>&self.t1AntiElectronMVA3Raw_value)

        #print "making t1AntiElectronMVA3Tight"
        self.t1AntiElectronMVA3Tight_branch = the_tree.GetBranch("t1AntiElectronMVA3Tight")
        #if not self.t1AntiElectronMVA3Tight_branch and "t1AntiElectronMVA3Tight" not in self.complained:
        if not self.t1AntiElectronMVA3Tight_branch and "t1AntiElectronMVA3Tight":
            warnings.warn( "EETauTauTree: Expected branch t1AntiElectronMVA3Tight does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t1AntiElectronMVA3Tight")
        else:
            self.t1AntiElectronMVA3Tight_branch.SetAddress(<void*>&self.t1AntiElectronMVA3Tight_value)

        #print "making t1AntiElectronMVA3VTight"
        self.t1AntiElectronMVA3VTight_branch = the_tree.GetBranch("t1AntiElectronMVA3VTight")
        #if not self.t1AntiElectronMVA3VTight_branch and "t1AntiElectronMVA3VTight" not in self.complained:
        if not self.t1AntiElectronMVA3VTight_branch and "t1AntiElectronMVA3VTight":
            warnings.warn( "EETauTauTree: Expected branch t1AntiElectronMVA3VTight does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t1AntiElectronMVA3VTight")
        else:
            self.t1AntiElectronMVA3VTight_branch.SetAddress(<void*>&self.t1AntiElectronMVA3VTight_value)

        #print "making t1AntiElectronMedium"
        self.t1AntiElectronMedium_branch = the_tree.GetBranch("t1AntiElectronMedium")
        #if not self.t1AntiElectronMedium_branch and "t1AntiElectronMedium" not in self.complained:
        if not self.t1AntiElectronMedium_branch and "t1AntiElectronMedium":
            warnings.warn( "EETauTauTree: Expected branch t1AntiElectronMedium does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t1AntiElectronMedium")
        else:
            self.t1AntiElectronMedium_branch.SetAddress(<void*>&self.t1AntiElectronMedium_value)

        #print "making t1AntiElectronTight"
        self.t1AntiElectronTight_branch = the_tree.GetBranch("t1AntiElectronTight")
        #if not self.t1AntiElectronTight_branch and "t1AntiElectronTight" not in self.complained:
        if not self.t1AntiElectronTight_branch and "t1AntiElectronTight":
            warnings.warn( "EETauTauTree: Expected branch t1AntiElectronTight does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t1AntiElectronTight")
        else:
            self.t1AntiElectronTight_branch.SetAddress(<void*>&self.t1AntiElectronTight_value)

        #print "making t1AntiMuonLoose"
        self.t1AntiMuonLoose_branch = the_tree.GetBranch("t1AntiMuonLoose")
        #if not self.t1AntiMuonLoose_branch and "t1AntiMuonLoose" not in self.complained:
        if not self.t1AntiMuonLoose_branch and "t1AntiMuonLoose":
            warnings.warn( "EETauTauTree: Expected branch t1AntiMuonLoose does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t1AntiMuonLoose")
        else:
            self.t1AntiMuonLoose_branch.SetAddress(<void*>&self.t1AntiMuonLoose_value)

        #print "making t1AntiMuonLoose2"
        self.t1AntiMuonLoose2_branch = the_tree.GetBranch("t1AntiMuonLoose2")
        #if not self.t1AntiMuonLoose2_branch and "t1AntiMuonLoose2" not in self.complained:
        if not self.t1AntiMuonLoose2_branch and "t1AntiMuonLoose2":
            warnings.warn( "EETauTauTree: Expected branch t1AntiMuonLoose2 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t1AntiMuonLoose2")
        else:
            self.t1AntiMuonLoose2_branch.SetAddress(<void*>&self.t1AntiMuonLoose2_value)

        #print "making t1AntiMuonMedium"
        self.t1AntiMuonMedium_branch = the_tree.GetBranch("t1AntiMuonMedium")
        #if not self.t1AntiMuonMedium_branch and "t1AntiMuonMedium" not in self.complained:
        if not self.t1AntiMuonMedium_branch and "t1AntiMuonMedium":
            warnings.warn( "EETauTauTree: Expected branch t1AntiMuonMedium does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t1AntiMuonMedium")
        else:
            self.t1AntiMuonMedium_branch.SetAddress(<void*>&self.t1AntiMuonMedium_value)

        #print "making t1AntiMuonMedium2"
        self.t1AntiMuonMedium2_branch = the_tree.GetBranch("t1AntiMuonMedium2")
        #if not self.t1AntiMuonMedium2_branch and "t1AntiMuonMedium2" not in self.complained:
        if not self.t1AntiMuonMedium2_branch and "t1AntiMuonMedium2":
            warnings.warn( "EETauTauTree: Expected branch t1AntiMuonMedium2 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t1AntiMuonMedium2")
        else:
            self.t1AntiMuonMedium2_branch.SetAddress(<void*>&self.t1AntiMuonMedium2_value)

        #print "making t1AntiMuonTight"
        self.t1AntiMuonTight_branch = the_tree.GetBranch("t1AntiMuonTight")
        #if not self.t1AntiMuonTight_branch and "t1AntiMuonTight" not in self.complained:
        if not self.t1AntiMuonTight_branch and "t1AntiMuonTight":
            warnings.warn( "EETauTauTree: Expected branch t1AntiMuonTight does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t1AntiMuonTight")
        else:
            self.t1AntiMuonTight_branch.SetAddress(<void*>&self.t1AntiMuonTight_value)

        #print "making t1AntiMuonTight2"
        self.t1AntiMuonTight2_branch = the_tree.GetBranch("t1AntiMuonTight2")
        #if not self.t1AntiMuonTight2_branch and "t1AntiMuonTight2" not in self.complained:
        if not self.t1AntiMuonTight2_branch and "t1AntiMuonTight2":
            warnings.warn( "EETauTauTree: Expected branch t1AntiMuonTight2 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t1AntiMuonTight2")
        else:
            self.t1AntiMuonTight2_branch.SetAddress(<void*>&self.t1AntiMuonTight2_value)

        #print "making t1Charge"
        self.t1Charge_branch = the_tree.GetBranch("t1Charge")
        #if not self.t1Charge_branch and "t1Charge" not in self.complained:
        if not self.t1Charge_branch and "t1Charge":
            warnings.warn( "EETauTauTree: Expected branch t1Charge does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t1Charge")
        else:
            self.t1Charge_branch.SetAddress(<void*>&self.t1Charge_value)

        #print "making t1CiCTightElecOverlap"
        self.t1CiCTightElecOverlap_branch = the_tree.GetBranch("t1CiCTightElecOverlap")
        #if not self.t1CiCTightElecOverlap_branch and "t1CiCTightElecOverlap" not in self.complained:
        if not self.t1CiCTightElecOverlap_branch and "t1CiCTightElecOverlap":
            warnings.warn( "EETauTauTree: Expected branch t1CiCTightElecOverlap does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t1CiCTightElecOverlap")
        else:
            self.t1CiCTightElecOverlap_branch.SetAddress(<void*>&self.t1CiCTightElecOverlap_value)

        #print "making t1DZ"
        self.t1DZ_branch = the_tree.GetBranch("t1DZ")
        #if not self.t1DZ_branch and "t1DZ" not in self.complained:
        if not self.t1DZ_branch and "t1DZ":
            warnings.warn( "EETauTauTree: Expected branch t1DZ does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t1DZ")
        else:
            self.t1DZ_branch.SetAddress(<void*>&self.t1DZ_value)

        #print "making t1DecayFinding"
        self.t1DecayFinding_branch = the_tree.GetBranch("t1DecayFinding")
        #if not self.t1DecayFinding_branch and "t1DecayFinding" not in self.complained:
        if not self.t1DecayFinding_branch and "t1DecayFinding":
            warnings.warn( "EETauTauTree: Expected branch t1DecayFinding does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t1DecayFinding")
        else:
            self.t1DecayFinding_branch.SetAddress(<void*>&self.t1DecayFinding_value)

        #print "making t1DecayMode"
        self.t1DecayMode_branch = the_tree.GetBranch("t1DecayMode")
        #if not self.t1DecayMode_branch and "t1DecayMode" not in self.complained:
        if not self.t1DecayMode_branch and "t1DecayMode":
            warnings.warn( "EETauTauTree: Expected branch t1DecayMode does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t1DecayMode")
        else:
            self.t1DecayMode_branch.SetAddress(<void*>&self.t1DecayMode_value)

        #print "making t1ElecOverlap"
        self.t1ElecOverlap_branch = the_tree.GetBranch("t1ElecOverlap")
        #if not self.t1ElecOverlap_branch and "t1ElecOverlap" not in self.complained:
        if not self.t1ElecOverlap_branch and "t1ElecOverlap":
            warnings.warn( "EETauTauTree: Expected branch t1ElecOverlap does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t1ElecOverlap")
        else:
            self.t1ElecOverlap_branch.SetAddress(<void*>&self.t1ElecOverlap_value)

        #print "making t1ElecOverlapZHLoose"
        self.t1ElecOverlapZHLoose_branch = the_tree.GetBranch("t1ElecOverlapZHLoose")
        #if not self.t1ElecOverlapZHLoose_branch and "t1ElecOverlapZHLoose" not in self.complained:
        if not self.t1ElecOverlapZHLoose_branch and "t1ElecOverlapZHLoose":
            warnings.warn( "EETauTauTree: Expected branch t1ElecOverlapZHLoose does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t1ElecOverlapZHLoose")
        else:
            self.t1ElecOverlapZHLoose_branch.SetAddress(<void*>&self.t1ElecOverlapZHLoose_value)

        #print "making t1ElecOverlapZHTight"
        self.t1ElecOverlapZHTight_branch = the_tree.GetBranch("t1ElecOverlapZHTight")
        #if not self.t1ElecOverlapZHTight_branch and "t1ElecOverlapZHTight" not in self.complained:
        if not self.t1ElecOverlapZHTight_branch and "t1ElecOverlapZHTight":
            warnings.warn( "EETauTauTree: Expected branch t1ElecOverlapZHTight does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t1ElecOverlapZHTight")
        else:
            self.t1ElecOverlapZHTight_branch.SetAddress(<void*>&self.t1ElecOverlapZHTight_value)

        #print "making t1Eta"
        self.t1Eta_branch = the_tree.GetBranch("t1Eta")
        #if not self.t1Eta_branch and "t1Eta" not in self.complained:
        if not self.t1Eta_branch and "t1Eta":
            warnings.warn( "EETauTauTree: Expected branch t1Eta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t1Eta")
        else:
            self.t1Eta_branch.SetAddress(<void*>&self.t1Eta_value)

        #print "making t1GenDecayMode"
        self.t1GenDecayMode_branch = the_tree.GetBranch("t1GenDecayMode")
        #if not self.t1GenDecayMode_branch and "t1GenDecayMode" not in self.complained:
        if not self.t1GenDecayMode_branch and "t1GenDecayMode":
            warnings.warn( "EETauTauTree: Expected branch t1GenDecayMode does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t1GenDecayMode")
        else:
            self.t1GenDecayMode_branch.SetAddress(<void*>&self.t1GenDecayMode_value)

        #print "making t1IP3DS"
        self.t1IP3DS_branch = the_tree.GetBranch("t1IP3DS")
        #if not self.t1IP3DS_branch and "t1IP3DS" not in self.complained:
        if not self.t1IP3DS_branch and "t1IP3DS":
            warnings.warn( "EETauTauTree: Expected branch t1IP3DS does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t1IP3DS")
        else:
            self.t1IP3DS_branch.SetAddress(<void*>&self.t1IP3DS_value)

        #print "making t1JetArea"
        self.t1JetArea_branch = the_tree.GetBranch("t1JetArea")
        #if not self.t1JetArea_branch and "t1JetArea" not in self.complained:
        if not self.t1JetArea_branch and "t1JetArea":
            warnings.warn( "EETauTauTree: Expected branch t1JetArea does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t1JetArea")
        else:
            self.t1JetArea_branch.SetAddress(<void*>&self.t1JetArea_value)

        #print "making t1JetBtag"
        self.t1JetBtag_branch = the_tree.GetBranch("t1JetBtag")
        #if not self.t1JetBtag_branch and "t1JetBtag" not in self.complained:
        if not self.t1JetBtag_branch and "t1JetBtag":
            warnings.warn( "EETauTauTree: Expected branch t1JetBtag does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t1JetBtag")
        else:
            self.t1JetBtag_branch.SetAddress(<void*>&self.t1JetBtag_value)

        #print "making t1JetCSVBtag"
        self.t1JetCSVBtag_branch = the_tree.GetBranch("t1JetCSVBtag")
        #if not self.t1JetCSVBtag_branch and "t1JetCSVBtag" not in self.complained:
        if not self.t1JetCSVBtag_branch and "t1JetCSVBtag":
            warnings.warn( "EETauTauTree: Expected branch t1JetCSVBtag does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t1JetCSVBtag")
        else:
            self.t1JetCSVBtag_branch.SetAddress(<void*>&self.t1JetCSVBtag_value)

        #print "making t1JetEtaEtaMoment"
        self.t1JetEtaEtaMoment_branch = the_tree.GetBranch("t1JetEtaEtaMoment")
        #if not self.t1JetEtaEtaMoment_branch and "t1JetEtaEtaMoment" not in self.complained:
        if not self.t1JetEtaEtaMoment_branch and "t1JetEtaEtaMoment":
            warnings.warn( "EETauTauTree: Expected branch t1JetEtaEtaMoment does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t1JetEtaEtaMoment")
        else:
            self.t1JetEtaEtaMoment_branch.SetAddress(<void*>&self.t1JetEtaEtaMoment_value)

        #print "making t1JetEtaPhiMoment"
        self.t1JetEtaPhiMoment_branch = the_tree.GetBranch("t1JetEtaPhiMoment")
        #if not self.t1JetEtaPhiMoment_branch and "t1JetEtaPhiMoment" not in self.complained:
        if not self.t1JetEtaPhiMoment_branch and "t1JetEtaPhiMoment":
            warnings.warn( "EETauTauTree: Expected branch t1JetEtaPhiMoment does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t1JetEtaPhiMoment")
        else:
            self.t1JetEtaPhiMoment_branch.SetAddress(<void*>&self.t1JetEtaPhiMoment_value)

        #print "making t1JetEtaPhiSpread"
        self.t1JetEtaPhiSpread_branch = the_tree.GetBranch("t1JetEtaPhiSpread")
        #if not self.t1JetEtaPhiSpread_branch and "t1JetEtaPhiSpread" not in self.complained:
        if not self.t1JetEtaPhiSpread_branch and "t1JetEtaPhiSpread":
            warnings.warn( "EETauTauTree: Expected branch t1JetEtaPhiSpread does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t1JetEtaPhiSpread")
        else:
            self.t1JetEtaPhiSpread_branch.SetAddress(<void*>&self.t1JetEtaPhiSpread_value)

        #print "making t1JetPartonFlavour"
        self.t1JetPartonFlavour_branch = the_tree.GetBranch("t1JetPartonFlavour")
        #if not self.t1JetPartonFlavour_branch and "t1JetPartonFlavour" not in self.complained:
        if not self.t1JetPartonFlavour_branch and "t1JetPartonFlavour":
            warnings.warn( "EETauTauTree: Expected branch t1JetPartonFlavour does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t1JetPartonFlavour")
        else:
            self.t1JetPartonFlavour_branch.SetAddress(<void*>&self.t1JetPartonFlavour_value)

        #print "making t1JetPhiPhiMoment"
        self.t1JetPhiPhiMoment_branch = the_tree.GetBranch("t1JetPhiPhiMoment")
        #if not self.t1JetPhiPhiMoment_branch and "t1JetPhiPhiMoment" not in self.complained:
        if not self.t1JetPhiPhiMoment_branch and "t1JetPhiPhiMoment":
            warnings.warn( "EETauTauTree: Expected branch t1JetPhiPhiMoment does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t1JetPhiPhiMoment")
        else:
            self.t1JetPhiPhiMoment_branch.SetAddress(<void*>&self.t1JetPhiPhiMoment_value)

        #print "making t1JetPt"
        self.t1JetPt_branch = the_tree.GetBranch("t1JetPt")
        #if not self.t1JetPt_branch and "t1JetPt" not in self.complained:
        if not self.t1JetPt_branch and "t1JetPt":
            warnings.warn( "EETauTauTree: Expected branch t1JetPt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t1JetPt")
        else:
            self.t1JetPt_branch.SetAddress(<void*>&self.t1JetPt_value)

        #print "making t1JetQGLikelihoodID"
        self.t1JetQGLikelihoodID_branch = the_tree.GetBranch("t1JetQGLikelihoodID")
        #if not self.t1JetQGLikelihoodID_branch and "t1JetQGLikelihoodID" not in self.complained:
        if not self.t1JetQGLikelihoodID_branch and "t1JetQGLikelihoodID":
            warnings.warn( "EETauTauTree: Expected branch t1JetQGLikelihoodID does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t1JetQGLikelihoodID")
        else:
            self.t1JetQGLikelihoodID_branch.SetAddress(<void*>&self.t1JetQGLikelihoodID_value)

        #print "making t1JetQGMVAID"
        self.t1JetQGMVAID_branch = the_tree.GetBranch("t1JetQGMVAID")
        #if not self.t1JetQGMVAID_branch and "t1JetQGMVAID" not in self.complained:
        if not self.t1JetQGMVAID_branch and "t1JetQGMVAID":
            warnings.warn( "EETauTauTree: Expected branch t1JetQGMVAID does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t1JetQGMVAID")
        else:
            self.t1JetQGMVAID_branch.SetAddress(<void*>&self.t1JetQGMVAID_value)

        #print "making t1Jetaxis1"
        self.t1Jetaxis1_branch = the_tree.GetBranch("t1Jetaxis1")
        #if not self.t1Jetaxis1_branch and "t1Jetaxis1" not in self.complained:
        if not self.t1Jetaxis1_branch and "t1Jetaxis1":
            warnings.warn( "EETauTauTree: Expected branch t1Jetaxis1 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t1Jetaxis1")
        else:
            self.t1Jetaxis1_branch.SetAddress(<void*>&self.t1Jetaxis1_value)

        #print "making t1Jetaxis2"
        self.t1Jetaxis2_branch = the_tree.GetBranch("t1Jetaxis2")
        #if not self.t1Jetaxis2_branch and "t1Jetaxis2" not in self.complained:
        if not self.t1Jetaxis2_branch and "t1Jetaxis2":
            warnings.warn( "EETauTauTree: Expected branch t1Jetaxis2 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t1Jetaxis2")
        else:
            self.t1Jetaxis2_branch.SetAddress(<void*>&self.t1Jetaxis2_value)

        #print "making t1Jetmult"
        self.t1Jetmult_branch = the_tree.GetBranch("t1Jetmult")
        #if not self.t1Jetmult_branch and "t1Jetmult" not in self.complained:
        if not self.t1Jetmult_branch and "t1Jetmult":
            warnings.warn( "EETauTauTree: Expected branch t1Jetmult does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t1Jetmult")
        else:
            self.t1Jetmult_branch.SetAddress(<void*>&self.t1Jetmult_value)

        #print "making t1JetmultMLP"
        self.t1JetmultMLP_branch = the_tree.GetBranch("t1JetmultMLP")
        #if not self.t1JetmultMLP_branch and "t1JetmultMLP" not in self.complained:
        if not self.t1JetmultMLP_branch and "t1JetmultMLP":
            warnings.warn( "EETauTauTree: Expected branch t1JetmultMLP does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t1JetmultMLP")
        else:
            self.t1JetmultMLP_branch.SetAddress(<void*>&self.t1JetmultMLP_value)

        #print "making t1JetmultMLPQC"
        self.t1JetmultMLPQC_branch = the_tree.GetBranch("t1JetmultMLPQC")
        #if not self.t1JetmultMLPQC_branch and "t1JetmultMLPQC" not in self.complained:
        if not self.t1JetmultMLPQC_branch and "t1JetmultMLPQC":
            warnings.warn( "EETauTauTree: Expected branch t1JetmultMLPQC does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t1JetmultMLPQC")
        else:
            self.t1JetmultMLPQC_branch.SetAddress(<void*>&self.t1JetmultMLPQC_value)

        #print "making t1JetptD"
        self.t1JetptD_branch = the_tree.GetBranch("t1JetptD")
        #if not self.t1JetptD_branch and "t1JetptD" not in self.complained:
        if not self.t1JetptD_branch and "t1JetptD":
            warnings.warn( "EETauTauTree: Expected branch t1JetptD does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t1JetptD")
        else:
            self.t1JetptD_branch.SetAddress(<void*>&self.t1JetptD_value)

        #print "making t1LeadTrackPt"
        self.t1LeadTrackPt_branch = the_tree.GetBranch("t1LeadTrackPt")
        #if not self.t1LeadTrackPt_branch and "t1LeadTrackPt" not in self.complained:
        if not self.t1LeadTrackPt_branch and "t1LeadTrackPt":
            warnings.warn( "EETauTauTree: Expected branch t1LeadTrackPt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t1LeadTrackPt")
        else:
            self.t1LeadTrackPt_branch.SetAddress(<void*>&self.t1LeadTrackPt_value)

        #print "making t1LooseIso"
        self.t1LooseIso_branch = the_tree.GetBranch("t1LooseIso")
        #if not self.t1LooseIso_branch and "t1LooseIso" not in self.complained:
        if not self.t1LooseIso_branch and "t1LooseIso":
            warnings.warn( "EETauTauTree: Expected branch t1LooseIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t1LooseIso")
        else:
            self.t1LooseIso_branch.SetAddress(<void*>&self.t1LooseIso_value)

        #print "making t1LooseIso3Hits"
        self.t1LooseIso3Hits_branch = the_tree.GetBranch("t1LooseIso3Hits")
        #if not self.t1LooseIso3Hits_branch and "t1LooseIso3Hits" not in self.complained:
        if not self.t1LooseIso3Hits_branch and "t1LooseIso3Hits":
            warnings.warn( "EETauTauTree: Expected branch t1LooseIso3Hits does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t1LooseIso3Hits")
        else:
            self.t1LooseIso3Hits_branch.SetAddress(<void*>&self.t1LooseIso3Hits_value)

        #print "making t1LooseMVA2Iso"
        self.t1LooseMVA2Iso_branch = the_tree.GetBranch("t1LooseMVA2Iso")
        #if not self.t1LooseMVA2Iso_branch and "t1LooseMVA2Iso" not in self.complained:
        if not self.t1LooseMVA2Iso_branch and "t1LooseMVA2Iso":
            warnings.warn( "EETauTauTree: Expected branch t1LooseMVA2Iso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t1LooseMVA2Iso")
        else:
            self.t1LooseMVA2Iso_branch.SetAddress(<void*>&self.t1LooseMVA2Iso_value)

        #print "making t1LooseMVAIso"
        self.t1LooseMVAIso_branch = the_tree.GetBranch("t1LooseMVAIso")
        #if not self.t1LooseMVAIso_branch and "t1LooseMVAIso" not in self.complained:
        if not self.t1LooseMVAIso_branch and "t1LooseMVAIso":
            warnings.warn( "EETauTauTree: Expected branch t1LooseMVAIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t1LooseMVAIso")
        else:
            self.t1LooseMVAIso_branch.SetAddress(<void*>&self.t1LooseMVAIso_value)

        #print "making t1MVA2IsoRaw"
        self.t1MVA2IsoRaw_branch = the_tree.GetBranch("t1MVA2IsoRaw")
        #if not self.t1MVA2IsoRaw_branch and "t1MVA2IsoRaw" not in self.complained:
        if not self.t1MVA2IsoRaw_branch and "t1MVA2IsoRaw":
            warnings.warn( "EETauTauTree: Expected branch t1MVA2IsoRaw does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t1MVA2IsoRaw")
        else:
            self.t1MVA2IsoRaw_branch.SetAddress(<void*>&self.t1MVA2IsoRaw_value)

        #print "making t1Mass"
        self.t1Mass_branch = the_tree.GetBranch("t1Mass")
        #if not self.t1Mass_branch and "t1Mass" not in self.complained:
        if not self.t1Mass_branch and "t1Mass":
            warnings.warn( "EETauTauTree: Expected branch t1Mass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t1Mass")
        else:
            self.t1Mass_branch.SetAddress(<void*>&self.t1Mass_value)

        #print "making t1MediumIso"
        self.t1MediumIso_branch = the_tree.GetBranch("t1MediumIso")
        #if not self.t1MediumIso_branch and "t1MediumIso" not in self.complained:
        if not self.t1MediumIso_branch and "t1MediumIso":
            warnings.warn( "EETauTauTree: Expected branch t1MediumIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t1MediumIso")
        else:
            self.t1MediumIso_branch.SetAddress(<void*>&self.t1MediumIso_value)

        #print "making t1MediumIso3Hits"
        self.t1MediumIso3Hits_branch = the_tree.GetBranch("t1MediumIso3Hits")
        #if not self.t1MediumIso3Hits_branch and "t1MediumIso3Hits" not in self.complained:
        if not self.t1MediumIso3Hits_branch and "t1MediumIso3Hits":
            warnings.warn( "EETauTauTree: Expected branch t1MediumIso3Hits does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t1MediumIso3Hits")
        else:
            self.t1MediumIso3Hits_branch.SetAddress(<void*>&self.t1MediumIso3Hits_value)

        #print "making t1MediumMVA2Iso"
        self.t1MediumMVA2Iso_branch = the_tree.GetBranch("t1MediumMVA2Iso")
        #if not self.t1MediumMVA2Iso_branch and "t1MediumMVA2Iso" not in self.complained:
        if not self.t1MediumMVA2Iso_branch and "t1MediumMVA2Iso":
            warnings.warn( "EETauTauTree: Expected branch t1MediumMVA2Iso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t1MediumMVA2Iso")
        else:
            self.t1MediumMVA2Iso_branch.SetAddress(<void*>&self.t1MediumMVA2Iso_value)

        #print "making t1MediumMVAIso"
        self.t1MediumMVAIso_branch = the_tree.GetBranch("t1MediumMVAIso")
        #if not self.t1MediumMVAIso_branch and "t1MediumMVAIso" not in self.complained:
        if not self.t1MediumMVAIso_branch and "t1MediumMVAIso":
            warnings.warn( "EETauTauTree: Expected branch t1MediumMVAIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t1MediumMVAIso")
        else:
            self.t1MediumMVAIso_branch.SetAddress(<void*>&self.t1MediumMVAIso_value)

        #print "making t1MtToMET"
        self.t1MtToMET_branch = the_tree.GetBranch("t1MtToMET")
        #if not self.t1MtToMET_branch and "t1MtToMET" not in self.complained:
        if not self.t1MtToMET_branch and "t1MtToMET":
            warnings.warn( "EETauTauTree: Expected branch t1MtToMET does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t1MtToMET")
        else:
            self.t1MtToMET_branch.SetAddress(<void*>&self.t1MtToMET_value)

        #print "making t1MtToMVAMET"
        self.t1MtToMVAMET_branch = the_tree.GetBranch("t1MtToMVAMET")
        #if not self.t1MtToMVAMET_branch and "t1MtToMVAMET" not in self.complained:
        if not self.t1MtToMVAMET_branch and "t1MtToMVAMET":
            warnings.warn( "EETauTauTree: Expected branch t1MtToMVAMET does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t1MtToMVAMET")
        else:
            self.t1MtToMVAMET_branch.SetAddress(<void*>&self.t1MtToMVAMET_value)

        #print "making t1MtToPFMET"
        self.t1MtToPFMET_branch = the_tree.GetBranch("t1MtToPFMET")
        #if not self.t1MtToPFMET_branch and "t1MtToPFMET" not in self.complained:
        if not self.t1MtToPFMET_branch and "t1MtToPFMET":
            warnings.warn( "EETauTauTree: Expected branch t1MtToPFMET does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t1MtToPFMET")
        else:
            self.t1MtToPFMET_branch.SetAddress(<void*>&self.t1MtToPFMET_value)

        #print "making t1MtToPfMet_Ty1"
        self.t1MtToPfMet_Ty1_branch = the_tree.GetBranch("t1MtToPfMet_Ty1")
        #if not self.t1MtToPfMet_Ty1_branch and "t1MtToPfMet_Ty1" not in self.complained:
        if not self.t1MtToPfMet_Ty1_branch and "t1MtToPfMet_Ty1":
            warnings.warn( "EETauTauTree: Expected branch t1MtToPfMet_Ty1 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t1MtToPfMet_Ty1")
        else:
            self.t1MtToPfMet_Ty1_branch.SetAddress(<void*>&self.t1MtToPfMet_Ty1_value)

        #print "making t1MtToPfMet_jes"
        self.t1MtToPfMet_jes_branch = the_tree.GetBranch("t1MtToPfMet_jes")
        #if not self.t1MtToPfMet_jes_branch and "t1MtToPfMet_jes" not in self.complained:
        if not self.t1MtToPfMet_jes_branch and "t1MtToPfMet_jes":
            warnings.warn( "EETauTauTree: Expected branch t1MtToPfMet_jes does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t1MtToPfMet_jes")
        else:
            self.t1MtToPfMet_jes_branch.SetAddress(<void*>&self.t1MtToPfMet_jes_value)

        #print "making t1MtToPfMet_mes"
        self.t1MtToPfMet_mes_branch = the_tree.GetBranch("t1MtToPfMet_mes")
        #if not self.t1MtToPfMet_mes_branch and "t1MtToPfMet_mes" not in self.complained:
        if not self.t1MtToPfMet_mes_branch and "t1MtToPfMet_mes":
            warnings.warn( "EETauTauTree: Expected branch t1MtToPfMet_mes does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t1MtToPfMet_mes")
        else:
            self.t1MtToPfMet_mes_branch.SetAddress(<void*>&self.t1MtToPfMet_mes_value)

        #print "making t1MtToPfMet_tes"
        self.t1MtToPfMet_tes_branch = the_tree.GetBranch("t1MtToPfMet_tes")
        #if not self.t1MtToPfMet_tes_branch and "t1MtToPfMet_tes" not in self.complained:
        if not self.t1MtToPfMet_tes_branch and "t1MtToPfMet_tes":
            warnings.warn( "EETauTauTree: Expected branch t1MtToPfMet_tes does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t1MtToPfMet_tes")
        else:
            self.t1MtToPfMet_tes_branch.SetAddress(<void*>&self.t1MtToPfMet_tes_value)

        #print "making t1MtToPfMet_ues"
        self.t1MtToPfMet_ues_branch = the_tree.GetBranch("t1MtToPfMet_ues")
        #if not self.t1MtToPfMet_ues_branch and "t1MtToPfMet_ues" not in self.complained:
        if not self.t1MtToPfMet_ues_branch and "t1MtToPfMet_ues":
            warnings.warn( "EETauTauTree: Expected branch t1MtToPfMet_ues does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t1MtToPfMet_ues")
        else:
            self.t1MtToPfMet_ues_branch.SetAddress(<void*>&self.t1MtToPfMet_ues_value)

        #print "making t1MuOverlap"
        self.t1MuOverlap_branch = the_tree.GetBranch("t1MuOverlap")
        #if not self.t1MuOverlap_branch and "t1MuOverlap" not in self.complained:
        if not self.t1MuOverlap_branch and "t1MuOverlap":
            warnings.warn( "EETauTauTree: Expected branch t1MuOverlap does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t1MuOverlap")
        else:
            self.t1MuOverlap_branch.SetAddress(<void*>&self.t1MuOverlap_value)

        #print "making t1MuOverlapZHLoose"
        self.t1MuOverlapZHLoose_branch = the_tree.GetBranch("t1MuOverlapZHLoose")
        #if not self.t1MuOverlapZHLoose_branch and "t1MuOverlapZHLoose" not in self.complained:
        if not self.t1MuOverlapZHLoose_branch and "t1MuOverlapZHLoose":
            warnings.warn( "EETauTauTree: Expected branch t1MuOverlapZHLoose does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t1MuOverlapZHLoose")
        else:
            self.t1MuOverlapZHLoose_branch.SetAddress(<void*>&self.t1MuOverlapZHLoose_value)

        #print "making t1MuOverlapZHTight"
        self.t1MuOverlapZHTight_branch = the_tree.GetBranch("t1MuOverlapZHTight")
        #if not self.t1MuOverlapZHTight_branch and "t1MuOverlapZHTight" not in self.complained:
        if not self.t1MuOverlapZHTight_branch and "t1MuOverlapZHTight":
            warnings.warn( "EETauTauTree: Expected branch t1MuOverlapZHTight does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t1MuOverlapZHTight")
        else:
            self.t1MuOverlapZHTight_branch.SetAddress(<void*>&self.t1MuOverlapZHTight_value)

        #print "making t1Phi"
        self.t1Phi_branch = the_tree.GetBranch("t1Phi")
        #if not self.t1Phi_branch and "t1Phi" not in self.complained:
        if not self.t1Phi_branch and "t1Phi":
            warnings.warn( "EETauTauTree: Expected branch t1Phi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t1Phi")
        else:
            self.t1Phi_branch.SetAddress(<void*>&self.t1Phi_value)

        #print "making t1Pt"
        self.t1Pt_branch = the_tree.GetBranch("t1Pt")
        #if not self.t1Pt_branch and "t1Pt" not in self.complained:
        if not self.t1Pt_branch and "t1Pt":
            warnings.warn( "EETauTauTree: Expected branch t1Pt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t1Pt")
        else:
            self.t1Pt_branch.SetAddress(<void*>&self.t1Pt_value)

        #print "making t1Rank"
        self.t1Rank_branch = the_tree.GetBranch("t1Rank")
        #if not self.t1Rank_branch and "t1Rank" not in self.complained:
        if not self.t1Rank_branch and "t1Rank":
            warnings.warn( "EETauTauTree: Expected branch t1Rank does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t1Rank")
        else:
            self.t1Rank_branch.SetAddress(<void*>&self.t1Rank_value)

        #print "making t1TNPId"
        self.t1TNPId_branch = the_tree.GetBranch("t1TNPId")
        #if not self.t1TNPId_branch and "t1TNPId" not in self.complained:
        if not self.t1TNPId_branch and "t1TNPId":
            warnings.warn( "EETauTauTree: Expected branch t1TNPId does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t1TNPId")
        else:
            self.t1TNPId_branch.SetAddress(<void*>&self.t1TNPId_value)

        #print "making t1TightIso"
        self.t1TightIso_branch = the_tree.GetBranch("t1TightIso")
        #if not self.t1TightIso_branch and "t1TightIso" not in self.complained:
        if not self.t1TightIso_branch and "t1TightIso":
            warnings.warn( "EETauTauTree: Expected branch t1TightIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t1TightIso")
        else:
            self.t1TightIso_branch.SetAddress(<void*>&self.t1TightIso_value)

        #print "making t1TightIso3Hits"
        self.t1TightIso3Hits_branch = the_tree.GetBranch("t1TightIso3Hits")
        #if not self.t1TightIso3Hits_branch and "t1TightIso3Hits" not in self.complained:
        if not self.t1TightIso3Hits_branch and "t1TightIso3Hits":
            warnings.warn( "EETauTauTree: Expected branch t1TightIso3Hits does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t1TightIso3Hits")
        else:
            self.t1TightIso3Hits_branch.SetAddress(<void*>&self.t1TightIso3Hits_value)

        #print "making t1TightMVA2Iso"
        self.t1TightMVA2Iso_branch = the_tree.GetBranch("t1TightMVA2Iso")
        #if not self.t1TightMVA2Iso_branch and "t1TightMVA2Iso" not in self.complained:
        if not self.t1TightMVA2Iso_branch and "t1TightMVA2Iso":
            warnings.warn( "EETauTauTree: Expected branch t1TightMVA2Iso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t1TightMVA2Iso")
        else:
            self.t1TightMVA2Iso_branch.SetAddress(<void*>&self.t1TightMVA2Iso_value)

        #print "making t1TightMVAIso"
        self.t1TightMVAIso_branch = the_tree.GetBranch("t1TightMVAIso")
        #if not self.t1TightMVAIso_branch and "t1TightMVAIso" not in self.complained:
        if not self.t1TightMVAIso_branch and "t1TightMVAIso":
            warnings.warn( "EETauTauTree: Expected branch t1TightMVAIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t1TightMVAIso")
        else:
            self.t1TightMVAIso_branch.SetAddress(<void*>&self.t1TightMVAIso_value)

        #print "making t1ToMETDPhi"
        self.t1ToMETDPhi_branch = the_tree.GetBranch("t1ToMETDPhi")
        #if not self.t1ToMETDPhi_branch and "t1ToMETDPhi" not in self.complained:
        if not self.t1ToMETDPhi_branch and "t1ToMETDPhi":
            warnings.warn( "EETauTauTree: Expected branch t1ToMETDPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t1ToMETDPhi")
        else:
            self.t1ToMETDPhi_branch.SetAddress(<void*>&self.t1ToMETDPhi_value)

        #print "making t1VLooseIso"
        self.t1VLooseIso_branch = the_tree.GetBranch("t1VLooseIso")
        #if not self.t1VLooseIso_branch and "t1VLooseIso" not in self.complained:
        if not self.t1VLooseIso_branch and "t1VLooseIso":
            warnings.warn( "EETauTauTree: Expected branch t1VLooseIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t1VLooseIso")
        else:
            self.t1VLooseIso_branch.SetAddress(<void*>&self.t1VLooseIso_value)

        #print "making t1VZ"
        self.t1VZ_branch = the_tree.GetBranch("t1VZ")
        #if not self.t1VZ_branch and "t1VZ" not in self.complained:
        if not self.t1VZ_branch and "t1VZ":
            warnings.warn( "EETauTauTree: Expected branch t1VZ does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t1VZ")
        else:
            self.t1VZ_branch.SetAddress(<void*>&self.t1VZ_value)

        #print "making t1_t2_CosThetaStar"
        self.t1_t2_CosThetaStar_branch = the_tree.GetBranch("t1_t2_CosThetaStar")
        #if not self.t1_t2_CosThetaStar_branch and "t1_t2_CosThetaStar" not in self.complained:
        if not self.t1_t2_CosThetaStar_branch and "t1_t2_CosThetaStar":
            warnings.warn( "EETauTauTree: Expected branch t1_t2_CosThetaStar does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t1_t2_CosThetaStar")
        else:
            self.t1_t2_CosThetaStar_branch.SetAddress(<void*>&self.t1_t2_CosThetaStar_value)

        #print "making t1_t2_DPhi"
        self.t1_t2_DPhi_branch = the_tree.GetBranch("t1_t2_DPhi")
        #if not self.t1_t2_DPhi_branch and "t1_t2_DPhi" not in self.complained:
        if not self.t1_t2_DPhi_branch and "t1_t2_DPhi":
            warnings.warn( "EETauTauTree: Expected branch t1_t2_DPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t1_t2_DPhi")
        else:
            self.t1_t2_DPhi_branch.SetAddress(<void*>&self.t1_t2_DPhi_value)

        #print "making t1_t2_DR"
        self.t1_t2_DR_branch = the_tree.GetBranch("t1_t2_DR")
        #if not self.t1_t2_DR_branch and "t1_t2_DR" not in self.complained:
        if not self.t1_t2_DR_branch and "t1_t2_DR":
            warnings.warn( "EETauTauTree: Expected branch t1_t2_DR does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t1_t2_DR")
        else:
            self.t1_t2_DR_branch.SetAddress(<void*>&self.t1_t2_DR_value)

        #print "making t1_t2_Eta"
        self.t1_t2_Eta_branch = the_tree.GetBranch("t1_t2_Eta")
        #if not self.t1_t2_Eta_branch and "t1_t2_Eta" not in self.complained:
        if not self.t1_t2_Eta_branch and "t1_t2_Eta":
            warnings.warn( "EETauTauTree: Expected branch t1_t2_Eta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t1_t2_Eta")
        else:
            self.t1_t2_Eta_branch.SetAddress(<void*>&self.t1_t2_Eta_value)

        #print "making t1_t2_Mass"
        self.t1_t2_Mass_branch = the_tree.GetBranch("t1_t2_Mass")
        #if not self.t1_t2_Mass_branch and "t1_t2_Mass" not in self.complained:
        if not self.t1_t2_Mass_branch and "t1_t2_Mass":
            warnings.warn( "EETauTauTree: Expected branch t1_t2_Mass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t1_t2_Mass")
        else:
            self.t1_t2_Mass_branch.SetAddress(<void*>&self.t1_t2_Mass_value)

        #print "making t1_t2_MassFsr"
        self.t1_t2_MassFsr_branch = the_tree.GetBranch("t1_t2_MassFsr")
        #if not self.t1_t2_MassFsr_branch and "t1_t2_MassFsr" not in self.complained:
        if not self.t1_t2_MassFsr_branch and "t1_t2_MassFsr":
            warnings.warn( "EETauTauTree: Expected branch t1_t2_MassFsr does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t1_t2_MassFsr")
        else:
            self.t1_t2_MassFsr_branch.SetAddress(<void*>&self.t1_t2_MassFsr_value)

        #print "making t1_t2_PZeta"
        self.t1_t2_PZeta_branch = the_tree.GetBranch("t1_t2_PZeta")
        #if not self.t1_t2_PZeta_branch and "t1_t2_PZeta" not in self.complained:
        if not self.t1_t2_PZeta_branch and "t1_t2_PZeta":
            warnings.warn( "EETauTauTree: Expected branch t1_t2_PZeta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t1_t2_PZeta")
        else:
            self.t1_t2_PZeta_branch.SetAddress(<void*>&self.t1_t2_PZeta_value)

        #print "making t1_t2_PZetaVis"
        self.t1_t2_PZetaVis_branch = the_tree.GetBranch("t1_t2_PZetaVis")
        #if not self.t1_t2_PZetaVis_branch and "t1_t2_PZetaVis" not in self.complained:
        if not self.t1_t2_PZetaVis_branch and "t1_t2_PZetaVis":
            warnings.warn( "EETauTauTree: Expected branch t1_t2_PZetaVis does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t1_t2_PZetaVis")
        else:
            self.t1_t2_PZetaVis_branch.SetAddress(<void*>&self.t1_t2_PZetaVis_value)

        #print "making t1_t2_Phi"
        self.t1_t2_Phi_branch = the_tree.GetBranch("t1_t2_Phi")
        #if not self.t1_t2_Phi_branch and "t1_t2_Phi" not in self.complained:
        if not self.t1_t2_Phi_branch and "t1_t2_Phi":
            warnings.warn( "EETauTauTree: Expected branch t1_t2_Phi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t1_t2_Phi")
        else:
            self.t1_t2_Phi_branch.SetAddress(<void*>&self.t1_t2_Phi_value)

        #print "making t1_t2_Pt"
        self.t1_t2_Pt_branch = the_tree.GetBranch("t1_t2_Pt")
        #if not self.t1_t2_Pt_branch and "t1_t2_Pt" not in self.complained:
        if not self.t1_t2_Pt_branch and "t1_t2_Pt":
            warnings.warn( "EETauTauTree: Expected branch t1_t2_Pt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t1_t2_Pt")
        else:
            self.t1_t2_Pt_branch.SetAddress(<void*>&self.t1_t2_Pt_value)

        #print "making t1_t2_PtFsr"
        self.t1_t2_PtFsr_branch = the_tree.GetBranch("t1_t2_PtFsr")
        #if not self.t1_t2_PtFsr_branch and "t1_t2_PtFsr" not in self.complained:
        if not self.t1_t2_PtFsr_branch and "t1_t2_PtFsr":
            warnings.warn( "EETauTauTree: Expected branch t1_t2_PtFsr does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t1_t2_PtFsr")
        else:
            self.t1_t2_PtFsr_branch.SetAddress(<void*>&self.t1_t2_PtFsr_value)

        #print "making t1_t2_SS"
        self.t1_t2_SS_branch = the_tree.GetBranch("t1_t2_SS")
        #if not self.t1_t2_SS_branch and "t1_t2_SS" not in self.complained:
        if not self.t1_t2_SS_branch and "t1_t2_SS":
            warnings.warn( "EETauTauTree: Expected branch t1_t2_SS does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t1_t2_SS")
        else:
            self.t1_t2_SS_branch.SetAddress(<void*>&self.t1_t2_SS_value)

        #print "making t1_t2_SVfitEta"
        self.t1_t2_SVfitEta_branch = the_tree.GetBranch("t1_t2_SVfitEta")
        #if not self.t1_t2_SVfitEta_branch and "t1_t2_SVfitEta" not in self.complained:
        if not self.t1_t2_SVfitEta_branch and "t1_t2_SVfitEta":
            warnings.warn( "EETauTauTree: Expected branch t1_t2_SVfitEta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t1_t2_SVfitEta")
        else:
            self.t1_t2_SVfitEta_branch.SetAddress(<void*>&self.t1_t2_SVfitEta_value)

        #print "making t1_t2_SVfitMass"
        self.t1_t2_SVfitMass_branch = the_tree.GetBranch("t1_t2_SVfitMass")
        #if not self.t1_t2_SVfitMass_branch and "t1_t2_SVfitMass" not in self.complained:
        if not self.t1_t2_SVfitMass_branch and "t1_t2_SVfitMass":
            warnings.warn( "EETauTauTree: Expected branch t1_t2_SVfitMass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t1_t2_SVfitMass")
        else:
            self.t1_t2_SVfitMass_branch.SetAddress(<void*>&self.t1_t2_SVfitMass_value)

        #print "making t1_t2_SVfitPhi"
        self.t1_t2_SVfitPhi_branch = the_tree.GetBranch("t1_t2_SVfitPhi")
        #if not self.t1_t2_SVfitPhi_branch and "t1_t2_SVfitPhi" not in self.complained:
        if not self.t1_t2_SVfitPhi_branch and "t1_t2_SVfitPhi":
            warnings.warn( "EETauTauTree: Expected branch t1_t2_SVfitPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t1_t2_SVfitPhi")
        else:
            self.t1_t2_SVfitPhi_branch.SetAddress(<void*>&self.t1_t2_SVfitPhi_value)

        #print "making t1_t2_SVfitPt"
        self.t1_t2_SVfitPt_branch = the_tree.GetBranch("t1_t2_SVfitPt")
        #if not self.t1_t2_SVfitPt_branch and "t1_t2_SVfitPt" not in self.complained:
        if not self.t1_t2_SVfitPt_branch and "t1_t2_SVfitPt":
            warnings.warn( "EETauTauTree: Expected branch t1_t2_SVfitPt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t1_t2_SVfitPt")
        else:
            self.t1_t2_SVfitPt_branch.SetAddress(<void*>&self.t1_t2_SVfitPt_value)

        #print "making t1_t2_ToMETDPhi_Ty1"
        self.t1_t2_ToMETDPhi_Ty1_branch = the_tree.GetBranch("t1_t2_ToMETDPhi_Ty1")
        #if not self.t1_t2_ToMETDPhi_Ty1_branch and "t1_t2_ToMETDPhi_Ty1" not in self.complained:
        if not self.t1_t2_ToMETDPhi_Ty1_branch and "t1_t2_ToMETDPhi_Ty1":
            warnings.warn( "EETauTauTree: Expected branch t1_t2_ToMETDPhi_Ty1 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t1_t2_ToMETDPhi_Ty1")
        else:
            self.t1_t2_ToMETDPhi_Ty1_branch.SetAddress(<void*>&self.t1_t2_ToMETDPhi_Ty1_value)

        #print "making t1_t2_Zcompat"
        self.t1_t2_Zcompat_branch = the_tree.GetBranch("t1_t2_Zcompat")
        #if not self.t1_t2_Zcompat_branch and "t1_t2_Zcompat" not in self.complained:
        if not self.t1_t2_Zcompat_branch and "t1_t2_Zcompat":
            warnings.warn( "EETauTauTree: Expected branch t1_t2_Zcompat does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t1_t2_Zcompat")
        else:
            self.t1_t2_Zcompat_branch.SetAddress(<void*>&self.t1_t2_Zcompat_value)

        #print "making t2AbsEta"
        self.t2AbsEta_branch = the_tree.GetBranch("t2AbsEta")
        #if not self.t2AbsEta_branch and "t2AbsEta" not in self.complained:
        if not self.t2AbsEta_branch and "t2AbsEta":
            warnings.warn( "EETauTauTree: Expected branch t2AbsEta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t2AbsEta")
        else:
            self.t2AbsEta_branch.SetAddress(<void*>&self.t2AbsEta_value)

        #print "making t2AntiElectronLoose"
        self.t2AntiElectronLoose_branch = the_tree.GetBranch("t2AntiElectronLoose")
        #if not self.t2AntiElectronLoose_branch and "t2AntiElectronLoose" not in self.complained:
        if not self.t2AntiElectronLoose_branch and "t2AntiElectronLoose":
            warnings.warn( "EETauTauTree: Expected branch t2AntiElectronLoose does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t2AntiElectronLoose")
        else:
            self.t2AntiElectronLoose_branch.SetAddress(<void*>&self.t2AntiElectronLoose_value)

        #print "making t2AntiElectronMVA3Loose"
        self.t2AntiElectronMVA3Loose_branch = the_tree.GetBranch("t2AntiElectronMVA3Loose")
        #if not self.t2AntiElectronMVA3Loose_branch and "t2AntiElectronMVA3Loose" not in self.complained:
        if not self.t2AntiElectronMVA3Loose_branch and "t2AntiElectronMVA3Loose":
            warnings.warn( "EETauTauTree: Expected branch t2AntiElectronMVA3Loose does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t2AntiElectronMVA3Loose")
        else:
            self.t2AntiElectronMVA3Loose_branch.SetAddress(<void*>&self.t2AntiElectronMVA3Loose_value)

        #print "making t2AntiElectronMVA3Medium"
        self.t2AntiElectronMVA3Medium_branch = the_tree.GetBranch("t2AntiElectronMVA3Medium")
        #if not self.t2AntiElectronMVA3Medium_branch and "t2AntiElectronMVA3Medium" not in self.complained:
        if not self.t2AntiElectronMVA3Medium_branch and "t2AntiElectronMVA3Medium":
            warnings.warn( "EETauTauTree: Expected branch t2AntiElectronMVA3Medium does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t2AntiElectronMVA3Medium")
        else:
            self.t2AntiElectronMVA3Medium_branch.SetAddress(<void*>&self.t2AntiElectronMVA3Medium_value)

        #print "making t2AntiElectronMVA3Raw"
        self.t2AntiElectronMVA3Raw_branch = the_tree.GetBranch("t2AntiElectronMVA3Raw")
        #if not self.t2AntiElectronMVA3Raw_branch and "t2AntiElectronMVA3Raw" not in self.complained:
        if not self.t2AntiElectronMVA3Raw_branch and "t2AntiElectronMVA3Raw":
            warnings.warn( "EETauTauTree: Expected branch t2AntiElectronMVA3Raw does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t2AntiElectronMVA3Raw")
        else:
            self.t2AntiElectronMVA3Raw_branch.SetAddress(<void*>&self.t2AntiElectronMVA3Raw_value)

        #print "making t2AntiElectronMVA3Tight"
        self.t2AntiElectronMVA3Tight_branch = the_tree.GetBranch("t2AntiElectronMVA3Tight")
        #if not self.t2AntiElectronMVA3Tight_branch and "t2AntiElectronMVA3Tight" not in self.complained:
        if not self.t2AntiElectronMVA3Tight_branch and "t2AntiElectronMVA3Tight":
            warnings.warn( "EETauTauTree: Expected branch t2AntiElectronMVA3Tight does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t2AntiElectronMVA3Tight")
        else:
            self.t2AntiElectronMVA3Tight_branch.SetAddress(<void*>&self.t2AntiElectronMVA3Tight_value)

        #print "making t2AntiElectronMVA3VTight"
        self.t2AntiElectronMVA3VTight_branch = the_tree.GetBranch("t2AntiElectronMVA3VTight")
        #if not self.t2AntiElectronMVA3VTight_branch and "t2AntiElectronMVA3VTight" not in self.complained:
        if not self.t2AntiElectronMVA3VTight_branch and "t2AntiElectronMVA3VTight":
            warnings.warn( "EETauTauTree: Expected branch t2AntiElectronMVA3VTight does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t2AntiElectronMVA3VTight")
        else:
            self.t2AntiElectronMVA3VTight_branch.SetAddress(<void*>&self.t2AntiElectronMVA3VTight_value)

        #print "making t2AntiElectronMedium"
        self.t2AntiElectronMedium_branch = the_tree.GetBranch("t2AntiElectronMedium")
        #if not self.t2AntiElectronMedium_branch and "t2AntiElectronMedium" not in self.complained:
        if not self.t2AntiElectronMedium_branch and "t2AntiElectronMedium":
            warnings.warn( "EETauTauTree: Expected branch t2AntiElectronMedium does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t2AntiElectronMedium")
        else:
            self.t2AntiElectronMedium_branch.SetAddress(<void*>&self.t2AntiElectronMedium_value)

        #print "making t2AntiElectronTight"
        self.t2AntiElectronTight_branch = the_tree.GetBranch("t2AntiElectronTight")
        #if not self.t2AntiElectronTight_branch and "t2AntiElectronTight" not in self.complained:
        if not self.t2AntiElectronTight_branch and "t2AntiElectronTight":
            warnings.warn( "EETauTauTree: Expected branch t2AntiElectronTight does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t2AntiElectronTight")
        else:
            self.t2AntiElectronTight_branch.SetAddress(<void*>&self.t2AntiElectronTight_value)

        #print "making t2AntiMuonLoose"
        self.t2AntiMuonLoose_branch = the_tree.GetBranch("t2AntiMuonLoose")
        #if not self.t2AntiMuonLoose_branch and "t2AntiMuonLoose" not in self.complained:
        if not self.t2AntiMuonLoose_branch and "t2AntiMuonLoose":
            warnings.warn( "EETauTauTree: Expected branch t2AntiMuonLoose does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t2AntiMuonLoose")
        else:
            self.t2AntiMuonLoose_branch.SetAddress(<void*>&self.t2AntiMuonLoose_value)

        #print "making t2AntiMuonLoose2"
        self.t2AntiMuonLoose2_branch = the_tree.GetBranch("t2AntiMuonLoose2")
        #if not self.t2AntiMuonLoose2_branch and "t2AntiMuonLoose2" not in self.complained:
        if not self.t2AntiMuonLoose2_branch and "t2AntiMuonLoose2":
            warnings.warn( "EETauTauTree: Expected branch t2AntiMuonLoose2 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t2AntiMuonLoose2")
        else:
            self.t2AntiMuonLoose2_branch.SetAddress(<void*>&self.t2AntiMuonLoose2_value)

        #print "making t2AntiMuonMedium"
        self.t2AntiMuonMedium_branch = the_tree.GetBranch("t2AntiMuonMedium")
        #if not self.t2AntiMuonMedium_branch and "t2AntiMuonMedium" not in self.complained:
        if not self.t2AntiMuonMedium_branch and "t2AntiMuonMedium":
            warnings.warn( "EETauTauTree: Expected branch t2AntiMuonMedium does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t2AntiMuonMedium")
        else:
            self.t2AntiMuonMedium_branch.SetAddress(<void*>&self.t2AntiMuonMedium_value)

        #print "making t2AntiMuonMedium2"
        self.t2AntiMuonMedium2_branch = the_tree.GetBranch("t2AntiMuonMedium2")
        #if not self.t2AntiMuonMedium2_branch and "t2AntiMuonMedium2" not in self.complained:
        if not self.t2AntiMuonMedium2_branch and "t2AntiMuonMedium2":
            warnings.warn( "EETauTauTree: Expected branch t2AntiMuonMedium2 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t2AntiMuonMedium2")
        else:
            self.t2AntiMuonMedium2_branch.SetAddress(<void*>&self.t2AntiMuonMedium2_value)

        #print "making t2AntiMuonTight"
        self.t2AntiMuonTight_branch = the_tree.GetBranch("t2AntiMuonTight")
        #if not self.t2AntiMuonTight_branch and "t2AntiMuonTight" not in self.complained:
        if not self.t2AntiMuonTight_branch and "t2AntiMuonTight":
            warnings.warn( "EETauTauTree: Expected branch t2AntiMuonTight does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t2AntiMuonTight")
        else:
            self.t2AntiMuonTight_branch.SetAddress(<void*>&self.t2AntiMuonTight_value)

        #print "making t2AntiMuonTight2"
        self.t2AntiMuonTight2_branch = the_tree.GetBranch("t2AntiMuonTight2")
        #if not self.t2AntiMuonTight2_branch and "t2AntiMuonTight2" not in self.complained:
        if not self.t2AntiMuonTight2_branch and "t2AntiMuonTight2":
            warnings.warn( "EETauTauTree: Expected branch t2AntiMuonTight2 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t2AntiMuonTight2")
        else:
            self.t2AntiMuonTight2_branch.SetAddress(<void*>&self.t2AntiMuonTight2_value)

        #print "making t2Charge"
        self.t2Charge_branch = the_tree.GetBranch("t2Charge")
        #if not self.t2Charge_branch and "t2Charge" not in self.complained:
        if not self.t2Charge_branch and "t2Charge":
            warnings.warn( "EETauTauTree: Expected branch t2Charge does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t2Charge")
        else:
            self.t2Charge_branch.SetAddress(<void*>&self.t2Charge_value)

        #print "making t2CiCTightElecOverlap"
        self.t2CiCTightElecOverlap_branch = the_tree.GetBranch("t2CiCTightElecOverlap")
        #if not self.t2CiCTightElecOverlap_branch and "t2CiCTightElecOverlap" not in self.complained:
        if not self.t2CiCTightElecOverlap_branch and "t2CiCTightElecOverlap":
            warnings.warn( "EETauTauTree: Expected branch t2CiCTightElecOverlap does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t2CiCTightElecOverlap")
        else:
            self.t2CiCTightElecOverlap_branch.SetAddress(<void*>&self.t2CiCTightElecOverlap_value)

        #print "making t2DZ"
        self.t2DZ_branch = the_tree.GetBranch("t2DZ")
        #if not self.t2DZ_branch and "t2DZ" not in self.complained:
        if not self.t2DZ_branch and "t2DZ":
            warnings.warn( "EETauTauTree: Expected branch t2DZ does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t2DZ")
        else:
            self.t2DZ_branch.SetAddress(<void*>&self.t2DZ_value)

        #print "making t2DecayFinding"
        self.t2DecayFinding_branch = the_tree.GetBranch("t2DecayFinding")
        #if not self.t2DecayFinding_branch and "t2DecayFinding" not in self.complained:
        if not self.t2DecayFinding_branch and "t2DecayFinding":
            warnings.warn( "EETauTauTree: Expected branch t2DecayFinding does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t2DecayFinding")
        else:
            self.t2DecayFinding_branch.SetAddress(<void*>&self.t2DecayFinding_value)

        #print "making t2DecayMode"
        self.t2DecayMode_branch = the_tree.GetBranch("t2DecayMode")
        #if not self.t2DecayMode_branch and "t2DecayMode" not in self.complained:
        if not self.t2DecayMode_branch and "t2DecayMode":
            warnings.warn( "EETauTauTree: Expected branch t2DecayMode does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t2DecayMode")
        else:
            self.t2DecayMode_branch.SetAddress(<void*>&self.t2DecayMode_value)

        #print "making t2ElecOverlap"
        self.t2ElecOverlap_branch = the_tree.GetBranch("t2ElecOverlap")
        #if not self.t2ElecOverlap_branch and "t2ElecOverlap" not in self.complained:
        if not self.t2ElecOverlap_branch and "t2ElecOverlap":
            warnings.warn( "EETauTauTree: Expected branch t2ElecOverlap does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t2ElecOverlap")
        else:
            self.t2ElecOverlap_branch.SetAddress(<void*>&self.t2ElecOverlap_value)

        #print "making t2ElecOverlapZHLoose"
        self.t2ElecOverlapZHLoose_branch = the_tree.GetBranch("t2ElecOverlapZHLoose")
        #if not self.t2ElecOverlapZHLoose_branch and "t2ElecOverlapZHLoose" not in self.complained:
        if not self.t2ElecOverlapZHLoose_branch and "t2ElecOverlapZHLoose":
            warnings.warn( "EETauTauTree: Expected branch t2ElecOverlapZHLoose does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t2ElecOverlapZHLoose")
        else:
            self.t2ElecOverlapZHLoose_branch.SetAddress(<void*>&self.t2ElecOverlapZHLoose_value)

        #print "making t2ElecOverlapZHTight"
        self.t2ElecOverlapZHTight_branch = the_tree.GetBranch("t2ElecOverlapZHTight")
        #if not self.t2ElecOverlapZHTight_branch and "t2ElecOverlapZHTight" not in self.complained:
        if not self.t2ElecOverlapZHTight_branch and "t2ElecOverlapZHTight":
            warnings.warn( "EETauTauTree: Expected branch t2ElecOverlapZHTight does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t2ElecOverlapZHTight")
        else:
            self.t2ElecOverlapZHTight_branch.SetAddress(<void*>&self.t2ElecOverlapZHTight_value)

        #print "making t2Eta"
        self.t2Eta_branch = the_tree.GetBranch("t2Eta")
        #if not self.t2Eta_branch and "t2Eta" not in self.complained:
        if not self.t2Eta_branch and "t2Eta":
            warnings.warn( "EETauTauTree: Expected branch t2Eta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t2Eta")
        else:
            self.t2Eta_branch.SetAddress(<void*>&self.t2Eta_value)

        #print "making t2GenDecayMode"
        self.t2GenDecayMode_branch = the_tree.GetBranch("t2GenDecayMode")
        #if not self.t2GenDecayMode_branch and "t2GenDecayMode" not in self.complained:
        if not self.t2GenDecayMode_branch and "t2GenDecayMode":
            warnings.warn( "EETauTauTree: Expected branch t2GenDecayMode does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t2GenDecayMode")
        else:
            self.t2GenDecayMode_branch.SetAddress(<void*>&self.t2GenDecayMode_value)

        #print "making t2IP3DS"
        self.t2IP3DS_branch = the_tree.GetBranch("t2IP3DS")
        #if not self.t2IP3DS_branch and "t2IP3DS" not in self.complained:
        if not self.t2IP3DS_branch and "t2IP3DS":
            warnings.warn( "EETauTauTree: Expected branch t2IP3DS does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t2IP3DS")
        else:
            self.t2IP3DS_branch.SetAddress(<void*>&self.t2IP3DS_value)

        #print "making t2JetArea"
        self.t2JetArea_branch = the_tree.GetBranch("t2JetArea")
        #if not self.t2JetArea_branch and "t2JetArea" not in self.complained:
        if not self.t2JetArea_branch and "t2JetArea":
            warnings.warn( "EETauTauTree: Expected branch t2JetArea does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t2JetArea")
        else:
            self.t2JetArea_branch.SetAddress(<void*>&self.t2JetArea_value)

        #print "making t2JetBtag"
        self.t2JetBtag_branch = the_tree.GetBranch("t2JetBtag")
        #if not self.t2JetBtag_branch and "t2JetBtag" not in self.complained:
        if not self.t2JetBtag_branch and "t2JetBtag":
            warnings.warn( "EETauTauTree: Expected branch t2JetBtag does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t2JetBtag")
        else:
            self.t2JetBtag_branch.SetAddress(<void*>&self.t2JetBtag_value)

        #print "making t2JetCSVBtag"
        self.t2JetCSVBtag_branch = the_tree.GetBranch("t2JetCSVBtag")
        #if not self.t2JetCSVBtag_branch and "t2JetCSVBtag" not in self.complained:
        if not self.t2JetCSVBtag_branch and "t2JetCSVBtag":
            warnings.warn( "EETauTauTree: Expected branch t2JetCSVBtag does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t2JetCSVBtag")
        else:
            self.t2JetCSVBtag_branch.SetAddress(<void*>&self.t2JetCSVBtag_value)

        #print "making t2JetEtaEtaMoment"
        self.t2JetEtaEtaMoment_branch = the_tree.GetBranch("t2JetEtaEtaMoment")
        #if not self.t2JetEtaEtaMoment_branch and "t2JetEtaEtaMoment" not in self.complained:
        if not self.t2JetEtaEtaMoment_branch and "t2JetEtaEtaMoment":
            warnings.warn( "EETauTauTree: Expected branch t2JetEtaEtaMoment does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t2JetEtaEtaMoment")
        else:
            self.t2JetEtaEtaMoment_branch.SetAddress(<void*>&self.t2JetEtaEtaMoment_value)

        #print "making t2JetEtaPhiMoment"
        self.t2JetEtaPhiMoment_branch = the_tree.GetBranch("t2JetEtaPhiMoment")
        #if not self.t2JetEtaPhiMoment_branch and "t2JetEtaPhiMoment" not in self.complained:
        if not self.t2JetEtaPhiMoment_branch and "t2JetEtaPhiMoment":
            warnings.warn( "EETauTauTree: Expected branch t2JetEtaPhiMoment does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t2JetEtaPhiMoment")
        else:
            self.t2JetEtaPhiMoment_branch.SetAddress(<void*>&self.t2JetEtaPhiMoment_value)

        #print "making t2JetEtaPhiSpread"
        self.t2JetEtaPhiSpread_branch = the_tree.GetBranch("t2JetEtaPhiSpread")
        #if not self.t2JetEtaPhiSpread_branch and "t2JetEtaPhiSpread" not in self.complained:
        if not self.t2JetEtaPhiSpread_branch and "t2JetEtaPhiSpread":
            warnings.warn( "EETauTauTree: Expected branch t2JetEtaPhiSpread does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t2JetEtaPhiSpread")
        else:
            self.t2JetEtaPhiSpread_branch.SetAddress(<void*>&self.t2JetEtaPhiSpread_value)

        #print "making t2JetPartonFlavour"
        self.t2JetPartonFlavour_branch = the_tree.GetBranch("t2JetPartonFlavour")
        #if not self.t2JetPartonFlavour_branch and "t2JetPartonFlavour" not in self.complained:
        if not self.t2JetPartonFlavour_branch and "t2JetPartonFlavour":
            warnings.warn( "EETauTauTree: Expected branch t2JetPartonFlavour does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t2JetPartonFlavour")
        else:
            self.t2JetPartonFlavour_branch.SetAddress(<void*>&self.t2JetPartonFlavour_value)

        #print "making t2JetPhiPhiMoment"
        self.t2JetPhiPhiMoment_branch = the_tree.GetBranch("t2JetPhiPhiMoment")
        #if not self.t2JetPhiPhiMoment_branch and "t2JetPhiPhiMoment" not in self.complained:
        if not self.t2JetPhiPhiMoment_branch and "t2JetPhiPhiMoment":
            warnings.warn( "EETauTauTree: Expected branch t2JetPhiPhiMoment does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t2JetPhiPhiMoment")
        else:
            self.t2JetPhiPhiMoment_branch.SetAddress(<void*>&self.t2JetPhiPhiMoment_value)

        #print "making t2JetPt"
        self.t2JetPt_branch = the_tree.GetBranch("t2JetPt")
        #if not self.t2JetPt_branch and "t2JetPt" not in self.complained:
        if not self.t2JetPt_branch and "t2JetPt":
            warnings.warn( "EETauTauTree: Expected branch t2JetPt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t2JetPt")
        else:
            self.t2JetPt_branch.SetAddress(<void*>&self.t2JetPt_value)

        #print "making t2JetQGLikelihoodID"
        self.t2JetQGLikelihoodID_branch = the_tree.GetBranch("t2JetQGLikelihoodID")
        #if not self.t2JetQGLikelihoodID_branch and "t2JetQGLikelihoodID" not in self.complained:
        if not self.t2JetQGLikelihoodID_branch and "t2JetQGLikelihoodID":
            warnings.warn( "EETauTauTree: Expected branch t2JetQGLikelihoodID does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t2JetQGLikelihoodID")
        else:
            self.t2JetQGLikelihoodID_branch.SetAddress(<void*>&self.t2JetQGLikelihoodID_value)

        #print "making t2JetQGMVAID"
        self.t2JetQGMVAID_branch = the_tree.GetBranch("t2JetQGMVAID")
        #if not self.t2JetQGMVAID_branch and "t2JetQGMVAID" not in self.complained:
        if not self.t2JetQGMVAID_branch and "t2JetQGMVAID":
            warnings.warn( "EETauTauTree: Expected branch t2JetQGMVAID does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t2JetQGMVAID")
        else:
            self.t2JetQGMVAID_branch.SetAddress(<void*>&self.t2JetQGMVAID_value)

        #print "making t2Jetaxis1"
        self.t2Jetaxis1_branch = the_tree.GetBranch("t2Jetaxis1")
        #if not self.t2Jetaxis1_branch and "t2Jetaxis1" not in self.complained:
        if not self.t2Jetaxis1_branch and "t2Jetaxis1":
            warnings.warn( "EETauTauTree: Expected branch t2Jetaxis1 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t2Jetaxis1")
        else:
            self.t2Jetaxis1_branch.SetAddress(<void*>&self.t2Jetaxis1_value)

        #print "making t2Jetaxis2"
        self.t2Jetaxis2_branch = the_tree.GetBranch("t2Jetaxis2")
        #if not self.t2Jetaxis2_branch and "t2Jetaxis2" not in self.complained:
        if not self.t2Jetaxis2_branch and "t2Jetaxis2":
            warnings.warn( "EETauTauTree: Expected branch t2Jetaxis2 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t2Jetaxis2")
        else:
            self.t2Jetaxis2_branch.SetAddress(<void*>&self.t2Jetaxis2_value)

        #print "making t2Jetmult"
        self.t2Jetmult_branch = the_tree.GetBranch("t2Jetmult")
        #if not self.t2Jetmult_branch and "t2Jetmult" not in self.complained:
        if not self.t2Jetmult_branch and "t2Jetmult":
            warnings.warn( "EETauTauTree: Expected branch t2Jetmult does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t2Jetmult")
        else:
            self.t2Jetmult_branch.SetAddress(<void*>&self.t2Jetmult_value)

        #print "making t2JetmultMLP"
        self.t2JetmultMLP_branch = the_tree.GetBranch("t2JetmultMLP")
        #if not self.t2JetmultMLP_branch and "t2JetmultMLP" not in self.complained:
        if not self.t2JetmultMLP_branch and "t2JetmultMLP":
            warnings.warn( "EETauTauTree: Expected branch t2JetmultMLP does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t2JetmultMLP")
        else:
            self.t2JetmultMLP_branch.SetAddress(<void*>&self.t2JetmultMLP_value)

        #print "making t2JetmultMLPQC"
        self.t2JetmultMLPQC_branch = the_tree.GetBranch("t2JetmultMLPQC")
        #if not self.t2JetmultMLPQC_branch and "t2JetmultMLPQC" not in self.complained:
        if not self.t2JetmultMLPQC_branch and "t2JetmultMLPQC":
            warnings.warn( "EETauTauTree: Expected branch t2JetmultMLPQC does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t2JetmultMLPQC")
        else:
            self.t2JetmultMLPQC_branch.SetAddress(<void*>&self.t2JetmultMLPQC_value)

        #print "making t2JetptD"
        self.t2JetptD_branch = the_tree.GetBranch("t2JetptD")
        #if not self.t2JetptD_branch and "t2JetptD" not in self.complained:
        if not self.t2JetptD_branch and "t2JetptD":
            warnings.warn( "EETauTauTree: Expected branch t2JetptD does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t2JetptD")
        else:
            self.t2JetptD_branch.SetAddress(<void*>&self.t2JetptD_value)

        #print "making t2LeadTrackPt"
        self.t2LeadTrackPt_branch = the_tree.GetBranch("t2LeadTrackPt")
        #if not self.t2LeadTrackPt_branch and "t2LeadTrackPt" not in self.complained:
        if not self.t2LeadTrackPt_branch and "t2LeadTrackPt":
            warnings.warn( "EETauTauTree: Expected branch t2LeadTrackPt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t2LeadTrackPt")
        else:
            self.t2LeadTrackPt_branch.SetAddress(<void*>&self.t2LeadTrackPt_value)

        #print "making t2LooseIso"
        self.t2LooseIso_branch = the_tree.GetBranch("t2LooseIso")
        #if not self.t2LooseIso_branch and "t2LooseIso" not in self.complained:
        if not self.t2LooseIso_branch and "t2LooseIso":
            warnings.warn( "EETauTauTree: Expected branch t2LooseIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t2LooseIso")
        else:
            self.t2LooseIso_branch.SetAddress(<void*>&self.t2LooseIso_value)

        #print "making t2LooseIso3Hits"
        self.t2LooseIso3Hits_branch = the_tree.GetBranch("t2LooseIso3Hits")
        #if not self.t2LooseIso3Hits_branch and "t2LooseIso3Hits" not in self.complained:
        if not self.t2LooseIso3Hits_branch and "t2LooseIso3Hits":
            warnings.warn( "EETauTauTree: Expected branch t2LooseIso3Hits does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t2LooseIso3Hits")
        else:
            self.t2LooseIso3Hits_branch.SetAddress(<void*>&self.t2LooseIso3Hits_value)

        #print "making t2LooseMVA2Iso"
        self.t2LooseMVA2Iso_branch = the_tree.GetBranch("t2LooseMVA2Iso")
        #if not self.t2LooseMVA2Iso_branch and "t2LooseMVA2Iso" not in self.complained:
        if not self.t2LooseMVA2Iso_branch and "t2LooseMVA2Iso":
            warnings.warn( "EETauTauTree: Expected branch t2LooseMVA2Iso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t2LooseMVA2Iso")
        else:
            self.t2LooseMVA2Iso_branch.SetAddress(<void*>&self.t2LooseMVA2Iso_value)

        #print "making t2LooseMVAIso"
        self.t2LooseMVAIso_branch = the_tree.GetBranch("t2LooseMVAIso")
        #if not self.t2LooseMVAIso_branch and "t2LooseMVAIso" not in self.complained:
        if not self.t2LooseMVAIso_branch and "t2LooseMVAIso":
            warnings.warn( "EETauTauTree: Expected branch t2LooseMVAIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t2LooseMVAIso")
        else:
            self.t2LooseMVAIso_branch.SetAddress(<void*>&self.t2LooseMVAIso_value)

        #print "making t2MVA2IsoRaw"
        self.t2MVA2IsoRaw_branch = the_tree.GetBranch("t2MVA2IsoRaw")
        #if not self.t2MVA2IsoRaw_branch and "t2MVA2IsoRaw" not in self.complained:
        if not self.t2MVA2IsoRaw_branch and "t2MVA2IsoRaw":
            warnings.warn( "EETauTauTree: Expected branch t2MVA2IsoRaw does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t2MVA2IsoRaw")
        else:
            self.t2MVA2IsoRaw_branch.SetAddress(<void*>&self.t2MVA2IsoRaw_value)

        #print "making t2Mass"
        self.t2Mass_branch = the_tree.GetBranch("t2Mass")
        #if not self.t2Mass_branch and "t2Mass" not in self.complained:
        if not self.t2Mass_branch and "t2Mass":
            warnings.warn( "EETauTauTree: Expected branch t2Mass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t2Mass")
        else:
            self.t2Mass_branch.SetAddress(<void*>&self.t2Mass_value)

        #print "making t2MediumIso"
        self.t2MediumIso_branch = the_tree.GetBranch("t2MediumIso")
        #if not self.t2MediumIso_branch and "t2MediumIso" not in self.complained:
        if not self.t2MediumIso_branch and "t2MediumIso":
            warnings.warn( "EETauTauTree: Expected branch t2MediumIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t2MediumIso")
        else:
            self.t2MediumIso_branch.SetAddress(<void*>&self.t2MediumIso_value)

        #print "making t2MediumIso3Hits"
        self.t2MediumIso3Hits_branch = the_tree.GetBranch("t2MediumIso3Hits")
        #if not self.t2MediumIso3Hits_branch and "t2MediumIso3Hits" not in self.complained:
        if not self.t2MediumIso3Hits_branch and "t2MediumIso3Hits":
            warnings.warn( "EETauTauTree: Expected branch t2MediumIso3Hits does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t2MediumIso3Hits")
        else:
            self.t2MediumIso3Hits_branch.SetAddress(<void*>&self.t2MediumIso3Hits_value)

        #print "making t2MediumMVA2Iso"
        self.t2MediumMVA2Iso_branch = the_tree.GetBranch("t2MediumMVA2Iso")
        #if not self.t2MediumMVA2Iso_branch and "t2MediumMVA2Iso" not in self.complained:
        if not self.t2MediumMVA2Iso_branch and "t2MediumMVA2Iso":
            warnings.warn( "EETauTauTree: Expected branch t2MediumMVA2Iso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t2MediumMVA2Iso")
        else:
            self.t2MediumMVA2Iso_branch.SetAddress(<void*>&self.t2MediumMVA2Iso_value)

        #print "making t2MediumMVAIso"
        self.t2MediumMVAIso_branch = the_tree.GetBranch("t2MediumMVAIso")
        #if not self.t2MediumMVAIso_branch and "t2MediumMVAIso" not in self.complained:
        if not self.t2MediumMVAIso_branch and "t2MediumMVAIso":
            warnings.warn( "EETauTauTree: Expected branch t2MediumMVAIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t2MediumMVAIso")
        else:
            self.t2MediumMVAIso_branch.SetAddress(<void*>&self.t2MediumMVAIso_value)

        #print "making t2MtToMET"
        self.t2MtToMET_branch = the_tree.GetBranch("t2MtToMET")
        #if not self.t2MtToMET_branch and "t2MtToMET" not in self.complained:
        if not self.t2MtToMET_branch and "t2MtToMET":
            warnings.warn( "EETauTauTree: Expected branch t2MtToMET does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t2MtToMET")
        else:
            self.t2MtToMET_branch.SetAddress(<void*>&self.t2MtToMET_value)

        #print "making t2MtToMVAMET"
        self.t2MtToMVAMET_branch = the_tree.GetBranch("t2MtToMVAMET")
        #if not self.t2MtToMVAMET_branch and "t2MtToMVAMET" not in self.complained:
        if not self.t2MtToMVAMET_branch and "t2MtToMVAMET":
            warnings.warn( "EETauTauTree: Expected branch t2MtToMVAMET does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t2MtToMVAMET")
        else:
            self.t2MtToMVAMET_branch.SetAddress(<void*>&self.t2MtToMVAMET_value)

        #print "making t2MtToPFMET"
        self.t2MtToPFMET_branch = the_tree.GetBranch("t2MtToPFMET")
        #if not self.t2MtToPFMET_branch and "t2MtToPFMET" not in self.complained:
        if not self.t2MtToPFMET_branch and "t2MtToPFMET":
            warnings.warn( "EETauTauTree: Expected branch t2MtToPFMET does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t2MtToPFMET")
        else:
            self.t2MtToPFMET_branch.SetAddress(<void*>&self.t2MtToPFMET_value)

        #print "making t2MtToPfMet_Ty1"
        self.t2MtToPfMet_Ty1_branch = the_tree.GetBranch("t2MtToPfMet_Ty1")
        #if not self.t2MtToPfMet_Ty1_branch and "t2MtToPfMet_Ty1" not in self.complained:
        if not self.t2MtToPfMet_Ty1_branch and "t2MtToPfMet_Ty1":
            warnings.warn( "EETauTauTree: Expected branch t2MtToPfMet_Ty1 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t2MtToPfMet_Ty1")
        else:
            self.t2MtToPfMet_Ty1_branch.SetAddress(<void*>&self.t2MtToPfMet_Ty1_value)

        #print "making t2MtToPfMet_jes"
        self.t2MtToPfMet_jes_branch = the_tree.GetBranch("t2MtToPfMet_jes")
        #if not self.t2MtToPfMet_jes_branch and "t2MtToPfMet_jes" not in self.complained:
        if not self.t2MtToPfMet_jes_branch and "t2MtToPfMet_jes":
            warnings.warn( "EETauTauTree: Expected branch t2MtToPfMet_jes does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t2MtToPfMet_jes")
        else:
            self.t2MtToPfMet_jes_branch.SetAddress(<void*>&self.t2MtToPfMet_jes_value)

        #print "making t2MtToPfMet_mes"
        self.t2MtToPfMet_mes_branch = the_tree.GetBranch("t2MtToPfMet_mes")
        #if not self.t2MtToPfMet_mes_branch and "t2MtToPfMet_mes" not in self.complained:
        if not self.t2MtToPfMet_mes_branch and "t2MtToPfMet_mes":
            warnings.warn( "EETauTauTree: Expected branch t2MtToPfMet_mes does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t2MtToPfMet_mes")
        else:
            self.t2MtToPfMet_mes_branch.SetAddress(<void*>&self.t2MtToPfMet_mes_value)

        #print "making t2MtToPfMet_tes"
        self.t2MtToPfMet_tes_branch = the_tree.GetBranch("t2MtToPfMet_tes")
        #if not self.t2MtToPfMet_tes_branch and "t2MtToPfMet_tes" not in self.complained:
        if not self.t2MtToPfMet_tes_branch and "t2MtToPfMet_tes":
            warnings.warn( "EETauTauTree: Expected branch t2MtToPfMet_tes does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t2MtToPfMet_tes")
        else:
            self.t2MtToPfMet_tes_branch.SetAddress(<void*>&self.t2MtToPfMet_tes_value)

        #print "making t2MtToPfMet_ues"
        self.t2MtToPfMet_ues_branch = the_tree.GetBranch("t2MtToPfMet_ues")
        #if not self.t2MtToPfMet_ues_branch and "t2MtToPfMet_ues" not in self.complained:
        if not self.t2MtToPfMet_ues_branch and "t2MtToPfMet_ues":
            warnings.warn( "EETauTauTree: Expected branch t2MtToPfMet_ues does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t2MtToPfMet_ues")
        else:
            self.t2MtToPfMet_ues_branch.SetAddress(<void*>&self.t2MtToPfMet_ues_value)

        #print "making t2MuOverlap"
        self.t2MuOverlap_branch = the_tree.GetBranch("t2MuOverlap")
        #if not self.t2MuOverlap_branch and "t2MuOverlap" not in self.complained:
        if not self.t2MuOverlap_branch and "t2MuOverlap":
            warnings.warn( "EETauTauTree: Expected branch t2MuOverlap does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t2MuOverlap")
        else:
            self.t2MuOverlap_branch.SetAddress(<void*>&self.t2MuOverlap_value)

        #print "making t2MuOverlapZHLoose"
        self.t2MuOverlapZHLoose_branch = the_tree.GetBranch("t2MuOverlapZHLoose")
        #if not self.t2MuOverlapZHLoose_branch and "t2MuOverlapZHLoose" not in self.complained:
        if not self.t2MuOverlapZHLoose_branch and "t2MuOverlapZHLoose":
            warnings.warn( "EETauTauTree: Expected branch t2MuOverlapZHLoose does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t2MuOverlapZHLoose")
        else:
            self.t2MuOverlapZHLoose_branch.SetAddress(<void*>&self.t2MuOverlapZHLoose_value)

        #print "making t2MuOverlapZHTight"
        self.t2MuOverlapZHTight_branch = the_tree.GetBranch("t2MuOverlapZHTight")
        #if not self.t2MuOverlapZHTight_branch and "t2MuOverlapZHTight" not in self.complained:
        if not self.t2MuOverlapZHTight_branch and "t2MuOverlapZHTight":
            warnings.warn( "EETauTauTree: Expected branch t2MuOverlapZHTight does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t2MuOverlapZHTight")
        else:
            self.t2MuOverlapZHTight_branch.SetAddress(<void*>&self.t2MuOverlapZHTight_value)

        #print "making t2Phi"
        self.t2Phi_branch = the_tree.GetBranch("t2Phi")
        #if not self.t2Phi_branch and "t2Phi" not in self.complained:
        if not self.t2Phi_branch and "t2Phi":
            warnings.warn( "EETauTauTree: Expected branch t2Phi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t2Phi")
        else:
            self.t2Phi_branch.SetAddress(<void*>&self.t2Phi_value)

        #print "making t2Pt"
        self.t2Pt_branch = the_tree.GetBranch("t2Pt")
        #if not self.t2Pt_branch and "t2Pt" not in self.complained:
        if not self.t2Pt_branch and "t2Pt":
            warnings.warn( "EETauTauTree: Expected branch t2Pt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t2Pt")
        else:
            self.t2Pt_branch.SetAddress(<void*>&self.t2Pt_value)

        #print "making t2Rank"
        self.t2Rank_branch = the_tree.GetBranch("t2Rank")
        #if not self.t2Rank_branch and "t2Rank" not in self.complained:
        if not self.t2Rank_branch and "t2Rank":
            warnings.warn( "EETauTauTree: Expected branch t2Rank does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t2Rank")
        else:
            self.t2Rank_branch.SetAddress(<void*>&self.t2Rank_value)

        #print "making t2TNPId"
        self.t2TNPId_branch = the_tree.GetBranch("t2TNPId")
        #if not self.t2TNPId_branch and "t2TNPId" not in self.complained:
        if not self.t2TNPId_branch and "t2TNPId":
            warnings.warn( "EETauTauTree: Expected branch t2TNPId does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t2TNPId")
        else:
            self.t2TNPId_branch.SetAddress(<void*>&self.t2TNPId_value)

        #print "making t2TightIso"
        self.t2TightIso_branch = the_tree.GetBranch("t2TightIso")
        #if not self.t2TightIso_branch and "t2TightIso" not in self.complained:
        if not self.t2TightIso_branch and "t2TightIso":
            warnings.warn( "EETauTauTree: Expected branch t2TightIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t2TightIso")
        else:
            self.t2TightIso_branch.SetAddress(<void*>&self.t2TightIso_value)

        #print "making t2TightIso3Hits"
        self.t2TightIso3Hits_branch = the_tree.GetBranch("t2TightIso3Hits")
        #if not self.t2TightIso3Hits_branch and "t2TightIso3Hits" not in self.complained:
        if not self.t2TightIso3Hits_branch and "t2TightIso3Hits":
            warnings.warn( "EETauTauTree: Expected branch t2TightIso3Hits does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t2TightIso3Hits")
        else:
            self.t2TightIso3Hits_branch.SetAddress(<void*>&self.t2TightIso3Hits_value)

        #print "making t2TightMVA2Iso"
        self.t2TightMVA2Iso_branch = the_tree.GetBranch("t2TightMVA2Iso")
        #if not self.t2TightMVA2Iso_branch and "t2TightMVA2Iso" not in self.complained:
        if not self.t2TightMVA2Iso_branch and "t2TightMVA2Iso":
            warnings.warn( "EETauTauTree: Expected branch t2TightMVA2Iso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t2TightMVA2Iso")
        else:
            self.t2TightMVA2Iso_branch.SetAddress(<void*>&self.t2TightMVA2Iso_value)

        #print "making t2TightMVAIso"
        self.t2TightMVAIso_branch = the_tree.GetBranch("t2TightMVAIso")
        #if not self.t2TightMVAIso_branch and "t2TightMVAIso" not in self.complained:
        if not self.t2TightMVAIso_branch and "t2TightMVAIso":
            warnings.warn( "EETauTauTree: Expected branch t2TightMVAIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t2TightMVAIso")
        else:
            self.t2TightMVAIso_branch.SetAddress(<void*>&self.t2TightMVAIso_value)

        #print "making t2ToMETDPhi"
        self.t2ToMETDPhi_branch = the_tree.GetBranch("t2ToMETDPhi")
        #if not self.t2ToMETDPhi_branch and "t2ToMETDPhi" not in self.complained:
        if not self.t2ToMETDPhi_branch and "t2ToMETDPhi":
            warnings.warn( "EETauTauTree: Expected branch t2ToMETDPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t2ToMETDPhi")
        else:
            self.t2ToMETDPhi_branch.SetAddress(<void*>&self.t2ToMETDPhi_value)

        #print "making t2VLooseIso"
        self.t2VLooseIso_branch = the_tree.GetBranch("t2VLooseIso")
        #if not self.t2VLooseIso_branch and "t2VLooseIso" not in self.complained:
        if not self.t2VLooseIso_branch and "t2VLooseIso":
            warnings.warn( "EETauTauTree: Expected branch t2VLooseIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t2VLooseIso")
        else:
            self.t2VLooseIso_branch.SetAddress(<void*>&self.t2VLooseIso_value)

        #print "making t2VZ"
        self.t2VZ_branch = the_tree.GetBranch("t2VZ")
        #if not self.t2VZ_branch and "t2VZ" not in self.complained:
        if not self.t2VZ_branch and "t2VZ":
            warnings.warn( "EETauTauTree: Expected branch t2VZ does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("t2VZ")
        else:
            self.t2VZ_branch.SetAddress(<void*>&self.t2VZ_value)

        #print "making tauHpsVetoPt20"
        self.tauHpsVetoPt20_branch = the_tree.GetBranch("tauHpsVetoPt20")
        #if not self.tauHpsVetoPt20_branch and "tauHpsVetoPt20" not in self.complained:
        if not self.tauHpsVetoPt20_branch and "tauHpsVetoPt20":
            warnings.warn( "EETauTauTree: Expected branch tauHpsVetoPt20 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tauHpsVetoPt20")
        else:
            self.tauHpsVetoPt20_branch.SetAddress(<void*>&self.tauHpsVetoPt20_value)

        #print "making tauTightCountZH"
        self.tauTightCountZH_branch = the_tree.GetBranch("tauTightCountZH")
        #if not self.tauTightCountZH_branch and "tauTightCountZH" not in self.complained:
        if not self.tauTightCountZH_branch and "tauTightCountZH":
            warnings.warn( "EETauTauTree: Expected branch tauTightCountZH does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tauTightCountZH")
        else:
            self.tauTightCountZH_branch.SetAddress(<void*>&self.tauTightCountZH_value)

        #print "making tauVetoPt20"
        self.tauVetoPt20_branch = the_tree.GetBranch("tauVetoPt20")
        #if not self.tauVetoPt20_branch and "tauVetoPt20" not in self.complained:
        if not self.tauVetoPt20_branch and "tauVetoPt20":
            warnings.warn( "EETauTauTree: Expected branch tauVetoPt20 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tauVetoPt20")
        else:
            self.tauVetoPt20_branch.SetAddress(<void*>&self.tauVetoPt20_value)

        #print "making tauVetoPt20Loose3HitsVtx"
        self.tauVetoPt20Loose3HitsVtx_branch = the_tree.GetBranch("tauVetoPt20Loose3HitsVtx")
        #if not self.tauVetoPt20Loose3HitsVtx_branch and "tauVetoPt20Loose3HitsVtx" not in self.complained:
        if not self.tauVetoPt20Loose3HitsVtx_branch and "tauVetoPt20Loose3HitsVtx":
            warnings.warn( "EETauTauTree: Expected branch tauVetoPt20Loose3HitsVtx does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tauVetoPt20Loose3HitsVtx")
        else:
            self.tauVetoPt20Loose3HitsVtx_branch.SetAddress(<void*>&self.tauVetoPt20Loose3HitsVtx_value)

        #print "making tauVetoPt20LooseMVA2Vtx"
        self.tauVetoPt20LooseMVA2Vtx_branch = the_tree.GetBranch("tauVetoPt20LooseMVA2Vtx")
        #if not self.tauVetoPt20LooseMVA2Vtx_branch and "tauVetoPt20LooseMVA2Vtx" not in self.complained:
        if not self.tauVetoPt20LooseMVA2Vtx_branch and "tauVetoPt20LooseMVA2Vtx":
            warnings.warn( "EETauTauTree: Expected branch tauVetoPt20LooseMVA2Vtx does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tauVetoPt20LooseMVA2Vtx")
        else:
            self.tauVetoPt20LooseMVA2Vtx_branch.SetAddress(<void*>&self.tauVetoPt20LooseMVA2Vtx_value)

        #print "making tauVetoPt20LooseMVAVtx"
        self.tauVetoPt20LooseMVAVtx_branch = the_tree.GetBranch("tauVetoPt20LooseMVAVtx")
        #if not self.tauVetoPt20LooseMVAVtx_branch and "tauVetoPt20LooseMVAVtx" not in self.complained:
        if not self.tauVetoPt20LooseMVAVtx_branch and "tauVetoPt20LooseMVAVtx":
            warnings.warn( "EETauTauTree: Expected branch tauVetoPt20LooseMVAVtx does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tauVetoPt20LooseMVAVtx")
        else:
            self.tauVetoPt20LooseMVAVtx_branch.SetAddress(<void*>&self.tauVetoPt20LooseMVAVtx_value)

        #print "making tauVetoPt20VLooseHPSVtx"
        self.tauVetoPt20VLooseHPSVtx_branch = the_tree.GetBranch("tauVetoPt20VLooseHPSVtx")
        #if not self.tauVetoPt20VLooseHPSVtx_branch and "tauVetoPt20VLooseHPSVtx" not in self.complained:
        if not self.tauVetoPt20VLooseHPSVtx_branch and "tauVetoPt20VLooseHPSVtx":
            warnings.warn( "EETauTauTree: Expected branch tauVetoPt20VLooseHPSVtx does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tauVetoPt20VLooseHPSVtx")
        else:
            self.tauVetoPt20VLooseHPSVtx_branch.SetAddress(<void*>&self.tauVetoPt20VLooseHPSVtx_value)

        #print "making tauVetoZH"
        self.tauVetoZH_branch = the_tree.GetBranch("tauVetoZH")
        #if not self.tauVetoZH_branch and "tauVetoZH" not in self.complained:
        if not self.tauVetoZH_branch and "tauVetoZH":
            warnings.warn( "EETauTauTree: Expected branch tauVetoZH does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tauVetoZH")
        else:
            self.tauVetoZH_branch.SetAddress(<void*>&self.tauVetoZH_value)

        #print "making type1_pfMetEt"
        self.type1_pfMetEt_branch = the_tree.GetBranch("type1_pfMetEt")
        #if not self.type1_pfMetEt_branch and "type1_pfMetEt" not in self.complained:
        if not self.type1_pfMetEt_branch and "type1_pfMetEt":
            warnings.warn( "EETauTauTree: Expected branch type1_pfMetEt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMetEt")
        else:
            self.type1_pfMetEt_branch.SetAddress(<void*>&self.type1_pfMetEt_value)

        #print "making type1_pfMetPhi"
        self.type1_pfMetPhi_branch = the_tree.GetBranch("type1_pfMetPhi")
        #if not self.type1_pfMetPhi_branch and "type1_pfMetPhi" not in self.complained:
        if not self.type1_pfMetPhi_branch and "type1_pfMetPhi":
            warnings.warn( "EETauTauTree: Expected branch type1_pfMetPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMetPhi")
        else:
            self.type1_pfMetPhi_branch.SetAddress(<void*>&self.type1_pfMetPhi_value)

        #print "making idx"
        self.idx_branch = the_tree.GetBranch("idx")
        #if not self.idx_branch and "idx" not in self.complained:
        if not self.idx_branch and "idx":
            warnings.warn( "EETauTauTree: Expected branch idx does not exist!"                " It will crash if you try and use it!",Warning)
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

    property e1_t1_CosThetaStar:
        def __get__(self):
            self.e1_t1_CosThetaStar_branch.GetEntry(self.localentry, 0)
            return self.e1_t1_CosThetaStar_value

    property e1_t1_DPhi:
        def __get__(self):
            self.e1_t1_DPhi_branch.GetEntry(self.localentry, 0)
            return self.e1_t1_DPhi_value

    property e1_t1_DR:
        def __get__(self):
            self.e1_t1_DR_branch.GetEntry(self.localentry, 0)
            return self.e1_t1_DR_value

    property e1_t1_Eta:
        def __get__(self):
            self.e1_t1_Eta_branch.GetEntry(self.localentry, 0)
            return self.e1_t1_Eta_value

    property e1_t1_Mass:
        def __get__(self):
            self.e1_t1_Mass_branch.GetEntry(self.localentry, 0)
            return self.e1_t1_Mass_value

    property e1_t1_MassFsr:
        def __get__(self):
            self.e1_t1_MassFsr_branch.GetEntry(self.localentry, 0)
            return self.e1_t1_MassFsr_value

    property e1_t1_PZeta:
        def __get__(self):
            self.e1_t1_PZeta_branch.GetEntry(self.localentry, 0)
            return self.e1_t1_PZeta_value

    property e1_t1_PZetaVis:
        def __get__(self):
            self.e1_t1_PZetaVis_branch.GetEntry(self.localentry, 0)
            return self.e1_t1_PZetaVis_value

    property e1_t1_Phi:
        def __get__(self):
            self.e1_t1_Phi_branch.GetEntry(self.localentry, 0)
            return self.e1_t1_Phi_value

    property e1_t1_Pt:
        def __get__(self):
            self.e1_t1_Pt_branch.GetEntry(self.localentry, 0)
            return self.e1_t1_Pt_value

    property e1_t1_PtFsr:
        def __get__(self):
            self.e1_t1_PtFsr_branch.GetEntry(self.localentry, 0)
            return self.e1_t1_PtFsr_value

    property e1_t1_SS:
        def __get__(self):
            self.e1_t1_SS_branch.GetEntry(self.localentry, 0)
            return self.e1_t1_SS_value

    property e1_t1_ToMETDPhi_Ty1:
        def __get__(self):
            self.e1_t1_ToMETDPhi_Ty1_branch.GetEntry(self.localentry, 0)
            return self.e1_t1_ToMETDPhi_Ty1_value

    property e1_t1_Zcompat:
        def __get__(self):
            self.e1_t1_Zcompat_branch.GetEntry(self.localentry, 0)
            return self.e1_t1_Zcompat_value

    property e1_t2_CosThetaStar:
        def __get__(self):
            self.e1_t2_CosThetaStar_branch.GetEntry(self.localentry, 0)
            return self.e1_t2_CosThetaStar_value

    property e1_t2_DPhi:
        def __get__(self):
            self.e1_t2_DPhi_branch.GetEntry(self.localentry, 0)
            return self.e1_t2_DPhi_value

    property e1_t2_DR:
        def __get__(self):
            self.e1_t2_DR_branch.GetEntry(self.localentry, 0)
            return self.e1_t2_DR_value

    property e1_t2_Eta:
        def __get__(self):
            self.e1_t2_Eta_branch.GetEntry(self.localentry, 0)
            return self.e1_t2_Eta_value

    property e1_t2_Mass:
        def __get__(self):
            self.e1_t2_Mass_branch.GetEntry(self.localentry, 0)
            return self.e1_t2_Mass_value

    property e1_t2_MassFsr:
        def __get__(self):
            self.e1_t2_MassFsr_branch.GetEntry(self.localentry, 0)
            return self.e1_t2_MassFsr_value

    property e1_t2_PZeta:
        def __get__(self):
            self.e1_t2_PZeta_branch.GetEntry(self.localentry, 0)
            return self.e1_t2_PZeta_value

    property e1_t2_PZetaVis:
        def __get__(self):
            self.e1_t2_PZetaVis_branch.GetEntry(self.localentry, 0)
            return self.e1_t2_PZetaVis_value

    property e1_t2_Phi:
        def __get__(self):
            self.e1_t2_Phi_branch.GetEntry(self.localentry, 0)
            return self.e1_t2_Phi_value

    property e1_t2_Pt:
        def __get__(self):
            self.e1_t2_Pt_branch.GetEntry(self.localentry, 0)
            return self.e1_t2_Pt_value

    property e1_t2_PtFsr:
        def __get__(self):
            self.e1_t2_PtFsr_branch.GetEntry(self.localentry, 0)
            return self.e1_t2_PtFsr_value

    property e1_t2_SS:
        def __get__(self):
            self.e1_t2_SS_branch.GetEntry(self.localentry, 0)
            return self.e1_t2_SS_value

    property e1_t2_ToMETDPhi_Ty1:
        def __get__(self):
            self.e1_t2_ToMETDPhi_Ty1_branch.GetEntry(self.localentry, 0)
            return self.e1_t2_ToMETDPhi_Ty1_value

    property e1_t2_Zcompat:
        def __get__(self):
            self.e1_t2_Zcompat_branch.GetEntry(self.localentry, 0)
            return self.e1_t2_Zcompat_value

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

    property e2_t1_CosThetaStar:
        def __get__(self):
            self.e2_t1_CosThetaStar_branch.GetEntry(self.localentry, 0)
            return self.e2_t1_CosThetaStar_value

    property e2_t1_DPhi:
        def __get__(self):
            self.e2_t1_DPhi_branch.GetEntry(self.localentry, 0)
            return self.e2_t1_DPhi_value

    property e2_t1_DR:
        def __get__(self):
            self.e2_t1_DR_branch.GetEntry(self.localentry, 0)
            return self.e2_t1_DR_value

    property e2_t1_Eta:
        def __get__(self):
            self.e2_t1_Eta_branch.GetEntry(self.localentry, 0)
            return self.e2_t1_Eta_value

    property e2_t1_Mass:
        def __get__(self):
            self.e2_t1_Mass_branch.GetEntry(self.localentry, 0)
            return self.e2_t1_Mass_value

    property e2_t1_MassFsr:
        def __get__(self):
            self.e2_t1_MassFsr_branch.GetEntry(self.localentry, 0)
            return self.e2_t1_MassFsr_value

    property e2_t1_PZeta:
        def __get__(self):
            self.e2_t1_PZeta_branch.GetEntry(self.localentry, 0)
            return self.e2_t1_PZeta_value

    property e2_t1_PZetaVis:
        def __get__(self):
            self.e2_t1_PZetaVis_branch.GetEntry(self.localentry, 0)
            return self.e2_t1_PZetaVis_value

    property e2_t1_Phi:
        def __get__(self):
            self.e2_t1_Phi_branch.GetEntry(self.localentry, 0)
            return self.e2_t1_Phi_value

    property e2_t1_Pt:
        def __get__(self):
            self.e2_t1_Pt_branch.GetEntry(self.localentry, 0)
            return self.e2_t1_Pt_value

    property e2_t1_PtFsr:
        def __get__(self):
            self.e2_t1_PtFsr_branch.GetEntry(self.localentry, 0)
            return self.e2_t1_PtFsr_value

    property e2_t1_SS:
        def __get__(self):
            self.e2_t1_SS_branch.GetEntry(self.localentry, 0)
            return self.e2_t1_SS_value

    property e2_t1_ToMETDPhi_Ty1:
        def __get__(self):
            self.e2_t1_ToMETDPhi_Ty1_branch.GetEntry(self.localentry, 0)
            return self.e2_t1_ToMETDPhi_Ty1_value

    property e2_t1_Zcompat:
        def __get__(self):
            self.e2_t1_Zcompat_branch.GetEntry(self.localentry, 0)
            return self.e2_t1_Zcompat_value

    property e2_t2_CosThetaStar:
        def __get__(self):
            self.e2_t2_CosThetaStar_branch.GetEntry(self.localentry, 0)
            return self.e2_t2_CosThetaStar_value

    property e2_t2_DPhi:
        def __get__(self):
            self.e2_t2_DPhi_branch.GetEntry(self.localentry, 0)
            return self.e2_t2_DPhi_value

    property e2_t2_DR:
        def __get__(self):
            self.e2_t2_DR_branch.GetEntry(self.localentry, 0)
            return self.e2_t2_DR_value

    property e2_t2_Eta:
        def __get__(self):
            self.e2_t2_Eta_branch.GetEntry(self.localentry, 0)
            return self.e2_t2_Eta_value

    property e2_t2_Mass:
        def __get__(self):
            self.e2_t2_Mass_branch.GetEntry(self.localentry, 0)
            return self.e2_t2_Mass_value

    property e2_t2_MassFsr:
        def __get__(self):
            self.e2_t2_MassFsr_branch.GetEntry(self.localentry, 0)
            return self.e2_t2_MassFsr_value

    property e2_t2_PZeta:
        def __get__(self):
            self.e2_t2_PZeta_branch.GetEntry(self.localentry, 0)
            return self.e2_t2_PZeta_value

    property e2_t2_PZetaVis:
        def __get__(self):
            self.e2_t2_PZetaVis_branch.GetEntry(self.localentry, 0)
            return self.e2_t2_PZetaVis_value

    property e2_t2_Phi:
        def __get__(self):
            self.e2_t2_Phi_branch.GetEntry(self.localentry, 0)
            return self.e2_t2_Phi_value

    property e2_t2_Pt:
        def __get__(self):
            self.e2_t2_Pt_branch.GetEntry(self.localentry, 0)
            return self.e2_t2_Pt_value

    property e2_t2_PtFsr:
        def __get__(self):
            self.e2_t2_PtFsr_branch.GetEntry(self.localentry, 0)
            return self.e2_t2_PtFsr_value

    property e2_t2_SS:
        def __get__(self):
            self.e2_t2_SS_branch.GetEntry(self.localentry, 0)
            return self.e2_t2_SS_value

    property e2_t2_ToMETDPhi_Ty1:
        def __get__(self):
            self.e2_t2_ToMETDPhi_Ty1_branch.GetEntry(self.localentry, 0)
            return self.e2_t2_ToMETDPhi_Ty1_value

    property e2_t2_Zcompat:
        def __get__(self):
            self.e2_t2_Zcompat_branch.GetEntry(self.localentry, 0)
            return self.e2_t2_Zcompat_value

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


