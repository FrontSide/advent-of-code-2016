
out = "input = ["
with open("input.txt", 'r+') as inpt:
    for line in inpt.readlines():

        if line.startswith("rect"):
            intsInString = line.split()[1].split('x')
            instruction = "doRect %d %d" % (int(intsInString[0]), int(intsInString[1]))

        elif line.startswith("rotate row"):
            intsInString = line.split('=')[1].split(" by ")
            instruction = "doRotateRow %d %d" % (int(intsInString[0]), int(intsInString[1]))

        elif line.startswith("rotate column"):
            intsInString = line.split('=')[1].split(" by ")
            instruction = "doRotateColumn %d %d" % (int(intsInString[0]), int(intsInString[1]))

        else:
            print "ERROR. NO MATCH."
            break

        out += '(%s), ' % instruction

print out
