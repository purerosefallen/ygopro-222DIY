--灵都并蒂·苜蓿
function c1110131.initial_effect(c)
--
	aux.AddSynchroProcedure(c,c1110131.syfilter1,aux.NonTuner,1)
	c:EnableReviveLimit()
--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetCountLimit(1,1110131)
	e1:SetCondition(c1110131.con1)
	e1:SetTarget(c1110131.tg1)
	e1:SetOperation(c1110131.op1)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_REMOVE)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetCode(EVENT_TO_DECK)
	c:RegisterEffect(e3)
	local e4=e1:Clone()
	e4:SetCode(EVENT_TO_HAND)
	c:RegisterEffect(e4)
--
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_ATTACK_COST)
	e5:SetCost(c1110131.cost5)
	e5:SetOperation(c1110131.op5)
	c:RegisterEffect(e5)
--
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e6:SetValue(1)
	c:RegisterEffect(e6)
	local e7=e6:Clone()
	e7:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e7)
end
--
c1110131.named_with_Ld=1
function c1110131.IsLd(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Ld
end
--
function c1110131.syfilter1(c)
	return c:IsType(TYPE_TUNER) and (c:GetLevel()==1 or c:GetLevel()==3)
end
--
function c1110131.con1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousPosition(POS_FACEUP) and c:IsPreviousLocation(LOCATION_ONFIELD)
end
--
function c1110131.thfilter(c,e,tp)
	return c1110131.IsLd(c) and c:IsAbleToHand() and c:IsType(TYPE_MONSTER)
end
function c1110131.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c1110131.thfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE+LOCATION_REMOVED)
end
--
function c1110131.op1(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.SelectMatchingCard(tp,c1110131.thfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,e:GetHandler())
	if tc then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end
--
function c1110131.filter5(c,e)
	return c:IsAbleToGrave()
end
function c1110131.cost5(e,c,tp)
	return Duel.IsExistingMatchingCard(c1110131.filter5,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,e:GetHandler())
end
--
function c1110131.op5(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c1110131.filter5,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,e:GetHandler())
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_COST)
	end
end
--