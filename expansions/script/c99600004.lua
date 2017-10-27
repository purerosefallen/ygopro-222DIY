--
function c99600004.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(99600004,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,99600054)
	e1:SetCondition(c99600004.descon)
	e1:SetTarget(c99600004.destg)
	e1:SetOperation(c99600004.desop)
	c:RegisterEffect(e1)
	--to extra
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(99600004,0))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,99600004)
	e2:SetTarget(c99600004.target)
	e2:SetOperation(c99600004.operation)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	--special summon
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_SPSUMMON_PROC)
	e5:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e5:SetRange(LOCATION_HAND)
	e5:SetCondition(c99600004.spcon)
	c:RegisterEffect(e5)	
end
function c99600004.descon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(Card.IsSetCard,tp,LOCATION_PZONE,0,1,e:GetHandler(),0x1702)
end
function c99600004.desfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c99600004.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and c99600004.desfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c99600004.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c99600004.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c99600004.desop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
function c99600004.filter(c)
	return c:IsType(TYPE_PENDULUM) and c:IsSetCard(0x1702)
end
function c99600004.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c99600004.filter,tp,LOCATION_DECK,1,1,nil) end
end
function c99600004.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(99600004,2))
	local g=Duel.SelectMatchingCard(tp,c99600004.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoExtraP(g,nil,REASON_EFFECT)
	end
end
function c99600004.spcon(e,c)
	if c==nil then return true end
	return Duel.GetFieldGroupCount(c:GetControler(),LOCATION_MZONE,0,nil)==0
		and Duel.GetMZoneCount(c:GetControler())>0
end