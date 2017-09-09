<?php

function linesFromInput() {
        return file('input.txt.full', FILE_IGNORE_NEW_LINES | FILE_SKIP_EMPTY_LINES);
}

function getCheckpointsCoordinates($lines) {
        $checkpointCoordinates = [];
        for ($y=0; $y<count($lines); $y++) {
                $line_a = str_split($lines[$y]);
                for ($x=0; $x<count($line_a); $x++) {
                        if (is_numeric($line_a[$x])) {
                                array_push($checkpointCoordinates, ['y'=>$y, 'x'=>$x, 'value'=>$line_a[$x]]);
                        }
                }
        }
        return $checkpointCoordinates;
}

function getVisitableCoordinates($lines) {
        $visitableCoordinates = [];
        for ($y=0; $y<count($lines); $y++) {
                $line_a = str_split($lines[$y]);
                for ($x=0; $x<count($line_a); $x++) {
                        if (is_numeric($line_a[$x]) || ($line_a[$x] == '.')) {
                                array_push($visitableCoordinates, ['y'=>$y, 'x'=>$x]);
                        }
                }
        }
        return $visitableCoordinates;
}

function findShortestPathCost($targetCoordinates, $unvisitedCoordinates, $visitedCoordinates) {

        // Dijkstra's algorithm
        // According to: https://en.wikipedia.org/wiki/Dijkstra%27s_algorithm#Algorithm
        while(true) {

                //print("\n".count($unvisitedCoordinates));

                // Find coordinate with lowest tentative distance
                $sourceCoordinates = [];
                foreach($unvisitedCoordinates as $unvisited) {
                        if(empty($sourceCoordinates) || $unvisited['tentativeDistance'] <= $sourceCoordinates['tentativeDistance']) {
                                $sourceCoordinates = $unvisited;
                        }
                }

                if (empty($sourceCoordinates) || $sourceCoordinates['tentativeDistance'] == INF) {
                        echo "No more source coordinates";
                        return $visitedCoordinates;
                }

                $newUnvisitedCoordinates = [];
                // Tentative distance for neighbours
                foreach ($unvisitedCoordinates as $unvisited) {
                        if (($unvisited['x'] == $sourceCoordinates['x']+1 && $unvisited['y'] == $sourceCoordinates['y'])
                            || ($unvisited['x'] == $sourceCoordinates['x']-1 && $unvisited['y'] == $sourceCoordinates['y'])
                            || ($unvisited['x'] == $sourceCoordinates['x'] && $unvisited['y'] == $sourceCoordinates['y']+1)
                            || ($unvisited['x'] == $sourceCoordinates['x'] && $unvisited['y'] == $sourceCoordinates['y']-1)) {

                                $tentativeDistance = $sourceCoordinates['tentativeDistance'] + 1;

                                if($tentativeDistance <= $unvisited['tentativeDistance']) {
                                        $unvisited['tentativeDistance'] = $tentativeDistance;
                                }

                                array_push($newUnvisitedCoordinates, $unvisited);

                        } else if ($unvisited['x'] == $sourceCoordinates['x'] && $unvisited['y'] == $sourceCoordinates['y']) {
                                // Remove the source coordinate from the unvisitedCoordinates array
                                // by not adding it to the new one.
                                // Also add it to the visited array
                                array_push($visitedCoordinates, $unvisited);

                                if ($unvisited['x'] == $targetCoordinates['x'] && $unvisited['y'] == $targetCoordinates['y']) {
                                        return $unvisited['tentativeDistance'];
                                }

                        } else {
                                array_push($newUnvisitedCoordinates, $unvisited);
                        }
                }

                $unvisitedCoordinates = $newUnvisitedCoordinates;
        }
}

$checkpointPaths = [];
foreach(getCheckpointsCoordinates(linesFromInput()) as $checkpointCoordinates) {
        foreach(getCheckpointsCoordinates(linesFromInput()) as $toComparecheckPointCoordinates) {

                if ($checkpointCoordinates['value'] == $toComparecheckPointCoordinates['value']) {
                        continue;
                }

                $startCoordinates = $checkpointCoordinates;
                $unvisitedCoordinates = [];
                foreach (getVisitableCoordinates(linesFromInput()) as $visitable) {
                        if ($visitable['x'] == $startCoordinates['x'] && $visitable['y'] == $startCoordinates['y']) {
                                array_push($unvisitedCoordinates, ['x' => $visitable['x'], 'y' => $visitable['y'], 'tentativeDistance' => 0]);
                        } else {
                                array_push($unvisitedCoordinates, ['x' => $visitable['x'], 'y' => $visitable['y'], 'tentativeDistance' => INF]);
                        }
                }

                $path = ['start' => $checkpointCoordinates, 'target' => $toComparecheckPointCoordinates, 'cost' => findShortestPathCost($toComparecheckPointCoordinates, $unvisitedCoordinates, [])];
                array_push($checkpointPaths, $path);
        }
}

foreach($checkpointPaths as $path) {
        $start=$path['start']['value'];
        $target=$path['target']['value'];
        print("${start}----${path['cost']}----${target}\n");
}

?>
