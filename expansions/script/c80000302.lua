--口袋妖怪 比雕
function c80000302.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x2d0),aux.NonTuner(Card.IsSetCard,0x2d0),1)
	c:EnableReviveLimit()
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(80000302,0))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(c80000302.thtg)
	e2:SetOperation(c80000302.thop)
	c:RegisterEffect(e2)
	--sp
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(80000302,1))
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,80000302)
	e3:SetCondition(c80000302.thcon)
	e3:SetTarget(c80000302.thtg1)
	e3:SetOperation(c80000302.thop1)
	c:RegisterEffect(e3)	   
end
function c80000302.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsAbleToHand() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToHand,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,Card.IsAbleToHand,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c80000302.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end
function c80000302.cfilter(c,tp)
	return c:IsFaceup() and c:IsLevelBelow(7) and c:IsControler(tp)
end
function c80000302.thcon(e,tp,eg,ep,ev,re,r,rp)
	return not eg:IsContains(e:GetHandler()) and eg:IsExists(c80000302.cfilter,1,nil,1-tp)
end
function c80000302.filter(c)
	return bit.band(c:GetSummonType(),SUMMON_TYPE_SPECIAL)==SUMMON_TYPE_SPECIAL and c:IsAbleToHand()
end
function c80000302.thtg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c80000302.filter(chkc) end
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,c80000302.filter,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,g:GetCount(),0,0)
end
function c80000302.spfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,1-tp,false,false) and c:IsLevelAbove(7)
end
function c80000302.thop1(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		local g=Duel.GetMatchingGroup(c80000302.spfilter,tp,0,LOCATION_HAND,nil,e,1-tp)
		if g:GetCount()>0 and Duel.SelectYesNo(1-tp,aux.Stringid(80000302,2)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_SPSUMMON)
			local sc=g:Select(1-tp,1,1,nil)
			Duel.SpecialSummon(sc,0,1-tp,1-tp,false,false,POS_FACEUP)
		end
	end
end