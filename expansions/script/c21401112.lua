--Rider 圣乔治
function c21401112.initial_effect(c)
	c:EnableCounterPermit(0xf0f)
	--cannot be target
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(c21401112.tgtg)
	e1:SetValue(aux.tgoval)
	c:RegisterEffect(e1)
	--race change
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCondition(c21401112.racecon)
	e2:SetCountLimit(1)
	e2:SetCost( c21401112.racecost)
	e2:SetOperation(c21401112.raceop)
	c:RegisterEffect(e2)
end
function c21401112.tgtg(e,c)
	return c:IsSetCard(0xf00) and c~=e:GetHandler()
end
function c21401112.racecon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2
end
function c21401112.filter(c)
	return c:IsFaceup() and not c:IsRace(RACE_DRAGON)
end
function c21401112.racetg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c21401112.filter,tp,0,LOCATION_MZONE,1,nil) end
	local sg=Duel.GetMatchingGroup(c21401112.filter,tp,0,LOCATION_MZONE,nil)
end
function c21401112.racecost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanRemoveCounter(tp,0xf0f,2,REASON_COST) end
	local c1=e:GetHandler():GetCounter(0xf0f)
	e:GetHandler():RemoveCounter(tp,0xf0f,2,REASON_COST)
	local c2=e:GetHandler():GetCounter(0xf0f)
	if c1==c2+2 then
	Duel.RaiseEvent(e:GetHandler(),EVENT_CUSTOM+0xf0f,e,0,tp,0,0)
	end
end
function c21401112.raceop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local sg=Duel.GetMatchingGroup(c21401112.filter,tp,0,LOCATION_MZONE,nil)
	if sg:GetCount()>0 then
		local sc=sg:GetFirst()
		while sc do
	        local e1=Effect.CreateEffect(c)
	        e1:SetType(EFFECT_TYPE_SINGLE)
         	e1:SetCode(EFFECT_CHANGE_RACE)
        	e1:SetProperty(EFFECT_FLAG_OWNER_RELATE+EFFECT_FLAG_CANNOT_DISABLE)
	        e1:SetReset(RESET_EVENT+0x1fe0000)
	        e1:SetValue(RACE_DRAGON)
	        sc:RegisterEffect(e1)
			sc=sg:GetNext()
		end
	end
end