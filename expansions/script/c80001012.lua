--冰灵凋落
function c80001012.initial_effect(c)
	--to grave
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(TIMING_ATTACK,0x11e0)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCondition(c80001012.recon1)
	e1:SetTarget(c80001012.tgtg)
	e1:SetOperation(c80001012.tgop)
	c:RegisterEffect(e1)
	--search
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCondition(c80001012.condition)
	e3:SetCost(c80001012.thcost)
	e3:SetTarget(c80001012.thtg1)
	e3:SetOperation(c80001012.thop1)
	c:RegisterEffect(e3)
	--act in hand
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_SINGLE)
	e9:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e9:SetCondition(c80001012.handcon)
	c:RegisterEffect(e9)
end
function c80001012.cfilter1(c)
	return c:IsFaceup() and (c:IsSetCard(0x2dc) or c:IsAttribute(ATTRIBUTE_WATER))
end
function c80001012.recon1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c80001012.cfilter1,tp,LOCATION_ONFIELD,0,1,nil)
end
function c80001012.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldCard(tp,LOCATION_SZONE,5)==nil
end
function c80001012.filter1(c)
	return c:IsFaceup() and c:IsCode(80001014)
end
function c80001012.handcon(e)
	return Duel.IsExistingMatchingCard(c80001012.filter1,e:GetHandlerPlayer(),LOCATION_SZONE,LOCATION_SZONE,1,nil)
end
function c80001012.tgtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and chkc:IsAbleToGrave() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToGrave,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectTarget(tp,Card.IsAbleToGrave,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,0)
end
function c80001012.tgop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoGrave(tc,REASON_EFFECT)
	end
end
function c80001012.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c80001012.thfilter(c)
	return c:IsAbleToHand() and c:IsCode(80001014)
end
function c80001012.thtg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c80001012.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c80001012.thop1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c80001012.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end