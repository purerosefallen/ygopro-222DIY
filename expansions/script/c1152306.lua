--禁忌『恋之迷宫』
function c1152306.initial_effect(c)
--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
--  
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_REMOVE+CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(c1152306.con2)
	e2:SetTarget(c1152306.tg2)
	e2:SetOperation(c1152306.op2)
	c:RegisterEffect(e2) 
--
	local e3=Effect.CreateEffect(c)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL+EFFECT_FLAG_SET_AVAILABLE)
	e3:SetType(EFFECT_TYPE_QUICK_F)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCondition(c1152306.con3)
	e3:SetOperation(c1152306.op3)
	c:RegisterEffect(e3)
--
end
--
function c1152306.IsFulan(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Fulan
end
c1152306.named_with_Fulsp=1
function c1152306.IsFulsp(c)
	local m=_G["c"..c:GetCode()]
	return c.named_with_Fulsp
end
--
function c1152306.con2(e,tp,eg,ep,ev,re,r,rp)
	local ec=eg:GetFirst()
	while ec do
		if ec:GetPreviousControler()==tp and ec:GetReasonPlayer()~=ec:GetPreviousControler() and ec:IsPreviousLocation(LOCATION_ONFIELD) then
			return true
		end
		ec=eg:GetNext()
	end
	return false
end
--
function c1152306.tfilter2_1(c,e,tp)
	return c1152306.IsFulsp(c) and c:IsAbleToRemove() and bit.band(c:GetReason(),REASON_DESTROY)~=0 and Duel.IsExistingMatchingCard(c1152306.tfilter2_2,tp,LOCATION_DECK,0,1,nil,c:GetCode())
end
function c1152306.tfilter2_2(c,code)
	return c:IsCode(code) and c:IsAbleToHand()
end
function c1152306.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c1152306.tfilter2_1,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
--
function c1152306.op2(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g=Duel.SelectMatchingCard(tp,c1152306.tfilter2_1,tp,LOCATION_GRAVE,0,1,1,nil)
		if g:GetCount()>0 then
			if Duel.Remove(g,POS_FACEUP,REASON_EFFECT)>0 and Duel.IsExistingMatchingCard(c1152306.tfilter2_2,tp,LOCATION_DECK,0,1,nil,g:GetFirst():GetCode()) then
				local g1=Duel.SelectMatchingCard(tp,c1152306.tfilter2_2,tp,LOCATION_DECK,0,1,1,nil,g:GetFirst():GetCode())
				if g1:GetCount()>0 then
					Duel.SendtoHand(g1,nil,REASON_EFFECT)
					Duel.ConfirmCards(1-tp,g1)
				end
			end
		end
	end
end
--
function c1152306.con3(e,tp,eg,ep,ev,re,r,rp)
	if re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then
		local tg=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
		local tc=tg:GetFirst()
		local i=0
		while tc do
			if tc==e:GetHandler() and e:GetHandler():IsFacedown() then
				i=1
			end
			tc=tg:GetNext()
		end
		if i==1 then
			return true
		else
			return false
		end
	else 
		return false 
	end
end
--
function c1152306.op3(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
	Duel.ChangePosition(e:GetHandler(),POS_FACEUP)
	local c=e:GetHandler()
	local e3_1=Effect.CreateEffect(c)
	e3_1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3_1:SetCode(EVENT_PHASE+PHASE_END)
	e3_1:SetCountLimit(1)
	e3_1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	e3_1:SetRange(LOCATION_SZONE)
	e3_1:SetOperation(c1152306.op3_1)
	c:RegisterEffect(e3_1,true)
end
function c1152306.ofilter3_1(c)
	return c:IsFaceup() and bit.band(c:GetOriginalType(),TYPE_MONSTER)==0
end
function c1152306.ofilter3_2(c)
	return c:IsFacedown()
end
function c1152306.op3_1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() then
		local g=Duel.GetMatchingGroup(c1152306.ofilter3_1,tp,LOCATION_SZONE,0,nil)
		if g:GetCount()>0 then
			Duel.ChangePosition(g,POS_FACEDOWN)
		end
	end
end


--
