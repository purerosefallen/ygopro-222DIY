--来吧，笑一个
function c22262001.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c22262001.condition)
	e1:SetTarget(c22262001.target)
	e1:SetOperation(c22262001.activate)
	c:RegisterEffect(e1)
end
function c22262001.IsKuMaKawa(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_KuMaKawa
end
function c22262001.condition(e)
	local g=Duel.GetFieldGroup(tp,LOCATION_MZONE,0)
	local tp=e:GetHandler():GetControler()
	local val=Duel.GetLP(1-tp)-Duel.GetLP(tp)
	return g:GetCount()==1 and c22262001.IsKuMaKawa(g:GetFirst()) and g:GetFirst():IsFaceup() and val>3000
end
function c22262001.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		Duel.SetChainLimit(aux.FALSE)
	end
end
function c22262001.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)~=1 then return end
	local tc=Duel.GetFieldGroup(tp,LOCATION_MZONE,0):GetFirst()
	if tc:IsFaceup() and tc:IsLocation(LOCATION_MZONE) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e1:SetValue(2500)
		tc:RegisterEffect(e1,true)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UPDATE_DEFENSE)
		tc:RegisterEffect(e2,true)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_FIELD)
		e3:SetCode(EFFECT_CHANGE_DAMAGE)
		e3:SetRange(LOCATION_MZONE)
		e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_AVAILABLE_BD+EFFECT_FLAG_CANNOT_DISABLE)
		e3:SetReset(RESET_EVENT+0x1fe0000)
		e3:SetTargetRange(1,0)
		e3:SetCondition(c22262001.con)
		e3:SetValue(0)
		tc:RegisterEffect(e3,true)
		local e4=e3:Clone()
		e4:SetCode(EFFECT_NO_EFFECT_DAMAGE)
		tc:RegisterEffect(e4,true)
		local e5=Effect.CreateEffect(c)
		e5:SetType(EFFECT_TYPE_SINGLE)
		e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e5:SetRange(LOCATION_MZONE)
		e5:SetCode(EFFECT_IMMUNE_EFFECT)
		e5:SetReset(RESET_EVENT+0x1fe0000)
		e5:SetValue(c22262001.efilter)
		tc:RegisterEffect(e5)
		local e6=Effect.CreateEffect(c)
		e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
		e6:SetCode(EVENT_LEAVE_FIELD)
		e6:SetOperation(c22262001.leaveop)
		e6:SetReset(RESET_EVENT+0xc020000)
		tc:RegisterEffect(e6,true)
	end
end
function c22262001.con(e)
	return e:GetHandlerPlayer()==e:GetOwnerPlayer()
end
function c22262001.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end
function c22262001.leaveop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SetLP(tp,100)
end