--幽禁之间·芙兰朵露
function c1152002.initial_effect(c)
--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c1152002.con1)
	e1:SetTarget(c1152002.tg1)
	e1:SetOperation(c1152002.op1)
	c:RegisterEffect(e1)
--
	local e2=Effect.CreateEffect(c)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL+EFFECT_FLAG_DELAY)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetCondition(c1152002.con2)
	e2:SetTarget(c1152002.tg2)
	e2:SetOperation(c1152002.op2)
	c:RegisterEffect(e2)	
--
end
--
c1152002.named_with_Fulan=1
function c1152002.IsFulan(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Fulan
end
c1152002.named_with_Fulsp=1
function c1152002.IsFulsp(c)
	local m=_G["c"..c:GetCode()]
	return c.named_with_Fulsp
end
--
function c1152002.con1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2
end
--
function c1152002.tfilter1(c)
	return ((c:IsRace(RACE_FIEND) and c:IsType(TYPE_MONSTER)) or (c:IsType(TYPE_SPELL) and c:IsFaceup())) and c:IsDestructable()
end
function c1152002.tg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingTarget(c1152002.tfilter1,tp,LOCATION_ONFIELD,0,1,nil) and Duel.GetFlagEffect(tp,1152000)==0 end
	Duel.RegisterFlagEffect(tp,1152000,RESET_CHAIN,0,1)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,0,LOCATION_ONFIELD)
end
--
function c1152002.op1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c1152002.tfilter1,tp,LOCATION_ONFIELD,0,1,1,nil)
	if g:GetCount()>0 then
		local tc=g:GetFirst()
		if Duel.Destroy(tc,REASON_EFFECT)~=0 then
			if Duel.GetFlagEffect(tp,1152002)==0 and Duel.GetFlagEffect(1-tp,1152002)==0 then
				Duel.RegisterFlagEffect(tp,1152002,RESET_PHASE+PHASE_END,0,1)
				local e1_1=Effect.CreateEffect(tc)
				e1_1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
				e1_1:SetCode(EVENT_PHASE+PHASE_END)
				e1_1:SetCountLimit(1)
				e1_1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
				e1_1:SetRange(LOCATION_GRAVE)
				e1_1:SetOperation(c1152002.op1_1)
				tc:RegisterEffect(e1_1,true)			
			end
			if e:GetHandler():IsLocation(LOCATION_HAND) and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.SelectYesNo(tp,aux.Stringid(1152002,0)) then
				Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP)
			end
		end
	end
end
function c1152002.op1_1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	if not c:IsHasEffect(EFFECT_NECRO_VALLEY) then
		if Duel.SelectYesNo(tp,aux.Stringid(1152002,1)) then
			Duel.SendtoHand(c,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,c)	   
		end
	end
end
--
function c1152002.con2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsPreviousPosition(POS_FACEUP)
end
--
function c1152002.tfilter2(c,e,tp)
	return c1152002.IsFulan(c) and (c:IsType(TYPE_SPELL) or c:IsType(TYPE_TRAP)) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c1152002.tg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c1152002.tfilter2,tp,LOCATION_SZONE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,LOCATION_SZONE)
end
--
function c1152002.op2(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local tg=Duel.GetMatchingGroup(c1152002.tfilter2,tp,LOCATION_SZONE,0,nil,e,tp)  
	if ft<=0 or tg:GetCount()==0 then return end
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=tg:Select(tp,ft,ft,nil)
	local tc=g:GetFirst()
	while tc do
		Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
		tc=g:GetNext()
	end
	Duel.SpecialSummonComplete()
end
