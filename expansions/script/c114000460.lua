--未来への追憶の夢（ノスタルジーカ）
function c114000460.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,0x1e0)
	e1:SetCost(c114000460.cost)
	e1:SetCondition(c114000460.condition)
	e1:SetTarget(c114000460.target)
	e1:SetOperation(c114000460.activate)
	c:RegisterEffect(e1)
end
function c114000460.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,114000376)==0 end
	Duel.RegisterFlagEffect(tp,114000376,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
end
function c114000460.filter(c)
	return ( c:IsSetCard(0x221) or c:IsCode(114000231) ) and c:IsFaceup()
end
function c114000460.condition(e,c) --xc:GetControler()
	return Duel.GetMatchingGroup(c114000460.filter,tp,LOCATION_MZONE,0,nil):GetClassCount(Card.GetCode)>=2
end
function c114000460.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsLocation(LOCATION_REMOVED) end
	if chk==0 then return Duel.IsExistingMatchingCard(nil,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,PLAYER_ALL,LOCATION_REMOVED)
end
function c114000460.activate(e,tp,eg,ep,ev,re,r,rp)
    local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetRange(LOCATION_REMOVED)
    e1:SetCountLimit(1)
    e1:SetOperation(c114000460.operation)
    e1:SetReset(RESET_PHASE+PHASE_END)
    Duel.RegisterEffect(e1,tp)
end
function c114000460.spfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
	and ( c:IsSetCard(0x221) or c:IsCode(114000231) )
	and c:IsRace(RACE_MACHINE)
	and c:IsLevelBelow(4)
end
function c114000460.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,LOCATION_REMOVED,LOCATION_REMOVED)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT+REASON_RETURN)
		if Duel.IsExistingMatchingCard(c114000460.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
		and Duel.SelectYesNo(tp,aux.Stringid(114000460,0)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local g2=Duel.SelectMatchingCard(tp,c114000460.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
			Duel.SpecialSummon(g2,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end