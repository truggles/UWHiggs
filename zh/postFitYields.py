#!/usr/bin/env python
from ROOT import gROOT
from ROOT import gStyle
import ROOT
import os
import pyplotter.plot_functions as plotter
import math

cardsDir = 'cardsMF'
mass = '300'
variable = "A_SVfitMass"

pre = ROOT.TFile("%s/shapes.root" % cardsDir, "r")
ofile = open("postFitNormalization.txt", 'w')
ofile.write("%12s %12s %14s %14s %14s %14s\n" % (title[0], title[1], title[2], title[3], title[4], title[5] ) )

title = ['Channel', 'Sample', 'Pre-Yield', 'Post-Yield', 'Pre/Post', 'Post/Pre']

AllChannels = ['mmtt', 'eett', 'mmmt', 'eemt', 'mmet', 'eeet', 'mmme', 'eeem']
for sample in ['ZH_ww125', 'ZH_tt125', 'TTZ', 'GGToZZ2L2L', 'ZZ', 'Zjets', 'ZZZ', 'WZZ', 'WWZ']:
#    print sample
    inc = 0
    for channel in AllChannels:
#        print channel
        writer = '%12s %12s' % (sample, channel)
        preHist = pre.Get("%s_zh/%s" % (channel, sample) )
        preInt = round( preHist.Integral(), 5)

        post = ROOT.TFile("%s/%s/%s/mlfit.root" % (cardsDir, channel, mass), "r")
        postHist = post.Get("shapes_fit_s/%s_zh/%s" % (channel, sample) )
        if postHist == None:
            postInt = 0
        else:
            postInt = round(postHist.Integral(), 5)
        if postInt > 0:
            preOverPost = round(preInt / postInt, 5)
            postOverPre = round( postInt / preInt, 5)
        else:
            preOverPost = "NAN"
            postOverPre = "NAN"
        ofile.write( "%s %14s %14s %14s %14s\n" % (writer, preInt, postInt, preOverPost, postOverPre) )
ofile.close()
