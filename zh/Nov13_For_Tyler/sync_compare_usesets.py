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
      print round( evt[4], 3)
      #channel,row.run,row.lumi,(row.evt1*10**5 + row.evt2),row.mva_me    tEt,row.t1Pt,row.t2Pt,( row.SVFit_h_Mass + row.Z_Mass
      my_events.add((evt[1],evt[2],evt[3],round( evt[4], 3),round( evt[6], 3),round( evt[5], 3),round( evt[7], 3))) # 7 = t2Pt, 8 = t2Eta
    else:
      my_events.add((evt[1],evt[2],evt[3],round( evt[4], 3),round( evt[5], 3),round( evt[6], 3),round( evt[7], 3)))

print my_events

cecile_events = set()
for line in cecile_file:
    #channel run:lumi:event mvaMET l1Pt l2Pt l3Pt l4Pt AMass
    evt = line.strip().split(' ')
    id = evt[1].split(':')
    cecile_events.add((id[0],id[1],id[2],round( evt[2], 3),round( evt[5], 3),round( evt[6], 3),round( evt[7], 3)))

print cecile_events

#common_events = open("common_events.txt", 'w')
#my_extras = open("my_extra_events.txt", 'w')
#ceciles_extras = open("ceciles_extra_events.txt", 'w')
#
#nCommon = 0.0
#nMyExtra = 0.0
#nPExtra = 0.0
##print my_events
##print "blah"
##print cecile_events
#common_events_set = my_events.intersection(cecile_events)
#my_extra_set = my_events.difference(cecile_events)
#ceciles_extra_set = cecile_events.difference(my_events)
#
#
##print len(cecile_events)
#
#for val in common_events_set:
#    #if not (len(val) == 4): continue
#    #s = val[0] + " " + val[1] + " " + val[2] + "\n"
#    #s = val[0] + " " + val[1] + " " + val[2] + " " + val[3] + "\n"
#    s = val[0] + " " + val[1] + " " + val[2] + " " + val[3] + " " + val[4] + " " + val[5] + " " + val[6] +  " " + val[7] + "\n" 
#    #s = val[0] + " " + val[1] + " " + val[2] + " " + val[3] + " " + val[4] + " " + val[5] + " " + val[6] + "\n" # w/o EventID 
#    #print val
#    nCommon+=1
#    common_events.write(s)
#
#for val in my_extra_set:
#    #s = val[0] + " " + val[1] + " " + val[2] + "\n"
#    #s = val[0] + " " + val[1] + " " + val[2] + " " + val[3] + "\n"
#    s = val[0] + " " + val[1] + " " + val[2] + " " + val[3] + " " + val[4] + " " + val[5] + " " + val[6] +  " " + val[7] + "\n" 
#    #s = val[0] + " " + val[1] + " " + val[2] + " " + val[3] + " " + val[4] + " " + val[5] + " " + val[6] + "\n" # w/o EventID 
#    nMyExtra+=1
#    my_extras.write(s)
#
#for val in ceciles_extra_set:
#    #s = val[0] + " " + val[1] + " " + val[2] + "\n"
#    #s = val[0] + " " + val[1] + " " + val[2] + " " + val[3] + "\n"
#    s = val[0] + " " + val[1] + " " + val[2] + " " + val[3] + " " + val[4] + " " + val[5] + " " + val[6] +  " " + val[7] + "\n" 
#    #s = val[0] + " " + val[1] + " " + val[2] + " " + val[3] + " " + val[4] + " " + val[5] + " " + val[6] + "\n" # w/o EventID 
#    nPExtra+=1
#    ceciles_extras.write(s)
#
##print "all done!"
#print "common events: %s" % str(nCommon)
#print "my extra events: %s" % str(nMyExtra)
#print "cecile's extra events: %s" % nPExtra
#if (nCommon != 0):
#  print "estimate of sync: %f" % ( (nPExtra+nMyExtra) / nCommon )
#
