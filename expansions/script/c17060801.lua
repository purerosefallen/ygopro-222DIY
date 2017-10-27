--私装丘
function c17060801.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--atk
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(17060801,0))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c17060801.atkcon)
	e2:SetOperation(c17060801.atkop)
	c:RegisterEffect(e2)
	--special summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(17060801,1))
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_SPSUMMON_PROC)
	e3:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e3:SetRange(LOCATION_HAND)
	e3:SetCountLimit(1,17060801)
	e3:SetCondition(c17060801.spcon)
	c:RegisterEffect(e3)
	--pendulum set
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(17060801,2))
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCost(c17060801.cost)
	e4:SetCondition(c17060801.condition)
	e4:SetTarget(c17060801.pctg)
	e4:SetOperation(c17060801.pcop)
	c:RegisterEffect(e4)
end
c17060801.is_named_with_Mercenary_Arthur=1
c17060801.is_named_with_Million_Arthur=1
function c17060801.Mercenary_Arthur(c)
	local m=_G["c"..c:GetCode()]
	return m and m.is_named_with_Mercenary_Arthur
end
function c17060801.IsMillion_Arthur(c)
	local m=_G["c"..c:GetCode()]
	return m and m.is_named_with_Million_Arthur
end
function c17060801.cfilter(c,tp)
	return c:IsFaceup() and c17060801.IsMillion_Arthur(c) and c:IsControler(tp) and c:IsSummonType(SUMMON_TYPE_PENDULUM)
end
function c17060801.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c17060801.cfilter,1,nil,tp)
end
function c17060801.filter(c)
	return c:IsFaceup() and c17060801.IsMillion_Arthur(c) and c:IsType(TYPE_MONSTER)
end
function c17060801.atkop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(c17060801.filter,tp,LOCATION_MZONE,0,nil)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(1000)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		tc=g:GetNext()
	end
end
function c17060801.spcon(e,c)
	if c==nil then return true end
	return Duel.GetMZoneCount(c:GetControler())>0 and
		Duel.IsExistingMatchingCard(c17060801.filter,c:GetControler(),LOCATION_MZONE,0,1,nil)
end
function c17060801.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c17060801.condition(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.GetFieldCard(tp,LOCATION_PZONE,0) and not Duel.GetFieldCard(tp,LOCATION_PZONE,1)
end
function c17060801.psfilter(c)
	return c:IsType(TYPE_PENDULUM) and c17060801.IsMillion_Arthur(c) and not c:IsCode(17060801) and not c:IsForbidden()
end
function c17060801.pctg(e,tp,eg,ep,ev,re,r,rp,chk)
	local seq=e:GetHandler():GetSequence()
	if chk==0 then return Duel.IsExistingMatchingCard(c17060801.psfilter,tp,LOCATION_DECK,0,1,nil) end
end
function c17060801.pcop(e,tp,eg,ep,ev,re,r,rp)
	if chkc then return chkc:IsLocation(LOCATION_DECK) and chkc:IsControler(tp) and c17060801.psfilter(chkc) end
		if not Duel.CheckLocation(tp,LOCATION_PZONE,0) and not Duel.CheckLocation(tp,LOCATION_PZONE,1) then return false end
	local seq=e:GetHandler():GetSequence()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectMatchingCard(tp,c17060801.psfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.MoveToField(g:GetFirst(),tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
end