--Sweets Time
function c57310007.initial_effect(c)
	--Senya.nntr(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(57310007,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,57310007+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c57310007.decon)
	e1:SetTarget(c57310007.target)
	e1:SetOperation(c57310007.activate)
	c:RegisterEffect(e1)
end
function c57310007.filter(c)
	return c:IsFaceup() and c:IsHasEffect(57310000)
end
function c57310007.decon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c57310007.filter,tp,LOCATION_MZONE,0,1,nil)
end
function c57310007.defilter(c)
	return c:IsDestructable()
end
function c57310007.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsOnField() and c57310007.defilter(chkc) and chkc~=e:GetHandler() end
	if chk==0 then return Duel.IsExistingTarget(c57310007.defilter,tp,0,LOCATION_ONFIELD,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c57310007.defilter,tp,0,LOCATION_ONFIELD,1,1,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c57310007.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end