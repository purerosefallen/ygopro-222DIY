--AIW·指引者柴郡猫
function c66619903.initial_effect(c)
	--SpecialSummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(66619903,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetCost(c66619903.tdcost)
	e1:SetTarget(c66619903.sptg)
	e1:SetOperation(c66619903.spop)
	c:RegisterEffect(e1)
	--tohand
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetDescription(aux.Stringid(66619903,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_HAND)
	e2:SetCost(c66619903.dcost)
	e2:SetTarget(c66619903.thtg1)
	e2:SetOperation(c66619903.thop1)
	c:RegisterEffect(e2)
	--tohand
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetDescription(aux.Stringid(66619903,2))
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCost(c66619903.decost)
	e4:SetTarget(c66619903.thtg)
	e4:SetOperation(c66619903.thop)
	c:RegisterEffect(e4)
end
function c66619903.cfilter(c)
	return c:IsFaceup() and c:IsCode(66619916) and c:IsAbleToGraveAsCost()
end
function c66619903.tdcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c66619903.cfilter,tp,LOCATION_SZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c66619903.cfilter,tp,LOCATION_SZONE,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function c66619903.tdfilter1(c,e,tp)
	return c:IsSetCard(0x666) and c:IsAbleToHand()
end
function c66619903.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c66619903.tdfilter1,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c66619903.spop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c66619903.tdfilter1,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c66619903.dcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() and e:GetHandler():IsDiscardable() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c66619903.thfilter(c,e,tp)
	return c:IsCode(66619916) and c:IsAbleToHand() and Duel.IsExistingMatchingCard(c66619903.thfilter2,tp,LOCATION_DECK,0,1,nil,c:GetCode())
end
function c66619903.thfilter2(c,code)
	return c:IsCode(code) and c:IsAbleToHand()
end
function c66619903.thtg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c66619903.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c66619903.thop1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c66619903.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		if Duel.SendtoHand(g,nil,REASON_EFFECT) and Duel.IsExistingMatchingCard(c66619903.thfilter2,tp,LOCATION_DECK,0,1,nil,g:GetFirst():GetCode()) then
		local g1=Duel.SelectMatchingCard(tp,c66619903.thfilter2,tp,LOCATION_DECK,0,1,1,nil,g:GetFirst():GetCode())
		if g1:GetCount()>0 then
			Duel.SendtoHand(g1,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g1)
			Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_DISCARD)
			end
		end
	end
end
function c66619903.decost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c66619903.cfilter,tp,LOCATION_ONFIELD,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c66619903.cfilter,tp,LOCATION_ONFIELD,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function c66619903.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMZoneCount(tp)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c66619903.thop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetMZoneCount(tp)<=0 then return end
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)==1 then
		local e1=Effect.CreateEffect(c)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_ADD_TYPE)
		e1:SetValue(TYPE_TUNER)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		c:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		c:RegisterEffect(e2)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_DISABLE_EFFECT)
		e3:SetReset(RESET_EVENT+0x1fe0000)
		c:RegisterEffect(e3)
	end
end