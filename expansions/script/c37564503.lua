--Tomaru Susumu
local m=37564503
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c37564765") end,function() require("script/c37564765") end)
cm.Senya_desc_with_nanahira=true
function cm.initial_effect(c)
	Senya.Nanahira(c)
	c:EnableReviveLimit()
	aux.AddFusionProcCodeRep(c,37564765,2,true,true)
	Senya.AddSelfFusionProcedure(c,LOCATION_MZONE,Duel.Release)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCondition(function(e)
		local c=e:GetHandler()
		return Duel.GetCurrentPhase()==PHASE_DAMAGE_CAL and c:IsRelateToBattle() and c:GetBattleTarget() and c:GetBattledGroupCount()==0
	end)
	e1:SetValue(function(e)
		return math.max(e:GetHandler():GetBattleTarget():GetAttack(),0)
	end)
	c:RegisterEffect(e1)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,0))
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_BATTLED)
	e3:SetCountLimit(1)
	e3:SetCondition(cm.atcon)
	e3:SetOperation(cm.atop)
	c:RegisterEffect(e3)
end
function cm.atcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	return bc and bc:IsStatus(STATUS_BATTLE_DESTROYED) and c:IsChainAttackable() and c:IsStatus(STATUS_OPPO_BATTLE) 
end
function cm.atop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ChainAttack()
end