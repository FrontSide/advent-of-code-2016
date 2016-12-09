#include "room.h"
#include <iostream>
#include <algorithm>

Room::Room(std::string roomString) {
    setRoomFromRoomString(roomString);
}

int Room::getId() {
    return m_id;
}

void Room::setRoomFromRoomString(std::string roomString) {

    // Break a room String up into its components
    // and assigns the parts to the Room object
    // A room string is defined as follows:
    //   encrypted name (lowercase letters separated by dashes)
    //   followed by a dash, a sector ID,
    //   and a checksum in square brackets.
    // e.g. aaaaa-bbb-z-y-x-123[abxyz]
    //      encryped name = aaaaa-bbb-z-y-x
    //      id = 123
    //      checksum = abxyz

    const std::string CHECKSUM_INTRO_STRING = "[";
    const std::string ID_INTRO_STRING = "-";

    std::string encNameAndId = roomString.substr(0, roomString.find(CHECKSUM_INTRO_STRING));
    m_checksum = roomString.substr(roomString.find(CHECKSUM_INTRO_STRING)+1, roomString.length()-roomString.find_last_of(CHECKSUM_INTRO_STRING)-2);
    m_id = std::stoi(encNameAndId.substr(encNameAndId.find_last_of(ID_INTRO_STRING)+1, encNameAndId.length()));
    m_encName = encNameAndId.substr(0, encNameAndId.find_last_of(ID_INTRO_STRING));

}

bool Room::isReal() {
    return m_checksum == computeChecksumFromEncName();
}

std::string Room::computeChecksumFromEncName() {

    // Calculate the checksum from the encrypted name
    // of the room.
    // The checksum is calculated as follows:
    //     the checksum is the five most common letters in the encrypted name,
    //     in order, with ties broken by alphabetization.
    // e.g. enc name = aaaaa-bbb-z-y-x
    //      checksum = abxyz

    const char CHAR_TO_IGNORE = '-';

    // Get the different letters in the encryptd name
    std::string foundLetters;
    for (int i = 0; i < m_encName.length(); i++) {
        if (m_encName[i] == CHAR_TO_IGNORE)
            continue;
        if (foundLetters.find(m_encName[i]) == std::string::npos) {
            foundLetters = foundLetters + m_encName[i];
        }
    }

    // Sort the found letters by alphabeth
    std::sort(foundLetters.begin(), foundLetters.end());

    // Get the occurrences of a letter in the encrypted name
    // the occurrences array will correspond with its indexes
    // to the foundLetters string. .
    // e.g. the number on index 2 in the occurrences array
    //      represents the occurrences of the letter at the 2nd index
    //      in the foundLetters string
    int occurrences[foundLetters.length()];
    std::string tmpString = m_encName;
    for (int i = 0; i < foundLetters.length(); i++) {
        occurrences[i] = 0;
        while (tmpString.find(foundLetters[i]) != std::string::npos) {
            occurrences[i] = occurrences[i]+1;
            tmpString[tmpString.find(foundLetters[i])] = CHAR_TO_IGNORE;
        }
    }

    // Order letter by occurrences
    // This will then be our checksum
    std::string checksum;
    int largestOccurrencesFound;
    while (true) {

        // Reset largestOccurrences number
        // So that if the largest number is 1 it can still be found
        largestOccurrencesFound = 0;

        // Find largest number of occurrences
        for (int i = 0; i < foundLetters.length(); i++) {
            if (occurrences[i] > largestOccurrencesFound)
                largestOccurrencesFound = occurrences[i];
        }

        // If the largest occurrenct is 0 at this point, we are done
        if (largestOccurrencesFound == 0)
            break;

        // Put all letters with the most occurrences to the top
        // of the checksum string, without destroying the alphabetical
        // order of letters with tied occurrences
        std::string partChecksumString;
        for (int i = 0; i < foundLetters.length(); i++) {
            if (occurrences[i] == largestOccurrencesFound) {
                partChecksumString = partChecksumString + foundLetters[i];
                // Set the occurrences at this index to 0
                // as we are done with this letter now
                occurrences[i] = 0;
            }
        }

        // Prepend the partial checksum to the all over chcksum
        checksum = checksum + partChecksumString;

    }

    // The checksum must also be trimmed to the first 5 letters
    return checksum.substr(0, 5);

}

std::string Room::getdecryptedName() {
    // Decrypts the encrypted room name
    // Room names can be decrypted as follows:
    //   To decrypt a room name,
    //   rotate each letter forward through the alphabet a number of times
    //   equal to the room's sector ID.
    //   A becomes B, B becomes C, Z becomes A, and so on.
    //   Dashes become spaces.
    // e.g. enc: qzmt-zixmtkozy-ivhz-343
    //      dec: very encrypted name

    const std::string alphabeth = "abcdefghijklmnopqrstuvwxyz";
    const char CHAR_TO_WHITESPACE = '-';

    std::string decName;
    for (int i = 0; i < m_encName.length(); i++) {
        if (m_encName[i] == CHAR_TO_WHITESPACE) {
            decName += " ";
            continue;
        }
        decName += alphabeth[(alphabeth.find(m_encName[i]) + getId()) % alphabeth.length()];
    }

    return decName;

}
