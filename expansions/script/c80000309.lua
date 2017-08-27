--口袋妖怪 烈箭鹟
function c80000309.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,c80000309.ffilter,c80000309.ffilter1,false)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c80000309.splimit)
	c:RegisterEffect(e1) 
	--direct attack
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_DIRECT_ATTACK)
	c:RegisterEffect(e2)
	--damage reduce
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_PRE_BATTLE_DAMAGE)
	e3:SetCondition(c80000309.rdcon)
	e3:SetOperation(c80000309.rdop)
	c:RegisterEffect(e3) 
	--actlimit
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_ATTACK_ANNOUNCE)
	e4:SetOperation(c80000309.atkop)
	c:RegisterEffect(e4)  
	--special summon rule
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_SPSUMMON_PROC)
	e5:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e5:SetRange(LOCATION_EXTRA)
	e5:SetCondition(c80000309.spcon)
	e5:SetOperation(c80000309.spop)
	c:RegisterEffect(e5) 
	--destroy
	local e6=Effect.CreateEffect(c)
	e6:SetCategory(CATEGORY_DESTROY)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e6:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e6:SetCode(EVENT_BATTLE_DAMAGE)
	e6:SetCondition(c80000309.descon)
	e6:SetTarget(c80000309.destg1)
	e6:SetOperation(c80000309.desop1)
	c:RegisterEffect(e6)
end
function c80000309.rdcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return ep~=tp and Duel.GetAttackTarget()==nil
		and c:GetEffectCount(EFFECT_DIRECT_ATTACK)<2 and Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)>0
end
function c80000309.rdop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ChangeBattleDamage(ep,ev/2)
end
function c80000309.atkop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetTargetRange(0,1)
	e1:SetValue(c80000309.aclimit)
	e1:SetReset(RESET_PHASE+PHASE_DAMAGE)
	Duel.RegisterEffect(e1,tp)
end
function c80000309.aclimit(e,re,tp)
	return re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function c80000309.ffilter(c)
	return c:IsAttribute(ATTRIBUTE_FIRE) and c:IsSetCard(0x2d0)
end
function c80000309.ffilter1(c)
	return c:IsRace(RACE_WINDBEAST) and c:IsSetCard(0x2d0)
end
function c80000309.splimit(e,se,sp,st)
	return bit.band(st,SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION
end
function c80000309.spfilter1(c,tp)
	return c:IsAttribute(ATTRIBUTE_FIRE) and c:IsSetCard(0x2d0) and c:IsCanBeFusionMaterial()
		and Duel.CheckReleaseGroup(tp,c80000309.spfilter2,1,c)
end
function c80000309.spfilter2(c)
	return c:IsRace(RACE_WINDBEAST) and c:IsSetCard(0x2d0)
end
function c80000309.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>-2
		and Duel.CheckReleaseGroup(tp,c80000309.spfilter1,1,nil,tp)
end
function c80000309.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g1=Duel.SelectReleaseGroup(tp,c80000309.spfilter1,1,1,nil,tp)
	local g2=Duel.SelectReleaseGroup(tp,c80000309.spfilter2,1,1,g1:GetFirst())
	g1:Merge(g2)
	c:SetMaterial(g1)
	Duel.Release(g1,REASON_COST+REASON_FUSION+REASON_MATERIAL)
end
function c80000309.descon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp
end
function c80000309.destg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_MZONE) and chkc:IsDestructable() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsDestructable,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,Card.IsDestructable,tp,0,LOCATION_MZONE,1,1,nil)
	local d=g:GetFirst()
	local atk=0
	if d:IsFaceup() then atk=d:GetAttack() end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,atk/2)
end
function c80000309.desop1(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		local atk=0
		if tc:IsFaceup() then atk=tc:GetAttack() end
		if Duel.Destroy(tc,REASON_EFFECT)==0 then return end
		Duel.Damage(1-tp,atk/2,REASON_EFFECT)
	end
end