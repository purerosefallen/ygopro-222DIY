--裂空的洗礼
function c80000292.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c80000292.target)
	e1:SetOperation(c80000292.activate)
	c:RegisterEffect(e1)
	--act in hand
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e2:SetCondition(c80000292.handcon)
	c:RegisterEffect(e2)  
	--Activate
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCost(c80000292.cost)
	e3:SetTarget(c80000292.target1)
	e3:SetOperation(c80000292.activate1)
	c:RegisterEffect(e3)  
end
function c80000292.filter(c)
	return c:IsFaceup() and c:IsCode(80000144)
end
function c80000292.handcon(e)
	return Duel.IsExistingMatchingCard(c80000292.filter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
function c80000292.dfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x2d0) and c:IsDestructable() and c:IsAttribute(ATTRIBUTE_WATER)
end
function c80000292.spfilter(c,e,tp)
	return c:IsSetCard(0x2d0) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and not c:IsHasEffect(EFFECT_NECRO_VALLEY)
end
function c80000292.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c80000292.dfilter,tp,LOCATION_MZONE,0,1,nil) end
	local g=Duel.GetMatchingGroup(c80000292.dfilter,tp,LOCATION_MZONE,0,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c80000292.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c80000292.dfilter,tp,LOCATION_MZONE,0,nil)
	local ct=Duel.Destroy(g,REASON_EFFECT)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ct==0 or ft<=0 then return end
	if ft>ct then ft=ct end
	local sg=Duel.GetMatchingGroup(c80000292.spfilter,tp,LOCATION_GRAVE,0,nil,e,tp)
	if sg:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(80000292,0)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local fg=sg:Select(tp,ft,ft,nil)
		Duel.SpecialSummon(fg,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
	end
end
function c80000292.tgfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToHand() and c:IsLevelAbove(6) and c:IsSetCard(0x2d0)
end
function c80000292.target1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c80000292.tgfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c80000292.tgfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local sg=Duel.SelectTarget(tp,c80000292.tgfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,sg,sg:GetCount(),0,0)
end
function c80000292.activate1(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end
function c80000292.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end