--Sawawa-Blinding Destruction
local m=37564231
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c37564765") end,function() require("script/c37564765") end)
cm.Senya_name_with_sawawa=true
function cm.initial_effect(c)
	Senya.SawawaCommonEffect(c,2,true,false,false)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_SELF_DESTROY)
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetCondition(cm.effcon)
	e2:SetTarget(cm.filter)
	e2:SetValue(aux.TRUE)
	c:RegisterEffect(e2)
	--atk
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e2:SetHintTiming(TIMING_DAMAGE_STEP,TIMING_DAMAGE_STEP+0x1c0)
	e2:SetCountLimit(1)
	e2:SetCost(Senya.SawawaRemoveCost(1))
	e2:SetOperation(cm.atkop)
	c:RegisterEffect(e2)
end
function cm.atkop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetTargetRange(0,LOCATION_MZONE)
	e1:SetValue(1000)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	Duel.RegisterEffect(e2,tp)
end
function cm.effcon(e)
	local tp=e:GetHandler():GetControler()
	return Senya.CheckNoExtra(e,tp) and Duel.IsExistingMatchingCard(Senya.check_set_sawawa,tp,LOCATION_GRAVE,0,1,nil)
end
function cm.filter(e,c)
	return c:GetAttack()>=3000 and c:IsFaceup() and not c:IsImmuneToEffect(e) and c:IsDestructable()
end