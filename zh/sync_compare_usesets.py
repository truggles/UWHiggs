import sys

my_file = open(sys.argv[1], 'r')
cecile_file = open(sys.argv[2], 'r')
channel = sys.argv[3]
channel_map = { '1' : 'MMTT',
                '5' : 'EETT',
                '3' : 'MMMT',
                '6' : 'EEMT',
                '2' : 'MMET',
                '7' : 'EEET',
                '4' : 'MMEM',
                '8' : 'EEEM',
}


print "Now analyzing channel %s" % channel_map[channel]
my_events = set()
for line in my_file:
    evt = line.strip().split(' ')
    #evt.pop()
    #evt.pop()
    if (evt[0] == channel and evt[0] != '4'):
      my_events.add((evt[1],evt[2],evt[3]))
      #my_events.add((evt[1],evt[2],evt[3],evt[4],evt[5],evt[6],evt[7],evt[8])) # 6 = t2Pt, 7 = t2Eta
      #my_events.add((evt[1],evt[2],evt[3],round(float(evt[4])),round(float(evt[5]))))
    elif(evt[0] == channel):
      #my_events.add((evt[1],evt[2],evt[3],evt[6],evt[7],evt[4],evt[5],evt[8]))
      my_events.add((evt[1],evt[2],evt[3]))

#cecile_file = open("cecile_formatted.txt", "w")
cecile_events = set()
for line in cecile_file:
    evt = line.strip().split(' ')
    #evt.pop()
    #evt.pop()
    # ignore 7 TeV data
    #if (int(evt[1]) < 190456): continue
    #print "skipped..."
    if (evt[0] == channel):
      cecile_events.add((evt[1],evt[2],evt[3]))
      #cecile_events.add((evt[1],evt[2],evt[3],evt[4],evt[5],evt[6],evt[7],evt[8]))
     #cecile_events.add((evt[1],evt[2],evt[3],round(float(evt[4])),round(float(evt[5]))))
#    s = evt[0] + ":" + evt[1] + ":" + evt[2] + "\n"
#    cecile_file.write(s)


common_events = open("common_events.txt", 'w')
my_extras = open("my_extra_events.txt", 'w')
ceciles_extras = open("ceciles_extra_events.txt", 'w')

nCommon = 0.0
nMyExtra = 0.0
nPExtra = 0.0
#print my_events
#print "blah"
#print cecile_events
common_events_set = my_events.intersection(cecile_events)
my_extra_set = my_events.difference(cecile_events)
ceciles_extra_set = cecile_events.difference(my_events)


#print len(cecile_events)

for val in common_events_set:
    #if not (len(val) == 4): continue
    s = val[0] + " " + val[1] + " " + val[2] + " " + "\n"
    #s = val[0] + " " + val[1] + " " + val[2] + " " + val[3] + " " + val[4] + " " + val[5] + " " + val[6] +  " " + val[7] + "\n" 
    #print val
    nCommon+=1
    common_events.write(s)

for val in my_extra_set:
    s = val[0] + " " + val[1] + " " + val[2] + " " + "\n"
    #s = val[0] + " " + val[1] + " " + val[2] + " " + val[3] + " " + val[4] + " " + val[5] + " " + val[6] +  " " + val[7] + "\n" 
    nMyExtra+=1
    my_extras.write(s)

for val in ceciles_extra_set:
    s = val[0] + " " + val[1] + " " + val[2] + " " + "\n"
    #s = val[0] + " " + val[1] + " " + val[2] + " " + val[3] + " " + val[4] + " " + val[5] + " " + val[6] +  " " + val[7] + "\n" 
    nPExtra+=1
    ceciles_extras.write(s)

#print "all done!"
print "common events: %s" % str(nCommon)
print "my extra events: %s" % str(nMyExtra)
print "cecile's extra events: %s" % nPExtra
if (nCommon != 0):
  print "estimate of sync: %f" % ( (nPExtra+nMyExtra) / nCommon )

