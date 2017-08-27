--ＰＭ 玛沙那
function c80000397.initial_effect(c)
	--nontuner
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e0:SetRange(LOCATION_MZONE)
	e0:SetCode(EFFECT_NONTUNER)
	c:RegisterEffect(e0)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c80000397.spcon)
	c:RegisterEffect(e1)
	--synchro level
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_SYNCHRO_LEVEL)
	e2:SetValue(c80000397.slevel)
	c:RegisterEffect(e2)
	--cannot be material
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	e3:SetValue(c80000397.splimit)
	c:RegisterEffect(e3)
	Duel.AddCustomActivityCounter(80000397,ACTIVITY_CHAIN,c80000397.chainfilter)
end
function c80000397.splimit(e,c)
	if not c then return false end
	return not c:IsRace(RACE_WARRIOR)
end

function c80000397.slevel(e,c)
	local lv=e:GetHandler():GetLevel()
	return 4*65536+lv
end
function c80000397.chainfilter(re,tp,cid)
	return not re:IsActiveType(TYPE_SPELL) 
end
function c80000397.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetCustomActivityCount(80000397,tp,ACTIVITY_CHAIN)~=0
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
end
