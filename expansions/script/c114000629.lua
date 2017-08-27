--狼殺し
function c114000629.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c114000629.target)
	e1:SetOperation(c114000629.activate)
	c:RegisterEffect(e1)
end
function c114000629.filter(c,e,tp)
	--must be attack > 0
	return ( c:IsSetCard(0x221) or c:IsCode(114000231) ) and c:IsFaceup() and c:GetAttack()>0
end
function c114000629.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(c114000629.filter,tp,LOCATION_MZONE,0,1,nil) end
	--declare a race
	Duel.Hint(HINT_SELECTMSG,tp,563)
	local rc=Duel.AnnounceRace(tp,1,0xffffff)
	e:SetLabel(rc)
	--selecting monster
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c114000629.filter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,1,0,0)
end
function c114000629.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and c:GetAttack()>0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e1:SetValue(0)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e2)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_DISABLE_EFFECT)
		e3:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e3)
		--destroy condition 
		local rc=e:GetLabel()
		e:GetHandler():SetHint(CHINT_RACE,rc)
		local e4=Effect.CreateEffect(c)
		e4:SetCategory(CATEGORY_DESTROY)
		e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
		e4:SetCode(EVENT_BATTLE_START)
		e4:SetRange(LOCATION_MZONE)
		e4:SetLabel(rc)
		e4:SetLabelObject(tc)
		e4:SetTarget(c114000629.destg)
		e4:SetOperation(c114000629.desop)
		e4:SetReset(RESET_EVENT+0x1fe0000)
		Duel.RegisterEffect(e4,tp)
	end
end
function c114000629.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetLabelObject()
	local tc=Duel.GetAttacker()
	if c~=tc and c~=Duel.GetAttackTarget() then return end
	if tc==c then tc=Duel.GetAttackTarget() end
	if chk==0 then return tc and tc:IsFaceup() and tc:IsRace(e:GetLabel()) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,tc,1,0,0)
end
function c114000629.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetAttacker()
	if tc==c then tc=Duel.GetAttackTarget() end
	if tc:IsRelateToBattle() then Duel.Destroy(tc,REASON_EFFECT) end
end