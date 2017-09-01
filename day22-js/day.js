function parse_line(line) {
        if (!line.startsWith("/dev/grid/node-")) {
                console.log("parsing error")
                return null
        }

        matches = line.match(/x(\d+)-y(\d+)\s+(\d+)T\s+(\d+)T\s+(\d+)T\s+(\d+)%/)

        return {
                'x': parseInt(matches[1]),
                'y': parseInt(matches[2]),
                'size': parseInt(matches[3]),
                'used': parseInt(matches[4]),
                'avail': parseInt(matches[5]),
                'used-perc': parseInt(matches[6])
        }
}

function is_viable_pair(node_a, node_b) {

        return node_a.used != 0 && (!(node_a.x == node_b.x && node_a.y == node_b.y)) && (node_a.used <= node_b.avail)
}

var lines = require('./input.js').input.match(/(.+)/g)

nodes = []
for (i = 0; i < lines.length; i++) {
        nodes.push(parse_line(lines[i]))
}

// good old O(n^2)
viable_count = 0
for (var i = 0; i < nodes.length; i++) {
        for (var j = 0; j < nodes.length; j++) {
                if (is_viable_pair(nodes[i], nodes[j])) {
                        viable_count++
                }
        }
}

console.log(viable_count)


// Store nodes in 2dim array
grid = []
for (var i = 0; i < nodes.length; i++) {
        node = nodes[i]
        if (node.x == 0) {
                // Add new y array
                grid.push([])
        }
        grid[node.y].push(node)
}

goaly = 0
goalx = 33
for (var y = 0; y < grid.length; y++) {

        for (var x = 0; x < grid[y].length; x++) {

                node = grid[y][x]
                if (node.x != x || node.y != y) {
                        console.log("err")
                        break
                }

                if (node.x == goalx && node.y == goaly) {
                        process.stdout.write(" G ");
                } else if (node.used == 0) {
                        process.stdout.write(" _ ")
                } else if (node.used > 100) {
                        process.stdout.write(" # ")
                } else {
                        process.stdout.write(" . ")
                }

        }

        console.log()

}
