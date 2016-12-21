
import java.util.ArrayList;

public class Day {

        private static String[] sampleInput = new String[] {
                "cpy 41 a",
                "inc a",
                "inc a",
                "dec a",
                "jnz a 2",
                "dec a"
        };

        private static String[] input = new String[] {
                "cpy 1 a",
                "cpy 1 b",
                "cpy 26 d",
                "jnz c 2",
                "jnz 1 5",
                "cpy 7 c",
                "inc d",
                "dec c",
                "jnz c -2",
                "cpy a c",
                "inc a",
                "dec b",
                "jnz b -2",
                "cpy c b",
                "dec d",
                "jnz d -6",
                "cpy 19 c",
                "cpy 14 d",
                "inc a",
                "dec d",
                "jnz d -2",
                "dec c",
                "jnz c -5"
        };

        public static void main(String[] args) {

                Memory memory = new Memory();
                System.out.println(memory);

                for (int idx = 0; idx < input.length; idx++) {

                        String rawInstruction = input[idx];

                        String[] instruction = rawInstruction.split(" ");
                        if (instruction[0].equals("cpy")) {
                                try {
                                        memory.set(Integer.parseInt(instruction[1]), instruction[2].charAt(0));
                                } catch(NumberFormatException e) {
                                        memory.set(instruction[1].charAt(0), instruction[2].charAt(0));
                                }
                        } else if (instruction[0].equals("inc")) {
                                memory.increase(instruction[1].charAt(0));
                        } else if (instruction[0].equals("dec")) {
                                memory.decrease(instruction[1].charAt(0));
                        } else if (instruction[0].equals("jnz")) {
                                int jumXValue = 0;
                                try {
                                        jumXValue = Integer.parseInt(instruction[1]);
                                } catch(NumberFormatException e) {
                                        jumXValue = memory.get(instruction[1].charAt(0));
                                }

                                if (jumXValue == 0) {
                                        // We can ignore this jump
                                        continue;
                                }

                                idx += Integer.parseInt(instruction[2]);
                                idx--;
                                continue;

                        } else {
                                throw new IllegalArgumentException("Not a valid instruction :: " + rawInstruction);
                        }

                }

                System.out.println(memory);

        }

}
