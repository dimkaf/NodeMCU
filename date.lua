-- Convert SNTP or RTC data from seconds format to conventional variables like minutes hours or year and month
-- IMPORTANT: code for integer version only, in the case flot firmware use int format or floor functions 

-- Extract time from SNTP/RTC data and return set of variables: hours,minutes, seconds
-- varables: 
-- sec= data value in seconds (by default take internal RTC time)
-- gmt= local offset of time in hours (by default=0)
Date = {}
function Date.GetTime (sec,gmt)
    local dSec,dHours,dMinutes
    if sec ==nil then sec,_ = rtctime.get() end
    dSec=sec-60*(sec/60)
    dMinutes=sec-3600*(sec/3600)
    dHours=sec-86400*(sec/86400) 
    dHours=(dHours-dMinutes)/3600
    dMinutes=(dMinutes-dSec)/60
    if gmt ~=nil then dHours=dHours+gmt end
    collectgarbage();
    return dHours,dMinutes,dSec
end
-- Convert SNTP/RTC data from seconds format to variables: Day,Month,Year.
-- for integer version only
-- varables: 
-- sec= data value in seconds (by default take internal RTC time)
function Date.GetDate (sec)
    local dDays,dYear,dMonth,dDate,dYl
    if sec ==nil then sec,_ = rtctime.get() end  
    dYear,dDays =Date.GetYear(sec)
    if dDays>58 then
        if Date.LapYear(dYear)==false then dDays=dDays+1 end
        if dDays<60 then 
            if Date.LapYear(dYear)==true then dMonth=2;dDate=29; end
        elseif dDays<91 then dMonth=3;dDate=dDays-59;
        elseif dDays<121 then dMonth=4;dDate=dDays-90;
        elseif dDays<152 then dMonth=5;dDate=dDays-120;
        elseif dDays<182 then dMonth=6;dDate=dDays-151;
        elseif dDays<213 then dMonth=7;dDate=dDays-181;
        elseif dDays<244 then dMonth=8;dDate=dDays-212;
        elseif dDays<274 then dMonth=9;dDate=dDays-243;
        elseif dDays<305 then dMonth=10;dDate=dDays-273;
        elseif dDays<335 then dMonth=11;dDate=dDays-305;
        else dMonth=12;dDate=dDays-334;
        end
    else
        if dDays<31 then 
            dMonth=1;dDate=1+dDays;
        else
            dMonth=2;dDate=dDays-30;
        end
    end
    collectgarbage();
    return dDate,dMonth,dYear
end
-- Calculate day of week 
-- varables: t= total seconds
-- Return :0...6 where 0 is Sunday, 1 is Monday... and 6 is Sat.
function Date.GetDay(t)
   t=(t-(t-86400*(t/86400)))/86400
   t=t-7*(t/7)
   if t<3 then return t+4; else return t-3; end
end
-- Calculate year 
-- varables: t= total seconds
--Return: 
    --1) year (as number from 1970) 
    --2) remain days
function Date.GetYear(t)
        t=(t-(t-86400*(t/86400)))/86400
    local yt=1970
        t=t-365;
    while (t>0) do
        yt=yt+1;t=t-365;
        if t>0 then yt=yt+1;t=t-366; else return yt,t+365; end
        if t>0 then yt=yt+1;t=t-365; else return yt,t+366; end
        if t>0 then yt=yt+1;t=t-365; else return yt,t+365; end
    end
    return yt,t+365
end
-- Is it lap year? Return: true is yes ,false is not eat lap
-- varables: t=year as value in four digits - 2016
function Date.LapYear(t)
    t=t-1972
    t=(t*10/4)-10*(t/4)
    if t==0 then return true end
    return false
end


return Date
