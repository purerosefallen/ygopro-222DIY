--Nanahira & Sherry
local m=37564555
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c37564765") end,function() require("script/c37564765") end)
cm.Senya_desc_with_nanahira=true
function cm.initial_effect(c)
	Senya.NanahiraPendulum(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.operation)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCode(EVENT_LEAVE_FIELD_P)
	e2:SetOperation(cm.checkop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetOperation(cm.desop)
	e3:SetLabelObject(e2)
	c:RegisterEffect(e3)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(m*16+1)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_PZONE)
	e3:SetCountLimit(1,m)
	e3:SetCost(function(e,tp,eg,ep,ev,re,r,rp,chk)
		local p1=Duel.CheckLocation(tp,LOCATION_SZONE,6)
		local p2=Duel.CheckLocation(tp,LOCATION_SZONE,7)
		local pend=p1 or p2
		local c=e:GetHandler()
		local g=Duel.GetMatchingGroup(cm.f,tp,LOCATION_ONFIELD,0,c,pend)
		e:SetLabel(1)
		if chk==0 then return g:GetCount()>0 and c:IsReleasable() end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		local sg=g:Select(tp,1,1,nil)
		sg:AddCard(c)
		Duel.Release(sg,REASON_COST)
	end)
	e3:SetTarget(function(e,tp,eg,ep,ev,re,r,rp,chk)
		if chk==0 then
			local l=e:GetLabel()
			e:SetLabel(0)
			if l~=1 and not (Duel.CheckLocation(tp,LOCATION_SZONE,6) and Duel.CheckLocation(tp,LOCATION_SZONE,7)) then return false end
			return Duel.IsExistingMatchingCard(cm.pcfilter,tp,LOCATION_DECK,0,2,nil)
		end
		e:SetLabel(0)
	end)
	e3:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
		if not (Duel.CheckLocation(tp,LOCATION_SZONE,6) and Duel.CheckLocation(tp,LOCATION_SZONE,7)) then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
		local g=Duel.SelectMatchingCard(tp,cm.pcfilter,tp,LOCATION_DECK,0,2,2,nil)
		local pc=g:GetFirst()
		while pc do
			Duel.MoveToField(pc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
			pc:RegisterEffect(e1,true)
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e2:SetValue(RESET_TURN_SET)
			e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
			pc:RegisterEffect(e2,true)
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_CHANGE_CODE)
			e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e2:SetValue(37564765)
			e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
			pc:RegisterEffect(e2,true)
			pc=g:GetNext()
		end
	end)
	c:RegisterEffect(e3)
end
cm.pendulum_level=7
function cm.f(c,pend)
	if not pend and (c:GetSequence()<5 or c:IsLocation(LOCATION_MZONE)) then return false end
	return c:IsCode(37564765) and c:IsReleasable()
end
function cm.pcfilter(c)
	return c:IsType(TYPE_PENDULUM) and c.Senya_desc_with_nanahira and not c:IsForbidden()
end
function cm.filter(c)
	return c.Senya_desc_with_nanahira and c:IsType(TYPE_TRAP) and c:IsSSetable()
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_DECK,0,1,nil) end
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFacedown() or not c:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_DECK,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.SSet(tp,tc)
		Duel.ConfirmCards(1-tp,tc)
		c:SetCardTarget(tc)
	end
end
function cm.checkop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsDisabled() then
		e:SetLabel(1)
	else e:SetLabel(0) end
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabelObject():GetLabel()~=0 then return end
	local tc=e:GetHandler():GetFirstCardTarget()
	if tc and tc:IsLocation(LOCATION_SZONE) and tc:IsFacedown() then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end