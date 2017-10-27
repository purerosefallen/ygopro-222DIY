--Warpko 蓅·魉
function c50000041.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.FilterBoolFunction(Card.IsRace,RACE_SPELLCASTER),1)
	c:EnableReviveLimit()
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(50000041,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,50000041)
	e1:SetTarget(c50000041.sptg)
	e1:SetOperation(c50000041.spop)
	c:RegisterEffect(e1)
	--negate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(50000041,1))
	e2:SetCategory(CATEGORY_DISABLE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCost(c50000041.cost)
	e2:SetTarget(c50000041.lvtg)
	e2:SetOperation(c50000041.lvop)
	c:RegisterEffect(e2)
end
function c50000041.spfilter(c,e,tp)
	return c:IsType(TYPE_TUNER) and c:IsSetCard(0x50a) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c50000041.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMZoneCount(tp)>0
		and Duel.IsExistingMatchingCard(c50000041.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c50000041.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetMZoneCount(tp)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c50000041.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end

function c50000041.cffilter(c)
	return c:IsSetCard(0x50a) and not c:IsPublic()
end
function c50000041.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c50000041.cffilter,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,c50000041.cffilter,tp,LOCATION_HAND,0,1,1,e:GetHandler())
	Duel.ConfirmCards(1-tp,g)
	Duel.ShuffleHand(tp)
end
function c50000041.filter(c)
	return c:IsFaceup() and c:GetLevel()>0 and c:GetLevel()~=4
end
function c50000041.lvtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c50000041.filter,tp,LOCATION_MZONE,0,1,nil) end
end
function c50000041.lvop(e,tp,eg,ep,ev,re,r,rp)
	local lv=4
	local g=Duel.GetMatchingGroup(c50000041.filter,tp,LOCATION_MZONE,0,nil)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_LEVEL)
		e1:SetValue(lv)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
		tc=g:GetNext()
	end
end
