--七曜-金木符『元素收获者』
function c2170711.initial_effect(c)
	c:EnableReviveLimit()
	--pendulum summon
	aux.EnablePendulumAttribute(c,false)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(Card.IsSetCard,0x211),1)
	c:EnableReviveLimit()
	--tohand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(2170711,0))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_PZONE)
	e3:SetCountLimit(1,21707111)
	e3:SetTarget(c2170711.target)
	e3:SetOperation(c2170711.operation)
	c:RegisterEffect(e3)
	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.FALSE)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(2170711,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCountLimit(1,2170711)
	e2:SetCondition(c2170711.condition)
	e2:SetTarget(c2170711.pentg)
	e2:SetOperation(c2170711.penop)
	c:RegisterEffect(e2)
	if not c2170711.global_check then
		c2170711.global_check=true
		c2170711[0]=0
		c2170711[1]=0
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAINING)
		ge1:SetOperation(c2170711.checkop)
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		ge2:SetOperation(c2170711.clear)
		Duel.RegisterEffect(ge2,0)
	end

end
function c2170711.efilter1(e,te)
	return te:IsCode(2170704)
end
function c2170711.efilter2(e,te)
	return te:IsCode(2170705)
end
function c2170711.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	if tc:IsCode(2170705) and re:IsHasType(EFFECT_TYPE_ACTIVATE) then
		c2170711[tc:GetControler()]=c2170711[tc:GetControler()]+1
	end
	if tc:IsCode(2170704) and re:IsHasType(EFFECT_TYPE_ACTIVATE) then
		c2170711[tc:GetControler()]=c2170711[tc:GetControler()]+1
	end
end
function c2170711.clear(e,tp,eg,ep,ev,re,r,rp)
	c2170711[0]=0
	c2170711[1]=0
end
function c2170711.condition(e,tp,eg,ep,ev,re,r,rp)
	return c2170711[e:GetHandler():GetControler()]>=2
end
function c2170711.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1) end
end
function c2170711.penop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.CheckLocation(tp,LOCATION_PZONE,0) and not Duel.CheckLocation(tp,LOCATION_PZONE,1) then return false end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
end
function c2170711.filter(c)
	return c:IsSetCard(0x211) and c:IsType(TYPE_SPELL) and c:IsAbleToHand()
end
function c2170711.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c2170711.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c2170711.operation(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c2170711.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		Duel.BreakEffect()
		Duel.Destroy(e:GetHandler(),REASON_EFFECT)
	end
end