import Toybox.Graphics;
import Toybox.Math;
import Toybox.WatchUi;
import Toybox.Lang;
import Toybox.Application;

class BatteryArc extends WatchUi.Drawable {

  hidden var mStartDegree;
  hidden var mEndDegree;
  hidden var mTotalDegree;
  hidden var mRadius;
  hidden var remainingBatteryInDays;
  hidden var remainingBattery;

  function initialize(params as Object) {
    Drawable.initialize(params);

    mStartDegree = 90 - DataValues.batteryArcGapDegree;
    mEndDegree = 90 + DataValues.batteryArcGapDegree;
    mTotalDegree = 360 - DataValues.batteryArcGapDegree * 2;
    mRadius = DataValues.batteryArcRadius;
  }

  function draw(dc) {    
    var remainingBatteryInDays = DataValues.batteryInDays;
    var remainingBattery = DataValues.batteryInPercentage;
    dc.setPenWidth(12);
    drawRemainingArc(dc);
    drawProgressArc(dc, remainingBattery);
    drawIcon(dc, remainingBattery, remainingBatteryInDays);
  }

  hidden function drawProgressArc(dc, fillLevel) {
    dc.setColor(Color.getColor("primary"), Graphics.COLOR_TRANSPARENT);
    if (fillLevel > 0.0) {
      var startDegree = mStartDegree;
      var endDegree = mStartDegree - getFillDegree(fillLevel);

      drawEndpoint(dc, startDegree, 0, 0);
      drawEndpoint(dc, endDegree, 0, 0);

      dc.drawArc(
        DataValues.centerX,
        DataValues.centerY,
        mRadius,
        Graphics.ARC_CLOCKWISE,
        mStartDegree,
        endDegree
      );
    }
  }

  hidden function drawRemainingArc(dc) {    
    dc.setColor(Color.getColor("inactive"), Graphics.COLOR_TRANSPARENT);

    drawEndpoint(dc, mStartDegree, 0, 0);
    drawEndpoint(dc, mEndDegree, 0, 0);

    dc.drawArc(
      DataValues.centerX,
      DataValues.centerY,
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

  hidden function drawIcon(dc, remainingBattery, remainingBatteryInDays) {
    var batteryInDays = Properties.getValue("batteryInDays");

    if(batteryInDays == true){
      remainingBattery = remainingBatteryInDays;
    }
    
    remainingBattery = remainingBattery.toNumber().format("%i");
    if (remainingBattery == "0") {
      dc.setColor(Color.getColor("inactive"), Graphics.COLOR_TRANSPARENT);
    } else {
      dc.setColor(Color.getColor("text"), Graphics.COLOR_TRANSPARENT);
    }


    var  x = DataValues.centerX;
    var  y = 15; 
    

    if(remainingBattery.equals("  ")){
      remainingBattery = "0";
    }

    if(batteryInDays == true){
        remainingBattery = remainingBattery + "d";
    }else{
        remainingBattery = remainingBattery + "%";
        x = DataValues.centerX - 10;
    }

    dc.drawText(
        x-17,
        y-2,
        $.fonts.icons,
        "h",
        Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER
      );  

    var charArray = remainingBattery.toCharArray() as Array<String>;
    var offset = 0;

    for(var i = 0; i < charArray.size() as Number; i++ ){
      dc.drawText(
        x + offset,
        y,
        $.fonts.data,
        charArray[i],
        Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER
      );
      if(i == charArray.size()-2 && batteryInDays == false){
        offset += 18; 
      } else{
        offset += 12; 
      }
    } 
  }

  hidden function getX(dc, degree) {
    degree = Math.toRadians(degree);
    return (DataValues.centerY).toFloat() + mRadius.toFloat() * Math.cos(degree);
  }

  hidden function getY(dc, degree) {
    degree = Math.toRadians(degree);
    return DataValues.height.toFloat() - ((DataValues.centerY).toFloat() + mRadius.toFloat() * Math.sin(degree));
  }

  hidden function getFillDegree(fillLevel) {
    return mTotalDegree * fillLevel/100;
  }
} 