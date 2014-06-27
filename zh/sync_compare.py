import sys

my_file = open(sys.argv[1], 'r')
cecile_file = open(sys.argv[2], 'r')
#channel = sys.argv[3]
channel_map = { '1' : 'MMTT',
                '5' : 'EETT',
                '3' : 'MMMT',
                '6' : 'EEMT',
                '2' : 'MMET',
                '7' : 'EEET',
                '4' : 'MMEM',
                '8' : 'EEEM',
}


#print "Now analyzing channel %s" % channel_map[channel]
my_events = []
for line in my_file:
    evt = line.split(' ')
    #evt.pop()
    #evt.pop()
    #if (evt[0] == channel):
    my_events.append(evt)

#cecile_file = open("cecile_formatted.txt", "w")
cecile_events = []
for line in cecile_file:
    evt = line.split(' ')
    #evt.pop()
    #evt.pop()
    # ignore 7 TeV data
    #if (int(evt[1]) < 190456): continue
    #print "skipped..."
    #if (evt[0] == channel):
    cecile_events.append(evt)
#    s = evt[0] + ":" + evt[1] + ":" + evt[2] + "\n"
#    cecile_file.write(s)

common_events = open("common_events.txt", 'w')
my_extras = open("my_extra_events.txt", 'w')
ceciles_extras = open("ceciles_extra_events.txt", 'w')


nCommon = 0
nMyExtra = 0
nPExtra = 0

for val in my_events:
    if not (len(val) == 4): continue
    s = val[1] + ":" + val[2] + ":" + val[3]# + "\n"
    if val in cecile_events:
        #print val
        nCommon+=1
        #common_events.write(str(val) + "\n")
        common_events.write(s)
    else:
        #my_extras.write(str(val) + "\n")
        nMyExtra+=1
        my_extras.write(s)

for val in cecile_events:
    if not (len(val) == 4): continue
    s = val[1] + ":" + val[2] + ":" + val[3]# + "\n"
    if not val in my_events:
        #pavels_extras.write(str(val) + "\n")
        nPExtra+=1
        ceciles_extras.write(s)

#print "all done!"
print "common events: %s" % str(nCommon)
print "my extra events: %s" % str(nMyExtra)
print "cecile's extra events: %s" % nPExtra
print "estimate of sync: %f" % (1.0*nMyExtra/nCommon)
