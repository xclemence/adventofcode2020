{-# LANGUAGE BangPatterns #-}

module Game (play, move) where

import Data.Maybe
import Data.Vector.Unboxed as V

import Utils

position :: Int -> Vector Int -> Vector Int -> Int ->Int
position value list excludeList maxValue = do
    let !targetValue = getValueBeforeInsert (toList excludeList) value maxValue
    fromJust (elemIndex targetValue list ) + 1

move :: Vector Int -> Vector Int
move cups =  V.concat [as, move, bs, fromList [head]]
              where !list = V.drop 4 cups
                    !head = V.head cups
                    !size = V.length cups
                    !move = V.drop 1 (V.take 4 cups) 
                    !(as,bs) =  V.splitAt (position head list move size) list

play :: Vector Int -> Int -> Vector Int
play cups 0 =  cups
play cups run  = do
    let !moveResult = move cups
    let !tracer = traceRun run 10
    play moveResult (run - 1)
