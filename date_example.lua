--These examples related to Date functions that maybe usfull for SNTP or RTC data conversion from seconds format to conventional variables like minutes hours or year and month
-- IMPORTANT: code for integer version only, in the case flot firmware use int format or floor functions 

local xx,dd,mm,yy,hh,mn,ss,sc
local wd={"Sun","Mon","Tue","Wed","Thu","Fri","Sat"};
sc=1468252705; --Mon Jul 11 2016 18:58:25 GMT+0300 (RTZ 2 ,winter)

hh,mn,ss =Date.GetTime (sc,3) -- calculate time stamp for GMT+0300
dd,mm,yy =Date.GetDate(sc) -- calculate data time stamp
xx =wd[1+Date.GetDay(sc)] -- define day of week
print(xx..". "..dd.."/"..mm.."/"..yy.."   "..hh..":"..mn.."'"..ss) --show result as formated string day/month/year hours:minutes'seconds

hh,mn,ss =Date.GetTime (_,4) -- calculate time stamp from RTC on board using local time shift GMT+0400