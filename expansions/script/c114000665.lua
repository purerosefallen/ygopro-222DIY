--二人の星座づくり
function c114000665.initial_effect(c)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c114000665.cost)
	e1:SetTarget(c114000665.target)
	e1:SetOperation(c114000665.activate)
	c:RegisterEffect(e1)
end
function c114000665.cfilter(c)
	return ( c:IsSetCard(0x221) or c:IsCode(114000231) ) and c:IsType(TYPE_MONSTER) and not c:IsPublic()
end
function c114000665.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c114000665.cfilter,tp,LOCATION_HAND,0,nil)
	if chk==0 then return g:GetClassCount(Card.GetCode)>=2 and Duel.GetFlagEffect(tp,114000665)==0 end
	local cg=Group.CreateGroup()
	for i=1,2 do
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
		local sg=g:Select(tp,1,1,nil)
		g:Remove(Card.IsCode,nil,sg:GetFirst():GetCode())
		cg:Merge(sg)
	end
	Duel.ConfirmCards(1-tp,cg)
	Duel.ShuffleHand(tp)
	Duel.RegisterFlagEffect(tp,114000665,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
end
--target
function c114000665.filter1(c)
	return ( c:IsSetCard(0x221) or c:IsCode(114000231) ) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c114000665.filter2(c)
	return c:IsType(TYPE_FIELD) and c:IsAbleToHand()
end
function c114000665.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c114000665.filter1,tp,LOCATION_DECK,0,1,nil)
		and Duel.IsExistingMatchingCard(c114000665.filter2,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,tp,LOCATION_DECK)
end
function c114000665.activate(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetMatchingGroup(c114000665.filter1,tp,LOCATION_DECK,0,nil)
	local g2=Duel.GetMatchingGroup(c114000665.filter2,tp,LOCATION_DECK,0,nil)
	if g1:GetCount()>0 and g2:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg1=g1:Select(tp,1,1,nil)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg2=g2:Select(tp,1,1,nil)
		sg1:Merge(sg2)
		Duel.SendtoHand(sg1,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg1)
	end
	local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
    e1:SetTargetRange(1,0)
    e1:SetTarget(c114000665.splimit)
    e1:SetReset(RESET_PHASE+PHASE_END)
    Duel.RegisterEffect(e1,tp)
end
function c114000665.splimit(e,c,sump,sumtype,sumpos,targetp)
    return c:IsLocation(LOCATION_HAND)
end