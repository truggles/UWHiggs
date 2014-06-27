import ROOT
import os
from FinalStateAnalysis.MetaData.data_views import extract_sample, read_lumi
import math
import sys

jobid = "2014-02-28_8TeV_Ntuples-v2"


channels = ["MMMT", "MMET", "MMEM", "MMTT", "EEMT", "EEET", "EEEM", "EETT"]
if (len(sys.argv) == 2):
  channels = [sys.argv[1]]

dict_prods = { 'MMMT' : ('m1','m2','m3','t'),
              'MMET' : ('m1','m2','e','t'),
              'MMEM' : ('m1','m2','e','m3'),
              'MMTT' : ('m1','m2','t1','t2'),
              'EEMT' : ('e1','e2','m','t'),
              'EEET' : ('e1','e2','e3','t'),
              'EEEM' : ('e1','e2','e3','m'),
              'EETT' : ('e1','e2','t1','t2')
}

channel_map = { 'MMTT' : 1,
                'EETT' : 5,
                'MMMT' : 3,
                'EEMT' : 6,
                'MMET' : 2,
                'EEET' : 7,
                'MMEM' : 4,
                'EEEM' : 8,
}

def make_control_plot(prods, variable, cvariable, xaxis_title, rbin, nbins, xlow, xhigh,blinded=False,strip=False):

  ofile = ROOT.TFile("plots.root", "RECREATE")
  fullsim = ROOT.TH1F("fullsim", "fullsim", nbins, xlow, xhigh)

  for channel in channels:
  #for i in range(1):
    
    label = ""
    prods_avail = dict_prods[channel]
    #print prods_avail
    for prod in prods:
      label += "%s_" % prods_avail[prod-1] # zero indexed
    if strip:
      label = label[:-1]
    label += variable

    fullsim_file = ROOT.TFile("results/%s/ZHAnalyze%s/A300-Zh-lltt-FullSim.root" % (jobid, channel), "READ")
    fullsim_tmp = fullsim_file.Get("os/All_Passed/%s" % label)
    print label
    fullsim.Add(fullsim_tmp)
    
    fullsim_file.Close()

    #fullsim_f = ROOT.TFile("common_events.root", "READ")
    #fullsim_ntuple = fullsim_f.Get("os/All_Passed/Event_ID")
    #fullsim_tmp = fullsim_f.Get(label)
    #fullsim.Add(fullsim_tmp)
    

  #ROOT.gROOT.SetBatch(True)
  canvas = ROOT.TCanvas("canvas", "canvas")

  pad1 = ROOT.TPad("pad1","",0,0.2,1,1) # compare distributions
  pad2 = ROOT.TPad("pad2","",0,0,1,0.2) # ratio plot
  pad1.Draw()
  pad2.Draw()

  pad1.cd()

  ROOT.gStyle.SetOptStat(0)
  fullsim.SetStats(0)
  fullsim.Rebin(rbin)  
  fullsim.SetMaximum(fullsim.GetMaximum()*1.8)

  if (variable == 'SVfitMass'):
    fullsim.GetXaxis().SetRangeUser(0, 125)

  if len(channels) == 1:
    fullsim.GetXaxis().SetTitle(xaxis_title + " " + channels[0])
  else:  fullsim.GetXaxis().SetTitle(xaxis_title)
  fullsim.GetYaxis().SetTitle("Events / %0.1f GeV" % ( (1.0*xhigh - xlow)/nbins * rbin) )

  fullsim.SetLineColor(ROOT.kRed+2)   
 
  fullsim.Draw("hist")
  #cecile_hist = fullsim.Clone("cecile_hist")
  cecile_hist = ROOT.TH1F()
  cecile_file = ROOT.TFile("For_Stephane/AZh300_8TeV.root", "READ")
  if (len(channels) > 2): 
    # running on all channels combined
    cecile_ntuple = cecile_file.Get("BG_Tree")
    #print "%s>>cecile_hist" % cvariable
    ofile.cd()
    #string = "%s>>cecile_hist" % cvariable
    #print "cecile_ntuple.Draw(%s, subChannel_==3)" % string
    cecile_ntuple.Draw("%s>>cecile_hist" % cvariable, "subChannel_==3","same")
    cecile_hist = ROOT.gDirectory.Get("cecile_hist")
    #os.system("sleep 1")
    #canvas.cd()
    #canvas.Close()
    #os.system("sleep 2")
    #print "now drawing cecile_hist"
    #cecile_hist = ofile.Get("cecile_hist")
    #cecile_hist.Draw()
    #os.system("sleep 5")

  #elif (cvariable == 'SVMass_'):
  #  ofile.cd()
  #  if (channels[0]=='MMEM'):
  #    cecile_hist = cecile_file.Get("SVMass_mmme_pp" )
  #  else: cecile_hist = cecile_file.Get("SVMass_%s_pp" % channels[0].lower() )
  #  ofile.Write("cecile_hist")
  #  cecile_hist.Rebin(rbin)
  #  #cecile_hist.Draw("EP same")   

  else: 
    cecile_ntuple = cecile_file.Get("BG_Tree")
    ofile.cd()
    cecile_ntuple.Draw("%s>>cecile_hist" % cvariable, "subChannel_==3&&Channel_==%i" % channel_map[channels[0]],"same")
    cecile_hist = ROOT.gDirectory.Get("cecile_hist")
    print "Cecile's number of events is %f" % cecile_ntuple.GetEntries("subChannel_==3&&Channel_==%i" % channel_map[channels[0]])

  
  ofile.cd()
  #ofile.ls()
  #cecile_hist.Rebin(rbin)
  print "My number of events is %f" % fullsim.Integral()
  fullsim.Draw("hist")

  #if len(channels) < 2:
  #  # Cecile's individual channel mass shapes are weighted, let's remove that
  #  cecile_hist.Scale( cecile_hist.GetEntries()/cecile_hist.Integral() )
  print "Cecile's number of events is %f" % cecile_hist.Integral()
  cecile_hist.Draw("EP same")
  
  

  l1 = ROOT.TLegend(0.60,0.73,0.70,0.93,"")
  l1.AddEntry(fullsim, "Wisconsin", "l")
  l1.AddEntry(cecile_hist, "ULB", "l")
  #l1.AddEntry(cecile_ntuple, "Cecile A to Zh", "l")
  #l1.AddEntry(signal, "A->Zh (mA=%s GeV)" % mass,"l")
  l1.SetBorderSize(0)
  l1.SetFillColor(0)
  l1.SetTextSize(0.03)
  l1.Draw() 

  pad2.cd() # make ratio plot
 
  HDiff = fullsim.Clone("HDiff")
  HDiff.Divide(cecile_hist)
  #HDiff.GetYaxis().SetRangeUser(0.9,1.1)
  #HDiff.GetYaxis().SetRangeUser(0.98,1.02)
  HDiff.GetYaxis().SetRangeUser(0.5, 1.5)
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
  

  prod_label = ""
  for p in prods:
    prod_label += str(p)
  ofile.cd()
  canvas.Write()
  if (len(sys.argv) == 2):
    canvas.SaveAs("sync_shapes/%s/%s%s.png" % (channel, prod_label, variable) )
  else: canvas.SaveAs("sync_shapes/combined/%s%s.png" % (prod_label, variable) )
  os.system("sleep 1")

  canvas.Close()
  cecile_file.Close()
  ofile.Close()

