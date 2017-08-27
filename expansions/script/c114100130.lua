--★腐毒の守り 天魔･悪路（あくろ）
function c114100130.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(c114100130.descost)
	e1:SetTarget(c114100130.destg)
	e1:SetOperation(c114100130.desop)
	c:RegisterEffect(e1)
end
--
function c114100130.cfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost() and c:IsSetCard(0x221)
end
function c114100130.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c114100130.cfilter,tp,LOCATION_GRAVE,0,2,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c114100130.cfilter,tp,LOCATION_GRAVE,0,2,2,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c114100130.filter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToGrave()
end
function c114100130.downfilter(c)
	return c:IsFaceup() and ( c:GetAttack()>=0 or c:GetDefense()>=0 )
end
function c114100130.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c114100130.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
		--and Duel.IsExistingMatchingCard(c114100130.downfilter,tp,0,LOCATION_MZONE,1,nil)  end
	local g=Duel.GetMatchingGroup(c114100130.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,g:GetCount(),0,0)
end
function c114100130.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c114100130.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	if g:GetCount()>0 then
		Duel.SelectOption(tp,aux.Stringid(114100130,0))
		Duel.SelectOption(1-tp,aux.Stringid(114100130,0))
	end
	if Duel.SendtoGrave(g,REASON_EFFECT)~=0 then
		local mg=Duel.GetMatchingGroup(c114100130.downfilter,tp,0,LOCATION_MZONE,nil)
		if mg:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(114100130,1)) then
			local tc=mg:GetFirst()
			while tc do
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_UPDATE_ATTACK)
				e1:SetValue(-600)
				e1:SetReset(RESET_EVENT+0x1fe0000)
				tc:RegisterEffect(e1)
				local e2=e1:Clone()
				e2:SetCode(EFFECT_UPDATE_DEFENSE)
				tc:RegisterEffect(e2)
				tc=mg:GetNext()
			end
		end
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_FIELD)
		e3:SetCode(EFFECT_CANNOT_ATTACK)
		e3:SetTargetRange(LOCATION_MZONE,0)
		e3:SetTarget(c114100130.ftarget)
		e3:SetLabel(c:GetFieldID())
		e3:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e3,tp)
	end
end
function c114100130.ftarget(e,c)
	return e:GetLabel()~=c:GetFieldID()
end