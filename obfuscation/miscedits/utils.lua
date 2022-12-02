local utils = {}
function utils.change_len_strings(struct)
  for i,v in pairs(struct.protos) do
    utils.change_len_strings(v)
  end   
  local lentrack = {}
  for i,Instruction in pairs(struct.instructions) do
    if Instruction.op == 1 and struct.instructions[i+1].op ==20 then 
      local inst1,inst2 = Instruction,struct.instructions[i+1]
      if inst1[1] == inst2[2] then
        
        local constant_lengthed = struct.constants[inst1[2]]
        if not lentrack[#constant_lengthed.Value] then
        local newstr = kek.get_custom_string(#constant_lengthed.Value-1)
        newstr = kek.constant(struct,newstr)
        Instruction[2] = newstr
        lentrack[#constant_lengthed.Value] = newstr
        else
          Instruction[2] = lentrack[#constant_lengthed.Value]
        end
      end
    end
  end
end

return utils