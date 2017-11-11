--秘弹『之后就一个人都没有了吗？』
function c1152208.initial_effect(c)
--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c1152208.con1)
	e1:SetTarget(c1152208.tg1)
	e1:SetOperation(c1152208.op1)
	c:RegisterEffect(e1)
--
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN+CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(c1152208.con2)
	e2:SetCost(c1152208.cost2)
	e2:SetTarget(c1152208.tg2)
	e2:SetOperation(c1152208.op2)
	c:RegisterEffect(e2)  
--
end
--
function c1152208.IsFulan(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Fulan
end
c1152208.named_with_Fulsp=1
function c1152208.IsFulsp(c)
	local m=_G["c"..c:GetCode()]
	return c.named_with_Fulsp
end
--
function c1152208.con1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp and Duel.GetCurrentPhase()==PHASE_STANDBY 
end
--
function c1152208.tfilter1(c)
	return c1152208.IsFulan(c) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemove()
end
function c1152208.tg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and chkc:IsControler(tp) and c1152208.tfilter1(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c1152208.tfilter1,tp,LOCATION_ONFIELD,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c1152208.tfilter1,tp,LOCATION_ONFIELD,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
--
function c1152208.op1(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.Remove(tc,0,REASON_EFFECT+REASON_TEMPORARY)~=0 then
		tc:RegisterFlagEffect(1152208,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
		local e1_1=Effect.CreateEffect(e:GetHandler())
		e1_1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1_1:SetCode(EVENT_PHASE+PHASE_END)
		e1_1:SetReset(RESET_PHASE+PHASE_END)
		e1_1:SetLabelObject(tc)
		e1_1:SetCountLimit(1)
		e1_1:SetCondition(c1152208.con1_1)
		e1_1:SetOperation(c1152208.op1_1)
		Duel.RegisterEffect(e1_1,tp)
	end
end
--
function c1152208.con1_1(e,tp,eg,ep,ev,re,r,rp)
	return e:GetLabelObject():GetFlagEffect(1152208)~=0
end
function c1152208.ofilter1_1(c)
	return c:IsType(TYPE_MONSTER)
end
function c1152208.op1_1(e,tp,eg,ep,ev,re,r,rp)
	local gn=Duel.GetMatchingGroup(c1152208.ofilter1_1,tp,LOCATION_ONFIELD,0,nil)
	if gn:GetCount()==0 then
		local c=e:GetHandler()
		local g=Duel.GetMatchingGroup(c1152208.ofilter1_1,tp,0,LOCATION_ONFIELD,nil)
		local num=0
		if g:GetCount()>0 then
			if Duel.Destroy(g,REASON_EFFECT)==g:GetCount() then
				if Duel.ReturnToField(e:GetLabelObject()) then
					num=1
				end
			end
		else
			if Duel.ReturnToField(e:GetLabelObject()) then
				num=1
			end
		end
		if num==1 then
			local e1_1_1=Effect.CreateEffect(e:GetHandler())
			e1_1_1:SetType(EFFECT_TYPE_FIELD)
			e1_1_1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e1_1_1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
			e1_1_1:SetReset(RESET_PHASE+PHASE_END+RESET_SELF_TURN)
			e1_1_1:SetTargetRange(1,0)
			e1_1_1:SetTarget(c1152208.limit1_1_1)
			Duel.RegisterEffect(e1_1_1,tp)
		end
	end
end
function c1152208.limit1_1_1(e,c,sump,sumtype,sumpos,targetp,se)
	return c:IsLocation(LOCATION_EXTRA) and not c:IsType(TYPE_LINK)
end
--
function c1152208.con2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0
end
--
function c1152208.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
--
function c1152208.tfilter2(c)
	return c:IsAbleToDeck() and c1152208.IsFulan(c) and c:IsType(TYPE_MONSTER)
end
function c1152208.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c1152208.tfilter2,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsPlayerCanSpecialSummonMonster(tp,1152990,0,0x4011,0,0,1,RACE_FIEND,ATTRIBUTE_DARK) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_GRAVE+LOCATION_REMOVED)
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)  
end
--
function c1152208.op2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c1152208.tfilter2,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
	if g:GetCount()>0 and Duel.SendtoDeck(g,nil,2,REASON_EFFECT)~=0 then
		local token=Duel.CreateToken(tp,1152990)
		Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
		Duel.SpecialSummonComplete()
	end
end
