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

variables_map = {'LT_Higgs' : (20, 200, "L_{T} higgs", "(GeV)", "x"),
                 'Mass' : (20, 800, "Visible Mass_{l^{+}l^{-}#tau^{+}#tau^{-}}", "(GeV)", "x"),
                 #'Mass' : (20, 200, "SM higgs Visible Mass", "(GeV)", "h"),
                 #'Mass' : (20, 200, "Z Mass", "(GeV)", "z"),
                 'mva_metEt' : (30, 300, "mva metEt", "(GeV)", "x"),
                 'A_SVfitMass' : (20, 800, "Mass_{l^{+}l^{-}#tau^{+}#tau^{-}}", "(GeV)", "x"),
                 'SVfitMass' : (30, 300, "SM higgs Mass", "(GeV)", "h"),
                 #'DR' : (20, 10, "higgs products dR", "(GeV)", "h"),
                 'DR' : (20, 10, "Z products dR", "(GeV)", "z"),
                 'Pt' : (20, 100, "Z lepton1 product dR", "(GeV)", 0),
}

products_map = {'mmtt' : ('m1', 'm2', 't1', 't2'), 
                'eett' : ('e1', 'e2', 't1', 't2'),
                'mmmt' : ('m1', 'm2', 'm3', 't'),
                'eemt' : ('e1', 'e2', 'm', 't'),
                'mmet' : ('m1', 'm2', 'e', 't'),
                'eeet' : ('e1', 'e2', 'e3', 't'),
                'mmem' : ('m1', 'm2', 'e', 'm3'),
                'eeem' : ('e1', 'e2', 'e3', 'm')
}


blind = True
A300Scaling = 20

variables = ['Pt']#,'Mass','DR','LT_Higgs','mva_metEt','A_SVfitMass','SVfitMass']

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
    my_A300 = ROOT.TH1F("my_A300", "A300x%i, xsec=1fb, tan#beta = ???" % A300Scaling, variables_map[variable][0], 0, variables_map[variable][1])
    
    for sample in ['VHWW', 'VHTauTau', 'TTZJets', 'ggZZ2L2L', 'ZZJetsTo4L', 'Zjets', 'data_obs', 'AHttZll300']:
        #print sampVar
        #print variable
        #print sample
        #print "sampVar: %s" % sampVar
        #print "sample: %s" % sample
        my_red_combined = ROOT.THStack("%s combined" % sample, "%s combined" % sample)
    
        for channel in ['mmtt', 'eett', 'mmmt', 'eemt', 'mmet', 'eeet', 'mmem', 'eeem']:
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
    
        if sample == 'data_obs':
            tempHistD = ROOT.TH1F("my_temp_data", "%s" % sample, variables_map[variable][0], 0, variables_map[variable][1])
            tempHistD = my_red_combined.GetStack().Last().Clone()
            my_data.Add( tempHistD.Clone() )
            #print "# of Bins: %i" % my_data.GetSize()
            #print "Bin Width %i" % my_data.GetBinWidth(1)
            #print "Max: %i" % ( (my_data.GetSize() - 2) * my_data.GetBinWidth(1) )
            if (variable == 'Mass' or variable == 'A_SVfitMass') and blind:
                print "We made it to blind section"
                numBins = my_data.GetSize() - 2
                binWidth = my_data.GetBinWidth(1)
                # we will blind 240 - 360 GeV as a first run in both Mass and SVFitMass
                lowBlind = int(((240/binWidth) + 1)) # +1 b/c of overflow low bin
                binsToNull = [lowBlind, lowBlind + 1, lowBlind + 2]
                #tGraph = ROOT.TGraph( my_data, "e1")
                for bin in binsToNull:
                    my_data.SetBinContent(bin, 0)
        if sample == 'AHttZll300':
            my_A300.Add( my_red_combined.GetStack().Last().Clone() )
            #my_A300.SetLineColor(ROOT.kPink+10)
            #my_A300.SetLineWidth(3)
            #my_A300.SetFillStyle(3140)
            #print "A300 Int: %f" % my_A300.Integral()
            my_A300.Scale( A300Scaling )
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
    my_total.Draw("hist")
    #my_total.GetYaxis().SetTitle("hello")
    my_total.GetYaxis().SetTitle("Events / %i %s" % ( (variables_map[variable][1]/variables_map[variable][0]), variables_map[variable][3] ) )
    my_total.GetXaxis().SetTitle("%s %s" % (variables_map[variable][2], variables_map[variable][3]) )
    my_A300.SetLineWidth(2)
    my_A300.SetLineColor(ROOT.kAzure)
    #my_A300.SetFillStyle(0)
    #my_A300.SetFillColor(ROOT.kRed)
    my_A300.Draw("hist same")
    #my_A300.GetYaxis().SetTitle("Events / %i %s" % ( (variables_map[variable][1]/variables_map[variable][0]), variables_map[variable][3] ) )
    #my_A300.GetXaxis().SetTitle("%s %s" % (variables_map[variable][2], variables_map[variable][3]) )
    my_total.SetMaximum( 1.3 * my_data.GetMaximum() )
    my_A300.SetStats(0)
    #print "Fill Style: %i" % my_A300.GetFillStyle()
    #my_total.Draw("hist same")
    #print "My Total Int: %f" % my_total.GetStack().Last().Integral()
    my_data.Draw("e1 same")
    my_data.SetMarkerStyle(21)
    my_data.SetMarkerSize(.8)
    leg = pad5.BuildLegend(0.60, 0.55, 0.9, 0.9)
    leg.SetMargin(0.3)
    leg.SetFillColor(0)
    leg.Draw()
    my_total.SetTitle("CMS Preliminary, Background, Data & MC Signal, 19.7 fb^{-1} at S=#sqrt{8} TeV")
   
    #if variables_map[ variable][4] == "h": saveVar = variable +'_h'
    #if variables_map[ variable][4] == "z": saveVar = variable +'_z'
    saveVar = variable
 
    c3.SaveAs("/afs/hep.wisc.edu/home/truggles/public_html/A_to_Zh_Plots/background_comparisons/total_bkg_%s.pdf" % saveVar)
    #c3.SaveAs("/afs/hep.wisc.edu/home/truggles/public_html/A_to_Zh_Plots/background_comparisons/total_bkg_%s.pdf" % saveVar)
   # pad5.SetLogy()
   # my_total.SetMinimum( 0.1 )
   # c3.SaveAs("/afs/hep.wisc.edu/home/truggles/public_html/A_to_Zh_Plots/background_comparisons/total_bkg_log_%s.png" % saveVar)
    pad5.Close()
    c3.Close()
