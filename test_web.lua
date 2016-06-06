wifi.setmode(wifi.STATIONAP)
wifi.sta.config("MYSSID","123456789")
led1 = 6
led2 = 7
gpio.mode(led1, gpio.OUTPUT)
gpio.mode(led2, gpio.OUTPUT)
srv=net.createServer(net.TCP)
print("lunch web server")

local xml_req=nil
local data_req = nil
srv:listen(80, function(conn)
  conn:on("receive", function(sck, req)
  -- parse request
  print(req)
  local response = {}
  local request=string.match(req,'GET ([%w/.]+) HTTP')
  if  request~= nil then
    print (request)
    request=nil
  
  -- show web page HTML5
    response[#response + 1] = "HTTP/1.0 404 Not Found\r\nServer: ESP8266\r\n\r\n"
    local f = file.open("main.html","r")
    local f_len=0
    if f ~= nil then
        repeat 
            local line=file.read(512)
            if line then 
                response[#response + 1]=line
                f_len=f_len+string.len(line)
                print(f_len) 
             end
         until not line    
         file.close()
         f=nil
         response[1] = 'HTTP/1.0 200 OK\r\nServer: ESP8266\r\nContent-Type: text/html\r\nContent-Length: '..f_len..'\r\n\r\n'
     end
  else  -- not GET, check at POST form
    request=string.match(req,'POST ([%w/.]+) HTTP')
     if request ~= nil then
        request=string.match(request,'/post.cgi')
        print(request)
        xml_req=0
        if request ~= nil then -- await json in next call
            response[1] = 'HTTP/1.0 200 OK\r\nServer: ESP8266\r\nContent-Type: application/xml\r\n\r\n'
            request=string.match(req,'Content%-Length: ([%w/.]+)')
            xml_req=tonumber(request)
            print(xml_req) 
            data_req=nil  
        end
     else  -- not GET & POST too, check for JSON body
        if xml_req >0 then
            print('await json...')
            xml_req=xml_req-string.len(req)
            if xml_data==nil then xml_data=req else  xml_data=xml_data..req end 
            if xml_req==0 then
                t = cjson.decode(xml_data)
                print(xml_data)
                for k,v in pairs(t) do print(k,v) end
                xml_data=nil
            end
        end
     end
  end -- end of parse request
      -- send line and remove element from table
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
  end)
end)
