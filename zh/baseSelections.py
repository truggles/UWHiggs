'''
Common selection used in ZH analysis
'''

import os
from FinalStateAnalysis.PlotTools.decorators import memo

@memo
def getVar(name, var):
    return name+var

# Determine MC-DATA corrections
is7TeV = bool('7TeV' in os.environ['jobid'])

iso_base_name = 'RelPFIsoDB' #'RelPFIsoDBZhLike'
def objIsolation(row,muon):
    return getattr(row, getVar(muon, iso_base_name) )

def muIsoTight(row,muon):
    return objIsolation(row,muon) < 0.15

def muIsoLoose(row,muon):
    return objIsolation(row,muon) < 0.30

def elIsoTight(row,el):
    return objIsolation(row,el) < 0.20 # used to be < 0.15

def elIsoLoose(row,el):
    return objIsolation(row,el) < 0.30


def MuTriggerMatching(row):
    '''
    Applies trigger matching according to the run period
    '''
    if is7TeV:
        return row.m1MatchesDoubleMu2011Paths > 0 and row.m2MatchesDoubleMu2011Paths > 0
    else:
        #return True
        if (row.m1MatchesDoubleMuPaths <= 0 and row.m1MatchesDoubleMuTrkPaths <= 0): return False
        if (row.m2MatchesDoubleMuPaths <= 0 and row.m2MatchesDoubleMuTrkPaths <= 0): return False
        return True
 
def ElTriggerMatching(row):
    '''
    Applies trigger matching
    '''
    #return True
    return (row.e1MatchesDoubleEPath > 0 and row.e2MatchesDoubleEPath > 0)

def Vetos(row):
    '''
    applies b-tag, muon, electron and tau veto
    '''
    #if (row.bjetTightCountZH > 0): return False
    if (row.bjetCSVVetoZHLikeNoJetId_2 > 0): return False
    
    # Doubl check that elminiating these next two vetos doesn't mess us up (new counting mthds in channel specific files
    if (row.muVetoZH > 0): return False
    if (row.eVetoZH > 0): return False
      #print "eVetoZH killed an event"
    #  return False
    #if bool(row.t_tauHpsVetoPt15): return False
    return True
    #return (row.bjetCSVVetoZHLikeNoJetId_2 <= 0 and row.muVetoZH <= 0 and row.eVetoZH <= 0)

def overlap(row,*args):
    return any( map( lambda x: x < 0.1, [getattr(row,'%s_%s_DR' % (l1,l2) ) for l1 in args for l2 in args if l1 <> l2 and hasattr(row,'%s_%s_DR' % (l1,l2) )] ) ) 

def generalCuts(row, *args):
    if overlap(row, *args): return False

    # all leptons within 0.1cm of the primary vertex
    for l in args:
      if abs(getattr(row, getVar(l, 'DZ') ) ) > 0.1: return False


    #if not Vetos(row): return False
    return Vetos(row)
    #return not any( map( lambda x: x > 0.1, getattr(row,'%sDZ' % l for l in args) ) )

def eleIDLoose(row, name):
    if getattr(row, getVar(name, 'Pt') )   < 10: return False
    if getattr(row, getVar(name, 'MissingHits') ) >= 2: return False
    if getattr(row, getVar(name, 'AbsEta') ) < 0.8    and getattr(row, getVar(name, 'MVANonTrig')) > 0.5: return True
    if getattr(row, getVar(name, 'AbsEta') ) >= 0.8   and getattr(row, getVar(name, 'AbsEta')) < 1.479 and getattr(row, getVar(name, 'MVANonTrig')) > 0.12: return True
    if getattr(row, getVar(name, 'AbsEta') ) >= 1.479 and getattr(row, getVar(name, 'MVANonTrig')) > 0.6: return True
    return False

