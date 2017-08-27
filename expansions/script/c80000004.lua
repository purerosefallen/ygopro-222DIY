--口袋妖怪 鲤鱼王
function c80000004.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c,false)
	--Activate
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_ACTIVATE)
	e3:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e3)
	--cannot be target
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetRange(LOCATION_PZONE)
	e2:SetTargetRange(LOCATION_ONFIELD,0)
	e2:SetTarget(c80000004.tgtg)
	e2:SetValue(aux.tgoval)
	c:RegisterEffect(e2) 
	--splimit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetTargetRange(1,0)
	e1:SetCondition(c80000004.splimcon)
	e1:SetTarget(c80000004.splimit)
	c:RegisterEffect(e1)	
end
c80000004.lvupcount=1
c80000004.lvup={80000005}
function c80000004.tgtg(e,c)
	return c:IsSetCard(0x2d0) and c:IsType(TYPE_MONSTER)
end
function c80000004.splimcon(e)
	return not e:GetHandler():IsForbidden()
end
function c80000004.splimit(e,c,sump,sumtype,sumpos,targetp)
	return not c:IsSetCard(0x2d0) and bit.band(sumtype,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
