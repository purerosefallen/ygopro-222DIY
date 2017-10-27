--3L·花开艳丽终将凋落
local m=37564828
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c37564765") end,function() require("script/c37564765") end)
function cm.initial_effect(c)
	--Senya.CommonEffect_3L(c,m)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_STANDBY_PHASE)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
end
function cm.effect_operation_3L(c)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(1,1)
	e3:SetReset(RESET_EVENT+0x1fe0000)
	c:RegisterEffect(e3,true)
	return e3
end
cm.announce_forbidden_3L=true
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMZoneCount(tp)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,m,0,0x21,1000,800,1,RACE_BEAST,ATTRIBUTE_EARTH) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.GetMZoneCount(tp)<=0
		or not Duel.IsPlayerCanSpecialSummonMonster(tp,m,0,0x21,1000,800,1,RACE_BEAST,ATTRIBUTE_EARTH) then return end
	c:AddMonsterAttribute(TYPE_EFFECT+TYPE_TRAP)
	Duel.SpecialSummonStep(c,0,tp,tp,true,false,POS_FACEUP)
	c:AddMonsterAttributeComplete()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(m)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	c:RegisterEffect(e1,true)
	Duel.SpecialSummonComplete()
end