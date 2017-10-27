--魔瑟
function c17060844.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c,false)
	--synchro summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(17060844,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(aux.SynCondition(nil,aux.NonTuner(c17060844.ntfilter),1,99))
	e1:SetTarget(aux.SynTarget(nil,aux.NonTuner(c17060844.ntfilter),1,99))
	e1:SetOperation(aux.SynOperation(nil,aux.NonTuner(c17060844.ntfilter),1,99))
	e1:SetValue(SUMMON_TYPE_SYNCHRO)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetDescription(aux.Stringid(17060844,1))
	e2:SetCondition(c17060844.syncon)
	e2:SetTarget(c17060844.syntg)
	e2:SetOperation(c17060844.synop)
	e2:SetValue(SUMMON_TYPE_SYNCHRO)
	c:RegisterEffect(e2)
	--disable
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(17060844,2))
	e3:SetCategory(CATEGORY_DISABLE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCountLimit(1,17060844)
	e3:SetRange(LOCATION_PZONE)
	e3:SetCost(c17060844.discost)
	e3:SetTarget(c17060844.distg)
	e3:SetOperation(c17060844.disop)
	c:RegisterEffect(e3)
	--negate+copy
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(17060844,3))
	e3:SetCategory(CATEGORY_DISABLE)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,170608440)
	e3:SetCondition(c17060844.necon)
	e3:SetCost(c17060844.necost)
	e3:SetTarget(c17060844.netg)
	e3:SetOperation(c17060844.neop)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetHintTiming(0,0x1c0)
	e4:SetCondition(c17060844.necon1)
	c:RegisterEffect(e4)
	--cannot be target
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(17060844,4))
	e5:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e5:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetRange(LOCATION_MZONE)
	e5:SetTargetRange(LOCATION_MZONE,0)
	e5:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0xff9f))
	e5:SetValue(aux.tgoval)
	c:RegisterEffect(e5)
	--pendulum
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(17060844,5))
	e6:SetCategory(CATEGORY_DESTROY)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e6:SetCode(EVENT_DESTROYED)
	e6:SetProperty(EFFECT_FLAG_DELAY)
	e6:SetCondition(c17060844.pencon)
	e6:SetTarget(c17060844.pentg)
	e6:SetOperation(c17060844.penop)
	c:RegisterEffect(e6)
end
c17060844.is_named_with_Magic_Factions=1
c17060844.is_named_with_Million_Arthur=1
function c17060844.IsMagic_Factions(c)
	local m=_G["c"..c:GetCode()]
	return m and m.is_named_with_Magic_Factions
end
function c17060844.IsMillion_Arthur(c)
	local m=_G["c"..c:GetCode()]
	return m and m.is_named_with_Million_Arthur
end
function c17060844.ntfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_SYNCHRO) and c:IsRace(RACE_WARRIOR) and c:IsCanBeSynchroMaterial()
end
function c17060844.matfilter1(c,syncard)
	return (c:IsType(TYPE_PENDULUM) and c17060844.IsMillion_Arthur(c)) and c:IsSummonType(SUMMON_TYPE_PENDULUM) and c:IsNotTuner() and c:IsFaceup() and c:IsCanBeSynchroMaterial(syncard)
		and Duel.IsExistingMatchingCard(c17060844.matfilter2,0,LOCATION_MZONE,LOCATION_MZONE,1,c,syncard)
end
function c17060844.matfilter2(c,syncard)
	return c:IsNotTuner() and c:IsFaceup() and c:IsType(TYPE_SYNCHRO) and c:IsRace(RACE_WARRIOR) and c:IsCanBeSynchroMaterial(syncard)
end
function c17060844.synfilter(c,syncard,lv,g2,minc)
	local tlv=c:GetSynchroLevel(syncard)
	if lv-tlv<=0 then return false end
	local g=g2:Clone()
	g:RemoveCard(c)
	return g:CheckWithSumEqual(Card.GetSynchroLevel,lv-tlv,minc-1,63,syncard)
end
function c17060844.syncon(e,c,tuner,mg)
	if c==nil then return true end
	if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then return false end
	local tp=c:GetControler()
	local ct=-Duel.GetMZoneCount(tp)
	local minc=2
	if minc<ct then minc=ct end
	local g1=nil
	local g2=nil
	if mg then
		g1=mg:Filter(c17060844.matfilter1,nil,c)
		g2=mg:Filter(c17060844.matfilter2,nil,c)
	else
		g1=Duel.GetMatchingGroup(c17060844.matfilter1,tp,LOCATION_MZONE,LOCATION_MZONE,nil,c)
		g2=Duel.GetMatchingGroup(c17060844.matfilter2,tp,LOCATION_MZONE,LOCATION_MZONE,nil,c)
	end
	local pe=Duel.IsPlayerAffectedByEffect(tp,EFFECT_MUST_BE_SMATERIAL)
	local lv=c:GetLevel()
	if tuner then
		return c17060844.synfilter(tuner,c,lv,g2,minc)
	end
	if not pe then
		return g1:IsExists(c17060844.synfilter,1,nil,c,lv,g2,minc)
	else
		return c17060844.synfilter(pe:GetOwner(),c,lv,g2,minc)
	end
