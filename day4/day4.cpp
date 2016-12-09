#include <string>
#include <iostream>
#include "filereader.h"
#include "room.h"

int main() {

  std::string* linesOfFile;
  int numOfLines;
  linesOfFile = getLinesFromFile("input.txt", &numOfLines);

  // If you don't initialiye your integer
  // you're gonna have a bad time.
  // (A random value that the int points to in memory will be taken)
  int idsum = 0;
  for(int i = 0; i < numOfLines; i++) {
      Room* r = new Room(linesOfFile[i]);
      if (r->isReal()) {
          idsum += r->getId();
          std::cout << r->getdecryptedName() << " | " << r->getId() << std::endl;
      }
  }

  std::cout << idsum << std::endl;

  return 0;
}
