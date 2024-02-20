import Toybox.Graphics;
import Toybox.Math;
import Toybox.WatchUi;
import Toybox.Lang;
import Toybox.System;

class BatteryArc extends WatchUi.Drawable {

  hidden var mStartDegree;
  hidden var mEndDegree;
  hidden var mTotalDegree;
  hidden var mRadius;
  hidden var remainingBatteryInDays;
  hidden var remainingBattery;

  function initialize(params as Object) {
    Drawable.initialize(params);

    mStartDegree = 90 - $.mFaceValues.batteryArcGapDegree;
    mEndDegree = 90 + $.mFaceValues.batteryArcGapDegree;
    mTotalDegree = 360 - $.mFaceValues.batteryArcGapDegree * 2;
    mRadius = $.mFaceValues.batteryArcRadius;
  }

  function draw(dc) {    
    var remainingBatteryInDays = $.mFaceValues.batteryInDays;
    var remainingBattery = $.mFaceValues.batteryInPercentage;
    dc.setPenWidth(12);
    drawRemainingArc(dc);
    drawProgressArc(dc, remainingBattery);
    drawIcon(dc, remainingBatteryInDays);
  }

  function update(dc) {
    drawIcon(dc, remainingBatteryInDays);
  }

  hidden function drawProgressArc(dc, fillLevel) {
    dc.setColor(themeColor(Color.PRIMARY), Graphics.COLOR_TRANSPARENT);
    if (fillLevel > 0.0) {
      var startDegree = mStartDegree;
      var endDegree = mStartDegree - getFillDegree(fillLevel);

      drawEndpoint(dc, startDegree, 0, 0);
      drawEndpoint(dc, endDegree, 0, 0);

      dc.drawArc(
        $.mFaceValues.centerX,
        $.mFaceValues.centerY,
        mRadius,
        Graphics.ARC_CLOCKWISE,
        mStartDegree,
        endDegree
      );
    }
  }

  hidden function drawRemainingArc(dc) {    
    dc.setColor(themeColor(Color.INACTIVE), Graphics.COLOR_TRANSPARENT);

    drawEndpoint(dc, mStartDegree, 0, 0);
    drawEndpoint(dc, mEndDegree, 0, 0);

    dc.drawArc(
      $.mFaceValues.centerX,
      $.mFaceValues.centerY,
      mRadius,
      Graphics.ARC_CLOCKWISE,
      mStartDegree,
      mEndDegree
    );    
  }

  hidden function drawEndpoint(dc, degree, offX, offY) {
    var x = Math.round(getX(dc, degree));
    var y = Math.round(getY(dc, degree));
    
    
    dc.fillCircle(x+offX, y+offY, 5);
  }

  hidden function drawIcon(dc, remainingBattery) {
    remainingBattery = remainingBattery.toNumber().format("%i");
    if (remainingBattery == "0") {
      dc.setColor(themeColor(Color.TEXT_INACTIVE), Graphics.COLOR_TRANSPARENT);
    } else {
      dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
    }

    var  x = $.mFaceValues.centerX;
    var  y = 15; 
    

    if(remainingBattery.equals("  ")){
      remainingBattery = "0";
    }

    remainingBattery = remainingBattery + "d";

    dc.drawText(
        x-17,
        y-2,
        Settings.resource(Rez.Fonts.Icons),
        "h",
        Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER
      );  

    var charArray = remainingBattery.toCharArray() as Array<String>;
    var offset = 0;

    for(var i = 0; i < charArray.size() as Number; i++ ){
      dc.drawText(
        x + offset,
        y,
        Settings.resource(Rez.Fonts.Data),
        charArray[i],
        Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER
      );  
      offset += 12; 
    } 
  }

  hidden function getX(dc, degree) {
    degree = Math.toRadians(degree);
    return ($.mFaceValues.centerY).toFloat() + mRadius.toFloat() * Math.cos(degree);
  }

  hidden function getY(dc, degree) {
    degree = Math.toRadians(degree);
    return $.mFaceValues.height.toFloat() - (($.mFaceValues.centerY).toFloat() + mRadius.toFloat() * Math.sin(degree));
  }

  hidden function getFillDegree(fillLevel) {
    return mTotalDegree * fillLevel/100;
  }
} 