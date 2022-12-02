
local instruction_modifying_module = {}


local files = {}

for i=1,37 do
  local read_file = pcall(function() file.read('obfuscation/instructions/individualinstructions/op_'..tostring(i)..'.lua') end)
  if read_file ~= false then
  files[i] = require('obfuscation/instructions/individualinstructions/op_'..tostring(i))
  end
end

function instruction_modifying_module.modify(struct)
  for i,proto in pairs(struct.protos) do
    instruction_modifying_module.modify(proto)
  end

  for i,instruction in ipairs(struct.instructions) do
    if files[instruction.op] then
      struct.instructions[i] = files[instruction.op](struct,i)
    end
  end
  struct.stacksize = struct.stacksize+1

  kek.fold_struct(struct)
end


return instruction_modifying_module