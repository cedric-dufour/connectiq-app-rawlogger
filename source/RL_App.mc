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

using Toybox.Activity;
using Toybox.ActivityRecording;
using Toybox.Application as App;
using Toybox.FitContributor;
using Toybox.Position;
using Toybox.Sensor;
using Toybox.System as Sys;
using Toybox.Timer;
using Toybox.WatchUi as Ui;

//
// GLOBALS
//

// Application settings
var RL_oSettings = null;

// Application data
var RL_oData = null;

// Activity session (recording)
var RL_oActivitySession = null;
// ... system inputs
var RL_oFitField_SystemBattery = null;
var RL_oFitField_SystemMemoryUsed = null;
var RL_oFitField_SystemMemoryFree = null;
// ... position inputs
var RL_oFitField_PositionLatitude = null;
var RL_oFitField_PositionLongitude = null;
var RL_oFitField_PositionAltitude = null;
var RL_oFitField_PositionSpeed = null;
var RL_oFitField_PositionHeading = null;
var RL_oFitField_PositionAccuracy = null;
// ... sensor inputs
var RL_oFitField_SensorAltitude = null;
var RL_oFitField_SensorSpeed = null;
var RL_oFitField_SensorHeading = null;
var RL_oFitField_SensorPressure = null;
var RL_oFitField_SensorAccelerationX = null;
var RL_oFitField_SensorAccelerationY = null;
var RL_oFitField_SensorAccelerationZ = null;
var RL_oFitField_SensorAccelerationX_HD = null;
var RL_oFitField_SensorAccelerationY_HD = null;
var RL_oFitField_SensorAccelerationZ_HD = null;
var RL_oFitField_SensorMagnetometerX = null;
var RL_oFitField_SensorMagnetometerY = null;
var RL_oFitField_SensorMagnetometerZ = null;
var RL_oFitField_SensorHeartrate = null;
var RL_oFitField_SensorCadence = null;
var RL_oFitField_SensorPower = null;
var RL_oFitField_SensorTemperature = null;
// ... activity inputs
var RL_oFitField_ActivityLatitude = null;
var RL_oFitField_ActivityLongitude = null;
var RL_oFitField_ActivityAltitude = null;
var RL_oFitField_ActivitySpeed = null;
var RL_oFitField_ActivityHeading = null;
var RL_oFitField_ActivityAccuracy = null;
var RL_oFitField_ActivityPressureRaw = null;
var RL_oFitField_ActivityPressureAmbient = null;
var RL_oFitField_ActivityPressureMean = null;
var RL_oFitField_ActivityHeartrate = null;
var RL_oFitField_ActivityCadence = null;
var RL_oFitField_ActivityPower = null;

