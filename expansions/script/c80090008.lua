--情热传说 德泽尔
function c80090008.initial_effect(c)
	c:SetUniqueOnField(1,0,80090008) 
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c80090008.spcon)
	c:RegisterEffect(e1)	
	--atk/def up
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(80090008,1))
	e2:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_RELEASE)
	e2:SetTarget(c80090008.adtg)
	e2:SetOperation(c80090008.adop)
	c:RegisterEffect(e2)
	--remove
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(80090008,2))
	e5:SetCategory(CATEGORY_REMOVE)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1,80090008)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e5:SetCost(c80090008.rmcost)
	e5:SetTarget(c80090008.rmtg)
	e5:SetOperation(c80090008.rmop)
	c:RegisterEffect(e5) 
end
function c80090008.cffilter(c)
	return c:IsSetCard(0x52d4) and c:IsType(TYPE_MONSTER) and not c:IsPublic()
end
function c80090008.rmcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c80090008.cffilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,c80090008.cffilter,tp,LOCATION_HAND,0,1,1,nil)
	Duel.ConfirmCards(1-tp,g)
	Duel.ShuffleHand(tp)
end
function c80090008.filter(c)
	return c:IsFaceup() and c:IsCode(80090000)
end
function c80090008.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0 and
		Duel.IsExistingMatchingCard(c80090008.filter,c:GetControler(),LOCATION_MZONE,0,1,nil)
end
function c80090008.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,1-tp,LOCATION_HAND)
end
function c80090008.rmop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_HAND,nil)
	if g:GetCount()==0 then return end
	local rg=g:RandomSelect(tp,1)
	local tc=rg:GetFirst()
	Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
	tc:RegisterFlagEffect(80090008,RESET_EVENT+0x1fe0000,0,1)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetCountLimit(1)
	e1:SetLabelObject(tc)
	e1:SetCondition(c80090008.retcon)
	e1:SetOperation(c80090008.retop)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c80090008.retcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:GetFlagEffect(80090008)==0 then
		e:Reset()
		return false
	else
		return true
	end
end
function c80090008.retop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	Duel.SendtoHand(tc,1-tp,REASON_EFFECT)
end
function c80090008.adfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x52d4)
end
function c80090008.adtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c80090008.adfilter,tp,LOCATION_MZONE,0,1,nil) end
end
function c80090008.adop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c80090008.adfilter,tp,LOCATION_MZONE,0,nil)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(1000)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UPDATE_DEFENSE)
		tc:RegisterEffect(e2)
		tc=g:GetNext()
	end
end