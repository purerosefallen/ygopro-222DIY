--口袋妖怪 可达鸭
function c80000103.initial_effect(c)
	aux.EnableDualAttribute(c)  
	--remove
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(80000103,1))
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCountLimit(1)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c80000103.damcon)
	e2:SetTarget(c80000103.rmtg)
	e2:SetOperation(c80000103.rmop)
	c:RegisterEffect(e2)  
end
c80000103.lvupcount=1
c80000103.lvup={80000104}
function c80000103.damcon(e,tp,eg,ep,ev,re,r,rp)
	return aux.IsDualState(e) 
end
function c80000103.tgfilter(c)
	return c:IsAbleToRemove()
end
function c80000103.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c80000103.tgfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c80000103.tgfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,c80000103.tgfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c80000103.rmop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
	end
end