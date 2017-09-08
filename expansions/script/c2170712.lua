--七曜-土金符『翡翠巨城』
function c2170712.initial_effect(c)
	c:EnableReviveLimit()
	--pendulum summon
	aux.EnablePendulumAttribute(c,false)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(Card.IsSetCard,0x211),1)
	c:EnableReviveLimit()
	--tohand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(2170712,0))
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_PZONE)
	e3:SetCountLimit(1,21707121)
	e3:SetCost(c2170712.cost)
	e3:SetTarget(c2170712.target)
	e3:SetOperation(c2170712.operation)
	c:RegisterEffect(e3)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(2170712,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCountLimit(1,2170712)
	e2:SetCondition(c2170712.condition)
	e2:SetTarget(c2170712.pentg)
	e2:SetOperation(c2170712.penop)
	c:RegisterEffect(e2)
	if not c2170712.global_check then
		c2170712.global_check=true
		c2170712[0]=0
		c2170712[1]=0
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAINING)
		ge1:SetOperation(c2170712.checkop)
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		ge2:SetOperation(c2170712.clear)
		Duel.RegisterEffect(ge2,0)
	end

end
function c2170712.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	if tc:IsCode(2170705) and re:IsHasType(EFFECT_TYPE_ACTIVATE) then
		c2170712[tc:GetControler()]=c2170712[tc:GetControler()]+1
	end
	if tc:IsCode(2170706) and re:IsHasType(EFFECT_TYPE_ACTIVATE) then
		c2170712[tc:GetControler()]=c2170712[tc:GetControler()]+1
	end
end
function c2170712.clear(e,tp,eg,ep,ev,re,r,rp)
	c2170712[0]=0
	c2170712[1]=0
end
function c2170712.condition(e,tp,eg,ep,ev,re,r,rp)
	return c2170712[e:GetHandler():GetControler()]>=2
end
function c2170712.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1) end
end
function c2170712.penop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.CheckLocation(tp,LOCATION_PZONE,0) and not Duel.CheckLocation(tp,LOCATION_PZONE,1) then return false end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
end
function c2170712.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c2170712.filter,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,c2170712.filter,1,1,REASON_COST+REASON_DISCARD)
end
function c2170712.filter(c)
	return c:IsSetCard(0x211) and c:IsType(TYPE_SPELL) and c:IsDiscardable()
end
function c2170712.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function c2170712.operation(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
	Duel.BreakEffect()
	Duel.Destroy(e:GetHandler(),REASON_EFFECT)
end
