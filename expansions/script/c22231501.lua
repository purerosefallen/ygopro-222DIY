--Darkest　黑暗的地牢
function c22231501.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--tograve
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(22231501,0))
	e6:SetCategory(CATEGORY_TOGRAVE)
	e6:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e6:SetType(EFFECT_TYPE_QUICK_O)
	e6:SetCode(EVENT_FREE_CHAIN)
	e6:SetRange(LOCATION_FZONE)
	e6:SetCountLimit(1)
	e6:SetTarget(c22231501.tgtg)
	e6:SetOperation(c22231501.tgop)
	c:RegisterEffect(e6)
	--Draw
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(22231501,2))
	e6:SetCategory(CATEGORY_POSITION+CATEGORY_DRAW)
	e6:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e6:SetType(EFFECT_TYPE_IGNITION)
	e6:SetRange(LOCATION_FZONE)
	e6:SetCountLimit(1)
	e6:SetTarget(c22231501.dtg)
	e6:SetOperation(c22231501.dop)
	c:RegisterEffect(e6)
	--immune
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCondition(c22231501.econ)
	e3:SetValue(c22231501.efilter)
	c:RegisterEffect(e3)
end
c22231501.named_with_Darkest_D=1
function c22231501.IsDarkest(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Darkest_D
end
function c22231501.tgfilter(c)
	return c:IsFacedown() and c:IsAbleToGrave()
end
function c22231501.tgtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and c22231501.tgfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c22231501.tgfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEDOWN)
	local g=Duel.SelectTarget(tp,c22231501.tgfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,0)
end
function c22231501.setfilter(c)
	return c22231501.IsDarkest(c) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable()
end
function c22231501.tgop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return false end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFacedown() then
		if Duel.SendtoGrave(tc,REASON_EFFECT) and tc:IsControler(tp) and Duel.IsExistingMatchingCard(c22231501.setfilter,tp,LOCATION_DECK,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(22231501,1)) then
			local g=Duel.SelectMatchingCard(tp,c22231501.setfilter,tp,LOCATION_DECK,0,1,1,nil)
			if g:GetCount()>0 then
				Duel.SSet(tp,g)
				Duel.ConfirmCards(1-tp,g)
			end
		end
	end
end
function c22231501.posfilter(c)
	return c22231501.IsDarkest(c) and c:IsType(TYPE_MONSTER) and c:IsCanTurnSet() and c:IsFaceup()
end
function c22231501.dtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c22231501.posfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c22231501.posfilter,tp,LOCATION_MZONE,0,1,nil) and Duel.IsPlayerCanDraw(tp,1) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c22231501.posfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,1,0,0)
end

function c22231501.dop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return false end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and tc:IsCanTurnSet() then
		if Duel.ChangePosition(tc,POS_FACEDOWN_DEFENSE) then
			Duel.Draw(tp,1,REASON_EFFECT)
		end
	end
end
function c22231501.econ(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(Card.IsFacedown,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,3,nil)
end
function c22231501.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end