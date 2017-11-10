--廓尔喀的煌龙鹰
function c10173063.initial_effect(c)
	--SpecialSummon1
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10173063,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1,10173263)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTarget(c10173063.sptg)
	e1:SetOperation(c10173063.spop)
	c:RegisterEffect(e1)
	--SpecialSummon2
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10173063,1))
	e2:SetCategory(CATEGORY_REMOVE+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,0x1e0)
	e2:SetCountLimit(1,10173063)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetTarget(c10173063.sptg2)
	e2:SetOperation(c10173063.spop2)
	c:RegisterEffect(e2)
	--SpecialSummon3
	local e3=e2:Clone()
	e3:SetDescription(aux.Stringid(10173063,2))
	e3:SetCountLimit(1,10173063)
	e3:SetTarget(c10173063.sptg3)
	e3:SetOperation(c10173063.spop3)
	c:RegisterEffect(e3)
end
function c10173063.spfilter2(c,e,tp)
	return c:IsCode(10173061) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c10173063.sptg3(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToRemove() and Duel.IsExistingMatchingCard(c10173063.spfilter2,tp,0x13,0,1,c,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,c,1,tp,LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0x13)
end
function c10173063.spop3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.Remove(c,POS_FACEUP,REASON_EFFECT)~=0 and c:IsLocation(LOCATION_REMOVED) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
	   Duel.BreakEffect()
	   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	   local g=Duel.SelectMatchingCard(tp,c10173063.spfilter2,tp,0x13,0,1,1,nil,e,tp)
	   if g:GetCount()>0 then
		  Duel.SpecialSummon(g,0,tp,tp,true,false,POS_FACEUP)
	   end
	end
end
function c10173063.cfilter(c)
	return c:IsAbleToRemove() and c:IsType(TYPE_MONSTER)
end
function c10173063.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then 
	   local g=Duel.GetMatchingGroup(c10173063.cfilter,tp,LOCATION_GRAVE,0,c)
	   return g:GetCount()>1 and g:FilterCount(Card.IsSetCard,nil,0xc332)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,2,tp,LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,LOCATION_GRAVE)
end
function c10173063.spop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c10173063.cfilter,tp,LOCATION_GRAVE,0,c)
	if g:GetCount()<2 or g:FilterCount(Card.IsSetCard,nil,0xc332)<1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g1=g:FilterSelect(tp,Card.IsSetCard,1,1,nil,0xc332)
	g:Sub(g1)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g2=g:Select(tp,1,1,nil)
	g1:Merge(g2)
	if Duel.Remove(g1,POS_FACEUP,REASON_EFFECT)~=0 and g1:FilterCount(Card.IsLocation,nil,LOCATION_REMOVED)==2 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsRelateToEffect(e) then
	   Duel.BreakEffect()
	   Duel.SpecialSummon(c,0,tp,tp,true,false,POS_FACEUP)
	end
end
function c10173063.spfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c10173063.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c10173063.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c10173063.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c10173063.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end