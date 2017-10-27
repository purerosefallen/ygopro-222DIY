--Blue Rose Ruin
local m=37564017
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c37564765") end,function() require("script/c37564765") end)
cm.Senya_name_with_rose=true
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(cm.condition)
	e1:SetCost(cm.cost)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	Duel.AddCustomActivityCounter(m,ACTIVITY_SPSUMMON,cm.counterfilter)
end
function cm.counterfilter(c)
	return Senya.check_set_elem(c) or c:GetSummonLocation()~=LOCATION_EXTRA
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0
		and Duel.GetMZoneCount(tp)>0
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(m,tp,ACTIVITY_SPSUMMON)==0 end
	Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetTargetRange(1,0)
	e1:SetTarget(cm.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function cm.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not Senya.check_set_elem(c) and c:IsLocation(LOCATION_EXTRA)
end
function cm.filter(c,e,tp)
	return Senya.check_set_elem(c) and c:GetRank()==4 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCountFromEx(tp)>0
		and Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCountFromEx(tp)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
	local tc=g:GetFirst()
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		if e:IsHasType(EFFECT_TYPE_ACTIVATE) and e:GetHandler():IsRelateToEffect(e) then
			Duel.BreakEffect()
			e:GetHandler():CancelToGrave()
			Duel.Overlay(tc,Group.FromCards(e:GetHandler()))
		end
	end
end
