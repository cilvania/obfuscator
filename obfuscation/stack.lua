local ssfuncs = {}
-- pretty simple function 
function ssfuncs.increment_stack_size(Inst,Amount)
  Amount = Amount or 1
  Inst.stacksize = Inst.stacksize+Amount
  for i,v in pairs(Inst.protos) do
    ssfuncs.increment_stack_size(v,Amount)
  end
end


return ssfuncs