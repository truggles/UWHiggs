#!/usr/bin/env python
from ROOT import gROOT
from ROOT import gStyle
import ROOT
import os
import pyplotter.plot_functions as plotter


blind = True
A300Scaling = 20
ROOT.gROOT.SetBatch(True)
txtLabel = True

products_map = {'mmtt' : ('m1', 'm2', 't1', 't2'), 
                'eett' : ('e1', 'e2', 't1', 't2'),
                'mmmt' : ('m1', 'm2', 'm3', 't'),
                'eemt' : ('e1', 'e2', 'm', 't'),
                'mmet' : ('m1', 'm2', 'e', 't'),
                'eeet' : ('e1', 'e2', 'e3', 't'),
                'mmme' : ('m1', 'm2', 'e', 'm3'),
                'eeem' : ('e1', 'e2', 'e3', 'm')
}
# maps sample to marker color and marker fill style
samples = { 'TTZ' : ("kGreen-7", "kCyan-2", 21),
            'ZH_ww125' : ("kCyan-7", "kYellow-2", 21),
            'ZH_tt125' : ("kMagenta-7", "kMagenta-2", 21),
            'ZZ' : ("kBlue-7", "kGreen+2", 21),
            'ZZZ' : ("kGreen+7", "kGreen+2", 21),
            'WZZ' : ("kGreen-1", "kGreen+2", 21),
            'WWZ' : ("kGreen+2", "kGreen+2", 21),
            'GGToZZ2L2L' : ("kRed-7", "kRed-2", 21), 
            'Zjets' : ("kYellow-7", "kMagenta+1", 21),
            'AZh300' : ("kBlue", "kBlue", 21),
            'data_obs' : ("","")
}

variables_map = {'LT_Higgs' : (20, 200, "L_{T} #tau1 #tau2", "(GeV)", "x"),
                 'Mass' : (40, 800, "Visible Mass_{l^{+}l^{-}#tau^{+}#tau^{-}}", "(GeV)", "x"),
                 #'Mass' : (20, 200, "SM higgs Visible Mass", "(GeV)", "h"),
                 #'Mass' : (20, 200, "Z Mass", "(GeV)", "z"),
                 'mva_metEt' : (15, 300, "mva metEt", "(GeV)", "x"),
                 'A_SVfitMass' : (20, 800, "Mass_{l^{+}l^{-}#tau^{+}#tau^{-}}", "(GeV)", "x"),
                 'SVfitMass' : (30, 300, "#tau1 #tau2 Mass", "(GeV)", "h"),
                 #'DR' : (20, 10, "dR of #tau1 #tau2", "(GeV)", "h"),
                 'DR' : (20, 10, "dR of lepton1 lepton2", "radians", "z"),
                 'Pt' : (15, 300, "temp", "(GeV)", 0),
                 #'Pt' : (20, 100, "#tau1 Pt", "(GeV)", 2),
                 #'Pt' : (20, 100, "lepton1 lepton2 Vector Sum Pt", "(GeV)", "z"),
                 #'Pt' : (20, 100, "#tau1 #tau2 Vector Sum Pt", "(GeV)", "h"),
}

#variables = ['Pt','Mass','DR','LT_Higgs','mva_metEt','A_SVfitMass','SVfitMass']

AllChannels = ['mmtt', 'eett', 'mmmt', 'eemt', 'mmet', 'eeet', 'mmme', 'eeem']
ZChannelsEE = ['eett', 'eemt', 'eeet', 'eeem']
ZChannelsMM = ['mmtt', 'mmmt', 'mmet', 'mmme']
hChannelsEM = ['eeem', 'mmme']
hChannelsET = ['eeet', 'mmet']
hChannelsMT = ['eemt', 'mmmt']
hChannelsTT = ['eett', 'mmtt']

