return function(struct,i)
  local new_instruction = kek.wrap_instruction(struct.instructions[i])
  local old_instruction = struct.instructions[i]
  local pc_plus_id = struct.instructions[i+2].ID
  local pc_normal_id = struct.instructions[i+1].ID
  local new_routine_id = uuid()
  local new_routine = {ID = new_routine_id}
  new_instruction[1] = {
    op=23;
    [1] = (old_instruction[2] == 0 and 1) or 0;
    [2] = kek.constant(struct,{});
    [3] = old_instruction[1];
  }
  new_instruction[2] = {
    op=22;
    [1] = new_routine_id;
  }
  new_instruction[3] = {
    op=22;
    [1] = pc_plus_id
  }
  local end_inst_id = uuid()
  new_routine[1] = {
    op=22;
    [1] = end_inst_id;
  }

  new_routine[2] = {
    op=0;
    [1] = old_instruction[1];
    [2] = old_instruction[2];
  }
  table.insert(new_routine,{
    op=22;
    [1] = 0;
    ID=end_inst_id
  })
  struct.instructions[i] = new_instruction 
  print(inspect(new_instruction))
  table.insert(struct.instructions,1,new_routine)
  return new_instruction
end
