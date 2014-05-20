import ROOT
import os
from FinalStateAnalysis.MetaData.data_views import extract_sample, read_lumi
import math
import sys

jobid = "2014-02-28_Ntuples-v2"

def get_lumi(filename):
    sample_name = extract_sample(filename)
    lumi = read_lumi(
        os.path.join(
            'inputs',
            jobid,
            sample_name+".lumicalc.sum"
        )
    )
    return lumi

#mass = sys.argv[1]
mass = 300
print mass


channels = ["MMMT", "MMET", "MMEM", "MMTT", "EEMT", "EEET", "EEEM", "EETT"]
if (len(sys.argv) == 2):
  channels = [sys.argv[1]]
#jobid = "2013-10-02-8TeV-v2-MSSM_A_ZH_mmtt"

#ofile = ROOT.TFile("plots.root", "RECREATE")

# scale to 19.5 fb^-1
data_lumi = 39425.0/2
zz_lumi = get_lumi("ZZJetsTo4L_pythia.root")
signal_lumi = get_lumi("A%s-Zh-mmtt-PU025" % mass)
signal_lumi += get_lumi("A%s-Zh-eett-PU025" % mass)
fullsim_lumi = get_lumi("A300-Zh-lltt-FullSim")
vh_lumi = get_lumi("VH_H2Tau_M-125")
#wz_lumi = get_lumi("WZJetsTo3LNu_pythia.root")

#nbins = 200
#xlow = 0
#xhigh = 1600

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
  data = ROOT.TH1F("data", "data", nbins, xlow, xhigh)
  zz = ROOT.TH1F("zz", "zz", nbins, xlow, xhigh)
  signal = ROOT.TH1F("signal", "signal", nbins, xlow, xhigh)
  #wz = ROOT.TH1F("wz", "wz", nbins, xlow, xhigh)
  fullsim = ROOT.TH1F("fullsim", "fullsim", nbins, xlow, xhigh)
  vh = ROOT.TH1F("vh", "vh", nbins, xlow, xhigh)

  # reducible background components
  data_1 = ROOT.TH1F("data_1", "data_1", nbins, xlow, xhigh)
  data_2 = ROOT.TH1F("data_2", "data_2", nbins, xlow, xhigh)
  data_0 = ROOT.TH1F("data_0", "data_0", nbins, xlow, xhigh)

## A SV-fit Mass
#for channel, label in [("MMMT", "A_SVfitMass"),
#       ("MMET", "A_SVfitMass"),("MMEM", "A_SVfitMass"),
#        ("EEET", "A_SVfitMass"), ("EEMT", "A_SVfitMass"),
#        ("EEEM", "A_SVfitMass"), ("MMTT", "A_SVfitMass"),("EETT","A_SVfitMass")]:

## A Visible Mass
#for channel, label in [("MMMT", "Mass"),
#       ("MMET", "Mass"),("MMEM", "Mass"),
#        ("EEET", "Mass"), ("EEMT", "Mass"),
#        ("EEEM", "Mass"), ("MMTT", "Mass"),("EETT","Mass")]:

## H candidate visible mass
#for channel, label in [("MMTT", "t1_t2_Mass"), ("MMMT", "m3_t_Mass"),
#        ("MMET", "e_t_Mass"),("MMEM", "e_m3_Mass")]:

## H candidate svmass
#for channel, label in [("MMMT", "m3_t_SVfitMass"),
#	("MMET", "e_t_SVfitMass"),("MMEM", "e_m3_SVfitMass"),
#        ("EEET", "e3_t_SVfitMass"), ("EEMT", "m_t_SVfitMass"),
#        ("EEEM", "e3_m_SVfitMass"), ("MMTT", "t1_t2_SVfitMass"),("EETT","t1_t2_SVfitMass")]:

#for channel, label in [("MMMT", "m3_t_Mass"),
#       ("MMET", "e_t_Mass"),("MMEM", "e_m3_Mass"),
#        ("EEET", "e3_t_Mass"), ("EEMT", "m_t_Mass"),
#        ("EEEM", "e3_m_Mass"), ("MMTT", "t1_t2_Mass"), ("EETT", "t1_t2_Mass")]:

#for channel, label in [("MMTT", "t1_t2_SVfitMass")]:

## Z mass
#for channel, label in [("MMTT", "m1_m2_Mass")]:

