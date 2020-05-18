{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE BlockArguments #-}
{-# LANGUAGE DuplicateRecordFields #-}

import qualified Data.Map.Strict as Map
import           Test.Hspec
import           Data.Aeson (decode)
import           Data.Maybe (isJust)

import           Buttplug
import           Buttplug.Devices
import qualified Buttplug.Devices as Dev

main :: IO ()
main = hspec do
  describe "decode" do
    let non_empty_device_list = "[{\"ServerInfo\":{\"MajorVersion\":0,\"MinorVersion\":5,\"BuildVersion\":5,\"MessageVersion\":1,\"MaxPingTime\":0,\"ServerName\":\"Intiface Server\",\"Id\":1}},{\"DeviceList\":{\"Devices\":[{\"DeviceName\":\"Youou Wand Vibrator\",\"DeviceIndex\":1,\"DeviceMessages\":{\"SingleMotorVibrateCmd\":{},\"VibrateCmd\":{\"FeatureCount\":1},\"StopDeviceCmd\":{}}}],\"Id\":1}},{\"Ok\":{\"Id\":1}}]"
    it "can decode a list of messages with a nonempty device list" $
      (decode non_empty_device_list :: Maybe [Message]) `shouldBe` Just expectedNonemptyDeviceFields


      
-- [{"ServerInfo":{"MajorVersion":0,"MinorVersion":5,"BuildVersion":5,"MessageVersion":1,"MaxPingTime":0,"ServerName":"Intiface Server","Id":1}},{"DeviceList":{"Devices":[{"DeviceName":"Youou Wand Vibrator","DeviceIndex":1,"DeviceMessages":{"SingleMotorVibrateCmd":{},"VibrateCmd":{"FeatureCount":1},"StopDeviceCmd":{}}}],"Id":1}},{"Ok":{"Id":1}}]

expectedNonemptyDeviceFields = [ ServerInfo ServerInfoFields
        { majorVersion = 0
        , minorVersion = 5
        , buildVersion = 5
        , messageVersion = 1
        , maxPingTime = 0
        , serverName = "Intiface Server"
        , id = 1 } 
    , DeviceList DeviceListFields
        { id = 1
        , devices = [ Device
                        { deviceName = "Youou Wand Vibrator"
                        , deviceIndex = 1
                        , deviceMessages = Map.fromList [ (SingleMotorVibrateCmd, MessageAttributes Nothing)
                                                        , (Dev.VibrateCmd, MessageAttributes $ Just 1)
                                                        , (StopDeviceCmd, MessageAttributes Nothing)
                                                        ]
                        }
                    ]

        }
    , Ok OkFields { id = 1 }
    ]
