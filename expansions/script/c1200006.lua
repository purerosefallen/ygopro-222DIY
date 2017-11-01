--LA Da'ath 王冠的梅丹佐
function c1200006.initial_effect(c)
	--des
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetDescription(aux.Stringid(1200006,0))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(c1200006.atktg)
	e2:SetOperation(c1200006.atkop)
	c:RegisterEffect(e2)
	--SpecialSummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetDescription(aux.Stringid(1200006,1))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetTarget(c1200006.target2)
	e1:SetOperation(c1200006.operation2)
	c:RegisterEffect(e1)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(1200006,2))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetCountLimit(1)
	e3:SetCondition(c1200006.spcon)
	e3:SetTarget(c1200006.sptg)
	e3:SetOperation(c1200006.spop)
	c:RegisterEffect(e3)
end
function c1200006.atkfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xfba) and c:IsType(TYPE_MONSTER)
end
function c1200006.refilter(c)
	return c:IsSetCard(0xfba) and c:IsType(TYPE_MONSTER) and c:IsReleasable()
end
function c1200006.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c1200006.refilter,tp,LOCATION_HAND,0,1,nil) and Duel.IsExistingMatchingCard(c1200006.refilter,tp,LOCATION_DECK,0,1,nil) end
end
function c1200006.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not Duel.IsExistingMatchingCard(c1200006.refilter,tp,LOCATION_HAND,0,1,nil) then return false end
	if not Duel.IsExistingMatchingCard(c1200006.refilter,tp,LOCATION_DECK,0,1,nil) then return false end
	local g1=Duel.SelectMatchingCard(tp,c1200006.refilter,tp,LOCATION_HAND,0,1,1,nil)
	local g2=Duel.SelectMatchingCard(tp,c1200006.refilter,tp,LOCATION_DECK,0,1,1,nil)
	g1:Merge(g2)
	local m=g1:GetCount()
	if m>0 then
		Duel.SendtoGrave(g1,REASON_RELEASE+REASON_EFFECT)
		Duel.BreakEffect()
		local sg=Duel.GetMatchingGroup(c1200006.atkfilter,tp,LOCATION_MZONE,0,nil)
		local tc=sg:GetFirst()
		while tc do
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetValue(500)
			e1:SetReset(RESET_EVENT+0x1ff0000)
			tc:RegisterEffect(e1)
			tc=sg:GetNext()
		end
	end
end
function c1200006.filter2(c)
	return c:IsFaceup() and c:GetAttack()~=c:GetBaseAttack()
end
function c1200006.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:GetLocation()==LOCATION_MZONE and c1200006.filter2(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c1200006.filter2,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(1200006,2))
	local g=Duel.SelectTarget(tp,c1200006.filter2,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
end
function c1200006.operation2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsLocation(LOCATION_HAND) then
		if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP) then
			if tc and tc:IsFaceup() and tc:IsRelateToEffect(e) and tc:IsLocation(LOCATION_MZONE) then
				Duel.BreakEffect()
				Duel.Destroy(tc,REASON_EFFECT)
			end
		end
	end
end
function c1200006.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsReason(REASON_EFFECT+REASON_BATTLE) and c:IsPreviousLocation(LOCATION_MZONE) and c:GetPreviousAttackOnField()>c:GetBaseAttack()
end
function c1200006.spfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsSetCard(0xfba) and c:IsType(TYPE_MONSTER)
end
function c1200006.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp)
		and chkc:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
		and Duel.IsExistingTarget(c1200006.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c1200006.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c1200006.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end













