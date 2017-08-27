--Sawawa-上海红茶馆
local m=37564212
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c37564765") end,function() require("script/c37564765") end)
cm.Senya_name_with_sawawa=true
function cm.initial_effect(c)
	Senya.SawawaCommonEffect(c,1,true,false,false)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,0))
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_BATTLED)
	--e3:SetCountLimit(1)
	e3:SetCondition(cm.atcon)
	e3:SetCost(Senya.SawawaRemoveCost(1))
	e3:SetOperation(cm.atop)
	c:RegisterEffect(e3)
end
function cm.atcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	return bc and bc:IsStatus(STATUS_BATTLE_DESTROYED) and c:IsChainAttackable() and c:IsStatus(STATUS_OPPO_BATTLE) and Senya.CheckNoExtra(e,tp)
end
function cm.atop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ChainAttack()
end