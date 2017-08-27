--3L·奇迹的厄运
local m=37564833
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c37564765") end,function() require("script/c37564765") end)
function cm.initial_effect(c)
	--Senya.CommonEffect_3L(c,m)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_POSITION)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,m)
	e1:SetHintTiming(0,0x1e0)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCost(cm.DiscardHandCost)
	e1:SetTarget(cm.distg)
	e1:SetOperation(cm.disop)
	c:RegisterEffect(e1)
end
function cm.effect_operation_3L(c)
	local ex1=Effect.CreateEffect(c)
	ex1:SetType(EFFECT_TYPE_FIELD)
	ex1:SetRange(LOCATION_MZONE)
	ex1:SetCode(EFFECT_SWAP_BASE_AD)
	ex1:SetTargetRange(0,LOCATION_MZONE)
	ex1:SetTarget(function(e,c)
		return c:IsFaceup() and not c:IsImmuneToEffect(e)
	end)
	ex1:SetReset(RESET_EVENT+0x1fe0000)
	c:RegisterEffect(ex1,true)
	return ex1
end
function cm.costfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToGraveAsCost() and Senya.check_set_3L(c)
end
function cm.DiscardHandCost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToGraveAsCost() and 
		Duel.IsExistingMatchingCard(cm.costfilter,tp,LOCATION_HAND,0,1,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,cm.costfilter,tp,LOCATION_HAND,0,1,1,c)
	g:AddCard(c)
	Duel.SendtoGrave(g,REASON_COST)
end
function cm.filter(c)
	return c:IsFaceup() and c:IsCanTurnSet() and not c:IsType(TYPE_LINK)
end
function cm.distg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(cm.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,cm.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,2,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,g:GetCount(),0,0)
end
function cm.disop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tg=g:Filter(cm.cf,nil,e)
	if tg:GetCount()>0 then
		Duel.ChangePosition(tg,POS_FACEDOWN_DEFENSE)
	end
end
function cm.cf(c,e)
	return c:IsFaceup() and c:IsRelateToEffect(e)
end