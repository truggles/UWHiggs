import ROOT

infile  = ROOT.TFile("AZh300_8TeV_messaround.root", "READ")

outfile = ROOT.TFile("AZh300_8TeV_new.root", 'RECREATE')

intree  = ROOT.TTree("BG_Tree", "A tree for testing")
outtree = ROOT.TTree("BG_Tree", "A tree for testing")

ntuple = infile.Get("BG_Tree")

for row in ntuple:
	#print "Consider evt: "  
	#print row.Event_
	if row.l4Pt_ > 20:
		outtree.AddBranchToCache(intree.GetBranch("BG_TREE"))
		outtree.Fill()

infile.Close()
outfile.Close()
