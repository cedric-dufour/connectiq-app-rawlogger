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
  public var bSystemBattery;
  public var bSystemMemory;
  // ... position
  public var bPositionLocation;
  public var bPositionAltitude;
  public var bPositionSpeed;
  public var bPositionHeading;
  public var bPositionAccuracy;
  // ... sensor
  public var bSensorAltitude;
  public var bSensorSpeed;
  public var bSensorHeading;
  public var bSensorPressure;
  public var bSensorAcceleration;
  public var bSensorAcceleration_HD;
  public var bSensorMagnetometer;
  public var bSensorHeartrate;
  public var bSensorCadence;
  public var bSensorPower;
  public var bSensorTemperature;
  // ... activity
  public var bActivityLocation;
  public var bActivityAltitude;
  public var bActivitySpeed;
  public var bActivityHeading;
  public var bActivityAccuracy;
  public var bActivityPressure;
  public var bActivityHeartrate;
  public var bActivityCadence;
  public var bActivityPower;

  
  //
  // FUNCTIONS: self
  //

  function load() {
    // Inputs
    // ... system
    self.bSystemBattery = App.Properties.getValue("userSystemBattery");
    self.bSystemMemory = App.Properties.getValue("userSystemMemory");
    // ... position
    self.bPositionLocation = App.Properties.getValue("userPositionLocation");
    self.bPositionAltitude = App.Properties.getValue("userPositionAltitude");
    self.bPositionSpeed = App.Properties.getValue("userPositionSpeed");
    self.bPositionHeading = App.Properties.getValue("userPositionHeading");
    self.bPositionAccuracy = App.Properties.getValue("userPositionAccuracy");
    // ... sensor
    self.bSensorAltitude = App.Properties.getValue("userSensorAltitude");
    self.bSensorSpeed = App.Properties.getValue("userSensorSpeed");
    self.bSensorHeading = App.Properties.getValue("userSensorHeading");
    self.bSensorPressure = App.Properties.getValue("userSensorPressure");
    self.bSensorAcceleration = App.Properties.getValue("userSensorAcceleration");
    self.bSensorAcceleration_HD = App.Properties.getValue("userSensorAcceleration_HD");
    self.bSensorMagnetometer = App.Properties.getValue("userSensorMagnetometer");
    self.bSensorHeartrate = App.Properties.getValue("userSensorHeartrate");
    self.bSensorCadence = App.Properties.getValue("userSensorCadence");
    self.bSensorPower = App.Properties.getValue("userSensorPower");
    self.bSensorTemperature = App.Properties.getValue("userSensorTemperature");
    // ... activity
    self.bActivityLocation = App.Properties.getValue("userActivityLocation");
    self.bActivityAltitude = App.Properties.getValue("userActivityAltitude");
    self.bActivitySpeed = App.Properties.getValue("userActivitySpeed");
    self.bActivityHeading = App.Properties.getValue("userActivityHeading");
    self.bActivityAccuracy = App.Properties.getValue("userActivityAccuracy");
    self.bActivityPressure = App.Properties.getValue("userActivityPressure");
    self.bActivityHeartrate = App.Properties.getValue("userActivityHeartrate");
    self.bActivityCadence = App.Properties.getValue("userActivityCadence");
    self.bActivityPower = App.Properties.getValue("userActivityPower");
  }
}
