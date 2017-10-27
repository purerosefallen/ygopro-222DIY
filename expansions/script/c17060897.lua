--グィネヴィア
function c17060897.initial_effect(c)
	aux.EnablePendulumAttribute(c)
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(17060897,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,17060897)
	e1:SetCost(c17060897.thcost)
	e1:SetTarget(c17060897.thtg)
	e1:SetOperation(c17060897.thop)
	c:RegisterEffect(e1)
	--pendulum set
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(17060897,1))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,17060897+100)
	e2:SetTarget(c17060897.pstg)
	e2:SetOperation(c17060897.psop)
	c:RegisterEffect(e2)
	local e2b=e2:Clone()
	e2b:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2b)
	--activate
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(17060897,2))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,17060897+200)
	e3:SetCost(c17060897.cost)
	e3:SetTarget(c17060897.target)
	e3:SetOperation(c17060897.activate)
	c:RegisterEffect(e3)
end
c17060897.is_named_with_Opera_type=1
function c17060897.IsOpera_type(c)
	local m=_G["c"..c:GetCode()]
	return m and m.is_named_with_Opera_type
end
function c17060897.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c17060897.thfilter(c)
	return c:GetLevel()==1 and c:IsType(TYPE_PENDULUM) and c:IsAbleToHand()
end
function c17060897.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c17060897.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c17060897.thop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c17060897.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

function c17060897.psfilter(c)
	return c:IsCode(17060901) and c:IsType(TYPE_PENDULUM) and not c:IsForbidden()
end
function c17060897.pstg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1))
		and Duel.IsExistingMatchingCard(c17060897.psfilter,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_EXTRA,0,1,nil) end
end
function c17060897.psop(e,tp,eg,ep,ev,re,r,rp)
	if chkc then return chkc:IsLocation(LOCATION_DECK+LOCATION_GRAVE+LOCATION_EXTRA) and chkc:IsControler(tp) and c17060897.psfilter(chkc) end
		if not Duel.CheckLocation(tp,LOCATION_PZONE,0) and not Duel.CheckLocation(tp,LOCATION_PZONE,1) then return false end
	local seq=e:GetHandler():GetSequence()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectMatchingCard(tp,c17060897.psfilter,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_EXTRA,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.MoveToField(g:GetFirst(),tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
end

function c17060897.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c17060897.mfilter(c)
	return c:IsType(TYPE_PENDULUM) and c:IsAbleToRemove()
end
function c17060897.filter(c,e,tp,m1,m2,ft)
	if not c:IsCode(17060901) or not c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true) then return false end
	local mg=m1:Filter(Card.IsCanBeRitualMaterial,c,c)
	mg:Merge(m2)
	if ft>0 then
		return mg:CheckWithSumGreater(Card.GetRitualLevel,5,c)
	else
		return mg:IsExists(c17060897.mfilterf,1,nil,tp,mg,c)
	end
end
function c17060897.mfilterf(c,tp,mg,rc)
	if c:IsControler(tp) and c:IsLocation(LOCATION_MZONE) then
		Duel.SetSelectedCard(c)
		return mg:CheckWithSumGreater(Card.GetRitualLevel,5,rc)
	else return false end
end
function c17060897.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local mg1=Duel.GetRitualMaterial(tp)
		mg1:RemoveCard(e:GetHandler())
		local mg2=Duel.GetMatchingGroup(c17060897.mfilter,tp,LOCATION_GRAVE,0,nil)
		local ft=Duel.GetMZoneCount(tp)
		if e:GetHandler():IsLocation(LOCATION_MZONE) then ft=ft+1 end
		return ft>-1 and Duel.IsExistingMatchingCard(c17060897.filter,tp,LOCATION_PZONE,0,1,nil,e,tp,mg1,mg2,ft)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_PZONE)
end
function c17060897.activate(e,tp,eg,ep,ev,re,r,rp)
	local mg1=Duel.GetRitualMaterial(tp)
	local mg2=Duel.GetMatchingGroup(c17060897.mfilter,tp,LOCATION_GRAVE,0,nil)
	local ft=Duel.GetMZoneCount(tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c17060897.filter,tp,LOCATION_PZONE,0,1,1,nil,e,tp,mg1,mg2,ft)
	local tc=g:GetFirst()
	if tc then
		local mg=mg1:Filter(Card.IsCanBeRitualMaterial,tc,tc)
		mg:Merge(mg2)
		local mat=nil
		if ft>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
			mat=mg:SelectWithSumGreater(tp,Card.GetRitualLevel,5,tc)
		else
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
			mat=mg:FilterSelect(tp,c17060897.mfilterf,1,1,nil,tp,mg,tc)
			Duel.SetSelectedCard(mat)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
			local mat2=mg:SelectWithSumGreater(tp,Card.GetRitualLevel,5,tc)
			mat:Merge(mat2)
		end
		tc:SetMaterial(mat)
		Duel.ReleaseRitualMaterial(mat)
		Duel.BreakEffect()
		Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
		tc:CompleteProcedure()
	end
end
