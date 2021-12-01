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
using Toybox.ActivityRecording;
using Toybox.Application as App;
using Toybox.FitContributor as Fit;
using Toybox.Position;
using Toybox.Sensor;
using Toybox.System as Sys;
using Toybox.Timer;
using Toybox.WatchUi as Ui;

//
// GLOBALS
//

// Application settings
var RL_oSettings as RL_Settings = new RL_Settings();

// Application data
var RL_oData as RL_Data = new RL_Data();

// Activity session (recording)
var RL_oActivitySession as ActivityRecording.Session? = null;
// ... system inputs
var RL_oFitField_SystemBattery as Fit.Field? = null;
var RL_oFitField_SystemMemoryUsed as Fit.Field? = null;
var RL_oFitField_SystemMemoryFree as Fit.Field? = null;
// ... position inputs
var RL_oFitField_PositionLatitude as Fit.Field? = null;
var RL_oFitField_PositionLongitude as Fit.Field? = null;
var RL_oFitField_PositionAltitude as Fit.Field? = null;
var RL_oFitField_PositionSpeed as Fit.Field? = null;
var RL_oFitField_PositionHeading as Fit.Field? = null;
var RL_oFitField_PositionAccuracy as Fit.Field? = null;
// ... sensor inputs
var RL_oFitField_SensorAltitude as Fit.Field? = null;
var RL_oFitField_SensorSpeed as Fit.Field? = null;
var RL_oFitField_SensorHeading as Fit.Field? = null;
var RL_oFitField_SensorPressure as Fit.Field? = null;
var RL_oFitField_SensorAccelerationX as Fit.Field? = null;
var RL_oFitField_SensorAccelerationY as Fit.Field? = null;
var RL_oFitField_SensorAccelerationZ as Fit.Field? = null;
var RL_oFitField_SensorAccelerationX_HD as Fit.Field? = null;
var RL_oFitField_SensorAccelerationY_HD as Fit.Field? = null;
var RL_oFitField_SensorAccelerationZ_HD as Fit.Field? = null;
var RL_oFitField_SensorMagnetometerX as Fit.Field? = null;
var RL_oFitField_SensorMagnetometerY as Fit.Field? = null;
var RL_oFitField_SensorMagnetometerZ as Fit.Field? = null;
var RL_oFitField_SensorHeartrate as Fit.Field? = null;
var RL_oFitField_SensorCadence as Fit.Field? = null;
var RL_oFitField_SensorPower as Fit.Field? = null;
var RL_oFitField_SensorTemperature as Fit.Field? = null;
// ... activity inputs
var RL_oFitField_ActivityLatitude as Fit.Field? = null;
var RL_oFitField_ActivityLongitude as Fit.Field? = null;
var RL_oFitField_ActivityAltitude as Fit.Field? = null;
var RL_oFitField_ActivitySpeed as Fit.Field? = null;
var RL_oFitField_ActivityHeading as Fit.Field? = null;
var RL_oFitField_ActivityAccuracy as Fit.Field? = null;
var RL_oFitField_ActivityPressureRaw as Fit.Field? = null;
var RL_oFitField_ActivityPressureAmbient as Fit.Field? = null;
var RL_oFitField_ActivityPressureMean as Fit.Field? = null;
var RL_oFitField_ActivityHeartrate as Fit.Field? = null;
var RL_oFitField_ActivityCadence as Fit.Field? = null;
var RL_oFitField_ActivityPower as Fit.Field? = null;

// Current view
var RL_oCurrentView as Ui.View? = null;


//
// CLASS
//

class RL_App extends App.AppBase {

  //
  // CONSTANTS
  //

  // FIT fields (as per resources/fit.xml)
  // ... system inputs
  public const FITFIELD_SYSTEMBATTERY = 1;
  public const FITFIELD_SYSTEMMEMORYUSED = 2;
  public const FITFIELD_SYSTEMMEMORYFREE = 3;
  // ... position inputs
  public const FITFIELD_POSITIONLATITUDE = 51;
  public const FITFIELD_POSITIONLONGITUDE = 52;
  public const FITFIELD_POSITIONALTITUDE = 53;
  public const FITFIELD_POSITIONSPEED = 54;
  public const FITFIELD_POSITIONHEADING = 55;
  public const FITFIELD_POSITIONACCURACY = 56;
  // ... sensor inputs
  public const FITFIELD_SENSORALTITUDE = 101;
  public const FITFIELD_SENSORSPEED = 102;
  public const FITFIELD_SENSORHEADING = 103;
  public const FITFIELD_SENSORPRESSURE = 104;
  public const FITFIELD_SENSORACCELERATIONX = 105;
  public const FITFIELD_SENSORACCELERATIONY = 106;
  public const FITFIELD_SENSORACCELERATIONZ = 107;
  public const FITFIELD_SENSORMAGNETOMETERX = 108;
  public const FITFIELD_SENSORMAGNETOMETERY = 109;
  public const FITFIELD_SENSORMAGNETOMETERZ = 110;
  public const FITFIELD_SENSORHEARTRATE = 111;
  public const FITFIELD_SENSORCADENCE = 112;
  public const FITFIELD_SENSORPOWER = 113;
  public const FITFIELD_SENSORTEMPERATURE = 114;
  // ... sensor inputs (high-definition)
  public const FITFIELD_SENSORACCELERATIONX_HD = 131;
  public const FITFIELD_SENSORACCELERATIONY_HD = 132;
  public const FITFIELD_SENSORACCELERATIONZ_HD = 133;
  // ... activity inputs
  public const FITFIELD_ACTIVITYLATITUDE = 151;
  public const FITFIELD_ACTIVITYLONGITUDE = 152;
  public const FITFIELD_ACTIVITYALTITUDE = 153;
  public const FITFIELD_ACTIVITYSPEED = 154;
  public const FITFIELD_ACTIVITYHEADING = 155;
  public const FITFIELD_ACTIVITYACCURACY = 156;
  public const FITFIELD_ACTIVITYPRESSURERAW = 157;
  public const FITFIELD_ACTIVITYPRESSUREAMBIENT = 158;
  public const FITFIELD_ACTIVITYPRESSUREMEAN = 159;
  public const FITFIELD_ACTIVITYHEARTRATE = 160;
  public const FITFIELD_ACTIVITYCADENCE = 161;
  public const FITFIELD_ACTIVITYPOWER = 162;

