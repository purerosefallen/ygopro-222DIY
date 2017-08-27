--口袋妖怪 负电拍拍
function c80000237.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c,false)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--splimit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetRange(LOCATION_PZONE)
	e2:SetTargetRange(1,0)
	e2:SetCondition(c80000237.splimcon)
	e2:SetTarget(c80000237.splimit)
	c:RegisterEffect(e2)
	--atk down
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_PZONE)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetTargetRange(0,LOCATION_MZONE)
	e3:SetValue(-300)
	c:RegisterEffect(e3)   
	--special summon rule
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_SPSUMMON_PROC)
	e4:SetRange(LOCATION_HAND)
	e4:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e4:SetCondition(c80000237.spcon)
	c:RegisterEffect(e4)  
	--untargetable
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
	e5:SetRange(LOCATION_MZONE)
	e5:SetTargetRange(0,LOCATION_MZONE)
	e5:SetValue(c80000237.atlimit)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetCode(EFFECT_CANNOT_SELECT_EFFECT_TARGET)
	e6:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e6:SetTargetRange(0,0xff)
	e6:SetValue(c80000237.tglimit)
	c:RegisterEffect(e6)
end
function c80000237.splimcon(e)
	return not e:GetHandler():IsForbidden()
end
function c80000237.splimit(e,c)
	return not c:IsSetCard(0x2d0)
end
function c80000237.cfilter(c)
	return c:IsFaceup() and c:IsCode(80000238)
end
function c80000237.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c80000237.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c80000237.atlimit(e,c)
	return c:IsFaceup() and c:IsSetCard(0x2d0) and c~=e:GetHandler()
end
function c80000237.tglimit(e,re,c)
	return c:IsControler(e:GetHandlerPlayer()) and c:IsLocation(LOCATION_MZONE) and c:IsFaceup() and c:IsSetCard(0x2d0) and c~=e:GetHandler()
end