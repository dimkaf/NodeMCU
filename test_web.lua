MyData = {Task="",iRed=64, iBlu=64, iGrn=64, iClr=1, bClr=true, iNgl=512, bNgl=true, iWht=512, bWht=true,
            iSfl=512, bSfl=true, bNfd=false, iNtm=3600,
            iMup=0, iMhk=-1, iMdn=1, iEnd=50, iSen=10,
            sSid="SSID-ESP", sPsw="ESP-2222" , sAut=0}

node.setcpufreq(node.CPU80MHZ)
cfg={}
cfg.ssid="ESP-"..node.chipid()
cfg.pwd=cfg.ssid
cfg.auth=wifi.AUTH_OPEN --actually feature not work correct
wifi.ap.config(cfg)
wifi.setmode(wifi.STATIONAP)
--wifi.setphymode(wifi.PHYMODE_G)

Led_G = 6
Led_B = 7
Led_R = 8
pwm.setup(Led_R, 500, 50)
pwm.setup(Led_G, 500, 50)
pwm.setup(Led_B, 500, 50)
pwm.start(Led_R)
pwm.start(Led_G)
pwm.start(Led_B)

tmr.register(0, 1000, tmr.ALARM_AUTO, function() 
     if MyData.Task ~= nil then
        --check in
        pwm.setduty(Led_R,(MyData.iRed*MyData.iClr))
        pwm.setduty(Led_G,(MyData.iGrn*MyData.iClr))
        pwm.setduty(Led_B,(MyData.iBlu*MyData.iClr))
        
        MyData.Task = nil
     end
end)

tmr.start(0)
srv=net.createServer(net.TCP)
require("config")

local xml_req=nil
local data_req = nil
local def_page = "index.html"


print("lunch web server...")

srv:listen(80, function(conn)
  conn:on("receive", function(sck, req)
  -- parse request
  print(req)
  print('----------------------------------------------')
  local response = {}
  local request=string.match(req,'GET ([%w/.]+) HTTP')
  local header='HTTP/1.0 200 OK\r\nServer: ESP8266\r\nContent-Type: text/html\r\nContent-Length: '
  if  request~= nil then
    if string.len(request)==1 then request=def_page else  request=string.sub(request,2) end
    print ('file:'..request)
  
  -- show web page HTML5
    response[#response + 1] = "HTTP/1.0 404 Not Found\r\nServer: ESP8266\r\n\r\n"
    local f = file.open(request,"r")
    local f_len=0
    request=nil
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
         response[1] = header..f_len..'\r\n\r\n'
     else
        print("file not found!")
        print(response[1])
     end
  else  -- not GET, check at POST form
    request=string.match(req,'POST ([%w/.]+) HTTP')
     if request ~= nil then
        request=string.match(request,'/post.cgi')
        print(request)
        xml_req=0
        response =nil
        if request ~= nil then -- await json in next call
            request=string.match(req,'Content%-Length: ([%w/.]+)')
            xml_req=tonumber(request)
            print(xml_req)
            print('await json.len='..xml_req) 
            data_req=nil
            -- check data merged to header
            k,v=string.find(req,'\r\n\r\n');
            print(v,k)
            k=string.len(req);
            print(k)
            if k>v then
                req=string.sub(req,v+1,k)
                print('found body:'..req)
         --  check for JSON body
                if xml_req >0 then
                    xml_req=xml_req-string.len(req)
                    xml_data=req 
                    if xml_req==0 then -- complete json
                        response ={}
                        response[1] = header..string.len(xml_data)..'\r\n\r\n'
                        response[1]=response[1]..xml_data
                         Config.Xml(xml_data,MyData)
                         MyData.Task="x"
                        xml_data=nil
                    end
                end
            end

        end
     else
     --  check for JSON body
        if xml_req >0 then
            xml_req=xml_req-string.len(req)
            if xml_data==nil then xml_data=req else  xml_data=xml_data..req end 
            if xml_req==0 then -- complete json
                response[1] = header..string.len(xml_data)..'\r\n\r\n'
                response[1]=response[1]..xml_data
                Config.Xml(xml_data,MyData)
                 MyData.Task="x"
                xml_data=nil
            end
        end
     end
  end -- end of parse request
    if response ~= nil then  -- send line and remove element from table
      local function send(sk)
        if #response > 0
            then sk:send(table.remove(response, 1))
            print("x")
        else
            sk:close()
		    response = nil
            collectgarbage()
        end
      end
     -- triggers the send() function again once the first chunk of data was sent
     sck:on("sent", send)
     send(sck)
    end

  end)
end)
