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
              'MMEM' : ('m1','m2','e','m3'),
              'MMTT' : ('m1','m2','t1','t2'),
              'EEMT' : ('e1','e2','m','t'),
              'EEET' : ('e1','e2','e3','t'),
              'EEEM' : ('e1','e2','e3','m'),
              'EETT' : ('e1','e2','t1','t2')
}

mass = 300 # fullsim mA 

ofile = open("stephane_fullsim%i.txt" % mass, 'w')
#amasses = open("amasses.txt", 'w')

for channel in ['MMTT','MMMT','MMEM','MMET','EEMT','EEET','EEEM','EETT']:
    #print channel
    ifile = ROOT.TFile("results/2014-02-28_8TeV_Ntuples-v2/ZHAnalyze%s/A%i-Zh-lltt-FullSim.root" % (channel, mass), "READ" )
    #ifile = ROOT.TFile("results/2014-02-28_8TeV_Ntuples-v2/ZHAnalyze%s/data.root" % (channel), "READ" )
    ntuple = ifile.Get("os/All_Passed/Event_ID")
    for row in ntuple:
      #if channel == 'EETT':
      #ofile.write("%i %i %i %i %f %f %f %f %f\n" % (channel_map[channel],row.run,row.lumi,(row.evt1*10**5 + row.evt2),row.t1Pt,row.t1Eta,row.t2Pt,row.t2Eta, round(row.zmass,2) ))
      ofile.write("%i %i %i %i %f %f\n" % (channel_map[channel], row.run,row.lumi,(row.evt1*10**5 + row.evt2),row.t1JetPt,row.t2JetPt ))
      #ofile.write("%i:%i:%i\n" % (row.run,row.lumi,(row.evt1*10**5 + row.evt2) ))
      #if channel == 'EETT':
      #  amasses.write("%i:%i:%i:%f\n" % (row.run,row.lumi,(row.evt1*10**5 + row.evt2), row.hmass ))
      #ofile.write("%i %i %i %i%i\n" % (channel_map[channel],row.run,row.lumi,row.evt1,row.evt2 ))