end
function c17060844.syntg(e,tp,eg,ep,ev,re,r,rp,chk,c,tuner,mg)
	local g=Group.CreateGroup()
	local g1=nil
	local g2=nil
	if mg then
		g1=mg:Filter(c17060844.matfilter1,nil,c)
		g2=mg:Filter(c17060844.matfilter2,nil,c)
	else
		g1=Duel.GetMatchingGroup(c17060844.matfilter1,tp,LOCATION_MZONE,LOCATION_MZONE,nil,c)
		g2=Duel.GetMatchingGroup(c17060844.matfilter2,tp,LOCATION_MZONE,LOCATION_MZONE,nil,c)
	end
	local ct=-Duel.GetMZoneCount(tp)
	local minc=2
	if minc<ct then minc=ct end
	local pe=Duel.IsPlayerAffectedByEffect(tp,EFFECT_MUST_BE_SMATERIAL)
	local lv=c:GetLevel()
	if tuner then
		g:AddCard(tuner)
		g2:RemoveCard(tuner)
		local lv1=tuner:GetSynchroLevel(c)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
		local m2=g2:SelectWithSumEqual(tp,Card.GetSynchroLevel,lv-lv1,minc-1,63,c)
		g:Merge(m2)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
		local tuner=nil
		if not pe then
			local t1=g1:FilterSelect(tp,c17060844.synfilter,1,1,nil,c,lv,g2,minc)
			tuner=t1:GetFirst()
		else
			tuner=pe:GetOwner()
			Group.FromCards(tuner):Select(tp,1,1,nil)
		end
		tuner:RegisterFlagEffect(17060844,RESET_EVENT+0x1fe0000,0,1)
		g:AddCard(tuner)
		g2:RemoveCard(tuner)
		local lv1=tuner:GetSynchroLevel(c)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
		local m2=g2:SelectWithSumEqual(tp,Card.GetSynchroLevel,lv-lv1,minc-1,63,c)
		g:Merge(m2)
	end
	if g then
		g:KeepAlive()
		e:SetLabelObject(g)
		return true
	else return false end
end
function c17060844.synop(e,tp,eg,ep,ev,re,r,rp,c,tuner,mg)
	local g=e:GetLabelObject()
	c:SetMaterial(g)
	Duel.SendtoGrave(g,REASON_MATERIAL+REASON_SYNCHRO)
	g:DeleteGroup()
end
function c17060844.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToExtraAsCost() end
	Duel.SendtoDeck(e:GetHandler(),nil,0,REASON_COST)
end
function c17060844.disfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_EFFECT) and not c:IsDisabled()
end
function c17060844.distg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c17060844.disfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c17060844.disfilter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c17060844.disfilter,tp,0,LOCATION_MZONE,1,1,nil)
end
function c17060844.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and not tc:IsDisabled() and tc:IsControler(1-tp) then
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
	end
end
function c17060844.copyfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_EFFECT) and not c:IsDisabled()
end
function c17060844.necost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetFlagEffect(17060844)==0 end
	e:GetHandler():RegisterFlagEffect(17060844,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
end
function c17060844.netg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c17060844.copyfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c17060844.copyfilter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c17060844.copyfilter,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetChainLimit(c17060844.limit(g:GetFirst()))
end
function c17060844.limit(c)
	return	function (e,lp,tp)
				return e:GetHandler()~=c
			end
end
function c17060844.neop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local code=tc:GetOriginalCodeRule()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_CHANGE_CODE)
		e1:SetValue(code)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE)
		e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_DISABLE_EFFECT)
		e3:SetValue(RESET_TURN_SET)
		e3:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e3)
		if not tc:IsType(TYPE_TRAPMONSTER) then
		local code=tc:GetOriginalCode()
			c:CopyEffect(code,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,1)
		end
	end
end
function c17060844.necon(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.GetFieldCard(tp,LOCATION_PZONE,0) or not Duel.GetFieldCard(tp,LOCATION_PZONE,1)
end
function c17060844.necon1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldCard(tp,LOCATION_PZONE,0) and Duel.GetFieldCard(tp,LOCATION_PZONE,1)
end
function c17060844.pencon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return bit.band(r,REASON_EFFECT+REASON_BATTLE)~=0 and c:IsPreviousLocation(LOCATION_MZONE) and c:IsFaceup()
end
function c17060844.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
	local lsc=Duel.GetFieldCard(tp,LOCATION_PZONE,0)
	local rsc=Duel.GetFieldCard(tp,LOCATION_PZONE,1)
	local g=Group.FromCards(lsc,rsc):Filter(aux.TRUE,nil)
	if chk==0 then return g:GetCount()>0 end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c17060844.penop(e,tp,eg,ep,ev,re,r,rp)
	local lsc=Duel.GetFieldCard(tp,LOCATION_PZONE,0)
	local rsc=Duel.GetFieldCard(tp,LOCATION_PZONE,1)
	local g=Group.FromCards(lsc,rsc)
	if Duel.Destroy(g,REASON_EFFECT)~=0 and e:GetHandler():IsRelateToEffect(e) then
		Duel.MoveToField(e:GetHandler(),tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
end