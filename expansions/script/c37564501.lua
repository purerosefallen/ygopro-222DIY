--Dokkin
local m=37564501
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c37564765") end,function() require("script/c37564765") end)
cm.Senya_desc_with_nanahira=true
function cm.initial_effect(c)
	Senya.Nanahira(c)
	aux.AddXyzProcedure(c,cm.mfilter,7,2)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetCountLimit(1,m)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.operation)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,m-4000)
	e2:SetTarget(cm.xmtg)
	e2:SetOperation(cm.xmop)
	c:RegisterEffect(e2)
end
function cm.mfilter(c)
	return c:IsRace(RACE_FAIRY) and c:IsAttribute(ATTRIBUTE_LIGHT)
end
function cm.cfilter(c)
	return c:IsFaceup() and c:GetFlagEffect(m)==0
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsType(TYPE_XYZ) and eg:IsExists(cm.cfilter,1,e:GetHandler()) end
	Duel.SetTargetCard(eg)
end
function cm.filter(c,e,tp)
	return c:IsFaceup() and c:GetFlagEffect(m)==0 and c:IsRelateToEffect(e) and not c:IsImmuneToEffect(e) and not c:IsType(TYPE_TOKEN) and (c:IsControler(tp) or c:IsAbleToChangeControler())
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() or c:IsControler(1-tp) then return end
	local g=eg:Filter(cm.filter,nil,e,tp)
	Senya.OverlayGroup(c,g)
end
function cm.ssfilter(c,e,tp)
	return c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,true,true) and c:GetOwner()==1-tp
end
function cm.xmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMZoneCount(tp)>0 and e:GetHandler():GetOverlayGroup():IsExists(cm.ssfilter,1,nil,e,tp) and e:GetHandler():IsType(TYPE_XYZ) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,LOCATION_MZONE)
end
function cm.xmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local gg=c:GetOverlayGroup()
	if not (c:IsRelateToEffect(e) and c:IsFaceup() and c:IsControler(tp) and not c:IsImmuneToEffect(e) and gg:IsExists(cm.ssfilter,1,nil,e,tp) and Duel.GetMZoneCount(tp)>0) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=gg:FilterSelect(tp,cm.ssfilter,1,1,nil,e,tp):GetFirst()
	if sg and Duel.SpecialSummonStep(sg,0,tp,tp,true,true,POS_FACEUP) then
		if Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
			sg:RegisterFlagEffect(m,RESET_EVENT+0x1fe0000,0,1)
		end
		Duel.SpecialSummonComplete()
		sg:CompleteProcedure()
	end
end