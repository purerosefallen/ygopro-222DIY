--流魂的银屑 祈明
function c2100006.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c2100006.spcon)
	c:RegisterEffect(e1)
	--todeck
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(2100006,1))
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,2100006)
	e2:SetTarget(c2100006.tdtg)
	e2:SetOperation(c2100006.tdop)
	c:RegisterEffect(e2)
end
function c2100006.spcon(e,c)
	if c==nil then return true end
	return Duel.GetFieldGroupCount(c:GetControler(),LOCATION_MZONE,0,nil)==0
		and Duel.GetMZoneCount(c:GetControler())>0
end
function c2100006.tdfilter(c)
	return c:IsSetCard(0x3219) and c:IsAbleToDeck()
end
function c2100006.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and c2100006.tdfilter(chkc) and chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) end
	if chk==0 then return Duel.IsExistingTarget(c2100006.tdfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c2100006.tdfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
end
function c2100006.filter(c)
	return c:IsSetCard(0x3219) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c2100006.tdop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)~=0 then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c2100006.filter,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end