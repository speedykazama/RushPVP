-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
SERVER = IsDuplicityVersion()
-----------------------------------------------------------------------------------------------------------------------------------------
-- CLASSWORK
-----------------------------------------------------------------------------------------------------------------------------------------
function ClassWork(WorkName)
    return Work[WorkName] or "Nenhum"
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- DISCATEGORY
-----------------------------------------------------------------------------------------------------------------------------------------
function ClassCategory(Number)
	local Level = 1

	if Number >= 250 and Number <= 500 then
		Level = 2
	elseif Number >= 501 and Number <= 1000 then
		Level = 3
	elseif Number >= 1001 and Number <= 2000 then
		Level = 4
	elseif Number >= 2001 and Number <= 3500 then
		Level = 5
	elseif Number >= 3501 and Number <= 5000 then
		Level = 6
	elseif Number >= 5001 and Number <= 7500 then
		Level = 7
	elseif Number >= 7501 and Number <= 10000 then
		Level = 8
	elseif Number >= 10001 and Number <= 15000 then
		Level = 9
	elseif Number >= 15001 then
		Level = 10
	end

	return Level
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- SANGUINE
-----------------------------------------------------------------------------------------------------------------------------------------
function Sanguine(Number)
    return Types[Number]
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- TABLE.MAXN
-----------------------------------------------------------------------------------------------------------------------------------------
function table.maxn(Table)
	local Number = 0

	for Index,_ in pairs(Table) do
		local Next = tonumber(Index)
		if Next and Next > Number then
			Number = Next
		end
	end

	return Number
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- COUNTTALBE
-----------------------------------------------------------------------------------------------------------------------------------------
function CountTable(Table)
	local Number = 0

	for _,v in pairs(Table) do
		Number = Number + 1
	end

	return Number
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- MODULE
-----------------------------------------------------------------------------------------------------------------------------------------
local modules = {}
function module(Resource,patchs)
	if not patchs then
		patchs = Resource
		Resource = "vrp"
	end

	local key = Resource..patchs
	local checkModule = modules[key]
	if checkModule then
		return checkModule
	else
		local code = LoadResourceFile(Resource,patchs..".lua")
		if code then
			local floats = load(code,Resource.."/"..patchs..".lua")
			if floats then
				local resAccept,resUlts = xpcall(floats,debug.traceback)
				if resAccept then
					modules[key] = resUlts
					return resUlts
				end
			end
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- WAIT
-----------------------------------------------------------------------------------------------------------------------------------------
local function wait(self)
	local rets = Citizen.Await(self.p)
	if not rets then
		if self.r then
			rets = self.r
		end
	end

	return table.unpack(rets,1,table.maxn(rets))
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- ARETURN
-----------------------------------------------------------------------------------------------------------------------------------------
local function areturn(self,...)
	self.r = {...}
	self.p:resolve(self.r)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- ASYNC
