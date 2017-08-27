--ＰＭ 土龙弟弟 
function c80000430.initial_effect(c)
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_QUICK_F)
	e1:SetDescription(aux.Stringid(80000430,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetCode(EVENT_CHAINING)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c80000430.discon)
	e1:SetTarget(c80000430.target)
	e1:SetOperation(c80000430.operation)
	c:RegisterEffect(e1)
end
function c80000430.discon(e,tp,eg,ep,ev,re,r,rp)
	return  rp~=tp 
end
function c80000430.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeck() end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetHandler(),1,0,0)
end
function c80000430.operation(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_EFFECT)
		Duel.BreakEffect()
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end