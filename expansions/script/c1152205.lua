--禁弹『折反射』
function c1152205.initial_effect(c)
--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCondition(c1152205.con2)
	e2:SetOperation(c1152205.op2)
	c:RegisterEffect(e2)
--  
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_TODECK)	
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_REMOVE)
	e1:SetTarget(c1152205.tg1)
	e1:SetOperation(c1152205.op1)
	c:RegisterEffect(e1)
--
end
--
function c1152205.IsFulan(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Fulan
end
c1152205.named_with_Fulsp=1
function c1152205.IsFulsp(c)
	local m=_G["c"..c:GetCode()]
	return c.named_with_Fulsp
end
--
function c1152205.tfilter1_1(c)
	return c1152205.IsFulsp(c) and c:IsDestructable() and (c:IsType(TYPE_SPELL) or c:IsType(TYPE_TRAP))
end
function c1152205.tfilter1_2(c)
	return c1152205.IsFulsp(c) and c:IsAbleToDeck() and (c:IsType(TYPE_SPELL) or c:IsType(TYPE_TRAP))
end
function c1152205.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c1152205.tfilter1_1,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,nil) and Duel.IsExistingMatchingCard(c1152212.tfilter1_2,tp,LOCATION_REMOVED,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,tp,LOCATION_ONFIELD+LOCATION_HAND)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_REMOVED)
end
--
function c1152205.op1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,c1152205.tfilter1_1,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,1,nil)
	if g and g:GetCount()>0 then
		local tc=g:GetFirst()
		if Duel.Destroy(tc,REASON_EFFECT)~=0 then
			local e1_1=Effect.CreateEffect(tc)
			e1_1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e1_1SetCode(EVENT_PHASE+PHASE_END)
			e1_1:SetCountLimit(1)
			e1_1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
			e1_1:SetRange(LOCATION_GRAVE)
			e1_1:SetOperation(c1152205.op1_1)
			tc:RegisterEffect(e1_1,true)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
			local g2=Duel.SelectMatchingCard(tp,c1152205.tfilter1_2,tp,LOCATION_REMOVED,0,1,3,nil)
			if g2 and g2:GetCount()>0 then
				Duel.SendtoDeck(g2,nil,2,REASON_EFFECT)
			end
		end
	end
end
--
function c1152205.op1_1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	if not c:IsHasEffect(EFFECT_NECRO_VALLEY) then
		if c:IsType(TYPE_MONSTER) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE) then
			Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)
			Duel.ConfirmCards(1-tp,c)
		else
			if (c:IsType(TYPE_FIELD) or Duel.GetLocationCount(tp,LOCATION_SZONE)>0) and c:IsSSetable() then
				Duel.SSet(tp,c)
				Duel.ConfirmCards(1-tp,c)
			end
		end
	end
end
--
function c1152205.cfilter2(c)
	return c:IsFaceup() and c1152205.IsFulan(c)
end
function c1152205.con2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c1152205.cfilter2,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
end
--
function c1152205.op2(e,tp,eg,ep,ev,re,r,rp)
	local e2_1=Effect.CreateEffect(e:GetHandler())
	e2_1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2_1:SetCode(EVENT_CHAINING)
	e2_1:SetProperty(EFFECT_FLAG_DELAY)
	e2_1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
	e2_1:SetOperation(c1152205.op2_1)
	Duel.RegisterEffect(e2_1,tp)	
end
function c1152205.ofilter2_1(c,tp)
	return c:GetControler()~=tp
end
function c1152205.ofilter2_2(c)
	return c:IsType(TYPE_MONSTER) and c:IsFaceup()
end
function c1152205.ofilter2_3(c)
	return c:IsType(TYPE_MONSTER) and c:IsFaceup() and c:GetAttack()==0
end
function c1152205.op2_1(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(c1152205.ofilter2_1,nil,tp)
	if g:GetCount()~=0 then
		local g2=Duel.GetMatchingGroup(c1152205.ofilter2_2,tp,0,LOCATION_ONFIELD,nil)
		if g2:GetCount()>0 then
			Duel.Hint(HINT_CARD,0,1152205)
			local num=g2:GetCount()
			local hert=num*200
			if Duel.SelectYesNo(1-tp,aux.Stringid(1152205,0)) then
				local tc=g2:GetFirst()
				while tc do
					local e2_1_1=Effect.CreateEffect(tc)
					e2_1_1:SetType(EFFECT_TYPE_SINGLE)
					e2_1_1:SetCode(EFFECT_UPDATE_ATTACK)
					e2_1_1:SetReset(RESET_EVENT+0x1fe0000)
					e2_1_1:SetValue(-hert)
					tc:RegisterEffect(e2_1_1)
					tc=g2:GetNext()
				end
			else
				Duel.Damage(1-tp,hert,REASON_EFFECT)
			end
			local g3=Duel.GetMatchingGroup(c1152205.ofilter2_3,tp,0,LOCATION_ONFIELD,nil)
			if g3:GetCount()>0 then
				Duel.Destroy(g3,REASON_EFFECT)
			end
		end
	end
end
--
