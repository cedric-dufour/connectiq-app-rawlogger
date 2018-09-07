// -*- mode:java; tab-width:2; c-basic-offset:2; intent-tabs-mode:nil; -*- ex: set tabstop=2 expandtab:

// ConnectIQ Raw Logger (RawLogger)
// Copyright (C) 2018 Cedric Dufour <http://cedric.dufour.name>
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

//
// CLASS
//

class RL_Data {

  //
  // VARIABLES
  //

  // Inputs
  // ... position
  public var fPositionLatitude;
  public var fPositionLongitude;
  public var fPositionAltitude;
  public var fPositionSpeed;
  public var fPositionHeading;
  public var iPositionAccuracy;
  // ... sensor
  public var fSensorAltitude;
  public var fSensorSpeed;
  public var fSensorHeading;
  public var fSensorPressure;
  public var iSensorAccelerationX;
  public var iSensorAccelerationY;
  public var iSensorAccelerationZ;
  public var iSensorMagnetometerX;
  public var iSensorMagnetometerY;
  public var iSensorMagnetometerZ;
  public var iSensorHeartrate;
  public var iSensorCadence;
  public var iSensorPower;
  public var fSensorTemperature;
  // ... activity
  public var fActivityLatitude;
  public var fActivityLongitude;
  public var fActivityAltitude;
  public var fActivitySpeed;
  public var fActivityHeading;
  public var iActivityAccuracy;
  public var fActivityPressureRaw;
  public var fActivityPressureAmbient;
  public var fActivityPressureMean;
  public var iActivityHeartrate;
  public var iActivityCadence;
  public var iActivityPower;

  
  //
  // FUNCTIONS: self
  //

  function storePositionInfo(_oInfo) {
    // ... position
    if(_oInfo has :position and _oInfo.position != null) {
      var afLocation = _oInfo.position.toDegrees();
      self.fPositionLatitude = afLocation[0];
      self.fPositionLongitude = afLocation[1];
    }
    else {
      self.fPositionLatitude = null;
      self.fPositionLongitude = null;
    }
    // ... altitude
    if(_oInfo has :altitude and _oInfo.altitude != null) {
      self.fPositionAltitude = _oInfo.altitude;
    }
    else {
      self.fPositionAltitude = null;
    }
    // ... speed
    if(_oInfo has :speed and _oInfo.speed != null) {
      self.fPositionSpeed = _oInfo.speed;
    }
    else {
      self.fPositionSpeed = null;
    }
    // ... heading
    if(_oInfo has :heading and _oInfo.heading != null) {
      self.fPositionHeading = _oInfo.heading;
    }
    else {
      self.fPositionHeading = null;
    }
    // ... accuracy
    if(_oInfo has :accuracy and _oInfo.accuracy != null) {
      self.iPositionAccuracy = _oInfo.accuracy;
    }
    else {
      self.iPositionAccuracy = null;
    }
  }

