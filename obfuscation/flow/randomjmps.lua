local fakejmps = {}

local trampoline_ops = {0,2,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37}
trampoline_ops = table.set(trampoline_ops)
local t = {0,2,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37}
local blacklisted_opcodes = table.set(t)
function fakejmps.add_fake_loops(struct)

	for i,v in pairs(struct.protos) do
		fakejmps.add_fake_loops(v)
	end
	math.randomseed(os.time()+os.clock())
	for iterator,instruction in pairs(struct.instructions) do
		if type(instruction[1]) ~= 'table' and not blacklisted_opcodes[instruction.op] and iterator %3 ==0 then
			local origop = instruction.op
			struct.instructions[iterator] = kek.wrap_instruction(instruction)
			instruction = struct.instructions[iterator]
			local Jmp = {
				op=22;
				[1] = 2;
				ID=uuid();
			}
			local Jmp2 = {
				op=22;
				[1] = -3;
				ID=uuid();
			}
			local Jmp3 = {
				op=22;
				[1] = 1;
				ID=uuid();
			}


			table.insert(instruction,Jmp2)
			table.insert(instruction,1,Jmp)
			table.insert(instruction,3,Jmp3)

		end
	end
	--kek.fold_struct(struct)
end

function fakejmps.jmp_bomb(struct) 
  for i,v in pairs(struct.protos) do fakejmps.jmp_bomb(v) end
  function get_random_instructions(s)
    local t={}
    for i=1,math.random(10,20) do
      table.insert(t,s.instructions[math.random(3,#s.instructions-4)].ID)
    end
    return t
  end
  for i,instruction in pairs(struct.instructions) do
    
    if instruction.op and not trampoline_ops[instruction.op] and i%20 == 0 then
    local instructions_to_jmp = get_random_instructions(struct)
      local endid = struct.instructions[i+1].ID
      local jmp_ball = {
       ID = uuid();
       {op=22;[1]=endid}
      }
      for i,id in ipairs(instructions_to_jmp) do
        table.insert(jmp_ball,{
          op=22;
          [1] = id;
        })
      end
      table.insert(struct.instructions,i+1,jmp_ball)
    end
  end
end


function fakejmps.jmp_trampoline_instruction(struct,i)
  math.randomseed(os.time()+i)
  local instructions = struct.instructions
  local save_instruction = instructions[i]
  local save_id = save_instruction.ID
  local function find_insertion_place(struct) 
    
    local place = math.random(#struct.instructions-2)
    local x = 0
    while blacklisted_opcodes[instructions[place].op] and x < 100  do
      place = math.random(#struct.instructions-1)
      x = x +1 
    end
    if blacklisted_opcodes[instructions[place].op] then
      return 0
    end
    return place
  end

  local insertion_point = find_insertion_place(struct)

  local jmp_to_id = uuid()
  local jmp_out_id = struct.instructions[insertion_point+1].ID
  local jmp_back_id = struct.instructions[i+1].ID
  save_instruction.ID = uuid()
  local routine = {
    ID = jmp_to_id;
    {op=22;[1] = jmp_out_id};
    save_instruction;
    {op=22;[1] = jmp_back_id};
  }
  struct.instructions[i] = {op=22;[1]=save_instruction.ID;ID=save_id}
  table.insert(struct.instructions,insertion_point+1,routine)
end

function fakejmps.trampoline_instructions(struct)
  math.randomseed(os.time()+(os.clock()*1098122))
  for i,v in pairs(struct.instructions) do
    math.randomseed(os.time()+(os.clock()*1098122))
    if i % 3 == 0 and type(v[1]) ~= 'table' and i < #struct.instructions-2 and not trampoline_ops[v.op] then
      fakejmps.jmp_trampoline_instruction(struct,i)
    end
  end
  for i,v in pairs(struct.protos) do
    fakejmps.trampoline_instructions(v)
  end
end


return fakejmps
