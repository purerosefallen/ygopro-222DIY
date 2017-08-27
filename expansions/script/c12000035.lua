--奇迹糕点 巧克力布丁拼盘
function c12000035.initial_effect(c)
	 --xyz summon
	 aux.AddXyzProcedure(c,nil,9,2,c12000035.ovfilter,aux.Stringid(12000035,1),2)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1)
	e1:SetOperation(c12000035.activate)
	c:RegisterEffect(e1)
	if c12000035.counter==nil then
		c12000035.counter=true
		c12000035[0]=0
		c12000035[1]=0
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e2:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		e2:SetOperation(c12000035.resetcount)
		Duel.RegisterEffect(e2,0)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e3:SetCode(EVENT_RELEASE)
		e3:SetOperation(c12000035.addcount)
		Duel.RegisterEffect(e3,0)
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e4:SetCode(EVENT_DISCARD)
		e4:SetOperation(c12000035.addcount)
		Duel.RegisterEffect(e4,0)
	end
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_UNCOPYABLE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCode(EFFECT_IMMUNE_EFFECT)
	e5:SetCondition(c12000035.immcon)
	e5:SetValue(c12000035.efilter)
	c:RegisterEffect(e5)
end
function c12000035.immcon(e)
	return e:GetHandler()
end
function c12000035.efilter(e,te)
	if te:IsActiveType(TYPE_SPELL+TYPE_TRAP) or te:IsType(TYPE_TOKEN) then return true
	else return aux.qlifilter(e,te) end
end
function c12000035.resetcount(e,tp,eg,ep,ev,re,r,rp)
	c12000035[0]=0
	c12000035[1]=0
end
function c12000035.addcount(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	while tc do
		local pl=tc:GetPreviousLocation()
		if pl==LOCATION_MZONE and tc:IsSetCard(0xfbe) then
			local p=tc:GetReasonPlayer()
			c12000035[p]=c12000035[p]+1
		elseif pl==LOCATION_HAND and tc:IsSetCard(0xfbe) then
			local p=tc:GetPreviousControler()
			c12000035[p]=c12000035[p]+1
		end
		tc=eg:GetNext()
	end
end
function c12000035.activate(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetCountLimit(1)
	e1:SetOperation(c12000035.droperation)
	Duel.RegisterEffect(e1,tp)
end
function c12000035.droperation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,12000035)
	Duel.Draw(tp,c12000035[tp],REASON_EFFECT)
end
function c12000035.ovfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xfbe) and c:GetCode()~=12000035 and c:IsType(TYPE_XYZ)
end