
local function tohex(arg1)
	return (arg1:gsub('.', function (c)
		return string.format('%02X', string.byte(c))
	end))
end
local function fromhex(arg1)
	return (arg1:gsub('..', function (cc)
		return (tonumber(cc,16) and string.char(tonumber(cc, 16))) or ''
	end))
end


local function flip(str,fliplength)
	local f = ''
	str:gsub(string.rep('.',fliplength), function (cc)
		f = cc..f
	end)
	return f
end

local function totable(str)
	local t = {}
	for i=1,#str do
		t[i] = str:sub(i,i)
	end
	return t
end

local function split(inputstr, sep)
	if sep == nil then
		sep = "%s"
	end
	local t={}
	for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
		table.insert(t, str)
	end
	return t
end
local split_strings = split(file.read('useful/randomstrings'),'\n')
local function random()
  math.randomseed(os.time()+os.clock()*1290834)
  return split_strings[math.random(#split_strings)]
end

local function charbits(str,bits)
	local num = (type(str) == 'string' and string.byte(str)) or str
	local t=''-- will contain the bits
	for b=bits,1,-1 do
		rest=math.fmod(num,2)
		t=tostring(rest)..t
		num=(num-rest)/2
	end
	if num==0 then return t else return {'Not enough bits to represent this number'}end

	return t
end

local function bits(bc,n,tog)
	tog = (type(n) == 'boolean' and n) or tog
	n=(type(n) == 'number' and n) or (type(n) == 'boolean' and 8) or 8
	local bintab = (tog and {}) or ''
	for i,v in pairs(bc:table()) do
		if tog == true then
			table.insert(bintab,charbits(v,n))
		else
			bintab = bintab..charbits(v,n)
		end
	end
	return bintab
end

string.split = split
string.table = totable
string.totable = totable
string.to_table = totable
string.flip = flip
string.to_hex = tohex
string.tohex = tohex
string.from_hex = fromhex
string.fromhex = fromhex
string.charbits = charbits
string.bits = bits
string.random = random
return nil
