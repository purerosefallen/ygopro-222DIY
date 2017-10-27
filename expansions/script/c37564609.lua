--Prim-Glimmer
local m=37564609
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c37564765") end,function() require("script/c37564765") end)
cm.Senya_name_with_prim=true
function cm.initial_effect(c)
	--Senya.setreg(c,m,37564600)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(37564609,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,37564609)
	e1:SetCost(cm.rmcost)
	e1:SetTarget(cm.thtg)
	e1:SetOperation(cm.rmop)
	c:RegisterEffect(e1)
	--spsummon
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(34834619,0))
	e6:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e6:SetRange(LOCATION_GRAVE)
	e6:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e6:SetCountLimit(1,37564699)
	e6:SetCost(Senya.DiscardHandCost(1))
	e6:SetCondition(cm.thcon)
	e6:SetTarget(cm.sptg)
	e6:SetOperation(cm.spop)
	c:RegisterEffect(e6)
end
function cm.rmcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function cm.thfilter(c)
	return Senya.check_set_prim(c) and c:IsAbleToHand() and (not c:IsCode(37564609))
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.rmop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function cm.thcon(e,tp,eg,ep,ev,re,r,rp)
	return tp==Duel.GetTurnPlayer()
end
function cm.mtfilter(c,e)
	return c:GetLevel()>0 and Senya.check_set_prim(c) and c:IsAbleToDeckAsCost() and not c:IsImmuneToEffect(e) and not c:IsCode(37564609)
end
function cm.spfilter(c,e,tp,m)
	return c:IsCode(37564609) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
		and m:CheckWithSumEqual(Card.GetRitualLevel,2,1,99,c)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if Duel.GetMZoneCount(tp)<=0 then return false end
		local mg=Duel.GetMatchingGroup(cm.mtfilter,tp,LOCATION_GRAVE,0,e:GetHandler(),e)
		return cm.spfilter(e:GetHandler(),e,tp,mg)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetMZoneCount(tp)<=0 then return end
	local mg=Duel.GetMatchingGroup(cm.mtfilter,tp,LOCATION_GRAVE,0,nil,e)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp,mg)
	local tc=g:GetFirst()
	if tc then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local mat=mg:SelectWithSumEqual(tp,Card.GetLevel,2,1,99,tc)
		tc:SetMaterial(mat)
		Duel.SendtoDeck(mat,nil,2,REASON_COST)
		Duel.BreakEffect()
		Duel.SpecialSummon(tc,0,tp,tp,true,false,POS_FACEUP)
	end
end