--THIS FILE IS THE MAIN HUB FOR OBFUSCATION
local parsing = require('parsing/bcparse')
local construct = require('assembly/bconstruct')
local polymorphize_lib = require('polymorphizer/parser')
local linking_lib = require('assembly/link')


--obfuscation libs//
local replacerk = require('obfuscation/standards/replacerk')
local stack = require('obfuscation/stack')
local loops = require('obfuscation/flow/randomjmps')
local globals = require('obfuscation/standards/globals')
local debug = require('obfuscation/miscedits/debug')
local closures_modification = require('obfuscation/instructions/clumpclosures_upvalues')
local individualinstructions = require('obfuscation/instructions/loadindividual')
local constant_modification = require('obfuscation/constants/constants')
local utils = require('obfuscation/miscedits/utils')
--local constant_loading = require('obfuscation/standards/constantloading')
--local eq_checks = require('obfuscation/miscedits/eqchecks')
local string_xor = require('obfuscation/miscedits/string_xor')




function get_struct(func)
	local DumpedBytecode = string.dump(func):tohex()
  file.write("DUMPED2.out",DumpedBytecode)
	local ParsedStruct = parsing.parse_chunk(DumpedBytecode)
	return polymorphize_lib.morph_struct(ParsedStruct)
end

function assemble_struct(struct)
print("LINKING")
	local simplerstruct = linking_lib.link_struct(struct)
	return construct.construct_function(simplerstruct)
end

function strip_struct(struct)
	for i,v in pairs(struct.protos) do
		strip_struct(v)
	end
  for i,v in pairs(struct.constants) do
   
  if type(v) == 'table' and type(v.Value) == 'string' then
    --v.Value = v.Value..'\0'
    end
  end
	struct.lineinfo = {}
	struct.locals = {}
  struct.upvals = {}
  struct.SourceName = "@ALPINE ERROR\0"
end
local charset = {}
for i=string.byte('a'),string.byte('z') do
  table.insert(charset,string.char(i))
end
for i=string.byte('A'),string.byte('Z') do
  table.insert(charset,string.char(i))
end
for i=string.byte('0'),string.byte('9') do
  table.insert(charset,string.char(i))
end
function fillgarg(struct)
  for i=1,math.random(2,3) do
    local str = 'PSU|'
    for i=1,math.random(1,100) do
    math.randomseed((os.time()+os.clock()*10920) + i)
      str = str..charset[math.random(#charset)]
    end
    local str = string_xor.string_xor(str,math.random(1,255))
    kek.constant(struct,str)
  end
  for i,v in pairs(struct.protos) do
    fillgarg(v)
  end
end

function obfuscate(data)
	if type(data) == 'string' then data = loadstring(data,'') end
  print("PARSING struct")
	local struct = get_struct(data)
  --kek.constant(struct,'')
  --fillgarg(struct)
  --table.insert(struct.instructions,1,break_instruction)
  globals.modify_globals(struct)
  individualinstructions.modify(struct)
  replacerk.replace_rk_usage(struct)
  kek.fold_struct(struct)
  constant_modification.use_function_constants(struct)
  kek.fold_struct(struct)
  closures_modification.modify_closures(struct)
  loops.trampoline_instructions(struct)
  loops.jmp_bomb(struct)
  kek.fold_struct(struct)
  string_xor.replace_prot_strings(struct)
  kek.fold_struct(struct)
  utils.change_len_strings(struct)
  kek.fold_struct(struct)
  debug.remove_unused_constants(struct)
  file.write('outstruct.out',inspect(struct))
  strip_struct(struct)
  --debug.fix_info(struct)
	local bytecode = assemble_struct(struct)
	return bytecode,struct
end

return obfuscate