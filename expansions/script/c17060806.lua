--技瑟
function c17060806.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,c17060806.ffilter,aux.FilterBoolFunction(Card.IsRace,RACE_WARRIOR),false)
	--pendulum summon
	aux.EnablePendulumAttribute(c,false)
	--pendulum set
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(17060806,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1)
	e1:SetCost(c17060806.pccon)
	e1:SetTarget(c17060806.pctg)
	e1:SetOperation(c17060806.pcop)
	c:RegisterEffect(e1)
	--REMOVE
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(17060806,1))
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c17060806.rmcon)
	e2:SetTarget(c17060806.rmtg)
	e2:SetOperation(c17060806.rmop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_MATERIAL_CHECK)
	e3:SetValue(c17060806.valcheck)
	e3:SetLabelObject(e2)
	c:RegisterEffect(e3)
	--pendulum
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(17060806,2))
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_DESTROYED)
	e4:SetCondition(c17060806.pencon)
	e4:SetTarget(c17060806.pentg)
	e4:SetOperation(c17060806.penop)
	c:RegisterEffect(e4)
	--Banish
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(17060806,3))
	e5:SetCategory(CATEGORY_REMOVE)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1)
	e5:SetCondition(c17060806.rmcon)
	e5:SetTarget(c17060806.rmtg)
	e5:SetOperation(c17060806.rmop)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetType(EFFECT_TYPE_QUICK_O)
	e6:SetCode(EVENT_FREE_CHAIN)
	e6:SetCondition(c17060806.rmcon1)
	c:RegisterEffect(e6)
end
c17060806.is_named_with_Skill_Field=1
c17060806.is_named_with_Million_Arthur=1
function c17060806.IsSkill_Field(c)
	local m=_G["c"..c:GetCode()]
	return m and m.is_named_with_Skill_Field
end
function c17060806.IsMillion_Arthur(c)
	local m=_G["c"..c:GetCode()]
	return m and m.is_named_with_Million_Arthur
end
function c17060806.ffilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsLocation(LOCATION_MZONE) and not c:IsType(TYPE_TOKEN)
end
function c17060806.pccon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(nil,tp,LOCATION_PZONE,0,1,e:GetHandler())
end
function c17060806.pcfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_PENDULUM) and not c:IsForbidden()
end
function c17060806.pctg(e,tp,eg,ep,ev,re,r,rp,chk)
	local sc=Duel.GetFirstMatchingCard(nil,tp,LOCATION_PZONE,0,e:GetHandler())
	if chk==0 then return Duel.IsExistingMatchingCard(c17060806.pcfilter,tp,LOCATION_EXTRA,0,1,nil) end
	Duel.SetTargetCard(sc)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sc,1,0,0)
end
function c17060806.pcop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
		local g=Duel.SelectMatchingCard(tp,c17060806.pcfilter,tp,LOCATION_EXTRA,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.MoveToField(g:GetFirst(),tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		end
	end
end
function c17060806.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION) and e:GetLabel()==1
end
function c17060806.rmfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToRemove()
end
function c17060806.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c17060806.rmfilter,tp,0,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(c17060806.rmfilter,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
	Duel.SetChainLimit(c17060806.chainlm)
end
function c17060806.rmop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c17060806.rmfilter,tp,0,LOCATION_ONFIELD,nil)
	if g:GetCount()>0 then
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	end
end
function c17060806.chainlm(e,rp,tp)
	return tp==rp
end
function c17060806.valcheck(e,c)
	local g=c:GetMaterial()
	if g:IsExists(Card.IsType,1,nil,TYPE_FUSION) then
		e:GetLabelObject():SetLabel(1)
	else
		e:GetLabelObject():SetLabel(0)
	end
end
function c17060806.pencon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_MZONE) and c:IsFaceup()
end
function c17060806.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1) end
end
function c17060806.penop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.CheckLocation(tp,LOCATION_PZONE,0) and not Duel.CheckLocation(tp,LOCATION_PZONE,1) then return false end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
end
function c17060806.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.GetFieldCard(tp,LOCATION_PZONE,0) or not Duel.GetFieldCard(tp,LOCATION_PZONE,1)
end
function c17060806.rmcon1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldCard(tp,LOCATION_PZONE,0) and Duel.GetFieldCard(tp,LOCATION_PZONE,1)
end
function c17060806.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsAbleToRemove() end
	if chk==0 then return e:GetHandler():IsAbleToRemove()
		and Duel.IsExistingTarget(Card.IsAbleToRemove,tp,LOCATION_MZONE,LOCATION_MZONE,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,Card.IsAbleToRemove,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,e:GetHandler())
	g:AddCard(e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,2,0,0)
end
function c17060806.rmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not c:IsRelateToEffect(e) or not tc:IsRelateToEffect(e) then return end
	local g=Group.FromCards(c,tc)
	if Duel.Remove(g,0,REASON_EFFECT+REASON_TEMPORARY)~=0 then
		local og=Duel.GetOperatedGroup()
		local oc=og:GetFirst()
		while oc do
			if oc:IsControler(tp) then
				oc:RegisterFlagEffect(17060806,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN,0,1)
			else
				oc:RegisterFlagEffect(17060806,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_STANDBY+RESET_OPPO_TURN,0,1)
			end
			oc=og:GetNext()
		end
		og:KeepAlive()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
		e1:SetReset(RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN)
		e1:SetCountLimit(1)
		e1:SetLabelObject(og)
		e1:SetCondition(c17060806.retcon)
		e1:SetOperation(c17060806.retop)
		Duel.RegisterEffect(e1,tp)
	end
end
function c17060806.retfilter(c)
	return c:GetFlagEffect(17060806)~=0
end
function c17060806.retcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c17060806.retop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	local sg=g:Filter(c17060806.retfilter,nil)
	if sg:GetCount()>1 and sg:GetClassCount(Card.GetPreviousControler)==1 then
		local ft=Duel.GetMZoneCount(sg:GetFirst():GetPreviousControler())
		if ft==1 then
			Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(17060806,0))
			local tc=sg:Select(tp,1,1,nil):GetFirst()
			Duel.ReturnToField(tc)
			sg:RemoveCard(tc)
		end
	end
	local tc=sg:GetFirst()
	while tc do
		Duel.ReturnToField(tc)
		tc=sg:GetNext()
	end
end