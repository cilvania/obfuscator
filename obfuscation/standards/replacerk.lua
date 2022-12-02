local module = {}
--THIS WILL REPLACE ALL INSTRUCTIONS THAT USE RK() INTO INSTRUCTIONS PRECEEDED BY LOADK AS TO MAKE MODIFICATION OF THESE INSTRUCTIONS EASIER (THIS FILE IS NEEDED FOR LOTS OF OBFUSCATION)
local random_save_string = string.random()

local opcodes_using_registers = {
  {1,1}, --MOVE
  {1,0}, --LOADK
  {1,0,0}, --loadbool
  {1,1},--loadnil
  {1,0}, --getupval

  {1,0}, --getgbl
  {1,1,2}, --gettbl
  
  {1,0}, --setglobal
  {1,0}, --setupval
  {1,2,2}, --settable

  {1,0,0}, --newtable

  {1,1,2}, --self

  {1,2,2}, --add
  {1,2,2}, --sub
  {1,2,2}, --mul
  {1,2,2}, --div
  {1,2,2}, --mod
  {1,2,2}, --pow
  {1,1}, --unm
  {1,1}, --not
  {1,1}, --len

  {1,1,1}, --concat

  {0}, --nil jmp

  {0,2,2}, --eq
  {0,2,2}, --lt
  {0,2,2}, --le

  {1,0}, -- test
  {1,1,0}, --testset

  {1,0,0}, --call
  {1,0,0}, --tailcall
  {1,0}, -- return

  {1,0}, --forloop

  {1,0}, --forprep

  {1,0}, --tforloop

  {1,0,0}, --setlist

  {1}, --close
  {1,0}, --closure

  {1,0} --vararg
}
function module.replace_rk_instruction(struct,i) 
  local instruction = struct.instructions[i]
  local New_Wrapped = kek.wrap_instruction(instruction) 
  New_Wrapped[1].ID = nil
  local function handle_operand(oper)
    table.insert(New_Wrapped,1,{
      op=1;
      [1] = struct.stacksize+(oper-2);
      [2] = instruction[oper];
    })
    New_Wrapped[#New_Wrapped][oper] = struct.stacksize+oper-2;
  end
  for Operand = 2,3 do
    if type(instruction[Operand]) == 'string' then handle_operand(Operand) end
  end
  struct.instructions[i] = New_Wrapped
end
function module.replace_rk_usage(struct)
  for i,v in pairs(struct.instructions) do
    if not v.op then print(inspect(v)) end
    if opcodes_using_registers[v.op+1][2] == 2 or opcodes_using_registers[v.op+1][3] == 2 then
      module.replace_rk_instruction(struct,i)
    end
  end
  struct.stacksize = struct.stacksize+2
  for i,v in pairs(struct.protos) do
    module.replace_rk_usage(v)
  end
end

return module
