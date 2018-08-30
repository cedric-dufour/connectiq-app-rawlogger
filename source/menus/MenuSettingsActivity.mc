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

using Toybox.System as Sys;
using Toybox.WatchUi as Ui;

// Menu: resources/menus/menuSettingsActivity.xml

class MenuDelegateSettingsActivity extends Ui.MenuInputDelegate {

  //
  // FUNCTIONS: Ui.MenuInputDelegate (override/implement)
  //

  function initialize() {
    MenuInputDelegate.initialize();
  }

  function onMenuItem(item) {
    if (item == :menuSettingsLocation) {
      //Sys.println("DEBUG: MenuDelegateSettings.onMenuItem(:menuSettingsLocation)");
      Ui.pushView(new PickerGenericOnOff("userActivityLocation", Ui.loadResource(Rez.Strings.labelLocation)), new PickerDelegateGenericOnOff("userActivityLocation"), Ui.SLIDE_IMMEDIATE);
    }
    else if (item == :menuSettingsAltitude) {
      //Sys.println("DEBUG: MenuDelegateSettings.onMenuItem(:menuSettingsAltitude)");
      Ui.pushView(new PickerGenericOnOff("userActivityAltitude", Ui.loadResource(Rez.Strings.labelAltitude)), new PickerDelegateGenericOnOff("userActivityAltitude"), Ui.SLIDE_IMMEDIATE);
    }
    else if (item == :menuSettingsSpeed) {
      //Sys.println("DEBUG: MenuDelegateSettings.onMenuItem(:menuSettingsSpeed)");
      Ui.pushView(new PickerGenericOnOff("userActivitySpeed", Ui.loadResource(Rez.Strings.labelSpeed)), new PickerDelegateGenericOnOff("userActivitySpeed"), Ui.SLIDE_IMMEDIATE);
    }
    else if (item == :menuSettingsHeading) {
      //Sys.println("DEBUG: MenuDelegateSettings.onMenuItem(:menuSettingsHeading)");
      Ui.pushView(new PickerGenericOnOff("userActivityHeading", Ui.loadResource(Rez.Strings.labelHeading)), new PickerDelegateGenericOnOff("userActivityHeading"), Ui.SLIDE_IMMEDIATE);
    }
    else if (item == :menuSettingsAccuracy) {
      //Sys.println("DEBUG: MenuDelegateSettings.onMenuItem(:menuSettingsAccuracy)");
      Ui.pushView(new PickerGenericOnOff("userActivityAccuracy", Ui.loadResource(Rez.Strings.labelAccuracy)), new PickerDelegateGenericOnOff("userActivityAccuracy"), Ui.SLIDE_IMMEDIATE);
    }
    else if (item == :menuSettingsPressure) {
      //Sys.println("DEBUG: MenuDelegateSettings.onMenuItem(:menuSettingsPressure)");
      Ui.pushView(new PickerGenericOnOff("userActivityPressure", Ui.loadResource(Rez.Strings.labelPressure)), new PickerDelegateGenericOnOff("userActivityPressure"), Ui.SLIDE_IMMEDIATE);
    }
    else if (item == :menuSettingsHeartrate) {
      //Sys.println("DEBUG: MenuDelegateSettings.onMenuItem(:menuSettingsHeartrate)");
      Ui.pushView(new PickerGenericOnOff("userActivityHeartrate", Ui.loadResource(Rez.Strings.labelHeartrate)), new PickerDelegateGenericOnOff("userActivityHeartrate"), Ui.SLIDE_IMMEDIATE);
    }
    else if (item == :menuSettingsCadence) {
      //Sys.println("DEBUG: MenuDelegateSettings.onMenuItem(:menuSettingsCadence)");
      Ui.pushView(new PickerGenericOnOff("userActivityCadence", Ui.loadResource(Rez.Strings.labelCadence)), new PickerDelegateGenericOnOff("userActivityCadence"), Ui.SLIDE_IMMEDIATE);
    }
    else if (item == :menuSettingsPower) {
      //Sys.println("DEBUG: MenuDelegateSettings.onMenuItem(:menuSettingsPower)");
      Ui.pushView(new PickerGenericOnOff("userActivityPower", Ui.loadResource(Rez.Strings.labelPower)), new PickerDelegateGenericOnOff("userActivityPower"), Ui.SLIDE_IMMEDIATE);
    }
  }

}
