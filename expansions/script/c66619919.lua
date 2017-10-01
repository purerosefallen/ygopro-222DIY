--仙境的血腥王座
function c66619919.initial_effect(c)
	--change name
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_CHANGE_CODE)
	e1:SetRange(LOCATION_ONFIELD+LOCATION_GRAVE)
	e1:SetValue(66619916)
	c:RegisterEffect(e1)
	--Activate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(66619919,0))
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	e2:SetOperation(c66619919.operation)
	c:RegisterEffect(e2)
	--Activate
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(66619919,1))
	e3:SetType(EFFECT_TYPE_ACTIVATE)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	e3:SetOperation(c66619919.operation1)
	c:RegisterEffect(e3)
	--Activate
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(66619919,2))
	e4:SetType(EFFECT_TYPE_ACTIVATE)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	e4:SetOperation(c66619919.operation2)
	c:RegisterEffect(e4)
	--act in hand
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e6:SetCondition(c66619919.handcon)
	c:RegisterEffect(e6)
	--act in hand
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE)
	e7:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e7:SetCondition(c66619919.handcon1)
	c:RegisterEffect(e7)
	--draw
	local e9=Effect.CreateEffect(c)
	e9:SetDescription(aux.Stringid(90953320,0))
	e9:SetCategory(CATEGORY_DRAW)
	e9:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e9:SetRange(LOCATION_SZONE)
	e9:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
	e9:SetCountLimit(1)
	e9:SetCode(EVENT_SPSUMMON_SUCCESS)
	e9:SetCondition(c66619919.drcon)
	e9:SetTarget(c66619919.drtg)
	e9:SetOperation(c66619919.drop)
	c:RegisterEffect(e9)
end
function c66619919.operation(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e)  then return end
	local c=e:GetHandler()
	--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(66619919,0))
	e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetRange(LOCATION_SZONE)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x666))
	e1:SetValue(c66619919.indval)
	c:RegisterEffect(e1)
end
function c66619919.operation1(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e)  then return end
	local c=e:GetHandler()
	--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(66619919,1))
	e2:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_REMOVE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x666))
	e2:SetValue(c66619919.indval)
	c:RegisterEffect(e2)
end
function c66619919.operation2(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e)  then return end
	local c=e:GetHandler()
	--
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(66619919,2))
	e3:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_TO_DECK)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x666))
	e3:SetValue(c66619919.indval)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_CANNOT_TO_HAND)
	c:RegisterEffect(e4)
	local e5=e3:Clone()
	e5:SetCode(EFFECT_CANNOT_TO_HAND)
	e5:SetTarget(c66619919.etarget)
	c:RegisterEffect(e5)
end
function c66619919.indval(e,re,tp)
	return rp~=e:GetHandlerPlayer()
end
function c66619919.etarget(e,c)
	return bit.band(c:GetOriginalType(),TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ)~=0 and c:IsFaceup() and c:IsSetCard(0x666)
end
function c66619919.cfilter(c)
	return c:IsCode(66619921) and c:IsFaceup()
end
function c66619919.handcon(e)
	local tp=e:GetHandlerPlayer()
	return  Duel.IsExistingMatchingCard(c66619919.cfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function c66619919.handcon1(e)
	return Duel.GetTurnPlayer()==e:GetHandlerPlayer() and (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2)
end
function c66619919.cfilter1(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x666) and c:IsControler(tp) and c:IsSummonType(SUMMON_TYPE_XYZ) 
end
function c66619919.drcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c66619919.cfilter1,1,nil,tp)
end
function c66619919.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c66619919.drop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e)  then return end
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end