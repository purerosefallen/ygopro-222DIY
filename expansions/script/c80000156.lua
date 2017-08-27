--超古代口袋妖怪 原始固拉多
function c80000156.initial_effect(c)
	if c:IsStatus(STATUS_COPYING_EFFECT) then return end
	--xyz summon
	aux.AddXyzProcedure(c,nil,11,5,c80000156.ovfilter,aux.Stringid(80000156,0),5,c80000156.xyzop)
	c:EnableReviveLimit()   
	--spsummon limit
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c80000156.splimit)
	c:RegisterEffect(e1) 
	--Attribute Dark
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetCode(EFFECT_ADD_ATTRIBUTE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(ATTRIBUTE_FIRE)
	c:RegisterEffect(e3)	
	--Attribute Dark
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetCode(EFFECT_ADD_ATTRIBUTE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetValue(ATTRIBUTE_EARTH)
	c:RegisterEffect(e4)
	--wudi 
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE)
	e8:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e8:SetRange(LOCATION_MZONE)
	e8:SetCode(EFFECT_IMMUNE_EFFECT)
	e8:SetValue(c80000156.efilter)
	c:RegisterEffect(e8) 
	--Activate
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(c80000156.target)
	e2:SetOperation(c80000156.activate)
	c:RegisterEffect(e2)
	--pos Change
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(80000156,2))
	e7:SetCategory(CATEGORY_POSITION)
	e7:SetType(EFFECT_TYPE_QUICK_O)
	e7:SetCode(EVENT_FREE_CHAIN)
	e7:SetRange(LOCATION_MZONE)
	e7:SetHintTiming(0,0x1e0)
	e7:SetCountLimit(1)
	e7:SetOperation(c80000156.posop)
	c:RegisterEffect(e7)
	--dis field
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(80000156,4))
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1)
	e5:SetCode(EVENT_PHASE+PHASE_END)
	e5:SetOperation(c80000156.operation)
	c:RegisterEffect(e5)
end
function c80000156.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
		and Duel.GetLocationCount(1-tp,LOCATION_MZONE)<=0 then return end
	--disable field
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_DISABLE_FIELD)
	e1:SetOperation(c80000156.disop)
	e:GetHandler():RegisterEffect(e1)
end
function c80000156.disop(e,tp)
	local dis1=Duel.SelectDisableField(tp,1,LOCATION_MZONE,LOCATION_MZONE,0)
	return dis1
end
function c80000156.filter222(c)
	return c:IsFaceup() and not c:IsCode(80000156)
end
function c80000156.posop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c80000156.filter222,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	Duel.ChangePosition(g,POS_FACEUP_DEFENSE,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK,true)
end
function c80000156.filter(c,tp)
	return c:IsCode(80000147) and c:GetActivateEffect():IsActivatable(tp)
end
function c80000156.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c80000156.filter,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE,0,1,nil,tp) end
end
function c80000156.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(80000156,1))
	local tc=Duel.SelectMatchingCard(tp,c80000156.filter,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,tp):GetFirst()
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
function c80000156.cfilter(c)
	return c:IsCode(80000154) and c:IsType(TYPE_SPELL) and c:IsDiscardable()
end
function c80000156.ovfilter(c)
	return c:IsFaceup() and c:IsCode(80000145)
end
function c80000156.xyzop(e,tp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c80000156.cfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,c80000156.cfilter,1,1,REASON_COST+REASON_DISCARD)
end
function c80000156.splimit(e,se,sp,st)
	return bit.band(st,SUMMON_TYPE_XYZ)==SUMMON_TYPE_XYZ and not (se:GetHandler():IsType(TYPE_SPELL) or se:GetHandler():IsType(TYPE_MONSTER) or se:GetHandler():IsType(TYPE_TRAP))
end
function c80000156.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end