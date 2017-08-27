--黑暗与光明
function c80021034.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetCondition(c80021034.condition)
	e1:SetTarget(c80021034.target)
	e1:SetOperation(c80021034.activate)
	c:RegisterEffect(e1)
	--draw
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e2:SetDescription(aux.Stringid(80021034,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(aux.exccon)
	e2:SetTarget(c80021034.tdtg)
	e2:SetOperation(c80021034.tdop)
	c:RegisterEffect(e2)
end
function c80021034.cfilter(c)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_LIGHT+ATTRIBUTE_DARK)
end
function c80021034.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c80021034.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c80021034.cfilter2(c,att)
	return c:IsFaceup() and c:IsAttribute(att)
end
function c80021034.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local b1=Duel.IsExistingMatchingCard(c80021034.cfilter2,tp,LOCATION_MZONE,0,1,nil,ATTRIBUTE_DARK)
	local b2=Duel.IsExistingMatchingCard(c80021034.cfilter2,tp,LOCATION_MZONE,0,1,nil,ATTRIBUTE_LIGHT)
	if chk==0 then return b1 or b2 end
	if b2 then
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
	end
end
function c80021034.activate(e,tp,eg,ep,ev,re,r,rp)
	local opt=0
	if Duel.IsExistingMatchingCard(c80021034.cfilter2,tp,LOCATION_MZONE,0,1,nil,ATTRIBUTE_DARK) then opt=opt+1 end
	if Duel.IsExistingMatchingCard(c80021034.cfilter2,tp,LOCATION_MZONE,0,1,nil,ATTRIBUTE_LIGHT) then opt=opt+2 end
	if opt==1 or opt==3 then
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsAttribute,ATTRIBUTE_DARK))
	e1:SetValue(1)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	Duel.RegisterEffect(e2,tp)
	--inactivatable
	local e4=Effect.CreateEffect(e:GetHandler())
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_CANNOT_INACTIVATE)
	e4:SetValue(c80021034.effectfilter)
	e4:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e4,tp)
	local e5=Effect.CreateEffect(e:GetHandler())
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_CANNOT_DISEFFECT)
	e5:SetValue(c80021034.effectfilter)
	e5:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e5,tp)
	end
	if opt==2 or opt==3 then
		Duel.BreakEffect()
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(p,Card.IsRace,p,LOCATION_HAND,0,1,1,nil,RACE_FIEND)
	local tg=g:GetFirst()
	if tg then
		if Duel.Remove(tg,POS_FACEUP,REASON_EFFECT)==0 then
			Duel.ConfirmCards(1-p,tg)
			Duel.ShuffleHand(p)
		end
	else
		local sg=Duel.GetFieldGroup(p,LOCATION_HAND,0)
		Duel.SendtoGrave(sg,REASON_EFFECT)
	end
end
end
function c80021034.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeck() and Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c80021034.tdop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SendtoDeck(c,nil,0,REASON_EFFECT)~=0 and c:IsLocation(LOCATION_DECK) then
		Duel.ShuffleDeck(tp)
		Duel.BreakEffect()
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end
function c80021034.effectfilter(e,ct)
	local p=e:GetHandlerPlayer()
	local te,tp,loc=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER,CHAININFO_TRIGGERING_LOCATION)
	local tc=te:GetHandler()
	return p==tp and bit.band(loc,LOCATION_ONFIELD)~=0 and tc:IsSetCard(0x92d5) and tc~=e:GetHandler()
end
