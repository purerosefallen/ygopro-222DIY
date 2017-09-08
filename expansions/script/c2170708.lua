--七曜-月符『沉静的月神』
function c2170708.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,2170708+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c2170708.sdcon)
	e1:SetHintTiming(0,0x1c0)
	e1:SetTarget(c2170708.target)
	e1:SetOperation(c2170708.activate)
	c:RegisterEffect(e1)
end
function c2170708.sdfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x211)
end
function c2170708.sdcon(e)
	return Duel.IsExistingMatchingCard(c2170708.sdfilter,e:GetHandlerPlayer(),LOCATION_GRAVE,0,2,e:GetHandler())
end
function c2170708.filter(c)
	return c:IsFaceup() and not c:IsDisabled()
end
function c2170708.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and chkc:IsControler(1-tp) and c2170708.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c2170708.filter,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c2170708.filter,tp,0,LOCATION_ONFIELD,1,1,nil)
end
function c2170708.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and not tc:IsDisabled() and tc:IsControler(1-tp) then
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
	end
end