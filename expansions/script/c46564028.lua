--春 淚 · 寻 觅
local m=46564028
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
end
function cm.filter(c,e,tp)
	return c:IsLevelAbove(4) and c:IsLevelBelow(4) and c:IsAttribute(ATTRIBUTE_WATER) and c:IsCanBeEffectTarget(e) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.xyzfilter(c,mg)
	return c:IsXyzSummonable(mg,2,2)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(cm.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp) and Duel.IsExistingTarget(cm.filter,tp,LOCATION_REMOVED,0,1,nil,e,tp) end
	local exg=Duel.GetMatchingGroup(cm.xyzfilter,tp,LOCATION_EXTRA,0,nil,mg)
	if chk==0 then return Duel.IsPlayerCanSpecialSummonCount(tp,2)
		and not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and Duel.GetMZoneCount(tp)>1
		and exg:GetCount()>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local mg=Duel.SelectTarget(tp,cm.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local mg2=Duel.SelectTarget(tp,cm.filter,tp,LOCATION_REMOVED,0,1,1,nil,e,tp)
	mg:Merge(mg2)
	Duel.SetTargetCard(mg)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,mg,2,0,0)
end
function cm.filter2(c,e,tp)
	return c:IsRelateToEffect(e) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	if Duel.GetMZoneCount(tp)<2 then return end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(cm.filter2,nil,e,tp)
	if g:GetCount()<2 then return end
	Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	Duel.BreakEffect()
	local xyzg=Duel.GetMatchingGroup(cm.xyzfilter,tp,LOCATION_EXTRA,0,nil,g)
	if xyzg:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local xyz=xyzg:Select(tp,1,1,nil):GetFirst()
		Duel.XyzSummon(tp,xyz,g)
	end
end