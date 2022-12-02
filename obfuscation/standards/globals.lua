local globals_lib = {}
--[[THIS FILE WAS ORIGINALLY MADE FOR USING A GETFENV() TABLE TO GET AND SET GLOBALS, BUT THAT METHOD WAS SLOW FOR PERFORMANCE, SO NOW THIS FILE IS USED TO REPLACE NON PRE DEFINED GLOBALS WITH RANDOM NAMES FOR EX:
  sex()
BECOMES:
  HwXJNALGNYEHAidokcdOIIiiI1lIl1()

BUT THINGS LIKE:
  print()
DO NOT BECOME:
  HwXJNALGNYEHAidokcdOIIiiI1lIl1()
THEY ARE DEFINED IN THE CURRENT ENVIRONMENT AND THEREFOR ARE NOT REPLACED
]]
function globals_lib.modify_closure_creation(struct)
	local protos = struct.protos
	for iterator,instruction in ipairs(struct.instructions) do
		local opcode = instruction.op

		if opcode == 36 then
			local proto = struct.protos[instruction[2]+1]
			local upvalues = proto.nups

			table.insert(struct.instructions,iterator+upvalues+1,{
				op=0;
				[1] = 0;
				[2] = 1;
				no_inc = {
					b=true;
				}
			})
			struct.protos[instruction[2]+1].nups = proto.nups+1
		end
	end
end
function globals_lib.insert_header(struct)
	local globalregister = 1
	local getglobal_inst = {
		op=5;
		[1] = 0;
		[2] = kek.constant(struct,"getfenv\0");
		ID=uuid();
		gbl_made=true;
		noshift = true
	}
	local call_inst = {
		op=28;
		[1] = 0;
		[2] = 1;
		[3] = 2;
		ID=uuid();
		gbl_made=true;
		noshift = true
	}
	local move_inst = {
		op=0;
		[1] = globalregister;
		[2] = 0;
		ID=uuid();
		gbl_made=true;
		noshift = true
	}
	struct.stacksize = struct.stacksize+1
	table.insert(struct.instructions,1,move_inst)
	table.insert(struct.instructions,1,call_inst)
	table.insert(struct.instructions,1,getglobal_inst)
	local function insert_sub_header(p)
		table.insert(p.instructions,1,{
			op=4;
			[1] = globalregister;
			[2] = p.nups-1;
			ID=uuid();
			no_inc = {
				a=true;
			}
		})
		for i,v in pairs(p.protos) do
			insert_sub_header(v);
		end
	end
	for i,v in pairs(struct.protos) do
		insert_sub_header(v);
	end
end

