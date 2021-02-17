{-# LANGUAGE BangPatterns #-}

module MGame (play) where

import Data.Vector.Unboxed.Mutable as MV
import Data.Vector.Unboxed as V
import Control.Monad.ST
import Control.Monad.Primitive

import Utils

play :: Vector Int -> Int -> Vector Int
play cups run  = runST $ do
    mutable <- V.thaw  cups

    V.forM_ (V.fromList [1..run]) (\ i -> do
            moveCup_ mutable
            let !tracer = traceRun i 1000
            return ()
        )

    V.freeze mutable

moveCup_ :: (PrimMonad m) => MVector (PrimState m) Int -> m ()
moveCup_ cups = do
    head <- MV.read cups 0
    move1 <- MV.read cups 1
    move2 <- MV.read cups 2
    move3 <- MV.read cups 3

    let size = MV.length cups
    let !insertValue = getValueBeforeInsert [move1, move2, move3] head size

    lastIndex <- moveBeginPart_ cups 0 insertValue

    MV.write cups (lastIndex + 1) move1
    MV.write cups (lastIndex + 2) move2
    MV.write cups (lastIndex + 3) move3
    
    moveEndPart_ cups (lastIndex + 4) (size - 1)
    
    MV.write cups (size - 1) head

moveBeginPart_ :: (PrimMonad m) => MVector (PrimState m) Int -> Int -> Int -> m Int
moveBeginPart_ cups index endValue = do
    currentValue <- MV.read cups (index + 4)
    MV.write cups index currentValue

    if currentValue == endValue
        then return index
        else moveBeginPart_ cups (index + 1) endValue

moveEndPart_ :: (PrimMonad m) => MVector (PrimState m) Int -> Int -> Int -> m ()
moveEndPart_ cups index endIndex = do
    if index >= endIndex
        then return ()
        else do
            currentValue <- MV.read cups (index + 1)
            MV.write cups index currentValue
            moveEndPart_ cups (index + 1) endIndex
