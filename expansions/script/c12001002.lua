--六曜 友引的夕碧姬
function c12001002.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)

	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(12001002,0))
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,12001002)
	e1:SetTarget(c12001002.target)
	e1:SetTarget(c12001002.target1)
	e1:SetOperation(c12001002.operation)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(12001002,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCountLimit(1,12001102)
	e2:SetCondition(c12001002.spcon)
	e2:SetTarget(c12001002.sptg)
	e2:SetOperation(c12001002.spop)
	c:RegisterEffect(e2)
end
function c12001002.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDiscardDeck(tp,1) end
end
function c12001002.filter(c)
	return c:IsSetCard(0xfb0) and c:IsAbleToHand() and c:IsType(TYPE_TRAP)
end
function c12001002.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c12001002.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c12001002.operation(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsPlayerCanDiscardDeck(tp,1) then return end
	Duel.ConfirmDecktop(tp,1)
	local g=Duel.GetDecktopGroup(tp,1)
	local tc=g:GetFirst()
	if tc:IsSetCard(0xfb0) then
		Duel.DisableShuffleCheck()
		Duel.SendtoGrave(g,REASON_EFFECT+REASON_REVEAL)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c12001002.filter,tp,LOCATION_DECK,0,1,1,nil)
		  if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		  end
	else
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ShuffleDeck(tp)
		Duel.SendtoDeck(e:GetHandler(),nil,0,REASON_EFFECT)
end
end
function c12001002.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_DECK) and c:IsReason(REASON_REVEAL)
end
function c12001002.filter1(c,e,tp)
	return c:IsSetCard(0xfb0) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c12001002.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMZoneCount(tp)>0
		and Duel.IsExistingMatchingCard(c12001002.filter1,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c12001002.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetMZoneCount(tp)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c12001002.filter1,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
