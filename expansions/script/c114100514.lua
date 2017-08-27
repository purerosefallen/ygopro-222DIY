--ありがとうの花束
function c114100514.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c114100514.target)
	e1:SetOperation(c114100514.activate)
	c:RegisterEffect(e1)
	--act in hand
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e2:SetCondition(c114100514.handcon)
	c:RegisterEffect(e2)
end
function c114100514.IsKeyT(c,f,v)
	local f=f or Card.GetCode
	local t={f(c)}
	for i,code in pairs(t) do
		local m=_G["c"..code]
		if m and m.chuchu then return true end --and (not v or m.XiangYuan_name_keyrune==v)
	end
	return false
end
function c114100514.filter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToHand() and c:IsSetCard(0x221) and c:IsLevelBelow(4) and ( c:IsLocation(LOCATION_GRAVE) or c:IsFaceup() )
end
function c114100514.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:GetControler()==tp and chkc:GetLocation()==LOCATION_GRAVE+LOCATION_REMOVED and c114100514.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c114100514.filter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c114100514.filter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c114100514.deckfilter(c)
	return c:IsType(TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ+TYPE_NORMAL) and c:IsAbleToDeck() and ( c:IsLocation(LOCATION_MZONE+LOCATION_GRAVE) or c:IsFaceup() )
end
function c114100514.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		if Duel.SendtoHand(tc,nil,REASON_EFFECT)>0 then
			Duel.ConfirmCards(1-tp,tc)
			--retrive monsters
			local mg=Duel.GetMatchingGroup(c114100514.deckfilter,tp,LOCATION_MZONE+LOCATION_GRAVE+LOCATION_REMOVED,0,nil)
			if mg:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(114100514,0)) then
				local sg=mg:Select(tp,1,99,nil)
				local fdg=sg:Filter(Card.IsFacedown,nil)
				if fdg:GetCount()>0 then Duel.ConfirmCards(1-tp,fdg) end
				Duel.HintSelection(sg)
				Duel.SendtoDeck(sg,nil,2,REASON_EFFECT)
			end
		end
	end
end
--
function c114100514.hdfilter(c)
	return ( c114100514.IsKeyT(c) or c:IsCode(49375719) ) and ( c:IsLocation(LOCATION_GRAVE) or c:IsFaceup() )
end
function c114100514.handcon(e)
	return Duel.IsExistingMatchingCard(c114100514.hdfilter,e:GetHandlerPlayer(),LOCATION_MZONE+LOCATION_GRAVE,0,1,nil)
end
