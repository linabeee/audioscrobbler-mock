{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}

module Error where

import Data.Aeson
import Data.Aeson.Types
import qualified Data.Text as T
import GHC.Generics (Generic)
import Network.HTTP.Types
import Network.Wai (Response, responseLBS)

data LfmError = LfmError Int T.Text deriving (Generic)

instance ToJSON LfmError where
  toEncoding (LfmError code message) = pairs ("code" .= code <> "message" .= message)

errorFromCode :: Int -> LfmError
errorFromCode 6 = LfmError 6 "Invalid parameters - Your request is missing a required parameter"
errorFromCode _ = undefined

responseError :: Int -> Response
responseError c =
  responseLBS
    status400
    [("Content-Type", "application/json; charset=utf8")]
    $ encode (errorFromCode c)