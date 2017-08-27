--1998 - 十六夜 原始木头 -
function c80006045.initial_effect(c)
	c:EnableReviveLimit()  
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,80006045)
	e1:SetCondition(c80006045.spcon)
	e1:SetOperation(c80006045.spop)
	c:RegisterEffect(e1)	
	--tohand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(80006045,0))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,91000186)
	e3:SetTarget(c80006045.target)
	e3:SetOperation(c80006045.operation)
	c:RegisterEffect(e3)
	--return grave
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(80006045,2))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,91000187)
	e2:SetCost(c80006045.rtgcost)
	e2:SetTarget(c80006045.rtgtg)
	e2:SetOperation(c80006045.rtgop)
	c:RegisterEffect(e2)
end
function c80006045.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetCustomActivityCount(80006045,tp,ACTIVITY_SUMMON)==0
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
end
function c80006045.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	Duel.RegisterEffect(e1,tp)
end
function c80006045.filter(c)
	return c:IsSetCard(0x2de) and c:IsAbleToHand() and c:IsType(TYPE_MONSTER)
end
function c80006045.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c80006045.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	Duel.SetChainLimit(c80006045.chainlm)
end
function c80006045.chainlm(e,rp,tp)
	return tp==rp
end
function c80006045.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c80006045.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c80006045.rtgcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c80006045.filter1(c)
	return c:IsFaceup() and c:IsSetCard(0x2de)
end
function c80006045.rtgtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_REMOVED) and c80006045.filter1(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c80006045.filter1,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectTarget(tp,c80006045.filter1,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,0)
end
function c80006045.rtgop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoGrave(tc,REASON_EFFECT+REASON_RETURN)
	end
end