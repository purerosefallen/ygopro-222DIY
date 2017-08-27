--ルシフェル
local m=17082104
local cm=_G["c"..m]
function c17082104.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c,false)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsXyzType,TYPE_PENDULUM),8,3)
	c:EnableReviveLimit()
	--damage
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(17082104,1))
	e1:SetCategory(CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_BATTLED)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(c17082104.dacon)
	e1:SetOperation(c17082104.daop)
	c:RegisterEffect(e1)
	--damage
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DAMAGE)
	e3:SetDescription(aux.Stringid(17082104,2))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c17082104.damcon)
	e3:SetOperation(c17082104.damop)
	c:RegisterEffect(e3)
	--destroy replace
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(17082104,3))
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EFFECT_DESTROY_REPLACE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTarget(c17082104.reptg)
	e4:SetValue(c17082104.repval)
	e4:SetOperation(c17082104.repop)
	c:RegisterEffect(e4)
	--spsummon bgm
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(17082104,4))
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	e5:SetOperation(c17082104.sumsuc)
	c:RegisterEffect(e5)
	--atk bgm
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(17082104,5))
	e6:SetCategory(CATEGORY_ATKCHANGE)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e6:SetCode(EVENT_ATTACK_ANNOUNCE)
	e6:SetOperation(c17082104.atksuc)
	c:RegisterEffect(e6)
	--destroy bgm
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(17082104,6))
	e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e7:SetCode(EVENT_DESTROYED)
	e7:SetProperty(EFFECT_FLAG_DELAY)
	e7:SetCondition(c17082104.descon)
	e7:SetOperation(c17082104.dessuc)
	c:RegisterEffect(e7)
	--back
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_ADJUST)
	e8:SetRange(LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_HAND+LOCATION_EXTRA)
	e8:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_SET_AVAILABLE)
	e8:SetCondition(c17082104.backon)
	e8:SetOperation(c17082104.backop)
	c:RegisterEffect(e8)
end
c17082104.pendulum_level=8
function c17082104.backon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c.dfc_front_side and c:GetOriginalCode()==c.dfc_back_side
end
function c17082104.backop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tcode=c.dfc_front_side
	c:SetEntityCode(tcode)
	Duel.ConfirmCards(tp,Group.FromCards(c))
	Duel.ConfirmCards(1-tp,Group.FromCards(c))
	c:ReplaceEffect(tcode,0,0)
end
function c17082104.dacon(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	if not d then return false end
	if d:IsControler(tp) then a,d=d,a end
	return a:IsType(TYPE_MONSTER)
		and not a:IsStatus(STATUS_BATTLE_DESTROYED) and d:IsStatus(STATUS_BATTLE_DESTROYED)
end
function c17082104.daop(e,tp,eg,ep,ev,re,r,rp)
	local bc=Duel.GetAttackTarget()
	Duel.Damage(1-tp,bc:GetAttack(),REASON_EFFECT)
	Duel.Hint(12,0,aux.Stringid(17082104,11))
end
function c17082104.damcon(e,tp,eg,ep,ev,re,r,rp)
	return tp==Duel.GetTurnPlayer()
end
function c17082104.damop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Damage(1-tp,1600,REASON_EFFECT)
	Duel.Hint(12,0,aux.Stringid(17082104,11))
end
function c17082104.repfilter(c,tp)
	return c:IsFaceup() and c:IsLocation(LOCATION_MZONE)
		and c:IsControler(tp) and c:IsReason(REASON_EFFECT+REASON_BATTLE)
end
function c17082104.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemove() and eg:IsExists(c17082104.repfilter,1,nil,tp)
	and (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)) end
	return Duel.SelectYesNo(tp,aux.Stringid(17082104,7))
end
function c17082104.repval(e,c)
	return c17082104.repfilter(c,e:GetHandlerPlayer())
end
function c17082104.repop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
end
function c17082104.descon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_MZONE+LOCATION_SZONE) and c:IsFaceup()
end
function c17082104.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(12,0,aux.Stringid(17082104,8))
end	
function c17082104.atksuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(12,0,aux.Stringid(17082104,9))
end
function c17082104.dessuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(12,0,aux.Stringid(17082104,10))
end