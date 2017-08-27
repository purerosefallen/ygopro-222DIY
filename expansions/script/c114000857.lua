--★雷電の魔女っ娘　Nobel Gold
function c114000857.initial_effect(c)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetCountLimit(1,114000857)
	e1:SetCondition(c114000857.condition)
	e1:SetTarget(c114000857.target)
	e1:SetOperation(c114000857.operation)
	c:RegisterEffect(e1)
end
function c114000857.condition(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousPosition(POS_FACEUP) and c:IsPreviousLocation(LOCATION_ONFIELD)
end
function c114000857.filter(c)
	return c:IsAbleToHand()
		and ( c:IsSetCard(0xcabb) or c:IsSetCard(0x223) or c:IsSetCard(0x224) 
		or c:IsCode(36405256) or c:IsCode(54360049) or c:IsCode(37160778) or c:IsCode(27491571) or c:IsCode(80741828) or c:IsCode(90330453) --0x223
		or c:IsCode(32751480) or c:IsCode(78010363) or c:IsCode(39432962) or c:IsCode(67511500) or c:IsCode(62379337) or c:IsCode(23087070) or c:IsCode(17720747) or c:IsCode(98358303) or c:IsCode(91584698) ) --0x224
end
function c114000857.filter2(c)
	return c:GetLevel()==10 and c:IsRace(RACE_FIEND) and c:IsAttribute(ATTRIBUTE_DARK) and c:IsAbleToHand() and not c:IsHasEffect(EFFECT_NECRO_VALLEY) 
end
function c114000857.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		local sel=0
		if Duel.IsExistingMatchingCard(c114000857.filter,tp,LOCATION_DECK,0,1,nil) then sel=sel+1 end
		if Duel.IsExistingMatchingCard(c114000857.filter2,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) then sel=sel+2 end
		e:SetLabel(sel)
		return sel~=0
	end
	local sel=e:GetLabel()
	if sel==3 then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(114000857,0))
		sel=Duel.SelectOption(tp,aux.Stringid(114000857,1),aux.Stringid(114000857,2))+1
	end
	e:SetLabel(sel)
	if sel==1 then
		Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(114000857,1))
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	else 
		Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(114000857,2))
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
	end
end
function c114000857.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local sel=e:GetLabel()
	if sel==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c114000857.filter,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c114000857.filter2,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end