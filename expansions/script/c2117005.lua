--恶魔墓碑
function c2117005.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,2117005+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c2117005.condition)
	e1:SetTarget(c2117005.target)
	e1:SetOperation(c2117005.activate)
	c:RegisterEffect(e1)
end
function c2117005.cfilter(c)
	return not c:IsRace(RACE_FIEND)
end
function c2117005.condition(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(c2117005.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c2117005.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,tp,3)
end
function c2117005.tgfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x21c) and c:IsAbleToGrave()
end
function c2117005.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.DiscardDeck(tp,3,REASON_EFFECT)
	local mg=Duel.GetMatchingGroup(c2117005.tgfilter,tp,LOCATION_GRAVE,0,nil)
	if mg:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(2117005,0)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=mg:Select(tp,1,1,nil)
		if sg:GetFirst():IsHasEffect(EFFECT_NECRO_VALLEY) then return end
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end