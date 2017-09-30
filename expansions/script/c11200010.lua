--我真是个笨蛋……
function c11200010.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetDescription(aux.Stringid(11200010,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,11200010)
	e1:SetTarget(c11200010.target)
	e1:SetOperation(c11200010.activate)
	c:RegisterEffect(e1)
  --search
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetDescription(aux.Stringid(11200010,1))
	e2:SetRange(LOCATION_GRAVE+LOCATION_HAND)
	e2:SetCountLimit(1,11200010+EFFECT_COUNT_CODE_DUEL)
	e2:SetCost(c11200010.thcost)
	e2:SetTarget(c11200010.thtg)
	e2:SetOperation(c11200010.thop)
	c:RegisterEffect(e2)
end
function c11200010.rmfilter(c,fc)
	return c:IsCanBeRitualMaterial(fc) or (c:IsLocation(LOCATION_GRAVE) and c:IsAbleToRemove())
end
function c11200010.filter(c,e,tp,m1,m2,ft)
	if not (c:IsCode(11200007) and bit.band(c:GetType(),0x81)==0x81
		and  c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true)) then return false end
   m1:Merge(m2)
	local mg=m1:Filter(c11200010.rmfilter,c,c)
	if ft>0 then
		return mg:CheckWithSumGreater(Card.GetRitualLevel,9,c)
	else
		return ft>-1 and mg:IsExists(c11200010.mfilterf,1,nil,tp,mg,c)
	end
end
function c11200010.mfilterf(c,tp,mg,rc)
	if c:IsControler(tp) and c:IsLocation(LOCATION_MZONE) and c:GetSequence()<5 then
		Duel.SetSelectedCard(c)
		return mg:CheckWithSumGreater(Card.GetRitualLevel,9,rc)
	else return false end
end
function c11200010.mfilter(c)
	return c:GetLevel()>0 and c:IsSetCard(0x134) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemove() 
end
function c11200010.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local mg1=Duel.GetRitualMaterial(tp)
		local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
		local mg2=Duel.GetMatchingGroup(c11200010.mfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil)
		return  Duel.IsExistingMatchingCard(c11200010.filter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp,mg1,mg2,ft)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function c11200010.activate(e,tp,eg,ep,ev,re,r,rp)
	local mg1=Duel.GetRitualMaterial(tp)
	local mg2=Duel.GetMatchingGroup(c11200010.mfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tg=Duel.SelectMatchingCard(tp,c11200010.filter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp,mg1,mg2,ft)
   local tc=tg:GetFirst()
	if tc then
		mg1:Merge(mg2)
		local mg=mg1:Filter(c11200010.rmfilter,tc,tc)
		   local mat=nil
			if ft>0 then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
				mat=mg:SelectWithSumGreater(tp,Card.GetRitualLevel,9,tc)
			else
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
				mat=mg:FilterSelect(tp,c11200010.mfilterf,1,1,nil,tp,mg,tc)
				Duel.SetSelectedCard(mat)
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
				local mat2=mg:SelectWithSumGreater(tp,Card.GetRitualLevel,9,tc)
				mat:Merge(mat2)
			end
			tc:SetMaterial(mat)
			Duel.ReleaseRitualMaterial(mat)
		end
		Duel.BreakEffect()
		Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
		tc:CompleteProcedure()
end
function c11200010.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c11200010.thfilter(c)
	return c:IsCode(11200007) and c:IsAbleToHand()
end
function c11200010.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c11200010.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c11200010.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c11200010.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
