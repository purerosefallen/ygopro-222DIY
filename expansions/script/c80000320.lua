--传说中的口袋妖怪 急冻鸟
function c80000320.initial_effect(c)
	if c:IsStatus(STATUS_COPYING_EFFECT) then return end
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,c80000320.ffilter,5,true)
	--counter
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(80000320,0))
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTarget(c80000320.cttg)
	e1:SetOperation(c80000320.ctop)
	c:RegisterEffect(e1)
	--atk,pos limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_ATTACK)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetTarget(c80000320.target)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_CANNOT_CHANGE_POSITION)
	c:RegisterEffect(e3)
	--negate
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_DISABLE)
	e4:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_DISABLE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
	e4:SetTarget(c80000320.target)
	c:RegisterEffect(e4)
	--sy
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	e5:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e5:SetValue(c80000320.target)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	c:RegisterEffect(e6)
	--win
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(80000320,1))
	e7:SetRange(LOCATION_MZONE)
	e7:SetType(EFFECT_TYPE_IGNITION)
	e7:SetCountLimit(1,80000320+EFFECT_COUNT_CODE_DUEL)
	e7:SetCondition(c80000320.wincon)
	e7:SetOperation(c80000320.winop)
	c:RegisterEffect(e7)
	--wudi 
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE)
	e8:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e8:SetRange(LOCATION_MZONE)
	e8:SetCode(EFFECT_IMMUNE_EFFECT)
	e8:SetValue(c80000320.efilter)
	c:RegisterEffect(e8)   
	--spsummon limit
	local e9=Effect.CreateEffect(c)
	e9:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e9:SetType(EFFECT_TYPE_SINGLE)
	e9:SetCode(EFFECT_SPSUMMON_CONDITION)
	e9:SetValue(c80000320.splimit)
	c:RegisterEffect(e9)   
end
function c80000320.splimit(e,se,sp,st)
	return bit.band(st,SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION 
end
function c80000320.target(e,c)
	return c~=e:GetHandler() and c:GetCounter(0x15)~=0
end
function c80000320.ffilter(c)
	return  c:IsSetCard(0x2d0) and c:IsAttribute(ATTRIBUTE_WATER) and c:IsRace(RACE_WINDBEAST)
end
function c80000320.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end
function c80000320.cttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_ONFIELD,1,e:GetHandler()) end
end
function c80000320.ctop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_ONFIELD,e:GetHandler())
	local tc=g:GetFirst()
	while tc do
		tc:AddCounter(0x15,1)
		tc=g:GetNext()
	end
end
function c80000320.wincon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetLP(1-tp)<=3000 and Duel.GetLP(tp)>=3000
end
function c80000320.winop(e,tp,eg,ep,ev,re,r,rp)
	local WIN_REASON_DISASTER_LEO=0x30
	Duel.Win(tp,WIN_REASON_DISASTER_LEO)
end