  // High-definition data sample rates
  public const SAMPLERATE_ACCELERATION_HD = 25;


  //
  // VARIABLES
  //

  // Timers
  private var oUpdateTimer as Timer.Timer?;


  //
  // FUNCTIONS: App.AppBase (override/implement)
  //

  function initialize() {
    AppBase.initialize();

    // Timers
    // ... UI update
    self.oUpdateTimer = null;
  }

  function onStart(state) {
    //Sys.println("DEBUG: RL_App.onStart()");

    // Load settings
    $.RL_oSettings.load();

    // Enable position events
    Position.enableLocationEvents(Position.LOCATION_CONTINUOUS, method(:onLocationEvent));

    // Enable sensor events
    Sensor.setEnabledSensors([Sensor.SENSOR_BIKESPEED, Sensor.SENSOR_BIKECADENCE, Sensor.SENSOR_BIKEPOWER, Sensor.SENSOR_HEARTRATE, Sensor.SENSOR_TEMPERATURE] as Array<Sensor.SensorType>);
    Sensor.enableSensorEvents(method(:onSensorEvent));

    // Start UI update timer (every multiple of 5 seconds, to save energy)
    // NOTE: in normal circumstances, UI update will be triggered by position events (every ~1 second)
    self.oUpdateTimer = new Timer.Timer();
    var iUpdateTimerDelay = (60-Sys.getClockTime().sec)%5;
    if(iUpdateTimerDelay > 0) {
      (self.oUpdateTimer as Timer.Timer).start(method(:onUpdateTimer_init), 1000*iUpdateTimerDelay, false);
    }
    else {
      (self.oUpdateTimer as Timer.Timer).start(method(:onUpdateTimer), 5000, true);
    }
  }

  function onStop(state) {
    //Sys.println("DEBUG: RL_App.onStop()");

    // Stop timers
    // ... UI update
    if(self.oUpdateTimer != null) {
      (self.oUpdateTimer as Timer.Timer).stop();
      self.oUpdateTimer = null;
    }

    // Disable sensor events
    Sensor.setEnabledSensors([] as Array<Sensor.SensorType>);
    Sensor.enableSensorEvents(null);

    // Disable position events
    Position.enableLocationEvents(Position.LOCATION_DISABLE, method(:onLocationEvent));
  }

  function getInitialView() {
    //Sys.println("DEBUG: RL_App.getInitialView()");

    return [new RL_View(), new RL_ViewDelegate()] as Array<Ui.Views or Ui.InputDelegates>;
  }

  function onSettingsChanged() {
    //Sys.println("DEBUG: RL_App.onSettingsChanged()");
    $.RL_oSettings.load();
    self.updateUi();
  }


  //
  // FUNCTIONS: self
  //

