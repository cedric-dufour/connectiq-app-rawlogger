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
using Toybox.ActivityRecording;
using Toybox.Attention;
using Toybox.Graphics as Gfx;
using Toybox.System as Sys;
using Toybox.Time;
using Toybox.Time.Gregorian;
using Toybox.WatchUi as Ui;

//
// GLOBALS
//

// Current view index and labels
var iMyViewIndex as Number = 0;
var sMyViewLabel1 as String?;
var sMyViewLabel2 as String?;


//
// CLASS
//

class MyView extends Ui.View {

  //
  // CONSTANTS
  //

  private const NOVALUE_BLANK = "";
  private const NOVALUE_LEN3 = "---";


  //
  // VARIABLES
  //

  // Display mode (internal)
  private var bShow as Boolean = false;

  // Screen center coordinates
  private var iWidthX as Number = 0;
  private var iHeightY as Number = 0;
  private var iCenterX as Number = 0;
  private var iCenterY as Number = 0;
  private var iStatusY as Number = 0;
  private var iLabel1Y as Number = 0;
  private var iLabel2Y as Number = 0;
  private var iValue1Y as Number = 0;
  private var iValue2Y as Number = 0;
  private var iValue3Y as Number = 0;


  //
  // FUNCTIONS: Ui.View (override/implement)
  //

  function initialize() {
    View.initialize();
  }

  function onLayout(_oDC) {
    //Sys.println("DEBUG: MyView.onLayout()");

    // Screen center coordinates
    self.iWidthX = _oDC.getWidth();
    self.iHeightY = _oDC.getHeight();
    self.iCenterX = (self.iWidthX/2).toNumber();
    self.iCenterY = (self.iHeightY/2).toNumber();
    self.iStatusY = (self.iHeightY/8).toNumber();
    self.iLabel1Y = (self.iHeightY/5+self.iHeightY/8).toNumber();
    self.iLabel2Y = (self.iHeightY/5+self.iHeightY/8*2).toNumber();
    self.iValue1Y = (self.iHeightY/5+self.iHeightY/8*3).toNumber();
    self.iValue2Y = (self.iHeightY/5+self.iHeightY/8*4).toNumber();
    self.iValue3Y = (self.iHeightY/5+self.iHeightY/8*5).toNumber();
  }

  function onShow() {
    //Sys.println("DEBUG: MyView.onShow()");
    self.bShow = true;
    $.oMyView = self;
  }

  function onUpdate(_oDC) {
    //Sys.println("DEBUG: MyView.onUpdate()");
    self.drawValues(_oDC);
  }

  function onHide() {
    //Sys.println("DEBUG: MyView.onHide()");
    $.oMyView = null;
    self.bShow = false;
  }


  //
  // FUNCTIONS: self
  //

  function updateUi() as Void {
    //Sys.println("DEBUG: MyView.updateUi()");

    // Request UI update
    if(self.bShow) {
      Ui.requestUpdate();
    }
  }

  function drawValues(_oDC as Gfx.Dc) as Void {
    //Sys.println("DEBUG: MyView.drawValues()");
    _oDC.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_BLACK);
    _oDC.clear();
    var sValue;

    if($.oMyActivitySession != null) {  // ... activity status
      _oDC.setColor(Gfx.COLOR_RED, Gfx.COLOR_TRANSPARENT);
      _oDC.drawText(self.iCenterX, self.iStatusY, Gfx.FONT_SMALL, "REC", Gfx.TEXT_JUSTIFY_CENTER|Gfx.TEXT_JUSTIFY_VCENTER);
    }

