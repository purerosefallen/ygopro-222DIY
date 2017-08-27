--N.十文字 蛮
function c80030013.initial_effect(c)
	c:EnableReviveLimit()
	--cannot special summon
	local e0=Effect.CreateEffect(c)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(aux.FALSE)
	c:RegisterEffect(e0) 
	--immune
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c80030013.efilter)
	c:RegisterEffect(e1)   
	--splimit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(1,0)
	e2:SetCondition(c80030013.splimcon)
	e2:SetTarget(c80030013.splimit)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_CANNOT_SUMMON)
	c:RegisterEffect(e3)
	local e4=e2:Clone()
	e4:SetCode(EFFECT_CANNOT_FLIP_SUMMON)
	c:RegisterEffect(e4)
	--special summon
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_SPSUMMON_PROC)
	e5:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e5:SetRange(LOCATION_HAND)
	e5:SetCondition(c80030013.spcon)
	c:RegisterEffect(e5)
	--activate limit
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(80030013,2))
	e6:SetType(EFFECT_TYPE_QUICK_O)
	e6:SetRange(LOCATION_HAND)
	e6:SetCode(EVENT_FREE_CHAIN)
	e6:SetCondition(c80030013.condition)
	e6:SetCost(c80030013.cost2)
	e6:SetOperation(c80030013.actop)
	c:RegisterEffect(e6)
	--destroy replace
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e7:SetCode(EFFECT_DESTROY_REPLACE)
	e7:SetRange(LOCATION_GRAVE)
	e7:SetTarget(c80030013.reptg)
	e7:SetValue(c80030013.repval)
	e7:SetOperation(c80030013.repop)
	c:RegisterEffect(e7)
end
function c80030013.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end
function c80030013.splimcon(e)
	return not e:GetHandler():IsForbidden()
end
function c80030013.splimit(e,c)
	return not c:IsSetCard(0x92d4)
end
function c80030013.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x92d4)
end
function c80030013.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0 and
		Duel.IsExistingMatchingCard(c80030013.filter,c:GetControler(),LOCATION_MZONE,0,2,nil)
end
function c80030013.actop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetTargetRange(0,1)
	e1:SetCondition(c80030013.actcon)
	e1:SetValue(c80030013.actlimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c80030013.actcon(e)
	local ph=Duel.GetCurrentPhase()
	return ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE
end
function c80030013.actlimit(e,re,tp)
	return not re:GetHandler():IsImmuneToEffect(e)
end
function c80030013.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c80030013.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x92d4)
end
function c80030013.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c80030013.cfilter,tp,LOCATION_MZONE,0,1,nil) and (Duel.GetCurrentPhase()>=PHASE_BATTLE_START and Duel.GetCurrentPhase()<=PHASE_BATTLE)
end
function c80030013.repfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x92d4) and c:IsLocation(LOCATION_MZONE)
		and c:IsControler(tp) and c:IsReason(REASON_EFFECT+REASON_BATTLE)
end
function c80030013.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemove() and eg:IsExists(c80030013.repfilter,1,nil,tp) end
	return Duel.SelectYesNo(tp,aux.Stringid(80030013,0))
end
function c80030013.repval(e,c)
	return c80030013.repfilter(c,e:GetHandlerPlayer())
end
function c80030013.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT)
end