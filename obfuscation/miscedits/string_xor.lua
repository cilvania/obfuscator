local string_xor_lib = {}

function string_xor(str,xorkey)
  local function xor(a1, a2)
		local f, g, h = 1, 0, 10
		while a1 > 0 and a2 > 0 do
			local L_45_, L_46_ = a1 % 2, a2 % 2
			if L_45_ ~= L_46_ then
				g = g + f
			end
			a1, a2, f = (a1 - L_45_) / 2, (a2 - L_46_) / 2, f * 2
		end
		if a1 < a2 then
			a1 = a2
		end
		while a1 > 0 do
			local L_47_ = a1 % 2
			if L_47_ > 0 then
				g = g + f
			end
			a1, f = (a1 - L_47_) / 2, f * 2
		end
		return g
	end
  local newstr = ''
  for i=1,#str do
    newstr = newstr..string.char(xor(string.byte(str:sub(i,i)),xorkey))
  end
  return newstr
end
string_xor_lib.string_xor = string_xor
local SIGN = 'ALPPRT|'
function string_xor_lib.replace_prot_strings(struct)
  for i,v in pairs(struct.protos) do
    string_xor_lib.replace_prot_strings(v)
  end
  local xor_value = math.random(1,255)
  
  local xor_value_constant = kek.constant(struct,xor_value/2)
	local xor_func
	for i,instruction in ipairs(struct.instructions) do
		if instruction.op == 1 then
			local used_constant_holder = struct.constants[instruction[2]]
			local used_constant = used_constant_holder.Value
			if type(used_constant) == 'string' then
				local subbed = used_constant:sub(1,#SIGN)
				if subbed == SIGN then
          if not xor_func then 
          xor_func= kek.create_function(struct,string_xor)
          end
          used_constant_holder.Value = string_xor(used_constant:sub(#SIGN+1),xor_value)..'\0'
          local new_routine = {ID = instruction.ID}
          table.insert(new_routine,{
            op=36;
            [1] = struct.stacksize-4;
            [2] = xor_func;
          })
          table.insert(new_routine,{
            op=1;
            [1] = struct.stacksize-3;
            [2] = used_constant_holder.ID;
          })
          table.insert(new_routine,{
            op=1;
            [1] = struct.stacksize-2;
            [2] = xor_value_constant;
          })
          table.insert(new_routine,{
            op=14;
            [1] = struct.stacksize-2;
            [2] = struct.stacksize-2;
            [3] = kek.constant(struct,2);
          })
          table.insert(new_routine,{
            op=28;
            [1] = struct.stacksize-4;
            [2] = 3;
            [3] = 2;
          })
          table.insert(new_routine,{
            op=0;
            [1] = instruction[1];
            [2] = struct.stacksize-4;
          })
          struct.instructions[i] = new_routine
				end
			end
		end
	end
end


return string_xor_lib
