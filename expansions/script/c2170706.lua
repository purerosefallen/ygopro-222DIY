--七曜-土符『慵懒三石塔』
function c2170706.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,2170706+EFFECT_COUNT_CODE_OATH)
	e1:SetOperation(c2170706.activate)
	c:RegisterEffect(e1)
	--atk down
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetTargetRange(0,LOCATION_MZONE)
	e3:SetCondition(c2170706.sdcon)
	e3:SetValue(-300)
	c:RegisterEffect(e3)
end
function c2170706.filter(c)
	return c:IsCode(2170701) and c:IsAbleToHand()
end
function c2170706.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(c2170706.filter,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(2170706,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end
function c2170706.rmtarget(e,c)
	return not c:IsSetCard(0x211)
end
function c2170706.sdfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x211)
end
function c2170706.sdcon(e)
	return Duel.IsExistingMatchingCard(c2170706.sdfilter,e:GetHandlerPlayer(),LOCATION_GRAVE,0,1,nil)
end