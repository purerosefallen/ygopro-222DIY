--十六夜之降临
function c80006000.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,80006000)
	e1:SetTarget(c80006000.target)
	e1:SetOperation(c80006000.activate)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(80006000,3))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,91000025)
	e2:SetCost(c80006000.spcost)
	e2:SetTarget(c80006000.sptg)
	e2:SetOperation(c80006000.spop)
	c:RegisterEffect(e2)
	--to hand
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_TOHAND)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e5:SetCode(EVENT_TO_GRAVE)
	e5:SetCondition(c80006000.condtion)
	e5:SetCountLimit(1,80006001)
	e5:SetTarget(c80006000.thtg)
	e5:SetOperation(c80006000.thop)
	c:RegisterEffect(e5) 
end
function c80006000.chainlm(e,rp,tp)
	return tp==rp
end
function c80006000.condtion(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_EFFECT) and re and re:GetHandler():IsSetCard(0x2de)
end
function c80006000.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
	Duel.SetChainLimit(c80006000.chainlm)
end
function c80006000.thop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.SendtoHand(e:GetHandler(),nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,e:GetHandler())
	end
end
function c80006000.filter(c,e,tp,m)
	if not c:IsSetCard(0x2de) or not c:IsType(TYPE_MONSTER) or bit.band(c:GetType(),0x81)~=0x81
		or not c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true) or c:IsHasEffect(EFFECT_NECRO_VALLEY) then return false end
	if c:IsCode(21105106) then return c:ritual_custom_condition(m) end
	local mg=nil
	if c.mat_filter then
		mg=m:Filter(c.mat_filter,c)
	else
		mg=m:Clone()
		mg:RemoveCard(c)
	end
	return mg:CheckWithSumEqual(Card.GetRitualLevel,c:GetLevel(),1,99,c)
end
function c80006000.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local mg1=Duel.GetRitualMaterial(tp)
		return Duel.IsExistingMatchingCard(c80006000.filter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp,mg1)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
	Duel.SetChainLimit(c80006000.chainlm)
end
function c80006000.activate(e,tp,eg,ep,ev,re,r,rp)
	local mg1=Duel.GetRitualMaterial(tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tg=Duel.SelectMatchingCard(tp,c80006000.filter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp,mg1)
	if tg:GetCount()>0 then
		local tc=tg:GetFirst()
		if tc:IsCode(21105106) then
			tc:ritual_custom_operation(mg1)
			local mat=tc:GetMaterial()
			Duel.ReleaseRitualMaterial(mat)
		else
			mg1:RemoveCard(tc)
			if tc.mat_filter then
				mg1=mg1:Filter(tc.mat_filter,nil)
			end
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
			local mat=mg1:SelectWithSumEqual(tp,Card.GetRitualLevel,tc:GetLevel(),1,99,tc)
			tc:SetMaterial(mat)
			Duel.ReleaseRitualMaterial(mat)
		end
		Duel.BreakEffect()
		Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
		tc:CompleteProcedure()
	end
end
function c80006000.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c80006000.mtfilter(c,e)
	return c:GetLevel()>0 and c:IsAbleToRemove() and not c:IsImmuneToEffect(e)
end
function c80006000.spfilter(c,e,tp,m)
	return c:IsSetCard(0x2de) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,true,false)
		and m:CheckWithSumEqual(Card.GetRitualLevel,8,1,99,c) and c:IsType(TYPE_RITUAL)
end
function c80006000.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return false end
		local mg=Duel.GetMatchingGroup(c80006000.mtfilter,tp,LOCATION_GRAVE,0,e:GetHandler(),e)
		return Duel.IsExistingMatchingCard(c80006000.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp,mg)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
	Duel.SetChainLimit(c80006000.chainlm)
end
function c80006000.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local mg=Duel.GetMatchingGroup(c80006000.mtfilter,tp,LOCATION_GRAVE,0,nil,e)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c80006000.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp,mg)
	local tc=g:GetFirst()
	if tc then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local mat=mg:SelectWithSumEqual(tp,Card.GetRitualLevel,8,1,99,tc)
		tc:SetMaterial(mat)
		Duel.ReleaseRitualMaterial(mat)
		Duel.BreakEffect()
		Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,true,false,POS_FACEUP)
		tc:CompleteProcedure()
	end
end