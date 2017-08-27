--Shielder 玛修·基列莱特
function c21401101.initial_effect(c)
	c:EnableCounterPermit(0xf0f)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--scale
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CHANGE_LSCALE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCondition(c21401101.slcon)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CHANGE_RSCALE)
	c:RegisterEffect(e2)
	--to hand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(21401101,0))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetRange(LOCATION_PZONE)
	e3:SetCountLimit(1,21401101)
	e3:SetCode(EVENT_TO_DECK)
	e3:SetCost(c21401101.thcost1)
	e3:SetCondition(c21401101.thcon1)
	e3:SetTarget(c21401101.thtg1)
	e3:SetOperation(c21401101.thop1)
	c:RegisterEffect(e3)
	--to hand
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e4:SetTarget(c21401101.thtg2)
	e4:SetOperation(c21401101.tgop2)
	c:RegisterEffect(e4)
	--indes
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(21401101,0))
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_NO_TURN_RESET)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1+EFFECT_COUNT_CODE_DUEL)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetTarget(c21401101.target)
	e5:SetOperation(c21401101.operation)
	c:RegisterEffect(e5)
end 
function c21401101.slcon(e,tp,eg,ep,ev,re,r,rp)
	local seq=e:GetHandler():GetSequence()
	local tc=Duel.GetFieldCard(e:GetHandlerPlayer(),LOCATION_SZONE,13-seq)
	return tc and tc:IsSetCard(0xf00) and tc:GetLeftScale()==7
end
function c21401101.cfilter(c,tp)
	return c:IsPreviousLocation(LOCATION_SZONE) and (c:GetPreviousSequence()==6 or c:GetPreviousSequence()==7) and c:GetPreviousControler()==tp and c:IsSetCard(0xf00)
end
function c21401101.thcost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end       
    Duel.SendtoExtraP(e:GetHandler(),tp,REASON_COST)
end
function c21401101.thfilter(c,tp)
	return c:IsFaceup() and c:GetOwner()==tp and c:IsLocation(LOCATION_EXTRA) and c:IsSetCard(0xf00)
end
function c21401101.thcon1(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsExists(c21401101.thfilter,1,nil,tp)
end
function c21401101.thfilter1(c)
	return c:IsSetCard(0xf00) and c:IsAbleToHand()
end
function c21401101.thtg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c21401101.thfilter1,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c21401101.thop1(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(21401101,0))
	local g=Duel.SelectMatchingCard(tp,c21401101.thfilter1,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c21401101.thfilter2(c)
	return c:IsSetCard(0xf0b) and c:IsAbleToHand()
end
function c21401101.thtg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c21401101.thfilter2,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c21401101.tgop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(21401101,1))
	local g=Duel.SelectMatchingCard(tp,c21401101.thfilter2,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c21401101.filter(c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER)
end
function c21401101.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsOnField() and c21401101.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c21401101.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c21401101.filter,tp,LOCATION_ONFIELD,0,1,1,nil)
end
function c21401101.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and tc:IsControler(tp) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetCode(EFFECT_IMMUNE_EFFECT)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		e1:SetValue(c21401101.efilter)
		e1:SetOwnerPlayer(tp)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
		e2:SetValue(c21401101.valcon)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
	end
end
function c21401101.efilter(e,re)
	return e:GetOwnerPlayer()~=re:GetOwnerPlayer()
end
function c21401101.valcon(e,re,r,rp)
	return bit.band(r,REASON_BATTLE)~=0
end