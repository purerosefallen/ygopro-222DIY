--ＬＰＭ 帝牙卢卡
function c80000445.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,c80000445.tfilter,c80000445.tfilter1,4)
	c:EnableReviveLimit()
	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.synlimit)
	c:RegisterEffect(e1)  
	--immune
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(c80000445.efilter)
	c:RegisterEffect(e2)  
	--activate limit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c80000445.regcon)
	e3:SetOperation(c80000445.aclimit1)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e4:SetCode(EVENT_CHAIN_NEGATED)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(c80000445.regcon)
	e4:SetOperation(c80000445.aclimit2)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_CANNOT_ACTIVATE)
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e5:SetRange(LOCATION_MZONE)
	e5:SetTargetRange(0,1)
	e5:SetCondition(c80000445.regcon)
	e5:SetCondition(c80000445.econ)
	e5:SetValue(c80000445.elimit)
	c:RegisterEffect(e5)
	--spsummon count limit
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetCode(EFFECT_SPSUMMON_COUNT_LIMIT)
	e6:SetRange(LOCATION_MZONE)
	e6:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCondition(c80000445.regcon)
	e6:SetTargetRange(0,1)
	e6:SetValue(1)
	c:RegisterEffect(e6)
	--Destroy replace
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e7:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCode(EFFECT_DESTROY_REPLACE)
	e7:SetCountLimit(1,80000445+EFFECT_COUNT_CODE_DUEL)
	e7:SetTarget(c80000445.reptg)
	e7:SetValue(c80000445.repval)
	e7:SetCondition(c80000445.regcon)
	c:RegisterEffect(e7)
	--remove
	local e8=Effect.CreateEffect(c)
	e8:SetCategory(CATEGORY_REMOVE)
	e8:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e8:SetType(EFFECT_TYPE_QUICK_O)
	e8:SetRange(LOCATION_MZONE)
	e8:SetCountLimit(1)
	e8:SetCode(EVENT_FREE_CHAIN)
	e8:SetHintTiming(0,0x1e0)
	e8:SetTarget(c80000445.target)
	e8:SetOperation(c80000445.operation)
	c:RegisterEffect(e8)
end
function c80000445.repfilter(c,tp)
	return c:IsFaceup() and c:IsControler(tp) and c:IsLocation(LOCATION_MZONE)
		and c:IsCode(80000445) and c:IsReason(REASON_BATTLE+REASON_EFFECT)
end
function c80000445.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=eg:FilterCount(c80000445.repfilter,nil,tp)
	local g=Duel.GetDecktopGroup(tp,ct)
	if chk==0 then return g:IsExists(Card.IsAbleToRemove,10,nil) end
	if Duel.SelectYesNo(tp,aux.Stringid(80000445,1)) then
		Duel.DisableShuffleCheck()
		Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT)
		return true
	else return false end
end
function c80000445.repval(e,c)
	return c80000445.repfilter(c,e:GetHandlerPlayer())
end
function c80000445.regcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SYNCHRO
end
function c80000445.tfilter(c)
	return c:IsType(TYPE_SYNCHRO) and c:IsSetCard(0x2d0)
end
function c80000445.tfilter1(c)
	return c:IsType(TYPE_SYNCHRO) and c:IsSetCard(0x2d0) and not c:IsType(TYPE_TUNER)
end
function c80000445.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end
function c80000445.aclimit1(e,tp,eg,ep,ev,re,r,rp)
	if ep==tp or not re:IsHasType(EFFECT_TYPE_ACTIVATE) then return end
	e:GetHandler():RegisterFlagEffect(80000445,RESET_EVENT+0x3ff0000+RESET_PHASE+PHASE_END,0,1)
end
function c80000445.aclimit2(e,tp,eg,ep,ev,re,r,rp)
	if ep==tp or not re:IsHasType(EFFECT_TYPE_ACTIVATE) then return end
	e:GetHandler():ResetFlagEffect(80000445)
end
function c80000445.econ(e)
	return e:GetHandler():GetFlagEffect(80000445)~=0
end
function c80000445.elimit(e,te,tp)
	return te:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function c80000445.filter(c)
	return c:IsAbleToRemove()
end
function c80000445.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c80000445.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c80000445.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,c80000445.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
		Duel.SetChainLimit(aux.FALSE)
end
function c80000445.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and Duel.Remove(tc,0,REASON_EFFECT+REASON_TEMPORARY)~=0 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetReset(RESET_PHASE+PHASE_END)
		e1:SetLabelObject(tc)
		e1:SetCountLimit(1)
		e1:SetOperation(c80000445.retop)
		Duel.RegisterEffect(e1,tp)
	end
	if Duel.GetAttacker() then Duel.NegateAttack()
	else
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_ATTACK_ANNOUNCE)
		e1:SetReset(RESET_PHASE+PHASE_END)
		e1:SetCountLimit(1)
		e1:SetOperation(c80000445.disop)
		Duel.RegisterEffect(e1,tp)
	end
end
function c80000445.retop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ReturnToField(e:GetLabelObject())
end
function c80000445.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,80000445)
	Duel.NegateAttack()
end