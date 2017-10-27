--裁定者-降临礼装
function c21401125.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c21401125.target)
	e1:SetOperation(c21401125.activate)
	c:RegisterEffect(e1)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(21401125,0))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(c21401125.shcost)
	e2:SetCondition(c21401125.shcon)
	e2:SetTarget(c21401125.shtg)
	e2:SetOperation(c21401125.shop)
	c:RegisterEffect(e2)
end
function c21401125.filter(c,e,tp,m1,m2,ft)
	if not c:IsSetCard(0xf08) or bit.band(c:GetType(),0x81)~=0x81
		or not c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true) then return false end
	local mg=m1:Filter(Card.IsCanBeRitualMaterial,c,c)
	mg:Merge(m2)
	if ft>0 then
		return mg:CheckWithSumEqual(Card.GetRitualLevel,c:GetLevel(),1,99,c)
	else
		return ft>-1 and mg:IsExists(c21401125.mfilterf,1,nil,tp,mg,c)
	end
end
function c21401125.mfilterf(c,tp,mg,rc)
	if c:IsControler(tp) and c:IsLocation(LOCATION_MZONE) then
		Duel.SetSelectedCard(c)
		return mg:CheckWithSumEqual(Card.GetRitualLevel,rc:GetLevel(),0,99,rc)
	else return false end
end
function c21401125.mfilter(c)
	return c:GetLevel()>0 and c:IsType(TYPE_PENDULUM) and c:IsSetCard(0xf00) and not c:IsForbidden()
end
function c21401125.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local mg1=Duel.GetRitualMaterial(tp)
		local mg2=Duel.GetMatchingGroup(c21401125.mfilter,tp,LOCATION_DECK,0,nil)
		local ft=Duel.GetMZoneCount(tp)
		return Duel.IsExistingMatchingCard(c21401125.filter,tp,LOCATION_HAND,0,1,nil,e,tp,mg1,mg2,ft)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c21401125.activate(e,tp,eg,ep,ev,re,r,rp)
	local mg1=Duel.GetRitualMaterial(tp)
	local mg2=Duel.GetMatchingGroup(c21401125.mfilter,tp,LOCATION_DECK,0,nil)
	local ft=Duel.GetMZoneCount(tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c21401125.filter,tp,LOCATION_HAND,0,1,1,nil,e,tp,mg1,mg2,ft)
	local tc=g:GetFirst()
	if tc then
		local mg=mg1:Filter(Card.IsCanBeRitualMaterial,tc,tc)
		mg:Merge(mg2)
		local mat=nil
		if ft>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
			mat=mg:SelectWithSumEqual(tp,Card.GetRitualLevel,tc:GetLevel(),1,99,tc)
		else
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
			mat=mg:FilterSelect(tp,c21401125.mfilterf,1,1,nil,tp,mg,tc)
			Duel.SetSelectedCard(mat)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
			local mat2=mg:SelectWithSumEqual(tp,Card.GetRitualLevel,tc:GetLevel(),0,99,tc)
			mat:Merge(mat2)
		end
		tc:SetMaterial(mat)
		local mat2=mat:Filter(Card.IsLocation,nil,LOCATION_DECK)
		mat:Sub(mat2)
		Duel.ReleaseRitualMaterial(mat)
		Duel.SendtoExtraP(mat2,tp,REASON_EFFECT+REASON_MATERIAL+REASON_RITUAL)
		Duel.BreakEffect()
		Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
		tc:CompleteProcedure()
	end
end
function c21401125.shcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0
end
function c21401125.shcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeckAsCost() end
	Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_COST)
end
function c21401125.thfilter(c)
	return c:IsSetCard(0xf08) and bit.band(c:GetType(),0x81)==0x81 and c:IsAbleToHand()
end
function c21401125.shtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_DECK) and chkc:IsControler(tp) and c21401125.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c21401125.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c21401125.shop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c21401125.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	local tc=g:GetFirst()
	if tc and tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end

