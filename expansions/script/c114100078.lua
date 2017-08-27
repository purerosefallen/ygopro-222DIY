--★ブラック★ゴールドソー
function c114100078.initial_effect(c)
	--negate attack
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,114100078)
	e1:SetCost(c114100078.cost)
	e1:SetCondition(c114100078.negcon)
	e1:SetOperation(c114100078.negop)
	c:RegisterEffect(e1)
	--remove
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1,114100079)
	e2:SetCost(c114100078.cost)
	e2:SetTarget(c114100078.rmtg)
	e2:SetOperation(c114100078.rmop)
	c:RegisterEffect(e2)
end
function c114100078.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsPublic() end
end
function c114100078.negcon(e,tp,eg,ep,ev,re,r,rp)
	local at=Duel.GetAttackTarget()
	if at==nil then return false end
	return at:IsControler(tp) and at:IsFaceup() and at:IsRace(RACE_WARRIOR) and at:IsAttribute(ATTRIBUTE_DARK)
end
function c114100078.negop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateAttack()
end

function c114100078.filter(c)
	return c:IsRace(RACE_WARRIOR) and c:IsAttribute(ATTRIBUTE_DARK) and c:IsAbleToRemove()
end
function c114100078.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c114100078.filter,tp,LOCATION_DECK,0,1,nil) and e:GetHandler():IsAbleToDeck() end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_DECK)
end
function c114100078.rmop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c114100078.filter,tp,LOCATION_DECK,0,1,1,nil)
	if Duel.Remove(g,POS_FACEUP,REASON_EFFECT)~=0 then
		if e:GetHandler():IsRelateToEffect(e) then
			Duel.BreakEffect()
			Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_EFFECT) 
		end
	end
end