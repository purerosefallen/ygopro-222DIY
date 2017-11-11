local m=37564520
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c37564765") end,function() require("script/c37564765") end)
cm.Senya_desc_with_nanahira=true
function cm.initial_effect(c)
	Senya.Nanahira(c)
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsCode,37564765),aux.NonTuner(Card.IsRace,RACE_FAIRY),1)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(m*16+1)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(cm.condition)
	e1:SetTarget(aux.TRUE)
	e1:SetOperation(cm.operation0)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCost(cm.copycost)
	e2:SetCondition(cm.condition1)
	e2:SetTarget(cm.target2)
	e2:SetOperation(cm.operation)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetLabelObject(e2)
	e3:SetCondition(function(e)
		return e:GetHandler():GetFlagEffect(37560520)>0
	end)
	e3:SetValue(cm.efilter)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_CHAINING)
	e4:SetRange(LOCATION_MZONE)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e4:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
		return re:GetHandler()==e:GetHandler()
	end)
	e4:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
		e:GetHandler():RegisterFlagEffect(37560520,RESET_EVENT+0x1fe0000+RESET_CHAIN,0,1)
	end)
	c:RegisterEffect(e4)
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=re:GetHandler()
	return re:IsActiveType(TYPE_MONSTER) and rc~=c and not c:IsStatus(STATUS_BATTLE_DESTROYED) and ep~=tp
end
function cm.condition1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=re:GetHandler()
	return re:IsHasType(EFFECT_TYPE_ACTIVATE) and rc~=c and not c:IsStatus(STATUS_BATTLE_DESTROYED) and ep~=tp
end 
function cm.operation0(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rcd=re:GetHandler():GetOriginalCode()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	local ccd=c:GetFlagEffectLabel(m)
	if ccd then
		c:ResetFlagEffect(m)
		c:ResetEffect(ccd,RESET_COPY)
	end
	local ecd=c:CopyEffect(rcd,RESET_EVENT+0x1fe0000,1)
	c:RegisterFlagEffect(m,RESET_EVENT+0x1fe0000,EFFECT_FLAG_CLIENT_HINT,1,ecd,m*16)
end
function cm.copycost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	return true
end
function cm.filter1(c)
	return c:CheckActivateEffect(true,true,false)
end
function cm.filter2(c,e,tp,eg,ep,ev,re,r,rp)
		if c:CheckActivateEffect(true,true,false) then return true end
		local te=c:GetActivateEffect()
		--if te:GetCode()~=EVENT_CHAINING then return false end
		local tg=te:GetTarget()
		if not tg then return true end
		local res=false
		if not pcall(function() res=tg(e,tp,eg,ep,ev,re,r,rp,0) end) then return false end
		return res
end
function cm.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		local te=e:GetLabelObject()
		local tg=te:GetTarget()
		return te:IsHasProperty(EFFECT_FLAG_CARD_TARGET) and (not tg or tg(e,tp,eg,ep,ev,re,r,rp,0,chkc))
	end
	if chk==0 then
		if e:GetLabel()==0 then return false end
		e:SetLabel(0)
		return cm.filter2(re:GetHandler(),e,tp,eg,ep,ev,re,r,rp)
	end
	e:SetLabel(0)
	local tc=re:GetHandler()
	local te,ceg,cep,cev,cre,cr,crp
	local fchain=cm.filter1(tc)
	if fchain then
		te,ceg,cep,cev,cre,cr,crp=tc:CheckActivateEffect(true,true,true)
	else
		te=tc:GetActivateEffect()
	end
	e:SetCategory(te:GetCategory())
	e:SetProperty(te:GetProperty())
	local tg=te:GetTarget()
	if tg then
		if fchain then
			tg(e,tp,ceg,cep,cev,cre,cr,crp,1)
		else
			tg(e,tp,eg,ep,ev,re,r,rp,1)
		end
	end
	te:SetLabelObject(e:GetLabelObject())
	e:SetLabelObject(te)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
	if not te then return end
	e:SetLabelObject(te:GetLabelObject())
	local op=te:GetOperation()
	e:GetHandler():ReleaseEffectRelation(e)
	if op then op(e,tp,eg,ep,ev,re,r,rp) end
end
function cm.efilter(e,te)
	return te:GetOwnerPlayer()~=e:GetHandlerPlayer() or te==e:GetLabelObject()
end