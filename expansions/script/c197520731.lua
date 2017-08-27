--A?ジェネクス?バードマン
function c197520731.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(197520731,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,197520731)
	e1:SetCost(c197520731.spcost)
	e1:SetTarget(c197520731.sptg)
	e1:SetOperation(c197520731.spop)
	c:RegisterEffect(e1)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(197520731,2))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetHintTiming(0,0x1c0)
	e3:SetCost(c197520731.spcost1)
	e3:SetTarget(c197520731.sptg1)
	e3:SetOperation(c197520731.spop1)
	c:RegisterEffect(e3)
end
function c197520731.cfilter(c,ft,tp)
	return c:IsFaceup() and c:IsAbleToHandAsCost() and (ft>0 or c:IsControler(tp)) and not c:IsCode(197520731)
end
function c197520731.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if chk==0 then return Duel.IsExistingMatchingCard(c197520731.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,ft,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectMatchingCard(tp,c197520731.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,ft,tp)
	Duel.SendtoHand(g,nil,REASON_COST)
end
function c197520731.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local ft=e:GetLabel()*-1
		e:SetLabel(0)
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>ft and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.IsExistingMatchingCard(c197520731.tgfilter,tp,LOCATION_DECK,0,1,nil)
	end
	e:SetLabel(0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c197520731.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or not c197520731.sptg(e,tp,eg,ep,ev,re,r,rp,0) then return end
	if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g2=Duel.SelectMatchingCard(tp,c197520731.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
		if g2:GetCount()>0 then
			Duel.BreakEffect()
			Duel.SendtoGrave(g2,REASON_EFFECT)
		end
	else
		Duel.SendtoGrave(c,REASON_RULE)  
	end
end
function c197520731.tgfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsRace(RACE_WARRIOR) and c:IsAbleToGrave()
end
function c197520731.spfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsRace(RACE_WARRIOR)
end
function c197520731.spcost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c197520731.sptg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and Duel.IsExistingMatchingCard(c197520731.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c197520731.spop1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g1=Duel.SelectMatchingCard(tp,c197520731.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	if g1:GetCount()>0 then
		Duel.SpecialSummon(g1,0,tp,tp,false,false,POS_FACEUP)
	end
end