--秘术 灰色奇术
function c21990009.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetHintTiming(0,TIMING_END_PHASE+TIMING_EQUIP)
	e1:SetCountLimit(1,21990009+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c21990009.destg)
	e1:SetOperation(c21990009.spop)
	e1:SetCondition(c21990009.condition)
	c:RegisterEffect(e1)
end
function c21990009.condition(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return not Duel.IsExistingMatchingCard(Card.IsType,tp,LOCATION_GRAVE,0,1,nil,TYPE_TRAP) and (ph==PHASE_MAIN1 or ph==PHASE_MAIN2)
end

function c21990009.spfilter(c,e,tp)
	return c:IsAttribute(ATTRIBUTE_WIND) and c:IsRace(RACE_FAIRY) and c:IsFaceup()
end
function c21990009.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c21990009.spfilter(chkc) end
	if chk==0 then return Duel.IsExistingMatchingCard(c21990009.spfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.SelectTarget(tp,c21990009.spfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c21990009.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local c=e:GetHandler()
	local sg=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,tc)
	if tc:IsRelateToEffect(e) then
		if Duel.ChangePosition(sg,POS_FACEDOWN_DEFENSE) then
			Duel.Draw(1-tp,1,REASON_EFFECT)
		end
	end
end