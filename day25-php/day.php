<?php

include_once 'memory.php';

$input = array(

    "cpy a d",
    "cpy 15 c",
    "cpy 170 b",
    "inc d",
    "dec b",
    "jnz b -2",
    "dec c",
    "jnz c -5",
    "cpy d a",
    "jnz 0 0",
    "cpy a b",
    "cpy 0 a",
    "cpy 2 c",
    "jnz b 2",
    "jnz 1 6",
    "dec b",
    "dec c",
    "jnz c -4",
    "inc a",
    "jnz 1 -7",
    "cpy 2 b",
    "jnz c 2",
    "jnz 1 4",
    "dec b",
    "dec c",
    "jnz 1 -4",
    "jnz 0 0",
    "out b",
    "jnz a -19",
    "jnz 1 -21"

);

echo $memory;

function main_loop($init_value, $input) {

        $memory = new Memory();
        $memory->set($init_value, 'a');

        $print_counter=0;
        $clockarray=[];
        for ($idx=0;$idx<count($input);$idx++) {

                if ($print_counter > 10) {
                    return $clockarray;
                }


                //echo("\n\nexecute ${idx} ${input[$idx]}");
                //echo("\n".implode($input, ","));
                //echo("\n${memory}");

                $instruction = explode(" ", $input[$idx]);
                if (strcmp($instruction[0], "cpy") == 0) {

                        if (is_numeric($instruction[1])) {
                                $memory->set($instruction[1], $instruction[2]);
                        } else {
                                $memory->setValueFromRegister($instruction[1], $instruction[2]);
                        }
                } else if (strcmp($instruction[0], "out") == 0) {
                        $print_counter++;
                        if (is_numeric($instruction[1])) {
                                array_push($clockarray, $instruction[1]);
                        } else {
                                array_push($clockarray, $memory->get($instruction[1]));
                        }
                } else if (strcmp($instruction[0], "inc") == 0) {
                        $memory->increase($instruction[1]);
                } else if (strcmp($instruction[0], "dec") == 0) {
                        $memory->decrease($instruction[1]);
                } else if (strcmp($instruction[0], "jnz") == 0) {
                        $jumXValue = 0;
                        if (is_numeric($instruction[1])) {
                                $jumXValue = $instruction[1];
                        } else {
                                $jumXValue = $memory->get($instruction[1]);
                        }

                        if ($jumXValue == 0) {
                                // We can ignore this jump
                                continue;
                        }

                        $jumYValue = 0;
                        if (is_numeric($instruction[2])) {
                                $jumYValue = $instruction[2];
                        } else {
                                $jumYValue = $memory->get($instruction[2]);
                        }

                        $idx += $jumYValue;
                        $idx--;
                } else if (strcmp($instruction[0], "tgl") == 0) {

                        // The instruction that will be written
                        // to the instruction that is to be toggled
                        $newInstruction = "";

                        $toggleValue = 0;
                        if (is_numeric($instruction[1])) {
                                $toggleValue = $instruction[1];
                        } else {
                                $toggleValue = $memory->get($instruction[1]);
                        }

                        if(($idx + $toggleValue) > (count($input)-1)) {
                                continue;
                        }

                        $instructionToToggle = explode(" ", $input[$idx + $toggleValue]);

                        //one-argument instructions
                        if (count($instructionToToggle) == 2) {
                                if (strcmp($instructionToToggle[0], "inc") == 0) {
                                        $instructionToToggle[0] = "dec";
                                } else {
                                        $instructionToToggle[0] = "inc";
                                }
                        }

                        // two-argument instructions
                        else if (count($instructionToToggle) == 3) {
                                if (strcmp($instructionToToggle[0], "jnz") == 0) {
                                        $instructionToToggle[0] = "cpy";
                                } else {
                                        $instructionToToggle[0] = "jnz";
                                }
                        }
                        $input[$idx + $toggleValue] = implode($instructionToToggle, " ");

                } else {
                        throw new Exception("Not a valid instruction :: '".implode($instruction, " ")."' at index ".$idx);
                }
        }
}

$i=0;
while(true) {
        if (strcmp(implode("", main_loop($i, $input)), "01010101010") == 0) {
                echo $i;
                break;
        }
        $i++;
}

echo("\n${memory}");

?>
