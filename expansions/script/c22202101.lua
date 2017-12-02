--强制突破
function c22202101.initial_effect(c)
	--negate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCountLimit(1,22202101+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c22202101.con)
	e1:SetOperation(c22202101.op)
	c:RegisterEffect(e1)
	--search
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_TO_HAND)
	e3:SetOperation(c22202101.handop)
	c:RegisterEffect(e3)
	--act in hand
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e2:SetCondition(c22202101.handcon)
	c:RegisterEffect(e2)
end
function c22202101.con(e,tp,eg,ep,ev,re,r,rp)
	return re:IsHasCategory(CATEGORY_NEGATE) or re:IsHasCategory(CATEGORY_DISABLE) or re:IsHasCategory(CATEGORY_DISABLE_SUMMON)
end
function c22202101.filter(c,rtype)
	return c:IsType(rtype) and c:IsAbleToGrave()
end
function c22202101.op(e,tp,eg,ep,ev,re,r,rp)
	local rtype=bit.band(re:GetActiveType(),0x7)
	local g=Group.CreateGroup()
	Duel.ChangeTargetCard(ev,g)
	Duel.ChangeChainOperation(ev,c22202101.repop)
	if Duel.IsExistingMatchingCard(c22202101.filter,tp,LOCATION_DECK,0,1,nil,rtype) and Duel.SelectYesNo(tp,aux.Stringid(22202101,0)) then
		Duel.BreakEffect()
		local sg=Duel.SelectMatchingCard(tp,c22202101.filter,tp,LOCATION_DECK,0,1,1,nil,rtype)
		if sg:GetCount()>0 then Duel.SendtoGrave(sg,REASON_EFFECT) end
	end
end
function c22202101.repop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsType(TYPE_SPELL+TYPE_TRAP) then
		c:CancelToGrave(false)
	end
	Duel.SendtoGrave(c,REASON_EFFECT)
end
function c22202101.handop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	c:RegisterFlagEffect(22202101,RESET_PHASE+PHASE_END,0,1)
end
function c22202101.handcon(e)
	return e:GetHandler():GetFlagEffect(22202101)>0
end