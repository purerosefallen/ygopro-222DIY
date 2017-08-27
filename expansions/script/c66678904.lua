--忘却之海的游侠
function c66678904.initial_effect(c)
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DRAW)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCost(c66678904.remcost)
	e3:SetTarget(c66678904.remtg)
	e3:SetOperation(c66678904.remop)
	c:RegisterEffect(e3)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_HAND)
	e2:SetCost(c66678904.cost)
	e2:SetTarget(c66678904.target)
	e2:SetOperation(c66678904.activate)
	c:RegisterEffect(e2)
end
function c66678904.remfilter(c)
	return c:IsSetCard(0x665) and c:IsType(TYPE_MONSTER) and (c:IsAbleToDeckAsCost() or c:IsAbleToExtraAsCost())
end
function c66678904.remcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c66678904.remfilter,tp,LOCATION_GRAVE,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c66678904.remfilter,tp,LOCATION_GRAVE,0,1,1,e:GetHandler())
	Duel.SendtoDeck(g,nil,2,REASON_COST)
end
function c66678904.remtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c66678904.remop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
function c66678904.ofilter(c)
	return c:GetOverlayCount()~=0 and c:IsSetCard(0x665) and c:IsType(TYPE_XYZ)
end
function c66678904.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(c66678904.ofilter,tp,LOCATION_MZONE,0,1,nil) and e:GetHandler():IsAbleToGraveAsCost() end
	Duel.Hint(HINT_SELECTMSG,tp,532)
	local g=Duel.SelectMatchingCard(tp,c66678904.ofilter,tp,LOCATION_MZONE,0,1,1,nil)
	g:GetFirst():RemoveOverlayCard(tp,1,1,REASON_COST)
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c66678904.tgfilter(c)
	return c:IsDestructable() and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c66678904.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingTarget(c66678904.tgfilter,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c66678904.tgfilter,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c66678904.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end