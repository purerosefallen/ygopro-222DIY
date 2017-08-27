--★昴（すばる）の魔法少女　かずみ
function c114000217.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c114000217.spcon)
	c:RegisterEffect(e1)
	--atkup for all
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(c114000217.target)
	e2:SetValue(500)
	c:RegisterEffect(e2)
	--level
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_UPDATE_LEVEL)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(c114000217.target)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	--atkup during battle
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_UPDATE_ATTACK)
	e4:SetCondition(c114000217.atkcon)
	e4:SetValue(c114000217.atkval)
	c:RegisterEffect(e4)
end
--sp summon function
function c114000217.cfilter(c)
	return c:IsSetCard(0xcabb) and c:IsFaceup() and c:IsType(TYPE_MONSTER)
end
function c114000217.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.GetMatchingGroupCount(c114000217.cfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil)>=4
end
--update attack and level for others
function c114000217.target(e,c)
	return c~=e:GetHandler() and c:IsSetCard(0xcabb)
end
--attack up during battle
function c114000217.atkcon(e)
	local ph=Duel.GetCurrentPhase()
	return (ph==PHASE_DAMAGE or ph==PHASE_DAMAGE_CAL) and (Duel.GetAttacker()==e:GetHandler() or Duel.GetAttackTarget()==e:GetHandler())
end
--determine value
function c114000217.atkfilter(c)
	return c:IsSetCard(0xcabb) and c:IsFaceup()
end
function c114000217.atkval(e,c)
	local g=Duel.GetMatchingGroup(c114000217.atkfilter,c:GetControler(),LOCATION_MZONE,0,nil)
	return g:GetSum(Card.GetLevel)*100
end