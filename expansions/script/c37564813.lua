--妖隐 -BANAMI & 3L Remix-
local m=37564813
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c37564765") end,function() require("script/c37564765") end)
cm.Senya_name_with_remix=true
function cm.initial_effect(c)

end
function cm.effect_condition_3L(c,fc)
	return c:IsLocation(LOCATION_MZONE)
end
function cm.effect_operation_3L(c,ctlm)
	local e=Senya.NegateEffectModule(c,ctlm)
	e:SetDescription(m*16+1)
	e:SetReset(RESET_EVENT+0x1fe0000)
	e:SetCost(Senya.DescriptionCost())
	local con=e:GetCondition()
	e:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
		return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION) and con(e,tp,eg,ep,ev,re,r,rp)
	end)
	c:RegisterEffect(e,true)
	return e
end