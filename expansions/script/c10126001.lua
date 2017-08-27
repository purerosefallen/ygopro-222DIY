--反骨的志士 勇
function c10126001.initial_effect(c)
	--SearchCard
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10126001,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCountLimit(1,10126001)
	e1:SetTarget(c10126001.thtg)
	e1:SetOperation(c10126001.thop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)  
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(10126001,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	--e3:SetHintTiming(0,TIMING_END_PHASE)
	e3:SetCountLimit(1,10126101)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCost(c10126001.spcost)
	e3:SetTarget(c10126001.sptg)
	e3:SetOperation(c10126001.spop)
	c:RegisterEffect(e3)
end

function c10126001.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	return true
end
function c10126001.filter1(c,tp)
	local ec=c:GetEquipTarget()
	return ec and ec:IsControler(tp) and c:IsAbleToGraveAsCost()
end
function c10126001.filter2(c,e,tp,ct)
	return c:IsRace(RACE_WARRIOR) and c:IsAttribute(ATTRIBUTE_EARTH) and c:IsLevelBelow(ct) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and not c:IsCode(10126001)
end
function c10126001.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local eqg=Duel.GetMatchingGroup(c10126001.filter1,tp,LOCATION_SZONE,LOCATION_SZONE,nil,tp)
	local ct=eqg:GetCount()+e:GetHandler():GetLevel()
	if chk==0 then
		if e:GetLabel()~=100 then return false end
		e:SetLabel(0)
		return eqg:GetCount()>0 and Duel.IsExistingMatchingCard(c10126001.filter2,tp,0x13,0,1,nil,e,tp,ct) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	end
	local sg=Duel.GetMatchingGroup(c10126001.filter2,tp,0x13,0,nil,e,tp,ct)
	local tg1,lvmax=sg:GetMaxGroup(Card.GetLevel)
	local tg2,lvminx=sg:GetMinGroup(Card.GetLevel)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local rg=eqg:Select(tp,lvmin,lvmax,nil)
	local ct2=Duel.SendtoGrave(rg,REASON_COST)
	c10126001[1]=ct2
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0x13)
end
function c10126001.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c10126001.filter2,tp,0x13,0,1,1,nil,e,tp,c10126001[1]+e:GetHandler():GetLevel())
	if g:GetCount()>0 and not g:GetFirst():IsHasEffect(EFFECT_NECRO_VALLEY) then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c10126001.thfilter(c)
	return c:IsAbleToHand() and c:IsSetCard(0x1335)
end
function c10126001.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10126001.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c10126001.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c10126001.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 and not g:GetFirst():IsHasEffect(EFFECT_NECRO_VALLEY) then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end