wifi.setmode(wifi.STATIONAP)
wifi.sta.config("MYSSID","123456789")
led1 = 6
led2 = 7
gpio.mode(led1, gpio.OUTPUT)
gpio.mode(led2, gpio.OUTPUT)
srv=net.createServer(net.TCP)
print("lunch web server")

srv:listen(80, function(conn)
  conn:on("receive", function(sck, req)

  -- parse request
  print(req)
  local request=string.match(req,'GET ([%w/.]+) HTTP')
  if  request~= nil then
    print (request)
    request=nil
  
  -- show web page HTML5
    local response = {}
    response[#response + 1] = "HTTP/1.0 200 OK\r\nServer: NodeMCU on ESP8266\r\nContent-Type: text/html\r\n\r\n"
    local f = file.open("main.html","r")
    if f ~= nil then
        repeat 
            local line=file.read(512)
            if line then 
                response[#response + 1]=line
                print("*") 
             end
         until not line    
         file.close()
         f=nil
     end
     -- sends and removes the first element from the 'response' table
    local function send(sk)
      if #response > 0
        then sk:send(table.remove(response, 1))
        print("x")
      else
        sk:close()
        response = nil
      end
    end
    -- triggers the send() function again once the first chunk of data was sent
    sck:on("sent", send)

    send(sck)
  end -- end of parse request
  end)
end)
