local t = {0,2,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37}
local blacklisted_opcodes = table.set(t)
local function find_insertion_place(struct) 
    
    local place = math.random(#struct.instructions-2)
    local x = 0
    while blacklisted_opcodes[struct.instructions[place].op] and x < 100  do
      place = math.random(#struct.instructions-1)
      x = x +1 
    end
    if blacklisted_opcodes[struct.instructions[place].op] then
      return 0
    end
    return place
  end

return function(struct,i)
  local old_instruction = struct.instructions[i]
  if old_instruction[1]~= old_instruction.ID then return old_instruction end
  local new_instruction = kek.wrap_instruction(struct.instructions[i])
  local loop_around_times = math.random(1,5)
  local jmp_uuid = uuid()
  new_instruction[1][1] = jmp_uuid
  local newinst
  for i=1,loop_around_times do
    newinst = {ID = jmp_uuid;op=22;[1] = uuid();}
    jmp_uuid = newinst[1]
    local insert_place = find_insertion_place(struct)
    local jmp_orig_id = struct.instructions[insert_place].ID
    table.insert(struct.instructions,insert_place,newinst)
    table.insert(struct.instructions,insert_place,{op=22;ID=uuid();[1] = jmp_orig_id;})
  end
  newinst[1] = old_instruction.ID
  return new_instruction
end
