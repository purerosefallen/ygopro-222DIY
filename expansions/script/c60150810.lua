--终焉的约定
function c60150810.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,60150810+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c60150810.target)
	e1:SetOperation(c60150810.activate)
	c:RegisterEffect(e1)
end
function c60150810.filter(c)
	return c:IsSetCard(0x3b23) and c:IsAttribute(ATTRIBUTE_DARK) and c:IsAbleToHand()
end
function c60150810.afilter(c)
	return c:IsAbleToRemove()
end
function c60150810.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c60150810.filter,tp,LOCATION_DECK,0,1,nil)
		and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_DECK,LOCATION_DECK,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_COIN,nil,0,tp,1)
end
function c60150810.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c60150810.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		Duel.BreakEffect()
		local c=e:GetHandler()
		local res=0
		res=Duel.TossCoin(tp,1)
		if res==0 then
			local g=Duel.GetFieldCard(tp,LOCATION_DECK,0)
			Duel.DisableShuffleCheck()
			Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
		end
		if res==1 then
			local g=Duel.GetFieldCard(1-tp,LOCATION_DECK,0)
			Duel.DisableShuffleCheck()
			Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
		end 
	end
end