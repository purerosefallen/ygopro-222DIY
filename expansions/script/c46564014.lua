--开 运 的 奇 迹 石
function c46564014.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1) 
	--atk up
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetTarget(c46564014.tg)
	e2:SetValue(c46564014.val)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e3:SetTarget(c46564014.tg)
	e3:SetValue(c46564014.val)
	c:RegisterEffect(e3)
	--atk limit
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCode(EFFECT_CANNOT_ATTACK_ANNOUNCE)
	e4:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e4:SetTarget(c46564014.target)
	c:RegisterEffect(e4)
end
function c46564014.tg(e,c)
	return c:IsSetCard(0x650)
end
function c46564014.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x650)
end
function c46564014.val(e,c)
	return Duel.GetMatchingGroupCount(c46564014.filter,c:GetControler(),LOCATION_MZONE,LOCATION_MZONE,nil)*1000
end
function c46564014.target(e,c)
	return c:IsSetCard(0x650) and c:IsFaceup() and bit.band(c:GetSummonType(),SUMMON_TYPE_SPECIAL)~=0 and c:GetTurnID()==Duel.GetTurnCount()
end











