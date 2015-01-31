import ROOT

ifile = ROOT.TFile("results/2014-02-28_8TeV_Ntuples-v2/fakerate_fits/t_ztt_pt10high_LooseIso3Hits_tauJetPt_ltau.corrected_inputs.root", "r")

all = ifile.Get("denominator")
passing = ifile.Get("numerator")

#c1 = ROOT.TCanvas("c1", "a canvas")
#pad1 = ROOT.TPad("pad1","",0,0,1,1)
#pad1.Draw()

check = ROOT.TEfficiency().CheckConsistency(passing, all)

print "Does it pass? %s" % str(check)

numBins = all.GetSize()
print numBins

for i in range (1, 18):
    print "Bin: %i" % i
    print "All: %i" % all.GetBinContent(i)
    print "Pass: %i" % passing.GetBinContent(i)

passing.SetBinContent(2, all.GetBinContent(2))

check = ROOT.TEfficiency().CheckConsistency(passing, all)

for i in range (1, 18):
    print "Bin: %i" % i 
    print "All: %i" % all.GetBinContent(i)
    print "Pass: %i" % passing.GetBinContent(i)

print "Does it pass? %s" % str(check)
#
#
#all.SetLineColor(ROOT.kBlack-2)
#all.Draw()
#passing.Draw("Same")
#
#c1.SaveAs("frChecking.png")
