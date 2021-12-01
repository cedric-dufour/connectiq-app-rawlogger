// -*- mode:java; tab-width:2; c-basic-offset:2; intent-tabs-mode:nil; -*- ex: set tabstop=2 expandtab:

// ConnectIQ Raw Logger (RawLogger)
// Copyright (C) 2018-2019 Cedric Dufour <http://cedric.dufour.name>
//
// ConnectIQ Raw Logger (RawLogger) is free software:
// you can redistribute it and/or modify it under the terms of the GNU General
// Public License as published by the Free Software Foundation, Version 3.
//
// ConnectIQ Raw Logger (RawLogger) is distributed in the hope that it will be
// useful, but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
//
// See the GNU General Public License for more details.
//
// SPDX-License-Identifier: GPL-3.0
// License-Filename: LICENSE/GPL-3.0.txt

import Toybox.Lang;
using Toybox.Application as App;

//
// CLASS
//

class RL_Settings {

  //
  // VARIABLES
  //

  // Inputs
  // ... system
  public var bSystemBattery as Boolean = false;
  public var bSystemMemory as Boolean = false;
  // ... position
  public var bPositionLocation as Boolean = false;
  public var bPositionAltitude as Boolean = false;
  public var bPositionSpeed as Boolean = false;
  public var bPositionHeading as Boolean = false;
  public var bPositionAccuracy as Boolean = false;
  // ... sensor
  public var bSensorAltitude as Boolean = false;
  public var bSensorSpeed as Boolean = false;
  public var bSensorHeading as Boolean = false;
  public var bSensorPressure as Boolean = false;
  public var bSensorAcceleration as Boolean = false;
  public var bSensorAcceleration_HD as Boolean = false;
  public var bSensorMagnetometer as Boolean = false;
  public var bSensorHeartrate as Boolean = false;
  public var bSensorCadence as Boolean = false;
  public var bSensorPower as Boolean = false;
  public var bSensorTemperature as Boolean = false;
  // ... activity
  public var bActivityLocation as Boolean = false;
  public var bActivityAltitude as Boolean = false;
  public var bActivitySpeed as Boolean = false;
  public var bActivityHeading as Boolean = false;
  public var bActivityAccuracy as Boolean = false;
  public var bActivityPressure as Boolean = false;
  public var bActivityHeartrate as Boolean = false;
  public var bActivityCadence as Boolean = false;
  public var bActivityPower as Boolean = false;


  //
  // FUNCTIONS: self
  //

  function load() as Void {
    // Inputs
    // ... system
    self.bSystemBattery = App.Properties.getValue("userSystemBattery") as Boolean;
    self.bSystemMemory = App.Properties.getValue("userSystemMemory") as Boolean;
    // ... position
    self.bPositionLocation = App.Properties.getValue("userPositionLocation") as Boolean;
    self.bPositionAltitude = App.Properties.getValue("userPositionAltitude") as Boolean;
    self.bPositionSpeed = App.Properties.getValue("userPositionSpeed") as Boolean;
    self.bPositionHeading = App.Properties.getValue("userPositionHeading") as Boolean;
    self.bPositionAccuracy = App.Properties.getValue("userPositionAccuracy") as Boolean;
    // ... sensor
    self.bSensorAltitude = App.Properties.getValue("userSensorAltitude") as Boolean;
    self.bSensorSpeed = App.Properties.getValue("userSensorSpeed") as Boolean;
    self.bSensorHeading = App.Properties.getValue("userSensorHeading") as Boolean;
    self.bSensorPressure = App.Properties.getValue("userSensorPressure") as Boolean;
    self.bSensorAcceleration = App.Properties.getValue("userSensorAcceleration") as Boolean;
    self.bSensorAcceleration_HD = App.Properties.getValue("userSensorAcceleration_HD") as Boolean;
    self.bSensorMagnetometer = App.Properties.getValue("userSensorMagnetometer") as Boolean;
    self.bSensorHeartrate = App.Properties.getValue("userSensorHeartrate") as Boolean;
    self.bSensorCadence = App.Properties.getValue("userSensorCadence") as Boolean;
    self.bSensorPower = App.Properties.getValue("userSensorPower") as Boolean;
    self.bSensorTemperature = App.Properties.getValue("userSensorTemperature") as Boolean;
    // ... activity
    self.bActivityLocation = App.Properties.getValue("userActivityLocation") as Boolean;
    self.bActivityAltitude = App.Properties.getValue("userActivityAltitude") as Boolean;
    self.bActivitySpeed = App.Properties.getValue("userActivitySpeed") as Boolean;
    self.bActivityHeading = App.Properties.getValue("userActivityHeading") as Boolean;
    self.bActivityAccuracy = App.Properties.getValue("userActivityAccuracy") as Boolean;
    self.bActivityPressure = App.Properties.getValue("userActivityPressure") as Boolean;
    self.bActivityHeartrate = App.Properties.getValue("userActivityHeartrate") as Boolean;
    self.bActivityCadence = App.Properties.getValue("userActivityCadence") as Boolean;
    self.bActivityPower = App.Properties.getValue("userActivityPower") as Boolean;
  }
}
