--素云鬼
function c217070.initial_effect(c)
	--negate
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(217070,0))
	e4:SetCategory(CATEGORY_DISABLE)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_CHAINING)
	e4:SetRange(LOCATION_HAND)
	e4:SetCost(c217070.cost)
	e4:SetCondition(c217070.condition)
	e4:SetTarget(c217070.distg)
	e4:SetOperation(c217070.disop)
	c:RegisterEffect(e4)
end
function c217070.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c217070.condition(e,tp,eg,ep,ev,re,r,rp)
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local tg=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return tg and tg:IsExists(Card.IsLocation,1,nil,LOCATION_ONFIELD+LOCATION_GRAVE) and Duel.IsChainDisablable(ev)
end
function c217070.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
end
function c217070.disop(e,tp,eg,ep,ev,re,r,rp,chk)
	Duel.NegateEffect(ev)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
