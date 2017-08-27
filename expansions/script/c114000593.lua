--不思議な星木之町
function c114000593.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--atk up
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(c114000593.tg)
	e2:SetValue(c114000593.val)
	c:RegisterEffect(e2)
	--extra summon
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(LOCATION_HAND+LOCATION_MZONE,0)
	e3:SetCode(EFFECT_EXTRA_SUMMON_COUNT)
	e3:SetTarget(c114000593.tg)
	c:RegisterEffect(e3)
	--draw
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCode(EVENT_PHASE+PHASE_END)
	e4:SetCountLimit(1)
	e4:SetCondition(c114000593.drcon)
	e4:SetTarget(c114000593.drtg)
	e4:SetOperation(c114000593.drop)
	c:RegisterEffect(e4)
end
function c114000593.tg(e,c)
	return ( c:IsSetCard(0x221) or c:IsCode(114000231) )
end
function c114000593.atkfilter(c)
	return c:IsFaceup() and ( c:IsSetCard(0x221) or c:IsCode(114000231) )
end
function c114000593.val(e,c)
	return Duel.GetMatchingGroupCount(c114000593.atkfilter,c:GetControler(),LOCATION_MZONE,0,nil)*200
end
--draw function
function c114000593.drcon(e,tp,eg,ep,ev,re,r,rp)
	return tp~=Duel.GetTurnPlayer()
end
function c114000593.filter(c)
	return ( c:IsSetCard(0x221) or c:IsCode(114000231) ) and c:IsType(TYPE_MONSTER) and c:IsAbleToDeck()
		and ( c:IsLocation(LOCATION_GRAVE) or c:IsFaceup() )
end
function c114000593.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) and Duel.IsExistingMatchingCard(c114000593.filter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_GRAVE+LOCATION_REMOVED)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c114000593.drop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c114000593.filter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
	if g:GetCount()>0 and Duel.SendtoDeck(g,nil,0,REASON_EFFECT)>0 then
		local ct=g:FilterCount(Card.IsLocation,nil,LOCATION_DECK)
		if ct>0 then Duel.ShuffleDeck(tp) end -- check if the chosen card is returned to extra deck
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end