  function initActivity() as Void {
    if($.RL_oActivitySession == null) {
      var oActivitySession = ActivityRecording.createSession({ :name => "RawLogger", :sport => ActivityRecording.SPORT_GENERIC, :subSport => ActivityRecording.SUB_SPORT_GENERIC });
      var iFitFields = 16;  // ... it would seem ConnectIQ allows only 16 contributed FIT fields (undocumented)
      var iFitBytes = 256;  // ... FIT message can be no longer than 256 bytes
      var bHighDefListener_Acceleration = false;

      // ... system inputs
      if($.RL_oSettings.bSystemBattery and iFitFields >= 1 and iFitBytes >= 4) {
        $.RL_oFitField_SystemBattery = oActivitySession.createField("SystemBattery", RL_App.FITFIELD_SYSTEMBATTERY, Fit.DATA_TYPE_FLOAT, { :mesgType => Fit.MESG_TYPE_RECORD as Number, :units => Ui.loadResource(Rez.Strings.unitSystemBattery) as String });
        iFitFields -= 1;
        iFitBytes -= 4;
      }
      if($.RL_oSettings.bSystemMemory and iFitFields >= 2 and iFitBytes >= 8) {
        $.RL_oFitField_SystemMemoryUsed = oActivitySession.createField("SystemMemoryUsed", RL_App.FITFIELD_SYSTEMMEMORYUSED, Fit.DATA_TYPE_UINT32, { :mesgType => Fit.MESG_TYPE_RECORD as Number, :units => Ui.loadResource(Rez.Strings.unitSystemMemory) as String });
        $.RL_oFitField_SystemMemoryFree = oActivitySession.createField("SystemMemoryFree", RL_App.FITFIELD_SYSTEMMEMORYFREE, Fit.DATA_TYPE_UINT32, { :mesgType => Fit.MESG_TYPE_RECORD as Number, :units => Ui.loadResource(Rez.Strings.unitSystemMemory) as String });
        iFitFields -= 2;
        iFitBytes -= 8;
      }

      // ... position inputs
      if($.RL_oSettings.bPositionLocation and iFitFields >= 2 and iFitBytes >= 8) {
        $.RL_oFitField_PositionLatitude = oActivitySession.createField("PositionLatitude", RL_App.FITFIELD_POSITIONLATITUDE, Fit.DATA_TYPE_FLOAT, { :mesgType => Fit.MESG_TYPE_RECORD as Number, :units => Ui.loadResource(Rez.Strings.unitPositionLocation) as String });
        $.RL_oFitField_PositionLongitude = oActivitySession.createField("PositionLongitude", RL_App.FITFIELD_POSITIONLONGITUDE, Fit.DATA_TYPE_FLOAT, { :mesgType => Fit.MESG_TYPE_RECORD as Number, :units => Ui.loadResource(Rez.Strings.unitPositionLocation) as String });
        iFitFields -= 2;
        iFitBytes -= 8;
      }
      if($.RL_oSettings.bPositionAltitude and iFitFields >= 1 and iFitBytes >= 4) {
        $.RL_oFitField_PositionAltitude = oActivitySession.createField("PositionAltitude", RL_App.FITFIELD_POSITIONALTITUDE, Fit.DATA_TYPE_FLOAT, { :mesgType => Fit.MESG_TYPE_RECORD as Number, :units => Ui.loadResource(Rez.Strings.unitPositionAltitude) as String });
        iFitFields -= 1;
        iFitBytes -= 4;
      }
      if($.RL_oSettings.bPositionSpeed and iFitFields >= 1 and iFitBytes >= 4) {
        $.RL_oFitField_PositionSpeed = oActivitySession.createField("PositionSpeed", RL_App.FITFIELD_POSITIONSPEED, Fit.DATA_TYPE_FLOAT, { :mesgType => Fit.MESG_TYPE_RECORD as Number, :units => Ui.loadResource(Rez.Strings.unitPositionSpeed) as String });
        iFitFields -= 1;
        iFitBytes -= 4;
      }
      if($.RL_oSettings.bPositionHeading and iFitFields >= 1 and iFitBytes >= 4) {
        $.RL_oFitField_PositionHeading = oActivitySession.createField("PositionHeading", RL_App.FITFIELD_POSITIONHEADING, Fit.DATA_TYPE_FLOAT, { :mesgType => Fit.MESG_TYPE_RECORD as Number, :units => Ui.loadResource(Rez.Strings.unitPositionHeading) as String });
        iFitFields -= 1;
        iFitBytes -= 4;
      }
      if($.RL_oSettings.bPositionAccuracy and iFitFields >= 1 and iFitBytes >= 1) {
        $.RL_oFitField_PositionAccuracy = oActivitySession.createField("PositionAccuracy", RL_App.FITFIELD_POSITIONACCURACY, Fit.DATA_TYPE_UINT8, { :mesgType => Fit.MESG_TYPE_RECORD as Number, :units => Ui.loadResource(Rez.Strings.unitPositionAccuracy) as String });
        iFitFields -= 1;
        iFitBytes -= 1;
      }

      // ... sensor inputs
      if($.RL_oSettings.bSensorAltitude and iFitFields >= 1 and iFitBytes >= 4) {
        $.RL_oFitField_SensorAltitude = oActivitySession.createField("SensorAltitude", RL_App.FITFIELD_SENSORALTITUDE, Fit.DATA_TYPE_FLOAT, { :mesgType => Fit.MESG_TYPE_RECORD as Number, :units => Ui.loadResource(Rez.Strings.unitSensorAltitude) as String });
        iFitFields -= 1;
        iFitBytes -= 4;
      }
      if($.RL_oSettings.bSensorSpeed and iFitFields >= 1 and iFitBytes >= 4) {
        $.RL_oFitField_SensorSpeed = oActivitySession.createField("SensorSpeed", RL_App.FITFIELD_SENSORSPEED, Fit.DATA_TYPE_FLOAT, { :mesgType => Fit.MESG_TYPE_RECORD as Number, :units => Ui.loadResource(Rez.Strings.unitSensorSpeed) as String });
        iFitFields -= 1;
        iFitBytes -= 4;
      }
      if($.RL_oSettings.bSensorHeading and iFitFields >= 1 and iFitBytes >= 4) {
        $.RL_oFitField_SensorHeading = oActivitySession.createField("SensorHeading", RL_App.FITFIELD_SENSORHEADING, Fit.DATA_TYPE_FLOAT, { :mesgType => Fit.MESG_TYPE_RECORD as Number, :units => Ui.loadResource(Rez.Strings.unitSensorHeading) as String });
        iFitFields -= 1;
        iFitBytes -= 4;
      }
      if($.RL_oSettings.bSensorPressure and iFitFields >= 1 and iFitBytes >= 4) {
        $.RL_oFitField_SensorPressure = oActivitySession.createField("SensorPressure", RL_App.FITFIELD_SENSORPRESSURE, Fit.DATA_TYPE_FLOAT, { :mesgType => Fit.MESG_TYPE_RECORD as Number, :units => Ui.loadResource(Rez.Strings.unitSensorPressure) as String });
        iFitFields -= 1;
        iFitBytes -= 4;
      }
      if($.RL_oSettings.bSensorAcceleration and iFitFields >= 3 and iFitBytes >= 6) {
        $.RL_oFitField_SensorAccelerationX = oActivitySession.createField("SensorAccelerationX", RL_App.FITFIELD_SENSORACCELERATIONX, Fit.DATA_TYPE_SINT16, { :mesgType => Fit.MESG_TYPE_RECORD as Number, :units => Ui.loadResource(Rez.Strings.unitSensorAcceleration) as String });
        $.RL_oFitField_SensorAccelerationY = oActivitySession.createField("SensorAccelerationY", RL_App.FITFIELD_SENSORACCELERATIONY, Fit.DATA_TYPE_SINT16, { :mesgType => Fit.MESG_TYPE_RECORD as Number, :units => Ui.loadResource(Rez.Strings.unitSensorAcceleration) as String });
        $.RL_oFitField_SensorAccelerationZ = oActivitySession.createField("SensorAccelerationZ", RL_App.FITFIELD_SENSORACCELERATIONZ, Fit.DATA_TYPE_SINT16, { :mesgType => Fit.MESG_TYPE_RECORD as Number, :units => Ui.loadResource(Rez.Strings.unitSensorAcceleration) as String });
        iFitFields -= 3;
        iFitBytes -= 6;
      }
      if($.RL_oSettings.bSensorAcceleration_HD and iFitFields >= 3 and iFitBytes >= 6*RL_App.SAMPLERATE_ACCELERATION_HD) {
        $.RL_oFitField_SensorAccelerationX_HD = oActivitySession.createField("SensorAccelerationX_HD", RL_App.FITFIELD_SENSORACCELERATIONX_HD, Fit.DATA_TYPE_SINT16, { :count => RL_App.SAMPLERATE_ACCELERATION_HD, :mesgType => Fit.MESG_TYPE_RECORD as Number, :units => Ui.loadResource(Rez.Strings.unitSensorAcceleration) as String });
        $.RL_oFitField_SensorAccelerationY_HD = oActivitySession.createField("SensorAccelerationY_HD", RL_App.FITFIELD_SENSORACCELERATIONY_HD, Fit.DATA_TYPE_SINT16, { :count => RL_App.SAMPLERATE_ACCELERATION_HD, :mesgType => Fit.MESG_TYPE_RECORD as Number, :units => Ui.loadResource(Rez.Strings.unitSensorAcceleration) as String });
        $.RL_oFitField_SensorAccelerationZ_HD = oActivitySession.createField("SensorAccelerationZ_HD", RL_App.FITFIELD_SENSORACCELERATIONZ_HD, Fit.DATA_TYPE_SINT16, { :count => RL_App.SAMPLERATE_ACCELERATION_HD, :mesgType => Fit.MESG_TYPE_RECORD as Number, :units => Ui.loadResource(Rez.Strings.unitSensorAcceleration) as String });
        iFitFields -= 3;
        iFitBytes -= 6*RL_App.SAMPLERATE_ACCELERATION_HD;
        bHighDefListener_Acceleration = true;
      }
      if($.RL_oSettings.bSensorMagnetometer and iFitFields >= 3 and iFitBytes >= 6) {
        $.RL_oFitField_SensorMagnetometerX = oActivitySession.createField("SensorMagnetometerX", RL_App.FITFIELD_SENSORMAGNETOMETERX, Fit.DATA_TYPE_SINT16, { :mesgType => Fit.MESG_TYPE_RECORD as Number, :units => Ui.loadResource(Rez.Strings.unitSensorMagnetometer) as String });
        $.RL_oFitField_SensorMagnetometerY = oActivitySession.createField("SensorMagnetometerY", RL_App.FITFIELD_SENSORMAGNETOMETERY, Fit.DATA_TYPE_SINT16, { :mesgType => Fit.MESG_TYPE_RECORD as Number, :units => Ui.loadResource(Rez.Strings.unitSensorMagnetometer) as String });
        $.RL_oFitField_SensorMagnetometerZ = oActivitySession.createField("SensorMagnetometerZ", RL_App.FITFIELD_SENSORMAGNETOMETERZ, Fit.DATA_TYPE_SINT16, { :mesgType => Fit.MESG_TYPE_RECORD as Number, :units => Ui.loadResource(Rez.Strings.unitSensorMagnetometer) as String });
        iFitFields -= 3;
        iFitBytes -= 6;
      }
      if($.RL_oSettings.bSensorHeartrate and iFitFields >= 1 and iFitBytes >= 2) {
        $.RL_oFitField_SensorHeartrate = oActivitySession.createField("SensorHeartrate", RL_App.FITFIELD_SENSORHEARTRATE, Fit.DATA_TYPE_UINT16, { :mesgType => Fit.MESG_TYPE_RECORD as Number, :units => Ui.loadResource(Rez.Strings.unitSensorHeartrate) as String });
        iFitFields -= 1;
        iFitBytes -= 2;
      }
      if($.RL_oSettings.bSensorCadence and iFitFields >= 1 and iFitBytes >= 2) {
        $.RL_oFitField_SensorCadence = oActivitySession.createField("SensorCadence", RL_App.FITFIELD_SENSORCADENCE, Fit.DATA_TYPE_UINT16, { :mesgType => Fit.MESG_TYPE_RECORD as Number, :units => Ui.loadResource(Rez.Strings.unitSensorCadence) as String });
        iFitFields -= 1;
        iFitBytes -= 2;
      }
      if($.RL_oSettings.bSensorPower and iFitFields >= 1 and iFitBytes >= 2) {
        $.RL_oFitField_SensorPower = oActivitySession.createField("SensorPower", RL_App.FITFIELD_SENSORPOWER, Fit.DATA_TYPE_UINT16, { :mesgType => Fit.MESG_TYPE_RECORD as Number, :units => Ui.loadResource(Rez.Strings.unitSensorPower) as String });
        iFitFields -= 1;
        iFitBytes -= 2;
      }
      if($.RL_oSettings.bSensorTemperature and iFitFields >= 1 and iFitBytes >= 4) {
        $.RL_oFitField_SensorTemperature = oActivitySession.createField("SensorTemperature", RL_App.FITFIELD_SENSORTEMPERATURE, Fit.DATA_TYPE_FLOAT, { :mesgType => Fit.MESG_TYPE_RECORD as Number, :units => Ui.loadResource(Rez.Strings.unitSensorTemperature) as String });
        iFitFields -= 1;
        iFitBytes -= 4;
      }

      // ... activity inputs
      if($.RL_oSettings.bActivityLocation and iFitFields >= 2 and iFitBytes >= 8) {
        $.RL_oFitField_ActivityLatitude = oActivitySession.createField("ActivityLatitude", RL_App.FITFIELD_ACTIVITYLATITUDE, Fit.DATA_TYPE_FLOAT, { :mesgType => Fit.MESG_TYPE_RECORD as Number, :units => Ui.loadResource(Rez.Strings.unitActivityLocation) as String });
        $.RL_oFitField_ActivityLongitude = oActivitySession.createField("ActivityLongitude", RL_App.FITFIELD_ACTIVITYLONGITUDE, Fit.DATA_TYPE_FLOAT, { :mesgType => Fit.MESG_TYPE_RECORD as Number, :units => Ui.loadResource(Rez.Strings.unitActivityLocation) as String });
        iFitFields -= 2;
        iFitBytes -= 8;
      }
      if($.RL_oSettings.bActivityAltitude and iFitFields >= 1 and iFitBytes >= 4) {
        $.RL_oFitField_ActivityAltitude = oActivitySession.createField("ActivityAltitude", RL_App.FITFIELD_ACTIVITYALTITUDE, Fit.DATA_TYPE_FLOAT, { :mesgType => Fit.MESG_TYPE_RECORD as Number, :units => Ui.loadResource(Rez.Strings.unitActivityAltitude) as String });
        iFitFields -= 1;
        iFitBytes -= 4;
      }
      if($.RL_oSettings.bActivitySpeed and iFitFields >= 1 and iFitBytes >= 4) {
        $.RL_oFitField_ActivitySpeed = oActivitySession.createField("ActivitySpeed", RL_App.FITFIELD_ACTIVITYSPEED, Fit.DATA_TYPE_FLOAT, { :mesgType => Fit.MESG_TYPE_RECORD as Number, :units => Ui.loadResource(Rez.Strings.unitActivitySpeed) as String });
        iFitFields -= 1;
        iFitBytes -= 4;
      }
      if($.RL_oSettings.bActivityHeading and iFitFields >= 1 and iFitBytes >= 4) {
        $.RL_oFitField_ActivityHeading = oActivitySession.createField("ActivityHeading", RL_App.FITFIELD_ACTIVITYHEADING, Fit.DATA_TYPE_FLOAT, { :mesgType => Fit.MESG_TYPE_RECORD as Number, :units => Ui.loadResource(Rez.Strings.unitActivityHeading) as String });
        iFitFields -= 1;
        iFitBytes -= 4;
      }
      if($.RL_oSettings.bActivityAccuracy and iFitFields >= 1 and iFitBytes >= 2) {
        $.RL_oFitField_ActivityAccuracy = oActivitySession.createField("ActivityAccuracy", RL_App.FITFIELD_ACTIVITYACCURACY, Fit.DATA_TYPE_UINT16, { :mesgType => Fit.MESG_TYPE_RECORD as Number, :units => Ui.loadResource(Rez.Strings.unitActivityAccuracy) as String });
        iFitFields -= 1;
        iFitBytes -= 2;
      }
      if($.RL_oSettings.bActivityPressure and iFitFields >= 3 and iFitBytes >= 12) {
        $.RL_oFitField_ActivityPressureRaw = oActivitySession.createField("ActivityPressureRaw", RL_App.FITFIELD_ACTIVITYPRESSURERAW, Fit.DATA_TYPE_FLOAT, { :mesgType => Fit.MESG_TYPE_RECORD as Number, :units => Ui.loadResource(Rez.Strings.unitActivityPressure) as String });
        $.RL_oFitField_ActivityPressureAmbient = oActivitySession.createField("ActivityPressureAmbient", RL_App.FITFIELD_ACTIVITYPRESSUREAMBIENT, Fit.DATA_TYPE_FLOAT, { :mesgType => Fit.MESG_TYPE_RECORD as Number, :units => Ui.loadResource(Rez.Strings.unitActivityPressure) as String });
        $.RL_oFitField_ActivityPressureMean = oActivitySession.createField("ActivityPressureMean", RL_App.FITFIELD_ACTIVITYPRESSUREMEAN, Fit.DATA_TYPE_FLOAT, { :mesgType => Fit.MESG_TYPE_RECORD as Number, :units => Ui.loadResource(Rez.Strings.unitActivityPressure) as String });
        iFitFields -= 3;
        iFitBytes -= 12;
      }
      if($.RL_oSettings.bActivityHeartrate and iFitFields >= 1 and iFitBytes >= 2) {
        $.RL_oFitField_ActivityHeartrate = oActivitySession.createField("ActivityHeartrate", RL_App.FITFIELD_ACTIVITYHEARTRATE, Fit.DATA_TYPE_UINT16, { :mesgType => Fit.MESG_TYPE_RECORD as Number, :units => Ui.loadResource(Rez.Strings.unitActivityHeartrate) as String });
        iFitFields -= 1;
        iFitBytes -= 2;
      }
      if($.RL_oSettings.bActivityCadence and iFitFields >= 1 and iFitBytes >= 2) {
        $.RL_oFitField_ActivityCadence = oActivitySession.createField("ActivityCadence", RL_App.FITFIELD_ACTIVITYCADENCE, Fit.DATA_TYPE_UINT16, { :mesgType => Fit.MESG_TYPE_RECORD as Number, :units => Ui.loadResource(Rez.Strings.unitActivityCadence) as String });
        iFitFields -= 1;
        iFitBytes -= 2;
      }
      if($.RL_oSettings.bActivityPower and iFitFields >= 1 and iFitBytes >= 1) {
        $.RL_oFitField_ActivityPower = oActivitySession.createField("ActivityPower", RL_App.FITFIELD_ACTIVITYPOWER, Fit.DATA_TYPE_UINT8, { :mesgType => Fit.MESG_TYPE_RECORD as Number, :units => Ui.loadResource(Rez.Strings.unitActivityPower) as String });
        iFitFields -= 1;
        iFitBytes -= 1;
      }

      // ... high-definition data listener
      if(bHighDefListener_Acceleration) {
        Sensor.registerSensorDataListener(method(:onSensorData), { :period => 1, :accelerometer =>  { :enabled => true, :sampleRate => RL_App.SAMPLERATE_ACCELERATION_HD } });
      }

      // ... done
      $.RL_oActivitySession = oActivitySession;
    }
  }

