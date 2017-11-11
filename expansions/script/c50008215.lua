--请问您今天要来点恶作剧吗
local m=50008215
local cm=_G["c"..m]
local mil=require("expansions/script/Millux")
cm.is_series_with_rabbit=true
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,0x1c0)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(
	function(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
		if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and cm.filter(chkc) end
		if chk==0 then return Duel.IsExistingTarget(cm
.filter,tp,LOCATION_MZONE,0,1,nil) end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
		Duel.SelectTarget(tp,cm.filter,tp,LOCATION_MZONE,0,1,1,nil)
	end)
	c:RegisterEffect(e1)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCode(EVENT_CHAIN_SOLVED)
	e3:SetCondition(
	function(e,tp,eg,ep,ev,re,r,rp)
		return re==e:GetLabelObject()
	end)
	e3:SetOperation(
	function(e,tp,eg,ep,ev,re,r,rp)
		local c=e:GetHandler()
		local tc=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS):GetFirst()
		if c:IsRelateToEffect(re) and tc:IsFaceup() and tc:IsRelateToEffect(re) then
			c:SetCardTarget(tc)
		end
	end)
	e3:SetLabelObject(e1)
	c:RegisterEffect(e3)
	--atk up
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_UPDATE_ATTACK)
	e4:SetRange(LOCATION_SZONE)
	e4:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e4:SetTarget(cm.tg)
	e4:SetValue(800)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e5)
	--immune effect
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetCode(EFFECT_IMMUNE_EFFECT)
	e6:SetRange(LOCATION_SZONE)
	e6:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e6:SetTarget(cm.tg)
	e6:SetValue(
	function(e,re)
		return re:GetOwnerPlayer()~=e:GetHandlerPlayer()
	end)
	c:RegisterEffect(e6)
	--disable
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_FIELD)
	e7:SetCode(EFFECT_DISABLE)
	e7:SetRange(LOCATION_SZONE)
	e7:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e7:SetTarget(cm.tg)
	c:RegisterEffect(e7)
	--destroy2
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e8:SetRange(LOCATION_SZONE)
	e8:SetCode(EVENT_LEAVE_FIELD)
	e8:SetCondition(
	function(e,tp,eg,ep,ev,re,r,rp)
		local tc=e:GetHandler():GetFirstCardTarget()
		return tc and eg:IsContains(tc)
	end)
	e8:SetOperation(
	function(e,tp,eg,ep,ev,re,r,rp)
		Duel.Destroy(e:GetHandler(),REASON_EFFECT)
	end)
	c:RegisterEffect(e8)
	--cannot trigger
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_FIELD)
	e9:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e9:SetCode(EFFECT_CANNOT_ACTIVATE)
	e9:SetRange(LOCATION_SZONE)
	e9:SetTargetRange(1,0)
	e9:SetValue(
	function(e,re,tp)
		local c=re:GetHandler()
		return re:IsActiveType(TYPE_MONSTER) and not mil.is_series(c,'rabbit')
	end)
	c:RegisterEffect(e9)
end
function cm.filter(c)
	return c:IsFaceup() and mil.is_series(c,'rabbit')
end
function cm.tg(e,c)
	 return e:GetHandler():IsHasCardTarget(c)
end