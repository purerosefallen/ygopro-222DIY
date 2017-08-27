--Timer Ball
function c80000419.initial_effect(c)
	c:EnableCounterPermit(0x1b)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--add counter
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(80000419,0))
	e2:SetCategory(CATEGORY_COUNTER)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)
	e2:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e2:SetCondition(c80000419.ctcon)
	e2:SetOperation(c80000419.ctop)
	c:RegisterEffect(e2)  
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(80000419,1))
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_SZONE)
	e3:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
	e3:SetCountLimit(1)
	e3:SetCondition(c80000419.dcon1)
	e3:SetTarget(c80000419.sptg)
	e3:SetOperation(c80000419.spop)
	c:RegisterEffect(e3)
	--cannot target
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e4:SetValue(aux.tgoval)
	c:RegisterEffect(e4)
	--indes
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e5:SetRange(LOCATION_SZONE)
	e5:SetValue(c80000419.indval)
	c:RegisterEffect(e5)  
	--tohand
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(80000419,2))
	e6:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e6:SetType(EFFECT_TYPE_IGNITION)
	e6:SetRange(LOCATION_SZONE)
	e6:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
	e6:SetCountLimit(1)
	e6:SetTarget(c80000419.thtg)
	e6:SetCondition(c80000419.dcon2)
	e6:SetOperation(c80000419.thop)
	c:RegisterEffect(e6)
	--tohand
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(80000419,3))
	e7:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e7:SetType(EFFECT_TYPE_IGNITION)
	e7:SetRange(LOCATION_SZONE)
	e7:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
	e7:SetCountLimit(1)
	e7:SetCondition(c80000419.dcon3)
	e7:SetTarget(c80000419.thtg1)
	e7:SetOperation(c80000419.thop)
	c:RegisterEffect(e7)
	--win
	local e8=Effect.CreateEffect(c)
	e8:SetDescription(aux.Stringid(80000419,4))
	e8:SetType(EFFECT_TYPE_IGNITION)
	e8:SetRange(LOCATION_SZONE)
	e8:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
	e8:SetCountLimit(1)
	e8:SetCondition(c80000419.dcon4)
	e8:SetOperation(c80000419.winop)
	c:RegisterEffect(e8)
end
function c80000419.indval(e,re,tp)
	return tp~=e:GetHandlerPlayer()
end
function c80000419.dcon1(e)
	return e:GetHandler():GetCounter(0x1b)>=1
end
function c80000419.dcon2(e)
	return e:GetHandler():GetCounter(0x1b)>=4
end
function c80000419.dcon3(e)
	return e:GetHandler():GetCounter(0x1b)>=7
end
function c80000419.dcon4(e)
	return e:GetHandler():GetCounter(0x1b)>=10
end
function c80000419.ctcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function c80000419.ctop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():AddCounter(0x1b+COUNTER_NEED_ENABLE,1)
end
function c80000419.filter3(c)
	return c:IsAbleToHand()
end
function c80000419.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c80000419.filter3,tp,0,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(c80000419.filter3,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c80000419.spop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c80000419.filter3,tp,0,LOCATION_ONFIELD,1,1,nil)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		Duel.SendtoHand(g,nil,REASON_EFFECT)
	end
end
function c80000419.filter(c)
	return c:IsSetCard(0x2d0) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c80000419.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c80000419.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c80000419.thop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c80000419.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c80000419.filter1(c)
	return c:IsSetCard(0x2d2) and c:IsAbleToHand()
end
function c80000419.thtg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c80000419.filter1,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c80000419.winop(e,tp,eg,ep,ev,re,r,rp)
	local WIN_REASON_DISASTER_LEO=0x30
	Duel.Win(tp,WIN_REASON_DISASTER_LEO)
end