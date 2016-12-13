
linesegments = []
with open("input.txt", 'r') as f:
    idx = 0
    segidx = 0
    for line in f.readlines():
        if (idx % 100) == 0:
            segidx = idx / 100
            segment = []
            linesegments.append(segment)
        linesegments[segidx].append(line.strip())
        idx = idx + 1

idx = 0
for segment in linesegments:
    print "inpt%s = [" % idx
    for line in segment:
        print " \"%s\"," % line
    print "]"
    idx = idx + 1

print idx

