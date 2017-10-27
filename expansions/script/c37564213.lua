--Sawawa-High Speed Apple
xpcall(function() require("expansions/script/c37564765") end,function() require("script/c37564765") end)
local m=37564213
local cm=_G["c"..m]
cm.Senya_name_with_sawawa=true
function cm.initial_effect(c)
Senya.SawawaCommonEffect(c,1,true,false,false)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(37564213,1))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_BATTLE_DESTROYING)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,37564213)
	e1:SetCondition(aux.bdogcon)
	e1:SetTarget(cm.tg)
	e1:SetOperation(cm.op)
	c:RegisterEffect(e1)
end
function cm.filter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Senya.check_set_sawawa(c)
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and cm.filter(chkc,e,tp) end
	if chk==0 then return Duel.GetMZoneCount(tp)>0
		and Duel.IsExistingTarget(cm.filter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil,e,tp) and Duel.GetFieldGroupCount(tp,LOCATION_EXTRA,0)==0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,cm.filter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end