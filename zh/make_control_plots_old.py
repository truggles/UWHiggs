import ROOT
import os
from FinalStateAnalysis.MetaData.data_views import extract_sample, read_lumi
import math

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

#jobid = "2013-10-02-8TeV-v2-MSSM_A_ZH_mmtt"
#jobid = "2013-11-02-8TeV-v1-ZH"
jobid = "2014-02-28_Ntuples-v2"

#data_file = ROOT.TFile("results/%s/ZHAnalyzeCOMB/data.root" % jobid, "READ")
#zz_file = ROOT.TFile("results/%s/ZHAnalyzeCOMB/ZZJetsTo4L_pythia.root"% jobid, "READ")
#signal_file = ROOT.TFile("results/%s/ZHAnalyzeCOMB/MSSM_A_ZH_FastSim.root"% jobid, "READ")

# scale to 19.5 fb^-1
data_lumi = 39425.0/2
zz_lumi = get_lumi("ZZJetsTo4L_pythia.root")
signal_lumi = get_lumi("MSSM_A_ZH_FastSim.root")
print "signal_lumi = %f" % signal_lumi

nbins = 100
xlow = 0
xhigh = 100

data = ROOT.TH1F("data", "data", nbins, xlow, xhigh)
zz = ROOT.TH1F("zz", "zz", nbins, xlow, xhigh)
signal = ROOT.TH1F("signal", "signal", nbins, xlow, xhigh)

# reducible background components
data_1 = ROOT.TH1F("data_1", "data_1", nbins, xlow, xhigh)
data_2 = ROOT.TH1F("data_2", "data_2", nbins, xlow, xhigh)
data_0 = ROOT.TH1F("data_0", "data_0", nbins, xlow, xhigh)

variable = "Z_Pt"

## H candidate visible mass
#for channel, label in [("MMTT", "t1_t2_Mass"), ("MMMT", "m3_t_Mass"),
#        ("MMET", "e_t_Mass"),("MMEM", "e_m3_Mass")]:

## H candidate svmass
#for channel, label in [("MMTT", "t1_t2_SVfitMass"), ("MMMT", "m3_t_SVfitMass"),
#	("MMET", "e_t_SVfitMass"),("MMEM", "e_m3_SVfitMass")]:
# di-tau sv mass
#for channel, label in [("MMMT", "m3_t_SVfitMass"),
#        ("MMET", "e_t_SVfitMass"),("MMEM", "e_m3_SVfitMass"),
#        ("EEET", "e3_t_SVfitMass"), ("EEMT", "m_t_SVfitMass"),
#        ("EEEM", "e3_m_SVfitMass"), ("MMTT", "t1_t2_SVfitMass"),
#        ("EETT", "t1_t2_SVfitMass")]:

# ditau pt
#for channel, label in [("MMMT", "m3_t_Pt"),
#        ("MMET", "e_t_Pt"),("MMEM", "e_m3_Pt"),
#        ("EEET", "e3_t_Pt"), ("EEMT", "m_t_Pt"),
#        ("EEEM", "e3_m_Pt"), ("MMTT", "t1_t2_Pt"),
#        ("EETT", "t1_t2_Pt")]:
# Z mass
#for channel, label in [("MMMT", "m1_m2_Mass"),
#        ("MMET", "m1_m2_Mass"),("MMEM", "m1_m2_Mass"),
#        ("EEET", "e1_e2_Mass"), ("EEMT", "e1_e2_Mass"),
#        ("EEEM", "e1_e2_Mass"), ("MMTT", "m1_m2_Mass"),
#        ("EETT", "e1_e2_Mass")]:
# Z pt
for channel, label in [("MMMT", "m1_m2_Pt"),
        ("MMET", "m1_m2_Pt"),("MMEM", "m1_m2_Pt"),
        ("EEET", "e1_e2_Pt"), ("EEMT", "e1_e2_Pt"),
        ("EEEM", "e1_e2_Pt"), ("MMTT", "m1_m2_Pt"),
        ("EETT", "e1_e2_Pt")]:

