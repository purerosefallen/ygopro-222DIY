--逆行贝琳
local m=17060907
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,cm.matfilter,1)
	--extra summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_EXTRA_SUMMON_COUNT)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_HAND+LOCATION_MZONE,0)
	e1:SetTarget(cm.sumtg)
	c:RegisterEffect(e1)
	--atk
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(cm.atkval)
	c:RegisterEffect(e2)
end
function cm.matfilter(c)
	return c:GetLevel()==1 and c:IsType(TYPE_PENDULUM)
end
function cm.sumtg(e,c)
	return c:IsType(TYPE_PENDULUM)
end
function cm.atkval(e,c)
	local g=e:GetHandler():GetLinkedGroup()
	local tc=g:GetFirst()
	local val=0
	while tc do
		local atk=tc:GetTextAttack()
		if atk<0 then atk=0 end
		val=val+atk
		tc=g:GetNext()
	end
	return val/2
end