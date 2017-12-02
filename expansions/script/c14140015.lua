--Snow Goose
local m=14140015
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,aux.FilterEqualFunction(Card.GetLevel,10),aux.FilterEqualFunction(Card.GetRank,10),false)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1)
	--special summon rule
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(m*16)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetCondition(cm.spcon)
	e0:SetOperation(cm.spop)
	c:RegisterEffect(e0)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(m*16+1)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,0x1e0)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCost(cm.cost)
	e2:SetTarget(cm.tg1)
	e2:SetOperation(cm.op)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetDescription(m*16+2)
	e3:SetTarget(cm.tg2)
	c:RegisterEffect(e3)
end
function cm.spfilter1(c,tp,fc)
	return c:GetLevel()==10 and c:IsCanBeFusionMaterial(fc)
		and Duel.CheckReleaseGroup(tp,cm.spfilter2,1,c,fc)
end
function cm.spfilter2(c,fc)
	return c:GetRank()==10 and c:IsCanBeFusionMaterial(fc)
end
function cm.mfilter(c)
	return c:IsReleasable() and c:IsOnField()
end
function cm.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local mg=Duel.GetFusionMaterial(tp):Filter(cm.mfilter,nil)
	return c:CheckFusionMaterial(mg,nil,PLAYER_NONE)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local mg=Duel.GetFusionMaterial(tp):Filter(cm.mfilter,nil)
	local g1=Duel.SelectFusionMaterial(tp,f,mg,nil,PLAYER_NONE)
	c:SetMaterial(g1)
	Duel.Release(g1,REASON_COST+REASON_FUSION+REASON_MATERIAL)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	if chk==0 then return Duel.GetFlagEffect(tp,m)==0 end
	Duel.RegisterFlagEffect(tp,m,RESET_CHAIN,0,1)
end
function cm.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		if e:GetLabel()~=1 then return false end
		e:SetLabel(0)
		if not c:IsLocation(LOCATION_MZONE) then return false end
		local seq=c:GetSequence()
		if seq<5 then return false end
		for i=0,4 do
			local tc=Duel.GetFieldCard(1-tp,LOCATION_MZONE,4-i)
			if Duel.CheckLocation(tp,LOCATION_MZONE,i) and tc and tc:IsAbleToHand() then return true end
		end
		return false
	end
	e:SetLabel(0)
	local al=0xff
	for i=0,4 do
		local tc=Duel.GetFieldCard(1-tp,LOCATION_MZONE,4-i)
		if Duel.CheckLocation(tp,LOCATION_MZONE,i) and tc and tc:IsAbleToHand() then al=al-(al & 2^i) end
	end
	Duel.Hint(HINT_SELECTMSG,0,m*16+3)
	local op=Duel.SelectDisableField(tp,1,LOCATION_MZONE,0,al)
	local tseq=math.log(op,2)
	Duel.MoveSequence(c,tseq)
	local tc=Duel.GetFieldCard(1-tp,LOCATION_MZONE,4-tseq)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,tc,1,0,0)
	Duel.SetTargetParam(tseq)
end
function cm.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		if e:GetLabel()~=1 then return false end
		e:SetLabel(0)
		if not c:IsLocation(LOCATION_MZONE) then return false end
		local seq=c:GetSequence()
		if seq>4 then return false end
		if seq>0 then
			local i=seq-1
			local tc=Duel.GetFieldCard(1-tp,LOCATION_MZONE,4-i)
			if Duel.CheckLocation(tp,LOCATION_MZONE,i) and tc and tc:IsAbleToHand() then return true end
		end
		if seq<4 then
			local i=seq+1
			local tc=Duel.GetFieldCard(1-tp,LOCATION_MZONE,4-i)
			if Duel.CheckLocation(tp,LOCATION_MZONE,i) and tc and tc:IsAbleToHand() then return true end
		end
		return false
	end
	e:SetLabel(0)
	local seq=c:GetSequence()
	local al=0xff
	if seq>0 then
		local i=seq-1
		local tc=Duel.GetFieldCard(1-tp,LOCATION_MZONE,4-i)
		if Duel.CheckLocation(tp,LOCATION_MZONE,i) and tc and tc:IsAbleToHand() then al=al-(al & 2^i) end
	end
	if seq<4 then
		local i=seq+1
		local tc=Duel.GetFieldCard(1-tp,LOCATION_MZONE,4-i)
		if Duel.CheckLocation(tp,LOCATION_MZONE,i) and tc and tc:IsAbleToHand() then al=al-(al & 2^i) end
	end
	Duel.Hint(HINT_SELECTMSG,0,m*16+3)
	local op=Duel.SelectDisableField(tp,1,LOCATION_MZONE,0,al)
	local tseq=math.log(op,2)
	Duel.MoveSequence(c,tseq)
	local tc=Duel.GetFieldCard(1-tp,LOCATION_MZONE,4-tseq)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,tc,1,0,0)
	Duel.SetTargetParam(tseq)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local tseq=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	local tc=Duel.GetFieldCard(1-tp,LOCATION_MZONE,4-tseq)
	if tc then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end