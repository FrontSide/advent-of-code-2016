public class Chip implements IAssembleable {

        private final AssembleableType type;

        public Chip(AssembleableType type) {
                this.type = type;
        }

        public AssembleableType getType() {
                return this.type;
        }

        public boolean isActive() {
                return false;
        }

        public boolean isSecuredBy(IAssembleable assembleable) {
                System.out.println(">> is " + this + " secured by " + assembleable + " ?");
                if (!assembleable.isActive()) {
                        return false;
                }
                return this.getType() == assembleable.getType();
        }

        public boolean isHarmedBy(IAssembleable assembleable) {

                if (!assembleable.isActive()) {
                        return false;
                }
                return this.getType() != assembleable.getType();

        }


        @Override
        public String toString(){
                return "C::" + this.getType();
        }

}
