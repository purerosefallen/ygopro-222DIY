--奇迹糕点魔式厨房
function c12000033.initial_effect(c)
	aux.AddRitualProcGreaterCode(c,12000032)

	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCondition(aux.exccon)
	e1:SetCost(aux.bfgcost)
	e1:SetCountLimit(1,12000033)
	e1:SetTarget(c12000033.thtg)
	e1:SetOperation(c12000033.thop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(12000033,0))
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_RECOVER)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_GRAVE)
	e1:SetCountLimit(1,12000133)
	e2:SetCondition(c12000033.descon)
	e2:SetTarget(c12000033.destg)
	e2:SetOperation(c12000033.desop)
	c:RegisterEffect(e2)
end
function c12000033.thfilter(c)
	return c:IsSetCard(0xfbe) and c:IsAbleToHand()
end
function c12000033.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c12000033.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c12000033.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c12000033.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c12000033.descon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_HAND) or c:IsPreviousLocation(LOCATION_DECK)
end
function c12000033.desfilter(c)
	return c:IsFaceup() and c:IsDestructable()
end
function c12000033.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c12000033.desfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	local g=Duel.GetMatchingGroup(c12000033.desfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	local tg=g:GetMinGroup(Card.GetAttack)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,tg,1,0,0)
end
function c12000033.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c12000033.desfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if g:GetCount()>0 then
		local tg=g:GetMinGroup(Card.GetAttack)
		if tg:GetCount()>1 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
			local sg=tg:Select(tp,1,1,nil)
			Duel.HintSelection(sg)
			local tc=sg:GetFirst()
			local atk=tc:IsFaceup() and tc:GetAttack() or 0
			if Duel.Destroy(sg,REASON_EFFECT)==1 and atk~=0
				then Duel.Recover(tp,atk,REASON_EFFECT)
			end
		else
			local tc=tg:GetFirst()
			local atk=tc:IsFaceup() and tc:GetAttack() or 0
			if Duel.Destroy(tg,REASON_EFFECT)==1 and atk~=0 
				then Duel.Recover(tp,atk,REASON_EFFECT)
			end
		end
	end
end