  function resetActivity() as Void {
    $.RL_oActivitySession = null;

    // ... high-definition data listener
    Sensor.unregisterSensorDataListener();

    // ... system inputs
    $.RL_oFitField_SystemBattery = null;
    $.RL_oFitField_SystemMemoryUsed = null;
    $.RL_oFitField_SystemMemoryFree = null;

    // ... position inputs
    $.RL_oFitField_PositionLatitude = null;
    $.RL_oFitField_PositionLongitude = null;
    $.RL_oFitField_PositionAltitude = null;
    $.RL_oFitField_PositionSpeed = null;
    $.RL_oFitField_PositionHeading = null;
    $.RL_oFitField_PositionAccuracy = null;

    // ... sensor inputs
    $.RL_oFitField_SensorAltitude = null;
    $.RL_oFitField_SensorSpeed = null;
    $.RL_oFitField_SensorHeading = null;
    $.RL_oFitField_SensorPressure = null;
    $.RL_oFitField_SensorAccelerationX = null;
    $.RL_oFitField_SensorAccelerationY = null;
    $.RL_oFitField_SensorAccelerationZ = null;
    $.RL_oFitField_SensorAccelerationX_HD = null;
    $.RL_oFitField_SensorAccelerationY_HD = null;
    $.RL_oFitField_SensorAccelerationZ_HD = null;
    $.RL_oFitField_SensorMagnetometerX = null;
    $.RL_oFitField_SensorMagnetometerY = null;
    $.RL_oFitField_SensorMagnetometerZ = null;
    $.RL_oFitField_SensorHeartrate = null;
    $.RL_oFitField_SensorCadence = null;
    $.RL_oFitField_SensorPower = null;
    $.RL_oFitField_SensorTemperature = null;

    // ... activity inputs
    $.RL_oFitField_ActivityLatitude = null;
    $.RL_oFitField_ActivityLongitude = null;
    $.RL_oFitField_ActivityAltitude = null;
    $.RL_oFitField_ActivitySpeed = null;
    $.RL_oFitField_ActivityHeading = null;
    $.RL_oFitField_ActivityAccuracy = null;
    $.RL_oFitField_ActivityPressureRaw = null;
    $.RL_oFitField_ActivityPressureAmbient = null;
    $.RL_oFitField_ActivityPressureMean = null;
    $.RL_oFitField_ActivityHeartrate = null;
    $.RL_oFitField_ActivityCadence = null;
    $.RL_oFitField_ActivityPower = null;
  }

