--AIW·疯帽子
function c66619904.initial_effect(c)
	--SpecialSummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetTarget(c66619904.thtg)
	e1:SetOperation(c66619904.thop)
	c:RegisterEffect(e1)
	--tur
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(66619904,0))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1)
	e2:SetTarget(c66619904.adtg1)
	e2:SetOperation(c66619904.adop1)
	c:RegisterEffect(e2)
	--spsummon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(66619904,0))
	e4:SetCategory(CATEGORY_DRAW)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_BE_MATERIAL)
	e4:SetCondition(c66619904.con)
	e4:SetCost(c66619904.darwcost)
	e4:SetTarget(c66619904.drtg)
	e4:SetOperation(c66619904.drop)
	c:RegisterEffect(e4)
end
function c66619904.filter1(c)
	return c:IsCode(66619916) and c:IsAbleToHand()
end
function c66619904.filter2(c,e,tp)
	return c:IsSetCard(0x666) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and not c:IsType(TYPE_SYNCHRO)
end
function c66619904.cfilter(c)
	return c:IsFaceup() and c:IsCode(66619916) and c:IsAbleToGrave()
end
function c66619904.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_DECK+LOCATION_GRAVE) and chkc:IsControler(tp) and c66619904.filter1(chkc) and Duel.GetMZoneCount(tp)>0 end
	local b1=Duel.IsExistingTarget(c66619904.filter1,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil)
	local b2=Duel.IsExistingTarget(c66619904.filter2,tp,LOCATION_GRAVE,0,1,nil,e,tp) and Duel.IsExistingTarget(c66619904.cfilter,tp,LOCATION_ONFIELD,0,1,nil)
	if chk==0 then return b1 or b2 and Duel.IsExistingTarget(c66619904.filter2,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	local op=0
	if b1 and b2 then op=Duel.SelectOption(tp,aux.Stringid(66619904,0),aux.Stringid(66619904,1))
	elseif b1 then op=Duel.SelectOption(tp,aux.Stringid(66619904,0))
	else op=Duel.SelectOption(tp,aux.Stringid(66619904,1))+1 end
	e:SetLabel(op)
	if op==0 then
		e:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
	else
		e:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
		local g=Duel.SelectMatchingCard(tp,c66619904.cfilter,tp,LOCATION_ONFIELD,0,1,1,nil)
		Duel.SendtoGrave(g,REASON_EFFECT)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
	end
end
function c66619904.thop(e,tp,eg,ep,ev,re,r,rp)
		local c=e:GetHandler()
	if e:GetLabel()==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c66619904.filter1,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	else
		if Duel.GetMZoneCount(tp)<=0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectTarget(tp,c66619904.filter2,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
		local tc=Duel.GetFirstTarget()
		if tc:IsRelateToEffect(e) then
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
function c66619904.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x666)
end
function c66619904.adtg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c66619904.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c66619904.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c66619904.filter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c66619904.adop1(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_ADD_TYPE)
		e1:SetValue(TYPE_TUNER)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
end
function c66619904.con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsLocation(LOCATION_GRAVE) and r==REASON_SYNCHRO
end
function c66619904.darwfilter(c)
	return c:IsFaceup() and c:IsCode(66619916) and c:IsAbleToDeckAsCost()
end
function c66619904.darwcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(c66619904.darwfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c66619904.darwfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SendtoDeck(g,nil,2,REASON_COST)
end
function c66619904.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c66619904.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end