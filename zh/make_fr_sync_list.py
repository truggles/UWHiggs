import ROOT

dict_prods = { 'MMMT' : ('m1','m2','m3','t'),
              'MMET' : ('m1','m2','e','t'),
              'MMEM' : ('m1','m2','m3','e'),
              'MMTT' : ('m1','m2','t1','t2'),
              'EEMT' : ('e1','e2','m','t'),
              'EEET' : ('e1','e2','e3','t'),
              'EEEM' : ('e1','e2','e3','m'),
              'EETT' : ('e1','e2','t1','t2')}

Z_samples = { 'MM' : ('data_DoubleMuParked_Run2012B_22Jan2013_v1.root',
                      'data_DoubleMuParked_Run2012C_22Jan2013_v1.root',
                      'data_DoubleMuParked_Run2012D_22Jan2013_v1.root',
                      'data_DoubleMu_Run2012A_22Jan2013_v1.root'),
              'EE' : ('data_DoubleElectron_Run2012A_22Jan2013_v1.root',
                      'data_DoubleElectron_Run2012B_22Jan2013_v1.root',
                      'data_DoubleElectron_Run2012C_22Jan2013_v1.root',
                      'data_DoubleElectron_Run2012D_22Jan2013_v1.root')}

Higgs = { 0 : 'TT',
          1 : 'MT',
          2 : 'ET',
          3 : 'EM', }

print Z_samples['MM'][0]
print Z_samples['MM'][1]
print Z_samples['MM'][2]
print Z_samples['MM'][3]

ofile = open("fr_sync_UW.txt", 'w')

for Z_sample in ['MM']:#, 'EE']:
  for i in [0]:#, 1, 2, 3]:
    channel = '%s%s' % (Z_sample, Higgs[i])
    print channel
    #for j in [0, 1, 2, 3]:
    ifile1 = ROOT.TFile("results/2014-02-28_8TeV_Ntuples-v2/ZHAnalyze%s/%s" % (channel, Z_samples[Z_sample][0]), "READ") 
    ifile2 = ROOT.TFile("results/2014-02-28_8TeV_Ntuples-v2/ZHAnalyze%s/%s" % (channel, Z_samples[Z_sample][1]), "READ") 
    ifile3 = ROOT.TFile("results/2014-02-28_8TeV_Ntuples-v2/ZHAnalyze%s/%s" % (channel, Z_samples[Z_sample][2]), "READ") 
    ifile4 = ROOT.TFile("results/2014-02-28_8TeV_Ntuples-v2/ZHAnalyze%s/%s" % (channel, Z_samples[Z_sample][3]), "READ")

    ntuple1_l3l4 = ifile1.Get("ss/Leg3Failed_Leg4Failed/Event_ID")
    ntuple2_l3l4 = ifile2.Get("ss/Leg3Failed_Leg4Failed/Event_ID")
    ntuple3_l3l4 = ifile3.Get("ss/Leg3Failed_Leg4Failed/Event_ID")
    ntuple4_l3l4 = ifile4.Get("ss/Leg3Failed_Leg4Failed/Event_ID")

    for row in ntuple1_l3l4:
      ofile.write("%s %i %i %i %f %f %f %f %f\n" % (channel,row.run,row.lumi,(row.evt1*10**5 + row.evt2),round(row.Z_Mass,0),row.t1Pt,row.t1Eta,row.t2Pt,row.t2Eta ))
    for row in ntuple2_l3l4:
      ofile.write("%s %i %i %i %f %f %f %f %f\n" % (channel,row.run,row.lumi,(row.evt1*10**5 + row.evt2),round(row.Z_Mass,0),row.t1Pt,row.t1Eta,row.t2Pt,row.t2Eta ))
    for row in ntuple3_l3l4:
      ofile.write("%s %i %i %i %f %f %f %f %f\n" % (channel,row.run,row.lumi,(row.evt1*10**5 + row.evt2),round(row.Z_Mass,0),row.t1Pt,row.t1Eta,row.t2Pt,row.t2Eta ))
    for row in ntuple4_l3l4:
      ofile.write("%s %i %i %i %f %f %f %f %f\n" % (channel,row.run,row.lumi,(row.evt1*10**5 + row.evt2),round(row.Z_Mass,0),row.t1Pt,row.t1Eta,row.t2Pt,row.t2Eta ))
#
#for channel in ['MMTT']: #,'MMMT','MMEM','MMET','EEMT','EEET','EEEM','EETT']:
#    Z_sample = 'MM'
#    for higgs in [1,5,1]:
#        print "Hello %i" % higgs
#         #print Z_samples['%s' % Z_samples][higgs]
#
#        ifile = ROOT.TFile("results/2014-02-28_8TeV_Ntuples-v2/ZHAnalyze%s/A%i-Zh-lltt-FullSim.root" % (channel, mass), "READ" )
#        #ifile = ROOT.TFile("results/2014-02-28_8TeV_Ntuples-v2/ZHAnalyze%s/data.root" % (channel), "READ" )
#        ntuple = ifile.Get("os/All_Passed/Event_ID")
#        for row in ntuple:
#           #if channel == 'EETT':
#    
#           # Only consider Pt > 20 Taus: this is now a relice because Tau filter is in the Ntuple stage
#           #if (channel == 'MMTT' and (row.t1Pt < 20 or row.t2Pt < 20)): continue
#           #elif (channel == 'EETT' and (row.t1Pt < 20 or row.t2Pt < 20)): continue
#           #elif (channel == 'MMMT' and row.t2Pt < 20): continue
#           #elif (channel == 'MMET' and row.t2Pt < 20): continue
#           #elif (channel == 'EEMT' and row.t2Pt < 20): continue
#           #elif (channel == 'EEET' and row.t2Pt < 20): continue
#           #else:
#             ofile.write("%i %i %i %i %f %f %f %f %f\n" % (channel_map[channel],row.run,row.lumi,(row.evt1*10**5 + row.evt2),round(row.Z_Mass,0),row.t1Pt,row.t1Eta,row.t2Pt,row.t2Eta )) #pick_FSA friendly
#          #ofile.write("%i %i %i %i %f %f\n" % (channel_map[channel], row.run,row.lumi,(row.evt1*10**5 + row.evt2),row.t1JetPt,row.t2JetPt ))
#          #ofile.write("%i:%i:%i\n" % (row.run,row.lumi,(row.evt1*10**5 + row.evt2) ))
#          #if channel == 'EETT':
#          #  amasses.write("%i:%i:%i:%f\n" % (row.run,row.lumi,(row.evt1*10**5 + row.evt2), row.hmass ))
#          #ofile.write("%i %i %i %i%i\n" % (channel_map[channel],row.run,row.lumi,row.evt1,row.evt2 )):
