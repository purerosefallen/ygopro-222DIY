--请问您今天要来点咖啡吗
local m=50008207
local cm=_G["c"..m]
local mil=require("expansions/script/Millux")
cm.is_series_with_rabbit=true
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(
	function(e,tp,eg,ep,ev,re,r,rp,chk)
		if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>2 end
	end)
	e1:SetOperation(
	function(e,tp,eg,ep,ev,re,r,rp)
		if not e:GetHandler():IsRelateToEffect(e) then return end
		if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<3 then return end
		local g=Duel.GetDecktopGroup(tp,3)
		Duel.ConfirmCards(tp,g)
		if g:IsExists(cm.filter,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local sg=g:FilterSelect(tp,cm.filter,1,1,nil)
			Duel.DisableShuffleCheck()
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sg)
			Duel.ShuffleHand(tp)
			Duel.SortDecktop(tp,tp,2)
		else Duel.SortDecktop(tp,tp,3) end
	end)
	c:RegisterEffect(e1)
	--may not return
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(m)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	c:RegisterEffect(e2)
	--extra summon
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_EXTRA_SUMMON_COUNT)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(LOCATION_HAND+LOCATION_MZONE,0)
	e3:SetTarget(function(e,c) return c:IsType(TYPE_MONSTER) and mil.is_series(c,'rabbit') end)
	c:RegisterEffect(e3)
end
function cm.filter(c)
	return mil.is_series(c,'rabbit') and c:IsAbleToHand()
end