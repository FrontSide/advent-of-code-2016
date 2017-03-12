class Marker(var raw: String) {
        /*
         * A marker is every tring segment
         * that matches [(][\d]x[\d][)] e.g. (2x4)
         * unless it is withing the action range of a previous marker*
         */

         var actionRange = parseFromRawString(raw) _1
         var multiplier = parseFromRawString(raw) _2
         var stringLength = raw.length()

         def parseFromRawString(raw: String) : (Int, Int) = {
                 val markerPattern = """[(](\d+)[x](\d+)[)]""".r
                 val m = markerPattern findFirstMatchIn(raw) match {
                         case Some(s) => s
                         case None => throw new IllegalArgumentException("This is not a valid marker :: " + raw)
                 }
                 (m.group(1) toInt, m.group(2) toInt)
         }

         override def toString() : String = "(" + actionRange + ", " + multiplier + ")[" + stringLength + "]"

}
