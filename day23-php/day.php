<?php

        include_once 'memory.php';

        $memory = new Memory();

        $input_test = array(
                "cpy 2 a",
                "tgl a",
                "tgl a",
                "tgl a", //inc a // a=
                "cpy 1 a", //jnz 1 a
                "dec a", //a=0
                "dec a" // a=-1
        );

        $input = array(
                "cpy a b",
                "dec b",
                "cpy a d",
                "cpy 0 a",
                "cpy b c",
                "inc a",
                "dec c",
                "jnz c -2",
                "dec d",
                "jnz d -5",
                "dec b",
                "cpy b c",
                "cpy c d",
                "dec d",
                "inc c",
                "jnz d -2",
                "tgl c",
                "cpy -16 c",
                "jnz 1 c",
                "cpy 89 c",
                "jnz 90 d",
                "inc a",
                "inc d",
                "jnz d -2",
                "inc c",
                "jnz c -5"
        );

        echo $memory;

        for ($idx=0;$idx<count($input);$idx++) {

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

        echo("\n${memory}");

?>
