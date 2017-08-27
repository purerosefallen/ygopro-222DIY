--★人を食い殺す寄生獣（パラサイト）
function c114100357.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(114100357,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SPSUM_PARAM)
	e1:SetRange(LOCATION_HAND)
	e1:SetTargetRange(POS_FACEUP,1)
	e1:SetCondition(c114100357.spcon)
	e1:SetOperation(c114100357.spop)
	c:RegisterEffect(e1)	
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(114100357,1))
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_HAND)
	e2:SetCondition(c114100357.spcon2)
	e2:SetOperation(c114100357.spop2)
	c:RegisterEffect(e2)	
	--summon limit
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_SPSUMMON_COST)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e4:SetCost(c114100357.spcost)
	e4:SetOperation(c114100357.spcop)
	c:RegisterEffect(e4)
	--before check
	if not c114100357.global_check then
		c114100357.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge1:SetOperation(c114100357.checkop)
		Duel.RegisterEffect(ge1,0)
		local ge2=ge1:Clone()
		ge2:SetCode(EVENT_SUMMON_SUCCESS)
		Duel.RegisterEffect(ge2,0)
	end
end
--Define
c114100357.Parasite=1
--sp con check
function c114100357.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	local p1=false
	local p2=false
	while tc do
		if not tc:IsSetCard(0x221) then
			if tc:GetSummonPlayer()==0 then p1=true else p2=true end
		end
		tc=eg:GetNext()
	end
	if p1 then Duel.RegisterFlagEffect(0,114100357,RESET_PHASE+PHASE_END,0,1) end
	if p2 then Duel.RegisterFlagEffect(1,114100357,RESET_PHASE+PHASE_END,0,1) end
end
--sp1
function c114100357.IsKeyT(c,f,v)
	local f=f or Card.GetCode
	local t={f(c)}
	for i,code in pairs(t) do
		local m=_G["c"..code]
		if m and m.Parasite then return true end --and (not v or m.XiangYuan_name_keyrune==v)
	end
	return false
end
function c114100357.gfilter(c)
	return c:IsAbleToGraveAsCost() and not c114100357.IsKeyT(c)
end
function c114100357.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(1-c:GetControler(),LOCATION_MZONE)>-1
		and Duel.IsExistingMatchingCard(c114100357.gfilter,c:GetControler(),0,LOCATION_MZONE,1,nil)
end
function c114100357.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c114100357.gfilter,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
	c114100357.setpower(c,g)
end
--sp2
function c114100357.spcon2(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>-1
		and Duel.IsExistingMatchingCard(c114100357.gfilter,c:GetControler(),LOCATION_MZONE,0,1,nil)
end
function c114100357.spop2(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c114100357.gfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
	c114100357.setpower(c,g)
end
--set atk/def
function c114100357.setpower(c,g)
	local atk=g:GetFirst():GetBaseAttack()
	local def=g:GetFirst():GetBaseDefense()
	if atk<0 then atk=0 end
	if def<0 then def=0 end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetReset(RESET_EVENT+0xff0000)
	e1:SetCode(EFFECT_SET_ATTACK)
	e1:SetValue(atk+500)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_SET_DEFENSE)
	e2:SetValue(def+500)
	c:RegisterEffect(e2)
end
--sp limit
function c114100357.spcost(e,c,tp)
	return Duel.GetFlagEffect(c:GetControler(),114100357)==0
end
function c114100357.spcop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c114100357.sumlimit)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_SUMMON)
	Duel.RegisterEffect(e2,tp)
end
function c114100357.sumlimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsSetCard(0x221)
end