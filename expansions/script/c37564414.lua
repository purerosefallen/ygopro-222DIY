--百慕 学院的绮罗星·奥莉维亚
local m=37564414
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c37564765") end,function() require("script/c37564765") end)
cm.Senya_name_with_prism=true
function cm.initial_effect(c)
	Senya.PrismXyzProcedure(c,2,63)
	Senya.PrismDamageCheckRegister(c,true)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,1))
	e3:SetCategory(CATEGORY_ATKCHANGE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	--e3:SetCost(Senya.ForbiddenCost())
	e3:SetCondition(Senya.PrismDamageCheckCondition)
	e3:SetTarget(function(e,tp,eg,ep,ev,re,r,rp,chk)
		if chk==0 then
			--if e:GetLabel()==0 then return false end
			--e:SetLabel(0)
			return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0 and c:CheckRemoveOverlayCard(tp,1,REASON_COST) and c:GetFlagEffect(m)==0
		end
		c:RemoveOverlayCard(tp,1,99,REASON_COST)
		local ct=Duel.GetOperatedGroup():GetCount()
		e:SetLabel(ct)
		c:RegisterFlagEffect(m,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_DAMAGE_CAL,0,1)
	end)
	e3:SetOperation(Senya.PrismDamageCheckOperation)
	c:RegisterEffect(e3)
end
