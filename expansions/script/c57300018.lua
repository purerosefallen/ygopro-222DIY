--死奏怜音、玲珑之终
function c57300018.initial_effect(c)
	--Activate(effect)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_CHAINING)
	e2:SetCondition(c57300018.condition2)
	e2:SetCountLimit(1,57300018+EFFECT_COUNT_CODE_OATH)
	e2:SetTarget(c57300018.target2)
	e2:SetOperation(c57300018.activate2)
	c:RegisterEffect(e2)
end
function c57300018.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x570)
end
function c57300018.condition2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsChainNegatable(ev) and Duel.IsExistingMatchingCard(c57300018.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c57300018.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c57300018.activate2(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
