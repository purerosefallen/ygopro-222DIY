--元始魔力
function c13254040.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,13254040)
	e2:SetCost(c13254040.cost)
	e2:SetTarget(c13254040.target)
	e2:SetOperation(c13254040.activate)
	c:RegisterEffect(e2)
	--destroy replace
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetCode(EFFECT_DESTROY_REPLACE)
	e3:SetRange(LOCATION_FZONE)
	e3:SetTarget(c13254040.reptg)
	e3:SetOperation(c13254040.repop)
	c:RegisterEffect(e3)
end
function c13254040.cfilter(c)
	return c:IsSetCard(0x3356) and c:IsDiscardable()
end
function c13254040.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c13254040.cfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local g=Duel.SelectMatchingCard(tp,c13254040.cfilter,tp,LOCATION_HAND,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST+REASON_DISCARD)
end
function c13254040.thfilter(c)
	return c:IsSetCard(0x356) and c:IsType(TYPE_MONSTER)
end
function c13254040.tgfilter(c)
	return c:IsSetCard(0x3356) and c:IsType(TYPE_MONSTER) and c:IsAbleToGrave()
end
function c13254040.refilter(c)
	return c:IsSetCard(0x356) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemove()
end
function c13254040.disfilter(c)
	return c:IsSetCard(0x3356) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c13254040.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c13254040.disfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c13254040.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local sg=Duel.SelectMatchingCard(tp,c13254040.disfilter,tp,LOCATION_DECK,0,1,1,nil)
	if sg:GetCount()>0 then
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
	local tc=Duel.GetOperatedGroup():GetFirst()
	local code=tc:GetCode()
	if code<13254031 and code>13254034 then return end
	Duel.ShuffleHand(tp)
	Duel.BreakEffect()
	local g=Group.CreateGroup()
	if code==13254031 then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(13254040,0))
		g=Duel.SelectMatchingCard(tp,c13254040.thfilter,tp,LOCATION_DECK,0,1,1,nil)
		local tc=g:GetFirst()
		if tc then
			Duel.ShuffleDeck(tp)
			Duel.MoveSequence(tc,0)
			Duel.ConfirmDecktop(tp,1)
		end
	elseif code==13254032 then
		Duel.Draw(tp,1,REASON_EFFECT)
	elseif code==13254033 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g=Duel.SelectMatchingCard(tp,c13254040.refilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
		end
	elseif code==13254034 then
		local g=Duel.GetMatchingGroup(c13254040.tgfilter,tp,LOCATION_DECK,0,nil)
		if g:GetCount()>=1 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
			sg=g:Select(tp,1,1,nil)
			Duel.SendtoGrave(sg,REASON_EFFECT)
		end
	end
end
function c13254040.repfilter(c)
	return (c:IsCode(13254035) or c:IsCode(13254036))
end
function c13254040.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return not c:IsReason(REASON_REPLACE) and c:IsOnField() and c:IsFaceup()
		and Duel.IsExistingMatchingCard(c13254040.repfilter,tp,LOCATION_HAND,0,1,nil) end
	if Duel.SelectYesNo(tp,aux.Stringid(13254040,1)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESREPLACE)
		local g=Duel.SelectMatchingCard(tp,c13254040.repfilter,tp,LOCATION_HAND,0,1,1,nil)
		e:SetLabelObject(g:GetFirst())
		return true
	else return false end
end
function c13254040.repop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	Duel.SendtoGrave(tc,REASON_EFFECT+REASON_DISCARD)
end

