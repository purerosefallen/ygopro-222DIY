--请问您今天要来运动吗
local m=50008208
local cm=_G["c"..m]
local mil=require("expansions/script/Millux")
cm.is_series_with_rabbit=true
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(TIMING_DAMAGE_STEP)
	e1:SetCondition(
	function(e,tp,eg,ep,ev,re,r,rp)
		return Duel.GetCurrentPhase()~=PHASE_DAMAGE or not Duel.IsDamageCalculated()
	end)
	e1:SetTarget(
	function(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
		if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and cm.filter(chkc) end
		if chk==0 then return Duel.IsExistingTarget(cm.filter,tp,LOCATION_MZONE,0,1,nil) end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
		Duel.SelectTarget(tp,cm.filter,tp,LOCATION_MZONE,0,1,1,nil)
	end)
	e1:SetOperation(
	function(e,tp,eg,ep,ev,re,r,rp)
		local c=e:GetHandler()
		local tc=Duel.GetFirstTarget()
		if tc:IsRelateToEffect(e) and tc:IsFaceup() and tc:IsControler(tp) then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			e1:SetValue(500)
			tc:RegisterEffect(e1)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_UPDATE_DEFENSE)
			tc:RegisterEffect(e2)
			local e3=Effect.CreateEffect(c)
			e3:SetDescription(aux.Stringid(m,0))
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetCode(EFFECT_IMMUNE_EFFECT)
			e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CLIENT_HINT)
			e3:SetRange(LOCATION_MZONE)
			e3:SetValue(function(e,re) return e:GetOwnerPlayer()~=re:GetOwnerPlayer() end)
			e3:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
			e3:SetOwnerPlayer(tp)
			tc:RegisterEffect(e3)
		end
	end)
	c:RegisterEffect(e1)
	--destroy replace
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetTarget(
	function(e,tp,eg,ep,ev,re,r,rp,chk)
		if chk==0 then return e:GetHandler():IsAbleToRemove() and eg:IsExists(cm.repfilter,1,nil,tp) end
		return Duel.SelectEffectYesNo(tp,e:GetHandler(),96)
	end)
	e2:SetValue(function(e,c) return cm.repfilter(c,e:GetHandlerPlayer()) end)
	e2:SetOperation(function(e,tp,eg,ep,ev,re,r,rp) Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT) end)
	c:RegisterEffect(e2)
end
function cm.repfilter(c,tp)
	return c:IsFaceup() and mil.is_series(c,'rabbit') and c:IsLocation(LOCATION_ONFIELD)
		and c:IsControler(tp) and c:IsReason(REASON_EFFECT+REASON_BATTLE)
end
function cm.filter(c)
	return mil.is_series(c,'rabbit') and c:IsFaceup()
end