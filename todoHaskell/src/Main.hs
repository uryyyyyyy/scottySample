{-# LANGUAGE OverloadedStrings #-}

import Web.Scotty

import Sample.App as Sample

main = do
	let port = 3000

	scotty port $ do
		get "/" Sample.getRoot
--		get "/" Sample.getPersistent
		get "/:word" Sample.getParams
