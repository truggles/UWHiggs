#!/usr/bin/env python
import ROOT

map = {'EE' : ('EM', 'ET', 'MT', 'TT', 'data_DoubleElectron_Run2012A_22Jan2013_v1.root',
               'data_DoubleElectron_Run2012B_22Jan2013_v1.root',
               'data_DoubleElectron_Run2012C_22Jan2013_v1.root',
               'data_DoubleElectron_Run2012D_22Jan2013_v1.root',),
       'MM' : ('EM', 'ET', 'MT', 'TT', 'data_DoubleMu_Run2012A_22Jan2013_v1.root',
               'data_DoubleMuParked_Run2012B_22Jan2013_v1.root',
               'data_DoubleMuParked_Run2012C_22Jan2013_v1.root',
               'data_DoubleMuParked_Run2012D_22Jan2013_v1.root')}

products_map = {'mmtt' : ('m1', 'm2', 't1', 't2'), 
                'eett' : ('e1', 'e2', 't1', 't2'),
                'mmmt' : ('m1', 'm2', 'm3', 't'),
                'eemt' : ('e1', 'e2', 'm', 't'),
                'mmet' : ('m1', 'm2', 'e', 't'),
                'eeet' : ('e1', 'e2', 'e3', 't'),
                'mmem' : ('m1', 'm2', 'e', 'm3'),
                'eeem' : ('e1', 'e2', 'e3', 'm')}

writeCount = 0
ofile = open("uw_data_events.txt", 'w')
#ofile.write("channel:run:lumi:evtID:t1Pt:t1Eta:t2Pt:t2Eta:z_Pt:z_Eta:z_Phi:z_Mass:h_Pt:h_Eta:h_Phi:h_mass:h_svFitPt:h_svFitEta:h_svFitPhi:h_svFitMass:pfMetEt:pfMetPhi:mva_metEt:mva_metPhi:A_VisMass:A_SVFitMass\n")
ofile.write("channel : run : lumi : evtID : pfMetEt : mva_metEt : A_SVFitMass : h_Mass : h_SVFitMAss\n")

for key in map.keys():
  #print "Key = %s" % key
  for i in range(0, 4):
    channel = key + map[key][i]
    #print channel
    for j in range(4, 8):
      ifileName = "results/2014-02-28_8TeV_Ntuples-v2/ZHAnalyze%s/%s" % (channel, map[key][j])
      ifile = ROOT.TFile(ifileName, "READ")
      #print ifileName
      ntuple = ifile.Get("os/All_Passed/Event_ID")
      for row in ntuple:
        #if row.mva_metEt > 120:
        #if row.A_SVFitMass > 400 and (channel == 'MMEM' or channel == 'EEEM'):
          #ofile.write("%s:%i:%i:%i:%f:%f:%f:%f:%f:%f:%f:%f:%f:%f:%f:%f:%f:%f:%f:%f:%f:%f:%f:%f:%f:%f\n" % (channel,row.run,row.lumi,(row.evt1*10**5 + row.evt2),row.t1Pt,row.t1Eta,row.t2Pt,row.t2Eta,row.Z_Pt,row.Z_Eta,row.Z_Phi,row.Z_Mass,row.h_Pt,row.h_Eta,row.h_Phi,row.h_Mass,row.h_SVFitPt,row.h_SVFitEta,row.h_SVFitPhi,row.h_SVFitMass,row.pfMetEt,row.pfMetPhi,row.mva_metEt,row.mva_metPhi,row.A_VisMass,row.A_SVFitMass )) #pick_FSA friendly
          ofile.write("%6s %8i %8i %12i %8.1f %8.1f %8.1f %8.1f %8.1f\n" % (channel,row.run,row.lumi,(row.evt1*10**5 + row.evt2),row.pfMetEt,row.mva_metEt, row.A_SVFitMass, row.h_Mass, row.h_SVFitMass)) #pick_FSA friendly
          writeCount = writeCount + 1
ofile.close()
print "Total data evts: %i" % writeCount
#
#
#
