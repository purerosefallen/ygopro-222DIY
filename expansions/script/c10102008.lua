--和平与丰饶
function c10102008.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,10102008+EFFECT_COUNT_CODE_OATH)
	e1:SetHintTiming(TIMING_END_PHASE)
	e1:SetOperation(c10102008.activate)
	c:RegisterEffect(e1)   
	if c10102008.counter==nil then
		c10102008.counter=true
		c10102008[0]=0
		c10102008[1]=0
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e2:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		e2:SetOperation(c10102008.resetcount)
		Duel.RegisterEffect(e2,0)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e3:SetCode(EVENT_RELEASE)
		e3:SetOperation(c10102008.addcount)
		Duel.RegisterEffect(e3,0)
	end
end
function c10102008.resetcount(e,tp,eg,ep,ev,re,r,rp)
	c10102008[0]=0
	c10102008[1]=0
end
function c10102008.addcount(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	while tc do
	   local p=tc:GetReasonPlayer()
	   if tc:IsSetCard(0x9330) and tc:IsPreviousLocation(LOCATION_MZONE+LOCATION_HAND) and tc:IsType(TYPE_MONSTER) then
		  c10102008[p]=c10102008[p]+1
	   end
	tc=eg:GetNext()
	end
end
function c10102008.activate(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetCountLimit(1)
	e1:SetOperation(c10102008.droperation)
	Duel.RegisterEffect(e1,tp)
end
function c10102008.droperation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,10102008)
	Duel.Draw(tp,math.min(c10102008[tp],3),REASON_EFFECT)
end