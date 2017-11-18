--天罚『六芒星』
function c1151201.initial_effect(c)
--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(1151201,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c1151201.cost1)
	e1:SetTarget(c1151201.tg1)
	e1:SetOperation(c1151201.op1)
	c:RegisterEffect(e1)		
--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(1151201,1))
	e2:SetCategory(CATEGORY_NEGATE+CATEGORY_RELEASE+CATEGORY_DESTROY+CATEGORY_REMOVE)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_CHAINING)
	e2:SetCondition(c1151201.con2)
	e2:SetTarget(c1151201.tg2)
	e2:SetOperation(c1151201.op2)
	c:RegisterEffect(e2)
--
end
--
function c1151201.IsLeimi(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Leimi
end
c1151201.named_with_Leisp=1
function c1151201.IsLeisp(c)
	local m=_G["c"..c:GetCode()]
	return c.named_with_Leisp
end
--
function c1151201.cfilter1(c)
	return c:IsRace(RACE_FIEND) and c:IsType(TYPE_MONSTER)
end
function c1151201.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.IsExistingMatchingCard(c1151201.cfilter1,tp,LOCATION_ONFIELD,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELF)
	local g=Duel.SelectMatchingCard(tp,c1151201.cfilter1,tp,LOCATION_ONFIELD,0,1,1,nil)
	if g:GetCount()>0 then
		local tc=g:GetFirst()
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		local e1_1=Effect.CreateEffect(e:GetHandler())
		e1_1:SetType(EFFECT_TYPE_SINGLE)
		e1_1:SetCode(EFFECT_CHANGE_TYPE)
		e1_1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1_1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
		e1_1:SetReset(RESET_EVENT+0x1fc0000)
		tc:RegisterEffect(e1_1,true)
	end
end
--
function c1151201.tfilter1(c)
	return c:IsAbleToHand()
end
function c1151201.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c1151201.tfilter1,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,LOCATION_ONFIELD)
end
--
function c1151201.op1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPPO)
	local g=Duel.SelectMatchingCard(tp,c1151201.tfilter1,tp,0,LOCATION_ONFIELD,1,2,nil)
	if g:GetCount()==1 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
	else
		if g:GetCount()>1 then
			local tg=g:RandomSelect(tp,1,1,nil)
			local tc=tg:GetFirst()
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			g:RemoveCard(tc)
			Duel.SendtoDeck(g,nil,0,REASON_EFFECT)
		end
	end
end
--
function c1151201.con2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsChainNegatable(ev) and rp~=tp
end
--
function c1151201.tfilter2(c)
	return c:IsAttribute(ATTRIBUTE_DARK) and c:IsRace(RACE_FIEND) and c:IsType(TYPE_MONSTER)
end
function c1151201.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c1151201.tfilter2,tp,LOCATION_ONFIELD,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
--
function c1151201.op2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) then
		local tc=re:GetHandler()
		local code=tc:GetCode()
		local e2_1=Effect.CreateEffect(e:GetHandler())
		e2_1:SetType(EFFECT_TYPE_FIELD)
		e2_1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e2_1:SetCode(EFFECT_CANNOT_ACTIVATE)
		e2_1:SetTargetRange(0,1)
		e2_1:SetValue(c1151201.limit2_1)
		e2_1:SetLabel(code)
		e2_1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e2_1,tp)		
	end
end
function c1151201.limit2_1(e,re)
	return re:GetHandler():GetCode()==e:GetLabel()
end
--