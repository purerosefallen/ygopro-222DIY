--蓬莱山辉夜 蓬莱的玉枝-梦色之乡
function c15051705.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--atk,def
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_SET_ATTACK)
	e1:SetValue(c15051705.value)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_SET_DEFENSE)
	c:RegisterEffect(e2)
	--targettoactiveremov
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(15051705,0))
	e3:SetCategory(CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_BECOME_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	e3:SetCondition(c15051705.spcon)
	e3:SetTarget(c15051705.distg)
	e3:SetOperation(c15051705.disop)
	c:RegisterEffect(e3) 
	--attacktoactiveremov
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(15051705,0))
	e4:SetCategory(CATEGORY_REMOVE)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_BE_BATTLE_TARGET)
	e4:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	e4:SetTarget(c15051705.distg)
	e4:SetOperation(c15051705.disop)
	c:RegisterEffect(e4)
	--dame
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(15051705,1))
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1)
	e5:SetCost(c15051705.descost)
	e5:SetTarget(c15051705.destg)
	e5:SetOperation(c15051705.desop)
	c:RegisterEffect(e5)
	--to hand
	--[[local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(15051705,3))
	e6:SetType(EFFECT_TYPE_QUICK_O)
	e6:SetCategory(CATEGORY_TOHAND)
	e6:SetCode(EVENT_FREE_CHAIN)
	e6:SetRange(LOCATION_GRAVE)
	e6:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e6:SetCountLimit(1,7005)
	e6:SetCost(c15051705.thcost)
	e6:SetTarget(c15051705.thtg)
	e6:SetOperation(c15051705.thop)
	c:RegisterEffect(e6)]]
end
function c15051705.value(e,c)
	return c:GetLevel()*350
end
function c15051705.synfilter(c)
	return c:GetTextAttack()==-2 and c:GetTextDefense()==-2
end
function c15051705.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsContains(e:GetHandler())
end
function c15051705.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c15051705.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	if g:GetCount()>0 then
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	end
end
function c15051705.cfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToDeckAsCost()
end
function c15051705.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c15051705.cfilter,tp,LOCATION_SZONE,LOCATION_SZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c15051705.cfilter,tp,LOCATION_SZONE,LOCATION_SZONE,1,1,nil)
	Duel.SendtoDeck(g,nil,2,REASON_COST)
end
function c15051705.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(700)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,700)
end
function c15051705.desop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end
function c15051705.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c15051705.filter(c)
	return c:IsSetCard(0x260) and c:IsType(TYPE_MONSTER) and c:IsFaceup()
end
function c15051705.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c15051705.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c15051705.filter,tp,LOCATION_MZONE,0,1,nil) end
	local g=Duel.SelectTarget(tp,c15051705.filter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c15051705.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end