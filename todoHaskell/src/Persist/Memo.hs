{-# LANGUAGE EmptyDataDecls             #-}
{-# LANGUAGE FlexibleContexts           #-}
{-# LANGUAGE GADTs                      #-}
{-# LANGUAGE GeneralizedNewtypeDeriving #-}
{-# LANGUAGE MultiParamTypeClasses      #-}
{-# LANGUAGE OverloadedStrings          #-}
{-# LANGUAGE QuasiQuotes                #-}
{-# LANGUAGE TemplateHaskell            #-}
{-# LANGUAGE TypeFamilies               #-}

module Persist.Memo where

import Database.Persist.MySQL
import Data.Text (Text)
import Database.Persist
import Database.Persist.Sqlite (runSqlite, runMigration)
import Database.Persist.TH (mkPersist, mkMigrate, persistLowerCase,
       share, sqlSettings)

share [mkPersist sqlSettings, mkMigrate "migrateAll"] [persistLowerCase|
Memo
    name String
    age Int
    deriving Show
|]

main = runSqlConn $ do
  insert $ Memo "aa@bb.vv" 2
 where
  conf = defaultConnectInfo {
    connectHost = "localhost",
    connectPort = 3306,
    connectUser = "hoge",
    connectPassword = "hoge",
    connectDatabase = "hoge"
  }