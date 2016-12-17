import scala.collection.mutable.ArrayBuffer
import scala.collection.mutable.ListBuffer

object Day {

        val instructions : ArrayBuffer[String] = new Filereader().getLines("input.txt").to[ArrayBuffer]
        val manager = new OperationElementsManager()

        val ValueToBotPattern = """value (\d+) goes to bot (\d+)""" r
        val FromLowToBotAndHighToBot = """bot (\d+) gives low to bot (\d+) and high to bot (\d+)""" r
        val FromLowToOutputAndHighToBot = """bot (\d+) gives low to output (\d+) and high to bot (\d+)""" r
        val FromLowToBotAndHighToOutput = """bot (\d+) gives low to bot (\d+) and high to output (\d+)""" r
        val FromLowToOutputAndHighToOutput = """bot (\d+) gives low to output (\d+) and high to output (\d+)""" r

        def main(args: Array[String]) {
                executeInstructions()

                // This will reveal the result for task 2
                println(manager.getChipsOfBin(0)(0).id() * manager.getChipsOfBin(1)(0).id() * manager.getChipsOfBin(2)(0).id())
        }

        def executeInstructions() {

                val inputArray = instructions.clone

                for ( idx <- inputArray.indices ) {

                   val instruction = inputArray(idx)

                   try {

                        instruction match {
                                case ValueToBotPattern(chipId, botId) => {
                                        manager.handOverChip(None, manager.getBotForId(botId.toInt), chipId.toInt)
                                }

                                case FromLowToBotAndHighToBot(sourceBotId, lowReceiveBotId, highReceiverBotId) => {
                                        manager.handOverLowerChip(manager.getBotForId(sourceBotId.toInt), manager.getBotForId(lowReceiveBotId.toInt))
                                        manager.handOverHigherChip(manager.getBotForId(sourceBotId.toInt), manager.getBotForId(highReceiverBotId.toInt))
                                }

                                case FromLowToOutputAndHighToBot(sourceBotId, outputBinId, botId) => {
                                        manager.handOverLowerChip(manager.getBotForId(sourceBotId.toInt), manager.getOutputBinForId(outputBinId.toInt))
                                        manager.handOverHigherChip(manager.getBotForId(sourceBotId.toInt), manager.getBotForId(botId.toInt))
                                }

                                case FromLowToBotAndHighToOutput(sourceBotId, botId, outputBinId) => {
                                        manager.handOverLowerChip(manager.getBotForId(sourceBotId.toInt), manager.getBotForId(botId.toInt))
                                        manager.handOverHigherChip(manager.getBotForId(sourceBotId.toInt), manager.getOutputBinForId(outputBinId.toInt))
                                }

                                case FromLowToOutputAndHighToOutput(sourceBotId, lowOutputBinId, highOutputBinId) => {
                                        manager.handOverLowerChip(manager.getBotForId(sourceBotId.toInt), manager.getOutputBinForId(lowOutputBinId.toInt))
                                        manager.handOverHigherChip(manager.getBotForId(sourceBotId.toInt), manager.getOutputBinForId(highOutputBinId.toInt))
                                }
                        }

                        // remove instruction from the global instruction array
                        instructions -= instruction

                } catch {

                        case ex : NotReadyForInstructionException => {}

                }

            }

            if (instructions.length > 0) {
                    executeInstructions()
            }

        }

}

abstract class OperationElement(id : Int) {

        import scala.math.Ordered.orderingToOrdered

        private val m_id : Int = id

        def id() : Int = m_id

        override def equals(o: Any) : Boolean = o match {
                case that: OperationElement => that.m_id == this.m_id
                case _ => false
        }

        override def hashCode = id.hashCode

        implicit def ordering[A <: OperationElement]: Ordering[A] = new Ordering[A] {
                override def compare(x: A, y: A): Int = {
                        x.m_id - y.m_id
                }
        }

}

trait ChipReceivable {
        // An Operation Element that can receive a chip
        def receive( chip: Chip )
}

class OperationElementsManager {

        private val bots : scala.collection.mutable.Map[Int, Bot] = scala.collection.mutable.Map()
        private val outputBins : scala.collection.mutable.Map[Int, OutputBin] = scala.collection.mutable.Map()

        private def createBot(botId: Int) : Bot = {
                // Creates a bot, adds it to the bots map
                // and returns it
                if (bots contains botId) {
                        throw new IllegalArgumentException("Bot " + botId + " already exists.")
                }

                val newBot = new Bot(botId)
                bots + (botId -> newBot)
                newBot

        }

        def getBotForId(botId: Int) : Bot = {
                // Takes a bot with given id from the bots
                // map if it exists or creates a new one if not
                // and returns it
                bots.getOrElse(botId, createBot(botId))
        }

        def update(receivable: ChipReceivable) = {
                receivable match {
                        case bin: OutputBin => outputBins += ( bin.id() -> bin )
                        case bot: Bot => bots += ( bot.id() -> bot )
                }
        }

        def handOverChip(source: Option[Bot], target: ChipReceivable, chipId: Int) {

                var chip : Chip = source match {
                        case Some(b) => {
                                b.getChip(chipId)
                        }
                        case None => new Chip(chipId)
                }

                source match {
                        case Some(b) => update(b)
                        case None => None
                }

                target.receive(chip)
                update(target)
        }

        def handOverHigherChip(source: Bot, target: ChipReceivable) {
                target.receive(source.getHigherChip())
                update(source)
                update(target)
        }

        def handOverLowerChip(source: Bot, target: ChipReceivable) {
                target.receive(source.getLowerChip())
                update(source)
                update(target)
        }

        private def createOutputBin(binId: Int): OutputBin = {
                // Creates a bin, adds it to the bins map
                // and returns it
                if (outputBins contains binId) {
                        throw new IllegalArgumentException("Bot " + binId + " already exists.")
                }

                val newBin = new OutputBin(binId)
                outputBins + (binId -> newBin)
                newBin

        }

        def getOutputBinForId(binId: Int) : OutputBin = {
                // Takes a bin with given id from the outputBins
                // map if it exists or creates a new one if not
                // and returns it
                outputBins.getOrElse(binId, createOutputBin(binId))
        }

        def getChipsOfBin(binId: Int) : ListBuffer[Chip] = getOutputBinForId(binId).getChips

}

class NotReadyForInstructionException extends Exception {}
