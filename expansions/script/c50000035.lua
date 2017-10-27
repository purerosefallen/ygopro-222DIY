--Warpko 洝研
function c50000035.initial_effect(c)
	--sp
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(50000035,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,50000035)
	e1:SetCost(c50000035.spcost)
	e1:SetTarget(c50000035.sptg)
	e1:SetOperation(c50000035.spop)
	c:RegisterEffect(e1) 
	--summon to
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(50000035,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_HAND)
	e2:SetCountLimit(1,500000351)
	e2:SetCondition(c50000035.tkcon)
	e2:SetTarget(c50000035.tktg)
	e2:SetOperation(c50000035.tkop)
	c:RegisterEffect(e2) 
end
function c50000035.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsPublic() end
end
function c50000035.filter(c,e,tp)
	if not c:IsFaceup() or c:IsCode(50000035) or not c:IsSetCard(0x50a) then return false end
	local g=Duel.GetMatchingGroup(c50000035.filter2,tp,LOCATION_DECK,0,nil,e,tp,c)
	return g:GetClassCount(Card.GetCode)>0
end
function c50000035.filter2(c,e,tp,tc)
	return  c:IsSetCard(0x50a) and not c:IsCode(tc:GetCode()) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c50000035.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c50000035.filter(chkc,e,tp) end
	if chk==0 then return not Duel.IsPlayerAffectedByEffect(tp,50000035)
		and Duel.GetMZoneCount(tp)>0
		and Duel.IsExistingTarget(c50000035.filter,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c50000035.filter,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c50000035.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local ft=Duel.GetMZoneCount(tp)
	local g=Duel.GetMatchingGroup(c50000035.filter2,tp,LOCATION_DECK,0,nil,e,tp,tc)
	if not Duel.IsPlayerAffectedByEffect(tp,50000035)
		and ft>0 and g:GetClassCount(Card.GetCode)>0 and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g1=g:Select(tp,1,1,nil)
		local tc1=g1:GetFirst()
		if tc and  Duel.SpecialSummon(g1,0,tp,tp,false,false,POS_FACEUP)~=0 then
			Duel.BreakEffect()
			Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_EFFECT)
		end
	end
end

function c50000035.tkcon(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(r,REASON_EFFECT)~=0 and e:GetHandler():IsPreviousLocation(LOCATION_DECK)
end
function c50000035.tktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMZoneCount(tp)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,500000352,0x50a,0x4011,0,0,1,RACE_SPELLCASTER,ATTRIBUTE_FIRE) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c50000035.tkop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetMZoneCount(tp)<=0 then return end
	if Duel.IsPlayerCanSpecialSummonMonster(tp,500000352,0x50a,0x4011,0,0,1,RACE_SPELLCASTER,ATTRIBUTE_FIRE) then
		local token=Duel.CreateToken(tp,500000352)
		Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
	end
end