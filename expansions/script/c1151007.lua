--红色的夜行恶魔·蕾米莉亚
function c1151007.initial_effect(c)
--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_REMOVE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,1151007)
	e1:SetTarget(c1151007.tg1)
	e1:SetOperation(c1151007.op1)
	c:RegisterEffect(e1)
--  
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,1151008)
	e2:SetCost(c1151007.cost2)
	e2:SetTarget(c1151007.tg2)
	e2:SetOperation(c1151007.op2)
	c:RegisterEffect(e2)
--
end
--
c1151007.named_with_Leimi=1
function c1151007.IsLeimi(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Leimi
end
function c1151007.IsLeisp(c)
	local m=_G["c"..c:GetCode()]
	return c.named_with_Leisp
end
--
function c1151007.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMZoneCount(tp)>0 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,LOCATION_REMOVED)
end
--
function c1151007.ofilter1(c)
	return c1151007.IsLeisp(c)
end
function c1151007.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 and Duel.IsExistingMatchingCard(c1151007.ofilter1,tp,LOCATION_DECK,0,1,nil) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(1151007,0))
			local g=Duel.SelectMatchingCard(tp,c1151007.ofilter1,tp,LOCATION_DECK,0,1,1,nil)
			if g:GetCount()>0 then
				local tc=g:GetFirst()
				Duel.ShuffleDeck(tp)
				Duel.MoveSequence(tc,0)
				Duel.ConfirmDecktop(tp,1)
			end
		end
	end
end
--
function c1151007.cfilter2(c)
	return c:IsType(TYPE_MONSTER)
end
function c1151007.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c1151007.cfilter2,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectReleaseGroup(tp,c1151007.cfilter2,1,1,nil)
	if g:GetCount()>0 then
		Duel.Release(g,REASON_EFFECT)
	end 
end
--
function c1151007.tfilter2(c)
	return c:IsCode(1151999) and c:IsFaceup()
end
function c1151007.tfilter2x1(c,e,tp)
	return c:IsRace(RACE_FIEND) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c1151007.tfilter2x2(c,e,tp)
	return c:IsRace(RACE_FIEND) and c:GetLevel()<5 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c1151007.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if Duel.IsExistingMatchingCard(c1151007.tfilter2,tp,LOCATION_ONFIELD,0,1,nil) then
			return Duel.IsExistingMatchingCard(c1151007.tfilter2x1,tp,LOCATION_GRAVE,0,1,nil,e,tp) or Duel.IsExistingMatchingCard(c1151007.tfilter2x2,tp,LOCATION_GRAVE,0,1,nil,e,tp)
		else
			return Duel.IsExistingMatchingCard(c1151007.tfilter2x1,tp,LOCATION_GRAVE,0,1,nil,e,tp)
		end
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
--
function c1151007.op2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsExistingMatchingCard(c1151007.tfilter2,tp,LOCATION_ONFIELD,0,1,nil) then  
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g1=Duel.GetMatchingGroup(c1151007.tfilter2x1,tp,LOCATION_GRAVE,0,nil,e,tp)
		local g2=Duel.GetMatchingGroup(c1151007.tfilter2x2,tp,LOCATION_DECK,0,nil,e,tp)
		g1:Merge(g2)
		if g1:GetCount()>0 then
			local g=g1:Select(tp,1,1,nil,e,tp) 
			if g:GetCount()>0 then
				Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
			end
		end
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c1151007.tfilter2x1,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
		if g:GetCount()>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end