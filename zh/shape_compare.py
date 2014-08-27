from ROOT import gROOT
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
official_shapes = ROOT.TFile("/cms/truggles/zh_proj/june23_sync_setup/src/UWHiggs/zh/For_Tyler/TotalRootForLimit_SVMass__8TeV.root", "r")

#my_red_combined = ROOT.THStack("my_red_combined", "combined shape", 20, 0, 800)
#off_red_combined = ROOT.THStack("off_red_combined", "combined shape", 20, 0, 800)
#off_red_combined_2 = ROOT.THStack("off_red_combined_2", "combined shape", 20, 0, 800)

ROOT.gROOT.SetBatch(True)
for sample in ['Zjets', 'TTZJets', 'VHWW', 'VHTauTau', 'ZZJetsTo4L', 'ggZZ2L2L', 'data_obs']:

    my_red_combined = ROOT.THStack("my_red_combined", "combined shape")
    off_red_combined = ROOT.THStack("off_red_combined", "combined shape")
    off_red_combined_2 = ROOT.THStack("off_red_combined_2", "combined shape")

    for channel in ['mmtt', 'eett', 'mmmt', 'eemt', 'mmet', 'eeet', 'mmme', 'eeem']:
    #for channel in ["eeem"]:
    #for channel in ["mmmt", "eemt", "mmet", "eeet", "mmme", "eeem"]:
        #my_shapes.cd("%s_zh" % channel)
        #official_shapes.cd("%s_zh" % channel)
        print channel
        if (channel == 'mmme'):
            my_red = my_shapes.Get("mmem_zh/%s" % sample)
        else: my_red = my_shapes.Get("%s_zh/%s" % (channel, sample))
        off_red = official_shapes.Get("%s_zh/%s" % (channel, samples[sample]))
        c1 = ROOT.TCanvas("c1", "a canvas")
        pad1 = ROOT.TPad("pad1","",0,0.2,1,1) # compare distributions
        pad2 = ROOT.TPad("pad2","",0,0,1,0.2) # ratio plot
        pad1.Draw()
        pad2.Draw()
    
        pad1.cd() 
        my_red.SetLineColor(ROOT.kRed)
        my_red.SetMarkerColor(ROOT.kRed)
        off_red.GetXaxis().SetTitle(" A SVMass (GeV), %s" % channel)
        #off_red.Sumw2()
        off_red.SetLineColor(ROOT.kBlue)
        #off_red.SetMaximum(1.8 * off_red.GetMaximum() )
        off_red.SetMaximum(4.0 * off_red.GetMaximum() )
        off_red.Draw("hist")
        off_red_2 = official_shapes.Get("%s_zh/%s" % (channel, samples[sample]))
        off_red_2.Draw("AP same")
        my_red.Draw("AP same")
    
        pad2.cd()
        HDiff = my_red.Clone("HDiff")
        HDiff.Divide(off_red)
        #HDiff.GetYaxis().SetRangeUser(0.9,1.1)
        #HDiff.GetYaxis().SetRangeUser(0.98,1.02)
        #HDiff.GetYaxis().SetRangeUser(0.5, 1.5)
        HDiff.GetYaxis().SetRangeUser(0.0, 6)
        HDiff.GetYaxis().SetNdivisions(3)
        HDiff.GetYaxis().SetLabelSize(0.1)
        HDiff.GetYaxis().SetTitleSize(0.1)
        HDiff.GetYaxis().SetTitleOffset(0.5)
        HDiff.GetYaxis().SetTitle("Wisconsin / ULB")
        HDiff.GetXaxis().SetNdivisions(-1)
        HDiff.GetXaxis().SetTitle("")
        HDiff.GetXaxis().SetLabelSize(0.0001)
        HDiff.Draw()
        line = ROOT.TLine()
        line.DrawLine(HDiff.GetXaxis().GetXmin(),1,HDiff.GetXaxis().GetXmax(),1)
    
        #os.system("sleep 3")
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
    #HDiff.GetYaxis().SetRangeUser(0.9,1.1)
    #HDiff.GetYaxis().SetRangeUser(0.98,1.02)
    #HDiff.GetYaxis().SetRangeUser(0.5, 1.5)
    HDiff.GetYaxis().SetRangeUser(0.0, 6.0)
    HDiff.GetYaxis().SetNdivisions(3)
    HDiff.GetYaxis().SetLabelSize(0.1)
    HDiff.GetYaxis().SetTitleSize(0.1)
    HDiff.GetYaxis().SetTitleOffset(0.5)
    HDiff.GetYaxis().SetTitle("Wisconsin / ULB")
    HDiff.GetXaxis().SetNdivisions(-1)
    HDiff.GetXaxis().SetTitle("")
    HDiff.GetXaxis().SetLabelSize(0.0001)
    HDiff.Draw()
    line = ROOT.TLine()
    line.DrawLine(HDiff.GetXaxis().GetXmin(),1,HDiff.GetXaxis().GetXmax(),1)
    
    c2.SaveAs("/afs/hep.wisc.edu/home/truggles/public_html/A_to_Zh_Plots/shape_comparisons/%s/combined.png" % sample)
    #os.system("sleep 3")
    pad1.Close()
    pad2.Close()
    c2.Close()

