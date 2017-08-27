--白泽球捕获瓶
function c22221101.initial_effect(c)
	--to grave
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_REMOVE+CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCountLimit(1,22221101+EFFECT_COUNT_CODE_OATH)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetTarget(c22221101.dtg)
	e2:SetOperation(c22221101.dop)
	c:RegisterEffect(e2)
	--to deck
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(c22221101.cost)
	e2:SetTarget(c22221101.target)
	e2:SetOperation(c22221101.activate)
	c:RegisterEffect(e2)
end
c22221101.named_with_Shirasawa_Tama=1
function c22221101.IsShirasawaTama(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Shirasawa_Tama
end
function c22221101.dfilter(c)
	return c:IsFaceup() and c22221101.IsShirasawaTama(c) and c:IsAbleToRemove() and c:IsType(TYPE_MONSTER)
end
function c22221101.dtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return (chkc:IsLocation(LOCATION_MZONE) or chkc:IsLocation(LOCATION_GRAVE)) and c22221101.dfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c22221101.dfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,c22221101.dfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c22221101.filter(c,code)
	return c:IsAbleToHand() and c:GetCode()==code
end
function c22221101.dop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
		local code=tc:GetCode()
		if Duel.IsExistingMatchingCard(c22221101.filter,tp,LOCATION_DECK,0,1,e:GetHandler(),code) then
			Duel.BreakEffect()
			local g=Duel.GetMatchingGroup(c22221101.filter,tp,LOCATION_DECK,0,e:GetHandler(),code)
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)   
		end
	end
end
function c22221101.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c22221101.rfilter(c)
	return c:IsType(TYPE_MONSTER) and c22221101.IsShirasawaTama(c) and c:IsAbleToRemove()
end
function c22221101.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c22221101.rfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_DECK)
end
function c22221101.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c22221101.rfilter,tp,LOCATION_DECK,0,1,1,nil)
	local tc=g:GetFirst()
	if tc==nil then return end
	Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
	tc:SetStatus(STATUS_PROC_COMPLETE, true)
end




