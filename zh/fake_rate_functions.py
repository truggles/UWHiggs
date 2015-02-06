import os
from FinalStateAnalysis.StatTools.RooFunctorFromWS import build_roofunctor
from ROOT import TMath

################################################################################
#### Fitted fake rate functions ################################################
################################################################################

# Get fitted fake rate functions
frfit_dir = os.path.join('results', os.environ['jobid'], 'fakerate_fits')

mu_tight_jetpt_fr = build_roofunctor(
    frfit_dir + '/m_zlt_pt10_tightId_muonJetPt.root',
    'fit_efficiency',# workspace name
    'efficiency'
)

e_tight_jetpt_fr =build_roofunctor(
    frfit_dir + '/e_zlt_pt10_tightId_electronJetPt.root',
    'fit_efficiency',
    'efficiency'
)

mu_loose_jetpt_fr = build_roofunctor(
    frfit_dir + '/m_zlt_pt10_looseId_muonJetPt.root',
    'fit_efficiency',
    'efficiency'
)

# We are plitting loose by barrel and endcap
#e_loose_jetpt_fr =build_roofunctor(
#    frfit_dir + '/e_zlt_pt10_looseId_electronJetPt.root',
#    'fit_efficiency',
#    'efficiency'
#)

e_loose_jetpt_barrle_fr =build_roofunctor(
    frfit_dir + '/e_zlt_pt10_looseId_electronJetPtBarrel.root',
    'fit_efficiency',
    'efficiency'
)

e_loose_jetpt_endcap_fr =build_roofunctor(
    frfit_dir + '/e_zlt_pt10_looseId_electronJetPtEndCap.root',
    'fit_efficiency',
    'efficiency'
)

tau_medium_jetpt_fr_low = build_roofunctor(
    frfit_dir + '/t_ztt_pt10low_MediumIso3Hits_tauJetPt_tautau.root',
    'fit_efficiency',
    'efficiency'
)
tau_medium_jetpt_fr_high = build_roofunctor(
    frfit_dir + '/t_ztt_pt10high_MediumIso3Hits_tauJetPt_tautau.root',
    'fit_efficiency',
    'efficiency'
)

tau_jetpt_fr_low = build_roofunctor(
    frfit_dir + '/t_ztt_pt10low_LooseIso3Hits_tauJetPt_ltau.root',
    'fit_efficiency',
    'efficiency'
)
tau_jetpt_fr_high = build_roofunctor(
    frfit_dir + '/t_ztt_pt10high_LooseIso3Hits_tauJetPt_ltau.root',
    'fit_efficiency',
    'efficiency'
)


# Hardcoded fake rate fit functions for comparison with RooStats versions.
#$$ def mu_loose_jetpt_fr( Pt ):
#$$   scale = 1.0790e+00 - 7.10e-01
#$$   decay = -8.7340e-02 - 2.03e-02
#$$   offset = 3.6711e-03 - 2.20e-03
#$$   return (scale*TMath.Exp(Pt*decay)+offset)
#$$ 
#$$ 
#$$ def e_tight_jetpt_fr( Pt ):
#$$   scale = 1.4488e-01 - 1.56e-01
#$$   decay = -1.0302e-01 - 4.01e-02
#$$   offset = 3.7096e-03 - 9.11e-04
#$$   return (scale*TMath.Exp(Pt*decay)+offset)
#$$ 
#$$ 
#$$ def mu_tight_jetpt_fr( Pt ):
#$$   scale = 1.0767e+00 - 7.23e-01
#$$   decay = -8.8429e-02 - 2.09e-02
#$$   offset = 3.7251e-03 - 2.19e-03
#$$   return (scale*TMath.Exp(Pt*decay)+offset)
#$$ 
#$$ 
#$$ def e_loose_jetpt_fr( Pt ):
#$$   scale = 7.4425e-01 - 6.53e-01
#$$   decay = -1.0879e-01 - 2.94e-02
#$$   offset = 1.2421e-02 - 1.57e-03
#$$   return (scale*TMath.Exp(Pt*decay)+offset)

#$$def tau_medium_jetpt_fr_low( Pt ):
#$$  scale = 1.8584e+00 - 9.42e-01
#$$  decay = -8.7303e-02 - 1.05e-02
#$$  offset = 1.9512e-03 - 3.73e-04
#$$  return (scale*TMath.Exp(Pt*decay)+offset)
#$$
#$$
#$$def tau_medium_jetpt_fr_high( Pt ): 
#$$  scale = 2.9989e+00 - 1.52e+00
#$$  decay = -8.2747e-02 - 1.17e-02
#$$  offset = 3.8377e-03 - 1.15e-03
#$$  return (scale*TMath.Exp(Pt*decay)+offset)
#$$
#$$
#$$def tau_jetpt_fr_low( Pt ):
#$$  scale = 2.2609e+00 - 1.10e+00
#$$  decay = -7.9702e-02 - 1.05e-02
#$$  offset = 2.5477e-03 - 9.46e-04
#$$  return (scale*TMath.Exp(Pt*decay)+offset)
#$$
#$$
#$$def tau_jetpt_fr_high( Pt ):
#$$  scale = 5.0000e+00 - 3.63e+00
#$$  decay = -9.1265e-02 - 5.17e-03
#$$  offset = 9.7737e-03 - 2.62e-03
#$$  return (scale*TMath.Exp(Pt*decay)+offset)
#$$
