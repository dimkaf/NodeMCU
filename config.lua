Config = {}
local function SetType(value,name,table)
    if table[name]~= nil then
        if type(table[name])=='number' then
            table[name]=tonumber(value)                  
        elseif type(table[name])=='boolean' then
            if string.match(value,'true') then
                table[name]=true
            else
               table[name]=false
            end
        elseif type(table[name])=='string' then
               table[name]=value
        else
          print('Error: Not support type of parameter '..name)
          return false
        end
    else
          print('Error: Not found parameter '..name)
          return false
    end
    return true
end


function Config.Load(file_name, table)
    local f=file.open(file_name, "r")
    print('reading config from '..file_name)
    if f ~= nil then
        repeat 
            local line=file.readline()
            if line then 
            local name,value;
                name=string.match(line,'(.-)=');
                value=string.match(line,'=(.+)');
                if (name== nil)or (value== nil) then
                    print ('Error: Incorrect parameter '..line)
                    return false;
                else
                   SetType(value,name,table)
                end
             end
         until not line    
         file.close()
         return true;
     end
end

function Config.Save(file_name,table)
    local f=file.open(file_name, "w")
    if f~= nil then
        for k,v in pairs(table) do file.write(k..'='..tostring(v)..'\n') end  
        file.close()
        return true;
    else
        return false; 
    end
end

-- XmlConfig('{"ID":"sPsw", "VALUE":"1234567n"}',Variables)
function Config.Xml(xml,table)
    local m = cjson.decode(xml)
    local key=nil
    print('send json='..xml)
    for k,v in pairs(m) do 
        print(k,v)
        if k=="ID" then 
            if table[v]~= nil then
                print('key is')
                key=v
            else
                key=nil --key not found!
            end
         else
            if (k=="VALUE") and (key~= nil) then  -- check value type
                SetType(v,key,table)
            end
         end 
    end
end

return Config


