--WL·默 礼 人 鱼
local m=46564052
local cm=_G["c"..m]
function cm.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,1))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCost(cm.spcost)
	e1:SetTarget(cm.sptg)
	e1:SetOperation(cm.spop)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1,m)
	e2:SetCost(cm.cost)
	e2:SetTarget(cm.target)
	e2:SetOperation(cm.activate)
	c:RegisterEffect(e2)
end
function cm.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToHandAsCost() end
	Duel.SendtoHand(c,nil,REASON_COST)
end
function cm.spfilter(c,e,tp)
	return c:IsSetCard(0x65c) and c:IsCanBeSpecialSummoned(e,POS_FACEUP,tp,false,false) and not c:IsCode(m)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE+LOCATION_HAND) and cm.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetMZoneCount(tp)>-1 and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_GRAVE+LOCATION_HAND,0,1,nil,e,tp) end
	local g=Duel.GetMatchingGroup(cm.spfilter,tp,LOCATION_GRAVE+LOCATION_HAND,0,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_GRAVE+LOCATION_HAND,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		sg=g:GetFirst()
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
	end
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function cm.rthfilter(c)
	if c:IsRace(RACE_SEASERPENT) and c:IsAbleToHand() and c:IsFaceup() then return true end
	return c:IsSetCard(0x65c) and c:IsAbleToHand() and c:IsFaceup()
end
function cm.thfilter(c)
	return c:IsSetCard(0x46) and c:IsType(TYPE_SPELL) and c:IsAbleToHand()
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsAbleToHand() end
	if chk==0 then return Duel.IsExistingTarget(cm.rthfilter,tp,LOCATION_MZONE,0,1,nil) and Duel.IsExistingTarget(cm.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,cm.rthfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if tc and tc:IsRelateToEffect(e) and g:GetCount()>0 then
		local sg=g:GetFirst()
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
	end
end





