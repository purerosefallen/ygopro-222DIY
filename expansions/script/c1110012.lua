--梅露兰·普莉兹姆利巴
function c1110012.initial_effect(c)
--
	c:EnableReviveLimit()
--
	aux.EnableSpiritReturn(c,EVENT_SPSUMMON_SUCCESS)
--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1)
--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_HAND)
	e2:SetCondition(c1110012.con2)
	e2:SetOperation(c1110012.op2)
	c:RegisterEffect(e2)
--
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(1110012,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_COUNTER)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCountLimit(1,1110012)
	e3:SetTarget(c1110012.tg3)
	e3:SetOperation(c1110012.op3)
	c:RegisterEffect(e3)
--
end
--
c1110012.named_with_Prismriver=1
--
function c1110012.IsLq(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Lq
end
function c1110012.IsPrismriver(c)
	local m=_G["c"..c:GetCode()]
	return c.named_with_Prismriver
end
--
function c1110012.cfilter2(c)
	return ((c:IsType(TYPE_SPELL) and c:IsType(TYPE_CONTINUOUS) and c1110012.IsLq(c)) or (c:IsType(TYPE_SPIRIT) and c:IsType(TYPE_MONSTER))) and c:IsAbleToRemoveAsCost()
end
function c1110012.con2(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c1110012.cfilter2,tp,LOCATION_GRAVE,0,1,nil)
end
--
function c1110012.op2(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c1110012.cfilter2,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
--
function c1110012.tfilter3(c,e,tp)
	return c:IsType(TYPE_SPIRIT) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,true,true)
end
function c1110012.tg3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c1110012.tfilter3,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
--
function c1110012.ofilter3(c)
	return c:IsCanAddCounter(0x1111,1) and c:IsFaceup() and c:IsType(TYPE_SPELL) and c:IsType(TYPE_CONTINUOUS)
end
function c1110012.op3(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c1110012.tfilter3,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		local tc=g:GetFirst()
		if Duel.SpecialSummon(tc,0,tp,tp,true,true,POS_FACEUP)~=0 then
			local e3_1=Effect.CreateEffect(c)
			e3_1:SetType(EFFECT_TYPE_SINGLE)
			e3_1:SetCode(EFFECT_DISABLE)
			e3_1:SetReset(RESET_EVENT+0x1fe0000)
			tc:RegisterEffect(e3_1,true)
			local e3_2=Effect.CreateEffect(c)
			e3_2:SetType(EFFECT_TYPE_SINGLE)
			e3_2:SetCode(EFFECT_DISABLE_EFFECT)
			e3_2:SetReset(RESET_EVENT+0x1fe0000)
			tc:RegisterEffect(e3_2,true)
			Duel.SpecialSummonComplete()
			if Duel.IsExistingMatchingCard(c1110012.ofilter3,tp,LOCATION_ONFIELD,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(1110012,1)) then
				Duel.BreakEffect()
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELF)
				local g2=Duel.SelectMatchingCard(tp,c1110012.ofilter3,tp,LOCATION_ONFIELD,0,1,1,nil)
				if g2:GetCount()>0 then
					local tc2=g2:GetFirst()
					tc2:AddCounter(0x1111,1)
				end
			end
		end
	end
end
--
