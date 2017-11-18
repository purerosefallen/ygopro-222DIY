--恶魔之妹·芙兰朵露
function c1152001.initial_effect(c)
--
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(c1152001.lfilter),4)
--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(1152001,0))
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetHintTiming(0,0x1e0)
	e1:SetTarget(c1152001.tg1)
	e1:SetOperation(c1152001.op1)
	c:RegisterEffect(e1)
--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(c1152001.tg2)
	e2:SetOperation(c1152001.op2)
	c:RegisterEffect(e2)	
--
end
--
c1152001.named_with_Fulan=1
function c1152001.IsFulan(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Fulan
end
c1152001.named_with_Fulsp=1
function c1152001.IsFulsp(c)
	local m=_G["c"..c:GetCode()]
	return c.named_with_Fulsp
end
--
function c1152001.lfilter(c)
	return c:IsRace(RACE_FIEND)
end
--
function c1152001.tfilter1(c)
	return c:IsFaceup() and not c:IsDisabled()
end
function c1152001.tfilter1_2(c)
	return c1152001.IsFulsp(c) and c:IsAbleToRemove() and bit.band(c:GetReason(),REASON_DESTROY)~=0
end
function c1152001.tg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsOnField() and c1152001.tfilter1(chkc) end
	local c=e:GetHandler()
	local lg=c:GetLinkedGroup()
	local g=lg:Filter(Card.IsDestructable,nil)
	if chk==0 then return Duel.IsExistingTarget(c1152001.tfilter1,tp,0,LOCATION_ONFIELD,1,nil) and (g:GetCount()>0 or Duel.IsExistingTarget(c1152001.tfilter1_2,tp,LOCATION_GRAVE,0,1,nil)) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c1152001.tfilter1,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
--
function c1152001.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local lg=c:GetLinkedGroup()
	local g=lg:Filter(Card.IsDestructable,nil)
	local Destroy=0
	if g:GetCount()>0 and Duel.IsExistingTarget(c1152001.tfilter1_2,tp,LOCATION_GRAVE,0,1,nil) then
		local i=Duel.SelectOption(tp,aux.Stringid(1152001,1),aux.Stringid(1152001,2))
		if i==0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
			local tc=g:Select(tp,1,1,nil)
			if Duel.Destroy(tc,REASON_EFFECT)~=0 then
				Destroy=1
			end
		else
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
			local g2=Duel.SelectMatchingCard(tp,c1152001.tfilter1_2,tp,LOCATION_GRAVE,0,1,1,nil)
			local tc2=g2:GetFirst()
			if Duel.Remove(tc2,POS_FACEUP,REASON_EFFECT)~=0 then
				Destroy=1
			end
		end
	else
		if g:GetCount()>0 and not Duel.IsExistingTarget(c1152001.tfilter1_2,tp,LOCATION_GRAVE,0,1,nil) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
			local tc=g:Select(tp,1,1,nil)
			if Duel.Destroy(tc,REASON_EFFECT)~=0 then
				Destroy=1
			end
		else
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
			local g2=Duel.SelectMatchingCard(tp,c1152001.tfilter1_2,tp,LOCATION_GRAVE,0,1,1,nil)
			local tc2=g2:GetFirst()
			if Duel.Remove(tc2,POS_FACEUP,REASON_EFFECT)~=0 then
				Destroy=1
			end
		end
	end
	if Destroy==1 then
		local tc=Duel.GetFirstTarget()
		if tc and tc:IsRelateToEffect(e) and not tc:IsDisabled() then
			Duel.NegateRelatedChain(tc,RESET_TURN_SET)
			local e1_1=Effect.CreateEffect(e:GetHandler())
			e1_1:SetType(EFFECT_TYPE_SINGLE)
			e1_1:SetCode(EFFECT_DISABLE)
			e1_1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1_1:SetReset(RESET_EVENT+0x1fe0000)
			tc:RegisterEffect(e1_1)
			local e1_2=e1_1:Clone()
			e1_2:SetCode(EFFECT_DISABLE_EFFECT)
			e1_2:SetValue(RESET_TURN_SET)
			tc:RegisterEffect(e1_2)
			if tc:IsType(TYPE_TRAPMONSTER) then
				local e1_3=Effect.CreateEffect(e:GetHandler())
				e1_3:SetType(EFFECT_TYPE_SINGLE)
				e1_3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e1_3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
				e1_3:SetReset(RESET_EVENT+0x1fe0000)
				tc:RegisterEffect(e1_3)
			end
			Duel.AdjustInstantly()
			Duel.Destroy(tc,REASON_EFFECT)
		end
	end
end
--
function c1152001.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetControler()==Duel.GetTurnPlayer() and rp~=tp end
	return Duel.SelectYesNo(tp,aux.Stringid(1152001,3))
end
--
function c1152001.op2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT+REASON_TEMPORARY)~=0 then
		local e2_1=Effect.CreateEffect(e:GetHandler())
		e2_1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2_1:SetCode(EVENT_PHASE+PHASE_END)
		e2_1:SetReset(RESET_PHASE+PHASE_END)
		e2_1:SetCountLimit(1)
		e2_1:SetOperation(c1152001.op2_1)
		Duel.RegisterEffect(e2_1,tp)
		local g=Group.CreateGroup()
		Duel.ChangeTargetCard(ev,g)
		Duel.ChangeChainOperation(ev,aux.NULL)
	end
end
function c1152001.op2_1(e,tp,eg,ep,ev,re,r,rp)
	Duel.ReturnToField(e:GetOwner())
end
--

