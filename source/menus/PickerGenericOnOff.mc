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

using Toybox.Application as App;
using Toybox.Graphics as Gfx;
using Toybox.WatchUi as Ui;

class PickerGenericOnOff extends Ui.Picker {

  //
  // FUNCTIONS: Ui.Picker (override/implement)
  //

  function initialize(_sPropertyId, _sTitle) {
    // Get property
    var bOnOff = App.Properties.getValue(_sPropertyId);

    // Initialize picker
    var oFactory = new PickerFactoryDictionary([true, false], [Ui.loadResource(Rez.Strings.valueOn), Ui.loadResource(Rez.Strings.valueOff)], null);
    Picker.initialize({
      :title => new Ui.Text({ :text => _sTitle, :font => Gfx.FONT_TINY, :locX=>Ui.LAYOUT_HALIGN_CENTER, :locY=>Ui.LAYOUT_VALIGN_BOTTOM, :color => Gfx.COLOR_BLUE }),
      :pattern => [ oFactory ],
      :defaults => [ oFactory.indexOfKey(bOnOff != null ? bOnOff : false) ]
    });
  }

}

class PickerDelegateGenericOnOff extends Ui.PickerDelegate {

  //
  // VARIABLES
  //

  private var sPropertyId;


  //
  // FUNCTIONS: Ui.Picker (override/implement)
  //

  function initialize(_sPropertyId) {
    PickerDelegate.initialize();
    self.sPropertyId = _sPropertyId;
  }

  function onAccept(_amValues) {
    // Set property and exit
    App.Properties.setValue(self.sPropertyId, _amValues[0]);
    $.RL_oSettings.load();
    Ui.popView(Ui.SLIDE_IMMEDIATE);
  }

  function onCancel() {
    // Exit
    Ui.popView(Ui.SLIDE_IMMEDIATE);
  }

}
