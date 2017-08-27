--神术『吸血鬼幻想』
function c1151205.initial_effect(c)
--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,1151205+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c1151205.con1)
	e1:SetTarget(c1151205.tg1)
	e1:SetOperation(c1151205.op1)
	c:RegisterEffect(e1)
--
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,1151205+EFFECT_COUNT_CODE_OATH)
	e2:SetCondition(c1151205.con2)
	e2:SetTarget(c1151205.tg2)
	e2:SetOperation(c1151205.op2)
	c:RegisterEffect(e2)
end
--
function c1151205.IsLeimi(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Leimi
end
c1151205.named_with_Leisp=1
function c1151205.IsLeisp(c)
	local m=_G["c"..c:GetCode()]
	return c.named_with_Leisp
end
--
function c1151205.cfilter1(c)
	return c:IsFaceup() and c1151205.IsLeimi(c)
end
function c1151205.con1(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(c1151205.cfilter1,tp,LOCATION_ONFIELD,0,1,nil)
end
--
function c1151205.tfilter1(c)
	return c1151205.IsLeimi(c) and c:IsAbleToHand()
end
function c1151205.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c1151205.tfilter1,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
--
function c1151205.op1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c1151205.tfilter1,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
--
function c1151205.cfilter2(c)
	return c:IsFaceup() and c1151205.IsLeimi(c)
end
function c1151205.con2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c1151205.cfilter2,tp,LOCATION_ONFIELD,0,1,nil)
end
--
function c1151205.tfilter2(c)
	return c:IsFaceup() and not c:IsType(TYPE_XYZ)
end
function c1151205.tg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c1151205.tfilter2(chkc) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(c1151205.tfilter2,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c1151205.tfilter2,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
end
--
function c1151205.ofilter2(c)
	return c1151205.IsLeisp(c) and c:IsAbleToHand() and not c:IsCode(1151205)
end
function c1151205.op2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Hint(HINT_SELECTMSG,1-tp,567)
		local lv=Duel.AnnounceNumber(tp,1,2,3,4,5,6,7,8,9,10,11,12)
		local e2_1=Effect.CreateEffect(e:GetHandler())
		e2_1:SetType(EFFECT_TYPE_SINGLE)
		e2_1:SetCode(EFFECT_CHANGE_LEVEL)
		e2_1:SetValue(lv)
		e2_1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e2_1)
		if Duel.IsExistingMatchingCard(c1151205.ofilter2,tp,LOCATION_DECK,0,1,nil) and tc:GetLevel()==lv then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local g2=Duel.SelectMatchingCard(tp,c1151205.ofilter2,tp,LOCATION_DECK,0,1,1,nil)
			if g2:GetCount()>0 then
				local tc2=g2:GetFirst()
				Duel.SendtoHand(tc2,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,tc2)
			end
		end
	end
end