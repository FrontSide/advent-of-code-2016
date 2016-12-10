package main

import "fmt"
import "crypto/md5"
import "io"
import "strings"
import "strconv"

type HashSum struct {
    hash string
    iterationIdx int
}

type PasswordCharacter struct {
    exists bool
    character string
    iterationIndex int
}
type PasswordCharacters []PasswordCharacter

func (slice PasswordCharacters) isFullyPopulated() bool {
    for _, passwordCharacter := range slice {
        if ! passwordCharacter.exists {
            return false
        }
    }
    return true
}

func main() {

    input := "uqwqemis"

    PASSWORD_LENGTH := 8
    passwordCharacters := make(PasswordCharacters, PASSWORD_LENGTH)

    ITERATIONS_PER_THREAD := 10000
    NUM_OF_THREADS := 1000
    hashSumChannel := make(chan HashSum, ITERATIONS_PER_THREAD*NUM_OF_THREADS)

    startIdx := 0
    for ! passwordCharacters.isFullyPopulated() {
        startIdx = triggerIteration(hashSumChannel, input, startIdx, ITERATIONS_PER_THREAD, NUM_OF_THREADS)
        findPassword(hashSumChannel, &passwordCharacters, NUM_OF_THREADS*ITERATIONS_PER_THREAD)
    }

    for _, passwordCharacter := range passwordCharacters {
        fmt.Printf("%s", passwordCharacter.character)
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

        if !strings.ContainsRune("01234567", rune(hashsum.hash[5])) {
            continue
        }

        positionIdx, err := strconv.Atoi(string(hashsum.hash[5]))
        if err != nil {
            fmt.Printf("Error when parsing position.")
            return
        }

        // If this position of the password is already filled and the
        // iteration index of the newly found character for this
        // position is bigger than the position index of the existing one,
        // we can ignore the new one.
        // This check is necessay because a newly found character for the same
        // position might actually have a lower iteration index
        // because of the randomness of concurrency.
        if (*passwordCharacters)[positionIdx].exists && (*passwordCharacters)[positionIdx].iterationIndex < hashsum.iterationIdx {
            continue
        }

        (*passwordCharacters)[positionIdx] = PasswordCharacter{exists: true, character: string(hashsum.hash[6]), iterationIndex: hashsum.iterationIdx}

        // We must not break off this iteration even if we have reached the
        // desired numbers of characters in the password
        // Since we are relying on concurrency we need to expect that
        // the 7th character in the password might be only found after the
        // 9th has already been found (for example)

    }

}
