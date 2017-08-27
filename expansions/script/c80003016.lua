--DRRR!! 聊天室
function c80003016.initial_effect(c)
	c:EnableCounterPermit(0x1c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,80003016)
	e1:SetOperation(c80003016.activate)
	c:RegisterEffect(e1)
	--counter
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCondition(c80003016.ctcon)
	e2:SetOperation(c80003016.ctop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	--atkup
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_UPDATE_ATTACK)
	e4:SetRange(LOCATION_SZONE)
	e4:SetTargetRange(LOCATION_MZONE,0)
	e4:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x2da))
	e4:SetValue(c80003016.atkval)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	e5:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e5)
	--destroy replace
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e6:SetCode(EFFECT_DESTROY_REPLACE)
	e6:SetRange(LOCATION_SZONE)
	e6:SetTarget(c80003016.destg)
	e6:SetValue(c80003016.value)
	e6:SetOperation(c80003016.desop)
	c:RegisterEffect(e6)
end
function c80003016.filter(c)
	return c:IsSetCard(0x2da) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c80003016.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(c80003016.filter,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(80003016,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end
function c80003016.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x2da)
end
function c80003016.ctcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c80003016.cfilter,1,nil)
end
function c80003016.ctop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():AddCounter(0x1c,1)
end
function c80003016.atkval(e,c)
	return e:GetHandler():GetCounter(0x1c)*100
end
function c80003016.dfilter(c,tp)
	return c:IsFaceup() and c:IsLocation(LOCATION_ONFIELD)
		and c:IsSetCard(0x2da) and c:IsControler(tp) and c:IsReason(REASON_EFFECT)
end
function c80003016.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local count=eg:FilterCount(c80003016.dfilter,nil,tp)
		e:SetLabel(count)
		return count>0 and e:GetHandler():GetCounter(0x1c)>=count*2
	end
	return Duel.SelectYesNo(tp,aux.Stringid(80003016,1))
end
function c80003016.value(e,c)
	return c:IsFaceup() and c:IsLocation(LOCATION_ONFIELD)
		and c:IsSetCard(0x2da) and c:IsControler(e:GetHandlerPlayer()) and c:IsReason(REASON_EFFECT)
end
function c80003016.desop(e,tp,eg,ep,ev,re,r,rp)
	local count=e:GetLabel()
	e:GetHandler():RemoveCounter(ep,0x1c,count*2,REASON_EFFECT)
end