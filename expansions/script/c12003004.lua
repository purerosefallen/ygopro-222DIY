--水歌 幼奏的玛忒
function c12003004.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(12003004,0))
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1,12003004)
	e1:SetRange(LOCATION_HAND)
	e1:SetCost(c12003004.discost)
	e1:SetTarget(c12003004.target)
	e1:SetOperation(c12003004.operation)
	c:RegisterEffect(e1)
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(EFFECT_FLAG_CARD_TARGET)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCost(c12003004.thcost)
	e4:SetTarget(c12003004.thtg)
	e4:SetOperation(c12003004.thop)
	c:RegisterEffect(e4)
end
function c12003004.costfilter(c)
	return c:IsRace(RACE_SEASERPENT) and c:IsAbleToGraveAsCost()
end
function c12003004.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToGraveAsCost() and 
		Duel.IsExistingMatchingCard(c12003004.costfilter,tp,LOCATION_HAND,0,1,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c12003004.costfilter,tp,LOCATION_HAND,0,1,1,c)
	g:AddCard(c)
	Duel.SendtoGrave(g,REASON_COST)
end
function c12003004.filter(c)
	return c:IsRace(RACE_SEASERPENT) and c:IsAbleToHand()
end
function c12003004.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_DECK) and c12003004.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c12003004.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c12003004.filter,tp,LOCATION_DECK,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c12003004.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end
function c12003004.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c12003004.tgfilter(c)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_WATER) and c:IsType(TYPE_XYZ)
end
function c12003004.mfilter(c)
	return c:IsRace(RACE_SEASERPENT) and c:IsType(TYPE_MONSTER)
end
function c12003004.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(c12003004.tgfilter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingTarget(c12003004.mfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g1=Duel.SelectTarget(tp,c12003004.tgfilter,tp,LOCATION_MZONE,0,1,1,nil)
	e:SetLabelObject(g1:GetFirst())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local g2=Duel.SelectTarget(tp,c12003004.mfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,g2,1,0,0)
end
function c12003004.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:IsFacedown() or not tc:IsRelateToEffect(e) or tc:IsImmuneToEffect(e) then return end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,tc,e)
	if g:GetCount()>0 then
		Duel.Overlay(tc,g)
	end
end