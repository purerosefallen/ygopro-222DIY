--ＰＭ 恰雷姆
function c80000398.initial_effect(c)
	c:SetUniqueOnField(1,0,80000398)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_WARRIOR),aux.NonTuner(Card.IsRace,RACE_WARRIOR),1)
	c:EnableReviveLimit() 
	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.synlimit)
	c:RegisterEffect(e1) 
	--attack cost
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_ATTACK_COST)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(0,1)
	e2:SetCost(c80000398.atcost1)
	e2:SetOperation(c80000398.atop1)
	c:RegisterEffect(e2)
	--attack cost
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_ATTACK_COST)
	e3:SetCost(c80000398.atcost)
	e3:SetOperation(c80000398.atop)
	c:RegisterEffect(e3)  
	--control
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_CANNOT_CHANGE_CONTROL)
	c:RegisterEffect(e4)
end
function c80000398.atcost(e,c,tp)
	return Duel.IsExistingMatchingCard(Card.IsAbleToHandAsCost,tp,0,LOCATION_ONFIELD,1,e:GetHandler())
end
function c80000398.atop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToHandAsCost,tp,0,LOCATION_ONFIELD,1,1,e:GetHandler())
	Duel.SendtoHand(g,nil,REASON_COST)
end
function c80000398.atcost1(e,c,tp)
	return Duel.CheckReleaseGroup(tp,nil,1,e:GetHandler())
end
function c80000398.atop1(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.SelectReleaseGroup(tp,nil,1,1,e:GetHandler())
	Duel.Release(g,REASON_COST)
end