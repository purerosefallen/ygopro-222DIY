--下架的祝福
function c80010011.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCountLimit(1,80010011+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c80010011.limtg)
	e1:SetCost(c80010011.negcost)
	e1:SetOperation(c80010011.activate)
	c:RegisterEffect(e1)
end
function c80010011.limtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetChainLimit(aux.FALSE)
end
function c80010011.activate(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_SKIP_DP)
	e1:SetTargetRange(1,0)
	e1:SetReset(RESET_PHASE+PHASE_END,3)
	Duel.RegisterEffect(e1,tp)
end
function c80010011.cfilter(c,e,tp)
	return c:IsAbleToRemoveAsCost()
end
function c80010011.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c80010011.cfilter,tp,0,LOCATION_MZONE,1,nil,e,tp) end
	local g=Duel.SelectMatchingCard(tp,c80010011.cfilter,tp,0,LOCATION_MZONE,1,1,nil,e,tp)
	Duel.Remove(g,POS_FACEDOWN,REASON_COST)
end