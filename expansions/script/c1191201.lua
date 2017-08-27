--ELF·诱人庭院
function c1191201.initial_effect(c)
--
	c:SetUniqueOnField(1,0,1191201)
--  
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)  
	e1:SetCondition(c1191201.con1)
	c:RegisterEffect(e1)
--
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_ONFIELD)
	e4:SetValue(1)
	c:RegisterEffect(e4)
--  
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_SZONE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetOperation(c1191201.op2)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAIN_SOLVED)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCondition(c1191201.con3)
	e3:SetOperation(c1191201.op3)
	c:RegisterEffect(e3)
--
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetProperty(EFFECT_FLAG_DELAY)
	e5:SetCode(EVENT_TO_GRAVE)
	e5:SetCondition(c1191201.con5)
	e5:SetTarget(c1191201.tg5)
	e5:SetOperation(c1191201.op5)
	c:RegisterEffect(e5)
end
--
c1191201.named_with_ELF=1
function c1191201.IsELF(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_ELF
end
--
function c1191201.filter(c)
	return c:IsFaceup() and c1191201.IsELF(c) and c:IsType(TYPE_SYNCHRO)
end
function c1191201.con1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c1191201.filter,tp,LOCATION_MZONE,0,1,nil)
end
--
function c1191201.op2(e,tp,eg,ep,ev,re,r,rp)
	if rp==tp then return end
	e:GetHandler():RegisterFlagEffect(1191201,RESET_EVENT+0x1fc0000+RESET_CHAIN,0,1)
end
function c1191201.con3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return ep~=tp and c:GetFlagEffect(1191201)~=0
end
function c1191201.op3(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,1191201)
	Duel.Damage(1-tp,200,REASON_EFFECT)
end
--
function c1191201.con5(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD) 
end
function c1191201.tg5(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_MZONE,1,nil) end
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,g:GetCount(),0,0)
end
function c1191201.op5(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,nil)
	Duel.SendtoGrave(g,REASON_EFFECT)
end