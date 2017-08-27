--神之施予
function c10102007.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW+CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,10102007+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c10102007.cost)
	e1:SetTarget(c10102007.target)
	e1:SetOperation(c10102007.activate)
	c:RegisterEffect(e1)	
end
function c10102007.costfilter(c)
	return c:IsSetCard(0x9330) and c:IsType(TYPE_MONSTER)
end
function c10102007.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroupEx(tp,c10102007.costfilter,1,nil) end
	local g=Duel.SelectReleaseGroupEx(tp,c10102007.costfilter,1,1,nil)
	Duel.Release(g,REASON_COST)
end
function c10102007.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2) and Duel.IsPlayerCanDiscardDeck(tp,2)
		and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=4 end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,tp,2)
end
function c10102007.spfilter(c,e,tp)
	return c:IsSetCard(0x9330) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c10102007.activate(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	if Duel.Draw(p,d,REASON_EFFECT)~=0 then
	   local g=Duel.GetMatchingGroup(c10102007.spfilter,p,LOCATION_HAND,0,nil,e,tp)
	   if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(10102007,0)) then
		  Duel.BreakEffect()
		  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		  local sg=g:Select(p,1,1,nil)
		  Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
	   end
	end
end