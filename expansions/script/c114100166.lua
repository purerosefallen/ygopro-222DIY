--★黄昏の守護者 天魔･夜刀
function c114100166.initial_effect(c)
	c:EnableReviveLimit()
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c114100166.splimit)
	c:RegisterEffect(e1)
	--limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_ACTIVATE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,1)
	e2:SetCondition(c114100166.tgcon)
	e2:SetValue(c114100166.aclimit)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_ATTACK_ANNOUNCE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(0,LOCATION_MZONE)
	e3:SetCondition(c114100166.tgcon)
	e3:SetTarget(c114100166.target)
	c:RegisterEffect(e3)
end
function c114100166.splimit(e,se,sp,st)
	return se:GetHandler():IsSetCard(0x228)
end
--cannot activate
function c114100166.tgcon(e)
	local st=e:GetHandler():GetSummonType()
	return st==SUMMON_TYPE_SPECIAL+88
end
function c114100166.aclimit(e,re,tp)
	return not ( re:GetHandler():IsImmuneToEffect(e) or re:GetHandler():IsLevelAbove(10) or re:GetHandler():IsRankAbove(10) )
end
--cannot attack
function c114100166.target(e,c)
	return ( c:IsLevelBelow(9) or c:IsRankBelow(9) ) and c:IsFaceup() and not c:IsImmuneToEffect(e)
end