  function storeSensorInfo(_oInfo) {
    // ... altitude
    if(_oInfo has :altitude and _oInfo.altitude != null) {
      self.fSensorAltitude = _oInfo.altitude;
    }
    else {
      self.fSensorAltitude = null;
    }
    // ... speed
    if(_oInfo has :speed and _oInfo.speed != null) {
      self.fSensorSpeed = _oInfo.speed;
    }
    else {
      self.fSensorSpeed = null;
    }
    // ... heading
    if(_oInfo has :heading and _oInfo.heading != null) {
      self.fSensorHeading = _oInfo.heading;
    }
    else {
      self.fSensorHeading = null;
    }
    // ... pressure
    if(_oInfo has :pressure and _oInfo.pressure != null) {
      self.fSensorPressure = _oInfo.pressure;
    }
    else {
      self.fSensorPressure = null;
    }
    // ... acceleration
    if(_oInfo has :accel and _oInfo.accel != null) {
      self.iSensorAccelerationX = _oInfo.accel[0];
      self.iSensorAccelerationY = _oInfo.accel[1];
      self.iSensorAccelerationZ = _oInfo.accel[2];
    }
    else {
      self.iSensorAccelerationX = null;
      self.iSensorAccelerationY = null;
      self.iSensorAccelerationZ = null;
    }
    // ... magnetometer
    if(_oInfo has :mag and _oInfo.mag != null) {
      self.iSensorMagnetometerX = _oInfo.mag[0];
      self.iSensorMagnetometerY = _oInfo.mag[1];
      self.iSensorMagnetometerZ = _oInfo.mag[2];
    }
    else {
      self.iSensorMagnetometerX = null;
      self.iSensorMagnetometerY = null;
      self.iSensorMagnetometerZ = null;
    }
    // ... heartrate
    if(_oInfo has :heartRate and _oInfo.heartRate != null) {
      self.iSensorHeartrate = _oInfo.heartRate;
    }
    else {
      self.iSensorHeartrate = null;
    }
    // ... cadence
    if(_oInfo has :cadence and _oInfo.cadence != null) {
      self.iSensorCadence = _oInfo.cadence;
    }
    else {
      self.iSensorCadence = null;
    }
    // ... power
    if(_oInfo has :power and _oInfo.power != null) {
      self.iSensorPower = _oInfo.power;
    }
    else {
      self.iSensorPower = null;
    }
    // ... temperature
    if(_oInfo has :temperature and _oInfo.temperature != null) {
      self.fSensorTemperature = _oInfo.temperature;
    }
    else {
      self.fSensorTemperature = null;
    }
  }

  function storeActivityInfo(_oInfo) {
    // ... position
    if(_oInfo has :currentLocation and _oInfo.currentLocation != null) {
      var afLocation = _oInfo.currentLocation.toDegrees();
      self.fActivityLatitude = afLocation[0];
      self.fActivityLongitude = afLocation[1];
    }
    else {
      self.fActivityLatitude = null;
      self.fActivityLongitude = null;
    }
    // ... altitude
    if(_oInfo has :altitude and _oInfo.altitude != null) {
      self.fActivityAltitude = _oInfo.altitude;
    }
    else {
      self.fActivityAltitude = null;
    }
    // ... speed
    if(_oInfo has :currentSpeed and _oInfo.currentSpeed != null) {
      self.fActivitySpeed = _oInfo.currentSpeed;
    }
    else {
      self.fActivitySpeed = null;
    }
    // ... heading
    if(_oInfo has :currentHeading and _oInfo.currentHeading != null) {
      self.fActivityHeading = _oInfo.currentHeading;
    }
    else {
      self.fActivityHeading = null;
    }
    // ... accuracy
    if(_oInfo has :currentLocationAccuracy and _oInfo.currentLocationAccuracy != null) {
      self.iActivityAccuracy = _oInfo.currentLocationAccuracy;
    }
    else {
      self.iActivityAccuracy = null;
    }
    // ... pressure (raw)
    if(_oInfo has :rawAmbientPressure and _oInfo.rawAmbientPressure != null) {
      self.fActivityPressureRaw = _oInfo.rawAmbientPressure;
    }
    else {
      self.fActivityPressureRaw = null;
    }
    // ... pressure (ambient)
    if(_oInfo has :ambientPressure and _oInfo.ambientPressure != null) {
      self.fActivityPressureAmbient = _oInfo.ambientPressure;
    }
    else {
      self.fActivityPressureAmbient = null;
    }
    // ... pressure (mean)
    if(_oInfo has :meanSeaLevelPressure and _oInfo.meanSeaLevelPressure != null) {
      self.fActivityPressureMean = _oInfo.meanSeaLevelPressure;
    }
    else {
      self.fActivityPressureMean = null;
    }
    // ... heartrate
    if(_oInfo has :currentHeartRate and _oInfo.currentHeartRate != null) {
      self.iActivityHeartrate = _oInfo.currentHeartRate;
    }
    else {
      self.iActivityHeartrate = null;
    }
    // ... cadence
    if(_oInfo has :currentCadence and _oInfo.currentCadence != null) {
      self.iActivityCadence = _oInfo.currentCadence;
    }
    else {
      self.iActivityCadence = null;
    }
    // ... power
    if(_oInfo has :currentPower and _oInfo.currentPower != null) {
      self.iActivityPower = _oInfo.currentPower;
    }
    else {
      self.iActivityPower = null;
    }
  }

}