#            Channel str     Channel List, List for varialbes_map and title for the associated histo
run_map = { "AllChannels" : (AllChannels, ('Mass', 'Visible Mass_{l^{+}l^{-}#tau^{+}#tau^{-}}', 'all'),
                                          ('Mass', 'Visible Mass_{#tau^{+}#tau^{-}}', 'h'),
                                          ('Mass', 'Mass_{l^{+}l^{-}}', 'z'),
                                          ('LT_Higgs', 'L_{T} #tau1 #tau2', 'all'),
                                          ('mva_metEt', 'mva metEt', 'all'),
                                          ('A_SVfitMass', 'Mass_{l^{+}l^{-}#tau^{+}#tau^{-}}', 'all'),
                                          ('SVfitMass', 'Mass_{#tau^{+}#tau^{-}}', 'h'),
                                          ('Pt', '#tau1 Pt', 2),
                                          ('Pt', '#tau2 Pt', 3),
                                          ('Pt', 'Lepton1 Pt', 0),
                                          ('Pt', 'Lepton2 Pt', 1),
                                          ('Pt', 'Vector Sum Pt_{#tau^{+}#tau^{-}}', 'h'),
                                          ('Pt', 'Vector Sum Pt_{l^{+}l^{-}}', 'z'), ),
            "ZChannelsEE" : (ZChannelsEE, ('Mass', 'Visible Mass_{l^{+}l^{-}#tau^{+}#tau^{-}}', 'all'),
                                          ('Mass', 'Mass_{l^{+}l^{-}}', 'z'),
                                          ('mva_metEt', 'mva metEt', 'all'),
                                          ('A_SVfitMass', 'Mass_{l^{+}l^{-}#tau^{+}#tau^{-}}', 'all'),
                                          ('Pt', 'Lepton1 Pt', 0),
                                          ('Pt', 'Lepton2 Pt', 1),
                                          ('Pt', 'Vector Sum Pt_{l^{+}l^{-}}', 'z'), ),
            "ZChannelsMM" : (ZChannelsMM, ('Mass', 'Visible Mass_{l^{+}l^{-}#tau^{+}#tau^{-}}', 'all'),
                                          ('Mass', 'Mass_{l^{+}l^{-}}', 'z'),
                                          ('mva_metEt', 'mva metEt', 'all'),
                                          ('A_SVfitMass', 'Mass_{l^{+}l^{-}#tau^{+}#tau^{-}}', 'all'),
                                          ('Pt', 'Lepton1 Pt', 0),
                                          ('Pt', 'Lepton2 Pt', 1),
                                          ('Pt', 'Vector Sum Pt_{l^{+}l^{-}}', 'z'), ),
            "hChannelsEM" : (hChannelsEM, ('Mass', 'Visible Mass_{l^{+}l^{-}#tau^{+}#tau^{-}}', 'all'),
                                          ('Mass', 'Visible Mass_{#tau^{+}#tau^{-}}', 'h'),
                                          ('LT_Higgs', 'L_{T} #tau1 #tau2', 'all'),
                                          ('mva_metEt', 'mva metEt', 'all'),
                                          ('A_SVfitMass', 'Mass_{l^{+}l^{-}#tau^{+}#tau^{-}}', 'all'),
                                          ('SVfitMass', 'Mass_{#tau^{+}#tau^{-}}', 'h'),
                                          ('Pt', '#tau1 Pt', 2),
                                          ('Pt', '#tau2 Pt', 3),
                                          ('Pt', 'Vector Sum Pt_{#tau^{+}#tau^{-}}', 'h'), ),
            "hChannelsET" : (hChannelsET, ('Mass', 'Visible Mass_{l^{+}l^{-}#tau^{+}#tau^{-}}', 'all'),
                                          ('Mass', 'Visible Mass_{#tau^{+}#tau^{-}}', 'h'),
                                          ('LT_Higgs', 'L_{T} #tau1 #tau2', 'all'),
                                          ('mva_metEt', 'mva metEt', 'all'),
                                          ('A_SVfitMass', 'Mass_{l^{+}l^{-}#tau^{+}#tau^{-}}', 'all'),
                                          ('SVfitMass', 'Mass_{#tau^{+}#tau^{-}}', 'h'),
                                          ('Pt', '#tau1 Pt', 2),
                                          ('Pt', '#tau2 Pt', 3),
                                          ('Pt', 'Vector Sum Pt_{#tau^{+}#tau^{-}}', 'h'), ),
            "hChannelsMT" : (hChannelsMT, ('Mass', 'Visible Mass_{l^{+}l^{-}#tau^{+}#tau^{-}}', 'all'),
                                          ('Mass', 'Visible Mass_{#tau^{+}#tau^{-}}', 'h'),
                                          ('LT_Higgs', 'L_{T} #tau1 #tau2', 'all'),
                                          ('mva_metEt', 'mva metEt', 'all'),
                                          ('A_SVfitMass', 'Mass_{l^{+}l^{-}#tau^{+}#tau^{-}}', 'all'),
                                          ('SVfitMass', 'Mass_{#tau^{+}#tau^{-}}', 'h'),
                                          ('Pt', '#tau1 Pt', 2),
                                          ('Pt', '#tau2 Pt', 3),
                                          ('Pt', 'Vector Sum Pt_{#tau^{+}#tau^{-}}', 'h'), ),
            "hChannelsTT" : (hChannelsTT, ('Mass', 'Visible Mass_{l^{+}l^{-}#tau^{+}#tau^{-}}', 'all'),
                                          ('Mass', 'Visible Mass_{#tau^{+}#tau^{-}}', 'h'),
                                          ('LT_Higgs', 'L_{T} #tau1 #tau2', 'all'),
                                          ('mva_metEt', 'mva metEt', 'all'),
                                          ('A_SVfitMass', 'Mass_{l^{+}l^{-}#tau^{+}#tau^{-}}', 'all'),
                                          ('SVfitMass', 'Mass_{#tau^{+}#tau^{-}}', 'h'),
                                          ('Pt', '#tau1 Pt', 2),
                                          ('Pt', '#tau2 Pt', 3),
                                          ('Pt', 'Vector Sum Pt_{#tau^{+}#tau^{-}}', 'h'), ),
}

