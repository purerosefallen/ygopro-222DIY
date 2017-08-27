--1998 - 十六夜 布兰度 -
function c80006015.initial_effect(c)
	c:EnableReviveLimit() 
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(80006015,0))
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,80006015)
	e1:SetTarget(c80006015.limtg1)
	e1:SetCost(c80006015.thcost)
	e1:SetTarget(c80006015.target)
	e1:SetOperation(c80006015.activate)
	c:RegisterEffect(e1)  
	--activate limit
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(80006015,1))
	e6:SetCode(CATEGORY_TODECK)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e6:SetProperty(EFFECT_FLAG_DELAY)
	e6:SetCode(EVENT_SPSUMMON_SUCCESS)
	e6:SetCountLimit(1,91000053)
	e6:SetTarget(c80006015.limtg)
	e6:SetCondition(c80006015.actcon)
	e6:SetOperation(c80006015.actop)
	c:RegisterEffect(e6)
	--chain attack
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(80006015,2))
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_BATTLED)
	e3:SetCountLimit(1,91000051)
	e3:SetTarget(c80006015.limtg1)
	e3:SetCondition(c80006015.atcon)
	e3:SetOperation(c80006015.atop)
	c:RegisterEffect(e3)
end
function c80006015.limtg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetChainLimit(c80006015.chainlm)
end
function c80006015.limtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
	Duel.SetChainLimit(c80006015.chainlm)
end
function c80006015.chainlm(e,rp,tp)
	return tp==rp
end
function c80006015.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable() and Duel.GetCustomActivityCount(80006015,tp,ACTIVITY_CHAIN)==0 end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function c80006015.tgfilter(c)
	return c:IsSetCard(0x2de) and not c:IsCode(80006015) and c:IsAbleToGrave()
end
function c80006015.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c80006015.tgfilter,tp,LOCATION_DECK,0,2,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,2,tp,LOCATION_DECK)
	Duel.SetChainLimit(c80006015.chainlm)
end
function c80006015.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c80006015.tgfilter,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>=2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local sg=g:Select(tp,2,2,nil)
		Duel.SendtoGrave(sg,REASON_EFFECT)
	end
end
function c80006015.actcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_RITUAL 
end
function c80006015.actop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD,1,1,nil)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
	end
end
function c80006015.atcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	return bc and bc:IsStatus(STATUS_BATTLE_DESTROYED) and c:IsChainAttackable() and c:IsStatus(STATUS_OPPO_BATTLE) 
end
function c80006015.atop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ChainAttack()
end