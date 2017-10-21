--地狱使者亲临
function c60159915.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c60159915.target)
	e1:SetOperation(c60159915.operation)
	c:RegisterEffect(e1)
    --to hand
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(60159915,0))
    e2:SetCategory(CATEGORY_TOHAND)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_GRAVE)
    e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e2:SetCondition(aux.exccon)
    e2:SetCost(c60159915.descost)
    e2:SetTarget(c60159915.destg)
    e2:SetOperation(c60159915.activate)
    c:RegisterEffect(e2)
    local e13=e2:Clone()
    e13:SetDescription(aux.Stringid(60159915,1))
    e13:SetType(EFFECT_TYPE_QUICK_O)
    e13:SetCode(EVENT_FREE_CHAIN)
    e13:SetHintTiming(0,0x1e0)
    e13:SetCondition(c60159915.setcon2)
    c:RegisterEffect(e13)
end
c60159915.fit_monster={60159914}
function c60159915.filter(c,e,tp,m)
	if not c:IsCode(60159914) or bit.band(c:GetType(),0x81)~=0x81
		or not c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,true,true) 
		or c:IsHasEffect(EFFECT_NECRO_VALLEY) then return false end
	local mg=m:Filter(Card.IsCanBeRitualMaterial,c,c)
	if c.mat_filter then
		mg=mg:Filter(c.mat_filter,nil)
	end
	return mg:CheckWithSumGreater(Card.GetRitualLevel,10,c)
end
function c60159915.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local mg=Duel.GetRitualMaterial(tp)
		mg:RemoveCard(e:GetHandler())
		local ct1=Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)
		local ct2=Duel.GetFieldGroupCount(tp,0,LOCATION_ONFIELD)
		if ct1>ct2 then
			return Duel.IsExistingMatchingCard(c60159915.filter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp,mg)
		else
			return Duel.IsExistingMatchingCard(c60159915.filter,tp,LOCATION_HAND,0,1,nil,e,tp,mg)
		end
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c60159915.operation(e,tp,eg,ep,ev,re,r,rp)
	local mg=Duel.GetRitualMaterial(tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local ct1=Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)
	local ct2=Duel.GetFieldGroupCount(tp,0,LOCATION_ONFIELD)
	if ct1>ct2 then
		local tg=Duel.SelectMatchingCard(tp,c60159915.filter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp,mg)
		local tc=tg:GetFirst()
		if tc then
			if tc:IsLocation(LOCATION_GRAVE) then Duel.HintSelection(tg) end
			mg=mg:Filter(Card.IsCanBeRitualMaterial,tc,tc)
			if tc.mat_filter then
				mg=mg:Filter(tc.mat_filter,nil)
			end
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
			local mat=mg:SelectWithSumGreater(tp,Card.GetRitualLevel,10,tc)
			tc:SetMaterial(mat)
			Duel.ReleaseRitualMaterial(mat)
			Duel.BreakEffect()
			Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,true,true,POS_FACEUP)
			tc:CompleteProcedure()
		end
	else
		local tg=Duel.SelectMatchingCard(tp,c60159915.filter,tp,LOCATION_HAND,0,1,1,nil,e,tp,mg)
		local tc=tg:GetFirst()
		if tc then
			mg=mg:Filter(Card.IsCanBeRitualMaterial,tc,tc)
			if tc.mat_filter then
				mg=mg:Filter(tc.mat_filter,nil)
			end
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
			local mat=mg:SelectWithSumGreater(tp,Card.GetRitualLevel,10,tc)
			tc:SetMaterial(mat)
			Duel.ReleaseRitualMaterial(mat)
			Duel.BreakEffect()
			Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,true,true,POS_FACEUP)
			tc:CompleteProcedure()
		end
	end
end
function c60159915.descost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
    Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c60159915.filter2(c)
    return c:IsFaceup() and c:IsCode(60159914) and c:IsAbleToHand()
end
function c60159915.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chk==0 then return Duel.IsExistingTarget(c60159915.filter2,tp,LOCATION_MZONE,0,1,e:GetHandler()) 
		and Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>2 end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
    local g=Duel.SelectTarget(tp,c60159915.filter2,tp,LOCATION_MZONE,0,1,1,e:GetHandler())
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c60159915.activate(e,tp,eg,ep,ev,re,r,rp)
    local tc2=Duel.GetFirstTarget()
    if tc2:IsRelateToEffect(e) then
        if Duel.SendtoHand(tc2,nil,REASON_EFFECT)>0 then
			if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
			local mg=Duel.GetRitualMaterial(tp)
			local g=Duel.GetMatchingGroup(c60159915.filter,tp,LOCATION_HAND,0,nil,e,tp,mg)
			if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(60159915,2)) then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				local tg=Duel.SelectMatchingCard(tp,c60159915.filter,tp,LOCATION_HAND,0,1,1,nil,e,tp,mg)
				local tc=tg:GetFirst()
				if tc then
					mg=mg:Filter(Card.IsCanBeRitualMaterial,tc,tc)
					if tc.mat_filter then
						mg=mg:Filter(tc.mat_filter,nil)
					end
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
					local mat=mg:SelectWithSumGreater(tp,Card.GetRitualLevel,10,tc)
					tc:SetMaterial(mat)
					Duel.ReleaseRitualMaterial(mat)
					Duel.BreakEffect()
					Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,true,true,POS_FACEUP)
					tc:CompleteProcedure()
				end
			end
		end
    end
end
function c60159915.setcon2(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>4 
		and Duel.GetTurnCount()~=e:GetHandler():GetTurnID() or e:GetHandler():IsReason(REASON_RETURN)
end
