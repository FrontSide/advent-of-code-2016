<?php

        class Memory {

                private $registers = array('a'=>12, 'b'=>0, 'c'=>0, 'd'=>0);

                function setValueFromRegister($sourceRegister, $targetRegister) {
                        $this->set($this->get($sourceRegister), $targetRegister);
                }

                function set($value, $targetRegister) {
                        $this->registers[$targetRegister] = $value;
                }

                function get($sourceRegister) {
                        if (!isset($this->registers[$sourceRegister])) {
                                throw new Exception("Invalid Register '${sourceRegister}'");
                        }
                        return $this->registers[$sourceRegister];
                }

                function increase($register) {
                        $this->set($this->get($register)+1, $register);
                }

                function decrease($register) {
                        $this->set($this->get($register)-1, $register);
                }

                function __toString() {
                        $out = "";
                        foreach ($this->registers as $register => $value) {
                                $out = "${out}[{$register} -> ${value}]";
                        }
                        return $out;
                }

        }

?>
