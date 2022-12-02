return function(struct,i)
  local new_instruction = kek.wrap_instruction(struct.instructions[i])
  local old_instruction = struct.instructions[i]

  new_instruction[1] = nil

  new_instruction[1] = {
    op=0;
    [1] = old_instruction[1]+1;
    [2] = old_instruction[2];
  }
  new_instruction[2] = {
    op=6;
    [1] = old_instruction[1];
    [2] = old_instruction[2];
    [3] = old_instruction[3]
  }
  return new_instruction
end
