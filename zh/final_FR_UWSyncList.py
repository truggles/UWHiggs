import ROOT

region_map = ['TauFakeRatesZLT']#, 'EFakeRateZET', 'MUFakeRateZMT', 'TauFakeRatesZLT', 'TauFakeRatesZTT']

sample_run = ['data_DoubleElectron_Run2012A_22Jan2013_v1.root',
              'data_DoubleElectron_Run2012B_22Jan2013_v1.root',
              'data_DoubleElectron_Run2012C_22Jan2013_v1.root',
              'data_DoubleElectron_Run2012D_22Jan2013_v1.root',
              'data_DoubleMu_Run2012A_22Jan2013_v1.root',
              'data_DoubleMuParked_Run2012B_22Jan2013_v1.root',
              'data_DoubleMuParked_Run2012C_22Jan2013_v1.root',
              'data_DoubleMuParked_Run2012D_22Jan2013_v1.root']

code_map = {0  : 'Tau_barrel_denom',
            1  : 'Tau_LooseIso3Hits_barrel',
            2  : 'Tau_LooseIso3Hits_endcap',
            10 : 'Tau_endcap_denom',
            11 : 'Tau_MediumIso3Hits_barrel',
            12 : 'Tau_MediumIso3Hits_endcap',
            20 : 'Lep_denom',
            21 : 'Lep_LooseID',
            22 : 'Lep_TightID',}

tauCode = {0  : 't',
           1  : 't1',
           2  : 't2',
           10 : 'e',
           11 : 'e3',
           20 : 'm',
           21 : 'm3',}

for region in region_map:
  ofile = open("%s.txt" % region, 'w')
  ofile1 = open("%s_LT_Barrel.txt" % region, 'w')
  ofile2 = open("%s_LT_BarrelMoreData.txt" % region, 'w')
  print region
  for sample in sample_run:
    #print sample
    #ofile.write(sample + "\n")
    # this will iterate over all of our data fake rate info
    ifile = ROOT.TFile("results/2014-02-28_8TeV_Ntuples-v2/%s/%s" % (region, sample), "READ")
    ntuple = ifile.Get("Event_ID")
    for row in ntuple:
        ofile.write("%i %i %i %i %i %f %f %f %f %f %f\n" % (row.NumDenomCode, row.tauCode, row.run,row.lumi,(row.evt1*10**5 + row.evt2),round(row.Zmass,0),row.t1Pt,row.t1Eta,row.t1MtToMET,row.t2Pt,row.t2Eta )) #pick_FSA friendly
        if row.NumDenomCode == 0:
            ofile1.write("%i:%i:%i\n" % (row.run,row.lumi,(row.evt1*10**5 + row.evt2) )) #pick_FSA friendly
            ofile2.write("%i:%i:%i:%f:%f:%f:%f\n" % (row.run,row.lumi,(row.evt1*10**5 + row.evt2),row.t1Pt,row.t1Eta,row.t2Pt,row.t2Eta ) ) #pick_FSA friendly
  ofile.close()
  ofile1.close()
  ofile2.close()
  print "File Ready: %s.txt" % region
  print "File Ready: %s_E_Loose.txt" % region
  print "File Ready: %s_E_LooseMoreData.txt" % region
