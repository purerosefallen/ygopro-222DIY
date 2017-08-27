--恋爱的小夜曲
local m=57300026
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return e:IsHasType(EFFECT_TYPE_ACTIVATE) and re:IsHasType(EFFECT_TYPE_ACTIVATE) end
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsCanTurnSet() then
		c:CancelToGrave()
		Duel.ChangePosition(c,POS_FACEDOWN)
		local f=Card.RegisterEffect
		Card.RegisterEffect=cm.replace_register_effect(f)
		c:ReplaceEffect(re:GetHandler():GetOriginalCode(),0x1fc1000,1)
		Card.RegisterEffect=f
		Duel.RaiseEvent(c,EVENT_SSET,e,REASON_EFFECT,tp,tp,0)
	end
end
function cm.replace_register_effect(f)
	return function(c,e,forced)
		if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
			e:SetCost(aux.TRUE)
			e:SetCondition(aux.TRUE)
			e:SetCountLimit(63)
		end
		f(c,e,forced)
	end
end