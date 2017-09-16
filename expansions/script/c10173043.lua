--对象狂热者
function c10173043.initial_effect(c)
	--effect
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10173043,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,10173043)
	e1:SetHintTiming(0,0x1c0)
	e1:SetRange(LOCATION_HAND)
	e1:SetCost(c10173043.cost)
	e1:SetOperation(c10173043.operation)
	c:RegisterEffect(e1)
end
function c10173043.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function c10173043.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Group.CreateGroup()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e1:SetTargetRange(LOCATION_ONFIELD,0)
	e1:SetReset(RESET_PHASE+PHASE_END,2)
	e1:SetTarget(c10173043.target)
	e1:SetValue(c10173043.efilter)
	Duel.RegisterEffect(e1,tp)
end
function c10173043.target(e,c)
	local g,te=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS,CHAININFO_TRIGGERING_EFFECT)
	return not (te and te:IsHasProperty(EFFECT_FLAG_CARD_TARGET))
		or not (g and g:IsContains(c))
end
function c10173043.efilter(e,te)
	return te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end
