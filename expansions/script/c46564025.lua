--春 淚  无 声 细 雨
local m=46564025
local cm=_G["c"..m]
function cm.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_WATER),4,2)
	c:EnableReviveLimit()
	--back to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,m)
	e2:SetCost(cm.cost)
	e2:SetTarget(cm.thtg)
	e2:SetOperation(cm.thop)
	c:RegisterEffect(e2)
	--negate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,2))
	e1:SetCategory(CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,465640251)
	e1:SetCost(cm.decost)
	e1:SetTarget(cm.detg)
	e1:SetOperation(cm.deop)
	c:RegisterEffect(e1)
	--spsummon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,0))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_LEAVE_FIELD)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e4:SetCondition(cm.spcon)
	e4:SetTarget(cm.sptg)
	e4:SetOperation(cm.spop)
	c:RegisterEffect(e4)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function cm.thfilter(c)
	return c:IsAbleToHand()
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and chkc:IsAbleToHand() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToHand,tp,LOCATION_ONFIELD,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,Card.IsAbleToHand,tp,LOCATION_ONFIELD,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end
function cm.decost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToExtraAsCost() end
	Duel.SendtoDeck(e:GetHandler(),nil,0,REASON_COST)
end
function cm.defilter(c)
	return c:IsFaceup() and not c:IsDisabled()
end
function cm.detg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.defilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(cm.defilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
end
function cm.deop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(cm.defilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	local sg=g:Select(tp,1,1,nil)
	Duel.HintSelection(sg)
	local tc=sg:GetFirst()
	if tc and tc:IsFaceup() and not tc:IsDisabled() then
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(tc)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(tc)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
		if tc:IsType(TYPE_TRAPMONSTER) then
			local e3=Effect.CreateEffect(tc)
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
			e3:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e3)
		end
	end
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousPosition(POS_FACEUP)
end
function cm.spfilter(c,e,tp)
	return c:IsRace(RACE_AQUA) and not c:IsType(TYPE_XYZ) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and cm.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetMZoneCount(tp)>0
		and Duel.IsExistingTarget(cm.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,cm.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		if not Duel.SelectYesNo(tp,aux.Stringid(m,3)) then return end
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_LEVEL)
		e1:SetValue(-1)
		e1:SetReset(RESET_EVENT+0xfe0000)
		tc:RegisterEffect(e1)
	end
end
