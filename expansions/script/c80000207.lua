--裂空的阻碍
function c80000207.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c80000207.actcon)
	c:RegisterEffect(e1)
	--cannot attack
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_ATTACK_ANNOUNCE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(0,LOCATION_MZONE)
	c:RegisterEffect(e2)
	--
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetCountLimit(1)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCondition(c80000207.tgcon)
	e3:SetOperation(c80000207.tgop)
	c:RegisterEffect(e3)
	--act in hand
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e4:SetCondition(c80000207.handcon)
	c:RegisterEffect(e4)
end
function c80000207.filter(c)
	return c:IsFaceup() and c:IsCode(80000143)
end
function c80000207.handcon(e)
	return Duel.IsExistingMatchingCard(c80000207.filter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
function c80000207.cfilter(c)
	return c:IsSetCard(0x2d0) and c:IsLevelAbove(7)
end
function c80000207.actcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c80000207.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c80000207.distg(e,c)
	return bit.band(c:GetSummonType(),SUMMON_TYPE_ADVANCE)~=SUMMON_TYPE_ADVANCE
end
function c80000207.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
		and not Duel.IsExistingMatchingCard(c80000207.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c80000207.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SendtoGrave(e:GetHandler(),REASON_EFFECT)
end