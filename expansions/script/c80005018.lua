--圣灵之夜
function c80005018.initial_effect(c)
	--return
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(80005018,0))
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetCountLimit(1,80005018)
	e1:SetTarget(c80005018.target)
	e1:SetOperation(c80005018.operation)
	c:RegisterEffect(e1)
	--act in hand
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e3:SetCondition(c80005018.handcon)
	c:RegisterEffect(e3)
	--Activate
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_REMOVE)
	e2:SetDescription(aux.Stringid(80005018,1))
	e2:SetRange(LOCATION_SZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCondition(c80005018.condition)
	e2:SetTarget(c80005018.target1)
	e2:SetOperation(c80005018.activate1)
	c:RegisterEffect(e2)
	--splimit
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetRange(LOCATION_FZONE)
	e4:SetTargetRange(1,0)
	e4:SetTarget(c80005018.splimit)
	c:RegisterEffect(e4)
end
function c80005018.splimit(e,c)
	return c:IsLevelAbove(7)
end
function c80005018.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function c80005018.filter(c)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_DARK+ATTRIBUTE_LIGHT)
end
function c80005018.handcon(e)
	return Duel.IsExistingMatchingCard(c80005018.filter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
function c80005018.filter3(c)
	return c:IsFaceup() and c:IsRace(RACE_SPELLCASTER) and c:IsAbleToHand()
end
function c80005018.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c80005018.filter3(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c80005018.filter3,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,c80005018.filter3,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c80005018.sumfilter(c)
	return c:IsRace(RACE_SPELLCASTER) and c:GetAttack()==-2 and c:GetDefense()==-2
end
function c80005018.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SendtoHand(tc,nil,REASON_EFFECT)>0 and tc:IsLocation(LOCATION_HAND) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local g=Duel.SelectMatchingCard(tp,c80005018.sumfilter,tp,LOCATION_HAND,0,1,1,nil)
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c80005018.filter1(c)
	return c:IsFaceup()
end
function c80005018.target1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_REMOVED) and c80005018.filter1(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c80005018.filter1,tp,0,LOCATION_REMOVED,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c80005018.filter1,tp,0,LOCATION_REMOVED,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
end
function c80005018.activate1(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=tg:Filter(Card.IsRelateToEffect,nil,e)
	if sg:GetCount()>0 then
		Duel.SendtoDeck(sg,nil,2,REASON_EFFECT)
			Duel.BreakEffect()
	g=Duel.GetDecktopGroup(1-tp,2)
	Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	end
end