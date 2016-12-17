public class Elevator {

        private final static int MAX_NUM_OF_ELEMENTS_ON_ELEVATOR = 2;

        private int floorLevel;
        private IAssembleable[] assembleables = new IAssembleable[MAX_NUM_OF_ELEMENTS_ON_ELEVATOR];
        private Floor[] floors;

        public Elevator(int initFloorLevel, Floor[] floors) {
                this.floorLevel = initFloorLevel;
                this.floors = floors;
        }

        public int getCurrentFloorLevel() {
                return this.floorLevel;
        }

        public IAssembleable[] unload() {
                IAssembleable[] abbembleables = this.assembleables;
                this.assembleables = new IAssembleable[MAX_NUM_OF_ELEMENTS_ON_ELEVATOR];
                return abbembleables;
        }

        public void recharge() throws FireException {
                // This happens at every floor no matter if a
                // Assembleable is removed or added
                // from or to the elevator or not
                System.out.println(" >> recharge on floor " + this.floorLevel);
                this.floors[this.floorLevel].addAssembleables(assembleables);
                System.out.println(" >> " + this.floors[this.floorLevel]);
                if (!this.floors[this.floorLevel].isSafe()) {
                        throw new FireException("A chip got fried on floor " + this.floorLevel);
                }
        }

        public Floor getCurrentFloor() {
                return this.floors[this.getCurrentFloorLevel()];
        }

        private void moveToFloor(int floorLevel) throws FireException {
                // cannot be called from outside as it adds no assembleable

                if (floorLevel == this.floorLevel) {
                        return;
                }

                if (floorLevel > this.floorLevel) {
                        moveToFloor(floorLevel-1);
                }

                if (floorLevel < this.floorLevel) {
                        moveToFloor(floorLevel+1);
                }

                this.floorLevel = floorLevel;
                recharge();
        }

        public void moveToFloor(int floorLevel, int assembleableOnFloorIdx) throws FireException {

                System.out.println(">> Move to floor " + floorLevel);

                if (this.assembleables[0] == null) {
                        this.assembleables[0] = this.getCurrentFloor().getAssembleables()[assembleableOnFloorIdx];
                } else if (this.assembleables[1] == null)  {
                        this.assembleables[1] = this.getCurrentFloor().getAssembleables()[assembleableOnFloorIdx];
                }

                moveToFloor(floorLevel);

        }

        public void moveToFloor(int floorLevel, int assembleableAOnFloorIdx, int assembleableBOnFloorIdx) throws FireException {

                this.assembleables[0] = this.getCurrentFloor().getAssembleables()[assembleableAOnFloorIdx];
                this.assembleables[1] = this.getCurrentFloor().getAssembleables()[assembleableBOnFloorIdx];

                moveToFloor(floorLevel);

        }

}
