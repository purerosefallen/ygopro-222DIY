--ＦＰＭ 宝宝暴龙
function c80000364.initial_effect(c)
	--cannot special summon
	local e3=Effect.CreateEffect(c)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e3)  
	--ritual level
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_RITUAL_LEVEL)
	e1:SetValue(c80000364.rlevel)
	c:RegisterEffect(e1)  
	--become material
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCode(EVENT_BE_MATERIAL)
	e2:SetCondition(c80000364.condition)
	e2:SetOperation(c80000364.operation)
	c:RegisterEffect(e2)
end
function c80000364.rlevel(e,c)
	local lv=e:GetHandler():GetLevel()
	if c:IsSetCard(0x2d1) then
		local clv=c:GetLevel()
		return lv*65536+clv
	else return lv end
end
function c80000364.condition(e,tp,eg,ep,ev,re,r,rp)
	return r==REASON_RITUAL
end
function c80000364.operation(e,tp,eg,ep,ev,re,r,rp)
	local rc=eg:GetFirst()
	while rc do
		if rc:GetFlagEffect(80000364)==0 then
			--immune
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetDescription(aux.Stringid(80000364,0))
			e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CLIENT_HINT)
			e1:SetRange(LOCATION_MZONE)
			e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			e1:SetValue(1)
			rc:RegisterEffect(e1,true)
			rc:RegisterFlagEffect(80000364,RESET_EVENT+0x1fe0000,0,1)
		end
		rc=eg:GetNext()
	end
end