--感情的摩天楼 -3L Remix-
local m=37564825
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c37564765") end,function() require("script/c37564765") end)
cm.Senya_name_with_remix=true
function cm.initial_effect(c)
	--Senya.CommonEffect_3L(c,m)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,m)
	e1:SetTarget(cm.eqtg)
	e1:SetOperation(cm.eqop)
	c:RegisterEffect(e1)
	local e3=e1:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_EXTRA_FUSION_MATERIAL)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_SZONE,0)
	e3:SetTarget(cm.mttg)
	e3:SetValue(cm.mtval)
	c:RegisterEffect(e3)
end
function cm.effect_operation_3L(c,ctlm)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,1))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(ctlm)
	e1:SetCondition(cm.condition)
	e1:SetOperation(cm.operation)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	c:RegisterEffect(e1,true)
	return e1
end
function cm.eqfilter(c,tp)
	return c:IsFaceup() and (c:IsControler(tp) or c:IsAbleToChangeControler())
end
function cm.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and cm.eqfilter(chkc,tp) and chkc~=e:GetHandler() end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingTarget(cm.eqfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,e:GetHandler(),tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectTarget(tp,cm.eqfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,e:GetHandler(),tp)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,g,1,0,0)
end
function cm.eqop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not (tc:IsRelateToEffect(e) and tc:IsFaceup()) then return end
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		if Duel.Equip(tp,tc,c)==0 then return end
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetCode(EFFECT_EQUIP_LIMIT)
		e2:SetValue(cm.eqlimit)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e2)
	else Duel.SendtoGrave(tc,REASON_EFFECT) end
end
function cm.eqlimit(e,c)
	return e:GetOwner()==c
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:GetHandler():IsOnField() and (re:GetHandler():GetOriginalType() & TYPE_PENDULUM)==0 and re:GetHandler():GetFlagEffect(m)==0
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	local c=e:GetHandler()
	local cid=Duel.GetChainInfo(ev,CHAININFO_CHAIN_ID)
	if rc:IsRelateToEffect(re) then
		local te=re
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_CHAIN_SOLVED)
		e1:SetLabel(cid)
		e1:SetReset(RESET_CHAIN)
		e1:SetLabelObject(rc)
		e1:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
			local rc=e:GetLabelObject()
			if Duel.GetChainInfo(ev,CHAININFO_CHAIN_ID)~=e:GetLabel() or not rc:IsRelateToEffect(re) then return false end
			if rc:GetFlagEffect(m)>0 then return false end
			local seq=rc:GetSequence()
			if seq>5 then return false end
			if rc:GetControler()==tp then return true end
			if seq==5 then return true end
			return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		end)
		e1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
			local rc=e:GetLabelObject()
			if rc:IsStatus(STATUS_LEAVE_CONFIRMED) then
				rc:CancelToGrave()
			end
			if rc:GetControler()~=tp then
				--Senya.ExileCard(rc)
				Duel.MoveToField(rc,tp,tp,LOCATION_SZONE,POS_FACEDOWN,true)
			else
				Duel.ChangePosition(rc,POS_FACEDOWN)
			end
			Duel.RaiseEvent(rc,EVENT_SSET,te,REASON_EFFECT,tp,tp,0)
			rc:RegisterFlagEffect(m,RESET_EVENT+0x47e0000,0,1)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetReset(RESET_EVENT+0x47e0000)
			e1:SetValue(LOCATION_REMOVED)
			rc:RegisterEffect(e1)
		end)
		Duel.RegisterEffect(e1,tp)
	end
end
function cm.mttg(e,c)
	return c:GetEquipTarget()==e:GetHandler()
end
function cm.mtval(e,c)
	return not c or Senya.check_set_3L(c)
end
