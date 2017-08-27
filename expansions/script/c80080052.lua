--诛仙剑
function c80080052.initial_effect(c)
	--immune
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_IMMUNE_EFFECT)
	e0:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e0:SetRange(LOCATION_SZONE)
	e0:SetValue(c80080052.efilter1)
	c:RegisterEffect(e0)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e1:SetTarget(c80080052.target)
	e1:SetOperation(c80080052.operation)
	c:RegisterEffect(e1)
	--equip limit
	local e2=Effect.CreateEffect(c)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_EQUIP_LIMIT)
	e2:SetValue(c80080052.eqlimit)
	c:RegisterEffect(e2)
	--atk/def
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_EQUIP)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e3:SetValue(1000)
	c:RegisterEffect(e3)
	--immune
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_EQUIP)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e5:SetCode(EFFECT_IMMUNE_EFFECT)
	e5:SetValue(c80080052.efilter)
	c:RegisterEffect(e5) 
	--tohand
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(80080052,0))
	e6:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e6:SetType(EFFECT_TYPE_IGNITION)
	e6:SetRange(LOCATION_SZONE)
	e6:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e6:SetCountLimit(1)
	e6:SetTarget(c80080052.thtg)
	e6:SetOperation(c80080052.thop)
	c:RegisterEffect(e6)  
	--release or damage
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(80080052,1))
	e7:SetCategory(CATEGORY_RELEASE)
	e7:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e7:SetCode(EVENT_PHASE+PHASE_END)
	e7:SetRange(LOCATION_SZONE)
	e7:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e7:SetCountLimit(1)
	e7:SetOperation(c80080052.phop)
	c:RegisterEffect(e7)
end
function c80080052.filter(c)
	return c:IsFaceup() and c:IsCode(80080012)
end
function c80080052.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c81810441.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c80080052.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,c80080052.filter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function c80080052.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if e:GetHandler():IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Equip(tp,e:GetHandler(),tc)
	end
end
function c80080052.eqlimit(e,c)
	return c:IsCode(80080012) and c:GetControler()==e:GetHandler():GetControler()
end
function c80080052.efilter(e,re)
	return e:GetOwner()~=re:GetOwner()
end
function c80080052.efilter1(e,te)
	return te:GetOwner()~=e:GetOwner()
end
function c80080052.filter1(c)
	return c:IsCode(197520711) and c:IsAbleToHand()
end
function c80080052.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c80080052.filter1,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c80080052.thop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c80080052.filter1,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c80080052.filter2(c)
	return c:IsSetCard(0x32d6) and c:IsType(TYPE_MONSTER)
end
function c80080052.phop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.CheckReleaseGroup(tp,c80080052.filter2,1,e:GetHandler()) and Duel.SelectYesNo(tp,aux.Stringid(80080052,2)) then
		Duel.Release(Duel.SelectReleaseGroup(tp,c80080052.filter2,1,1,e:GetHandler()),REASON_EFFECT)
	else Duel.SetLP(tp,Duel.GetLP(tp)-4000) end
end