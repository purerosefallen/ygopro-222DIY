--神与人之间 鹿目圆香
function c60151613.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,c60151613.mfilter,6,2)
	c:EnableReviveLimit()
	--pendulum summon
	aux.EnablePendulumAttribute(c,false)
	--
	local e11=Effect.CreateEffect(c)
	e11:SetCategory(CATEGORY_RECOVER+CATEGORY_ATKCHANGE)
	e11:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e11:SetRange(LOCATION_MZONE)
	e11:SetCode(EVENT_CHAIN_ACTIVATING)
	e11:SetOperation(c60151613.disop)
	c:RegisterEffect(e11)
	--adup
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(60151613,0))
	e1:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,60151613)
	e1:SetCost(c60151613.adcost)
	e1:SetTarget(c60151613.adtg)
	e1:SetOperation(c60151613.adop)
	c:RegisterEffect(e1)
	--pendulum
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_EXTRA)
	e4:SetCountLimit(1,6011611)
	e4:SetCost(c60151613.cost)
	e4:SetCondition(c60151613.spcon)
	e4:SetTarget(c60151613.pentg)
	e4:SetOperation(c60151613.penop)
	c:RegisterEffect(e4)
end
c60151613.pendulum_level=6
function c60151613.mfilter(c)
	return c:IsRace(RACE_SPELLCASTER) and c:IsAttribute(ATTRIBUTE_LIGHT)
end
function c60151613.filter(c)
	return c:IsFaceup() and c:IsSetCard(0xcb25) and c:IsType(TYPE_MONSTER)
end
function c60151613.disop(e,tp,eg,ep,ev,re,r,rp)
	if not (re:IsActiveType(TYPE_MONSTER) and re:IsActivated()) then return end
	Duel.Hint(HINT_CARD,0,60151613)
	Duel.Recover(tp,600,REASON_EFFECT)
	local g=Duel.GetMatchingGroup(c60151613.filter,tp,LOCATION_MZONE,0,nil)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(200)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
		tc=g:GetNext()
	end
end
function c60151613.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsFaceup() and (Duel.CheckLocation(tp,LOCATION_SZONE,6) or Duel.CheckLocation(tp,LOCATION_SZONE,7))
end
function c60151613.cfilter(c,tp)
	return c:IsFaceup() and c:IsType(TYPE_PENDULUM) and c:IsAbleToGraveAsCost()
end
function c60151613.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c60151613.cfilter,tp,LOCATION_EXTRA,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c60151613.cfilter,tp,LOCATION_EXTRA,0,1,1,e:GetHandler())
	Duel.SendtoGrave(g,REASON_COST)
end
function c60151613.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
	local lsc=Duel.CheckLocation(tp,LOCATION_SZONE,6)
	local rsc=Duel.CheckLocation(tp,LOCATION_SZONE,7)
	if chk==0 then return lsc or rsc end
end
function c60151613.penop(e,tp,eg,ep,ev,re,r,rp)
	Duel.MoveToField(e:GetHandler(),tp,tp,LOCATION_SZONE,POS_FACEUP,true)
end
function c60151613.adcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
	Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
end
function c60151613.adtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function c60151613.adop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(math.abs(Duel.GetLP(0)-Duel.GetLP(1)))
	e1:SetReset(RESET_EVENT+0x1fe0000)
	e:GetHandler():RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	e:GetHandler():RegisterEffect(e2)
	if Duel.GetLP(tp)<Duel.GetLP(1-tp) then
		--disable effect
		local e3=Effect.CreateEffect(e:GetHandler())
		e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e3:SetCode(EVENT_CHAIN_SOLVING)
		e3:SetOperation(c60151613.disoperation)
		e3:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e3,tp)
	end
end
function c60151613.disoperation(e,tp,eg,ep,ev,re,r,rp)
	if ep~=tp and re:IsActiveType(TYPE_TRAP) then
		Duel.NegateEffect(ev)
	end
end