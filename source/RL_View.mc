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

using Toybox.Application as App;
using Toybox.Attention;
using Toybox.Graphics as Gfx;
using Toybox.System as Sys;
using Toybox.Time;
using Toybox.Time.Gregorian;
using Toybox.WatchUi as Ui;

//
// GLOBALS
//

// Current view index and label
var RL_iViewIndex = 0;
var RL_sViewLabel1 = null;
var RL_sViewLabel2 = null;


//
// CLASS
//

class RL_View extends Ui.View {

  //
  // CONSTANTS
  //

  private const NOVALUE_BLANK = "";
  private const NOVALUE_LEN3 = "---";


  //
  // VARIABLES
  //

  // Display mode (internal)
  private var bShow;

  // Screen center coordinates
  private var iWidthX;
  private var iHeightY;
  private var iCenterX;
  private var iCenterY;
  private var iStatusY;
  private var iLabel1Y;
  private var iLabel2Y;
  private var iValue1Y;
  private var iValue2Y;
  private var iValue3Y;


  //
  // FUNCTIONS: Ui.View (override/implement)
  //

  function initialize() {
    View.initialize();

    // Display mode
    // ... internal
    self.bShow = false;
  }

  function onLayout(_oDC) {
    //Sys.println("DEBUG: RL_View.onLayout()");

    // Screen center coordinates
    self.iWidthX = _oDC.getWidth();
    self.iHeightY = _oDC.getHeight();
    self.iCenterX = (self.iWidthX/2).toNumber();
    self.iCenterY = (self.iHeightY/2).toNumber();
    self.iStatusY = (self.iHeightY/8).toNumber();
    self.iLabel1Y = (self.iHeightY/4+self.iHeightY/8).toNumber();
    self.iLabel2Y = (self.iHeightY/4+self.iHeightY/8*2).toNumber();
    self.iValue1Y = (self.iHeightY/4+self.iHeightY/8*3).toNumber();
    self.iValue2Y = (self.iHeightY/4+self.iHeightY/8*4).toNumber();
    self.iValue3Y = (self.iHeightY/4+self.iHeightY/8*5).toNumber();
      
    // Done
    return true;
  }

  function onShow() {
    //Sys.println("DEBUG: RL_View.onShow()");
    self.bShow = true;
    $.RL_oCurrentView = self;
    return true;
  }

  function onUpdate(_oDC) {
    //Sys.println("DEBUG: RL_View.onUpdate()");
    self.drawValues(_oDC);
    return true;
  }

  function onHide() {
    //Sys.println("DEBUG: RL_View.onHide()");
    $.RL_oCurrentView = null;
    self.bShow = false;
  }


  //
  // FUNCTIONS: self
  //

  function updateUi() {
    //Sys.println("DEBUG: RL_View.updateUi()");

    // Request UI update
    if(self.bShow) {
      Ui.requestUpdate();
    }
  }

  function drawValues(_oDC) {
    //Sys.println("DEBUG: RL_View.drawValues()");
    _oDC.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_BLACK);
    _oDC.clear();
    var sValue;

    if($.RL_oActivitySession != null) {  // ... activity status
      _oDC.setColor(Gfx.COLOR_RED, Gfx.COLOR_TRANSPARENT);
      _oDC.drawText(self.iCenterX, self.iStatusY, Gfx.FONT_SMALL, "REC", Gfx.TEXT_JUSTIFY_CENTER|Gfx.TEXT_JUSTIFY_VCENTER);
    }

