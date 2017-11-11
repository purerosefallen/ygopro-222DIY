--U.N.OWEN就是她吗？
function c1152999.initial_effect(c)
--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(c1152999.op1)
	c:RegisterEffect(e1)
--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTarget(c1152999.tg2)
	e2:SetOperation(c1152999.op2)
	c:RegisterEffect(e2)
--
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_REMOVE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTarget(c1152999.tg3)
	e3:SetOperation(c1152999.op3)
	c:RegisterEffect(e3)   
-- 
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_PHASE+PHASE_END)
	e4:SetRange(LOCATION_SZONE)
	e4:SetTarget(c1152999.tg4)
	e4:SetOperation(c1152999.op4)
	c:RegisterEffect(e4)
--
end
--
function c1152999.IsFulan(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Fulan
end
c1152999.named_with_Fulsp=1
function c1152999.IsFulsp(c)
	local m=_G["c"..c:GetCode()]
	return c.named_with_Fulsp
end
--
function c1152999.ofilter1(c,e,tp)
	return c1152999.IsFulan(c) and c:IsFaceup() and c:IsAbleToHand()
end
function c1152999.op1(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(c1152999.ofilter1,tp,LOCATION_ONFIELD,0,nil)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(1152999,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
		local sg=g:Select(tp,1,1,nil)
		if Duel.SendtoHand(sg,nil,REASON_EFFECT)~=0 then
			Duel.ConfirmCards(1-tp,sg)
			local e1_1=Effect.CreateEffect(e:GetHandler())
			e1_1:SetType(EFFECT_TYPE_SINGLE)
			e1_1:SetCode(EFFECT_IMMUNE_EFFECT)
			e1_1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
			e1_1:SetRange(LOCATION_SZONE)
			e1_1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
			e1_1:SetValue(c1152999.efilter1_1)
			e:GetHandler():RegisterEffect(e1_1)
		end
	end
end
function c1152999.efilter1_1(e,te)
	return te:GetOwner()~=e:GetOwner()
end
--
function c1152999.cfilter2(c)
	return c:IsPreviousLocation(LOCATION_HAND)
end
function c1152999.tfilter2(c)
	return (c:IsType(TYPE_SPELL) or c:IsType(TYPE_TRAP)) and c1152999.IsFulsp(c) and c:IsSSetable() 
end
function c1152999.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c1152999.tfilter2,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and e:GetHandler():GetFlagEffect(1152997)==0 end
end
--
function c1152999.op2(e,tp,eg,ep,ev,re,r,rp,c)
	if eg:IsExists(c1152999.cfilter2,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(1152999,1)) then
		e:GetHandler():RegisterFlagEffect(1152997,RESET_PHASE+PHASE_END,0,1)
		if not e:GetHandler():IsHasEffect(EFFECT_NECRO_VALLEY) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
			local g=Duel.SelectMatchingCard(tp,c1152999.tfilter2,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
			if g:GetCount()>0 and Duel.SSet(tp,g)~=0 then
				Duel.ConfirmCards(1-tp,g)
			end
		end
	end
end
--
function c1152999.cfilter3(c)
	return (c:IsType(TYPE_SPELL) or c:IsType(TYPE_TRAP)) and c1152999.IsFulsp(c)
end
function c1152999.tfilter3(c)
	return (c:IsType(TYPE_SPELL) or c:IsType(TYPE_TRAP)) and c1152999.IsFulsp(c) and c:IsDestructable()
end
function c1152999.tg3(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c1152999.tfilter3,tp,LOCATION_DECK,0,1,nil) and e:GetHandler():GetFlagEffect(1152997)~=0 and e:GetHandler():GetFlagEffect(1152998)==0 end
end
--
function c1152999.op3(e,tp,eg,ep,ev,re,r,rp,c)
	if eg:IsExists(c1152999.cfilter3,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(1152999,2)) then
		e:GetHandler():RegisterFlagEffect(1152998,RESET_PHASE+PHASE_END,0,1)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local g=Duel.SelectMatchingCard(tp,c1152999.tfilter3,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.Destroy(g,REASON_EFFECT)
		end
	end
end
--
function c1152999.tg4(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return e:GetHandler():IsAbleToDeck() and e:GetHandler():GetFlagEffect(1152997)~=0 and e:GetHandler():GetFlagEffect(1152998)~=0 end
end
--
function c1152999.ofilter4(c)
	return c:IsFaceup() and c:GetOriginalRace()==RACE_FIEND and c:GetOriginalType()==TYPE_MONSTER and c:IsAbleToDeck()
end
function c1152999.op4(e,tp,eg,ep,ev,re,r,rp)
	if Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_EFFECT)~=0 then
		if Duel.IsExistingMatchingCard(c1152999.ofilter4,tp,LOCATION_ONFIELD,0,1,nil) then
			local g=Duel.SelectMatchingCard(tp,c1152999.ofilter4,tp,LOCATION_ONFIELD,0,1,1,nil)
			if g:GetCount()>0 then
				Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
			end
		end
	end
end
