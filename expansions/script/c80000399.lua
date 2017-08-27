--ＰＭ Mega恰雷姆
function c80000399.initial_effect(c)
	c:EnableReviveLimit()
	c:SetUniqueOnField(1,0,10000000)
	if c:IsStatus(STATUS_COPYING_EFFECT) then return end
	--spsummon condition
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(aux.FALSE)
	c:RegisterEffect(e0)  
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetValue(c80000399.efilter)
	c:RegisterEffect(e1) 
	--control
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_CANNOT_CHANGE_CONTROL)
	c:RegisterEffect(e2)  
	--attack cost
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_ATTACK_COST)
	e3:SetCost(c80000399.atcost)
	e3:SetOperation(c80000399.atop)
	c:RegisterEffect(e3)  
	--cannot release
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_UNRELEASABLE_SUM)
	e4:SetValue(1)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EFFECT_UNRELEASABLE_NONSUM)
	c:RegisterEffect(e5)
	--attack cost
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetCode(EFFECT_ATTACK_COST)
	e6:SetRange(LOCATION_MZONE)
	e6:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e6:SetTargetRange(0,1)
	e6:SetCost(c80000399.atcost1)
	e6:SetOperation(c80000399.atop1)
	c:RegisterEffect(e6)
	--ATK
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE)
	e7:SetCode(EFFECT_UPDATE_ATTACK)
	e7:SetCondition(c80000399.atkcon)
	e7:SetValue(2000)
	c:RegisterEffect(e7)
end
function c80000399.efilter(e,te)
	if not te:IsActiveType(TYPE_MONSTER) then return false end
	local c=e:GetHandler()
	local ec=te:GetHandler()
	if ec:IsHasCardTarget(c) then return true end
	return te:IsHasType(EFFECT_TYPE_ACTIONS) and te:IsHasProperty(EFFECT_FLAG_CARD_TARGET) and c:IsRelateToEffect(te)
end
function c80000399.atcost(e,c,tp)
	return Duel.IsExistingMatchingCard(Card.IsAbleToDeckAsCost,tp,0,LOCATION_ONFIELD,1,e:GetHandler())
end
function c80000399.atop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToDeckAsCost,tp,0,LOCATION_ONFIELD,1,1,e:GetHandler())
	Duel.SendtoDeck(g,nil,2,REASON_COST)
end
function c80000399.atcost1(e,c,tp)
	return Duel.CheckReleaseGroup(tp,nil,1,e:GetHandler())
end
function c80000399.atop1(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.SelectReleaseGroup(tp,nil,1,1,e:GetHandler())
	Duel.Release(g,REASON_COST)
end
function c80000399.atkcon(e,tp,eg,ep,ev,re,r,rp)
  local ph=Duel.GetCurrentPhase()
  local c=e:GetHandler()
	return (ph==PHASE_DAMAGE or ph==PHASE_DAMAGE_CAL) and Duel.GetAttacker()==c 
end