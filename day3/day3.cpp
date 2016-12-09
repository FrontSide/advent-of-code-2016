#include <iostream>
#include <string>
#include "triangle.h"
#include "filereader.h"

int main() {

  const int COLUMNS_TO_READ = 3;
  const int SIDES_ON_TRIANGLE = 3;

  std::string* linesOfFile;
  int numOfLines;
  linesOfFile = getLinesFromFile("input.txt", &numOfLines);
  int possibleTrianglesCount = 0;

  for (int columnIdx = 0; columnIdx < COLUMNS_TO_READ; columnIdx++) {

      double triangleSideLengths[SIDES_ON_TRIANGLE];

      for(int i = 0; i < numOfLines; i++) {

          int numOfElements;
          std::string* elementsInLine = getElementsFromLine(linesOfFile[i], " ", &numOfElements);

          triangleSideLengths[i % SIDES_ON_TRIANGLE] = std::stod(elementsInLine[columnIdx]);

          if (i % SIDES_ON_TRIANGLE == 2) {

              if ((new Triangle(triangleSideLengths[0], triangleSideLengths[1], triangleSideLengths[2]))->isLegal()) {
                      possibleTrianglesCount++;
              }
          }

      }

  }

  std::cout << possibleTrianglesCount << std::endl;

  return 0;
}
