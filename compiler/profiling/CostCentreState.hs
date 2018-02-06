{-# LANGUAGE DeriveDataTypeable #-}
{-# LANGUAGE GeneralizedNewtypeDeriving #-}
module CostCentreState ( CostCentreState, newCostCentreState
                       , CostCentreIndex, unCostCentreIndex, getCCIndex
                       ) where

import GhcPrelude
import FastString

import Data.Data
import Data.Map (Map)
import qualified Data.Map as Map
import Binary

-- | Per-module state for tracking cost centre indices.
--
-- See documentation of 'CostCentre.cc_flavour' for more details.
newtype CostCentreState = CostCentreState (Map FastString Int)

-- | Initialize cost centre state.
newCostCentreState :: CostCentreState
newCostCentreState = CostCentreState Map.empty

-- | An index into a given cost centre module,name,flavour set
newtype CostCentreIndex = CostCentreIndex { unCostCentreIndex :: Int }
  deriving (Eq, Ord, Data, Binary)

-- | Get a new index for a given cost centre name.
getCCIndex :: FastString
           -> CostCentreState
           -> (CostCentreIndex, CostCentreState)
getCCIndex nm (CostCentreState m) =
    (CostCentreIndex idx, CostCentreState m')
  where
    update _ old _ = old + 1
    (m_idx, m') = Map.insertLookupWithKey update nm 1 m
    idx = maybe 0 id m_idx
