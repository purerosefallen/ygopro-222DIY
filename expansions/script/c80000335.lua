--口袋妖怪 狩猎凤蝶
function c80000335.initial_effect(c)
	c:EnableReviveLimit()
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1)	
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(80000335,0))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCountLimit(1,80000335)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCost(c80000335.cost)
	e2:SetTarget(c80000335.target)
	e2:SetOperation(c80000335.operation)
	c:RegisterEffect(e2)
	--immune spell
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c80000335.econ)
	e3:SetValue(c80000335.efilter)
	c:RegisterEffect(e3)
	--damage
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(80000335,1))
	e4:SetCategory(CATEGORY_DAMAGE)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetCondition(c80000335.econ)
	e4:SetTarget(c80000335.target1)
	e4:SetOperation(c80000335.operation1)
	c:RegisterEffect(e4)
end
function c80000335.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c80000335.filter(c)
	return c:IsRace(RACE_INSECT) and c:IsAbleToHand() and c:IsLevelBelow(4) and c:IsSetCard(0x2d0)
end
function c80000335.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c80000335.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c80000335.filter1(c)
	return c:IsDestructable()
end
function c80000335.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c80000335.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
		local g=Duel.GetMatchingGroup(c80000335.filter1,tp,0,LOCATION_MZONE,nil)
		if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(80000335,2)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
			local dg=g:Select(tp,1,1,nil)
			Duel.HintSelection(dg)
			Duel.Destroy(dg,REASON_EFFECT)
		end
end
function c80000335.filter2(c)
	return c:IsFaceup() and c:IsCode(80000147)
end
function c80000335.econ(e)
	return Duel.IsExistingMatchingCard(c80000335.filter2,0,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
		or Duel.IsEnvironment(80000147)
end
function c80000335.efilter(e,te)
	return te:IsActiveType(TYPE_SPELL)
end
function c80000335.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(1000)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,1000)
end
function c80000335.operation1(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end