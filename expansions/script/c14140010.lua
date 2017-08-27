--祝祭初学
local m=14140010
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.operation)
	c:RegisterEffect(e1)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e1:SetCondition(function(e)
		return not Duel.IsExistingMatchingCard(function(c) return not c:IsSetCard(0x360) and c:IsFaceup() end,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
	end)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(m*16+1)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCountLimit(1)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCondition(function()
		local ph=Duel.GetCurrentPhase()
		return ph>PHASE_MAIN1 and ph<PHASE_MAIN2
	end)
	e1:SetTarget(cm.xyztg)
	e1:SetOperation(cm.xyzop)
	c:RegisterEffect(e1)
end
function cm.spfilter1(c,e,tp)
	return c:IsSetCard(0x360) and c:IsType(TYPE_MONSTER) and (c:IsAbleToHand() or (c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0))
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local g=Duel.GetMatchingGroup(cm.spfilter1,tp,LOCATION_DECK,0,nil,e,tp)
		return g:GetClassCount(Card.GetCode)>=3
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(cm.spfilter1,tp,LOCATION_DECK,0,nil)
	if g:GetClassCount(Card.GetCode)>=3 then
		local cg=Group.CreateGroup()
		for i=1,3 do
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELF)
			local sg=g:Select(tp,1,1,nil)
			g:Remove(Card.IsCode,nil,sg:GetFirst():GetCode())
			cg:Merge(sg)
		end
		Duel.ConfirmCards(1-tp,cg)
		Duel.ShuffleDeck(tp)
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_OPPO)
		local tg=cg:Select(1-tp,1,1,nil)
		Duel.ConfirmCards(tp,cg)
		local tc=tg:GetFirst()
		Duel.Hint(HINT_CARD,0,tc:GetOriginalCode())
		local b1=tc:IsAbleToHand()
		local b2=tc:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		local op
		if b1 and b2 then
			op=Duel.SelectOption(tp,m*16,m*16+1)
		elseif b1 and not b2 then
			op=Duel.SelectOption(tp,m*16)
		elseif b2 and not b2 then
			op=Duel.SelectOption(tp,m*16+1)+1
		end
		if op==0 then
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
		elseif op==1 then
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		end
		Duel.ShuffleDeck(tp)
	end
end
function cm.xyzfilter(c)
	if not c:IsSetCard(0x360) then return false end
	return c:IsXyzSummonable(nil) or c:IsSynchroSummonable(nil)
end
function cm.xyztg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.xyzfilter,tp,LOCATION_EXTRA,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function cm.xyzop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(cm.xyzfilter,tp,LOCATION_EXTRA,0,nil)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=g:Select(tp,1,1,nil)
		Duel.SpecialSummonRule(tp,tg:GetFirst())
	end
end