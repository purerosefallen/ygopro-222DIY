--回锅白泽球
function c22221102.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetCountLimit(1,22221102)
	e1:SetTarget(c22221102.target)
	e1:SetOperation(c22221102.operation)
	c:RegisterEffect(e1)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCode(EVENT_REMOVE)
	e2:SetCountLimit(1)
	e2:SetTarget(c22221102.shtg)
	e2:SetOperation(c22221102.shop)
	c:RegisterEffect(e2)

end

c22221102.named_with_Shirasawa_Tama=1
function c22221102.IsShirasawaTama(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Shirasawa_Tama
end
function c22221102.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMatchingGroupCount(Card.IsAbleToRemove, tp, LOCATION_DECK, 0, nil) > 2 end
end

function c22221102.filter(c)
	return c22221102.IsShirasawaTama(c) and c:IsFaceup()
end

function c22221102.pfilter(c)
	return c22221102.IsShirasawaTama(c) and c:IsAbleToRemove()
end

function c22221102.operation(e,tp,eg,ep,ev,re,r,rp)
	local c = e:GetHandler()
	Duel.ConfirmDecktop(tp,3)
	local sg = Duel.GetDecktopGroup(tp,3)
	local pg = sg:Filter(c22221102.pfilter, nil)
	if pg:GetCount() > 0 then
		local tc=pg:GetFirst()
		while tc do
			Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
			if tc:IsType(TYPE_MONSTER) then tc:CompleteProcedure() end
			tc=pg:GetNext()
		end
		Duel.ShuffleDeck(tp)
		if Duel.IsExistingMatchingCard(c22221102.filter,tp,LOCATION_ONFIELD,0,1,e:GetHandler()) and Duel.IsExistingMatchingCard(c22221102.sfilter,tp,LOCATION_DECK,0,1,nil) then
			Duel.BreakEffect()
			local ssg=Duel.SelectMatchingCard(tp,c22221102.sfilter,tp,LOCATION_DECK,0,1,1,nil)
			if ssg:GetCount()>0 then
				Duel.SendtoHand(ssg,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,ssg)
				Duel.ShuffleHand(tp)
			end
		end
	end
end
function c22221102.sfilter(c)
	return c22221102.IsShirasawaTama(c) and c:IsAbleToHand()
end
function c22221102.shtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c22221102.sfilter,tp,LOCATION_DECK+LOCATION_REMOVED,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_REMOVED)
end
function c22221102.shop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c22221102.sfilter,tp,LOCATION_DECK+LOCATION_REMOVED,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end