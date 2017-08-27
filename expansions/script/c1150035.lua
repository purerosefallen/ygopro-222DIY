--MARRIAGE
function c1150035.initial_effect(c)
--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,1150035+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c1150035.tg1)
	e1:SetOperation(c1150035.op1)
	c:RegisterEffect(e1)  
--	
end
--
function c1150035.tfilter1(c)
	return c:IsFaceup() 
end
function c1150035.tg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(c1150035.tfilter1,tp,LOCATION_MZONE,0,2,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g1=Duel.SelectTarget(tp,c1150035.tfilter1,tp,LOCATION_MZONE,0,1,1,nil)
	local tc1=g1:GetFirst()
	e:SetLabelObject(g1:GetFirst())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g2=Duel.SelectTarget(tp,c1150035.tfilter1,tp,LOCATION_MZONE,0,1,1,tc1)	
end
--
function c1150035.ofilter1(c,e)
	return c:IsFaceup() and c:IsRelateToEffect(e)
end
function c1150035.op1(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(c1150035.ofilter1,tc,e)
		if g:GetCount()>0 then
			local tc2=g:GetFirst()
			if not tc:IsImmuneToEffect(e) then
				local e1_1=Effect.CreateEffect(e:GetHandler())
				e1_1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
				e1_1:SetCode(EFFECT_DESTROY_REPLACE)
				e1_1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
				e1_1:SetRange(LOCATION_MZONE)
				e1_1:SetReset(RESET_EVENT+0x1fe0000)
				e1_1:SetLabelObject(tc2)
				e1_1:SetTarget(c1150035.tg1_1)
				e1_1:SetOperation(c1150035.op1_1)
				tc:RegisterEffect(e1_1)
			end
			if tc2:IsFaceup() and not tc2:IsImmuneToEffect(e) then
				local e1_2=Effect.CreateEffect(e:GetHandler())
				e1_2:SetType(EFFECT_TYPE_SINGLE)
				e1_2:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
				e1_2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
				e1_2:SetRange(LOCATION_MZONE)
				e1_2:SetLabelObject(tc)
				e1_2:SetValue(1)
				e1_2:SetCondition(c1150035.con1_2)
				tc2:RegisterEffect(e1_2)			
				local e1_3=Effect.CreateEffect(e:GetHandler())
				e1_3:SetType(EFFECT_TYPE_SINGLE)
				e1_3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
				e1_3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
				e1_3:SetRange(LOCATION_MZONE)
				e1_3:SetLabelObject(tc)
				e1_3:SetCondition(c1150035.con1_2)				
				e1_3:SetValue(c1150035.efilter1_3)
				tc2:RegisterEffect(e1_3)
			end
		end
	end
end
--
function c1150035.tg1_1(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=e:GetHandler()
	local tc2=e:GetLabelObject()
	if chk==0 then return tc2:GetAttack()>499 and tc2:IsFaceup() end
	return Duel.SelectYesNo(tp,aux.Stringid(1150035,0))
end
--
function c1150035.op1_1(e,tp,eg,ep,ev,re,r,rp)
	local tc2=e:GetLabelObject()
	local e1_1_1=Effect.CreateEffect(e:GetHandler())
	e1_1_1:SetType(EFFECT_TYPE_SINGLE)
	e1_1_1:SetCode(EFFECT_UPDATE_ATTACK)
	e1_1_1:SetReset(RESET_EVENT+0x1fe0000)
	e1_1_1:SetValue(-500)
	tc2:RegisterEffect(e1_1_1)
end
--
function c1150035.con1_2(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	return tc:IsFaceup()
end
--
function c1150035.efilter1_3(e,re)
	return e:GetHandlerPlayer()~=re:GetHandlerPlayer()
end
--








