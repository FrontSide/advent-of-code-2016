#include <fstream>
#include <sstream>
#include <iostream>
#include <ios>

#include "filereader.h"

std::string* getLinesFromFile(std::string filename, int* numOfLines) {

  std::string line;
  std::ifstream inputfile(filename);

  if (!inputfile.is_open()) {
    std::cout << "Cannot open file.\n";
    return new std::string[0];
  }

  // Count number of lines
  int linesCount = 0;
  for (;std::getline(inputfile, line); linesCount++) {}

  // Remove EOF flag and move back to beginning of file
  inputfile.clear();
  inputfile.seekg(0, std::ios::beg);

  std::string* lines = new std::string[linesCount];

  // Read in lines
  for (int i = 0; std::getline(inputfile, line); i++) {
    lines[i] = line;
  }

  inputfile.close();
  *numOfLines = linesCount;
  return lines;

}
