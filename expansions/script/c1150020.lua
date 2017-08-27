--蝴蝶之梦
function c1150020.initial_effect(c)
--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,1150020+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c1150020.tg1)
	e1:SetOperation(c1150020.op1)
	c:RegisterEffect(e1)
--  
end
--
function c1150020.tfilter1(c)
	return c:IsFaceup()
end
function c1150020.tg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c1150020.tfilter1(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c1150020.tfilter1,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c1150020.tfilter1,tp,LOCATION_MZONE,0,1,1,nil)
end
--
function c1150020.op1(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and tc:IsLocation(LOCATION_MZONE) then
		local e1_1=Effect.CreateEffect(e:GetHandler())
		e1_1:SetDescription(aux.Stringid(1150020,0))
		e1_1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
		e1_1:SetCategory(CATEGORY_REMOVE+CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_DRAW)
		e1_1:SetType(EFFECT_TYPE_QUICK_O)
		e1_1:SetCode(EVENT_CHAINING)
		e1_1:SetRange(LOCATION_MZONE)
		e1_1:SetCountLimit(1)
		e1_1:SetLabelObject(tc)
		e1_1:SetReset(RESET_EVENT+0x1fe0000)
		e1_1:SetCondition(c1150020.con1_1)
		e1_1:SetTarget(c1150020.tg1_1)
		e1_1:SetOperation(c1150020.op1_1)
		tc:RegisterEffect(e1_1,true)	  
	end
end
--
function c1150020.con1_1(e,tp,eg,ep,ev,re,r,rp)
	return rp~=tp 
end
--
function c1150020.tg1_1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemove() end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,e:GetHandler(),1,0,LOCATION_MZONE)
end
--
function c1150020.ofilter1_1(c)
	return c:GetLevel()<5 and c:IsAbleToHand() and c:IsRace(RACE_INSECT)
end
function c1150020.op1_1(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	local pos=0
	if tc:GetPosition()==POS_FACEUP_ATTACK then
		pos=1
	else
		pos=2
	end
	if Duel.Remove(tc,POS_FACEUP,REASON_EFFECT+REASON_TEMPORARY)~=0 then
		local e1_1_1=Effect.CreateEffect(e:GetHandler())
		e1_1_1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1_1_1:SetCode(EVENT_PHASE+PHASE_END)
		e1_1_1:SetCountLimit(1)
		e1_1_1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		e1_1_1:SetRange(LOCATION_REMOVED)
		e1_1_1:SetLabel(pos)
		e1_1_1:SetOperation(c1150020.op1_1_1)
		tc:RegisterEffect(e1_1_1)
--
		Duel.BreakEffect()
		local sel=1
		local cg=Duel.GetMatchingGroup(c1150020.ofilter1_1,tp,LOCATION_DECK,0,nil)
		if cg:GetCount()>0 then
			sel=Duel.SelectOption(tp,aux.Stringid(1150020,1),aux.Stringid(1150020,2))
		else
			sel=Duel.SelectOption(tp,aux.Stringid(1150020,2))+1
		end
		if sel==0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local sg=cg:Select(tp,1,1,nil)
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
		end
		if sel==1 then
			Duel.Draw(tp,1,REASON_EFFECT)
		end
	end
end
--
function c1150020.op1_1_1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local pos=e:GetLabel()
	if pos==1 then
		Duel.MoveToField(c,tp,tp,LOCATION_MZONE,POS_FACEUP_ATTACK,true)
		if not c:GetOriginalType()==TYPE_MONSTER then
			Duel.SendtoGrave(c,REASON_RULE)
		end
		if not (c:IsLocation(LOCATION_MZONE) or c:IsLocation(LOCATION_GRAVE)) then
			Duel.SendtoGrave(c,REASON_RULE)
		end
	else
		Duel.MoveToField(c,tp,tp,LOCATION_MZONE,POS_FACEUP_DEFENSE,true)
		if not c:GetOriginalType()==TYPE_MONSTER then
			Duel.SendtoGrave(c,REASON_RULE)
		end 
		if not (c:IsLocation(LOCATION_MZONE) or c:IsLocation(LOCATION_GRAVE)) then
			Duel.SendtoGrave(c,REASON_RULE)
		end  
	end
end

