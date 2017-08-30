import Data.List.Split
import Data.List
import Control.Concurrent
import Control.Concurrent.MVar

import qualified Data.Vector.Unboxed


-- range looks like "<min>-<max>"
-- eg. 23-345
rangeToTuple rangeString = do
        let rangeBounds = splitOn "-" rangeString
        let min = (read (rangeBounds!!0) :: Int)
        let max = (read (rangeBounds!!1) :: Int)
        ((read (rangeBounds!!0) :: Int), (read (rangeBounds!!1) :: Int))

-- This is probably unnecessary because "sort" would already
-- sort it correctly (i.e by the first number in the tuple)
-- but let's be safe
rangeTuplesSorterFunction a b | (fst a) < (fst b) = LT
                              | otherwise = GT

toRangeTuples rangesStringList =
        map rangeToTuple rangesStringList

isBlockedByRange range ip =
        ip >= fst range && ip <= snd range

isBlockedByAnyRange ranges ip = do
        let isBlocked = find (\x -> isBlockedByRange x ip) ranges
        case isBlocked of
                Just x -> True
                Nothing -> False

highsFromRangeTuples rangeTuples =
        map snd rangeTuples

findLowestUnblocked lockedRangeTuples = do
        let lowestUnblockedPreRangeEnd = find (\x -> (not (isBlockedByAnyRange lockedRangeTuples (x+1)))) (highsFromRangeTuples lockedRangeTuples)
        case lowestUnblockedPreRangeEnd of
                -- We'll need to add one know because the number we
                -- found is a "high" from a range
                -- above you can see that we added + 1 to the x as well
                -- in order to exceed/leave the range
                Just x -> x + 1
                Nothing -> -1

main = do
        f <- readFile "./input.txt.full"
        --print (findLowestUnblocked (sort (toRangeTuples (lines f))))
        --print ((highsFromRangeTuples (toRangeTuples (sort (lines f))))!!8)
        print (findLowestUnblocked (sortBy rangeTuplesSorterFunction (toRangeTuples (lines f))))
