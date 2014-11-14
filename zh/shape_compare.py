from ROOT import gROOT
from ROOT import gStyle
import ROOT
import os

samples = { 'TTZJets' : 'TTZ',
            'VHWW' : 'ZH_ww125',
            'VHTauTau' : 'ZH_tt125',
            'ZZJetsTo4L' : 'ZZ',
            'ggZZ2L2L' : 'GGToZZ2L2L',
            'data_obs' : 'data_obs',
            'Zjets' : 'Zjets'
}

my_shapes = ROOT.TFile("results/2014-02-28_8TeV_Ntuples-v2/cards/shapes.root", "r")
official_shapes = ROOT.TFile("/cms/truggles/zh_proj/june23_sync_setup/src/UWHiggs/zh/Nov13_For_Tyler/inputFile_12nov.root", "r")

#my_red_combined = ROOT.THStack("my_red_combined", "combined shape", 20, 0, 800)
#off_red_combined = ROOT.THStack("off_red_combined", "combined shape", 20, 0, 800)
#off_red_combined_2 = ROOT.THStack("off_red_combined_2", "combined shape", 20, 0, 800)

ROOT.gROOT.SetBatch(True)
for sample in ['TTZ', 'ZH_ww125', 'ZH_tt125', 'ZZ', 'GGToZZ2L2L', 'ZZZ', 'WZZ', 'WWZ', 'Zjets', 'data_obs']:

    my_red_combined = ROOT.THStack("my_red_combined", "combined shape")
    off_red_combined = ROOT.THStack("off_red_combined", "combined shape")
    off_red_combined_2 = ROOT.THStack("off_red_combined_2", "combined shape")

    for channel in ['mmtt', 'eett', 'mmmt', 'eemt', 'mmet', 'eeet', 'mmme', 'eeem']:
    #for channel in ["eeem"]:
    #for channel in ["mmmt", "eemt", "mmet", "eeet", "mmme", "eeem"]:
        #my_shapes.cd("%s_zh" % channel)
        #official_shapes.cd("%s_zh" % channel)
        print channel
        my_red = my_shapes.Get("%s_zh/%s" % (channel, sample))

        #''' Normalize histos b/c we don't have properly normalized histos from ULB (9/9/14) '''
        if (my_red.Integral() > 0):
            my_red.Scale( 1/my_red.Integral() )
        off_red = official_shapes.Get("%s_zh/%s" % (channel, sample) )
        if (off_red.Integral() > 0):
            off_red.Scale( 1/off_red.Integral() )
        c1 = ROOT.TCanvas("c1", "a canvas")
        pad1 = ROOT.TPad("pad1","",0,0.2,1,1) # compare distributions
        pad2 = ROOT.TPad("pad2","",0,0,1,0.2) # ratio plot
        pad1.Draw()
        #gStyle.SetOptStat(0)
        pad2.Draw()
    
        pad1.cd() 
        my_red.SetLineColor(ROOT.kRed)
        my_red.SetMarkerColor(ROOT.kRed)
        off_red.GetXaxis().SetTitle(" A SVMass (GeV), %s" % channel)
        #off_red.Sumw2()
        off_red.SetLineColor(ROOT.kBlue)

        off_red.Draw("hist")
        off_red_2 = official_shapes.Get("%s_zh/%s" % (channel, sample) )
        #if off_red_2.Integral() > 0:
        #    off_red_2.Scale( 1/off_red_2.Integral() )
        off_red_2.Draw("AP same")
        my_red.Draw("AP same")

        ''' Set reasonable maximums on histos '''        
        off_red_max = off_red.GetMaximum()
        my_red_max = my_red.GetMaximum()
        if ( off_red.GetMaximum() >= my_red.GetMaximum() ):
            off_red.SetMaximum(1.8 * off_red.GetMaximum() )
            print "off_red_max: %f" % (1.8 * off_red.GetMaximum() )
        else:
            off_red.SetMaximum(1.8 * my_red.GetMaximum() )
            print "my_red_max: %f" % (1.8 * my_red.GetMaximum() )
    
        pad2.cd()
        HDiff = my_red.Clone("HDiff")
        HDiff.Divide(off_red)
        HDiff.SetTitle("")
        #HDiff.GetYaxis().SetRangeUser(0.9,1.1)
        #HDiff.GetYaxis().SetRangeUser(0.98,1.02)
        #HDiff.GetYaxis().SetRangeUser(0.5, 1.5)
        HDiff.GetYaxis().SetRangeUser(0.0, 2.0)
        HDiff.GetYaxis().SetNdivisions(3)
        HDiff.GetYaxis().SetLabelSize(0.1)
        HDiff.GetYaxis().SetTitleSize(0.1)
        HDiff.GetYaxis().SetTitleOffset(0.5)
        HDiff.GetYaxis().SetTitle("Wisconsin / ULB")
        HDiff.GetXaxis().SetNdivisions(-1)
        HDiff.GetXaxis().SetTitle("")
        HDiff.GetXaxis().SetLabelSize(0.0001)
        HDiff.Draw()
        HDiff.SetStats(0)
        line = ROOT.TLine()
        line.DrawLine(HDiff.GetXaxis().GetXmin(),1,HDiff.GetXaxis().GetXmax(),1)
 
        print sample
        print channel   
        c1.SaveAs("/afs/hep.wisc.edu/home/truggles/public_html/A_to_Zh_Plots/shape_comparisons/%s/%s.png" % (sample, channel))
        pad1.Close()
        pad2.Close()
        c1.Close()
            
        gROOT.cd()
        #my_red.SetFillStyle(3004)
        #off_red.SetFillStyle(3005)
        #off_red_2.SetFillStyle(3005)
        new_my_red = my_red.Clone()
        new_off_red = off_red.Clone()
        new_off_red_2 = off_red_2.Clone()
        
        # add to combined shape
        my_red_combined.Add(new_my_red)
        off_red_combined.Add(new_off_red)
        off_red_combined_2.Add(new_off_red_2)
        
    
    c2 = ROOT.TCanvas("c2", "a canvas")
    pad1 = ROOT.TPad("pad1","",0,0.2,1,1) # compare distributions
    pad2 = ROOT.TPad("pad2","",0,0,1,0.2) # ratio plot
    pad1.Draw()
    pad2.Draw()
    
    pad1.cd()
    off_red_combined.GetStack().Last().Draw("hist")
    off_red_combined_2.GetStack().Last().Draw("AP same")
    my_red_combined.GetStack().Last().Draw("AP same")
    
    #my_red_combined.SetLineColor(ROOT.kRed)
    #my_red_combined.SetMarkerColor(ROOT.kRed)
    #my_red_combined.SetTitle(channel)
    off_red_combined.GetStack().Last().GetXaxis().SetTitle(" A SVMass (GeV), combined")
    #off_red_combined.SetLineColor(ROOT.kBlue)
    off_red_combined.GetStack().Last().SetMaximum(1.8 * off_red_combined.GetStack().Last().GetMaximum() )
    #off_red_combined_2.SetLineColor(ROOT.kBlue)
    #off_red_combined_2.SetMarkerStyle(1)
    
    pad2.cd()
    HDiff = my_red.Clone("HDiff")
    HDiff.Divide(off_red)
    HDiff.SetTitle("")
    #HDiff.GetYaxis().SetRangeUser(0.9,1.1)
    #HDiff.GetYaxis().SetRangeUser(0.98,1.02)
    #HDiff.GetYaxis().SetRangeUser(0.5, 1.5)
    HDiff.GetYaxis().SetRangeUser(0.0, 2.0)
    HDiff.GetYaxis().SetNdivisions(3)
    HDiff.GetYaxis().SetLabelSize(0.1)
    HDiff.GetYaxis().SetTitleSize(0.1)
    HDiff.GetYaxis().SetTitleOffset(0.5)
    HDiff.GetYaxis().SetTitle("Wisconsin / ULB")
    HDiff.GetXaxis().SetNdivisions(-1)
    HDiff.GetXaxis().SetTitle("")
    HDiff.GetXaxis().SetLabelSize(0.0001)
    HDiff.Draw()
    HDiff.SetStats(0)
    line = ROOT.TLine()
    line.DrawLine(HDiff.GetXaxis().GetXmin(),1,HDiff.GetXaxis().GetXmax(),1)
    
    c2.SaveAs("/afs/hep.wisc.edu/home/truggles/public_html/A_to_Zh_Plots/shape_comparisons/%s/combined.png" % sample)
    #os.system("sleep 3")
    pad1.Close()
    pad2.Close()
    c2.Close()

