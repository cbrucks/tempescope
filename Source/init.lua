cfg = {};
cfg.ssid = "Tempescope" ..  node.chipid();
cfg.pwd = "t" .. node.chipid();
cfg.auth = AUTH_WPA2_PSK;
cfg.hidden = 0;
cfg.max = 1;

wifi.ap.config(cfg);
wifi.setmode(wifi.STATIONAP);

dofile("server.lua");