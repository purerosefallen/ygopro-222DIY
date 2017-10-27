--新津 恶役
function c16080004.initial_effect(c)
	--SpecialSummon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c16080004.spcon)
	c:RegisterEffect(e1)
	--Disable
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_DISABLE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,LOCATION_SZONE)
	e2:SetTarget(c16080004.attg)
	e2:SetCondition(c16080004.atcon)
	c:RegisterEffect(e2)
	--disable effect
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_CHAIN_SOLVING)
	e4:SetRange(LOCATION_MZONE)
	e4:SetOperation(c16080004.disop)
	c:RegisterEffect(e4)
	--disable trap monster
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_DISABLE_TRAPMONSTER)
	e5:SetRange(LOCATION_MZONE)
	e5:SetTargetRange(0,LOCATION_MZONE)
	e5:SetTarget(c16080004.attg)
	c:RegisterEffect(e5)
	--change
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_POSITION)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	e3:SetOperation(c16080004.rmop)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e4)
end
function c16080004.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x5ca) and not c:IsCode(16080004)
end
function c16080004.spcon(e,c)
	if c==nil then return true end
	return Duel.GetMZoneCount(c:GetControler())>0
		and Duel.IsExistingMatchingCard(c16080004.filter,c:GetControler(),LOCATION_MZONE,0,1,nil)
end
function c16080004.attg(e,c)
	return c~=e:GetHandler() and c:IsType(TYPE_CONTINUOUS)
end
function c16080004.atcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetPosition()==POS_FACEUP_ATTACK 
end
function c16080004.rmfilter(c)
	return c:IsType(TYPE_MONSTER) 
end
--function c16080004.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	--if chk==0 then return true end
	--local g=Duel.GetMatchingGroup(c16080004.rmfilter(),tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	--Duel.SetOperationInfo(0,CATEGORY_POSITION,g,g:GetCount(),0,0)
--end
function c16080004.rmop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c16080004.rmfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	Duel.ChangePosition(g,POS_FACEUP_DEFENSE,POS_FACEDOWN_DEFENSE,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK,true)
end
function c16080004.disop(e,tp,eg,ep,ev,re,r,rp)
	local tl=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	if tl==LOCATION_SZONE and re:IsActiveType(TYPE_CONTINUOUS) and rp~=tp then
		Duel.NegateEffect(ev)
	end
end