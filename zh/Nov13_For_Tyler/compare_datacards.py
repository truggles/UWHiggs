#!/usr/bin/env python

import os

if __name__ == "__main__":

    from ROOT import *
ROOT.gROOT.SetBatch(True)

def main():
    Fc = TFile("cecile_datacard.root","r")
    Ft = TFile("nov24_shapes.root","r")
    c=TCanvas("c1","c1",600,600)
    gStyle.SetOptStat(0)
    directories=["mmet_zh","mmmt_zh","mmtt_zh","mmme_zh","eeem_zh","eett_zh","eeet_zh","eemt_zh"]
    variables_t=["ZZ","data_obs","Zjets","TTZ","GGToZZ2L2L","ZH_tt125","ZH_ww125","AZh220","AZh230","AZh240","AZh250","AZh260","AZh270","AZh280","AZh290","AZh300","AZh310","AZh320","AZh330","AZh340","AZh350","WWZ","WZZ","ZZZ"]
    for v in range(len(variables_t)):
     for dirr in directories:
       Ft.Get(dirr).Get(variables_t[v]).SetTitle(variables_t[v]+", "+dirr)
       Ft.Get(dirr).Get(variables_t[v]).GetXaxis().SetTitle("m_{A} [GeV]")
       Ft.Get(dirr).Get(variables_t[v]).GetYaxis().SetTitle("Events")
       Ft.Get(dirr).Get(variables_t[v]).SetFillColor(kWhite)
       Ft.Get(dirr).Get(variables_t[v]).SetLineColor(kBlue)
       Ft.Get(dirr).Get(variables_t[v]).Draw("hist")
       Fc.Get(dirr).Get(variables_t[v]).SetLineColor(kRed)
       Fc.Get(dirr).Get(variables_t[v]).SetFillColor(kWhite)
       Fc.Get(dirr).Get(variables_t[v]).Draw("histsame")
       free = TPaveText(0.5,0.7,0.9,0.9,"NDC")
       free.SetFillColor(0)
       free.AddText("Wisconsin: %.3f"%Ft.Get(dirr).Get(variables_t[v]).Integral() )
       free.AddText("ULB: %.3f"%Fc.Get(dirr).Get(variables_t[v]).Integral() )
       free.Draw()
       c.SaveAs("comparaison_shapes/comp_"+dirr+"_"+variables_t[v]+".png")

if __name__ == '__main__':
    main()
