--灵都圣芒·蓿
function c1110121.initial_effect(c)
--
	c:EnableReviveLimit()
	aux.AddXyzProcedure(c,c1110121.xyzfilter,3,2,c1110121.ovfilter,aux.Stringid(1110121,0),2,c1110121.xyzop)
--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(1110121,2))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,1110121)
	e2:SetCost(c1110121.cost2)
	e2:SetTarget(c1110121.tg2)
	e2:SetOperation(c1110121.op2)
	c:RegisterEffect(e2)
--
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCountLimit(1,1110126)
	e3:SetCondition(c1110121.con3)
	e3:SetTarget(c1110121.tg3)
	e3:SetOperation(c1110121.op3)
	c:RegisterEffect(e3)
end
--
c1110121.named_with_Ld=1
function c1110121.IsLd(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Ld
end
--
function c1110121.xyzfilter(c)
	return c1110121.IsLd(c) 
end
function c1110121.ovfilter(c)
	return c:IsFaceup() and c:IsCode(1110001)
end
--
function c1110121.ofilter(c)
	return c1110121.IsLd(c) and c:IsType(TYPE_FIELD)
end
function c1110121.xyzop(e,tp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c1110121.ofilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
end
--
function c1110121.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
--
function c1110121.tg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToHand,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,Card.IsAbleToHand,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,LOCATION_ONFIELD)
end
--
function c1110121.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsLocation(LOCATION_ONFIELD) then
		if Duel.SendtoHand(tc,nil,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_HAND) and tc:IsAbleToRemove() then
			Duel.BreakEffect()
			Duel.ConfirmCards(tp,tc)
			Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
		end
	end
end
--
function c1110121.con3(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
--
function c1110121.tg3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
--
function c1110121.op3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_PHASE+PHASE_END)
	e4:SetCountLimit(1)
	e4:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetOperation(c1110121.op4)
	c:RegisterEffect(e4)
end
function c1110121.filter4(c)
	return c:IsCode(1110001) and c:IsAbleToHand()
end
function c1110121.op4(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.Remove(c,POS_FACEUP,REASON_EFFECT)~=0 and Duel.IsExistingMatchingCard(c1110121.filter4,tp,LOCATION_REMOVED,0,1,nil) then
		Duel.BreakEffect()
		local g=Duel.SelectMatchingCard(tp,c1110121.filter4,tp,LOCATION_REMOVED,0,1,1,nil)
		tc=g:GetFirst()
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end
--