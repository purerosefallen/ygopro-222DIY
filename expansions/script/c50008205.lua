--请问您今天要来点兔子吗
local m=50008205
local cm=_G["c"..m]
local mil=require("expansions/script/Millux")
cm.is_series_with_rabbit=true
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetOperation(
		function(e,tp,eg,ep,ev,re,r,rp)
		if not e:GetHandler():IsRelateToEffect(e) then return end
		local g=Duel.GetMatchingGroup(cm.thfilter,tp,LOCATION_DECK,0,nil)
			if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
				local sg=g:Select(tp,1,1,nil)
				Duel.SendtoHand(sg,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,sg)
			end
		end)
	c:RegisterEffect(e1)
	--tohand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,2))
	e2:SetCategory(CATEGORY_DRAW+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_TO_HAND)
	e2:SetCountLimit(1)
	e2:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
		return eg:IsExists(function(c,tp)
			return mil.is_series(c,'rabbit') and c:GetPreviousControler()==tp
				and c:IsPreviousLocation(LOCATION_MZONE) and c:IsPreviousPosition(POS_FACEUP)
			end,1,nil,tp)
	end)
	e2:SetTarget(
	function(e,tp,eg,ep,ev,re,r,rp,chk)
		if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
		Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	end)
	e2:SetOperation(
	function(e,tp,eg,ep,ev,re,r,rp)
		local c=e:GetHandler()
		if not e:GetHandler():IsRelateToEffect(e) then return end
		if Duel.Draw(tp,1,REASON_EFFECT)==0 then return end
		local tc=Duel.GetOperatedGroup():GetFirst()
		Duel.ConfirmCards(1-tp,tc)
		if mil.is_series(tc,'rabbit') then
			if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
			local g=Duel.GetMatchingGroup(cm.spfilter,tp,LOCATION_DECK,0,nil,e,tp)
			if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
				Duel.BreakEffect()
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				local sc=g:Select(tp,1,1,nil)
				Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP)
			end
		else
			Duel.BreakEffect()
			Duel.Destroy(c,REASON_EFFECT)
			Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)
		end
		Duel.ShuffleHand(tp)
	end)
	c:RegisterEffect(e2)
	--inactivatable
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_INACTIVATE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetValue(
	function(e,ct)
		local te=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT)
		local tc=te:GetHandler()
		return te:IsActiveType(TYPE_MONSTER) and mil.is_series(tc,'rabbit') and (tc:IsLocation(LOCATION_ONFIELD) or tc:IsLocation(LOCATION_HAND))
	end)
	c:RegisterEffect(e3)
end
function cm.thfilter(c)
	return mil.is_series(c,'rabbit') and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function cm.spfilter(c,e,tp)
	return mil.is_series(c,'rabbit') and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end