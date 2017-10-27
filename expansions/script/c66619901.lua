--AIW·仙境的爱丽丝
function c66619901.initial_effect(c)
	--tograve
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetTarget(c66619901.thtg)
	e1:SetOperation(c66619901.thop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--th
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(29200014,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCondition(c66619901.spcon)
	e3:SetCost(c66619901.cost)
	e3:SetTarget(c66619901.target)
	e3:SetOperation(c66619901.operation)
	c:RegisterEffect(e3)
end
function c66619901.filter1(c)
	return c:IsCode(66619916) and c:IsAbleToHand()
end
function c66619901.filter2(c)
	return c:IsSetCard(0x666) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c66619901.cfilter(c)
	return c:IsFaceup() and c:IsCode(66619916) and c:IsAbleToGrave()
end
function c66619901.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_DECK+LOCATION_GRAVE) and chkc:IsControler(tp) and c66619901.filter1(chkc) end
	local b1=Duel.IsExistingTarget(c66619901.filter1,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil)
	local b2=Duel.IsExistingMatchingCard(c66619901.filter2,tp,LOCATION_DECK,0,1,nil) and Duel.IsExistingTarget(c66619901.cfilter,tp,LOCATION_SZONE,0,1,nil)
	if chk==0 then return b1 or b2 end
	local op=0
	if b1 and b2 then op=Duel.SelectOption(tp,aux.Stringid(66619901,0),aux.Stringid(66619901,1))
	elseif b1 then op=Duel.SelectOption(tp,aux.Stringid(66619901,0))
	else op=Duel.SelectOption(tp,aux.Stringid(66619901,1))+1 end
	e:SetLabel(op)
	if op==0 then
		e:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
	else
		e:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
		local g=Duel.SelectMatchingCard(tp,c66619901.cfilter,tp,LOCATION_SZONE,0,1,1,nil)
		Duel.SendtoGrave(g,REASON_EFFECT)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	end
end
function c66619901.thop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabel()==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c66619901.filter1,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c66619901.filter2,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end
function c66619901.cfilter(c)
	return c:IsFaceup() and c:IsCode(66619916) and c:IsAbleToGraveAsCost()
end
function c66619901.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c66619901.cfilter,tp,LOCATION_SZONE,0,1,nil) and e:GetHandler():IsAbleToDeck() end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c66619901.cfilter,tp,LOCATION_SZONE,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
	Duel.SendtoDeck(e:GetHandler(),c,nil,2,REASON_COST)
end
function c66619901.cfilter1(c)
	return c:IsFaceup() and c:IsCode(66619916)
end
function c66619901.spcon(e)
	local g=Duel.GetFieldGroup(e:GetHandlerPlayer(),LOCATION_SZONE,0)
	return g:IsExists(c66619901.cfilter1,1,nil)
end
function c66619901.spfilter(c,e,tp)
	return c:IsSetCard(0x666) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c66619901.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMZoneCount(tp)>0
		and Duel.IsExistingMatchingCard(c66619901.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c66619901.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetMZoneCount(tp)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c66619901.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end