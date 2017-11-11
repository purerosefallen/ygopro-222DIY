--秘谈·时令的欢舞
function c1111012.initial_effect(c)
--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c1111012.tg1)
	e1:SetOperation(c1111012.op1)
	c:RegisterEffect(e1)
--  
end
--
function c1111012.IsLq(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Lq
end
--
function c1111012.tfilter1(c,e,tp)
	return c:IsType(TYPE_MONSTER) and c:IsType(TYPE_SPIRIT) and c:GetLevel()<4 and c:IsCanBeSpecialSummoned(e,0,tp,true,true) and not c:IsType(TYPE_XYZ) and not c:IsType(TYPE_LINK)
end
function c1111012.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
		local num=Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)
		if e:GetHandler():IsLocation(LOCATION_HAND) then 
			num=num-1 
		end
		return num>0 and Duel.IsExistingMatchingCard(c1111012.tfilter1,tp,LOCATION_GRAVE,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
--
function c1111012.ofilter1(c)
	return c:IsType(TYPE_SPELL) and c:IsType(TYPE_CONTINUOUS) and c:IsCanAddCounter(0x1111,1) and c:IsFaceup() and c1111012.IsLq(c)
end
function c1111012.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
	local num=Duel.SendtoGrave(g,REASON_EFFECT)
	if num>0 then
		local num2=Duel.GetLocationCount(tp,LOCATION_MZONE)
		if num>num2 then
			num=num2
		end
		if Duel.IsPlayerAffectedByEffect(tp,59822133) then
			num=1
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)	
		local g2=Duel.SelectMatchingCard(tp,c1111012.tfilter1,tp,LOCATION_GRAVE,0,1,num,nil,e,tp)
		if g2:GetCount()>0 then
			if Duel.SpecialSummon(g2,0,tp,tp,true,true,POS_FACEUP)~=0 and Duel.IsExistingMatchingCard(c1111012.ofilter1,tp,LOCATION_ONFIELD,0,1,nil) then
				Duel.BreakEffect()
				local g3=Duel.GetMatchingGroup(c1111012.ofilter1,tp,LOCATION_ONFIELD,0,nil)
				if g3:GetCount()>0 then
					local tc3=g3:GetFirst()
					while tc3 do
						tc3:AddCounter(0x1111,1)
						tc3=g3:GetNext()
					end
				end
			end
		end
	end
end
--