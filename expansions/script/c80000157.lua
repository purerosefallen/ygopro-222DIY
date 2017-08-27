--超古代口袋妖怪 原始盖欧卡
function c80000157.initial_effect(c)
	if c:IsStatus(STATUS_COPYING_EFFECT) then return end
	--xyz summon
	aux.AddXyzProcedure(c,nil,11,5,c80000157.ovfilter,aux.Stringid(80000157,0),5,c80000157.xyzop)
	c:EnableReviveLimit()   
	--spsummon limit
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c80000157.splimit)
	c:RegisterEffect(e1) 
	--Attribute Dark
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetCode(EFFECT_ADD_ATTRIBUTE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(ATTRIBUTE_WATER)
	c:RegisterEffect(e3)	
	--wudi 
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE)
	e8:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e8:SetRange(LOCATION_MZONE)
	e8:SetCode(EFFECT_IMMUNE_EFFECT)
	e8:SetValue(c80000157.efilter)
	c:RegisterEffect(e8) 
	--Activate
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(c80000157.target)
	e2:SetOperation(c80000157.activate)
	c:RegisterEffect(e2)
	--disable
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EVENT_CHAIN_ACTIVATING)
	e4:SetOperation(c80000157.disop)
	c:RegisterEffect(e4)
	--cannot attack
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_CANNOT_ATTACK)
	e5:SetRange(LOCATION_MZONE)
	e5:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e5:SetTarget(c80000157.atktarget)
	c:RegisterEffect(e5)
	--actlimit
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_FIELD)
	e9:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e9:SetCode(EFFECT_CANNOT_ACTIVATE)
	e9:SetRange(LOCATION_MZONE)
	e9:SetTargetRange(0,1)
	e9:SetValue(c80000157.aclimit)
	e9:SetCondition(c80000157.actcon)
	c:RegisterEffect(e9)
end
function c80000157.aclimit(e,re,tp)
	return not re:GetHandler():IsImmuneToEffect(e)
end
function c80000157.actcon(e)
	return Duel.GetTurnPlayer()==e:GetHandlerPlayer()
end
function c80000157.atktarget(e,c)
	return not c:IsAttribute(ATTRIBUTE_WATER)
end
function c80000157.disop(e,tp,eg,ep,ev,re,r,rp)
	if not re:GetHandler():IsAttribute(ATTRIBUTE_WATER) and re:GetHandler():IsType(TYPE_MONSTER) then
		Duel.NegateEffect(ev)
	end
end
function c80000157.filter(c,tp)
	return c:IsCode(80000148) and c:GetActivateEffect():IsActivatable(tp)
end
function c80000157.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c80000157.filter,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE,0,1,nil,tp) end
end
function c80000157.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(80000156,1))
	local tc=Duel.SelectMatchingCard(tp,c80000157.filter,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,tp):GetFirst()
	if tc then
		local fc=Duel.GetFieldCard(tp,LOCATION_SZONE,5)
		if fc then
			Duel.SendtoGrave(fc,REASON_RULE)
			Duel.BreakEffect()
		end
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		local te=tc:GetActivateEffect()
		local tep=tc:GetControler()
		local cost=te:GetCost()
		if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
		Duel.RaiseEvent(tc,EVENT_CHAIN_SOLVED,tc:GetActivateEffect(),0,tp,tp,Duel.GetCurrentChain())
	end
end
function c80000157.cfilter(c)
	return c:IsCode(80000155) and c:IsType(TYPE_SPELL) and c:IsDiscardable()
end
function c80000157.ovfilter(c)
	return c:IsFaceup() and c:IsCode(80000146)
end
function c80000157.xyzop(e,tp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c80000157.cfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,c80000157.cfilter,1,1,REASON_COST+REASON_DISCARD)
end
function c80000157.splimit(e,se,sp,st)
	return bit.band(st,SUMMON_TYPE_XYZ)==SUMMON_TYPE_XYZ and not (se:GetHandler():IsType(TYPE_SPELL) or se:GetHandler():IsType(TYPE_MONSTER) or se:GetHandler():IsType(TYPE_TRAP))
end
function c80000157.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end 