  function onLocationEvent(_oInfo as Position.Info) as Void {
    //Sys.println("DEBUG: RL_App.onLocationEvent()");

    // Save FIT fields

    // ... system inputs
    self.saveSystemStats();

    // ... position inputs
    $.RL_oData.storePositionInfo(_oInfo);
    if($.RL_oData.dPositionLatitude != null and $.RL_oFitField_PositionLatitude != null) {
      ($.RL_oFitField_PositionLatitude as Fit.Field).setData($.RL_oData.dPositionLatitude as Object);
    }
    if($.RL_oData.dPositionLongitude != null and $.RL_oFitField_PositionLongitude != null) {
      ($.RL_oFitField_PositionLongitude as Fit.Field).setData($.RL_oData.dPositionLongitude as Object);
    }
    if($.RL_oData.fPositionAltitude != null and $.RL_oFitField_PositionAltitude != null) {
      ($.RL_oFitField_PositionAltitude as Fit.Field).setData($.RL_oData.fPositionAltitude as Object);
    }
    if($.RL_oData.fPositionSpeed != null and $.RL_oFitField_PositionSpeed != null) {
      ($.RL_oFitField_PositionSpeed as Fit.Field).setData($.RL_oData.fPositionSpeed as Object);
    }
    if($.RL_oData.fPositionHeading != null and $.RL_oFitField_PositionHeading != null) {
      ($.RL_oFitField_PositionHeading as Fit.Field).setData($.RL_oData.fPositionHeading as Object);
    }
    if($.RL_oData.ePositionAccuracy != null and $.RL_oFitField_PositionAccuracy != null) {
      ($.RL_oFitField_PositionAccuracy as Fit.Field).setData($.RL_oData.ePositionAccuracy as Object);
    }

    // ... activity inputs
    self.saveActivityInfo();

    // UI update
    self.updateUi();
  }