// Current view
var RL_oCurrentView = null;


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
  private var oUpdateTimer;


  //
  // FUNCTIONS: App.AppBase (override/implement)
  //

  function initialize() {
    AppBase.initialize();

    // Application resources
    $.RL_oSettings = new RL_Settings();
    $.RL_oData = new RL_Data();

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
    Sensor.setEnabledSensors([Sensor.SENSOR_BIKESPEED, Sensor.SENSOR_BIKECADENCE, Sensor.SENSOR_BIKEPOWER, Sensor.SENSOR_HEARTRATE, Sensor.SENSOR_TEMPERATURE]);
    Sensor.enableSensorEvents(method(:onSensorEvent));

    // Start UI update timer (every multiple of 5 seconds, to save energy)
    // NOTE: in normal circumstances, UI update will be triggered by position events (every ~1 second)
    self.oUpdateTimer = new Timer.Timer();
    var iUpdateTimerDelay = (60-Sys.getClockTime().sec)%5;
    if(iUpdateTimerDelay > 0) {
      self.oUpdateTimer.start(method(:onUpdateTimer_init), 1000*iUpdateTimerDelay, false);
    }
    else {
      self.oUpdateTimer.start(method(:onUpdateTimer), 5000, true);
    }
  }

  function onStop(state) {
    //Sys.println("DEBUG: RL_App.onStop()");

    // Stop timers
    // ... UI update
    if(self.oUpdateTimer != null) {
      self.oUpdateTimer.stop();
      self.oUpdateTimer = null;
    }

    // Disable sensor events
    Sensor.enableSensorEvents(null);

    // Disable position events
    Position.enableLocationEvents(Position.LOCATION_DISABLE, null);
  }

  function getInitialView() {
    //Sys.println("DEBUG: RL_App.getInitialView()");

    return [new RL_View(), new RL_ViewDelegate()];
  }

  function onSettingsChanged() {
    //Sys.println("DEBUG: RL_App.onSettingsChanged()");
    $.RL_oSettings.load();
    self.updateUi();
  }


  //
  // FUNCTIONS: self
  //

  function initActivity() {
    if($.RL_oActivitySession == null) {
      $.RL_oActivitySession = ActivityRecording.createSession({ :name => "RawLogger", :sport => ActivityRecording.SPORT_GENERIC, :subSport => ActivityRecording.SUB_SPORT_GENERIC });
      var iFitFields = 16;  // ... it would seem ConnectIQ allows only 16 contributed FIT fields (undocumented)
      var iFitBytes = 256;  // ... FIT message can be no longer than 256 bytes
      var bHighDefListener_Acceleration = false;

      // ... system inputs
      if($.RL_oSettings.bSystemBattery and iFitFields >= 1 and iFitBytes >= 4) {
        $.RL_oFitField_SystemBattery = $.RL_oActivitySession.createField("SystemBattery", RL_App.FITFIELD_SYSTEMBATTERY, FitContributor.DATA_TYPE_FLOAT, { :mesgType => FitContributor.MESG_TYPE_RECORD, :units => Ui.loadResource(Rez.Strings.unitSystemBattery) });
        iFitFields -= 1;
        iFitBytes -= 4;
      }
      if($.RL_oSettings.bSystemMemory and iFitFields >= 2 and iFitBytes >= 8) {
        $.RL_oFitField_SystemMemoryUsed = $.RL_oActivitySession.createField("SystemMemoryUsed", RL_App.FITFIELD_SYSTEMMEMORYUSED, FitContributor.DATA_TYPE_UINT32, { :mesgType => FitContributor.MESG_TYPE_RECORD, :units => Ui.loadResource(Rez.Strings.unitSystemMemory) });
        $.RL_oFitField_SystemMemoryFree = $.RL_oActivitySession.createField("SystemMemoryFree", RL_App.FITFIELD_SYSTEMMEMORYFREE, FitContributor.DATA_TYPE_UINT32, { :mesgType => FitContributor.MESG_TYPE_RECORD, :units => Ui.loadResource(Rez.Strings.unitSystemMemory) });
        iFitFields -= 2;
        iFitBytes -= 8;
      }

      // ... position inputs
      if($.RL_oSettings.bPositionLocation and iFitFields >= 2 and iFitBytes >= 8) {
        $.RL_oFitField_PositionLatitude = $.RL_oActivitySession.createField("PositionLatitude", RL_App.FITFIELD_POSITIONLATITUDE, FitContributor.DATA_TYPE_FLOAT, { :mesgType => FitContributor.MESG_TYPE_RECORD, :units => Ui.loadResource(Rez.Strings.unitPositionLocation) });
        $.RL_oFitField_PositionLongitude = $.RL_oActivitySession.createField("PositionLongitude", RL_App.FITFIELD_POSITIONLONGITUDE, FitContributor.DATA_TYPE_FLOAT, { :mesgType => FitContributor.MESG_TYPE_RECORD, :units => Ui.loadResource(Rez.Strings.unitPositionLocation) });
        iFitFields -= 2;
        iFitBytes -= 8;
      }
      if($.RL_oSettings.bPositionAltitude and iFitFields >= 1 and iFitBytes >= 4) {
        $.RL_oFitField_PositionAltitude = $.RL_oActivitySession.createField("PositionAltitude", RL_App.FITFIELD_POSITIONALTITUDE, FitContributor.DATA_TYPE_FLOAT, { :mesgType => FitContributor.MESG_TYPE_RECORD, :units => Ui.loadResource(Rez.Strings.unitPositionAltitude) });
        iFitFields -= 1;
        iFitBytes -= 4;
      }
      if($.RL_oSettings.bPositionSpeed and iFitFields >= 1 and iFitBytes >= 4) {
        $.RL_oFitField_PositionSpeed = $.RL_oActivitySession.createField("PositionSpeed", RL_App.FITFIELD_POSITIONSPEED, FitContributor.DATA_TYPE_FLOAT, { :mesgType => FitContributor.MESG_TYPE_RECORD, :units => Ui.loadResource(Rez.Strings.unitPositionSpeed) });
        iFitFields -= 1;
        iFitBytes -= 4;
      }
      if($.RL_oSettings.bPositionHeading and iFitFields >= 1 and iFitBytes >= 4) {
        $.RL_oFitField_PositionHeading = $.RL_oActivitySession.createField("PositionHeading", RL_App.FITFIELD_POSITIONHEADING, FitContributor.DATA_TYPE_FLOAT, { :mesgType => FitContributor.MESG_TYPE_RECORD, :units => Ui.loadResource(Rez.Strings.unitPositionHeading) });
        iFitFields -= 1;
        iFitBytes -= 4;
      }
      if($.RL_oSettings.bPositionAccuracy and iFitFields >= 1 and iFitBytes >= 1) {
        $.RL_oFitField_PositionAccuracy = $.RL_oActivitySession.createField("PositionAccuracy", RL_App.FITFIELD_POSITIONACCURACY, FitContributor.DATA_TYPE_UINT8, { :mesgType => FitContributor.MESG_TYPE_RECORD, :units => Ui.loadResource(Rez.Strings.unitPositionAccuracy) });
        iFitFields -= 1;
        iFitBytes -= 1;
      }

      // ... sensor inputs
      if($.RL_oSettings.bSensorAltitude and iFitFields >= 1 and iFitBytes >= 4) {
        $.RL_oFitField_SensorAltitude = $.RL_oActivitySession.createField("SensorAltitude", RL_App.FITFIELD_SENSORALTITUDE, FitContributor.DATA_TYPE_FLOAT, { :mesgType => FitContributor.MESG_TYPE_RECORD, :units => Ui.loadResource(Rez.Strings.unitSensorAltitude) });
        iFitFields -= 1;
        iFitBytes -= 4;
      }
      if($.RL_oSettings.bSensorSpeed and iFitFields >= 1 and iFitBytes >= 4) {
        $.RL_oFitField_SensorSpeed = $.RL_oActivitySession.createField("SensorSpeed", RL_App.FITFIELD_SENSORSPEED, FitContributor.DATA_TYPE_FLOAT, { :mesgType => FitContributor.MESG_TYPE_RECORD, :units => Ui.loadResource(Rez.Strings.unitSensorSpeed) });
        iFitFields -= 1;
        iFitBytes -= 4;
      }
      if($.RL_oSettings.bSensorHeading and iFitFields >= 1 and iFitBytes >= 4) {
        $.RL_oFitField_SensorHeading = $.RL_oActivitySession.createField("SensorHeading", RL_App.FITFIELD_SENSORHEADING, FitContributor.DATA_TYPE_FLOAT, { :mesgType => FitContributor.MESG_TYPE_RECORD, :units => Ui.loadResource(Rez.Strings.unitSensorHeading) });
        iFitFields -= 1;
        iFitBytes -= 4;
      }
      if($.RL_oSettings.bSensorPressure and iFitFields >= 1 and iFitBytes >= 4) {
        $.RL_oFitField_SensorPressure = $.RL_oActivitySession.createField("SensorPressure", RL_App.FITFIELD_SENSORPRESSURE, FitContributor.DATA_TYPE_FLOAT, { :mesgType => FitContributor.MESG_TYPE_RECORD, :units => Ui.loadResource(Rez.Strings.unitSensorPressure) });
        iFitFields -= 1;
        iFitBytes -= 4;
      }
      if($.RL_oSettings.bSensorAcceleration and iFitFields >= 3 and iFitBytes >= 6) {
        $.RL_oFitField_SensorAccelerationX = $.RL_oActivitySession.createField("SensorAccelerationX", RL_App.FITFIELD_SENSORACCELERATIONX, FitContributor.DATA_TYPE_SINT16, { :mesgType => FitContributor.MESG_TYPE_RECORD, :units => Ui.loadResource(Rez.Strings.unitSensorAcceleration) });
        $.RL_oFitField_SensorAccelerationY = $.RL_oActivitySession.createField("SensorAccelerationY", RL_App.FITFIELD_SENSORACCELERATIONY, FitContributor.DATA_TYPE_SINT16, { :mesgType => FitContributor.MESG_TYPE_RECORD, :units => Ui.loadResource(Rez.Strings.unitSensorAcceleration) });
        $.RL_oFitField_SensorAccelerationZ = $.RL_oActivitySession.createField("SensorAccelerationZ", RL_App.FITFIELD_SENSORACCELERATIONZ, FitContributor.DATA_TYPE_SINT16, { :mesgType => FitContributor.MESG_TYPE_RECORD, :units => Ui.loadResource(Rez.Strings.unitSensorAcceleration) });
        iFitFields -= 3;
        iFitBytes -= 6;
      }
      if($.RL_oSettings.bSensorAcceleration_HD and iFitFields >= 3 and iFitBytes >= 6*RL_App.SAMPLERATE_ACCELERATION_HD) {
        $.RL_oFitField_SensorAccelerationX_HD = $.RL_oActivitySession.createField("SensorAccelerationX_HD", RL_App.FITFIELD_SENSORACCELERATIONX_HD, FitContributor.DATA_TYPE_SINT16, { :count => RL_App.SAMPLERATE_ACCELERATION_HD, :mesgType => FitContributor.MESG_TYPE_RECORD, :units => Ui.loadResource(Rez.Strings.unitSensorAcceleration) });
        $.RL_oFitField_SensorAccelerationY_HD = $.RL_oActivitySession.createField("SensorAccelerationY_HD", RL_App.FITFIELD_SENSORACCELERATIONY_HD, FitContributor.DATA_TYPE_SINT16, { :count => RL_App.SAMPLERATE_ACCELERATION_HD, :mesgType => FitContributor.MESG_TYPE_RECORD, :units => Ui.loadResource(Rez.Strings.unitSensorAcceleration) });
        $.RL_oFitField_SensorAccelerationZ_HD = $.RL_oActivitySession.createField("SensorAccelerationZ_HD", RL_App.FITFIELD_SENSORACCELERATIONZ_HD, FitContributor.DATA_TYPE_SINT16, { :count => RL_App.SAMPLERATE_ACCELERATION_HD, :mesgType => FitContributor.MESG_TYPE_RECORD, :units => Ui.loadResource(Rez.Strings.unitSensorAcceleration) });
        iFitFields -= 3;
        iFitBytes -= 6*RL_App.SAMPLERATE_ACCELERATION_HD;
        bHighDefListener_Acceleration = true;
      }
      if($.RL_oSettings.bSensorMagnetometer and iFitFields >= 3 and iFitBytes >= 6) {
        $.RL_oFitField_SensorMagnetometerX = $.RL_oActivitySession.createField("SensorMagnetometerX", RL_App.FITFIELD_SENSORMAGNETOMETERX, FitContributor.DATA_TYPE_SINT16, { :mesgType => FitContributor.MESG_TYPE_RECORD, :units => Ui.loadResource(Rez.Strings.unitSensorMagnetometer) });
        $.RL_oFitField_SensorMagnetometerY = $.RL_oActivitySession.createField("SensorMagnetometerY", RL_App.FITFIELD_SENSORMAGNETOMETERY, FitContributor.DATA_TYPE_SINT16, { :mesgType => FitContributor.MESG_TYPE_RECORD, :units => Ui.loadResource(Rez.Strings.unitSensorMagnetometer) });
        $.RL_oFitField_SensorMagnetometerZ = $.RL_oActivitySession.createField("SensorMagnetometerZ", RL_App.FITFIELD_SENSORMAGNETOMETERZ, FitContributor.DATA_TYPE_SINT16, { :mesgType => FitContributor.MESG_TYPE_RECORD, :units => Ui.loadResource(Rez.Strings.unitSensorMagnetometer) });
        iFitFields -= 3;
        iFitBytes -= 6;
      }
      if($.RL_oSettings.bSensorHeartrate and iFitFields >= 1 and iFitBytes >= 2) {
        $.RL_oFitField_SensorHeartrate = $.RL_oActivitySession.createField("SensorHeartrate", RL_App.FITFIELD_SENSORHEARTRATE, FitContributor.DATA_TYPE_UINT16, { :mesgType => FitContributor.MESG_TYPE_RECORD, :units => Ui.loadResource(Rez.Strings.unitSensorHeartrate) });
        iFitFields -= 1;
        iFitBytes -= 2;
      }
      if($.RL_oSettings.bSensorCadence and iFitFields >= 1 and iFitBytes >= 2) {
        $.RL_oFitField_SensorCadence = $.RL_oActivitySession.createField("SensorCadence", RL_App.FITFIELD_SENSORCADENCE, FitContributor.DATA_TYPE_UINT16, { :mesgType => FitContributor.MESG_TYPE_RECORD, :units => Ui.loadResource(Rez.Strings.unitSensorCadence) });
        iFitFields -= 1;
        iFitBytes -= 2;
      }
      if($.RL_oSettings.bSensorPower and iFitFields >= 1 and iFitBytes >= 2) {
        $.RL_oFitField_SensorPower = $.RL_oActivitySession.createField("SensorPower", RL_App.FITFIELD_SENSORPOWER, FitContributor.DATA_TYPE_UINT16, { :mesgType => FitContributor.MESG_TYPE_RECORD, :units => Ui.loadResource(Rez.Strings.unitSensorPower) });
        iFitFields -= 1;
        iFitBytes -= 2;
      }
      if($.RL_oSettings.bSensorTemperature and iFitFields >= 1 and iFitBytes >= 4) {
        $.RL_oFitField_SensorTemperature = $.RL_oActivitySession.createField("SensorTemperature", RL_App.FITFIELD_SENSORTEMPERATURE, FitContributor.DATA_TYPE_FLOAT, { :mesgType => FitContributor.MESG_TYPE_RECORD, :units => Ui.loadResource(Rez.Strings.unitSensorTemperature) });
        iFitFields -= 1;
        iFitBytes -= 4;
      }

      // ... activity inputs
      if($.RL_oSettings.bActivityLocation and iFitFields >= 2 and iFitBytes >= 8) {
        $.RL_oFitField_ActivityLatitude = $.RL_oActivitySession.createField("ActivityLatitude", RL_App.FITFIELD_ACTIVITYLATITUDE, FitContributor.DATA_TYPE_FLOAT, { :mesgType => FitContributor.MESG_TYPE_RECORD, :units => Ui.loadResource(Rez.Strings.unitActivityLocation) });
        $.RL_oFitField_ActivityLongitude = $.RL_oActivitySession.createField("ActivityLongitude", RL_App.FITFIELD_ACTIVITYLONGITUDE, FitContributor.DATA_TYPE_FLOAT, { :mesgType => FitContributor.MESG_TYPE_RECORD, :units => Ui.loadResource(Rez.Strings.unitActivityLocation) });
        iFitFields -= 2;
        iFitBytes -= 8;
      }
      if($.RL_oSettings.bActivityAltitude and iFitFields >= 1 and iFitBytes >= 4) {
        $.RL_oFitField_ActivityAltitude = $.RL_oActivitySession.createField("ActivityAltitude", RL_App.FITFIELD_ACTIVITYALTITUDE, FitContributor.DATA_TYPE_FLOAT, { :mesgType => FitContributor.MESG_TYPE_RECORD, :units => Ui.loadResource(Rez.Strings.unitActivityAltitude) });
        iFitFields -= 1;
        iFitBytes -= 4;
      }
      if($.RL_oSettings.bActivitySpeed and iFitFields >= 1 and iFitBytes >= 4) {
        $.RL_oFitField_ActivitySpeed = $.RL_oActivitySession.createField("ActivitySpeed", RL_App.FITFIELD_ACTIVITYSPEED, FitContributor.DATA_TYPE_FLOAT, { :mesgType => FitContributor.MESG_TYPE_RECORD, :units => Ui.loadResource(Rez.Strings.unitActivitySpeed) });
        iFitFields -= 1;
        iFitBytes -= 4;
      }
      if($.RL_oSettings.bActivityHeading and iFitFields >= 1 and iFitBytes >= 4) {
        $.RL_oFitField_ActivityHeading = $.RL_oActivitySession.createField("ActivityHeading", RL_App.FITFIELD_ACTIVITYHEADING, FitContributor.DATA_TYPE_FLOAT, { :mesgType => FitContributor.MESG_TYPE_RECORD, :units => Ui.loadResource(Rez.Strings.unitActivityHeading) });
        iFitFields -= 1;
        iFitBytes -= 4;
      }
      if($.RL_oSettings.bActivityAccuracy and iFitFields >= 1 and iFitBytes >= 2) {
        $.RL_oFitField_ActivityAccuracy = $.RL_oActivitySession.createField("ActivityAccuracy", RL_App.FITFIELD_ACTIVITYACCURACY, FitContributor.DATA_TYPE_UINT16, { :mesgType => FitContributor.MESG_TYPE_RECORD, :units => Ui.loadResource(Rez.Strings.unitActivityAccuracy) });
        iFitFields -= 1;
        iFitBytes -= 2;
      }
      if($.RL_oSettings.bActivityPressure and iFitFields >= 3 and iFitBytes >= 12) {
        $.RL_oFitField_ActivityPressureRaw = $.RL_oActivitySession.createField("ActivityPressureRaw", RL_App.FITFIELD_ACTIVITYPRESSURERAW, FitContributor.DATA_TYPE_FLOAT, { :mesgType => FitContributor.MESG_TYPE_RECORD, :units => Ui.loadResource(Rez.Strings.unitActivityPressure) });
        $.RL_oFitField_ActivityPressureAmbient = $.RL_oActivitySession.createField("ActivityPressureAmbient", RL_App.FITFIELD_ACTIVITYPRESSUREAMBIENT, FitContributor.DATA_TYPE_FLOAT, { :mesgType => FitContributor.MESG_TYPE_RECORD, :units => Ui.loadResource(Rez.Strings.unitActivityPressure) });
        $.RL_oFitField_ActivityPressureMean = $.RL_oActivitySession.createField("ActivityPressureMean", RL_App.FITFIELD_ACTIVITYPRESSUREMEAN, FitContributor.DATA_TYPE_FLOAT, { :mesgType => FitContributor.MESG_TYPE_RECORD, :units => Ui.loadResource(Rez.Strings.unitActivityPressure) });
        iFitFields -= 3;
        iFitBytes -= 12;
      }
      if($.RL_oSettings.bActivityHeartrate and iFitFields >= 1 and iFitBytes >= 2) {
        $.RL_oFitField_ActivityHeartrate = $.RL_oActivitySession.createField("ActivityHeartrate", RL_App.FITFIELD_ACTIVITYHEARTRATE, FitContributor.DATA_TYPE_UINT16, { :mesgType => FitContributor.MESG_TYPE_RECORD, :units => Ui.loadResource(Rez.Strings.unitActivityHeartrate) });
        iFitFields -= 1;
        iFitBytes -= 2;
      }
      if($.RL_oSettings.bActivityCadence and iFitFields >= 1 and iFitBytes >= 2) {
        $.RL_oFitField_ActivityCadence = $.RL_oActivitySession.createField("ActivityCadence", RL_App.FITFIELD_ACTIVITYCADENCE, FitContributor.DATA_TYPE_UINT16, { :mesgType => FitContributor.MESG_TYPE_RECORD, :units => Ui.loadResource(Rez.Strings.unitActivityCadence) });
        iFitFields -= 1;
        iFitBytes -= 2;
      }
      if($.RL_oSettings.bActivityPower and iFitFields >= 1 and iFitBytes >= 1) {
        $.RL_oFitField_ActivityPower = $.RL_oActivitySession.createField("ActivityPower", RL_App.FITFIELD_ACTIVITYPOWER, FitContributor.DATA_TYPE_UINT8, { :mesgType => FitContributor.MESG_TYPE_RECORD, :units => Ui.loadResource(Rez.Strings.unitActivityPower) });
        iFitFields -= 1;
        iFitBytes -= 1;
      }

      // ... high-definition data listener
      if(bHighDefListener_Acceleration) {
        Sensor.registerSensorDataListener(method(:onSensorData), { :period => 1, :accelerometer =>  { :enabled => true, :sampleRate => RL_App.SAMPLERATE_ACCELERATION_HD } });
      }
    }
  }

  function resetActivity() {
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

  function onLocationEvent(_oInfo) {
    //Sys.println("DEBUG: RL_App.onLocationEvent()");

    // Save FIT fields

    // ... system inputs
    self.saveSystemStats();

    // ... position inputs
    $.RL_oData.storePositionInfo(_oInfo);
    if($.RL_oData.fPositionLatitude != null and $.RL_oFitField_PositionLatitude != null) {
      $.RL_oFitField_PositionLatitude.setData($.RL_oData.fPositionLatitude);
    }
    if($.RL_oData.fPositionLongitude != null and $.RL_oFitField_PositionLongitude != null) {
      $.RL_oFitField_PositionLongitude.setData($.RL_oData.fPositionLongitude);
    }
    if($.RL_oData.fPositionAltitude != null and $.RL_oFitField_PositionAltitude != null) {
      $.RL_oFitField_PositionAltitude.setData($.RL_oData.fPositionAltitude);
    }
    if($.RL_oData.fPositionSpeed != null and $.RL_oFitField_PositionSpeed != null) {
      $.RL_oFitField_PositionSpeed.setData($.RL_oData.fPositionSpeed);
    }
    if($.RL_oData.fPositionHeading != null and $.RL_oFitField_PositionHeading != null) {
      $.RL_oFitField_PositionHeading.setData($.RL_oData.fPositionHeading);
    }
    if($.RL_oData.iPositionAccuracy != null and $.RL_oFitField_PositionAccuracy != null) {
      $.RL_oFitField_PositionAccuracy.setData($.RL_oData.iPositionAccuracy);
    }

    // ... activity inputs
    self.saveActivityInfo();

    // UI update
    self.updateUi();
  }

  function onSensorEvent(_oInfo) {
    //Sys.println("DEBUG: RL_App.onSensorEvent());

    // Save FIT fields

    // ... system inputs
    self.saveSystemStats();

    // ... sensor inputs
    $.RL_oData.storeSensorInfo(_oInfo);
    if($.RL_oData.fSensorAltitude != null and $.RL_oFitField_SensorAltitude != null) {
      $.RL_oFitField_SensorAltitude.setData($.RL_oData.fSensorAltitude);
    }
    if($.RL_oData.fSensorSpeed != null and $.RL_oFitField_SensorSpeed != null) {
      $.RL_oFitField_SensorSpeed.setData($.RL_oData.fSensorSpeed);
    }
    if($.RL_oData.fSensorHeading != null and $.RL_oFitField_SensorHeading != null) {
      $.RL_oFitField_SensorHeading.setData($.RL_oData.fSensorHeading);
    }
    if($.RL_oData.fSensorPressure != null and $.RL_oFitField_SensorPressure != null) {
      $.RL_oFitField_SensorPressure.setData($.RL_oData.fSensorPressure);
    }
    if($.RL_oData.iSensorAccelerationX != null and $.RL_oFitField_SensorAccelerationX != null) {
      $.RL_oFitField_SensorAccelerationX.setData($.RL_oData.iSensorAccelerationX);
    }
    if($.RL_oData.iSensorAccelerationY != null and $.RL_oFitField_SensorAccelerationY != null) {
      $.RL_oFitField_SensorAccelerationY.setData($.RL_oData.iSensorAccelerationY);
    }
    if($.RL_oData.iSensorAccelerationZ != null and $.RL_oFitField_SensorAccelerationZ != null) {
      $.RL_oFitField_SensorAccelerationZ.setData($.RL_oData.iSensorAccelerationZ);
    }
    if($.RL_oData.iSensorMagnetometerX != null and $.RL_oFitField_SensorMagnetometerX != null) {
      $.RL_oFitField_SensorMagnetometerX.setData($.RL_oData.iSensorMagnetometerX);
    }
    if($.RL_oData.iSensorMagnetometerY != null and $.RL_oFitField_SensorMagnetometerY != null) {
      $.RL_oFitField_SensorMagnetometerY.setData($.RL_oData.iSensorMagnetometerY);
    }
    if($.RL_oData.iSensorMagnetometerZ != null and $.RL_oFitField_SensorMagnetometerZ != null) {
      $.RL_oFitField_SensorMagnetometerZ.setData($.RL_oData.iSensorMagnetometerZ);
    }
    if($.RL_oData.iSensorHeartrate != null and $.RL_oFitField_SensorHeartrate != null) {
      $.RL_oFitField_SensorHeartrate.setData($.RL_oData.iSensorHeartrate);
    }
    if($.RL_oData.iSensorCadence != null and $.RL_oFitField_SensorCadence != null) {
      $.RL_oFitField_SensorCadence.setData($.RL_oData.iSensorCadence);
    }
    if($.RL_oData.iSensorPower != null and $.RL_oFitField_SensorPower != null) {
      $.RL_oFitField_SensorPower.setData($.RL_oData.iSensorPower);
    }
    if($.RL_oData.fSensorTemperature != null and $.RL_oFitField_SensorTemperature != null) {
      $.RL_oFitField_SensorTemperature.setData($.RL_oData.fSensorTemperature);
    }

    // ... activity inputs
    self.saveActivityInfo();

    // UI update
    self.updateUi();
  }

  function onSensorData(_oData) {
    //Sys.println("DEBUG: RL_App.onSensorData());

    // Save FIT fields

    // ... sensor inputs
    $.RL_oData.storeSensorData(_oData);
    if($.RL_oData.aiSensorAccelerationX_HD != null and $.RL_oFitField_SensorAccelerationX_HD != null) {
      $.RL_oFitField_SensorAccelerationX_HD.setData($.RL_oData.aiSensorAccelerationX_HD.slice(0, RL_App.SAMPLERATE_ACCELERATION_HD));
    }
    if($.RL_oData.aiSensorAccelerationY_HD != null and $.RL_oFitField_SensorAccelerationY_HD != null) {
      $.RL_oFitField_SensorAccelerationY_HD.setData($.RL_oData.aiSensorAccelerationY_HD.slice(0, RL_App.SAMPLERATE_ACCELERATION_HD));
    }
    if($.RL_oData.aiSensorAccelerationZ_HD != null and $.RL_oFitField_SensorAccelerationZ_HD != null) {
      $.RL_oFitField_SensorAccelerationZ_HD.setData($.RL_oData.aiSensorAccelerationZ_HD.slice(0, RL_App.SAMPLERATE_ACCELERATION_HD));
    }

    // UI update
    self.updateUi();
  }

  function saveSystemStats() {
    //Sys.println("DEBUG: RL_App.saveSystemStats()");
    $.RL_oData.storeSystemStats(Sys.getSystemStats());

    // Save FIT fields
    // ... system inputs
    if($.RL_oData.fSystemBattery != null and $.RL_oFitField_SystemBattery != null) {
      $.RL_oFitField_SystemBattery.setData($.RL_oData.fSystemBattery);
    }
    if($.RL_oData.iSystemMemoryUsed != null and $.RL_oFitField_SystemMemoryUsed != null) {
      $.RL_oFitField_SystemMemoryUsed.setData($.RL_oData.iSystemMemoryUsed);
    }
    if($.RL_oData.iSystemMemoryFree != null and $.RL_oFitField_SystemMemoryFree != null) {
      $.RL_oFitField_SystemMemoryFree.setData($.RL_oData.iSystemMemoryFree);
    }
  }

  function saveActivityInfo() {
    //Sys.println("DEBUG: RL_App.saveActivityInfo());
    $.RL_oData.storeActivityInfo(Activity.getActivityInfo());

    // Save FIT fields
    // ... activity inputs
    if($.RL_oData.fActivityLatitude != null and $.RL_oFitField_ActivityLatitude != null) {
      $.RL_oFitField_ActivityLatitude.setData($.RL_oData.fActivityLatitude);
    }
    if($.RL_oData.fActivityLongitude != null and $.RL_oFitField_ActivityLongitude != null) {
      $.RL_oFitField_ActivityLongitude.setData($.RL_oData.fActivityLongitude);
    }
    if($.RL_oData.fActivityAltitude != null and $.RL_oFitField_ActivityAltitude != null) {
      $.RL_oFitField_ActivityAltitude.setData($.RL_oData.fActivityAltitude);
    }
    if($.RL_oData.fActivitySpeed != null and $.RL_oFitField_ActivitySpeed != null) {
      $.RL_oFitField_ActivitySpeed.setData($.RL_oData.fActivitySpeed);
    }
    if($.RL_oData.fActivityHeading != null and $.RL_oFitField_ActivityHeading != null) {
      $.RL_oFitField_ActivityHeading.setData($.RL_oData.fActivityHeading);
    }
    if($.RL_oData.iActivityAccuracy != null and $.RL_oFitField_ActivityAccuracy != null) {
      $.RL_oFitField_ActivityAccuracy.setData($.RL_oData.iActivityAccuracy);
    }
    if($.RL_oData.fActivityPressureRaw != null and $.RL_oFitField_ActivityPressureRaw != null) {
      $.RL_oFitField_ActivityPressureRaw.setData($.RL_oData.fActivityPressureRaw);
    }
    if($.RL_oData.fActivityPressureAmbient != null and $.RL_oFitField_ActivityPressureAmbient != null) {
      $.RL_oFitField_ActivityPressureAmbient.setData($.RL_oData.fActivityPressureAmbient);
    }
    if($.RL_oData.fActivityPressureMean != null and $.RL_oFitField_ActivityPressureMean != null) {
      $.RL_oFitField_ActivityPressureMean.setData($.RL_oData.fActivityPressureMean);
    }
    if($.RL_oData.iActivityHeartrate != null and $.RL_oFitField_ActivityHeartrate != null) {
      $.RL_oFitField_ActivityHeartrate.setData($.RL_oData.iActivityHeartrate);
    }
    if($.RL_oData.iActivityCadence != null and $.RL_oFitField_ActivityCadence != null) {
      $.RL_oFitField_ActivityCadence.setData($.RL_oData.iActivityCadence);
    }
    if($.RL_oData.iActivityPower != null and $.RL_oFitField_ActivityPower != null) {
      $.RL_oFitField_ActivityPower.setData($.RL_oData.iActivityPower);
    }
  }

  function onUpdateTimer_init() {
    //Sys.println("DEBUG: RL_App.onUpdateTimer_init()");
    self.onUpdateTimer();
    self.oUpdateTimer = new Timer.Timer();
    self.oUpdateTimer.start(method(:onUpdateTimer), 5000, true);
  }

  function onUpdateTimer() {
    //Sys.println("DEBUG: RL_App.onUpdateTimer()");
    self.updateUi();
  }

  function updateUi() {
    //Sys.println("DEBUG: RL_App.updateUi()");

    // Update UI
    if($.RL_oCurrentView != null) {
      $.RL_oCurrentView.updateUi();
    }
  }

}
