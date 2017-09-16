--七曜-土水符『诺亚的大洪水』
function c2170710.initial_effect(c)
	c:EnableReviveLimit()
	--pendulum summon
	aux.EnablePendulumAttribute(c,false)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(Card.IsSetCard,0x211),1)
	c:EnableReviveLimit()
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(2170710,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,21707101)
	e1:SetTarget(c2170710.thtg)
	e1:SetOperation(c2170710.thop)
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
	e2:SetDescription(aux.Stringid(2170710,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCountLimit(1,2170710)
	e2:SetCondition(c2170710.condition)
	e2:SetTarget(c2170710.pentg)
	e2:SetOperation(c2170710.penop)
	c:RegisterEffect(e2)
	if not c2170710.global_check then
		c2170710.global_check=true
		c2170710[0]=0
		c2170710[1]=0
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAINING)
		ge1:SetOperation(c2170710.checkop)
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		ge2:SetOperation(c2170710.clear)
		Duel.RegisterEffect(ge2,0)
	end
end
function c2170710.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	if tc:IsCode(2170703) and re:IsHasType(EFFECT_TYPE_ACTIVATE) then
		c2170710[tc:GetControler()]=c2170710[tc:GetControler()]+1
	end
	if tc:IsCode(2170706) and re:IsHasType(EFFECT_TYPE_ACTIVATE) then
		c2170710[tc:GetControler()]=c2170710[tc:GetControler()]+1
	end
end
function c2170710.clear(e,tp,eg,ep,ev,re,r,rp)
	c2170710[0]=0
	c2170710[1]=0
end
function c2170710.condition(e,tp,eg,ep,ev,re,r,rp)
	return c2170710[e:GetHandler():GetControler()]>=2
end
function c2170710.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1) end
end
function c2170710.penop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.CheckLocation(tp,LOCATION_PZONE,0) and not Duel.CheckLocation(tp,LOCATION_PZONE,1) then return false end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
end
function c2170710.filter(c)
	return c:IsSetCard(0x211) and c:IsAbleToHand()
end
function c2170710.thfilter(c)
	return c:IsAbleToHand()
end
function c2170710.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return (chkc:IsLocation(LOCATION_ONFIELD) and c2170710.thfilter(chkc)) or (chkc:IsLocation(LOCATION_GRAVE) and c2170710.filter(chkc)) end
	if chk==0 then return Duel.IsExistingTarget(c2170710.thfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) or Duel.IsExistingTarget(c2170710.filter,tp,LOCATION_GRAVE,0,1,nil) end
	local b1=Duel.IsExistingTarget(c2170710.thfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
	local b2=Duel.IsExistingTarget(c2170710.thfilter,tp,LOCATION_GRAVE,0,1,nil)
	local op=0
	if b1 and b2 then
		op=Duel.SelectOption(tp,aux.Stringid(2170710,2),aux.Stringid(2170710,1))
	elseif b1 and not b2 then
		op=0
	elseif b2 and not b1 then
		op=1
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=nil
	if op==0 then
		g=Duel.SelectTarget(tp,c2170710.thfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	elseif op==1 then
		g=Duel.SelectTarget(tp,c2170710.filter,tp,LOCATION_GRAVE,0,1,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c2170710.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.BreakEffect()
		Duel.Destroy(e:GetHandler(),REASON_EFFECT)
	end
end
