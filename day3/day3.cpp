#include <iostream>
#include <string>
#include "triangle.h"
#include "filereader.h"

int main() {

  std::string* linesOfFile;
  int numOfLines;
  linesOfFile = getLinesFromFile("input.txt", &numOfLines);
  int possibleTrianglesCount = 0;

  for(int i = 0; i < numOfLines; i++) {
    int numOfElements;
    std::string* triangleSideLengths = getElementsFromLine(linesOfFile[i], " ", &numOfElements);

    if (numOfElements != 3) {
      std::cout << "Error. Triangle must have 3 sides. Line has " << numOfElements << std::endl;
      std::cout << "Line is :: " << linesOfFile[i] << std::endl;
      return 1;
    }

    if ((new Triangle(std::stod(triangleSideLengths[0]), std::stod(triangleSideLengths[1]), std::stod(triangleSideLengths[2])))->isLegal()) {
            possibleTrianglesCount++;
    }

  }

  std::cout << possibleTrianglesCount << std::endl;

  return 0;
}
