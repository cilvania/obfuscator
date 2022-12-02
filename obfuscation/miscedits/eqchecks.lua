local t = {0,2,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37}
local blacklisted_opcodes = table.set(t)

local function add_eq_checks(struct)

  for i,v in pairs(struct.instructions) do
    if math.random(1,7) == 3 and type(v[1]) ~= 'table' and i < #struct.instructions-1  and not blacklisted_opcodes[v.op] then
      local randconstant = table.list(struct.constants)
      if #randconstant ~= 0 then
      randconstant = randconstant[math.random(#randconstant)].ID
      local registercmp = math.random(struct.stacksize)
      local id = uuid()
      table.insert(struct.instructions,i,{
        ID=id;
        [1] = {
          op=23;
          [1] = 0;
          [2] = registercmp;
          [3] = registercmp;
        };
        [2] = {
          op=22;
          [1] = id;
        }
      })
      end
    end
  end
  for i,v in pairs(struct.protos) do
    add_eq_checks(v)
  end
end

return add_eq_checks
