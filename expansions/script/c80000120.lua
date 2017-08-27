--口袋妖怪化石复活 基因
function c80000120.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,80000120)
	e1:SetTarget(c80000120.target)
	e1:SetOperation(c80000120.activate)
	c:RegisterEffect(e1) 
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(c80000120.thcon)
	e2:SetCost(c80000120.thcost)
	e2:SetTarget(c80000120.thtg)
	e2:SetOperation(c80000120.thop)
	c:RegisterEffect(e2)   
end
function c80000120.filter(c,e,tp,m)
	if not c:IsSetCard(0x2d1) or bit.band(c:GetType(),0x81)~=0x81
		or not c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true) then return false end
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
function c80000120.mfilter(c)
	return c:IsSetCard(0x2d0) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemove()
end
function c80000120.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local mg1=Duel.GetRitualMaterial(tp)
		local mg2=Duel.GetMatchingGroup(c80000120.mfilter,tp,LOCATION_GRAVE,0,nil)
		mg1:Merge(mg2)
		return Duel.IsExistingMatchingCard(c80000120.filter,tp,LOCATION_HAND,0,1,nil,e,tp,mg1)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c80000120.activate(e,tp,eg,ep,ev,re,r,rp)
	local mg1=Duel.GetRitualMaterial(tp)
	local mg2=Duel.GetMatchingGroup(c80000120.mfilter,tp,LOCATION_GRAVE,0,nil)
	mg1:Merge(mg2)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tg=Duel.SelectMatchingCard(tp,c80000120.filter,tp,LOCATION_HAND,0,1,1,nil,e,tp,mg1)
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
function c80000120.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetTurnID()~=Duel.GetTurnCount()
end
function c80000120.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c80000120.thfilter(c)
	return c:IsSetCard(0x2d1) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c80000120.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c80000120.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c80000120.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c80000120.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end