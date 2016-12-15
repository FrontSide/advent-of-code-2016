class Filereader {
        def getAllAsOneString(filepath: String): String = {
                scala.io.Source.fromFile(filepath).getLines.toList.mkString("")
        }
}
