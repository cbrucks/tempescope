-- create a table that converts WiFi status codes to string descriptions
statusMessage = {}
statusMessage[0] = "STATION_IDLE"
statusMessage[1] = "STATION_CONNECTING"
statusMessage[2] = "STATION_WRONG_PASSWORD"
statusMessage[3] = "STATION_NO_AP_FOUND"
statusMessage[4] = "STATION_CONNECT_FAIL"
statusMessage[5] = "STATION_GOT_IP"

-- power down the modem as much as possible to save power
wifi.sleeptype(wifi.MODEM_SLEEP)

--wifi.sta.sethostname("OpenTempescope - " .. wifi.sta.getmac())

-- Set up the access point to allow the user to configure the device
local cfg = {}
cfg.ssid = "OpenTempescope - " .. node.chipid()
cfg.pwd = "ESP_" .. node.chipid()
cfg.auth = AUTH_WPA_WPA2_PSK -- use encryption
cfg.hidden = 0 -- make the AP visible
cfg.max = 1 -- one connection at a time
wifi.ap.config(cfg)

-- Set the WiFi mode so the device can create a local WiFi connection and 
-- connect to another WiFi router
wifi.setmode(wifi.STATIONAP)

-- Starts up the DHCP service to allow automatic connections
--local dhcp_config ={}
--dhcp_config.start = "192.168.1.100"
--wifi.ap.dhcp.config(dhcp_config)
--wifi.ap.dhcp.start()

-- register WiFi status change callbacks
--wifi.sta.eventMonReg(wifi.STA_IDLE,       WiFiConnectionFailed)
--wifi.sta.eventMonReg(wifi.STA_CONNECTING, WiFiConnectionFailed)
--wifi.sta.eventMonReg(wifi.STA_WRONGPWD,   WiFiConnectionFailed)
--wifi.sta.eventMonReg(wifi.STA_APNOTFOUND, WiFiConnectionFailed)
--wifi.sta.eventMonReg(wifi.STA_FAIL,       WiFiConnectionFailed)
--wifi.sta.eventMonReg(wifi.STA_GOTIP,      WiFiConnectionSuccessful)

function WiFiConnectionSuccessful()
    -- The WiFi connection has been established
    
    print(statusMessage[wifi.sta.status()])
    
    -- turn off the hosted Access Point
    wifi.setmode(wifi.STATION)
    
    -- start the SNTP synchronization
    tmr.start(TIMER_ID_SNTP_SYNCHRO)
end

function WiFiConnectionFailed()
    -- The WiFi connection has been lost

    print(statusMessage[wifi.sta.status()])
    
    -- turn on the hosted Access Point
    wifi.setmode(wifi.STATIONAP)
    
    -- stop the SNTP synchronization
    tmr.stop(TIMER_ID_SNTP_SYNCHRO)
end

function SNTPSynchronization()
    -- get the IP address of the SNTP server
    net.dns.resolve("time.nist.gov",
        function(sk, ip)
            if (ip == nil) then
                print("Could not resolve SNTP server IP!")
            else
                sntp.sync(ip)
            end
        end
    )
end
