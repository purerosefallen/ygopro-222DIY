--幻蝶的雄姿
function c80070026.initial_effect(c)
	--act in hand
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e3:SetCondition(c80070026.handcon)
	c:RegisterEffect(e3)
	--destroy replace
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetTarget(c80070026.reptg)
	e2:SetValue(c80070026.repval)
	e2:SetOperation(c80070026.repop)
	c:RegisterEffect(e2)   
	--Protection
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(80070026,2))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(c80070026.indop)
	c:RegisterEffect(e1) 
end
function c80070026.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x6a)
end
function c80070026.handcon(e)
	return Duel.IsExistingMatchingCard(c80070026.filter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
function c80070026.repfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x6a) and c:IsLocation(LOCATION_MZONE)
		and c:IsControler(tp) and c:IsReason(REASON_EFFECT+REASON_BATTLE)
end
function c80070026.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemove() and eg:IsExists(c80070026.repfilter,1,nil,tp) end
	return Duel.SelectYesNo(tp,aux.Stringid(80070026,0))
end
function c80070026.repval(e,c)
	return c80070026.repfilter(c,e:GetHandlerPlayer())
end
function c80070026.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT)
end
function c80070026.indop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetValue(1)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsRace,RACE_WARRIOR))
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	Duel.RegisterEffect(e2,tp)
	local e3=Effect.CreateEffect(e:GetHandler())
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetTargetRange(1,0)
	e3:SetValue(1)
	e3:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e3,tp)
end