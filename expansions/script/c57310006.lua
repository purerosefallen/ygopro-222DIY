--梦幻泡影
function c57310006.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,57310006+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c57310006.target)
	e1:SetOperation(c57310006.activate)
	c:RegisterEffect(e1)
end
function c57310006.filter(c,e,tp)
	return c:IsHasEffect(57310000)
end
function c57310006.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and c57310006.filter(chkc,e,tp) end
	if chk==0 then return Duel.GetMZoneCount(tp)>0
		and Duel.IsExistingTarget(c57310006.filter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectTarget(tp,c57310006.filter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil,e,tp)
end
function c57310006.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.GetMZoneCount(tp)>0 then
		Duel.MoveToField(tc,tp,tp,LOCATION_MZONE,POS_FACEUP,true)
	end
end
