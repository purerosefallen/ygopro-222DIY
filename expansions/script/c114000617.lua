--逆転の錬成陣
function c114000617.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetDescription(aux.Stringid(114000617,0))
	e1:SetCondition(c114000617.condition)
	e1:SetOperation(c114000617.activate)
	c:RegisterEffect(e1)
	--diseffect
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetDescription(aux.Stringid(114000617,1))
	--e2:SetCondition(c114000617.negcon)
	e2:SetCost(c114000617.negcost)
	e2:SetTarget(c114000617.negtg)
	e2:SetOperation(c114000617.negop)
	c:RegisterEffect(e2)
end
function c114000617.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x221) 
end
function c114000617.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c114000617.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c114000617.activate(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_INACTIVATE)
	e1:SetValue(1)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetValue(c114000617.effectfilter)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_DISEFFECT)
	Duel.RegisterEffect(e2,tp)
end
function c114000617.effectfilter(e,ct)
	local p=e:GetHandler():GetControler()
	local te,tp=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
	local tc=te:GetHandler()
	return p==tp and tc:IsType(TYPE_SPELL+TYPE_TRAP+TYPE_MONSTER)
end
--diseffect cost
function c114000617.costfilter(c)
	return c:IsSetCard(0x221) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
end
function c114000617.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToRemoveAsCost() and 
		Duel.IsExistingMatchingCard(c114000617.costfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c114000617.costfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil)
	g:AddCard(c)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
--diseffect target
function c114000617.filter(c,tp,ep)
	return c:IsFaceup() and c:IsPreviousLocation(LOCATION_EXTRA) and c:GetSummonPlayer()~=tp
end
function c114000617.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=eg:GetFirst()
	if chk==0 then return eg:IsExists(c114000617.filter,1,nil,tp) end
	Duel.SetChainLimit(c114000617.chlimit)
end
function c114000617.chlimit(re,ep,tp)
    return tp==ep or not re:GetHandler():IsType(TYPE_MONSTER)
end
--diseffect operation
function c114000617.filter1(c)
	return c:IsFaceup() and c:IsPreviousLocation(LOCATION_EXTRA)
end
function c114000617.filter2(c)
	return c:IsFaceup() and c:IsPreviousLocation(LOCATION_EXTRA) 
		and c:IsType(TYPE_EFFECT) and not c:IsDisabled()
end
function c114000617.filter3(c)
	return c:IsFaceup() and c:IsPreviousLocation(LOCATION_EXTRA) 
		and c:IsType(TYPE_XYZ)
end
function c114000617.negop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	--decrease attack & defense
	local g1=Duel.GetMatchingGroup(c114000617.filter1,tp,0,LOCATION_MZONE,nil)
	tc1=g1:GetFirst()
	while tc1 do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(-1000)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc1:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_UPDATE_DEFENSE)
		e2:SetValue(-1000)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		tc1:RegisterEffect(e2)
		tc1=g1:GetNext()
	end
	--disable effect
	local g2=Duel.GetMatchingGroup(c114000617.filter2,tp,0,LOCATION_MZONE,nil)
	local tc2=g2:GetFirst()
	while tc2 do
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_DISABLE)
		e3:SetReset(RESET_EVENT+0x1fe0000)
		tc2:RegisterEffect(e3)
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_SINGLE)
		e4:SetCode(EFFECT_DISABLE_EFFECT)
		e4:SetReset(RESET_EVENT+0x1fe0000)
		tc2:RegisterEffect(e4)
		tc2=g2:GetNext()
	end
	--take out all XYZ material
	local g3=Duel.GetMatchingGroup(c114000617.filter3,tp,0,LOCATION_MZONE,nil)
	local tc3=g3:GetFirst()
	while tc3 do
	    local cg=tc3:GetOverlayGroup()
        Duel.SendtoGrave(cg,REASON_EFFECT)
		tc3=g3:GetNext()
	end
end