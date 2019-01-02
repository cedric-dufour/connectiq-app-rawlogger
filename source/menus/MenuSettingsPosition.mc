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

// Menu: resources/menus/menuSettingsPosition.xml

class MenuDelegateSettingsPosition extends Ui.MenuInputDelegate {

  //
  // FUNCTIONS: Ui.MenuInputDelegate (override/implement)
  //

  function initialize() {
    MenuInputDelegate.initialize();
  }

  function onMenuItem(item) {
    if (item == :menuSettingsLocation) {
      //Sys.println("DEBUG: MenuDelegateSettings.onMenuItem(:menuSettingsLocation)");
      Ui.pushView(new PickerGenericOnOff("userPositionLocation", Ui.loadResource(Rez.Strings.labelLocation)), new PickerDelegateGenericOnOff("userPositionLocation"), Ui.SLIDE_IMMEDIATE);
    }
    else if (item == :menuSettingsAltitude) {
      //Sys.println("DEBUG: MenuDelegateSettings.onMenuItem(:menuSettingsAltitude)");
      Ui.pushView(new PickerGenericOnOff("userPositionAltitude", Ui.loadResource(Rez.Strings.labelAltitude)), new PickerDelegateGenericOnOff("userPositionAltitude"), Ui.SLIDE_IMMEDIATE);
    }
    else if (item == :menuSettingsSpeed) {
      //Sys.println("DEBUG: MenuDelegateSettings.onMenuItem(:menuSettingsSpeed)");
      Ui.pushView(new PickerGenericOnOff("userPositionSpeed", Ui.loadResource(Rez.Strings.labelSpeed)), new PickerDelegateGenericOnOff("userPositionSpeed"), Ui.SLIDE_IMMEDIATE);
    }
    else if (item == :menuSettingsHeading) {
      //Sys.println("DEBUG: MenuDelegateSettings.onMenuItem(:menuSettingsHeading)");
      Ui.pushView(new PickerGenericOnOff("userPositionHeading", Ui.loadResource(Rez.Strings.labelHeading)), new PickerDelegateGenericOnOff("userPositionHeading"), Ui.SLIDE_IMMEDIATE);
    }
    else if (item == :menuSettingsAccuracy) {
      //Sys.println("DEBUG: MenuDelegateSettings.onMenuItem(:menuSettingsAccuracy)");
      Ui.pushView(new PickerGenericOnOff("userPositionAccuracy", Ui.loadResource(Rez.Strings.labelAccuracy)), new PickerDelegateGenericOnOff("userPositionAccuracy"), Ui.SLIDE_IMMEDIATE);
    }
  }

}
