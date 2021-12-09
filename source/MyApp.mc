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
var oMySettings as MySettings = new MySettings();

// Application data
var oMyData as MyData = new MyData();

// Activity session (recording)
var oMyActivitySession as ActivityRecording.Session? = null;
// ... system inputs
var oMyFitField_SystemBattery as Fit.Field? = null;
var oMyFitField_SystemMemoryUsed as Fit.Field? = null;
var oMyFitField_SystemMemoryFree as Fit.Field? = null;
// ... position inputs
var oMyFitField_PositionLatitude as Fit.Field? = null;
var oMyFitField_PositionLongitude as Fit.Field? = null;
var oMyFitField_PositionAltitude as Fit.Field? = null;
var oMyFitField_PositionSpeed as Fit.Field? = null;
var oMyFitField_PositionHeading as Fit.Field? = null;
var oMyFitField_PositionAccuracy as Fit.Field? = null;
// ... sensor inputs
var oMyFitField_SensorAltitude as Fit.Field? = null;
var oMyFitField_SensorSpeed as Fit.Field? = null;
var oMyFitField_SensorHeading as Fit.Field? = null;
var oMyFitField_SensorPressure as Fit.Field? = null;
var oMyFitField_SensorAccelerationX as Fit.Field? = null;
var oMyFitField_SensorAccelerationY as Fit.Field? = null;
var oMyFitField_SensorAccelerationZ as Fit.Field? = null;
var oMyFitField_SensorAccelerationX_HD as Fit.Field? = null;
var oMyFitField_SensorAccelerationY_HD as Fit.Field? = null;
var oMyFitField_SensorAccelerationZ_HD as Fit.Field? = null;
var oMyFitField_SensorMagnetometerX as Fit.Field? = null;
var oMyFitField_SensorMagnetometerY as Fit.Field? = null;
var oMyFitField_SensorMagnetometerZ as Fit.Field? = null;
var oMyFitField_SensorHeartrate as Fit.Field? = null;
var oMyFitField_SensorCadence as Fit.Field? = null;
var oMyFitField_SensorPower as Fit.Field? = null;
var oMyFitField_SensorTemperature as Fit.Field? = null;
// ... activity inputs
var oMyFitField_ActivityLatitude as Fit.Field? = null;
var oMyFitField_ActivityLongitude as Fit.Field? = null;
var oMyFitField_ActivityAltitude as Fit.Field? = null;
var oMyFitField_ActivitySpeed as Fit.Field? = null;
var oMyFitField_ActivityHeading as Fit.Field? = null;
var oMyFitField_ActivityAccuracy as Fit.Field? = null;
var oMyFitField_ActivityPressureRaw as Fit.Field? = null;
var oMyFitField_ActivityPressureAmbient as Fit.Field? = null;
var oMyFitField_ActivityPressureMean as Fit.Field? = null;
var oMyFitField_ActivityHeartrate as Fit.Field? = null;
var oMyFitField_ActivityCadence as Fit.Field? = null;
var oMyFitField_ActivityPower as Fit.Field? = null;

// Current view
var oMyView as Ui.View? = null;


//
// CLASS
//

class MyApp extends App.AppBase {

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
    //Sys.println("DEBUG: MyApp.onStart()");

    // Load settings
    $.oMySettings.load();

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
    //Sys.println("DEBUG: MyApp.onStop()");

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
    //Sys.println("DEBUG: MyApp.getInitialView()");

