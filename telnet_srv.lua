local module = {}

inUse = false

local function listenFun(sock)
	if inUse then
		sock:send("Already in use.\n")
		sock:close()
		return
	end
	inUse = true

	function s_output(str)
		if(sock ~=nil) then
			sock:send(str)
		end
	end

	node.output(s_output, 0)

	sock:on("receive",function(sock, input)
		node.input(input)
	end)

	sock:on("disconnection",function(sock)
		node.output(nil)
		inUse = false
	end)

	sock:send("Welcome to NodeMCU world.\n> ")
end

function module.start()
	module.server = net.createServer(net.TCP, 180)
	module.server:listen(23, listenFun)
end

function module.stop()
  module.server:close()
end

return module
