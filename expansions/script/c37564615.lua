
xpcall(function() require("expansions/script/c37564765") end,function() require("script/c37564765") end)
local m=37564615
local cm=_G["c"..m]
function cm.initial_effect(c)
	Senya.NegateEffectTrap(c,1,37564615,cm.cost)
end
function cm.filter(c)
	return Senya.check_set_prim(c) and c:IsAbleToDeckOrExtraAsCost()
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_GRAVE,0,3,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_GRAVE,0,3,3,nil)
	Duel.SendtoDeck(g,nil,2,REASON_COST)
end