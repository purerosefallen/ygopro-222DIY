--DRRR!! 甘乐
function c80003038.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	c:SetUniqueOnField(1,0,80003038)
	aux.AddFusionProcCodeFun(c,80003034,aux.FilterBoolFunction(Card.IsSetCard,0x2da),1,true,false)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.fuslimit)
	c:RegisterEffect(e1)  
	--handes
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(80003038,0))
	e3:SetCategory(CATEGORY_TODECK)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)  
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCondition(c80003038.condition)
	e3:SetTarget(c80003038.target)
	e3:SetOperation(c80003038.operation)
	c:RegisterEffect(e3)  
	--tohand
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(80003038,1))
	e4:SetCategory(CATEGORY_TOHAND)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetCondition(c80003038.condition2)
	e4:SetTarget(c80003038.thtg)
	e4:SetOperation(c80003038.thop)
	c:RegisterEffect(e4) 
	--tohand
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(80003038,2))
	e5:SetCategory(CATEGORY_REMOVE)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1)
	e5:SetCondition(c80003038.condition1)
	e5:SetTarget(c80003038.thtg1)
	e5:SetOperation(c80003038.thop1)
	c:RegisterEffect(e5) 
end
function c80003038.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_FUSION 
end
function c80003038.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,1-tp,LOCATION_HAND)
	Duel.SetChainLimit(c80003038.chainlm)
end
function c80003038.chainlm(e,rp,tp)
	return tp==rp
end
function c80003038.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(ep,0,LOCATION_HAND,nil)
	if g:GetCount()==0 then return end
	local sg=g:RandomSelect(1-tp,1)
	Duel.SendtoDeck(sg,nil,2,REASON_EFFECT)
end
function c80003038.filter(c)
	return bit.band(c:GetSummonType(),SUMMON_TYPE_SPECIAL)==SUMMON_TYPE_SPECIAL and c:IsAbleToHand()
end
function c80003038.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c80003038.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c80003038.filter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,c80003038.filter,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,g:GetCount(),0,0)
	Duel.SetChainLimit(c80003038.chainlm)
end
function c80003038.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end
function c80003038.cfilter(c,tp)
	return c:GetSummonPlayer()==tp and c:IsPreviousLocation(LOCATION_EXTRA)
end
function c80003038.condition2(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return eg:IsExists(c80003038.cfilter,1,nil,tp) and (ph==PHASE_MAIN1 or ph==PHASE_MAIN2) and Duel.GetTurnPlayer()==tp
end
function c80003038.filter1(c)
	return bit.band(c:GetSummonType(),SUMMON_TYPE_SPECIAL)==SUMMON_TYPE_SPECIAL and c:IsAbleToRemove()
end
function c80003038.thtg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c80003038.filter1(chkc) end
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,c80003038.filter1,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
	Duel.SetChainLimit(c80003038.chainlm)
end
function c80003038.thop1(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
	end
end
function c80003038.cfilter1(c,tp)
	return c:GetSummonPlayer()~=tp and c:IsPreviousLocation(LOCATION_EXTRA)
end
function c80003038.condition1(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return eg:IsExists(c80003038.cfilter1,1,nil,tp) and (ph==PHASE_MAIN1 or ph==PHASE_MAIN2) and Duel.GetTurnPlayer()~=tp
end