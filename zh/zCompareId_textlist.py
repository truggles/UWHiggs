import sys

ifile = open(sys.argv[1], 'r')
ofile = open("duplicates.txt", 'w')

channel_map = { '1' : 'MMTT',
                '3' : 'MMMT',
                '6' : 'EEMT',
                '2' : 'MMET',
                '7' : 'EEET',
                '4' : 'MMEM',
                '8' : 'EEEM',
                '5' : 'EETT',
}


evtIDs = [] # list of all unique event id's in the file
channel_dict = {}
dups = 0

for line in ifile:
    line = line.strip()
    info = line.split(' ')
    channel = info[0]
    run = info[1]
    lumi = info[2]
    evtID = info[3]
    t1Pt = info[5]
    t1Eta = info[6]
    t2Pt = info[7]
    t2Eta = info[8]
    zMass = info[4]
    #tuple = (channel, run, lumi, evtID)
    tuple = (run, lumi, evtID)
    #print (channel, run, lumi, evtID)
    #if (evtID == '48411'):
        #print tuple
    pTuple =(channel, run, lumi, evtID, t1Pt, t1Eta, t2Pt, t2Eta, zMass)

    if not tuple in evtIDs:
        evtIDs.append(tuple)
        channel_dict[tuple] = channel_map[channel]
    else:
        dups += 1
        if channel == '5':
          ofile.write("%s:%s:%s\n" % (run, lumi, evtID))
        #print "%s event also %s" % (channel_dict[tuple], channel_map[channel])
        #print evtID
        #print "%s %s %s %s %s %s %s %s %s" % (pTuple[0],pTuple[1],pTuple[2],pTuple[3],pTuple[4],pTuple[5],pTuple[6],pTuple[7],pTuple[8]) 
        print "%s,%s,%s,%s,%s,%s,%s,%s,%s" % (pTuple[0],pTuple[1],pTuple[2],pTuple[3],pTuple[4],pTuple[5],pTuple[6],pTuple[7],pTuple[8]) # comma delimited, for excel pasting 
print "%i duplicates out of %i unique events" % (dups, len(evtIDs))
