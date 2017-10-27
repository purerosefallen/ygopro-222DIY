--Warpko 冰晶天
function c50000040.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,50000040+EFFECT_COUNT_CODE_OATH)
	e1:SetOperation(c50000040.activate)
	c:RegisterEffect(e1)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(50000040,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_TO_DECK)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(c50000040.sptg)
	e3:SetOperation(c50000040.spop)
	c:RegisterEffect(e3)
end
function c50000040.filter(c)
	return c:IsCode(50000032) and c:IsAbleToHand()
end
function c50000040.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(c50000040.filter,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(50000040,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end

function c50000040.spfilter(c,e,tp)
	return c:IsSetCard(0x50a) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c50000040.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsRelateToEffect(e)
		and Duel.GetMZoneCount(tp)>0
		and Duel.IsExistingMatchingCard(c50000040.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c50000040.spop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	if Duel.GetMZoneCount(tp)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c50000040.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end