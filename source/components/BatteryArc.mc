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

  function initialize(params as Object) {
    Drawable.initialize(params);

    mStartDegree = 90 - params[:gapDegree];
    mEndDegree = 90 + params[:gapDegree];
    mTotalDegree = 360 - params[:gapDegree] * 2;
    mRadius = params[:radius];
  }

  function draw(dc) {    
    update(dc);
  }

  function update(dc) {
    setAntiAlias(dc, true);
    var remainingBatteryInDays = System.getSystemStats().batteryInDays;
    var remainingBattery = System.getSystemStats().battery;
    // draw remaining arc first so it wont overdraw our endpoint
    drawMargin(dc);
    dc.setPenWidth(12);
    drawRemainingArc(dc);
    drawProgressArc(dc, remainingBattery);
    drawIcon(dc, remainingBatteryInDays);

    setAntiAlias(dc, false);
  }

  hidden function drawMargin(dc){
    dc.setPenWidth(20);
    dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_TRANSPARENT);
    dc.drawArc(
        dc.getWidth()/2,
        dc.getHeight()/2,
        mRadius+8,
        Graphics.ARC_CLOCKWISE,
        0,
        360
      );
  }

  hidden function drawProgressArc(dc, fillLevel) {
    dc.setColor(themeColor(Color.PRIMARY), Graphics.COLOR_TRANSPARENT);
    if (fillLevel > 0.0) {
      var startDegree = mStartDegree;
      var endDegree = mStartDegree - getFillDegree(fillLevel);

      drawEndpoint(dc, startDegree, 0, 0);
      drawEndpoint(dc, endDegree, 0, 0);

      dc.drawArc(
        dc.getWidth()/2,
        dc.getHeight()/2,
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
      dc.getWidth()/2,
      dc.getHeight()/2,
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

    var  x = dc.getWidth()/2;
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
    return (dc.getHeight()/2).toFloat() + mRadius.toFloat() * Math.cos(degree);
  }

  hidden function getY(dc, degree) {
    degree = Math.toRadians(degree);
    return dc.getHeight().toFloat() - ((dc.getHeight()/2).toFloat() + mRadius.toFloat() * Math.sin(degree));
  }

  hidden function getFillDegree(fillLevel) {
    return mTotalDegree * fillLevel/100;
  }
} 