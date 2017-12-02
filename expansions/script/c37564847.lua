--3L·Firefly
local m=37564847
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c37564765") end,function() require("script/c37564765") end)
function cm.initial_effect(c)
	--Senya.CommonEffect_3L(c,m)
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(m*16)
	e6:SetType(EFFECT_TYPE_QUICK_O)
	e6:SetCode(EVENT_FREE_CHAIN)
	e6:SetRange(LOCATION_HAND)
	e6:SetHintTiming(0x3c0)
	e6:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e6:SetCountLimit(1,m)
	e6:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
		return not Duel.CheckEvent(EVENT_CHAINING) and Duel.IsExistingMatchingCard(cm.filter3L,tp,LOCATION_MZONE,0,1,nil)
	end)
	e6:SetCost(cm.cost)
	e6:SetTarget(cm.scopytg)
	e6:SetOperation(cm.CopyOperation)
	c:RegisterEffect(e6)
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(m*16)
	e7:SetType(EFFECT_TYPE_QUICK_O)
	e7:SetCode(EVENT_CHAINING)
	e7:SetRange(LOCATION_HAND)
	e7:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e7:SetCountLimit(1,m)
	e7:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
		return Duel.IsExistingMatchingCard(cm.filter3L,tp,LOCATION_MZONE,0,1,nil)
	end)
	e7:SetCost(cm.cost)
	e7:SetTarget(cm.CopySpellChainingTarget)
	e7:SetOperation(cm.CopyOperation)
	c:RegisterEffect(e7)
	if not cm.last_spell then
		cm.last_spell={}
		local ge=Effect.GlobalEffect()
		ge:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge:SetCode(EVENT_CHAIN_SOLVED)
		ge:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
			if not re:IsHasType(EFFECT_TYPE_ACTIVATE) then return false end
			return true
		end)
		ge:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
			cm.last_spell[Duel.GetTurnCount()]=re:GetHandler()
		end)
		Duel.RegisterEffect(ge,0)
	end
end
function cm.effect_operation_3L(c)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_CHAINING)
	e2:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
		return re:IsHasType(EFFECT_TYPE_ACTIVATE) and Duel.IsExistingMatchingCard(Card.IsType,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil,TYPE_SPELL+TYPE_TRAP)
	end)
	e2:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
		Duel.Hint(HINT_CARD,0,e:GetHandler():GetOriginalCode())
		local g=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil,TYPE_SPELL+TYPE_TRAP)
		local sg=g:RandomSelect(tp,1)
		local sc=sg:GetFirst()
		--if not cm.tfilter(sc,ev,re,rp) then return end
		Duel.Hint(HINT_CARD,0,sc:GetOriginalCode())
		local te=sc:GetActivateEffect()  
		Duel.ChangeTargetCard(ev,Group.CreateGroup())
		Duel.ChangeChainOperation(ev,cm.cop(te))
	end)
	e2:SetReset(RESET_EVENT+0x1fe0000)
	c:RegisterEffect(e2,true)
	return e2
end
function cm.filter3L(c)
	return Senya.check_set_3L(c) and c:IsFaceup()
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	if chk==0 then return e:GetHandler():IsDiscardable() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function cm.scopytg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local tc=cm.last_spell[Duel.GetTurnCount()-1]
	if chkc then
		local te=e:GetLabelObject()
		local tg=te:GetTarget()
		return te:IsHasProperty(EFFECT_FLAG_CARD_TARGET) and (not tg or tg(e,tp,eg,ep,ev,re,r,rp,0,chkc))
	end
	if chk==0 then
		if e:GetLabel()~=1 then return false end
		e:SetLabel(0)
		if not tc then return false end
		return cm.CopySpellNormalFilter(tc)
	end
	e:SetLabel(0)
	local te,ceg,cep,cev,cre,cr,crp=tc:CheckActivateEffect(false,true,true)
	e:SetCategory(te:GetCategory())
	e:SetProperty(te:GetProperty())
	local tg=te:GetTarget()
	if tg then tg(e,tp,ceg,cep,cev,cre,cr,crp,1) end
	te:SetLabelObject(e:GetLabelObject())
	e:SetLabelObject(te)
