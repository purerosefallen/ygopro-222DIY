--朱槿花花园
function c1150027.initial_effect(c)
--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
-- 
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_RECOVER)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_HAND)
	e2:SetRange(LOCATION_FZONE)
	e2:SetOperation(c1150027.op2)
	c:RegisterEffect(e2)
--   
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(1150027,0))
	e3:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCountLimit(1,1150027)
	e3:SetCost(c1150027.cost3)
	e3:SetTarget(c1150027.tg3)
	e3:SetOperation(c1150027.op3)
	c:RegisterEffect(e3)
--
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(1150027,1))
	e4:SetCategory(CATEGORY_TOGRAVE+CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_RECOVER)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_FZONE)
	e4:SetCountLimit(1,1150029)
	e4:SetTarget(c1150027.tg4)
	e4:SetOperation(c1150027.op4)
	c:RegisterEffect(e4)
end
--
function c1150027.op2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Recover(tp,100,REASON_EFFECT)
end
--
function c1150027.cfilter3(c)
	return c:IsAbleToDeckAsCost()
end
function c1150027.cost3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c1150027.cfilter3,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c1150027.cfilter3,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SendtoDeck(g,nil,2,REASON_COST)
end
--
function c1150027.tfilter3(c)
	return c:GetLevel()>4 and c:GetRace()==RACE_PLANT and c:IsAbleToHand()
end
function c1150027.tg3(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c1150027.tfilter3,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
--
function c1150027.op3(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c1150027.tfilter4,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
		end
	end
end
--
function c1150027.tg4(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0 end
	Duel.Hint(HINT_SELECTMSG,tp,564)
	local ac=Duel.AnnounceCard(tp)
	e:SetLabel(ac)
	e:GetHandler():SetHint(CHINT_CARD,ac)
end
--
function c1150027.op4(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		local ac=e:GetLabel()
		local g=Duel.GetMatchingGroup(Card.IsCode,tp,0,LOCATION_HAND,nil,ac)
		local hg=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
		Duel.ConfirmCards(tp,hg)
		if g:GetCount()>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
			local sg=g:Select(tp,1,1,nil)
			if Duel.SendtoGrave(sg,REASON_EFFECT)>0 then 
				Duel.Recover(1-tp,800,REASON_EFFECT) 
			end
		else
			local cg=Duel.GetMatchingGroup(Card.IsCode,tp,0,LOCATION_DECK+LOCATION_GRAVE,nil,ac)
			local sg=cg:Filter(Card.IsAbleToHand,nil)
			if sg:GetCount()>0 and Duel.SelectYesNo(1-tp,aux.Stringid(1150027,2)) then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOHAND)
				local tc=sg:Select(1-tp,1,1,nil)
				if Duel.SendtoHand(tc,1-tp,REASON_EFFECT)>0 then 
					Duel.ConfirmCards(tp,tc)
					Duel.Recover(tp,500,REASON_EFFECT) 
				end
			end
		end
		Duel.ShuffleHand(1-tp)
	end
end




