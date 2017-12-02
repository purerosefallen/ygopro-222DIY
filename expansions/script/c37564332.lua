--狂气之瞳·Senhane
local m=37564332
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c37564765") end,function() require("script/c37564765") end)
function cm.initial_effect(c)
	Senya.enable_kaguya_check_3L()
	aux.AddXyzProcedure(c,nil,8,2)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetHintTiming(0,TIMING_DRAW_PHASE)
	e1:SetCost(cm.atcost)
	e1:SetTarget(cm.attg)
	e1:SetOperation(cm.atop)
	c:RegisterEffect(e1)
end
function cm.atcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function cm.attg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(0,m)==0 end
end
function cm.atop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(0,m)>0 then return end
	Duel.RegisterFlagEffect(0,m,RESET_PHASE+PHASE_END,0,1)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAINING)
	e2:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
		return re:IsHasType(EFFECT_TYPE_ACTIVATE) and Duel.IsPlayerCanDiscardDeck(ep,1)
	end)
	e2:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
		Duel.Hint(HINT_CARD,0,e:GetOwner():GetOriginalCode())
		Duel.DiscardDeck(ep,1,REASON_EFFECT)
		local sc=Duel.GetOperatedGroup():GetFirst()
		if cm.tfilter(sc,ev,re,rp) then
			local te=sc:GetActivateEffect()
			Duel.Hint(HINT_CARD,0,sc:GetOriginalCode())		
			Duel.ChangeTargetCard(ev,Group.CreateGroup())
			Duel.ChangeChainOperation(ev,cm.cop(te))
		end
	end)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
end
function cm.tfilter(c,ev,re,rp)
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
end
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