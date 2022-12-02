local function set(list) 
  local t = {}
  for i,v in pairs(list) do
    t[v] = i
  end
  return t
end
local function list(tx)
  local t = {}
  local count = 1
  for i,v in pairs(tx) do
    t[count] = v
    count = count+1
  end
  return t
end

table.list = list
table.set = set