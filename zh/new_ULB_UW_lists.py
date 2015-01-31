import ROOT

# map each channel to a number to match Cecile's convention
channel_map = { 'MMTT' : 1,
                'EETT' : 5,
                'MMMT' : 3, 
                'EEMT' : 6,
                'MMET' : 2,
                'EEET' : 7,
                'MMEM' : 4,
                'EEEM' : 8, 
}

dict_prods = { 'MMMT' : ('m1','m2','m3','t'),
              'MMET' : ('m1','m2','e','t'),
              'MMEM' : ('m1','m2','m3','e'),
              'MMTT' : ('m1','m2','t1','t2'),
              'EEMT' : ('e1','e2','m','t'),
              'EEET' : ('e1','e2','e3','t'),
              'EEEM' : ('e1','e2','e3','m'),
              'EETT' : ('e1','e2','t1','t2')
}

mass = 300 # madgraph mA 

#amasses = open("amasses.txt", 'w')

def make_list_txt():
  for samp in ['TES_rerunMVAMET', 'TES']:
      ofile = open("A300_%s.txt" % samp, 'w')
      for channel in ['MMTT','MMMT','MMEM','MMET','EEMT','EEET','EEEM','EETT']:
          #print channel
          ifile = ROOT.TFile("results/2014-02-28_8TeV_Ntuples-v2/ZHAnalyze%s/A300-Zh-lltt-svFit-MadGraph-%s.root" % (channel, samp), "READ" )
          #ifile = ROOT.TFile("results/2014-02-28_8TeV_Ntuples-v2/ZHAnalyze%s/data.root" % (channel), "READ" )
          ntuple = ifile.Get("os/All_Passed/Event_ID")
          for row in ntuple:
               ofile.write("%s %s %i %i %i %f %f %f %f %f %f %f %f %f %f %f\n" % (samp,channel,row.run,row.lumi,(row.evt1*10**5 + row.evt2),round(row.Z_Mass,0),row.t1Pt,row.t1Eta,row.t2Pt,row.t2Eta,row.mva_metEt,row.mva_metPhi,row.pfMetEt,row.pfMetPhi,row.type1_pfMetEt,row.type1_pfMetEt))
      ofile.close()

def make_UW_set():
  uwSet = set()
  for samp in ['TES_rerunMVAMET', 'TES']:
      for channel in ['MMTT','MMMT','MMEM','MMET','EEMT','EEET','EEEM','EETT']:
          #print channel
          ifile = ROOT.TFile("results/2014-02-28_8TeV_Ntuples-v2/ZHAnalyze%s/A300-Zh-lltt-svFit-MadGraph-%s.root" % (channel, samp), "READ" )
          #ifile = ROOT.TFile("results/2014-02-28_8TeV_Ntuples-v2/ZHAnalyze%s/data.root" % (channel), "READ" )
          ntuple = ifile.Get("os/All_Passed/Event_ID")
          for row in ntuple:
               tup = (row.run,row.lumi,(row.evt1*10**5 + row.evt2),round(row.Z_Mass,0),row.t1Pt,row.t1Eta,row.t2Pt,row.t2Eta)
               uwSet.add( tup )
  return uwSet


def get_ULB( uwSet ):
  ofile = open("A300_select_samplesULB.txt", 'w')
  ifile = ROOT.TFile("Nov7_For_Tyler/ntuple_AZh300.root", "READ" )
  ntuple = ifile.Get("RLE_tree")
  for row in ntuple:
    ulbMatchTup = (row.Run, row.Lumi, row.Event, round(row.ZMass,0),row.l3Pt,row.l3Eta,row.l4Pt,row.l4Eta)
    ulbFullTup = (row.Run, row.Lumi, row.Event, round(row.ZMass,0),row.l3Pt,row.l3Eta,row.l4Pt,row.l4Eta,row.met,row.metPhi,row.pfmet,row.pfmetPhi)
    if ulbMatchTup in uwSet:
      ofile.write("%i %i %i %f %f %f %f %f %f %f %f %f\n" % (ulbFullTup))
  ofile.close()

def get_UW_noPhi( uwSet ):
  for samp in ['_rerunMVAMET', '']:
    ofile = open("A300_select_mva_noPhi%s.txt" % samp, 'w')
    ifile = ROOT.TFile("/nfs_scratch/truggles/2014-11-08_svFit_A300_Ntups/2014-11-08_svFit_A300%s/A300-Zh-lltt-MadGraph/make_ntuples_cfg-patTuple_cfg-36727742-EE0A-E411-B1E5-008CFA008CC8.root" % samp, "READ" )
    ntuple = ifile.Get("mmtt/final/Ntuple")
    for row in ntuple:
        matchTup = (row.run,row.lumi,row.evt,round(row.m1_m2_Mass,0),row.t1Pt,row.t1Eta,row.t2Pt,row.t2Eta)
        fullTup = (row.run,row.lumi,row.evt,round(row.m1_m2_Mass,0),row.t1Pt,row.t1Eta,row.t2Pt,row.t2Eta,row.mva_metEt_noPhiCor)
        if matchTup in uwSet:
          ofile.write("%i %i %i %f %f %f %f %f %f\n" % (fullTup))
    ofile.close()


#make_list_txt()
uwSet = make_UW_set() 
print "got set"
#get_ULB( uwSet )
get_UW_noPhi( uwSet )
















