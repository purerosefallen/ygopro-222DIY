--Nanahira & 3L
local m=37564519
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c37564765") end,function() require("script/c37564765") end)
cm.Senya_desc_with_nanahira=true
cm.Senya_name_with_3L=true
function cm.initial_effect(c)
	Senya.Nanahira(c)
	Senya.Fusion_3L(c,nil,Senya.GroupFilterMulti(cm.mfilter,Senya.check_fusion_set_3L),2,2)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetRange(LOCATION_ONFIELD+LOCATION_GRAVE)
	e5:SetCode(37564800)
	c:RegisterEffect(e5)
	local e88=Effect.CreateEffect(c)
	e88:SetDescription(aux.Stringid(m,2))
	e88:SetCategory(CATEGORY_REMOVE)
	e88:SetType(EFFECT_TYPE_QUICK_O)
	e88:SetCode(EVENT_FREE_CHAIN)
	e88:SetRange(LOCATION_MZONE)
	e88:SetHintTiming(0,0x1e0)
	e88:SetCountLimit(1)
	e88:SetCost(Senya.DescriptionCost(Senya.multi_choice_target(m,cm.tdcost,Senya.RemoveEffectCost_3L(1))))
	e88:SetTarget(cm.tgtg)
	e88:SetOperation(cm.tgop)
	c:RegisterEffect(e88)
end
function cm.mfilter(c,fc,sub)
	return c:IsFusionCode(37564765) or (sub and c:CheckFusionSubstitute(fc))
end
function cm.SawawaRemoveCostFilter(c)
	return c:IsCode(37564765) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
end
function cm.tdcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.SawawaRemoveCostFilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,cm.SawawaRemoveCostFilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function cm.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function cm.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,1,nil)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	end
end