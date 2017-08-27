--火玉杖·炎爆球
function c13254110.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(TIMING_DAMAGE_STEP)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCountLimit(1,13254110)
	e1:SetCondition(c13254110.condition)
	e1:SetTarget(c13254110.target)
	e1:SetOperation(c13254110.operation)
	c:RegisterEffect(e1)
	--Equip limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_EQUIP_LIMIT)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetValue(c13254110.eqlimit)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCountLimit(1,13254110)
	e3:SetCondition(c13254110.condition2)
	e3:SetTarget(c13254110.target2)
	e3:SetOperation(c13254110.activate2)
	c:RegisterEffect(e3)
	
end
function c13254110.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()~=PHASE_DAMAGE or not Duel.IsDamageCalculated()
end
function c13254110.filter(c)
	return c:IsFaceup() and c:IsRace(RACE_FAIRY) and c:IsLevelBelow(1)
end
function c13254110.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c13254110.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c13254110.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectTarget(tp,c13254110.filter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function c13254110.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsLocation(LOCATION_SZONE) then return end
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Equip(tp,c,tc)
		c:CancelToGrave()
	end
	local i=0
	local seq=0
	local sg=Group.CreateGroup()
	local des=1
	if Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0 or Duel.GetLocationCount(1-tp,LOCATION_SZONE)>0 then i=i+1 end
	if Duel.GetMatchingGroupCount(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)>0 then i=i+2 end
	if i~=0 and Duel.SelectYesNo(tp,aux.Stringid(13254110,0)) then
		Duel.BreakEffect()
		if i==1 then
			seq=Duel.SelectDisableField(tp,1,0,LOCATION_ONFIELD,0)
		elseif i==2 then
			sg=Duel.SelectMatchingCard(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,1,nil)
		else
			i=Duel.SelectOption(tp,aux.Stringid(13254110,1),aux.Stringid(13254110,2))
			if i==0 then
				sg=Duel.SelectMatchingCard(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,1,nil)
			else
				seq=Duel.SelectDisableField(tp,1,0,LOCATION_ONFIELD,0)
			end
		end
		if sg:GetCount()>0 then
			local tc=sg:GetFirst()
			seq=tc:GetSequence()
			seq=seq+16
			if tc:IsLocation(LOCATION_SZONE) then
				seq=bit.lshift(0x100,seq)
			else
				seq=bit.lshift(0x1,seq)
			end
			if Duel.Destroy(tc,REASON_EFFECT)==1 then des=1 else des=0 end
		end
		if des==1 then
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_FIELD)
			e3:SetCode(EFFECT_DISABLE_FIELD)
			e3:SetOperation(function (e,tp)
				return seq end
			)
			if Duel.GetTurnPlayer()==tp and Duel.GetCurrentPhase()==PHASE_END then
				e3:SetReset(RESET_PHASE+PHASE_END+RESET_SELF_TURN,2)
			else
				e3:SetReset(RESET_PHASE+PHASE_END+RESET_SELF_TURN)
			end
			Duel.RegisterEffect(e3,tp)
		end
	end
end
function c13254110.eqlimit(e,c)
	return c:IsRace(RACE_FAIRY) and c:IsLevelBelow(1)
end
function c13254110.condition2(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetHandler():GetEquipTarget()
	return tc
end
function c13254110.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(1-tp,LOCATION_MZONE) or Duel.GetLocationCount(1-tp,LOCATION_SZONE) end
	local seq=Duel.SelectDisableField(tp,1,0,LOCATION_ONFIELD,0)
	e:SetLabel(seq)
end
function c13254110.activate2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local seq=e:GetLabel()
	local des=1
	local tc=Duel.GetFieldCard(tp,LOCATION_ONFIELD,seq)
	if tc then
		if Duel.Destroy(tc,REASON_EFFECT)==1 then des=1 else des=0 end
	end
	if des==1 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_DISABLE_FIELD)
		e1:SetOperation(function (e,tp)
		return seq end
		)
		if Duel.GetTurnPlayer()==tp and Duel.GetCurrentPhase()==PHASE_END then
			e1:SetReset(RESET_PHASE+PHASE_END+RESET_SELF_TURN,2)
			e1:SetValue(Duel.GetTurnCount())
		else
			e1:SetReset(RESET_PHASE+PHASE_END+RESET_SELF_TURN)
			e1:SetValue(0)
		end
		Duel.RegisterEffect(e1,tp)
	end
end
