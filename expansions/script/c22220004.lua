--半人半灵的白泽球
function c22220004.initial_effect(c)
	c:EnableReviveLimit()
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(22220004,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetRange(LOCATION_HAND+LOCATION_REMOVED)
	e1:SetCode(EVENT_BATTLE_START)
	e1:SetCountLimit(1,22220004)
	e1:SetCondition(c22220004.spcon)
	e1:SetCost(c22220004.spcost)
	e1:SetTarget(c22220004.sptg)
	e1:SetOperation(c22220004.spop)
	c:RegisterEffect(e1)
   --c:RegisterEffect(e5)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetCode(EFFECT_EXTRA_ATTACK)
	e6:SetRange(LOCATION_MZONE)
	e6:SetTargetRange(LOCATION_MZONE,0)
	e6:SetTarget(aux.TargetBoolFunction(c22220004.filter))
	e6:SetValue(1)
	c:RegisterEffect(e6)
	--sp&battle
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(22220004,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(c22220004.target)
	e2:SetOperation(c22220004.operation)
	c:RegisterEffect(e2)
end
c22220004.named_with_Shirasawa_Tama=1
function c22220004.IsShirasawaTama(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Shirasawa_Tama
end
function c22220004.spcon(e,tp,eg,ep,ev,re,r,rp)
	local ac=Duel.GetAttacker() 
	return (ac:GetControler()==tp and ac:GetLevel()==2) or (Duel.GetAttackTarget()~=nil and Duel.GetAttackTarget():GetControler()==tp and Duel.GetAttackTarget():GetLevel()==2)
end
function c22220004.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local ac=Duel.GetAttacker()
	if chk==0 then return true end
	if ac:GetControler()==tp and ac:GetLevel()==2 then 
		Duel.Remove(ac,POS_FACEUP,REASON_COST)
	end
	if Duel.GetAttackTarget()~=nil and Duel.GetAttackTarget():GetControler()==tp and Duel.GetAttackTarget():GetLevel()==2 then 
		Duel.Remove(Duel.GetAttackTarget(),POS_FACEUP,REASON_COST)
	end
end
function c22220004.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,true,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c22220004.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.SpecialSummon(c,SUMMON_TYPE_RITUAL,tp,tp,true,false,POS_FACEUP)
	end
end
function c22220004.filter(c)
	return c:IsType(TYPE_MONSTER) and c22220004.IsShirasawaTama(c)
end
function c22220004.bfilter(c,e,tp)
	return c:IsType(TYPE_MONSTER) and c22220004.IsShirasawaTama(c) and c:IsCanBeSpecialSummoned(e,0,tp,true,true)
end
function c22220004.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) end
	if chk==0 then return Duel.IsExistingMatchingCard(c22220004.bfilter,tp,LOCATION_DECK+LOCATION_REMOVED,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingTarget(nil,tp,0,LOCATION_MZONE,1,nil) end
	local g=Duel.SelectTarget(tp,nil,tp,0,LOCATION_MZONE,1,1,nil)
end
function c22220004.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 or not Duel.IsExistingMatchingCard(c22220004.bfilter,tp,LOCATION_DECK+LOCATION_REMOVED,0,1,nil,e,tp) then return false end
	local g=Duel.SelectMatchingCard(tp,c22220004.bfilter,tp,LOCATION_DECK+LOCATION_REMOVED,0,1,1,nil,e,tp)
	local sc=g:GetFirst()
	Duel.SpecialSummon(sc,0,tp,tp,true,true,POS_FACEUP_ATTACK)
	if not (tc:IsLocation(LOCATION_MZONE) and sc:IsLocation(LOCATION_MZONE)) then return false end
	Duel.BreakEffect()
	Duel.CalculateDamage(sc,tc)
end








