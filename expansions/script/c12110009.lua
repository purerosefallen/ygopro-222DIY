--绯樱的公主·汐
function c12110009.initial_effect(c)
	--summon
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(12110009,0))
	e0:SetCategory(CATEGORY_SUMMON)
	e0:SetType(EFFECT_TYPE_QUICK_O)
	e0:SetRange(LOCATION_HAND)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetHintTiming(0,0x1c0+TIMING_MAIN_END)
	e0:SetCost(c12110009.sumcost)
	e0:SetTarget(c12110009.sumtg)
	e0:SetOperation(c12110009.sumop)
	c:RegisterEffect(e0)
	--todeck
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(12110009,1))
	e1:SetCategory(CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(2)
	e1:SetTarget(c12110009.tdtg)
	e1:SetOperation(c12110009.tdop)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(12110009,2))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_TO_DECK)
	e2:SetCondition(c12110009.spcon)
	e2:SetCost(c12110009.spcost)
	e2:SetTarget(c12110009.sptg)
	e2:SetOperation(c12110009.spop)
	c:RegisterEffect(e2)
end
function c12110009.cfilter(c)
	return c:IsSetCard(0xbe) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToRemoveAsCost()
end
function c12110009.sumcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:GetFlagEffect(12110009)==0 end
	c:RegisterFlagEffect(12110009,RESET_CHAIN,0,1)
end
function c12110009.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsSummonable(true,nil,1) or c:IsMSetable(true,nil,1) end
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,c,1,0,0)
end
function c12110009.sumop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local pos=0
	if c:IsSummonable(true,nil,1) then pos=pos+POS_FACEUP_ATTACK end
	if c:IsMSetable(true,nil,1) then pos=pos+POS_FACEDOWN_DEFENSE end
	if pos==0 then return end
	if Duel.SelectPosition(tp,c,pos)==POS_FACEUP_ATTACK then
		Duel.Summon(tp,c,true,nil,1)
	else
		Duel.MSet(tp,c,true,nil,1)
	end
end
function c12110009.tdfilter(c)
	return c:IsAbleToDeck()
end
function c12110009.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsAbleToDeck() end
	if chk==0 then return Duel.IsExistingTarget(c12110009.tdfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c12110009.tdfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,2,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
end
function c12110009.tdop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
end
function c12110009.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(Card.IsPreviousLocation,1,nil,LOCATION_GRAVE)
end
function c12110009.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:GetFlagEffect(12110009)==0 end
	c:RegisterFlagEffect(12110009,RESET_CHAIN,0,1)
end
function c12110009.filter(c)
	return c:IsFaceup() and c:GetLevel()>0
end
function c12110009.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c12110009.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c12110009.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c12110009.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	local op=0
	Duel.Hint(HINT_SELECTMSG,tp,550)
	if g:GetFirst():GetLevel()==1 then
		op=Duel.SelectOption(tp,aux.Stringid(12110009,3))
	else
		op=Duel.SelectOption(tp,aux.Stringid(12110009,3),aux.Stringid(12110009,4))
	end
	e:SetLabel(op)
end
function c12110009.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_LEVEL)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		if e:GetLabel()==0 then
			e1:SetValue(1)
		else
			e1:SetValue(-1)
		end
		tc:RegisterEffect(e1)
	end
end