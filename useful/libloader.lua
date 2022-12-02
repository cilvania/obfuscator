

  local libs = {'file','string','math','table','uuid','inspect','kek',}
  for iterator,libname in pairs(libs) do
    require('useful/extralibs/'..libname)
  end
 
 
 return nil

