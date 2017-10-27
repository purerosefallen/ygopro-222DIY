--★取残された厨二病少女ひなた
function c114005088.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,114005088)
	e1:SetCost(c114005088.hspcost)
	e1:SetTarget(c114005088.hsptg)
	e1:SetOperation(c114005088.hspop)
	c:RegisterEffect(e1)
	--reg
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetOperation(c114005088.regop)
	c:RegisterEffect(e2)
	--search
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetCountLimit(1,114005088)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCondition(c114005088.thcon)
	e3:SetTarget(c114005088.thtg)
	e3:SetOperation(c114005088.thop)
	c:RegisterEffect(e3)
end
--
function c114005088.rfilter(c)
	return c:IsType(TYPE_SPELL) and c:IsAbleToRemoveAsCost()
end
function c114005088.hspcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c114005088.rfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c114005088.rfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c114005088.hsptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMZoneCount(tp)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c114005088.hspop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)==0 and Duel.GetMZoneCount(tp)<=0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) then
		Duel.SendtoGrave(c,REASON_RULE)
	end
end
--
function c114005088.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	c:RegisterFlagEffect(114005088,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
end
function c114005088.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(114005088)>0
end
function c114005088.thfilter(c)
	return c:IsSetCard(0xab0) and c:IsAbleToHand()
end
function c114005088.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c114005088.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c114005088.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c114005088.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 and not g:GetFirst():IsHasEffect(EFFECT_NECRO_VALLEY) then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end