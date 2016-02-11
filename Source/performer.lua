local blinkM = require("blinkM");
local hardware = require("hardwareInterface");
local weather = require("weather");

local publicClass = {};

local 

blinkM.setup(5, 6, 0x09);
hardware.setup(pump_gpio, fogger_gpio, fan_gpio);
weather.setup();

function publicClass.update()
    weather.update();
    
    if (weather.isRaining()) then
        hardware.setRainState(ON);
    else
        hardware.setRainState(OFF);
    end
    
    if (weather.isFoggy()) then
        hardware.setFogState(ON);
    else
        hardware.setFogState(OFF);
    end
    
    if (weather.isCloudy()) then
        hardware.setFogState(ON);
        hardware.setFanState(ON);
    else
        hardware.setFogState(OFF);
        hardware.setFanState(OFF);
    end
    
    -- set color based on time of day
    
    
    if (weather.isLightning()) then
        -- start lightning timer
    end
end

return publicClass;