end
function cm.CopySpellChainingTarget(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local tc=cm.last_spell[Duel.GetTurnCount()-1]
	if chkc then
		local te=e:GetLabelObject()
		local tg=te:GetTarget()
		return te:IsHasProperty(EFFECT_FLAG_CARD_TARGET) and (not tg or tg(e,tp,eg,ep,ev,re,r,rp,0,chkc))
	end
	if chk==0 then
		if e:GetLabel()~=1 then return false end
		e:SetLabel(0)
		if not tc then return false end
		return cm.CopySpellChainingFilter(tc,e,tp,eg,ep,ev,re,r,rp)
	end
	e:SetLabel(0)
	local te,ceg,cep,cev,cre,cr,crp
	local fchain=cm.CopySpellNormalFilter(tc)
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
function cm.CopyOperation(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
	if not te then return end
	e:SetLabelObject(te:GetLabelObject())
	local op=te:GetOperation()
	if te:IsHasType(EFFECT_TYPE_ACTIVATE) then
		e:GetHandler():ReleaseEffectRelation(e)
	end
	if op then op(e,tp,eg,ep,ev,re,r,rp) end
end
function cm.CopySpellNormalFilter(c)
	return c:CheckActivateEffect(true,true,false)
end
function cm.CopySpellChainingFilter(c,e,tp,eg,ep,ev,re,r,rp)
	if c:CheckActivateEffect(true,true,false) then return true end
	local te=c:GetActivateEffect()
	if te:GetCode()~=EVENT_CHAINING then return false end
	local tg=te:GetTarget()
	if tg and not tg(e,tp,eg,ep,ev,re,r,rp,0) then return false end
	return true
end
--[[function cm.tfilter(c,ev,re,rp)
	if not c:IsType(TYPE_SPELL+TYPE_TRAP) then return false end
	local te=c:GetActivateEffect()
	if not te then return false end
	local code=te:GetCode()
	local rcode=re:GetCode()
	if code~=EVENT_FREE_CHAIN and code~=rcode then return false end
	local tg=te:GetTarget()
	if not tg then return true end
	if code==EVENT_CHAINING then
		local cid=Duel.GetChainInfo(ev-1,CHAININFO_CHAIN_ID)
		local ceg,cep,cev,cre,cr,crp=table.unpack(Senya.previous_chain_info[cid])
		return tg(re,rp,ceg,cep,cev,cre,cr,crp,0)
	else
		local ex,ceg,cep,cev,cre,cr,crp=Duel.CheckEvent(code,true)
		return tg(re,rp,ceg,cep,cev,cre,cr,crp,0)
	end
end]]
function cm.cop(te)
	return function(e,tp,eg,ep,ev,re,r,rp)
		if not te then return end
		local c=e:GetHandler()
		local tg=te:GetTarget()
		if (c:GetType() & TYPE_FIELD+TYPE_CONTINUOUS+TYPE_PENDULUM)==0 then
			c:CancelToGrave(false)
		end
		local code=te:GetCode()
		local ceg,cep,cev,cre,cr,crp
		if code==EVENT_CHAINING and Duel.GetCurrentChain()>1 then
			local chainc=Duel.GetCurrentChain()-1
			local cid=Duel.GetChainInfo(chainc,CHAININFO_CHAIN_ID)
			ceg,cep,cev,cre,cr,crp=table.unpack(Senya.previous_chain_info[cid])
		elseif code~=EVENT_FREE_CHAIN and Duel.CheckEvent(code) then
			_,ceg,cep,cev,cre,cr,crp=Duel.CheckEvent(code,true)
		else
			ceg,cep,cev,cre,cr,crp=eg,ep,ev,re,r,rp
		end
		local pr=e:GetProperty()
		e:SetProperty(te:GetProperty())
		if not cm.call_function(tg,e,tp,ceg,cep,cev,cre,cr,crp,0) then
			e:SetProperty(pr)
			Duel.NegateEffect(0)
			return
		end
		cm.call_function(tg,e,tp,ceg,cep,cev,cre,cr,crp,1)
		cm.call_function(te:GetOperation(),e,tp,ceg,cep,cev,cre,cr,crp)
		e:SetProperty(pr)
	end
end
function cm.call_function(f,e,tp,eg,ep,ev,re,r,rp,chk)
	if not f then return true end
	local res=false
	if not pcall(function() res=f(e,tp,eg,ep,ev,re,r,rp,chk) end) then return false end
	return res
end