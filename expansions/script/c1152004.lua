--高贵与罪恶的红月
function c1152004.initial_effect(c)
--
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,c1152004.matfilter,1)
--  
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetOperation(c1152004.op1)
	c:RegisterEffect(e1)
--
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetTarget(c1152004.tg2)
	e2:SetOperation(c1152004.op2)
	c:RegisterEffect(e2)
--
end
--
c1152004.named_with_Fulan=1
function c1152004.IsFulan(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Fulan
end
function c1152004.IsFulsp(c)
	local m=_G["c"..c:GetCode()]
	return c.named_with_Fulsp
end
--
function c1152004.matfilter(c)
	return c:IsRace(RACE_FIEND)
end
--
function c1152004.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local lg=c:GetLinkedGroup()
	local tc=lg:GetFirst()
	while tc do
		if not tc:IsDisabled() then
			Duel.NegateRelatedChain(tc,RESET_TURN_SET)
			local e1_1=Effect.CreateEffect(tc)
			e1_1:SetType(EFFECT_TYPE_SINGLE)
			e1_1:SetCode(EFFECT_DISABLE)
			e1_1:SetReset(RESET_EVENT+0x1fe0000)
			tc:RegisterEffect(e1_1)
			local e2_1=Effect.CreateEffect(tc)
			e2_1:SetType(EFFECT_TYPE_SINGLE)
			e2_1:SetCode(EFFECT_DISABLE_EFFECT)
			e2_1:SetValue(RESET_TURN_SET)
			e2_1:SetReset(RESET_EVENT+0x1fe0000)
			tc:RegisterEffect(e2_1)
			Duel.BreakEffect()
			if Duel.Destroy(tc,REASON_EFFECT)~=0 then
				Duel.Draw(tc:GetOwner(),1,REASON_EFFECT)
			end
		end
		tc=lg:GetNext()
	end
end
--
function c1152004.tfilter2(c,e)
	return c:IsType(TYPE_SPELL) and c:IsFaceup() and not c:IsImmuneToEffect(e) and not c:IsCode(1152999)
end
function c1152004.tg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c1152004.tfilter2,tp,LOCATION_ONFIELD,0,2,nil,e) and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,tp,LOCATION_GRAVE)
end
--
function c1152004.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c1152004.tfilter2,tp,LOCATION_ONFIELD,0,nil,e)
	if g and g:GetCount()>0 and Duel.Destroy(g,REASON_EFFECT)~=0 and c:IsLocation(LOCATION_GRAVE) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
--