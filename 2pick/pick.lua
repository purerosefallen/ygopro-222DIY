os=require("os")
io=require("io")
--globals
local main={}
local extra={}

local main_monster={}
local main_spell={}
local main_trap={}

local main_plain={}
local main_adv={}

local extra_sp={
	[TYPE_FUSION]={},
	[TYPE_SYNCHRO]={},
	[TYPE_XYZ]={},
	[TYPE_LINK]={},
}

function Auxiliary.SplitData(inputstr)
	local t={}
	for str in string.gmatch(inputstr,"([^|]+)") do
		table.insert(t,tonumber(str))
	end
	return t
end
function Auxiliary.LoadDB()
	os.execute("sqlite3 2pick/2pick.cdb < 2pick/sqlite_cmd.txt")
	for line in io.lines("card_list.txt") do
		local data=Auxiliary.SplitData(line)
		local code=data[1]
		local cat=data[5]
		local lv=data[8]
		if (cat & TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ+TYPE_LINK)>0 then
			table.insert(extra,code)
			for tp,list in pairs(extra_sp) do
				if (cat & tp)>0 then
					table.insert(list,code)
				end
			end
		elseif (cat & TYPE_TOKEN)==0 then
			if (cat & TYPE_MONSTER)>0 then
				table.insert(main_monster,code)
				if lv>5 then
					table.insert(main_adv,code)
				else
					table.insert(main_plain,code)				
				end
			elseif (cat & TYPE_SPELL)>0 then
				table.insert(main_spell,code)
			elseif (cat & TYPE_TRAP)>0 then
				table.insert(main_trap,code)
			end
			table.insert(main,code)
		end
	end
end

function Auxiliary.SaveDeck()
	for p=0,1 do
		local g=Duel.GetFieldGroup(p,0xff,0)
		Duel.SavePickDeck(p,g)
	end
end
function Auxiliary.SinglePick(p,list,count,ex_list,ex_count)
	if not Duel.IsPlayerNeedToPickDeck(p) then return end
	local g1=Group.CreateGroup()
	local g2=Group.CreateGroup()
	for _,g in ipairs({g1,g2}) do
		for i=1,count do
			local code=list[math.random(#list)]
			g:AddCard(Duel.CreateToken(p,code))
		end
		if ex_list and ex_count then
			for i=1,ex_count do
				local code=ex_list[math.random(#ex_list)]
				g:AddCard(Duel.CreateToken(p,code))
			end
		end
		Duel.SendtoDeck(g,nil,0,REASON_RULE)
	end
	local sg=g1:Clone()
	sg:Merge(g2)
	Duel.ResetTimeLimit(p,60)
	Duel.Hint(HINT_SELECTMSG,p,HINTMSG_TODECK)
	local sc=sg:Select(p,1,1,nil):GetFirst()
	local rg=g1:IsContains(sc) and g2 or g1
	Duel.Exile(rg,REASON_RULE)
end

function Auxiliary.SinglePickForMain(p,list,count,ex_list,ex_count)
	if not Duel.IsPlayerNeedToPickDeck(p) then return end
	local g1=Group.CreateGroup()
	local g2=Group.CreateGroup()
	for _,g in ipairs({g1,g2}) do
		for i=1,count do
			local code=list[math.random(#list)]
			g:AddCard(Duel.CreateToken(p,code))
		end
		if ex_list and ex_count then
			for i=1,ex_count do
				local code=ex_list[math.random(#ex_list)]
				g:AddCard(Duel.CreateToken(p,code))
			end
		end
		Duel.SendtoDeck(g,nil,0,REASON_RULE)
	end
	local sg=g1:Clone()
	sg:Merge(g2)
	Duel.ResetTimeLimit(p,60)
	Duel.Hint(HINT_SELECTMSG,p,HINTMSG_TODECK)
	local sc=sg:Select(p,1,1,nil):GetFirst()
	local tg=g1:IsContains(sc) and g1 or g2
	local rg=g1:IsContains(sc) and g2 or g1
	Duel.Exile(rg,REASON_RULE)
	local g3=Group.CreateGroup()
	for nc in aux.Next(tg) do
		local copy_code=nc:GetOriginalCode()
		g3:AddCard(Duel.CreateToken(p,copy_code))
	end
	Duel.SendtoDeck(g3,nil,0,REASON_RULE)
end

function Auxiliary.StartPick(e)
	math.randomseed(os.time())
	for p=0,1 do
		if Duel.IsPlayerNeedToPickDeck(p) then
			local g=Duel.GetFieldGroup(p,0xff,0)
			Duel.Exile(g,REASON_RULE)
		end
	end
	for i=1,5 do
		local list=main_plain
		local count=4
		local ex_list=nil
		local ex_count=nil
		if i<3 then
			count=3
			ex_list=main_adv
			ex_count=1
		elseif i==4 then
			list=main_spell
		elseif i==5 then
			list=main_trap
		end
		for p=0,1 do
			Auxiliary.SinglePickForMain(p,list,count,ex_list,ex_count)
		end
	end
	for tp,list in pairs(extra_sp) do
		if tp~=TYPE_FUSION then
			for p=0,1 do
				Auxiliary.SinglePick(p,list,4)
			end
		end
	end
	for i=1,2 do
		for p=0,1 do
			Auxiliary.SinglePick(p,extra,4)
		end
	end
	Auxiliary.SaveDeck()
	for p=0,1 do
		if Duel.IsPlayerNeedToPickDeck(p) then
			Duel.ShuffleDeck(p)
			Duel.ResetTimeLimit(p)
		end
	end
	for p=0,1 do
		Duel.Draw(p,Duel.GetStartCount(p),REASON_RULE)
	end
	e:Reset()
end

function Auxiliary.Load2PickRule()
	Auxiliary.LoadDB()
	local e1=Effect.GlobalEffect()
	e1:SetType(EFFECT_TYPE_FIELD | EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_ADJUST)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetOperation(Auxiliary.StartPick)
	Duel.RegisterEffect(e1,0)
end
