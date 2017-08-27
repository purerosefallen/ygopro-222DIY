--千年之泪
function c66678917.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	--e1:SetCountLimit(1,66678917+EFFECT_COUNT_CODE_OATH)
	e1:SetOperation(c66678917.activate)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1)
	e2:SetTarget(c66678917.mattg)
	e2:SetOperation(c66678917.matop)
	c:RegisterEffect(e2)
	--
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_CHAINING)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
		return ep~=tp
	end)
	e4:SetCost(function(e,tp,eg,ep,ev,re,r,rp,chk)
		if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
		Duel.SendtoGrave(e:GetHandler(),REASON_COST)
	end)
	e4:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_IMMUNE_EFFECT)
		e1:SetTargetRange(LOCATION_MZONE,0)
		e1:SetTarget(function(e,c)
			return c:IsFaceup() and c:IsSetCard(0x665) and c:IsType(TYPE_XYZ)
		end)
		e1:SetValue(function(e,te)
			return te:GetOwnerPlayer()~=e:GetOwnerPlayer()
		end)
		e1:SetReset(RESET_CHAIN)
		Duel.RegisterEffect(e1,tp)
	end)
	c:RegisterEffect(e4)
end
function c66678917.filter(c)
	return c:IsSetCard(0x665) and c:IsAbleToHand() and c:IsType(TYPE_MONSTER)
end
function c66678917.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(c66678917.filter,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(66678917,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end
function c66678917.xyzfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:IsSetCard(0x665)
end
function c66678917.matfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x665) and c:IsType(TYPE_MONSTER)
end
function c66678917.mattg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c66678917.xyzfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c66678917.xyzfilter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingMatchingCard(c66678917.matfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c66678917.xyzfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c66678917.matop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
		local g=Duel.SelectMatchingCard(tp,c66678917.matfilter,tp,LOCATION_GRAVE,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.Overlay(tc,g)
		end
	end
end