--传说中的口袋妖怪 闪电鸟
function c80000322.initial_effect(c)
	if c:IsStatus(STATUS_COPYING_EFFECT) then return end
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,c80000322.ffilter,5,true)  
	--act limit
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(80000322,0))
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_BATTLE_DAMAGE)
	e1:SetCondition(c80000322.condition)
	e1:SetTarget(c80000322.target)
	e1:SetOperation(c80000322.operation)
	c:RegisterEffect(e1)
	--Activate
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetCountLimit(1)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c80000322.condition1)
	e2:SetTarget(c80000322.target1)
	e2:SetOperation(c80000322.activate1)
	c:RegisterEffect(e2)
	--wudi 
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE)
	e8:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e8:SetRange(LOCATION_MZONE)
	e8:SetCode(EFFECT_IMMUNE_EFFECT)
	e8:SetValue(c80000322.efilter)
	c:RegisterEffect(e8)  
	--spsummon limit
	local e9=Effect.CreateEffect(c)
	e9:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e9:SetType(EFFECT_TYPE_SINGLE)
	e9:SetCode(EFFECT_SPSUMMON_CONDITION)
	e9:SetValue(c80000322.splimit)
	c:RegisterEffect(e9)   
end
function c80000322.splimit(e,se,sp,st)
	return bit.band(st,SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION 
end
function c80000322.condition(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp
end
function c80000322.ffilter(c)
	return  c:IsSetCard(0x2d0) and c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsRace(RACE_WINDBEAST)
end
function c80000322.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end
function c80000322.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(80000322,1))
	e:SetLabel(Duel.SelectOption(tp,70,71,72))
end
function c80000322.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetTargetRange(0,1)
	if e:GetLabel()==0 then
		e1:SetValue(c80000322.aclimit1)
	elseif e:GetLabel()==1 then
		e1:SetValue(c80000322.aclimit2)
	else e1:SetValue(c80000322.aclimit3) end
	e1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN,1)
	Duel.RegisterEffect(e1,tp)
end
function c80000322.aclimit1(e,re,tp)
	return re:IsActiveType(TYPE_MONSTER) and not re:GetHandler():IsImmuneToEffect(e)
end
function c80000322.aclimit2(e,re,tp)
	return re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:IsActiveType(TYPE_SPELL) and not re:GetHandler():IsImmuneToEffect(e)
end
function c80000322.aclimit3(e,re,tp)
	return re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:IsActiveType(TYPE_TRAP) and not re:GetHandler():IsImmuneToEffect(e)
end
function c80000322.condition1(e,tp,eg,ep,ev,re,r,rp)
	return (re:IsActiveType(TYPE_MONSTER) or re:IsHasType(EFFECT_TYPE_ACTIVATE)) and re:IsHasProperty(EFFECT_FLAG_PLAYER_TARGET)
end
function c80000322.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local te=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_EFFECT)
		local ftg=te:GetTarget()
		return ftg==nil or ftg(e,tp,eg,ep,ev,re,r,rp,chk)
	end
end
function c80000322.activate1(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(ev,CHAININFO_TARGET_PLAYER)
	Duel.ChangeTargetPlayer(ev,1-p)
end