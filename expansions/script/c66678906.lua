--忘却之海的妖女
function c66678906.initial_effect(c)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
		return e:GetHandler():GetSummonType()==SUMMON_TYPE_ADVANCE
	end)
	e1:SetTarget(function(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
		if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() end
		if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
		local g=Duel.SelectTarget(tp,Card.IsFaceup,tp,0,LOCATION_MZONE,1,1,nil)
		Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,1,0,0)
	end)
	e1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
		local c=e:GetHandler()
		local tc=Duel.GetFirstTarget()
		if c:IsRelateToEffect(e) and tc:IsFaceup() and tc:IsRelateToEffect(e) and c:IsControler(1-tp) then
			c:SetCardTarget(tc)
			Duel.NegateRelatedChain(tc,RESET_TURN_SET)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_OWNER_RELATE)
			e1:SetCode(EFFECT_SET_ATTACK_FINAL)
			e1:SetValue(0)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			e1:SetCondition(function(e)
				return e:GetOwner():IsHasCardTarget(e:GetHandler())
			end)
			tc:RegisterEffect(e1,true)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_DISABLE)
			tc:RegisterEffect(e2,true)
			local e3=e1:Clone()
			e3:SetCode(EFFECT_DISABLE_EFFECT)
			e3:SetValue(RESET_TURN_SET)
			tc:RegisterEffect(e3,true)
		end
	end)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
	e2:SetCountLimit(1)
	e2:SetValue(function(e,re,r,rp)
		return bit.band(r,REASON_BATTLE)~=0
	end)
	c:RegisterEffect(e2)
	--
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e3:SetRange(LOCATION_HAND)
	e3:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
		return ep~=tp and re:IsActiveType(TYPE_MONSTER) and Duel.IsChainNegatable(ev)
	end)
	e3:SetCost(function(e,tp,eg,ep,ev,re,r,rp,chk)
		local fil1,fil2=
			function(c) return c:GetOverlayCount()~=0 end,
			function(c) return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x665) and c:IsAbleToGraveAsCost() end
		if chk==0 then return Duel.IsExistingMatchingCard(fil1,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
			and Duel.IsExistingMatchingCard(fil2,tp,LOCATION_HAND,0,1,e:GetHandler())
			and e:GetHandler():IsAbleToGraveAsCost() end
		Duel.Hint(HINT_SELECTMSG,tp,532)
		local g1=Duel.SelectMatchingCard(tp,fil1,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
		g1:GetFirst():RemoveOverlayCard(tp,1,1,REASON_COST)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g2=Duel.SelectMatchingCard(tp,fil2,tp,LOCATION_HAND,0,1,1,e:GetHandler())
		g2:AddCard(e:GetHandler())
		Duel.SendtoGrave(g2,REASON_COST)
	end)
	e3:SetTarget(function(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
		Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
		if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
			Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
		end
	end)
	e3:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
		Duel.NegateActivation(ev)
		if re:GetHandler():IsRelateToEffect(re) then
			Duel.Destroy(eg,REASON_EFFECT)
		end
	end)
	c:RegisterEffect(e3)
end
