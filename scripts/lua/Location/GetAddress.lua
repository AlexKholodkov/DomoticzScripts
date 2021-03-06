-- Paste the code below in a new Lua Time Event
commandArray = {}

interval = 5 -- In Minutes
ttidx = "151" -- idx of Text Dummy in Domoticz
local m = os.date('%M')
if (m % interval == 0) then
  function address(longitude, latitude)
    command = "curl -s https://maps.googleapis.com/maps/api/geocode/json?latlng=" .. latitude .. "," .. longitude .. "&sensor=false"
    local handle = io.popen(command)
    local result = handle:read("*a")
    local startIndex = string.find(result,"formatted_address") + 22
    output = string.sub(result,startIndex)
    local endIndex = string.find(output,'",')-1
    output = string.sub(output ,1,endIndex)
    handle:close()
    return output
  end
  current_address = otherdevices['Location']
  current_location = uservariables["Current Location"]
  distance_from_home = uservariables["DistanceFromHome"]
  current_latitude, current_longitude = current_location:match("([^,]+),([^,]+)")
  new_address = address(current_longitude,current_latitude)
  new_address = string.gsub(new_address, ', Netherlands', '') .. '<br>(' .. (math.floor((distance_from_home/1000)*10+0.5)/10) .. ' km)'
  new_address = string.gsub(new_address,',','<br>')
  if (current_address ~= new_address) then
     commandArray['UpdateDevice'] = ttidx..'|0|'..new_address
     print("Locatie gebruiker gewijzigd, nieuw adres: "..new_address)
  end
end

return commandArray
