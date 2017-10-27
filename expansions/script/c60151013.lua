--魔与人之间 晓美焰
function c60151013.initial_effect(c)
	c:EnableReviveLimit()
	--spsummon condition
	local e11=Effect.CreateEffect(c)
	e11:SetType(EFFECT_TYPE_SINGLE)
	e11:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e11:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e11)
	--special summon rule
	local e12=Effect.CreateEffect(c)
	e12:SetType(EFFECT_TYPE_FIELD)
	e12:SetCode(EFFECT_SPSUMMON_PROC)
	e12:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e12:SetRange(LOCATION_EXTRA)
	e12:SetCondition(c60151013.spcon)
	e12:SetOperation(c60151013.spop)
	c:RegisterEffect(e12)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetCondition(c60151013.condtion)
	e1:SetValue(500)
	c:RegisterEffect(e1)
	--
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(60151013,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_BATTLE_DESTROYING)
	e3:SetTarget(c60151013.thtg)
	e3:SetOperation(c60151013.thop)
	c:RegisterEffect(e3)
	--cannot be target
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetCondition(c60151013.atkcon)
	e2:SetValue(aux.tgval)
	c:RegisterEffect(e2)
	local e4=e2:Clone()
	e4:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
	e4:SetValue(aux.imval1)
	c:RegisterEffect(e4)
end
function c60151013.condtion(e)
	local ph=Duel.GetCurrentPhase()
	return (ph==PHASE_DAMAGE or ph==PHASE_DAMAGE_CAL)
		and Duel.GetAttackTarget()~=nil
end
function c60151013.spfilter1(c,tp)
	return c:IsRace(RACE_SPELLCASTER) and c:IsSetCard(0x5b23) and c:IsCanBeFusionMaterial()
		and Duel.CheckReleaseGroup(tp,c60151013.spfilter2,1,c)
end
function c60151013.spfilter2(c)
	return c:IsType(TYPE_XYZ) and c:IsSetCard(0x5b23) and c:IsCanBeFusionMaterial()
end
function c60151013.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetMZoneCount(tp)>-2
		and Duel.CheckReleaseGroup(tp,c60151013.spfilter1,1,nil,tp)
end
function c60151013.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(60151016,2))
	local g1=Duel.SelectMatchingCard(tp,c60151013.spfilter1,tp,LOCATION_MZONE,0,1,1,nil,tp)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(60151016,3))
	local g2=Duel.SelectMatchingCard(tp,c60151013.spfilter2,tp,LOCATION_MZONE,0,1,1,nil,tp)
	g1:Merge(g2)
	c:SetMaterial(g1)
	Duel.Release(g1,REASON_COST)
end
function c60151013.discon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) 
		and (re:IsHasType(EFFECT_TYPE_ACTIVATE) or re:IsActiveType(TYPE_MONSTER))
		and re:GetHandler()~=e:GetHandler()
end
function c60151013.chlimit(e,ep,tp)
	return tp==ep
end
function c60151013.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetChainLimit(c60151013.chlimit)
end
function c60151013.disop(e,tp,eg,ep,ev,re,r,rp)
	
end
function c60151013.thcon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp
end
function c60151013.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMZoneCount(tp)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,60151014,0,0x4011,-2,-2,6,RACE_FIEND,ATTRIBUTE_DARK) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c60151013.thop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetMZoneCount(tp)<=0 then return end
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	local atk=bc:GetAttack()
	local def=bc:GetDefense()
	if not Duel.IsPlayerCanSpecialSummonMonster(tp,60151014,0,0x4011,-2,-2,6,RACE_FIEND,ATTRIBUTE_DARK) then return end
	local token=Duel.CreateToken(tp,60151014)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SET_ATTACK)
	e1:SetValue(atk)
	e1:SetReset(RESET_EVENT+0xfe0000)
	token:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_SET_DEFENSE)
	e2:SetValue(def)
	e2:SetReset(RESET_EVENT+0xfe0000)
	token:RegisterEffect(e2)
	Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
	Duel.SpecialSummonComplete()
end
function c60151013.atkcon(e)
	return Duel.IsExistingMatchingCard(Card.IsCode,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil,60151014)
end