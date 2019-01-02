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

using Toybox.System as Sys;
using Toybox.WatchUi as Ui;

// Menu: resources/menus/menuSettingsSensor.xml

class MenuDelegateSettingsSensor extends Ui.MenuInputDelegate {

  //
  // FUNCTIONS: Ui.MenuInputDelegate (override/implement)
  //

  function initialize() {
    MenuInputDelegate.initialize();
  }

  function onMenuItem(item) {
    if (item == :menuSettingsAltitude) {
      //Sys.println("DEBUG: MenuDelegateSettings.onMenuItem(:menuSettingsAltitude)");
      Ui.pushView(new PickerGenericOnOff("userSensorAltitude", Ui.loadResource(Rez.Strings.labelAltitude)), new PickerDelegateGenericOnOff("userSensorAltitude"), Ui.SLIDE_IMMEDIATE);
    }
    else if (item == :menuSettingsSpeed) {
      //Sys.println("DEBUG: MenuDelegateSettings.onMenuItem(:menuSettingsSpeed)");
      Ui.pushView(new PickerGenericOnOff("userSensorSpeed", Ui.loadResource(Rez.Strings.labelSpeed)), new PickerDelegateGenericOnOff("userSensorSpeed"), Ui.SLIDE_IMMEDIATE);
    }
    else if (item == :menuSettingsHeading) {
      //Sys.println("DEBUG: MenuDelegateSettings.onMenuItem(:menuSettingsHeading)");
      Ui.pushView(new PickerGenericOnOff("userSensorHeading", Ui.loadResource(Rez.Strings.labelHeading)), new PickerDelegateGenericOnOff("userSensorHeading"), Ui.SLIDE_IMMEDIATE);
    }
    else if (item == :menuSettingsPressure) {
      //Sys.println("DEBUG: MenuDelegateSettings.onMenuItem(:menuSettingsPressure)");
      Ui.pushView(new PickerGenericOnOff("userSensorPressure", Ui.loadResource(Rez.Strings.labelPressure)), new PickerDelegateGenericOnOff("userSensorPressure"), Ui.SLIDE_IMMEDIATE);
    }
    else if (item == :menuSettingsAcceleration) {
      //Sys.println("DEBUG: MenuDelegateSettings.onMenuItem(:menuSettingsAcceleration)");
      Ui.pushView(new PickerGenericOnOff("userSensorAcceleration", Ui.loadResource(Rez.Strings.labelAcceleration)), new PickerDelegateGenericOnOff("userSensorAcceleration"), Ui.SLIDE_IMMEDIATE);
    }
    else if (item == :menuSettingsAcceleration_HD) {
      //Sys.println("DEBUG: MenuDelegateSettings.onMenuItem(:menuSettingsAcceleration_HD)");
      Ui.pushView(new PickerGenericOnOff("userSensorAcceleration_HD", Ui.loadResource(Rez.Strings.labelAcceleration_HD)), new PickerDelegateGenericOnOff("userSensorAcceleration_HD"), Ui.SLIDE_IMMEDIATE);
    }
    else if (item == :menuSettingsMagnetometer) {
      //Sys.println("DEBUG: MenuDelegateSettings.onMenuItem(:menuSettingsMagnetometer)");
      Ui.pushView(new PickerGenericOnOff("userSensorMagnetometer", Ui.loadResource(Rez.Strings.labelMagnetometer)), new PickerDelegateGenericOnOff("userSensorMagnetometer"), Ui.SLIDE_IMMEDIATE);
    }
    else if (item == :menuSettingsHeartrate) {
      //Sys.println("DEBUG: MenuDelegateSettings.onMenuItem(:menuSettingsHeartrate)");
      Ui.pushView(new PickerGenericOnOff("userSensorHeartrate", Ui.loadResource(Rez.Strings.labelHeartrate)), new PickerDelegateGenericOnOff("userSensorHeartrate"), Ui.SLIDE_IMMEDIATE);
    }
    else if (item == :menuSettingsCadence) {
      //Sys.println("DEBUG: MenuDelegateSettings.onMenuItem(:menuSettingsCadence)");
      Ui.pushView(new PickerGenericOnOff("userSensorCadence", Ui.loadResource(Rez.Strings.labelCadence)), new PickerDelegateGenericOnOff("userSensorCadence"), Ui.SLIDE_IMMEDIATE);
    }
    else if (item == :menuSettingsPower) {
      //Sys.println("DEBUG: MenuDelegateSettings.onMenuItem(:menuSettingsPower)");
      Ui.pushView(new PickerGenericOnOff("userSensorPower", Ui.loadResource(Rez.Strings.labelPower)), new PickerDelegateGenericOnOff("userSensorPower"), Ui.SLIDE_IMMEDIATE);
    }
    else if (item == :menuSettingsTemperature) {
      //Sys.println("DEBUG: MenuDelegateSettings.onMenuItem(:menuSettingsTemperature)");
      Ui.pushView(new PickerGenericOnOff("userSensorTemperature", Ui.loadResource(Rez.Strings.labelTemperature)), new PickerDelegateGenericOnOff("userSensorTemperature"), Ui.SLIDE_IMMEDIATE);
    }
  }

}
