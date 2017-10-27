--七曜-『贤者之石』
function c2170709.initial_effect(c)
	c:EnableReviveLimit()
	--pendulum summon
	aux.EnablePendulumAttribute(c,false)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(Card.IsSetCard,0x211),1)
	c:EnableReviveLimit()
	--spsommon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(2170709,0))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_PZONE)
	e3:SetCountLimit(1,21707091)
	e3:SetCost(c2170709.cost)
	e3:SetTarget(c2170709.target)
	e3:SetOperation(c2170709.operation)
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
	e2:SetDescription(aux.Stringid(2170709,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCountLimit(1,21707092)
	e2:SetCondition(c2170709.condition)
	e2:SetTarget(c2170709.pentg)
	e2:SetOperation(c2170709.penop)
	c:RegisterEffect(e2)
	if not c2170709.global_check then
		c2170709.global_check=true
		c2170709[0]=0
		c2170709[1]=0
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAINING)
		ge1:SetOperation(c2170709.checkop)
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		ge2:SetOperation(c2170709.clear)
		Duel.RegisterEffect(ge2,0)
	end

end
function c2170709.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	if tc:IsCode(2170702) and re:IsHasType(EFFECT_TYPE_ACTIVATE) then
		c2170709[tc:GetControler()]=c2170709[tc:GetControler()]+1
	end
	if tc:IsCode(2170703) and re:IsHasType(EFFECT_TYPE_ACTIVATE) then
		c2170709[tc:GetControler()]=c2170709[tc:GetControler()]+1
	end
	if tc:IsCode(2170704) and re:IsHasType(EFFECT_TYPE_ACTIVATE) then
		c2170709[tc:GetControler()]=c2170709[tc:GetControler()]+1
	end
	if tc:IsCode(2170705) and re:IsHasType(EFFECT_TYPE_ACTIVATE) then
		c2170709[tc:GetControler()]=c2170709[tc:GetControler()]+1
	end
	if tc:IsCode(2170706) and re:IsHasType(EFFECT_TYPE_ACTIVATE) then
		c2170709[tc:GetControler()]=c2170709[tc:GetControler()]+1
	end
end
function c2170709.clear(e,tp,eg,ep,ev,re,r,rp)
	c2170709[0]=0
	c2170709[1]=0
end
function c2170709.condition(e,tp,eg,ep,ev,re,r,rp)
	return c2170709[e:GetHandler():GetControler()]>=5
end
function c2170709.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1) end
end
function c2170709.penop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.CheckLocation(tp,LOCATION_PZONE,0) and not Duel.CheckLocation(tp,LOCATION_PZONE,1) then return false end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
end
function c2170709.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c2170709.filter(c,e,tp)
	return c:IsType(TYPE_SYNCHRO) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function c2170709.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMZoneCount(tp)>0
		and Duel.IsExistingMatchingCard(c2170709.filter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c2170709.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetMZoneCount(tp)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c2170709.filter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,true,false,POS_FACEUP)
	end
end