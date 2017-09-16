--七曜-日水符『氢化日珥』
function c2170714.initial_effect(c)
	c:EnableReviveLimit()
	--pendulum summon
	aux.EnablePendulumAttribute(c,false)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(Card.IsSetCard,0x211),1)
	c:EnableReviveLimit()
	--tohand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(2170714,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,21707141)
	e1:SetTarget(c2170714.target)
	e1:SetOperation(c2170714.operation)
	c:RegisterEffect(e1)
	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.FALSE)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(2170714,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCountLimit(1,2170714)
	e2:SetCondition(c2170714.condition)
	e2:SetTarget(c2170714.pentg)
	e2:SetOperation(c2170714.penop)
	c:RegisterEffect(e2)
	if not c2170714.global_check then
		c2170714.global_check=true
		c2170714[0]=0
		c2170714[1]=0
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAINING)
		ge1:SetOperation(c2170714.checkop)
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		ge2:SetOperation(c2170714.clear)
		Duel.RegisterEffect(ge2,0)
	end
end
function c2170714.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	if tc:IsCode(2170703) and re:IsHasType(EFFECT_TYPE_ACTIVATE) then
		c2170714[tc:GetControler()]=c2170714[tc:GetControler()]+1
	end
	if tc:IsCode(2170704) and re:IsHasType(EFFECT_TYPE_ACTIVATE) then
		c2170714[tc:GetControler()]=c2170714[tc:GetControler()]+1
	end
end
function c2170714.clear(e,tp,eg,ep,ev,re,r,rp)
	c2170714[0]=0
	c2170714[1]=0
end
function c2170714.condition(e,tp,eg,ep,ev,re,r,rp)
	return c2170714[e:GetHandler():GetControler()]>=2
end
function c2170714.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1) end
end
function c2170714.penop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.CheckLocation(tp,LOCATION_PZONE,0) and not Duel.CheckLocation(tp,LOCATION_PZONE,1) then return false end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
end
function c2170714.filter(c)
	return c:IsFaceup()
end
function c2170714.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,2170798,0,0x4011,1600,1000,4,RACE_SPELLCASTER,ATTRIBUTE_WATER) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c2170714.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.IsPlayerCanSpecialSummonMonster(tp,2170798,0,0x4011,1600,1000,4,RACE_SPELLCASTER,ATTRIBUTE_WATER)
	end
	local token=Duel.CreateToken(tp,2170798)
	Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
	Duel.BreakEffect()
	Duel.Destroy(e:GetHandler(),REASON_EFFECT)
end