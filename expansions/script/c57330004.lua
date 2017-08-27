--Windbot-弥音
local m=57330004
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c57300000") end,function() require("script/c57300000") end)
cm.named_with_windbot=true
function cm.initial_effect(c)
	miyuki.WindbotCommonEffect(c,cm.target,cm.operation,0,0)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsPlayerCanSummon(tp) end
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetTargetRange(LOCATION_HAND+LOCATION_MZONE,0)
	e1:SetCode(EFFECT_EXTRA_SUMMON_COUNT)
	e1:SetTarget(cm.estg)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function cm.estg(e,c)
	return miyuki.IsWindbot(c)
end