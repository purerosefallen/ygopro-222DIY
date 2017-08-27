--三位一体魔法陣(ザ･トリニティ)
function c114001253.initial_effect(c)
	--atkup
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,114001253+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c114001253.condition)
	e1:SetTarget(c114001253.target)
	e1:SetOperation(c114001253.operation)
	c:RegisterEffect(e1)
end
function c114001253.confilter(c)
	return c:IsFaceup()
		and ( c:IsSetCard(0x223) or c:IsSetCard(0x224) or c:IsSetCard(0xcabb) 
		or c:IsCode(36405256) or c:IsCode(54360049) or c:IsCode(37160778) or c:IsCode(27491571) or c:IsCode(80741828) or c:IsCode(90330453) --0x223
		or c:IsCode(32751480) or c:IsCode(78010363) or c:IsCode(39432962) or c:IsCode(67511500) or c:IsCode(62379337) or c:IsCode(23087070) or c:IsCode(17720747) or c:IsCode(98358303) or c:IsCode(91584698) ) --0x224
end
function c114001253.condition(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(nil,tp,LOCATION_MZONE,0,nil)
	local tg=g:Filter(c114001253.confilter,nil)
	local gc=g:GetCount()
	local tgc=tg:GetCount()
	return Duel.GetCurrentPhase()==PHASE_MAIN1 and gc==3 and tgc==3
end
function c114001253.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(c114001253.confilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c114001253.confilter,tp,LOCATION_MZONE,0,1,1,nil)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_ATTACK)
	e1:SetProperty(EFFECT_FLAG_OATH+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(c114001253.ftarget)
	e1:SetLabel(g:GetFirst():GetFieldID())
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c114001253.ftarget(e,c)
	return e:GetLabel()~=c:GetFieldID()
end
function c114001253.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local atk=0
		local g=Duel.GetMatchingGroup(c114001253.confilter,tp,LOCATION_MZONE,0,tc)
		if g:GetCount()==0 then return end
		local bc=g:GetFirst()
		while bc do
			atk=atk+bc:GetAttack()
			bc=g:GetNext()
		end
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(atk)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_ATTACK_ALL)
		e2:SetValue(1)
		e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
		local e3=Effect.CreateEffect(e:GetHandler())
		e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
		e3:SetCode(EVENT_BATTLED)
		e3:SetOperation(c114001253.negop)
		e3:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e3)
	end
end
function c114001253.negop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	if not bc or not bc:IsStatus(STATUS_BATTLE_DESTROYED) then return end
	local e1=Effect.CreateEffect(e:GetOwner())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DISABLE)
	e1:SetReset(RESET_EVENT+0x17a0000)
	bc:RegisterEffect(e1)
	local e2=Effect.CreateEffect(e:GetOwner())
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_DISABLE_EFFECT)
	e2:SetReset(RESET_EVENT+0x17a0000)
	bc:RegisterEffect(e2)
end
