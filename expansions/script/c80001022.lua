--冰灵水晶
function c80001022.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)  
	--material
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(80001022,0))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_SZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,80001023)
	e2:SetCondition(c80001022.spcon)
	e2:SetTarget(c80001022.mattg)
	e2:SetOperation(c80001022.matop)
	c:RegisterEffect(e2)
	--cannot be target
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_SELECT_EFFECT_TARGET)
	e3:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IMMEDIATELY_APPLY)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(0,0xff)
	e3:SetValue(c80001022.etarget)
	c:RegisterEffect(e3)  
	--draw
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(80001022,0))
	e4:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetCountLimit(1,80001022)
	e4:SetRange(LOCATION_SZONE)
	e4:SetTarget(c80001022.target)
	e4:SetOperation(c80001022.operation)
	c:RegisterEffect(e4)
end
function c80001022.cfilter(c,tp)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:IsControler(tp) and c:IsAttribute(ATTRIBUTE_WATER)
end
function c80001022.spcon(e,tp,eg,ep,ev,re,r,rp)
	return not eg:IsContains(e:GetHandler()) and eg:IsExists(c80001022.cfilter,1,nil,tp)
end
function c80001022.etarget(e,re,c)
	return c:IsFaceup() and c:IsControler(e:GetHandlerPlayer()) and ((c:IsLocation(LOCATION_MZONE) and c:IsType(TYPE_XYZ) and c:IsAttribute(ATTRIBUTE_WATER)) or c:IsSetCard(0x2dc))
end
function c80001022.filter(c)
	return (c:IsSetCard(0x2dc) or c:IsRace(RACE_WINDBEAST)) and c:IsAbleToDeck() and not c:IsPublic()
end
function c80001022.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp)
		and Duel.IsExistingMatchingCard(c80001022.filter,tp,LOCATION_HAND,0,1,nil) end
	Duel.SetTargetPlayer(tp)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_HAND)
end
function c80001022.operation(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	Duel.Hint(HINT_SELECTMSG,p,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(p,c80001022.filter,p,LOCATION_HAND,0,1,99,nil)
	if g:GetCount()>0 then
		Duel.ConfirmCards(1-p,g)
		local ct=Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
		Duel.ShuffleDeck(p)
		Duel.BreakEffect()
		Duel.Draw(p,ct,REASON_EFFECT)
		Duel.ShuffleHand(p)
	end
end
function c80001022.xyzfilter(c,tp)
	return c:IsFaceup() and c:IsType(TYPE_XYZ)
		and Duel.IsExistingMatchingCard(c80001022.matfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,c) and c:IsAttribute(ATTRIBUTE_WATER)
end
function c80001022.matfilter(c)
	return c:IsLocation(LOCATION_GRAVE) and c:IsType(TYPE_XYZ) and not c:IsType(TYPE_TOKEN)
end
function c80001022.mattg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c80001022.xyzfilter(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(c80001022.xyzfilter,tp,LOCATION_MZONE,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c80001022.xyzfilter,tp,LOCATION_MZONE,0,1,1,nil,tp)
end
function c80001022.matop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		local g=Duel.SelectMatchingCard(tp,c80001022.matfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,tc)
		if g:GetCount()>0 then
			local mg=g:GetFirst():GetOverlayGroup()
			if mg:GetCount()>0 then
				Duel.SendtoGrave(mg,REASON_RULE)
			end
			Duel.Overlay(tc,g)
		end
	end
end