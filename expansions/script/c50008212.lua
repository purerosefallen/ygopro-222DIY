--请问您今天要来晾衣服吗
local m=50008212
local cm=_G["c"..m]
local mil=require("expansions/script/Millux")
cm.is_series_with_rabbit=true
function cm.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkType,TYPE_LINK),2)
	c:EnableReviveLimit()
	--negate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,m)
	e1:SetCondition(
	function(e,tp,eg,ep,ev,re,r,rp)
		return (re:IsActiveType(TYPE_MONSTER) or re:IsHasType(EFFECT_TYPE_ACTIVATE)) and Duel.IsChainNegatable(ev)
	end)
	e1:SetTarget(
	function(e,tp,eg,ep,ev,re,r,rp,chk)
		if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)>0 end
		Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
		if re:GetHandler():IsRelateToEffect(re) then
			Duel.SetOperationInfo(0,CATEGORY_TODECK,eg,1,0,0)
		end
	end)
	e1:SetOperation(
	function(e,tp,eg,ep,ev,re,r,rp)
		local ec=re:GetHandler()
		if Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)<3 then return end
		Duel.ConfirmDecktop(tp,3)
		local g=Duel.GetDecktopGroup(tp,3)
		local gc=g:Filter(cm.ttfilter,nil)
		if g:GetClassCount(Card.GetCode)==3 and gc:GetCount()>1 then
			if Duel.NegateActivation(ev) and ec:IsRelateToEffect(re) then
				ec:CancelToGrave()
				Duel.SendtoDeck(ec,nil,2,REASON_EFFECT) 
			end
		end
	end)
	c:RegisterEffect(e1)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetTarget(
	function(e,tp,eg,ep,ev,re,r,rp,chk)
		if chk==0 then return Duel.IsExistingMatchingCard(cm.ttfilter,tp,LOCATION_DECK,0,1,nil) end
	end)
	e2:SetOperation(
	function(e,tp,eg,ep,ev,re,r,rp)
		if not e:GetHandler():IsRelateToEffect(e) then return end
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,1))
		local g=Duel.SelectMatchingCard(tp,cm.ttfilter,tp,LOCATION_DECK,0,1,1,nil)
		local tc=g:GetFirst()
		if tc then
			Duel.ShuffleDeck(tp)
			Duel.MoveSequence(tc,0)
			Duel.ConfirmDecktop(tp,1)
		end
	end)
	c:RegisterEffect(e2)
end
function cm.ttfilter(c)
	return mil.is_series(c,'rabbit')
end