return function(struct,i)
  local new_instruction = kek.wrap_instruction(struct.instructions[i])
  local old_instruction = struct.instructions[i]

  new_instruction[1] = {
    op=23;
    [1] = (old_instruction[2] == 0 and 1) or 0;
    [2] = kek.constant(struct,{});
    [3] = old_instruction[1];
  }
  return new_instruction
end
