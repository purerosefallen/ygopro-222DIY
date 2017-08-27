--正华 十六夜
function c80006027.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetCountLimit(1,80006027+EFFECT_COUNT_CODE_OATH)
	e1:SetOperation(c80006027.activate)
	c:RegisterEffect(e1)   
	--act in hand
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e2:SetCondition(c80006027.handcon)
	c:RegisterEffect(e2)
	--Activate
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCost(c80006027.thcost)
	e3:SetTarget(c80006027.target1)
	e3:SetOperation(c80006027.activate1)
	c:RegisterEffect(e3) 
end
function c80006027.filter11(c)
	return c:IsFaceup() and c:IsCode(80006054)
end
function c80006027.handcon(e)
	return Duel.IsExistingMatchingCard(c80006027.filter11,e:GetHandlerPlayer(),LOCATION_SZONE,0,1,nil)
end
function c80006027.filter(c)
	return c:IsType(TYPE_MONSTER) and c:IsType(TYPE_RITUAL) and c:IsSetCard(0x2de) 
end
function c80006027.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(c80006027.filter,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_REMOVED,0,nil)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(80006027,0)) then
	local sg=Duel.SelectMatchingCard(tp,c80006027.filter,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,e,tp)
	local tc=sg:GetFirst()
		Duel.SpecialSummon(tc,0,tp,tp,true,true,POS_FACEUP)
	end
end
function c80006027.filter1(c)
	return c:IsCode(80006030) and c:IsAbleToHand()
end
function c80006027.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c80006027.filter1,tp,LOCATION_REMOVED,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_REMOVED)
end
function c80006027.activate1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c80006027.filter1,tp,LOCATION_REMOVED,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c80006027.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end