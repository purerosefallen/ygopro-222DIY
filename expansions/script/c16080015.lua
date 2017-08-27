--天地祈词
function c16080015.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_POSITION)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCondition(c16080015.condition)
	e1:SetTarget(c16080015.target)
	e1:SetOperation(c16080015.activate)
	c:RegisterEffect(e1)
end
function c16080015.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()~=PHASE_DAMAGE or not Duel.IsDamageCalculated()
end
function c16080015.filter(c)
	return c:IsAttackPos() and c:IsFaceup() and c:IsSetCard(0x5ca) and not c:IsType(TYPE_LINK)
end
function c16080015.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c16080015.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c16080015.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c16080015.filter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c16080015.dsfilter(c)
	return c:IsDestructable() and c:IsFaceup()
end
function c16080015.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsFaceup() and tc:IsRelateToEffect(e) then
		Duel.ChangePosition(tc,POS_FACEUP_DEFENSE)
			if tc:IsOnField() and Duel.SelectYesNo(tp,aux.Stringid(16080015,1)) then 
			Duel.BreakEffect() 
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
			local g=Duel.SelectMatchingCard(tp,c16080015.dsfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
			Duel.HintSelection(g)
			Duel.Destroy(g,REASON_EFFECT)
		end
	end
end