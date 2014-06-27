import ROOT
#from ROOT import TPad
import os
from FinalStateAnalysis.MetaData.data_views import extract_sample, read_lumi
import math
import sys

jobid = "2014-02-28_8TeV_Ntuples-v2"

mass = sys.argv[1]

dict_prods = { 'MMMT' : ('m1','m2','m3','t'),
              'MMET' : ('m1','m2','e','t'),
              'MMEM' : ('m1','m2','e','m3'),
              'MMTT' : ('m1','m2','t1','t2'),
              'EEMT' : ('e1','e2','m','t'),
              'EEET' : ('e1','e2','e3','t'),
              'EEEM' : ('e1','e2','e3','m'),
              'EETT' : ('e1','e2','t1','t2')
}

def make_control_plot(prods, variable, xaxis_title, rbin, nbins, xlow, xhigh,blinded=False,strip=False):

  ofile = ROOT.TFile("plots.root", "RECREATE")
  signal = ROOT.TH1F("signal", "signal", nbins, xlow, xhigh)
  fullsim = ROOT.TH1F("fullsim", "fullsim", nbins, xlow, xhigh)
  madgraph = ROOT.TH1F("madgraph", "madgraph", nbins, xlow, xhigh)

  for channel in ["MMMT", "MMET", "MMEM", "MMTT", "EEMT", "EEET", "EEEM", "EETT"]:
    
    label = ""
    prods_avail = dict_prods[channel]
    #print prods_avail
    for prod in prods:
      label += "%s_" % prods_avail[prod-1] # zero indexed
    if strip:
      label = label[:-1]
    label += variable
    #print label

    if ("EE" in channel):
      signal_file = ROOT.TFile("results/%s/ZHAnalyze%s/A%s-Zh-eett-PU025.root"% (jobid,channel,mass), "READ")
    else:
      signal_file = ROOT.TFile("results/%s/ZHAnalyze%s/A%s-Zh-mmtt-PU025.root"% (jobid,channel,mass), "READ")

    fullsim_file = ROOT.TFile("results/%s/ZHAnalyze%s/A%s-Zh-lltt-FullSim.root" % (jobid, channel, mass), "READ")
    fullsim_tmp = fullsim_file.Get("os/All_Passed/%s" % label)
    fullsim.Add(fullsim_tmp)
 
    #madgraph_file = ROOT.TFile("results/%s/ZHAnalyze%s/A%s-AToZhToLLTauTau-MadGraph.root" % (jobid, channel, mass), "READ")
    #madgraph_tmp = madgraph_file.Get("os/All_Passed/%s" % label)
    #madgraph.Add(madgraph_tmp)

    signal_m = signal_file.Get("os/All_Passed/%s" % label)
    signal.Add(signal_m)

    fullsim_file.Close()
    #madgraph_file.Close()
    signal_file.Close()
  #ROOT.gROOT.SetBatch(True)

  ## Area normalize
  signal.Scale(1/signal.Integral())
  fullsim.Scale(1/fullsim.Integral())
  #madgraph.Scale(1/madgraph.Integral())

  canvas = ROOT.TCanvas("canvas", "canvas")
  pad1 = ROOT.TPad("pad1","",0,0.2,1,1)
  pad2 = ROOT.TPad("pad2","",0,0,1,0.2)

  pad1.Draw()
  pad2.Draw()


  ROOT.gStyle.SetOptStat(0)
  #signal.SetStats(0)
  #reducible_background.SetLineColor(ROOT.kBlue)
  #red_bkgrd.SetLineColor(ROOT.kOrange - 4)
  #zz.SetLineColor(ROOT.kRed + 2)
  #zz.SetFillColor(ROOT.kRed + 2)
  #zz.SetFillStyle(3003)
  signal.SetLineColor(ROOT.kBlue)
  signal.SetFillColor(ROOT.kBlue)
  signal.SetFillStyle(3003)
  fullsim.SetLineColor(ROOT.kRed +2)
  fullsim.SetFillColor(ROOT.kRed +2)
  fullsim.SetFillStyle(3003)
  madgraph.SetLineColor(ROOT.kGreen + 2)
  madgraph.SetFillColor(ROOT.kGreen +2)
  madgraph.SetFillStyle(3005)

  signal.SetLineWidth(3)
  fullsim.SetLineWidth(3)
  madgraph.SetLineWidth(3)
  #zz.SetLineWidth(3)
  #red_bkgrd.SetLineWidth(3)
  #red_bkgrd.SetLineWidth(3)

  # rebin histograms
  signal.Rebin(rbin)
  fullsim.Rebin(rbin)  
  madgraph.Rebin(rbin)

  fullsim.SetMaximum(fullsim.GetMaximum()*1.8)

  fullsim.GetXaxis().SetRangeUser(0, 800)
  fullsim.GetXaxis().SetTitle(xaxis_title)
  #hstack.GetYaxis().SetTitle("Events / %i GeV" % ( (xhigh - xlow)/nbins * rbin) )
    

  #zz.Fit("gaus")
  #zz.GetFunction("gaus").SetLineColor(ROOT.kRed + 2)
  #signal.Fit("gaus")
  #signal.GetFunction("gaus").SetLineColor(ROOT.kBlue)
  #wz.Fit("gaus")
  #wz.GetFunction("gaus").SetLineColor(ROOT.kGreen + 2)

  #signal.GetXaxis().SetRange(0, 50)
  #signal.SetTitle("ZH Visible Mass")
  #reducible_background.Draw("hist")
  #signal.Draw("hist")
  #zjets.Draw("hist same")
  #data.Draw("same")
  #reducible_background.Draw("hist same")
  #signal.Draw("hist")
  #signal.GetFunction("gaus").Draw("same")
  #red_bkgrd.Draw("hist same")
  #zz.Draw("hist same")
  #zz.GetFunction("gaus").Draw("same")
  #red_bkgrd.Draw("hist same")
  #hstack.Draw("hist")
  #if not blinded:
  #  data.Draw("same")
  
  pad1.cd()
  pad1.SetGridx()
  pad1.SetGridy()
  pad1.GetFrame().SetFillColor( 42 )
  pad1.GetFrame().SetBorderMode( -1 )
  pad1.GetFrame().SetBorderSize( 5 )

  fullsim.Draw("hist")
  signal.Draw("hist same")
  #madgraph.Draw("hist same")
  #zz.Draw("hist same")
  #red_bkgrd.Draw("hist same")
  #wz.GetFunction("gaus").Draw("same")
  #signal.Draw("hist same")
  #data.Draw("hist same")

  l1 = ROOT.TLegend(0.50,0.63,0.70,0.93,"")
  l1.AddEntry(signal, "A->Zh FastSim (mA=%s GeV)" % mass,"l")
  l1.AddEntry(fullsim, "A->Zh Pythia6 (mA=%s GeV)" % mass,"l")
  #l1.AddEntry(madgraph, "A->Zh MadGraph (mA=%s GeV)" % mass,"l")
  
  l1.SetBorderSize(0)
  l1.SetFillColor(0)
  l1.SetTextSize(0.03)
  l1.Draw()
  canvas.Update()
  
  pad2.cd();
  pad2.GetFrame().SetFillColor( 42 )
  pad2.GetFrame().SetBorderMode( -1 )
  pad2.GetFrame().SetBorderSize( 5 )

  HDiff = fullsim.Clone("HDiff")
  HDiff.Divide(signal)
  HDiff.GetYaxis().SetRangeUser(0.9,1.1)
  HDiff.GetYaxis().SetRangeUser(0.98,1.02)
  HDiff.GetYaxis().SetRangeUser(0.,2.0)
  HDiff.GetYaxis().SetNdivisions(3)
  HDiff.GetYaxis().SetLabelSize(0.1)
  HDiff.GetYaxis().SetTitleSize(0.1)
  HDiff.GetYaxis().SetTitleOffset(0.5)
  HDiff.GetYaxis().SetTitle("Pythia6 / FastSim")
  HDiff.GetXaxis().SetNdivisions(-1)
  HDiff.GetXaxis().SetTitle("")
  HDiff.GetXaxis().SetLabelSize(0.0001)
  #HDiff.SetMarkerColor(2)
  HDiff.Draw("histep")
  #HDiff.Draw()
  line = ROOT.TLine()
  line.DrawLine(HDiff.GetXaxis().GetXmin(),1,HDiff.GetXaxis().GetXmax(),1)
  #os.system("sleep 100")

  prod_label = ""
  for p in prods:
    prod_label += str(p)
  #canvas.SetTitle("Reconstructed Z Mass")
  ofile.cd()
  canvas.Write()
  canvas.SaveAs("mc_shape_comparisons/%s/%s%s.png" % (mass, prod_label, variable) )
  pad1.Close()
  pad2.Close()
  canvas.Close()
  ofile.Close()

