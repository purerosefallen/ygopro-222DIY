--传颂之中章
function c16063002.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,16063002+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c16063002.target)
	e1:SetOperation(c16063002.activate)
	c:RegisterEffect(e1)
	--tohand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(16063002,0))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCondition(c16063002.thcon)
	e2:SetTarget(c16063002.thtg)
	e2:SetOperation(c16063002.thop)
	c:RegisterEffect(e2)
end
function c16063002.desfilter(c,e,tp)
	local lv=c:GetLevel()
	return  c:IsDestructable()
	and Duel.IsExistingMatchingCard(c16063002.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp,lv)
end
function c16063002.spfilter(c,e,tp,lv)
	return c:GetLevel()==lv and c:IsSetCard(0x5c5) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c16063002.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return c16063002.desfilter(chkc,e,tp) and chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) end
	if chk==0 then return Duel.GetMZoneCount(tp)>-1
		and Duel.IsExistingTarget(c16063002.desfilter,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c16063002.desfilter,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c16063002.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local lv=tc:GetLevel()
	if  tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)>0 then
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c16063002.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp,lv)
		if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
end
function c16063002.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD) and e:GetHandler():IsReason(REASON_DESTROY)
end
function c16063002.thfilter(c)
	return c:IsSetCard(0x5c5) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c16063002.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return  Duel.IsExistingMatchingCard(c16063002.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,0)
end
function c16063002.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c16063002.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end