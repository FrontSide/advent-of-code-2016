import scala.collection.mutable.ListBuffer

class InputBin(id: Int) extends OperationElement(id) {

}

class OutputBin(id: Int) extends OperationElement(id) with ChipReceivable {

        private val chips : ListBuffer[Chip] = ListBuffer()

        def getChips() : ListBuffer[Chip] = chips

        def receive( chip : Chip ) {
                chips += chip
        }

        override def toString() : String = {
                return "(Bin :: " + this.id() + ") has chips :: [" + chips.mkString + "]"
        }

}
