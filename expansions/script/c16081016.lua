--狐仙 九重樁
function c16081016.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,c16081016.filter,aux.NonTuner(c16081016.sfilter),1)
	c:EnableReviveLimit()
	--cannot sp
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.synlimit)
	c:RegisterEffect(e1)
	--atdis
	local e2=Effect.CreateEffect(c)
	e2:SetCode(EFFECT_CANNOT_TRIGGER)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetTarget(c16081016.actlimit)
	c:RegisterEffect(e2)
	--eff dis
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetCountLimit(1)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c16081016.discon)
	e3:SetCost(c16081016.discost)
	e3:SetTarget(c16081016.distg)
	e3:SetOperation(c16081016.disop)
	c:RegisterEffect(e3)
	--cannot bd
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e4:SetValue(1)
	c:RegisterEffect(e4)
end
function c16081016.filter(c)
	return c:IsAttribute(ATTRIBUTE_WIND) and c:IsRace(RACE_BEAST)
end
function c16081016.sfilter(c)
	return c:IsAttribute(ATTRIBUTE_WIND) and c:IsRace(RACE_BEAST) and c:IsType(TYPE_SYNCHRO)
end
function c16081016.actlimit(e,c)
	return bit.band(c:GetSummonType(),SUMMON_TYPE_SPECIAL)~=0 
end
function c16081016.discon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev)
end
function c16081016.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c16081016.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsAbleToRemove() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,eg,1,0,0)
	end
end
function c16081016.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.Remove(eg,POS_FACEUP,REASON_EFFECT)
	end
end