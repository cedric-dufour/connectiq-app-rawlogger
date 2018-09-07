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

// Menu: resources/menus/menuSettingsSystem.xml

class MenuDelegateSettingsSystem extends Ui.MenuInputDelegate {

  //
  // FUNCTIONS: Ui.MenuInputDelegate (override/implement)
  //

  function initialize() {
    MenuInputDelegate.initialize();
  }

  function onMenuItem(item) {
    if (item == :menuSettingsBattery) {
      //Sys.println("DEBUG: MenuDelegateSettings.onMenuItem(:menuSettingsBattery)");
      Ui.pushView(new PickerGenericOnOff("userSystemBattery", Ui.loadResource(Rez.Strings.labelBattery)), new PickerDelegateGenericOnOff("userSystemBattery"), Ui.SLIDE_IMMEDIATE);
    }
    else if (item == :menuSettingsMemory) {
      //Sys.println("DEBUG: MenuDelegateSettings.onMenuItem(:menuSettingsMemory)");
      Ui.pushView(new PickerGenericOnOff("userSystemMemory", Ui.loadResource(Rez.Strings.labelMemory)), new PickerDelegateGenericOnOff("userSystemMemory"), Ui.SLIDE_IMMEDIATE);
    }
  }

}
