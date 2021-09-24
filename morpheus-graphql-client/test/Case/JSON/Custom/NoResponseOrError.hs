{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE DerivingStrategies #-}
{-# LANGUAGE DuplicateRecordFields #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE NoImplicitPrelude #-}

module Case.JSON.Custom.NoResponseOrError
  ( test,
  )
where

import Data.ByteString.Lazy.Char8
  ( ByteString,
  )
import Data.Morpheus.Client
  ( EncodeScalar (..),
    Fetch (..),
    FetchError (..),
    ScalarValue (..),
    gql,
  )
import Data.Text (Text)
import Spec.Utils
  ( defineClientWithJSON,
    mockApi,
  )
import Test.Tasty
  ( TestTree,
  )
import Test.Tasty.HUnit
  ( assertEqual,
    testCase,
  )
import Prelude
  ( Either (..),
    Eq (..),
    IO,
    Show,
    ($),
  )

newtype GitTimestamp = GitTimestamp
  { unGitTimestamp :: Text
  }
  deriving (Eq, Show)

instance EncodeScalar GitTimestamp where
  encodeScalar (GitTimestamp x) = String x

defineClientWithJSON
  "JSON/Custom"
  [gql|
    query TestQuery
      {
        queryTypeName
      }
  |]

resolver :: ByteString -> IO ByteString
resolver = mockApi "JSON/Custom/NoResponseOrError"

client :: IO (Either (FetchError TestQuery) TestQuery)
client = fetch resolver ()

test :: TestTree
test = testCase "test NoResponseOrError" $ do
  value <- client
  assertEqual
    "test custom NoResponseOrError"
    ( Left FetchErrorNoResult
    )
    value