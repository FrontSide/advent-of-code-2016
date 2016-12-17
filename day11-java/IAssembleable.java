public interface IAssembleable {

        public AssembleableType getType();
        public boolean isSecuredBy(IAssembleable assembleable);
        public boolean isHarmedBy(IAssembleable assembleable);
        public boolean isActive();

}
