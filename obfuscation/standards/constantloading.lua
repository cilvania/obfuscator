local const_load_lib = {}
--[[this file is unused due to it producing unstable/non-executable bytecode 
  this will replace things like the constant list with table indexes

  EX:
  ```
    print("HELLO WORLD")
  ```
  BECOMES:
  ```
    local kst = {"HELLO WORLD"}
    function __MAIN(...)
      print(kst[1])
    end
    return __MAIN(...)
  ```
]]
local shift_reg = require('obfuscation/standards/shiftreg')

function const_load_lib.generate_indexes(struct,struct2)
  local new_list = {}
  local second_list = {}
  local constantlist = struct.constants 
  local array,hash = 0,0
  if #constantlist < 127 then
    local num_index_list = table.list(constantlist)
    for i,v in ipairs(num_index_list) do
      local random_bool = math.random(1,2) 
      if random_bool == 1 then
        array = array+1
        local idx = math.random(1,900000000)
        local number_index = kek.constant(struct,idx)
        local number_index2 = kek.constant(struct2,idx)
        new_list[v.ID] = number_index
        second_list[v.ID] = number_index2
      else
        hash = hash+1
        local idx = string.random()..'\0'
        local string_index = kek.constant(struct,idx)
        local string_index2 = kek.constant(struct2,idx)
        new_list[v.ID] = string_index
        second_list[v.ID] = string_index2
      end
    end
   end
  return new_list,second_list,array,hash
end
function const_load_lib.wrap_mainblock(struct)
  print(#struct.constants)
  if #struct.constants > 127 then print("TOO BIG") return struct end
  shift_reg.shift_registers(struct,1) 

  local wrap_struct = {
  LastLineDefined = 699,
  LineDefined = 42069,
  SourceName = "joe mama\0",
  constants = struct.constants,
  constsize = 0,
  header = struct.header,
  instructions = { 
    { 0,0,0,
      op=10;
    },
    { 1, 0,
      op = 36;
    },
    { 0,0,
      op=0;
    },
    { 1,1,1,
      op=29;
    },
    { 0, 1,
      op = 30,
    } },
  isvararg = 2,
  lineinfo = {},
  locals = {},
  nparams = 0,
  nups = 0,
  protos = {},
  protosize = 0,
  stacksize = struct.stacksize,
  upvals = {}
}
local indexes,indexes_2,array_size,hash_size = const_load_lib.generate_indexes(wrap_struct,struct)
print(array_size,hash_size)
wrap_struct.instructions[1] =  { 0,array_size,hash_size,
      op=10;
    }
table.insert(struct.instructions,1,{
  op=4;
  [1] = 0;
  [2] = 0;
})
for i,v in pairs(indexes) do
  table.insert(wrap_struct.instructions,2,{
    op=9;
    [1] = 0;
    [2] = v;
    [3] = i;
  })
end
for i,v in pairs(struct.instructions) do
  if v.op == 1 then
    struct.instructions[i] = {
      op=6;
      [1] = v[1];
      [2] = 0;
      [3] = indexes_2[v[2]];
      ID = v.ID;
    }
  end
end

struct.nups = 1;
wrap_struct.protos[1] = struct

return wrap_struct
end


return const_load_lib