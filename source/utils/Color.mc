import Toybox.Application;


module Color {    

    function getColor(colorName) {

      var colors = {
          "primary" => Properties.getValue("primaryColor"),
          "secondary" => Properties.getValue("secondaryColor"),
          "inactive" => Properties.getValue("inactiveColor"),
          "text" => Properties.getValue("textColor"),
          "background" => Properties.getValue("backgroundColor")
      };

      return colors[colorName].toNumberWithBase(16);
    }  
}