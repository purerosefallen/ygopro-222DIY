--白夜防护罩 -极冰之力-
function c80002016.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,0x1c0)
	e1:SetTarget(c80002016.target1)
	e1:SetOperation(c80002016.activate1)
	c:RegisterEffect(e1)
	--Activate
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCondition(c80002016.descon)
	e2:SetCost(c80002016.cost)
	e2:SetTarget(c80002016.target)
	e2:SetOperation(c80002016.activate)
	c:RegisterEffect(e2)	
end
function c80002016.filter3(c)
	return c:IsFaceup() and c:IsType(TYPE_EFFECT) and not c:IsDisabled()
end
function c80002016.target1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c80002016.filter3(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c80002016.filter3,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c80002016.filter3,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
end
function c80002016.activate1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and not tc:IsDisabled() then
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
	end
end
function c80002016.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	return true
end
function c80002016.costfilter(c,e,dg)
	if not (c:IsSetCard(0x2db) or c:IsCode(79473793) or c:IsCode(20193924)) then return false end
	local a=0
	if dg:IsContains(c) then a=1 end
	if c:GetEquipCount()==0 then return dg:GetCount()-a>=2 end
	local eg=c:GetEquipGroup()
	local tc=eg:GetFirst()
	while tc do
		if dg:IsContains(tc) then a=a+1 end
		tc=eg:GetNext()
	end
	return dg:GetCount()-a>=2
end
function c80002016.tgfilter(c,e)
	return c:IsAbleToRemove() and c:IsCanBeEffectTarget(e)
end
function c80002016.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then
		if chkc then return chkc:IsOnField() and chkc:IsAbleToRemove() end
		if e:GetLabel()==1 then
			e:SetLabel(0)
			local rg=Duel.GetReleaseGroup(tp)
			local dg=Duel.GetMatchingGroup(c80002016.tgfilter,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE,e:GetHandler(),e)
			local res=rg:IsExists(c80002016.costfilter,1,e:GetHandler(),e,dg)
			return res
		else
			return Duel.IsExistingTarget(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE,2,e:GetHandler())
		end
	end
	if e:GetLabel()==1 then
		e:SetLabel(0)
		local rg=Duel.GetReleaseGroup(tp)
		local dg=Duel.GetMatchingGroup(c80002016.tgfilter,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE,e:GetHandler(),e)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		local sg=rg:FilterSelect(tp,c80002016.costfilter,1,1,e:GetHandler(),e,dg)
		Duel.Release(sg,REASON_COST)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE,2,2,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
end
function c80002016.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=g:Filter(Card.IsRelateToEffect,nil,e)
	Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
end
function c80002016.descon(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(r,REASON_EFFECT)~=0
		and (re:GetHandler():IsSetCard(0x2db) or re:GetHandler():IsCode(79473793) or re:GetHandler():IsCode(20193924)) and not e:GetHandler():IsReason(REASON_RETURN)
end

