import ROOT
import os

cecile_channel_cut = "subChannel_==3" # passed events

cecile_file = ROOT.TFile("For_Stephane/AZh300_8TeV.root")
wisco_file = ROOT.TFile("results/2014-02-28_8TeV_Ntuples-v2/ZHAnalyzeCOMB/A300-Zh-lltt-FullSim.root")

for wname, cname, rbin in [('A_SVfitMass','SVMass_', 40)]:

  cecile_ntuple = cecile_file.Get("BG_Tree")
  w_hist = wisco_file.Get("os/All_Passed/%s" % wname)

  w_hist.Rebin(rbin)
  w_hist.GetXaxis().SetTitle(wname)
  w_hist.SetMaximum(1.8*w_hist.GetMaximum())

  canv = ROOT.TCanvas()
  w_hist.Draw("P")
  cecile_ntuple.Draw(cname, cecile_channel_cut, "same")
  
  canv.SaveAs("sync_shapes/%s.png" % wname)
  os.system("sleep 3")
  canv.Close()

cecile_file.Close()
wisco_file.Close()
