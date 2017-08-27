--口袋妖怪 火神虫
function c80000352.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure2(c,aux.FilterBoolFunction(c80000352.sfilter),aux.NonTuner(c80000352.sfilter1))
	c:EnableReviveLimit()  
	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.synlimit)
	c:RegisterEffect(e1) 
	--Immune
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(aux.tgoval)
	c:RegisterEffect(e3)
	local e2=e3:Clone()
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e2:SetValue(c80000352.tgvalue)
	c:RegisterEffect(e2)
	--multi attack
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(80000352,1))
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1)
	e5:SetCondition(c80000352.condition1)
	e5:SetCost(c80000352.cost)
	e5:SetOperation(c80000352.operation1)
	c:RegisterEffect(e5)
end
function c80000352.tgvalue(e,re,rp)
	return rp~=e:GetHandlerPlayer()
end
function c80000352.sfilter(c)
	return c:IsSetCard(0x2d0) and c:IsAttribute(ATTRIBUTE_FIRE)
end
function c80000352.sfilter1(c)
	return c:IsSetCard(0x2d0) and c:IsRace(RACE_INSECT) and c:GetLevel()==6
end
function c80000352.condition1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsAbleToEnterBP() and Duel.GetLP(tp)<=Duel.GetLP(1-tp)-3000
end
function c80000352.filter(c)
	return c:IsRace(RACE_INSECT) and c:IsAbleToRemoveAsCost() and c:GetLevel()==6
end
function c80000352.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c80000352.filter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c80000352.filter,tp,LOCATION_GRAVE,0,1,99,nil)
	e:SetLabel(g:GetCount())
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c80000352.operation1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EXTRA_ATTACK)
		e1:SetValue(e:GetLabel())
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
	end
end