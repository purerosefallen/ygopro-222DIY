--百慕 魔法的应援·妮娜
xpcall(function() require("expansions/script/c37564765") end,function() require("script/c37564765") end)
local m=37564402
local cm=_G["c"..m]
cm.Senya_name_with_prism=true
function cm.initial_effect(c)
	Senya.PrismCommonEffect(c,cm.target,cm.operation,false,CATEGORY_RECOVER+CATEGORY_DAMAGE)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,1000)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,1000)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Damage(1-tp,1000,REASON_EFFECT)
	Duel.Recover(tp,1000,REASON_EFFECT)
end