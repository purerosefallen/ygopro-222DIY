--222 擦边球
function c80010053.initial_effect(c)
	--remove
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(80010053,0))
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetCountLimit(1,80010053+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c80010053.condition)
	e1:SetTarget(c80010053.target)
	e1:SetOperation(c80010053.operation)
	c:RegisterEffect(e1)
end
function c80010053.condition(e,tp,eg,ep,ev,re,r,rp)
	local t=Duel.GetFieldGroupCount(tp,0,LOCATION_ONFIELD)
	local s=Duel.GetFieldGroupCount(tp,LOCATION_ONFIELD,0)
	return t-s==1
end
function c80010053.filter(c)
	return c:IsAbleToRemove() and c:IsFaceup()
end
function c80010053.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and c80010053.filter(chkc) and chkc~=e:GetHandler() end
	if chk==0 then return Duel.IsExistingTarget(c80010053.filter,tp,0,LOCATION_ONFIELD,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,c80010053.filter,tp,0,LOCATION_ONFIELD,1,1,e:GetHandler())
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(1000)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,1000)
end
function c80010053.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
		Duel.Damage(1-tp,1000,REASON_EFFECT)
	end
end