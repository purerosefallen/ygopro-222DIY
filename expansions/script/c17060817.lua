--新春型歌姬亚瑟
function c17060817.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(Card.IsType,TYPE_PENDULUM),1)
	c:EnableReviveLimit()
	--pendulum summon
	aux.EnablePendulumAttribute(c,false)
	--recover
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(17060817,1))
	e2:SetCategory(CATEGORY_RECOVER)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,17060817)
	e2:SetTarget(c17060817.rectg)
	e2:SetOperation(c17060817.recop)
	c:RegisterEffect(e2)
	--chain attack
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(17060817,2))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_BATTLE_DESTROYING)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,17060817)
	e3:SetCondition(c17060817.cacon)
	e3:SetTarget(c17060817.catg)
	e3:SetOperation(c17060817.caop)
	c:RegisterEffect(e3)
	--pendulum
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(17060817,3))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_DESTROYED)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCondition(c17060817.pencon)
	e4:SetTarget(c17060817.pentg)
	e4:SetOperation(c17060817.penop)
	c:RegisterEffect(e4)
end
c17060817.is_named_with_Singer_Arthur=1
c17060817.is_named_with_Million_Arthur=1
function c17060817.IsSinger_Arthur(c)
	local m=_G["c"..c:GetCode()]
	return m and m.is_named_with_Singer_Arthur
end
function c17060817.IsMillion_Arthur(c)
	local m=_G["c"..c:GetCode()]
	return m and m.is_named_with_Million_Arthur
end
function c17060817.filter(c)
	return c:IsFaceup() and c:GetAttack()>0
end
function c17060817.rectg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c17060817.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c17060817.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c17060817.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,g:GetFirst():GetAttack())
end
function c17060817.recop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and tc:GetAttack()>0 then
		Duel.Recover(tp,tc:GetAttack(),REASON_EFFECT)
	end
end
function c17060817.cacon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=eg:GetFirst()
	return rc:IsRelateToBattle() and rc:IsStatus(STATUS_OPPO_BATTLE)
		and rc:IsFaceup() and rc:IsType(TYPE_PENDULUM)  and rc:IsControler(tp)
end
function c17060817.catg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMZoneCount(1-tp)>0
		and Duel.GetAttackTarget():IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_ATTACK,1-tp) end
	Duel.GetAttackTarget():CreateEffectRelation(e)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,Duel.GetAttackTarget(),1,0,0)
end
function c17060817.caop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=Duel.GetAttackTarget()
	if not bc:IsRelateToEffect(e) then return end
	if Duel.SpecialSummonStep(bc,0,tp,1-tp,false,false,POS_FACEUP_ATTACK) then
		local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			bc:RegisterEffect(e1)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			e2:SetReset(RESET_EVENT+0x1fe0000)
			bc:RegisterEffect(e2)
		end
		Duel.SpecialSummonComplete()
		local tc=Duel.GetAttacker()
		if tc:IsFaceup() and tc:IsControler(tp) and tc:IsRelateToBattle() then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetValue(500)
			e1:SetReset(RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e1)
			if tc:IsChainAttackable() then
				Duel.ChainAttack()
		end
	end
end
function c17060817.pencon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_MZONE) and c:IsFaceup()
end
function c17060817.penfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c17060817.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMZoneCount(tp)>0
		and Duel.IsExistingMatchingCard(c17060817.penfilter,tp,LOCATION_PZONE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_PZONE)
end
function c17060817.penop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or Duel.GetMZoneCount(tp)<1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c17060817.penfilter,tp,LOCATION_PZONE,0,1,1,nil,e,tp)
	if g:GetCount()>0 and Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)>0 then
		Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
end