## ZH system mass (A candidate)
#for channel, label in [("MMTT", "A_SVfitMass")]:
  for channel in channels:
    
    label = ""
    prods_avail = dict_prods[channel]
    #print prods_avail
    for prod in prods:
      label += "%s_" % prods_avail[prod-1] # zero indexed
    if strip:
      label = label[:-1]
    label += variable
    #print label

    data_file = ROOT.TFile("results/%s/ZHAnalyze%s/data.root" % (jobid,channel), "READ")
    zz_file = ROOT.TFile("results/%s/ZHAnalyze%s/ZZJetsTo4L_pythia.root"% (jobid,channel), "READ")
    if ("EE" in channel):
      signal_file = ROOT.TFile("results/%s/ZHAnalyze%s/A%s-Zh-eett-PU025.root"% (jobid,channel,mass), "READ")
    else:
      signal_file = ROOT.TFile("results/%s/ZHAnalyze%s/A%s-Zh-mmtt-PU025.root"% (jobid,channel,mass), "READ")
    #wz_file = ROOT.TFile("results/%s/ZHAnalyze%s/WZJetsTo3LNu_pythia.root" % (jobid,channel), "READ")

    fullsim_file = ROOT.TFile("results/%s/ZHAnalyze%s/A300-Zh-lltt-FullSim.root" % (jobid, channel), "READ")
    fullsim_tmp = fullsim_file.Get("os/All_Passed/%s" % label)
    fullsim.Add(fullsim_tmp)

    vh_file = ROOT.TFile("results/%s/ZHAnalyze%s/VH_H2Tau_M-125.root" % (jobid, channel), "READ")
    vh_tmp = vh_file.Get("os/All_Passed/%s" % label)
    vh.Add(vh_tmp)
 
    data_tmp = data_file.Get("os/All_Passed/%s" % label)
    data.Add(data_tmp)

    zz_tmp = zz_file.Get("os/All_Passed/%s" % label)
    zz.Add(zz_tmp)
  
    data_1_tmp = data_file.Get("ss/Leg3Failed/leg3_weight/%s" % label)
    data_1.Add(data_1_tmp)

    data_2_tmp = data_file.Get("ss/Leg4Failed/leg4_weight/%s" % label)
    data_2.Add(data_2_tmp)

    data_0_tmp = data_file.Get("ss/Leg3Failed_Leg4Failed/all_weights_applied/%s" % label)
    data_0.Add(data_0_tmp)

    signal_m = signal_file.Get("os/All_Passed/%s" % label)
    signal.Add(signal_m)

    #wz_m = wz_file.Get("os/All_Passed/%s" % label)
    #wz.Add(wz_m)

    data_file.Close()
    zz_file.Close()
    signal_file.Close()
    #wz_file.Close()

  ROOT.gROOT.SetBatch(True)
  red_bkgrd = ROOT.TH1F(data_1)
  red_bkgrd.Add(data_2)
  red_bkgrd.Add(data_0, -1)

  ## Scale to data lumi
  zz.Scale(data_lumi/zz_lumi)
  signal.Scale(data_lumi/signal_lumi)
  fullsim.Scale(data_lumi/fullsim_lumi)
  vh.Scale(data_lumi/vh_lumi)

  # Add uncertainty on the reducible background of 30%
  uncert = red_bkgrd.Clone()
  uncert.Scale(0.3)

  ## Area normalize
  #zz.Scale(1/zz.Integral())
  #signal.Scale(1/signal.Integral())
  #red_bkgrd.Scale(1/red_bkgrd.Integral())
  #fullsim.Scale(1/fullsim.Integral())
  #vh.Scale(1/vh.Integral())

  #ofile = ROOT.TFile("plots.root", "RECREATE")
  canvas = ROOT.TCanvas("canvas", "canvas")
  #reducible_background = ROOT.TH1F(wz)
  #reducible_background.Add(zjets)

  ROOT.gStyle.SetOptStat(0)
  signal.SetStats(0)
  #reducible_background.SetLineColor(ROOT.kBlue)
  #red_bkgrd.SetLineColor(ROOT.kOrange - 4)
  zz.SetLineColor(ROOT.kRed + 2)
  zz.SetFillColor(ROOT.kRed + 2)
  zz.SetFillStyle(3003)
  signal.SetLineColor(ROOT.kBlue)
  signal.SetFillColor(ROOT.kBlue)
  signal.SetFillStyle(3003)
  red_bkgrd.SetLineColor(ROOT.kGreen + 2)
  red_bkgrd.SetFillColor(ROOT.kGreen +2)
  red_bkgrd.SetFillStyle(3005)

  uncert.SetFillColor(ROOT.kBlack)
  uncert.SetFillStyle(3005)

  signal.SetLineWidth(3)
  zz.SetLineWidth(3)
  red_bkgrd.SetLineWidth(3)
  #red_bkgrd.SetLineWidth(3)
  #vh.SetLineWidth(3)

  # rebin histograms
  #reducible_background.Rebin(20)
  #rbin = 1
  data.Rebin(rbin)
  zz.Rebin(rbin)
  signal.Rebin(rbin)
  red_bkgrd.Rebin(rbin)
  fullsim.Rebin(rbin)  
  vh.Rebin(rbin)
  uncert.Rebin(rbin)

  hstack = ROOT.THStack("MC", "MC")
  hstack.Add(red_bkgrd)
  hstack.Add(zz)
  hstack.Add(vh)
  hstack.Add(uncert)
  #hstack.Add(signal)
  hstack.Draw("hist")

  #if(signal.GetMaximum() > zz.GetMaximum()):
  #    maxval = signal.GetMaximum()
  #else:
  #    maxval = zz.GetMaximum()
  hstack.SetMaximum(hstack.GetMaximum()*1.8)
  #signal.SetMaximum(maxval*1.8);

  hstack.GetXaxis().SetRangeUser(0, 800)
  #signal.GetYaxis().SetRangeUser(0, 0.24)
  #red_bkgrd.GetXaxis().SetLimits(0, 200)
  #zz.GetXaxis().SetLimits(0, 200)

  hstack.GetXaxis().SetTitle(xaxis_title)
  hstack.GetYaxis().SetTitle("Events / %0.1f GeV" % ( (1.0*xhigh - xlow)/nbins * rbin) )
    

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
  if not blinded:
    data.Draw("same")
  #fullsim.Draw("hist")
  #signal.Draw("hist")
  #zz.Draw("hist same")
  #red_bkgrd.Draw("hist same")
  #wz.GetFunction("gaus").Draw("same")
  #signal.Draw("hist same")
  #data.Draw("hist same")

  l1 = ROOT.TLegend(0.60,0.73,0.70,0.93,"")
  l1.AddEntry(red_bkgrd,"REDUCIBLE BKG","l")
  #l1.AddEntry(wz, "WZ", "l")
  l1.AddEntry(zz, "ZZ", "l")
  l1.AddEntry(vh, "SM Zh (m_{H} = 125 GeV)", "l")
  l1.AddEntry(uncert, "Red Bkgrd Uncert", "f")
  #l1.AddEntry(signal, "A->Zh (mA=%s GeV)" % mass,"l")
  l1.SetBorderSize(0)
  l1.SetFillColor(0)
  l1.SetTextSize(0.03)
  l1.Draw()

  #os.system("sleep 10")

  prod_label = ""
  for p in prods:
    prod_label += str(p)
  #canvas.SetTitle("Reconstructed Z Mass")
  ofile.cd()
  canvas.Write()
  if (len(sys.argv) == 2):
    canvas.SaveAs("control_plots/%s/%s%s.png" % (channel, prod_label, variable) )
  else: canvas.SaveAs("control_plots/combined/%s%s.png" % (prod_label, variable) )
  canvas.Close()
  ofile.Close()

