--忘却之海·幽冥紫
function c66678921.initial_effect(c)
	aux.AddXyzProcedure(c,nil,9,2)
	c:SetUniqueOnField(1,0,66678921)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_SET_ATTACK_FINAL)
	e3:SetValue(0)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
		return e:GetHandler():GetOverlayCount()>0
	end)
	e3:SetTargetRange(0,LOCATION_MZONE)
	e3:SetTarget(c66678921.distg)
	c:RegisterEffect(e3)
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
		if chk==0 then return Duel.IsExistingMatchingCard(c66678921.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
	end)
	e4:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c66678921.thfilter,tp,LOCATION_GRAVE,0,1,2,nil)
		if g:GetCount()>0 then
			Duel.HintSelection(g)
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end)
	c:RegisterEffect(e4)
end
function c66678921.distg(e,c)
	return c:GetSummonLocation()==LOCATION_EXTRA
end
function c66678921.thfilter(c)
	return c:IsSetCard(0x665) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand() and not c:IsHasEffect(EFFECT_NECRO_VALLEY)
end