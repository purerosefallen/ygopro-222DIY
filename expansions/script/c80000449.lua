--破格的世界 
function c80000449.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--Atk/def
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTarget(c80000449.adtg)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetValue(400)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e3) 
	--cannot attack
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_CANNOT_ATTACK)
	e4:SetRange(LOCATION_FZONE)
	e4:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e4:SetTarget(c80000449.adtg1)
	c:RegisterEffect(e4) 
	--handes
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(80000449,0))
	e5:SetCategory(CATEGORY_REMOVE)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e5:SetRange(LOCATION_FZONE)
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	e5:SetCondition(c80000449.condition)
	e5:SetTarget(c80000449.target)
	e5:SetOperation(c80000449.operation)
	c:RegisterEffect(e5)
	--Atk/def
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_FIELD)
	e7:SetCode(EFFECT_UPDATE_ATTACK)
	e7:SetRange(LOCATION_FZONE)
	e7:SetTarget(c80000449.adtg1)
	e7:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e7:SetValue(-400)
	c:RegisterEffect(e7)
	local e8=e7:Clone()
	e8:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e8)	  
end
function c80000449.adtg(e,c)
	return c:IsType(TYPE_XYZ)
end
function c80000449.adtg1(e,c)
	return not c:IsType(TYPE_XYZ)
end

function c80000449.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:GetFirst():GetSummonType()==SUMMON_TYPE_XYZ
end
function c80000449.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,1-tp,LOCATION_DECK)
end
function c80000449.operation(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetDecktopGroup(1-tp,1)
	Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT)
end



