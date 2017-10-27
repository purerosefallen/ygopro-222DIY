--ELF·宝石妖精
function c1190006.initial_effect(c)
--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetCountLimit(1,1190006)
	e1:SetCondition(c1190006.con1)
	e1:SetTarget(c1190006.tg1)
	e1:SetOperation(c1190006.op1)
	c:RegisterEffect(e1)
--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(1190006,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_HAND)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,1190056)
	e2:SetCondition(c1190006.con2)
	e2:SetTarget(c1190006.tg2)
	e2:SetOperation(c1190006.op2)
	c:RegisterEffect(e2)	
end
--
c1190006.named_with_ELF=1
function c1190006.IsELF(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_ELF
end
--
function c1190006.cfilter(c)
	return c:IsFaceup() and c1190006.IsELF(c) and c:IsType(TYPE_SYNCHRO)
end
function c1190006.confilter(c)
	return c:IsFaceup() and c1190006.IsELF(c) and c:IsType(TYPE_TUNER) and c:GetLevel()==2 and not c:IsCode(1190016)
end
function c1190006.con1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c1190006.cfilter,tp,LOCATION_MZONE,0,1,nil) and Duel.IsExistingMatchingCard(c1190006.confilter,tp,LOCATION_MZONE,0,1,nil)
end
--
function c1190006.tg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c1190006.cfilter,tp,LOCATION_MZONE,0,1,nil) and Duel.IsExistingMatchingCard(c1190006.confilter,tp,LOCATION_MZONE,0,1,nil) and Duel.GetMZoneCount(tp)>0 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
--
function c1190006.filter(c)
	return c1190006.IsELF(c) and c:IsAbleToGrave()
end
function c1190006.filter1(c)
	return c:IsCode(1191001) and c:IsAbleToHand()
end
function c1190006.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
		local g=Duel.GetMatchingGroup(c1190006.filter,tp,LOCATION_HAND,0,nil)
		local g2=Duel.GetMatchingGroup(c1190006.filter1,tp,LOCATION_DECK,0,nil)
		if g:GetCount()>0 and g2:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(1190006,0)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
			local g3=Duel.SelectMatchingCard(tp,c1190006.filter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
			if g3:GetCount()>0 then
				local tc2=g3:GetFirst()
				Duel.SendtoGrave(g3,REASON_EFFECT)
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
				local g4=Duel.SelectMatchingCard(tp,c1190006.filter1,tp,LOCATION_DECK,0,1,1,nil,e,tp)
				if g4:GetCount()>0 then
					Duel.SendtoHand(g4,tp,REASON_EFFECT)
				end
			end
		end
	end
end
--
--
function c1190006.con2(e,tp,eg,ep,ev,re,r,rp)
	return ((e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
		and e:GetHandler():IsPreviousPosition(POS_FACEUP)) or e:GetHandler():IsPreviousLocation(LOCATION_GRAVE))
end
function c1190006.filter2(c,e,tp)
	return c:IsCode(1190013) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c1190006.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMZoneCount(tp)>0
		and Duel.IsExistingMatchingCard(c1190006.filter2,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,LOCATION_DECK)
end
function c1190006.op2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetMZoneCount(tp)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c1190006.filter2,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
