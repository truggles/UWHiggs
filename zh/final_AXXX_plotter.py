from ROOT import gROOT
from ROOT import gStyle
import ROOT
import os

# maps sample to marker color and marker fill style
samples = { 'TTZJets' : ("kCyan", "kCyan-2", 21),
            'VHWW' : ("kYellow", "kYellow-2", 21),
            'VHTauTau' : ("kMagenta", "kMagenta-2", 21),
            'ZZJetsTo4L' : ("kGreen", "kGreen-2", 21),
            'ggZZ2L2L' : ("kRed", "kRed-2", 21), 
            'Zjets' : ("kMagenta+3", "kMagenta+1", 21),
            'AZh300' : ("kBlue", "kBlue", 21),
            'data_obs' : ("","")
}

A_map = { 220 : "ROOT.kBlack",
          240 : "ROOT.kOrange+7",
          260 : "ROOT.kGreen+2",
          280 : "ROOT.kYellow-2",
          300 : "ROOT.kMagenta-2",
          320 : "ROOT.kRed",
          340 : "ROOT.kAzure",}

variables_map = {'A_SVfitMass' : (160, 800, "Mass_{l^{+}l^{-}#tau^{+}#tau^{-}}", "(GeV)", "x")}

variables = ['A_SVfitMass']

ROOT.gROOT.SetBatch(True)

