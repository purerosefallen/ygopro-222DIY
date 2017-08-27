--3L·MyonMyonMyonMyonMyon
local m=37564843
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c37564765") end,function() require("script/c37564765") end)
cm.Senya_name_with_myon=5
function cm.initial_effect(c)
	--Senya.CommonEffect_3L(c,m)
	aux.AddXyzProcedure(c,cm.mfilter,7,3,cm.xfilter,m*16)
	c:EnableReviveLimit()
	Senya.ContinuousEffectGainModule_3L(c,cm.omit_group_3L)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_PUBLIC)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_HAND,0)
	c:RegisterEffect(e2)
end
function cm.effect_operation_3L(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(500)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	c:RegisterEffect(e1,true)
	return e1
end
function cm.omit_group_3L(c)
	return Duel.GetMatchingGroup(Card.IsPublic,c:GetControler(),LOCATION_HAND,0,nil)
end
function cm.mfilter(c)
	return Senya.check_set_3L(c)
end
function cm.xfilter(c)
	return Senya.check_set(c,"myon") and c:IsXyzType(TYPE_FUSION) and c:IsFaceup() and Senya.GetGainedCount_3L(c)>1
end