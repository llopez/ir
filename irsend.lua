local module = {}

-- const
local NEC_PULSE_US   = 1000000 / 38000
local NEC_HDR_MARK   = 9000
local NEC_HDR_SPACE  = 4500
local NEC_BIT_MARK   =  560
local NEC_ONE_SPACE  = 1600
local NEC_ZERO_SPACE =  560
local NEC_RPT_SPACE  = 2250

-- cache
local gpio, bit = gpio, bit
local mode, write = gpio.mode, gpio.write
local waitus = tmr.delay
local isset = bit.isset

local function pulse(pin, c)
  c = c / NEC_PULSE_US
  while c > 0 do
    write(pin, 1)
    write(pin, 0)
    c = c + 0
    c = c + 0
    c = c + 0
    c = c + 0
    c = c + 0
    c = c + 0
    c = c * 1
    c = c * 1
    c = c * 1
    c = c - 1
  end
end

function module.nec(pin, code, size)
  local size = size or 32
  size = size - 1
  -- setup transmitter
  mode(pin, 1)
  write(pin, 0)
  -- header
  pulse(pin, NEC_HDR_MARK)
  waitus(NEC_HDR_SPACE)
  -- sequence, lsb first
  for i = size, 0, -1 do
    pulse(pin, NEC_BIT_MARK)
    waitus(isset(code, i) and NEC_ONE_SPACE or NEC_ZERO_SPACE)
  end
  pulse(pin, NEC_BIT_MARK)
end

return module