for variable in variables:
    #print variable
    my_total = ROOT.THStack("my_total", "CMS Preliminary       19.7 fb^{-1} at #sqrt{S} = 8 TeV")
    my_shapes = ROOT.TFile("results/2014-02-28_8TeV_Ntuples-v2/cards/shapes.root", "r")
    my_A220 = ROOT.TH1F("my_A220", "A220, xsec=1fb", variables_map[variable][0], 0, variables_map[variable][1])
    my_A240 = ROOT.TH1F("my_A240", "A240, xsec=1fb", variables_map[variable][0], 0, variables_map[variable][1])
    my_A260 = ROOT.TH1F("my_A260", "A260, xsec=1fb", variables_map[variable][0], 0, variables_map[variable][1])
    my_A280 = ROOT.TH1F("my_A280", "A280, xsec=1fb", variables_map[variable][0], 0, variables_map[variable][1])
    my_A300 = ROOT.TH1F("my_A300", "A300, xsec=1fb", variables_map[variable][0], 0, variables_map[variable][1])
    my_A320 = ROOT.TH1F("my_A320", "A320, xsec=1fb", variables_map[variable][0], 0, variables_map[variable][1])
    my_A340 = ROOT.TH1F("my_A340", "A340, xsec=1fb", variables_map[variable][0], 0, variables_map[variable][1])
    
    #for sample in ['AZh220', 'AZh240', 'AZh260', 'AZh280', 'AZh300', 'AZh320', 'AZh340']:
    for sample in ['AZh220', 'AZh240', 'AZh260', 'AZh280', 'AZh300', 'AZh320', 'AZh340']:
        #print sampVar
        #print variable
        #print sample
        #print "sampVar: %s" % sampVar
        #print "sample: %s" % sample
        my_red_combined = ROOT.THStack("%s combined" % sample, "%s combined" % sample)
    
        for channel in ['mmtt', 'eett', 'mmmt', 'eemt', 'mmet', 'eeet', 'mmme', 'eeem']:
            if variables_map[ variable][4] == "x":
                #print "no var"
                if variable == 'A_SVfitMass': sampVar = sample
                else: sampVar = sample + "_" + variable
            elif variables_map[ variable][4] == "z":
                #print "Z"
                first = products_map[channel][0]
                second = products_map[channel][1]
                sampVar = "%s_%s_%s_%s" % (sample, first, second, variable)
                #print sampVar
            elif variables_map[ variable][4] == "h":
                #print "h"
                first = products_map[channel][2]
                second = products_map[channel][3]
                sampVar = "%s_%s_%s_%s" % (sample, first, second, variable)
            else:
                #print "singles"
                first = products_map[channel][ variables_map[ variable][4] ]
                sampVar = "%s_%s%s" % (sample, first, variable)
                #print sampVar
            my_red = my_shapes.Get("%s_zh/%s" % (channel, sampVar) )
            #print "Bin#: %i" % my_red.GetSize()
            #print "Max: %f" % ((my_red.GetSize() - 2) * my_red.GetBinWidth(1))
            #try: my_red.GetEntries()
            #except AttributeError:
            #    print sampVar + 'in channel ' + channel + 'has problems'
            #    continue
            c1 = ROOT.TCanvas("c1", "a canvas")
            pad1 = ROOT.TPad("pad1","",0,0,1,1) # compare distributions
            pad1.Draw()    
            pad1.cd() 
            pad1.SetGrid()
            my_red.Draw("%s_%s" % (sampVar, channel) )
            #my_red.SetLineColor(ROOT.kRed)
            #my_red.SetMarkerColor(ROOT.kRed)
            #my_red.SetFillColor(ROOT.kRed)
            #my_red.SetFillStyle(1001)
            my_red.GetXaxis().SetTitle("%s (GeV), %s" % (variable, channel) )
    
            ''' Set reasonable maximums on histos '''        
            my_red_max = my_red.GetMaximum()
            my_red.SetMaximum(1.8 * my_red.GetMaximum() )
        
            #c1.SaveAs("/afs/hep.wisc.edu/home/truggles/public_html/A_to_Zh_Plots/background_comparisons/%s/%s.png" % (sample, channel))
            pad1.Close()
            c1.Close()
                
            gROOT.cd()
            new_my_red = my_red.Clone()
            my_red_combined.Add(new_my_red)
        
        c2 = ROOT.TCanvas("c2", "a canvas")
        pad2 = ROOT.TPad("pad2","",0,0.2,1,1) # compare distributions
        pad2.Draw()
        
        pad2.cd()
        my_red_combined.GetStack().Last().Draw()
        #my_red_combined.GetStack().Last().GetXaxis().SetTitle("%s (GeV), combined" % variable)
        #pad2.SetGrid() 
        #c2.SaveAs("/afs/hep.wisc.edu/home/truggles/public_html/A_to_Zh_Plots/background_comparisons/%s/combined.png" % sample)
        pad2.Close()
        c2.Close()
    
        gROOT.cd()
    
        if sample == 'AZh220':
            my_A220.Add( my_red_combined.GetStack().Last().Clone() )
        if sample == 'AZh240':
            my_A240.Add( my_red_combined.GetStack().Last().Clone() )
        if sample == 'AZh260':
            my_A260.Add( my_red_combined.GetStack().Last().Clone() )
        if sample == 'AZh280':
            my_A280.Add( my_red_combined.GetStack().Last().Clone() )
        if sample == 'AZh300':
            my_A300.Add( my_red_combined.GetStack().Last().Clone() )
        if sample == 'AZh320':
            my_A320.Add( my_red_combined.GetStack().Last().Clone() )
        if sample == 'AZh340':
            my_A340.Add( my_red_combined.GetStack().Last().Clone() )
    
    c3 = ROOT.TCanvas("c3", "a canvas")
    pad5 = ROOT.TPad("pad5","",0,0,1,1) # compare distributions
    pad5.Draw()
    pad5.SetGridy(1)
    pad5.cd()
    my_A220.Draw("hist")
    my_A220.GetYaxis().SetTitle("Events / %i %s" % ( (variables_map[variable][1]/variables_map[variable][0]), variables_map[variable][3] ) )
    my_A220.GetXaxis().SetTitle("%s %s" % (variables_map[variable][2], variables_map[variable][3]) )
    my_A220.SetStats(0)
    my_A220.SetLineWidth(2)
 
    for num in [240, 260, 280, 300, 320, 340]:
        eval("my_A%s.Draw('hist same')" % num)
        eval("my_A%s.SetStats(0)" % num)
        eval("my_A%s.SetLineWidth(2)" % num)
        eval("my_A%s.SetLineColor( %s )" % (num, A_map[num]))
    #my_A300.GetYaxis().SetTitle("Events / %i %s" % ( (variables_map[variable][1]/variables_map[variable][0]), variables_map[variable][3] ) )
    #my_A300.GetXaxis().SetTitle("%s %s" % (variables_map[variable][2], variables_map[variable][3]) )
    my_A220.SetMaximum( 1.4 * my_A260.GetMaximum() )
    #print "Fill Style: %i" % my_A300.GetFillStyle()
    #my_total.Draw("hist same")
    #print "My Total Int: %f" % my_total.GetStack().Last().Integral()
    leg = pad5.BuildLegend(0.65, 0.65, 0.9, 0.9)
    leg.SetMargin(0.3)
    leg.SetFillColor(0)
    leg.Draw()
    my_A220.SetTitle("CMS Preliminary, AToZh MadGraph Signal Post Cuts")
   
    saveVar = variable
    my_A220.GetXaxis().SetRange(20, 100)
 
    c3.SaveAs("/afs/hep.wisc.edu/home/truggles/public_html/A_to_Zh_Plots/background_comparisons/AToZh_Signal_Plot_MG.pdf")
    c3.SaveAs("/afs/hep.wisc.edu/home/truggles/public_html/A_to_Zh_Plots/background_comparisons/AToZh_Signal_Plot_MG.png")
    #c3.SaveAs("/afs/hep.wisc.edu/home/truggles/public_html/A_to_Zh_Plots/background_comparisons/total_bkg_%s.pdf" % saveVar)
   # pad5.SetLogy()
   # my_total.SetMinimum( 0.1 )
   # c3.SaveAs("/afs/hep.wisc.edu/home/truggles/public_html/A_to_Zh_Plots/background_comparisons/total_bkg_log_%s.png" % saveVar)
    pad5.Close()
    c3.Close()
