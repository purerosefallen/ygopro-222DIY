--Senya bt
local m=37564331
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c37564765") end,function() require("script/c37564765") end)
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcCode2(c,37564813,37564043,true,true)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(cm.discon)
	e2:SetTarget(cm.distg)
	e2:SetOperation(cm.disop)
	c:RegisterEffect(e2)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(m)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	c:RegisterEffect(e2)
end
function cm.discon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsStatus(STATUS_BATTLE_DESTROYED) then return false end
	return Duel.IsChainNegatable(ev)
end
function cm.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function cm.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not Duel.NegateActivation(ev) then return end
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(re:GetDescription())
	e1:SetCategory(re:GetCategory())
	local t=re:GetType()
	local cd=re:GetCode()
	local pr1,pr2=re:GetProperty()
	pr1=(pr1 | EFFECT_FLAG_NO_TURN_RESET)
	if (t & EFFECT_TYPE_ACTIVATE)~=0 then
		t=(t-EFFECT_TYPE_ACTIVATE | EFFECT_TYPE_QUICK_O)
	end
	if (t & EFFECT_TYPE_XMATERIAL)~=0 then
		t=t-EFFECT_TYPE_XMATERIAL
	end
	if (t & EFFECT_TYPE_QUICK_F)~=0 then
		t=(t-EFFECT_TYPE_QUICK_F | EFFECT_TYPE_QUICK_O)
	end
	if (t & EFFECT_TYPE_TRIGGER_F)~=0 then
		t=(t-EFFECT_TYPE_TRIGGER_F | EFFECT_TYPE_TRIGGER_O)
		pr1=(pr1 | EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	end
	if (t & EFFECT_TYPE_IGNITION)~=0 then
		t=(t-EFFECT_TYPE_IGNITION | EFFECT_TYPE_QUICK_O)
		cd=EVENT_FREE_CHAIN
	end
	e1:SetType(t)
	e1:SetCode(cd)
	e1:SetProperty(pr1,pr2)
	if cd==EVENT_FREE_CHAIN then
		e1:SetHintTiming(0,0x1e0)
	end
	e1:SetRange(LOCATION_MZONE)
	e1:SetLabel(re:GetLabel())
	e1:SetLabelObject(re:GetLabelObject())
	e1:SetCountLimit(1)
	e1:SetCondition(function(e)
		return e:GetHandler():IsHasEffect(m)
	end)
	local tg=re:GetTarget()
	if tg then e1:SetTarget(tg) end
	local op=re:GetOperation()
	if op then e1:SetOperation(op) end
	e1:SetReset(0x1fe1000)
	c:RegisterEffect(e1,true)
end