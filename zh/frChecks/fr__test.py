from ROOT import gROOT, gDirectory, gPad, gSystem, gStyle
import ROOT
import os
import GeneralPlotScript as Plots



myShapes = ROOT.TFile("results/2014-02-28_8TeV_Ntuples-v2/TauFakeRatesMMET/ggZZ2L2L.root", "r")
ntuple = myShapes.Get("ztt/pt10low/LooseIso3Hits/Event_ID")

for row in ntuple:
    print "%s %s %s" % (row.run, row,lumi, row.eVetoZH)
