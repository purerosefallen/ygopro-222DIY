--太古龙·瀑星龙
function c10162002.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x9333),9,2)
	c:EnableReviveLimit() 
	--atk
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetCondition(c10162002.atkcon)
	e1:SetValue(c10162002.atkval)
	c:RegisterEffect(e1)   
	--damage re
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10162002,0))
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,10162002)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMING_BATTLE_START+TIMING_ATTACK)
	e2:SetCost(c10162002.drcost)
	e2:SetOperation(c10162002.drop)
	c:RegisterEffect(e2)
	--cannot attack
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_CANNOT_ATTACK)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(c10162002.antarget)
	c:RegisterEffect(e3)
end

function c10162002.antarget(e,c)
	return c~=e:GetHandler()
end

function c10162002.drop(e,tp,eg,ep,ev,re,r,rp)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetCode(EFFECT_REFLECT_DAMAGE)
		e1:SetTargetRange(1,0)
		e1:SetValue(1)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
end

function c10162002.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
	Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
end

function c10162002.atkcon(e)
	return Duel.GetLP(e:GetHandlerPlayer())<4000
end

function c10162002.atkval(e,c)
	local lp=Duel.GetLP(c:GetControler())
	return 4000-lp
end