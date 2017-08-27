--Harukoi
local m=37564502
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c37564765") end,function() require("script/c37564765") end)
cm.Senya_desc_with_nanahira=true
function cm.initial_effect(c)
	Senya.Nanahira(c)
	aux.AddSynchroProcedure2(c,nil,aux.FilterBoolFunction(Card.IsCode,37564765))
	c:EnableReviveLimit()
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DAMAGE)
	e3:SetType(EFFECT_TYPE_QUICK_F)
	e3:SetCode(EVENT_CHAINING)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(cm.discon)
	e3:SetTarget(cm.distg)
	e3:SetOperation(cm.disop)
	c:RegisterEffect(e3)
end
function cm.discon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev) and ep~=tp
end
function cm.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local val=Duel.GetFlagEffect(tp,m)*100
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,val+100)
	Duel.SetChainLimit(function(e,p1,p2)
		return p1==p2
	end)
end
function cm.disop(e,tp,eg,ep,ev,re,r,rp) 
	Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,0,1)
	local val=Duel.GetFlagEffect(tp,m)*100
	Duel.Damage(1-tp,val,REASON_EFFECT)
	if val==100 then
		if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
			Duel.Destroy(eg,REASON_EFFECT)
		end 
	end
end