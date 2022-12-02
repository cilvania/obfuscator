file = {}


function file.read(file)
local f = assert(io.open(file, "rb"))  local content = f:read("*all")
  f:close()
  return content
end
function file.write(FilePath, Contents)

	local File = io.open(FilePath, 'w')

	if not File then
		print('WriteFile: unable to open file at ' .. FilePath)
		return
	end

	File:write(Contents)
	File:close()

	return true
end