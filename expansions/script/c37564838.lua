--3L·Scarlet Moon
local m=37564838
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c37564765") end,function() require("script/c37564765") end)
function cm.initial_effect(c)
	--Senya.CommonEffect_3L(c,m) 
end
function cm.effect_operation_3L(c,ctlm)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,2))
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_SELF_DESTROY)
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetTarget(cm.filter)
	e2:SetValue(aux.TRUE)
	e2:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	e2:SetReset(RESET_EVENT+0x1fe0000)
	c:RegisterEffect(e2,true)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,1))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetHintTiming(TIMING_DAMAGE_STEP,TIMING_DAMAGE_STEP+0x1c0)
	e1:SetCountLimit(ctlm)
	e1:SetCost(Senya.DescriptionCost(Senya.RemoveEffectCost_3L(1,m)))
	e1:SetOperation(cm.atkop)
	c:RegisterEffect(e1,true)
	Duel.Readjust()
	return e2,e1
end
function cm.filter(e,c)
	return c:GetAttack()==0 and c:IsFaceup() and not c:IsImmuneToEffect(e) and c:IsDestructable()
end
function cm.atkop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetTargetRange(0,LOCATION_MZONE)
	e1:SetValue(-2000)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
cm.custom_effect_count_3L=2