--Darkest　危机或危机
function c22231101.initial_effect(c)
	--pos
	local e6=Effect.CreateEffect(c)
	e6:SetCategory(CATEGORY_POSITION)
	e6:SetType(EFFECT_TYPE_ACTIVATE)
	e6:SetCode(EVENT_FREE_CHAIN)
	e6:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e6:SetCountLimit(1,22231101)
	e6:SetTarget(c22231101.postg)
	e6:SetOperation(c22231101.posop)
	c:RegisterEffect(e6)
	--pos
	local e6=Effect.CreateEffect(c)
	e6:SetCategory(CATEGORY_POSITION)
	e6:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e6:SetType(EFFECT_TYPE_IGNITION)
	e6:SetRange(LOCATION_GRAVE)
	e6:SetCountLimit(1,22231101)
	e6:SetCondition(aux.exccon)
	e6:SetTarget(c22231101.settg)
	e6:SetOperation(c22231101.setop)
	c:RegisterEffect(e6)
end
c22231101.named_with_Darkest_D=1
function c22231101.IsDarkest(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Darkest_D
end
function c22231101.postg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsFacedown() and chkc:IsLocation(LOCATION_MZONE) end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFacedown,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEDOWN)
	local g=Duel.SelectTarget(tp,Card.IsFacedown,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,1,0,0)
end
function c22231101.posfilter(c)
	return c:IsFaceup() and c:IsCanTurnSet()
end
function c22231101.posop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsFacedown() and tc:IsRelateToEffect(e) then
		Duel.ChangePosition(tc,POS_FACEUP_DEFENSE)
		if c22231101.IsDarkest(tc) and Duel.IsExistingMatchingCard(c22231101.posfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,tc) and Duel.SelectYesNo(tp,aux.Stringid(22231101,0)) then
			local g=Duel.SelectMatchingCard(tp,c22231101.posfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,tc)
			if g:GetCount()>0 then
				Duel.ChangePosition(g,POS_FACEDOWN_DEFENSE)
			end
		end
	end
end
function c22231101.settg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsFacedown() and chkc:IsLocation(LOCATION_MZONE) end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFacedown,tp,LOCATION_MZONE,0,1,nil) and e:GetHandler():IsSSetable() end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEDOWN)
	local g=Duel.SelectTarget(tp,Card.IsFacedown,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,1,0,0)
end
function c22231101.setop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsFacedown() and tc:IsRelateToEffect(e) then
		if Duel.ChangePosition(tc,0x1,0x1,0x4,0x4,true)>0 and c:IsSSetable() then
			Duel.SSet(tp,c)
			Duel.ConfirmCards(1-tp,c)
		end
	end
end