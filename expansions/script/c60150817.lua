--爱莎-窒息的痛楚
function c60150817.initial_effect(c)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1,60150817)
	e2:SetCondition(c60150817.spcon)
	e2:SetOperation(c60150817.spop)
	c:RegisterEffect(e2)
	--xyz limit
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	e4:SetValue(c60150817.xyzlimit)
	c:RegisterEffect(e4)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(60150817,1))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL+EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,60150817)
	e1:SetTarget(c60150817.sptg2)
	e1:SetOperation(c60150817.spop2)
	c:RegisterEffect(e1)
end
function c60150817.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetMZoneCount(tp)>0
		and Duel.IsExistingMatchingCard(Card.IsAbleToDeckOrExtraAsCost,tp,LOCATION_REMOVED,LOCATION_REMOVED,2,nil)
end
function c60150817.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(60150817,0))
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToDeckOrExtraAsCost,tp,LOCATION_REMOVED,LOCATION_REMOVED,2,2,nil)
	Duel.SendtoDeck(g,nil,2,REASON_COST)
end
function c60150817.xyzlimit(e,c)
	if not c then return false end
	return not (c:IsAttribute(ATTRIBUTE_DARK) and c:IsRace(RACE_SPELLCASTER))
end
function c60150817.filter(c,e,tp)
	return c:IsSetCard(0x3b23) and c:IsType(TYPE_MONSTER) and c:IsAttribute(ATTRIBUTE_DARK)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c60150817.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMZoneCount(tp)>0
		and Duel.IsExistingMatchingCard(c60150817.filter,tp,LOCATION_DECK,0,1,nil,e,tp) and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_DECK,LOCATION_DECK,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c60150817.spop2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetMZoneCount(tp)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c60150817.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		local tc=g:GetFirst()
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		--xyz limit
		local e4=Effect.CreateEffect(e:GetHandler())
		e4:SetDescription(aux.Stringid(60150822,0))
		e4:SetType(EFFECT_TYPE_SINGLE)
		e4:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CLIENT_HINT)
		e4:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
		e4:SetReset(RESET_EVENT+0xfe0000)
		e4:SetValue(c60150817.xyzlimit)
		tc:RegisterEffect(e4)
		Duel.SpecialSummonComplete()
		Duel.BreakEffect()
		local c=e:GetHandler()
		local res=0
		res=Duel.TossCoin(tp,1)
		if res==0 then
			local g=Duel.GetFieldCard(tp,LOCATION_DECK,0)
			Duel.DisableShuffleCheck()
			Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
		end
		if res==1 then
			local g=Duel.GetFieldCard(1-tp,LOCATION_DECK,0)
			Duel.DisableShuffleCheck()
			Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
		end 
	end
end