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
using Toybox.Activity;
using Toybox.Position;
using Toybox.Sensor;
using Toybox.System as Sys;

//
// CLASS
//

class RL_Data {

  //
  // VARIABLES
  //

  // Inputs
  // ... system
  public var fSystemBattery as Float?;
  public var iSystemMemoryUsed as Number?;
  public var iSystemMemoryFree as Number?;
  // ... position
  public var dPositionLatitude as Double?;
  public var dPositionLongitude as Double?;
  public var fPositionAltitude as Float?;
  public var fPositionSpeed as Float?;
  public var fPositionHeading as Float?;
  public var ePositionAccuracy as Position.Quality?;
  // ... sensor
  public var fSensorAltitude as Float?;
  public var fSensorSpeed as Float?;
  public var fSensorHeading as Float?;
  public var fSensorPressure as Float?;
  public var iSensorAccelerationX as Number?;
  public var iSensorAccelerationY as Number?;
  public var iSensorAccelerationZ as Number?;
  public var aiSensorAccelerationX_HD as Array<Number>?;
  public var aiSensorAccelerationY_HD as Array<Number>?;
  public var aiSensorAccelerationZ_HD as Array<Number>?;
  public var iSensorMagnetometerX as Number?;
  public var iSensorMagnetometerY as Number?;
  public var iSensorMagnetometerZ as Number?;
  public var iSensorHeartrate as Number?;
  public var iSensorCadence as Number?;
  public var iSensorPower as Number?;
  public var fSensorTemperature as Float?;
  // ... activity
  public var dActivityLatitude as Double?;
  public var dActivityLongitude as Double?;
  public var fActivityAltitude as Float?;
  public var fActivitySpeed as Float?;
  public var fActivityHeading as Float?;
  public var eActivityAccuracy as Position.Quality?;
  public var fActivityPressureRaw as Float?;
  public var fActivityPressureAmbient as Float?;
  public var fActivityPressureMean as Float?;
  public var iActivityHeartrate as Number?;
  public var iActivityCadence as Number?;
  public var iActivityPower as Number?;


  //
  // FUNCTIONS: self
  //

  function storeSystemStats(_oStats as Sys.Stats) as Void {
    // ... battery
    if(_oStats has :battery and _oStats.battery != null) {
      self.fSystemBattery = _oStats.battery;
    }
    else {
      self.fSystemBattery = null;
    }
    // ... memory (used)
    if(_oStats has :usedMemory and _oStats.usedMemory != null) {
      self.iSystemMemoryUsed = _oStats.usedMemory;
    }
    else {
      self.iSystemMemoryUsed = null;
    }
    // ... memory (free)
    if(_oStats has :freeMemory and _oStats.freeMemory != null) {
      self.iSystemMemoryFree = _oStats.freeMemory;
    }
    else {
      self.iSystemMemoryFree = null;
    }
  }

  function storePositionInfo(_oInfo as Position.Info) as Void {
    // ... position
    if(_oInfo has :position and _oInfo.position != null) {
      var afLocation = (_oInfo.position as Position.Location).toDegrees();
      self.dPositionLatitude = afLocation[0];
      self.dPositionLongitude = afLocation[1];
    }
    else {
      self.dPositionLatitude = null;
      self.dPositionLongitude = null;
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
      self.ePositionAccuracy = _oInfo.accuracy;
    }
    else {
      self.ePositionAccuracy = null;
    }
  }

  function storeSensorInfo(_oInfo as Sensor.Info) as Void {
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
      self.iSensorAccelerationX = (_oInfo.accel as Array<Number>)[0];
      self.iSensorAccelerationY = (_oInfo.accel as Array<Number>)[1];
      self.iSensorAccelerationZ = (_oInfo.accel as Array<Number>)[2];
    }
    else {
      self.iSensorAccelerationX = null;
      self.iSensorAccelerationY = null;
      self.iSensorAccelerationZ = null;
    }
    // ... magnetometer
    if(_oInfo has :mag and _oInfo.mag != null) {
      self.iSensorMagnetometerX = (_oInfo.mag as Array<Number>)[0];
      self.iSensorMagnetometerY = (_oInfo.mag as Array<Number>)[1];
      self.iSensorMagnetometerZ = (_oInfo.mag as Array<Number>)[2];
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

  function storeSensorData(_oData as Sensor.SensorData) as Void {
    // ... acceleration
    if(_oData has :accelerometerData and _oData.accelerometerData != null) {
      self.aiSensorAccelerationX_HD = (_oData.accelerometerData as Sensor.AccelerometerData).x;
      self.aiSensorAccelerationY_HD = (_oData.accelerometerData as Sensor.AccelerometerData).y;
      self.aiSensorAccelerationZ_HD = (_oData.accelerometerData as Sensor.AccelerometerData).z;
    }
    else {
      self.aiSensorAccelerationX_HD = null;
      self.aiSensorAccelerationY_HD = null;
      self.aiSensorAccelerationZ_HD = null;
    }
  }

  function storeActivityInfo(_oInfo as Activity.Info) as Void {
    // ... position
    if(_oInfo has :currentLocation and _oInfo.currentLocation != null) {
      var afLocation = (_oInfo.currentLocation as Position.Location).toDegrees();
      self.dActivityLatitude = afLocation[0];
      self.dActivityLongitude = afLocation[1];
    }
    else {
      self.dActivityLatitude = null;
      self.dActivityLongitude = null;
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
      self.eActivityAccuracy = _oInfo.currentLocationAccuracy;
    }
    else {
      self.eActivityAccuracy = null;
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
