--Darkest　降临的灾难
function c22232001.initial_effect(c)
	--pos
	local e6=Effect.CreateEffect(c)
	e6:SetCategory(CATEGORY_POSITION)
	e6:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e6:SetType(EFFECT_TYPE_ACTIVATE)
	e6:SetCode(EVENT_FREE_CHAIN)
	e6:SetCountLimit(1,22232001+EFFECT_COUNT_CODE_OATH)
	e6:SetTarget(c22232001.postg)
	e6:SetOperation(c22232001.posop)
	c:RegisterEffect(e6)
	--ppos
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_POSITION)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetCondition(c22232001.spcon)
	e1:SetTarget(c22232001.sptg)
	e1:SetOperation(c22232001.spop)
	c:RegisterEffect(e1)
end
c22232001.named_with_Darkest_D=1
function c22232001.IsDarkest(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Darkest_D
end
function c22232001.postg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsFacedown() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFacedown,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEDOWN)
	local g=Duel.SelectTarget(tp,Card.IsFacedown,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,1,0,0)
end
function c22232001.spfilter(c,e,tp,code)
	return c22232001.IsDarkest(c) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and not c:IsCode(code)
end
function c22232001.posop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local code=tc:GetCode()
	if tc:IsRelateToEffect(e) and tc:IsFacedown() then
		Duel.ChangePosition(tc,POS_FACEUP_DEFENSE)
		if c22232001.IsDarkest(tc) and Duel.GetMZoneCount(tp)>0 and Duel.IsExistingMatchingCard(c22232001.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp,code) then
			local sg=Duel.SelectMatchingCard(tp,c22232001.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp,code)
			if sg:GetCount()>0 then
				Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
			end
		end
	end
end
function c22232001.posfilter(c)
	return c:IsFaceup() and c:IsCanTurnSet()
end
function c22232001.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD) and e:GetHandler():IsReason(REASON_EFFECT)
end
function c22232001.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c22232001.posfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_POSITION,nil,0,0,0)
end
function c22232001.spop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c22232001.posfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	Duel.ChangePosition(g,POS_FACEDOWN_DEFENSE)
end