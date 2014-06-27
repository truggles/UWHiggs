f = open("list.txt", "r")
fout = open("event_counts.txt", "w")

for line in f:
    line = line.rstrip()
    event_file = open(line)
    fout.write(line)
    for l in event_file:
        fout.write(l)
    event_file.close()
fout.close()
f.close()
