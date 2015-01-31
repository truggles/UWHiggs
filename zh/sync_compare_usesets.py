import sys

my_file = open("uw_data_events.txt", 'r')
cecile_file = open("list_observed_events.txt", 'r')
channel_map = { '1' : 'MMTT',
                '5' : 'EETT',
                '3' : 'MMMT',
                '6' : 'EEMT',
                '2' : 'MMET',
                '7' : 'EEET',
                '4' : 'MMEM',
                '8' : 'EEEM',
}

my_events = set()
for line in my_file:
    evt = line.strip().split(':')
    #evt.pop()
    #evt.pop()
    if (evt[0] == 'MMEM'):
      #channel,row.run,row.lumi,(row.evt1*10**5 + row.evt2),row.mva_me    tEt,row.t1Pt,row.t2Pt,( row.SVFit_h_Mass + row.Z_Mass
      #my_events.add((evt[1],evt[2],evt[3],round( float( evt[6]), 3),round( float( evt[5]), 3),round( float( evt[7]), 3))) # 7 = t2Pt, 8 = t2Eta
      #my_events.add((evt[1],evt[2],evt[3],round( float( evt[4]), -1),round( float( evt[6]), 0),round( float( evt[5]), 0))) # 7 = t2Pt, 8 = t2Eta
      my_events.add((evt[0],evt[1],evt[2],evt[3]))
    else:
      #my_events.add((evt[1],evt[2],evt[3],round( float( evt[5]), 3),round( float( evt[6]), 3),round( float( evt[7]), 3)))
      #my_events.add((evt[1],evt[2],evt[3],round( float( evt[4]), -1),round( float( evt[5]), 0),round( float( evt[6]), 0)))
      my_events.add((evt[0],evt[1],evt[2],evt[3]))

print len(my_events)
#print my_events

cecile_events = set()
for line in cecile_file:
     #channel run:lumi:event mvaMET l1Pt l2Pt l3Pt l4Pt AMass
     evt = line.strip().split(' ')
     id = evt[1].split(':')
     #cecile_events.add((id[0],id[1],id[2],round( float( evt[5]), 3),round( float( evt[6]), 3),round( float( evt[7]), 3)))
     #cecile_events.add((id[0],id[1],id[2],round( float( evt[4]), -1),round( float( evt[5]), 0),round( float( evt[6]), 0)))
     cecile_events.add((channel_map[evt[0]],id[0],id[1],id[2]))

print len(cecile_events)
#print cecile_events

common_events = open("common_events.txt", 'w')
my_extras = open("my_extra_events.txt", 'w')
ceciles_extras = open("ceciles_extra_events.txt", 'w')

nCommon = 0.0
nMyExtra = 0.0
nPExtra = 0.0

common_events_set = my_events.intersection(cecile_events)
my_extra_set = my_events.difference(cecile_events)
ceciles_extra_set = cecile_events.difference(my_events)

for val in common_events_set:
    s = ''
    for i in range( len( val ) ):
        s += str(val[i]) + " "
    s += "\n"
    nCommon+=1
    common_events.write(s)

for val in my_extra_set:
    s = ''
    for i in range( len( val ) ):
        s += str(val[i]) + " "
    s += "\n"
    nMyExtra+=1
    my_extras.write(s)

for val in ceciles_extra_set:
    s = ''
    for i in range( len( val ) ):
        s += str(val[i]) + " "
    s += "\n"
    nPExtra+=1
    ceciles_extras.write(s)

#print "all done!"
print "common events: %s" % str(nCommon)
print "my extra events: %s" % str(nMyExtra)
print "cecile's extra events: %s" % nPExtra
if (nCommon != 0):
  print "estimate of sync: %f" % ( (nPExtra+nMyExtra) / nCommon )

