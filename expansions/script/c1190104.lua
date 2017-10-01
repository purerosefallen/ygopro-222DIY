--ELF·始源妖精女皇
function c1190104.initial_effect(c)
--
	aux.AddSynchroProcedure(c,c1190104.syfilter1,c1190104.syfilter2,1)
	c:EnableReviveLimit()
--   
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,1190104)
	e1:SetCondition(c1190104.con1)
	e1:SetOperation(c1190104.op1)
	c:RegisterEffect(e1) 
-- 
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_NEGATE)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,1190154)
	e2:SetCode(EVENT_CHAINING)
	e2:SetCondition(c1190104.con2)
	e2:SetTarget(c1190104.tg2)
	e2:SetOperation(c1190104.op2)
	c:RegisterEffect(e2)
end
--
c1190104.named_with_ELF=1
function c1190104.IsELF(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_ELF
end
--
function c1190104.syfilter1(c)
	return c1190104.IsELF(c) and c:IsType(TYPE_TUNER)
end
function c1190104.syfilter2(c)
	return c1190104.IsELF(c) and c:IsType(TYPE_MONSTER)
end
--
function c1190104.con1(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function c1190104.op1(e,tp,eg,ep,ev,re,r,rp)
	Duel.SetLP(1-tp,Duel.GetLP(1-tp)/2) 
end
--
function c1190104.con2(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED)
		and ep~=tp and Duel.IsChainNegatable(ev)
end
function c1190104.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function c1190104.op2(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_CANNOT_ACTIVATE)
	e2:SetTargetRange(0,1)
	e2:SetValue(c1190104.aclimit)
	e2:SetReset(RESET_PHASE+PHASE_END,2)
	Duel.RegisterEffect(e2,tp)
end
function c1190104.aclimit(e,re,tp)
	return (re:IsActiveType(TYPE_SPELL) or re:IsActiveType(TYPE_TRAP)) and not re:GetHandler():IsImmuneToEffect(e)
end
