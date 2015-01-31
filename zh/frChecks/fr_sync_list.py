import ROOT


channels = ['ZLT', 'EEET', 'EEMT'] #, 'MMET', 'MMMT']

totalDup = 0

for channel in channels:
    #ifile = ROOT.TFile("results/2014-02-28_8TeV_Ntuples-v2/TauFakeRates%s/ggZZ2L2L.root" % channel, "READ" )
    ifile = ROOT.TFile("results/2014-02-28_8TeV_Ntuples-v2/TauFakeRates%s/data_DoubleElectron_Run2012D_22Jan2013_v1.root" % channel, "READ" )
    ofile = open("fr_sync_list_%s.txt" % channel, 'w')
    #ifile = ROOT.TFile("results/2014-02-28_8TeV_Ntuples-v2/TauFakeRatesZLT/data_DoubleMuParked_Run2012D_22Jan2013_v1.root", "READ" )
    ntuple = ifile.Get("Event_ID")
    
    evtSet = set()
    duplicatesCh = 0
    
    for row in ntuple:
        evtTuple = (row.run,row.lumi,(row.evt1*10**5 + row.evt2), row.NumDenomCode)
        #if evtTuple in evtSet:# and row.NumDenomCode != 0 and row.NumDenomCode != 10:
        if evtTuple in evtSet and row.NumDenomCode != 1 and row.NumDenomCode != 2 and row.NumDenomCode != 11 and row.NumDenomCode != 12:
            #print "Duplicate!: %i %i %i %i" % (row.run,row.lumi,(row.evt1*10**5 + row.evt2), row.NumDenomCode)
            ofile.write("%i %i %i\n" % (row.run,row.lumi,(row.evt1*10**5 + row.evt2))) #pick_FSA friendly
            duplicatesCh = duplicatesCh + 1
            totalDup = totalDup + 1
        else:
            evtSet.add(evtTuple)
    
    print "Total duplicates in channel %s = %i" % (channel, duplicatesCh)
print "TOTAL duplicates = %i" % totalDup
print "Unique Events: %i" % len(evtSet)
