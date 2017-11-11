--灵曲·年华静谧之月
function c1111223.initial_effect(c)
--
	c:EnableCounterPermit(0x1111)
--  
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(1111223,0))
	e1:SetCategory(CATEGORY_FLIP+CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCountLimit(1,1111223) 
	e1:SetCost(c1111223.cost1)
	e1:SetTarget(c1111223.tg1)
	e1:SetOperation(c1111223.op1)
	c:RegisterEffect(e1)
--  
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(1111223,1))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,1111228) 
	e2:SetCost(c1111223.cost2)
	e2:SetTarget(c1111223.tg2)
	e2:SetOperation(c1111223.op2)
	c:RegisterEffect(e2)
--
end
--
c1111223.named_with_Lq=1
function c1111223.IsLq(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Lq
end
--
function c1111223.cfilter1(c)
	return c:IsAbleToRemoveAsCost() and c:IsType(TYPE_SPELL) and c:IsType(TYPE_CONTINUOUS) and c1111223.IsLq(c)
end
function c1111223.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c1111223.cfilter1,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE) 
	local g=Duel.SelectMatchingCard(tp,c1111223.cfilter1,tp,LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.Remove(tg,POS_FACEUP,REASON_EFFECT)
	end
end
--
function c1111223.tfilter1(c)
	return c:IsCanTurnSet()
end
function c1111223.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local c=e:GetHandler()
	c:SetTurnCounter(0)
	local g=Duel.GetMatchingGroup(c1111223.tfilter1,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,1,0,LOCATION_ONFIELD)
end
--
function c1111223.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		local g=Duel.GetMatchingGroup(c1111223.tfilter1,tp,0,LOCATION_MZONE,nil)
		if g:GetCount()>0 then
			if Duel.ChangePosition(g,POS_FACEDOWN_DEFENSE)~=0 then
				c:AddCounter(0x1111,1)
			end
		end
	end
end
--
function c1111223.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanRemoveCounter(tp,0x1111,1,REASON_COST) end
	e:GetHandler():RemoveCounter(tp,0x1111,1,REASON_COST)
end
--
function c1111223.tfilter2(c)
	return c:IsFaceup()
end
function c1111223.tg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) end
	if chk==0 then return Duel.IsExistingTarget(c1111223.tfilter2,tp,LOCATION_ONFIELD,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELF)
	local g=Duel.SelectTarget(tp,c1111223.tfilter2,tp,LOCATION_ONFIELD,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,1,0,LOCATION_ONFIELD)
end
--
function c1111223.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) then
		local e2_1=Effect.CreateEffect(c)
		e2_1:SetType(EFFECT_TYPE_SINGLE)
		e2_1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e2_1:SetRange(LOCATION_ONFIELD)
		e2_1:SetCode(EFFECT_IMMUNE_EFFECT)
		e2_1:SetValue(c1111223.val2_1)
		e2_1:SetReset(RESET_EVENT+0x1fe0000+RESET_CHAIN)
		c:RegisterEffect(e2_1)
	end
end
function c1111223.val2_1(e,te)
	return e:GetOwnerPlayer()~=re:GetOwnerPlayer()
end
