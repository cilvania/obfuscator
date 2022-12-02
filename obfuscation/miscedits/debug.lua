local debug_lib = {}
local ignore_opcodes = {
	[22] = true;
	[31] = true;
	[32] = true;
}

function debug_lib.remove_unused_constants(struct)
  local t = {}
  for i,v in pairs(struct.instructions) do
    if not ignore_opcodes[v.op] then
    for i=1,3 do
      if v[i] and type(v[i]) == 'string' then t[v[i]] = true end 
    end
    end
  end
  for i,v in pairs(struct.constants) do
    if not t[i] then struct.constants[i] = nil end
  end

end


function debug_lib.fix_info(struct)

  struct.lineinfo = {}
  print(#struct.instructions,'INSTSIZE')

  for i=1,#struct.instructions do
    table.insert(struct.lineinfo,math.random(1,2^28))
  end
  for i,v in pairs(struct.protos) do
    debug_lib.fix_info(v)
  end
end

function debug_lib.get_constant_usage(struct,id)
  local usage = {}
  local const_container = struct.constants[id]
  for i,Instruction in ipairs(struct.instructions) do
    if not ignore_opcodes[Instruction.op] then
      for argn=1,3 do
        local arg = Instruction[argn]
        
        if arg and arg == id then
          table.insert(usage,Instruction)
          break;
        end 
      end
    end
  end
  return usage
end
return debug_lib