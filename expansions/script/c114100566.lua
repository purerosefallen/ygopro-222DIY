--★血染花の渇望　凶月咲耶
function c114100566.initial_effect(c)
	--remove
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c114100566.target)
	e1:SetOperation(c114100566.operation)
	c:RegisterEffect(e1)
	--Normal monster
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(EFFECT_ADD_TYPE)
	e2:SetRange(LOCATION_MZONE+LOCATION_GRAVE)
	e2:SetValue(TYPE_NORMAL)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_REMOVE_TYPE)
	e3:SetValue(TYPE_EFFECT)
	c:RegisterEffect(e3)
end
function c114100566.atkf(c)
	return c:IsAttribute(ATTRIBUTE_DARK) and c:GetAttack()==1500 and c:GetDefense()==800
end
function c114100566.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(c114100566.atkf,tp,LOCATION_MZONE,0,1,nil) and e:GetHandler():IsAbleToRemove() end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c114100566.atkf,tp,LOCATION_MZONE,0,1,1,nil)
end
function c114100566.operation(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT)
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) and tc:IsControler(tp) then
		Duel.BreakEffect()
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e1:SetValue(700)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetCode(EFFECT_UPDATE_ATTACK)
		e2:SetRange(LOCATION_MZONE)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		e2:SetTargetRange(0,LOCATION_MZONE)
		e2:SetValue(-700)
		tc:RegisterEffect(e2)
		local e3=e2:Clone()
		e3:SetCode(EFFECT_UPDATE_DEFENSE)
		tc:RegisterEffect(e3)
		if not tc:IsType(TYPE_EFFECT) then
			if tc:IsType(TYPE_NORMAL) then
				local e4=Effect.CreateEffect(e:GetHandler())
				e4:SetType(EFFECT_TYPE_SINGLE)
				e4:SetCode(EFFECT_REMOVE_TYPE)
				e4:SetReset(RESET_EVENT+0x1fe0000)
				e4:SetValue(TYPE_NORMAL)
				tc:RegisterEffect(e4,true)
			end
			local e5=Effect.CreateEffect(e:GetHandler())
			e5:SetType(EFFECT_TYPE_SINGLE)
			e5:SetCode(EFFECT_ADD_TYPE)
			e5:SetValue(TYPE_EFFECT)
			e5:SetReset(RESET_EVENT+0x1fe0000)
			tc:RegisterEffect(e5,true)
		end
	end
end