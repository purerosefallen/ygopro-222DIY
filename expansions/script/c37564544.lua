--Bassdrop Freaks
local m=37564544
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c37564765") end,function() require("script/c37564765") end)
cm.Senya_desc_with_nanahira=true
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_HANDES)
	e1:SetCode(EVENT_TO_HAND)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(Senya.NanahiraExistingCondition(false))
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	Senya.NanahiraTrap(c,e1)
end
function cm.cfilter(c,tp)
	return c:IsControler(tp) and c:IsReason(REASON_EFFECT)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(cm.cfilter,1,nil,1-tp) and rp~=tp end
	Duel.SetTargetCard(eg)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,0,1-tp,1)
end
function cm.filter(c,e,tp)
	return c:IsRelateToEffect(e) and c:IsControler(tp) and c:IsReason(REASON_EFFECT) and c:IsAbleToRemove() and not c:IsImmuneToEffect(e)
end
function cm.setfilter(c,e,tp)
	if c:IsLocation(LOCATION_HAND+LOCATION_DECK) then return false end
	if c:IsType(TYPE_MONSTER) and Duel.GetMZoneCount(tp)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE) then return true end
	if (c:IsType(TYPE_FIELD) or Duel.GetLocationCount(tp,LOCATION_SZONE)>0) and c:IsSSetable() then return true end
	return false
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local sg=eg:Filter(cm.filter,nil,e,1-tp)
	if sg:GetCount()>0 and Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)>0 then
		local og=Duel.GetOperatedGroup():Filter(cm.setfilter,nil,e,tp)
		if Senya.NanahiraExistingCondition(true)(e,tp) and og:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(90809975,4)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
			local rc=og:Select(tp,1,1,nil):GetFirst()
			Duel.BreakEffect()
			if rc:IsType(TYPE_MONSTER) then
				Duel.SpecialSummon(rc,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)
			else
				Duel.SSet(tp,rc)
			end
			Duel.ConfirmCards(1-tp,rc)
		end
	end
end