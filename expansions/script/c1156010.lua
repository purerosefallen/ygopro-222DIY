--逆袭的天邪鬼
function c1156010.initial_effect(c)
--
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,c1156010.lfilter0,2,4)
--  
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(1156010,0))
	e1:SetType(EVENT_FREE_CHAIN+EFFECT_TYPE_CONTINUOUS)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(c1156010.tg1)
	e1:SetOperation(c1156010.op1)
	c:RegisterEffect(e1)
--
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_FIELD)
	e2:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c1156010.con2)
	e2:SetOperation(c1156010.op2)
	c:RegisterEffect(e2)
--
end
--
function c1156010.lfilter0(c)
	return c:GetAttack()~=c:GetBaseAttack()
end
--
function c1156010.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetTurnPlayer()==e:GetHandler():GetControler() end
end 
--
function c1156010.op1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,1156010)
	local c=e:GetHandler()
	local sel=Duel.SelectOption(tp,aux.Stringid(1156010,1),aux.Stringid(1156010,2))
	if sel==0 then
		local e1_1=Effect.CreateEffect(c)
		e1_1:SetDescription(aux.Stringid(1156010,1))
		e1_1:SetCategory(CATEGORY_DISABLE+CATEGORY_ATKCHANGE)
		e1_1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
		e1_1:SetType(EFFECT_TYPE_QUICK_O)
		e1_1:SetCode(EVENT_FREE_CHAIN)
		e1_1:SetRange(LOCATION_MZONE)
		e1_1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
		e1_1:SetCountLimit(1)
		e1_1:SetTarget(c1156010.tg1_1)
		e1_1:SetOperation(c1156010.op1_1)
		c:RegisterEffect(e1_1,true)
	else
		local e1_2=Effect.CreateEffect(c)
		e1_2:SetDescription(aux.Stringid(1156010,2))
		e1_2:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
		e1_2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
		e1_2:SetType(EFFECT_TYPE_QUICK_O)
		e1_2:SetCode(EVENT_FREE_CHAIN)
		e1_2:SetRange(LOCATION_MZONE)
		e1_2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
		e1_2:SetCountLimit(1)
		e1_2:SetTarget(c1156010.tg1_2)
		e1_2:SetOperation(c1156010.op1_2)
		c:RegisterEffect(e1_2,true)		
	end
end
--
function c1156010.tfilter1_1(c)
	return c:IsType(TYPE_MONSTER) and c:IsFaceup()
end
function c1156010.tg1_1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMatchingGroupCount(c1156010.tfilter1_1,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)>0 end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,nil,1,0,LOCATION_ONFIELD)
	Duel.SetOperationInfo(0,CATEGORY_ATKCHANGE,nil,1,0,LOCATION_ONFIELD)
end
function c1156010.op1_1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c1156010.tfilter1_1,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	if g:GetCount()>0 then
		local tg=g:GetMaxGroup(Card.GetAttack)
		if tg:GetCount()>0 then
			if tg:GetCount()>1 then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
				local sg=tg:Select(tp,1,1,nil)
				Duel.HintSelection(sg)
				local tc=sg:GetFirst()
				local e1_1_1=Effect.CreateEffect(c)
				e1_1_1:SetType(EFFECT_TYPE_SINGLE)
				e1_1_1:SetCode(EFFECT_DISABLE)
				e1_1_1:SetReset(RESET_EVENT+0x1fe0000)
				tc:RegisterEffect(e1_1_1)
				local e1_1_2=Effect.CreateEffect(c)
				e1_1_2:SetType(EFFECT_TYPE_SINGLE)
				e1_1_2:SetCode(EFFECT_DISABLE_EFFECT)
				e1_1_2:SetReset(RESET_EVENT+0x1fe0000)
				tc:RegisterEffect(e1_1_2)
				local gn=g:GetMinGroup(Card.GetAttack)
				local tn=gn:GetFirst()
				local num=tn:GetAttack()
				local e1_1_3=Effect.CreateEffect(c)
				e1_1_3:SetType(EFFECT_TYPE_SINGLE)
				e1_1_3:SetCode(EFFECT_SET_ATTACK)
				e1_1_3:SetValue(num)
				e1_1_3:SetReset(RESET_EVENT+0x1fe0000)
				tc:RegisterEffect(e1_1_3)
			else 
				local tc=tg:GetFirst()
				local e1_1_1=Effect.CreateEffect(c)
				e1_1_1:SetType(EFFECT_TYPE_SINGLE)
				e1_1_1:SetCode(EFFECT_DISABLE)
				e1_1_1:SetReset(RESET_EVENT+0x1fe0000)
				tc:RegisterEffect(e1_1_1)
				local e1_1_2=Effect.CreateEffect(c)
				e1_1_2:SetType(EFFECT_TYPE_SINGLE)
				e1_1_2:SetCode(EFFECT_DISABLE_EFFECT)
				e1_1_2:SetReset(RESET_EVENT+0x1fe0000)
				tc:RegisterEffect(e1_1_2)
				local gn=g:GetMinGroup(Card.GetAttack)
				local tn=gn:GetFirst()
				local num=tn:GetAttack()
				local e1_1_3=Effect.CreateEffect(c)
				e1_1_3:SetType(EFFECT_TYPE_SINGLE)
				e1_1_3:SetCode(EFFECT_SET_ATTACK)
				e1_1_3:SetValue(num)
				e1_1_3:SetReset(RESET_EVENT+0x1fe0000)
				tc:RegisterEffect(e1_1_3)
			end
		end
	end
