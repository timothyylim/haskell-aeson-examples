{-# START_FILE main.hs #-}
{-# LANGUAGE OverloadedStrings, DeriveGeneric #-}

import Data.Aeson
import Data.Text
import Control.Applicative
import Control.Monad
import qualified Data.ByteString.Lazy as B
import Network.HTTP.Conduit (simpleHttp)
import GHC.Generics

-- | Type of each JSON entry in record syntax.
data Person =
  Person { firstName  :: !Text
         , lastName   :: !Text
         , age        :: Int
         , likesPizza :: Bool
           } deriving (Show,Generic)

-- Instances to convert our type to/from JSON.

instance FromJSON Person
instance ToJSON Person

-- | Location of the local copy, in case you have it,
--   of the JSON file.
jsonFile :: FilePath
jsonFile = "data/pizza.json"

-- | URL that points to the remote JSON file, in case
--   you have it.
jsonURL :: String
jsonURL = "http://daniel-diaz.github.io/misc/pizza.json"

-- Move the right brace (}) from one comment to another
-- to switch from local to remote.

{--}
-- Read the local copy of the JSON file.
getJSON :: IO B.ByteString
getJSON = B.readFile jsonFile
--}

{--
-- Read the remote copy of the JSON file.
getJSON :: IO B.ByteString
getJSON = simpleHttp jsonURL
--}

main :: IO ()
main = do
 -- Get JSON data and decode it
 d <- (eitherDecode <$> getJSON) :: IO (Either String [Person])
 -- If d is Left, the JSON was malformed.
 -- In that case, we report the error.
 -- Otherwise, we perform the operation of
 -- our choice. In this case, just print it.
 case d of
  Left err -> putStrLn err
  Right ps -> print ps