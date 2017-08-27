--夜樱之宴
local m=98600005
local cm=_G["c"..m]
cm.count=0
function cm.initial_effect(c)
	local id=cm.count+m
	cm.count=cm.count+100
	--summon with 5 tribute
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_LIMIT_SUMMON_PROC)
	e1:SetCondition(cm.ttcon)
	e1:SetOperation(cm.ttop)
	e1:SetValue(SUMMON_TYPE_ADVANCE)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_LIMIT_SET_PROC)
	e2:SetCondition(cm.setcon)
	c:RegisterEffect(e2)
	--cannot special summon
	local e3=Effect.CreateEffect(c)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e3)
--[[
	--cannot target
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetValue(aux.tgoval)
	c:RegisterEffect(e2)
	--indes
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(cm.indval)
	c:RegisterEffect(e3)]]
	--negate
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(id)
	e2:SetCondition(cm.acon)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsFaceup))
	e2:SetValue(1)
	c:RegisterEffect(e2)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_ADD_TYPE)
	e2:SetCondition(cm.acon)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsFaceup))
	e2:SetValue(TYPE_EFFECT)
	c:RegisterEffect(e2)
	--local g=Group.CreateGroup()
	--g:KeepAlive()
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_ADJUST)
	--e2:SetLabelObject(g)
	e2:SetLabel(id)
	e2:SetCondition(cm.regcon)
	e2:SetOperation(cm.regop)
	c:RegisterEffect(e2)
end
function cm.ttcon(e,c,minc)
	if c==nil then return true end
	return minc<=5 and Duel.CheckTribute(c,5)
end
function cm.ttop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.SelectTribute(tp,c,5,5)
	c:SetMaterial(g)
	Duel.Release(g,REASON_SUMMON+REASON_MATERIAL)
end
function cm.setcon(e,c)
	if not c then return true end
	return false
end
function cm.indval(e,re,tp)
	return tp~=e:GetHandlerPlayer()
end
function cm.acon(e)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_ADVANCE
end
function cm.regfilter(c,id)
	return c:IsFaceup() and c:IsHasEffect(id) and c:GetFlagEffect(id)==0
end
function cm.regcon(e,tp,eg,ep,ev,re,r,rp)
	local id=e:GetLabel()
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_ADVANCE and Duel.IsExistingMatchingCard(cm.regfilter,tp,LOCATION_MZONE,0,1,nil,id)
end
function cm.regop(e,tp,eg,ep,ev,re,r,rp)
	local id=e:GetLabel()
	local g=Duel.GetMatchingGroup(cm.regfilter,tp,LOCATION_MZONE,0,nil,id)
	for tc in aux.Next(g) do
		tc:RegisterFlagEffect(id,0,0,0)
		local e2=Effect.CreateEffect(tc)
		e2:SetDescription(aux.Stringid(m,0))
		e2:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
		e2:SetType(EFFECT_TYPE_QUICK_O)
		e2:SetCode(EVENT_CHAINING)
		e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
		e2:SetRange(LOCATION_MZONE)
		e2:SetCountLimit(1)
		e2:SetLabel(id)
		e2:SetCondition(cm.discon)
		e2:SetTarget(cm.distg)
		e2:SetOperation(cm.disop)
		--e2:SetReset(0x1fe1000)
		tc:RegisterEffect(e2,true)
	end
end
function cm.discon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsStatus(STATUS_BATTLE_DESTROYED) or not c:IsHasEffect(e:GetLabel()) then return false end
	return Duel.IsChainNegatable(ev)
end
function cm.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function cm.disop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end