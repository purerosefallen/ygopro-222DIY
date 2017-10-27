--ELF·翼之辉
function c1191001.initial_effect(c)
--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCountLimit(1,1191001+EFFECT_COUNT_CODE_OATH)  
	e1:SetCost(c1191001.cost1)
	e1:SetTarget(c1191001.tg1)
	e1:SetOperation(c1191001.op1)
	c:RegisterEffect(e1)
--
end
--
c1191001.named_with_ELF=1
function c1191001.IsELF(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_ELF
end
--
function c1191001.cfilter(c)
	return c1191001.IsELF(c) and c:IsAbleToGraveAsCost()
end
function c1191001.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c1191001.cfilter,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.DiscardHand(tp,c1191001.cfilter,1,1,REASON_COST,nil)
end
function c1191001.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function c1191001.filter1(c)
	return c:IsType(TYPE_MONSTER) and c1191001.IsELF(c) and c:IsLevelBelow(1)
end
function c1191001.opfilter1(c,e,tp)
	return c:IsType(TYPE_MONSTER) and c1191001.IsELF(c) and c:IsLevelBelow(1) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP)
end
function c1191001.ofilter1(c)
	return c1191001.IsELF(c)
end
function c1191001.op1(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
	local dc=Duel.GetOperatedGroup()
	if Duel.GetMZoneCount(tp)<=0 then return end
	local sg=dc:Filter(c1191001.ofilter1,nil)
	if sg:GetCount()==2 then
		local g3=Duel.GetMatchingGroup(c1191001.filter1,tp,LOCATION_HAND+LOCATION_GRAVE,0,nil)
		if g3:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(1191001,0)) then
		Duel.ConfirmCards(1-tp,dc)
		Duel.ShuffleHand(tp)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g2=Duel.SelectMatchingCard(tp,c1191001.opfilter1,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp)
			if g2:GetCount()>0 then
				Duel.SpecialSummon(g2,0,tp,tp,false,false,POS_FACEUP)
			end
		end
	end
end


