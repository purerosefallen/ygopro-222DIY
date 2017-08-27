--灵都少女·苜
function c1110002.initial_effect(c)
--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCost(c1110002.cost1)
	e1:SetOperation(c1110002.op1)
	c:RegisterEffect(e1)
--
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1,1110002)
	e2:SetCost(c1110002.cost2)
	e2:SetTarget(c1110002.tg2)
	e2:SetOperation(c1110002.op2)
	c:RegisterEffect(e2)
end
--
c1110002.named_with_Ld=1
function c1110002.IsLd(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Ld
end
--
function c1110002.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,800) end
	Duel.PayLPCost(tp,800)
end
function c1110002.op1(e,tp,eg,ep,ev,re,r,rp)
	local e1_1=Effect.CreateEffect(e:GetHandler())
	e1_1:SetType(EFFECT_TYPE_FIELD)
	e1_1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1_1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1_1:SetTargetRange(0,1)
	e1_1:SetValue(c1110002.limit1_1)
	e1_1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1_1,tp)
end
function c1110002.limit1_1(e,re,tp)
	return not re:GetHandler():IsLocation(LOCATION_ONFIELD)
end
--
function c1110002.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	if Duel.SelectYesNo(tp,aux.Stringid(1110002,1)) then
		local e2_1=Effect.CreateEffect(e:GetHandler())
		e2_1:SetType(EFFECT_TYPE_FIELD)
		e2_1:SetCode(EFFECT_CHANGE_DAMAGE)
		e2_1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e2_1:SetTargetRange(0,1)
		e2_1:SetValue(0)
		e2_1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e2_1,tp)
		e:SetLabel(1)
	end
end
--
function c1110002.tfilter2(c)
	return c:IsCode(1110001) and c:IsFaceup()
end
function c1110002.tg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c1110002.tfilter2,tp,LOCATION_MZONE,0,1,nil) and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,LOCATION_HAND)
	if e:GetLabel() and e:GetLabel()==1 then
	   Duel.SetChainLimit(c1110002.limit2)
	end
end
function c1110002.limit2(e,ep,tp)
	return tp==ep
end
--
function c1110002.ofilter2(c)
	return c1110002.IsLd(c) and c:IsType(TYPE_SPELL) and c:IsType(TYPE_FIELD) and c:IsSSetable()
end
function c1110002.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 and Duel.GetMatchingGroupCount(c1110002.ofilter2,tp,LOCATION_DECK,0,nil)>0 and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.SelectYesNo(tp,aux.Stringid(1110002,0)) then  
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
			local g2=Duel.SelectMatchingCard(tp,c1110002.ofilter2,tp,LOCATION_DECK,0,1,1,nil,e,tp)
			if g2:GetCount()>0 then
				local tc=g2:GetFirst()
				Duel.SSet(tp,tc)
				Duel.ConfirmCards(1-tp,tc)
			end
		end
	end
end