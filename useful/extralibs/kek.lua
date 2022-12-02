kek = {}
local parsing_lib = require('parsing/bcparse')
function kek.constant(info,Value)
  for i,v in pairs(info.constants) do
    if v.Value == Value then  return v.ID end
  end
  local const = {}
  const.ID = uuid()
  while info.constants[const.ID] do
    const.ID = uuid()
  end
  const.Value = Value
  info.constants[const.ID] = const
  return const.ID--,info.constants[const.ID]
end

function kek.random_constant(struct) 
  local set = table.list(struct.constants)
  return set[math.random(#set)].ID
end

function kek.clock_call(f,...)
local starttime = os.clock()
f(...)
return os.clock()-starttime
end

function kek.switch(case)
  return function(t)
    return (t[case] or t['default'] or (function() end))()
  end
end

function kek.wrap_instruction(instruction)

  return {instruction,ID=instruction.ID}

end
function kek.create_function(struct,f)
  local f_bytecode = string.dump(f)
  local parsed_bytecode = parsing_lib.parse_chunk(f_bytecode:tohex())
  local function_uuid = uuid();
  parsed_bytecode.ID = function_uuid
  struct.protos[function_uuid] = parsed_bytecode
  struct.protos[function_uuid].info = {user_defined = true}
  return function_uuid
end
function kek.get_range_before(struct,opcodes)
  local start = 1;
  local ending = 0;
  local opcodeset = table.set(opcodes)
  for iterator1,instruction1 in ipairs(struct.instructions) do
    if type(instruction1[1]) == 'table' then
      for i,v in ipairs(instruction1) do
        if opcodeset[v.op] then
          ending = iterator1
          return ending
        end
      end
    else
      if opcodeset[instruction1.op] then
        return iterator1;
      end
    end
  end
end

local string_t = {
  'n-';
  'while true do end';
  'sex()';
  'bro helpplz';
  'no way bro look at my lbi';
  'STOP USING CALAMARI MARCOS!!!';
  "STOP SKIDDERING!@!!!!@@!";
  'imagine being perth and not even knowing how your own product works LOL!';
  'theres a reason hes 0x90 bro... he doesnt operate...'
}  
function kek.get_custom_string(len)
    math.randomseed(os.time()+(os.clock()*10000))
    local charset = {' '}
    local str=''
    while #str < len do
      str = str..string_t[math.random(#string_t)]..charset[math.random(#charset)]
    end
    str = str:sub(1,len)
    return str..'\0'
  end

function kek.get_index_id(struct,id)
  for i,v in pairs(struct.instructions) do
    if v.ID == id then
      return i
    end
  end
end
local csr = require('assembly/link').collapse_small_routines
kek.fold_struct = function(strct)
  csr(strct)
  for i,v in pairs(strct.protos) do
    kek.fold_struct(v)
  end
end

return functions