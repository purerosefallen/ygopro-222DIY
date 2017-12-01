--Brambly Rose Garden
local m=37564056
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c37564765") end,function() require("script/c37564765") end)
cm.Senya_name_with_rose=true
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(Senya.DiscardHandCost(1))
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.operation)
	c:RegisterEffect(e1)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0 end
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp,chk)
	local hg=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
	if hg:GetCount()==0 then return end
	local tc=hg:RandomSelect(tp,1):GetFirst()
	if tc:GetFlagEffect(m)>0 then return end
	tc:RegisterFlagEffect(m,0x1fe1000+RESET_PHASE+PHASE_END,0,1)
	local e0=Effect.CreateEffect(e:GetHandler())
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_PUBLIC)
	e0:SetValue(1)
	e0:SetReset(0x1fe1000+RESET_PHASE+PHASE_END)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	tc:RegisterEffect(e0,true)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAIN_SOLVED)
	e1:SetOperation(cm.regop)
	e1:SetLabelObject(tc)
	e1:SetLabel(1)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetCountLimit(1)
	e2:SetCondition(cm.damcon)
	e2:SetOperation(cm.damop)
	e2:SetReset(RESET_PHASE+PHASE_END)
	e2:SetLabelObject(e1)
	Duel.RegisterEffect(e2,tp)
	local f=Card.RegisterEffect
	Card.RegisterEffect=cm.replace_register_effect(f,tp)
	tc:CopyEffect(tc:GetOriginalCode(),0x1fe1000+RESET_PHASE+PHASE_END,1)
	Card.RegisterEffect=f
end
function cm.replace_register_effect(f,p)
	return function(c,e,forced)
		if e:IsHasType(0x7f0) then
			if e:IsHasType(EFFECT_TYPE_ACTIVATE) and not c:IsType(TYPE_PENDULUM) then
				if c:IsType(TYPE_TRAP+TYPE_QUICKPLAY) then
					e:SetType(EFFECT_TYPE_QUICK_O)
				else
					e:SetType(EFFECT_TYPE_IGNITION)
					e:SetCode(0)
				end
				e:SetRange(LOCATION_HAND)
				local cost=e:GetCost()
				e:SetCost(function(e,tp,eg,ep,ev,re,r,rp,chk)
					if chk==0 then
						local let={Duel.IsPlayerAffectedByEffect(tp,EFFECT_CANNOT_ACTIVATE)}
						for _,le in pairs(let) do
							local cres=Senya.GetEffectValue(le,c:GetActivateEffect(),le:GetHandlerPlayer())
							if cres and cres~=0 then return false end
						end
						return (not cost or cost(e,tp,eg,ep,ev,re,r,rp,0)) and (Duel.GetLocationCount(tp,LOCATION_SZONE)>0 or c:IsType(TYPE_FIELD))
					end
					local c=e:GetHandler()
					Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP_ATTACK,true)
					c:CreateEffectRelation(e)
					c:SetStatus(STATUS_ACTIVATED,true)
					if not c:IsType(TYPE_EQUIP+TYPE_CONTINUOUS+TYPE_FIELD) and not c:IsHasEffect(EFFECT_REMAIN_FIELD) then
						c:CancelToGrave(false)
					end
					e:SetType(EFFECT_TYPE_ACTIVATE)
					if cost then cost(e,tp,eg,ep,ev,re,r,rp,1) end
				end)
			end
			local pr=e:GetProperty()
			e:SetProperty(bit.bor(pr,EFFECT_FLAG_BOTH_SIDE))
			local con=e:GetCondition()
			e:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
				return (not con or con(e,tp,eg,ep,ev,re,r,rp)) and tp==p
			end)
			e:SetTarget(cm.replace_function(e:GetTarget()))
			e:SetOperation(cm.replace_function(e:GetOperation()))
			return f(c,e,true)
		end
	end
end
function cm.replace_function(of)
	return function(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
		local f=Duel.IsPlayerAffectedByEffect
		Duel.IsPlayerAffectedByEffect=cm.replace_affected_by_effect(f)
		local res=(not of or of(e,tp,eg,ep,ev,re,r,rp,chk,chkc))
		Duel.IsPlayerAffectedByEffect=f
		return res
	end
end
function cm.replace_affected_by_effect(f)
	return function(tp,code)
		local p=tp
		if code==88581108 then p=1-p end
		return f(p,code)
	end
end
function cm.regop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabel()==0 then return end
	local tc=re:GetHandler()
	if ep==tp and tc==e:GetLabelObject() then
		e:SetLabel(0)
	end
end
function cm.damcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetLabelObject():GetLabel()~=0
end
function cm.damop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Damage(tp,2000,REASON_EFFECT)
end