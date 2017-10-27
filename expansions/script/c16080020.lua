--新津 溯月
function c16080020.initial_effect(c)
	--sps
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_BATTLE_DAMAGE)
	e1:SetCondition(c16080020.spcon)
	e1:SetTarget(c16080020.sptg)
	e1:SetOperation(c16080020.spop)
	c:RegisterEffect(e1)
	--tograve
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_CHANGE_POS)
	e2:SetCountLimit(1,16080020)
	e2:SetCondition(c16080020.thcon)
	e2:SetTarget(c16080020.thtg)
	e2:SetOperation(c16080020.thop)
	c:RegisterEffect(e2)
	--Change
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_POSITION)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCountLimit(1)
	e3:SetTarget(c16080020.distg)
	e3:SetOperation(c16080020.disop)
	c:RegisterEffect(e3)
end
function c16080020.spcon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp
end
function c16080020.spfilter(c,e,tp)
	return not c:IsCode(16080020) and c:IsLevelBelow(6) and c:IsSetCard(0x5ca) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c16080020.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMZoneCount(tp)>0 
		and Duel.IsExistingMatchingCard(c16080020.spfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c16080020.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetMZoneCount(tp)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c16080020.spfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c16080020.thcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return not c:IsStatus(STATUS_CONTINUOUS_POS) and c:IsPosition(POS_FACEUP_ATTACK) and c:IsPreviousPosition(POS_FACEUP_DEFENSE)
end
function c16080020.thfilter(c)
	return c:IsSetCard(0x5ca) and c:IsAbleToGrave() and c:IsType(TYPE_MONSTER)
end
function c16080020.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true and Duel.IsExistingMatchingCard(c16080020.thfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK+LOCATION_HAND)
end
function c16080020.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c16080020.thfilter,tp,LOCATION_DECK+LOCATION_HAND,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,nil,REASON_EFFECT)
	end
end
function c16080020.disfilter(c,e)
	return c:IsFaceup() and not c:IsType(TYPE_LINK)
end
function c16080020.distg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(c16080020.disfilter,tp,LOCATION_MZONE,0,1,e:GetHandler(),tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
	local g=Duel.SelectTarget(tp,c16080020.disfilter,tp,LOCATION_MZONE,0,1,1,e:GetHandler(),tp)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,1,0,0)
end
function c16080020.disop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsFaceup() and tc:IsRelateToEffect(e) then
		Duel.ChangePosition(tc,POS_FACEUP_DEFENSE,POS_FACEDOWN_DEFENSE,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK)
	end
end