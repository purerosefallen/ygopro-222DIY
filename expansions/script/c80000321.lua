--传说中的口袋妖怪 火焰鸟
function c80000321.initial_effect(c)
	if c:IsStatus(STATUS_COPYING_EFFECT) then return end
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,c80000321.ffilter,5,true)
	--atkup
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(c80000321.atktg)
	e1:SetOperation(c80000321.atkop)
	c:RegisterEffect(e1)
	--damage
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(80000321,0))
	e2:SetCategory(CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EVENT_BATTLE_DAMAGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c80000321.con)
	e2:SetTarget(c80000321.tg)
	e2:SetOperation(c80000321.op)
	c:RegisterEffect(e2)
	--wudi 
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE)
	e8:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e8:SetRange(LOCATION_MZONE)
	e8:SetCode(EFFECT_IMMUNE_EFFECT)
	e8:SetValue(c80000321.efilter)
	c:RegisterEffect(e8)	 
	--spsummon limit
	local e9=Effect.CreateEffect(c)
	e9:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e9:SetType(EFFECT_TYPE_SINGLE)
	e9:SetCode(EFFECT_SPSUMMON_CONDITION)
	e9:SetValue(c80000321.splimit)
	c:RegisterEffect(e9)   
end
function c80000321.splimit(e,se,sp,st)
	return bit.band(st,SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION 
end
function c80000321.ftarget(e,c)
	return e:GetLabel()~=c:GetFieldID()
end
function c80000321.atkfilter(c)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_FIRE) and not c:IsCode(80000321)
end
function c80000321.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c80000321.atkfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_ATTACK)
	e1:SetProperty(EFFECT_FLAG_OATH)
	e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e1:SetTarget(c80000321.ftarget)
	e1:SetLabel(e:GetHandler():GetFieldID())
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c80000321.atkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetHandler()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local atk=0
		local g=Duel.GetMatchingGroup(c80000321.atkfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
		local bc=g:GetFirst()
		while bc do
			atk=atk+bc:GetAttack()
			bc=g:GetNext()
		end
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		e1:SetValue(atk)
		tc:RegisterEffect(e1)
	end
end
function c80000321.ffilter(c)
	return  c:IsSetCard(0x2d0) and c:IsAttribute(ATTRIBUTE_FIRE) and c:IsRace(RACE_WINDBEAST)
end
function c80000321.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end
function c80000321.con(e,tp,eg,ep,ev,re,r,rp)
	return ep==1-tp
end
function c80000321.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(800)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,800)
end
function c80000321.op(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end