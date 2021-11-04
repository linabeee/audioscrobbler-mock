{-# LANGUAGE OverloadedStrings #-}

module Main where

import qualified Data.ByteString.Lazy.Char8 as LB
import Data.Maybe (mapMaybe)
import qualified Data.Text as T
import Data.Text.Encoding (encodeUtf8)
import qualified Data.Text.IO as T
import Error
import Network.HTTP.Types
import Network.Wai
import Network.Wai.Handler.Warp (Port, run)
import Prelude as P

port :: Port
port = 8001

queryToSimpleQuery :: Query -> SimpleQuery
queryToSimpleQuery =
  mapMaybe
    ( \(k, v) -> case v of
        Nothing -> Nothing
        Just v -> Just (k, v)
    )

simpleQuery :: Request -> SimpleQuery
simpleQuery = queryToSimpleQuery . queryString

response404 :: Response
response404 = responseLBS status404 [] ""

serveAPI :: Request -> Response
serveAPI req =
  if ("format", "json") `P.elem` simpleQuery req
    then responseLBS status500 [("Content-Encoding", "utf8")] $ LB.pack $ show (queryString req)
    else responseError 6

app :: Application
app req res = res $ case pathInfo req of
  "2.0" : ps ->
    if null ps || all (== "") ps then serveAPI req else response404
  ps -> responseLBS status404 [] $ LB.pack $ show ps

main :: IO ()
main = putStrLn ("http://localhost:" ++ show port) >> run port app