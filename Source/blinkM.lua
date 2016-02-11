-- time units are "ticks" = 1/30th of a second

local publicClass = {};

local ID = 0;
publicClass.I2C_ADDR = 0x09;
publicClass.I2C_SDA_GPIO = 0;
publicClass.I2C_SCL_GPIO =1;

function publicClass.setup(i2c_sda_gpio, i2c_scl_gpio, address)
    I2C_SDA_GPIO = i2c_sda_gpio;
    I2C_SCL_GPIO = i2c_scl_gpio;
    I2C_ADDR = address;
    i2c.setup(ID, publicClass.I2C_SDA_GPIO, publicClass.I2C_SCL_GPIO, i2c.SLOW);
end

function publicClass.setStartupMode(mode, scriptId, numLoops, fadeSpeed, timeAdjust)
    -- This command sets the startup (or “boot”) action for BlinkM. The command takes four
    -- arguments. The first argument ‘m’ is the startup mode: 0 means do nothing, 1 means play a
    -- script. The second argument ‘n’ is which script id to play. The third argument ‘f’ is the number
    -- of repetitions to play that script id. The fourth (‘f’) and fifth (‘t’) arguments are the fade speed
    -- and time adjust, respectively, to use with the script. This command takes about 20
    -- milliseconds to complete, due to EEPROM write time.
    -- Note: when turning off playing a script by setting the first argument ‘m’ to 0, the other
    -- arguments are saved but not loaded on startup and instead set to zero. This is most
    -- noticeable with the fade speed value. Thus if a “{‘B’,0,...}” is issued to disable startup script
    -- playing, be sure to issue a “{‘f’, 20}” command after BlinkM startup or color fading will not
    -- work.
    i2c.start(ID);
    i2c.address(ID, publicClass.I2C_ADDR, i2c.TRANSMITTER);
    i2c.write(ID, 'B', mode, scriptId, numLoops, fadeSpeed, timeAdjust);
    i2c.stop(ID);
end

function publicClass.fadeToColor(hue, saturation, brightness, speed)
    -- This command will fade from the current color to the specified HSB color. The command takes
    -- three bytes as arguments. The first argument byte is the hue (or raw color), with the following
    -- mapping from 0-255.
    -- The second argument is the saturation, or vividness, of the color. A saturation of 0 means a
    -- very light/white color and a saturation of 255 means a very vivid color. The third argument is
    -- the brightness of the resulting color, where 0 is totally dark and 255 means maximally bright.
    -- For more information about the HSB color space, see Section 4.3 “Color Models” below.
    -- The rate at which the fading occurs is controlled by the “Set Fade Speed” (‘f’) command.
    -- The default fade time is 15 time units.
    -- This command sets the rate at which color fading happens. It takes one argument that is the
    -- fade speed from 1-255. The slowest fading occurs when the fade speed is 1. To change
    -- colors instantly, set the fade speed to 255. A value of 0 is invalid and is reserved for a future
    -- “Smart Fade” feature.
    i2c.start(ID);
    i2c.address(ID, publicClass.I2C_ADDR, i2c.TRANSMITTER);
    i2c.write(ID, 'f', speed);
    i2c.write(ID, 'h', hue, saturation, brightness);
    i2c.stop(ID);
end

return publicClass;