  function onSensorEvent(_oInfo as Sensor.Info) as Void {
    //Sys.println("DEBUG: RL_App.onSensorEvent());

    // Save FIT fields

    // ... system inputs
    self.saveSystemStats();

    // ... sensor inputs
    $.RL_oData.storeSensorInfo(_oInfo);
    if($.RL_oData.fSensorAltitude != null and $.RL_oFitField_SensorAltitude != null) {
      ($.RL_oFitField_SensorAltitude as Fit.Field).setData($.RL_oData.fSensorAltitude as Object);
    }
    if($.RL_oData.fSensorSpeed != null and $.RL_oFitField_SensorSpeed != null) {
      ($.RL_oFitField_SensorSpeed as Fit.Field).setData($.RL_oData.fSensorSpeed as Object);
    }
    if($.RL_oData.fSensorHeading != null and $.RL_oFitField_SensorHeading != null) {
      ($.RL_oFitField_SensorHeading as Fit.Field).setData($.RL_oData.fSensorHeading as Object);
    }
    if($.RL_oData.fSensorPressure != null and $.RL_oFitField_SensorPressure != null) {
      ($.RL_oFitField_SensorPressure as Fit.Field).setData($.RL_oData.fSensorPressure as Object);
    }
    if($.RL_oData.iSensorAccelerationX != null and $.RL_oFitField_SensorAccelerationX != null) {
      ($.RL_oFitField_SensorAccelerationX as Fit.Field).setData($.RL_oData.iSensorAccelerationX as Object);
    }
    if($.RL_oData.iSensorAccelerationY != null and $.RL_oFitField_SensorAccelerationY != null) {
      ($.RL_oFitField_SensorAccelerationY as Fit.Field).setData($.RL_oData.iSensorAccelerationY as Object);
    }
    if($.RL_oData.iSensorAccelerationZ != null and $.RL_oFitField_SensorAccelerationZ != null) {
      ($.RL_oFitField_SensorAccelerationZ as Fit.Field).setData($.RL_oData.iSensorAccelerationZ as Object);
    }
    if($.RL_oData.iSensorMagnetometerX != null and $.RL_oFitField_SensorMagnetometerX != null) {
      ($.RL_oFitField_SensorMagnetometerX as Fit.Field).setData($.RL_oData.iSensorMagnetometerX as Object);
    }
    if($.RL_oData.iSensorMagnetometerY != null and $.RL_oFitField_SensorMagnetometerY != null) {
      ($.RL_oFitField_SensorMagnetometerY as Fit.Field).setData($.RL_oData.iSensorMagnetometerY as Object);
    }
    if($.RL_oData.iSensorMagnetometerZ != null and $.RL_oFitField_SensorMagnetometerZ != null) {
      ($.RL_oFitField_SensorMagnetometerZ as Fit.Field).setData($.RL_oData.iSensorMagnetometerZ as Object);
    }
    if($.RL_oData.iSensorHeartrate != null and $.RL_oFitField_SensorHeartrate != null) {
      ($.RL_oFitField_SensorHeartrate as Fit.Field).setData($.RL_oData.iSensorHeartrate as Object);
    }
    if($.RL_oData.iSensorCadence != null and $.RL_oFitField_SensorCadence != null) {
      ($.RL_oFitField_SensorCadence as Fit.Field).setData($.RL_oData.iSensorCadence as Object);
    }
    if($.RL_oData.iSensorPower != null and $.RL_oFitField_SensorPower != null) {
      ($.RL_oFitField_SensorPower as Fit.Field).setData($.RL_oData.iSensorPower as Object);
    }
    if($.RL_oData.fSensorTemperature != null and $.RL_oFitField_SensorTemperature != null) {
      ($.RL_oFitField_SensorTemperature as Fit.Field).setData($.RL_oData.fSensorTemperature as Object);
    }

    // ... activity inputs
    self.saveActivityInfo();

    // UI update
    self.updateUi();
  }

