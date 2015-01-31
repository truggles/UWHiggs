# THR
# Oct 13, 2014
# Script to plot ULB vs. UW Fake Rate Fits
# Note that the ordering of ULB and UW parameters is not consistent in run_map


from ROOT import gStyle
from ROOT import gROOT, TCanvas, TF1, TFormula, TMath
import ROOT
import os
import math

gROOT.Reset()
ROOT.gROOT.SetBatch(True)

# UW Results from Oct 10, have fixed elec 0-10JetPt Bins and Mu Iso Loose
run_map = { #'FakeRate_TT_Tau_Pt_After_Loose' : (1.82E-03, 1.20E+00, -7.11E-02),
            'FakeRate_TT_Tau_Pt_After_Loose_CloseJet_B' : (1.69E-03, 1.27E+00, -7.75E-02, -8.3414e-02, 1.9859e-03, 1.4865e+00),
            'FakeRate_TT_Tau_Pt_After_Loose_CloseJet_E' : (3.45E-03, 2.40E+00, -7.97E-02, -8.0276e-02, 3.4539e-03, 2.4893e+00),
            #'FakeRate_LT_Tau_Pt_After_Loose' : (3.54E-03, 2.31E+00, -8.05E-02),
            'FakeRate_LT_Tau_Pt_After_Loose_CloseJet_B' : (2.39E-03, 1.91E+00, -7.89E-02, -7.8275e-02, 3.2501e-03, 2.1593e+00),
            'FakeRate_LT_Tau_Pt_After_Loose_CloseJet_E' : (9.92E-03, 1.07E+01, -1.09E-01, -7.5708e-02, 6.9841e-03, 3.1243e+00),
            '4objFR_Ele_NumLoose' : (1.08E-02, 1.65E+00, -1.48E-01, -9.1661e-02, 1.3266e-02, 3.4613e-01),
            # pre Missing Hits == 0: '4objFR_Ele_NumTight' : (2.85E-03, 3.40E-01, -1.30E-01, -5.5150e-02, 5.7587e-03, 3.8072e-02),
            '4objFR_Ele_NumTight' : (2.85E-03, 3.40E-01, -1.30E-01, -5.8769e-02, 4.6999e-03, 2.8120e-02),
            '4objFR_Mu_NumLoose' : (4.21E-03, 1.05E+00, -8.95E-02, -7.9967e-02, 3.6030e-03, 9.2412e-01),
            '4objFR_Mu_NumTight' : (4.00E-03, 9.63E-01, -8.76E-02, -8.0517e-02, 3.6539e-03, 9.0691e-01)
}

# UW Results from Oct7
#run_map = { #'FakeRate_TT_Tau_Pt_After_Loose' : (1.82E-03, 1.20E+00, -7.11E-02),
#            'FakeRate_TT_Tau_Pt_After_Loose_CloseJet_B' : (1.69E-03, 1.27E+00, -7.75E-02, -8.3448e-02, 1.9891e-03, 1.4908e+00),
#            'FakeRate_TT_Tau_Pt_After_Loose_CloseJet_E' : (3.45E-03, 2.40E+00, -7.97E-02, -8.0184e-02, 3.4561e-03, 2.4767e+00),
#            #'FakeRate_LT_Tau_Pt_After_Loose' : (3.54E-03, 2.31E+00, -8.05E-02),
#            'FakeRate_LT_Tau_Pt_After_Loose_CloseJet_B' : (2.39E-03, 1.91E+00, -7.89E-02, -7.8353e-02, 3.2132e-03, 2.1659e+00),
#            'FakeRate_LT_Tau_Pt_After_Loose_CloseJet_E' : (9.92E-03, 1.07E+01, -1.09E-01, -7.5462e-02, 6.9626e-03, 3.0712e+00),
#            '4objFR_Ele_NumLoose' : (1.08E-02, 1.65E+00, -1.48E-01, -1.7642e-01, 1.4148e-02, 4.9998e+00),
#            '4objFR_Ele_NumTight' : (2.85E-03, 3.40E-01, -1.30E-01, -4.4259e-02, 5.2389e-03, 2.9058e-02),
#            '4objFR_Mu_NumLoose' : (4.21E-03, 1.05E+00, -8.95E-02, -7.9921e-02, 3.6045e-03, 9.2386e-01),
#            '4objFR_Mu_NumTight' : (4.00E-03, 9.63E-01, -8.76E-02, -8.8076e-02, 3.2184e-03, 6.0686e-01)
#}

def myf(x, par = ()):
    c1 = par[0]
    c2 = par[1]
    c3 = par[2]
    return c1*TMath.Exp(x[0]*c2)+c3

#def mydiff(x, par = ()):
#    c1 = par[0]
#    c2 = par[1]
#    c3 = par[2]
#    c4 = par[3]
#    c5 = par[4]
#    c6 = par[5]
#    return ( (c1*TMath.Exp(x[0]*c2)+c3) / (c4*TMath.Exp(x[0]*c5)+c6+.0001) )

