--人偶少女·曼珠沙华
local m=57320010
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c57300000") end,function() require("script/c57300000") end)
cm.named_with_doll=true
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep2(c,miyuki.isfusiondoll,3,63,true)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
		return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)
	end)
	e2:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
		local c=e:GetHandler()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(c:GetMaterialCount()*500)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		c:RegisterEffect(e1)
		c:RegisterFlagEffect(m,RESET_EVENT+0x1fe0000,0,1,c:GetMaterialCount())
	end)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,0))
	e3:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(cm.discon)
	e3:SetCost(cm.cost)
	e3:SetTarget(cm.distg)
	e3:SetOperation(cm.disop)
	c:RegisterEffect(e3)
	for i,v in pairs({EVENT_SUMMON,EVENT_FLIP_SUMMON,EVENT_SPSUMMON}) do
		local e3=Effect.CreateEffect(c)
		e3:SetDescription(aux.Stringid(m,1))
		e3:SetCategory(CATEGORY_DISABLE_SUMMON+CATEGORY_DESTROY)
		e3:SetType(EFFECT_TYPE_QUICK_O)
		e3:SetRange(LOCATION_MZONE)
		e3:SetCode(v)
		e3:SetCondition(cm.discon1)
		e3:SetCost(cm.cost(c))
		e3:SetTarget(cm.distg1)
		e3:SetOperation(cm.disop1)
		c:RegisterEffect(e3)
	end
	local e9=Effect.CreateEffect(c)
	e9:SetDescription(aux.Stringid(m,2))
	e9:SetCategory(CATEGORY_REMOVE)
	e9:SetType(EFFECT_TYPE_QUICK_O)
	e9:SetCode(EVENT_FREE_CHAIN)
	e9:SetRange(LOCATION_MZONE)
	e9:SetHintTiming(0,0x1e0)
	e9:SetCost(cm.cost)
	e9:SetTarget(cm.tdtg)
	e9:SetOperation(cm.tdop)
	c:RegisterEffect(e9)
end
function cm.cost(c)
local dchk=c:IsStatus(STATUS_COPYING_EFFECT) and c:GetFlagEffectLabel(37564768) or 0
return function(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local ctfs=c:GetFlagEffectLabel(m) or 0
	local ctlm=math.max(dchk,ctfs)
	if chk==0 then
		if c:GetFlagEffect(57320000)<ctlm then return true end
		if not c.named_with_doll then return false end
		if Duel.IsPlayerAffectedByEffect(tp,57320012) then return true end
		local te2=Duel.IsPlayerAffectedByEffect(tp,57320003)
		if te2 and te2:GetOwner():IsAbleToGraveAsCost() then return true end
		return false
	end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	if c:GetFlagEffect(57320000)<ctlm then
		c:RegisterFlagEffect(57320000,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
		return
	end
	local te1=Duel.IsPlayerAffectedByEffect(tp,57320012)
	if te1 then
		te1:Reset()
		return
	end
	local te2=Duel.IsPlayerAffectedByEffect(tp,57320003)
	if te2 then 
		Duel.SendtoGrave(te2:GetOwner(),REASON_COST)
		return
	end
end
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
end
function cm.filter1(c,tp)
	return c:GetSummonPlayer()==tp
end
function cm.discon1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentChain()==0 and eg:IsExists(cm.filter1,1,nil,1-tp)
end
function cm.distg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=eg:Filter(cm.filter1,nil,1-tp)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE_SUMMON,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function cm.disop1(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(cm.filter1,nil,1-tp)
	Duel.NegateSummon(g)
	Duel.Destroy(g,REASON_EFFECT)
end
function cm.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,0,0)
end
function cm.tdop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,e:GetHandler()) then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local sg=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,1,e:GetHandler())
		Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
end