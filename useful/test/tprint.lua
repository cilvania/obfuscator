function tview(t)
	local function tsize(t)
		local x =0
		for i,v in pairs(t) do x=x+1 end
		return x
	end
	local seperator = '   '
	local function format_data(data)
		local d_type = type(data)
		if d_type == '' then
			local str = string.format("'%s'",data):gsub("\n",'\\n')
			return str
		end
		return tostring(data)
	end
	local function table_serialize(t,sep,u)
		local str = '{\n'
		for iterator,value in next,t,nil do
			if type(value) ~= 'table' then
				str = str..string.format("%s[%s] = %s;\n",sep,format_data(iterator),format_data(value))
			elseif type(value) == 'table' then
				if tsize(value) <1 then
					str = str..string.format("%s[%s] = {  };\n",sep,format_data(iterator))
				elseif tsize(value) >0 then
					str = str..string.format('%s[%s] = %s; \n',sep,format_data(iterator),table_serialize(value,sep..seperator,true),tostring(value))
				end
			end
		end
		str = str..string.format('%s}',((u and sep:sub(1,#sep-#seperator)) or ''))
		return str
	end
	return table_serialize(t,seperator)
end


return tview
