--点兔 宇治松千夜
local m=50008203
local cm=_G["c"..m]
local mil=require("expansions/script/Millux")
cm.is_series_with_rabbit=true
function cm.initial_effect(c)
	mil.rabat_return(c,m,1)
	--tohand
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,0x1e0)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,m)
	e1:SetTarget(
	function(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
		if chkc then return false end
		if chk==0 then return Duel.IsExistingTarget(cm.filter,tp,LOCATION_MZONE,0,1,nil)
			and Duel.IsExistingTarget(Card.IsAbleToHand,tp,0,LOCATION_MZONE,1,nil) end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
		local g1=Duel.SelectTarget(tp,cm.filter,tp,LOCATION_MZONE,0,1,1,nil)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
		local g2=Duel.SelectTarget(tp,Card.IsAbleToHand,tp,0,LOCATION_MZONE,1,1,nil)
		g1:Merge(g2)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,g1,2,0,0)
	end)
	e1:SetOperation(
	function(e,tp,eg,ep,ev,re,r,rp)
		local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
		end
	end)
	c:RegisterEffect(e1)
	--meet
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_HAND)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,m..1)
	e2:SetCondition(mil.return_con)
	e2:SetTarget(
	function(e,tp,eg,ep,ev,re,r,rp,chk)
		if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)>2 and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0 end
	end)
	e2:SetOperation(
	function(e,tp,eg,ep,ev,re,r,rp)
		if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)==0 then return end
		if Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)<3 then return end
		Duel.ConfirmDecktop(tp,1)
		local g=Duel.GetDecktopGroup(tp,1)
		local tc=g:GetFirst()
		if mil.is_series(tc,'rabbit') then
			Duel.SortDecktop(tp,1-tp,3)
		end
	end)
	c:RegisterEffect(e2)
end
function cm.filter(c)
	return c:IsFaceup() and mil.is_series(c,'rabbit') and not c:IsCode(m) and c:IsAbleToHand()
end