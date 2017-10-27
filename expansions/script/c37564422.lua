--百慕 甜蜜乐园·玛妮娅
xpcall(function() require("expansions/script/c37564765") end,function() require("script/c37564765") end)
local m=37564422
local cm=_G["c"..m]
cm.Senya_name_with_prism=true
function cm.initial_effect(c)
	Senya.PrismCommonEffect(c,cm.sptg,cm.spop,false,CATEGORY_SPECIAL_SUMMON)
end
function cm.filter(c,e,tp)
	return Senya.CheckPrism(c) and not c:IsCode(37564422) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:GetLevel()==3 and Duel.GetFlagEffect(tp,c:GetCode())==0
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMZoneCount(tp)>0
		and Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetMZoneCount(tp)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc and Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) then
		tc:RegisterFlagEffect(37564499,RESET_EVENT+0x1fe0000,0,1)
		Duel.RegisterFlagEffect(tp,tc:GetCode(),RESET_PHASE+PHASE_END,0,1)
		Duel.SpecialSummonComplete()
	end
end