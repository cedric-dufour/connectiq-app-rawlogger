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

using Toybox.Graphics as Gfx;
using Toybox.WatchUi as Ui;

class PickerFactoryDictionary extends Ui.PickerFactory {

  //
  // VARIABLES
  //

  private var amKeys;
  private var amValues;
  private var amSettingsKeys;
  private var amSettingsValues;

  //
  // FUNCTIONS: Ui.PickerFactory (override/implement)
  //

  function initialize(_amKeys, _amValues, _dictSettings) {
    PickerFactory.initialize();
    self.amKeys = _amKeys;
    self.amValues = _amValues;
    if(_dictSettings != null) {
      self.amSettingsKeys = _dictSettings.keys();
      self.amSettingsValues = _dictSettings.values();
    }
    else {
      self.amSettingsKeys = null;
      self.amSettingsValues = null;
    }
  }

  function getDrawable(_iItem, _bSelected) {
    var dictSettings = {
      :text => self.amValues[_iItem],
      :locX => Ui.LAYOUT_HALIGN_CENTER,
      :locY => Ui.LAYOUT_VALIGN_CENTER,
      :color => _bSelected ? Gfx.COLOR_WHITE : Gfx.COLOR_DK_GRAY
    };
    if(self.amSettingsKeys != null) {
      for(var i=0; i<self.amSettingsKeys.size(); i++) {
        dictSettings[self.amSettingsKeys[i]] = self.amSettingsValues[i];
      }
    }
    return new Ui.Text(dictSettings);
  }

  function getValue(_iItem) {
    return self.amKeys[_iItem];
  }

  function getSize() {
    return self.amKeys.size();
  }


  //
  // FUNCTIONS: self
  //

  function indexOfKey(_mKey) {
    return self.amKeys.indexOf(_mKey);
  }

  function indexOfValue(_mValue) {
    return self.amValues.indexOf(_mValue);
  }

}
