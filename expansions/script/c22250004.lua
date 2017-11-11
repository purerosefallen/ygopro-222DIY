--Riviera 菲尔
function c22250004.initial_effect(c)
	--SpecialSummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(22250004,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,222500041)
	e1:SetCost(c22250004.spcost)
	e1:SetTarget(c22250004.sptg)
	e1:SetOperation(c22250004.spop)
	c:RegisterEffect(e1)
	--negate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(22250004,1))
	e2:SetCategory(CATEGORY_NEGATE+CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,222500042)
	e2:SetCost(c22250004.negcost)
	e2:SetCondition(c22250004.negcon)
	e2:SetTarget(c22250004.negtg)
	e2:SetOperation(c22250004.negop)
	c:RegisterEffect(e2)
end
c22250004.named_with_Riviera=1
function c22250004.IsRiviera(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Riviera
end
function c22250004.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c22250004.spfilter(c,code,e,tp)
	return c:IsCode(code) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE)
end
function c22250004.filter(c,e,tp)
	local code=c:GetCode()
	return c:IsFaceup() and c22250004.IsRiviera(c) and c:GetBattledGroupCount()>0 and Duel.IsExistingMatchingCard(c22250004.spfilter,tp,LOCATION_DECK,0,1,nil,code,e,tp)
end
function c22250004.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c22250004.filter(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(c22250004.filter,tp,LOCATION_MZONE,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c22250004.filter,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,nil,tp,LOCATION_DECK)
end
function c22250004.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local code=tc:GetCode()
	local ct=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local sg=Duel.GetMatchingGroup(c22250004.spfilter,tp,LOCATION_DECK,0,nil,code,e,tp)
	local sc=sg:GetCount()
	if sc<ct then ct=sc end 
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local spc=sg:GetFirst()
		local i=0
		while i<ct and spc do
			Duel.SpecialSummon(spc,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
			i=i+1
			spc=sg:GetNext()
		end
	end
end
function c22250004.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c22250004.negcon(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp and re:IsHasType(EFFECT_TYPE_ACTIVATE) and Duel.IsChainNegatable(ev) and c22250004.IsRiviera(re:GetHandler())
end
function c22250004.negfilter(c,code)
	return c:IsCode(code) and c:IsAbleToHand()
end
function c22250004.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local code=re:GetHandler():GetCode()
	if chk==0 then return Duel.IsExistingMatchingCard(c22250004.negfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,code) end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,nil,0,LOCATION_GRAVE+LOCATION_DECK)
end
function c22250004.negop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and Duel.IsExistingMatchingCard(c22250004.negfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,re:GetHandler():GetCode()) then
	local g=Duel.GetMatchingGroup(c22250004.negfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,nil,re:GetHandler():GetCode())
	Duel.SendtoHand(g,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,g)
	end
end