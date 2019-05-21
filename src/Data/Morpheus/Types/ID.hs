{-# LANGUAGE DeriveAnyClass    #-}
{-# LANGUAGE DeriveGeneric     #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TypeFamilies      #-}

module Data.Morpheus.Types.ID
  ( ID(..)
  ) where

import           Data.Morpheus.Error.Internal       (internalTypeMismatch)
import           Data.Morpheus.Kind.GQLScalar       (GQLScalar (..))
import           Data.Morpheus.Kind.GQLType         (GQLType)
import           Data.Morpheus.Kind.Internal        (KIND, SCALAR)
import           Data.Morpheus.Types.Internal.Value (ScalarValue (..), Value (..))
import           Data.Text                          (Text, pack)
import           GHC.Generics                       (Generic)

type instance KIND ID = SCALAR

newtype ID = ID
  { unpackID :: Text
  } deriving (Generic, GQLType)

instance GQLScalar ID where
  parseValue (Int x)    = return (ID $ pack $ show x)
  parseValue (String x) = return (ID x)
  parseValue value'     = internalTypeMismatch "ID" (Scalar value')
  serialize (ID x) = String x