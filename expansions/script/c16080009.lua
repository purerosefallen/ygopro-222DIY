--新津 钢蛾藤熙
function c16080009.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,4,2)
	c:EnableReviveLimit()
	--ChangeAtt 
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DEFCHANGE+CATEGORY_ATKCHANGE)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1)
	e1:SetHintTiming(TIMING_DAMAGE_STEP)
	e1:SetCost(c16080009.cost)
	e1:SetOperation(c16080009.operation)
	c:RegisterEffect(e1)
end
function c16080009.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c16080009.filter(c,e)
	return c:IsFaceup() and not c:IsImmuneToEffect(e)
end
function c16080009.chfilter(c,e)
	return c:IsType(TYPE_MONSTER) 
end
function c16080009.operation(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(c16080009.filter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,e)
	local c=e:GetHandler()
	local tc=sg:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SWAP_AD)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		tc=sg:GetNext()
	end
	local g=Duel.GetMatchingGroup(c16080009.chfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
		Duel.ChangePosition(g,POS_FACEUP_DEFENSE,0,POS_FACEUP_ATTACK,0,true)
end