for key in run_map.keys():
    if key == "AllChannels": pass
    else: break
    #print key
    nPlots = len( run_map[key] )
    for i in range(1, nPlots):
        variable = run_map[key][i][0]
        #print variable
        if variable == 'Mass' and run_map[key][i][2] != 'all':
            varRange = 300
            varBin = 30
        else:
            varRange = variables_map[variable][1]
            varBin = variables_map[variable][0]
        my_total = ROOT.THStack("my_total", "CMS Preliminary, Red + Irr bgk & Data, 19.7 fb^{-1} at S=#sqrt{8} TeV")
        my_shapes = ROOT.TFile("results/2014-02-28_8TeV_Ntuples-v2/cards/shapes.root", "r")
        #my_shapes = ROOT.TFile("shapes_Nov18_0.root", "r")
        my_data = ROOT.TH1F("my_data", "Data", varBin, 0, varRange)
        my_ZH_ww125 = ROOT.TH1F("my_ZH_ww125", "ZH_ww125", varBin, 0, varRange)
        my_ZH_tt125 = ROOT.TH1F("my_ZH_tt125", "ZH_tt125", varBin, 0, varRange)
        my_TTZ = ROOT.TH1F("my_TTZ", "TTZ", varBin, 0, varRange)
        my_GGToZZ2L2L = ROOT.TH1F("my_GGToZZ2L2L", "GGToZZ2L2L", varBin, 0, varRange)
        my_ZZ = ROOT.TH1F("my_ZZ", "ZZ", varBin, 0, varRange)
        my_ZZZ = ROOT.TH1F("my_ZZZ", "ZZZ", varBin, 0, varRange)
        my_WZZ = ROOT.TH1F("my_WZZ", "WZZ", varBin, 0, varRange)
        my_WWZ = ROOT.TH1F("my_WWZ", "WWZ", varBin, 0, varRange)
        my_Zjets = ROOT.TH1F("my_Zjets", "Zjets (Red bkg)", varBin, 0, varRange)
        my_A300 = ROOT.TH1F("my_A300", "%i x A300, xsec=1fb" % A300Scaling, varBin, 0, varRange)
        
        for sample in ['ZH_ww125', 'ZH_tt125', 'TTZ', 'GGToZZ2L2L', 'ZZ', 'Zjets', 'data_obs', 'AZh300', 'ZZZ', 'WZZ', 'WWZ']:
            #print sample
            my_red_combined = ROOT.THStack("%s combined" % sample, "%s combined" % sample)
        
            for channel in run_map[key][0]:
                if run_map[key][i][2] == "all":
                    if variable == 'A_SVfitMass': sampVar = sample
                    else: sampVar = sample + "_" + variable
                elif run_map[key][i][2] == "z":
                    first = products_map[channel][0]
                    second = products_map[channel][1]
                    sampVar = "%s_%s_%s_%s" % (sample, first, second, variable)
                elif run_map[key][i][2] == "h":
                    first = products_map[channel][2]
                    second = products_map[channel][3]
                    sampVar = "%s_%s_%s_%s" % (sample, first, second, variable)
                else:
                    first = products_map[channel][ run_map[key][i][2] ]
                    sampVar = "%s_%s%s" % (sample, first, variable)
                my_red = my_shapes.Get("%s_zh/%s" % (channel, sampVar) )
                #print "Bin#: %i" % my_red.GetSize()
                #print "Max: %f" % ((my_red.GetSize() - 2) * my_red.GetBinWidth(1))
                #try: my_red.GetEntries()
                #except AttributeError:
                #    print sampVar + 'in channel ' + channel + 'has problems'
                #    continue
                ##c1 = ("c1", "a canvas")
                c1 = plotter.getCanvas()
                #plotter.setTDRStyle(c1, 19.7, 8, "left") 
                pad1 = ROOT.TPad("pad1","",0,0,1,1) # compare distributions
                pad1.Draw()    
                pad1.cd() 
                pad1.SetGrid()
                my_red.Draw("%s_%s" % (sampVar, channel) )
                if run_map[key][i][0] == 'Pt': my_red.Rebin(4)
                if run_map[key][i][0] == 'mva_metEt': my_red.Rebin(2)
                #if run_map[key][i][0] == 'Mass' and run_map[key][i][2] == 'all': my_red.Rebin(4)
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
            
            #c2 = ROOT.TCanvas("c2", "a canvas")
            c2 = plotter.getCanvas()
            plotter.setTDRStyle(c2, 19.7, 8, "left") 
            pad2 = ROOT.TPad("pad2","",0,0.2,1,1) # compare distributions
            pad2.Draw()
            pad2.cd()
            my_red_combined.GetStack().Last().Draw()
            #my_red_combined.GetStack().Last().GetXaxis().SetTitle("%s (GeV), combined" % variable)
            #pad2.SetGrid() 
            #c2.SaveAs("/afs/hep.wisc.edu/home/truggles/public_html/A_to_Zh_Plots/background_comparisons/%s/combined.png" % sample)

            ROOT.gStyle.SetTitleOffset(1.15, "x")
            ROOT.gPad.Modified()
            ROOT.gPad.Update()
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
                    binsToNull = [lowBlind]#, lowBlind + 1, lowBlind + 2]#,lowBlind + 3,lowBlind + 4, lowBlind + 5]
                    #tGraph = ROOT.TGraph( my_data, "e1")
                    for bin in binsToNull:
                        my_data.SetBinError(bin, 0)
                        my_data.SetBinContent(bin, 0)
            if sample == 'AZh300':
                my_A300.Add( my_red_combined.GetStack().Last().Clone() )
                my_A300.Scale( A300Scaling )
            if sample != 'data_obs' and sample != 'AZh300':
                color = "ROOT.%s" % samples[sample][0]
                fillColor = "ROOT.%s" % samples[sample][1]
        	my_red_combined.GetStack().Last().SetFillColor( eval(color) )
                my_red_combined.GetStack().Last().SetLineColor( eval(color) )
                call = "my_%s.Add ( my_red_combined.GetStack().Last().Clone() )" % sample
                eval( call )
                call = "my_%s.SetFillColor( eval(color) )" % sample
                eval( call )
                call = "my_%s.SetFillStyle( 1001 )" % sample
                eval( call )
                call = "my_%s.Clone()" % sample
                my_total.Add( eval( call ), "hist" )
        
        c3 = plotter.getCanvas() # Use Kenneth's canvas setup
        pad5 = ROOT.TPad("pad5","",0,0,1,1) # compare distributions
        pad5.Draw()
        pad5.SetGridy(1)
        pad5.cd()
        my_total.Draw("hist")
        my_total.GetYaxis().SetTitle("Events / %i %s" % ( (variables_map[variable][1]/variables_map[variable][0]), variables_map[variable][3] ) )
        my_total.GetXaxis().SetTitle("%s %s" % (run_map[key][i][1], variables_map[variable][3]) )
        my_A300.SetLineWidth(2)
        my_A300.SetLineColor(ROOT.kOrange+10)
        my_A300.Draw("hist same")
        if my_data.GetMaximum() > my_total.GetMaximum():
          my_total.SetMaximum( 1.3 * my_data.GetMaximum() )
        else: my_total.SetMaximum( 1.3 * my_total.GetMaximum() )
        my_A300.SetStats(0)
        #print "My Total Int: %f" % my_total.GetStack().Last().Integral()
        my_data.Draw("e1 same")
        my_data.SetMarkerStyle(21)
        my_data.SetMarkerSize(.8)
        leg = pad5.BuildLegend(0.60, 0.55, 0.93, 0.89)
        leg.SetMargin(0.3)
        leg.SetFillColor(0)
        leg.SetBorderSize(0)
        leg.Draw()
        fileName = "%s/%s_%s" % ( key, run_map[key][i][2], run_map[key][i][0])

        #c3.SaveAs("/afs/hep.wisc.edu/home/truggles/public_html/A_to_Zh_Plots/background_comparisons/total_bkg_%s.pdf" % saveVar)
        txtLow = 5
        if run_map[key][i][0] == 'Mass':
            my_total.GetXaxis().SetRange(0, 36)
        if run_map[key][i][0] == 'Mass' and run_map[key][i][2] == "z":
            my_total.GetXaxis().SetRange(5, 15)
        #pad5.SetLogy()        
        plotter.setTDRStyle(c3, 19.7, 8, "left") 

        ''' Adjusts the location of the X axis title,
        this is difficult because you can't accest a THStacks'
        axis titles '''
        ROOT.gStyle.SetTitleOffset(1.15, "x")
        ROOT.gPad.Modified()
        ROOT.gPad.Update()

        c3.SaveAs("/afs/hep.wisc.edu/home/truggles/public_html/A_to_Zh_Plots/background_comparisons/%s.pdf" % fileName)
#        if run_map[key][i][0] == 'mva_metEt':
#            pad5.SetLogy()
#            my_total.SetMinimum( 0.001 )
#
#        if txtLabel:
#            if key == 'AllChannels': chan = "All"
#            else: chan = key[0] + ' = ' + key[-2] + key[-1]
#            txt = ROOT.TText(txtLow, my_data.GetMaximum()*1.2, "Channels: %s" % chan )
#            #txt.Draw()
#
#            c3.SaveAs("/afs/hep.wisc.edu/home/truggles/public_html/A_to_Zh_Plots/background_comparisons/%s_log.png" % fileName)
        pad5.Close()
        c3.Close()
