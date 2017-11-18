--禁忌『红莓陷阱』
function c1152301.initial_effect(c)
--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetTarget(c1152301.tg1)
	e1:SetOperation(c1152301.op1)
	c:RegisterEffect(e1)
--  
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_REMOVED)
	e2:SetCost(c1152301.cost2)
	e2:SetTarget(c1152301.tg2)
	e2:SetOperation(c1152301.op2)
	c:RegisterEffect(e2)
--
end
--
function c1152301.IsFulan(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Fulan
end
function c1152301.IsFulsp(c)
	local m=_G["c"..c:GetCode()]
	return c.named_with_Fulsp
end
--
function c1152301.tfilter1(c)
	return c:IsDestructable()
end
function c1152301.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c1152301.tfilter1,tp,LOCATION_ONFIELD,0,1,nil) end
end
--
function c1152301.op1(e,tp,eg,ep,ev,re,r,rp)
	local g=Group.CreateGroup()
	Duel.ChangeTargetCard(ev,g)
	Duel.ChangeChainOperation(ev,c1152301.op1_1)
	Duel.BreakEffect()
	if Duel.Destroy(e:GetHandler(),REASON_EFFECT)~=0 then
		local e1_2=Effect.CreateEffect(e:GetHandler())
		e1_2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1_2:SetCode(EVENT_PHASE+PHASE_END)
		e1_2:SetCountLimit(1)
		e1_2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		e1_2:SetRange(LOCATION_GRAVE)
		e1_2:SetOperation(c1152301.op1_2)
		e:GetHandler():RegisterEffect(e1_2)
	end
end
function c1152301.op1_1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(1-tp,c1152301.tfilter1,1-tp,LOCATION_ONFIELD,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.Destroy(g,REASON_EFFECT)
	end
	if c:IsType(TYPE_CONTINUOUS) then
		c:CancelToGrave()
	end
end
function c1152301.op1_2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and not e:GetHandler():IsHasEffect(EFFECT_NECRO_VALLEY) then
		local e1_2_1=Effect.CreateEffect(e:GetHandler())
		e1_2_1:SetType(EFFECT_TYPE_SINGLE)
		e1_2_1:SetCode(EFFECT_CHANGE_TYPE)
		e1_2_1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1_2_1:SetValue(TYPE_CONTINUOUS+TYPE_TRAP)
		e1_2_1:SetReset(RESET_EVENT+0x1fe0000)
		e:GetHandler():RegisterEffect(e1_2_1,true) 
		Duel.MoveToField(e:GetHandler(),tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		local e1_2_2=Effect.CreateEffect(e:GetHandler())
		e1_2_2:SetCategory(CATEGORY_DESTROY)
		e1_2_2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
		e1_2_2:SetType(EFFECT_TYPE_IGNITION)
		e1_2_2:SetRange(LOCATION_SZONE)
		e1_2_2:SetCountLimit(1)
		e1_2_2:SetReset(RESET_EVENT+0x1fe0000)
		e1_2_2:SetCondition(c1152301.con1_2_2)
		e1_2_2:SetTarget(c1152301.tg1_2_2)
		e1_2_2:SetOperation(c1152301.op1_2_2)
		e:GetHandler():RegisterEffect(e1_2_2,true) 
	end
end
function c1152301.con1_2_2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetControler()==Duel.GetTurnPlayer()
end
function c1152301.tfilter1_2_2(c)
	return c:IsDestructable()
end
function c1152301.tg1_2_2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(c1152301.tfilter1_2_2,tp,LOCATION_ONFIELD,0,1,nil) and Duel.IsExistingTarget(c1152301.tfilter1_2_2,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELF)
	local g1=Duel.SelectTarget(tp,c1152301.tfilter1_2_2,tp,LOCATION_ONFIELD,0,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPPO)
	local g2=Duel.SelectTarget(tp,c1152301.tfilter1_2_2,tp,0,LOCATION_ONFIELD,1,1,nil)
	g1:Merge(g2)
	Duel.HintSelection(g1)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g1,1,tp,LOCATION_ONFIELD)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g2,1,1-tp,LOCATION_ONFIELD)
end
function c1152301.op1_2_2(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
		if g:GetCount()>0 then
			Duel.Destroy(g,REASON_EFFECT)
		end
	end
end
--
function c1152301.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeckAsCost() end
	Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_COST)
end
--
function c1152301.tfilter2(c)
	return true
end
function c1152301.tg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and chkc:IsControler(tp) and c1152301.tfilter2(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(c1152301.tfilter2,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c1152301.tfilter2,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
end
--
function c1152301.op2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		local e2_1=Effect.CreateEffect(tc)
		e2_1:SetType(EFFECT_TYPE_SINGLE)
		e2_1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e2_1:SetRange(LOCATION_ONFIELD)
		e2_1:SetCode(EFFECT_SELF_DESTROY)
		e2_1:SetCondition(c1152301.con2_1)
		if Duel.GetTurnPlayer()~=tc:GetControler() and Duel.GetCurrentPhase()==PHASE_END then
			e2_1:SetLabel(Duel.GetTurnCount())
			e2_1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN,2)
		else
			e2_1:SetLabel(0)
			e2_1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
		end
		tc:RegisterEffect(e2_1)
	end
end
function c1152301.con2(e)
	return Duel.GetTurnPlayer()~=tc:GetControler() and Duel.GetTurnCount()~=e:GetLabel() and Duel.GetCurrentPhase()==PHASE_END 
end
--

