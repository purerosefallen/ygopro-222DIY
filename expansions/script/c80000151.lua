--化石口袋妖怪 摇篮百合
function c80000151.initial_effect(c)
	c:EnableReviveLimit()
	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c80000151.splimit)
	c:RegisterEffect(e1)	
	--search
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(80000151,0))
	e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_HAND)
	e4:SetCost(c80000151.cost)
	e4:SetTarget(c80000151.target)
	e4:SetOperation(c80000151.operation)
	c:RegisterEffect(e4)   
	--atk
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(EFFECT_IGNORE_BATTLE_TARGET)
	e2:SetRange(LOCATION_MZONE)
	c:RegisterEffect(e2)
	--pos Change
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(80000151,1))
	e3:SetCategory(CATEGORY_POSITION)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_ATTACK_ANNOUNCE)
	e3:SetOperation(c80000151.posop)
	c:RegisterEffect(e3)
	--disable effect
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_CHAIN_ACTIVATING)
	e5:SetRange(LOCATION_MZONE)
	e5:SetOperation(c80000151.disop)
	c:RegisterEffect(e5)
end
function c80000151.disop(e,tp,eg,ep,ev,re,r,rp)
	if re:IsActiveType(TYPE_FLIP) then
		Duel.NegateActivation(ev)
	end
end
function c80000151.splimit(e,se,sp,st)
	return bit.band(st,SUMMON_TYPE_RITUAL)==SUMMON_TYPE_RITUAL
end
function c80000151.mat_filter(c)
	return c:GetCode()==80000150
end
function c80000151.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToGraveAsCost() and c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function c80000151.filter(c)
	return c:GetCode()==80000150 and c:IsAbleToHand()
end
function c80000151.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c80000151.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c80000151.operation(e,tp,eg,ep,ev,re,r,rp,chk)
	local tg=Duel.GetFirstMatchingCard(c80000151.filter,tp,LOCATION_DECK,0,nil)
	if tg then
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tg)
	end
end
function c80000151.posop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c80000151.filter1,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	Duel.ChangePosition(g,POS_FACEUP_DEFENSE,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK)
end
function c80000151.filter1(c)
	return c:IsFaceup() and not c:IsSetCard(0x2d0)
end
function c80000151.disop(e,tp,eg,ep,ev,re,r,rp)
	if re:IsActiveType(TYPE_FLIP) then
		Duel.NegateActivation(ev)
	end
end