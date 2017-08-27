--自由-联合
function c10131013.initial_effect(c)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,10131013+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c10131013.target)
	e1:SetOperation(c10131013.activate)
	c:RegisterEffect(e1)	
end
function c10131013.thfilter2(c)
	return c10131013.thfilter(c) and c:IsAbleToHand()
end
function c10131013.thfilter(c)
	return c:IsSetCard(0x5338) and c:IsType(TYPE_MONSTER)
end
function c10131013.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10131013.thfilter2,tp,LOCATION_DECK,0,3,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,LOCATION_DECK)
end
function c10131013.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c10131013.thfilter,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>=3 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,3,3,nil)
		Duel.ConfirmCards(1-tp,sg)
		Duel.ShuffleDeck(tp)
		local tg=sg:RandomSelect(1-tp,1)
		local tc=tg:GetFirst()
		if tc:IsAbleToHand() then
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			sg:RemoveCard(tc)
		end
		Duel.ShuffleDeck(tp)
	end
end