#make_control_plot(prods, variable, xaxis_title, rbin, nbins, xlow, xhigh, blinded=False, stripped=False)

# ZH system plots
make_control_plot((), 'Mass', "A Visible Mass", 10, 800, 0, 800,True)
make_control_plot((), 'A_SVfitMass', "A SV-fit Mass", 10, 800, 0, 800,True)

# di-tau plots
make_control_plot((3,4), 'Mass', "#tau#tau Visible Mass", 10, 200, 0, 200,True)
make_control_plot((3,4), 'SVfitMass', "#tau#tau SV-fit Mass", 10, 300, 0, 300)
make_control_plot((3,4), 'Eta', "#tau#tau #eta", 10, 100, -2.4, 2.4)
make_control_plot((3,4), 'DR', "#tau#tau #deltaR", 10, 100, 0, 10)
make_control_plot((3,4), 'DPhi', "#tau#tau #delta#phi", 10, 180, 0, 7)
make_control_plot((3,4), 'Pt', "#tau#tau p_{T}", 10, 100, 0, 100)

# Z plots
make_control_plot((1,2), 'Pt', 'Z p_{T}', 10, 100, 0, 100)
make_control_plot((1,2), 'Mass', 'Z Mass', 10, 200, 0, 200)
make_control_plot((1,2), 'DR', "Z products #deltaR", 10, 100, 0, 10)
make_control_plot((1,2), 'DPhi', "Z products #delta#phi", 10, 180, 0, 7) 

# tau 1, tau 2 plots
make_control_plot((3,), 'AbsEta', '#tau_{1} Abs(#eta)', 10, 100, 0, 2.4,False,True)
make_control_plot((4,), 'AbsEta', '#tau_{2} Abs(#eta)', 10, 100, 0, 2.4,False,True)
make_control_plot((3,), 'Pt', '#tau_{1} p_{T}', 10, 100, 0, 100,False,True)
make_control_plot((4,), 'Pt', '#tau_{2} p_{T}', 10, 100, 0, 100,False,True)
