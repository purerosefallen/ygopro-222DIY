--感谢型亚瑟们
function c17060836.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(c17060836.activate)
	c:RegisterEffect(e1)
	--indes
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e2:SetCondition(c17060836.effcon)
	e2:SetValue(1)
	e2:SetLabel(3)
	c:RegisterEffect(e2)
	--indes
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e3:SetRange(LOCATION_FZONE)
	e3:SetTargetRange(LOCATION_MZONE+LOCATION_PZONE,0)
	e3:SetCondition(c17060836.effcon)
	e3:SetTarget(c17060836.indtg)
	e3:SetValue(1)
	e3:SetLabel(5)
	c:RegisterEffect(e3)
	local e3b=e3:Clone()
	e3b:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e3b:SetValue(aux.tgoval)
	c:RegisterEffect(e3b)
end
c17060836.is_named_with_Million_Arthur=1
function c17060836.IsMillion_Arthur(c)
	local m=_G["c"..c:GetCode()]
	return m and m.is_named_with_Million_Arthur
end
function c17060836.thfilter(c)
	return c:IsType(TYPE_MONSTER) and c17060836.IsMillion_Arthur(c) and c:IsAbleToHand()
end
function c17060836.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(c17060836.thfilter,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(17060836,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end
function c17060836.cfilter(c)
	return c:IsFaceup() and c17060836.IsMillion_Arthur(c)
end
function c17060836.effcon(e)
	return Duel.GetMatchingGroup(c17060836.cfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,nil):GetClassCount(Card.GetCode)>=e:GetLabel()
end
function c17060836.indtg(e,c)
	return c:IsType(TYPE_PENDULUM)
end