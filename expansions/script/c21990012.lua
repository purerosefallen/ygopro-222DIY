--准备 呼唤神风的星之仪式
function c21990012.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,21990012+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c21990012.target)
	e1:SetOperation(c21990012.activate)
	c:RegisterEffect(e1)
end
function c21990012.filter(c)
	return (c:IsSetCard(0xa219) or c:IsSetCard(0x9219)) and c:IsType(TYPE_SPELL) and c:IsAbleToHand()
end
function c21990012.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c21990012.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c21990012.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g1=Duel.SelectMatchingCard(tp,c21990012.filter,tp,LOCATION_DECK,0,1,1,nil)
	local g2=Duel.GetMatchingGroup(c21990012.filter,tp,LOCATION_GRAVE,0,nil)
	if g1:GetCount()>0 then
		Duel.SendtoHand(g1,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g1)
		if g2:GetCount()>0 and Duel.GetTurnPlayer()~=tp and Duel.SelectYesNo(tp,aux.Stringid(21990012,0)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local sg=g2:Select(tp,1,1,nil)
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sg)
		end
	end
end