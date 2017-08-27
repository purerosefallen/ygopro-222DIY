--Lacey's Dance!
local m=73205011
local cm=_G["c"..m]
if not pcall(function() require("expansions/script/c73205005") end) then require("script/c73205005") end
function cm.initial_effect(c)
	nep.global3(c,m-4,LOCATION_ONFIELD,Card.IsAbleToHand,CATEGORY_TOHAND,cm.op)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end