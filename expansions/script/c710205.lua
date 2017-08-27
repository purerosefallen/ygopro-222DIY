--风轮的风尘
function c710205.initial_effect(c)
	--to deck and to hand 
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
	e1:SetRange(LOCATION_HAND)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1.710205)
	e1:SetCost(c710205.cost)
	e1:SetTarget(c710205.target)
	e1:SetOperation(c710205.operation)
	c:RegisterEffect(e1)
end

c710205.is_named_with_WindWheel=1
function c710205.IsWindWheel(c)
	local m=_G["c"..c:GetCode()]
	return m and m.is_named_with_WindWheel
end

function c710205.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c710205.filter(c)
	return c:Faceup() and c:IsAbleToDeck()
end
function c710205.thfilter(c,e,tp)
	return c:IsAttribute(ATTRIBUTE_WIND) and (c:IsAbleToHand()
		or Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false))
end
function c710205.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c710205.thfilter(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(c710205.thfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g1=Duel.SelectTarget(tp,c710205.filter,tp,LOCATION_ONFIELD,0,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g2=Duel.SelectTarget(tp,c710205.thfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g1,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g2,1,0,0)
end
function c710205.operation(e,tp,eg,ep,ev,re,r,rp)
	local ex,g1=Duel.GetOperationInfo(0,CATEGORY_TODECK)
	local ex,g2=Duel.GetOperationInfo(0,CATEGORY_TOHAND)
	local tc1=g1:GetFirst()
	local tc2=g2:GetFirst()
	if tc1 and tc1:IsRelateToEffect(e) then
		if Duel.SendtoDeck(tc1,nil,0,REASON_EFFECT)~=0 and tc2:IsRelateToEffect(e) then
			local v1,v2=tc2:IsAbleToHand(),Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and tc2:IsCanBeSpecialSummoned(e,0,tp,false,false)
			local sel=0
			if v1 and v2 then
				sel=Duel.SelectOption(tp,aux.Stringid(710205,0),aux.Stringid(710205,1))+1
			else if v1 and not v2 then
				sel=Duel.SelectOption(tp,aux.Stringid(710205,0))+1
			else v2 and not v1 then
				sel=Duel.SelectOption(tp,aux.Stringid(710205,1))+2
			end
			if sel==1 then
				Duel.SendtoHand(tc2,nil,REASON_EFFECT)
			elseif sel==2 then
				Duel.SpecialSummon(tc2,0,tp,tp,false,false,POS_FACEUP)
			end
		end
	end
end

