--贡献给虚无的灵魂
function c60150812.initial_effect(c)
	--Activate(effect)
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e4:SetType(EFFECT_TYPE_ACTIVATE)
	e4:SetCode(EVENT_CHAINING)
	e4:SetCondition(c60150812.condition2)
	e4:SetCost(c60150812.cost2)
	e4:SetTarget(c60150812.target2)
	e4:SetOperation(c60150812.activate2)
	c:RegisterEffect(e4)
end
function c60150812.condition2(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsChainNegatable(ev) then return false end
	if not re:IsActiveType(TYPE_MONSTER) and not re:IsHasType(EFFECT_TYPE_ACTIVATE) then return false end
	return re:IsHasCategory(CATEGORY_SPECIAL_SUMMON)
end
function c60150812.cfilter(c)
	return c:IsSetCard(0x3b23) and c:IsAttribute(ATTRIBUTE_DARK) and c:IsAbleToRemoveAsCost()
end
function c60150812.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c60150812.cfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c60150812.cfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c60150812.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsAbleToRemove() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,eg,1,0,0)
	end
end
function c60150812.activate2(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.Remove(eg,POS_FACEUP,REASON_EFFECT)
		Duel.BreakEffect()
		local dc=Duel.TossDice(tp,1)
		if dc==1 then
			local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
			if g:GetCount()==0 then return end
			local sg=g:RandomSelect(tp,1)
			Duel.Remove(sg,POS_FACEDOWN,REASON_EFFECT)
		end
		if dc==2 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
			local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,1,nil)
			if g:GetCount()>0 then
				Duel.HintSelection(g)
				Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT)
			end	
		end
		if dc==3 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
			local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,0,LOCATION_GRAVE,1,1,nil)
			if g:GetCount()>0 then
				Duel.HintSelection(g)
				Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT)
			end	
		end
		if dc==4 then
			local g1=Duel.GetFieldGroup(tp,0,LOCATION_EXTRA)
			if g1:GetCount()>0 then
				Duel.ConfirmCards(tp,g1)
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
				local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,0,LOCATION_EXTRA,1,1,nil)
				if g:GetCount()>0 then
					Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT)
				end	
			end
		end
		if dc==5 then
			local g=Duel.GetFieldCard(1-tp,LOCATION_DECK,0)
			Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT)
		end	
		if dc==6 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
			local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,LOCATION_GRAVE+LOCATION_DECK,0,1,1,nil)
			if g:GetCount()>0 then
				Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
			end	
		end	
	end
end	
