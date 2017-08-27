--新津 青之王
function c16080019.initial_effect(c)
	aux.AddSynchroProcedure(c,c16080019.tfilter,aux.NonTuner(Card.IsType,TYPE_SYNCHRO),1)
	c:EnableReviveLimit()   
	--effect cant
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetCondition(c16080019.atcon)
	e1:SetTarget(c16080019.tglimit)
	e1:SetValue(aux.tgoval)
	c:RegisterEffect(e1)
	--cannot tohand
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DISABLE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_QUICK_F)
	e2:SetCode(EVENT_CHANGE_POS)
	e2:SetCondition(c16080019.thcon)
	e2:SetOperation(c16080019.thop)
	c:RegisterEffect(e2)
	--disable
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_NEGATE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL+EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,16080019)
	e3:SetCondition(c16080019.discon)
	e3:SetTarget(c16080019.distg)
	e3:SetOperation(c16080019.disop)
	c:RegisterEffect(e3)
end
function c16080019.tfilter(c)
	return c:IsSetCard(0x5ca) and c:IsType(TYPE_SYNCHRO)
end
function c16080019.atcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetPosition()==POS_FACEUP_ATTACK 
end
function c16080019.tglimit(e,c)
	return c~=e:GetHandler()
end
function c16080019.thcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return not c:IsStatus(STATUS_CONTINUOUS_POS) and (c:IsPosition(POS_FACEUP_DEFENSE) and c:IsPreviousPosition(POS_FACEUP_ATTACK)) or (c:IsPosition(POS_FACEUP_ATTACK) and c:IsPreviousPosition(POS_FACEUP_DEFENSE)) 
end
function c16080019.thop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_TO_HAND)
	e1:SetTargetRange(0,LOCATION_DECK)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetCondition(c16080019.condition)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_CANNOT_DRAW)
	e2:SetReset(RESET_PHASE+PHASE_END)
	e1:SetCondition(c16080019.condition)
	e2:SetTargetRange(0,1)
	Duel.RegisterEffect(e2,tp)
end
function c16080019.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()~=PHASE_DRAW
end
function c16080019.discon(e,tp,eg,ep,ev,re,r,rp)
	if ep==tp then return false end
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev)
end
function c16080019.filter(c)
	return c:IsType(TYPE_MONSTER) and not c:IsType(TYPE_LINK)
end
function c16080019.distg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c16080019.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c16080019.filter,tp,LOCATION_MZONE,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c16080019.filter,tp,LOCATION_MZONE,0,1,1,e:GetHandler())
end
function c16080019.disop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsFaceup() and tc:IsRelateToEffect(e) then
		Duel.ChangePosition(tc,POS_FACEUP_DEFENSE,POS_FACEDOWN_DEFENSE,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK)
			if tc:IsOnField() then
			 Duel.NegateActivation(ev)
		end
	end
end