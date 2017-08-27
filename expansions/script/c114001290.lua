--ツヴァイプリズム
function c114001290.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(c114001290.regop)
	c:RegisterEffect(e1)
	--Search
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetTarget(c114001290.target2)
	e2:SetOperation(c114001290.operation2)
	c:RegisterEffect(e2)
end
function c114001290.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetCountLimit(1,114001290)
	e1:SetRange(LOCATION_SZONE)
	e1:SetTarget(c114001290.target)
	e1:SetOperation(c114001290.activate)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e1)
end
function c114001290.tgfilter(c,att)
	return c:IsSetCard(0x1223) and c:IsAbleToGrave() and c:IsAttribute(att)
end
function c114001290.checkatt(tp)
	return Duel.IsExistingMatchingCard(c114001290.tgfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,ATTRIBUTE_EARTH)
	and Duel.IsExistingMatchingCard(c114001290.tgfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,ATTRIBUTE_WATER)
	and Duel.IsExistingMatchingCard(c114001290.tgfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,ATTRIBUTE_FIRE)
	and Duel.IsExistingMatchingCard(c114001290.tgfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,ATTRIBUTE_WIND)
end
function c114001290.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return c114001290.checkatt(tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,4,tp,LOCATION_DECK)
end
function c114001290.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	if c114001290.checkatt(tp) then
		local g1=Duel.GetMatchingGroup(c114001290.tgfilter,tp,LOCATION_HAND+LOCATION_DECK,0,nil,ATTRIBUTE_EARTH)
		local g2=Duel.GetMatchingGroup(c114001290.tgfilter,tp,LOCATION_HAND+LOCATION_DECK,0,nil,ATTRIBUTE_WATER)
		local g3=Duel.GetMatchingGroup(c114001290.tgfilter,tp,LOCATION_HAND+LOCATION_DECK,0,nil,ATTRIBUTE_FIRE)
		local g4=Duel.GetMatchingGroup(c114001290.tgfilter,tp,LOCATION_HAND+LOCATION_DECK,0,nil,ATTRIBUTE_WIND)
		g1:Merge(g2)
		g1:Merge(g3)
		g1:Merge(g4)
		local tg=Group.CreateGroup()
		for i=1,4 do
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
			local sg=g1:Select(tp,1,1,nil)
			g1:Remove(Card.IsAttribute,nil,sg:GetFirst():GetAttribute())
			tg:Merge(sg)
		end
		Duel.SendtoGrave(tg,REASON_EFFECT)
	end
end

function c114001290.scfilter(c)
	return c:IsCode(114000989) and c:IsAbleToHand() and not c:IsHasEffect(EFFECT_NECRO_VALLEY)
end
function c114001290.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c114001290.operation2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c114001290.scfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 
	then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	else
		if not Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_DECK,0,1,nil,114000989) then
			local cg=Duel.GetFieldGroup(tp,LOCATION_DECK,0)
			Duel.ConfirmCards(1-tp,cg)
			Duel.ShuffleDeck(tp)
		end
	end
end
--