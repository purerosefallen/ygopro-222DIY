--3L·黑暗的彼方
local m=37564829
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c37564765") end,function() require("script/c37564765") end)
function cm.initial_effect(c)
	c:EnableReviveLimit()
	--Senya.CommonEffect_3L(c,m)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_HAND)
	e2:SetValue(0x829)
	e2:SetCondition(cm.spcon)
	e2:SetOperation(cm.spop)
	c:RegisterEffect(e2)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_SPSUMMON_SUCCESS)
	e0:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
		return e:GetHandler():IsSummonType(0x829)
	end)
	e0:SetOperation(cm.skipop)
	c:RegisterEffect(e0)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_MATERIAL_CHECK)
	e3:SetValue(function(e,c)
		local g=c:GetMaterial()
		local fg=g:Filter(Senya.EffectSourceFilter_3L,nil,c)
		fg:KeepAlive()
		e:GetLabelObject():SetLabelObject(fg)
	end)
	e3:SetLabelObject(e0)
	c:RegisterEffect(e3)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(cm.atkval)
	c:RegisterEffect(e1)
end
cm.single_effect_3L=true
function cm.effect_operation_3L(c)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,1))
	e3:SetCategory(CATEGORY_NEGATE)
	e3:SetType(EFFECT_TYPE_QUICK_F)
	e3:SetCode(EVENT_CUSTOM+m)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e3:SetCountLimit(1,m)
	e3:SetCondition(cm.discon)
	e3:SetCost(Senya.DescriptionCost())
	e3:SetTarget(cm.distg)
	e3:SetOperation(cm.disop)
	e3:SetReset(RESET_EVENT+0x1fe0000)
	c:RegisterEffect(e3,true)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_ADJUST)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetOperation(function(e,tp)
		local c=e:GetHandler()
		local ct=c:GetFlagEffectLabel(m)
		local v=math.min(Senya.kaguya_check_3L[1-tp],7)
		if not ct then
			c:RegisterFlagEffect(m,0x1fe1000,EFFECT_FLAG_CLIENT_HINT,1,v,aux.Stringid(m,v+2))
			return
		end
		if v==ct then return end
		c:ResetFlagEffect(m)
		c:RegisterFlagEffect(m,0x1fe1000,EFFECT_FLAG_CLIENT_HINT,1,v,aux.Stringid(m,v+2))
	end)
	e2:SetReset(RESET_EVENT+0x1fe0000)
	c:RegisterEffect(e2,true)   
	return e3,e2
end
cm.reset_operation_3L={
aux.NULL,
function(e,c)
	c:ResetFlagEffect(m)
end,
}
function cm.spcon(e,c)
	if c==nil then return true end
	local ft=Duel.GetMZoneCount(c:GetControler())
	local ct=math.max(1,-ft)
	return Duel.CheckReleaseGroup(c:GetControler(),Senya.check_set_3L,ct,nil)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local ft=Duel.GetMZoneCount(c:GetControler())
	local ct=math.max(1,-ft)
	local g=Duel.SelectReleaseGroup(c:GetControler(),Senya.check_set_3L,ct,63,nil)
	c:SetMaterial(g)
	Duel.Release(g,REASON_COST)
end
function cm.skipop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=e:GetLabelObject()
	if not g then return end
	local tc=g:GetFirst()
	while tc do
		Senya.GainEffect_3L(c,tc)
		tc=g:GetNext()
	end
	g:DeleteGroup()
end
function cm.atkval(e,c)
	return Senya.GetGainedCount_3L(c)*500
end
function cm.discon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev) and ep~=tp
end
function cm.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function cm.disop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
	if Duel.GetCurrentPhase()==PHASE_END then return end
	local turnp=Duel.GetTurnPlayer()
	Duel.SkipPhase(turnp,PHASE_DRAW,RESET_PHASE+PHASE_END,1)
	Duel.SkipPhase(turnp,PHASE_STANDBY,RESET_PHASE+PHASE_END,1)
	Duel.SkipPhase(turnp,PHASE_MAIN1,RESET_PHASE+PHASE_END,1)
	Duel.SkipPhase(turnp,PHASE_BATTLE,RESET_PHASE+PHASE_END,1,1)
	Duel.SkipPhase(turnp,PHASE_MAIN2,RESET_PHASE+PHASE_END,1)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_BP)
	e1:SetTargetRange(1,0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,turnp)
end