--化石口袋妖怪 Mega化石翼龙
function c80000123.initial_effect(c)
	c:EnableReviveLimit()
	c:SetUniqueOnField(1,0,10000000) 
	--spsummon condition
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE)
	e7:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e7:SetCode(EFFECT_SPSUMMON_CONDITION)
	e7:SetValue(aux.FALSE)
	c:RegisterEffect(e7)	
	--indes
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e2)
	--avoid battle damage
	local e5=e1:Clone()
	e5:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
	c:RegisterEffect(e5)
	--atk
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(80000123,0))
	e4:SetCode(EVENT_ATTACK_ANNOUNCE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetTarget(c80000123.atktg)
	e4:SetOperation(c80000123.atkop)
	c:RegisterEffect(e4)
	--atkup
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(80000123,1))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCategory(CATEGORY_DAMAGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,80000123+EFFECT_COUNT_CODE_DUEL)
	e3:SetCost(c80000123.atkcost)
	e3:SetOperation(c80000123.atkop1)
	c:RegisterEffect(e3)
	--reflect damage
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetCode(EFFECT_REFLECT_DAMAGE)
	e6:SetRange(LOCATION_MZONE)
	e6:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e6:SetTargetRange(1,0)
	e6:SetValue(c80000123.refcon)
	c:RegisterEffect(e6)
end
function c80000123.refcon(e,re,val,r,rp,rc)
	return bit.band(r,REASON_EFFECT)~=0 and rp~=e:GetHandler():GetControler()
end
function c80000123.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetAttackTarget():IsCanBeEffectTarget(e) end
	Duel.SetTargetCard(Duel.GetAttackTarget())
end
function c80000123.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetReset(RESET_PHASE+RESET_DAMAGE_CAL)
		e1:SetValue(0)
		tc:RegisterEffect(e1)
	end
end
function c80000123.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local c=e:GetHandler()
		local a=Duel.GetAttacker()
		local at=Duel.GetAttackTarget()
		return ((a==c and at and at:IsFaceup() and at:GetAttack()>0) or (at==c and a:GetAttack()>0))
			and not e:GetHandler():IsStatus(STATUS_CHAINING)
	end
	Duel.SetTargetCard(e:GetHandler():GetBattleTarget())
end
function c80000123.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and c:IsFaceup() and tc:IsRelateToEffect(e) and tc:IsFaceup() and tc:GetAttack()>0 then
		local atk=tc:GetBaseAttack()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetValue(0)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_SET_DEFENSE_FINAL)
		e2:SetValue(0)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e2)
	end
end
function c80000123.cfilter(c)
	return c:IsSetCard(0x2d1) and (c:IsLocation(LOCATION_GRAVE) or c:IsFaceup())
end
function c80000123.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c80000123.cfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,LOCATION_MZONE+LOCATION_GRAVE,e:GetHandler())
	if chk==0 then return g:GetCount()>0 and g:FilterCount(Card.IsAbleToRemoveAsCost,nil)==g:GetCount() end
	e:SetLabel(g:GetCount())
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c80000123.atkop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
		Duel.Damage(1-tp,e:GetLabel()*700,REASON_EFFECT)
end