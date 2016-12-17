class Filereader {
        def getLines(filepath: String): List[String] = {
                scala.io.Source.fromFile(filepath).getLines.toList
        }
}
