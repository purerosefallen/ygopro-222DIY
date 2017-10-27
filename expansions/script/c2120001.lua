--铁血人形-稻草人
function c2120001.initial_effect(c)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(2120001,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetRange(LOCATION_HAND)
	e2:SetCondition(c2120001.spcon)
	e2:SetCost(c2120001.spcost)
	e2:SetTarget(c2120001.sptg)
	e2:SetOperation(c2120001.spop)
	c:RegisterEffect(e2)
	--Remove
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e3:SetTarget(c2120001.rmtg)
	e3:SetOperation(c2120001.rmop)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e4)
end
function c2120001.spcon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp
end
function c2120001.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c2120001.filter(c,e,tp)
	return c:IsSetCard(0x5219) and c:IsLevelAbove(6) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c2120001.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMZoneCount(tp)>0
		and Duel.IsExistingMatchingCard(c2120001.filter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,LOCATION_DECK)
end
function c2120001.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetMZoneCount(tp)<=0 then return end
	if Duel.NegateAttack() then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c2120001.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
		if g:GetCount()>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
function c2120001.rmfilter(c)
	return c:IsFaceup() and c:IsAbleToRemove()
end
function c2120001.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and chkc:IsControler(1-tp) and c2120001.rmfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c2120001.rmfilter,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,c2120001.rmfilter,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c2120001.rmop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		if Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)~=0 then
			local dam=Duel.GetFieldGroupCount(1-tp,LOCATION_REMOVED,LOCATION_REMOVED)*200
			Duel.Damage(1-tp,dam,REASON_EFFECT)
		end
	end
end