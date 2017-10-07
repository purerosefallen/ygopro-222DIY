--逆行贝琳
function c17060907.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,c17060907.matfilter,1)
	--extra summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_EXTRA_SUMMON_COUNT)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_HAND+LOCATION_MZONE,0)
	e1:SetTarget(c17060907.sumtg)
	c:RegisterEffect(e1)
	--atk
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(c17060907.atkval)
	c:RegisterEffect(e2)
end
function c17060907.matfilter(c)
	return c:GetLevel()==1 and c:IsType(TYPE_PENDULUM)
end
function c17060907.sumtg(e,c)
	return c:IsType(TYPE_PENDULUM)
end
function c17060907.atkval(e,c)
	local g=e:GetHandler():GetLinkedGroup()
	if g:GetCount()==0 then 
		return 0
	else
		local tg,val=g:GetMaxGroup(Card.GetBaseAttack)
		return val/2
	end
end