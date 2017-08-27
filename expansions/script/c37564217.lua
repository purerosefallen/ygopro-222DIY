--Sawawa-Lake Blizzard
xpcall(function() require("expansions/script/c37564765") end,function() require("script/c37564765") end)
local m=37564217
local cm=_G["c"..m]
cm.Senya_name_with_sawawa=true
function cm.initial_effect(c)
	Senya.SawawaCommonEffect(c,1,true,false,false)
   local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(37564217,1))
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,37564217)
	e1:SetCondition(Senya.CheckNoExtra)
	e1:SetCost(Senya.SawawaRemoveCost(1))
	e1:SetTarget(cm.tg)
	e1:SetOperation(cm.op)
	c:RegisterEffect(e1)
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetOverlayCount(tp,0,1)~=0 end
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetOverlayGroup(tp,0,1)
	local val=g:GetCount()*300
	if val~=0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
		Duel.BreakEffect()
		Duel.Damage(1-tp,val,REASON_EFFECT)
		if not c:IsFacedown() and c:IsRelateToEffect(e) then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetValue(val)
			e1:SetReset(RESET_EVENT+0x1ff0000)
			c:RegisterEffect(e1)
		end  
	end
end
