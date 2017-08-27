--口袋妖怪 触手百合
function c80000150.initial_effect(c)
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
	e1:SetValue(c80000150.rlevel)
	c:RegisterEffect(e1) 
	--xyz limit
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e4:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	e4:SetValue(c80000150.xyzlimit)
	c:RegisterEffect(e4)  
	--ritual material
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_EXTRA_RITUAL_MATERIAL)
	c:RegisterEffect(e2)
	--become material
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetCode(EVENT_BE_MATERIAL)
	e3:SetCondition(c80000150.condition)
	e3:SetOperation(c80000150.operation)
	c:RegisterEffect(e3)
end
function c80000150.rlevel(e,c)
	local lv=e:GetHandler():GetLevel()
	if c:IsSetCard(0x2d1) then
		local clv=c:GetLevel()
		return lv*65536+clv
	else return lv end
end	   
function c80000150.xyzlimit(e,c)
	if not c then return false end
	return not c:IsSetCard(0x2d0)
end
function c80000150.condition(e,tp,eg,ep,ev,re,r,rp)
	return r==REASON_RITUAL
end
function c80000150.operation(e,tp,eg,ep,ev,re,r,rp)
	local rc=e:GetHandler():GetReasonCard()
	if rc:GetFlagEffect(80000150)==0 then
		--untargetable
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetDescription(aux.Stringid(80000150,0))
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CLIENT_HINT)
		e1:SetRange(LOCATION_MZONE)
		e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
		e1:SetValue(aux.tgoval)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		rc:RegisterEffect(e1,true)
		rc:RegisterFlagEffect(80000150,RESET_EVENT+0x1fe0000,0,1)
	end
end