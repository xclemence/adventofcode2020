{-# LANGUAGE BangPatterns #-}

module Main where

import Data.Char(digitToInt, intToDigit)
import Data.Vector.Unboxed as V


import Game as G
import MGame as MG
import Utils

labeling = "198753462"

cupProvider = Prelude.map digitToInt labeling Prelude.++ [start..]
    where start = Prelude.length labeling + 1

main = do
    print "------------------Part 1-----------------------"

    let cups'9 = fromList(Prelude.take 9 cupProvider)

    let finalOrder = orderResult (G.play cups'9 100) 1
    print finalOrder

    print "------------------Part 2-----------------------"
    let cupNumber = 1000000
    let cups'1k = fromList (Prelude.take cupNumber cupProvider)

    let !playNumber = cupNumber * 10
    let !runResult = MG.play cups'1k playNumber

    let !afterOne = V.take 2 $ getResultElements runResult 1
    print afterOne

    let step2Result = V.head afterOne * afterOne!1
    print step2Result

 -- [875050, 792708] => 693659135400

 
