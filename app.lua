local module = {}  

m = nil
gpio.mode(4, gpio.OUTPUT)
gpio.write(4, gpio.LOW)

local function send_ping()
  if wifi.sta.getip() then
    m:publish(config.mqtt.channel .. "ping", config.chipid .." ".. wifi.sta.getip(), 0, 0)
  end
end

local function register_myself()  
  m:subscribe(config.mqtt.channel .. config.chipid,0,function(conn)
    print("Successfully subscribed to data endpoint")
  end)
end

local function split(data)
  local t = {}
  local i = 0
  for part in string.gmatch(data, "%S+") do
    t[i] = part
    i = i + 1
  end
  return t
end

local function mqtt_start()  
  m = mqtt.Client(config.chipid, 120)

  m:on("message", function(conn, topic, data) 
    if data ~= nil then
      t = split(data)
      code, bits = t[0], t[1]
      print(code)
      print(bits)
      irsend.nec(4, code, bits)
      print(topic .. ": " .. data)
    end
  end)

  m:connect(config.mqtt.host, config.mqtt.port, 0, 1, function(con) 
    register_myself()
    
    tmr.stop(6)
    tmr.alarm(6, 5000, 1, send_ping)
  end) 
end

function module.start()
  mqtt_start()
end

return module
