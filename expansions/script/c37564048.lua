--Sawawa-Satori Crisis
local m=37564048
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c37564765") end,function() require("script/c37564765") end)
cm.Senya_name_with_rose=true
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(cm.xmtg)
	e1:SetOperation(cm.xmop)
	c:RegisterEffect(e1)
end
function cm.xmfilter(c,e,tp)
	local gg=c:GetOverlayGroup()
	return c:IsType(TYPE_XYZ) and gg:IsExists(cm.ssfilter,1,nil,e,tp)
end
function cm.ssfilter(c,e,tp)
	return c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.xmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and cm.xmfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingTarget(cm.xmfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g1=Duel.SelectTarget(tp,cm.xmfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,LOCATION_MZONE)
end
function cm.xmop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local gg=tc:GetOverlayGroup()
	if not (gg:IsExists(cm.ssfilter,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and tc:IsRelateToEffect(e)) or tc:IsImmuneToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=gg:FilterSelect(tp,cm.ssfilter,1,1,nil,e,tp)
	if Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)~=0 then
	local ssed=Duel.GetOperatedGroup()
	local ssc=ssed:GetFirst()
		 if ssc:IsType(TYPE_XYZ) and (tc:IsControler(tp) or tc:IsAbleToChangeControler()) then
			  if Duel.SelectYesNo(tp,aux.Stringid(m,2)) then
					Duel.BreakEffect()
					local og=tc:GetOverlayGroup()
					if og:GetCount()>0 then
						Duel.SendtoGrave(og,REASON_RULE)
					end
					Duel.Overlay(ssc,Group.FromCards(tc))
			  end
		 end
	end
end

