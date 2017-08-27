--3L·MyonMyonMyon
local m=37564842
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c37564765") end,function() require("script/c37564765") end)
cm.Senya_name_with_myon=3
function cm.initial_effect(c)
	c:SetUniqueOnField(1,0,m)
	Senya.Fusion_3L(c,Senya.OR(cm.lfusfilter,cm.mfilter),Senya.GroupFilterMulti(cm.lfusfilter,cm.lfusfilter,cm.mfilter),3,3,true)
	--Senya.CommonEffect_3L(c,m)
	--[[local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(1,0)
	e2:SetTarget(function(e,c)
		return not Senya.check_set_3L(c)
	end)
	c:RegisterEffect(e2)]]
end
function cm.effect_operation_3L(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(300)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	c:RegisterEffect(e1,true)
	return e1
end
function cm.lfusfilter(c)
	return Senya.check_fusion_set_3L(c) and c:IsOnField()
end
function cm.mfilter(c)
	return c:IsFusionType(TYPE_EFFECT)
end