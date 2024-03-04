import Toybox.WatchUi;
import Toybox.Application;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.Time;

class DateAndTime extends WatchUi.Drawable {

  var mBurnInProtectionMode;

  var DayOfWeek as Array<Symbol> = [];
  var Months as Array<Symbol> = [];

  function initialize(params as Object) {
    Drawable.initialize(params);
    mBurnInProtectionMode = params[:burnInProtectionMode] && System.getDeviceSettings().requiresBurnInProtection;

    Months = [
      Rez.Strings.DateMonth1,
      Rez.Strings.DateMonth2,
      Rez.Strings.DateMonth3,
      Rez.Strings.DateMonth4,
      Rez.Strings.DateMonth5,
      Rez.Strings.DateMonth6,
      Rez.Strings.DateMonth7,
      Rez.Strings.DateMonth8,
      Rez.Strings.DateMonth9,
      Rez.Strings.DateMonth10,
      Rez.Strings.DateMonth11,
      Rez.Strings.DateMonth12
    ];

    DayOfWeek = [
      Rez.Strings.DateWeek1,
      Rez.Strings.DateWeek2,
      Rez.Strings.DateWeek3,
      Rez.Strings.DateWeek4,
      Rez.Strings.DateWeek5,
      Rez.Strings.DateWeek6,
      Rez.Strings.DateWeek7
    ];
  }

  function draw(dc) {
    var is12Hour = !System.getDeviceSettings().is24Hour;
    var now = Time.Gregorian.info(Time.now(), Time.FORMAT_SHORT);
    var date = getDateLine(now);
    var hours = getHours(now, is12Hour);
    var minutes = now.min.format("%02d");


    var hoursX = 120;
    var hoursY = DataValues.centerY - 89;

    var separatorY = DataValues.centerY - 95;

    var time = [hours.substring(0,1), hours.substring(1,2), ".", minutes.substring(0,1), minutes.substring(1,2)];

    dc.setColor(Color.getColor("text"), Graphics.COLOR_TRANSPARENT);

    //Time
    var lastPosition = hoursX - 70;

    dc.drawText(lastPosition, hoursY, $.fonts.time, time[0], Graphics.TEXT_JUSTIFY_CENTER);

    for(var i = 1; i<time.size();i++){
        if(time[i-1].equals("1")){
          lastPosition += 35;
        }else{
          lastPosition += 50;
        }
        if(time[i].equals(".")){
          if(time[i-1].equals("1")){
            lastPosition -= 10;
          }else{
            lastPosition -= 15;
          }
          dc.drawText(lastPosition, separatorY - 12, $.fonts.time, time[i], Graphics.TEXT_JUSTIFY_CENTER);
          dc.drawText(lastPosition, separatorY - 42, $.fonts.time, time[i], Graphics.TEXT_JUSTIFY_CENTER);
          if(time[i+1].equals("1")){
            lastPosition -= 25;
          }else{
            lastPosition -= 15;
          }          
          continue;
        }
        if(i == 4 && time[i].equals("1") && !time[i-1].equals("1")){
          lastPosition -= 10;
        }
        dc.drawText(lastPosition, hoursY, $.fonts.time, time[i], Graphics.TEXT_JUSTIFY_CENTER);
    }

      // Date
      var dateX = lastPosition + 18;
      var dateY = 112;
      dc.drawText(dateX, dateY, $.fonts.date, date, Graphics.TEXT_JUSTIFY_RIGHT);

    if (is12Hour) {
      var meridiem = (now.hour < 12) ? "AM" : "PM";
      var y = DataValues.centerY - 10;
      dc.drawText(lastPosition + 25, y, $.fonts.date, meridiem, Graphics.TEXT_JUSTIFY_LEFT);
    }
    //Alarms
    if(System.getDeviceSettings().alarmCount > 0){
      dc.setColor(Color.getColor("text"), Graphics.COLOR_TRANSPARENT);
      dc.drawText(lastPosition+45, DataValues.centerY - 20, $.fonts.icons, "k", Graphics.TEXT_JUSTIFY_CENTER);
    }    
    var showSeconds = Properties.getValue("showSeconds");

    if(showSeconds == true){
      updateSeconds(dc, now.sec, lastPosition);    
    }
  }

  function updateSeconds(dc, seconds, lastPosition) {
    var y = DataValues.centerY - 60;
    dc.setColor(Color.getColor("secondary"), Graphics.COLOR_TRANSPARENT);
    
    seconds = seconds.format("%02d");    

    var first = seconds.substring(0,1);
    var second = seconds.substring(1,2);
    
    dc.drawText(lastPosition + 33, y, $.fonts.date, first, Graphics.TEXT_JUSTIFY_CENTER);
    dc.drawText(lastPosition + 48, y, $.fonts.date, second, Graphics.TEXT_JUSTIFY_CENTER);
  }

  hidden function getDateLine(now as Gregorian.Info) {    
    return format(
      "$1$, $2$ $3$", 
      [ Settings.resource(DayOfWeek[(now.day_of_week as Number) - 1]), now.day.format("%02d"), Settings.resource(Months[(now.month as Number) - 1]) ]
    );    
  }

  hidden function getHours(now, is12Hour) {
    var hours = now.hour;
    if (is12Hour) {
      if (hours == 0) {
        hours = 12;
      }
      if (hours > 12) {
        hours -= 12;
      }
    }
    return hours.format("%02d");
  }

}