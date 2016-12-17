public class Manager {

        private static final int NUM_OF_FLOORS = 4;

        // Singleton
        private Manager() {}
        private static Manager INSTANCE;
        public static Manager getInstance() {
                if (Manager.INSTANCE == null) {
                        Manager.INSTANCE = new Manager();
                }
                return Manager.INSTANCE;
        }

        private final Floor[] floors = new Floor[NUM_OF_FLOORS];
        private Elevator elevator;

        public Manager initialize() {

                this.floors[0] = new Floor(
                        new IAssembleable[] {
                                new Generator(AssembleableType.POLONIUM),
                                new Generator(AssembleableType.THULIUM),
                                new Chip(AssembleableType.THULIUM),
                                new Generator(AssembleableType.PROMETHIUM),
                                new Generator(AssembleableType.RUTHENIUM),
                                new Chip(AssembleableType.RUTHENIUM),
                                new Generator(AssembleableType.COBALT),
                                new Chip(AssembleableType.COBALT)
                        }
                );

                this.floors[1] = new Floor(
                        new IAssembleable[] {
                                new Chip(AssembleableType.POLONIUM),
                                new Chip(AssembleableType.PROMETHIUM)
                        }
                );


                this.floors[2] = new Floor(
                        new IAssembleable[]{}
                );

                this.floors[3] = new Floor(
                        new IAssembleable[]{}
                );

                this.elevator = new Elevator(0, this.floors);

                return this;

        }

        public void bringAllToAssembly() {
                this.elevator.moveToFloor(3, 1);
        }

        @Override
        public String toString() {

                String out = "";

                ;
                for (int floorLevelCount = NUM_OF_FLOORS-1; floorLevelCount >= 0; floorLevelCount--) {
                        if (floorLevelCount == this.elevator.getCurrentFloorLevel()) {
                                out += "E:";
                        }
                        out += floors[floorLevelCount].toString();
                        out += "\n";
                }

                return out;

        }

}
