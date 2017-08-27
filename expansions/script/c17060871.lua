--神装佣兵
function c17060871.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,c17060871.matfilter,2)
	c:EnableReviveLimit()
	--atk
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(17060871,1))
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(c17060871.atkval)
	c:RegisterEffect(e2)
	--cannot be target/battle indestructable
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(17060871,2))
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e3:SetCondition(c17060871.incon)
	e3:SetTarget(c17060871.tgtg)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e4)
	local e5=e3:Clone()
	e5:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e5:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e5:SetValue(aux.tgoval)
	c:RegisterEffect(e5)
	--跳回合
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(17060871,3))
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e6:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e6:SetCode(EVENT_BATTLE_DESTROYING)
	e6:SetCondition(c17060871.incon1)
	e6:SetOperation(c17060871.activate)
	c:RegisterEffect(e6)
	
end
c17060871.is_named_with_God_Equipment=1
c17060871.is_named_with_Mercenary_Arthur=1
c17060871.is_named_with_Million_Arthur=1
function c17060871.God_Equipment(c)
	local m=_G["c"..c:GetCode()]
	return m and m.is_named_with_God_Equipment
end
function c17060871.Mercenary_Arthur(c)
	local m=_G["c"..c:GetCode()]
	return m and m.is_named_with_Mercenary_Arthur
end
function c17060871.IsMillion_Arthur(c)
	local m=_G["c"..c:GetCode()]
	return m and m.is_named_with_Million_Arthur
end
function c17060871.infilter(c)
	return c:IsFaceup() and (c17060871.God_Equipment(c) or c17060871.IsMillion_Arthur(c))
end
function c17060871.incon(e,c,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetLinkedGroup():FilterCount(c17060871.infilter,nil)>=1
end
function c17060871.incon1(e,c,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetLinkedGroup():FilterCount(c17060871.infilter,nil)>=2
end
function c17060871.atkval(e,c)
	return c:GetLinkedGroupCount()*500
end
function c17060871.matfilter(c)
	return not c:IsType(TYPE_TOKEN)
end
function c17060871.pcfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_PENDULUM) and not c:IsForbidden()
end
function c17060871.pccost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler() end
	Duel.Destroy(e:GetHandler(),nil,0,REASON_COST)
end
function c17060871.pccon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(nil,tp,LOCATION_PZONE,0,1,e:GetHandler())
end
function c17060871.pctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c17060871.pcfilter,tp,LOCATION_EXTRA,0,1,nil) end
end
function c17060871.pcop(e,tp,eg,ep,ev,re,r,rp)
	if chkc then return chkc:IsLocation(LOCATION_EXTRA) and chkc:IsControler(tp) and c17060871.pcfilter(chkc) end
		if not Duel.CheckLocation(tp,LOCATION_PZONE,0) and not Duel.CheckLocation(tp,LOCATION_PZONE,1) then return false end
	if not (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectMatchingCard(tp,c17060871.pcfilter,tp,LOCATION_EXTRA,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.MoveToField(g:GetFirst(),tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
end
function c17060871.tgtg(e,c)
	return e:GetHandler():GetLinkedGroup():IsContains(c)
end
function c17060871.activate(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(0,1)
	e1:SetCode(EFFECT_SKIP_DP)
	e1:SetReset(RESET_PHASE+PHASE_DRAW+RESET_OPPO_TURN)
	Duel.RegisterEffect(e1,tp)
end
