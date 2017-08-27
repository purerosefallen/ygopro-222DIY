--口袋妖怪 金鱼王
function c80000273.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--extra summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_EXTRA_SUMMON_COUNT)
	e1:SetRange(LOCATION_PZONE)
	e1:SetTargetRange(LOCATION_HAND,0)
	e1:SetValue(0x1)
	c:RegisterEffect(e1)
	--splimit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_PZONE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetTargetRange(1,0)
	e2:SetCondition(aux.nfbdncon)
	e2:SetTarget(c80000273.splimit)
	c:RegisterEffect(e2) 
	--special summon
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_SPSUMMON_PROC)
	e3:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e3:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e3:SetCountLimit(1,80000273)
	e3:SetCondition(c80000273.spcon)
	e3:SetOperation(c80000273.spop)
	c:RegisterEffect(e3)   
end
function c80000273.splimit(e,c,tp,sumtp,sumpos)
	return not c:IsSetCard(0x2d0) and bit.band(sumtp,SUMMON_TYPE_ADVANCE)==SUMMON_TYPE_ADVANCE 
end
function c80000273.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>-1
		and Duel.CheckReleaseGroup(c:GetControler(),Card.IsAttribute,1,nil,ATTRIBUTE_WATER)
end
function c80000273.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.SelectReleaseGroup(c:GetControler(),Card.IsAttribute,1,1,nil,ATTRIBUTE_WATER)
	Duel.Release(g,REASON_COST)
end