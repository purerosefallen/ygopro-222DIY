--尘封的记忆 奇犽
function c50000071.initial_effect(c)
	--1
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetDescription(aux.Stringid(50000071,0))
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,50000071)
	e1:SetCost(c50000071.dacost)
	e1:SetTarget(c50000071.datg)
	e1:SetOperation(c50000071.daop)
	c:RegisterEffect(e1)
	--2
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(50000071,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,50000071)
	e2:SetCost(c50000071.thcost)
	e2:SetTarget(c50000071.thtg)
	e2:SetOperation(c50000071.thop)
	c:RegisterEffect(e2)
	--3
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_BE_MATERIAL)
	e3:SetCondition(c50000071.indcon)
	e3:SetOperation(c50000071.indop)
	c:RegisterEffect(e3)
end
--1
function c50000071.dacost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function c50000071.dafilter(c)
	return c:IsFaceup() and c:IsType(TYPE_DUAL) and c:IsSetCard(0x50c) and not c:IsDualState()
end
function c50000071.datg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c50000071.dafilter(chkc) end
	if chk==0 then return  Duel.IsExistingTarget(c50000071.dafilter,tp,LOCATION_MZONE,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c50000071.dafilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c50000071.daop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and c50000071.dafilter(tc) then
		tc:EnableDualState()
	end
end
--2
function c50000071.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c50000071.thfilter(c)
	return c:IsSetCard(0x50c) and not c:IsCode(50000071) and c:IsAbleToHand()
end
function c50000071.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c50000071.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c50000071.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c50000071.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
--3
function c50000071.indcon(e,tp,eg,ep,ev,re,r,rp)
	return r==REASON_FUSION 
end
function c50000071.indop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(50000071,2))
	e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e1:SetValue(1)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	rc:RegisterEffect(e1)
end