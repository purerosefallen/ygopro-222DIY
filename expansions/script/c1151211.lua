--红符『红色不夜城』
function c1151211.initial_effect(c)
--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,1151211+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c1151211.con1)
	e1:SetTarget(c1151211.tg1)
	e1:SetOperation(c1151211.op1)
	c:RegisterEffect(e1)
--
end
--
function c1151211.IsLeimi(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Leimi
end
c1151211.named_with_Leisp=1
function c1151211.IsLeisp(c)
	local m=_G["c"..c:GetCode()]
	return c.named_with_Leisp
end
--
function c1151211.cfilter1(c)
	return c1151211.IsLeimi(c) and c:IsFaceup()
end
function c1151211.con1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetMatchingGroupCount(c1151211.cfilter1,tp,LOCATION_MZONE,0,nil)>0
end
--
function c1151211.tfilter1(c)
	return c:IsDestructable()
end
function c1151211.GetAvailableCards(c)
	local tp=c:GetControler()
	local seq=c:GetSequence()
	local g=Duel.GetMatchingGroup(aux.checksamecolumn,0,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,c)
	g:AddCard(c)
	if seq<4 then
		local tc1=Duel.GetFieldCard(tp,LOCATION_MZONE,seq+1)
		if tc1 then g:AddCard(tc1) end
	end
	if seq<5 and seq>0 then
		local tc1=Duel.GetFieldCard(tp,LOCATION_MZONE,seq-1)
		if tc1 then g:AddCard(tc1) end
	end
	return g
end
function c1151211.tg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c1151211.tfilter1(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c1151211.tfilter1,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPPO)
	local g=Duel.SelectTarget(tp,c1151211.tfilter1,tp,0,LOCATION_MZONE,1,1,nil)
	local gn=c1151211.GetAvailableCards(g:GetFirst())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,gn,gn:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,gn:GetCount(),tp,LOCATION_GRAVE)
end
--
function c1151211.op1(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsLocation(LOCATION_MZONE) then
		local g=c1151211.GetAvailableCards(tc)
		if Duel.Destroy(g,REASON_EFFECT)~=0 then
			Duel.BreakEffect()
			local tc2=g:GetFirst()
			local num=0
			while tc2 do
				if tc2:GetOwner()==tp and tc2~=e:GetHandler() then
					num=1
					break
				else
					tc2=g:GetNext()
				end
			end
			if num==1 then
				Duel.Draw(tp,1,REASON_EFFECT)
			end
		end
	end
end