end
--
function c1156010.tfilter1_2(c)
	return c:IsType(TYPE_MONSTER) and c:IsFaceup() and not c:IsType(TYPE_LINK)
end
function c1156010.tg1_2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMatchingGroupCount(c1156010.tfilter1_2,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)>0 end
	Duel.SetOperationInfo(0,CATEGORY_ATKCHANGE,nil,1,0,LOCATION_ONFIELD)
	Duel.SetOperationInfo(0,CATEGORY_DEFCHANGE,nil,1,0,LOCATION_ONFIELD)
end
function c1156010.op1_2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectMatchingCard(tp,c1156010.tfilter1_2,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)   
	if g:GetCount()>0 then
		local tc=g:GetFirst()
		local atk=tc:GetAttack()
		local def=tc:GetDefense()
		local e1_2_1=Effect.CreateEffect(c)
		e1_2_1:SetType(EFFECT_TYPE_SINGLE)
		e1_2_1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1_2_1:SetValue(def)
		e1_2_1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1_2_1)		
		local e1_2_2=Effect.CreateEffect(c)
		e1_2_2:SetType(EFFECT_TYPE_SINGLE)
		e1_2_2:SetCode(EFFECT_SET_DEFENSE_FINAL)
		e1_2_2:SetValue(atk)
		e1_2_2:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1_2_2)
		local e1_2_3=Effect.CreateEffect(c)
		e1_2_3:SetType(EFFECT_TYPE_SINGLE)
		e1_2_3:SetCode(EFFECT_IMMUNE_EFFECT)
		e1_2_3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1_2_3:SetRange(LOCATION_MZONE)
		e1_2_3:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
		e1_2_3:SetValue(c1156010.efilter1_2_3)
		e1_2_3:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1_2_3)
	end
end
function c1156010.efilter1_2_3(e,re)
	if re:IsActiveType(TYPE_MONSTER) then
		return re:GetHandler():GetAttack()>=e:GetHandler():GetAttack()
	else
		return false
	end
end
--
function c1156010.con2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetAttacker()
	local bc=Duel.GetAttackTarget()
	if not bc then return false end
	local num=0
	if bc:IsControler(1-tp) then
		if bc:GetAttack()>tc:GetAttack() then
			num=1
		end
		bc=tc
	else
		if bc:GetAttack()<tc:GetAttack() then
			num=1
		end
	end
	e:SetLabelObject(bc)
	if num==0 then
		return false 
	else
		return bc:IsFaceup() and e:GetHandler():GetLinkedGroup():IsContains(bc)
	end
end
--
function c1156010.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=e:GetLabelObject()
	local bc=Duel.GetAttackTarget()
	if tc:IsRelateToBattle() and tc:IsFaceup() and tc:IsControler(tp) and bc:IsRelateToBattle() then
		local e2_1=Effect.CreateEffect(c)
		e2_1:SetType(EFFECT_TYPE_SINGLE)
		e2_1:SetCode(EFFECT_UPDATE_ATTACK)
		e2_1:SetReset(RESET_PHASE+PHASE_DAMAGE_CAL)
		e2_1:SetValue(bc:GetAttack())
		tc:RegisterEffect(e2_1)
	end
end
--
