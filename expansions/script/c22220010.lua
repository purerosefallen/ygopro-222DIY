--传统的白泽球
function c22220010.initial_effect(c)
	c:EnableReviveLimit()
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(22220010,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_NEGATE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetRange(LOCATION_HAND+LOCATION_REMOVED)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCountLimit(1,22220010)
	e1:SetCondition(c22220010.discon)
	e1:SetTarget(c22220010.distg)
	e1:SetOperation(c22220010.disop)
	c:RegisterEffect(e1)
	--Remove
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(22220010,1))
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1)
	e1:SetCost(c22220010.tdcost)
	e1:SetTarget(c22220010.tdtg)
	e1:SetOperation(c22220010.tdop)
	c:RegisterEffect(e1)
	--negate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(22220010,2))
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(c22220010.remcon)
	e1:SetTarget(c22220010.remtg)
	e1:SetOperation(c22220010.remop)
	c:RegisterEffect(e1)
end

c22220010.named_with_Shirasawa_Tama=1
function c22220010.IsShirasawaTama(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Shirasawa_Tama
end
function c22220010.discon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp and re:IsActiveType(TYPE_QUICKPLAY) and Duel.IsChainNegatable(ev)
end
function c22220010.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and e:GetHandler():IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,true,false) end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function c22220010.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
	Duel.Remove(eg,POS_FACEUP,REASON_EFFECT)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.SpecialSummon(c,SUMMON_TYPE_RITUAL,tp,tp,true,false,POS_FACEUP)
	end
end
function c22220010.tdfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsRace(RACE_BEAST) and c:IsAbleToRemoveAsCost()
end
function c22220010.tdcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c22220010.tdfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c22220010.tdfilter,tp,LOCATION_DECK,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c22220010.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and chkc:IsAbleToRemove() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToRemove,tp,0,LOCATION_MZONE,1,nil) and e:GetHandler():IsAbleToRemove() end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,Card.IsAbleToRemove,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,2,0,0)
end
function c22220010.tdop(e,tp,eg,ep,ev,re,r,rp)
	local g=Group.CreateGroup()
	local tc=Duel.GetFirstTarget()
	g:AddCard(tc)
	g:AddCard(e:GetHandler())
	local tc=g:GetFirst()
	while tc do
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT+REASON_TEMPORARY)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetReset(RESET_PHASE+PHASE_END)
		e1:SetLabelObject(tc)
		e1:SetCountLimit(1)
		e1:SetOperation(c22220010.reop)
		Duel.RegisterEffect(e1,tp)
		tc=g:GetNext()
	end
end
function c22220010.reop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ReturnToField(e:GetLabelObject())
end
function c22220010.remcon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED)
		and ep~=tp and re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function c22220010.remfilter(c)
	return c:IsType(TYPE_MONSTER) and c22220010.IsShirasawaTama(c) and c:IsAbleToRemove()
end
function c22220010.remtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c22220010.remfilter,tp,LOCATION_MZONE,0,1,nil) end
end
function c22220010.remop(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetMatchingGroup(c22220010.remfilter,tp,LOCATION_MZONE,0,nil)
	local tc=tg:GetFirst()
	while tc do
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT+REASON_TEMPORARY)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_CHAIN_END)
		e1:SetReset(EVENT_CHAIN_END)
		e1:SetLabelObject(tc)
		e1:SetCountLimit(1)
		e1:SetOperation(c22220010.reop)
		Duel.RegisterEffect(e1,tp)
		tc=tg:GetNext()
	end
end
