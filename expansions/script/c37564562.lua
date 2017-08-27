--Nanahira & Nemoma
local m=37564562
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c37564765") end,function() require("script/c37564765") end)
function cm.initial_effect(c)
	Senya.Nanahira(c)
	c:EnableReviveLimit()
	aux.AddFusionProcCodeFun(c,37564765,aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_LIGHT),1,true,true)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_DEFENSE_ATTACK)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetCondition(function(e) return Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)==0 end)
	e3:SetValue(1)
	e3:SetTarget(function(e,c) return not c:IsType(TYPE_LINK) end)
	c:RegisterEffect(e3)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_SET_DEFENSE_FINAL)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetCondition(function(e) return Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)==0 end)
	e3:SetValue(function(e,c) return c:GetDefense()*2 end)
	e3:SetTarget(function(e,c) return not c:IsType(TYPE_LINK) end)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_PRE_BATTLE_DAMAGE)
	e4:SetCondition(cm.damcon)
	e4:SetOperation(cm.damop)
	c:RegisterEffect(e4)
end
function cm.damcon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp and Duel.GetMatchingGroupCount(aux.TRUE,tp,LOCATION_ONFIELD,0,e:GetHandler())==0
end
function cm.damop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ChangeBattleDamage(ep,ev*2)
end