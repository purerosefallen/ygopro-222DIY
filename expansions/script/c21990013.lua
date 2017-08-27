--引发奇迹的巫女-东风谷早苗
function c21990013.initial_effect(c)
	--to hand
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(21990013,1))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetCountLimit(1,21990013)
	e4:SetCost(c21990013.discost)
	e4:SetTarget(c21990013.sptg)
	e4:SetOperation(c21990013.spop)
	c:RegisterEffect(e4)
	--disable
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_DISABLE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_SZONE,LOCATION_SZONE)
	e2:SetCondition(c21990013.condition)
	e2:SetTarget(c21990013.distarget)
	c:RegisterEffect(e2)
	--disable effect
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAIN_SOLVING)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c21990013.condition)
	e3:SetOperation(c21990013.disop)
	c:RegisterEffect(e3)
	--disable trap monster
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_DISABLE_TRAPMONSTER)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e4:SetCondition(c21990013.condition)
	e4:SetTarget(c21990013.distarget)
	c:RegisterEffect(e4)
end
function c21990013.disfilter(c)
	return c:IsSetCard(0x9219) and c:IsDiscardable()
end
function c21990013.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c21990013.disfilter,tp,LOCATION_HAND,0,1,nil) and e:GetHandler():IsReleasable() end
	Duel.DiscardHand(tp,c21990013.disfilter,1,1,REASON_COST+REASON_DISCARD,nil)
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c21990013.filter(c,e,tp)
	return c:IsCode(21990001) and c:IsCanBeSpecialSummoned(e,0,tp,true,true)
end
function c21990013.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and Duel.IsExistingMatchingCard(c21990013.filter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c21990013.spop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c21990013.filter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,true,true,POS_FACEUP)
		Duel.ShuffleDeck(tp)
	end
end
function c21990013.condition(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(Card.IsType,tp,LOCATION_GRAVE,0,1,nil,TYPE_TRAP)
end
function c21990013.distarget(e,c)
	return c~=e:GetHandler() and c:IsType(TYPE_TRAP) and c:IsStatus(STATUS_ACTIVATED)
end
function c21990013.disop(e,tp,eg,ep,ev,re,r,rp)
	local tl=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	if tl==LOCATION_SZONE and re:IsActiveType(TYPE_TRAP) and re:GetHandler()~=e:GetHandler() then
		Duel.NegateEffect(ev)
	end
end