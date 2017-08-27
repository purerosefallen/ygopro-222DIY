--Love Ball
function c80000385.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,80000385+EFFECT_COUNT_CODE_OATH+EFFECT_COUNT_CODE_DUEL)
	e1:SetCost(c80000385.cost)
	e1:SetTarget(c80000385.target)
	e1:SetOperation(c80000385.activate)
	c:RegisterEffect(e1)
	--Activate
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DAMAGE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,80000383+EFFECT_COUNT_CODE_DUEL)
	e2:SetCost(c80000385.cost1)
	e2:SetTarget(c80000385.target1)
	e2:SetOperation(c80000385.activate1)
	c:RegisterEffect(e2)
	if not c80000385.global_check then
		c80000385.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAINING)
		ge1:SetOperation(c80000385.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function c80000385.checkop(e,tp,eg,ep,ev,re,r,rp)
	if re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:IsActiveType(TYPE_SPELL) and not (re:GetHandler():IsSetCard(0x2d0) or re:GetHandler():IsSetCard(0x2d2)) then
		Duel.RegisterFlagEffect(rp,80000378,RESET_PHASE+PHASE_END,0,1)
	end
end
function c80000385.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,80000378)==0 end
	--oath effects
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetTargetRange(1,0)
	e1:SetValue(c80000385.aclimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c80000385.aclimit(e,re,tp)
	return re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:IsActiveType(TYPE_SPELL) and not (re:GetHandler():IsSetCard(0x2d0) or re:GetHandler():IsSetCard(0x2d2))
end
function c80000385.filter(c)
	return c:IsCode(80000222) and c:IsAbleToHand()
end
function c80000385.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c80000385.filter,tp,LOCATION_DECK+LOCATION_REMOVED+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_REMOVED+LOCATION_GRAVE)
end
function c80000385.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c80000385.filter,tp,LOCATION_DECK+LOCATION_REMOVED+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c80000385.eqfilter(c)
	return c:IsCode(80000222) 
end
function c80000385.rfilter(c)
	return c:IsAbleToRemoveAsCost() and c:GetEquipGroup():IsExists(c80000385.eqfilter,1,nil)
end
function c80000385.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	if chk==0 then return Duel.IsExistingMatchingCard(c80000385.rfilter,tp,LOCATION_MZONE,0,1,nil) and e:GetHandler():IsAbleToRemoveAsCost() end
	local g=Duel.SelectMatchingCard(tp,c80000385.rfilter,tp,LOCATION_MZONE,0,1,1,nil)
	local atk=g:GetFirst():GetTextAttack()
	if atk<0 then atk=0 end
	e:SetLabel(atk)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c80000385.target1(e,tp,eg,ep,ev,re,r,rp,chk)
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
function c80000385.activate1(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end