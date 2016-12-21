import java.util.HashMap;
import java.util.Map;

public class Memory {

        private HashMap<Character, Integer> registers = new HashMap<Character, Integer>(){};

        public Memory() {
                registers.put('a', 0);
                registers.put('b', 0);
                registers.put('c', 1);
                registers.put('d', 0);
        }

        public void set(char sourceRegister, char targetRegister) {
                set(get(sourceRegister), targetRegister);
        }

        public void set(int value, char targetRegister) {
                registers.put(targetRegister, value);
        }

        public int get(char sourceRegister) {
                if (registers.get(sourceRegister) == null) {
                        throw new IllegalArgumentException("Invalid Register '" + sourceRegister + "'");
                }
                return registers.get(sourceRegister);
        }

        public void increase(char register) {
                set(get(register)+1, register);
        }

        public void decrease(char register) {
                set(get(register)-1, register);
        }

        @Override
        public String toString() {
                String out = "";
                for (Map.Entry<Character, Integer> register : registers.entrySet()) {
                        out += register.getKey() + " -> " + register.getValue() + "\n";
                }
                return out;
        }

}
