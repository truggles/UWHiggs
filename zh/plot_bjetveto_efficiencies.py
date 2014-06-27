import ROOT

#signal_mmtt = ROOT.TFile("results/2013-10-02-8TeV-v2-MSSM_A_ZH_mmtt/ZHAnalyzeMMTT/MSSM_A_ZH_mmtt.root","READ")
#signal_mmmt = ROOT.TFile("results/2013-10-02-8TeV-v2-MSSM_A_ZH_mmtt/ZHAnalyzeMMMT/MSSM_A_ZH_mmtt.root","READ")
#signal_mmet = ROOT.TFile("results/2013-10-02-8TeV-v2-MSSM_A_ZH_mmtt/ZHAnalyzeMMET/MSSM_A_ZH_mmtt.root","READ")
#signal_mmem = ROOT.TFile("results/2013-10-02-8TeV-v2-MSSM_A_ZH_mmtt/ZHAnalyzeMMEM/MSSM_A_ZH_mmtt.root","READ")

fout = ROOT.TFile("efficiency_plots/bjetvetozhlike/MSSM_A_ZH_mmtt.root", "RECREATE")

for channel,ltmax in [("MMTT",5),("MMET",5), ("MMMT",5), ("MMEM",5)]:

    signal_file = ROOT.TFile("results/2013-10-02-8TeV-v2-MSSM_A_ZH_mmtt/ZHAnalyze%s/MSSM_A_ZH_mmtt.root" % channel,"READ")
    #signal_file = ROOT.TFile("results/2013-10-02-8TeV-v2-MSSM_A_ZH_mmtt/ZHAnalyze%s/ZZJetsTo4L_pythia.root" % channel,"READ")
    #signal_file = ROOT.TFile("results/2013-10-02-8TeV-v2-MSSM_A_ZH_mmtt/ZHAnalyze%s/WZJetsTo3LNu_pythia.root" % channel,"READ")
    h_bjetveto = signal_file.Get("os/All_Passed/bjetCSVVetoZHLikeNoJetId")
    #h_bjetveto = signal_file.Get("os/All_Passed/bjetCSVVeto")
    tot = h_bjetveto.Integral()
    part = h_bjetveto.Integral(ltmax, 10)
    print str(part/tot)
    fout.cd()
    h_bjetveto.Write(channel)

fout.Write()


