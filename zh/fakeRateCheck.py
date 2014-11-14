from ROOT import gROOT, gDirectory, gPad, gSystem, gStyle
import ROOT
import os
import GeneralPlotScript as Plots

# maps sample to marker color and marker fill style
sample_map = {  1 : ('4objFR_Ele_NumLoose_0_Jet', 'e_zlt_pt10_looseId_electronJetPt', 'numerator', 10),
		2 : ('4objFR_Ele_Denum_0_Jet', 'e_zlt_pt10_looseId_electronJetPt', 'denominator', 10),
		3 : ('4objFR_Ele_NumTight_0_Jet', 'e_zlt_pt10_tightId_electronJetPt', 'numerator', 10),
		#4 : ('4objFR_Ele_Denum_0', 'e_zlt_pt10_tightId_electronJetPt', 'denominator', 1),
		5 : ('4objFR_Mu_NumLoose_0_Jet', 'm_zlt_pt10_looseId_muonJetPt', 'numerator', 10),
		6 : ('4objFR_Mu_Denum_0_Jet', 'm_zlt_pt10_looseId_muonJetPt', 'denominator', 10),
		7 : ('4objFR_Mu_NumTight_0_Jet', 'm_zlt_pt10_tightId_muonJetPt', 'numerator', 10),
		#8 : ('4objFR_Mu_Denum_0', 'm_zlt_pt10_tightId_muonJetPt', 'denominator', 1),
		9 : ('FakeRate_LT_Tau_Pt_After_Loose_CloseJet_E', 't_ztt_pt10high_LooseIso3Hits_tauJetPt_ltau', 'numerator', 10),
		10 : ('FakeRate_LT_Tau_Pt_After_Loose_CloseJet_B', 't_ztt_pt10low_LooseIso3Hits_tauJetPt_ltau', 'numerator', 10),
		11 : ('FakeRate_TT_Tau_Pt_After_Loose_CloseJet_B', 't_ztt_pt10low_MediumIso3Hits_tauJetPt_tautau', 'numerator', 10),
		12 : ('FakeRate_TT_Tau_Pt_After_Loose_CloseJet_E', 't_ztt_pt10high_MediumIso3Hits_tauJetPt_tautau', 'numerator', 10),
}

ROOT.gROOT.SetBatch(True)
ROOT.gStyle.SetOptStat(1111)

herShapes = ROOT.TFile("For_Tyler_Sept22/FR_histograms.root", "r")

for sample in sample_map.keys():
    print "sample: %s" % sample_map[sample][0]
    herShape = ROOT.TH1F("herHist", "%s" % sample_map[sample][0], 800, 0, 800)
    myShape = ROOT.TH1F("myHist", "%s" % sample_map[sample][0], 160, 0, 800)
    myShapes = ROOT.TFile("results/2014-02-28_8TeV_Ntuples-v2/fakerate_fits/%s.corrected_inputs.root" % sample_map[sample][1], "r")
    myShape = myShapes.Get("%s" % sample_map[sample][2] )
    herShape = herShapes.Get( sample_map[sample][0] )

    #myShape.Scale( 1/myShape.Integral() )
    #herShape.Scale( 1/herShape.Integral() )
    #herShape.Rebin(10)
    #myShape.Rebin( sample_map[sample][3] )
    herShape.Rebin( sample_map[sample][3] )
    #myShape.Rebin(5)
    herShape.SetMarkerStyle(21)
    herShape.SetMarkerColor(ROOT.kBlue)
    herShape.SetLineColor(ROOT.kBlue)
    #herShape.SetMarkerSize(2)
    #herShape.SetLineWidth(3)
    #myShape.SetMarkerStyle(21)
    #myShape.SetMarkerColor(ROOT.kRed)
    myShape.SetLineColor(ROOT.kRed)
    myShape.SetLineWidth(3)
    myShape.SetFillStyle(0)
    
    c1 = ROOT.TCanvas("c1", "a canvas")
    pad1 = ROOT.TPad("pad1","",0,0,1,1)
    pad1.Draw()
    pad1.cd()
    pad1.SetGridy()

    #pad1.SetStats(1)
    herShape.GetYaxis().SetTitle("Events / 10 Gev")
    herShape.GetXaxis().SetTitle("Pt of Closest Jet (GeV)")
    herShape.SetTitle("ULB")
    myShape.SetTitle("UW")

    if herShape.GetMaximum() > myShape.GetMaximum():
        max = herShape.GetMaximum()
    else:
        max = myShape.GetMaximum()
    herShape.SetMaximum( 1.2 * max )
    herShape.SetBins(15, 0, 150)

    herShape.SetName("ULB")
    myShape.SetName("UW")
    herShape.SetStats(1)
    myShape.SetStats(1)
    herShape.Draw()
    myShape.Draw("AP sames")
    c1.Update()
    stats1 = Plots.getStatBox( herShape )
    Plots.moveStatBox( stats1, 0.8, 0.98, 0.98, 0.85)
    stats2 = Plots.getStatBox( myShape )
    Plots.moveStatBox( stats2, 0.8, 0.85, 0.98, 0.72)
    leg = pad1.BuildLegend(.8, .63, .98, .72)
    leg.SetFillColor(0)
    leg.Draw()
    c1.Update()
    
    ##txtULB = ROOT.TText(150, herShape.GetMaximum()*0.9, "ULB's # of Entries: %i" % herShape.GetEntries() )
    #txtULB = ROOT.TText(70, herShape.GetMaximum()*0.9, "ULB's # of Entries: %i" % herShape.GetEntries() )
    #txtULB.Draw()
    ##txtUW = ROOT.TText(150, herShape.GetMaximum()*0.85, "UW's # of Entries: %i" % myShape.GetEntries() )
    #txtUW = ROOT.TText(70, herShape.GetMaximum()*0.85, "UW's # of Entries: %i" % myShape.GetEntries() )
    #txtUW.Draw("hist")

    herShape.SetTitle(sample_map[sample][0])

    #c1.SaveAs("/afs/hep.wisc.edu/home/truggles/public_html/A_to_Zh_Plots/FakeRatePlots/%s.png" % (sample) )
    herShape.GetXaxis().SetRange(0,30)

    c1.SaveAs("/afs/hep.wisc.edu/home/truggles/public_html/A_to_Zh_Plots/FakeRatePlots/%s_%i.png" % (sample_map[sample][0], sample) )
    pad1.Close()
    c1.Close()
