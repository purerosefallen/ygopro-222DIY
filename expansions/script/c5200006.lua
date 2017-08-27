--剑精灵-艾斯特
function c5200006.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(5200006,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_POSITION)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,5200006)
	e1:SetTarget(c5200006.sptg)
	e1:SetOperation(c5200006.spop)
	c:RegisterEffect(e1)
	--equipt
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(5200006,1))
	e2:SetCategory(CATEGORY_EQUIP)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCountLimit(1,52000062)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_CHAIN_UNIQUE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetHintTiming(TIMING_BATTLE_START+TIMING_BATTLE_END,TIMING_BATTLE_START+TIMING_BATTLE_END)
	e2:SetTarget(c5200006.target)
	e2:SetOperation(c5200006.operation)
	c:RegisterEffect(e2)
end
function c5200006.spfilter(c)
	return c:IsFaceup() and c:IsCode(5200001)
end
function c5200006.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c5200006.spfilter,tp,LOCATION_MZONE,0,1,nil,POS_FACEUP_ATTACK)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,true,false,POS_FACEUP) end
	local g=Duel.GetMatchingGroup(Card.IsPosition,tp,0,LOCATION_MZONE,nil,POS_FACEUP_ATTACK)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,g:GetCount(),0,0)
end
function c5200006.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP_ATTACK)~=0 
	and Duel.SelectYesNo(tp,aux.Stringid(5200006,0)) then
		Duel.BreakEffect() 
		local g=Duel.GetMatchingGroup(Card.IsPosition,tp,0,LOCATION_MZONE,nil,POS_FACEUP_ATTACK)
		Duel.ChangePosition(g,POS_FACEUP_DEFENSE)
	elseif Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP) then
		Duel.SendtoGrave(c,REASON_RULE)
	end
end
function c5200006.tcfilter(c)
	return c:IsFaceup() and (c:IsCode(5200001) or c:IsCode(5200011))
end
function c5200006.eqfilter(c)
	return c:IsType(TYPE_EQUIP) and c:IsCode(5200020)
end
function c5200006.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:GetLocation()==LOCATION_MZONE and chkc:IsControler(tp) and c5200006.tcfilter(chkc) end
	local ph=Duel.GetCurrentPhase()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and e:GetHandler():IsReleasable()
		and Duel.IsExistingTarget(c5200006.tcfilter,tp,LOCATION_MZONE,0,1,nil) and  (ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE)
		and Duel.IsExistingMatchingCard(c5200006.eqfilter,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(5200006,1))
	Duel.SelectTarget(tp,c5200006.tcfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE)
end
function c5200006.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then 
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
		local g=Duel.SelectMatchingCard(tp,c5200006.eqfilter,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,c)
		if g:GetCount()>0 and Duel.Release(e:GetHandler(),REASON_EFFECT)>0 then
			Duel.Equip(tp,g:GetFirst(),tc)
		end
	end
end

