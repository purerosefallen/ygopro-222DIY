--银屑照魂 梨涅莎
function c2100008.initial_effect(c)
	c:EnableReviveLimit()
	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.FALSE)
	c:RegisterEffect(e1)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(2100008,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c2100008.spcon)
	e1:SetOperation(c2100008.spop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CANNOT_DISABLE_SPSUMMON)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	c:RegisterEffect(e2)
	--summon success
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetOperation(c2100008.sumsuc)
	c:RegisterEffect(e2)
	--Atk
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x3219))
	e2:SetValue(1000)
	c:RegisterEffect(e2)
	--Def
	local e3=e2:Clone()
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e3)
	--remove
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(2100008,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetTarget(c2100008.sptg1)
	e1:SetOperation(c2100008.spop1)
	c:RegisterEffect(e1)
end
function c2100008.spfilter(c)
	return c:IsSetCard(0x3219) and c:IsAbleToRemoveAsCost()
end
function c2100008.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetMZoneCount(tp)>0
		and Duel.IsExistingMatchingCard(c2100008.spfilter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingMatchingCard(c2100008.spfilter,tp,LOCATION_GRAVE,0,1,nil)
		and Duel.IsExistingMatchingCard(c2100008.spfilter,tp,LOCATION_HAND,0,1,e:GetHandler())
end
function c2100008.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g1=Duel.SelectMatchingCard(tp,c2100008.spfilter,tp,LOCATION_HAND,0,1,1,e:GetHandler())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g2=Duel.SelectMatchingCard(tp,c2100008.spfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g3=Duel.SelectMatchingCard(tp,c2100008.spfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	g1:Merge(g2)
	g1:Merge(g3)
	Duel.Remove(g1,POS_FACEUP,REASON_COST)
end
function c2100008.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetValue(c2100008.actlimit)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x3219))
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c2100008.actlimit(e,te)
	return te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end
function c2100008.target(e,c)
	return c:IsSetCard(0x3219) and c:IsType(TYPE_MONSTER)
end
function c2100008.filter1(c,e,tp)
	return c:IsSetCard(0x3219) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c2100008.sptg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMZoneCount(tp)>0 
		and Duel.IsExistingMatchingCard(c2100008.filter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function c2100008.spop1(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetMZoneCount(tp)
	if ft<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c2100008.filter1,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,ft,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end