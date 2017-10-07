--超时空武装 主炮-干扰镭射
function c13257308.initial_effect(c)
	c:EnableReviveLimit()
	--equip limit
	local e11=Effect.CreateEffect(c)
	e11:SetType(EFFECT_TYPE_SINGLE)
	e11:SetCode(EFFECT_EQUIP_LIMIT)
	e11:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e11:SetValue(c13257308.eqlimit)
	c:RegisterEffect(e11)
	--immune
	local e12=Effect.CreateEffect(c)
	e12:SetType(EFFECT_TYPE_SINGLE)
	e12:SetCode(EFFECT_IMMUNE_EFFECT)
	e12:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e12:SetRange(LOCATION_SZONE)
	e12:SetCondition(c13257308.econ)
	e12:SetValue(c13257308.efilter)
	c:RegisterEffect(e12)
	--def up
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_EQUIP)
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	e2:SetValue(500)
	c:RegisterEffect(e2)
	--direct
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_EQUIP)
	e3:SetCode(EFFECT_DIRECT_ATTACK)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(13257308,0))
	e4:SetCategory(CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_BATTLE_DAMAGE)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCondition(c13257308.descon)
	e4:SetTarget(c13257308.destg)
	e4:SetOperation(c13257308.desop)
	c:RegisterEffect(e4)
	--actlimit
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e5:SetCode(EFFECT_CANNOT_ACTIVATE)
	e5:SetRange(LOCATION_SZONE)
	e5:SetTargetRange(0,1)
	e5:SetValue(c13257308.aclimit)
	e5:SetCondition(c13257308.actcon)
	c:RegisterEffect(e5)
	
end
function c13257308.eqlimit(e,c)
	return not c:GetEquipGroup():IsExists(Card.IsSetCard,1,e:GetHandler(),0x3352)
end
function c13257308.econ(e)
	return e:GetHandler():GetEquipTarget()
end
function c13257308.efilter(e,re)
	return e:GetHandlerPlayer()~=re:GetOwnerPlayer()
end
function c13257308.descon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp and eg:GetFirst()==e:GetHandler():GetEquipTarget()
end
function c13257308.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return true end
	local ec=e:GetHandler():GetEquipTarget()
	local seq=ec:GetSequence()
	local g=Group.CreateGroup()
	local tc=Duel.GetFieldCard(1-tp,LOCATION_MZONE,4-seq)
	if tc then g:AddCard(tc) end
	tc=Duel.GetFieldCard(1-tp,LOCATION_SZONE,4-seq)
	if tc then g:AddCard(tc) end
	if seq==1 then
		tc=Duel.GetFieldCard(1-tp,LOCATION_MZONE,6)
	elseif seq==3 then
		tc=Duel.GetFieldCard(1-tp,LOCATION_MZONE,5)
	end
	if tc and tc:IsControler(1-tp) then g:AddCard(tc) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c13257308.desop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local ec=e:GetHandler():GetEquipTarget()
	local seq=ec:GetSequence()
	local g=Group.CreateGroup()
	local tc=Duel.GetFieldCard(1-tp,LOCATION_MZONE,4-seq)
	if tc then g:AddCard(tc) end
	tc=Duel.GetFieldCard(1-tp,LOCATION_SZONE,4-seq)
	if tc then g:AddCard(tc) end
	if seq==1 then
		tc=Duel.GetFieldCard(1-tp,LOCATION_MZONE,6)
	elseif seq==3 then
		tc=Duel.GetFieldCard(1-tp,LOCATION_MZONE,5)
	end
	if tc and tc:IsControler(1-tp) then g:AddCard(tc) end
	tc=g:GetFirst()
	if g:GetCount()>0 then
		while tc do
			if tc:IsFaceup() and not tc:IsDisabled() then
				Duel.NegateRelatedChain(tc,RESET_TURN_SET)
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_DISABLE)
				e1:SetReset(RESET_EVENT+0x1fe0000)
				tc:RegisterEffect(e1)
				local e2=e1:Clone()
				e2:SetCode(EFFECT_DISABLE_EFFECT)
				e2:SetValue(RESET_EVENT+0x1fe0000)
				tc:RegisterEffect(e2)
				Duel.AdjustInstantly()
				Duel.NegateRelatedChain(tc,RESET_TURN_SET)
			end
			tc=g:GetNext()
		end
		Duel.Destroy(g,REASON_EFFECT)
		Duel.BreakEffect()
		if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
			local s=Duel.SelectDisableField(tp,1,LOCATION_MZONE,0,0)
			local nseq=0
			if s==1 then nseq=0
			elseif s==2 then nseq=1
			elseif s==4 then nseq=2
			elseif s==8 then nseq=3
			else nseq=4 end
			Duel.MoveSequence(ec,nseq)
		end
		Duel.ChangePosition(ec,POS_FACEUP_DEFENSE)
	end
end
function c13257308.aclimit(e,re,tp)
	return not re:GetHandler():IsImmuneToEffect(e)
end
function c13257308.actcon(e)
	local tc=e:GetHandler():GetEquipTarget()
	return Duel.GetAttacker()==tc or Duel.GetAttackTarget()==tc
end
