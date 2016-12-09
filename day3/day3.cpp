#include <iostream>
#include <string>
#include "triangle.h"
#include "filereader.h"

int main() {

  std::string* linesOfFile;
  int numOfLines;
  linesOfFile = getLinesFromFile("input.txt", &numOfLines);

  for(int i = 0; i < numOfLines; i++) {
    int numOfElements;
    std::string* triangleSideLengths = getElementsFromLine(linesOfFile[i], " ", &numOfElements);

    std::cout << "." << std::endl;

    if (numOfElements != 3) {
      std::cout << "Error. Triangle must have 3 sides. Line has " << numOfElements << std::endl;
      return 1;
    }

    new Triangle(std::stod(triangleSideLengths[0], triangleSideLengths[0].length()), std::stod(triangleSideLengths[1], triangleSideLengths[1].length()), std::stod(triangleSideLengths[2], triangleSideLengths[2].length()));

  }

  return 0;
}
