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
ofile = open("ceciles_fullsim%i.txt" % mass, 'w')
channel = 1 # FIXME only running over 1 channel now

ifile = ROOT.TFile("For_Stephane/AZh300_8TeV.root", "READ" )
#ifile = ROOT.TFile("my_extra_events.root", "READ")
ntuple = ifile.Get("BG_Tree")

for row in ntuple:
  if ((row.subChannel_ == 3)):
    #ofile.write("%i %i %i %i %f %f %f %f %f\n" % (row.Channel_,row.Run_,row.Lumi_,row.Event_,row.l3Pt_,row.l3Eta_,row.l4Pt_,row.l4Eta_, round(row.HMass_, 2) )) # new June 10
    ofile.write("%i %i %i %i %f %f \n" % (row.Channel_,row.Run_,row.Lumi_,row.Event_, row.l3_CloseJetPt_, row.l4_CloseJetPt_))
