--3L·死灵的夜樱
local m=37564824
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c37564765") end,function() require("script/c37564765") end)
function cm.initial_effect(c)
	Senya.AddSummonMusic(c,m*16,SUMMON_TYPE_XYZ)
	--Senya.CommonEffect_3L(c,m)
	Senya.AddXyzProcedureCustom(c,cm.xfilter,nil,2,63)
	Senya.ContinuousEffectGainModule_3L(c,cm.omit_group_3L,Senya.DirectReturn(Senya.RemoveOverlayCost(1)))
end
function cm.effect_operation_3L(c)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_TRIGGER)
	e3:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(0,LOCATION_SZONE)
	e3:SetTarget(cm.distg)
	e3:SetReset(RESET_EVENT+0x1fe0000)
	c:RegisterEffect(e3,true)
	return e3
end
cm.omit_group_3L=Card.GetOverlayGroup
function cm.distg(e,c)
	return c:IsFacedown()
end
function cm.xfilter(c,xyzcard)
	if not Senya.check_set_3L(c) then return false end
	for i=1,4 do
		if c:IsXyzLevel(xyzcard,i) then return true end
	end
	return false
end