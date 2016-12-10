package main

import "fmt"
import "crypto/md5"
import "io"
import "strings"
import "sort"

type HashSum struct {
    hash string
    iterationIdx int
}

type PasswordCharacter struct {
    character string
    iterationIndex int
}
type PasswordCharacters []PasswordCharacter

// Implement sort interface
func (slice PasswordCharacters) Len() int {
    return len(slice)
}

func (slice PasswordCharacters) Less(i, j int) bool {
    return slice[i].iterationIndex < slice[j].iterationIndex;
}

func (slice PasswordCharacters) Swap(i, j int) {
    slice[i], slice[j] = slice[j], slice[i]
}

func main() {

    input := "uqwqemis"
    passwordCharacters := PasswordCharacters{}

    ITERATIONS_PER_THREAD := 100000
    hashSumChannel := make(chan HashSum, 100000000)

    startIdx := 0
    for len(passwordCharacters) < 8 {
        startIdx = triggerIteration(hashSumChannel, input, startIdx, ITERATIONS_PER_THREAD, 10)
        findPassword(hashSumChannel, &passwordCharacters, 10*ITERATIONS_PER_THREAD)
    }

    sort.Sort(passwordCharacters)
    for _, passwordCharacter := range passwordCharacters[:8] {
        fmt.Printf(passwordCharacter.character)
    }

}

func triggerIteration(hashSumChannel chan HashSum, encInput string, startIdx int, numIterationsPerThread int, numThreads int) int {

    threadIdx := 0
    for ;threadIdx <= numThreads; threadIdx++ {
        go generateHashes(hashSumChannel, encInput, startIdx + (threadIdx * numIterationsPerThread), numIterationsPerThread)
    }

    return startIdx + (threadIdx * numIterationsPerThread)

}

func generateHashes(hashSumChannel chan HashSum, encPassword string, startIdx int, numIterations int) {

    for idx := startIdx; idx < (startIdx + numIterations); idx++ {
        h := md5.New()
        io.WriteString(h, fmt.Sprintf("%s%d", encPassword, idx))
        hashSumChannel <- HashSum{hash: fmt.Sprintf("%x", h.Sum(nil)), iterationIdx: idx}
    }

}

func findPassword(hashSumChannel chan HashSum, passwordCharacters *PasswordCharacters, numToRead int) {

    for idx := 0; idx < numToRead; idx++ {
        hashsum := <- hashSumChannel
        if !strings.HasPrefix(hashsum.hash, "00000") {
            continue
        }

        *passwordCharacters = append(*passwordCharacters, PasswordCharacter{character: string(hashsum.hash[5]), iterationIndex: hashsum.iterationIdx})

        // We must not break off this iteration even if we have reached the
        // desired numbers of characters in the password
        // Since we are relying on concurrency we need to expect that
        // the 7th character in the password might be only found after the
        // 9th has already been found (for example)

    }

}
