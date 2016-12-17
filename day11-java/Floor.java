import java.util.ArrayList;
import java.util.Arrays;

public class Floor {

        private ArrayList<IAssembleable> assembleables = new ArrayList<IAssembleable>();
        public Floor(IAssembleable[] assembleables) {
                addAssembleables(assembleables);
        }

        public IAssembleable[] getAssembleables() {
                IAssembleable[] assembleablesArr = new IAssembleable[assembleables.size()];
                this.assembleables.toArray(assembleablesArr);
                return assembleablesArr;
        }

        public void addAssembleable(IAssembleable assembleable) {
                System.out.println(">> Add " + assembleable + " to floor.");
                this.assembleables.add(assembleable);
        }

        public void addAssembleables(IAssembleable[] assembleables) {
                for (IAssembleable assembleable : assembleables) {
                        if (assembleable == null) continue;
                        addAssembleable(assembleable);
                }
        }

        @Override
        public String toString() {
                String out = "";
                for (IAssembleable assembleable : this.assembleables) {
                        out += "\t";
                        out += assembleable;
                }
                out += " :: " + this.isSafe();
                return out;
        }

        public boolean isSafe() {
                // Returns false if a michrichip is in a room with a generator
                // of a different type while a generator of its own type
                // is not in the room.

                for (IAssembleable assembleable : this.assembleables) {

                        if (assembleable.isActive()) {
                                continue;
                        }

                        boolean isActivelySecured = false;
                        boolean isActivelyHarmed = false;

                        for (IAssembleable secondAssembleable : this.assembleables) {
                                if (assembleable.isSecuredBy(secondAssembleable)) {
                                        isActivelySecured = true;
                                }
                                if (assembleable.isHarmedBy(secondAssembleable)) {
                                        isActivelyHarmed = true;
                                }
                        }

                        if (isActivelyHarmed && !isActivelySecured) {
                                return false;
                        }

                }

                return true;

        }

}
