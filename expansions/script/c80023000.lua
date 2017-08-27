--番长狮子
function c80023000.initial_effect(c)
	c:EnableReviveLimit()
	--cannot special summon
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(aux.ritlimit)
	c:RegisterEffect(e0)	
	--atkup
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(80023000,0))
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,80023000)
	e1:SetCondition(c80023000.atkcon)
	e1:SetCost(c80023000.atkcost)
	e1:SetOperation(c80023000.atkop)
	c:RegisterEffect(e1)
	--chain attack
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(80023000,2))
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_BATTLE_DESTROYING)
	e3:SetCondition(c80023000.atcon)
	e3:SetOperation(c80023000.atop)
	c:RegisterEffect(e3)
	--actlimit
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetCode(EFFECT_CANNOT_ACTIVATE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(0,1)
	e4:SetValue(c80023000.aclimit)
	e4:SetCondition(c80023000.actcon)
	c:RegisterEffect(e4)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(80023000,1))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCountLimit(1,80023001)
	e2:SetCondition(c80023000.thcon)
	e2:SetTarget(c80023000.target)
	e2:SetOperation(c80023000.operation)
	c:RegisterEffect(e2)
end
function c80023000.mat_filter(c)
	return c:IsSetCard(0xa2d6)
end
function c80023000.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local c=Duel.GetAttackTarget()
	if not c then return false end
	if c:IsControler(1-tp) then c=Duel.GetAttacker() end
	e:SetLabelObject(c)
	return c and c:IsSetCard(0xa2d6) and c:IsRelateToBattle()
end
function c80023000.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c80023000.atkop(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetLabelObject()
	if c:IsFaceup() and c:IsRelateToBattle() then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_DAMAGE_CAL)
		e1:SetValue(c:GetBaseAttack()*2)
		c:RegisterEffect(e1)
	end
end
function c80023000.atcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return Duel.GetAttacker()==c and aux.bdocon(e,tp,eg,ep,ev,re,r,rp) and c:IsChainAttackable()
end
function c80023000.atop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ChainAttack()
end
function c80023000.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c80023000.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)~=0 and tc:IsPreviousLocation(LOCATION_MZONE) then
		local atk=tc:GetTextAttack()
		if atk<0 then atk=0 end
		Duel.Damage(1-tp,atk,REASON_EFFECT)
	end
end
function c80023000.thcon(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(e:GetHandler():GetSummonType(),SUMMON_TYPE_RITUAL)==SUMMON_TYPE_RITUAL
end
function c80023000.actfilter(c,tp)
	return c and c:IsFaceup() and c:IsSetCard(0xa2d6) and c:IsType(TYPE_MONSTER) and c:IsControler(tp)
end
function c80023000.aclimit(e,re,tp)
	return not re:GetHandler():IsImmuneToEffect(e)
end
function c80023000.actcon(e)
	local tp=e:GetHandlerPlayer()
	return c80023000.actfilter(Duel.GetAttacker(),tp) or c80023000.actfilter(Duel.GetAttackTarget(),tp)
end