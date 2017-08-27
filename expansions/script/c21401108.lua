--Berserker 吕布奉先
function c21401108.initial_effect(c)
	c:EnableCounterPermit(0xf0f)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--tohand
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCost(c21401108.thcost)
	e1:SetTarget(c21401108.thtg)
	e1:SetOperation(c21401108.thop)
	c:RegisterEffect(e1)
	--atkup
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetCondition(c21401108.atkcon)
	e2:SetValue(600)
	c:RegisterEffect(e2)
	--pierce
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_PIERCE)
	c:RegisterEffect(e3)
	--to defense
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_DAMAGE_STEP_END)
	e4:SetCondition(c21401108.poscon)
	e4:SetOperation(c21401108.posop)
	c:RegisterEffect(e4)
	--destroy
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e5:SetCountLimit(1,21401108)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1)
	e5:SetCost(c21401108.descost)
	e5:SetTarget(c21401108.destg)
	e5:SetOperation(c21401108.desop)
	c:RegisterEffect(e5)
end
function c21401108.cfilter(c)
	return c:IsAbleToHand() and c:IsType(TYPE_EQUIP) and c:IsSetCard(0xf0b)
end
function c21401108.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SendtoExtraP(e:GetHandler(),1-tp,REASON_COST)
end
function c21401108.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c21401108.cfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c21401108.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(21401108,0))
		local g=Duel.SelectMatchingCard(tp,c21401108.cfilter,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
end
function c21401108.atkcon(e)
	local c=e:GetHandler()
	local ph=Duel.GetCurrentPhase()
	return  ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE
end
function c21401108.poscon(e,tp,eg,ep,ev,re,r,rp)
	local bg=Duel.GetAttackTarget()
	return e:GetHandler()==Duel.GetAttacker() and e:GetHandler():IsRelateToBattle() and bg~=nil and bit.band(bg:GetBattlePosition(),POS_DEFENSE)~=0
end
function c21401108.posop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsAttackPos() then
		Duel.ChangePosition(c,POS_FACEUP_DEFENSE)
	end
end
function c21401108.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanRemoveCounter(tp,0xf0f,3,REASON_COST) end
	local c1=e:GetHandler():GetCounter(0xf0f)
	e:GetHandler():RemoveCounter(tp,0xf0f,3,REASON_COST)
	local c2=e:GetHandler():GetCounter(0xf0f)
	if c1==c2+3 then
	Duel.RaiseEvent(e:GetHandler(),EVENT_CUSTOM+0xf0f,e,0,tp,0,0)
	end
end
function c21401108.filter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c21401108.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and c21401108.filter(chkc) and chkc~=e:GetHandler() end
	if chk==0 then return Duel.IsExistingTarget(c21401108.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(21401108,1))
	local g=Duel.SelectTarget(tp,c21401108.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,2,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c21401108.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	Duel.Destroy(g,REASON_EFFECT)
end