    if($.iMyViewIndex == 0) {  // ... time
      // ... label
      _oDC.setColor(Gfx.COLOR_BLUE, Gfx.COLOR_TRANSPARENT);
      if($.sMyViewLabel2 == null) {
        $.sMyViewLabel2 = format("$1$ [$2$]", [Ui.loadResource(Rez.Strings.labelTime), Ui.loadResource(Rez.Strings.unitTime)]);
      }
      _oDC.drawText(self.iCenterX, self.iLabel1Y, Gfx.FONT_SMALL, self.NOVALUE_BLANK, Gfx.TEXT_JUSTIFY_CENTER|Gfx.TEXT_JUSTIFY_VCENTER);
      _oDC.drawText(self.iCenterX, self.iLabel2Y, Gfx.FONT_SMALL, $.sMyViewLabel2 as String, Gfx.TEXT_JUSTIFY_CENTER|Gfx.TEXT_JUSTIFY_VCENTER);
      // ... value(s)
      _oDC.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);
      var oTimeInfo = Gregorian.info(Time.now(), Time.FORMAT_SHORT);
      sValue = format("$1$:$2$", [oTimeInfo.hour.format("%02d"), oTimeInfo.min.format("%02d")]);
      _oDC.drawText(self.iCenterX, self.iValue1Y, Gfx.FONT_SMALL, sValue, Gfx.TEXT_JUSTIFY_CENTER|Gfx.TEXT_JUSTIFY_VCENTER);
    }

    else if($.iMyViewIndex == 1) {  // ... system: battery
      // ... label
      _oDC.setColor(Gfx.COLOR_BLUE, Gfx.COLOR_TRANSPARENT);
      if($.sMyViewLabel1 == null) {
        $.sMyViewLabel1 = Ui.loadResource(Rez.Strings.labelSystem) as String;
      }
      if($.sMyViewLabel2 == null) {
        $.sMyViewLabel2 = format("$1$ [$2$]", [Ui.loadResource(Rez.Strings.labelBattery), Ui.loadResource(Rez.Strings.unitSystemBattery)]);
      }
      _oDC.drawText(self.iCenterX, self.iLabel1Y, Gfx.FONT_SMALL, $.sMyViewLabel1 as String, Gfx.TEXT_JUSTIFY_CENTER|Gfx.TEXT_JUSTIFY_VCENTER);
      _oDC.drawText(self.iCenterX, self.iLabel2Y, Gfx.FONT_SMALL, $.sMyViewLabel2 as String, Gfx.TEXT_JUSTIFY_CENTER|Gfx.TEXT_JUSTIFY_VCENTER);
      // ... value(s)
      _oDC.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);
      sValue = $.oMyData.fSystemBattery != null ? ($.oMyData.fSystemBattery as Float).format("%.1f") : self.NOVALUE_LEN3;
      _oDC.drawText(self.iCenterX, self.iValue1Y, Gfx.FONT_SMALL, sValue, Gfx.TEXT_JUSTIFY_CENTER|Gfx.TEXT_JUSTIFY_VCENTER);
    }
    else if($.iMyViewIndex == 2) {  // ... system: memory
      // ... label
      _oDC.setColor(Gfx.COLOR_BLUE, Gfx.COLOR_TRANSPARENT);
      if($.sMyViewLabel1 == null) {
        $.sMyViewLabel1 = Ui.loadResource(Rez.Strings.labelSystem) as String;
      }
      if($.sMyViewLabel2 == null) {
        $.sMyViewLabel2 = format("$1$ [$2$]", [Ui.loadResource(Rez.Strings.labelMemory), Ui.loadResource(Rez.Strings.unitSystemMemory)]);
      }
      _oDC.drawText(self.iCenterX, self.iLabel1Y, Gfx.FONT_SMALL, $.sMyViewLabel1 as String, Gfx.TEXT_JUSTIFY_CENTER|Gfx.TEXT_JUSTIFY_VCENTER);
      _oDC.drawText(self.iCenterX, self.iLabel2Y, Gfx.FONT_SMALL, $.sMyViewLabel2 as String, Gfx.TEXT_JUSTIFY_CENTER|Gfx.TEXT_JUSTIFY_VCENTER);
      // ... value(s)
      _oDC.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);
      sValue = $.oMyData.iSystemMemoryUsed != null ? ($.oMyData.iSystemMemoryUsed as Number).format("%d") : self.NOVALUE_LEN3;
      _oDC.drawText(self.iCenterX, self.iValue1Y, Gfx.FONT_SMALL, sValue, Gfx.TEXT_JUSTIFY_CENTER|Gfx.TEXT_JUSTIFY_VCENTER);
      sValue = $.oMyData.iSystemMemoryFree != null ? ($.oMyData.iSystemMemoryFree as Number).format("%d") : self.NOVALUE_LEN3;
      _oDC.drawText(self.iCenterX, self.iValue2Y, Gfx.FONT_SMALL, sValue, Gfx.TEXT_JUSTIFY_CENTER|Gfx.TEXT_JUSTIFY_VCENTER);
    }

    else if($.iMyViewIndex == 3) {  // ... position: location
      // ... label
      _oDC.setColor(Gfx.COLOR_BLUE, Gfx.COLOR_TRANSPARENT);
      if($.sMyViewLabel1 == null) {
        $.sMyViewLabel1 = Ui.loadResource(Rez.Strings.labelPosition) as String;
      }
      if($.sMyViewLabel2 == null) {
        $.sMyViewLabel2 = format("$1$ [$2$]", [Ui.loadResource(Rez.Strings.labelLocation), Ui.loadResource(Rez.Strings.unitPositionLocation)]);
      }
      _oDC.drawText(self.iCenterX, self.iLabel1Y, Gfx.FONT_SMALL, $.sMyViewLabel1 as String, Gfx.TEXT_JUSTIFY_CENTER|Gfx.TEXT_JUSTIFY_VCENTER);
      _oDC.drawText(self.iCenterX, self.iLabel2Y, Gfx.FONT_SMALL, $.sMyViewLabel2 as String, Gfx.TEXT_JUSTIFY_CENTER|Gfx.TEXT_JUSTIFY_VCENTER);
      // ... value(s)
      _oDC.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);
      sValue = $.oMyData.dPositionLatitude != null ? ($.oMyData.dPositionLatitude as Double).format("%.6f") : self.NOVALUE_LEN3;
      _oDC.drawText(self.iCenterX, self.iValue1Y, Gfx.FONT_SMALL, sValue, Gfx.TEXT_JUSTIFY_CENTER|Gfx.TEXT_JUSTIFY_VCENTER);
      sValue = $.oMyData.dPositionLongitude != null ? ($.oMyData.dPositionLongitude as Double).format("%.6f") : self.NOVALUE_LEN3;
      _oDC.drawText(self.iCenterX, self.iValue2Y, Gfx.FONT_SMALL, sValue, Gfx.TEXT_JUSTIFY_CENTER|Gfx.TEXT_JUSTIFY_VCENTER);
    }
    else if($.iMyViewIndex == 4) {  // ... position: altitude
      // ... label
      _oDC.setColor(Gfx.COLOR_BLUE, Gfx.COLOR_TRANSPARENT);
      if($.sMyViewLabel1 == null) {
        $.sMyViewLabel1 = Ui.loadResource(Rez.Strings.labelPosition) as String;
      }
      if($.sMyViewLabel2 == null) {
        $.sMyViewLabel2 = format("$1$ [$2$]", [Ui.loadResource(Rez.Strings.labelAltitude), Ui.loadResource(Rez.Strings.unitPositionAltitude)]);
      }
      _oDC.drawText(self.iCenterX, self.iLabel1Y, Gfx.FONT_SMALL, $.sMyViewLabel1 as String, Gfx.TEXT_JUSTIFY_CENTER|Gfx.TEXT_JUSTIFY_VCENTER);
      _oDC.drawText(self.iCenterX, self.iLabel2Y, Gfx.FONT_SMALL, $.sMyViewLabel2 as String, Gfx.TEXT_JUSTIFY_CENTER|Gfx.TEXT_JUSTIFY_VCENTER);
      // ... value(s)
      _oDC.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);
      sValue = $.oMyData.fPositionAltitude != null ? ($.oMyData.fPositionAltitude as Float).format("%.6f") : self.NOVALUE_LEN3;
      _oDC.drawText(self.iCenterX, self.iValue1Y, Gfx.FONT_SMALL, sValue, Gfx.TEXT_JUSTIFY_CENTER|Gfx.TEXT_JUSTIFY_VCENTER);
    }
    else if($.iMyViewIndex == 5) {  // ... position: speed
      // ... label
      _oDC.setColor(Gfx.COLOR_BLUE, Gfx.COLOR_TRANSPARENT);
      if($.sMyViewLabel1 == null) {
        $.sMyViewLabel1 = Ui.loadResource(Rez.Strings.labelPosition) as String;
      }
      if($.sMyViewLabel2 == null) {
        $.sMyViewLabel2 = format("$1$ [$2$]", [Ui.loadResource(Rez.Strings.labelSpeed), Ui.loadResource(Rez.Strings.unitPositionSpeed)]);
      }
      _oDC.drawText(self.iCenterX, self.iLabel1Y, Gfx.FONT_SMALL, $.sMyViewLabel1 as String, Gfx.TEXT_JUSTIFY_CENTER|Gfx.TEXT_JUSTIFY_VCENTER);
      _oDC.drawText(self.iCenterX, self.iLabel2Y, Gfx.FONT_SMALL, $.sMyViewLabel2 as String, Gfx.TEXT_JUSTIFY_CENTER|Gfx.TEXT_JUSTIFY_VCENTER);
      // ... value(s)
      _oDC.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);
      sValue = $.oMyData.fPositionSpeed != null ? ($.oMyData.fPositionSpeed as Float).format("%.6f") : self.NOVALUE_LEN3;
      _oDC.drawText(self.iCenterX, self.iValue1Y, Gfx.FONT_SMALL, sValue, Gfx.TEXT_JUSTIFY_CENTER|Gfx.TEXT_JUSTIFY_VCENTER);
    }
    else if($.iMyViewIndex == 6) {  // ... position: heading
      // ... label
      _oDC.setColor(Gfx.COLOR_BLUE, Gfx.COLOR_TRANSPARENT);
      if($.sMyViewLabel1 == null) {
        $.sMyViewLabel1 = Ui.loadResource(Rez.Strings.labelPosition) as String;
      }
      if($.sMyViewLabel2 == null) {
        $.sMyViewLabel2 = format("$1$ [$2$]", [Ui.loadResource(Rez.Strings.labelHeading), Ui.loadResource(Rez.Strings.unitPositionHeading)]);
      }
      _oDC.drawText(self.iCenterX, self.iLabel1Y, Gfx.FONT_SMALL, $.sMyViewLabel1 as String, Gfx.TEXT_JUSTIFY_CENTER|Gfx.TEXT_JUSTIFY_VCENTER);
      _oDC.drawText(self.iCenterX, self.iLabel2Y, Gfx.FONT_SMALL, $.sMyViewLabel2 as String, Gfx.TEXT_JUSTIFY_CENTER|Gfx.TEXT_JUSTIFY_VCENTER);
      // ... value(s)
      _oDC.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);
      sValue = $.oMyData.fPositionHeading != null ? ($.oMyData.fPositionHeading as Float).format("%.6f") : self.NOVALUE_LEN3;
      _oDC.drawText(self.iCenterX, self.iValue1Y, Gfx.FONT_SMALL, sValue, Gfx.TEXT_JUSTIFY_CENTER|Gfx.TEXT_JUSTIFY_VCENTER);
    }
    else if($.iMyViewIndex == 7) {  // ... position: accuracy
      // ... label
      _oDC.setColor(Gfx.COLOR_BLUE, Gfx.COLOR_TRANSPARENT);
      if($.sMyViewLabel1 == null) {
        $.sMyViewLabel1 = Ui.loadResource(Rez.Strings.labelPosition) as String;
      }
      if($.sMyViewLabel2 == null) {
        $.sMyViewLabel2 = format("$1$ [$2$]", [Ui.loadResource(Rez.Strings.labelAccuracy), Ui.loadResource(Rez.Strings.unitPositionAccuracy)]);
      }
      _oDC.drawText(self.iCenterX, self.iLabel1Y, Gfx.FONT_SMALL, $.sMyViewLabel1 as String, Gfx.TEXT_JUSTIFY_CENTER|Gfx.TEXT_JUSTIFY_VCENTER);
      _oDC.drawText(self.iCenterX, self.iLabel2Y, Gfx.FONT_SMALL, $.sMyViewLabel2 as String, Gfx.TEXT_JUSTIFY_CENTER|Gfx.TEXT_JUSTIFY_VCENTER);
      // ... value(s)
      _oDC.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);
      sValue = $.oMyData.ePositionAccuracy != null ? ($.oMyData.ePositionAccuracy as Number).format("%d") : self.NOVALUE_LEN3;
      _oDC.drawText(self.iCenterX, self.iValue1Y, Gfx.FONT_SMALL, sValue, Gfx.TEXT_JUSTIFY_CENTER|Gfx.TEXT_JUSTIFY_VCENTER);
    }

    else if($.iMyViewIndex == 8) {  // ... sensor: altitude
      // ... label
      _oDC.setColor(Gfx.COLOR_BLUE, Gfx.COLOR_TRANSPARENT);
      if($.sMyViewLabel1 == null) {
        $.sMyViewLabel1 = Ui.loadResource(Rez.Strings.labelSensor) as String;
      }
      if($.sMyViewLabel2 == null) {
        $.sMyViewLabel2 = format("$1$ [$2$]", [Ui.loadResource(Rez.Strings.labelAltitude), Ui.loadResource(Rez.Strings.unitSensorAltitude)]);
      }
      _oDC.drawText(self.iCenterX, self.iLabel1Y, Gfx.FONT_SMALL, $.sMyViewLabel1 as String, Gfx.TEXT_JUSTIFY_CENTER|Gfx.TEXT_JUSTIFY_VCENTER);
      _oDC.drawText(self.iCenterX, self.iLabel2Y, Gfx.FONT_SMALL, $.sMyViewLabel2 as String, Gfx.TEXT_JUSTIFY_CENTER|Gfx.TEXT_JUSTIFY_VCENTER);
      // ... value(s)
      _oDC.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);
      sValue = $.oMyData.fSensorAltitude != null ? ($.oMyData.fSensorAltitude as Float).format("%.6f") : self.NOVALUE_LEN3;
      _oDC.drawText(self.iCenterX, self.iValue1Y, Gfx.FONT_SMALL, sValue, Gfx.TEXT_JUSTIFY_CENTER|Gfx.TEXT_JUSTIFY_VCENTER);
    }
    else if($.iMyViewIndex == 9) {  // ... sensor: speed
      // ... label
      _oDC.setColor(Gfx.COLOR_BLUE, Gfx.COLOR_TRANSPARENT);
      if($.sMyViewLabel1 == null) {
        $.sMyViewLabel1 = Ui.loadResource(Rez.Strings.labelSensor) as String;
      }
      if($.sMyViewLabel2 == null) {
        $.sMyViewLabel2 = format("$1$ [$2$]", [Ui.loadResource(Rez.Strings.labelSpeed), Ui.loadResource(Rez.Strings.unitSensorSpeed)]);
      }
      _oDC.drawText(self.iCenterX, self.iLabel1Y, Gfx.FONT_SMALL, $.sMyViewLabel1 as String, Gfx.TEXT_JUSTIFY_CENTER|Gfx.TEXT_JUSTIFY_VCENTER);
      _oDC.drawText(self.iCenterX, self.iLabel2Y, Gfx.FONT_SMALL, $.sMyViewLabel2 as String, Gfx.TEXT_JUSTIFY_CENTER|Gfx.TEXT_JUSTIFY_VCENTER);
      // ... value(s)
      _oDC.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);
      sValue = $.oMyData.fSensorSpeed != null ? ($.oMyData.fSensorSpeed as Float).format("%.6f") : self.NOVALUE_LEN3;
      _oDC.drawText(self.iCenterX, self.iValue1Y, Gfx.FONT_SMALL, sValue, Gfx.TEXT_JUSTIFY_CENTER|Gfx.TEXT_JUSTIFY_VCENTER);
    }
    else if($.iMyViewIndex == 10) {  // ... sensor: heading
      // ... label
      _oDC.setColor(Gfx.COLOR_BLUE, Gfx.COLOR_TRANSPARENT);
      if($.sMyViewLabel1 == null) {
        $.sMyViewLabel1 = Ui.loadResource(Rez.Strings.labelSensor) as String;
      }
      if($.sMyViewLabel2 == null) {
        $.sMyViewLabel2 = format("$1$ [$2$]", [Ui.loadResource(Rez.Strings.labelHeading), Ui.loadResource(Rez.Strings.unitSensorHeading)]);
      }
      _oDC.drawText(self.iCenterX, self.iLabel1Y, Gfx.FONT_SMALL, $.sMyViewLabel1 as String, Gfx.TEXT_JUSTIFY_CENTER|Gfx.TEXT_JUSTIFY_VCENTER);
      _oDC.drawText(self.iCenterX, self.iLabel2Y, Gfx.FONT_SMALL, $.sMyViewLabel2 as String, Gfx.TEXT_JUSTIFY_CENTER|Gfx.TEXT_JUSTIFY_VCENTER);
      // ... value(s)
      _oDC.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);
      sValue = $.oMyData.fSensorHeading != null ? ($.oMyData.fSensorHeading as Float).format("%.6f") : self.NOVALUE_LEN3;
      _oDC.drawText(self.iCenterX, self.iValue1Y, Gfx.FONT_SMALL, sValue, Gfx.TEXT_JUSTIFY_CENTER|Gfx.TEXT_JUSTIFY_VCENTER);
    }
    else if($.iMyViewIndex == 11) {  // ... sensor: pressure
      // ... label
      _oDC.setColor(Gfx.COLOR_BLUE, Gfx.COLOR_TRANSPARENT);
      if($.sMyViewLabel1 == null) {
        $.sMyViewLabel1 = Ui.loadResource(Rez.Strings.labelSensor) as String;
      }
      if($.sMyViewLabel2 == null) {
        $.sMyViewLabel2 = format("$1$ [$2$]", [Ui.loadResource(Rez.Strings.labelPressure), Ui.loadResource(Rez.Strings.unitSensorPressure)]);
      }
      _oDC.drawText(self.iCenterX, self.iLabel1Y, Gfx.FONT_SMALL, $.sMyViewLabel1 as String, Gfx.TEXT_JUSTIFY_CENTER|Gfx.TEXT_JUSTIFY_VCENTER);
      _oDC.drawText(self.iCenterX, self.iLabel2Y, Gfx.FONT_SMALL, $.sMyViewLabel2 as String, Gfx.TEXT_JUSTIFY_CENTER|Gfx.TEXT_JUSTIFY_VCENTER);
      // ... value(s)
      _oDC.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);
      sValue = $.oMyData.fSensorPressure != null ? ($.oMyData.fSensorPressure as Float).format("%.2f") : self.NOVALUE_LEN3;
      _oDC.drawText(self.iCenterX, self.iValue1Y, Gfx.FONT_SMALL, sValue, Gfx.TEXT_JUSTIFY_CENTER|Gfx.TEXT_JUSTIFY_VCENTER);
    }
    else if($.iMyViewIndex == 12) {  // ... sensor: acceleration
      // ... label
      _oDC.setColor(Gfx.COLOR_BLUE, Gfx.COLOR_TRANSPARENT);
      if($.sMyViewLabel1 == null) {
        $.sMyViewLabel1 = Ui.loadResource(Rez.Strings.labelSensor) as String;
      }
      if($.sMyViewLabel2 == null) {
        $.sMyViewLabel2 = format("$1$ [$2$]", [Ui.loadResource(Rez.Strings.labelAcceleration), Ui.loadResource(Rez.Strings.unitSensorAcceleration)]);
      }
      _oDC.drawText(self.iCenterX, self.iLabel1Y, Gfx.FONT_SMALL, $.sMyViewLabel1 as String, Gfx.TEXT_JUSTIFY_CENTER|Gfx.TEXT_JUSTIFY_VCENTER);
      _oDC.drawText(self.iCenterX, self.iLabel2Y, Gfx.FONT_SMALL, $.sMyViewLabel2 as String, Gfx.TEXT_JUSTIFY_CENTER|Gfx.TEXT_JUSTIFY_VCENTER);
      // ... value(s)
      _oDC.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);
      sValue = $.oMyData.iSensorAccelerationX != null ? ($.oMyData.iSensorAccelerationX as Number).format("%d") : self.NOVALUE_LEN3;
      _oDC.drawText(self.iCenterX, self.iValue1Y, Gfx.FONT_SMALL, sValue, Gfx.TEXT_JUSTIFY_CENTER|Gfx.TEXT_JUSTIFY_VCENTER);
      sValue = $.oMyData.iSensorAccelerationY != null ? ($.oMyData.iSensorAccelerationY as Number).format("%d") : self.NOVALUE_LEN3;
      _oDC.drawText(self.iCenterX, self.iValue2Y, Gfx.FONT_SMALL, sValue, Gfx.TEXT_JUSTIFY_CENTER|Gfx.TEXT_JUSTIFY_VCENTER);
      sValue = $.oMyData.iSensorAccelerationZ != null ? ($.oMyData.iSensorAccelerationZ as Number).format("%d") : self.NOVALUE_LEN3;
      _oDC.drawText(self.iCenterX, self.iValue3Y, Gfx.FONT_SMALL, sValue, Gfx.TEXT_JUSTIFY_CENTER|Gfx.TEXT_JUSTIFY_VCENTER);
    }
    else if($.iMyViewIndex == 13) {  // ... sensor: acceleration (high-definition)
      // ... label
      _oDC.setColor(Gfx.COLOR_BLUE, Gfx.COLOR_TRANSPARENT);
      if($.sMyViewLabel1 == null) {
        $.sMyViewLabel1 = Ui.loadResource(Rez.Strings.labelSensor) as String;
      }
      if($.sMyViewLabel2 == null) {
        $.sMyViewLabel2 = format("$1$ [$2$]", [Ui.loadResource(Rez.Strings.labelAcceleration_HD), Ui.loadResource(Rez.Strings.unitSensorAcceleration)]);
      }
      _oDC.drawText(self.iCenterX, self.iLabel1Y, Gfx.FONT_SMALL, $.sMyViewLabel1 as String, Gfx.TEXT_JUSTIFY_CENTER|Gfx.TEXT_JUSTIFY_VCENTER);
      _oDC.drawText(self.iCenterX, self.iLabel2Y, Gfx.FONT_SMALL, $.sMyViewLabel2 as String, Gfx.TEXT_JUSTIFY_CENTER|Gfx.TEXT_JUSTIFY_VCENTER);
      // ... value(s)
      _oDC.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);
      sValue = $.oMyData.aiSensorAccelerationX_HD != null ? ($.oMyData.aiSensorAccelerationX_HD as Array<Number>)[($.oMyData.aiSensorAccelerationX_HD as Array<Number>).size()-1].format("%d") : self.NOVALUE_LEN3;
      _oDC.drawText(self.iCenterX, self.iValue1Y, Gfx.FONT_SMALL, sValue, Gfx.TEXT_JUSTIFY_CENTER|Gfx.TEXT_JUSTIFY_VCENTER);
      sValue = $.oMyData.aiSensorAccelerationY_HD != null ? ($.oMyData.aiSensorAccelerationY_HD as Array<Number>)[($.oMyData.aiSensorAccelerationY_HD as Array<Number>).size()-1].format("%d") : self.NOVALUE_LEN3;
      _oDC.drawText(self.iCenterX, self.iValue2Y, Gfx.FONT_SMALL, sValue, Gfx.TEXT_JUSTIFY_CENTER|Gfx.TEXT_JUSTIFY_VCENTER);
      sValue = $.oMyData.aiSensorAccelerationZ_HD != null ? ($.oMyData.aiSensorAccelerationZ_HD as Array<Number>)[($.oMyData.aiSensorAccelerationZ_HD as Array<Number>).size()-1].format("%d") : self.NOVALUE_LEN3;
      _oDC.drawText(self.iCenterX, self.iValue3Y, Gfx.FONT_SMALL, sValue, Gfx.TEXT_JUSTIFY_CENTER|Gfx.TEXT_JUSTIFY_VCENTER);
    }
    else if($.iMyViewIndex == 14) {  // ... sensor: magnetometer
      // ... label
      _oDC.setColor(Gfx.COLOR_BLUE, Gfx.COLOR_TRANSPARENT);
      if($.sMyViewLabel1 == null) {
        $.sMyViewLabel1 = Ui.loadResource(Rez.Strings.labelSensor) as String;
      }
      if($.sMyViewLabel2 == null) {
        $.sMyViewLabel2 = format("$1$ [$2$]", [Ui.loadResource(Rez.Strings.labelMagnetometer), Ui.loadResource(Rez.Strings.unitSensorMagnetometer)]);
      }
      _oDC.drawText(self.iCenterX, self.iLabel1Y, Gfx.FONT_SMALL, $.sMyViewLabel1 as String, Gfx.TEXT_JUSTIFY_CENTER|Gfx.TEXT_JUSTIFY_VCENTER);
      _oDC.drawText(self.iCenterX, self.iLabel2Y, Gfx.FONT_SMALL, $.sMyViewLabel2 as String, Gfx.TEXT_JUSTIFY_CENTER|Gfx.TEXT_JUSTIFY_VCENTER);
      // ... value(s)
      _oDC.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);
      sValue = $.oMyData.iSensorMagnetometerX != null ? ($.oMyData.iSensorMagnetometerX as Number).format("%d") : self.NOVALUE_LEN3;
      _oDC.drawText(self.iCenterX, self.iValue1Y, Gfx.FONT_SMALL, sValue, Gfx.TEXT_JUSTIFY_CENTER|Gfx.TEXT_JUSTIFY_VCENTER);
      sValue = $.oMyData.iSensorMagnetometerY != null ? ($.oMyData.iSensorMagnetometerY as Number).format("%d") : self.NOVALUE_LEN3;
      _oDC.drawText(self.iCenterX, self.iValue2Y, Gfx.FONT_SMALL, sValue, Gfx.TEXT_JUSTIFY_CENTER|Gfx.TEXT_JUSTIFY_VCENTER);
      sValue = $.oMyData.iSensorMagnetometerZ != null ? ($.oMyData.iSensorMagnetometerZ as Number).format("%d") : self.NOVALUE_LEN3;
      _oDC.drawText(self.iCenterX, self.iValue3Y, Gfx.FONT_SMALL, sValue, Gfx.TEXT_JUSTIFY_CENTER|Gfx.TEXT_JUSTIFY_VCENTER);
    }
    else if($.iMyViewIndex == 15) {  // ... sensor: heartrate
      // ... label
      _oDC.setColor(Gfx.COLOR_BLUE, Gfx.COLOR_TRANSPARENT);
      if($.sMyViewLabel1 == null) {
        $.sMyViewLabel1 = Ui.loadResource(Rez.Strings.labelSensor) as String;
      }
      if($.sMyViewLabel2 == null) {
        $.sMyViewLabel2 = format("$1$ [$2$]", [Ui.loadResource(Rez.Strings.labelHeartrate), Ui.loadResource(Rez.Strings.unitSensorHeartrate)]);
      }
      _oDC.drawText(self.iCenterX, self.iLabel1Y, Gfx.FONT_SMALL, $.sMyViewLabel1 as String, Gfx.TEXT_JUSTIFY_CENTER|Gfx.TEXT_JUSTIFY_VCENTER);
      _oDC.drawText(self.iCenterX, self.iLabel2Y, Gfx.FONT_SMALL, $.sMyViewLabel2 as String, Gfx.TEXT_JUSTIFY_CENTER|Gfx.TEXT_JUSTIFY_VCENTER);
      // ... value(s)
      _oDC.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);
      sValue = $.oMyData.iSensorHeartrate != null ? ($.oMyData.iSensorHeartrate as Number).format("%d") : self.NOVALUE_LEN3;
      _oDC.drawText(self.iCenterX, self.iValue1Y, Gfx.FONT_SMALL, sValue, Gfx.TEXT_JUSTIFY_CENTER|Gfx.TEXT_JUSTIFY_VCENTER);
    }
    else if($.iMyViewIndex == 16) {  // ... sensor: cadence
      // ... label
      _oDC.setColor(Gfx.COLOR_BLUE, Gfx.COLOR_TRANSPARENT);
      if($.sMyViewLabel1 == null) {
        $.sMyViewLabel1 = Ui.loadResource(Rez.Strings.labelSensor) as String;
      }
      if($.sMyViewLabel2 == null) {
        $.sMyViewLabel2 = format("$1$ [$2$]", [Ui.loadResource(Rez.Strings.labelCadence), Ui.loadResource(Rez.Strings.unitSensorCadence)]);
      }
      _oDC.drawText(self.iCenterX, self.iLabel1Y, Gfx.FONT_SMALL, $.sMyViewLabel1 as String, Gfx.TEXT_JUSTIFY_CENTER|Gfx.TEXT_JUSTIFY_VCENTER);
      _oDC.drawText(self.iCenterX, self.iLabel2Y, Gfx.FONT_SMALL, $.sMyViewLabel2 as String, Gfx.TEXT_JUSTIFY_CENTER|Gfx.TEXT_JUSTIFY_VCENTER);
      // ... value(s)
      _oDC.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);
      sValue = $.oMyData.iSensorCadence != null ? ($.oMyData.iSensorCadence as Number).format("%d") : self.NOVALUE_LEN3;
      _oDC.drawText(self.iCenterX, self.iValue1Y, Gfx.FONT_SMALL, sValue, Gfx.TEXT_JUSTIFY_CENTER|Gfx.TEXT_JUSTIFY_VCENTER);
    }
    else if($.iMyViewIndex == 17) {  // ... sensor: power
      // ... label
      _oDC.setColor(Gfx.COLOR_BLUE, Gfx.COLOR_TRANSPARENT);
      if($.sMyViewLabel1 == null) {
        $.sMyViewLabel1 = Ui.loadResource(Rez.Strings.labelSensor) as String;
      }
      if($.sMyViewLabel2 == null) {
        $.sMyViewLabel2 = format("$1$ [$2$]", [Ui.loadResource(Rez.Strings.labelPower), Ui.loadResource(Rez.Strings.unitSensorPower)]);
      }
      _oDC.drawText(self.iCenterX, self.iLabel1Y, Gfx.FONT_SMALL, $.sMyViewLabel1 as String, Gfx.TEXT_JUSTIFY_CENTER|Gfx.TEXT_JUSTIFY_VCENTER);
      _oDC.drawText(self.iCenterX, self.iLabel2Y, Gfx.FONT_SMALL, $.sMyViewLabel2 as String, Gfx.TEXT_JUSTIFY_CENTER|Gfx.TEXT_JUSTIFY_VCENTER);
      // ... value(s)
      _oDC.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);
      sValue = $.oMyData.iSensorPower != null ? ($.oMyData.iSensorPower as Number).format("%d") : self.NOVALUE_LEN3;
      _oDC.drawText(self.iCenterX, self.iValue1Y, Gfx.FONT_SMALL, sValue, Gfx.TEXT_JUSTIFY_CENTER|Gfx.TEXT_JUSTIFY_VCENTER);
    }
    else if($.iMyViewIndex == 18) {  // ... sensor: temperature
      // ... label
      _oDC.setColor(Gfx.COLOR_BLUE, Gfx.COLOR_TRANSPARENT);
      if($.sMyViewLabel1 == null) {
        $.sMyViewLabel1 = Ui.loadResource(Rez.Strings.labelSensor) as String;
      }
      if($.sMyViewLabel2 == null) {
        $.sMyViewLabel2 = format("$1$ [$2$]", [Ui.loadResource(Rez.Strings.labelTemperature), Ui.loadResource(Rez.Strings.unitSensorTemperature)]);
      }
      _oDC.drawText(self.iCenterX, self.iLabel1Y, Gfx.FONT_SMALL, $.sMyViewLabel1 as String, Gfx.TEXT_JUSTIFY_CENTER|Gfx.TEXT_JUSTIFY_VCENTER);
      _oDC.drawText(self.iCenterX, self.iLabel2Y, Gfx.FONT_SMALL, $.sMyViewLabel2 as String, Gfx.TEXT_JUSTIFY_CENTER|Gfx.TEXT_JUSTIFY_VCENTER);
      // ... value(s)
      _oDC.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);
      sValue = $.oMyData.fSensorTemperature != null ? ($.oMyData.fSensorTemperature as Float).format("%.2f") : self.NOVALUE_LEN3;
      _oDC.drawText(self.iCenterX, self.iValue1Y, Gfx.FONT_SMALL, sValue, Gfx.TEXT_JUSTIFY_CENTER|Gfx.TEXT_JUSTIFY_VCENTER);
    }

    else if($.iMyViewIndex == 19) {  // ... activity: location
      // ... label
      _oDC.setColor(Gfx.COLOR_BLUE, Gfx.COLOR_TRANSPARENT);
      if($.sMyViewLabel1 == null) {
        $.sMyViewLabel1 = Ui.loadResource(Rez.Strings.labelActivity) as String;
      }
      if($.sMyViewLabel2 == null) {
        $.sMyViewLabel2 = format("$1$ [$2$]", [Ui.loadResource(Rez.Strings.labelLocation), Ui.loadResource(Rez.Strings.unitActivityLocation)]);
      }
      _oDC.drawText(self.iCenterX, self.iLabel1Y, Gfx.FONT_SMALL, $.sMyViewLabel1 as String, Gfx.TEXT_JUSTIFY_CENTER|Gfx.TEXT_JUSTIFY_VCENTER);
      _oDC.drawText(self.iCenterX, self.iLabel2Y, Gfx.FONT_SMALL, $.sMyViewLabel2 as String, Gfx.TEXT_JUSTIFY_CENTER|Gfx.TEXT_JUSTIFY_VCENTER);
      // ... value(s)
      _oDC.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);
      sValue = $.oMyData.dActivityLatitude != null ? ($.oMyData.dActivityLatitude as Double).format("%.6f") : self.NOVALUE_LEN3;
      _oDC.drawText(self.iCenterX, self.iValue1Y, Gfx.FONT_SMALL, sValue, Gfx.TEXT_JUSTIFY_CENTER|Gfx.TEXT_JUSTIFY_VCENTER);
      sValue = $.oMyData.dActivityLongitude != null ? ($.oMyData.dActivityLongitude as Double).format("%.6f") : self.NOVALUE_LEN3;
      _oDC.drawText(self.iCenterX, self.iValue2Y, Gfx.FONT_SMALL, sValue, Gfx.TEXT_JUSTIFY_CENTER|Gfx.TEXT_JUSTIFY_VCENTER);
    }
    else if($.iMyViewIndex == 20) {  // ... activity: altitude
      // ... label
      _oDC.setColor(Gfx.COLOR_BLUE, Gfx.COLOR_TRANSPARENT);
      if($.sMyViewLabel1 == null) {
        $.sMyViewLabel1 = Ui.loadResource(Rez.Strings.labelActivity) as String;
      }
      if($.sMyViewLabel2 == null) {
        $.sMyViewLabel2 = format("$1$ [$2$]", [Ui.loadResource(Rez.Strings.labelAltitude), Ui.loadResource(Rez.Strings.unitActivityAltitude)]);
      }
      _oDC.drawText(self.iCenterX, self.iLabel1Y, Gfx.FONT_SMALL, $.sMyViewLabel1 as String, Gfx.TEXT_JUSTIFY_CENTER|Gfx.TEXT_JUSTIFY_VCENTER);
      _oDC.drawText(self.iCenterX, self.iLabel2Y, Gfx.FONT_SMALL, $.sMyViewLabel2 as String, Gfx.TEXT_JUSTIFY_CENTER|Gfx.TEXT_JUSTIFY_VCENTER);
      // ... value(s)
      _oDC.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);
      sValue = $.oMyData.fActivityAltitude != null ? ($.oMyData.fActivityAltitude as Float).format("%.6f") : self.NOVALUE_LEN3;
      _oDC.drawText(self.iCenterX, self.iValue1Y, Gfx.FONT_SMALL, sValue, Gfx.TEXT_JUSTIFY_CENTER|Gfx.TEXT_JUSTIFY_VCENTER);
    }
    else if($.iMyViewIndex == 21) {  // ... activity: speed
      // ... label
      _oDC.setColor(Gfx.COLOR_BLUE, Gfx.COLOR_TRANSPARENT);
      if($.sMyViewLabel1 == null) {
        $.sMyViewLabel1 = Ui.loadResource(Rez.Strings.labelActivity) as String;
      }
      if($.sMyViewLabel2 == null) {
        $.sMyViewLabel2 = format("$1$ [$2$]", [Ui.loadResource(Rez.Strings.labelSpeed), Ui.loadResource(Rez.Strings.unitActivitySpeed)]);
      }
      _oDC.drawText(self.iCenterX, self.iLabel1Y, Gfx.FONT_SMALL, $.sMyViewLabel1 as String, Gfx.TEXT_JUSTIFY_CENTER|Gfx.TEXT_JUSTIFY_VCENTER);
      _oDC.drawText(self.iCenterX, self.iLabel2Y, Gfx.FONT_SMALL, $.sMyViewLabel2 as String, Gfx.TEXT_JUSTIFY_CENTER|Gfx.TEXT_JUSTIFY_VCENTER);
      // ... value(s)
      _oDC.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);
      sValue = $.oMyData.fActivitySpeed != null ? ($.oMyData.fActivitySpeed as Float).format("%.6f") : self.NOVALUE_LEN3;
      _oDC.drawText(self.iCenterX, self.iValue1Y, Gfx.FONT_SMALL, sValue, Gfx.TEXT_JUSTIFY_CENTER|Gfx.TEXT_JUSTIFY_VCENTER);
    }
    else if($.iMyViewIndex == 22) {  // ... activity: heading
      // ... label
      _oDC.setColor(Gfx.COLOR_BLUE, Gfx.COLOR_TRANSPARENT);
      if($.sMyViewLabel1 == null) {
        $.sMyViewLabel1 = Ui.loadResource(Rez.Strings.labelActivity) as String;
      }
      if($.sMyViewLabel2 == null) {
        $.sMyViewLabel2 = format("$1$ [$2$]", [Ui.loadResource(Rez.Strings.labelHeading), Ui.loadResource(Rez.Strings.unitActivityHeading)]);
      }
      _oDC.drawText(self.iCenterX, self.iLabel1Y, Gfx.FONT_SMALL, $.sMyViewLabel1 as String, Gfx.TEXT_JUSTIFY_CENTER|Gfx.TEXT_JUSTIFY_VCENTER);
      _oDC.drawText(self.iCenterX, self.iLabel2Y, Gfx.FONT_SMALL, $.sMyViewLabel2 as String, Gfx.TEXT_JUSTIFY_CENTER|Gfx.TEXT_JUSTIFY_VCENTER);
      // ... value(s)
      _oDC.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);
      sValue = $.oMyData.fActivityHeading != null ? ($.oMyData.fActivityHeading as Float).format("%.6f") : self.NOVALUE_LEN3;
      _oDC.drawText(self.iCenterX, self.iValue1Y, Gfx.FONT_SMALL, sValue, Gfx.TEXT_JUSTIFY_CENTER|Gfx.TEXT_JUSTIFY_VCENTER);
    }
    else if($.iMyViewIndex == 23) {  // ... activity: accuracy
      // ... label
      _oDC.setColor(Gfx.COLOR_BLUE, Gfx.COLOR_TRANSPARENT);
      if($.sMyViewLabel1 == null) {
        $.sMyViewLabel1 = Ui.loadResource(Rez.Strings.labelActivity) as String;
      }
      if($.sMyViewLabel2 == null) {
        $.sMyViewLabel2 = format("$1$ [$2$]", [Ui.loadResource(Rez.Strings.labelAccuracy), Ui.loadResource(Rez.Strings.unitActivityAccuracy)]);
      }
      _oDC.drawText(self.iCenterX, self.iLabel1Y, Gfx.FONT_SMALL, $.sMyViewLabel1 as String, Gfx.TEXT_JUSTIFY_CENTER|Gfx.TEXT_JUSTIFY_VCENTER);
      _oDC.drawText(self.iCenterX, self.iLabel2Y, Gfx.FONT_SMALL, $.sMyViewLabel2 as String, Gfx.TEXT_JUSTIFY_CENTER|Gfx.TEXT_JUSTIFY_VCENTER);
      // ... value(s)
      _oDC.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);
      sValue = $.oMyData.eActivityAccuracy != null ? ($.oMyData.eActivityAccuracy as Number).format("%d") : self.NOVALUE_LEN3;
      _oDC.drawText(self.iCenterX, self.iValue1Y, Gfx.FONT_SMALL, sValue, Gfx.TEXT_JUSTIFY_CENTER|Gfx.TEXT_JUSTIFY_VCENTER);
    }
    else if($.iMyViewIndex == 24) {  // ... activity: pressure
      // ... label
      _oDC.setColor(Gfx.COLOR_BLUE, Gfx.COLOR_TRANSPARENT);
      if($.sMyViewLabel1 == null) {
        $.sMyViewLabel1 = Ui.loadResource(Rez.Strings.labelActivity) as String;
      }
      if($.sMyViewLabel2 == null) {
        $.sMyViewLabel2 = format("$1$ [$2$]", [Ui.loadResource(Rez.Strings.labelPressure), Ui.loadResource(Rez.Strings.unitActivityPressure)]);
      }
      _oDC.drawText(self.iCenterX, self.iLabel1Y, Gfx.FONT_SMALL, $.sMyViewLabel1 as String, Gfx.TEXT_JUSTIFY_CENTER|Gfx.TEXT_JUSTIFY_VCENTER);
      _oDC.drawText(self.iCenterX, self.iLabel2Y, Gfx.FONT_SMALL, $.sMyViewLabel2 as String, Gfx.TEXT_JUSTIFY_CENTER|Gfx.TEXT_JUSTIFY_VCENTER);
      // ... value(s)
      _oDC.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);
      sValue = $.oMyData.fActivityPressureRaw != null ? ($.oMyData.fActivityPressureRaw as Float).format("%.2f") : self.NOVALUE_LEN3;
      _oDC.drawText(self.iCenterX, self.iValue1Y, Gfx.FONT_SMALL, sValue, Gfx.TEXT_JUSTIFY_CENTER|Gfx.TEXT_JUSTIFY_VCENTER);
      sValue = $.oMyData.fActivityPressureAmbient != null ? ($.oMyData.fActivityPressureAmbient as Float).format("%.2f") : self.NOVALUE_LEN3;
      _oDC.drawText(self.iCenterX, self.iValue2Y, Gfx.FONT_SMALL, sValue, Gfx.TEXT_JUSTIFY_CENTER|Gfx.TEXT_JUSTIFY_VCENTER);
      sValue = $.oMyData.fActivityPressureMean != null ? ($.oMyData.fActivityPressureMean as Float).format("%.2f") : self.NOVALUE_LEN3;
      _oDC.drawText(self.iCenterX, self.iValue3Y, Gfx.FONT_SMALL, sValue, Gfx.TEXT_JUSTIFY_CENTER|Gfx.TEXT_JUSTIFY_VCENTER);
    }
    else if($.iMyViewIndex == 25) {  // ... activity: heartrate
      // ... label
      _oDC.setColor(Gfx.COLOR_BLUE, Gfx.COLOR_TRANSPARENT);
      if($.sMyViewLabel1 == null) {
        $.sMyViewLabel1 = Ui.loadResource(Rez.Strings.labelActivity) as String;
      }
      if($.sMyViewLabel2 == null) {
        $.sMyViewLabel2 = format("$1$ [$2$]", [Ui.loadResource(Rez.Strings.labelHeartrate), Ui.loadResource(Rez.Strings.unitActivityHeartrate)]);
      }
      _oDC.drawText(self.iCenterX, self.iLabel1Y, Gfx.FONT_SMALL, $.sMyViewLabel1 as String, Gfx.TEXT_JUSTIFY_CENTER|Gfx.TEXT_JUSTIFY_VCENTER);
      _oDC.drawText(self.iCenterX, self.iLabel2Y, Gfx.FONT_SMALL, $.sMyViewLabel2 as String, Gfx.TEXT_JUSTIFY_CENTER|Gfx.TEXT_JUSTIFY_VCENTER);
      // ... value(s)
      _oDC.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);
      sValue = $.oMyData.iActivityHeartrate != null ? ($.oMyData.iActivityHeartrate as Number).format("%d") : self.NOVALUE_LEN3;
      _oDC.drawText(self.iCenterX, self.iValue1Y, Gfx.FONT_SMALL, sValue, Gfx.TEXT_JUSTIFY_CENTER|Gfx.TEXT_JUSTIFY_VCENTER);
    }
    else if($.iMyViewIndex == 26) {  // ... activity: cadence
      // ... label
      _oDC.setColor(Gfx.COLOR_BLUE, Gfx.COLOR_TRANSPARENT);
      if($.sMyViewLabel1 == null) {
        $.sMyViewLabel1 = Ui.loadResource(Rez.Strings.labelActivity) as String;
      }
      if($.sMyViewLabel2 == null) {
        $.sMyViewLabel2 = format("$1$ [$2$]", [Ui.loadResource(Rez.Strings.labelCadence), Ui.loadResource(Rez.Strings.unitActivityCadence)]);
      }
      _oDC.drawText(self.iCenterX, self.iLabel1Y, Gfx.FONT_SMALL, $.sMyViewLabel1 as String, Gfx.TEXT_JUSTIFY_CENTER|Gfx.TEXT_JUSTIFY_VCENTER);
      _oDC.drawText(self.iCenterX, self.iLabel2Y, Gfx.FONT_SMALL, $.sMyViewLabel2 as String, Gfx.TEXT_JUSTIFY_CENTER|Gfx.TEXT_JUSTIFY_VCENTER);
      // ... value(s)
      _oDC.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);
      sValue = $.oMyData.iActivityCadence != null ? ($.oMyData.iActivityCadence as Number).format("%d") : self.NOVALUE_LEN3;
      _oDC.drawText(self.iCenterX, self.iValue1Y, Gfx.FONT_SMALL, sValue, Gfx.TEXT_JUSTIFY_CENTER|Gfx.TEXT_JUSTIFY_VCENTER);
    }
    else if($.iMyViewIndex == 27) {  // ... activity: power
      // ... label
      _oDC.setColor(Gfx.COLOR_BLUE, Gfx.COLOR_TRANSPARENT);
      if($.sMyViewLabel1 == null) {
        $.sMyViewLabel1 = Ui.loadResource(Rez.Strings.labelActivity) as String;
      }
      if($.sMyViewLabel2 == null) {
        $.sMyViewLabel2 = format("$1$ [$2$]", [Ui.loadResource(Rez.Strings.labelPower), Ui.loadResource(Rez.Strings.unitActivityPower)]);
      }
      _oDC.drawText(self.iCenterX, self.iLabel1Y, Gfx.FONT_SMALL, $.sMyViewLabel1 as String, Gfx.TEXT_JUSTIFY_CENTER|Gfx.TEXT_JUSTIFY_VCENTER);
      _oDC.drawText(self.iCenterX, self.iLabel2Y, Gfx.FONT_SMALL, $.sMyViewLabel2 as String, Gfx.TEXT_JUSTIFY_CENTER|Gfx.TEXT_JUSTIFY_VCENTER);
      // ... value(s)
      _oDC.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);
      sValue = $.oMyData.iActivityPower != null ? ($.oMyData.iActivityPower as Number).format("%d") : self.NOVALUE_LEN3;
      _oDC.drawText(self.iCenterX, self.iValue1Y, Gfx.FONT_SMALL, sValue, Gfx.TEXT_JUSTIFY_CENTER|Gfx.TEXT_JUSTIFY_VCENTER);
    }

  }

}