for key in run_map:
    plot = TF1(key, myf, 10, 150, 3)
    plot.SetParNames("c1", "c2", "c3")
    plot.SetParameter("c1", run_map[key][1])
    plot.SetParameter("c2", run_map[key][2])
    plot.SetParameter("c3", run_map[key][0])


    plot2 = TF1(key, myf, 10, 150, 3)
    plot2.SetParNames("c1", "c2", "c3")
    plot2.SetParameter("c1", run_map[key][5])
    plot2.SetParameter("c2", run_map[key][3])
    plot2.SetParameter("c3", run_map[key][4])


    c1 = ROOT.TCanvas("c1", "a canvas")
    pad1 = ROOT.TPad("pad1","",0,0,1,1) # compare distributions
    #pad2 = ROOT.TPad("pad2","",0,0,1,0.2) # ratio plot
    pad1.Draw()    
    pad1.cd() 
    pad1.SetGrid()
    plot.Draw()
    plot.SetLineColor(ROOT.kBlue)    
    plot.SetTitle("ULB Fit")
    plot2.Draw("same")
    plot2.SetLineColor(ROOT.kRed)    
    plot2.SetTitle("Wisconsin Fit")
    leg = pad1.BuildLegend(0.65, 0.65, 0.9, 0.9)
    leg.SetMargin(0.3)
    leg.SetFillColor(0)
    leg.Draw()
    plot.SetTitle("CMS Preliminary, AToZh MadGraph Signal Post Cuts")
    pad1.SetLogy()
    plot.SetMinimum( 0.001 )

    txtULB = ROOT.TText(20, plot.GetMaximum()*0.5, "%s" % key )
    txtULB.Draw()

    #pad2.cd()
    #pad2.SetGrid()
    #HDiff = TF1(key, mydiff, 10, 150, 6)
    #HDiff.SetParNames("c1", "c2", "c3", "c4", "c5", "c6")
    #HDiff.SetParameter("c1", run_map[key][1])
    #HDiff.SetParameter("c2", run_map[key][2])
    #HDiff.SetParameter("c3", run_map[key][0]+.4)
    #HDiff.SetParameter("c4", run_map[key][1])
    #HDiff.SetParameter("c5", run_map[key][2])
    #HDiff.SetParameter("c6", run_map[key][0])

    #HDiff.SetTitle("")
    ##HDiff.GetYaxis().SetRangeUser(0.9,1.1)
    ##HDiff.GetYaxis().SetRangeUser(0.98,1.02)
    ##HDiff.GetYaxis().SetRangeUser(0.5, 1.5)
    ##HDiff.GetYaxis().SetRangeUser(0.0, 2.0)
    ##HDiff.GetYaxis().SetNdivisions(3)
    ##HDiff.GetYaxis().SetLabelSize(0.1)
    ##HDiff.GetYaxis().SetTitleSize(0.1)
    ##HDiff.GetYaxis().SetTitleOffset(0.5)
    #HDiff.GetYaxis().SetTitle("Wisconsin / ULB")
    ##HDiff.GetXaxis().SetNdivisions(-1)
    ##HDiff.GetXaxis().SetTitle("")
    ##HDiff.GetXaxis().SetLabelSize(0.0001)
    #HDiff.Draw()
    ##HDiff.SetStats(0)
    
    c1.SaveAs("/afs/hep.wisc.edu/home/truggles/public_html/A_to_Zh_Plots/FR_Efficiencies/%s.png" % key)
    #c1.SaveAs("/afs/hep.wisc.edu/home/truggles/public_html/A_to_Zh_Plots/FR_Efficiencies/%s.png" % key)
    #c1.SaveAs("/afs/hep.wisc.edu/home/truggles/public_html/A_to_Zh_Plots/background_comparisons/total_bkg_%s.pdf" % saveVar)
    #c1.SaveAs("/afs/hep.wisc.edu/home/truggles/public_html/A_to_Zh_Plots/background_comparisons/total_bkg_%s.png" % saveVar)
    pad1.Close()
    #pad2.Close()
    c1.Close()

# For entering new UW results...
#run_map = { #'FakeRate_TT_Tau_Pt_After_Loose' : (1.82E-03, 1.20E+00, -7.11E-02),
#            'FakeRate_TT_Tau_Pt_After_Loose_CloseJet_B' : (1.69E-03, 1.27E+00, -7.75E-02, ),
#            'FakeRate_TT_Tau_Pt_After_Loose_CloseJet_E' : (3.45E-03, 2.40E+00, -7.97E-02, ),
#            #'FakeRate_LT_Tau_Pt_After_Loose' : (3.54E-03, 2.31E+00, -8.05E-02),
#            'FakeRate_LT_Tau_Pt_After_Loose_CloseJet_B' : (2.39E-03, 1.91E+00, -7.89E-02, ),
#            'FakeRate_LT_Tau_Pt_After_Loose_CloseJet_E' : (9.92E-03, 1.07E+01, -1.09E-01, ),
#            '4objFR_Ele_NumLoose' : (1.08E-02, 1.65E+00, -1.48E-01, ),
#            '4objFR_Ele_NumTight' : (2.85E-03, 3.40E-01, -1.30E-01, ),
#            '4objFR_Mu_NumLoose' : (4.21E-03, 1.05E+00, -8.95E-02, ),
#            '4objFR_Mu_NumTight' : (4.00E-03, 9.63E-01, -8.76E-02, )
#}
