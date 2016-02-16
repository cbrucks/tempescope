srv=net.createServer(net.TCP)
srv:listen(80, function(conn) 
    conn:on("receive", function(conn, payload)
        file.open("webPage.html", "r")
        local function sender(conn)
            local fileContents = file.read();
            if (fileContents ~= nil) then
                conn:send(fileContents);
            else
                file.close();
                conn:close();
                
                local req = dofile("httpserver-request.lua")(payload)
                for key,value in pairs(req.uri.args) do print(key,value) end;
            end
        end
        conn:on("sent", sender)
        sender(conn)
	end) 
end)
          
