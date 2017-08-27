--口袋妖怪 大菊花
function c80000178.initial_effect(c)
	c:EnableReviveLimit()
	--cannot special summon
	local e5=Effect.CreateEffect(c)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_SPSUMMON_CONDITION)
	e5:SetValue(aux.FALSE)
	c:RegisterEffect(e5) 
	--search
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(80000178,0))
	e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_HAND)
	e4:SetCost(c80000178.cost)
	e4:SetTarget(c80000178.target)
	e4:SetOperation(c80000178.operation)
	c:RegisterEffect(e4) 
	--indes
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--counter
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(80000178,1))
	e2:SetCategory(CATEGORY_COUNTER)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_BATTLED)
	e2:SetCondition(c80000178.ctcon)
	e2:SetOperation(c80000178.ctop)
	c:RegisterEffect(e2)
	--avoid battle damage
	local e3=e1:Clone()
	e3:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
	c:RegisterEffect(e3)
	--Pos Change
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_FIELD)
	e9:SetCode(EFFECT_SET_POSITION)
	e9:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e9:SetRange(LOCATION_MZONE)
	e9:SetTargetRange(0,LOCATION_MZONE)
	e9:SetCondition(c80000178.poscon)
	e9:SetValue(POS_FACEUP_ATTACK)
	c:RegisterEffect(e9)
	--must attack
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_FIELD)
	e7:SetCode(EFFECT_MUST_ATTACK)
	e7:SetRange(LOCATION_MZONE)
	e7:SetTargetRange(0,LOCATION_MZONE)
	c:RegisterEffect(e7)
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE)
	e8:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e8:SetCode(EFFECT_MUST_BE_ATTACKED)
	e8:SetRange(LOCATION_MZONE)
	c:RegisterEffect(e8)
	--Activate
	local e6=Effect.CreateEffect(c)
	e6:SetCategory(CATEGORY_CONTROL)
	e6:SetType(EFFECT_TYPE_IGNITION)
	e6:SetRange(LOCATION_MZONE)
	e6:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e6:SetCountLimit(1,80000178)
	e6:SetCondition(c80000178.condition)
	e6:SetTarget(c80000178.target1)
	e6:SetOperation(c80000178.operation1)
	c:RegisterEffect(e6)
end
c80000178.lvdncount=2
c80000178.lvdn={80000177,80000176}
function c80000178.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN2
end
function c80000178.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToGraveAsCost() and c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function c80000178.filter233(c)
	return c:GetCode()==80000176 and c:IsAbleToHand()
end
function c80000178.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c80000178.filter233,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c80000178.operation(e,tp,eg,ep,ev,re,r,rp,chk)
	local tg=Duel.GetFirstMatchingCard(c80000178.filter233,tp,LOCATION_DECK,0,nil)
	if tg then
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tg)
	end
end
function c80000178.poscon(e)
	local ph=Duel.GetCurrentPhase()
	return Duel.GetTurnPlayer()~=e:GetHandler():GetControler() and ph>=0x8 and ph<=0x20
end
function c80000178.filter1(c)
	return c:GetCounter(0x18)>0 and c:IsControlerCanBeChanged()
end
function c80000178.target1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c80000178.filter1(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c80000178.filter1,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
	local g=Duel.SelectTarget(tp,c80000178.filter1,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,g,1,0,0)
end
function c80000178.operation1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:GetCounter(0x18)>0 then
		c:SetCardTarget(tc)
		local e1=Effect.CreateEffect(c)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_OWNER_RELATE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_CONTROL)
		e1:SetValue(tp)
		e1:SetReset(RESET_EVENT+0x1fc0000)
		tc:RegisterEffect(e1)
	end
end
function c80000178.ctcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local a=Duel.GetAttacker()
	if a==c then a=Duel.GetAttackTarget() end
	e:SetLabelObject(a)
	return a and a:IsType(TYPE_EFFECT) and a:IsRelateToBattle()
end
function c80000178.ctop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:IsFacedown() or not tc:IsRelateToBattle() then return end
		tc:AddCounter(0x18,1)
end


