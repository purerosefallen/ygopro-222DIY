--LA SY 先負的菲斯特菲
function c1200021.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--atk
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(1200021,0))
	e4:SetCategory(CATEGORY_ATKCHANGE)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_PZONE)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetCountLimit(1)
	e4:SetCost(c1200021.atkcost)
	e4:SetTarget(c1200021.atktg)
	e4:SetOperation(c1200021.atkop)
	c:RegisterEffect(e4)
	--indes
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e2:SetValue(c1200021.efilter)
	c:RegisterEffect(e2)
	--poschange
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(1200021,1))
	e2:SetCategory(CATEGORY_POSITION+CATEGORY_DESTROY+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1,1200021)
	e2:SetCondition(c1200021.poscon)
	e2:SetCost(c1200021.poscost)
	e2:SetTarget(c1200021.postg)
	e2:SetOperation(c1200021.posop)
	c:RegisterEffect(e2)
end
function c1200021.rfilter(c)
	return c:IsReleasable() and c:IsSetCard(0xfba) and c:IsType(TYPE_MONSTER)
end
function c1200021.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c1200021.rfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil) end
	local g=Duel.SelectMatchingCard(tp,c1200021.rfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil)
	Duel.Release(g,REASON_COST)
end
function c1200021.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_ATKCHANGE,g,1,0,0)
end
function c1200021.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return false end
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_SET_ATTACK_FINAL)
		e3:SetReset(RESET_EVENT+0x1fe0000)
		e3:SetValue(0)
		tc:RegisterEffect(e3)
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
		e4:SetCode(EVENT_LEAVE_FIELD)
		e4:SetOperation(c1200021.operation)
		tc:RegisterEffect(e4)
	end
end
function c1200021.operation(e,tp,eg,ep,ev,re,r,rp,chk)
	Duel.Damage(e:GetHandler():GetControler(),1000,REASON_EFFECT)
	e:Reset()
end
function c1200021.efilter(e,te)
	return te:GetHandlerPlayer()~=e:GetHandlerPlayer() and te:IsActiveType(TYPE_MONSTER)
end
function c1200021.cfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0xfba) and c:IsControler(tp)
end
function c1200021.poscon(e,tp,eg,ep,ev,re,r,rp)
	local c=Duel.GetAttackTarget()
	if not c then return false end
	if c:IsControler(1-tp) then c=Duel.GetAttacker() end
	return c and c1200021.cfilter(c,tp)
end
function c1200021.poscost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function c1200021.thfilter(c,tp)
	return c:IsCode(1200025) and c:IsAbleToHand()
end
function c1200021.postg(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=Duel.GetAttackTarget()
	if not tc then return false end
	if tc:IsControler(tp) then tc=Duel.GetAttacker() end
	if chk==0 then return tc:IsFaceup() and tc:IsCanTurnSet() end
	Duel.SetOperationInfo(0,CATEGORY_POSITION,tc,1,0,0)
end
function c1200021.posop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetAttackTarget()
	local dc=Duel.GetAttacker()
	if not tc then return false end
	if tc:IsControler(tp) and tc:IsSetCard(0xfba) then
		local sc=tc
		tc=dc
		dc=sc
	end
	if Duel.ChangePosition(tc,POS_FACEDOWN_DEFENSE)>0 and Duel.IsExistingMatchingCard(c1200021.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) and dc:IsDestructable() then
		if Duel.SelectYesNo(tp,aux.Stringid(1200021,2)) then
			Duel.BreakEffect()
			if Duel.Destroy(dc,REASON_EFFECT)>0 then
				local g=Duel.SelectMatchingCard(tp,c1200021.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
				if g then 
					Duel.SendtoHand(g,nil,REASON_EFFECT)
					Duel.ConfirmCards(1-tp,g)
				end
			end
		end
	end
end