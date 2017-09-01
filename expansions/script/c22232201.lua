--Darkest　往复的古道
function c22232201.initial_effect(c)
	c:SetUniqueOnField(1,0,22232201)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--pos
	local e6=Effect.CreateEffect(c)
	e6:SetCategory(CATEGORY_POSITION)
	e6:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e6:SetType(EFFECT_TYPE_QUICK_O)
	e6:SetCode(EVENT_FREE_CHAIN)
	e6:SetRange(LOCATION_SZONE)
	e6:SetCountLimit(1)
	e6:SetTarget(c22232201.postg)
	e6:SetOperation(c22232201.posop)
	c:RegisterEffect(e6)
	--Immune
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_SZONE)
	e1:SetValue(c22232201.tgvalue)
	c:RegisterEffect(e1)
	--selfdes
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE)
	e7:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e7:SetRange(LOCATION_SZONE)
	e7:SetCode(EFFECT_SELF_DESTROY)
	e7:SetCondition(c22232201.descon)
	c:RegisterEffect(e7)
end
c22232201.named_with_Darkest_D=1
function c22232201.IsDarkest(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Darkest_D
end

function c22232201.postg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsFacedown() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFacedown,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEDOWN)
	local g=Duel.SelectTarget(tp,Card.IsFacedown,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,1,0,0)
end
function c22232201.setfilter(c)
	return c:IsFaceup() and c:IsLocation(LOCATION_SZONE) and c:IsCanTurnSet() and not c:IsLocation(LOCATION_PZONE)
end
function c22232201.posop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return false end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFacedown() then
		if Duel.ChangePosition(tc,POS_FACEUP_DEFENSE) then
			if e:GetHandler():IsRelateToEffect(e) and c22232201.IsDarkest(tc) and Duel.IsExistingMatchingCard(c22232201.setfilter,tp,0,LOCATION_ONFIELD,1,nil) and Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(22232201,0)) then 
				Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_EFFECT,nil)
				local g=Duel.SelectMatchingCard(tp,c22232201.setfilter,tp,0,LOCATION_ONFIELD,1,1,nil)
				if g:GetCount()>0 then
					local tc=g:GetFirst()
					Duel.ChangePosition(tc,POS_FACEDOWN)
					Duel.RaiseEvent(tc,EVENT_SSET,e,REASON_EFFECT,tp,tp,0)
					local e1=Effect.CreateEffect(e:GetHandler())
					e1:SetType(EFFECT_TYPE_SINGLE)
					e1:SetCode(EFFECT_CANNOT_TRIGGER)
					e1:SetReset(RESET_EVENT+0x1fe0000)
					e1:SetValue(1)
					tc:RegisterEffect(e1)
				end
			end
		end
	end
end
function c22232201.tgvalue(e,re,rp)
	return rp~=e:GetHandlerPlayer()
end
function c22232201.dfilter(c)
	return c:IsPosition(POS_FACEDOWN_DEFENSE)
end
function c22232201.descon(e)
	return not Duel.IsExistingMatchingCard(c22232201.dfilter,tp,LOCATION_MZONE,0,1,nil)
end