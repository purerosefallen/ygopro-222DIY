--ルシフェル
local m=17082102
local cm=_G["c"..m]
cm.dfc_front_side=m
cm.dfc_back_side=m+2
function c17082102.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c,false)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(Card.IsSynchroType,TYPE_PENDULUM),1)
	c:EnableReviveLimit()
	--recover
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(17082102,0))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_BATTLED)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(c17082102.recon)
	e1:SetOperation(c17082102.reop)
	c:RegisterEffect(e1)
	--Change
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(17082102,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(c17082102.changetg)
	e2:SetOperation(c17082102.changeop)
	c:RegisterEffect(e2)
	--recover
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(17082102,2))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c17082102.reccon)
	e3:SetOperation(c17082102.recop)
	c:RegisterEffect(e3)
	--destroy replace
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(17082102,3))
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EFFECT_DESTROY_REPLACE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTarget(c17082102.reptg)
	e4:SetValue(c17082102.repval)
	e4:SetOperation(c17082102.repop)
	c:RegisterEffect(e4)
	--spsummon bgm
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(17082102,4))
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	e5:SetOperation(c17082102.sumsuc)
	c:RegisterEffect(e5)
	--atk bgm
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(17082102,5))
	e6:SetCategory(CATEGORY_ATKCHANGE)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e6:SetCode(EVENT_ATTACK_ANNOUNCE)
	e6:SetOperation(c17082102.atksuc)
	c:RegisterEffect(e6)
	--destroy bgm
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(17082102,6))
	e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e7:SetCode(EVENT_DESTROYED)
	e7:SetProperty(EFFECT_FLAG_DELAY)
	e7:SetCondition(c17082102.descon)
	e7:SetOperation(c17082102.dessuc)
	c:RegisterEffect(e7)
end
function c17082102.recon(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	if not d then return false end
	if d:IsControler(tp) then a,d=d,a end
	return a:IsType(TYPE_MONSTER)
		and not a:IsStatus(STATUS_BATTLE_DESTROYED) and d:IsStatus(STATUS_BATTLE_DESTROYED)
end
function c17082102.reop(e,tp,eg,ep,ev,re,r,rp)
	local bc=Duel.GetAttackTarget()
	Duel.Recover(tp,bc:GetAttack(),REASON_EFFECT)
	Duel.Hint(12,0,aux.Stringid(17082102,11))
end
function c17082102.changetg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c.dfc_back_side and c.dfc_front_side==c:GetOriginalCode() end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c17082102.changeop(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() or c:IsImmuneToEffect(e) then return end
	local tcode=c.dfc_back_side
	c:SetEntityCode(tcode,true)
	c:ReplaceEffect(tcode,0,0)
	Duel.Hint(12,0,aux.Stringid(17082102,12))
end
function c17082102.reccon(e,tp,eg,ep,ev,re,r,rp)
	return tp==Duel.GetTurnPlayer()
end
function c17082102.recop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Recover(tp,1600,REASON_EFFECT)
	Duel.Hint(12,0,aux.Stringid(17082102,11))
end
function c17082102.repfilter(c,tp)
	return c:IsFaceup() and c:IsLocation(LOCATION_MZONE)
		and c:IsControler(tp) and c:IsReason(REASON_EFFECT+REASON_BATTLE)
end
function c17082102.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemove() and eg:IsExists(c17082102.repfilter,1,nil,tp)
	and (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)) end
	return Duel.SelectYesNo(tp,aux.Stringid(17082102,7))
end
function c17082102.repval(e,c)
	return c17082102.repfilter(c,e:GetHandlerPlayer())
end
function c17082102.repop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
end
function c17082102.descon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_MZONE+LOCATION_SZONE) and c:IsFaceup()
end
function c17082102.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(12,0,aux.Stringid(17082102,8))
end	
function c17082102.atksuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(12,0,aux.Stringid(17082102,9))
end
function c17082102.dessuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(12,0,aux.Stringid(17082102,10))
end