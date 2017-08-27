--ＬＰＭ 代欧奇希斯·防御型态
function c80000494.initial_effect(c)
	c:SetSPSummonOnce(80000494)
	c:EnableReviveLimit()
	--pendulum summon
	aux.EnablePendulumAttribute(c,false) 
	--splimit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetRange(LOCATION_PZONE)
	e1:SetTargetRange(1,0)
	e1:SetCondition(c80000494.splimcon)
	e1:SetTarget(c80000494.splimit)
	c:RegisterEffect(e1) 
	--cannot be targeted
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(aux.tgoval)
	c:RegisterEffect(e2)
	--battle indes
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
	e3:SetCountLimit(1)
	e3:SetValue(c80000494.valcon)
	c:RegisterEffect(e3)
	--atk limit
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
	e5:SetRange(LOCATION_PZONE)
	e5:SetTargetRange(0,LOCATION_MZONE)
	e5:SetCondition(c80000494.atkcon)
	e5:SetValue(c80000494.atlimit)
	c:RegisterEffect(e5) 
	--pendulum
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(80000494,5))
	e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e7:SetCode(EVENT_DESTROYED)
	e7:SetProperty(EFFECT_FLAG_DELAY)
	e7:SetCondition(c80000494.pencon)
	e7:SetTarget(c80000494.pentg)
	e7:SetOperation(c80000494.penop)
	c:RegisterEffect(e7) 
	--wudi 
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_SINGLE)
	e9:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e9:SetRange(LOCATION_ONFIELD)
	e9:SetCode(EFFECT_IMMUNE_EFFECT)
	e9:SetValue(c80000494.efilter)
	c:RegisterEffect(e9) 
	--spsummon
	local e10=Effect.CreateEffect(c)
	e10:SetDescription(aux.Stringid(80000494,2))
	e10:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e10:SetType(EFFECT_TYPE_QUICK_O)
	e10:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
	e10:SetRange(LOCATION_MZONE)
	e10:SetCode(EVENT_FREE_CHAIN)
	e10:SetTarget(c80000494.sptg)
	e10:SetOperation(c80000494.spop)
	c:RegisterEffect(e10)  
end
function c80000494.pencon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return bit.band(r,REASON_EFFECT+REASON_BATTLE)~=0 and c:IsPreviousLocation(LOCATION_MZONE) and c:IsFaceup()
end
function c80000494.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLocation(tp,LOCATION_SZONE,6) or Duel.CheckLocation(tp,LOCATION_SZONE,7) end
end
function c80000494.penop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.CheckLocation(tp,LOCATION_SZONE,6) and not Duel.CheckLocation(tp,LOCATION_SZONE,7) then return false end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
end
function c80000494.valcon(e,re,r,rp)
	return bit.band(r,REASON_BATTLE)~=0
end
function c80000494.spfilter(c,e,tp)
	return (c:IsCode(80000492) or c:IsCode(80000493) or c:IsCode(80000495)) and c:IsCanBeSpecialSummoned(e,0,tp,true,true)
end
function c80000494.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and e:GetHandler():IsAbleToExtra()
		and Duel.IsExistingMatchingCard(c80000494.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c80000494.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<0 then return end
	if c:IsRelateToEffect(e) and c:IsFaceup() and Duel.SendtoDeck(c,nil,2,REASON_EFFECT)~=0 then
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tc=Duel.SelectMatchingCard(tp,c80000494.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
		if tc then
			Duel.SpecialSummon(tc,0,tp,tp,true,true,POS_FACEUP)
		end
	end
end
function c80000494.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end
function c80000494.splimcon(e)
	return not e:GetHandler():IsForbidden()
end
function c80000494.splimit(e,c)
	return not c:IsSetCard(0x2d0)
end
function c80000494.atkcon(e)
	return Duel.IsExistingMatchingCard(Card.IsPosition,e:GetHandlerPlayer(),LOCATION_MZONE,0,2,nil,POS_FACEUP_DEFENSE)
end
function c80000494.atkfilter(c,atk)
	return c:IsFaceup() and c:GetDefense()<def
end
function c80000494.atlimit(e,c)
	return c:IsFaceup() and not Duel.IsExistingMatchingCard(c80000494.atkfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,c,c:GetDefense())
end