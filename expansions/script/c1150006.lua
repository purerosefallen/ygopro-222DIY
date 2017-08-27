--玫瑰的契约
function c1150006.initial_effect(c)
--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DAMAGE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,1150006+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c1150006.tg1)
	e1:SetOperation(c1150006.op1)
	c:RegisterEffect(e1)   
--  
end
--
function c1150006.tfilter1(c)
	return c:IsAbleToGrave() and c:IsFaceup()
end
function c1150006.tg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c1150006.tfilter1(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c1150006.tfilter1,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectTarget(tp,c1150006.tfilter1,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,0,LOCATION_MZONE) 
end
--
function c1150006.op1(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local atk=tc:GetAttack()
	local pos=0
	if tc:GetPosition()==POS_FACEUP_ATTACK then
		pos=1
	else
		pos=2
	end
	local num=atk/2
	if tc:IsRelateToEffect(e) and Duel.SendtoGrave(tc,REASON_EFFECT)~=0 then
		local hurt=Duel.Damage(tp,num,REASON_EFFECT)
		local e1_1=Effect.CreateEffect(e:GetHandler())
		e1_1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1_1:SetCode(EVENT_SPSUMMON_SUCCESS)
		e1_1:SetProperty(EFFECT_FLAG_DELAY)
		e1_1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
		e1_1:SetOperation(c1150006.op1_1)
		e1_1:SetLabel(hurt)
		Duel.RegisterEffect(e1_1,tp)
		local e1_2=Effect.CreateEffect(e:GetHandler())
		e1_2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1_2:SetCode(EVENT_PHASE+PHASE_STANDBY)
		e1_2:SetCountLimit(1)
		e1_2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN,2)
		e1_2:SetRange(LOCATION_GRAVE)
		e1_2:SetOperation(c1150006.op1_2)
		e1_2:SetLabel(pos)
		tc:RegisterEffect(e1_2)
	end
end
--
function c1150006.ofilter1_1(c,tp)
	return c:GetSummonPlayer()~=tp and c:IsPosition(POS_FACEUP_ATTACK)
end
function c1150006.op1_1(e,tp,eg,ep,ev,re,r,rp)
	local hurt=e:GetLabel()
	local dg=Group.CreateGroup()
	local g=eg:Filter(c1150006.ofilter1_1,nil,tp)
	if g:GetCount()>0 then
		local tc=g:GetFirst()
		while tc do
			local atk=tc:GetAttack()
			local e1_1_1=Effect.CreateEffect(e:GetHandler())
			e1_1_1:SetType(EFFECT_TYPE_SINGLE)
			e1_1_1:SetCode(EFFECT_UPDATE_ATTACK)
			e1_1_1:SetValue(-hurt)
			e1_1_1:SetReset(RESET_EVENT+0x1fe0000)
			tc:RegisterEffect(e1_1_1)
			if atk~=0 and tc:GetAttack()==0 then dg:AddCard(tc) end
			tc=g:GetNext()
		end
	end
	if dg:GetCount()>0 then
		Duel.Destroy(dg,REASON_EFFECT)
	end
end
--
function c1150006.op1_2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetTurnPlayer()==tp then
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
end

