import sys

f = open(sys.argv[1], "r")
file_formatted = open(sys.argv[2], "w")

for line in f:
    evt = line.split(' ')
    evt.pop()
    evt.pop()
    # ignore 7 TeV data
    #if (int(evt[1]) < 190456): continue
    #print "skipped..."
    print evt    
    s = evt[1] + ":" + evt[2] + ":" + evt[3] + "\n"
    file_formatted.write(s)

f.close()
file_formatted.close()