#make_control_plot(prods, variable, cvariable, xaxis_title, rbin, nbins, xlow, xhigh, blinded=False, stripped=False)

# ZH system plots
#make_control_plot((), 'Mass', "A Visible Mass", 40, 800, 0, 800,True)
make_control_plot((), 'A_SVfitMass','SVMass_', "A SV-fit Mass", 40, 800, 0, 800,True)
#make_control_plot((), 'weight', 'pu_Weight_', "Event Weight", 1, 100, 0, 5)

# di-tau plots
#make_control_plot((3,4), 'Mass', "#tau#tau Visible Mass", 10, 200, 0, 200, True)
#make_control_plot((3,4), 'SVfitMass', 'HMass_', "#tau#tau SV-fit Mass", 10, 300, 0, 300,True)
#make_control_plot((3,4), 'Eta', "#tau#tau #eta", 10, 100, -2.4, 2.4)
#make_control_plot((3,4), 'DR', "#tau#tau #deltaR", 10, 100, 0, 10)
#make_control_plot((3,4), 'DPhi', "#tau#tau #delta#phi", 10, 180, 0, 7)
#make_control_plot((3,4), 'Pt', "#tau#tau p_{T}", 10, 100, 0, 100)

# Z plots
#make_control_plot((1,2), 'Pt', 'Z p_{T}', 10, 100, 0, 100)
make_control_plot((1,2), 'Mass', 'HMass_', 'Z Mass', 10, 200, 0, 200,True)
#make_control_plot((1,2), 'DR', "Z products #deltaR", 10, 100, 0, 10)
#make_control_plot((1,2), 'DPhi', "Z products #delta#phi", 10, 180, 0, 7) 

# tau 1, tau 2 plots
make_control_plot((3,), 'Eta', 'l3Eta_', '#tau_{1} #eta', 10, 200, -2.4, 2.4,False,True)
make_control_plot((4,), 'Eta', 'l4Eta_', '#tau_{2} #eta', 10, 200, -2.4, 2.4,False,True)
make_control_plot((3,), 'Pt', 'l3Pt_', '#tau_{1} p_{T}', 10, 100, 0, 100,False,True)
make_control_plot((4,), 'Pt', 'l4Pt_', '#tau_{2} p_{T}', 10, 100, 0, 100,False,True)
make_control_plot((3,), 'JetPt', 'l3_CloseJetPt_', 'Closest jet p_{T}', 10, 100, 0, 200, False, True)
make_control_plot((4,), 'JetPt', 'l4_CloseJetPt_', 'Closest jet p_{T}', 10, 100, 0, 200, False, True) 