  function onSensorData(_oData as Sensor.SensorData) as Void {
    //Sys.println("DEBUG: RL_App.onSensorData());

    // Save FIT fields

    // ... sensor inputs
    $.RL_oData.storeSensorData(_oData);
    if($.RL_oData.aiSensorAccelerationX_HD != null and $.RL_oFitField_SensorAccelerationX_HD != null) {
      ($.RL_oFitField_SensorAccelerationX_HD as Fit.Field).setData(($.RL_oData.aiSensorAccelerationX_HD as Array<Number>).slice(0, RL_App.SAMPLERATE_ACCELERATION_HD) as Object);
    }
    if($.RL_oData.aiSensorAccelerationY_HD != null and $.RL_oFitField_SensorAccelerationY_HD != null) {
      ($.RL_oFitField_SensorAccelerationY_HD as Fit.Field).setData(($.RL_oData.aiSensorAccelerationY_HD as Array<Number>).slice(0, RL_App.SAMPLERATE_ACCELERATION_HD) as Object);
    }
    if($.RL_oData.aiSensorAccelerationZ_HD != null and $.RL_oFitField_SensorAccelerationZ_HD != null) {
      ($.RL_oFitField_SensorAccelerationZ_HD as Fit.Field).setData(($.RL_oData.aiSensorAccelerationZ_HD as Array<Number>).slice(0, RL_App.SAMPLERATE_ACCELERATION_HD) as Object);
    }

    // UI update
    self.updateUi();
  }

