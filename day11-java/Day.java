public class Day {

        public static void main(String[] args) {

                Manager manager = Manager.getInstance().initialize();
                System.out.println(manager);
                manager.bringAllToAssembly();
                System.out.println(manager);

        }

}
