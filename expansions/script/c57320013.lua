--少女人偶师·幽幽
local m=57320013
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c57300000") end,function() require("script/c57300000") end)
function cm.initial_effect(c)
	aux.AddLinkProcedure(c,function(c) return c:GetSummonLocation()==LOCATION_EXTRA end,2,2)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_CHANGE_CODE)
	e1:SetRange(LOCATION_MZONE+LOCATION_GRAVE)
	e1:SetValue(57320001)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(cm.target)
	e2:SetOperation(cm.activate)
	c:RegisterEffect(e2)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+0x14000)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetCondition(aux.dogcon)
	e1:SetTarget(cm.target1)
	e1:SetOperation(cm.activate1)
	c:RegisterEffect(e1)
end
function cm.tfilter(c,mc,e,tp)
	return c:IsType(TYPE_FUSION) and miyuki.isdoll(c) and c:IsAttribute(mc:GetAttribute()) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and mc:IsCanBeFusionMaterial(c) and c:GetLevel()==9
end
function cm.filter(c,e,tp)
	local ce={Duel.IsPlayerAffectedByEffect(tp,EFFECT_MUST_BE_FMATERIAL)}
	for _,te in ipairs(ce) do
		if c~=te:GetHandler() then return false end
	end
	return c:IsFaceup() and e:GetHandler():GetLinkedGroup():IsContains(c)
		and Duel.IsExistingMatchingCard(cm.tfilter,tp,LOCATION_EXTRA,0,1,nil,c,e,tp)
		and Duel.GetLocationCountFromEx(tp,tp,c)>0
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(cm.filter,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectTarget(tp,cm.filter,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) or not cm.filter(tc,e,tp) or tc:IsImmuneToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=Duel.SelectMatchingCard(tp,cm.tfilter,tp,LOCATION_EXTRA,0,1,1,nil,tc,e,tp)
	local sc=sg:GetFirst()
	if sc then
		sc:SetMaterial(sg)
		Duel.SendtoGrave(tc,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
		Duel.BreakEffect()
		Duel.SpecialSummon(sc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
		sc:CompleteProcedure()
	end
end
function cm.tfilter1(c,e,tp)
	return c:IsType(TYPE_FUSION) and c:IsCode(57320010) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and e:GetHandler():IsCanBeFusionMaterial(c)
end
function cm.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		local ce={Duel.IsPlayerAffectedByEffect(tp,EFFECT_MUST_BE_FMATERIAL)}
		for _,te in ipairs(ce) do
			if c~=te:GetHandler() then return false end
		end
		return c:IsLocation(LOCATION_GRAVE) and c:IsAbleToRemove() and Duel.IsExistingMatchingCard(cm.tfilter1,tp,LOCATION_EXTRA,0,1,nil,e,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function cm.activate1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or not cm.target1(e,tp,eg,ep,ev,re,r,rp,0) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=Duel.SelectMatchingCard(tp,cm.tfilter1,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	local sc=sg:GetFirst()
	if sc then
		sc:SetMaterial(sg)
		Duel.Remove(c,POS_FACEUP,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
		Duel.BreakEffect()
		Duel.SpecialSummon(sc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
		sc:CompleteProcedure()
	end
end