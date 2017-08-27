--饥饿狼王
function c10113067.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c10113067.spcon)
	c:RegisterEffect(e1)
	--code
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(EFFECT_CHANGE_CODE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(10113037)
	c:RegisterEffect(e2)
	--revive 
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(10113067,0))
	e3:SetCategory(CATEGORY_TODECK+CATEGORY_SPECIAL_SUMMON)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCost(c10113067.cost)
	e3:SetTarget(c10113067.target)
	e3:SetOperation(c10113067.operation)
	c:RegisterEffect(e3)
end
function c10113067.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c10113067.filter(c)
	return c:IsCode(10113037) and c:IsAbleToExtra()
end
function c10113067.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED) and c10113067.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c10113067.filter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c10113067.filter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,tp,LOCATION_GRAVE+LOCATION_REMOVED)
end
function c10113067.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_EXTRA) then
	   local g=Duel.GetMatchingGroup(c10113067.spfilter,tp,LOCATION_EXTRA,0,nil,e,tp)   
	   if g:GetCount()>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.SelectYesNo(tp,aux.Stringid(10113067,1))  then
		  Duel.BreakEffect()
		  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		  local sg=g:Select(tp,1,1,nil)
		  Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
	   end   
	end
end
function c10113067.spfilter(c,e,tp)
	return c:IsCode(10113037) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c10113067.sprfilter(c)
	return c:IsFaceup() and c:IsCode(10113037)
end
function c10113067.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c10113067.sprfilter,c:GetControler(),LOCATION_MZONE,0,2,nil)
end