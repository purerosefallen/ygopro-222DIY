--次元呼唤
function c10173007.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetHintTiming(TIMING_SPSUMMON)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1) 
	--actlimit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_CANNOT_ACTIVATE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(1,0)
	e2:SetValue(c10173007.aclimit)
	e2:SetCondition(c10173007.actcon)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetTargetRange(0,1)
	e3:SetValue(c10173007.aclimit2)
	e3:SetCondition(c10173007.actcon2) 
	c:RegisterEffect(e3)
	--selfdes
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetCode(EFFECT_SELF_DESTROY)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(c10173007.descon)
	c:RegisterEffect(e4)
end
function c10173007.descon(e)
	return not Duel.IsExistingMatchingCard(c10173007.acfilter,e:GetHandlerPlayer(),LOCATION_MZONE,LOCATION_MZONE,1,nil)
end
function c10173007.actcon(e)
	return Duel.IsExistingMatchingCard(c10173007.acfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
function c10173007.acfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_RITUAL+TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ)
end
function c10173007.aclimit(e,re,tp)
	local rc=re:GetHandler()
	local g=Duel.GetMatchingGroup(c10173007.acfilter,tp,LOCATION_MZONE,0,nil)
	return not rc:IsImmuneToEffect(e) and not g:IsContains(rc) and bit.band(rc:GetOriginalType(),TYPE_MONSTER)==TYPE_MONSTER 
end
function c10173007.actcon2(e)
	return Duel.IsExistingMatchingCard(c10173007.acfilter,e:GetHandlerPlayer(),0,LOCATION_MZONE,1,nil)
end
function c10173007.aclimit2(e,re,tp)
	local rc=re:GetHandler()
	local g=Duel.GetMatchingGroup(c10173007.acfilter,tp,0,LOCATION_MZONE,nil)
	return not rc:IsImmuneToEffect(e) and not g:IsContains(rc) and bit.band(rc:GetOriginalType(),TYPE_MONSTER)==TYPE_MONSTER 
end