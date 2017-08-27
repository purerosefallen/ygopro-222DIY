--风轮的巫女
function c710203.initial_effect(c)
	--to deck and set 
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,710203)
	e1:SetTarget(c710203.target)
	e1:SetOperation(c710203.operation)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
end

c710203.is_named_with_WindWheel=1
function c710203.IsWindWheel(c)
	local m=_G["c"..c:GetCode()]
	return m and m.is_named_with_WindWheel
end

function c710203.filter(c)
	return c:IsFaceup() and c:IsAbleToDeck()
end
function c710203.setfilter(c)
	return c:IsType(TYPE_CONTINUOUS) and c:IsSSetable()
end
function c710203.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c710203.setfilter(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(c710203.setfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g1=Duel.SelectTarget(tp,c710203.filter,tp,LOCATION_ONFIELD,0,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g2=Duel.SelectTarget(tp,c710203.setfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g1,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,g2,1,0,0)
end
function c710203.operation(e,tp,eg,ep,ev,re,r,rp)
	local ex,g1=Duel.GetOperationInfo(0,CATEGORY_TODECK)
	local ex,g2=Duel.GetOperationInfo(0,CATEGORY_LEAVE_GRAVE)
	local tc1=g1:GetFirst()
	local tc2=g2:GetFirst()
	if tc1 and tc1:IsRelateToEffect(e) then
		if Duel.SendtoDeck(tc1,nil,0,REASON_EFFECT)~=0 and  
		tc2:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 then 
			Duel.SSet(tp,tc2)
			Duel.ConfirmCards(1-tp,tc2)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
			e1:SetReset(RESET_EVENT+0x47e0000)
			e1:SetValue(LOCATION_REMOVED)
			tc2:RegisterEffect(e1,true)
		end
	end
end

