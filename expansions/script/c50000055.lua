--奇犽的生日礼物
function c50000055.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,50000055)
	e1:SetCost(c50000055.cost)
	e1:SetTarget(c50000055.target)
	e1:SetOperation(c50000055.activate)
	c:RegisterEffect(e1)
	--destroy replace
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetTarget(c50000055.reptg)
	e2:SetValue(c50000055.repval)
	e2:SetOperation(c50000055.repop)
	c:RegisterEffect(e2)
end
---
function c50000055.filter(c)
	return c:IsSetCard(0x50c) and c:IsType(TYPE_MONSTER) and c:IsDiscardable()
end
function c50000055.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c50000055.filter,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,c50000055.filter,1,1,REASON_COST+REASON_DISCARD)
end
function c50000055.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function c50000055.activate(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
------
function c50000055.repfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x50c)  and c:IsLocation(LOCATION_ONFIELD)
		and c:IsControler(tp) and c:IsReason(REASON_EFFECT+REASON_BATTLE)
end
function c50000055.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemove() and eg:IsExists(c50000055.repfilter,1,nil,tp) end
	return Duel.SelectYesNo(tp,aux.Stringid(50000055,0))
end
function c50000055.repval(e,c)
	return c50000055.repfilter(c,e:GetHandlerPlayer())
end
function c50000055.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT)
end
