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

// Menu: resources/menus/menuSettings.xml

class MenuDelegateSettings extends Ui.MenuInputDelegate {

  //
  // FUNCTIONS: Ui.MenuInputDelegate (override/implement)
  //

  function initialize() {
    MenuInputDelegate.initialize();
  }

  function onMenuItem(item) {
    if (item == :menuSettingsSystem) {
      //Sys.println("DEBUG: MenuDelegateSettings.onMenuItem(:menuSettingsSystem)");
      Ui.pushView(new Rez.Menus.menuSettingsSystem(), new MenuDelegateSettingsSystem(), Ui.SLIDE_IMMEDIATE);
    }
    else if (item == :menuSettingsPosition) {
      //Sys.println("DEBUG: MenuDelegateSettings.onMenuItem(:menuSettingsPosition)");
      Ui.pushView(new Rez.Menus.menuSettingsPosition(), new MenuDelegateSettingsPosition(), Ui.SLIDE_IMMEDIATE);
    }
    else if (item == :menuSettingsSensor) {
      //Sys.println("DEBUG: MenuDelegateSettings.onMenuItem(:menuSettingsSensor)");
      Ui.pushView(new Rez.Menus.menuSettingsSensor(), new MenuDelegateSettingsSensor(), Ui.SLIDE_IMMEDIATE);
    }
    else if (item == :menuSettingsActivity) {
      //Sys.println("DEBUG: MenuDelegateSettings.onMenuItem(:menuSettingsActivity)");
      Ui.pushView(new Rez.Menus.menuSettingsActivity(), new MenuDelegateSettingsActivity(), Ui.SLIDE_IMMEDIATE);
    }
    else if (item == :menuSettingsAbout) {
      //Sys.println("DEBUG: MenuDelegateSettings.onMenuItem(:menuSettingsAbout)");
      Ui.pushView(new MenuSettingsAbout(), new MenuDelegateSettingsAbout(), Ui.SLIDE_IMMEDIATE);
    }
  }

}
