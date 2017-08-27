--暗堕库垃圾
function c17060853.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--tuner
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(17060853,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCost(c17060853.tncost)
	e1:SetTarget(c17060853.tntg)
	e1:SetOperation(c17060853.tnop)
	c:RegisterEffect(e1)
	--pendulum
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(17060853,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c17060853.pencon)
	e2:SetTarget(c17060853.pentg)
	e2:SetOperation(c17060853.penop)
	c:RegisterEffect(e2)
end
c17060853.is_named_with_Dark_Degenerate=1
function c17060853.IsDark_Degenerate(c)
	local m=_G["c"..c:GetCode()]
	return m and m.is_named_with_Dark_Degenerate
end
function c17060853.filter(c)
	return c:IsFaceup() and c:IsType(TYPE_PENDULUM) and not c:IsType(TYPE_TUNER)
end
function c17060853.tncost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler() end
	Duel.Destroy(e:GetHandler(),nil,0,REASON_COST)
end
function c17060853.tntg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c17060853.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c17060853.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c17060853.filter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c17060853.tnop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_ADD_TYPE)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		e1:SetValue(TYPE_TUNER)
		tc:RegisterEffect(e1)
	end
end
function c17060853.cfilter(c)
	return c:IsFacedown() and not c:IsType(TYPE_PENDULUM)
end
function c17060853.pencon(e,c)
	return not Duel.IsExistingMatchingCard(c17060853.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c17060853.spfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and not c:IsCode(17060853)
end
function c17060853.pentg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_PZONE) and chkc:IsControler(tp) and c17060853.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c17060853.spfilter,tp,LOCATION_PZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c17060853.spfilter,tp,LOCATION_PZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c17060853.penop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and c:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
end