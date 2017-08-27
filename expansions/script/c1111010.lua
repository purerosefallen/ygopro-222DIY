--徜徉于冷暖的乐曲
function c1111010.initial_effect(c)
--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c1111010.tg1)
	e1:SetOperation(c1111010.op1)
	c:RegisterEffect(e1)
--  
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_INACTIVATE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetValue(c1111010.efilter2)
	c:RegisterEffect(e2)	
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_DISEFFECT)
	e3:SetRange(LOCATION_SZONE)
	e3:SetValue(c1111010.efilter2)
	c:RegisterEffect(e3)
--
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(1111010,1))
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_PHASE+PHASE_END)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCountLimit(1)
	e4:SetOperation(c1111010.op4)
	c:RegisterEffect(e4)
--
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_REMAIN_FIELD)
	c:RegisterEffect(e5)
--
end
--
function c1111010.IsLq(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Lq
end
--
function c1111010.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	e:GetHandler():SetTurnCounter(0)
--
	local e1_1=Effect.CreateEffect(e:GetHandler())
	e1_1:SetDescription(aux.Stringid(1111010,2))
	e1_1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1_1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1_1:SetCode(EVENT_PHASE+PHASE_END)
	e1_1:SetCountLimit(1)
	e1_1:SetRange(LOCATION_SZONE)
	e1_1:SetCondition(c1111010.con1_1)
	e1_1:SetOperation(c1111010.op1_1)
	e1_1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END+RESET_OPPO_TURN,3)
	e:GetHandler():RegisterEffect(e1_1)
	e:GetHandler():RegisterFlagEffect(1111010,RESET_PHASE+PHASE_END+RESET_OPPO_TURN,0,1)
	c1111010[e:GetHandler()]=e1_1
end
function c1111010.con1_1(e,tp,eg,ep,ev,re,r,rp)
	return tp~=Duel.GetTurnPlayer()
end
function c1111010.op1_1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=c:GetTurnCounter()
	ct=ct+1
	c:SetTurnCounter(ct)
	if ct==1 then
		Duel.SendtoGrave(c,REASON_RULE)
		c:ResetFlagEffect(1111010)
	end
end
--
function c1111010.ofilter1(c)
	return c1111010.IsLq(c) and c:IsAbleToHand() and c:IsType(TYPE_CONTINUOUS) and c:IsType(TYPE_SPELL)
end
function c1111010.op1(e,tp,eg,ep,ev,re,r,rp)
	local e1_2=Effect.CreateEffect(e:GetHandler())
	e1_2:SetType(EFFECT_TYPE_SINGLE)
	e1_2:SetCode(EFFECT_IMMUNE_EFFECT)
	e1_2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1_2:SetRange(LOCATION_SZONE)
	e1_2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,2)
	e1_2:SetValue(c1111010.efilter1_2)
	e:GetHandler():RegisterEffect(e1_2,true)
	Duel.BreakEffect()
	if Duel.IsExistingMatchingCard(c1111010.ofilter1,tp,LOCATION_DECK,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(1111010,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c1111010.ofilter1,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end
function c1111010.efilter1_2(e,re,tp)
	return re:GetHandlerPlayer()==e:GetHandlerPlayer()
end
--
function c1111010.efilter2(e,ct)
	local te=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT)
	local tc=te:GetHandler()
	return tc:IsType(TYPE_MONSTER) and ((tc:GetLevel()<4 and not tc:IsType(TYPE_XYZ) and not tc:IsType(TYPE_LINK)) or (tc:GetRank()<4 and tc:IsType(TYPE_XYZ)))
end
--
function c1111010.ofilter4(c)
	return c:IsType(TYPE_MONSTER) and ((c:GetLevel()<4 and not c:IsType(TYPE_XYZ) and not c:IsType(TYPE_LINK)) or (c:GetRank()<4 and c:IsType(TYPE_XYZ))) and c:IsAbleToDeck()
end
function c1111010.op4(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsExistingMatchingCard(c1111010.ofilter4,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) then
		local g=Duel.GetMatchingGroup(c1111010.ofilter4,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
		if g:GetCount()>0 then
			Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
		end
	end
end
--