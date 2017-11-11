--点兔 提比
local m=50008209
local cm=_G["c"..m]
local mil=require("expansions/script/Millux")
cm.is_series_with_rabbit=true
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,1))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,m..1)
	e1:SetCost(
	function(e,tp,eg,ep,ev,re,r,rp,chk)
		if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() and e:GetHandler():IsDiscardable() end
		Duel.SendtoGrave(e:GetHandler(),REASON_COST)
	end)
	e1:SetTarget(
	function(e,tp,eg,ep,ev,re,r,rp,chk)
		if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,1,nil) end
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	end)
	e1:SetOperation(
	function(e,tp,eg,ep,ev,re,r,rp)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end)
	c:RegisterEffect(e1)
	--negate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1,m)
	e2:SetCondition(
	function(e,tp,eg,ep,ev,re,r,rp)
		if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
		local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
		return g and g:IsExists(cm.tfilter,1,nil,tp) and Duel.IsChainNegatable(ev)
	end)
	e2:SetCost(
	function(e,tp,eg,ep,ev,re,r,rp,chk)
		if chk==0 then return e:GetHandler():IsDiscardable() end
		Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
	end)
	e2:SetTarget(
	function(e,tp,eg,ep,ev,re,r,rp,chk)
		if chk==0 then return true end
		Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
		if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
			Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
		end
	end)
	e2:SetOperation(
	function(e,tp,eg,ep,ev,re,r,rp)
		Duel.NegateActivation(ev)
		if re:GetHandler():IsRelateToEffect(re) then
			Duel.Destroy(eg,REASON_EFFECT)
		end
	end)
	c:RegisterEffect(e2)
end
function cm.tfilter(c,tp)
	return c:IsFaceup() and mil.is_series(c,'rabbit') and c:IsControler(tp) and c:IsLocation(LOCATION_ONFIELD)
end
function cm.thfilter(c)
	return c:IsCode(50008200) and c:IsAbleToHand()
end