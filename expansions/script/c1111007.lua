--蝶舞·清霖
function c1111007.initial_effect(c)
--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_POSITION+CATEGORY_DRAW)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c1111007.tg1)
	e1:SetOperation(c1111007.op1)
	c:RegisterEffect(e1)	
--
end
--
c1111007.named_with_Dw=1
function c1111007.IsDw(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Dw
end
--
function c1111007.tfilter1(c)
	return c:IsFaceup() and c:IsCanTurnSet() and c:IsType(TYPE_MONSTER)
end
function c1111007.tg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c1111007.tfilter1(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c1111007.tfilter1,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c1111007.tfilter1,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,1,0,LOCATION_MZONE)
end
--
function c1111007.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) and tc:IsLocation(LOCATION_MZONE) then
		if tc:IsType(TYPE_MONSTER) then
			local num=0
			if tc:IsHasEffect(EFFECT_DISABLE_EFFECT) or tc:IsHasEffect(EFFECT_DISABLE) then
				num=1
			end
			if Duel.ChangePosition(tc,POS_FACEDOWN_DEFENSE)>0 and tc:IsType(TYPE_MONSTER) then 
				if num==1 and Duel.SelectYesNo(tp,aux.Stringid(1111007,0)) then
					Duel.Draw(tp,1,REASON_EFFECT)
				end
				Duel.BreakEffect()
				if Duel.ChangePosition(tc,POS_FACEUP_ATTACK)~=0 then
					local e1_1=Effect.CreateEffect(e:GetHandler())
					e1_1:SetType(EFFECT_TYPE_SINGLE)
					e1_1:SetCode(EFFECT_IMMUNE_EFFECT)
					e1_1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
					e1_1:SetRange(LOCATION_MZONE)
					e1_1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
					e1_1:SetValue(c1111007.efilter1_1)
					tc:RegisterEffect(e1_1,true)
				end
			end
		end
	end
end
function c1111007.efilter1_1(e,re)
	return re:GetHandlerPlayer()~=e:GetHandlerPlayer()
end
--