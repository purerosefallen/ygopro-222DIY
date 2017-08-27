--奇迹糕点 糕点神龙
function c12000031.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0xfbe),aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(12000031,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,12000031)
	e1:SetCondition(c12000031.opcon)
	e1:SetTarget(c12000031.optg)
	e1:SetOperation(c12000031.opop)
	c:RegisterEffect(e1)

	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(12000031,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetHintTiming(0,TIMING_MAIN_END)
	e2:SetCountLimit(1,12000131)
	e2:SetCondition(c12000031.spcon)
	e2:SetTarget(c12000031.sptg)
	e2:SetOperation(c12000031.spop)
	c:RegisterEffect(e2)
end
function c12000031.opcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function c12000031.opfilter(c,e,tp)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToDeck() and c:IsLevelAbove(7)
end
function c12000031.optg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c12000031.opfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_GRAVE)
end
function c12000031.opop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c12000031.opfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		if Duel.SendtoDeck(g,nil,1,REASON_EFFECT)>0 then
			Duel.BreakEffect()
			local tc=g:GetFirst()
			local code=tc:GetOriginalCode()
			if c:IsRelateToEffect(e) and c:IsFaceup() then
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e1:SetReset(RESET_EVENT+0x1ff0000)
				e1:SetCode(EFFECT_CHANGE_CODE)
				e1:SetValue(code)
				c:RegisterEffect(e1)
				c:CopyEffect(code,RESET_EVENT+0x1fe0000,1)
			end
		end
	end
end
function c12000031.spcon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return Duel.GetTurnPlayer()~=tp and (ph==PHASE_MAIN1 or ph==PHASE_MAIN2)
end
function c12000031.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft1=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if chk==0 then return (ft1)>0 and not ((ft1)>1 and Duel.IsPlayerAffectedByEffect(tp,59822133)) and Duel.IsPlayerCanSpecialSummonMonster(tp,12000011,0,0x4011,800,800,3,RACE_ZOMBIE,ATTRIBUTE_FIRE,POS_FACEUP,tp) and Duel.IsPlayerCanSpecialSummonMonster(tp,12000011,0,0x4011,800,800,3,RACE_ZOMBIE,ATTRIBUTE_FIRE,POS_FACEUP,1-tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,ft1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,ft1,0,0)
end
function c12000031.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ft1=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if (ft1)>0 and not ((ft1)>1 and Duel.IsPlayerAffectedByEffect(tp,59822133))
		and Duel.IsPlayerCanSpecialSummonMonster(tp,12000011,0,0x4011,800,800,3,RACE_ZOMBIE,ATTRIBUTE_FIRE,POS_FACEUP,tp) and Duel.IsPlayerCanSpecialSummonMonster(tp,12000011,0,0x4011,800,800,3,RACE_ZOMBIE,ATTRIBUTE_FIRE,POS_FACEUP,1-tp) then
		local fid=c:GetFieldID()
		for i=1,ft1 do
			local token=Duel.CreateToken(tp,12000011)
			Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
		end
		Duel.SpecialSummonComplete()
	end
end