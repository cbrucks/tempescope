local publicClass = {};

STATE_ON = 1;
STATE_OFF = 0;

publicClass.pump_gpio = 0;
publicClass.fogger_gpio = 0;
publicClass.fan_gpio = 0;

function publicClass.setup(pump_gpio, fogger_gpio, fan_gpio)
    publicClass.pump_gpio = pump_gpio;
    publicClass.fogger_gpio = fogger_gpio;
    publicClass.fan_gpio = fan_gpio;
end

function publicClass.SetRainState(state)
    if (state == OFF) then
        -- turn the pump off
        gpio.write(publicClass.pump_gpio, gpio.LOW);
    else
        -- turn the pump on
        gpio.write(publicClass.pump_gpio, gpio.HIGH);
    end
end

function publicClass.SetFogState(state)
    if (state == OFF) then
        -- turn the fogger off
        gpio.write(publicClass.fogger_gpio, gpio.LOW);
    else
        -- turn the fogger on
        gpio.write(publicClass.fogger_gpio, gpio.HIGH);
    end
end

function publicClass.SetFanState(state)
    if (state == OFF) then
        -- turn the fan off
        gpio.write(publicClass.fan_gpio, gpio.LOW);
    else
        -- turn the fan on
        gpio.write(publicClass.fan_gpio, gpio.HIGH);
    end
end

return publicClass;