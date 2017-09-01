--Darkest　先祖的遗嘱
function c22231001.initial_effect(c)
	--tohand
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SEARCH+CATEGORY_TODECK+CATEGORY_TOHAND)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetType(EFFECT_TYPE_ACTIVATE)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCountLimit(1,22231001+EFFECT_COUNT_CODE_OATH)
	e3:SetTarget(c22231001.target)
	e3:SetOperation(c22231001.operation)
	c:RegisterEffect(e3)
	--pos
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(22231001,0))
	e2:SetCategory(CATEGORY_POSITION)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(aux.exccon)
	e2:SetCost(c22231001.poscost)
	e2:SetTarget(c22231001.postg)
	e2:SetOperation(c22231001.posop)
	c:RegisterEffect(e2)
end
c22231001.named_with_Darkest_D=1
function c22231001.IsDarkest(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Darkest_D
end
function c22231001.tgfilter(c)
	return c:IsFacedown() and c:IsAbleToDeck()
end
function c22231001.thfilter(c)
	return c22231001.IsDarkest(c) and c:IsAbleToHand() and c:IsType(TYPE_MONSTER)
end
function c22231001.spfilter(c,e,tp)
	return c22231001.IsDarkest(c) and c:IsType(TYPE_FLIP) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE)
end
function c22231001.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsFacedown() end
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingTarget(c22231001.tgfilter,tp,LOCATION_MZONE,0,1,nil) and Duel.IsExistingMatchingCard(c22231001.thfilter,tp,LOCATION_DECK,0,2,nil) end
	local g=Duel.SelectTarget(tp,c22231001.tgfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c22231001.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not (tc:IsRelateToEffect(e) or tc:IsFacedown()) then return false end
	local c=e:GetHandler()
	if Duel.SendtoDeck(tc,nil,2,REASON_EFFECT) then
		local g=Duel.SelectMatchingCard(tp,c22231001.thfilter,tp,LOCATION_DECK,0,2,2,nil)
		if g:GetCount()>1 then 
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
			if tc:IsLocation(LOCATION_EXTRA) and Duel.IsExistingMatchingCard(c22231001.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) and Duel.SelectYesNo(tp,aux.Stringid(22231001,0)) then
				local sg=Duel.SelectMatchingCard(tp,c22231001.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
				if sg:GetCount()>0 then 
					Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE) 
					Duel.ConfirmCards(1-tp,sg)
				end
			end
		end
	end
end
function c22231001.poscost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c22231001.posfilter(c)
	return c22231001.IsDarkest(c) and c:IsFaceup() and c:IsCanTurnSet()
end
function c22231001.postg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingTarget(c22231001.posfilter,tp,LOCATION_MZONE,0,1,nil) end
	local g=Duel.GetMatchingGroup(c22231001.posfilter,tp,LOCATION_MZONE,0,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,g:GetCount(),0,0)
end
function c22231001.posop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c22231001.posfilter,tp,LOCATION_MZONE,0,nil)
	Duel.ChangePosition(g,POS_FACEDOWN_DEFENSE)
end