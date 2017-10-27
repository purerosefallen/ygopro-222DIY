--私装姬
function c17060803.initial_effect(c)
	c:SetSPSummonOnce(17060803)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--atk up
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(17060803,0))
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(c17060803.target)
	e2:SetValue(300)
	c:RegisterEffect(e2)
	--special summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(17060803,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOGRAVE)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_HAND)
	e3:SetCost(c17060803.spcost)
	e3:SetTarget(c17060803.sptg)
	e3:SetOperation(c17060803.spop)
	c:RegisterEffect(e3)
end
c17060803.is_named_with_Singer_Arthur=1
c17060803.is_named_with_Million_Arthur=1
function c17060803.IsSinger_Arthur(c)
	local m=_G["c"..c:GetCode()]
	return m and m.is_named_with_Singer_Arthur
end
function c17060803.IsMillion_Arthur(c)
	local m=_G["c"..c:GetCode()]
	return m and m.is_named_with_Million_Arthur
end
function c17060803.target(e,c)
	return c:IsFaceup() and c17060803.IsMillion_Arthur(c)
end
function c17060803.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,Card.IsType,1,nil,TYPE_PENDULUM) end
	local g=Duel.SelectReleaseGroup(tp,Card.IsType,1,1,nil,TYPE_PENDULUM)
	Duel.Release(g,REASON_COST)
end
function c17060803.filter(c)
	return c17060803.IsMillion_Arthur(c) and c:IsType(TYPE_MONSTER) and c:IsAbleToGrave()
end
function c17060803.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c17060803.filter,tp,LOCATION_HAND+LOCATION_DECK,0,1,e:GetHandler())
		and Duel.GetMZoneCount(tp)>-1
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c17060803.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c17060803.filter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,c)
	local tc=g:GetFirst()
	if Duel.SendtoGrave(tc,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_GRAVE) and c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end