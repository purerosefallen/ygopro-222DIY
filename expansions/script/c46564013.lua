--幸 运 的 借 支
function c46564013.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c46564013.target)
	e1:SetOperation(c46564013.activate)
	c:RegisterEffect(e1)
end
function c46564013.cfilter(c,e,tp)
	return c:IsFaceup() and c:IsSetCard(0x650) and Duel.IsExistingMatchingCard(c46564013.filter,tp,LOCATION_DECK,0,1,nil,c:GetLevel()-1,e,tp)
end
function c46564013.filter(c,lv,e,tp)
	return c:GetLevel()==lv and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsSetCard(0x650)
end
function c46564013.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then
		return Duel.GetMZoneCount(tp)>0
			and Duel.IsExistingTarget(c46564013.cfilter,tp,LOCATION_MZONE,0,1,nil,e,tp)
	end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
		local g=Duel.SelectTarget(tp,c46564013.cfilter,tp,  LOCATION_MZONE,0,1,1,nil,e,tp)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c46564013.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetMZoneCount(tp)<=0 then return end
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c46564013.filter,tp,LOCATION_DECK,0,1,1,nil,tc:GetLevel()-1,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
	local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CANNOT_SUMMON)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetTargetRange(1,0)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetCode(EFFECT_CANNOT_MSET)
		e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e2:SetTargetRange(1,0)
		e2:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e2,tp)

end


