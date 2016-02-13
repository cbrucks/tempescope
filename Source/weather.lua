local publicClass = {};

publicClass.zipCode = 94040;

local function weatherUpdateCallback(sck, c)
    t = cjson.decode(c);
    
    print(t["weather"]["id"])
end

function publicClass.update()
    local token = "0474dfe66f55aa3845efbdd227a041b9";
    
    sk = net.createConnection(net.TCP, 0)
    sk:on("receive", weatherUpdateCallback)
    sk:connect(80,"api.openweathermap.org")
    sk:on("connection", function(sck,c)
        -- Wait for connection before sending.
        sk:send("GET /data/2.5/weather?zip=" .. publicClass.zipCode .. ",us&appid=" .. token .. " HTTP/1.1\r\nHost: api.openweathermap.org\r\nConnection: keep-alive\r\nAccept: */*\r\n\r\n")
    end);
end

return publicClass;
