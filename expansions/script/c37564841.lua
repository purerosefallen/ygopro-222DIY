--3L·破月
local m=37564841
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c37564765") end,function() require("script/c37564765") end)
function cm.initial_effect(c)
	--Senya.CommonEffect_3L(c,m)
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(m,0))
	e6:SetType(EFFECT_TYPE_IGNITION)
	e6:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e6:SetRange(LOCATION_HAND)
	e6:SetCountLimit(1,m)
	e6:SetCost(Senya.SelfToGraveCost)
	e6:SetTarget(cm.target)
	e6:SetOperation(cm.activate)
	c:RegisterEffect(e6)
end
function cm.effect_operation_3L(c,ctlm)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_SELF_DESTROY)
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e1:SetTargetRange(0,LOCATION_ONFIELD)
	e1:SetTarget(function(e,c)
		if c:IsImmuneToEffect(e) then return false end
		local s1=e:GetHandler():GetSequence()
		local s2=c:GetSequence()
		if c:IsLocation(LOCATION_SZONE) then
			if s2>=5 then return false end
			if s1<5 then
				return s1+s2==4
			else
				return (s1==5 and s2==3) or (s1==6 and s2==1)
			end
		end
		if s1<5 then
			if s2<5 then
				return s1+s2==4
			else
				return (s2==5 and s1==3) or (s2==6 and s1==1)
			end
		else
			if s2<5 then
				return (s1==5 and s2==3) or (s1==6 and s2==1)
			else
				return false
			end
		end
	end)
	e1:SetValue(aux.TRUE)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	c:RegisterEffect(e1,true)
	Duel.Readjust()
	return e1
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,Card.IsFaceup,tp,0,LOCATION_MZONE,1,1,nil)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(m)
		e2:SetDescription(m*16+2)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CLIENT_HINT)
		e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2,true)
	end
end