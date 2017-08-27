--Play with me!
function c13255207.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c13255207.tgtg)
	e1:SetOperation(c13255207.tgop)
	c:RegisterEffect(e1)
	--send to grave
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(13255207,1))
	e2:SetCategory(CATEGORY_TOGRAVE+CATEGORY_TODECK)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCountLimit(3,13255207)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTarget(c13255207.target)
	e2:SetOperation(c13255207.operation)
	c:RegisterEffect(e2)
	--Pos Change
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_SET_POSITION)
	e3:SetRange(LOCATION_FZONE)
	e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e3:SetValue(POS_FACEUP_ATTACK)
	c:RegisterEffect(e3)
	
end
function c13255207.filter(c)
	return c:GetOriginalCode()==13255201 and c:IsAbleToGrave()
end
function c13255207.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c13255207.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c13255207.tgop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(c13255207.filter,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(13255207,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoGrave(sg,REASON_EFFECT)
	end
end
function c13255207.tdfilter(c)
	return c:IsCode(13255201) and c:IsAbleToDeck()
end
function c13255207.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_ONFIELD) end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) and Duel.IsExistingMatchingCard(c13255207.tdfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,0)
end
function c13255207.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and e:GetHandler():IsRelateToEffect(e) then
		if Duel.SendtoGrave(tc,REASON_EFFECT)==1 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
			local tc1=Duel.SelectMatchingCard(tp,c13255207.tdfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
			if tc1:GetCount()==0 then return end
			Duel.BreakEffect()
			Duel.SendtoDeck(tc1,nil,2,REASON_EFFECT)
		end
	end
end
