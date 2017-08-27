--印卡天使
function c80010031.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetCountLimit(1,80010031+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c80010031.target)
	e1:SetCondition(c80010031.damcon)
	e1:SetOperation(c80010031.operation)
	c:RegisterEffect(e1)
end
function c80010031.cfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER)
end
function c80010031.damcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c80010031.cfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,e:GetHandler())
end
function c80010031.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(nil,tp,LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,1-tp,564)
	local ac=Duel.AnnounceCard(1-tp,TYPE_MONSTER)
	Duel.SetTargetParam(ac)
	Duel.SetOperationInfo(0,CATEGORY_ANNOUNCE,nil,0,tp,ANNOUNCE_CARD)
end
function c80010031.filter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function c80010031.operation(e,tp,eg,ep,ev,re,r,rp)
	local ac=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	local g=Duel.GetMatchingGroup(Card.IsCode,tp,LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_DECK,0,nil,ac)
	local hg=Duel.GetFieldGroup(tp,LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_DECK,0)
	Duel.ConfirmCards(tp,hg)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)  
		tc=g:Select(tp,1,1,nil):GetFirst()  
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ShuffleHand(tp)
	else
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c80010031.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		end
	end
end



