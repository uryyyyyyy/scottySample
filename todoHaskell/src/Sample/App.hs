{-# LANGUAGE OverloadedStrings #-}

module Sample.App (getRoot, getParams) where

import Web.Scotty

import Sample.Model
import Persist.Memo as Memo
import Persist.Migration as Migration
import Data.Monoid (mconcat)

getRoot :: ActionM ()
getRoot = do
	json (Coord 1.0 2.22)

getParams :: ActionM ()
getParams = do
	beam <- param "word"
	html $ mconcat ["<h1>Scotty, ", beam, " me up!</h1>"]


--getPersistent :: ActionM ()
--getPersistent = do
--	memos <- Model2.listMemos
--	json memos
--
--listMemos :: ActionM [Memo]
--listMemos = runDB $ map P.entityVal <$> P.selectList ([] :: [P.Filter Memo]) [P.Asc MemoId]