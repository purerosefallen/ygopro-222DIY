--福祸所依
function c197520737.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetHintTiming(TIMING_STANDBY_PHASE,TIMING_STANDBY_PHASE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(function()
		return Duel.GetCurrentPhase()==PHASE_STANDBY
	end)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(197520737,0))
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetProperty(0x14000)
	e2:SetCode(EVENT_TO_HAND)
	e2:SetRange(LOCATION_SZONE)
	--e2:SetCountLimit(1,197520737)
	e2:SetCondition(c197520737.hdcon)
	e2:SetTarget(c197520737.hdtg)
	e2:SetOperation(c197520737.hdop)
	c:RegisterEffect(e2)
end
function c197520737.cfilter(c)
	return c:IsPreviousLocation(LOCATION_DECK)
end
function c197520737.cfilter1(c,e)
	return c:IsRelateToEffect(e) and c:IsPreviousLocation(LOCATION_DECK)
end
function c197520737.hdcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()~=PHASE_DRAW
end
function c197520737.hdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c197520737.cfilter,1,nil) end
	Duel.SetTargetCard(eg)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_HAND)
end
function c197520737.hdop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=eg:Filter(c197520737.cfilter1,nil,e)
	Duel.SendtoGrave(g,REASON_EFFECT)
end
