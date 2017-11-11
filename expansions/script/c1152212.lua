--禁忌『禁果』
function c1152212.initial_effect(c)
--
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_REMOVE)
	e1:SetTarget(c1152212.tg1)
	e1:SetOperation(c1152212.op1)
	c:RegisterEffect(e1)
--  
	local e2=Effect.CreateEffect(c)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_CHAINING)
	e2:SetCondition(c1152212.con2)
	e2:SetTarget(c1152212.tg2)
	e2:SetOperation(c1152212.op2)
	c:RegisterEffect(e2)
--
end  
--
function c1152212.IsFulan(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Fulan
end
c1152212.named_with_Fulsp=1
function c1152212.IsFulsp(c)
	local m=_G["c"..c:GetCode()]
	return c.named_with_Fulsp
end
--
function c1152212.tfilter1_1(c)
	return c1152212.IsFulsp(c) and (c:IsType(TYPE_SPELL) or c:IsType(TYPE_TRAP)) and c:IsDestructable()
end
function c1152212.tfilter1_2(c)
	return c1152212.IsFulsp(c) and (c:IsType(TYPE_SPELL) or c:IsType(TYPE_TRAP)) and c:IsAbleToRemove() and bit.band(c:GetReason(),REASON_DESTROY)~=0
end
function c1152212.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() and e:GetHandler():IsLocation(LOCATION_REMOVED) and c:IsFaceup() and (Duel.IsExistingMatchingCard(c1152212.tfilter1_1,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,nil) or Duel.IsExistingMatchingCard(c1152212.tfilter1_2,tp,LOCATION_GRAVE,0,1,nil)) end
end
--
function c1152212.op1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsExistingMatchingCard(c1152212.tfilter1_1,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,nil) and Duel.IsExistingMatchingCard(c1152212.tfilter1_2,tp,LOCATION_GRAVE,0,1,nil)then 
		local i=Duel.SelectOption(tp,aux.Stringid(1152212,0),aux.Stringid(1152212,1))
		if i==0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
			local g=Duel.SelectMatchingCard(tp,c1152212.tfilter1_1,tp,0,LOCATION_ONFIELD+LOCATION_HAND,1,1,nil)
			if g:GetCount()>0 then
				local tc=g:GetFirst()
				if Duel.Destroy(tc,REASON_EFFECT)~=0 then
					Duel.SendtoHand(e:GetHandler(),nil,REASON_EFFECT)
					Duel.ConfirmCards(1-tp,tc)
				end
			end
		else
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
			local g=Duel.SelectMatchingCard(tp,c1152212.tfilter1_2,tp,0,LOCATION_GRAVE,1,1,nil)
			if g:GetCount()>0 then
				local tc=g:GetFirst()
				if Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)~=0 then
					Duel.SendtoHand(e:GetHandler(),nil,REASON_EFFECT)
					Duel.ConfirmCards(1-tp,tc)
				end
			end
		end
	else 
		if Duel.IsExistingMatchingCard(c1152212.tfilter1_1,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,nil) and not Duel.IsExistingMatchingCard(c1152212.tfilter1_2,tp,LOCATION_GRAVE,0,1,nil) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
			local g=Duel.SelectMatchingCard(tp,c1152212.tfilter1_1,tp,0,LOCATION_ONFIELD+LOCATION_HAND,1,1,nil)
			if g:GetCount()>0 then
				local tc=g:GetFirst()
				if Duel.Destroy(tc,REASON_EFFECT)~=0 then
					Duel.SendtoHand(e:GetHandler(),nil,REASON_EFFECT)
					Duel.ConfirmCards(1-tp,tc)
				end
			end
		else
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
			local g=Duel.SelectMatchingCard(tp,c1152212.tfilter1_2,tp,0,LOCATION_GRAVE,1,1,nil)
			if g:GetCount()>0 then
				local tc=g:GetFirst()
				if Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)~=0 then
					Duel.SendtoHand(e:GetHandler(),nil,REASON_EFFECT)
					Duel.ConfirmCards(1-tp,tc)
				end
			end
		end
	end
end
--
function c1152212.con2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)==LOCATION_HAND and rp~=tp and re:IsActiveType(TYPE_MONSTER)
end
--
function c1152212.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
--
function c1152212.op2(e,tp,eg,ep,ev,re,r,rp)
	local g=Group.CreateGroup()
	Duel.ChangeTargetCard(ev,g)
	Duel.ChangeChainOperation(ev,aux.NULL)
	e:GetHandler():CancelToGrave()
	if e:GetHandler():IsLocation(LOCATION_SZONE) then
		local e2_1=Effect.CreateEffect(e:GetHandler())
		e2_1:SetType(EFFECT_TYPE_SINGLE)
		e2_1:SetCode(EFFECT_CHANGE_TYPE)
		e2_1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2_1:SetValue(TYPE_EQUIP+TYPE_SPELL)
		e2_1:SetReset(RESET_EVENT+0x1fe0000)
		e:GetHandler():RegisterEffect(e2_1,true)
		local e2_2=Effect.CreateEffect(e:GetHandler())
		e2_2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
		e2_2:SetType(EFFECT_TYPE_QUICK_O)
		e2_2:SetCode(EVENT_CHAINING)
		e2_2:SetRange(LOCATION_SZONE)
		e2_2:SetReset(RESET_EVENT+0x1fe0000)
		e2_2:SetCondition(c1152212.con2_2)
		e2_2:SetTarget(c1152212.tg2_2)
		e2_2:SetOperation(c1152212.op2_2)
		e:GetHandler():RegisterEffect(e2_2,true)
	end
end
function c1152212.con2_2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetControler()==Duel.GetTurnPlayer() and rp~=tp
end
function c1152212.tg2_2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function c1152212.op2_2(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		local g=Group.CreateGroup()
		Duel.ChangeTargetCard(ev,g)
		Duel.ChangeChainOperation(ev,aux.NULL)
		Duel.Destroy(e:GetHandler(),REASON_EFFECT)
	end
end
--
