--蕾米莉亚·斯卡蕾特
function c1151101.initial_effect(c)
--
	aux.AddSynchroProcedure(c,c1151101.filter0_1,c1151101.filter0_2,1)
	c:EnableReviveLimit()
--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(1151101,0))
	e1:SetCategory(CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,1151101)
	e1:SetTarget(c1151101.tg1)
	e1:SetOperation(c1151101.op1)
	c:RegisterEffect(e1)
--
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(aux.tgoval)
	c:RegisterEffect(e3)
--
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(1151101,1))
	e4:SetCategory(CATEGORY_TOHAND+CATEGORY_TOGRAVE+CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,1151102)
	e4:SetTarget(c1151101.tg4)
	e4:SetOperation(c1151101.op4)
	c:RegisterEffect(e4)
--
end
--
c1151101.named_with_Leimi=1
function c1151101.IsLeimi(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Leimi
end
function c1151101.IsLeisp(c)
	local m=_G["c"..c:GetCode()]
	return c.named_with_Leisp
end
--
function c1151101.filter0_1(c)
	return c1151101.IsLeimi(c) and c:IsType(TYPE_TUNER)
end
function c1151101.filter0_2(c)
	return c:IsRace(RACE_FIEND)
end
--
function c1151101.tfilter1(c)
	return c:IsAbleToDeck()
end
function c1151101.tg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c1151101.tfilter1,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,0,LOCATION_GRAVE)
end
--
function c1151101.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local g=Duel.SelectMatchingCard(tp,c1151101.tfilter1,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoDeck(g,nil,0,REASON_EFFECT)
		end
	end
end
--
function c1151101.tg4(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0 end
	Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(1151101,2))
	Duel.Hint(HINT_SELECTMSG,tp,0)
	local ac=Duel.AnnounceCard(tp)
	e:SetLabel(ac)
end
--
function c1151101.ofilter4(c)
	return c:IsAbleToGrave()
end
function c1151101.op4(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) or Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)==0 then return end
	Duel.ConfirmDecktop(tp,1)
	local g=Duel.GetDecktopGroup(tp,1)
	local tc=g:GetFirst()
	if tc:GetCode()==e:GetLabel() and tc:IsAbleToHand() then
		Duel.DisableShuffleCheck()
		if Duel.SendtoHand(tc,nil,REASON_EFFECT)~=0 then
			Duel.ConfirmCards(1-tp,tc)
			if Duel.IsExistingMatchingCard(c1151101.ofilter4,tp,LOCATION_ONFIELD,0,1,nil) then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
				local g2=Duel.SelectMatchingCard(tp,c1151101.ofilter4,tp,0,LOCATION_ONFIELD,1,1,nil)
				if g2:GetCount()>0 then
					Duel.SendtoGrave(g2,REASON_EFFECT)
				end
			end
			Duel.ShuffleHand(tp)
		end
	else
		Duel.DisableShuffleCheck()
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
--


