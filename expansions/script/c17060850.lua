--
function c17060850.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,c17060850.matfilter,2)
	c:EnableReviveLimit()
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(17060850,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1)
	e1:SetTarget(c17060850.thtg)
	e1:SetOperation(c17060850.thop)
	c:RegisterEffect(e1)
	--atk
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(17060850,1))
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c17060850.atkcon)
	e2:SetOperation(c17060850.atkop)
	c:RegisterEffect(e2)
end
c17060850.is_named_with_Singer_Arthur=1
c17060850.is_named_with_Million_Arthur=1
function c17060850.IsSinger_Arthur(c)
	local m=_G["c"..c:GetCode()]
	return m and m.is_named_with_Singer_Arthur
end
function c17060850.IsMillion_Arthur(c)
	local m=_G["c"..c:GetCode()]
	return m and m.is_named_with_Million_Arthur
end
function c17060850.matfilter(c)
	return c17060850.IsMillion_Arthur(c)
end
function c17060850.filter(c,e,tp)
	return c:IsType(TYPE_PENDULUM)
end
function c17060850.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_PZONE) and chkc:IsControler(tp) and c17060850.filter(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(c17060850.filter,tp,LOCATION_PZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c17060850.filter,tp,LOCATION_PZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c17060850.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and not c:IsRelateToEffect(e) then return end
	if Duel.SendtoHand(tc,nil,REASON_EFFECT)==0 then
		return
	end
	local p=c:GetControler()
	local zone=bit.band(c:GetLinkedZone(),0x1f)
	if Duel.GetLocationCount(p,LOCATION_MZONE,p,LOCATION_REASON_CONTROL,zone)>0
		and Duel.SelectYesNo(tp,aux.Stringid(17060850,2)) then
		Duel.BreakEffect()
		local s=0
		if c:IsControler(tp) then
			local flag=bit.bxor(zone,0xff)
			Duel.Hint(HINT_SELECTMSG,tp,571)
			s=Duel.SelectDisableField(tp,1,LOCATION_MZONE,0,flag)
		else
			local flag=bit.bxor(zone,0xff)*0x10000
			Duel.Hint(HINT_SELECTMSG,tp,571)
			s=Duel.SelectDisableField(tp,1,0,LOCATION_MZONE,flag)/0x10000
		end
		local nseq=0
		if s==1 then nseq=0
		elseif s==2 then nseq=1
		elseif s==4 then nseq=2
		elseif s==8 then nseq=3
		else nseq=4 end
		Duel.MoveSequence(c,nseq)
	end
end
function c17060850.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local at=Duel.GetAttacker()
	return e:GetHandler():GetLinkedGroup():IsContains(at)
end
function c17060850.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local at=Duel.GetAttacker()
	if at:IsFaceup() and at:IsRelateToBattle() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(800)
		e1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
		at:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_PRE_BATTLE_DAMAGE)
		e2:SetCondition(c17060850.damcon)
		e2:SetOperation(c17060850.damop)
		e2:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
		at:RegisterEffect(e2)
	end
end
function c17060850.damcon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp and e:GetHandler():GetLinkedGroup()~=nil
end
function c17060850.damop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ChangeBattleDamage(ep,ev*2)
end