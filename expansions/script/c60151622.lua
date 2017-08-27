--因为，你是我最好的朋友……
function c60151622.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(c60151622.condition)
	e1:SetCost(c60151622.cost)
	e1:SetTarget(c60151622.target)
	e1:SetOperation(c60151622.activate)
	c:RegisterEffect(e1)
end
function c60151622.filter(c)
	return c:IsFaceup() and c:IsSetCard(0xcb25) and c:IsRace(RACE_SPELLCASTER) 
end
function c60151622.condition(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsExistingMatchingCard(c60151622.filter,tp,LOCATION_MZONE,0,1,nil) then return false end
	return ep~=tp and re:IsActiveType(TYPE_MONSTER) and Duel.IsChainNegatable(ev) 
end
function c60151622.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
end
function c60151622.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsAbleToRemove() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,eg,1,0,0)
	end
end
function c60151622.spfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xcb25) and c:IsType(TYPE_MONSTER)
end
function c60151622.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.Remove(eg,POS_FACEUP,REASON_EFFECT)
		local g=Duel.GetMatchingGroup(c60151622.spfilter,tp,LOCATION_MZONE,0,nil)
		if g:GetCount()>0 then
			Duel.BreakEffect()
			local p1=Duel.GetLP(tp)
			local p2=Duel.GetLP(1-tp)
			local s=p2-p1
			if s<0 then s=p1-p2 end
			local d=math.floor(s/1000)
			local tc=g:GetFirst()
			while tc do
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_UPDATE_ATTACK)
				e1:SetValue(d*300)
				e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e1:SetReset(RESET_EVENT+0x1fe0000)
				tc:RegisterEffect(e1)
				tc=g:GetNext()
			end
		end
	end
end