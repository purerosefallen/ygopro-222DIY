--LA SY 佛滅的波達蝶斯
function c1200024.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--atk
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(1200024,0))
	e4:SetCategory(CATEGORY_ATKCHANGE)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_PZONE)
	e4:SetCountLimit(1)
	e4:SetCondition(c1200024.atkcon)
	e4:SetCost(c1200024.atkcost)
	e4:SetTarget(c1200024.atktg)
	e4:SetOperation(c1200024.atkop)
	c:RegisterEffect(e4)
	--special summon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(1200024,1))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_ATTACK_ANNOUNCE)
	e4:SetRange(LOCATION_PZONE)
	e4:SetCondition(c1200024.spcon)
	e4:SetTarget(c1200024.sptg)
	e4:SetOperation(c1200024.spop)
	c:RegisterEffect(e4)
	--indes
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e2:SetValue(c1200024.efilter)
	c:RegisterEffect(e2)
	--search
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetDescription(aux.Stringid(1200024,2))
	e3:SetRange(LOCATION_HAND)
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetCountLimit(1,1200024)
	e3:SetCondition(c1200024.thcon)
	e3:SetCost(c1200024.cost2)
	e3:SetTarget(c1200024.thtg)
	e3:SetOperation(c1200024.thop)
	c:RegisterEffect(e3)
	--todeck
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(1200024,3))
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1)
	e2:SetCost(c1200024.cost)
	e2:SetTarget(c1200024.target)
	e2:SetOperation(c1200024.activate)
	c:RegisterEffect(e2)



end
function c1200024.efilter(e,te)
	return te:GetHandlerPlayer()~=e:GetHandlerPlayer() and te:IsActiveType(TYPE_MONSTER)
end
function c1200024.rfilter(c)
	return c:IsReleasable() and c:IsSetCard(0xfba) and c:IsType(TYPE_MONSTER)
end
function c1200024.atkcon(e,tp,eg,ep,ev,re,r,rp,chk)
	return Duel.GetTurnPlayer()==tp
end
function c1200024.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c1200024.rfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil) end
	local g=Duel.SelectMatchingCard(tp,c1200024.rfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil)
	Duel.Release(g,REASON_COST)
end
function c1200024.tgfilter(c)
	return c:IsFaceup() and c:GetAttack()>500
end
function c1200024.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c1200024.tgfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_ATKCHANGE,0,0,0,0)
end
function c1200024.tgfilter2(c)
	return c:IsFaceup() and c:GetAttack()>500 and not (c:IsType(TYPE_XYZ) or c:IsType(TYPE_LINK))
end
function c1200024.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return false end
	if not Duel.IsExistingMatchingCard(c1200024.tgfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) then return false end
	local g=Duel.GetMatchingGroup(c1200024.tgfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	local tc=g:GetFirst()
	while tc do
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_UPDATE_ATTACK)
		e3:SetReset(RESET_EVENT+0x1fe0000)
		e3:SetValue(-500)
		tc:RegisterEffect(e3)
		tc=g:GetNext()
	end
	local g=Duel.GetMatchingGroup(c1200024.tgfilter2,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	local tc=g:GetFirst()
	while tc do
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_UPDATE_LEVEL)
		e3:SetReset(RESET_EVENT+0x1fe0000)
		e3:SetValue(1)
		tc:RegisterEffect(e3)
		tc=g:GetNext()
	end
end
function c1200024.spcon(e,tp,eg,ep,ev,re,r,rp)
	local at=Duel.GetAttacker()
	return at:GetControler()~=tp and Duel.GetAttackTarget()==nil
end
function c1200024.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c1200024.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return false end
	if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_LEAVE_FIELD)
		e1:SetOperation(c1200024.tgop)
		c:RegisterEffect(e1)
	end
end
function c1200024.tgop(e,tp,eg,ep,ev,re,r,rp)
	e:Reset()
	Duel.SendtoGrave(e:GetHandler(),REASON_EFFECT)
end
function c1200024.thcfilter(c)
	return c:IsSetCard(0xfba) and c:IsFaceup()
end
function c1200024.thcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c1200024.thcfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
end
function c1200024.thfilter(c)
	return c:IsSetCard(0xfbc) and c:IsAbleToHand()
end
function c1200024.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c1200024.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c1200024.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c1200024.thop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsExistingMatchingCard(c1200024.thfilter,tp,LOCATION_DECK,0,1,nil) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c1200024.thfilter,tp,LOCATION_DECK,0,1,1,nil)
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c1200024.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c1200024.tdfilter(c,e,tp)
	return c:IsSetCard(0xfba) and c:IsType(TYPE_MONSTER) and c:IsAbleToDeck()
end
function c1200024.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c1200024.tdfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,e:GetHandler()) and Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,nil,tp,LOCATION_GRAVE+LOCATION_REMOVED)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,1,tp,nil)
end
function c1200024.activate(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsExistingMatchingCard(c1200024.tdfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,e:GetHandler()) then return false end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c1200024.tdfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,5,e:GetHandler())
	if Duel.SendtoDeck(g,nil,2,REASON_EFFECT)>0 then
		Duel.ShuffleDeck(tp)
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end