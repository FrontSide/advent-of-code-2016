import scala.collection.mutable.ListBuffer

class Bot(id: Int) extends OperationElement(id) with ChipReceivable {

        private val chips : ListBuffer[Chip] = ListBuffer()

        override def toString() : String = {
                return "(" + this.id() + ")[" + chips + "]"
        }

        def getChip(chipId : Int) : Chip = {
                for (idx <- chips.indices) {
                        if (chips(idx).id() == chipId) {
                                chips.remove(idx)
                        }
                }
                throw new IllegalArgumentException("Bot :: " + id + " has no chip with id " + chipId + ".")
        }

        def getLowerChip() : Chip = {

                // This is a bit hacky,
                // but the "getLowerChip" and "getHigherChip"
                // mthods are always only called together and
                // one after the other with the "lower" always being
                // the first one. So we know that this call is invalid
                // if not both slots are occupied by a chip.
                if (chips.length < 2) {
                        throw new NotReadyForInstructionException()
                }

                val lowestChip = chips.min
                chips -= lowestChip

                lowestChip
        }

        def getHigherChip() : Chip = {

                // As above, but since this is the second one being called
                // we know it's invalid if no slot is occupied.
                if (chips.length < 1) {
                        throw new NotReadyForInstructionException()
                }

                val highestChip = chips.min
                chips -= highestChip

                highestChip

        }

        def receive( chip : Chip ) {

                if (chips.length > 1) {
                        throw new IllegalArgumentException("Bot :: " + id + " already has two chips.")
                }

                chips += chip

                //This will reveal the result for task 1
                if (chips.length == 2 && chips.min.id() == 17 && chips.max.id() == 61) {
                        println(this)
                }

        }

}