  function saveSystemStats() as Void {
    //Sys.println("DEBUG: RL_App.saveSystemStats()");
    $.RL_oData.storeSystemStats(Sys.getSystemStats());

    // Save FIT fields
    // ... system inputs
    if($.RL_oData.fSystemBattery != null and $.RL_oFitField_SystemBattery != null) {
      ($.RL_oFitField_SystemBattery as Fit.Field).setData($.RL_oData.fSystemBattery as Object);
    }
    if($.RL_oData.iSystemMemoryUsed != null and $.RL_oFitField_SystemMemoryUsed != null) {
      ($.RL_oFitField_SystemMemoryUsed as Fit.Field).setData($.RL_oData.iSystemMemoryUsed as Object);
    }
    if($.RL_oData.iSystemMemoryFree != null and $.RL_oFitField_SystemMemoryFree != null) {
      ($.RL_oFitField_SystemMemoryFree as Fit.Field).setData($.RL_oData.iSystemMemoryFree as Object);
    }
  }

  function saveActivityInfo() as Void {
    //Sys.println("DEBUG: RL_App.saveActivityInfo());
    var oInfo = Activity.getActivityInfo();
    if(oInfo != null) {
      $.RL_oData.storeActivityInfo(oInfo as Activity.Info);
    }

    // Save FIT fields
    // ... activity inputs
    if($.RL_oData.dActivityLatitude != null and $.RL_oFitField_ActivityLatitude != null) {
      ($.RL_oFitField_ActivityLatitude as Fit.Field).setData($.RL_oData.dActivityLatitude as Object);
    }
    if($.RL_oData.dActivityLongitude != null and $.RL_oFitField_ActivityLongitude != null) {
      ($.RL_oFitField_ActivityLongitude as Fit.Field).setData($.RL_oData.dActivityLongitude as Object);
    }
    if($.RL_oData.fActivityAltitude != null and $.RL_oFitField_ActivityAltitude != null) {
      ($.RL_oFitField_ActivityAltitude as Fit.Field).setData($.RL_oData.fActivityAltitude as Object);
    }
    if($.RL_oData.fActivitySpeed != null and $.RL_oFitField_ActivitySpeed != null) {
      ($.RL_oFitField_ActivitySpeed as Fit.Field).setData($.RL_oData.fActivitySpeed as Object);
    }
    if($.RL_oData.fActivityHeading != null and $.RL_oFitField_ActivityHeading != null) {
      ($.RL_oFitField_ActivityHeading as Fit.Field).setData($.RL_oData.fActivityHeading as Object);
    }
    if($.RL_oData.eActivityAccuracy != null and $.RL_oFitField_ActivityAccuracy != null) {
      ($.RL_oFitField_ActivityAccuracy as Fit.Field).setData($.RL_oData.eActivityAccuracy as Object);
    }
    if($.RL_oData.fActivityPressureRaw != null and $.RL_oFitField_ActivityPressureRaw != null) {
      ($.RL_oFitField_ActivityPressureRaw as Fit.Field).setData($.RL_oData.fActivityPressureRaw as Object);
    }
    if($.RL_oData.fActivityPressureAmbient != null and $.RL_oFitField_ActivityPressureAmbient != null) {
      ($.RL_oFitField_ActivityPressureAmbient as Fit.Field).setData($.RL_oData.fActivityPressureAmbient as Object);
    }
    if($.RL_oData.fActivityPressureMean != null and $.RL_oFitField_ActivityPressureMean != null) {
      ($.RL_oFitField_ActivityPressureMean as Fit.Field).setData($.RL_oData.fActivityPressureMean as Object);
    }
    if($.RL_oData.iActivityHeartrate != null and $.RL_oFitField_ActivityHeartrate != null) {
      ($.RL_oFitField_ActivityHeartrate as Fit.Field).setData($.RL_oData.iActivityHeartrate as Object);
    }
    if($.RL_oData.iActivityCadence != null and $.RL_oFitField_ActivityCadence != null) {
      ($.RL_oFitField_ActivityCadence as Fit.Field).setData($.RL_oData.iActivityCadence as Object);
    }
    if($.RL_oData.iActivityPower != null and $.RL_oFitField_ActivityPower != null) {
      ($.RL_oFitField_ActivityPower as Fit.Field).setData($.RL_oData.iActivityPower as Object);
    }
  }

  function onUpdateTimer_init() as Void {
    //Sys.println("DEBUG: RL_App.onUpdateTimer_init()");
    self.onUpdateTimer();
    self.oUpdateTimer = new Timer.Timer();
    self.oUpdateTimer.start(method(:onUpdateTimer), 5000, true);
  }

  function onUpdateTimer() as Void {
    //Sys.println("DEBUG: RL_App.onUpdateTimer()");
    self.updateUi();
  }

  function updateUi() as Void {
    //Sys.println("DEBUG: RL_App.updateUi()");

    // Update UI
    if($.RL_oCurrentView != null) {
      ($.RL_oCurrentView as RL_View).updateUi();
    }
  }

}