#make_control_plot(prods, variable, xaxis_title, rbin, nbins, xlow, xhigh, blinded=False, stripped=False)

# ZH system plots
make_control_plot((), 'Mass', "A Visible Mass", 5, 200, 0, 1600,True)
make_control_plot((), 'A_SVfitMass', "A SV-fit Mass", 5, 200, 0, 1600,True)

# di-tau plots
#make_control_plot((3,4), 'Mass', "#tau#tau Visible Mass", 10, 200, 0, 200, True)
#make_control_plot((3,4), 'SVfitMass', "#tau#tau SV-fit Mass", 10, 300, 0, 300,True)
#make_control_plot((3,4), 'Eta', "#tau#tau #eta", 10, 100, -2.4, 2.4)
#make_control_plot((3,4), 'DR', "#tau#tau #deltaR", 10, 100, 0, 10)
#make_control_plot((3,4), 'DPhi', "#tau#tau #delta#phi", 10, 180, 0, 7)
#make_control_plot((3,4), 'Pt', "#tau#tau p_{T}", 10, 100, 0, 100)

# Z plots
#make_control_plot((1,2), 'Pt', 'Z p_{T}', 10, 100, 0, 100)
#make_control_plot((1,2), 'Mass', 'Z Mass', 10, 200, 0, 200,True)
#make_control_plot((1,2), 'DR', "Z products #deltaR", 10, 100, 0, 10)
#make_control_plot((1,2), 'DPhi', "Z products #delta#phi", 10, 180, 0, 7) 

# tau 1, tau 2 plots
#make_control_plot((3,), 'AbsEta', '#tau_{1} Abs(#eta)', 10, 100, 0, 2.4,False,True)
#make_control_plot((4,), 'AbsEta', '#tau_{2} Abs(#eta)', 10, 100, 0, 2.4,False,True)
#make_control_plot((3,), 'Pt', '#tau_{1} p_{T}', 10, 100, 0, 100,False,True)
#make_control_plot((4,), 'Pt', '#tau_{2} p_{T}', 10, 100, 0, 100,False,True)
