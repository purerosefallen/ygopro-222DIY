--暗堕希尔维娅
function c17060861.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(Card.IsType,TYPE_PENDULUM),1)
	c:EnableReviveLimit()
	--pendulum summon
	aux.EnablePendulumAttribute(c,false)
	--pendulum
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(17060861,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,17060861)
	e1:SetCondition(c17060861.spcon)
	e1:SetTarget(c17060861.sptg)
	e1:SetOperation(c17060861.spop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,0x1e0)
	e2:SetCondition(c17060861.spcon1)
	c:RegisterEffect(e2)
	--draw
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(17060861,1))
	e3:SetCategory(CATEGORY_DRAW)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCountLimit(1,170608611)
	e3:SetCondition(c17060861.drcon)
	e3:SetTarget(c17060861.drtg)
	e3:SetOperation(c17060861.drop)
	c:RegisterEffect(e3)
	--destroy replace
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(17060861,2))
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EFFECT_DESTROY_REPLACE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTarget(c17060861.reptg)
	e4:SetValue(c17060861.repval)
	e4:SetOperation(c17060861.repop)
	c:RegisterEffect(e4)
end
c17060861.is_named_with_Dark_Degenerate=1
function c17060861.IsDark_Degenerate(c)
	local m=_G["c"..c:GetCode()]
	return m and m.is_named_with_Dark_Degenerate
end
function c17060861.spcon(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(aux.FilterEqualFunction(Card.GetSummonLocation,LOCATION_EXTRA),tp,0,LOCATION_MZONE,1,nil)
end
function c17060861.spcon1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(aux.FilterEqualFunction(Card.GetSummonLocation,LOCATION_EXTRA),tp,0,LOCATION_MZONE,1,nil)
end
function c17060861.pcfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_PENDULUM) and not c:IsForbidden() and c17060861.IsDark_Degenerate(c)
end
function c17060861.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c17060861.pcfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c17060861.pcfilter,tp,LOCATION_MZONE,0,1,nil)
	and Duel.GetMZoneCount(tp)>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectTarget(tp,c17060861.pcfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c17060861.spop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	if Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP)~=0 then
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		end
	end
end
function c17060861.drcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function c17060861.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c17060861.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
function c17060861.repfilter(c,tp)
	return c:IsFaceup() and c:IsLocation(LOCATION_MZONE)
		and c:IsControler(tp) and c:IsReason(REASON_EFFECT+REASON_BATTLE)
end
function c17060861.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemove() and eg:IsExists(c17060861.repfilter,1,nil,tp)
	and (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)) end
	return Duel.SelectYesNo(tp,aux.Stringid(17060861,3))
end
function c17060861.repval(e,c)
	return c17060861.repfilter(c,e:GetHandlerPlayer())
end
function c17060861.repop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
end