import ROOT

#signal_mmtt = ROOT.TFile("results/2013-10-02-8TeV-v2-MSSM_A_ZH_mmtt/ZHAnalyzeMMTT/MSSM_A_ZH_mmtt.root","READ")
#signal_mmmt = ROOT.TFile("results/2013-10-02-8TeV-v2-MSSM_A_ZH_mmtt/ZHAnalyzeMMMT/MSSM_A_ZH_mmtt.root","READ")
#signal_mmet = ROOT.TFile("results/2013-10-02-8TeV-v2-MSSM_A_ZH_mmtt/ZHAnalyzeMMET/MSSM_A_ZH_mmtt.root","READ")
#signal_mmem = ROOT.TFile("results/2013-10-02-8TeV-v2-MSSM_A_ZH_mmtt/ZHAnalyzeMMEM/MSSM_A_ZH_mmtt.root","READ")

fout = ROOT.TFile("efficiency_plots/lt/MSSM_A_ZH_mmtt.root", "RECREATE")

for channel,ltmax in [("MMTT",70),("MMET",25), ("MMMT",35), ("MMEM",35)]:

    signal_file = ROOT.TFile("results/2013-10-02-8TeV-v2-MSSM_A_ZH_mmtt/ZHAnalyze%s/MSSM_A_ZH_mmtt.root" % channel,"READ")
    #signal_file = ROOT.TFile("results/2013-10-02-8TeV-v2-MSSM_A_ZH_mmtt/ZHAnalyze%s/ZZJetsTo4L_pythia.root" % channel,"READ")
    #signal_file = ROOT.TFile("results/2013-10-02-8TeV-v2-MSSM_A_ZH_mmtt/ZHAnalyze%s/WZJetsTo3LNu_pythia.root" % channel,"READ")
    LT_higgs = signal_file.Get("os/All_Passed/LT_Higgs")
    tot = LT_higgs.Integral()
    part = LT_higgs.Integral(ltmax, 200)
    print str(part/tot)
    fout.cd()
    LT_higgs.Write()

fout.Write()


