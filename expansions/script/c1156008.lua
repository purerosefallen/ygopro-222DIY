--辉光之针的利立浦特
function c1156008.initial_effect(c)
--
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(c1156008.lfilter),3)
--  
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(1156008,0))
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_ATKCHANGE)
	e1:SetType(EVENT_FREE_CHAIN+EFFECT_TYPE_CONTINUOUS)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(c1156008.tg1)
	e1:SetOperation(c1156008.op1)
	c:RegisterEffect(e1)
--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(1156008,1))
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,1156008)
	e2:SetTarget(c1156008.tg2)
	e2:SetOperation(c1156008.op2)
	c:RegisterEffect(e2)
--
end
--
function c1156008.lfilter(c)
	return c:GetAttack()<501 and c:IsType(TYPE_EFFECT)
end
--
function c1156008.tfilter1_1(c)
	return c:IsAbleToDeck()
end
function c1156008.tfilter1_2(c)
	return c:GetAttack()~=500 and c:IsFaceup() and c:IsType(TYPE_MONSTER)
end
function c1156008.tfilter1_3(c)
	return c:IsReleasable() and c:GetLevel()<501 and c:IsType(TYPE_MONSTER)
end
function c1156008.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=e:GetHandler():GetLinkedGroup()
	e:SetLabelObject(g)
	if chk==0 then return ((Duel.IsExistingMatchingCard(c1156008.tfilter1_1,tp,0,LOCATION_HAND,1,nil) or Duel.IsExistingMatchingCard(c1156008.tfilter1_1,tp,0,LOCATION_GRAVE,1,nil) or Duel.IsExistingMatchingCard(c1156008.tfilter1_1,tp,0,LOCATION_ONFIELD,1,nil)) or Duel.IsExistingMatchingCard(c1156008.tfilter1_2,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,g,e)) and Duel.IsExistingMatchingCard(c1156008.tfilter1_3,tp,LOCATION_ONFIELD,0,1,nil) end
	if Duel.IsExistingMatchingCard(c1156008.tfilter1_1,tp,0,LOCATION_HAND,1,nil) then
		Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,0,LOCATION_HAND)
	end
	if Duel.IsExistingMatchingCard(c1156008.tfilter1_1,tp,0,LOCATION_GRAVE,1,nil) then
		Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,0,LOCATION_GRAVE)
	end 
	if Duel.IsExistingMatchingCard(c1156008.tfilter1_1,tp,0,LOCATION_ONFIELD,1,nil) then
		Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,0,LOCATION_ONFIELD)
	end 
end
--
function c1156008.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_CARD,0,1156008)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)	
	local g=Duel.SelectMatchingCard(tp,c1156008.tfilter1_3,tp,LOCATION_ONFIELD,0,1,1,nil)
	if g:GetCount()>0 then
		if Duel.Release(g,REASON_EFFECT)~=0 then
			local gn=Group.CreateGroup()
			if Duel.IsExistingMatchingCard(c1156008.tfilter1_1,tp,0,LOCATION_ONFIELD,1,nil) then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
				local g=Duel.SelectMatchingCard(tp,c1156008.tfilter1_1,1-tp,LOCATION_ONFIELD,0,1,1,nil)
				local tc=g:GetFirst()
				gn:AddCard(tc)
			end
			if Duel.IsExistingMatchingCard(c1156008.tfilter1_1,tp,0,LOCATION_GRAVE,1,nil) then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
				local g=Duel.SelectMatchingCard(tp,c1156008.tfilter1_1,1-tp,LOCATION_GRAVE,0,1,1,nil)
				local tc=g:GetFirst()
				gn:AddCard(tc)
			end		 
			if Duel.IsExistingMatchingCard(c1156008.tfilter1_1,tp,0,LOCATION_HAND,1,nil) then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
				local g=Duel.SelectMatchingCard(tp,c1156008.tfilter1_1,1-tp,LOCATION_HAND,0,1,1,nil)
				local tc=g:GetFirst()
				gn:AddCard(tc)
			end 
			if gn:GetCount()>0 then
				Duel.SendtoDeck(gn,nil,2,REASON_EFFECT)
			end
		end
	end
	Duel.BreakEffect()
	local gn=e:GetHandler():GetLinkedGroup()
	local gr=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
	if gr:GetCount()>0 then
		local tcr=gr:GetFirst()
		while tcr do
			if gn:GetCount()>0 then
				local tcn=gn:GetFirst()
				while tcn do
					if tcr==tcn then
						gr:RemoveCard(tcr)
					end
					tcn=gn:GetNext()
				end
			end
			tcr=gr:GetNext()
		end
	end
	if gr:GetCount()>0 then
		local g2=gr:Filter(c1156008.tfilter1_2,nil)
		if g2:GetCount()>0 then
			local tc=g2:GetFirst()
			while tc do
				local e1_1=Effect.CreateEffect(c)
				e1_1:SetType(EFFECT_TYPE_SINGLE)
				e1_1:SetCode(EFFECT_SET_ATTACK)
				e1_1:SetValue(500)
				e1_1:SetReset(RESET_EVENT+0xfe0000)
				tc:RegisterEffect(e1_1)
				tc=g2:GetNext()
			end
			Duel.BreakEffect()
			local tc=g2:GetFirst()
			local num=0
			while tc do
				if tc:GetAttack()==500 then
					num=1
				end
				tc=g2:GetNext()
			end
			if num==1 then
				local e1_2=Effect.CreateEffect(e:GetHandler())
				e1_2:SetType(EFFECT_TYPE_FIELD)
				e1_2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
				e1_2:SetTargetRange(LOCATION_ONFIELD,0)
				e1_2:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
				e1_2:SetTarget(c1156008.tg1_2)
				e1_2:SetValue(1)
				Duel.RegisterEffect(e1_2,tp)
				local e1_3=Effect.CreateEffect(e:GetHandler())
				e1_3:SetType(EFFECT_TYPE_FIELD)
				e1_3:SetCode(EFFECT_IMMUNE_EFFECT)
				e1_3:SetTargetRange(LOCATION_MZONE,0)
				e1_3:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
				e1_3:SetTarget(c1156008.tg1_3)
				e1_3:SetValue(c1156008.efilter1_3)
				Duel.RegisterEffect(e1_3,tp)
			end
		end
	end
end
function c1156008.tg1_2(e,c)
	return c:IsFaceup() and c:IsControler(tp) and c:IsType(TYPE_MONSTER)and c:GetAttack()<501
end
function c1156008.tg1_3(e,c)
	return  c:IsFaceup() and c:IsControler(tp) and c:IsType(TYPE_MONSTER) and c:GetAttack()<501
end
function c1156008.efilter1_3(e,re,rp)
	if not re:IsActiveType(TYPE_SPELL+TYPE_TRAP) then return false end
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return true end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	return not g:IsContains(e:GetHandler())
end
--
function c1156008.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp) and Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.SetTargetPlayer(tp)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_HAND)
end
function c1156008.op2(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	Duel.Hint(HINT_SELECTMSG,p,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(p,Card.IsAbleToDeck,p,LOCATION_HAND,0,1,63,nil)
	if g:GetCount()~=0 then
		Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
		Duel.ShuffleDeck(p)
		Duel.Draw(p,g:GetCount(),REASON_EFFECT)
	end
end
--
