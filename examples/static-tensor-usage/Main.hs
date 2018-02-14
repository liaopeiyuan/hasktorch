{-# LANGUAGE DataKinds #-}
{-# LANGUAGE ScopedTypeVariables #-}

module Main where

import qualified Torch.Core.Random as RNG (new)
import Torch.Core.Tensor.Static
import Torch.Core.Tensor.Static.Math
import qualified Torch.Core.Tensor.Static.Math as Math
import qualified Torch.Core.Tensor.Static.Random as R (uniform)

initialization :: IO ()
initialization = do
  putStrLn "\nInitialization"
  putStrLn "--------------"

  putStrLn "\nZeros:"
  zeroMat :: DoubleTensor '[3,2] <- new
  printTensor zeroMat

  putStrLn "\nConstant:"
  constVec :: DoubleTensor '[2] <- constant 2
  printTensor constVec

  putStrLn "\nInitialize 1D vector from list:"
  listVec :: DoubleTensor '[6] <- fromList1d [1, 2, 3, 4, 5, 6]
  printTensor listVec

  putStrLn "\nResize 1D vector as 2D matrix:"
  asMat :: DoubleTensor '[3, 2] <- resizeAs listVec
  -- let asMat = resize listVec :: DoubleTensor '[3, 3] -- won't type check
  printTensor asMat

  putStrLn "\nInitialize arbitrary dimensions directly from list:"
  listVec2 :: DoubleTensor '[3, 2] <- fromList [1, 2, 3, 4, 5, 6]
  printTensor listVec2

  putStrLn "\nRandom values:"
  gen <- RNG.new
  randMat :: DoubleTensor '[4, 4] <- uniform gen (1.0) (3.0)
  printTensor randMat

valueTransformations :: IO ()
valueTransformations = do
  putStrLn "\nBatch tensor value transformations"
  putStrLn "-----------------------------------"
  gen <- RNG.new

  putStrLn "\nRandom matrix:"
  randMat :: DoubleTensor '[4, 4] <- uniform gen (1.0) (3.0)
  printTensor randMat

  putStrLn "\nNegated:"
  neg randMat >>= printTensor

  putStrLn "\nSigmoid:"
  sig :: DoubleTensor '[4, 4] <- Math.sigmoid randMat
  printTensor sig

  putStrLn "\nTanh:"
  Math.tanh randMat >>= printTensor

  putStrLn "\nLog:"
  Math.log randMat >>= printTensor

  putStrLn "\nRound:"
  Math.round randMat >>= printTensor

matrixVectorOps :: IO ()
matrixVectorOps = do
  putStrLn "\nMatrix/vector operations"
  putStrLn "------------------------"
  gen <- RNG.new

  putStrLn "\nRandom matrix:"
  randMat :: DoubleTensor '[2, 2] <- uniform gen (-1.0) (1.0)
  printTensor randMat

  putStrLn "\nConstant vector:"
  constVec :: DoubleTensor '[2] <- constant 2
  printTensor constVec

  putStrLn "\nMatrix x vector:"
  randMat !* constVec >>= printTensor

  putStrLn "\nVector outer product:"
  constVec `outer` constVec >>= printTensor

  putStrLn "\nVector dot product:"
  constVec <.> constVec >>= print

  putStrLn "\nMatrix trace:"
  trace randMat >>= print

main :: IO ()
main = do
  putStrLn "\nExample Usage of Typed Tensors"
  putStrLn "=============================="
  initialization
  matrixVectorOps
  valueTransformations
  pure ()
