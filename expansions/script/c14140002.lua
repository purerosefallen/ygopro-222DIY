--爱意·八重樱
function c14140002.initial_effect(c)
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAIN_SOLVING)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c14140002.discon)
	e1:SetOperation(c14140002.disop)
	c:RegisterEffect(e1)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(14140002,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetTarget(c14140002.sumtg)
	e3:SetOperation(c14140002.sumop)
	c:RegisterEffect(e3)
end
function c14140002.cfilter(c,rc)
	return c:IsAttribute(rc:GetAttribute()) and c:IsRace(rc:GetRace()) and c:IsAbleToGraveAsCost()
end
function c14140002.discon(e,tp,eg,ep,ev,re,r,rp)
	return rp~=tp and Duel.IsChainDisablable(ev) and re:IsActiveType(TYPE_MONSTER) and Duel.IsExistingMatchingCard(c14140002.cfilter,tp,LOCATION_HAND,0,1,e:GetHandler(),re:GetHandler())
end
function c14140002.disop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.SelectYesNo(tp,14140002*16) then return end
	Duel.Hint(HINT_CARD,0,e:GetHandler():GetCode())
	Duel.DiscardHand(tp,c14140002.cfilter,1,1,REASON_COST,e:GetHandler(),re:GetHandler())
	Duel.NegateEffect(ev)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(re:GetHandler(),REASON_EFFECT)
	end
end
function c14140002.filter(c,e,tp)
	return c:IsCode(14140003) and c:IsCanBeSpecialSummoned(e,0,tp,true,true)
end
function c14140002.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMZoneCount(tp)>0
		and Duel.IsExistingMatchingCard(c14140002.filter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c14140002.sumop(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetFirstMatchingCard(c14140002.filter,tp,LOCATION_EXTRA,0,nil,e,tp)
	if tg then
		Duel.SpecialSummon(tg,0,tp,tp,true,true,POS_FACEUP)
	end
end