--神枪『冈格尼尔之枪』
function c1151214.initial_effect(c)
--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,1151214+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c1151214.tg1)
	e1:SetOperation(c1151214.op1)
	c:RegisterEffect(e1)
--  
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_EQUIP)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,1151215)
	e2:SetTarget(c1151214.tg2)
	e2:SetOperation(c1151214.op2)
	c:RegisterEffect(e2)	
--  
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_EQUIP_LIMIT)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetValue(c1151214.limit3)
	c:RegisterEffect(e3)
--
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_EQUIP)
	e4:SetRange(LOCATION_SZONE)
	e4:SetOperation(c1151214.op4)
	c:RegisterEffect(e4) 
--  
end
--
function c1151214.IsLeimi(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Leimi
end
c1151214.named_with_Leisp=1
function c1151214.IsLeisp(c)
	local m=_G["c"..c:GetCode()]
	return c.named_with_Leisp
end
--
function c1151214.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroupCount(aux.TRUE,tp,0,LOCATION_MZONE,nil)
	local g2=Duel.GetMatchingGroupCount(aux.TRUE,tp,LOCATION_MZONE,0,nil)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) and g>=g2 end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c1151214.op1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.Draw(tp,1,REASON_EFFECT)~=0 then 
		local tc=Duel.GetOperatedGroup():GetFirst()
		Duel.ConfirmCards(1-tp,tc)
		if (tc:IsAttribute(ATTRIBUTE_DARK) and tc:IsRace(RACE_FIEND)) then
			if Duel.GetMatchingGroupCount(Card.IsDestructable,tp,0,LOCATION_ONFIELD,nil)>0 and Duel.SelectYesNo(tp,aux.Stringid(1151214,0)) then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
				local dg=Duel.SelectMatchingCard(tp,Card.IsDestructable,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
				Duel.Destroy(dg,REASON_EFFECT)
			end
		else
			Duel.Destroy(tc,REASON_EFFECT)
		end
	end
	Duel.ShuffleHand(tp)
end
--
function c1151214.tfilter2(c)
	return c:IsFaceup() and c1151214.IsLeimi(c)
end
function c1151214.tg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c1151214.tfilter2(chkc) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.IsExistingTarget(c1151214.tfilter2,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,c1151214.tfilter2,tp,LOCATION_MZONE,0,1,1,nil)
end
--
function c1151214.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		local tc=Duel.GetFirstTarget()
		if Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and tc:IsFaceup() and tc:IsRelateToEffect(e) then
			local e2_1=Effect.CreateEffect(c)
			e2_1:SetType(EFFECT_TYPE_SINGLE)
			e2_1:SetCode(EFFECT_CHANGE_TYPE)
			e2_1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e2_1:SetValue(TYPE_EQUIP+TYPE_SPELL)
			e2_1:SetReset(RESET_EVENT+0x1fe0000)
			c:RegisterEffect(e2_1,true) 
			Duel.Equip(tp,c,tc,true)
			local e2_2=Effect.CreateEffect(c)
			e2_2:SetType(EFFECT_TYPE_SINGLE)
			e2_2:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
			e2_2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e2_2:SetReset(RESET_EVENT+0x47e0000)
			e2_2:SetValue(LOCATION_REMOVED)
			c:RegisterEffect(e2_2,true)
		end
	end
end
--
function c1151214.limit3(e,c)
	return c1151214.IsLeimi(c)
end
--
function c1151214.op4(e,tp,eg,ep,ev,re,r,rp)
	if eg:GetFirst()~=e:GetHandler() then return end
	local tc=e:GetHandler():GetEquipTarget()
	if tc then
		local e4_1=Effect.CreateEffect(e:GetHandler())
		e4_1:SetDescription(aux.Stringid(1151214,0))
		e4_1:SetCategory(CATEGORY_TOHAND+CATEGORY_TODECK)
		e4_1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
		e4_1:SetRange(LOCATION_MZONE)
		e4_1:SetCode(EVENT_BATTLE_DAMAGE)
		e4_1:SetLabelObject(e:GetHandler())
		e4_1:SetCondition(c1151214.con4_1)
		e4_1:SetTarget(c1151214.tg4_1)
		e4_1:SetOperation(c1151214.op4_1)
		tc:RegisterEffect(e4_1,true)
		if e4_1:GetHandler()==nil then return end
	end
end
--
function c1151214.con4_1(e)
	local g=e:GetHandler():GetEquipGroup()
	if g:IsContains(e:GetLabelObject()) then
		return not e:GetLabelObject():IsDisabled()
	else return false
	end
end
--
function c1151214.tfilter4_1(c)
	return c:IsAbleToHand()
end
function c1151214.tg4_1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c1151214.tfilter4_1,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,0,1,0,LOCATION_GRAVE)
end
--
function c1151214.ofilter4_1(c)
	return c:IsAbleToDeck()
end
function c1151214.op4_1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c1151214.tfilter4_1,tp,LOCATION_GRAVE,0,1,1,nil)   
	if g:GetCount()>0 then
		if Duel.SendtoHand(g,1-tp,REASON_EFFECT)~=0 and Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0 then
			local g2=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
			if g2:GetCount()>0 then
				Duel.ConfirmCards(tp,g2)
				local g3=Duel.SelectMatchingCard(tp,c1151214.ofilter4_1,tp,0,LOCATION_HAND,1,1,nil)
				if g3:GetCount()>0 then
					local sel=Duel.SelectOption(tp,aux.Stringid(1151214,1),aux.Stringid(1151214,2))
					if sel==0 then
						Duel.SendtoDeck(g3,nil,2,REASON_EFFECT)
					else
						Duel.SendtoDeck(g3,nil,1,REASON_EFFECT)
					end
				end
			end
		end
	end
end
----




