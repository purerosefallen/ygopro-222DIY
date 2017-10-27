--花舞少女·孤独信号
local m=14141008
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c14141006") end,function() require("script/c14141006") end)
cm.named_with_hana=true
function cm.initial_effect(c)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_CHAINING)
	e2:SetCost(function(e,tp,eg,ep,ev,re,r,rp,chk)
		if chk==0 then return Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_MZONE,0,1,nil) end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
		local g=Duel.SelectMatchingCard(tp,cm.cfilter,tp,LOCATION_MZONE,0,1,1,nil)
		Duel.SendtoHand(g,nil,REASON_EFFECT)
	end)
	e2:SetCondition(cm.condition2)
	e2:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e2:SetTarget(cm.target2)
	e2:SetOperation(cm.activate2)
	c:RegisterEffect(e2)
end
function cm.cfilter(c)
	return c:IsFaceup() and scorp.check_set_hana(c) and c:IsAbleToHandAsCost()
end
function cm.condition2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsChainNegatable(ev)
end
function cm.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMZoneCount(tp)>-1
		and Duel.IsExistingMatchingCard(scorp.hanaspfilter,tp,LOCATION_HAND,0,1,nil,e,tp,m) end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function cm.activate2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) and Duel.Destroy(eg,REASON_EFFECT)>0 and Duel.GetMZoneCount(tp)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,scorp.hanaspfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
		if g:GetCount()>0 then
			Duel.BreakEffect()
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end