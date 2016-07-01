-- Example how to use script config.lua for load and save variables into flash 
-- Variables contained in table below, avalable 3 types of values: boolean, integer and string
-- they will saved to file setup.ini into flash memory.
-- Just run example and see result at terminal window:
--
-- ESP-3210
-- reading config from setup.ini
-- load data in sucsess!
-- ESP-2222

Variables = {iRed=50, iBlu=50, iGrn=50, bClt=true, bBkl=false, bWht=false, 
            iMup=0, iMhk=-1, iMdn=1, iEnd=50, iSen=10,
            sSid="SSID-ESP", sPsw="ESP-2222" , sAut=0}
require("config")            
--save data to file
    Config.Save('setup.ini',Variables)
 --chage variable to show different when data will load from file
    Variables['sPsw']="ESP-3210"
    print(Variables['sPsw'])
if Config.Load('setup.ini',Variables)==true then print ('load data in success!') end
    print(Variables['sPsw'])
