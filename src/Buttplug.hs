-- |
-- Module: Buttplug.Core
-- TODO
--
-- An implementation of the Buttplug Intimate Device Control Standard 
-- (<https://buttplug.io/>)
module Buttplug
  (
    -- * Overview
    -- $overview

    -- ** Quickstart
    -- $quickstart

    -- Message.hs
    clientMessageVersion
  , Message(..)
  , ErrorCode(..)
  , Vibrate(..)
  , Rotate(..)
  , LinearActuate(..)
  , RawData(..)

  -- Connector.hs
  , Connector
  , Connection
  , sendMessages
  , receiveMsgs
  , runClient
  , sendMessage
  , WebSocketConnector(..)
  , ConnectorException(..)

  -- Device.hs
  , MessageAttributes(..)
  , Device(..)
  , DeviceMessageType(..)
  ) where

import Buttplug.Message
import Buttplug.Connector
import Buttplug.Device

-- $overview
-- See (<https://buttplug.io/documentation/>) for documentation of the Buttplug
-- protocol.
--
-- The basic idea is:
--
-- - The Buttplug protocol is designed to simplify the process of using
-- computers to control sex toys, by abstracting over individual hardware
-- details.
--
-- - A Buttplug server is responsible for connecting to individual devices, 
-- and understanding the specific details of operating them. I recommend Intiface-cli-rs, a command line server implementation: (<https://github.com/intiface/intiface-cli-rs>)
--
-- - Applications act as Buttplug clients, speaking a straightforward message
-- format to the server, which abstracts over the individual details of 
-- different devices.
-- In this way developers are presented with a simple API for controlling a wide
-- variety of different toys.
--
-- This package contains the core types and functionality for writing clients,
-- including:
-- 
-- - The 'Message' type, and Aeson instances for serialization and deserialization.
-- The Buttplug message format is documented here: (<https://buttplug-spec.docs.buttplug.io/messages.html#basic-message-structure>)
--
-- - The 'Connector' typeclass, which abstracts over different ways of 
-- communicating with a Buttplug server. A connector allows the developer to open connections to the Buttplug Server, and send and receive Messages.
--
-- - 'WebSocketConnector', for connecting to a Buttplug server using Websockets.

-- $quickstart
-- Here is a simple example of a client which connects to a server, performs a handshake, and exits:
--
-- > main = error "TODO"
--
-- See the examples directory for more example programs.
