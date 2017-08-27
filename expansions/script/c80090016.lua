--情热传说 史雷·水神依
function c80090016.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcCode2(c,80090000,80090002,false,false)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c80090016.splimit)
	c:RegisterEffect(e1)
	--special summon rule
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(c80090016.spcon)
	e2:SetOperation(c80090016.spop)
	c:RegisterEffect(e2) 
	--cannot be fusion material
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	--summon success
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetOperation(c80090016.sumsuc)
	c:RegisterEffect(e4)
	--spsummon
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_CANNOT_DISABLE_SPSUMMON)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	c:RegisterEffect(e5) 
	--
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(80090014,1))
	e6:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e6:SetCode(EVENT_TO_GRAVE)
	e6:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e6:SetCondition(c80090016.spcon1)
	e6:SetTarget(c80090016.sptg)
	e6:SetOperation(c80090016.spop1)
	c:RegisterEffect(e6)  
	--attack all
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE)
	e7:SetCode(EFFECT_ATTACK_ALL)
	e7:SetValue(1)
	c:RegisterEffect(e7)
	--pierce
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE)
	e8:SetCode(EFFECT_PIERCE)
	c:RegisterEffect(e8)
	--disable
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e9:SetCode(EVENT_ATTACK_ANNOUNCE)
	e9:SetRange(LOCATION_MZONE)
	e9:SetOperation(c80090016.disop)
	c:RegisterEffect(e9)
	local e10=e9:Clone()
	e10:SetCode(EVENT_BE_BATTLE_TARGET)
	c:RegisterEffect(e10)
	--destroy
	local e11=Effect.CreateEffect(c)
	e11:SetDescription(aux.Stringid(80090014,0))
	e11:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e11:SetCategory(CATEGORY_DAMAGE)
	e11:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e11:SetCode(EVENT_BATTLE_DAMAGE)
	e11:SetCondition(c80090016.atkcon)
	e11:SetTarget(c80090016.destg)
	e11:SetOperation(c80090016.desop)
	c:RegisterEffect(e11)
end
function c80090016.splimit(e,se,sp,st)
	return bit.band(st,SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION
end
function c80090016.spfilter1(c,tp,fc)
	return c:IsCode(80090000) and c:IsCanBeFusionMaterial(fc)
		and Duel.CheckReleaseGroup(tp,c80090016.spfilter2,1,c,fc)
end
function c80090016.spfilter2(c,fc)
	return c:IsCode(80090002) and c:IsCanBeFusionMaterial(fc)
end
function c80090016.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>-2
		and Duel.CheckReleaseGroup(tp,c80090016.spfilter1,1,nil,tp,c)
end
function c80090016.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g1=Duel.SelectReleaseGroup(tp,c80090016.spfilter1,1,1,nil,tp,c)
	local g2=Duel.SelectReleaseGroup(tp,c80090016.spfilter2,1,1,g1:GetFirst(),c)
	g1:Merge(g2)
	c:SetMaterial(g1)
	Duel.Release(g1,REASON_COST+REASON_FUSION+REASON_MATERIAL)
end
function c80090016.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.SetChainLimitTillChainEnd(c80090016.chlimit)
end
function c80090016.chlimit(e,ep,tp)
	return tp==ep
end
function c80090016.spcon1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsReason(REASON_DESTROY) and rp==1-tp
end
function c80090016.spfilter12(c,e,tp)
	return c:IsCode(80090000) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c80090016.spfilter22(c,e,tp)
	return c:IsCode(80090002) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c80090016.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>1 and not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and Duel.IsExistingTarget(c80090016.spfilter12,tp,LOCATION_GRAVE,0,1,nil,e,tp)
		and Duel.IsExistingTarget(c80090016.spfilter22,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g1=Duel.SelectTarget(tp,c80090016.spfilter12,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g2=Duel.SelectTarget(tp,c80090016.spfilter22,tp,LOCATION_GRAVE,0,1,1,g1:GetFirst(),e,tp)
	g1:Merge(g2)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g1,2,0,0)
end
function c80090016.spop1(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<g:GetCount() or (g:GetCount()>1 and Duel.IsPlayerAffectedByEffect(tp,59822133)) then return end
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c80090016.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetAttackTarget()
	if tc:IsControler(tp) then tc=Duel.GetAttacker() end
	c:CreateRelation(tc,RESET_EVENT+0x1fe0000)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DISABLE)
	e1:SetCondition(c80090016.discon2)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_BATTLE)
	tc:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_DISABLE_EFFECT)
	e2:SetCondition(c80090016.discon2)
	e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_BATTLE)
	tc:RegisterEffect(e2)
end
function c80090016.discon2(e)
	return e:GetOwner():IsRelateToCard(e:GetHandler())
end
function c80090016.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(1200)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,1200)
	Duel.SetChainLimit(aux.FALSE)
end
function c80090016.desop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
	local g=Duel.SelectMatchingCard(1-tp,nil,1-tp,LOCATION_EXTRA,0,1,1,nil)
	if g and Duel.SelectYesNo(tp,aux.Stringid(80090016,2)) then
		 Duel.BreakEffect()
		 Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_REMOVE)
		 local g=Duel.SelectMatchingCard(1-tp,nil,1-tp,LOCATION_EXTRA,0,1,1,nil)
		 Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT)
	end
end
function c80090016.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp
end