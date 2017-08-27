--界限龙王 蒂雅玛特
function c10103006.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_DRAGON),aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--addtohand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10103006,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,10103006)
	e1:SetCondition(c10103006.thcon)
	e1:SetTarget(c10103006.thtg)
	e1:SetOperation(c10103006.thop)
	c:RegisterEffect(e1) 
	--to grave
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10103006,1))
	e2:SetCategory(CATEGORY_REMOVE+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,10103106)
	e2:SetTarget(c10103006.sptg)
	e2:SetOperation(c10103006.spop)
	c:RegisterEffect(e2)
end
function c10103006.spfilter(c,e,tp)
	return c:IsSetCard(0x337) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemove() and Duel.IsExistingMatchingCard(c10103006.spfilter2,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp,c:GetCode())
end
function c10103006.spfilter2(c,e,tp,code)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsCode(code)
end
function c10103006.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c10103006.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingTarget(c10103006.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,c10103006.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_HAND)
end
function c10103006.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_REMOVED) then
	   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)   
	   local sg=Duel.SelectMatchingCard(tp,c10103006.spfilter2,tp,LOCATION_DECK+LOCATION_HAND,0,1,1,nil,e,tp,tc:GetCode())
	   if sg:GetCount()>0 then
		  Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
	   end
	end
end
function c10103006.thcon(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(e:GetHandler():GetSummonType(),SUMMON_TYPE_SYNCHRO)==SUMMON_TYPE_SYNCHRO 
end
function c10103006.thfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToHand() and c:IsSetCard(0x337)
end
function c10103006.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c10103006.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c10103006.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c10103006.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c10103006.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SendtoHand(tc,nil,REASON_EFFECT)~=0 then
	   Duel.ConfirmCards(1-tp,tc)
	   local g=Duel.GetMatchingGroup(Card.IsCode,tp,LOCATION_REMOVED,0,nil,tc:GetCode())
	   if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(10103006,2)) then
		  Duel.BreakEffect()
		  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)  
		  local tg=g:Select(tp,1,1,nil)
		  Duel.SendtoHand(tg,nil,REASON_EFFECT)
		  Duel.ConfirmCards(1-tp,tg)
	   end
	end
end