--口袋妖怪 妙蛙花
function c80000011.initial_effect(c)
	c:EnableCounterPermit(0x18)
	c:EnableReviveLimit()
	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.FALSE)
	c:RegisterEffect(e1) 
	--search
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(80000011,0))
	e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_HAND)
	e4:SetCost(c80000011.cost)
	e4:SetTarget(c80000011.target)
	e4:SetOperation(c80000011.operation)
	c:RegisterEffect(e4) 
	--counter
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(80000011,3))
	e2:SetCategory(CATEGORY_COUNTER)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e2:SetCountLimit(1)
	e2:SetCondition(c80000011.ct)
	e2:SetOperation(c80000011.op)
	c:RegisterEffect(e2)
	--Add counter2
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e6:SetCode(EVENT_LEAVE_FIELD)
	e6:SetRange(LOCATION_MZONE)
	e6:SetOperation(c80000011.addop2)
	c:RegisterEffect(e6)
	--atk def
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_DAMAGE_CALCULATING)
	e8:SetRange(LOCATION_MZONE)
	e8:SetOperation(c80000011.adval)
	c:RegisterEffect(e8)
	--disable spsummon
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_FIELD)
	e9:SetRange(LOCATION_MZONE)
	e9:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e9:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e9:SetCondition(c80000011.descon)
	e9:SetTargetRange(0,1)
	c:RegisterEffect(e9)
	--battle indestructable
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE)
	e7:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCondition(c80000011.descon1)
	e7:SetValue(1)
	c:RegisterEffect(e7)
	--battle indestructable
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c80000011.descon2)
	e3:SetValue(1)
	c:RegisterEffect(e3)  
--indes
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e5:SetCondition(c80000011.descon3)
	e5:SetValue(1)
	c:RegisterEffect(e5)
end
c80000011.lvdncount=2
c80000011.lvdn={80000010,80000009}
function c80000011.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToGraveAsCost() and c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function c80000011.filter(c)
	return c:GetCode()==80000009 and c:IsAbleToHand()
end
function c80000011.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c80000011.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c80000011.operation(e,tp,eg,ep,ev,re,r,rp,chk)
	local tg=Duel.GetFirstMatchingCard(c80000011.filter,tp,LOCATION_DECK,0,nil)
	if tg then
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tg)
	end
end
function c80000011.ct(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==1-tp
end
function c80000011.op(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	local tc=g:GetFirst()
	while tc do
		tc:AddCounter(0x18,1)
		tc=g:GetNext()
	end
end
function c80000011.addown(c,e)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetReset(RESET_PHASE+RESET_DAMAGE_CAL)
	e1:SetValue(c:GetCounter(0x18)*-800)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e2)
end
function c80000011.adval(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	if not d then return end
	if a:GetCounter(0x18)>0 and d:IsCode(80000011) then c80000011.addown(a,e) end
	if d:GetCounter(0x18)>0 and a:IsCode(80000011) then c80000011.addown(d,e) end
end
function c80000011.addop2(e,tp,eg,ep,ev,re,r,rp)
	local count=0
	local c=eg:GetFirst()
	while c~=nil do
		if not c:IsCode(80000011) and c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsReason(REASON_DESTROY) then
			count=count+c:GetCounter(0x18)
		end
		c=eg:GetNext()
	end
	if count>0 then
		e:GetHandler():AddCounter(0x18,count)
	end
end
function c80000011.descon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetCounter(0x18)>2
end
function c80000011.descon1(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetCounter(0x18)>0
end
function c80000011.descon2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetCounter(0x18)>1
end
function c80000011.descon3(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetCounter(0x18)>3
end