def eleIDTight(row, name):
    if (getattr(row, getVar(name, 'MissingHits') ) >= 2 ): return False
    if (getattr(row, getVar(name, 'Pt') ) < 20. and  getattr(row, getVar(name, 'AbsEta') ) < 0.8 and getattr(row, getVar(name, 'MVANonTrig')) > 0.925): return True
    if (getattr(row, getVar(name, 'Pt') ) < 20. and getattr(row, getVar(name, 'AbsEta') ) >= 0.8 and getattr(row, getVar(name, 'AbsEta') ) < 1.479 and getattr(row, getVar(name, 'MVANonTrig')) > 0.915): return True
    if (getattr(row, getVar(name, 'Pt') ) < 20. and getattr(row, getVar(name, 'AbsEta') ) >= 1.479 and getattr(row, getVar(name, 'MVANonTrig')) > 0.965): return True

    if (getattr(row, getVar(name, 'Pt') ) > 20. and getattr(row, getVar(name, 'AbsEta') ) < 0.8 and getattr(row, getVar(name, 'MVANonTrig')) > 0.905): return True
    if (getattr(row, getVar(name, 'Pt') ) > 20. and getattr(row, getVar(name, 'AbsEta') ) >= 0.8 and getattr(row, getVar(name, 'AbsEta') ) < 1.479 and getattr(row, getVar(name, 'MVANonTrig')) > 0.955): return True
    if (getattr(row, getVar(name, 'Pt') ) > 20. and getattr(row, getVar(name, 'AbsEta') ) >= 1.479 and getattr(row, getVar(name, 'MVANonTrig')) > 0.975): return True
    return False

def muIDLoose(row, name):
    if not bool(getattr(row, getVar(name, 'IsGlobal'))): return False
    if not bool(getattr(row, getVar(name, 'IsTracker'))): return False
    if not bool(getattr(row, getVar(name, 'IsPFMuon'))): return False
    return True

def muIDTight(row, name):
    return bool(getattr(row, getVar(name, 'PFIDTight') ) )

def ZMuMuSelection(row):
    '''
    Z Selection as AN
    '''
    #Z Selection
   # print "x"
    if not (row.doubleMuPass > 0 or row.doubleMuTrkPass > 0):  return False
   # print "y"
    if not tightMuonSelection(row, 'm1'):            return False
    if not tightMuonSelection(row, 'm2'):            return False
   # print "z1"
    if row.m1Pt < 20:                                return False
   # print "z2"
    if bool(row.m1_m2_SS):                           return False
   # print "z3"
    if row.m1_m2_Mass < 60 or row.m1_m2_Mass > 120 : return False
   # print "z4"
   
    #if row.m1Pt < row.m2Pt:                            return False
    #if row.m1Pt < 20:                                  return False
    #if row.m2Pt < 10:                                  return False
    #if row.m1AbsEta > 2.4:                             return False
    #if row.m2AbsEta > 2.4:                             return False
    #if abs(row.m1DZ) > 0.1:                            return False
    #if abs(row.m2DZ) > 0.1:                            return False
    #if not muIDLoose(row,'m1'):                      return False
    #if not muIsoLoose(row,'m1'):                       return False
    #if not muIDLoose(row,'m2'):                      return False
    #if not muIsoLoose(row,'m2'):                       return False
    #if bool(row.m1_m2_SS):                             return False
    #if row.m1_m2_Mass < 60 or row.m1_m2_Mass > 120 :   return False
    # a bit of a hack in an attempt to sync
    #if bool(row.m1MatchesMu17Ele8IsoPath > 0): return False
    #if bool(row.m2MatchesMu17Ele8IsoPath > 0): return False
    #if bool(row.m1MatchesMu8Ele17IsoPath > 0): return False
    #if bool(row.m2MatchesMu8Ele17IsoPath > 0): return False
    #return True
    return MuTriggerMatching(row)
#    print "z5"

def ZEESelection(row):
    '''
    Z Selection as AN
    '''
#    print "x"
    if not tightElectronSelection(row, 'e1'):        return False
#    print "y"
    if not tightElectronSelection(row, 'e2'):        return False
#    print "z1"
    if row.e1Pt < 20:                                return False
#    print "z2"
    if bool(row.e1_e2_SS):                           return False
#    print "z3"
    if row.e1_e2_Mass < 60 or row.e1_e2_Mass > 120 : return False
#    print "z4"
    if not row.doubleEPass > 0:                      return False
#    print "z4p5"
    #if row.e1Pt < row.e2Pt:                          return False
    #if row.e1Pt < 20:                                return False
    #if row.e2Pt < 10:                                return False
    #if row.e1AbsEta > 2.5:                           return False
    #if row.e2AbsEta > 2.5:                           return False
    #if abs(row.e1DZ) > 0.1:                          return False
    #if abs(row.e2DZ) > 0.1:                          return False
    #if not eleID(row, 'e1'):                         return False
    #if not elIsoLoose(row, 'e1'):                    return False
    #if not eleID(row, 'e2'):                         return False
    #if not elIsoLoose(row, 'e1'):                    return False
    #if bool(row.e1_e2_SS):                           return False
    #if row.e1_e2_Mass < 60 or row.e1_e2_Mass > 120 : return False
    #return True
    return ElTriggerMatching(row)
    #print "z5"    

