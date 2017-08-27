--口袋妖怪 龙王蝎
function c80000346.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	c:SetUniqueOnField(1,1,80000346)
	aux.AddFusionProcFun2(c,c80000346.ffilter,c80000346.ffilter1,false)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c80000346.splimit)
	c:RegisterEffect(e1)
	--special summon rule
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_SPSUMMON_PROC)
	e5:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e5:SetRange(LOCATION_EXTRA)
	e5:SetCondition(c80000346.spcon)
	e5:SetOperation(c80000346.spop)
	c:RegisterEffect(e5)
	--damage
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(80000346,0))
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCategory(CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_BATTLE_DAMAGE)
	e2:SetCondition(c80000346.condition)
	e2:SetTarget(c80000346.target)
	e2:SetOperation(c80000346.operation)
	c:RegisterEffect(e2)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_BATTLE_DESTROYING)
	e3:SetCondition(aux.bdocon)
	e3:SetTarget(c80000346.sptg)
	e3:SetOperation(c80000346.spop1)
	c:RegisterEffect(e3)
	--immune spell
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_IMMUNE_EFFECT)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetValue(c80000346.efilter)
	c:RegisterEffect(e4)
end
function c80000346.efilter(e,te)
	return te:IsActiveType(TYPE_SPELL) and te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end
function c80000346.ffilter(c)
	return c:IsAttribute(ATTRIBUTE_DARK) and c:IsSetCard(0x2d0)
end
function c80000346.ffilter1(c)
	return c:IsRace(RACE_INSECT) and c:IsSetCard(0x2d0) and c:IsLevelAbove(4)
end
function c80000346.splimit(e,se,sp,st)
	return bit.band(st,SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION
end
function c80000346.spfilter1(c,tp)
	return c:IsAttribute(ATTRIBUTE_DARK) and c:IsSetCard(0x2d0) and c:IsCanBeFusionMaterial()
		and Duel.CheckReleaseGroup(tp,c80000346.spfilter2,1,c)
end
function c80000346.spfilter2(c)
	return c:IsRace(RACE_INSECT) and c:IsSetCard(0x2d0) and c:IsLevelAbove(4)
end
function c80000346.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>-2
		and Duel.CheckReleaseGroup(tp,c80000346.spfilter1,1,nil,tp,c)
end
function c80000346.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g1=Duel.SelectReleaseGroup(tp,c80000346.spfilter1,1,1,nil,tp,c)
	local g2=Duel.SelectReleaseGroup(tp,c80000346.spfilter2,1,1,g1:GetFirst(),c)
	g1:Merge(g2)
	c:SetMaterial(g1)
	Duel.Release(g1,REASON_COST+REASON_FUSION+REASON_MATERIAL)
end
function c80000346.filter(c)
	return c:IsFaceup() and c:IsRace(RACE_INSECT)
end
function c80000346.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local ct=Duel.GetMatchingGroupCount(c80000346.filter,tp,LOCATION_MZONE,0,nil)
	Duel.SetTargetPlayer(1-tp)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,ct*300)
end
function c80000346.operation(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local ct=Duel.GetMatchingGroupCount(c80000346.filter,tp,LOCATION_MZONE,0,nil)
	Duel.Damage(p,ct*300,REASON_EFFECT)
end
function c80000346.condition(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp and eg:GetFirst():IsRace(RACE_INSECT)
end
function c80000346.filter1(c,e,tp)
	return c:IsRace(RACE_INSECT) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsLevelBelow(4)
end
function c80000346.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and c80000346.filter1(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c80000346.filter1,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c80000346.filter1,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c80000346.spop1(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end