os=require("os")
io=require("io")
--globals
local main={}
local extra={}

local main_monster={}
local main_spell={}
local main_trap={}

local extra_sp={
	[TYPE_FUSION]={},
	[TYPE_SYNCHRO]={},
	[TYPE_XYZ]={},
	[TYPE_LINK]={},
}

local forbidden_check={}
local limited_check={}
local semi_limited_check={}

local forbidden={}
local limited={}
local semi_limited={}

function Auxiliary.LoadLFList()
	local started=false
	for line in io.lines("lflist.conf") do
		if line:find("!") then
			if started then
				break
			else
				started=true
			end
		elseif started then
			local fstart=line:find(" 0")
			local lstart=line:find(" 1")
			local sstart=line:find(" 2")
			if fstart then
				local code=tonumber(line:sub(1,fstart-1))
				if code then forbidden_check[code]=true end
			elseif lstart then
				local code=tonumber(line:sub(1,lstart-1))
				if code then limited_check[code]=true end
			elseif sstart then
				local code=tonumber(line:sub(1,sstart-1))
				if code then semi_limited_check[code]=true end
			end
		end
	end
end
function Auxiliary.LoadDB()
	os.execute("sqlite3 2pick/2pick.cdb < 2pick/sqlite_cmd.txt")
	for line in io.lines("card_list.txt") do
		local col=line:find("|")
		local code=tonumber(line:sub(1,col-1))
		local cat=tonumber(line:sub(col+1,#line))
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
			elseif (cat & TYPE_SPELL)>0 then
				table.insert(main_spell,code)
			elseif (cat & TYPE_TRAP)>0 then
				table.insert(main_trap,code)
			end
			table.insert(main,code)
			if forbidden_check[code] then
				table.insert(forbidden,code)
			elseif limited_check[code] then
				table.insert(limited,code)
			elseif semi_limited_check[code] then
				table.insert(semi_limited,code)			
			end
		end
	end
end

function Auxiliary.SaveDeck()
	for p=0,1 do
		local g=Duel.GetFieldGroup(p,0xff,0)
		Duel.SavePickDeck(p,g)
	end
end
function Auxiliary.SinglePick(p,list,count)
	if not Duel.IsPlayerNeedToPickDeck(p) then return end
	local g1=Group.CreateGroup()
	local g2=Group.CreateGroup()
	for _,g in ipairs({g1,g2}) do
		for i=1,count do
			local code=list[math.random(#list)]
			g:AddCard(Duel.CreateToken(p,code))
		end
		Duel.SendtoDeck(g,nil,0,REASON_RULE)
	end
	local sg=g1:Clone()
	sg:Merge(g2)
	--Duel.ConfirmCards(p,sg)
	Duel.Hint(HINT_SELECTMSG,p,HINTMSG_TODECK)
	local sc=sg:Select(p,1,1,nil):GetFirst()
	--local tg=g1:IsContains(sc) and g1 or g2
	local rg=g1:IsContains(sc) and g2 or g1
	--Duel.SendtoDeck(tg,p,0,REASON_RULE)
	Duel.Exile(rg,REASON_RULE)
end

function Auxiliary.SinglePickForMain(p,list,count)
	if not Duel.IsPlayerNeedToPickDeck(p) then return end
	local g1=Group.CreateGroup()
	local g2=Group.CreateGroup()
	for _,g in ipairs({g1,g2}) do
		for i=1,count do
			local code=list[math.random(#list)]
			g:AddCard(Duel.CreateToken(p,code))
		end
		Duel.SendtoDeck(g,nil,0,REASON_RULE)
	end
	local sg=g1:Clone()
	sg:Merge(g2)
	--Duel.ConfirmCards(p,sg)
	Duel.Hint(HINT_SELECTMSG,p,HINTMSG_TODECK)
	local sc=sg:Select(p,1,1,nil):GetFirst()
	local tg=g1:IsContains(sc) and g1 or g2
	local rg=g1:IsContains(sc) and g2 or g1
	--Duel.SendtoDeck(tg,p,0,REASON_RULE)
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
		local list=main_monster
		if i==4 then
			list=main_spell
		elseif i==5 then
			list=main_trap
		end
		for p=0,1 do
			Auxiliary.SinglePickForMain(p,list,4)
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
	--[[Card.IsSetCard=Auxiliary.TRUE
	Card.IsOriginalSetCard=Auxiliary.TRUE
	Card.IsFusionSetCard=Auxiliary.TRUE
	Card.IsLinkSetCard=Auxiliary.TRUE]]

	Auxiliary.LoadLFList()
	Auxiliary.LoadDB()

	--[[local e2=Effect.GlobalEffect()
	e2:SetDescription(1264319*16)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetValue(SUMMON_TYPE_FUSION)
	e2:SetCondition(Auxiliary.FusionSummonCondition)
	e2:SetOperation(Auxiliary.FusionSummonOperation)
	local e1=Effect.GlobalEffect()
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE | EFFECT_FLAG_SET_AVAILABLE)
	e1:SetTargetRange(LOCATION_EXTRA,LOCATION_EXTRA)
	e1:SetLabelObject(e2)
	e1:SetTarget(function(e,c) return c:IsType(TYPE_FUSION) end)
	Duel.RegisterEffect(e1,0)
	local e1=Effect.GlobalEffect()
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_ADD_TYPE)
	e1:SetProperty(EFFECT_FLAG_IGNORE_RANGE | EFFECT_FLAG_IGNORE_IMMUNE | EFFECT_FLAG_SET_AVAILABLE)
	e1:SetTargetRange(0xff,0xff)
	e1:SetValue(TYPE_TUNER)
	e1:SetTarget(function(e,c) return c:IsType(TYPE_MONSTER) end)
	Duel.RegisterEffect(e1,0)
	local e1=Effect.GlobalEffect()
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_NONTUNER)
	e1:SetProperty(EFFECT_FLAG_IGNORE_RANGE | EFFECT_FLAG_IGNORE_IMMUNE | EFFECT_FLAG_SET_AVAILABLE)
	e1:SetTargetRange(0xff,0xff)
	e1:SetValue(1)
	Duel.RegisterEffect(e1,0)
	local e1=Effect.GlobalEffect()
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_ADD_RACE)
	e1:SetProperty(EFFECT_FLAG_IGNORE_RANGE | EFFECT_FLAG_IGNORE_IMMUNE | EFFECT_FLAG_SET_AVAILABLE)
	e1:SetTargetRange(0xff,0xff)
	e1:SetValue(RACE_ALL)
	Duel.RegisterEffect(e1,0)
	local e1=Effect.GlobalEffect()
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_ADD_ATTRIBUTE)
	e1:SetProperty(EFFECT_FLAG_IGNORE_RANGE | EFFECT_FLAG_IGNORE_IMMUNE | EFFECT_FLAG_SET_AVAILABLE)
	e1:SetTargetRange(0xff,0xff)
	e1:SetValue(0x7f)
	Duel.RegisterEffect(e1,0)]]
	local e1=Effect.GlobalEffect()
	e1:SetType(EFFECT_TYPE_FIELD | EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_ADJUST)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetOperation(Auxiliary.StartPick)
	Duel.RegisterEffect(e1,0)
end
function Auxiliary.FusionSummonCondition(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local mg=Duel.GetFusionMaterial(tp):Filter(Card.IsOnField,nil)
	return c:CheckFusionMaterial(mg,nil,tp)
end
function Auxiliary.FusionSummonOperation(e,tp,eg,ep,ev,re,r,rp,c)
	local mg=Duel.GetFusionMaterial(tp):Filter(Card.IsOnField,nil)
	local g=Duel.SelectFusionMaterial(tp,c,mg,nil,tp)
	c:SetMaterial(g)
	Duel.SendtoGrave(g,REASON_MATERIAL+REASON_FUSION)
end
