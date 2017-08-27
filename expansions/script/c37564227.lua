--Sawawa-Flowering Night
xpcall(function() require("expansions/script/c37564765") end,function() require("script/c37564765") end)
local m=37564227
local cm=_G["c"..m]
cm.Senya_name_with_sawawa=true
function cm.initial_effect(c)
	Senya.SawawaCommonEffect(c,1,true,false,false)
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(37564227,1))
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1,37564227)
	e5:SetCondition(Senya.CheckNoExtra)
	e5:SetCost(cm.descost)
	e5:SetTarget(cm.destg)
	e5:SetOperation(cm.desop)
	c:RegisterEffect(e5)
end
function cm.cfilter(c)
	return c:IsFacedown() and c:IsAbleToRemoveAsCost()
end
function cm.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=1
	if chk==0 then return Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,2,nil) and Duel.IsExistingMatchingCard(Senya.SawawaRemoveCostFilter,tp,LOCATION_GRAVE,0,ct,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,cm.cfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,2,2,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g2=Duel.SelectMatchingCard(tp,Senya.SawawaRemoveCostFilter,tp,LOCATION_GRAVE,0,ct,ct,nil)
	g:Merge(g2)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function cm.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(800)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,800)
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end