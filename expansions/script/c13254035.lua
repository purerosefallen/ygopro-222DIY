--白飞球
function c13254035.initial_effect(c)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(13254035,0))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,13254035)
	e2:SetCost(c13254035.cost1)
	e2:SetTarget(c13254035.sptg)
	e2:SetOperation(c13254035.spop)
	c:RegisterEffect(e2)
	--effect gain
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(13254035,2))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_HAND)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCountLimit(1,23254035)
	e3:SetCost(c13254035.cost2)
	e3:SetTarget(c13254035.eftg)
	e3:SetOperation(c13254035.efop)
	c:RegisterEffect(e3)
	--checkhand
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(13254035,3))
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_HAND)
	e4:SetCountLimit(1,33254035)
	e4:SetCost(c13254035.spcost)
	e4:SetTarget(c13254035.sptarget)
	e4:SetOperation(c13254035.spoperation)
	c:RegisterEffect(e4)
end
function c13254035.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.PayLPCost(tp,1000)
end
function c13254035.filter(c)
	return c:IsAbleToDeck()
end
function c13254035.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and c13254035.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c13254035.filter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c13254035.filter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
end
function c13254035.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
	Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)
	end
end
function c13254035.cfilter(c)
	return c:IsRace(RACE_FAIRY) and c:IsLevelBelow(1) and c:IsAbleToGraveAsCost() and c:IsType(TYPE_MONSTER)
end
function c13254035.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToGraveAsCost() and 
		Duel.IsExistingMatchingCard(c13254035.cfilter,tp,LOCATION_HAND,0,1,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c13254035.cfilter,tp,LOCATION_HAND,0,1,1,c)
	g:AddCard(c)
	Duel.SendtoGrave(g,REASON_COST)
end
function c13254035.effilter(c)
	return c:IsRace(RACE_FAIRY) and c:IsLevelBelow(1) and c:IsFaceup()
end
function c13254035.eftg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:GetLocation()==LOCATION_MZONE and chkc:GetControler()==tp and c13254035.effilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c13254035.effilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c13254035.effilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c13254035.efop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsFacedown() or not tc:IsRelateToEffect(e) then return end
	local e1=Effect.CreateEffect(tc)
		e1:SetDescription(aux.Stringid(13254035,0))
		e1:SetType(EFFECT_TYPE_IGNITION)
		e1:SetRange(LOCATION_MZONE)
		e1:SetCategory(CATEGORY_TODECK)
		e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
		e1:SetCountLimit(1,13254035)
		e1:SetCost(c13254035.cost1)
		e1:SetTarget(c13254035.sptg)
		e1:SetOperation(c13254035.spop)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1,true)
		local e2=Effect.CreateEffect(tc)
		e2:SetDescription(aux.Stringid(13254035,1))
		e2:SetProperty(EFFECT_FLAG_CLIENT_HINT)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e2,true)
		if not tc:IsType(TYPE_EFFECT) then
			local e3=Effect.CreateEffect(tc)
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetCode(EFFECT_ADD_TYPE)
			e3:SetValue(TYPE_EFFECT)
			e3:SetReset(RESET_EVENT+0x1fe0000)
			tc:RegisterEffect(e3,true)
		end
end
function c13254035.cfilter1(c)
	return c:IsSetCard(0x3356) and not c:IsPublic()
end
function c13254035.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return not e:GetHandler():IsPublic() and Duel.IsExistingMatchingCard(c13254035.cfilter1,tp,LOCATION_HAND,0,1,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,c13254035.cfilter1,tp,LOCATION_HAND,0,1,1,c)
	g:AddCard(c)
	Duel.ConfirmCards(1-tp,g)
	Duel.ShuffleHand(tp)
end
function c13254035.sptarget(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsFacedown,tp,0,LOCATION_ONFIELD,1,nil) or Duel.GetFieldGroupCount(tp,0,LOCATION_HAND) end
	Duel.SetTargetPlayer(tp)
end
function c13254035.spoperation(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local g=Duel.GetFieldGroup(p,0,LOCATION_ONFIELD+LOCATION_HAND)
	if g:GetCount()>0 then
		Duel.ConfirmCards(p,g)
		Duel.ShuffleHand(1-p)
	end
end
