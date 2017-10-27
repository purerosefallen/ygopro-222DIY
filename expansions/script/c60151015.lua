--地平线的彼方 晓美焰
function c60151015.initial_effect(c)
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
	e12:SetCondition(c60151015.spcon)
	e12:SetOperation(c60151015.spop)
	c:RegisterEffect(e12)
	--atk
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(60151015,0))
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL+EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetCondition(c60151015.drcon)
	e2:SetOperation(c60151015.drop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(60151015,0))
	e3:SetCategory(CATEGORY_ATKCHANGE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL+EFFECT_FLAG_DELAY)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetCondition(c60151015.drcon2)
	e3:SetOperation(c60151015.drop2)
	c:RegisterEffect(e3)
	--battle indestructable
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e4:SetValue(1)
	c:RegisterEffect(e4)
	--e indestructable
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e5:SetValue(1)
	c:RegisterEffect(e5)
end
function c60151015.spfilter1(c,tp)
	return c:IsRace(RACE_SPELLCASTER) and c:IsSetCard(0x5b23) and c:IsCanBeFusionMaterial()
		and Duel.CheckReleaseGroup(tp,c60151015.spfilter2,1,c)
end
function c60151015.spfilter2(c)
	return c:IsType(TYPE_XYZ) and c:IsSetCard(0x5b23) and c:IsCanBeFusionMaterial()
end
function c60151015.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetMZoneCount(tp)>-2
		and Duel.CheckReleaseGroup(tp,c60151015.spfilter1,1,nil,tp)
end
function c60151015.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(60151016,2))
	local g1=Duel.SelectMatchingCard(tp,c60151015.spfilter1,tp,LOCATION_MZONE,0,1,1,nil,tp)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(60151016,3))
	local g2=Duel.SelectMatchingCard(tp,c60151015.spfilter2,tp,LOCATION_MZONE,0,1,1,nil,tp)
	g1:Merge(g2)
	c:SetMaterial(g1)
	Duel.Release(g1,REASON_COST)
end
function c60151015.discon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) 
		and (re:IsHasType(EFFECT_TYPE_ACTIVATE) or re:IsActiveType(TYPE_MONSTER))
		and re:GetHandler()~=e:GetHandler()
end
function c60151015.chlimit(e,ep,tp)
	return tp==ep
end
function c60151015.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetChainLimit(c60151015.chlimit)
end
function c60151015.disop(e,tp,eg,ep,ev,re,r,rp)
	
end
function c60151015.cfilter(c,tp)
	return c:IsReason(REASON_BATTLE+REASON_EFFECT) and c:IsPreviousLocation(LOCATION_MZONE)
end
function c60151015.drcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c60151015.cfilter,1,nil,tp)
end
function c60151015.drop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFacedown() or not c:IsRelateToEffect(e) then return end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(300)
	e1:SetReset(RESET_EVENT+0x1ff0000)
	c:RegisterEffect(e1)
end
function c60151015.cfilter2(c,tp)
	return c:IsReason(REASON_BATTLE+REASON_EFFECT) and c:IsSetCard(0x5b23) and c:IsPreviousLocation(LOCATION_MZONE)
end
function c60151015.drcon2(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c60151015.cfilter2,1,nil,tp)
end
function c60151015.drop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFacedown() or not c:IsRelateToEffect(e) then return end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(300)
	e1:SetReset(RESET_EVENT+0x1ff0000)
	c:RegisterEffect(e1)
end