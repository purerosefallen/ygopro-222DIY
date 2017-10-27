--新春型歌姬亚瑟
function c17060816.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(Card.IsType,TYPE_PENDULUM),1)
	c:EnableReviveLimit()
	--pendulum summon
	aux.EnablePendulumAttribute(c,false)
	--level change and synchro summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(17060816,0))
	e1:SetCategory(CATEGORY_LVCHANGE+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,17060816)
	e1:SetCondition(c17060816.syncon)
	e1:SetTarget(c17060816.syntg)
	e1:SetOperation(c17060816.synop)
	c:RegisterEffect(e1)
	local e1b=e1:Clone()
	e1b:SetType(EFFECT_TYPE_QUICK_O)
	e1b:SetCode(EVENT_FREE_CHAIN)
	e1b:SetHintTiming(0,0x1e0)
	e1b:SetCondition(c17060816.syncon1)
	c:RegisterEffect(e1b)
	--atk
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(17060816,1))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,17060816+100)
	e2:SetCondition(c17060816.rkcon)
	e2:SetTarget(c17060816.atktg)
	e2:SetOperation(c17060816.atkop)
	c:RegisterEffect(e2)
	--pendulum
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(17060816,2))
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCondition(c17060816.pencon)
	e3:SetTarget(c17060816.pentg)
	e3:SetOperation(c17060816.penop)
	c:RegisterEffect(e3)
end
c17060816.is_named_with_Singer_Arthur=1
c17060816.is_named_with_Million_Arthur=1
function c17060816.IsSinger_Arthur(c)
	local m=_G["c"..c:GetCode()]
	return m and m.is_named_with_Singer_Arthur
end
function c17060816.IsMillion_Arthur(c)
	local m=_G["c"..c:GetCode()]
	return m and m.is_named_with_Million_Arthur
end
function c17060816.filter(c)
	local lv=c:GetLevel()
	return c:IsFaceup() and lv>0 and lv~=2 and c:IsCanBeSynchroMaterial()
end
function c17060816.scfilter2(c,mg)
	return c:IsSynchroSummonable(nil,mg)
end
function c17060816.syncon(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(aux.FilterEqualFunction(Card.GetSummonLocation,LOCATION_EXTRA),tp,0,LOCATION_MZONE,1,nil)
end
function c17060816.syncon1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(aux.FilterEqualFunction(Card.GetSummonLocation,LOCATION_EXTRA),tp,0,LOCATION_MZONE,1,nil)
end
function c17060816.syntg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c17060816.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c17060816.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) 
	and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) 
	and Duel.GetMZoneCount(tp)>0
	and Duel.IsPlayerCanSpecialSummonCount(tp,2) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c17060816.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c17060816.synop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetMZoneCount(tp)<=0 then return end
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) and tc:GetLevel()~=2 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_CHANGE_LEVEL)
		e1:SetValue(2)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetCode(EFFECT_ADD_TYPE)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		e2:SetValue(TYPE_TUNER)
		tc:RegisterEffect(e2)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_SYNCHRO_MATERIAL)
		e3:SetReset(RESET_CHAIN)
		tc:RegisterEffect(e3)
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
			local mg=Group.FromCards(c,tc)
		if Duel.GetLocationCountFromEx(tp,tp,mg)<=0 then return end
			local g=Duel.GetMatchingGroup(c17060816.scfilter2,tp,LOCATION_EXTRA,0,nil,mg)
		if g:GetCount()>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg=g:Select(tp,1,1,nil)
			Duel.SynchroSummon(tp,sg:GetFirst(),nil,mg)
		end
	end
end

function c17060816.filter1(c)
	return c:IsFaceup() and c:IsType(TYPE_PENDULUM)
end
function c17060816.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c17060816.filter1(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c17060816.filter1,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c17060816.filter1,tp,LOCATION_MZONE,0,1,1,nil)
end
function c17060816.filter2(c)
	return c:IsFaceup() and c17060816.IsMillion_Arthur(c)
end
function c17060816.atkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local ct=Duel.GetMatchingGroupCount(c17060816.filter2,tp,LOCATION_ONFIELD,0,nil)
	if ct>0 and tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(ct*300)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
end
function c17060816.pencon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_MZONE) and c:IsFaceup()
end
function c17060816.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_PZONE,0)>0 end
	local g=Duel.GetFieldGroup(tp,LOCATION_PZONE,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c17060816.penop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,LOCATION_PZONE,0)
	if Duel.Destroy(g,REASON_EFFECT)~=0 and e:GetHandler():IsRelateToEffect(e) then
		Duel.MoveToField(e:GetHandler(),tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
end
function c17060816.rkcon(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.GetFieldCard(tp,LOCATION_PZONE,0) or not Duel.GetFieldCard(tp,LOCATION_PZONE,1)
end
function c17060816.rkcon1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldCard(tp,LOCATION_PZONE,0) and Duel.GetFieldCard(tp,LOCATION_PZONE,1)
end