-----------------------------------------------------------------------------------------------------------------------------------------
function async(func)
	if func then
		Citizen.CreateThreadNow(func)
	else
		return setmetatable({ wait = wait, p = promise.new() },{ __call = areturn })
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PARSEINT
-----------------------------------------------------------------------------------------------------------------------------------------
function parseInt(Value)
	local Result = 0
	local Number = tonumber(Value)

	if Number and Number > 0 then
		Result = math.floor(Number)
	end

	return Result
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- SANITIZESTRING
-----------------------------------------------------------------------------------------------------------------------------------------
local sanitize_tmp = {}
function sanitizeString(str,strchars,allow_policy)
	local r = ""
	local chars = sanitize_tmp[strchars]
	if not chars then
		chars = {}
		local size = string.len(strchars)
		for i = 1,size do
			local char = string.sub(strchars,i,i)
			chars[char] = true
		end

		sanitize_tmp[strchars] = chars
	end

	size = string.len(str)
	for i = 1,size do
		local char = string.sub(str,i,i)
		if (allow_policy and chars[char]) or (not allow_policy and not chars[char]) then
			r = r..char
		end
	end

	return r
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- SPLITSTRING
-----------------------------------------------------------------------------------------------------------------------------------------
function splitString(Full,Symbol)
	local Table = {}

	if not Symbol then
		Symbol = "-"
	end

	for Full in string.gmatch(Full,"([^"..Symbol.."]+)") do
		Table[#Table + 1] = Full
	end

	return Table
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- SPLITONE
-----------------------------------------------------------------------------------------------------------------------------------------
function SplitOne(Name,Symbol)
	if not Symbol then
		Symbol = "-"
	end

	return splitString(Name,Symbol)[1]
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- SPLITTWO
-----------------------------------------------------------------------------------------------------------------------------------------
function SplitTwo(Name,Symbol)
	if not Symbol then
		Symbol = "-"
	end

	return splitString(Name,Symbol)[2]
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- MATHLEGTH
-----------------------------------------------------------------------------------------------------------------------------------------
function mathLength(Number)
	return math.ceil(Number * 100) / 100
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PARSEFORMAT
-----------------------------------------------------------------------------------------------------------------------------------------
function parseFormat(Value)
	local Value = parseInt(Value)
	local Left,Number,Right = string.match(Value,"^([^%d]*%d)(%d*)(.-)$")
	return Left..(Number:reverse():gsub("(%d%d%d)","%1."):reverse())..Right
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- COMPLETETIMERS
-----------------------------------------------------------------------------------------------------------------------------------------
function CompleteTimers(Seconds)
	local Days = math.floor(Seconds / 86400)
	Seconds = Seconds - Days * 86400
	local Hours = math.floor(Seconds / 3600)
	Seconds = Seconds - Hours * 3600
	local Minutes = math.floor(Seconds / 60)
	Seconds = Seconds - Minutes * 60

	if Days > 0 then
		return string.format("<b>%d Dias</b>, <b>%d Horas</b>, <b>%d Minutos</b>",Days,Hours,Minutes)
	elseif Hours > 0 then
		return string.format("<b>%d Horas</b>, <b>%d Minutos</b> e <b>%d Segundos</b>",Hours,Minutes,Seconds)
	elseif Minutes > 0 then
		return string.format("<b>%d Minutos</b> e <b>%d Segundos</b>",Minutes,Seconds)
	elseif Seconds > 0 then
		return string.format("<b>%d Segundos</b>",Seconds)
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- MINIMALTIMERS
-----------------------------------------------------------------------------------------------------------------------------------------
function MinimalTimers(Seconds)
	local Days = math.floor(Seconds / 86400)
	Seconds = Seconds - Days * 86400
	local Hours = math.floor(Seconds / 3600)
	Seconds = Seconds - Hours * 3600
	local Minutes = math.floor(Seconds / 60)
	Seconds = Seconds - Minutes * 60

	if Days > 0 then
		return string.format("%d Dias, %d Horas",Days,Hours)
	elseif Hours > 0 then
		return string.format("%d Horas, %d Minutos",Hours,Minutes)
	elseif Minutes > 0 then
		return string.format("%d Minutos",Minutes)
	elseif Seconds > 0 then
		return string.format("%d Segundos",Seconds)
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- NUMBERZERO
-----------------------------------------------------------------------------------------------------------------------------------------
function NumberZero(Number)
	if Number <= 9 then
		return "0"..Number
	end

	return Number
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- NUMBERTIMERS
-----------------------------------------------------------------------------------------------------------------------------------------
function NumberTimers(Seconds)
	local Days = math.floor(Seconds / 86400)
	Seconds = Seconds - Days * 86400
	local Hours = math.floor(Seconds / 3600)
	Seconds = Seconds - Hours * 3600
	local Minutes = math.floor(Seconds / 60)
	Seconds = Seconds - Minutes * 60

	return NumberZero(Days)..":"..NumberZero(Hours)..":"..NumberZero(Minutes)..":"..NumberZero(Seconds)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- BONE
-----------------------------------------------------------------------------------------------------------------------------------------
function Bone(Number)
	return Bones[Number] or false
end