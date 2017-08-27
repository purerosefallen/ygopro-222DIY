--ex 头被砍死的幼女
function c80007034.initial_effect(c)
	c:EnableReviveLimit()
	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.FALSE)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(80007034,0))
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(c80007034.spcon)
	e2:SetOperation(c80007034.spop)
	c:RegisterEffect(e2)	
	--coin
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_TOSS_COIN_NEGATE)
	e3:SetCondition(c80007034.coincon)
	e3:SetOperation(c80007034.coinop)
	c:RegisterEffect(e3)
	--tohand
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(80007034,1))
	e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e4:SetCountLimit(1,80007034)
	e4:SetTarget(c80007034.target)
	e4:SetOperation(c80007034.operation)
	c:RegisterEffect(e4)
end
function c80007034.rfilter(c)
	return c:IsSetCard(0x2d9)
end
function c80007034.spcon(e,c)
	if c==nil then return true end
	return Duel.CheckReleaseGroup(c:GetControler(),c80007034.rfilter,2,nil)
end
function c80007034.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.SelectReleaseGroup(c:GetControler(),c80007034.rfilter,2,2,nil)
	Duel.Release(g,REASON_COST)
end
function c80007034.coincon(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp and Duel.GetFlagEffect(tp,80007034)==0
end
function c80007034.coinop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(tp,80007034)~=0 then return end
	if Duel.SelectYesNo(tp,aux.Stringid(80007034,1)) then
		Duel.Hint(HINT_CARD,0,80007034)
		Duel.RegisterFlagEffect(tp,80007034,RESET_PHASE+PHASE_END,0,1)
		Duel.TossCoin(tp,ev)
	end
end
function c80007034.filter(c)
	return c:IsSetCard(0x2d9) and c:IsAbleToHand()
end
function c80007034.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c80007034.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c80007034.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c80007034.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end