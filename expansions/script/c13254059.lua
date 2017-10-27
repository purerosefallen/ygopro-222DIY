--元始飞球
function c13254059.initial_effect(c)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_FLIP_SUMMON)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_SPSUMMON_CONDITION)
	e2:SetValue(aux.FALSE)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOGRAVE)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_EXTRA)
	e3:SetCountLimit(1,13254059)
	e3:SetCost(c13254059.cost)
	e3:SetOperation(c13254059.smop)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetRange(LOCATION_GRAVE+LOCATION_REMOVED)
	e4:SetCode(EFFECT_SEND_REPLACE)
	e4:SetCountLimit(1,23254059)
	e4:SetTarget(c13254059.reptg)
	e4:SetValue(c13254059.repval)
	c:RegisterEffect(e4)
	local e10=Effect.CreateEffect(c)
	e10:SetType(EFFECT_TYPE_SINGLE)
	e10:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e10:SetCode(EFFECT_CHANGE_LEVEL)
	e10:SetRange(LOCATION_MZONE+LOCATION_GRAVE)
	e10:SetValue(1)
	c:RegisterEffect(e10)
	
end
function c13254059.cfilter(c)
	return c:IsSetCard(0x3356) and c:IsType(TYPE_MONSTER) and c:IsDiscardable()
end
function c13254059.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c13254059.cfilter,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.DiscardHand(tp,c13254059.cfilter,1,1,REASON_COST+REASON_DISCARD)
end
function c13254059.smfilter(c)
	return c:IsSetCard(0x3356) and c:IsType(TYPE_MONSTER) and c:IsSummonable(true,nil)
end
function c13254059.smop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SendtoGrave(c,REASON_EFFECT)~=0 and c:IsLocation(LOCATION_GRAVE) then
		sg=Duel.GetMatchingGroup(c13254059.smfilter,tp,LOCATION_HAND,0,nil)
		if Duel.GetMZoneCount(tp)>0 and sg:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(13254059,0)) then
			local g=sg:Select(tp,1,1,nil)
			local tc=g:GetFirst()
			if tc then
				Duel.Summon(tp,tc,true,nil)
			end
		end
	end
end
function c13254059.repfilter(c,tp)
	return c:IsControler(tp) and c:IsLocation(LOCATION_GRAVE) and c:GetDestination()==LOCATION_DECK and c:IsType(TYPE_MONSTER) and c:IsSetCard(0x3356)
		and c:IsAbleToHand()
end
function c13254059.repfilter2(c,tp)
	return c:IsControler(tp) and c:IsLocation(LOCATION_GRAVE) and c:GetDestination()==LOCATION_DECK and c:IsType(TYPE_MONSTER) and c:IsCode(13254059)
		and c:IsAbleToHand()
end
function c13254059.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return bit.band(r,REASON_EFFECT)~=0 and re and eg:IsExists(c13254059.repfilter,1,nil,tp) and not eg:IsExists(c13254059.repfilter2,1,nil,tp) and e:GetHandler():IsAbleToExtra() end
	if Duel.SelectYesNo(tp,aux.Stringid(13254059,1)) then
		local g=eg:Filter(c13254059.repfilter,e:GetHandler(),tp)
		local ct=g:GetCount()
		if ct>1 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
			g=g:Select(tp,1,1,nil)
		end
		local tc=g:GetFirst()
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_TO_DECK_REDIRECT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(LOCATION_HAND)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		tc:RegisterFlagEffect(13254059,RESET_EVENT+0x1de0000+RESET_PHASE+PHASE_END,0,1)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e1:SetCode(EVENT_TO_HAND)
		e1:SetCountLimit(1)
		e1:SetCondition(c13254059.thcon)
		e1:SetOperation(c13254059.thop)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
		Duel.SendtoDeck(e:GetHandler(),tp,2,REASON_EFFECT)
		return true
	else return false end
end
function c13254059.repval(e,c)
	return false
end
function c13254059.thfilter(c)
	return c:GetFlagEffect(13254059)~=0
end
function c13254059.thcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c13254059.thfilter,1,nil)
end
function c13254059.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(c13254059.thfilter,nil)
	Duel.ConfirmCards(1-tp,g)
	Duel.ShuffleHand(tp)
end
