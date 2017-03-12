multipliers = [0, 1, 0, -1]
x_multiplidx = 0
y_multiplidx = 1

lipt = ['R3', 'L5', 'R2', 'L1', 'L2', 'R5', 'L2', 'R2', 'L2', 'L2', 'L1', 'R2',
        'L2', 'R4', 'R4', 'R1', 'L2', 'L3', 'R3', 'L1', 'R2', 'L2', 'L4', 'R4',
        'R5', 'L3', 'R3', 'L3', 'L3', 'R4', 'R5', 'L3', 'R3', 'L5', 'L1', 'L2',
        'R2', 'L1', 'R3', 'R1', 'L1', 'R187', 'L1', 'R2', 'R47', 'L5', 'L1',
        'L2', 'R4', 'R3', 'L3', 'R3', 'R4', 'R1', 'R3', 'L1', 'L4', 'L1', 'R2',
        'L1', 'R4', 'R5', 'L1', 'R77', 'L5', 'L4', 'R3', 'L2', 'R4', 'R5',
        'R5', 'L2', 'L2', 'R2', 'R5', 'L2', 'R194', 'R5', 'L2', 'R4', 'L5',
        'L4', 'L2', 'R5', 'L3', 'L2', 'L5', 'R5', 'R2', 'L3', 'R3', 'R1', 'L4',
        'R2', 'L1', 'R5', 'L1', 'R5', 'L1', 'L1', 'R3', 'L1', 'R5', 'R2', 'R5',
        'R5', 'L4', 'L5', 'L5', 'L5', 'R3', 'L2', 'L5', 'L4', 'R3', 'R1', 'R1',
        'R4', 'L2', 'L4', 'R5', 'R5', 'R4', 'L2', 'L2', 'R5', 'R5', 'L5', 'L2',
        'R4', 'R4', 'L4', 'R1', 'L3', 'R1', 'L1', 'L1', 'L1', 'L4', 'R5', 'R4',
        'L4', 'L4', 'R5', 'R3', 'L2', 'L2', 'R3', 'R1', 'R4', 'L3', 'R1', 'L4',
        'R3', 'L3', 'L2', 'R2', 'R2', 'R2', 'L1', 'L4', 'R3', 'R2', 'R2', 'L3',
        'R2', 'L3', 'L2', 'R4', 'L2', 'R3', 'L4', 'R5', 'R4', 'R1', 'R5', 'R3']

# lipt = ['R8', 'R4', 'R4', 'R8']


def walk(turn_dir, dist):
    global muiltipliers
    global x_multiplidx
    global y_multiplidx

    if turn_dir == 'R':
        x_multiplidx += 1
        y_multiplidx += 1

    if turn_dir == 'L':
        x_multiplidx -= 1
        y_multiplidx -= 1

    return dist * multipliers[x_multiplidx % 4], \
        dist * multipliers[y_multiplidx % 4]

endx = 0
endy = 0
locations = [(0, 0)]
for el in lipt:
    x, y = walk(el[0], int(el[1:]))

    newloc = []
    for i in range(abs(x)):
        if x is 0:
            break
        endx += (abs(x) / x)
        newloc.append((endx, endy))

    for i in range(abs(y)):
        if y is 0:
            break
        endy += (abs(y) / y)
        newloc.append((endx, endy))

    if len(list(set(locations).intersection(set(newloc)))) > 0:
        firstx, firsty = list(set(locations).intersection(set(newloc)))[0]
        print abs(firstx) + abs(firsty)
        break

    locations += newloc
