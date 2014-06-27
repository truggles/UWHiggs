import ROOT

root_files = open("zIDTest.txt", "r")

dupEvts = []
dups = open("dup.txt" , 'r')
for line in dups:
  line = line.strip()
  info = line.split(':')
  dupEvts.append((float(info[0]),float(info[1]),float(info[2])))
#print dupEvts
#m12_tally, m13_tally, m23_tally = 0, 0, 0

eventID = []
num_eventID = 0.0
iii = 0
dup_tally = 0

for line in root_files:

	input_file = ROOT.TFile(line.strip(), "READ")
	ntuple = input_file.Get("Ntuple")
	#print(line)
	for row in ntuple:
		iii += 1
                #num_eventID = (row.run, row.lumi, row.evt1*10**5 + row.evt2)
		num_eventID = (row.run, row.lumi, row.evt)
		if (num_eventID in eventID):
			dup_tally += 1
                        #print num_eventID
		else: 
                  eventID.append(num_eventID)
                  if num_eventID not in dupEvts:
                    print num_eventID
		#print num_eventID
		#print "evt 1: %f" % row.evt1
		#print "evt 2: %f" % row.evt2	
	print "Dup %i " % dup_tally
	print "Events %i " % iii
        dup_tally, iii = 0, 0

print "Dup %i " % dup_tally
print "Events %i " % iii
print "Number of unique events: %i" % len(eventID)



'''print("Finale is closest to Z mass?")
print("m12 count: %i" % m12_tally)
print("m13 count: %i" % m13_tally)
print("m23 count: %i" % m23_tally)
'''

