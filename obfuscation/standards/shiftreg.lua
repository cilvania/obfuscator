local module = {}
-- THIS IS USED FOR SHIFTING ALL REGISTERS USED +1 SO THAT WE CAN USE THE LOWER REGISTER(S) FOR LONG TERM STORAGE 
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
local function shift_individual_reg(struct,i,increment_num,a,b,c)
  if struct.instructions[i].noshift or i==#struct.instructions then return end
  local g_reg = struct.info.globalregister
  local inst = struct.instructions[i]
  if a and (a >=256 or a == 0 or (inst.no_inc and inst.no_inc.a)) then a = nil end
  if b and (b >=256 or b == 0 or (inst.no_inc and inst.no_inc.b)) then b = nil end
  if c and (c >=256 or c == 0 or (inst.no_inc and inst.no_inc.c)) then c = nil end
  local insts = struct.instructions
  if insts[i][1] and type(insts[i][1]) ~= 'string' and a then
    struct.instructions[i][1] = (a and struct.instructions[i][1]+increment_num)
  end
  if insts[i][2] and type(insts[i][2]) ~= 'string' and b then
    struct.instructions[i][2] = (b and struct.instructions[i][2]+increment_num)
  end
  if insts[i][3] and type(insts[i][3]) ~= 'string' and c then
    struct.instructions[i][3] = (c and struct.instructions[i][3]+increment_num)
  end
  --ik this can be done faster but dont judge this is just a proof of concept remember?

end

function insert_shift_header(struct,number)
  for i=0,struct.stacksize-1 do
    table.insert(struct.instructions,1, {
      op=0;
      [1] = i+number;
      [2] = i;
      noshift = true;
    })
    table.insert(struct.lineinfo,1,69999)
  end
end
function module.shift_registers(struct,number) 
  insert_shift_header(struct,number)
  struct.stacksize = struct.stacksize+number
  for i,v in pairs(struct.protos) do
    module.shift_registers(v,number)
  end
  
  for i,v in pairs(struct.instructions) do
  if not v.op then print(inspect(v)) else
    shift_individual_reg(struct,i,number,unpack(opcodes_using_registers[v.op+1]))
    end
  end
end

return module