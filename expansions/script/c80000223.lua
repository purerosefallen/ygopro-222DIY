--Cherish Ball
function c80000223.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,80000223)
	e1:SetTarget(c80000223.target)
	e1:SetOperation(c80000223.activate)
	c:RegisterEffect(e1)
end
function c80000223.filter(c)
	return c:IsSetCard(0x2d1) and c:IsAbleToHand()
end
function c80000223.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c80000223.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c80000223.tgfilter(c)
	return c:IsSetCard(0x2d1) and c:IsAbleToGrave()
end
function c80000223.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c80000223.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	local hg=Duel.GetMatchingGroup(c80000223.tgfilter,tp,LOCATION_DECK,0,nil)
	if  hg:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(80000223,0)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local sg=hg:Select(tp,1,1,nil)
		Duel.SendtoGrave(sg,REASON_EFFECT)
		end
	end
end