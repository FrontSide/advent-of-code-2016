import qualified Data.Vector.Unboxed

generateElfs :: Int -> Data.Vector.Unboxed.Vector Int
generateElfs len = Data.Vector.Unboxed.enumFromTo 1 len

getSndHalf :: Data.Vector.Unboxed.Vector Int -> Data.Vector.Unboxed.Vector Int
getSndHalf lst =
        Data.Vector.Unboxed.map fst (Data.Vector.Unboxed.filter (\x -> ((snd x) >= (((Data.Vector.Unboxed.length lst) - 1) `quot` 2))) (toIndexedList lst))

getFstHalf :: Data.Vector.Unboxed.Vector Int -> Data.Vector.Unboxed.Vector Int
getFstHalf lst =
        Data.Vector.Unboxed.map fst (Data.Vector.Unboxed.filter (\x -> ((snd x) < (((Data.Vector.Unboxed.length lst) - 1 ) `quot` 2))) (toIndexedList lst))

run elves 1 _ = print elves
run elves 3014387 startIdx = do
        let newElves = ( (getFstHalf elves) Data.Vector.Unboxed.++ ( oddEvenRm (getSndHalf elves) startIdx) )
        run newElves (Data.Vector.Unboxed.length newElves) ((Data.Vector.Unboxed.length (getSndHalf elves)) + startIdx)
run elves 2 startIdx = do
        print startIdx
        print elves
run elves elvesLength startIdx = do
        let newElves = (oddEvenRm elves startIdx)
        run newElves (Data.Vector.Unboxed.length newElves) (startIdx + (elvesLength))

toIndexedList lst = Data.Vector.Unboxed.zip lst (Data.Vector.Unboxed.enumFromTo (0) ((Data.Vector.Unboxed.length lst)-1))

-- removes all elements that are not mod 3 == 1
-- odd/even removal
oddEvenRm :: Data.Vector.Unboxed.Vector Int -> Int -> Data.Vector.Unboxed.Vector Int
oddEvenRm elves offsetIdx =
        Data.Vector.Unboxed.map fst (Data.Vector.Unboxed.filter (\x -> ((((snd x) + offsetIdx) `mod` 3 == 1))) (toIndexedList elves))

main = do
        let elves = generateElfs 3014387
        run elves 3014387 0
