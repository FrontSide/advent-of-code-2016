public class Generator implements IAssembleable {

        private final AssembleableType type;

        public Generator(AssembleableType type) {
                this.type = type;
        }

        public AssembleableType getType() {
                return this.type;
        }

        public boolean isSecuredBy(IAssembleable assembleable) {
                return !isActive();
        }

        public boolean isHarmedBy(IAssembleable assembleable) {
                return !isActive();
        }

        public boolean isActive() {
                return true;
        }

        @Override
        public String toString(){
                return "G::" + this.type;
        }

}
