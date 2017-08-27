--光辉之樱 艾儿
function c121053292.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--splimit
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetRange(LOCATION_PZONE)
    e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
    e1:SetTargetRange(1,0)
    e1:SetCondition(c121053292.splimcon)
    e1:SetTarget(c121053292.splimit)
    c:RegisterEffect(e1)
	--attack all
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(121053292,0))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_PZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1)
	e2:SetCondition(c121053292.condition)
	e2:SetTarget(c121053292.target)
	e2:SetOperation(c121053292.operation)
	c:RegisterEffect(e2)
	--hand
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(121053292,4))
    e3:SetCategory(CATEGORY_HANDES+CATEGORY_DAMAGE)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetRange(LOCATION_MZONE)
    e3:SetCode(EVENT_DAMAGE_STEP_END)
    e3:SetCondition(c121053292.effcon)
    e3:SetTarget(c121053292.attar)
    e3:SetOperation(c121053292.atop)
    c:RegisterEffect(e3)
	--tohand
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_TOHAND)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e4:SetCode(EVENT_LEAVE_FIELD)
	e4:SetCountLimit(1,121053292)
	e4:SetCondition(c121053292.thcon)
	e4:SetTarget(c121053292.thtg)
	e4:SetOperation(c121053292.thop)
	c:RegisterEffect(e4)
end
function c121053292.splimcon(e)
    return not e:GetHandler():IsForbidden()
end
function c121053292.splimit(e,c,tp,sumtp,sumpos)
    return not c:IsSetCard(0x121) and bit.band(sumtp,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function c121053292.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsAbleToEnterBP()
end
function c121053292.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x121)
end
function c121053292.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c121053292.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c121053292.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c121053292.filter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c121053292.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and e:GetHandler():IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_ATTACK_ALL)
		e1:SetValue(c121053292.atkfilter)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
end
function c121053292.atkfilter(e,c)
	return bit.band(c:GetSummonType(),SUMMON_TYPE_SPECIAL)==SUMMON_TYPE_SPECIAL
end
function c121053292.effcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler()==Duel.GetAttacker() and e:GetHandler():IsRelateToBattle()
end
function c121053292.attar(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,1-tp,1)
end
function c121053292.atop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
    if g:GetCount()>0 then
        local sg=g:RandomSelect(1-tp,1)
        Duel.SendtoGrave(sg,REASON_EFFECT+REASON_DISCARD)
        local tc=sg:GetFirst()
        if tc:IsType(TYPE_MONSTER) then
            Duel.Damage(1-tp,tc:GetLevel()*200,REASON_EFFECT)
        end
    end
end
function c121053292.thcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousPosition(POS_FACEUP) and c:GetLocation()~=LOCATION_DECK
end
function c121053292.thfilter(c)
	return c:IsSetCard(0x121) and c:IsType(TYPE_MONSTER)  and c:IsAbleToHand()
		and ((c:IsFaceup() and c:IsLocation(LOCATION_EXTRA) and c:IsType(TYPE_PENDULUM)) or c:IsLocation(LOCATION_GRAVE))
end
function c121053292.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c121053292.thfilter,tp,LOCATION_GRAVE+LOCATION_EXTRA,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE+LOCATION_EXTRA)
end
function c121053292.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c121053292.thfilter,tp,LOCATION_GRAVE+LOCATION_EXTRA,0,1,1,nil)
	if g:GetCount()>0 then
		if g:GetFirst():IsHasEffect(EFFECT_NECRO_VALLEY) and Duel.IsChainDisablable(0) then
			Duel.NegateEffect(0)
			return
		end
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
