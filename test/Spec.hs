{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE BlockArguments #-}
{-# LANGUAGE DuplicateRecordFields #-}

import           GHC.Generics
import qualified Data.Map.Strict as Map
import           Test.Hspec
import           Data.Aeson ( decode
                            , encode
                            , ToJSON(..)
                            , FromJSON(..)
                            , Options(..)
                            , SumEncoding(..)
                            , genericToJSON
                            , genericParseJSON
                            )
import           Data.Maybe (isJust)
import           Data.ByteString     (ByteString)
import qualified Data.ByteString     as BS

import           Buttplug.Internal
import           Buttplug.Devices
import qualified Buttplug.Devices as Dev
import           Buttplug.Internal.JSONUtils

main :: IO ()
main = hspec do
  testButtplug

testButtplug = do
  describe "decode" do
    let non_empty_device_list = "[{\"ServerInfo\":{\"MajorVersion\":0,\"MinorVersion\":5,\"BuildVersion\":5,\"MessageVersion\":1,\"MaxPingTime\":0,\"ServerName\":\"Intiface Server\",\"Id\":1}},{\"DeviceList\":{\"Devices\":[{\"DeviceName\":\"Youou Wand Vibrator\",\"DeviceIndex\":1,\"DeviceMessages\":{\"SingleMotorVibrateCmd\":{},\"VibrateCmd\":{\"FeatureCount\":1},\"StopDeviceCmd\":{}}}],\"Id\":1}},{\"Ok\":{\"Id\":1}}]"

    it "Can decode a simple list of messages with a nonempty device list" $
      (decode non_empty_device_list :: Maybe [Message]) `shouldBe` Just expectedNonemptyDeviceFields

    it "Decodes LogLevelOff correctly" do
      decode "\"Off\"" `shouldBe` Just LogLevelOff

    it "Decodes a RawCommand correctly" do
      decode "[255,255,0,123]" `shouldBe` (Just $ RawCommand $ BS.pack [255,255,0,123])

    it "Won't parse rawcommands if the ints are larger than the size of a byte" do
      decode "[255, 256]" `shouldBe` (Nothing :: Maybe RawCommand)

  describe "encode" do
    it "encodes LogLevelOff correctly" do
      (encode LogLevelOff) `shouldBe` "\"Off\""

-- [{"ServerInfo":{"MajorVersion":0,"MinorVersion":5,"BuildVersion":5,"MessageVersion":1,"MaxPingTime":0,"ServerName":"Intiface Server","Id":1}},{"DeviceList":{"Devices":[{"DeviceName":"Youou Wand Vibrator","DeviceIndex":1,"DeviceMessages":{"SingleMotorVibrateCmd":{},"VibrateCmd":{"FeatureCount":1},"StopDeviceCmd":{}}}],"Id":1}},{"Ok":{"Id":1}}]

expectedNonemptyDeviceFields =
  [ ServerInfo
      { majorVersion = 0
      , minorVersion = 5
      , buildVersion = 5
      , messageVersion = 1
      , maxPingTime = 0
      , serverName = "Intiface Server"
      , id = 1 }
  , DeviceList
      { id = 1
      , devices = [ Device
                      { deviceName = "Youou Wand Vibrator"
                      , deviceIndex = 1
                      , deviceMessages =
                          Map.fromList [ (Dev.SingleMotorVibrateCmd, MessageAttributes Nothing)
                                       , (Dev.VibrateCmd, MessageAttributes $ Just 1)
                                       , (Dev.StopDeviceCmd, MessageAttributes Nothing)
                                       ]
                      }
                  ]

      }
  , Ok { id = 1 }
  ]

data TestSingleConstructor = Constructor1 { field1 :: Int
                                          , field2 :: String }
                           | Constructor2 { field3 :: Int
                                          }
                                               deriving (Show, Eq, Generic)

instance ToJSON TestSingleConstructor where
  toJSON = genericToJSON $ pascalCaseOptions { sumEncoding = ObjectWithSingleField }
