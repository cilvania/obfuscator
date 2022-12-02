local function bits(num,bits)
	if num == nil then return nil end
	local num = num
	local t=''-- will contain the bits
	for b=bits,1,-1 do
		rest=math.fmod(num,2)
		t=tostring(rest)..t
		num=(num-rest)/2
	end
  return t
end

local function toint(num)
	local num = string.format('%02x',num)
	if #num > 8 then return '00000000', error('number too large to be represented by integer') end
	for i=1,8-#num do
		num = '0'..string.upper(num)
	end
	return num:flip(2)
end

local function tobyte(num)
	return string.format('%02X', num)
end

local function tosize_t(num)
	local num = string.format('%02x',num)
  local size = 16
	if #num > size then return '0000000000000000', error('number too large to be represented by size_t') end
	for i=1,size-#num do
		num = '0'..string.upper(num)
	end
	return num:flip(2)
end

local function todouble(x) 
	local function grab_byte(v)
		return math.floor(v / 256), string.char(math.mod(math.floor(v), 256))
	end
	local sign = 0
	if x < 0 then sign = 1; x = -x end
	local mantissa, exponent = math.frexp(x)
	if x == 0 then -- zero
		mantissa, exponent = 0, 0
	elseif x == 1/0 then
		mantissa, exponent = 0, 2047
	else
		mantissa = (mantissa * 2 - 1) * math.ldexp(0.5, 53)
		exponent = exponent + 1022
	end
	local v, byte = "" 
	x = mantissa
	for i = 1,6 do
		x, byte = grab_byte(x); v = v..byte 
	end
	x, byte = grab_byte(exponent * 16 + x); v = v..byte 
	x, byte = grab_byte(sign * 128 + x); v = v..byte 

	return v:tohex()
end

math.convert = {}
math.convert.toint = toint
math.convert.tobyte = tobyte
math.convert.tosize_t = tosize_t
math.convert.todouble = todouble

math.bits =bits


return nil