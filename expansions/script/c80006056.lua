--十六夜之夜
function c80006056.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,80006056+EFFECT_COUNT_CODE_DUEL)
	e1:SetTarget(c80006056.target)
	e1:SetOperation(c80006056.activate)
	c:RegisterEffect(e1)
	--Activate
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DAMAGE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,80006057+EFFECT_COUNT_CODE_DUEL)
	e2:SetCost(c80006056.cost)
	e2:SetTarget(c80006056.target1)
	e2:SetOperation(c80006056.activate1)
	c:RegisterEffect(e2)
end
function c80006056.filter(c)
	return c:IsCode(80006054) or c:IsCode(80006052) and c:IsAbleToHand()
end
function c80006056.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c80006056.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
	Duel.SetChainLimit(aux.FALSE)
end
function c80006056.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c80006056.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c80006056.rfilter(c)
	return c:IsAbleToRemoveAsCost()
end
function c80006056.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	if chk==0 then return Duel.IsExistingMatchingCard(c80006056.rfilter,tp,LOCATION_MZONE,0,1,nil) and e:GetHandler():IsAbleToRemoveAsCost() end
	local g=Duel.SelectMatchingCard(tp,c80006056.rfilter,tp,LOCATION_MZONE,0,1,1,nil)
	local atk=g:GetFirst():GetTextAttack()
	if atk<0 then atk=0 end
	e:SetLabel(atk)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c80006056.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local res=e:GetLabel()~=0
		e:SetLabel(0)
		return res
	end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(e:GetLabel())
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,e:GetLabel())
	e:SetLabel(0)
	Duel.SetChainLimit(aux.FALSE)
end
function c80006056.activate1(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d/2,REASON_EFFECT)
end