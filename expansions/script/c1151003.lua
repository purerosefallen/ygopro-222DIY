--红之恶魔·蕾米莉亚
function c1151003.initial_effect(c)
--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCountLimit(1,1151003)
	e1:SetCost(c1151003.cost1)
	e1:SetTarget(c1151003.tg1)
	e1:SetOperation(c1151003.op1)
	c:RegisterEffect(e1) 
--  
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(1151003,0))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCost(c1151003.cost2)
	e2:SetTarget(c1151003.tg2)
	e2:SetOperation(c1151003.op2)
	c:RegisterEffect(e2)
--
end
--
c1151003.named_with_Leimi=1
function c1151003.IsLeimi(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Leimi
end
c1151003.named_with_Leisp=1
function c1151003.IsLeisp(c)
	local m=_G["c"..c:GetCode()]
	return c.named_with_Leisp
end
--
function c1151003.cfilter(c)
	return c:IsAbleToDeck()
end
function c1151003.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c1151003.cfilter1,tp,LOCATION_SZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c1151003.cfilter1,tp,LOCATION_SZONE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
	end
end
--
function c1151003.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,tp,LOCATION_GRAVE)
end
--
function c1151003.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsLocation(LOCATION_GRAVE) then
		if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
			local e1_1=Effect.CreateEffect(c)
			e1_1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
			e1_1:SetCode(EVENT_LEAVE_FIELD)
			e1_1:SetReset(RESET_EVENT+0x01020000)
			e1_1:SetCondition(c1151003.con1_1)
			e1_1:SetOperation(c1151003.op1_1)
			c:RegisterEffect(e1_1)
			local e1_2=Effect.CreateEffect(c)
			e1_2:SetType(EFFECT_TYPE_SINGLE)
			e1_2:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
			e1_2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1_2:SetReset(RESET_EVENT+0x47e0000)
			e1_2:SetValue(LOCATION_REMOVED)
			c:RegisterEffect(e1_2,true)
		end
	end
end
function c1151003.con1_1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousPosition(POS_FACEUP)
end
function c1151003.op1_1(e,tp,eg,ep,ev,re,r,rp,chk)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsPlayerCanSpecialSummonMonster(tp,1151990,0,0x4011,200,200,1,RACE_FIEND,ATTRIBUTE_DARK) then
		Duel.Hint(HINT_CARD,0,1151003)
		local token=Duel.CreateToken(tp,1151990)
		Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
	end
end

--
function c1151003.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	if chk==0 then return true end
end
function c1151003.tfilter2(c,e,tp,eg,ep,ev,re,r,rp)
	if c:GetType()==TYPE_SPELL and c:IsAbleToRemoveAsCost() and c1151003.IsLeisp(c) then
		if c:CheckActivateEffect(true,true,false)~=nil then return true end
		local te=c:GetActivateEffect()
		local con=te:GetCondition()
		if con and not con(e,tp,eg,ep,ev,re,r,rp) then return false end
		local tg=te:GetTarget()
		if tg and not tg(e,tp,eg,ep,ev,re,r,rp,0) then return false end
	end
	return false
end
--
function c1151003.op2(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
	if not te then return end
	e:SetLabelObject(te:GetLabelObject())
	local op=te:GetOperation()
	if op then op(e,tp,eg,ep,ev,re,r,rp) end
	if Duel.GetLocationCount(tp,LOCATION_SZONE)>0 then
		Duel.MoveToField(e:GetHandler(),tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		local e2_1=Effect.CreateEffect(e:GetHandler())
		e2_1:SetCode(EFFECT_CHANGE_TYPE)
		e2_1:SetType(EFFECT_TYPE_SINGLE)
		e2_1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2_1:SetReset(RESET_EVENT+0x1fc0000)
		e2_1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
		e:GetHandler():RegisterEffect(e2_1,true)
	end 
end
--
function c1151003.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()==0 then return false end
		if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return false end
		e:SetLabel(0)
		return Duel.IsExistingMatchingCard(c1151003.tfilter2,tp,LOCATION_GRAVE,0,1,nil,e,tp,eg,ep,ev,re,r,rp)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c1151003.tfilter2,tp,LOCATION_GRAVE,0,1,1,nil,e,tp,eg,ep,ev,re,r,rp)
	local tc=g:GetFirst()
	local te,ceg,cep,cev,cre,cr,crp
	local fchain=c1151003.tfilter2(tc)
	if fchain then
		te,ceg,cep,cev,cre,cr,crp=tc:CheckActivateEffect(true,true,true)
	else
		te=tc:GetActivateEffect()
	end
	Duel.Remove(g,POS_FACEUP,REASON_COST)
	e:SetCategory(te:GetCategory())
	e:SetProperty(te:GetProperty())
	local tg=te:GetTarget()
	if tg then
		if fchain then
			tg(e,tp,ceg,cep,cev,cre,cr,crp,1)
		else
			tg(e,tp,eg,ep,ev,re,r,rp,1)
		end
	end
	te:SetLabelObject(e:GetLabelObject())
	e:SetLabelObject(te)
end
--