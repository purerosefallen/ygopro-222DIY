--口袋妖怪化石复活 灵魂的尽头
function c80000121.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,80000121)
	e1:SetTarget(c80000121.target)
	e1:SetOperation(c80000121.activate)
	c:RegisterEffect(e1)   
	--negate
	local e11=Effect.CreateEffect(c)
	e11:SetDescription(aux.Stringid(80000121,0))
	e11:SetCategory(CATEGORY_DISABLE)
	e11:SetType(EFFECT_TYPE_QUICK_O)
	e11:SetCode(EVENT_CHAINING)
	e11:SetRange(LOCATION_GRAVE)
	e11:SetCondition(c80000121.negcon)
	e11:SetCost(c80000121.negcost)
	e11:SetTarget(c80000121.negtg)
	e11:SetOperation(c80000121.negop)
	c:RegisterEffect(e11) 
end
function c80000121.filter(c,e,tp,m)
	if not c:IsSetCard(0x2d1) or bit.band(c:GetType(),0x81)~=0x81
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
function c80000121.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local mg1=Duel.GetRitualMaterial(tp)
		return Duel.IsExistingMatchingCard(c80000121.filter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp,mg1)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
end
function c80000121.activate(e,tp,eg,ep,ev,re,r,rp)
	local mg1=Duel.GetRitualMaterial(tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tg=Duel.SelectMatchingCard(tp,c80000121.filter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e,tp,mg1)
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
function c80000121.tfilter(c,tp)
	return c:IsLocation(LOCATION_MZONE) and c:IsControler(tp) and c:IsFaceup() and c:IsSetCard(0x2d0)
end
function c80000121.negcon(e,tp,eg,ep,ev,re,r,rp)
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return g and g:IsExists(c80000121.tfilter,1,nil,tp) and Duel.IsChainDisablable(ev)
end
function c80000121.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c80000121.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
end
function c80000121.negop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end