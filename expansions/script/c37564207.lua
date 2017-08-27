--Sawawa-Koishi Circulation
local m=37564207
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c37564765") end,function() require("script/c37564765") end)
cm.Senya_name_with_sawawa=true
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,1))
	e1:SetCategory(CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,m)
	e1:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
		return Senya.CheckNoExtra(e,tp) and (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2) and Duel.GetTurnPlayer()~=tp
	end)
	e1:SetCost(Senya.SawawaRemoveCost(1))
	e1:SetTarget(cm.tg)
	e1:SetOperation(cm.op)
	c:RegisterEffect(e1)
Senya.SawawaCommonEffect(c,2,true,false,false)
end
function cm.effilter(c)
	return Senya.check_set_sawawa(c)
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.GetFieldGroupCount(1-tp,LOCATION_HAND,0)~=0 end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,1-tp,LOCATION_HAND)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetMatchingGroupCount(cm.effilter,tp,LOCATION_REMOVED,LOCATION_REMOVED,nil)
	if ct==0 then return end
	local hg=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
	if hg:GetCount()==0 then return end
	Duel.ConfirmCards(tp,hg)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local sg=hg:Select(tp,1,ct,nil)
	local g=sg:GetCount()
	local dr=g-1
	Duel.SendtoDeck(sg,nil,2,REASON_EFFECT)
	Duel.ShuffleHand(1-tp)
	Duel.ShuffleDeck(1-tp)
	if dr>0 then
		Duel.BreakEffect()
		Duel.Draw(1-tp,dr,REASON_EFFECT)
	end
end