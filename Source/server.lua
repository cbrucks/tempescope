require("httpserver-request")

srv=net.createServer(net.TCP) 
srv:listen(80, function(conn) 
    conn:on("receive", function(conn, payload)
        print(payload) 
        file.open("webpage.html", "r")
        conn:send(file.read())
        file.close()
        conn:close()
	end) 
end)
          
