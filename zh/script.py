import ROOT
import os

our_file = ROOT.TFile("common_events.root")
her_file = ROOT.TFile("For_Stephane/AZh300_8TeV.root")

t1 = our_file.Get("Event_ID")
t2 = her_file.Get("BG_Tree")

c1 = ROOT.TCanvas()
#t1.Draw("t1Pt")
#t2.Draw("l3Pt_", "subChannel_==3&&Channel_==1", "same")

#os.system("sleep 5")
#c1.Clear()

t1.Draw("t2Pt>>h1")
t2.Draw("l4Pt_>>h2", "subChannel_==3&&Channel_==1", "same")
h1 = ROOT.gDirectory.Get("h1").Rebin(10)
h2 = ROOT.gDirectory.Get("h2").Rebin(10)

h1.Scale(1./h1.Integral())
h2.Scale(1./h2.Integral())

h1.SetMaximum(h1.GetMaximum()*1.7)


h1.Draw()
h2.Draw("hist same")

os.system("sleep 10000")
