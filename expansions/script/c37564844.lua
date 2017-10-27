--3L·MyonMyonMyonMyonMyonMyon
local m=37564844
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c37564765") end,function() require("script/c37564765") end)
cm.Senya_name_with_myon=6
function cm.initial_effect(c)
	--Senya.CommonEffect_3L(c,m)
	aux.AddXyzProcedure(c,aux.FALSE,10,5,cm.xfilter,m*16)
	c:EnableReviveLimit()
	Senya.ContinuousEffectGainModule_3L(c,cm.omit_group_3L,cm.exccost)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(37564827)
	e3:SetValue(Senya.order_table_new(cm.omit_group_3L))
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	c:RegisterEffect(e3)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_ADJUST)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(function(e,tp)
		return Duel.IsExistingMatchingCard(Senya.EffectSourceFilter_3L,tp,LOCATION_GRAVE,0,1,nil,e:GetHandler())
	end)
	e2:SetOperation(cm.op)
	c:RegisterEffect(e2)
end
function cm.effect_operation_3L(c)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetHintTiming(0,0x1e0)
	e3:SetCost(Senya.DescriptionCost(cm.cost))
	e3:SetTarget(cm.target)
	e3:SetOperation(cm.activate)
	e3:SetReset(RESET_EVENT+0x1fe0000)
	c:RegisterEffect(e3,true)
	return e3
end
cm.single_effect_3L=true
function cm.omit_group_3L(c)
	return Duel.GetMatchingGroup(aux.TRUE,c:GetControler(),LOCATION_GRAVE,0,nil)
end
function cm.xfilter(c)
	return Senya.check_set(c,"myon") and c:IsXyzType(TYPE_XYZ) and c:IsFaceup() and c:GetOverlayCount()>2
end
function cm.excfilter(c,cd)
	return c:GetOriginalCode()==cd and c:IsAbleToRemoveAsCost()
end
function cm.exccost(tc)
	local cd=tc:GetOriginalCode()
	return function(e,tp,eg,ep,ev,re,r,rp,chk)
		local c=e:GetHandler()
		if chk==0 then return Duel.IsExistingMatchingCard(cm.excfilter,tp,LOCATION_GRAVE,0,1,c,cd) end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g=Duel.SelectMatchingCard(tp,cm.excfilter,tp,LOCATION_GRAVE,0,1,1,c,cd)
		Duel.Remove(g,POS_FACEUP,REASON_COST)
	end
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		if not c:IsReleasable() then return false end
		local ct=0
		local t=Senya.GetGainedList_3L(c)
		for i,v in pairs(t) do
			local mt=Senya.LoadMetatable(v)
			if mt and mt.Senya_name_with_myon then ct=ct+1 end
		end
		return ct>=4
	end
	Duel.Release(c,REASON_COST)
end
function cm.sfilter(c,e,tp)
	return c:IsType(TYPE_FUSION) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial()
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMZoneCount(tp)>-1
		and Duel.IsExistingMatchingCard(cm.sfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetMZoneCount(tp)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.sfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if not tc then return end
	tc:SetMaterial(nil)
	Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
	tc:CompleteProcedure()
end