# 3rd leg pt
#for channel, label in [("MMMT", "m3Pt"),
#        ("MMET", "ePt"),("MMEM", "ePt"),
#        ("EEET", "e3Pt"), ("EEMT", "mPt"),
#        ("EEEM", "e3Pt"), ("MMTT", "t1Pt"),
#        ("EETT", "t1Pt")]:
# 3rd leg eta
#for channel, label in [("MMMT", "m3AbsEta"),
#        ("MMET", "eAbsEta"),("MMEM", "eAbsEta"),
#        ("EEET", "e3AbsEta"), ("EEMT", "mAbsEta"),
#        ("EEEM", "e3AbsEta"), ("MMTT", "t1AbsEta"),
#        ("EETT", "t1AbsEta")]:
# 4th leg pt
#for channel, label in [("MMMT", "tPt"),
#        ("MMET", "tPt"),("MMEM", "m3Pt"),
#        ("EEET", "tPt"), ("EEMT", "tPt"),
#        ("EEEM", "mPt"), ("MMTT", "t2Pt"),
#        ("EETT", "t2Pt")]:
# 4th leg eta
#for channel, label in [("MMMT", "tAbsEta"),
#        ("MMET", "tAbsEta"),("MMEM", "m3AbsEta"),
#        ("EEET", "tAbsEta"), ("EEMT", "tAbsEta"),
#        ("EEEM", "mAbsEta"), ("MMTT", "t2AbsEta"),
#        ("EETT", "t2AbsEta")]:

## Z mass
#for channel, label in [("MMTT", "m1_m2_Mass")]:

## ZH system mass (A candidate)
#for channel, label in [("MMTT", "Mass")]:
    print label
    data_file = ROOT.TFile("results/%s/ZHAnalyze%s/data.root" % (jobid, channel), "READ")
    zz_file = ROOT.TFile("results/%s/ZHAnalyze%s/ZZJetsTo4L_pythia.root"% (jobid, channel), "READ")
    signal_file = ROOT.TFile("results/%s/ZHAnalyze%s/MSSM_A_ZH_FastSim.root"% (jobid, channel), "READ")

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

    signal_m = signal_file.Get("os/All_Passed/%s" % label);
    signal.Add(signal_m)


red_bkgrd = ROOT.TH1F(data_1)
red_bkgrd.Add(data_2)
red_bkgrd.Add(data_0, -1)

zz.Scale(data_lumi/zz_lumi)
signal.Scale(5 * (data_lumi/signal_lumi) )

ofile = ROOT.TFile("plots.root", "RECREATE")
ROOT.gROOT.SetBatch(True)
canvas = ROOT.TCanvas("canvas", "canvas")

#reducible_background = ROOT.TH1F(wz)
#reducible_background.Add(zjets)

ROOT.gStyle.SetOptStat(0)
signal.SetStats(0)
#reducible_background.SetLineColor(ROOT.kBlue)
red_bkgrd.SetLineColor(ROOT.kOrange - 4)
red_bkgrd.SetFillColor(ROOT.kOrange - 4)
#zz.SetLineColor(ROOT.kRed+2)
zz.SetFillColor(ROOT.kRed+1)
signal.SetLineColor(ROOT.kGreen + 3)
#signal.SetFillColor(ROOT.kGreen + 3)

# rebin histograms
#reducible_background.Rebin(20)
rbin = 10
data.Rebin(rbin)
zz.Rebin(rbin)
red_bkgrd.Rebin(rbin)
signal.Rebin(rbin)

# overall background shape
background = ROOT.THStack("background", "overall background")
background.Add(red_bkgrd)
background.Add(zz)
#background.Add(signal)

if(data.GetMaximum() > background.GetMaximum()):
    maxval = data.GetMaximum()
else:
    maxval = background.GetMaximum()  

background.SetMaximum(maxval*1.8+math.sqrt(data.GetMaximum()));

#signal.GetXaxis().SetRange(0, 50)
#signal.SetTitle("ZH Visible Mass")
#reducible_background.Draw("hist")
#signal.Draw("hist")
#zjets.Draw("hist same")
#data.Draw("same")
#reducible_background.Draw("hist same")
#data.Draw()
#data.Draw()
background.Draw("hist")
data.Draw("same")
#data.Draw("AP same")
signal.Draw("hist same")
#data.Draw("hist same")

background.GetHistogram().GetXaxis().SetTitle("Z p_{t}")
background.GetHistogram().GetYaxis().SetTitle("Events / %d GeV" % ( (xhigh - xlow)/nbins * rbin) )
#background.GetHistogram().GetYaxis().SetTitle("Events")
#background.GetHistogram().SetMaximum(12)

l1 = ROOT.TLegend(0.65,0.63,0.85,0.93,"")
l1.AddEntry(red_bkgrd,"REDUCIBLE BKG","f")
l1.AddEntry(zz, "ZZ", "f")
l1.AddEntry(data, "2012 DATA", "p")
#l1.AddEntry(signal, "5 X MSSM A->ZH","l")
l1.SetBorderSize(0)
l1.SetFillColor(0)
l1.SetTextSize(0.03)
l1.Draw()

os.system("sleep 2")

#canvas.SetTitle("Reconstructed Z Mass")
canvas.Write()
canvas.SaveAs("control_plots/%s.png" % variable)
canvas.Close()
ofile.Close()

