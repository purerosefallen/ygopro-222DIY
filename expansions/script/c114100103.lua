--★魔女の残滓(ざんし) 天魔･奴奈比売(てんま･ぬまひめ)
function c114100103.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--get effect
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(c114100103.cost)
	e1:SetTarget(c114100103.target)
	e1:SetOperation(c114100103.operation)
	c:RegisterEffect(e1)
end
function c114100103.cfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost() and c:IsSetCard(0x221)
end
function c114100103.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c114100103.cfilter,tp,LOCATION_GRAVE,0,3,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c114100103.cfilter,tp,LOCATION_GRAVE,0,3,3,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c114100103.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:GetFlagEffect(114100103)==0 end
	--c:RegisterFlagEffect(114100103,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
end
function c114100103.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:GetFlagEffect(114100103)==0 then
		c:RegisterFlagEffect(114100103,RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_END,0,1)
		Duel.SelectOption(tp,aux.Stringid(114100103,0))
		Duel.SelectOption(1-tp,aux.Stringid(114100103,0))
		--disable
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CANNOT_TRIGGER)
		e1:SetReset(RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_END)
		e1:SetRange(LOCATION_MZONE)
		e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
		e1:SetTarget(c114100103.limtarget)
		c:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_DISABLE)
		c:RegisterEffect(e2)
		local e3=e1:Clone()
		e3:SetCode(EFFECT_CANNOT_ATTACK)
		c:RegisterEffect(e3)
	end
end
function c114100103.limtarget(e,c)
	return c~=e:GetHandler() and ( c:IsLevelBelow(5) or c:IsRankBelow(5) ) and not c:IsImmuneToEffect(e)
end