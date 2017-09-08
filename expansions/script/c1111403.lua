--灵纹·星屑辉芒
function c1111403.initial_effect(c)
--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c1111403.tg1)
	e1:SetOperation(c1111403.op1)
	c:RegisterEffect(e1)
--  
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_EQUIP_LIMIT)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetValue(c1111403.limit2)
	c:RegisterEffect(e2)
--   
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_EQUIP)
	e3:SetRange(LOCATION_SZONE)
	e3:SetOperation(c1111403.op3)
	c:RegisterEffect(e3) 
--
end
--
function c1111403.IsLd(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Ld
end
c1111403.named_with_Lw=1
function c1111403.IsLeisp(c)
	local m=_G["c"..c:GetCode()]
	return c.named_with_Lw
end
function c1111403.IsDw(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Dw
end
--
function c1111403.tfilter1(c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER) and c:IsType(TYPE_EFFECT)
end
function c1111403.tg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c1111403.tfilter1(chkc) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.IsExistingTarget(c1111403.tfilter1,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,c1111403.tfilter1,tp,LOCATION_MZONE,0,1,1,nil)
end
--
function c1111403.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		e:GetHandler():CancelToGrave()
		local tc=Duel.GetFirstTarget()
		if tc:IsFaceup() and tc:IsRelateToEffect(e) then
			local e1_1=Effect.CreateEffect(c)
			e1_1:SetType(EFFECT_TYPE_SINGLE)
			e1_1:SetCode(EFFECT_CHANGE_TYPE)
			e1_1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1_1:SetValue(TYPE_EQUIP+TYPE_SPELL)
			e1_1:SetReset(RESET_EVENT+0x1fe0000)
			c:RegisterEffect(e1_1,true) 
			if Duel.Equip(tp,c,tc,true) then
				local e1_2=Effect.CreateEffect(e:GetHandler())
				e1_2:SetType(EFFECT_TYPE_SINGLE)
				e1_2:SetCode(EFFECT_IMMUNE_EFFECT)
				e1_2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
				e1_2:SetRange(LOCATION_MZONE)
				e1_2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
				e1_2:SetValue(c1111403.efilter1_2)
				tc:RegisterEffect(e1_2,true)
			end
		end
	end
end
--
function c1111403.efilter1_2(e,re,tp)
	return re:GetHandlerPlayer()~=e:GetHandlerPlayer()
end
--
function c1111403.limit2(e,c)
	return c:IsType(TYPE_EFFECT)
end
--
function c1111403.op3(e,tp,eg,ep,ev,re,r,rp)
	if eg:GetFirst()~=e:GetHandler() then return end
	local tc=e:GetHandler():GetEquipTarget()
	if tc and tc:GetOriginalCode()==1110131 then
		local e3_1=Effect.CreateEffect(e:GetHandler())
		e3_1:SetDescription(aux.Stringid(1111403,0))
		e3_1:SetType(EFFECT_TYPE_IGNITION)
		e3_1:SetRange(LOCATION_MZONE)
		e3_1:SetCountLimit(1)
		e3_1:SetLabelObject(e:GetHandler())
		e3_1:SetCondition(c1111403.con3_1)
		e3_1:SetCost(c1111403.cost3_1)
		e3_1:SetOperation(c1111403.op3_1)
		tc:RegisterEffect(e3_1,true)
		if e3_1:GetHandler()==nil then return end
	end
	if tc and tc:GetOriginalCode()==1110141 then
		local e3_2=Effect.CreateEffect(e:GetHandler())
		e3_2:SetDescription(aux.Stringid(1111403,1))
		e3_2:SetCategory(CATEGORY_DISABLE)
		e3_2:SetProperty(EFFECT_FLAG_CARD_TARGET)
		e3_2:SetType(EFFECT_TYPE_QUICK_O)
		e3_2:SetRange(LOCATION_MZONE)
		e3_2:SetCode(EVENT_FREE_CHAIN)
		e3_2:SetCountLimit(1)
		e3_2:SetLabelObject(e:GetHandler())
		e3_2:SetCondition(c1111403.con3_2)
		e3_2:SetTarget(c1111403.tg3_2)
		e3_2:SetOperation(c1111403.op3_2)
		tc:RegisterEffect(e3_2,true)
		if e3_2:GetHandler()==nil then return end
	end 
	if tc and tc:GetOriginalCode()==1110142 then
		local e3_3=Effect.CreateEffect(e:GetHandler())
		e3_3:SetDescription(aux.Stringid(1111403,2))
		e3_3:SetCategory(CATEGORY_TODECK+CATEGORY_RECOVER)
		e3_3:SetType(EFFECT_TYPE_IGNITION)
		e3_3:SetRange(LOCATION_MZONE)
		e3_3:SetCountLimit(1)
		e3_3:SetLabelObject(e:GetHandler())
		e3_3:SetCondition(c1111403.con3_3)
		e3_3:SetCost(c1111403.cost3_3)
		e3_3:SetTarget(c1111403.tg3_3)
		e3_3:SetOperation(c1111403.op3_3)
		tc:RegisterEffect(e3_3,true)
		if e3_3:GetHandler()==nil then return end
	end 
end
--
function c1111403.con3_1(e)
	local g=e:GetHandler():GetEquipGroup()
	if g:IsContains(e:GetLabelObject()) then
		return not e:GetLabelObject():IsDisabled()
	else return false
	end
end
function c1111403.cfilter3_1(c)
	return c1111403.IsLw(c) and c:IsAbleToDeckAsCost()
end
function c1111403.cost3_1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c1111403.cfilter3_1,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c1111403.cfilter3_1,tp,LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
	end
end
function c1111403.op3_1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e3_1_1=Effect.CreateEffect(c)
	e3_1_1:SetType(EFFECT_TYPE_SINGLE)
	e3_1_1:SetCode(EFFECT_DIRECT_ATTACK)
	e3_1_1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e3_1_1,true)
end
--
function c1111403.con3_2(e)
	local g=e:GetHandler():GetEquipGroup()
	if g:IsContains(e:GetLabelObject()) then
		return not e:GetLabelObject():IsDisabled()
	else return false
	end
end
function c1111403.tfilter3_2(c)
	return c:IsFaceup() and not c:IsDisabled()
end
function c1111403.tg3_2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and c1111403.tfilter3_2(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c1111403.tfilter3_2,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c1111403.tfilter3_2,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,1,0,LOCATION_ONFIELD)
end
function c1111403.op3_2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if ((tc:IsFaceup() and not tc:IsDisabled()) or tc:IsType(TYPE_TRAPMONSTER)) and tc:IsRelateToEffect(e) then
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e3_2_1=Effect.CreateEffect(c)
		e3_2_1:SetType(EFFECT_TYPE_SINGLE)
		e3_2_1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e3_2_1:SetCode(EFFECT_DISABLE)
		e3_2_1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e3_2_1)
		local e3_2_2=Effect.CreateEffect(c)
		e3_2_2:SetType(EFFECT_TYPE_SINGLE)
		e3_2_2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e3_2_2:SetCode(EFFECT_DISABLE_EFFECT)
		e3_2_2:SetValue(RESET_TURN_SET)
		e3_2_2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e3_2_2)
		if tc:IsType(TYPE_TRAPMONSTER) then
			local e3_2_3=Effect.CreateEffect(c)
			e3_2_3:SetType(EFFECT_TYPE_SINGLE)
			e3_2_3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e3_2_3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
			e3_2_3:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e3_2_3)
		end
		Duel.BreakEffect()
		if tc:IsDisabled() and tc:IsLocation(LOCATION_ONFIELD) and tc:IsFaceup() then
			if tc:IsType(TYPE_MONSTER) then
				local e3_2_4=Effect.CreateEffect(c)
				e3_2_4:SetType(EFFECT_TYPE_SINGLE)
				e3_2_4:SetCode(EFFECT_IMMUNE_EFFECT)
				e3_2_4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
				e3_2_4:SetRange(LOCATION_ONFIELD)
				e3_2_4:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
				e3_2_4:SetValue(c1111403.efilter3_2_4)
				c:RegisterEffect(e3_2_4)
			end
			if tc:IsType(TYPE_SPELL) then
				local e3_2_5=Effect.CreateEffect(c)
				e3_2_5:SetType(EFFECT_TYPE_SINGLE)
				e3_2_5:SetCode(EFFECT_IMMUNE_EFFECT)
				e3_2_5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
				e3_2_5:SetRange(LOCATION_ONFIELD)
				e3_2_5:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
				e3_2_5:SetValue(c1111403.efilter3_2_5)
				c:RegisterEffect(e3_2_5)
			end
			if tc:IsType(TYPE_TRAP) then
				local e3_2_6=Effect.CreateEffect(c)
				e3_2_6:SetType(EFFECT_TYPE_SINGLE)
				e3_2_6:SetCode(EFFECT_IMMUNE_EFFECT)
				e3_2_6:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
				e3_2_6:SetRange(LOCATION_ONFIELD)
				e3_2_6:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
				e3_2_6:SetValue(c1111403.efilter3_2_6)
				c:RegisterEffect(e3_2_6)
			end
		end
	end
end
function c1111403.efilter3_2_4(e,te)
	return te:IsActiveType(TYPE_MONSTER)
end
function c1111403.efilter3_2_5(e,te)
	return te:IsActiveType(TYPE_SPELL)
end
function c1111403.efilter3_2_6(e,te)
	return te:IsActiveType(TYPE_TRAP)
end
--
function c1111403.con3_3(e)
	local g=e:GetHandler():GetEquipGroup()
	if g:IsContains(e:GetLabelObject()) then
		return not e:GetLabelObject():IsDisabled()
	else return false
	end
end
function c1111403.cost3_3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,800) end
	Duel.PayLPCost(tp,800)
end
function c1111403.tg3_3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_REMOVED,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,0,LOCATION_REMOVED)
end
function c1111403.op3_3(e,tp,eg,ep,ev,re,r,rp)
	local num=Duel.GetMatchingGroupCount(aux.TRUE,tp,LOCATION_REMOVED,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_REMOVED,0,1,num,nil)
	if g:GetCount()>0 then
		local num2=Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
		Duel.BreakEffect()
		if num2>0 then
			Duel.Recover(tp,400*num2,REASON_EFFECT)
		end
	end
end