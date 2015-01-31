import ROOT

#ofile = open("stephane_fullsim%i.txt" % mass, 'w')

samples = ['rerunMVAMET0_uw.root', 'rerunMVAMET0_uw.root']
channels = ['eeem','eeet','eemt','eett','emmm','emmt','mmmt','mmtt']

for sample in samples:
  print sample
  ifile = ROOT.TFile("/cms/truggles/zh_proj/june23_sync_setup/src/FinalStateAnalysis/NtupleTools/test/%s" % sample, "READ" )
  mvaMet = []
  evtSet = []
  for channel in channels:
    print channel
    ntuple = ifile.Get("%s/final/Ntuple" % channel)
    for row in ntuple:
      evtTup = [ row.run, row.lumi, row.evt ]
      #if evtTup not in evtSet:
      #  evtSet.append( evtTup )
      #else: continue
      print "Run: %i Lumi %i EvtID: %i MVAMET: %f pfMET: %f" % (row.run, row.lumi, row.evt, row.mva_metEt, row.pfMetEt)
      mvaMet.append( row.mva_metEt )
  avg = 0
  for i in mvaMet:
    avg += i
  print (avg / len(mvaMet) )
   #if channel == 'EETT':

     #ofile.write("%i %i %i %i %f %f %f %f %f\n" % (channel_map[channel],row.run,row.lumi,(row.evt1*10**5 + row.evt2),round(row.Z_Mass,0),row.t1Pt,row.t1Eta,row.t2Pt,row.t2    Eta )) #pick_FSA friendly
  #ofile.write("%i %i %i %i %f %f\n" % (channel_map[channel], row.run,row.lumi,(row.evt1*10**5 + row.evt2),row.t1JetPt,row.t2JetPt ))
  #ofile.write("%i:%i:%i\n" % (row.run,row.lumi,(row.evt1*10**5 + row.evt2) ))
  #if channel == 'EETT':
  #  amasses.write("%i:%i:%i:%f\n" % (row.run,row.lumi,(row.evt1*10**5 + row.evt2), row.hmass ))
  #ofile.write("%i %i %i %i%i\n" % (channel_map[channel],row.run,row.lumi,row.evt1,row.evt2 )):
