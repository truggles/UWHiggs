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
            'AHttZll300' : ("kBlue", "kBlue", 21),
            'data_obs' : ("","")
}

variables_map = {'LT_Higgs' : (5, 200, "L_{T} higgs", "(GeV)"),
                 'Mass' : (20, 800, "Visible Mass", "(GeV)"),
                 'mva_metEt' : (7, 280, "mva metEt", "(GeV)"),
                 'A_SVfitMass' : (20, 800, "Mass_{l^{+}l^{-}#tau^{+}#tau^{-}}", "(GeV)")
}

variables = ['LT_Higgs','Mass','mva_metEt','A_SVfitMass']

ROOT.gROOT.SetBatch(True)

for variable in variables:
    #print variable
    my_total = ROOT.THStack("my_total", "CMS Preliminary, Red + Irr bgk & Data, 19.7 fb^{-1} at S=#sqrt{8} TeV")
    my_shapes = ROOT.TFile("results/2014-02-28_8TeV_Ntuples-v2/cards/shapes.root", "r")
    my_data = ROOT.TH1F("my_data", "Data (no stack)", variables_map[variable][0], 0, variables_map[variable][1])
    my_VHWW = ROOT.TH1F("my_VHWW", "VHWW", variables_map[variable][0], 0, variables_map[variable][1])
    my_VHTauTau = ROOT.TH1F("my_VHTauTau", "VHTauTau", variables_map[variable][0], 0, variables_map[variable][1])
    my_TTZJets = ROOT.TH1F("my_TTZJets", "TTZJets", variables_map[variable][0], 0, variables_map[variable][1])
    my_ggZZ2L2L = ROOT.TH1F("my_ggZZ2L2L", "ggZZ2L2L", variables_map[variable][0], 0, variables_map[variable][1])
    my_ZZJetsTo4L = ROOT.TH1F("my_ZZJetsTo4L", "ZZJetsTo4L", variables_map[variable][0], 0, variables_map[variable][1])
    my_Zjets = ROOT.TH1F("my_Zjets", "Zjets (Red bkg)", variables_map[variable][0], 0, variables_map[variable][1])
    my_A300 = ROOT.TH1F("my_A300", "A300 Signal (no stack)", variables_map[variable][0], 0, variables_map[variable][1])
    
    for sample in ['VHWW', 'VHTauTau', 'TTZJets', 'ggZZ2L2L', 'ZZJetsTo4L', 'Zjets', 'data_obs', 'AHttZll300']:
        if variable == 'A_SVfitMass': sampVar = sample
        else: sampVar = sample + "_" + variable
        #print sampVar
        #print "sampVar: %s" % sampVar
        #print "sample: %s" % sample
        my_red_combined = ROOT.THStack("%s combined" % sample, "%s combined" % sample)
    
        for channel in ['mmtt', 'eett', 'mmmt', 'eemt', 'mmet', 'eeet', 'mmme', 'eeem']:
            if (channel == 'mmme'):
                my_red = my_shapes.Get("mmem_zh/%s" % (sampVar) )
            else: my_red = my_shapes.Get("%s_zh/%s" % (channel, sampVar) )
            #print "Bin#: %i" % my_red.GetSize()
            c1 = ROOT.TCanvas("c1", "a canvas")
            pad1 = ROOT.TPad("pad1","",0,0,1,1) # compare distributions
            pad1.Draw()    
            pad1.cd() 
            pad1.SetGrid()
            my_red.Draw("%s_%s" % (sampVar, channel) )
            my_red.SetLineColor(ROOT.kRed)
            #my_red.SetMarkerColor(ROOT.kRed)
            my_red.SetFillColor(ROOT.kRed)
            my_red.SetFillStyle(1001)
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
        my_red_combined.GetStack().Last().GetXaxis().SetTitle("%s (GeV), combined" % variable)
        pad2.SetGrid() 
        #c2.SaveAs("/afs/hep.wisc.edu/home/truggles/public_html/A_to_Zh_Plots/background_comparisons/%s/combined.png" % sample)
        pad2.Close()
        c2.Close()
    
        gROOT.cd()
    
        if sample == 'data_obs':
            tempHistD = ROOT.TH1F("my_temp_data", "%s" % sample, variables_map[variable][0], 0, variables_map[variable][1])
            tempHistD = my_red_combined.GetStack().Last().Clone()
            my_data.Add( tempHistD.Clone() )
        if sample == 'AHttZll300':
            my_A300.Add( my_red_combined.GetStack().Last().Clone() )
    	my_A300.SetLineColor(ROOT.kPink+10)
    	my_A300.SetLineWidth(3)
    	my_A300.SetFillStyle(0)
        if sample != 'data_obs' and sample != 'AHttZll300':
            color = "ROOT.%s" % samples[sample][0]
            fillColor = "ROOT.%s" % samples[sample][1]
    	    my_red_combined.GetStack().Last().SetFillColor( eval(color) )
            my_red_combined.GetStack().Last().SetLineColor( eval(color) )
            call = "my_%s.Add ( my_red_combined.GetStack().Last().Clone() )" % sample
            eval( call )
            call = "my_%s.SetFillColor( eval(color) )" % sample
            eval( call )
            call = "my_%s.SetFillStyle( 3140 )" % sample
            eval( call )
            call = "my_%s.Clone()" % sample
            my_total.Add( eval( call ), "hist" )
    
    c3 = ROOT.TCanvas("c3", "a canvas")
    pad5 = ROOT.TPad("pad5","",0,0,1,1) # compare distributions
    pad5.Draw()
    pad5.SetGridy(1)
    pad5.cd()
    my_A300.Draw("e1")
    my_A300.GetYaxis().SetTitle("Events / %i %s" % ( (variables_map[variable][1]/variables_map[variable][0]), variables_map[variable][3] ) )
    my_A300.GetXaxis().SetTitle("%s %s" % (variables_map[variable][2], variables_map[variable][3]) )
    my_A300.SetMaximum( 1.4 * my_data.GetMaximum() )
    my_A300.SetStats(0)
    my_total.Draw("hist same")
    my_data.Draw("e1 same")
    my_data.SetMarkerStyle(21)
    my_data.SetMarkerSize(.8)
    leg = pad5.BuildLegend(0.7, 0.70, 0.9, 0.9)
    leg.SetMargin(0.3)
    leg.SetFillColor(0)
    leg.Draw()
    my_A300.SetTitle("CMS Preliminary 2014, Red + Irr bgk & Data, 19.7 fb^{-1} at S=#sqrt{8} TeV")
    c3.SaveAs("/afs/hep.wisc.edu/home/truggles/public_html/A_to_Zh_Plots/background_comparisons/total_bkg_%s.png" % variable)
    #c3.SaveAs("/afs/hep.wisc.edu/home/truggles/public_html/A_to_Zh_Plots/background_comparisons/total_bkg_%s.pdf" % variable)
    pad5.SetLogy()
    my_A300.SetMinimum( 0.001 )
    c3.SaveAs("/afs/hep.wisc.edu/home/truggles/public_html/A_to_Zh_Plots/background_comparisons/total_bkg_log_%s.png" % variable)
    pad5.Close()
    c3.Close()
