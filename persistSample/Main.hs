{-# LANGUAGE EmptyDataDecls			 #-}
{-# LANGUAGE FlexibleContexts		   #-}
{-# LANGUAGE GADTs					  #-}
{-# LANGUAGE GeneralizedNewtypeDeriving #-}
{-# LANGUAGE MultiParamTypeClasses	  #-}
{-# LANGUAGE OverloadedStrings		  #-}
{-# LANGUAGE QuasiQuotes				#-}
{-# LANGUAGE TemplateHaskell			#-}
{-# LANGUAGE TypeFamilies			   #-}
import		   Control.Monad.IO.Class  (liftIO)
import		   Database.Persist
import		   Database.Persist.Sqlite
import		   Database.Persist.TH
import Database.Persist.MySQL as MY
import Control.Monad.Logger
import Control.Monad.Trans.Resource
import Control.Monad.Trans.Reader

share [mkPersist sqlSettings, mkMigrate "migrateAll"] [persistLowerCase|
Person
	name String
	age Int Maybe
	deriving Show
BlogPost
	title String
	authorId PersonId
	deriving Show
|]

main :: IO ()
main = runDb runSqlPool sqlExe

sqlExe :: ReaderT SqlBackend m0 (Key Person)
sqlExe = do
	johnId <- insert $ Person "John Doe" $ Just 35
	janeId <- insert $ Person "Jane Doe" Nothing

	insert $ BlogPost "My fr1st p0st" johnId
	insert $ BlogPost "One more for good measure" johnId

	oneJohnPost <- selectList [BlogPostAuthorId ==. johnId] [LimitTo 1]
	liftIO $ print (oneJohnPost :: [Entity BlogPost])

	john <- get johnId
	liftIO $ print (john :: Maybe Person)

	delete janeId
	deleteWhere [BlogPostAuthorId ==. johnId]

runDb func = runNoLoggingT 
      . runResourceT 
      . withSqlitePool "dev.app.sqlite3" 3
      . \pool -> func pool


runDb2 :: SqlPersistT (ResourceT (NoLoggingT IO)) a -> IO a
runDb2 = runNoLoggingT 
      . runResourceT 
      . withMySQLConn conf
      . runSqlConn
 where
  conf = defaultConnectInfo {
    connectHost = "127.0.0.1",
    connectPort = 3306,
    connectUser = "shiba",
    connectPassword = "shiba",
    connectDatabase = "hoge"
  }


