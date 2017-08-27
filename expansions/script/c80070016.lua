--模仿
function c80070016.initial_effect(c)
	--destroy&damage
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE+CATEGORY_SPECIAL_SUMMON)
	e1:SetDescription(aux.Stringid(80070016,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c80070016.target)
	e1:SetOperation(c80070016.operation)
	c:RegisterEffect(e1)
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCondition(aux.exccon)
	e1:SetCost(c80070016.thcost)
	e1:SetTarget(c80070016.destg)
	e1:SetOperation(c80070016.desop)
	c:RegisterEffect(e1)
end
function c80070016.filter(c)
	return c:IsType(TYPE_TOKEN)
end
function c80070016.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c80070016.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c80070016.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c80070016.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	local atk=g:GetFirst():GetAttack()
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,atk/2)
end
function c80070016.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		local atk=tc:GetAttack()
		if Duel.Destroy(tc,REASON_EFFECT)~=0 then
			Duel.Damage(1-tp,atk/2,REASON_EFFECT)
		if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.SelectYesNo(tp,aux.Stringid(80070016,1))
			and Duel.IsPlayerCanSpecialSummonMonster(tp,37564322,0,0x4011,-2,-2,1,RACE_SPELLCASTER,ATTRIBUTE_DARK) then
			Duel.BreakEffect()
			local token=Duel.CreateToken(tp,37564322)
			Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_SET_BASE_ATTACK)
			e1:SetValue(atk)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			token:RegisterEffect(e1)
			local e3=Effect.CreateEffect(e:GetHandler())
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetCode(EFFECT_SET_BASE_DEFENSE)
			e3:SetValue(atk)
			e3:SetReset(RESET_EVENT+0x1fe0000)
			token:RegisterEffect(e3)
			Duel.SpecialSummonComplete()
			end
		end
	end
end
function c80070016.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(c80070016.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,g:GetCount()*300)
end
function c80070016.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c80070016.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	Duel.Destroy(g,REASON_EFFECT)
	local sg=Duel.GetOperatedGroup()
	if sg:GetCount()>0 then
		Duel.Damage(1-tp,sg:GetCount()*300,REASON_EFFECT)
	end
end
function c80070016.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end