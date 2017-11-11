--禁忌『禁忌的游戏』
function c1152210.initial_effect(c)
--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c1152210.tg1)
	e1:SetOperation(c1152210.op1)
	c:RegisterEffect(e1)
--
end
--
function c1152210.IsFulan(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Fulan
end
c1152210.named_with_Fulsp=1
function c1152210.IsFulsp(c)
	local m=_G["c"..c:GetCode()]
	return c.named_with_Fulsp
end
--
function c1152210.tfilter1(c)
	return (c:IsType(TYPE_SPELL) or c:IsType(TYPE_TRAP)) and c1152210.IsFulsp(c)
end
function c1152210.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c1152210.tfilter1,tp,LOCATION_DECK,0,1,nil) and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0 end
end
--
function c1152210.ofilter1(c)
	return c1152210.IsFulan(c) and c:IsType(TYPE_MONSTER)
end
function c1152210.ofilter1_2(c)
	return c:IsType(TYPE_SPELL) and c:IsDestructable() and c:IsFaceup()
end
function c1152210.ofilter1_3(c)
	return c:IsDestructable()
end
function c1152210.op1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<1 then return end
	local num=0
	local g=Duel.GetMatchingGroup(c1152210.tfilter1,tp,LOCATION_DECK,0,nil)
	local dcount=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)
	local seq=-1
	local tc=g:GetFirst()
	local spcard=nil
	while tc do
		if tc:GetSequence()>seq then 
			seq=tc:GetSequence()
			spcard=tc
		end
		tc=g:GetNext()
	end
	if seq==-1 then
		Duel.ConfirmDecktop(tp,dcount)
		Duel.ShuffleDeck(tp)
		return
	end
	Duel.ConfirmDecktop(tp,dcount-seq)
	local gn=Duel.GetDecktopGroup(tp,dcount-seq)
	if gn:GetCount()>0 then
		num=gn:FilterCount(c1152210.ofilter1,nil)
	end
	if Duel.IsExistingMatchingCard(c1152210.ofilter1_2,tp,LOCATION_ONFIELD,0,1,e:GetHandler()) and Duel.SelectYesNo(tp,aux.Stringid(1152210,0)) then
		local i=Duel.GetMatchingGroupCount(c1152210.ofilter1_2,tp,LOCATION_ONFIELD,0,e:GetHandler())
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local g2=Duel.SelectMatchingCard(tp,c1152210.ofilter1_2,tp,LOCATION_ONFIELD,0,1,i,e:GetHandler())
		if g2:GetCount()>0 then
			local num2=Duel.Destroy(g2,REASON_EFFECT)
			num=num+num2
		end
	end
	if num>0 and Duel.IsExistingMatchingCard(c1152210.ofilter1_3,tp,0,LOCATION_ONFIELD,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(1152210,1)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)	 
		local g3=Duel.SelectMatchingCard(tp,c1152210.ofilter1_3,tp,0,LOCATION_ONFIELD,1,num,nil)   
		if g3:GetCount()>0 then
			Duel.Destroy(g3,REASON_EFFECT)
		end
	end
	e:GetHandler():CancelToGrave()
	if e:GetHandler():IsLocation(LOCATION_SZONE) then
		local e1_4=Effect.CreateEffect(e:GetHandler())
		e1_4:SetType(EFFECT_TYPE_SINGLE)
		e1_4:SetCode(EFFECT_CHANGE_TYPE)
		e1_4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1_4:SetValue(TYPE_EQUIP+TYPE_SPELL)
		e1_4:SetReset(RESET_EVENT+0x1fe0000)
		e:GetHandler():RegisterEffect(e1_4,true)
		local e1_5=Effect.CreateEffect(e:GetHandler())
		e1_5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
		e1_5:SetCode(EVENT_DESTROYED)
		e1_5:SetReset(RESET_EVENT+0x01020000)
		e1_5:SetCondition(c1152210.con1_5)
		e1_5:SetTarget(c1152210.tg1_5)
		e1_5:SetOperation(c1152210.op1_5)
		e:GetHandler():RegisterEffect(e1_5,true)
	end
end
function c1152210.con1_5(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousPosition(POS_FACEUP)
end
function c1152210.tg1_5(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return tp~=rp end
end
function c1152210.ofilter1_5(c)
	return c:IsAbleToHand() and (c:IsType(TYPE_SPELL) or c:IsType(TYPE_TRAP)) and c1152210.IsFulsp(c) and not c:IsCode(1152210)
end
function c1152210.op1_5(e,tp,eg,ep,ev,re,r,rp,chk)
	if Duel.GetMatchingGroupCount(c1152210.ofilter1_5,tp,LOCATION_DECK,0,nil)>0 then
		Duel.Hint(HINT_CARD,0,1152210)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c1152210.ofilter1_5,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			local tc=g:GetFirst()
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)	  
		end
	end
end