    if($.RL_iViewIndex == 0) {  // ... time
      // ... label
      _oDC.setColor(Gfx.COLOR_BLUE, Gfx.COLOR_TRANSPARENT);
      if($.RL_sViewLabel2 == null) {
        $.RL_sViewLabel2 = Lang.format("$1$ ($2$)", [Ui.loadResource(Rez.Strings.labelTime), Ui.loadResource(Rez.Strings.unitTime)]);
      }
      _oDC.drawText(self.iCenterX, self.iLabel1Y, Gfx.FONT_SMALL, self.NOVALUE_BLANK, Gfx.TEXT_JUSTIFY_CENTER|Gfx.TEXT_JUSTIFY_VCENTER);
      _oDC.drawText(self.iCenterX, self.iLabel2Y, Gfx.FONT_SMALL, $.RL_sViewLabel2, Gfx.TEXT_JUSTIFY_CENTER|Gfx.TEXT_JUSTIFY_VCENTER);
      // ... value(s)
      _oDC.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);
      var oTimeInfo = Gregorian.info(Time.now(), Time.FORMAT_SHORT);
      sValue = Lang.format("$1$:$2$", [oTimeInfo.hour.format("%02d"), oTimeInfo.min.format("%02d")]);
      _oDC.drawText(self.iCenterX, self.iValue1Y, Gfx.FONT_SMALL, sValue, Gfx.TEXT_JUSTIFY_CENTER|Gfx.TEXT_JUSTIFY_VCENTER);
    }

    else if($.RL_iViewIndex == 1) {  // ... position: location
      // ... label
      _oDC.setColor(Gfx.COLOR_BLUE, Gfx.COLOR_TRANSPARENT);
      if($.RL_sViewLabel1 == null) {
        $.RL_sViewLabel1 = Ui.loadResource(Rez.Strings.labelPosition);
      }
      if($.RL_sViewLabel2 == null) {
        $.RL_sViewLabel2 = Lang.format("$1$ ($2$)", [Ui.loadResource(Rez.Strings.labelLocation), Ui.loadResource(Rez.Strings.unitPositionLocation)]);
      }
      _oDC.drawText(self.iCenterX, self.iLabel1Y, Gfx.FONT_SMALL, $.RL_sViewLabel1, Gfx.TEXT_JUSTIFY_CENTER|Gfx.TEXT_JUSTIFY_VCENTER);
      _oDC.drawText(self.iCenterX, self.iLabel2Y, Gfx.FONT_SMALL, $.RL_sViewLabel2, Gfx.TEXT_JUSTIFY_CENTER|Gfx.TEXT_JUSTIFY_VCENTER);
      // ... value(s)
      _oDC.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);
      sValue = $.RL_oData.fPositionLatitude != null ? $.RL_oData.fPositionLatitude.format("%.06f") : self.NOVALUE_LEN3;
      _oDC.drawText(self.iCenterX, self.iValue1Y, Gfx.FONT_SMALL, sValue, Gfx.TEXT_JUSTIFY_CENTER|Gfx.TEXT_JUSTIFY_VCENTER);
      sValue = $.RL_oData.fPositionLongitude != null ? $.RL_oData.fPositionLongitude.format("%.06f") : self.NOVALUE_LEN3;
      _oDC.drawText(self.iCenterX, self.iValue2Y, Gfx.FONT_SMALL, sValue, Gfx.TEXT_JUSTIFY_CENTER|Gfx.TEXT_JUSTIFY_VCENTER);
    }
    else if($.RL_iViewIndex == 2) {  // ... position: altitude
      // ... label
      _oDC.setColor(Gfx.COLOR_BLUE, Gfx.COLOR_TRANSPARENT);
      if($.RL_sViewLabel1 == null) {
        $.RL_sViewLabel1 = Ui.loadResource(Rez.Strings.labelPosition);
      }
      if($.RL_sViewLabel2 == null) {
        $.RL_sViewLabel2 = Lang.format("$1$ ($2$)", [Ui.loadResource(Rez.Strings.labelAltitude), Ui.loadResource(Rez.Strings.unitPositionAltitude)]);
      }
      _oDC.drawText(self.iCenterX, self.iLabel1Y, Gfx.FONT_SMALL, $.RL_sViewLabel1, Gfx.TEXT_JUSTIFY_CENTER|Gfx.TEXT_JUSTIFY_VCENTER);
      _oDC.drawText(self.iCenterX, self.iLabel2Y, Gfx.FONT_SMALL, $.RL_sViewLabel2, Gfx.TEXT_JUSTIFY_CENTER|Gfx.TEXT_JUSTIFY_VCENTER);
      // ... value(s)
      _oDC.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);
      sValue = $.RL_oData.fPositionAltitude != null ? $.RL_oData.fPositionAltitude.format("%.06f") : self.NOVALUE_LEN3;
      _oDC.drawText(self.iCenterX, self.iValue1Y, Gfx.FONT_SMALL, sValue, Gfx.TEXT_JUSTIFY_CENTER|Gfx.TEXT_JUSTIFY_VCENTER);
    }
    else if($.RL_iViewIndex == 3) {  // ... position: speed
      // ... label
      _oDC.setColor(Gfx.COLOR_BLUE, Gfx.COLOR_TRANSPARENT);
      if($.RL_sViewLabel1 == null) {
        $.RL_sViewLabel1 = Ui.loadResource(Rez.Strings.labelPosition);
      }
      if($.RL_sViewLabel2 == null) {
        $.RL_sViewLabel2 = Lang.format("$1$ ($2$)", [Ui.loadResource(Rez.Strings.labelSpeed), Ui.loadResource(Rez.Strings.unitPositionSpeed)]);
      }
      _oDC.drawText(self.iCenterX, self.iLabel1Y, Gfx.FONT_SMALL, $.RL_sViewLabel1, Gfx.TEXT_JUSTIFY_CENTER|Gfx.TEXT_JUSTIFY_VCENTER);
      _oDC.drawText(self.iCenterX, self.iLabel2Y, Gfx.FONT_SMALL, $.RL_sViewLabel2, Gfx.TEXT_JUSTIFY_CENTER|Gfx.TEXT_JUSTIFY_VCENTER);
      // ... value(s)
      _oDC.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);
      sValue = $.RL_oData.fPositionSpeed != null ? $.RL_oData.fPositionSpeed.format("%.06f") : self.NOVALUE_LEN3;
      _oDC.drawText(self.iCenterX, self.iValue1Y, Gfx.FONT_SMALL, sValue, Gfx.TEXT_JUSTIFY_CENTER|Gfx.TEXT_JUSTIFY_VCENTER);
    }
    else if($.RL_iViewIndex == 4) {  // ... position: heading
      // ... label
      _oDC.setColor(Gfx.COLOR_BLUE, Gfx.COLOR_TRANSPARENT);
      if($.RL_sViewLabel1 == null) {
        $.RL_sViewLabel1 = Ui.loadResource(Rez.Strings.labelPosition);
      }
      if($.RL_sViewLabel2 == null) {
        $.RL_sViewLabel2 = Lang.format("$1$ ($2$)", [Ui.loadResource(Rez.Strings.labelHeading), Ui.loadResource(Rez.Strings.unitPositionHeading)]);
      }
      _oDC.drawText(self.iCenterX, self.iLabel1Y, Gfx.FONT_SMALL, $.RL_sViewLabel1, Gfx.TEXT_JUSTIFY_CENTER|Gfx.TEXT_JUSTIFY_VCENTER);
      _oDC.drawText(self.iCenterX, self.iLabel2Y, Gfx.FONT_SMALL, $.RL_sViewLabel2, Gfx.TEXT_JUSTIFY_CENTER|Gfx.TEXT_JUSTIFY_VCENTER);
      // ... value(s)
      _oDC.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);
      sValue = $.RL_oData.fPositionHeading != null ? $.RL_oData.fPositionHeading.format("%.06f") : self.NOVALUE_LEN3;
      _oDC.drawText(self.iCenterX, self.iValue1Y, Gfx.FONT_SMALL, sValue, Gfx.TEXT_JUSTIFY_CENTER|Gfx.TEXT_JUSTIFY_VCENTER);
    }
    else if($.RL_iViewIndex == 5) {  // ... position: accuracy
      // ... label
      _oDC.setColor(Gfx.COLOR_BLUE, Gfx.COLOR_TRANSPARENT);
      if($.RL_sViewLabel1 == null) {
        $.RL_sViewLabel1 = Ui.loadResource(Rez.Strings.labelPosition);
      }
      if($.RL_sViewLabel2 == null) {
        $.RL_sViewLabel2 = Lang.format("$1$ ($2$)", [Ui.loadResource(Rez.Strings.labelAccuracy), Ui.loadResource(Rez.Strings.unitPositionAccuracy)]);
      }
      _oDC.drawText(self.iCenterX, self.iLabel1Y, Gfx.FONT_SMALL, $.RL_sViewLabel1, Gfx.TEXT_JUSTIFY_CENTER|Gfx.TEXT_JUSTIFY_VCENTER);
      _oDC.drawText(self.iCenterX, self.iLabel2Y, Gfx.FONT_SMALL, $.RL_sViewLabel2, Gfx.TEXT_JUSTIFY_CENTER|Gfx.TEXT_JUSTIFY_VCENTER);
      // ... value(s)
      _oDC.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);
      sValue = $.RL_oData.iPositionAccuracy != null ? $.RL_oData.iPositionAccuracy.format("%d") : self.NOVALUE_LEN3;
      _oDC.drawText(self.iCenterX, self.iValue1Y, Gfx.FONT_SMALL, sValue, Gfx.TEXT_JUSTIFY_CENTER|Gfx.TEXT_JUSTIFY_VCENTER);
    }

    else if($.RL_iViewIndex == 6) {  // ... sensor: altitude
      // ... label
      _oDC.setColor(Gfx.COLOR_BLUE, Gfx.COLOR_TRANSPARENT);
      if($.RL_sViewLabel1 == null) {
        $.RL_sViewLabel1 = Ui.loadResource(Rez.Strings.labelSensor);
      }
      if($.RL_sViewLabel2 == null) {
        $.RL_sViewLabel2 = Lang.format("$1$ ($2$)", [Ui.loadResource(Rez.Strings.labelAltitude), Ui.loadResource(Rez.Strings.unitSensorAltitude)]);
      }
      _oDC.drawText(self.iCenterX, self.iLabel1Y, Gfx.FONT_SMALL, $.RL_sViewLabel1, Gfx.TEXT_JUSTIFY_CENTER|Gfx.TEXT_JUSTIFY_VCENTER);
      _oDC.drawText(self.iCenterX, self.iLabel2Y, Gfx.FONT_SMALL, $.RL_sViewLabel2, Gfx.TEXT_JUSTIFY_CENTER|Gfx.TEXT_JUSTIFY_VCENTER);
      // ... value(s)
      _oDC.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);
      sValue = $.RL_oData.fSensorAltitude != null ? $.RL_oData.fSensorAltitude.format("%.06f") : self.NOVALUE_LEN3;
      _oDC.drawText(self.iCenterX, self.iValue1Y, Gfx.FONT_SMALL, sValue, Gfx.TEXT_JUSTIFY_CENTER|Gfx.TEXT_JUSTIFY_VCENTER);
    }
    else if($.RL_iViewIndex == 7) {  // ... sensor: speed
      // ... label
      _oDC.setColor(Gfx.COLOR_BLUE, Gfx.COLOR_TRANSPARENT);
      if($.RL_sViewLabel1 == null) {
        $.RL_sViewLabel1 = Ui.loadResource(Rez.Strings.labelSensor);
      }
      if($.RL_sViewLabel2 == null) {
        $.RL_sViewLabel2 = Lang.format("$1$ ($2$)", [Ui.loadResource(Rez.Strings.labelSpeed), Ui.loadResource(Rez.Strings.unitSensorSpeed)]);
      }
      _oDC.drawText(self.iCenterX, self.iLabel1Y, Gfx.FONT_SMALL, $.RL_sViewLabel1, Gfx.TEXT_JUSTIFY_CENTER|Gfx.TEXT_JUSTIFY_VCENTER);
      _oDC.drawText(self.iCenterX, self.iLabel2Y, Gfx.FONT_SMALL, $.RL_sViewLabel2, Gfx.TEXT_JUSTIFY_CENTER|Gfx.TEXT_JUSTIFY_VCENTER);
      // ... value(s)
      _oDC.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);
      sValue = $.RL_oData.fSensorSpeed != null ? $.RL_oData.fSensorSpeed.format("%.06f") : self.NOVALUE_LEN3;
      _oDC.drawText(self.iCenterX, self.iValue1Y, Gfx.FONT_SMALL, sValue, Gfx.TEXT_JUSTIFY_CENTER|Gfx.TEXT_JUSTIFY_VCENTER);
    }
    else if($.RL_iViewIndex == 8) {  // ... sensor: heading
      // ... label
      _oDC.setColor(Gfx.COLOR_BLUE, Gfx.COLOR_TRANSPARENT);
      if($.RL_sViewLabel1 == null) {
        $.RL_sViewLabel1 = Ui.loadResource(Rez.Strings.labelSensor);
      }
      if($.RL_sViewLabel2 == null) {
        $.RL_sViewLabel2 = Lang.format("$1$ ($2$)", [Ui.loadResource(Rez.Strings.labelHeading), Ui.loadResource(Rez.Strings.unitSensorHeading)]);
      }
      _oDC.drawText(self.iCenterX, self.iLabel1Y, Gfx.FONT_SMALL, $.RL_sViewLabel1, Gfx.TEXT_JUSTIFY_CENTER|Gfx.TEXT_JUSTIFY_VCENTER);
      _oDC.drawText(self.iCenterX, self.iLabel2Y, Gfx.FONT_SMALL, $.RL_sViewLabel2, Gfx.TEXT_JUSTIFY_CENTER|Gfx.TEXT_JUSTIFY_VCENTER);
      // ... value(s)
      _oDC.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);
      sValue = $.RL_oData.fSensorHeading != null ? $.RL_oData.fSensorHeading.format("%.06f") : self.NOVALUE_LEN3;
      _oDC.drawText(self.iCenterX, self.iValue1Y, Gfx.FONT_SMALL, sValue, Gfx.TEXT_JUSTIFY_CENTER|Gfx.TEXT_JUSTIFY_VCENTER);
    }
    else if($.RL_iViewIndex == 9) {  // ... sensor: pressure
      // ... label
      _oDC.setColor(Gfx.COLOR_BLUE, Gfx.COLOR_TRANSPARENT);
      if($.RL_sViewLabel1 == null) {
        $.RL_sViewLabel1 = Ui.loadResource(Rez.Strings.labelSensor);
      }
      if($.RL_sViewLabel2 == null) {
        $.RL_sViewLabel2 = Lang.format("$1$ ($2$)", [Ui.loadResource(Rez.Strings.labelPressure), Ui.loadResource(Rez.Strings.unitSensorPressure)]);
      }
      _oDC.drawText(self.iCenterX, self.iLabel1Y, Gfx.FONT_SMALL, $.RL_sViewLabel1, Gfx.TEXT_JUSTIFY_CENTER|Gfx.TEXT_JUSTIFY_VCENTER);
      _oDC.drawText(self.iCenterX, self.iLabel2Y, Gfx.FONT_SMALL, $.RL_sViewLabel2, Gfx.TEXT_JUSTIFY_CENTER|Gfx.TEXT_JUSTIFY_VCENTER);
      // ... value(s)
      _oDC.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);
      sValue = $.RL_oData.fSensorPressure != null ? $.RL_oData.fSensorPressure.format("%.02f") : self.NOVALUE_LEN3;
      _oDC.drawText(self.iCenterX, self.iValue1Y, Gfx.FONT_SMALL, sValue, Gfx.TEXT_JUSTIFY_CENTER|Gfx.TEXT_JUSTIFY_VCENTER);
    }
    else if($.RL_iViewIndex == 10) {  // ... sensor: acceleration
      // ... label
      _oDC.setColor(Gfx.COLOR_BLUE, Gfx.COLOR_TRANSPARENT);
      if($.RL_sViewLabel1 == null) {
        $.RL_sViewLabel1 = Ui.loadResource(Rez.Strings.labelSensor);
      }
      if($.RL_sViewLabel2 == null) {
        $.RL_sViewLabel2 = Lang.format("$1$ ($2$)", [Ui.loadResource(Rez.Strings.labelAcceleration), Ui.loadResource(Rez.Strings.unitSensorAcceleration)]);
      }
      _oDC.drawText(self.iCenterX, self.iLabel1Y, Gfx.FONT_SMALL, $.RL_sViewLabel1, Gfx.TEXT_JUSTIFY_CENTER|Gfx.TEXT_JUSTIFY_VCENTER);
      _oDC.drawText(self.iCenterX, self.iLabel2Y, Gfx.FONT_SMALL, $.RL_sViewLabel2, Gfx.TEXT_JUSTIFY_CENTER|Gfx.TEXT_JUSTIFY_VCENTER);
      // ... value(s)
      _oDC.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);
      sValue = $.RL_oData.iSensorAccelerationX != null ? $.RL_oData.iSensorAccelerationX.format("%d") : self.NOVALUE_LEN3;
      _oDC.drawText(self.iCenterX, self.iValue1Y, Gfx.FONT_SMALL, sValue, Gfx.TEXT_JUSTIFY_CENTER|Gfx.TEXT_JUSTIFY_VCENTER);
      sValue = $.RL_oData.iSensorAccelerationY != null ? $.RL_oData.iSensorAccelerationY.format("%d") : self.NOVALUE_LEN3;
      _oDC.drawText(self.iCenterX, self.iValue2Y, Gfx.FONT_SMALL, sValue, Gfx.TEXT_JUSTIFY_CENTER|Gfx.TEXT_JUSTIFY_VCENTER);
      sValue = $.RL_oData.iSensorAccelerationZ != null ? $.RL_oData.iSensorAccelerationZ.format("%d") : self.NOVALUE_LEN3;
      _oDC.drawText(self.iCenterX, self.iValue3Y, Gfx.FONT_SMALL, sValue, Gfx.TEXT_JUSTIFY_CENTER|Gfx.TEXT_JUSTIFY_VCENTER);
    }
    else if($.RL_iViewIndex == 11) {  // ... sensor: magnetometer
      // ... label
      _oDC.setColor(Gfx.COLOR_BLUE, Gfx.COLOR_TRANSPARENT);
      if($.RL_sViewLabel1 == null) {
        $.RL_sViewLabel1 = Ui.loadResource(Rez.Strings.labelSensor);
      }
      if($.RL_sViewLabel2 == null) {
        $.RL_sViewLabel2 = Lang.format("$1$ ($2$)", [Ui.loadResource(Rez.Strings.labelMagnetometer), Ui.loadResource(Rez.Strings.unitSensorMagnetometer)]);
      }
      _oDC.drawText(self.iCenterX, self.iLabel1Y, Gfx.FONT_SMALL, $.RL_sViewLabel1, Gfx.TEXT_JUSTIFY_CENTER|Gfx.TEXT_JUSTIFY_VCENTER);
      _oDC.drawText(self.iCenterX, self.iLabel2Y, Gfx.FONT_SMALL, $.RL_sViewLabel2, Gfx.TEXT_JUSTIFY_CENTER|Gfx.TEXT_JUSTIFY_VCENTER);
      // ... value(s)
      _oDC.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);
      sValue = $.RL_oData.iSensorMagnetometerX != null ? $.RL_oData.iSensorMagnetometerX.format("%d") : self.NOVALUE_LEN3;
      _oDC.drawText(self.iCenterX, self.iValue1Y, Gfx.FONT_SMALL, sValue, Gfx.TEXT_JUSTIFY_CENTER|Gfx.TEXT_JUSTIFY_VCENTER);
      sValue = $.RL_oData.iSensorMagnetometerY != null ? $.RL_oData.iSensorMagnetometerY.format("%d") : self.NOVALUE_LEN3;
      _oDC.drawText(self.iCenterX, self.iValue2Y, Gfx.FONT_SMALL, sValue, Gfx.TEXT_JUSTIFY_CENTER|Gfx.TEXT_JUSTIFY_VCENTER);
      sValue = $.RL_oData.iSensorMagnetometerZ != null ? $.RL_oData.iSensorMagnetometerZ.format("%d") : self.NOVALUE_LEN3;
      _oDC.drawText(self.iCenterX, self.iValue3Y, Gfx.FONT_SMALL, sValue, Gfx.TEXT_JUSTIFY_CENTER|Gfx.TEXT_JUSTIFY_VCENTER);
    }
    else if($.RL_iViewIndex == 12) {  // ... sensor: heartrate
      // ... label
      _oDC.setColor(Gfx.COLOR_BLUE, Gfx.COLOR_TRANSPARENT);
      if($.RL_sViewLabel1 == null) {
        $.RL_sViewLabel1 = Ui.loadResource(Rez.Strings.labelSensor);
      }
      if($.RL_sViewLabel2 == null) {
        $.RL_sViewLabel2 = Lang.format("$1$ ($2$)", [Ui.loadResource(Rez.Strings.labelHeartrate), Ui.loadResource(Rez.Strings.unitSensorHeartrate)]);
      }
      _oDC.drawText(self.iCenterX, self.iLabel1Y, Gfx.FONT_SMALL, $.RL_sViewLabel1, Gfx.TEXT_JUSTIFY_CENTER|Gfx.TEXT_JUSTIFY_VCENTER);
      _oDC.drawText(self.iCenterX, self.iLabel2Y, Gfx.FONT_SMALL, $.RL_sViewLabel2, Gfx.TEXT_JUSTIFY_CENTER|Gfx.TEXT_JUSTIFY_VCENTER);
      // ... value(s)
      _oDC.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);
      sValue = $.RL_oData.iSensorHeartrate != null ? $.RL_oData.iSensorHeartrate.format("%d") : self.NOVALUE_LEN3;
      _oDC.drawText(self.iCenterX, self.iValue1Y, Gfx.FONT_SMALL, sValue, Gfx.TEXT_JUSTIFY_CENTER|Gfx.TEXT_JUSTIFY_VCENTER);
    }
    else if($.RL_iViewIndex == 13) {  // ... sensor: cadence
      // ... label
      _oDC.setColor(Gfx.COLOR_BLUE, Gfx.COLOR_TRANSPARENT);
      if($.RL_sViewLabel1 == null) {
        $.RL_sViewLabel1 = Ui.loadResource(Rez.Strings.labelSensor);
      }
      if($.RL_sViewLabel2 == null) {
        $.RL_sViewLabel2 = Lang.format("$1$ ($2$)", [Ui.loadResource(Rez.Strings.labelCadence), Ui.loadResource(Rez.Strings.unitSensorCadence)]);
      }
      _oDC.drawText(self.iCenterX, self.iLabel1Y, Gfx.FONT_SMALL, $.RL_sViewLabel1, Gfx.TEXT_JUSTIFY_CENTER|Gfx.TEXT_JUSTIFY_VCENTER);
      _oDC.drawText(self.iCenterX, self.iLabel2Y, Gfx.FONT_SMALL, $.RL_sViewLabel2, Gfx.TEXT_JUSTIFY_CENTER|Gfx.TEXT_JUSTIFY_VCENTER);
      // ... value(s)
      _oDC.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);
      sValue = $.RL_oData.iSensorCadence != null ? $.RL_oData.iSensorCadence.format("%d") : self.NOVALUE_LEN3;
      _oDC.drawText(self.iCenterX, self.iValue1Y, Gfx.FONT_SMALL, sValue, Gfx.TEXT_JUSTIFY_CENTER|Gfx.TEXT_JUSTIFY_VCENTER);
    }
    else if($.RL_iViewIndex == 14) {  // ... sensor: power
      // ... label
      _oDC.setColor(Gfx.COLOR_BLUE, Gfx.COLOR_TRANSPARENT);
      if($.RL_sViewLabel1 == null) {
        $.RL_sViewLabel1 = Ui.loadResource(Rez.Strings.labelSensor);
      }
      if($.RL_sViewLabel2 == null) {
        $.RL_sViewLabel2 = Lang.format("$1$ ($2$)", [Ui.loadResource(Rez.Strings.labelPower), Ui.loadResource(Rez.Strings.unitSensorPower)]);
      }
      _oDC.drawText(self.iCenterX, self.iLabel1Y, Gfx.FONT_SMALL, $.RL_sViewLabel1, Gfx.TEXT_JUSTIFY_CENTER|Gfx.TEXT_JUSTIFY_VCENTER);
      _oDC.drawText(self.iCenterX, self.iLabel2Y, Gfx.FONT_SMALL, $.RL_sViewLabel2, Gfx.TEXT_JUSTIFY_CENTER|Gfx.TEXT_JUSTIFY_VCENTER);
      // ... value(s)
      _oDC.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);
      sValue = $.RL_oData.iSensorPower != null ? $.RL_oData.iSensorPower.format("%d") : self.NOVALUE_LEN3;
      _oDC.drawText(self.iCenterX, self.iValue1Y, Gfx.FONT_SMALL, sValue, Gfx.TEXT_JUSTIFY_CENTER|Gfx.TEXT_JUSTIFY_VCENTER);
    }
    else if($.RL_iViewIndex == 15) {  // ... sensor: temperature
      // ... label
      _oDC.setColor(Gfx.COLOR_BLUE, Gfx.COLOR_TRANSPARENT);
      if($.RL_sViewLabel1 == null) {
        $.RL_sViewLabel1 = Ui.loadResource(Rez.Strings.labelSensor);
      }
      if($.RL_sViewLabel2 == null) {
        $.RL_sViewLabel2 = Lang.format("$1$ ($2$)", [Ui.loadResource(Rez.Strings.labelTemperature), Ui.loadResource(Rez.Strings.unitSensorTemperature)]);
      }
      _oDC.drawText(self.iCenterX, self.iLabel1Y, Gfx.FONT_SMALL, $.RL_sViewLabel1, Gfx.TEXT_JUSTIFY_CENTER|Gfx.TEXT_JUSTIFY_VCENTER);
      _oDC.drawText(self.iCenterX, self.iLabel2Y, Gfx.FONT_SMALL, $.RL_sViewLabel2, Gfx.TEXT_JUSTIFY_CENTER|Gfx.TEXT_JUSTIFY_VCENTER);
      // ... value(s)
      _oDC.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);
      sValue = $.RL_oData.fSensorTemperature != null ? $.RL_oData.fSensorTemperature.format("%.02f") : self.NOVALUE_LEN3;
      _oDC.drawText(self.iCenterX, self.iValue1Y, Gfx.FONT_SMALL, sValue, Gfx.TEXT_JUSTIFY_CENTER|Gfx.TEXT_JUSTIFY_VCENTER);
    }

    else if($.RL_iViewIndex == 16) {  // ... activity: location
      // ... label
      _oDC.setColor(Gfx.COLOR_BLUE, Gfx.COLOR_TRANSPARENT);
      if($.RL_sViewLabel1 == null) {
        $.RL_sViewLabel1 = Ui.loadResource(Rez.Strings.labelActivity);
      }
      if($.RL_sViewLabel2 == null) {
        $.RL_sViewLabel2 = Lang.format("$1$ ($2$)", [Ui.loadResource(Rez.Strings.labelLocation), Ui.loadResource(Rez.Strings.unitActivityLocation)]);
      }
      _oDC.drawText(self.iCenterX, self.iLabel1Y, Gfx.FONT_SMALL, $.RL_sViewLabel1, Gfx.TEXT_JUSTIFY_CENTER|Gfx.TEXT_JUSTIFY_VCENTER);
      _oDC.drawText(self.iCenterX, self.iLabel2Y, Gfx.FONT_SMALL, $.RL_sViewLabel2, Gfx.TEXT_JUSTIFY_CENTER|Gfx.TEXT_JUSTIFY_VCENTER);
      // ... value(s)
      _oDC.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);
      sValue = $.RL_oData.fActivityLatitude != null ? $.RL_oData.fActivityLatitude.format("%.06f") : self.NOVALUE_LEN3;
      _oDC.drawText(self.iCenterX, self.iValue1Y, Gfx.FONT_SMALL, sValue, Gfx.TEXT_JUSTIFY_CENTER|Gfx.TEXT_JUSTIFY_VCENTER);
      sValue = $.RL_oData.fActivityLongitude != null ? $.RL_oData.fActivityLongitude.format("%.06f") : self.NOVALUE_LEN3;
      _oDC.drawText(self.iCenterX, self.iValue2Y, Gfx.FONT_SMALL, sValue, Gfx.TEXT_JUSTIFY_CENTER|Gfx.TEXT_JUSTIFY_VCENTER);
    }
    else if($.RL_iViewIndex == 17) {  // ... activity: altitude
      // ... label
      _oDC.setColor(Gfx.COLOR_BLUE, Gfx.COLOR_TRANSPARENT);
      if($.RL_sViewLabel1 == null) {
        $.RL_sViewLabel1 = Ui.loadResource(Rez.Strings.labelActivity);
      }
      if($.RL_sViewLabel2 == null) {
        $.RL_sViewLabel2 = Lang.format("$1$ ($2$)", [Ui.loadResource(Rez.Strings.labelAltitude), Ui.loadResource(Rez.Strings.unitActivityAltitude)]);
      }
      _oDC.drawText(self.iCenterX, self.iLabel1Y, Gfx.FONT_SMALL, $.RL_sViewLabel1, Gfx.TEXT_JUSTIFY_CENTER|Gfx.TEXT_JUSTIFY_VCENTER);
      _oDC.drawText(self.iCenterX, self.iLabel2Y, Gfx.FONT_SMALL, $.RL_sViewLabel2, Gfx.TEXT_JUSTIFY_CENTER|Gfx.TEXT_JUSTIFY_VCENTER);
      // ... value(s)
      _oDC.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);
      sValue = $.RL_oData.fActivityAltitude != null ? $.RL_oData.fActivityAltitude.format("%.06f") : self.NOVALUE_LEN3;
      _oDC.drawText(self.iCenterX, self.iValue1Y, Gfx.FONT_SMALL, sValue, Gfx.TEXT_JUSTIFY_CENTER|Gfx.TEXT_JUSTIFY_VCENTER);
    }
    else if($.RL_iViewIndex == 18) {  // ... activity: speed
      // ... label
      _oDC.setColor(Gfx.COLOR_BLUE, Gfx.COLOR_TRANSPARENT);
      if($.RL_sViewLabel1 == null) {
        $.RL_sViewLabel1 = Ui.loadResource(Rez.Strings.labelActivity);
      }
      if($.RL_sViewLabel2 == null) {
        $.RL_sViewLabel2 = Lang.format("$1$ ($2$)", [Ui.loadResource(Rez.Strings.labelSpeed), Ui.loadResource(Rez.Strings.unitActivitySpeed)]);
      }
      _oDC.drawText(self.iCenterX, self.iLabel1Y, Gfx.FONT_SMALL, $.RL_sViewLabel1, Gfx.TEXT_JUSTIFY_CENTER|Gfx.TEXT_JUSTIFY_VCENTER);
      _oDC.drawText(self.iCenterX, self.iLabel2Y, Gfx.FONT_SMALL, $.RL_sViewLabel2, Gfx.TEXT_JUSTIFY_CENTER|Gfx.TEXT_JUSTIFY_VCENTER);
      // ... value(s)
      _oDC.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);
      sValue = $.RL_oData.fActivitySpeed != null ? $.RL_oData.fActivitySpeed.format("%.06f") : self.NOVALUE_LEN3;
      _oDC.drawText(self.iCenterX, self.iValue1Y, Gfx.FONT_SMALL, sValue, Gfx.TEXT_JUSTIFY_CENTER|Gfx.TEXT_JUSTIFY_VCENTER);
    }
    else if($.RL_iViewIndex == 19) {  // ... activity: heading
      // ... label
      _oDC.setColor(Gfx.COLOR_BLUE, Gfx.COLOR_TRANSPARENT);
      if($.RL_sViewLabel1 == null) {
        $.RL_sViewLabel1 = Ui.loadResource(Rez.Strings.labelActivity);
      }
      if($.RL_sViewLabel2 == null) {
        $.RL_sViewLabel2 = Lang.format("$1$ ($2$)", [Ui.loadResource(Rez.Strings.labelHeading), Ui.loadResource(Rez.Strings.unitActivityHeading)]);
      }
      _oDC.drawText(self.iCenterX, self.iLabel1Y, Gfx.FONT_SMALL, $.RL_sViewLabel1, Gfx.TEXT_JUSTIFY_CENTER|Gfx.TEXT_JUSTIFY_VCENTER);
      _oDC.drawText(self.iCenterX, self.iLabel2Y, Gfx.FONT_SMALL, $.RL_sViewLabel2, Gfx.TEXT_JUSTIFY_CENTER|Gfx.TEXT_JUSTIFY_VCENTER);
      // ... value(s)
      _oDC.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);
      sValue = $.RL_oData.fActivityHeading != null ? $.RL_oData.fActivityHeading.format("%.06f") : self.NOVALUE_LEN3;
      _oDC.drawText(self.iCenterX, self.iValue1Y, Gfx.FONT_SMALL, sValue, Gfx.TEXT_JUSTIFY_CENTER|Gfx.TEXT_JUSTIFY_VCENTER);
    }
    else if($.RL_iViewIndex == 20) {  // ... activity: accuracy
      // ... label
      _oDC.setColor(Gfx.COLOR_BLUE, Gfx.COLOR_TRANSPARENT);
      if($.RL_sViewLabel1 == null) {
        $.RL_sViewLabel1 = Ui.loadResource(Rez.Strings.labelActivity);
      }
      if($.RL_sViewLabel2 == null) {
        $.RL_sViewLabel2 = Lang.format("$1$ ($2$)", [Ui.loadResource(Rez.Strings.labelAccuracy), Ui.loadResource(Rez.Strings.unitActivityAccuracy)]);
      }
      _oDC.drawText(self.iCenterX, self.iLabel1Y, Gfx.FONT_SMALL, $.RL_sViewLabel1, Gfx.TEXT_JUSTIFY_CENTER|Gfx.TEXT_JUSTIFY_VCENTER);
      _oDC.drawText(self.iCenterX, self.iLabel2Y, Gfx.FONT_SMALL, $.RL_sViewLabel2, Gfx.TEXT_JUSTIFY_CENTER|Gfx.TEXT_JUSTIFY_VCENTER);
      // ... value(s)
      _oDC.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);
      sValue = $.RL_oData.iActivityAccuracy != null ? $.RL_oData.iActivityAccuracy.format("%d") : self.NOVALUE_LEN3;
      _oDC.drawText(self.iCenterX, self.iValue1Y, Gfx.FONT_SMALL, sValue, Gfx.TEXT_JUSTIFY_CENTER|Gfx.TEXT_JUSTIFY_VCENTER);
    }
    else if($.RL_iViewIndex == 21) {  // ... activity: pressure
      // ... label
      _oDC.setColor(Gfx.COLOR_BLUE, Gfx.COLOR_TRANSPARENT);
      if($.RL_sViewLabel1 == null) {
        $.RL_sViewLabel1 = Ui.loadResource(Rez.Strings.labelActivity);
      }
      if($.RL_sViewLabel2 == null) {
        $.RL_sViewLabel2 = Lang.format("$1$ ($2$)", [Ui.loadResource(Rez.Strings.labelPressure), Ui.loadResource(Rez.Strings.unitActivityPressure)]);
      }
      _oDC.drawText(self.iCenterX, self.iLabel1Y, Gfx.FONT_SMALL, $.RL_sViewLabel1, Gfx.TEXT_JUSTIFY_CENTER|Gfx.TEXT_JUSTIFY_VCENTER);
      _oDC.drawText(self.iCenterX, self.iLabel2Y, Gfx.FONT_SMALL, $.RL_sViewLabel2, Gfx.TEXT_JUSTIFY_CENTER|Gfx.TEXT_JUSTIFY_VCENTER);
      // ... value(s)
      _oDC.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);
      sValue = $.RL_oData.fActivityPressureRaw != null ? $.RL_oData.fActivityPressureRaw.format("%.02f") : self.NOVALUE_LEN3;
      _oDC.drawText(self.iCenterX, self.iValue1Y, Gfx.FONT_SMALL, sValue, Gfx.TEXT_JUSTIFY_CENTER|Gfx.TEXT_JUSTIFY_VCENTER);
      sValue = $.RL_oData.fActivityPressureAmbient != null ? $.RL_oData.fActivityPressureAmbient.format("%.02f") : self.NOVALUE_LEN3;
      _oDC.drawText(self.iCenterX, self.iValue2Y, Gfx.FONT_SMALL, sValue, Gfx.TEXT_JUSTIFY_CENTER|Gfx.TEXT_JUSTIFY_VCENTER);
      sValue = $.RL_oData.fActivityPressureMean != null ? $.RL_oData.fActivityPressureMean.format("%.02f") : self.NOVALUE_LEN3;
      _oDC.drawText(self.iCenterX, self.iValue3Y, Gfx.FONT_SMALL, sValue, Gfx.TEXT_JUSTIFY_CENTER|Gfx.TEXT_JUSTIFY_VCENTER);
    }
    else if($.RL_iViewIndex == 22) {  // ... activity: heartrate
      // ... label
      _oDC.setColor(Gfx.COLOR_BLUE, Gfx.COLOR_TRANSPARENT);
      if($.RL_sViewLabel1 == null) {
        $.RL_sViewLabel1 = Ui.loadResource(Rez.Strings.labelActivity);
      }
      if($.RL_sViewLabel2 == null) {
        $.RL_sViewLabel2 = Lang.format("$1$ ($2$)", [Ui.loadResource(Rez.Strings.labelHeartrate), Ui.loadResource(Rez.Strings.unitActivityHeartrate)]);
      }
      _oDC.drawText(self.iCenterX, self.iLabel1Y, Gfx.FONT_SMALL, $.RL_sViewLabel1, Gfx.TEXT_JUSTIFY_CENTER|Gfx.TEXT_JUSTIFY_VCENTER);
      _oDC.drawText(self.iCenterX, self.iLabel2Y, Gfx.FONT_SMALL, $.RL_sViewLabel2, Gfx.TEXT_JUSTIFY_CENTER|Gfx.TEXT_JUSTIFY_VCENTER);
      // ... value(s)
      _oDC.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);
      sValue = $.RL_oData.iActivityHeartrate != null ? $.RL_oData.iActivityHeartrate.format("%d") : self.NOVALUE_LEN3;
      _oDC.drawText(self.iCenterX, self.iValue1Y, Gfx.FONT_SMALL, sValue, Gfx.TEXT_JUSTIFY_CENTER|Gfx.TEXT_JUSTIFY_VCENTER);
    }
    else if($.RL_iViewIndex == 23) {  // ... activity: cadence
      // ... label
      _oDC.setColor(Gfx.COLOR_BLUE, Gfx.COLOR_TRANSPARENT);
      if($.RL_sViewLabel1 == null) {
        $.RL_sViewLabel1 = Ui.loadResource(Rez.Strings.labelActivity);
      }
      if($.RL_sViewLabel2 == null) {
        $.RL_sViewLabel2 = Lang.format("$1$ ($2$)", [Ui.loadResource(Rez.Strings.labelCadence), Ui.loadResource(Rez.Strings.unitActivityCadence)]);
      }
      _oDC.drawText(self.iCenterX, self.iLabel1Y, Gfx.FONT_SMALL, $.RL_sViewLabel1, Gfx.TEXT_JUSTIFY_CENTER|Gfx.TEXT_JUSTIFY_VCENTER);
      _oDC.drawText(self.iCenterX, self.iLabel2Y, Gfx.FONT_SMALL, $.RL_sViewLabel2, Gfx.TEXT_JUSTIFY_CENTER|Gfx.TEXT_JUSTIFY_VCENTER);
      // ... value(s)
      _oDC.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);
      sValue = $.RL_oData.iActivityCadence != null ? $.RL_oData.iActivityCadence.format("%d") : self.NOVALUE_LEN3;
      _oDC.drawText(self.iCenterX, self.iValue1Y, Gfx.FONT_SMALL, sValue, Gfx.TEXT_JUSTIFY_CENTER|Gfx.TEXT_JUSTIFY_VCENTER);
    }
    else if($.RL_iViewIndex == 24) {  // ... activity: power
      // ... label
      _oDC.setColor(Gfx.COLOR_BLUE, Gfx.COLOR_TRANSPARENT);
      if($.RL_sViewLabel1 == null) {
        $.RL_sViewLabel1 = Ui.loadResource(Rez.Strings.labelActivity);
      }
      if($.RL_sViewLabel2 == null) {
        $.RL_sViewLabel2 = Lang.format("$1$ ($2$)", [Ui.loadResource(Rez.Strings.labelPower), Ui.loadResource(Rez.Strings.unitActivityPower)]);
      }
      _oDC.drawText(self.iCenterX, self.iLabel1Y, Gfx.FONT_SMALL, $.RL_sViewLabel1, Gfx.TEXT_JUSTIFY_CENTER|Gfx.TEXT_JUSTIFY_VCENTER);
      _oDC.drawText(self.iCenterX, self.iLabel2Y, Gfx.FONT_SMALL, $.RL_sViewLabel2, Gfx.TEXT_JUSTIFY_CENTER|Gfx.TEXT_JUSTIFY_VCENTER);
      // ... value(s)
      _oDC.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);
      sValue = $.RL_oData.iActivityPower != null ? $.RL_oData.iActivityPower.format("%d") : self.NOVALUE_LEN3;
      _oDC.drawText(self.iCenterX, self.iValue1Y, Gfx.FONT_SMALL, sValue, Gfx.TEXT_JUSTIFY_CENTER|Gfx.TEXT_JUSTIFY_VCENTER);
    }

  }

}

