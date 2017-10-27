--★魔王聖女ミナト
function c114005077.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCountLimit(1,114005077)
	e1:SetTarget(c114005077.sptg)
	e1:SetOperation(c114005077.spop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetCode(EVENT_FLIP)
	c:RegisterEffect(e3)
	Duel.AddCustomActivityCounter(114005077,ACTIVITY_CHAIN,c114005077.chainfilter)
end

function c114005077.chainfilter(re,tp,cid)
	local rc=re:GetHandler()
	local loc,seq=Duel.GetChainInfo(cid,CHAININFO_TRIGGERING_LOCATION,CHAININFO_TRIGGERING_SEQUENCE)
	return not (re:IsActiveType(TYPE_SPELL))
end

function c114005077.spfilter(c,e,tp)
	return c:IsSetCard(0xabb) and not c:IsSetCard(0xab0) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c114005077.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMZoneCount(tp)>0
		and Duel.IsExistingMatchingCard(c114005077.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp)
		and Duel.GetCustomActivityCount(114005077,tp,ACTIVITY_CHAIN)==0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function c114005077.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetMZoneCount(tp)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c114005077.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 and not g:GetFirst():IsHasEffect(EFFECT_NECRO_VALLEY) then
		if Duel.SpecialSummonStep(g:GetFirst(),0,tp,tp,false,false,POS_FACEUP) then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_SET_ATTACK)
			e1:SetValue(0)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			g:GetFirst():RegisterEffect(e1)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_SET_DEFENSE)
			g:GetFirst():RegisterEffect(e2)
			Duel.SpecialSummonComplete()
		end
	end
end
