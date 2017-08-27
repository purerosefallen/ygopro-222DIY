--口袋妖怪 玛力露
function c80000283.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,80000283)
	e1:SetCondition(c80000283.spcon)
	c:RegisterEffect(e1)  
	--summon success
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(80000283,0))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(c80000283.lvtg)
	e2:SetOperation(c80000283.lvop)
	c:RegisterEffect(e2)  
end
function c80000283.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x2d0) and not c:IsCode(80000283) and c:IsRace(RACE_FAIRY)
end
function c80000283.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c80000283.filter,c:GetControler(),LOCATION_MZONE,0,1,nil)
end
function c80000283.filter1(c)
	local lv=c:GetLevel()
	return c:IsFaceup() and c:IsSetCard(0x2d0) and lv>0 and lv~=3
end
function c80000283.lvtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c80000283.filter1,tp,LOCATION_MZONE,0,1,nil) end
end
function c80000283.lvop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c80000283.filter1,tp,LOCATION_MZONE,0,nil)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_LEVEL)
		e1:SetValue(3)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
		tc=g:GetNext()
	end
end