    return [new MyView(), new MyViewDelegate()] as Array<Ui.Views or Ui.InputDelegates>;
  }

  function onSettingsChanged() {
    //Sys.println("DEBUG: MyApp.onSettingsChanged()");
    $.oMySettings.load();
    self.updateUi();
  }


  //
  // FUNCTIONS: self
  //

  function initActivity() as Void {
    if($.oMyActivitySession == null) {
      var oActivitySession = ActivityRecording.createSession({ :name => "RawLogger", :sport => ActivityRecording.SPORT_GENERIC, :subSport => ActivityRecording.SUB_SPORT_GENERIC });
      var iFitFields = 16;  // ... it would seem ConnectIQ allows only 16 contributed FIT fields (undocumented)
      var iFitBytes = 256;  // ... FIT message can be no longer than 256 bytes
      var bHighDefListener_Acceleration = false;

      // ... system inputs
      if($.oMySettings.bSystemBattery and iFitFields >= 1 and iFitBytes >= 4) {
        $.oMyFitField_SystemBattery = oActivitySession.createField("SystemBattery", MyApp.FITFIELD_SYSTEMBATTERY, Fit.DATA_TYPE_FLOAT, { :mesgType => Fit.MESG_TYPE_RECORD as Number, :units => Ui.loadResource(Rez.Strings.unitSystemBattery) as String });
        iFitFields -= 1;
        iFitBytes -= 4;
      }
      if($.oMySettings.bSystemMemory and iFitFields >= 2 and iFitBytes >= 8) {
        $.oMyFitField_SystemMemoryUsed = oActivitySession.createField("SystemMemoryUsed", MyApp.FITFIELD_SYSTEMMEMORYUSED, Fit.DATA_TYPE_UINT32, { :mesgType => Fit.MESG_TYPE_RECORD as Number, :units => Ui.loadResource(Rez.Strings.unitSystemMemory) as String });
        $.oMyFitField_SystemMemoryFree = oActivitySession.createField("SystemMemoryFree", MyApp.FITFIELD_SYSTEMMEMORYFREE, Fit.DATA_TYPE_UINT32, { :mesgType => Fit.MESG_TYPE_RECORD as Number, :units => Ui.loadResource(Rez.Strings.unitSystemMemory) as String });
        iFitFields -= 2;
        iFitBytes -= 8;
      }

      // ... position inputs
      if($.oMySettings.bPositionLocation and iFitFields >= 2 and iFitBytes >= 8) {
        $.oMyFitField_PositionLatitude = oActivitySession.createField("PositionLatitude", MyApp.FITFIELD_POSITIONLATITUDE, Fit.DATA_TYPE_FLOAT, { :mesgType => Fit.MESG_TYPE_RECORD as Number, :units => Ui.loadResource(Rez.Strings.unitPositionLocation) as String });
        $.oMyFitField_PositionLongitude = oActivitySession.createField("PositionLongitude", MyApp.FITFIELD_POSITIONLONGITUDE, Fit.DATA_TYPE_FLOAT, { :mesgType => Fit.MESG_TYPE_RECORD as Number, :units => Ui.loadResource(Rez.Strings.unitPositionLocation) as String });
        iFitFields -= 2;
        iFitBytes -= 8;
      }
      if($.oMySettings.bPositionAltitude and iFitFields >= 1 and iFitBytes >= 4) {
        $.oMyFitField_PositionAltitude = oActivitySession.createField("PositionAltitude", MyApp.FITFIELD_POSITIONALTITUDE, Fit.DATA_TYPE_FLOAT, { :mesgType => Fit.MESG_TYPE_RECORD as Number, :units => Ui.loadResource(Rez.Strings.unitPositionAltitude) as String });
        iFitFields -= 1;
        iFitBytes -= 4;
      }
      if($.oMySettings.bPositionSpeed and iFitFields >= 1 and iFitBytes >= 4) {
        $.oMyFitField_PositionSpeed = oActivitySession.createField("PositionSpeed", MyApp.FITFIELD_POSITIONSPEED, Fit.DATA_TYPE_FLOAT, { :mesgType => Fit.MESG_TYPE_RECORD as Number, :units => Ui.loadResource(Rez.Strings.unitPositionSpeed) as String });
        iFitFields -= 1;
        iFitBytes -= 4;
      }
      if($.oMySettings.bPositionHeading and iFitFields >= 1 and iFitBytes >= 4) {
        $.oMyFitField_PositionHeading = oActivitySession.createField("PositionHeading", MyApp.FITFIELD_POSITIONHEADING, Fit.DATA_TYPE_FLOAT, { :mesgType => Fit.MESG_TYPE_RECORD as Number, :units => Ui.loadResource(Rez.Strings.unitPositionHeading) as String });
        iFitFields -= 1;
        iFitBytes -= 4;
      }
      if($.oMySettings.bPositionAccuracy and iFitFields >= 1 and iFitBytes >= 1) {
        $.oMyFitField_PositionAccuracy = oActivitySession.createField("PositionAccuracy", MyApp.FITFIELD_POSITIONACCURACY, Fit.DATA_TYPE_UINT8, { :mesgType => Fit.MESG_TYPE_RECORD as Number, :units => Ui.loadResource(Rez.Strings.unitPositionAccuracy) as String });
        iFitFields -= 1;
        iFitBytes -= 1;
      }

      // ... sensor inputs
      if($.oMySettings.bSensorAltitude and iFitFields >= 1 and iFitBytes >= 4) {
        $.oMyFitField_SensorAltitude = oActivitySession.createField("SensorAltitude", MyApp.FITFIELD_SENSORALTITUDE, Fit.DATA_TYPE_FLOAT, { :mesgType => Fit.MESG_TYPE_RECORD as Number, :units => Ui.loadResource(Rez.Strings.unitSensorAltitude) as String });
        iFitFields -= 1;
        iFitBytes -= 4;
      }
      if($.oMySettings.bSensorSpeed and iFitFields >= 1 and iFitBytes >= 4) {
        $.oMyFitField_SensorSpeed = oActivitySession.createField("SensorSpeed", MyApp.FITFIELD_SENSORSPEED, Fit.DATA_TYPE_FLOAT, { :mesgType => Fit.MESG_TYPE_RECORD as Number, :units => Ui.loadResource(Rez.Strings.unitSensorSpeed) as String });
        iFitFields -= 1;
        iFitBytes -= 4;
      }
      if($.oMySettings.bSensorHeading and iFitFields >= 1 and iFitBytes >= 4) {
        $.oMyFitField_SensorHeading = oActivitySession.createField("SensorHeading", MyApp.FITFIELD_SENSORHEADING, Fit.DATA_TYPE_FLOAT, { :mesgType => Fit.MESG_TYPE_RECORD as Number, :units => Ui.loadResource(Rez.Strings.unitSensorHeading) as String });
        iFitFields -= 1;
        iFitBytes -= 4;
      }
      if($.oMySettings.bSensorPressure and iFitFields >= 1 and iFitBytes >= 4) {
        $.oMyFitField_SensorPressure = oActivitySession.createField("SensorPressure", MyApp.FITFIELD_SENSORPRESSURE, Fit.DATA_TYPE_FLOAT, { :mesgType => Fit.MESG_TYPE_RECORD as Number, :units => Ui.loadResource(Rez.Strings.unitSensorPressure) as String });
        iFitFields -= 1;
        iFitBytes -= 4;
      }
      if($.oMySettings.bSensorAcceleration and iFitFields >= 3 and iFitBytes >= 6) {
        $.oMyFitField_SensorAccelerationX = oActivitySession.createField("SensorAccelerationX", MyApp.FITFIELD_SENSORACCELERATIONX, Fit.DATA_TYPE_SINT16, { :mesgType => Fit.MESG_TYPE_RECORD as Number, :units => Ui.loadResource(Rez.Strings.unitSensorAcceleration) as String });
        $.oMyFitField_SensorAccelerationY = oActivitySession.createField("SensorAccelerationY", MyApp.FITFIELD_SENSORACCELERATIONY, Fit.DATA_TYPE_SINT16, { :mesgType => Fit.MESG_TYPE_RECORD as Number, :units => Ui.loadResource(Rez.Strings.unitSensorAcceleration) as String });
        $.oMyFitField_SensorAccelerationZ = oActivitySession.createField("SensorAccelerationZ", MyApp.FITFIELD_SENSORACCELERATIONZ, Fit.DATA_TYPE_SINT16, { :mesgType => Fit.MESG_TYPE_RECORD as Number, :units => Ui.loadResource(Rez.Strings.unitSensorAcceleration) as String });
        iFitFields -= 3;
        iFitBytes -= 6;
      }
      if($.oMySettings.bSensorAcceleration_HD and iFitFields >= 3 and iFitBytes >= 6*MyApp.SAMPLERATE_ACCELERATION_HD) {
        $.oMyFitField_SensorAccelerationX_HD = oActivitySession.createField("SensorAccelerationX_HD", MyApp.FITFIELD_SENSORACCELERATIONX_HD, Fit.DATA_TYPE_SINT16, { :count => MyApp.SAMPLERATE_ACCELERATION_HD, :mesgType => Fit.MESG_TYPE_RECORD as Number, :units => Ui.loadResource(Rez.Strings.unitSensorAcceleration) as String });
        $.oMyFitField_SensorAccelerationY_HD = oActivitySession.createField("SensorAccelerationY_HD", MyApp.FITFIELD_SENSORACCELERATIONY_HD, Fit.DATA_TYPE_SINT16, { :count => MyApp.SAMPLERATE_ACCELERATION_HD, :mesgType => Fit.MESG_TYPE_RECORD as Number, :units => Ui.loadResource(Rez.Strings.unitSensorAcceleration) as String });
        $.oMyFitField_SensorAccelerationZ_HD = oActivitySession.createField("SensorAccelerationZ_HD", MyApp.FITFIELD_SENSORACCELERATIONZ_HD, Fit.DATA_TYPE_SINT16, { :count => MyApp.SAMPLERATE_ACCELERATION_HD, :mesgType => Fit.MESG_TYPE_RECORD as Number, :units => Ui.loadResource(Rez.Strings.unitSensorAcceleration) as String });
        iFitFields -= 3;
        iFitBytes -= 6*MyApp.SAMPLERATE_ACCELERATION_HD;
        bHighDefListener_Acceleration = true;
      }
      if($.oMySettings.bSensorMagnetometer and iFitFields >= 3 and iFitBytes >= 6) {
        $.oMyFitField_SensorMagnetometerX = oActivitySession.createField("SensorMagnetometerX", MyApp.FITFIELD_SENSORMAGNETOMETERX, Fit.DATA_TYPE_SINT16, { :mesgType => Fit.MESG_TYPE_RECORD as Number, :units => Ui.loadResource(Rez.Strings.unitSensorMagnetometer) as String });
        $.oMyFitField_SensorMagnetometerY = oActivitySession.createField("SensorMagnetometerY", MyApp.FITFIELD_SENSORMAGNETOMETERY, Fit.DATA_TYPE_SINT16, { :mesgType => Fit.MESG_TYPE_RECORD as Number, :units => Ui.loadResource(Rez.Strings.unitSensorMagnetometer) as String });
        $.oMyFitField_SensorMagnetometerZ = oActivitySession.createField("SensorMagnetometerZ", MyApp.FITFIELD_SENSORMAGNETOMETERZ, Fit.DATA_TYPE_SINT16, { :mesgType => Fit.MESG_TYPE_RECORD as Number, :units => Ui.loadResource(Rez.Strings.unitSensorMagnetometer) as String });
        iFitFields -= 3;
        iFitBytes -= 6;
      }
      if($.oMySettings.bSensorHeartrate and iFitFields >= 1 and iFitBytes >= 2) {
        $.oMyFitField_SensorHeartrate = oActivitySession.createField("SensorHeartrate", MyApp.FITFIELD_SENSORHEARTRATE, Fit.DATA_TYPE_UINT16, { :mesgType => Fit.MESG_TYPE_RECORD as Number, :units => Ui.loadResource(Rez.Strings.unitSensorHeartrate) as String });
        iFitFields -= 1;
        iFitBytes -= 2;
      }
      if($.oMySettings.bSensorCadence and iFitFields >= 1 and iFitBytes >= 2) {
        $.oMyFitField_SensorCadence = oActivitySession.createField("SensorCadence", MyApp.FITFIELD_SENSORCADENCE, Fit.DATA_TYPE_UINT16, { :mesgType => Fit.MESG_TYPE_RECORD as Number, :units => Ui.loadResource(Rez.Strings.unitSensorCadence) as String });
        iFitFields -= 1;
        iFitBytes -= 2;
      }
      if($.oMySettings.bSensorPower and iFitFields >= 1 and iFitBytes >= 2) {
        $.oMyFitField_SensorPower = oActivitySession.createField("SensorPower", MyApp.FITFIELD_SENSORPOWER, Fit.DATA_TYPE_UINT16, { :mesgType => Fit.MESG_TYPE_RECORD as Number, :units => Ui.loadResource(Rez.Strings.unitSensorPower) as String });
        iFitFields -= 1;
        iFitBytes -= 2;
      }
      if($.oMySettings.bSensorTemperature and iFitFields >= 1 and iFitBytes >= 4) {
        $.oMyFitField_SensorTemperature = oActivitySession.createField("SensorTemperature", MyApp.FITFIELD_SENSORTEMPERATURE, Fit.DATA_TYPE_FLOAT, { :mesgType => Fit.MESG_TYPE_RECORD as Number, :units => Ui.loadResource(Rez.Strings.unitSensorTemperature) as String });
        iFitFields -= 1;
        iFitBytes -= 4;
      }

      // ... activity inputs
      if($.oMySettings.bActivityLocation and iFitFields >= 2 and iFitBytes >= 8) {
        $.oMyFitField_ActivityLatitude = oActivitySession.createField("ActivityLatitude", MyApp.FITFIELD_ACTIVITYLATITUDE, Fit.DATA_TYPE_FLOAT, { :mesgType => Fit.MESG_TYPE_RECORD as Number, :units => Ui.loadResource(Rez.Strings.unitActivityLocation) as String });
        $.oMyFitField_ActivityLongitude = oActivitySession.createField("ActivityLongitude", MyApp.FITFIELD_ACTIVITYLONGITUDE, Fit.DATA_TYPE_FLOAT, { :mesgType => Fit.MESG_TYPE_RECORD as Number, :units => Ui.loadResource(Rez.Strings.unitActivityLocation) as String });
        iFitFields -= 2;
        iFitBytes -= 8;
      }
      if($.oMySettings.bActivityAltitude and iFitFields >= 1 and iFitBytes >= 4) {
        $.oMyFitField_ActivityAltitude = oActivitySession.createField("ActivityAltitude", MyApp.FITFIELD_ACTIVITYALTITUDE, Fit.DATA_TYPE_FLOAT, { :mesgType => Fit.MESG_TYPE_RECORD as Number, :units => Ui.loadResource(Rez.Strings.unitActivityAltitude) as String });
        iFitFields -= 1;
        iFitBytes -= 4;
      }
      if($.oMySettings.bActivitySpeed and iFitFields >= 1 and iFitBytes >= 4) {
        $.oMyFitField_ActivitySpeed = oActivitySession.createField("ActivitySpeed", MyApp.FITFIELD_ACTIVITYSPEED, Fit.DATA_TYPE_FLOAT, { :mesgType => Fit.MESG_TYPE_RECORD as Number, :units => Ui.loadResource(Rez.Strings.unitActivitySpeed) as String });
        iFitFields -= 1;
        iFitBytes -= 4;
      }
      if($.oMySettings.bActivityHeading and iFitFields >= 1 and iFitBytes >= 4) {
        $.oMyFitField_ActivityHeading = oActivitySession.createField("ActivityHeading", MyApp.FITFIELD_ACTIVITYHEADING, Fit.DATA_TYPE_FLOAT, { :mesgType => Fit.MESG_TYPE_RECORD as Number, :units => Ui.loadResource(Rez.Strings.unitActivityHeading) as String });
        iFitFields -= 1;
        iFitBytes -= 4;
      }
      if($.oMySettings.bActivityAccuracy and iFitFields >= 1 and iFitBytes >= 2) {
        $.oMyFitField_ActivityAccuracy = oActivitySession.createField("ActivityAccuracy", MyApp.FITFIELD_ACTIVITYACCURACY, Fit.DATA_TYPE_UINT16, { :mesgType => Fit.MESG_TYPE_RECORD as Number, :units => Ui.loadResource(Rez.Strings.unitActivityAccuracy) as String });
        iFitFields -= 1;
        iFitBytes -= 2;
      }
      if($.oMySettings.bActivityPressure and iFitFields >= 3 and iFitBytes >= 12) {
        $.oMyFitField_ActivityPressureRaw = oActivitySession.createField("ActivityPressureRaw", MyApp.FITFIELD_ACTIVITYPRESSURERAW, Fit.DATA_TYPE_FLOAT, { :mesgType => Fit.MESG_TYPE_RECORD as Number, :units => Ui.loadResource(Rez.Strings.unitActivityPressure) as String });
        $.oMyFitField_ActivityPressureAmbient = oActivitySession.createField("ActivityPressureAmbient", MyApp.FITFIELD_ACTIVITYPRESSUREAMBIENT, Fit.DATA_TYPE_FLOAT, { :mesgType => Fit.MESG_TYPE_RECORD as Number, :units => Ui.loadResource(Rez.Strings.unitActivityPressure) as String });
        $.oMyFitField_ActivityPressureMean = oActivitySession.createField("ActivityPressureMean", MyApp.FITFIELD_ACTIVITYPRESSUREMEAN, Fit.DATA_TYPE_FLOAT, { :mesgType => Fit.MESG_TYPE_RECORD as Number, :units => Ui.loadResource(Rez.Strings.unitActivityPressure) as String });
        iFitFields -= 3;
        iFitBytes -= 12;
      }
      if($.oMySettings.bActivityHeartrate and iFitFields >= 1 and iFitBytes >= 2) {
        $.oMyFitField_ActivityHeartrate = oActivitySession.createField("ActivityHeartrate", MyApp.FITFIELD_ACTIVITYHEARTRATE, Fit.DATA_TYPE_UINT16, { :mesgType => Fit.MESG_TYPE_RECORD as Number, :units => Ui.loadResource(Rez.Strings.unitActivityHeartrate) as String });
        iFitFields -= 1;
        iFitBytes -= 2;
      }
      if($.oMySettings.bActivityCadence and iFitFields >= 1 and iFitBytes >= 2) {
        $.oMyFitField_ActivityCadence = oActivitySession.createField("ActivityCadence", MyApp.FITFIELD_ACTIVITYCADENCE, Fit.DATA_TYPE_UINT16, { :mesgType => Fit.MESG_TYPE_RECORD as Number, :units => Ui.loadResource(Rez.Strings.unitActivityCadence) as String });
        iFitFields -= 1;
        iFitBytes -= 2;
      }
      if($.oMySettings.bActivityPower and iFitFields >= 1 and iFitBytes >= 1) {
        $.oMyFitField_ActivityPower = oActivitySession.createField("ActivityPower", MyApp.FITFIELD_ACTIVITYPOWER, Fit.DATA_TYPE_UINT8, { :mesgType => Fit.MESG_TYPE_RECORD as Number, :units => Ui.loadResource(Rez.Strings.unitActivityPower) as String });
        iFitFields -= 1;
        iFitBytes -= 1;
      }

      // ... high-definition data listener
      if(bHighDefListener_Acceleration) {
        Sensor.registerSensorDataListener(method(:onSensorData), { :period => 1, :accelerometer =>  { :enabled => true, :sampleRate => MyApp.SAMPLERATE_ACCELERATION_HD } });
      }

      // ... done
      $.oMyActivitySession = oActivitySession;
    }
  }

  function resetActivity() as Void {
    $.oMyActivitySession = null;

    // ... high-definition data listener
    Sensor.unregisterSensorDataListener();

    // ... system inputs
    $.oMyFitField_SystemBattery = null;
    $.oMyFitField_SystemMemoryUsed = null;
    $.oMyFitField_SystemMemoryFree = null;

    // ... position inputs
    $.oMyFitField_PositionLatitude = null;
    $.oMyFitField_PositionLongitude = null;
    $.oMyFitField_PositionAltitude = null;
    $.oMyFitField_PositionSpeed = null;
    $.oMyFitField_PositionHeading = null;
    $.oMyFitField_PositionAccuracy = null;

    // ... sensor inputs
    $.oMyFitField_SensorAltitude = null;
    $.oMyFitField_SensorSpeed = null;
    $.oMyFitField_SensorHeading = null;
    $.oMyFitField_SensorPressure = null;
    $.oMyFitField_SensorAccelerationX = null;
    $.oMyFitField_SensorAccelerationY = null;
    $.oMyFitField_SensorAccelerationZ = null;
    $.oMyFitField_SensorAccelerationX_HD = null;
    $.oMyFitField_SensorAccelerationY_HD = null;
    $.oMyFitField_SensorAccelerationZ_HD = null;
    $.oMyFitField_SensorMagnetometerX = null;
    $.oMyFitField_SensorMagnetometerY = null;
    $.oMyFitField_SensorMagnetometerZ = null;
    $.oMyFitField_SensorHeartrate = null;
    $.oMyFitField_SensorCadence = null;
    $.oMyFitField_SensorPower = null;
    $.oMyFitField_SensorTemperature = null;

    // ... activity inputs
    $.oMyFitField_ActivityLatitude = null;
    $.oMyFitField_ActivityLongitude = null;
    $.oMyFitField_ActivityAltitude = null;
    $.oMyFitField_ActivitySpeed = null;
    $.oMyFitField_ActivityHeading = null;
    $.oMyFitField_ActivityAccuracy = null;
    $.oMyFitField_ActivityPressureRaw = null;
    $.oMyFitField_ActivityPressureAmbient = null;
    $.oMyFitField_ActivityPressureMean = null;
    $.oMyFitField_ActivityHeartrate = null;
    $.oMyFitField_ActivityCadence = null;
    $.oMyFitField_ActivityPower = null;
  }

  function onLocationEvent(_oInfo as Position.Info) as Void {
    //Sys.println("DEBUG: MyApp.onLocationEvent()");

    // Save FIT fields

    // ... system inputs
    self.saveSystemStats();

    // ... position inputs
    $.oMyData.storePositionInfo(_oInfo);
    if($.oMyData.dPositionLatitude != null and $.oMyFitField_PositionLatitude != null) {
      ($.oMyFitField_PositionLatitude as Fit.Field).setData($.oMyData.dPositionLatitude as Object);
    }
    if($.oMyData.dPositionLongitude != null and $.oMyFitField_PositionLongitude != null) {
      ($.oMyFitField_PositionLongitude as Fit.Field).setData($.oMyData.dPositionLongitude as Object);
    }
    if($.oMyData.fPositionAltitude != null and $.oMyFitField_PositionAltitude != null) {
      ($.oMyFitField_PositionAltitude as Fit.Field).setData($.oMyData.fPositionAltitude as Object);
    }
    if($.oMyData.fPositionSpeed != null and $.oMyFitField_PositionSpeed != null) {
      ($.oMyFitField_PositionSpeed as Fit.Field).setData($.oMyData.fPositionSpeed as Object);
    }
    if($.oMyData.fPositionHeading != null and $.oMyFitField_PositionHeading != null) {
      ($.oMyFitField_PositionHeading as Fit.Field).setData($.oMyData.fPositionHeading as Object);
    }
    if($.oMyData.ePositionAccuracy != null and $.oMyFitField_PositionAccuracy != null) {
      ($.oMyFitField_PositionAccuracy as Fit.Field).setData($.oMyData.ePositionAccuracy as Object);
    }

    // ... activity inputs
    self.saveActivityInfo();

    // UI update
    self.updateUi();
  }

  function onSensorEvent(_oInfo as Sensor.Info) as Void {
    //Sys.println("DEBUG: MyApp.onSensorEvent());

    // Save FIT fields

    // ... system inputs
    self.saveSystemStats();

    // ... sensor inputs
    $.oMyData.storeSensorInfo(_oInfo);
    if($.oMyData.fSensorAltitude != null and $.oMyFitField_SensorAltitude != null) {
      ($.oMyFitField_SensorAltitude as Fit.Field).setData($.oMyData.fSensorAltitude as Object);
    }
    if($.oMyData.fSensorSpeed != null and $.oMyFitField_SensorSpeed != null) {
      ($.oMyFitField_SensorSpeed as Fit.Field).setData($.oMyData.fSensorSpeed as Object);
    }
    if($.oMyData.fSensorHeading != null and $.oMyFitField_SensorHeading != null) {
      ($.oMyFitField_SensorHeading as Fit.Field).setData($.oMyData.fSensorHeading as Object);
    }
    if($.oMyData.fSensorPressure != null and $.oMyFitField_SensorPressure != null) {
      ($.oMyFitField_SensorPressure as Fit.Field).setData($.oMyData.fSensorPressure as Object);
    }
    if($.oMyData.iSensorAccelerationX != null and $.oMyFitField_SensorAccelerationX != null) {
      ($.oMyFitField_SensorAccelerationX as Fit.Field).setData($.oMyData.iSensorAccelerationX as Object);
    }
    if($.oMyData.iSensorAccelerationY != null and $.oMyFitField_SensorAccelerationY != null) {
      ($.oMyFitField_SensorAccelerationY as Fit.Field).setData($.oMyData.iSensorAccelerationY as Object);
    }
    if($.oMyData.iSensorAccelerationZ != null and $.oMyFitField_SensorAccelerationZ != null) {
      ($.oMyFitField_SensorAccelerationZ as Fit.Field).setData($.oMyData.iSensorAccelerationZ as Object);
    }
    if($.oMyData.iSensorMagnetometerX != null and $.oMyFitField_SensorMagnetometerX != null) {
      ($.oMyFitField_SensorMagnetometerX as Fit.Field).setData($.oMyData.iSensorMagnetometerX as Object);
    }
    if($.oMyData.iSensorMagnetometerY != null and $.oMyFitField_SensorMagnetometerY != null) {
      ($.oMyFitField_SensorMagnetometerY as Fit.Field).setData($.oMyData.iSensorMagnetometerY as Object);
    }
    if($.oMyData.iSensorMagnetometerZ != null and $.oMyFitField_SensorMagnetometerZ != null) {
      ($.oMyFitField_SensorMagnetometerZ as Fit.Field).setData($.oMyData.iSensorMagnetometerZ as Object);
    }
    if($.oMyData.iSensorHeartrate != null and $.oMyFitField_SensorHeartrate != null) {
      ($.oMyFitField_SensorHeartrate as Fit.Field).setData($.oMyData.iSensorHeartrate as Object);
    }
    if($.oMyData.iSensorCadence != null and $.oMyFitField_SensorCadence != null) {
      ($.oMyFitField_SensorCadence as Fit.Field).setData($.oMyData.iSensorCadence as Object);
    }
    if($.oMyData.iSensorPower != null and $.oMyFitField_SensorPower != null) {
      ($.oMyFitField_SensorPower as Fit.Field).setData($.oMyData.iSensorPower as Object);
    }
    if($.oMyData.fSensorTemperature != null and $.oMyFitField_SensorTemperature != null) {
      ($.oMyFitField_SensorTemperature as Fit.Field).setData($.oMyData.fSensorTemperature as Object);
    }

    // ... activity inputs
    self.saveActivityInfo();

    // UI update
    self.updateUi();
  }

  function onSensorData(_oData as Sensor.SensorData) as Void {
    //Sys.println("DEBUG: MyApp.onSensorData());

    // Save FIT fields

    // ... sensor inputs
    $.oMyData.storeSensorData(_oData);
    if($.oMyData.aiSensorAccelerationX_HD != null and $.oMyFitField_SensorAccelerationX_HD != null) {
      ($.oMyFitField_SensorAccelerationX_HD as Fit.Field).setData(($.oMyData.aiSensorAccelerationX_HD as Array<Number>).slice(0, MyApp.SAMPLERATE_ACCELERATION_HD) as Object);
    }
    if($.oMyData.aiSensorAccelerationY_HD != null and $.oMyFitField_SensorAccelerationY_HD != null) {
      ($.oMyFitField_SensorAccelerationY_HD as Fit.Field).setData(($.oMyData.aiSensorAccelerationY_HD as Array<Number>).slice(0, MyApp.SAMPLERATE_ACCELERATION_HD) as Object);
    }
    if($.oMyData.aiSensorAccelerationZ_HD != null and $.oMyFitField_SensorAccelerationZ_HD != null) {
      ($.oMyFitField_SensorAccelerationZ_HD as Fit.Field).setData(($.oMyData.aiSensorAccelerationZ_HD as Array<Number>).slice(0, MyApp.SAMPLERATE_ACCELERATION_HD) as Object);
    }

    // UI update
    self.updateUi();
  }

  function saveSystemStats() as Void {
    //Sys.println("DEBUG: MyApp.saveSystemStats()");
    $.oMyData.storeSystemStats(Sys.getSystemStats());

    // Save FIT fields
    // ... system inputs
    if($.oMyData.fSystemBattery != null and $.oMyFitField_SystemBattery != null) {
      ($.oMyFitField_SystemBattery as Fit.Field).setData($.oMyData.fSystemBattery as Object);
    }
    if($.oMyData.iSystemMemoryUsed != null and $.oMyFitField_SystemMemoryUsed != null) {
      ($.oMyFitField_SystemMemoryUsed as Fit.Field).setData($.oMyData.iSystemMemoryUsed as Object);
    }
    if($.oMyData.iSystemMemoryFree != null and $.oMyFitField_SystemMemoryFree != null) {
      ($.oMyFitField_SystemMemoryFree as Fit.Field).setData($.oMyData.iSystemMemoryFree as Object);
    }
  }

  function saveActivityInfo() as Void {
    //Sys.println("DEBUG: MyApp.saveActivityInfo());
    var oInfo = Activity.getActivityInfo();
    if(oInfo != null) {
      $.oMyData.storeActivityInfo(oInfo as Activity.Info);
    }

    // Save FIT fields
    // ... activity inputs
    if($.oMyData.dActivityLatitude != null and $.oMyFitField_ActivityLatitude != null) {
      ($.oMyFitField_ActivityLatitude as Fit.Field).setData($.oMyData.dActivityLatitude as Object);
    }
    if($.oMyData.dActivityLongitude != null and $.oMyFitField_ActivityLongitude != null) {
      ($.oMyFitField_ActivityLongitude as Fit.Field).setData($.oMyData.dActivityLongitude as Object);
    }
    if($.oMyData.fActivityAltitude != null and $.oMyFitField_ActivityAltitude != null) {
      ($.oMyFitField_ActivityAltitude as Fit.Field).setData($.oMyData.fActivityAltitude as Object);
    }
    if($.oMyData.fActivitySpeed != null and $.oMyFitField_ActivitySpeed != null) {
      ($.oMyFitField_ActivitySpeed as Fit.Field).setData($.oMyData.fActivitySpeed as Object);
    }
    if($.oMyData.fActivityHeading != null and $.oMyFitField_ActivityHeading != null) {
      ($.oMyFitField_ActivityHeading as Fit.Field).setData($.oMyData.fActivityHeading as Object);
    }
    if($.oMyData.eActivityAccuracy != null and $.oMyFitField_ActivityAccuracy != null) {
      ($.oMyFitField_ActivityAccuracy as Fit.Field).setData($.oMyData.eActivityAccuracy as Object);
    }
    if($.oMyData.fActivityPressureRaw != null and $.oMyFitField_ActivityPressureRaw != null) {
      ($.oMyFitField_ActivityPressureRaw as Fit.Field).setData($.oMyData.fActivityPressureRaw as Object);
    }
    if($.oMyData.fActivityPressureAmbient != null and $.oMyFitField_ActivityPressureAmbient != null) {
      ($.oMyFitField_ActivityPressureAmbient as Fit.Field).setData($.oMyData.fActivityPressureAmbient as Object);
    }
    if($.oMyData.fActivityPressureMean != null and $.oMyFitField_ActivityPressureMean != null) {
      ($.oMyFitField_ActivityPressureMean as Fit.Field).setData($.oMyData.fActivityPressureMean as Object);
    }
    if($.oMyData.iActivityHeartrate != null and $.oMyFitField_ActivityHeartrate != null) {
      ($.oMyFitField_ActivityHeartrate as Fit.Field).setData($.oMyData.iActivityHeartrate as Object);
    }
    if($.oMyData.iActivityCadence != null and $.oMyFitField_ActivityCadence != null) {
      ($.oMyFitField_ActivityCadence as Fit.Field).setData($.oMyData.iActivityCadence as Object);
    }
    if($.oMyData.iActivityPower != null and $.oMyFitField_ActivityPower != null) {
      ($.oMyFitField_ActivityPower as Fit.Field).setData($.oMyData.iActivityPower as Object);
    }
  }

  function onUpdateTimer_init() as Void {
    //Sys.println("DEBUG: MyApp.onUpdateTimer_init()");
    self.onUpdateTimer();
    self.oUpdateTimer = new Timer.Timer();
    self.oUpdateTimer.start(method(:onUpdateTimer), 5000, true);
  }

  function onUpdateTimer() as Void {
    //Sys.println("DEBUG: MyApp.onUpdateTimer()");
    self.updateUi();
  }

  function updateUi() as Void {
    //Sys.println("DEBUG: MyApp.updateUi()");

    // Update UI
    if($.oMyView != null) {
      ($.oMyView as MyView).updateUi();
    }
  }

}
