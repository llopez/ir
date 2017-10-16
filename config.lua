local module = {}

-- load config from file
f = file.open("config.json")
module = sjson.decode(f.read())
module.chipid = node.chipid()

f.close()

return module
