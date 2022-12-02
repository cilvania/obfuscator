local module = {} --generic name because it isnt special enough


function module.modify_closures(struct)
  for i,v in pairs(struct.instructions) do
    if v.op == 36 then
      local newinst = kek.wrap_instruction(v)
      local nups = struct.protos[v[2]].nups
      if nups ~= 0 then
      for _=1,nups do
        table.insert(newinst,struct.instructions[i+1])
        table.remove(struct.instructions,i+1)
      end
      struct.instructions[i] = newinst
    end
    end
  end
  for i,v in pairs(struct.protos) do
    module.modify_closures(v)
  end
end

return module