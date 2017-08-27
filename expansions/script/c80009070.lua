--爱心徽章
function c80009070.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,80009070+EFFECT_COUNT_CODE_OATH)
	e1:SetOperation(c80009070.activate1)
	c:RegisterEffect(e1) 
	--Activate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(80009070,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCountLimit(1,80009071)
	e2:SetRange(LOCATION_SZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCondition(c80009070.spcon)
	e2:SetTarget(c80009070.target)
	e2:SetOperation(c80009070.activate)
	c:RegisterEffect(e2)
end
function c80009070.filter5(c)
	return c:IsCode(80009016) or c:IsCode(80009018) and c:IsAbleToHand()
end
function c80009070.activate1(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(c80009070.filter5,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(80009070,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end
function c80009070.spfilter(c)
	return c:IsFaceup() and c:IsCode(80009064)
end
function c80009070.spcon(e,c)
	return Duel.IsExistingMatchingCard(c80009070.spfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function c80009070.filter1(c,e,tp)
	return c:IsFaceup() and c:IsCode(80009020)
		and Duel.IsExistingMatchingCard(c80009070.filter2,tp,LOCATION_EXTRA+LOCATION_GRAVE,0,1,nil,e,tp,c,nil)
end
function c80009070.filter2(c,e,tp,mc,rk)
	return c:IsCode(80009022) and mc:IsCanBeXyzMaterial(c)
		and c:IsCanBeSpecialSummoned(e,0,tp,true,true)
end
function c80009070.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c80009070.filter1(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and Duel.IsExistingTarget(c80009070.filter1,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c80009070.filter1,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA+LOCATION_GRAVE)
	Duel.SetChainLimit(aux.FALSE)
end
function c80009070.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<0 then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsFacedown() or not tc:IsRelateToEffect(e) or tc:IsControler(1-tp) or tc:IsImmuneToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c80009070.filter2,tp,LOCATION_EXTRA+LOCATION_GRAVE,0,1,1,nil,e,tp,tc,nil)
	local sc=g:GetFirst()
	if sc then
		local mg=tc:GetOverlayGroup()
		if mg:GetCount()~=0 then
			Duel.Overlay(sc,mg)
		end
		sc:SetMaterial(Group.FromCards(tc))
		Duel.Overlay(sc,Group.FromCards(tc))
		Duel.SpecialSummon(sc,0,tp,tp,true,true,POS_FACEUP)
		sc:CompleteProcedure()
		Duel.BreakEffect()
		Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_EFFECT)
	end
end
