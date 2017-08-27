--传说的探险
function c80090032.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,80090032+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c80090032.cost)
	e1:SetTarget(c80090032.target)
	e1:SetOperation(c80090032.activate)
	c:RegisterEffect(e1)
	--tohand
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(c80090032.discost)
	e2:SetTarget(c80090032.target1)
	e2:SetOperation(c80090032.operation)
	c:RegisterEffect(e2)
	Duel.AddCustomActivityCounter(80090032,ACTIVITY_SPSUMMON,c80090032.counterfilter)
end
function c80090032.counterfilter(c)
	return c:IsSetCard(0x52d4)
end
function c80090032.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(80090032,tp,ACTIVITY_SPSUMMON)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetLabelObject(e)
	e1:SetTarget(c80090032.splimit)
	Duel.RegisterEffect(e1,tp)
end
function c80090032.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsSetCard(0x52d4)
end
function c80090032.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
		if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<2 then return false end
		local g=Duel.GetDecktopGroup(tp,2)
		return g:FilterCount(Card.IsAbleToHand,nil)>0
	end
	Duel.SetTargetPlayer(tp)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c80090032.filter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSetCard(0x52d4)
end
function c80090032.filter1(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x52d4)
end
function c80090032.activate(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	Duel.ConfirmDecktop(p,2)
	local g=Duel.GetDecktopGroup(p,2)
	if g:GetCount()>0 then
		local sg=g:Filter(c80090032.filter,nil)
		local sg1=g:Filter(c80090032.filter1,nil)
		if sg:GetCount()>0 and sg1:GetCount()==0 then
			if sg:GetFirst():IsAbleToHand() then
				Duel.SendtoHand(sg,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-p,sg)
				Duel.ShuffleHand(p)
			end
		elseif sg1:GetCount()>0 and sg:GetCount()==0 then
				Duel.SpecialSummon(sg1,0,tp,tp,false,false,POS_FACEUP)
		elseif sg1:GetCount()>0 and sg:GetCount()>0 then
			if sg:GetFirst():IsAbleToHand() then
				Duel.SendtoHand(sg,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-p,sg)
				Duel.ShuffleHand(p)
				Duel.SpecialSummon(sg1,0,tp,tp,false,false,POS_FACEUP)
			end
		end
		Duel.ShuffleDeck(p)
	end
end
function c80090032.filter2(c)
	return c:IsSetCard(0x52d4) and c:IsAbleToRemove() and c:IsType(TYPE_MONSTER)
end
function c80090032.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c80090032.filter2,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_DECK)
end
function c80090032.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c80090032.filter2,tp,LOCATION_DECK,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetRange(LOCATION_REMOVED)
		e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
		e1:SetCountLimit(1)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN,2)
		e1:SetCondition(c80090032.thcon)
		e1:SetOperation(c80090032.thop)
		e1:SetLabel(0)
		tc:RegisterEffect(e1)
	end
end
function c80090032.thcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c80090032.thop(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetLabel()
	e:GetHandler():SetTurnCounter(ct+1)
	if ct==1 then
		Duel.SendtoHand(e:GetHandler(),nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,e:GetHandler())
	else e:SetLabel(1) end
end
function c80090032.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end