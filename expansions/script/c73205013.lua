--Rainy Ratnapura!
local m=73205013
local cm=_G["c"..m]
if not pcall(function() require("expansions/script/c73205005") end) then require("script/c73205005") end
function cm.initial_effect(c)
	nep.global3(c,m-4,LOCATION_MZONE,cm.filter,CATEGORY_POSITION,cm.op)
end
function cm.filter(c)
	return c:IsFaceup() and c:IsCanTurnSet()
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsLocation(LOCATION_MZONE) and tc:IsFaceup() then
		Duel.ChangePosition(tc,POS_FACEDOWN_DEFENSE)
	end
end
