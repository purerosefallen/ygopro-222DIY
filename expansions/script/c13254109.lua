--魔玉杖·贯穿束
function c13254109.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(TIMING_DAMAGE_STEP)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCountLimit(1,13254109)
	e1:SetCondition(c13254109.condition)
	e1:SetTarget(c13254109.target)
	e1:SetOperation(c13254109.operation)
	c:RegisterEffect(e1)
	--Equip limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_EQUIP_LIMIT)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetValue(c13254109.eqlimit)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCountLimit(1,13254109)
	e3:SetCondition(c13254109.condition2)
	e3:SetTarget(c13254109.target2)
	e3:SetOperation(c13254109.activate2)
	c:RegisterEffect(e3)
	
end
function c13254109.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()~=PHASE_DAMAGE or not Duel.IsDamageCalculated()
end
function c13254109.filter(c)
	return c:IsFaceup() and c:IsRace(RACE_FAIRY) and c:IsLevelBelow(1)
end
function c13254109.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c13254109.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c13254109.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectTarget(tp,c13254109.filter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function c13254109.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsLocation(LOCATION_SZONE) then return end
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Equip(tp,c,tc)
		c:CancelToGrave()
	end
	if Duel.SelectYesNo(tp,aux.Stringid(13254109,0)) then
		local seq=c:GetSequence()
		local g=Group.CreateGroup()
		local tc=Duel.GetFieldCard(1-tp,LOCATION_MZONE,4-seq)
		if tc then g:AddCard(tc) end
		tc=Duel.GetFieldCard(1-tp,LOCATION_SZONE,4-seq)
		if tc then g:AddCard(tc) end
		if seq==1 then
			tc=Duel.GetFieldCard(1-tp,LOCATION_MZONE,6)
		elseif seq==3 then
			tc=Duel.GetFieldCard(1-tp,LOCATION_MZONE,5)
		end
		if tc and tc:IsControler(1-tp) then g:AddCard(tc) end
		Duel.BreakEffect()
		Duel.Destroy(g,REASON_EFFECT)
	end
end
function c13254109.eqlimit(e,c)
	return c:IsRace(RACE_FAIRY) and c:IsLevelBelow(1)
end
function c13254109.condition2(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetHandler():GetEquipTarget()
	return tc and Duel.GetCurrentChain()<1
end
function c13254109.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return true end
	local seq=e:GetHandler():GetSequence()
	local g=Group.CreateGroup()
	local tc=Duel.GetFieldCard(1-tp,LOCATION_MZONE,4-seq)
	if tc then g:AddCard(tc) end
	tc=Duel.GetFieldCard(1-tp,LOCATION_SZONE,4-seq)
	if tc then g:AddCard(tc) end
	if seq==1 then
		tc=Duel.GetFieldCard(1-tp,LOCATION_MZONE,6)
	elseif seq==3 then
		tc=Duel.GetFieldCard(1-tp,LOCATION_MZONE,5)
	end
	if tc and tc:IsControler(1-tp) then g:AddCard(tc) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c13254109.activate2(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local seq=e:GetHandler():GetSequence()
	local g=Group.CreateGroup()
	local tc=Duel.GetFieldCard(1-tp,LOCATION_MZONE,4-seq)
	if tc then g:AddCard(tc) end
	tc=Duel.GetFieldCard(1-tp,LOCATION_SZONE,4-seq)
	if tc then g:AddCard(tc) end
	if seq==1 then
		tc=Duel.GetFieldCard(1-tp,LOCATION_MZONE,6)
	elseif seq==3 then
		tc=Duel.GetFieldCard(1-tp,LOCATION_MZONE,5)
	end
	if tc and tc:IsControler(1-tp) then g:AddCard(tc) end
	Duel.Destroy(g,REASON_EFFECT)
end
