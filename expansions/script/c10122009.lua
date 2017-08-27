--空想的湮灭
function c10122009.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,10122009+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c10122009.cost)
	e1:SetTarget(c10122009.target)
	e1:SetOperation(c10122009.activate)
	c:RegisterEffect(e1)	 
end
function c10122009.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10122009.cfilter,tp,LOCATION_REMOVED+LOCATION_GRAVE,0,3,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c10122009.cfilter,tp,LOCATION_REMOVED+LOCATION_GRAVE,0,3,3,nil)
	Duel.SendtoDeck(g,nil,2,REASON_COST)
end
function c10122009.cfilter(c)
	return c:IsSetCard(0xc333) and c:IsAbleToDeckAsCost()
end
function c10122009.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10122009.acfilter,tp,LOCATION_DECK,0,1,nil,tp) end
end
function c10122009.acfilter(c,tp)
	return c:IsType(TYPE_FIELD) and c:GetActivateEffect():IsActivatable(tp) and c:IsSetCard(0xc333) and Duel.IsExistingMatchingCard(c10122009.thfilter,tp,LOCATION_DECK,0,1,c)
end
function c10122009.thfilter(c,tp)
	return c:IsType(TYPE_FIELD) and c:IsAbleToHand() and c:IsSetCard(0xc333) 
end
function c10122009.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c10122009.acfilter,tp,LOCATION_DECK,0,nil,tp)
	if g:GetCount()<=0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(10122009,0))
		local tc=g:Select(tp,1,1,nil):GetFirst()
		local fc=Duel.GetFieldCard(tp,LOCATION_SZONE,5)
		if fc then
			Duel.SendtoGrave(fc,REASON_RULE)
			Duel.BreakEffect()
		end
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		local te=tc:GetActivateEffect()
		local tep=tc:GetControler()
		local cost=te:GetCost()
		if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
		Duel.RaiseEvent(tc,EVENT_CHAIN_SOLVED,te,0,tp,tp,Duel.GetCurrentChain())
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local tg=Duel.SelectMatchingCard(tp,c10122009.thfilter,tp,LOCATION_DECK,0,1,1,tc)
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tg)
end
