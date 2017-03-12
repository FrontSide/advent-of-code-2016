package main

import "log"
import "io/ioutil"
import "strings"
import "fmt"
import "sync"

type MostFrequentLetters []rune

func main() {

    input, err := ioutil.ReadFile("input.txt")
    if err != nil {
        log.Fatal(err)
    }

    lines := strings.Split(string(input), "\n")
    lineLength := len(lines[0])
    errorCorrectedMessage := make(MostFrequentLetters, lineLength)

    // Before printing the decoded message at the end, we need to make sure
    // that all calculations have finished. We do this by waiting for
    // the go routines with a wait group.
    var waitGroup sync.WaitGroup
    waitGroup.Add(lineLength)

    for columnIdx := 0; columnIdx < lineLength; columnIdx++ {
        go getLeastFrequentLetter(getColumnAsString(lines, columnIdx), columnIdx, &errorCorrectedMessage, &waitGroup)
    }

    // Wait untill all go routines are finished before printing the message
    waitGroup.Wait()

    for _, letter := range errorCorrectedMessage {
        fmt.Printf("%c", letter)
    }

}

func getLeastFrequentLetter(column string, columnIdx int, errorCorrectedMessage *MostFrequentLetters, waitGroup *sync.WaitGroup) {

    // Tell the wait group that one go routine has finished at the
    // end of this function
    defer (*waitGroup).Done()

    minOccurrencesCount := -1
    var minOccurrencesChar rune
    observedCharacters := ""

    for _, char := range column {

        if strings.ContainsRune(observedCharacters, char) {
            continue
        }

        observedCharacters += string(char)
        occurrencesCount := strings.Count(column, string(char))

        if minOccurrencesCount == -1 || occurrencesCount < minOccurrencesCount {
            minOccurrencesCount = occurrencesCount
            minOccurrencesChar = char
        }

    }

    (*errorCorrectedMessage)[columnIdx] = minOccurrencesChar

}

func getColumnAsString(lines []string, columnIndex int) string {
    var column string;
    for _, line := range lines {
        if len(line)-1 < columnIndex {
            continue
        }
        column += string(line[columnIndex])
    }
    return column
}
