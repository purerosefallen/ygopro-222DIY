--你的幸福就是我的心愿
function c22261002.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c22261002.condition)
	e1:SetCountLimit(1,22261002+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c22261002.target)
	e1:SetOperation(c22261002.activate)
	c:RegisterEffect(e1)
	--SpecialSummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(22260006,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetCondition(c22261002.spcon)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c22261002.sptg)
	e2:SetOperation(c22261002.spop)
	c:RegisterEffect(e2)
end
function c22261002.IsKuMaKawa(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_KuMaKawa
end
function c22261002.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(c:GetControler(),LOCATION_MZONE,0)==0
end
function c22261002.thfilter1(c)
	return c22261002.IsKuMaKawa(c) and c:IsAbleToHand()
end
function c22261002.thfilter2(c)
	return c:IsCode(22260005) and c:IsAbleToHand()
end
function c22261002.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c22261002.thfilter1,tp,LOCATION_DECK,0,1,nil) and Duel.IsExistingMatchingCard(c22261002.thfilter2,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,tp,LOCATION_DECK)
end
function c22261002.activate(e,tp,eg,ep,ev,re,r,rp)
	if not (Duel.IsExistingMatchingCard(c22261002.thfilter1,tp,LOCATION_DECK,0,1,nil) and Duel.IsExistingMatchingCard(c22261002.thfilter2,tp,LOCATION_DECK,0,1,nil)) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g1=Duel.SelectMatchingCard(tp,c22261002.thfilter1,tp,LOCATION_DECK,0,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g2=Duel.SelectMatchingCard(tp,c22261002.thfilter2,tp,LOCATION_DECK,0,1,1,nil)
	g1:Merge(g2)
	if g1:GetCount()>0 then
		Duel.SendtoHand(g1,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g1)
	end
end
function c22261002.spcfilter(c,tp)
	return c:IsCode(22260005) and c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsPreviousPosition(POS_FACEUP)
end
function c22261002.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c22261002.spcfilter,1,nil,tp)
end
function c22261002.filter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c22261002.IsKuMaKawa(c)
end
function c22261002.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and c22261002.filter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c22261002.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c22261002.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c22261002.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end