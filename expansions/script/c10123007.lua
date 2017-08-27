--夏恋·天堂
function c10123007.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(c10123007.activate)
	c:RegisterEffect(e1) 
	--tohand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10123007,1))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_SZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1)
	e2:SetTarget(c10123007.thtg)
	e2:SetOperation(c10123007.thop)
	c:RegisterEffect(e2)	
end
function c10123007.thfilter(c,eg,e,tp)
	return c:GetPreviousControler()==tp and c:IsControler(tp) and c:IsLocation(LOCATION_GRAVE)
		and bit.band(c:GetReason(),0x80008)==0x80008 and c:IsAbleToHand() and c:IsCanBeEffectTarget(e) and eg:IsExists(c10123007.thfilter2,1,nil,c,tp)
end
function c10123007.thfilter2(c,mc,tp)
	local mg=c:GetMaterial()
	return c:GetSummonType()==SUMMON_TYPE_SYNCHRO and mc:GetReasonCard()==c and mg:GetCount()>0 and mg:IsExists(c10123007.thfilter3,1,nil,tp)
end
function c10123007.thfilter3(c,tp)
	return c:GetPreviousControler()==tp and c:IsPreviousLocation(LOCATION_MZONE) and c:IsSetCard(0x5334)
end
function c10123007.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return c10123007.thfilter(chkc,eg,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(c10123007.thfilter,tp,LOCATION_GRAVE,0,1,nil,eg,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c10123007.thfilter,tp,LOCATION_GRAVE,0,1,1,nil,eg,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,LOCATION_GRAVE)
end
function c10123007.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end
function c10123007.filter(c)
	return c:IsRace(RACE_SPELLCASTER) and c:IsSummonable(true,nil)
end
function c10123007.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(c10123007.filter,tp,LOCATION_HAND,0,nil)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(10123007,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
		local sg=g:Select(tp,1,1,nil)
		Duel.Summon(tp,sg:GetFirst(),true,nil)
	end
end
