--智爷的皮神
function c80000022.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c,false)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--replace
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(c80000022.indtg)
	e2:SetValue(c80000022.indval)
	c:RegisterEffect(e2)
end
c80000022.lvupcount=1
c80000022.lvup={80000054}
function c80000022.indfilter(c,tp)
	return c:IsFaceup() and c:IsControler(tp) and c:IsOnField() and c:IsReason(REASON_EFFECT)
		and (c:IsSetCard(0x2d0) and c:IsType(TYPE_MONSTER))
end
function c80000022.indtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c80000022.indfilter,1,nil,tp) end
	return true
end
function c80000022.indval(e,c)
	return c80000022.indfilter(c,e:GetHandlerPlayer())
end