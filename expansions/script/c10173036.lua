--无敌卡AAA
function c10173036.initial_effect(c)
	--effect
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10173036,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,10173036)
	e1:SetHintTiming(0,0x1c0)
	e1:SetRange(LOCATION_HAND)
	e1:SetCost(c10173036.cost)
	e1:SetOperation(c10173036.operation)
	c:RegisterEffect(e1)
	if not c10173036.global_check then
		c10173036.global_check=true
		Real_Scl={}
		Dark_Scl={}
		Real_Scl[1]=0
		Dark_Scl[1]=0
		local ge1=Effect.GlobalEffect()
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SUMMON_SUCCESS)
		ge1:SetOperation(c10173036.checkop1)
		Duel.RegisterEffect(ge1,0)
		local ge2=ge1:Clone()
		ge2:SetCode(EVENT_SPSUMMON_SUCCESS)
		Duel.RegisterEffect(ge2,0)
		local ge3=ge1:Clone()
		ge3:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
		Duel.RegisterEffect(ge3,0)
		local ge4=ge1:Clone()
		ge4:SetCode(EVENT_CHAINING)
		ge4:SetOperation(c10173036.checkop2)
		Duel.RegisterEffect(ge4,0)
		local ge5=ge1:Clone()
		ge5:SetCode(EVENT_CHAIN_SOLVED)
		ge5:SetOperation(c10173036.checkop3)
		Duel.RegisterEffect(ge5,0)
		local ge6=Effect.CreateEffect(c)
		ge6:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		ge6:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		ge6:SetOperation(c10173036.reset)
		Duel.RegisterEffect(ge6,0)
	end
end
function c10173036.checkop3(e,tp,eg,ep,ev,re,r,rp)
	for k,v in ipairs(Dark_Scl) do
		if v==re:GetHandler():GetCode() then
		return end
	end
	if re:IsActiveType(TYPE_MONSTER) then
	   Dark_Scl[#Dark_Scl+1]=re:GetHandler():GetCode()
	end
end
function c10173036.checkop2(e,tp,eg,ep,ev,re,r,rp)
	if re:IsActiveType(TYPE_MONSTER) then
	   Dark_Scl[#Dark_Scl+1]=re:GetHandler():GetCode()
	end
end
function c10173036.reset(e,tp,eg,ep,ev,re,r,rp)
	Real_Scl={}
	Dark_Scl={}
	Real_Scl[1]=0
	Dark_Scl[1]=0
end
function c10173036.checkop1(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	while tc do
	   Real_Scl[#Real_Scl+1]=tc:GetCode()
	tc=eg:GetNext()
	end
end
function c10173036.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function c10173036.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(0,1)
	e1:SetTarget(c10173036.tg)
	e1:SetReset(RESET_PHASE+PHASE_END,2)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	Duel.RegisterEffect(e2,tp)
	local e3=e1:Clone()
	e3:SetCode(EFFECT_CANNOT_FLIP_SUMMON)
	Duel.RegisterEffect(e3,tp)
	local e4=e1:Clone()
	e4:SetCode(EFFECT_CANNOT_ACTIVATE)
	e4:SetValue(c10173036.tg2)
	Duel.RegisterEffect(e4,tp)
end
function c10173036.tg2(e,re,tp)
	return Dark_Scl and re:GetHandler():IsCode(table.unpack(Dark_Scl)) and not re:GetHandler():IsImmuneToEffect(e) and re:IsActiveType(TYPE_MONSTER)
end
function c10173036.tg(e,c)
	return Real_Scl and c:IsCode(table.unpack(Real_Scl))
end