local function gen_len_str(len)
	math.randomseed(os.time()+(os.clock()*10000))
	local charset = {'i','l','I','1'}
	local str=''
	for i=1,len do
		str = str..charset[math.random(#charset)]
	end
	return string.random()..str..'\0'
end

function globals_lib.modify_global_names(struct,tracking)

  
	local reserved = {unpack(getfenv())}
  local reserved_extr = {'syn_websocket_close','firesignal','makefolder','syn_io_append','is_protosmasher_caller','clonefunction','setrawmetatable','syn_mouse2press','debug','syn_io_delfolder','getrawmetatable','getinstancefromstate','syn_io_makefolder','gethiddenprop','setfflag','gethiddenprops','getcallingscript','sethiddenprop','getrenv','syn_crypt_b64_encode','get_instances','newcclosure','gethiddenproperties','getspecialinfo','isluau','shared','cloneref','decompile','loadstring','getprotos','syn_io_isfolder','hookfunction','isfile','getproto','print','isrbxactive','rconsoleinfo','make_readonly','getstack','rconsolename','unlockmodulescript','getupvalue','syn_getgc','syn_mouse2release','getfuncs','setproto','mouse1click','syn_io_read','setupvalue','syn_io_delfile','gethiddenproperty','identifyexecutor','getscripts','printx','rconsoleerr','dumpstring','keypress','syn_mousescroll','syn_getinstances','syn_mouse1click','get_scripts','rconsoleclear','getlocals','is_redirection_enabled','syn_context_set','syn_keyrelease','syn_io_listdir','isreadonly','rconsoleprint','mouse2click','getinfo','sethiddenproperty','writefile','warn','loadfile','getproperties','getconstant','getprops','syn_setfflag','require','setscriptable','get_nil_instances','getnilinstances','is_synapse_function','getscriptclosure','bit','getconnections','checkcaller','syn','setclipboard','getupvalues','syn_decompile','setsimulationradius','setreadonly','firetouchinterest','syn_getsenv','syn_io_isfile','syn_crypt_encrypt','getstates','mouse2press','syn_mouse1press','setconstant','validfgwindow','saveinstance','getinstances','getconstants','getloadedmodules','getgenv','syn_keypress','_G','messagebox','isnetworkowner','Drawing','delfile','mouse1release','get_loaded_modules','setnamecallmethod','syn_getreg','syn_dumpstring','syn_mousemoverel','replaceclosure','syn_getloadedmodules','syn_crypt_random','get_calling_script','XPROTECT','delfolder','syn_getcallingscript','keyrelease','appendfile','syn_islclosure','isfolder','listfiles','readfile','mousescroll','getcallstack','syn_websocket_connect','syn_crypt_hash','mousemoveabs','is_protosmasher_closure','syn_checkcaller','syn_mouse2click','mousemoverel','syn_mouse1release','mouse2release','getpcdprop','islclosure','rconsolewarn','getstateenv','syn_clipboard_set','syn_crypt_decrypt','readbinarystring','mouse1press','syn_getmenv','syn_crypt_b64_decode','syn_crypt_derive','syn_getrenv','getpropvalue','syn_newcclosure','syn_getgenv','getnamecallmethod','getgc','is_lclosure','getpointerfromstate','hookfunc','setfpscap','getsenv','syn_mousemoveabs','setpropvalue','rconsoleinputasync','getlocal','make_writeable','fireclickdetector','printconsole','rconsoleinput','getmenv','getreg','syn_io_write','setlocal','messageboxasync','setstack','iswindowactive','syn_websocket_send','syn_context_get','syn_isactive','DockWidgetPluginGuiInfo','userdata: 0x00000000cd624d9c','warn','CFrame','gcinfo','os','tick','userdata: 0x00000000ae6e244c','bit32','userdata: 0x000000003ecdc9bc','pairs','NumberSequence','assert','tonumber','userdata: 0x000000004e5dad34','Color3','debug','userdata: 0x000000005544d634','Enum','Delay','userdata: 0x00000000c40c9ebc','userdata: 0x000000005b7da524','Stats','ColorSequence','settings','userdata: 0x0000000041d85374','_G','userdata: 0x000000003529635c','stats','userdata: 0x000000005b84069c','userdata: 0x00000000a9a5ee6c','UserSettings','userdata: 0x0000000036b6b044','userdata: 0x00000000e95be34c','userdata: 0x00000000a4c02194','coroutine','userdata: 0x00000000467020ac','NumberRange','getmetatable','PhysicalProperties','userdata: 0x0000000022b04464','userdata: 0x00000000916e0344','PluginManager','userdata: 0x00000000c2c6402c','RaycastParams','Ray','NumberSequenceKeypoint','Version','Vector2','unpack','Game','delay','spawn','ypcall','string','CellId','Workspace','version','userdata: 0x000000001020b86c','print','PluginDrag','userdata: 0x000000008f8d9a94','loadstring','UDim2','table','TweenInfo','printidentity','require','Vector3','Wait','Vector3int16','setmetatable','next','wait','Instance','elapsedTime','ipairs','time','shared','rawequal','Vector2int16','collectgarbage','game','newproxy','Spawn','xpcall','Region3','utf8','CatalogSearchParams','tostring','rawset','PathWaypoint','DateTime','Random','typeof','workspace','userdata: 0x000000008c3f4fa4','math','getfenv','pcall','ColorSequenceKeypoint','userdata: 0x000000004f9d403c','type','Region3int16','ElapsedTime','select','userdata: 0x000000009f4d1ffc','_VERSION','rawget','Faces','Rect','BrickColor','setfenv','UDim','Axes','error','userdata: 0x000000009dff05cc','string','io'}

  for i,v in pairs(reserved_extr) do reserved[v] = true end
	tracking = tracking or {}
	for iterator,instruction in ipairs(struct.instructions) do
		if type(instruction[1]) ~= 'table' and (instruction.op == 5 or instruction.op == 7) then
      local constant = struct.constants[instruction[2]]
      if reserved[constant.Value:sub(1,-2)]==nil and not tracking[constant.Value] then
        tracking[constant.Value] = gen_len_str(10)
        struct.instructions[iterator][2] = kek.constant(struct,tracking[constant.Value])
      end
      if not reserved[constant.Value:sub(1,-2)] and tracking[constant.Value] then
        struct.instructions[iterator][2] = kek.constant(struct,tracking[constant.Value])
      end
		end
	end
  for i,v in pairs(struct.protos) do
    globals_lib.modify_global_names(v,tracking)
  end
end



function globals_lib.modify_globals(struct)
  globals_lib.modify_global_names(struct)
	if not struct.info.globalregister then struct.info.globalregister = 1 end
	--globals_lib.modify_closure_creation(struct) --clumps closure and upvalue moving together etc etc, yeah
  --[[	globals_lib.insert_header(struct)
	local function modify_instructions(p)
		for iterator,instruction in ipairs(p.instructions) do
			if instruction.op == 5 and not instruction.gbl_made then
				p.instructions[iterator] = {
					op=6;
					[1]=instruction[1];
					[2]=struct.info.globalregister;
					[3]=instruction[2];
					no_inc = {
						b=true;
					}
				}
			elseif instruction.op == 7 and not instruction.gbl_made then
				p.instructions[iterator] = {
					op=9;
					[1]=struct.info.globalregister;
					[2]=instruction[2];
					[3]=instruction[1];
					no_inc = {
						a=true;
					}
				}
			end
		end
	end
	for i,v in pairs(struct.protos) do
		modify_instructions(v)
	end
	modify_instructions(struct)]]
end




return globals_lib
