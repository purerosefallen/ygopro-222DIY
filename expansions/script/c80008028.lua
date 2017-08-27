--冰霜龙的接引
function c80008028.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,80008028)
	e1:SetTarget(c80008028.target)
	e1:SetOperation(c80008028.activate)
	c:RegisterEffect(e1)	
	--destroy
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(80008028,0))
	e3:SetCategory(CATEGORY_DESTROY+CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_TOGRAVE)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCountLimit(1,80008029)
	e3:SetCost(c80008028.descost)
	e3:SetTarget(c80008028.destg)
	e3:SetOperation(c80008028.desop)
	c:RegisterEffect(e3)
end
function c80008028.filter(c)
	return (c:IsSetCard(0x2d8) or (c:IsAttribute(ATTRIBUTE_WATER) and c:IsRace(RACE_SPELLCASTER))) and c:IsDiscardable(REASON_EFFECT)
end
function c80008028.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2)
		and Duel.IsExistingMatchingCard(c80008028.filter,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function c80008028.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.DiscardHand(tp,c80008028.filter,1,1,REASON_EFFECT+REASON_DISCARD,nil)~=0 then
		Duel.BreakEffect()
		Duel.Draw(tp,2,REASON_EFFECT)
	end
end
function c80008028.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c80008028.desfilter(c)
	return c:IsFaceup() and c:IsDestructable() and c:IsAttribute(ATTRIBUTE_WATER) and c:IsRace(RACE_SPELLCASTER)
end
function c80008028.thfilter(c)
	return c:IsSetCard(0x2d8) and c:IsAbleToHand() and c:IsType(TYPE_MONSTER)
end
function c80008028.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(tp) and c80008028.desfilter(chkc) and chkc~=e:GetHandler() end
	if chk==0 then return Duel.IsExistingTarget(c80008028.desfilter,tp,LOCATION_ONFIELD,0,1,e:GetHandler())
		and Duel.IsExistingMatchingCard(c80008028.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c80008028.desfilter,tp,LOCATION_ONFIELD,0,1,1,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c80008028.tgfilter(c)
	return c:IsSetCard(0x2d8) and c:IsType(TYPE_SPELL) and c:IsAbleToGrave()
end
function c80008028.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c80008028.thfilter,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
	local sg=Duel.GetMatchingGroup(c80008028.tgfilter,p,LOCATION_DECK,0,nil)
	if sg:GetCount()>0 and Duel.SelectYesNo(p,aux.Stringid(80008028,1)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,p,HINTMSG_TOGRAVE)
		local hg=sg:Select(p,1,1,nil)
		Duel.SendtoGrave(hg,REASON_EFFECT)
			end
		end
	end
end