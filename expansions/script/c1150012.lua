--娑羯罗
function c1150012.initial_effect(c)
--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
--  
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetCondition(c1150012.con2)
	e2:SetValue(1)
	c:RegisterEffect(e2)
--
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(1150012,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DRAW)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCountLimit(1,1150012)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCondition(c1150012.con3)
	e3:SetTarget(c1150012.tg3)
	e3:SetOperation(c150012.op3)
	c:RegisterEffect(e3)
--
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(1150012,1))
	e4:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetCountLimit(1,1150013)
	e4:SetRange(LOCATION_FZONE)
	e4:SetTarget(c1150012.tg4)
	e4:SetOperation(c150012.op4)
	c:RegisterEffect(e4)
end
--
function c1150012.cfilter2(c)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_WATER)
end
function c1150012.con2(e)
	return Duel.IsExistingMatchingCard(c1150012.cfilter2,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
end
--
function c1150012.con3(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0
end
--
function c1150012.tfilter3(c,e,sp)
	return c:IsRace(RACE_AQUA) and c:IsCanBeSpecialSummoned(e,0,sp,false,false) and c:GetLevel()<5 and not c:IsType(TYPE_XYZ)
end
function c1150012.tg3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMZoneCount(tp)>0
		and Duel.IsExistingMatchingCard(c1150012.tfilter3,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
--
function c1150012.op3(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		if Duel.GetMZoneCount(tp)>0 then
			if Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0 then 
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				local g=Duel.SelectMatchingCard(tp,c1150012.tfilter3,tp,LOCATION_HAND,0,1,1,nil,e,tp)
				if g:GetCount()>0 then
					local tc=g:GetFirst()
					Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
					local e3_1=Effect.CreateEffect(e:GetHandler())
					e3_1:SetType(EFFECT_TYPE_SINGLE)
					e3_1:SetCode(EFFECT_CANNOT_TRIGGER)
					e3_1:SetReset(RESET_EVENT+0x1fe0000)
					tc:RegisterEffect(e3_1,true) 
				end
			end
		end
	end
end
--
function c1150012.tfilter4(c)
	return c:IsRace(RACE_AQUA) and c:IsAbleToDeck()
end
function c1150012.tg4(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) and Duel.IsExistingMatchingCard(c1150012.tfilter4,tp,LOCATION_HAND,0,1,nil) end
	Duel.SetTargetPlayer(tp)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_HAND)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c1150012.op4(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
		local g=Duel.GetMatchingGroup(c1150012.tfilter4,p,LOCATION_HAND,0,nil)
		if g:GetCount()>=1 then
			Duel.Hint(HINT_SELECTMSG,p,HINTMSG_TODECK)
			local sg=g:Select(p,1,1,nil)
			Duel.ConfirmCards(1-p,sg)
			if Duel.SendtoDeck(sg,nil,2,REASON_EFFECT)~=0 then
				Duel.ShuffleDeck(p)
				Duel.BreakEffect()
				Duel.Draw(p,1,REASON_EFFECT)
			end
		end
	end
end



