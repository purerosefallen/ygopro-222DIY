--家族の決意
function c114000520.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(c114000520.condition)
	e1:SetTarget(c114000520.target)
	e1:SetOperation(c114000520.activate)
	c:RegisterEffect(e1)
end
function c114000520.filter(c)
	return ( c:IsSetCard(0x221) or c:IsCode(114000231) ) and c:IsFaceup()
end
function c114000520.condition(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.GetMatchingGroup(c114000520.spfilter,tp,LOCATION_MZONE,0,nil)
	local ct=g:GetClassCount(Card.GetCode)
	return ct>=3 and Duel.IsChainNegatable(ev)
end
function c114000520.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function c114000520.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(c114000520.etarget)
	e1:SetValue(c114000520.efilter)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c114000520.etarget(e,c)
	return c:IsFaceup() and ( c:IsSetCard(0x221) or c:IsCode(114000231) )
end
function c114000520.efilter(e,re)
	return e:GetHandlerPlayer()~=re:GetHandlerPlayer()
end