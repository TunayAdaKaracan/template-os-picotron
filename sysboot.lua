--[[pod_format="raw",created="2024-07-15 15:11:54",modified="2024-07-16 13:44:06",revision=13]]
_apply_system_settings(_fetch_local("/appdata/system/settings.pod") or {})

local head_func, err = load(fetch("/system/syslib/core.lua"))
if (not head_func) _printh("** could not load head ** "..err)
head_func()


_printh("Creating pm")
create_process("/system/managers/pm.lua")

_printh("Creating wm")
create_process("/system/managers/wm.lua")
_signal(37)

local timer = time()
local ticker = 0
last = 0
while true do
	if time() - timer > 1 then
		_printh(ticker)
		ticker = 0
		timer = time()
		
	else
		ticker += 1
	end
	_run_process_slice(2, .4)
	_run_process_slice(3, .4)
	_run_process_slice(3, .4)
	flip()
end