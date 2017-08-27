--风轮的疾风
function c710204.initial_effect(c)
	--to deck and set 
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,710204)
	e1:SetTarget(c710204.target)
	e1:SetOperation(c710204.operation)
	c:RegisterEffect(e1)
end

c710204.is_named_with_WindWheel=1
function c710204.IsWindWheel(c)
	local m=_G["c"..c:GetCode()]
	return m and m.is_named_with_WindWheel
end

function c710204.filter(c)
	return c:IsFaceup() and c:IsAbleToDeck()
end
function c710204.spfilter(c,e,tp)
	return c710204.IsWindWheel(c) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c710204.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c710204.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c710204.filter,tp,LOCATION_ONFIELD,0,1,nil)
		and Duel.IsExistingTarget(c710204.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g1=Duel.SelectTarget(tp,c710204.filter,tp,LOCATION_ONFIELD,0,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g2=Duel.SelectTarget(tp,c710204.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g1,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g2,1,0,0)
end
function c710204.operation(e,tp,eg,ep,ev,re,r,rp)
	local ex,g1=Duel.GetOperationInfo(0,CATEGORY_TODECK)
	local ex,g2=Duel.GetOperationInfo(0,CATEGORY_SPECIAL_SUMMON)
	local tc1=g1:GetFirst()
	local tc2=g2:GetFirst()
	if tc1 and tc1:IsRelateToEffect(e) then
		if Duel.SendtoDeck(tc1,nil,0,REASON_EFFECT)~=0 and  
		tc2:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then 
			Duel.SpecialSummon(tc2,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end

