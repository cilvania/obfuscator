local bconstruct = {}

--used for turning bytecode like struct generated by bcparse back into a executable chunk of hex lua 5.1 bytecode
local inst_lib = require('parsing/instructions')
--syn = true

local sint
local toint = math.convert.toint
local tobyte = math.convert.tobyte
local tosize_t = (not syn and math.convert.tosize_t) or toint
local todouble = math.convert.todouble


function bconstruct.construct_header(set)
	local header = (syn and '1B53584C') or '1B4C7561'

	function bytecode_append(str)
		header = header..str
	end
	bytecode_append((syn and '1000') or '5100') -- static for our version no use in changing, version and format
	bytecode_append(tobyte(set['endian']))
	bytecode_append(tobyte(set['sizeint']))
	bytecode_append(tobyte((syn and 4) or set['sizesize_t']))
	bytecode_append(tobyte(set['sizeinst']))
	bytecode_append(tobyte(set['sizelnum']))
	bytecode_append(tobyte(set['iflag']))

	return header

end

function bconstruct.construct_function(funcinfo,tog)

	local	funchex = (tog == nil and bconstruct.construct_header(funcinfo['header'])) or ''
 	
	local fi = funcinfo -- for ease

	local function setstring(str)
		funchex = funchex..(tosize_t(#str))
		funchex = funchex..(str:tohex())
	end
	local NameLength = #fi['SourceName'] or 0--string concatenation hell
	funchex = funchex..(tosize_t(NameLength))
	funchex = funchex..(fi['SourceName']:tohex())
	funchex = funchex..(toint( fi['LineDefined']))
	funchex = funchex..(toint(fi['LastLineDefined']))
	funchex = funchex..(tobyte(fi['nups']))
	funchex = funchex..(tobyte(fi['nparams']))
	funchex = funchex..(tobyte(fi['isvararg']))
	funchex = funchex..(tobyte(fi['stacksize']))

	funchex = funchex..(toint(#fi['instructions']))
	for i,v in pairs(fi['instructions']) do
		funchex = funchex..(inst_lib.AssembleInstruction(v))
	end
	funchex = funchex..(toint(#fi['constants']))

	for i,v in pairs(fi['constants']) do

		if type(v) == 'string' then
			funchex = funchex..(tobyte(4))
			setstring(v,"STRINCONST")
		end
		if type(v) == 'number' then
			funchex = funchex..(tobyte(3))
			funchex = funchex..(todouble(v))
		end
		if type(v) == 'table' then -- use table as a substitute for nil
			funchex = funchex..(tobyte(0))
		end
		if type(v) == 'boolean' then
			funchex = funchex..(tobyte(1))
			funchex = funchex..(tobyte((v==true and 1) or (v==false and 0)))
		end
	end
	funchex = funchex..(toint(#fi['protos']))
	for i,v in pairs(fi['protos']) do
		funchex = funchex..(bconstruct.construct_function(v,true))
	end

	funchex = funchex..(toint(#fi['lineinfo']))
	for i,v in pairs(fi['lineinfo']) do
		funchex = funchex..(toint(v))
	end

	funchex = funchex..(toint(#fi['locals']))

	for i,v in pairs(fi['locals']) do
		setstring(v.name)
		funchex = funchex..(toint(v.StartPc))
		funchex = funchex..(toint(v.EndPc))
	end

	funchex = funchex..(toint(#fi['upvals']))
	for i,v in pairs(fi['upvals']) do
		setstring(v)
	end

	return funchex
end


return bconstruct