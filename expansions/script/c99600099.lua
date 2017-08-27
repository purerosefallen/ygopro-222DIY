--
function c99600099.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_TODECK+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(c99600099.condition)
	e1:SetTarget(c99600099.target)
	e1:SetOperation(c99600099.activate)
	c:RegisterEffect(e1)
	--Activate(summon)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DISABLE_SUMMON+CATEGORY_DESTROY+CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_SPSUMMON)
	e2:SetCondition(c99600099.condition1)
	e2:SetTarget(c99600099.target1)
	e2:SetOperation(c99600099.activate1)
	c:RegisterEffect(e2)
end
function c99600099.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x1702)
end
function c99600099.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c99600099.cfilter,tp,LOCATION_ONFIELD,0,1,nil)
		and re:IsActiveType(TYPE_SPELL) and re:IsHasType(EFFECT_TYPE_ACTIVATE) and Duel.IsChainNegatable(ev)
end
function c99600099.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_TODECK,eg,1,0,0)
	end
end
function c99600099.activate(e,tp,eg,ep,ev,re,r,rp)
	local ec=re:GetHandler()
	Duel.NegateActivation(ev)
	if ec:IsRelateToEffect(re) then
		ec:CancelToGrave()
		if Duel.SendtoDeck(ec,nil,2,REASON_EFFECT)~=0 and ec:IsLocation(LOCATION_DECK+LOCATION_EXTRA) then
			local g=Duel.GetMatchingGroup(c99600099.cfilter,tp,LOCATION_ONFIELD,0,e:GetHandler())
			if g:GetCount()>0 then
				Duel.BreakEffect()
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
				local sg=g:Select(tp,1,1,nil)
				Duel.Destroy(sg,REASON_EFFECT)
			end
		end
	end
end
function c99600099.condition1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c99600099.cfilter,tp,LOCATION_ONFIELD,0,1,nil)
		and Duel.GetCurrentChain()==0
end
function c99600099.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE_SUMMON,eg,eg:GetCount(),0,0)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_TODECK,eg,1,0,0)
	end
end
function c99600099.activate1(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c99600099.cfilter,tp,LOCATION_ONFIELD,0,e:GetHandler())
	Duel.NegateSummon(eg)
	if Duel.SendtoDeck(eg,nil,2,REASON_EFFECT)>0 and  g:GetCount()>0 then
				Duel.BreakEffect()
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
				local sg=g:Select(tp,1,1,nil)
				Duel.Destroy(sg,REASON_EFFECT)
			end
end