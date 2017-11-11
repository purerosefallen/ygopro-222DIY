--禁忌『莱瓦汀』
function c1152201.initial_effect(c)
--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(c1152201.op1)
	c:RegisterEffect(e1)
--  
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_EQUIP)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCondition(c1152201.con2)
	e2:SetTarget(c1152201.tg2)
	e2:SetOperation(c1152201.op2)
	c:RegisterEffect(e2)	 
--
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_EQUIP)
	e3:SetRange(LOCATION_SZONE)
	e3:SetOperation(c1152201.op3)
	c:RegisterEffect(e3) 
--  
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_EQUIP_LIMIT)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e4:SetValue(c1152201.limit4)
	c:RegisterEffect(e4)
--
end
--
function c1152201.IsFulan(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Fulan
end
c1152201.named_with_Fulsp=1
function c1152201.IsFulsp(c)
	local m=_G["c"..c:GetCode()]
	return c.named_with_Fulsp
end
--
function c1152201.ofilter1(c)
	return c:IsType(TYPE_MONSTER) and c:IsFaceup() and c1152201.IsFulan(c)
end
function c1152201.op1(e,tp,eg,ep,ev,re,r,rp)
	local num=0
	local seq=0
	local sg=Group.CreateGroup()
	if (Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0 or Duel.GetLocationCount(1-tp,LOCATION_SZONE)>0) and Duel.GetFieldGroupCount(tp,0,LOCATION_ONFIELD)>0 then
		num=Duel.SelectOption(tp,aux.Stringid(1152201,0),aux.Stringid(1152201,1))
		if num==0 then
			sg=Duel.SelectMatchingCard(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,1,nil)
		else
			seq=Duel.SelectDisableField(tp,1,0,LOCATION_ONFIELD,0)
		end
	else
		if (Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0 or Duel.GetLocationCount(1-tp,LOCATION_SZONE)>0) and Duel.GetFieldGroupCount(tp,0,LOCATION_ONFIELD)==0 then
			seq=Duel.SelectDisableField(tp,1,0,LOCATION_ONFIELD,0)
		else
			sg=Duel.SelectMatchingCard(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,1,nil)
		end
	end
	if sg:GetCount()>0 then
		local tc=sg:GetFirst()
		seq=tc:GetSequence()
		seq=seq+16
		if tc:IsLocation(LOCATION_SZONE) then
			seq=bit.lshift(0x100,seq)
		else
			seq=bit.lshift(0x1,seq)
		end
	end
--  Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(1152201,))
	local e1_1=Effect.CreateEffect(e:GetHandler())
	e1_1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1_1:SetCode(EVENT_PHASE+PHASE_END)
	e1_1:SetCountLimit(1)
	e1_1:SetReset(RESET_PHASE+PHASE_END,2)
	e1_1:SetLabel(seq)
	e1_1:SetCondition(c1152201.con1_1)
	e1_1:SetOperation(c1152201.op1_1)
	Duel.RegisterEffect(e1_1,tp)
	local g=Duel.GetMatchingGroupCount(c1152201.ofilter1,tp,LOCATION_ONFIELD,0,nil)
	if g>0 then
		e:GetHandler():CancelToGrave()
	end
end
function c1152201.con1_1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function c1152201.op1_1(e,tp,eg,ep,ev,re,r,rp)
	local seq=e:GetLabel()
	local sg=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
	if sg:GetCount()>0 then
		local tc=sg:GetFirst()
		while tc do
			seq2=tc:GetSequence()
			seq2=seq2+16
			if tc:IsLocation(LOCATION_SZONE) then
				seq2=bit.lshift(0x100,seq2)
			else
				seq2=bit.lshift(0x1,seq2)
			end
			if seq==seq2 then
				Duel.Hint(HINT_CARD,0,1152201)
				Duel.Destroy(tc,REASON_EFFECT)
			end
			tc=sg:GetNext()
		end
	end
end
--
function c1152201.con2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_DESTROY)
end
--
function c1152201.tfilter2(c)
	return c:IsFaceup() and c1152201.IsFulan(c)
end
function c1152201.tg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c1152201.tfilter2(chkc) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.IsExistingTarget(c1152201.tfilter2,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,c1152201.tfilter2,tp,LOCATION_MZONE,0,1,1,nil)
end
--
function c1152201.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		local tc=Duel.GetFirstTarget()
		if Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and tc:IsFaceup() and tc:IsRelateToEffect(e) then
			local e2_1=Effect.CreateEffect(c)
			e2_1:SetType(EFFECT_TYPE_SINGLE)
			e2_1:SetCode(EFFECT_CHANGE_TYPE)
			e2_1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e2_1:SetValue(TYPE_EQUIP+TYPE_SPELL)
			e2_1:SetReset(RESET_EVENT+0x1fe0000)
			c:RegisterEffect(e2_1,true) 
			Duel.Equip(tp,c,tc,true)
			local e2_2=Effect.CreateEffect(c)
			e2_2:SetType(EFFECT_TYPE_SINGLE)
			e2_2:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
			e2_2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e2_2:SetReset(RESET_EVENT+0x47e0000)
			e2_2:SetValue(LOCATION_REMOVED)
			c:RegisterEffect(e2_2,true)
		end
	end
end
--
function c1152201.op3(e,tp,eg,ep,ev,re,r,rp)
	if eg:GetFirst()~=e:GetHandler() then return end
	local tc=e:GetHandler():GetEquipTarget()
	if tc then
		local e3_1=Effect.CreateEffect(e:GetHandler())
		e3_1:SetCategory(CATEGORY_HANDES)
		e3_1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
		e3_1:SetCode(EVENT_BATTLE_DAMAGE)
		e3_1:SetCountLimit(1)
		e3_1:SetLabelObject(e:GetHandler())
		e3_1:SetCondition(c1152201.con3_1)
		e3_1:SetTarget(c1152201.tg3_1)
		e3_1:SetOperation(c1152201.op3_1)
		tc:RegisterEffect(e3_1)
		if e3_1:GetHandler()==nil then return end
		local e3_2=Effect.CreateEffect(e:GetHandler())
		e3_2:SetType(EFFECT_TYPE_SINGLE)
		e3_2:SetCode(EFFECT_UPDATE_ATTACK)
		e3_2:SetValue(495)
		e3_2:SetLabelObject(e:GetHandler())
		e3_2:SetCondition(c1152201.con3_2)
		tc:RegisterEffect(e3_2)
	end
end
--
function c1152201.con3_1(e)
	local g=e:GetHandler():GetEquipGroup()
	if g:IsContains(e:GetLabelObject()) then
		return not e:GetLabelObject():IsDisabled()
	else return false
	end
end
--
function c1152201.tg3_1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY+CATEGORY_REMOVE,nil,1,1-tp,LOCATION_EXTRA)
end
--
function c1152201.op3_1(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		local g=Duel.GetFieldGroup(ep,LOCATION_EXTRA,0,nil)
		local sg=g:RandomSelect(ep,1)
		if Duel.Destroy(sg,REASON_EFFECT)~=0 then
			Duel.Remove(sg,POS_FACEDOWN,REASON_EFFECT)
		end
	end
end
--
function c1152201.con3_2(e)
	local g=e:GetHandler():GetEquipGroup()
	if g:IsContains(e:GetLabelObject()) then
		return not e:GetLabelObject():IsDisabled()
	else return false
	end
end
--
function c1152201.limit4(e,c)
	return c1152201.IsFulan(c)
end
--