def looseMuonSelection(row,muId):
    '''
    Basic selection for signal muons (the ones coming from Higgs). No Isolation applied
    '''
    if getattr(row, getVar(muId,'Pt') ) < 10:              return False
    if getattr(row, getVar(muId,'AbsEta') ) > 2.4:         return False
    if bool(getattr(row, getVar(muId, 'IsGlobal'))) or bool(getattr(row, getVar(muId, 'IsTracker'))): return True
    return False

def tightMuonSelection(row, muId):
    if getattr(row, getVar(muId,'Pt') ) < 10:              return False
    if getattr(row, getVar(muId,'AbsEta') ) > 2.4:         return False
    #print "hi1"
    if not muIDLoose(row, muId): return False
    #print "hi2"
    if not muIsoLoose(row, muId): return False
    #print "hi3"
    return True
    

def looseTauSelection(row, tauId, ptThr = 20):
    '''
    Basic selection for signal hadronic (the ones coming from Higgs). No Isolation is applied, but DecayMode is
    '''
    if not bool( getattr( row, getVar(tauId, 'DecayFinding') ) ):      return False
    #print "0.1"
    if getattr( row, getVar(tauId, 'Pt') )  < ptThr:                   return False
    #print "0.2"
    if getattr( row, getVar(tauId, 'AbsEta') )  > 2.3:                 return False
    #print "0.3"
    if getattr( row, getVar(tauId, 'JetCSVBtag') ) > 0.679: return False#  and abs(getattr( row, getVar(tauId, 'JetCSVBtag') ) ) != 1:      return False
    #print "0.4"
    if getattr( row, getVar(tauId, 'MuOverlapZHTight') ) > 0:	
#        print "LooseTauSelection failed MuOverlapZHLoose"
        return False
    if getattr( row, getVar(tauId, 'ElecOverlapZHTight') ) > 0:	
#        print "LooseTauSelection failed ElecOverlapZHLoose"
        return False
    return True

def tightTauSelection(row, tauId, ptThr = 20):
    
    if not bool( getattr( row, getVar(tauId, 'DecayFinding') ) ):      return False
    if getattr( row, getVar(tauId, 'Pt') )  < ptThr:                   return False
    if getattr( row, getVar(tauId, 'AbsEta') )  > 2.3:                 return False
    if not bool( getattr( row, getVar(tauId, 'AntiMuonLoose2') ) ):      return False
    if not bool( getattr( row, getVar(tauId, 'AntiElectronLoose') ) ):      return False
    if not bool( getattr( row, getVar(tauId, 'LooseIso3Hits') ) ):      return False
    if getattr( row, getVar(tauId, 'JetCSVBtag') ) > 0.679:      return False
    if getattr( row, getVar(tauId, 'MuOverlapZHTight') ) > 0:	
#        print "TightTauSelec failed MuOverlapZHTight"
        return False
    if getattr( row, getVar(tauId, 'ElecOverlapZHTight') ) > 0:	
#        print "TightTauSelection failed ElecOverlapZHTight"
        return False
    return True


def looseElectronSelection(row, elId):
    '''
    Basic selection for signal electrons (the ones coming from Higgs). No Isolation applied
    '''
    if getattr(row, getVar(elId, 'Pt') ) < 10:                 return False
    if getattr(row, getVar(elId, 'AbsEta') ) > 2.5:            return False
    if getattr(row, getVar(elId, 'MuOverlapZHTight') ) > 0:	   
#        print "LooseElecSelection failed MuOverlapLoose"
        return False
    return True

def tightElectronSelection(row, elId):
    if getattr(row, getVar(elId, 'Pt') ) < 10:                 return False
    if getattr(row, getVar(elId, 'AbsEta') ) > 2.5:            return False
    if not eleIDLoose(row, elId): return False
    if not elIsoLoose(row, elId): return False
    if getattr(row, getVar(elId, 'MuOverlapZHTight') ) > 0:	
#        print "TightElecSelection failed MuOverlapZHTight"
        return False
    return True
    
