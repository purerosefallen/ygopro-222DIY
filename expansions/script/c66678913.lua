--忘却之海·咏叹调
function c66678913.initial_effect(c)
	--Xyz
	aux.AddXyzProcedure(c,nil,7,3)
	c:EnableReviveLimit()
	--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetValue(function(e,re)
		return e:GetHandler():GetOverlayCount()>0 and e:GetOwnerPlayer()~=re:GetOwnerPlayer()
			and re:IsActiveType(TYPE_SPELL+TYPE_TRAP)
	end)
	c:RegisterEffect(e1)
	--
	--[[local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1)
	e2:SetTarget(function(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
		local fil=function(c) return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToChangeControler() end
		if chkc then return chkc:IsOnField() and fil(chkc) and chkc:IsControler(1-tp) end
		if chk==0 then return Duel.IsExistingTarget(fil,tp,0,LOCATION_ONFIELD,1,nil) end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
		Duel.SelectTarget(tp,fil,tp,0,LOCATION_ONFIELD,1,1,nil)
		Duel.SetChainLimit(function(e,lp,tp)
			return lp==tp or not e:IsActiveType(TYPE_SPELL+TYPE_TRAP)
		end)
	end)
	e2:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
		local tc=Duel.GetFirstTarget()
		if c:IsRelateToEffect(e) and tc and tc:IsRelateToEffect(e)
			and not tc:IsImmuneToEffect(e) and tc:IsAbleToChangeControler() then
			Duel.Overlay(e:GetHandler(),tc)
		end
	end)
	c:RegisterEffect(e2)]]
	--
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_TOHAND)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
		return bit.band(e:GetHandler():GetPreviousPosition(),POS_FACEUP)~=0
			and bit.band(e:GetHandler():GetPreviousLocation(),LOCATION_ONFIELD)~=0
	end)
	e4:SetTarget(function(e,tp,eg,ep,ev,re,r,rp,chk)
		if chk==0 then return Duel.IsExistingMatchingCard(c66678913.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
	end)
	e4:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c66678913.thfilter,tp,LOCATION_GRAVE,0,1,2,nil)
		if g:GetCount()>0 then
			Duel.HintSelection(g)
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end)
	c:RegisterEffect(e4)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_NEGATE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetCountLimit(1)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(c66678913.distg)
	e2:SetOperation(c66678913.disop)
	c:RegisterEffect(e2)
end
function c66678913.thfilter(c)
	return c:IsSetCard(0x665) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand() and not c:IsHasEffect(EFFECT_NECRO_VALLEY)
end
function c66678913.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev)
		and re:IsHasType(EFFECT_TYPE_ACTIVATE) end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function c66678913.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
	local c,tc=e:GetHandler(),re:GetHandler()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(re) and not tc:IsImmuneToEffect(e) then
		local og=tc:GetOverlayGroup()
		if og:GetCount()>0 then
			Duel.SendtoGrave(og,REASON_RULE)
		end
		if bit.band(tc:GetOriginalType(),TYPE_TOKEN)==TYPE_TOKEN then
			Duel.SendtoGrave(tc,REASON_RULE)
		else
			tc:CancelToGrave()
			Duel.Overlay(c,Group.FromCards(tc))			
		end
	end
end