class RL_ViewDelegate extends Ui.BehaviorDelegate {

  //
  // FUNCTIONS: Ui.BehaviorDelegate (override/implement)
  //

  function initialize() {
    BehaviorDelegate.initialize();
  }

  function onMenu() {
    //Sys.println("DEBUG: RL_ViewDelegate.onMenu()");
    if($.RL_oActivitySession == null) {
      Ui.pushView(new Rez.Menus.menuSettings(), new MenuDelegateSettings(), Ui.SLIDE_IMMEDIATE);
    }
    else {
      if(Attention has :playTone) {
        Attention.playTone(Attention.TONE_ERROR);
      }
    }
    return true;
  }

  function onSelect() {
    //Sys.println("DEBUG: RL_ViewDelegate.onSelect()");
    if($.RL_oActivitySession == null) {
      App.getApp().initActivity();
      $.RL_oActivitySession.start();
      if(Attention has :playTone) {
        Attention.playTone(Attention.TONE_START);
      }
    }
    else {
      $.RL_oActivitySession.stop();
      $.RL_oActivitySession.save();
      App.getApp().resetActivity();
      if(Attention has :playTone) {
        Attention.playTone(Attention.TONE_STOP);
      }
    }
    return true;
  }

  function onBack() {
    //Sys.println("DEBUG: RL_ViewDelegate.onBack()");
    if($.RL_oActivitySession != null) {
      $.RL_oActivitySession.addLap();
      if(Attention has :playTone) {
        Attention.playTone(Attention.TONE_LAP);
      }
      return true;
    }
    return false;
  }

