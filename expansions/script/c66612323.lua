--仙境国与魔术乡
function c66612323.initial_effect(c)
	---
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--change name
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_ADD_CODE)
	e1:SetRange(LOCATION_ONFIELD+LOCATION_GRAVE)
	e1:SetValue(66619916)
	c:RegisterEffect(e1)
	--copy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(66612320,1))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)
	e2:SetCost(c66612323.cpcost)
	e2:SetTarget(c66612323.cptg)
	e2:SetOperation(c66612323.cpop)
	c:RegisterEffect(e2)
	--spummop
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(66612320,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1)
	e3:SetCondition(c66612323.spcon)
	e3:SetCost(c66612323.cost)
	e3:SetTarget(c66612323.sptg)
	e3:SetOperation(c66612323.spop)
	c:RegisterEffect(e3)
end
function c66612323.tdfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_SPELL) and c:IsAbleToDeckAsCost()
end
function c66612323.cpcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(c66612323.tdfilter,tp,LOCATION_GRAVE,0,3,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c66612323.tdfilter,tp,LOCATION_GRAVE,0,3,3,nil)
	Duel.SendtoDeck(g,nil,2,REASON_COST)
end
function c66612323.filter1(c)
	return c:IsSetCard(0x660) and c:IsAbleToHand()
end
function c66612323.cptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c66612323.filter1,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c66612323.cpop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c66612323.filter1,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c66612323.afilter(c,tp)
	return c:IsFaceup() and c:GetSummonPlayer()==tp and c:IsSetCard(0x666) and c:IsType(TYPE_TUNER)
end
function c66612323.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c66612323.afilter,1,nil,tp)
end
function c66612323.cfilter(c,tp)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER) and c:IsSetCard(0x666) and c:IsType(TYPE_TUNER) and c:IsAbleToGraveAsCost() and Duel.IsExistingMatchingCard(c66612323.filter,tp,LOCATION_EXTRA,0,1,nil,e,tp,Group.FromCards(c))
end
function c66612323.bfilter(c)
	return c:IsAbleToGraveAsCost()
end
function c66612323.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c66612323.cfilter,tp,LOCATION_MZONE,0,1,nil,tp)
		and Duel.IsExistingMatchingCard(c66612323.bfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g1=Duel.SelectMatchingCard(tp,c66612323.cfilter,tp,LOCATION_MZONE,0,1,1,nil,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g2=Duel.SelectMatchingCard(tp,c66612323.bfilter,tp,LOCATION_HAND,0,1,1,nil)
	g1:Merge(g2)
	Duel.SendtoGrave(g1,REASON_COST)
end
function c66612323.filter(c,e,tp,g)
	if g and Duel.GetLocationCountFromEx(tp,tp,g,c)<=0 then return false end
	return c:IsType(TYPE_MONSTER) and c:IsType(TYPE_SYNCHRO) and c:IsSetCard(0x666) and not c:IsCode(66619912) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_SYNCHRO,tp,false,false)
end
function c66612323.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c66612323.filter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c66612323.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCountFromEx(tp)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c66612323.filter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc then
		Duel.SpecialSummon(tc,SUMMON_TYPE_SYNCHRO,tp,tp,true,true,POS_FACEUP)
		tc:CompleteProcedure()
	end
end