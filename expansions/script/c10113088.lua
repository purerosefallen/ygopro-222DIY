--万圣夜魔女
function c10113088.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10113088,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND+CATEGORY_POSITION)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,10113088)
	e1:SetCost(c10113088.spcost)
	e1:SetTarget(c10113088.sptg)
	e1:SetOperation(c10113088.spop)
	c:RegisterEffect(e1)  
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10113088,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,10113088)
	e2:SetCost(c10113088.thcost)
	e2:SetTarget(c10113088.thtg)
	e2:SetOperation(c10113088.thop)
	c:RegisterEffect(e2)	
end
function c10113088.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c10113088.thfilter(c)
	return c:IsCode(10113028) and c:IsAbleToHand()
end
function c10113088.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10113088.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c10113088.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c10113088.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 and not g:GetFirst():IsHasEffect(EFFECT_NECRO_VALLEY) then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c10113088.tfilter(c)
	return c:IsFaceup() and c:IsCanTurnSet()
end
function c10113088.tdfilter(c)
	return c:IsFaceup() and c:IsAbleToHand()
end
function c10113088.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c10113088.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(c10113088.tdfilter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingTarget(c10113088.tfilter,tp,0,LOCATION_MZONE,1,nil) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELF)
	local g1=Duel.SelectTarget(tp,c10113088.tdfilter,tp,LOCATION_MZONE,0,1,1,nil)
	e:SetLabelObject(g1:GetFirst())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPPO)
	local g2=Duel.SelectTarget(tp,c10113088.tfilter,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g1,1,tp,LOCATION_MZONE)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g2,1,1-tp,LOCATION_MZONE)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,tp,LOCATION_HAND)
end
function c10113088.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc1,c=e:GetLabelObject(),e:GetHandler()
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tc2=tg:GetFirst()
	if tc1==tc2 then tc2=tg:GetNext() end
	if tc1:IsRelateToEffect(e) and tc1:IsControler(tp) and Duel.SendtoHand(tc1,nil,REASON_EFFECT)~=0 and tc1:IsLocation(LOCATION_HAND) and tc2:IsRelateToEffect(e) and tc2:IsControler(1-tp) and tc2:IsFaceup() and Duel.ChangePosition(tc2,POS_FACEDOWN_DEFENSE)~=0 and c:IsRelateToEffect(e) then
	   Duel.BreakEffect()
	   if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)==0 and Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
		   and c:IsCanBeSpecialSummoned(e,0,tp,false,false) then
		   Duel.SendtoGrave(c,REASON_RULE)
	   end
	end
end