  function onNextPage() {
    //Sys.println("DEBUG: ViewDelegateVarioplot.onNextPage()");
    self.switchView(1);
    return true;
  }

  function onPreviousPage() {
    //Sys.println("DEBUG: ViewDelegateVarioplot.onNextPage()");
    self.switchView(-1);
    return true;
  }


  //
  // FUNCTIONS: self
  //

  function switchView(_iOffset) {
    if(_iOffset == 0) { return; }
    var iViewIndex_next = $.RL_iViewIndex;
    while(true) {
      iViewIndex_next += _iOffset;
      while(iViewIndex_next < 0) {
        iViewIndex_next += 25;
      }
      while(iViewIndex_next >= 25) {
        iViewIndex_next -= 25;
      }

      // ... time
      if(iViewIndex_next == 0) {
        break;
      }

      // ... position inputs
      else if(iViewIndex_next == 1 and $.RL_oSettings.bPositionLocation) { break; }
      else if(iViewIndex_next == 2 and $.RL_oSettings.bPositionAltitude) { break; }
      else if(iViewIndex_next == 3 and $.RL_oSettings.bPositionSpeed) { break; }
      else if(iViewIndex_next == 4 and $.RL_oSettings.bPositionHeading) { break; }
      else if(iViewIndex_next == 5 and $.RL_oSettings.bPositionAccuracy) { break; }

      // ... sensor inputs
      else if(iViewIndex_next == 6 and $.RL_oSettings.bSensorAltitude) { break; }
      else if(iViewIndex_next == 7 and $.RL_oSettings.bSensorSpeed) { break; }
      else if(iViewIndex_next == 8 and $.RL_oSettings.bSensorHeading) { break; }
      else if(iViewIndex_next == 9 and $.RL_oSettings.bSensorPressure) { break; }
      else if(iViewIndex_next == 10 and $.RL_oSettings.bSensorAcceleration) { break; }
      else if(iViewIndex_next == 11 and $.RL_oSettings.bSensorMagnetometer) { break; }
      else if(iViewIndex_next == 12 and $.RL_oSettings.bSensorHeartrate) { break; }
      else if(iViewIndex_next == 13 and $.RL_oSettings.bSensorCadence) { break; }
      else if(iViewIndex_next == 14 and $.RL_oSettings.bSensorPower) { break; }
      else if(iViewIndex_next == 15 and $.RL_oSettings.bSensorTemperature) { break; }

      // ... activity inputs
      else if(iViewIndex_next == 16 and $.RL_oSettings.bActivityLocation) { break; }
      else if(iViewIndex_next == 17 and $.RL_oSettings.bActivityAltitude) { break; }
      else if(iViewIndex_next == 18 and $.RL_oSettings.bActivitySpeed) { break; }
      else if(iViewIndex_next == 19 and $.RL_oSettings.bActivityHeading) { break; }
      else if(iViewIndex_next == 20 and $.RL_oSettings.bActivityAccuracy) { break; }
      else if(iViewIndex_next == 21 and $.RL_oSettings.bActivityPressure) { break; }
      else if(iViewIndex_next == 22 and $.RL_oSettings.bActivityHeartrate) { break; }
      else if(iViewIndex_next == 23 and $.RL_oSettings.bActivityCadence) { break; }
      else if(iViewIndex_next == 24 and $.RL_oSettings.bActivityPower) { break; }
    }
    if(iViewIndex_next != $.RL_iViewIndex) {
      $.RL_iViewIndex = iViewIndex_next;
      $.RL_sViewLabel1 = null;
      $.RL_sViewLabel2 = null;
    }
  }

}
