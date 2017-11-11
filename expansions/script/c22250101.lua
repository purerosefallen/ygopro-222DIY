--Riviera 利达
function c22250101.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,c22250101.ffilter,aux.FilterBoolFunction(Card.IsRace,RACE_FAIRY),true)
	--atk down
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE+CATEGORY_DESTROY)
	e5:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCode(EVENT_DAMAGE_CALCULATING)
	e5:SetCondition(c22250101.atkcon)
	e5:SetOperation(c22250101.atkop)
	c:RegisterEffect(e5)
	--extra atk
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(22250101,0))
	e1:SetCategory(CATEGORY_RECOVER+CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_BATTLED)
	e1:SetCountLimit(1,22250101)
	e1:SetCondition(c22250101.descon)
	e1:SetTarget(c22250101.destg)
	e1:SetOperation(c22250101.desop)
	c:RegisterEffect(e1)
	--battle indestructable
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_INDESTRUCTABLE)
	e2:SetCondition(c22250101.indcon)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	--no battle damage
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_NO_BATTLE_DAMAGE)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
	e1:SetValue(1)
	c:RegisterEffect(e1)
end
c22250101.named_with_Riviera=1
function c22250101.IsRiviera(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Riviera
end
function c22250101.ffilter(c)
	return c:IsFusionType(TYPE_MONSTER) and c22250101.IsRiviera(c)
end
function c22250101.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetBattleTarget()
end
function c22250101.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	if c:IsRelateToBattle() and c:IsFaceup() and bc:IsRelateToBattle() and bc:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(-500)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		bc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_UPDATE_DEFENSE)
		e2:SetValue(-500)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		bc:RegisterEffect(e2)
		if bc:GetAttack()*bc:GetDefense()==0 then
			Duel.Remove(bc,POS_FACEUP,REASON_EFFECT)
			if Duel.Remove(c,POS_FACEUP,REASON_EFFECT+REASON_TEMPORARY)~=0 then
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
				e1:SetCode(EVENT_PHASE+PHASE_END)
				e1:SetReset(RESET_PHASE+PHASE_END)
				e1:SetLabelObject(c)
				e1:SetCountLimit(1)
				e1:SetOperation(c22250101.retop)
				Duel.RegisterEffect(e1,tp)
			end
		end
	end
end
function c22250101.descon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetAttackTarget()~=nil
end
function c22250101.atkfilter(c)
	return c22250101.IsRiviera(c) and c:IsType(TYPE_MONSTER)
end
function c22250101.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local d=c:GetBattleTarget()
	local ct=c:GetMaterial():FilterCount(c22250101.atkfilter,nil)
	if chk==0 then return ct>0 and d:IsRelateToBattle() and c:IsRelateToBattle() and c:IsAttackable() end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,e:GetHandler(),1,0,0)
end
function c22250101.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=c:GetMaterial():FilterCount(c22250101.atkfilter,nil)
	local d=c:GetBattleTarget()
		e:SetLabel(0)
	while ct>0 and not c:IsStatus(STATUS_BATTLE_DESTROYED) do
		if c:IsPosition(POS_DEFENSE) then Duel.ChangePosition(c,POS_FACEUP_ATTACK) end
		Duel.CalculateDamage(c,d)
		ct=ct-1
		e:SetLabel(1)
	end
	if e:GetLabel()>0 and c:IsAbleToRemove() then
		Duel.BreakEffect()
		if c:IsRelateToEffect(e) and Duel.Remove(c,POS_FACEUP,REASON_EFFECT+REASON_TEMPORARY)~=0 then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e1:SetCode(EVENT_PHASE+PHASE_END)
			e1:SetReset(RESET_PHASE+PHASE_END)
			e1:SetLabelObject(c)
			e1:SetCountLimit(1)
			e1:SetOperation(c22250101.retop)
			Duel.RegisterEffect(e1,tp)
		end
	end
end
function c22250101.retop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ReturnToField(e:GetLabelObject())
end
function c22250101.indcon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE 
end