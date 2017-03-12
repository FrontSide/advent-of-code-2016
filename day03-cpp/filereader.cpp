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

std::string* getElementsFromLine(std::string line, std::string delimiter, int* numOfElements) {

  if (line.length() == 0) {
    *numOfElements = 0;
    return new std::string[0];
  }

  std::string* elements;

  // If there is a string i.e. the length is greater than 1,
  // there is at least one element in the line
  int elementCounter = 1;

  // Count the number of elements in the line
  int foundIdx = 0;
  std::string tmpLine = line;
  for (;tmpLine.find(delimiter) != std::string::npos;) {
    foundIdx = tmpLine.find(delimiter);

    // If the first element in the string is the delimiter
    // ignore and erase it and move to the next element
    if (foundIdx == 0) {
      tmpLine = tmpLine.substr(1, tmpLine.length()-1);
      continue;
    }

    elementCounter++;
    tmpLine = tmpLine.substr(foundIdx, tmpLine.length()-1);;
  }

  *numOfElements = elementCounter;
  elements = new std::string[elementCounter];

  foundIdx = 0;
  int elementIdx = 0;
  for (;line.find(delimiter) != std::string::npos;) {
    foundIdx = line.find(delimiter);

    // Again, ignore if the first element is a delimiter
    if (foundIdx == 0) {
      line = line.substr(1, line.length()-1);
      continue;
    }

    elements[elementIdx++] = line.substr(0, foundIdx);
    line = line.substr(foundIdx, line.length()-1);

  }

  //Write last element into array
  elements[elementIdx] = line;

  return elements;

}
