import ROOT

writeCount = 0
#ofile.write("channel:run:lumi:evtID:t1Pt:t1Eta:t2Pt:t2Eta:z_Pt:z_Eta:z_Phi:z_Mass:h_Pt:h_Eta:h_Phi:h_mass:h_svFitPt:h_svFitEta:h_svFitPhi:h_svFitMass:pfMetEt:pfMetPhi:mva_metEt:mva_metPhi:A_VisMass:A_SVFitMass\n")

products_map = {'mmtt' : ('m1', 'm2', 't1', 't2'), 
                'eett' : ('e1', 'e2', 't1', 't2'),
                'mmmt' : ('m1', 'm2', 'm3', 't'),
                'eemt' : ('e1', 'e2', 'm', 't'),
                'emmt' : ('m1', 'm2', 'e', 't'),
                'eeet' : ('e1', 'e2', 'e3', 't'),
                'emmm' : ('m1', 'm2', 'e', 'm3'),
                'eeem' : ('e1', 'e2', 'e3', 'm')}

uwFiles = ['51_dec3_1', '51_dec3_0']
channels = ['eeem','eeet','eemt','eett','emmm','emmt','mmmt','mmtt']

for file in uwFiles:
  ifile = ROOT.TFile("%s.root" % file, "READ")
  ofile = open("%s.txt" % file, 'w')
  evtSet = set()
  for channel in channels:
    ntuple = ifile.Get("%s/final/Ntuple" % channel)
    for row in ntuple:
        #if row.mva_metEt > 120:
        tuple = (row.run,row.lumi,row.evt,row.pfMetEt,row.pfMetPhi,row.mva_metEt,row.mva_metPhi)
        if tuple not in evtSet:
          evtSet.add(tuple)
          ofile.write("%i:%i:%i:%f:%f:%f:%f\n" % (row.run,row.lumi,row.evt,row.pfMetEt,row.pfMetPhi,row.mva_metEt,row.mva_metPhi )) #pick_FSA friendly
          writeCount = writeCount + 1
  ofile.close()
  print "Total data evts: %i %s" % (writeCount, file)
#
#
#
#for region in region_map:
#  ofile = open("%s.txt" % region, 'w')
#  ofile1 = open("%s_LT_Barrel.txt" % region, 'w')
#  ofile2 = open("%s_LT_BarrelMoreData.txt" % region, 'w')
#  print region
#  for sample in sample_run:
#    #print sample
#    #ofile.write(sample + "\n")
#    # this will iterate over all of our data fake rate info
#    ifile = ROOT.TFile("results/2014-02-28_8TeV_Ntuples-v2/%s/%s" % (region, sample), "READ")
#    ntuple = ifile.Get("Event_ID")
#    for row in ntuple:
#        ofile.write("%i %i %i %i %i %f %f %f %f %f %f\n" % (row.NumDenomCode, row.tauCode, row.run,row.lumi,(row.evt1*10**5 + row.evt2),round(row.Zmass,0),row.t1Pt,row.t1Eta,row.t1MtToMET,row.t2Pt,row.t2Eta )) #pick_FSA friendly
#        if row.NumDenomCode == 0:
#            ofile1.write("%i:%i:%i\n" % (row.run,row.lumi,(row.evt1*10**5 + row.evt2) )) #pick_FSA friendly
#            ofile2.write("%i:%i:%i:%f:%f:%f:%f\n" % (row.run,row.lumi,(row.evt1*10**5 + row.evt2),row.t1Pt,row.t1Eta,row.t2Pt,row.t2Eta ) ) #pick_FSA friendly
#  ofile.close()
#  ofile1.close()
#  ofile2.close()
#  print "File Ready: %s.txt" % region
#  print "File Ready: %s_E_Loose.txt" % region
#  print "File Ready: %s_E_LooseMoreData.txt" % region
