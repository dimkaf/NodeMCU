-- This is example show how to use variables in Lua and update it using conventional HTML5 GUI over XML-HTTP service with JSON data format.
-- For this example need load to Flash additional html file for server:  index.html, as page by default 
-- JsonData is table that matched to JSON-variables from index.html using in JavaScript at controls of HTML5 page. If you need own design then
-- HTML variables must be matched by name to variables in table of LUA. 
 
JsonData = {Task="",iRed=64, iBlu=64, iGrn=64, iClr=1, bClr=true, iNgl=512, bNgl=true, iWht=512, bWht=true,
            iSfl=512, bSfl=true, bNfd=false, iNtm=3600,
            iMup=0, iMhk=-1, iMdn=1, iEnd=50, iSen=10,
            sSid="SSID-ESP", sPsw="ESP-2222" , iMod=3, iPhy=3, iSlp=0, sAut=0, sDef="index.html"}
node.setcpufreq(node.CPU80MHZ)
local cfg={}
cfg.ssid="ESP-"..node.chipid()
cfg.pwd=cfg.ssid
cfg.auth=wifi.AUTH_OPEN --actually feature not work correct
wifi.ap.config(cfg)
wifi.setmode(wifi.SOFTAP)
require("webserver")
Webserver.Start(JsonData)

