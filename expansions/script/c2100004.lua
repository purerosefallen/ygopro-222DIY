--划空的银屑 飞焰
function c2100004.initial_effect(c)
	--to hand
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(2100004,1))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_HAND)
	e4:SetCountLimit(1,2100004)
	e4:SetTarget(c2100004.sptg)
	e4:SetOperation(c2100004.spop)
	c:RegisterEffect(e4)
	--tuner
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(c2100004.tg)
	e2:SetOperation(c2100004.op)
	c:RegisterEffect(e2)
end
function c2100004.filter(c)
	return c:IsSetCard(0x3219) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
end
function c2100004.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMZoneCount(tp)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.IsExistingMatchingCard(c2100004.filter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,nil) and Duel.IsExistingMatchingCard(c2100004.filter1,tp,LOCATION_DECK,0,1,nil)end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g1=Duel.SelectMatchingCard(tp,c2100004.filter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g1,POS_FACEUP,REASON_COST)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c2100004.filter1(c)
	return c:IsSetCard(0x3219) and not c:IsCode(2100004) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c2100004.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c2100004.filter1,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end
function c2100004.filter2(c)
	return c:IsFaceup() and c:IsSetCard(0x3219) and not c:IsType(TYPE_TUNER)
end
function c2100004.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c2100004.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c2100004.filter2,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c2100004.filter2,tp,LOCATION_MZONE,0,1,1,nil)
end
function c2100004.op(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_ADD_TYPE)
		e1:SetValue(TYPE_TUNER)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_LEVEL)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e1:SetValue(-1)
		tc:RegisterEffect(e1)
	end
end