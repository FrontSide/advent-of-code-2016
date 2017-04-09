import qualified Data.Vector.Unboxed

toIndexedList lst = Data.Vector.Unboxed.zip lst (Data.Vector.Unboxed.enumFromTo 0 ((Data.Vector.Unboxed.length lst)-1))

removeEvenElfIdx elfs = Data.Vector.Unboxed.map fst (Data.Vector.Unboxed.filter (\x -> ((mod (snd x) 2) /= 0)) (toIndexedList elfs))
removeOddElfIdx elfs = Data.Vector.Unboxed.map fst (Data.Vector.Unboxed.filter (\x -> ((mod (snd x) 2) == 0)) (toIndexedList elfs))

generateElfs :: Int -> Data.Vector.Unboxed.Vector Int
generateElfs len = Data.Vector.Unboxed.enumFromTo 1 len

isOfEvenLength lst = (Data.Vector.Unboxed.length lst) `mod` 2 == 0

run elfs previousListWasEven lastRemovalWasEven = do
        if (Data.Vector.Unboxed.length elfs) == 1
        then
                elfs
        else if previousListWasEven == lastRemovalWasEven
        then
                run (removeEvenElfIdx elfs) (isOfEvenLength elfs) True
        else
                run (removeOddElfIdx elfs) (isOfEvenLength elfs) False

main = do
        let elfs = generateElfs 3014387
        print (run elfs True False)
