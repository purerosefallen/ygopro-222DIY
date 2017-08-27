--777-凋零与重生
function c66677709.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetHintTiming(0,TIMING_END_PHASE+TIMING_ATTACK)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,66677709+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c66677709.target)
	e1:SetOperation(c66677709.activate)
	c:RegisterEffect(e1)
	--act in hand
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e2:SetCondition(c66677709.handcon)
	c:RegisterEffect(e2) 
end
function c66677709.cfilter(c)
	return c:IsFaceup() and c:IsCode(66677707)
end
function c66677709.handcon(e)
	return Duel.IsExistingMatchingCard(c66677709.cfilter,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,1,nil)
end
function c66677709.filter(c)
	return c:IsSetCard(0x777) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand() and c:IsFaceup()
end
function c66677709.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:GetControler()==tp and chkc:IsLocation(LOCATION_REMOVED) and c66677709.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c66677709.filter,tp,LOCATION_REMOVED,0,2,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c66677709.filter,tp,LOCATION_REMOVED,0,2,2,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,2,0,0)
end
function c66677709.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=g:Filter(Card.IsRelateToEffect,nil,e)
	if sg:GetCount()>0 then
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end