class MyViewDelegate extends Ui.BehaviorDelegate {

  //
  // FUNCTIONS: Ui.BehaviorDelegate (override/implement)
  //

  function initialize() {
    BehaviorDelegate.initialize();
  }

  function onMenu() {
    //Sys.println("DEBUG: MyViewDelegate.onMenu()");
    if($.oMyActivitySession == null) {
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
    //Sys.println("DEBUG: MyViewDelegate.onSelect()");
    if($.oMyActivitySession == null) {
      (App.getApp() as MyApp).initActivity();
      ($.oMyActivitySession as ActivityRecording.Session).start();
      if(Attention has :playTone) {
        Attention.playTone(Attention.TONE_START);
      }
    }
    else {
      ($.oMyActivitySession as ActivityRecording.Session).stop();
      ($.oMyActivitySession as ActivityRecording.Session).save();
      (App.getApp() as MyApp).resetActivity();
      if(Attention has :playTone) {
        Attention.playTone(Attention.TONE_STOP);
      }
    }
    return true;
  }

  function onBack() {
    //Sys.println("DEBUG: MyViewDelegate.onBack()");
    if($.oMyActivitySession != null) {
      ($.oMyActivitySession as ActivityRecording.Session).addLap();
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

  function switchView(_iOffset as Number) as Void {
    if(_iOffset == 0) { return; }
    var iViewIndex_next = $.iMyViewIndex;
    while(true) {
      iViewIndex_next += _iOffset;
      while(iViewIndex_next < 0) {
        iViewIndex_next += 28;
      }
      while(iViewIndex_next >= 28) {
        iViewIndex_next -= 28;
      }

      // ... time
      if(iViewIndex_next == 0) {
        break;
      }

      // ... system inputs
      else if(iViewIndex_next == 1 and $.oMySettings.bSystemBattery) { break; }
      else if(iViewIndex_next == 2 and $.oMySettings.bSystemMemory) { break; }

      // ... position inputs
      else if(iViewIndex_next == 3 and $.oMySettings.bPositionLocation) { break; }
      else if(iViewIndex_next == 4 and $.oMySettings.bPositionAltitude) { break; }
      else if(iViewIndex_next == 5 and $.oMySettings.bPositionSpeed) { break; }
      else if(iViewIndex_next == 6 and $.oMySettings.bPositionHeading) { break; }
      else if(iViewIndex_next == 7 and $.oMySettings.bPositionAccuracy) { break; }

      // ... sensor inputs
      else if(iViewIndex_next == 8 and $.oMySettings.bSensorAltitude) { break; }
      else if(iViewIndex_next == 9 and $.oMySettings.bSensorSpeed) { break; }
      else if(iViewIndex_next == 10 and $.oMySettings.bSensorHeading) { break; }
      else if(iViewIndex_next == 11 and $.oMySettings.bSensorPressure) { break; }
      else if(iViewIndex_next == 12 and $.oMySettings.bSensorAcceleration) { break; }
      else if(iViewIndex_next == 13 and $.oMySettings.bSensorAcceleration_HD) { break; }
      else if(iViewIndex_next == 14 and $.oMySettings.bSensorMagnetometer) { break; }
      else if(iViewIndex_next == 15 and $.oMySettings.bSensorHeartrate) { break; }
      else if(iViewIndex_next == 16 and $.oMySettings.bSensorCadence) { break; }
      else if(iViewIndex_next == 17 and $.oMySettings.bSensorPower) { break; }
      else if(iViewIndex_next == 18 and $.oMySettings.bSensorTemperature) { break; }

      // ... activity inputs
      else if(iViewIndex_next == 19 and $.oMySettings.bActivityLocation) { break; }
      else if(iViewIndex_next == 20 and $.oMySettings.bActivityAltitude) { break; }
      else if(iViewIndex_next == 21 and $.oMySettings.bActivitySpeed) { break; }
      else if(iViewIndex_next == 22 and $.oMySettings.bActivityHeading) { break; }
      else if(iViewIndex_next == 23 and $.oMySettings.bActivityAccuracy) { break; }
      else if(iViewIndex_next == 24 and $.oMySettings.bActivityPressure) { break; }
      else if(iViewIndex_next == 25 and $.oMySettings.bActivityHeartrate) { break; }
      else if(iViewIndex_next == 26 and $.oMySettings.bActivityCadence) { break; }
      else if(iViewIndex_next == 27 and $.oMySettings.bActivityPower) { break; }
    }
    if(iViewIndex_next != $.iMyViewIndex) {
      $.iMyViewIndex = iViewIndex_next;
      $.sMyViewLabel1 = null;
      $.sMyViewLabel2 = null;
    }
  }

}
