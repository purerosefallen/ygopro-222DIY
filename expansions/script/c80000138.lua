--口袋妖怪 Mega沙奈朵
function c80000138.initial_effect(c)
	c:EnableReviveLimit()
	c:SetUniqueOnField(1,0,10000000) 
	--spsummon condition
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE)
	e7:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e7:SetCode(EFFECT_SPSUMMON_CONDITION)
	e7:SetValue(aux.FALSE)
	c:RegisterEffect(e7) 
	--immune
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetValue(c80000138.efilter)
	c:RegisterEffect(e2)	
	--remove
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_RANGE)
	e1:SetCode(EFFECT_TO_GRAVE_REDIRECT)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(0,0xff)
	e1:SetValue(LOCATION_REMOVED)
	e1:SetTarget(c80000138.rmtg)
	c:RegisterEffect(e1)
	--flip
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(80000138,0))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCountLimit(1)
	e3:SetRange(LOCATION_MZONE)
	e3:SetOperation(c80000138.operation)
	c:RegisterEffect(e3)
end 
function c80000138.efilter(e,te)
	if te:IsActiveType(TYPE_SPELL+TYPE_TRAP) then return true end
end
function c80000138.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.SortDecktop(tp,1-tp,5)
end
function c80000138.rmtg(e,c)
	return c:GetOwner()~=e:GetHandlerPlayer()
end



