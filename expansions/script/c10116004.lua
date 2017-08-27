--光与暗的自由面
function c10116004.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c10116004.cost)
	e1:SetTarget(c10116004.target)
	e1:SetOperation(c10116004.activate)
	c:RegisterEffect(e1)	
end

function c10116004.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=nil
	if e:GetLabel()==1 then
	   g=Duel.SelectMatchingCard(tp,c10116004.sfilter1,tp,LOCATION_DECK+LOCATION_HAND,0,1,1,nil,e,tp)
	elseif e:GetLabel()==2 then
	   g=Duel.SelectMatchingCard(tp,c10116004.sfilter2,tp,LOCATION_DECK+LOCATION_HAND,0,1,1,nil,e,tp)
	end
	if g and g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end

function c10116004.filter1(c,e,tp)
	return c:IsFaceup() and c:IsSetCard(0x3331) and c:IsAbleToDeckAsCost()
		and Duel.IsExistingMatchingCard(c10116004.sfilter1,tp,LOCATION_DECK+LOCATION_HAND,0,1,nil,e,tp)
end

function c10116004.sfilter1(c,e,tp)
	return c:GetLevel()==4 and c:IsRace(RACE_WARRIOR) and c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end

function c10116004.filter2(c,e,tp)
   return c:IsFaceup() and c:GetLevel()==4 and c:IsRace(RACE_WARRIOR) and c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsAbleToDeckAsCost() and Duel.IsExistingMatchingCard(c10116004.sfilter2,tp,LOCATION_DECK+LOCATION_HAND,0,1,nil,e,tp)
end

function c10116004.sfilter2(c,e,tp)
	return c:IsSetCard(0x3331) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end

function c10116004.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g1=Duel.GetMatchingGroup(c10116004.filter1,tp,LOCATION_MZONE,0,nil,e,tp)
	local g2=Duel.GetMatchingGroup(c10116004.filter2,tp,LOCATION_MZONE,0,nil,e,tp)
	if chk==0 then
		if e:GetLabel()~=100 then return false end
		e:SetLabel(0)
		return g1:GetCount()>0 or g2:GetCount()>0
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EFFECT)
	local op=0
	if g1:GetCount()>0 and g2:GetCount()>0 then
	  op=Duel.SelectOption(tp,aux.Stringid(10116004,0),aux.Stringid(10116004,1))
	elseif g1:GetCount()<0 then
	  op=Duel.SelectOption(tp,aux.Stringid(10116004,1))
	  op=1
	else 
	  op=Duel.SelectOption(tp,aux.Stringid(10116004,0))
	end
	  e:SetLabel(op+1)
	  local g=nil
	  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	  if op==0 then
		g=Duel.SelectMatchingCard(tp,c10116004.filter1,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	  else
		g=Duel.SelectMatchingCard(tp,c10116004.filter2,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	  end
		Duel.SendtoDeck(g,nil,2,REASON_COST)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
end

function c10116004.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	return true
end