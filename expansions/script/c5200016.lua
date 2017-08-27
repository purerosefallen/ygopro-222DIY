--精灵使的剑舞
function c5200016.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,5200016+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c5200016.condition)
	e1:SetTarget(c5200016.target)
	e1:SetOperation(c5200016.activate)
	c:RegisterEffect(e1)
end
function c5200016.filter2(c)
	return not c:IsSetCard(0x360)
end
function c5200016.condition(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(c5200016.filter2,tp,LOCATION_MZONE,0,1,nil)
end
function c5200016.filter(c)
	return c:IsSetCard(0x360) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c5200016.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c5200016.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c5200016.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c5200016.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

