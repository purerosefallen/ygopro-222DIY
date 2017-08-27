--222 报警
function c80010017.initial_effect(c)
	--activate limit
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(80010017,1))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetHintTiming(0,TIMING_DRAW_PHASE)
	e1:SetCondition(c80010017.actcon)
	e1:SetOperation(c80010017.actop)
	c:RegisterEffect(e1)	
end
function c80010017.actcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function c80010017.actop(e,tp,eg,ep,ev,re,r,rp)
	local p1=Duel.GetLP(tp)
	local p2=Duel.GetLP(1-tp)
	local s=p2-p1
	if s>=7000 then
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetTargetRange(0,1)
	e1:SetValue(aux.TRUE)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e3=Effect.CreateEffect(e:GetHandler())
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CHANGE_DAMAGE)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetTargetRange(1,0)
	e3:SetValue(c80010017.val)
	e3:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e3,tp)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetReset(RESET_PHASE+PHASE_END)
	e2:SetValue(1)
	Duel.RegisterEffect(e2,tp)
	else 
	Duel.Draw(1-tp,1,REASON_EFFECT)
	end
end
function c80010017.val(e,re,val,r,rp,rc)
	if e:GetHandlerPlayer()~=rp then
		return 0
	else return val end
end