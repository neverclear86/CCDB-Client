local jsonLua = http.get("https://raw.githubusercontent.com/rxi/json.lua/master/json.lua").readAll()

local ccdbLua = http.get("https://raw.githubusercontent.com/neverclear86/CCDB-Client/master/ccdb.lua").readAll()

fs.open("json.lua", "w").write(jsonLua)
fs.open("ccdb.lua", "w").write(ccdbLua)
