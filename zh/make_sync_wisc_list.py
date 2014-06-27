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

mass = 300 # fullsim mA 

#ofile = open("stephane_fullsim%i.txt" % mass, 'w')
#
#for channel in channel_map:
#    ifile = ROOT.TFile("results/2014-02-28_8TeV_Ntuples-v2/ZHAnalyze%s/A%i-Zh-lltt-FullSim.root" % (channel, mass), "READ" )
#    ntuple = ifile.Get("os/All_Passed/Event_ID")
#    for row in ntuple:
#      #ofile.write("%i %i %i %i\n" % (channel_map[channel],row.run,row.lumi,(row.evt1*10**5 + row.evt2) )) # old
#      #ofile.write("%i %i %i %i%i\n" % (channel_map[channel],row.run,row.lumi,row.evt1,row.evt2 ))
#      ofile.write("%i %i %i %i\n" % (channel_map[channel],row.run,row.lumi,(row.evt1*10**5 + row.evt2) )) # new June 10
ofile = open("stephane_fullsim%i.txt" % mass, 'w')
channel = 1 # FIXME only running over 1 channel now

ifile = ROOT.TFile("results/2014-02-28_8TeV_Ntuples-v2/ZHAnalyzeMMTT/A%i-Zh-lltt-FullSim.root" % (mass), "READ" )
ntuple = ifile.Get("os/All_Passed/Event_ID")
for row in ntuple:
  ofile.write("%i %i %i %i %f %f %f %f\n" % (1,row.run,row.lumi,(row.evt1*10**5 + row.evt2),row.t1Pt,row.t1Eta,row.t2Pt,row.t2Eta )) # new June 10

