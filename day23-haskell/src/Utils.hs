{-# LANGUAGE BangPatterns #-}

module Utils (traceRun, nextValue, orderResult, getResultElements, getValueBeforeInsert) where
import Data.Maybe
import Debug.Trace
import Data.Vector.Unboxed as V

traceRun :: Int -> Int -> String
traceRun run displayStep
     | run `mod` displayStep == 0 = trace ("move " Prelude.++ show run) (show run)
     | otherwise  = "No trace"

nextValue :: Int -> Int -> Int 
nextValue value maxValue = (if next == 0 then -1 else next) `mod` (maxValue + 1)
    where next = value - 1

orderResult :: Vector Int -> Int -> Vector Int
orderResult list value =  V.drop (index + 1) list  V.++  V.take index list
                        where !index = fromJust $ elemIndex value list 

getResultElements :: Vector Int -> Int -> Vector Int
getResultElements list value = V.drop (fromJust (elemIndex value list) + 1) list

getValueBeforeInsert :: [Int] -> Int -> Int -> Int
getValueBeforeInsert headerValues value maxValue = do
    let checkValue = nextValue value maxValue
    if checkValue `Prelude.elem` headerValues then getValueBeforeInsert headerValues checkValue maxValue else checkValue
