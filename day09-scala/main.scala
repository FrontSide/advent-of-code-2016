object Day {

        val LengthOfMarkerString = 5
        val MarkerIntroCharacter = '('
        val MarkerStopCharacter = ')'
        val orig : Array[Char] = new Filereader getAllAsOneString("input.txt") toArray

        def main(args: Array[String]) {
                println(" :::: Final Length = " + getDecompressedLength(orig) + " ::::")
        }

        def getDecompressedLength(compressedChars: Array[Char]) : Long = {

                var markerRangeCountdown = 0
                var ignoreCharacterCountdown = 0
                var idx = 0
                var outputStringLen = 0L

                for ( char <- compressedChars ) {

                        //A(1x5)BC
                        println(char)

                        // if contains anoter marker call recursively
                        if ( markerRangeCountdown <= 0 && char == MarkerIntroCharacter ) {


                                val m = new Marker ( compressedChars slice(idx, compressedChars.indexOf(MarkerStopCharacter, idx) + 1) mkString )

                                // get the range of the array that is effected by the marker
                                // and recursively pass it to the decompression algorithm again
                                println("Check out substr :: " + compressedChars.slice( compressedChars.indexOf(MarkerStopCharacter, idx) + 1, idx + m.actionRange + m.stringLength ).mkString )
                                val decompressedActionRangeLength = getDecompressedLength ( compressedChars slice( compressedChars.indexOf(MarkerStopCharacter, idx) + 1, idx + m.actionRange + + m.stringLength ) )

                                outputStringLen += decompressedActionRangeLength * m.multiplier
                                markerRangeCountdown = m.actionRange + m.stringLength - 1
                                println("m :: " + m + "/")

                        } else if ( markerRangeCountdown > 0 ) {

                                markerRangeCountdown -= 1
                                println("i")

                        } else {
                                outputStringLen += 1
                                println("c")
                        }

                        idx += 1

                }

                outputStringLen

        }

}
