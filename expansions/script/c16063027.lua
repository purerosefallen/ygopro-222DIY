--wuluwulusalaana--
function c16063027.initial_effect(c)
	--Destroy+serach
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1,16063027)
	e1:SetTarget(c16063027.destg)
	e1:SetOperation(c16063027.desop)
	c:RegisterEffect(e1)
	--SpecialSummon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCountLimit(1,16063027)
	e2:SetCondition(c16063027.thcon)
	e2:SetTarget(c16063027.thtg)
	e2:SetOperation(c16063027.thop)
	c:RegisterEffect(e2)
end
function c16063027.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD) 
end
function c16063027.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDiscardDeck(tp,1)
		and Duel.GetMZoneCount(tp)>0
		and not Duel.IsPlayerAffectedByEffect(tp,EFFECT_CANNOT_SPECIAL_SUMMON) end
end
function c16063027.thop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsPlayerCanDiscardDeck(tp,1) then return end
	Duel.ConfirmDecktop(tp,1)
	local tc=Duel.GetDecktopGroup(tp,1):GetFirst()
	Duel.DisableShuffleCheck()
	if tc:IsSetCard(0x5c5) and tc:IsCanBeSpecialSummoned(e,0,tp,false,false) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	else
		Duel.SendtoGrave(tc,REASON_EFFECT+REASON_REVEAL)
	end
end
function c16063027.dfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsDestructable()
end
function c16063027.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and chkc:IsControler(1-tp) and c16063027.dfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c16063027.dfilter,tp,LOCATION_ONFIELD,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c16063027.dfilter,tp,LOCATION_ONFIELD,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c16063027.thfilter(c)
   return c:IsSetCard(0x5c5) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c16063027.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c16063027.thfilter,tp,LOCATION_GRAVE+LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		end
	end
end