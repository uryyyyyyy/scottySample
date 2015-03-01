{-# LANGUAGE OverloadedStrings #-}

module Sample.Model where

import Data.Aeson.Types

data Coord = Coord{ x :: Double, y :: Double }

instance ToJSON Coord where
   toJSON (Coord x y) = object ["x" .= x, "y" .= y]

