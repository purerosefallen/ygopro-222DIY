--精灵剑舞绝反
function c5200025.initial_effect(c)
	--Activate(effect)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_CHAINING)
	e2:SetCondition(c5200025.condition2)
	e2:SetCountLimit(1,55200025+EFFECT_COUNT_CODE_OATH)
	e2:SetTarget(c5200025.target2)
	e2:SetOperation(c5200025.activate2)
	c:RegisterEffect(e2)
	--act in hand
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e6:SetCondition(c5200025.handcon)
	c:RegisterEffect(e6)
end
function c5200025.handfilter(c)
	return c:IsFacedown() or not c:IsSetCard(0x360)
end
function c5200025.handcon(e)
	local g=Duel.GetFieldGroup(e:GetHandlerPlayer(),LOCATION_MZONE,0)
	return g:GetCount()>0 and g:GetCount()<3 and not g:IsExists(c5200025.handfilter,1,nil)
end
function c5200025.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x360)
end
function c5200025.condition2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsChainNegatable(ev) and Duel.IsExistingMatchingCard(c5200025.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c5200025.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c5200025.activate2(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
