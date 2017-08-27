--★戦いを望む少女 神足ユウ
function c114100333.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,114100333)
	e1:SetCost(c114100333.spcost)
	e1:SetTarget(c114100333.sptg)
	e1:SetOperation(c114100333.spop)
	c:RegisterEffect(e1)
	--sp 2
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_REMOVE)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,114100333)
	e2:SetTarget(c114100333.tg)
	e2:SetOperation(c114100333.op)
	c:RegisterEffect(e2)
end
--sp 1
function c114100333.cfilter(c)
	return c:IsRace(RACE_WARRIOR) and c:IsAttribute(ATTRIBUTE_DARK) and c:IsAbleToRemoveAsCost()
end
function c114100333.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local c=e:GetHandler()
	if chk==0 then 
		if ft==0 then
			return Duel.IsExistingMatchingCard(c114100333.cfilter,tp,LOCATION_MZONE,0,1,c)
		else
			return Duel.IsExistingMatchingCard(c114100333.cfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,c)
		end
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g
	if ft==0 then
		g=Duel.SelectMatchingCard(tp,c114100333.cfilter,tp,LOCATION_MZONE,0,1,1,c)
	else
		g=Duel.SelectMatchingCard(tp,c114100333.cfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,c)
	end
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c114100333.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c114100333.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
--sp 2
function c114100333.filter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and ( c:IsCode(20121116) or c:IsCode(114100054) )
end
function c114100333.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c114100333.filter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
end
function c114100333.op(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c114100333.filter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end