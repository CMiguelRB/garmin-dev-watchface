import Toybox.Graphics;
import Toybox.Lang;
import Toybox.Application;

module Color {
  const TEXT_ACTIVE as Lang.Number = 0;
  const TEXT_INACTIVE as Lang.Number = 1;
  const PRIMARY as Lang.Number = 2;
  const SECONDARY_1 as Lang.Number = 3;
  const SECONDARY_2 as Lang.Number = 4;
  const BACKGROUND as Lang.Number = 5;
  const FOREGROUND as Lang.Number = 6;
  const INACTIVE as Lang.Number = 7;

  const MAX_COLOR_ID as Lang.Number = 8;

  const _COLORS as Array<Lang.Number> = [
    /* EXPANSE */
      Graphics.COLOR_WHITE,   // TEXT_ACTIVE
      Graphics.COLOR_LT_GRAY, // TEXT_INACTIVE
      0x36CE87,  // PRIMARY
      0xD3F667,    // SECONDARY_1
      Graphics.COLOR_RED,     // SECONDARY_2
      Graphics.COLOR_BLACK,   // BACKGROUND
      Graphics.COLOR_WHITE,   // FOREGROUND
      Graphics.COLOR_DK_GRAY, // INACTIVE,
  ];
}

function themeColor(sectionId as Lang.Number) as Lang.Number {
  var theme = 0;
  return Color._COLORS[(theme * Color.MAX_COLOR_ID) + sectionId];
}

function setAntiAlias(dc, enabled as Lang.Boolean) as Void {
  if (Graphics.Dc has :setAntiAlias) {
    dc.setAntiAlias(enabled);
  }
}