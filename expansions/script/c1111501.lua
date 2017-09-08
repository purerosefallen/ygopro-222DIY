--灵都·命运交错
function c1111501.initial_effect(c)
--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
--	e1:SetCost(c1111501.cost1)
	e1:SetOperation(c1111501.op1)
	c:RegisterEffect(e1)
--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(1111501,0))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCountLimit(1,1111501)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTarget(c1111501.tg2)
	e2:SetOperation(c1111501.op2)
	c:RegisterEffect(e2)
--
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(1111501,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCountLimit(1)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCost(c1111501.cost3)
	e3:SetTarget(c1111501.tg3)
	e3:SetOperation(c1111501.op3)
	c:RegisterEffect(e3)
--
	Duel.AddCustomActivityCounter(1111501,ACTIVITY_SPSUMMON,c1111501.counterfilter)   
end
--
c1111501.named_with_Ld=1
function c1111501.IsLd(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Ld
end
--
function c1111501.counterfilter(c)
	return not (c:GetLevel()>7 and c:GetSummonLocation()==LOCATION_EXTRA)
end
--
function c1111501.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(1111501,tp,ACTIVITY_SPSUMMON)==0 end
	local e1_1=Effect.CreateEffect(e:GetHandler())
	e1_1:SetType(EFFECT_TYPE_FIELD)
	e1_1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1_1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1_1:SetTargetRange(1,0)
	e1_1:SetTarget(c1111501.limit1_1)
	e1_1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1_1,tp)
end
function c1111501.limit1_1(e,c,sump,sumtype,sumpos,targetp,se)
	return c:IsLocation(LOCATION_EXTRA) and c:GetLevel()>7
end
--
function c1111501.op1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsPlayerCanSpecialSummonMonster(tp,1110199,0,0x4011,100,100,3,RACE_FAIRY,ATTRIBUTE_LIGHT) and Duel.SelectYesNo(tp,aux.Stringid(1111501,3)) then
		local token=Duel.CreateToken(tp,1110199)
		if Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)~=0 then
			local e1_2=Effect.CreateEffect(e:GetHandler())
			e1_2:SetType(EFFECT_TYPE_SINGLE)
			e1_2:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
			e1_2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1_2:SetValue(c1111501.val1_2)
			e1_2:SetReset(RESET_EVENT+0x1fe0000)
			token:RegisterEffect(e1_2,true)
		end
	end
end
function c1111501.val1_2(e,c)
	return not c1111501.IsLd(c)
end
--
function c1111501.tfilter2_1(c)
	return c:IsCode(1110004) and c:IsAbleToHand()
end
function c1111501.tfilter2_2(c)
	return c:IsAbleToDeck()
end
function c1111501.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c1111501.tfilter2_1,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) and Duel.IsExistingMatchingCard(c1111501.tfilter2_2,tp,LOCATION_HAND,0,2,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,2,0,LOCATION_HAND)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
--
function c1111501.op2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c1111501.tfilter2_2,tp,LOCATION_HAND,0,2,2,nil)
	if g:GetCount()==2 then
		if Duel.SendtoDeck(g,nil,2,REASON_EFFECT)==2 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local g2=Duel.SelectMatchingCard(tp,c1111501.tfilter2_1,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
			if g2:GetCount()>0 then
				Duel.SendtoHand(g2,tp,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,g2)
			end
		end
	end
end
--
function c1111501.cfilter3(c,e,tp)
	return c1111501.IsLd(c) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
end
function c1111501.cost3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c1111501.cfilter3,tp,LOCATION_GRAVE,0,2,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c1111501.cfilter3,tp,LOCATION_GRAVE,0,2,2,e:GetHandler())
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
--
function c1111501.tfilter3(c,e,tp)
	return c:IsCode(1110003) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c1111501.tg3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c1111501.tfilter3,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,LOCATION_DECK+LOCATION_GRAVE)
end
--
function c1111501.op3(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c1111501.tfilter3,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		local tc=g:GetFirst()
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
--