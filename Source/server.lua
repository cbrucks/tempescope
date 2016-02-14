require("httpserver-request")

srv=net.createServer(net.TCP)
srv:listen(80, function(conn) 
    conn:on("receive", function(conn, payload)
        --local req = dofile("httpserver-request")(payload)
        --for key,value in pairs(req) do print(key,value) end;
        
        file.open("index.html", "r")
        local function sender(conn)
            local fileContents = file.read();
            if (fileContents ~= nil) then
                conn:send(fileContents);
            else
                file.close();
                conn:close();
            end
        end
        conn:on("sent", sender)
        sender(conn)
	end) 
end)
          
