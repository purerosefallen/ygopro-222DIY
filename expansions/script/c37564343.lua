--西行寺·绫·八分咲
local m=37564343
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c37564765") end,function() require("script/c37564765") end)
cm.dfc_back_side=m-1
function cm.initial_effect(c)
	Senya.DFCBackSideCommonEffect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(0x14000+EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.operation)
	c:RegisterEffect(e1)	
end
function cm.filter(c)
	return c:IsType(TYPE_EFFECT)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and cm.filter(chkc) end
	if chk==0 then return e:GetHandler():IsOnField() and Duel.IsExistingTarget(cm.filter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELF)
	local g=Duel.SelectTarget(tp,cm.filter,tp,LOCATION_GRAVE,0,1,1,nil)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		local f=Card.RegisterEffect
		Card.RegisterEffect=function(tc,e,forced)
			e:SetCondition(cm.rcon(e:GetCondition()))
			e:SetCost(cm.rcost(e:GetCost()))
			if e:IsHasType(EFFECT_TYPE_IGNITION) then
				e:SetType((e:GetType()-EFFECT_TYPE_IGNITION | EFFECT_TYPE_QUICK_O))
				e:SetCode(EVENT_FREE_CHAIN)
				e:SetHintTiming(0,0x1c0)
			end
			f(tc,e,forced)
		end
		Senya.CopyStatusAndEffect(e,c,tc,false,0x1fe1000,1)
		Card.RegisterEffect=f
	end
end
function cm.rcon(con)
	return function(e,tp,eg,ep,ev,re,r,rp)
		return not con or con(e,tp,eg,ep,ev,re,r,rp) or e:IsHasType(0x7e0)
	end
end
function cm.rcost(cost)
	return function(e,tp,eg,ep,ev,re,r,rp,chk)
		if chk==0 then return not cost or cost(e,tp,eg,ep,ev,re,r,rp,0) or e:IsHasType(0x7e0) end
		return not cost or e:IsHasType(0x7e0) or cost(e,tp,eg,ep,ev,re,r,rp,1)
	end
end