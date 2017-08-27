--新津 望月之城
function c16080016.initial_effect(c)
	c:SetUniqueOnField(1,0,16080016)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--cannot Remove
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_REMOVE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,1)
	e2:SetValue(c16080016.aclimit)
	c:RegisterEffect(e2)
	-- changge
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(16080016,0))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_DESTROYED)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e4:SetCondition(c16080016.descon)
	e4:SetTarget(c16080016.destg)
	e4:SetOperation(c16080016.desop)
	c:RegisterEffect(e4)
end
function c16080016.aclimit(e,re,tp)
	return re:IsType(TYPE_MONSTER) 
end
function c16080016.descon(e,tp,eg,ep,ev,re,r,rp)
	return rp~=tp and e:GetHandler():GetPreviousControler()==tp
end
function c16080016.filter(c)
	return c:IsFaceup() and not c:IsType(TYPE_LINK)
end
function c16080016.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c16080016.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c16080016.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c16080016.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
end
function c16080016.thfilter(c)
	return c:IsAbleToDeck() and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c16080016.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsFaceup() and tc:IsRelateToEffect(e) then
		Duel.ChangePosition(tc,POS_FACEUP_DEFENSE,POS_FACEDOWN_DEFENSE,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK)
		if tc:IsOnField() and Duel.SelectYesNo(tp,aux.Stringid(16080016,1)) then
		   local g=Duel.GetFieldGroup(c16080016.thfilter,LOCATION_REMOVED,LOCATION_REMOVED)
		   Duel.SendtoDeck(g,nil,2,REASON_EFFECT) 
		end
	end
end